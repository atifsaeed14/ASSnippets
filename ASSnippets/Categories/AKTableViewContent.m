//
//  TPTableViewContent.m
//
//  Created by Thiago Peres on 12/21/11.
//  Copyright (c) 2011 Thiago Peres. All rights reserved.
//

#import "AKTableViewContent.h"

@implementation NSMutableArray (AKTableViewContent)

#pragma mark - Creating

- (NSMutableDictionary*)sectionWithTitle:(NSString*)title
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    [dic setObject:title forKey:kTitleKey];
    [dic setObject:arr forKey:kCellsKey];
    
    
    return dic;
}

- (NSInteger)createSectionWithTitle:(NSString*)title
{
    NSMutableDictionary *dic = [self sectionWithTitle:title];
    [self addObject:dic];
    
    return [self indexOfObject:dic];
}

- (void)createSectionAtIndex:(NSInteger)section title:(NSString*)title
{    
    [self insertObject:[self sectionWithTitle:title] atIndex:section];
}

#pragma mark - Adding cells

- (void)addCell:(id)cell forSection:(NSInteger)section withIdentifier:(NSString*)identifier
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:cell forKey:kCellKey];
    [dic setObject:identifier forKey:kCellIdKey];
    
    [[[self objectAtIndex:section] objectForKey:kCellsKey] addObject:dic];
    
}

- (void)addCell:(id)cell withIdentifier:(NSString*)identifier
{
    [self addCell:cell forSection:self.count-1 withIdentifier:identifier];
}

- (void)addCell:(id)cell
{
    [self addCell:cell withIdentifier:kNoIdentifier];
}

- (void)addCell:(id)cell forSection:(NSInteger)section
{
    [self addCell:cell forSection:section withIdentifier:kNoIdentifier];
}

- (void)addCells:(NSArray *)cells forSection:(NSInteger)section
{
    for (id obj in cells) 
    {
        [self addCell:cells forSection:section withIdentifier:kNoIdentifier];
    }
}

#pragma mark - Retrieving cells

- (NSArray*)allCells
{
    NSMutableArray *allCells = [NSMutableArray arrayWithCapacity:self.count];
    for (NSDictionary *section in self) 
    {
        [allCells addObjectsFromArray: [[section objectForKey:kCellsKey] valueForKeyPath:@"cell"]];
    }
    
    return allCells;
}

- (BOOL)containsCellWithIdentifier:(NSString*)identifier
{
    NSArray *arr = [self valueForKeyPath:@"self.cells.cellId"];
    return [arr containsObject:identifier];
}

- (NSString*)titleForSection:(NSInteger)section
{
    return [[self objectAtIndex:section] objectForKey:kTitleKey];
}

- (NSMutableArray*)cellsForSection:(NSInteger)section
{
    return [[self objectAtIndex:section] valueForKeyPath:@"cells.cell"];
}

- (id)cellForSection:(NSInteger)section row:(NSInteger)row
{
    return [[self cellsForSection:section] objectAtIndex:row];
}

- (id)cellForIndexPath:(NSIndexPath*)indexPath
{
    return [self cellForSection:indexPath.section row:indexPath.row];
}

- (id)cellForIdentifier:(NSString*)identifier
{
    for (NSDictionary *section in self) 
    {
        for (NSDictionary *cell in [section objectForKey:kCellsKey]) 
        {
            if ([[cell objectForKey:kCellIdKey] isKindOfClass:[NSString class]]) 
            {
                if ([[cell objectForKey:kCellIdKey] isEqualToString:identifier]) 
                {
                    return [cell objectForKey:kCellKey];
                }
            }
        }
    }
    return nil;
    
    /*for (NSDictionary *cellDic in [self valueForKeyPath:@"cells"]) 
    {
        NSLog(@"%@", cellDic);
        if ([[cellDic objectForKey:kCellIdKey] isEqualToString:identifier]) 
        {
            return [cellDic objectForKey:kCellKey];
        }
    }
    return nil;*/
}

- (NSIndexPath*)indexPathForIdentifier:(NSString*)identifier
{
    if ([self containsCellWithIdentifier:identifier]) 
    {
        return [self indexPathForCell: [self cellForIdentifier:identifier] ];
    }
    return nil;
}

- (NSInteger)sectionForCellWithIdentifier:(NSString*)identifier
{
    for (int i = 0; i < [self count]; i++) 
    {
        if ([[[self objectAtIndex:i] valueForKeyPath:@"cells.cellId"] containsObject:identifier]) 
        {
            return i;
        }
    }
    return -1;
}

- (NSString*)identifierForIndexPath:(NSIndexPath*)indexPath
{
    return [[[[self objectAtIndex:indexPath.section] objectForKey:kCellsKey] objectAtIndex:indexPath.row] objectForKey:kCellIdKey];
}

- (NSArray*)cellsForIdentifier:(NSString*)identifier
{
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (NSDictionary *cellDic in [self valueForKeyPath:@"self.cells"]) 
    {
        if ([[cellDic objectForKey:kCellIdKey] isEqualToString:identifier]) 
        {
            [tempArr addObject:[cellDic objectForKey:kCellKey]];
        }
    }
    
    NSArray *arr = [NSArray arrayWithArray:tempArr];
    return arr;
}

- (NSInteger)numberOfCellsForSection:(NSInteger)section
{
    return [[[self objectAtIndex:section] objectForKey:kCellsKey] count];
}

- (NSIndexPath*)indexPathForCell:(id)cell
{
    for (int i = 0; i < [self count]; i++) 
    {
        NSInteger indexOfObject = [[[self objectAtIndex:i] valueForKeyPath:@"cells.cell"] indexOfObject:cell];
        if (indexOfObject != INT_MAX) 
        {
            return [NSIndexPath indexPathForRow:indexOfObject inSection:i];
        }
    }
    return nil;
}

#pragma mark - Deleting cells

- (void)removeCellsForSection:(NSInteger)section
{
    return [[[self objectAtIndex:section] objectForKey:kCellsKey] removeAllObjects];
}

- (void)removeSectionAtIndex:(NSInteger)section
{
    return [self removeObjectAtIndex:section];
}

- (void)removeAllSections
{
    return [self removeAllObjects];
}

@end
