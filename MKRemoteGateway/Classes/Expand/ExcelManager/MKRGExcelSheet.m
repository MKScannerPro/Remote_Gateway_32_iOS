//
//  MKRGExcelSheet.m
//  MKRemoteGateway_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKRGExcelSheet.h"

#import "MKRGExcelCell.h"

@implementation MKRGExcelSheet

/**
 根据 横竖坐标 查找cell
 @param column 竖坐标 例：A、H
 @param row 横坐标 例：1、15
 @param error 错误信息
 @return 单元格数据
 */
-(MKRGExcelCell *)getCellWithColumn:(NSString *)column row:(NSInteger )row error:(NSError **)error
{
    MKRGExcelCell *cell = nil;

    for(NSInteger i = 0 ; i < self.cellArray.count ;i++)
    {
        MKRGExcelCell *originCell = [self.cellArray objectAtIndex:i];
        
        if([originCell.column isEqualToString:column] && originCell.row == row)
        {
            cell = originCell;
            break;
        }
    }
    return cell;
}





/**
 解析单表数据
 @param sheetDic 单表字典
 @param sharedStringsArray 公共字符串数组
 @return sheet里所有cell数组
 */
+(NSMutableArray <MKRGExcelCell *>*)analysisSheetDataWithSheetDic:(NSDictionary *)sheetDic sharedStringsArray:(NSArray *)sharedStringsArray
{
    NSMutableArray <MKRGExcelCell *>*oneSheetAllCellArray = [self getCellArrayWithSheetDic:sheetDic sharedStringsArray:sharedStringsArray];
    
    if(oneSheetAllCellArray && oneSheetAllCellArray.count > 0)
    {
        
    }
    return oneSheetAllCellArray;
}





+(NSMutableArray <MKRGExcelCell *>*)getCellArrayWithSheetDic:(NSDictionary *)sheetDic sharedStringsArray:(NSArray *)sharedStringsArray
{
    NSMutableArray <MKRGExcelCell *>*oneSheetAllCellArray = nil;
    
    if(sharedStringsArray.count <= 0)
    {
        return oneSheetAllCellArray;
    }
    
    NSDictionary *oneSheetData = [sheetDic objectForKey:@"oneSheetData"];
    
    if(oneSheetData && [oneSheetData isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *worksheet = [oneSheetData objectForKey:@"worksheet"];
        
        if(worksheet && [worksheet isKindOfClass:[NSDictionary class]])
        {
            NSArray *mergeCellInfoArray = nil;
            
            NSDictionary *mergeCells = [worksheet objectForKey:@"mergeCells"];
            
            if(mergeCells && [mergeCells isKindOfClass:[NSDictionary class]])
            {
                mergeCellInfoArray = [mergeCells objectForKey:@"mergeCell"];
            }
            
            
            NSDictionary *sheetData = [worksheet objectForKey:@"sheetData"];
            
            if(sheetData && [sheetData isKindOfClass:[NSDictionary class]])
            {
                NSArray *row = [sheetData objectForKey:@"row"];
                
                for(NSInteger i = 0 ; i < row.count ;i++)
                {
                    if(oneSheetAllCellArray == nil)
                    {
                        oneSheetAllCellArray = [[NSMutableArray alloc]init];
                    }
                    NSDictionary *oneRowDic = [row objectAtIndex:i];
                    
                    if(oneRowDic && [oneRowDic isKindOfClass:[NSDictionary class]])
                    {
                        NSArray *c = [oneRowDic objectForKey:@"c"];
                        
                        for(NSInteger j = 0 ; j < c.count ; j ++)
                        {
                            NSDictionary *cellDic = [c objectAtIndex:j];
                            
                            MKRGExcelCell *cell = [[MKRGExcelCell alloc]init];
                            
                            cell.cellDic = cellDic;
                            
                            if(cell.indexAnalysisSuccess && (sharedStringsArray.count > cell.stringValueIndex))
                            {
                                cell.stringValue = [sharedStringsArray objectAtIndex:cell.stringValueIndex];
                            }
                            

                            NSString *mergeCellColumAndRowStr = [self getMergeCellColumAndRowStrWithCell:cell mergeCellInfoArray:mergeCellInfoArray];
                            
                            cell.mergeCellColumAndRowStr = mergeCellColumAndRowStr;
                            
                            [oneSheetAllCellArray addObject:cell];
                        }
                    }
                }
            }
        }
    }
    return oneSheetAllCellArray;
}


+(NSString *)getMergeCellColumAndRowStrWithCell:(MKRGExcelCell *)cell mergeCellInfoArray:(NSArray *)mergeCellInfoArray
{
    NSString *columnAndRowStr = nil;
    
     if([mergeCellInfoArray isKindOfClass:[NSArray class]])
     {
         if(mergeCellInfoArray && mergeCellInfoArray.count > 0)
         {
             for(NSInteger i = 0 ;i < mergeCellInfoArray.count ;i ++)
             {
                 NSDictionary *mergeInfoDic = [mergeCellInfoArray objectAtIndex:i];
                 
                 columnAndRowStr = [self getMergeStrWithMergeInfoDic:mergeInfoDic column:cell.column row:cell.row];
                 
                 if(columnAndRowStr.length > 0)
                 {
                     break;
                 }
             }
         }
     }
    else
    {
        NSDictionary *mergeInfoDic = (NSDictionary *)mergeCellInfoArray;
        
        columnAndRowStr = [self getMergeStrWithMergeInfoDic:mergeInfoDic column:cell.column row:cell.row];
    }
    return columnAndRowStr;
}



+(NSString *)getMergeStrWithMergeInfoDic:(NSDictionary *)mergeInfoDic column:(NSString *)column row:(NSInteger )row
{
    NSString *mergeStr = nil;
    
    NSString *ref = [mergeInfoDic objectForKey:@"ref"];
    
    if(ref && [ref isKindOfClass:[NSString class]] && ref.length > 0)
    {
        NSArray *array = [ref componentsSeparatedByString:@":"]; //从字符A中分隔成2个元素的数组
      
        if(array && array.count == 2)
        {
            NSString *startStr = array.firstObject;
            
            NSString *endStr = array.lastObject;
            
            NSInteger startRow = [[MKRGExcelCell getNumberFromStr:startStr] integerValue];
            
            NSInteger endRow = [[MKRGExcelCell getNumberFromStr:endStr] integerValue];
            
            NSString *tempStartColumnStr = [MKRGExcelCell getLetterFromStr:startStr];
            
            NSString *tempEndColumnStr = [MKRGExcelCell getLetterFromStr:endStr];
            
            if([tempStartColumnStr isEqualToString:tempEndColumnStr])//竖合并单元格
            {
                if(startRow <= row && endRow >= row)
                {
                    mergeStr = startStr;
                }
            }
            else //横合并单元格
            {
                if(startRow == row)
                {
                    if( tempStartColumnStr <= column && tempEndColumnStr >= column)
                    {
                        mergeStr = startStr;
                    }
                }
            }
        }
    }

    return mergeStr;
}

@end
