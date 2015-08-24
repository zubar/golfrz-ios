//
//  CustomCollectionViewLayout.m
//  Brightec
//
//  Created by JOSE MARTINEZ on 03/09/2014.
//  Copyright (c) 2014 Brightec. All rights reserved.
//

#import "CustomCollectionViewLayout.h"
#import "ScoreBoardManager.h"

#define INDEX_LIMIT 2
#define MIN_SPACES_BETWEEN_CELLS 45

//#define NUMBEROFCOLUMNS 12

@interface CustomCollectionViewLayout (){
    
    NSUInteger numberOfColumns;
    
}
@property (strong, nonatomic) NSMutableArray *itemAttributes;
@property (strong, nonatomic) NSMutableArray *itemsSize;
@property (nonatomic, assign) CGSize contentSize;

@end

@implementation CustomCollectionViewLayout


-(NSInteger)space_between_cells
{
    int screenWidth = [[UIScreen mainScreen] bounds].size.width;
    int space =   (screenWidth / [ScoreBoardManager sharedScoreBoardManager].numberOfItems);
    return MAX(MIN_SPACES_BETWEEN_CELLS, space);
}

- (void)prepareLayout
{
    if ([self.collectionView numberOfSections] == 0) {
        return;
    }
    
    //NSUInteger indexOffSet = 0;
    NSUInteger noOfStickyColumns = [[ScoreBoardManager sharedScoreBoardManager].scoreCard.teeBoxCount intValue] + 1;
    numberOfColumns = [ScoreBoardManager sharedScoreBoardManager].numberOfItems;
    NSUInteger column = 0; // Current column inside row
    CGFloat xOffset = 0.0;
    CGFloat yOffset = 0.0;
    CGFloat contentWidth = 0.0; // To determine the contentSize
    CGFloat contentHeight = 0.0; // To determine the contentSize
    
    /*
     
     */
    
    if (self.itemAttributes.count > 0) { // We don't enter in this if statement the first time, we enter the following times
        for (int section = 0; section < [self.collectionView numberOfSections]; section++) {
            NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
            for (NSUInteger index = 0; index < numberOfItems; index++) {
             if ((section != 0) && (index > noOfStickyColumns)) { // This is a content cell that shouldn't be sticked
                    continue;
                }
                
                UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:section]];
                if (section == 0) { // We stick the first row
                    CGRect frame = attributes.frame;
                    frame.origin.y = self.collectionView.contentOffset.y;
                    attributes.frame = frame;
                    
                }
                
                for (int i = 0; i <= noOfStickyColumns; i++) {
                    if (index == i){
                        CGRect frame = attributes.frame;
                     if (index == 0) {
                            frame.origin.x = self.collectionView.contentOffset.x;
                        }else if (index == 1){
                            frame.origin.x = self.collectionView.contentOffset.x + (index * [self space_between_cells]);
                        }else{
                            frame.origin.x = self.collectionView.contentOffset.x + [self space_between_cells] + ((index -1) * [self space_between_cells]);
                        }
                        
                        attributes.frame = frame;
                        
                    }                    
                }
            }
        }
        
        return;
    }
    
    // The following code is only executed the first time we prepare the layout
    self.itemAttributes = [@[] mutableCopy];
    self.itemsSize = [@[] mutableCopy];
    
    // Tip: If we don't know the number of columns we can call the following method and use the NSUInteger object instead of the NUMBEROFCOLUMNS macro
    // NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
    
    // We calculate the item size of each column
    if (self.itemsSize.count != numberOfColumns) {
        [self calculateItemsSize];
    }
    
    // We loop through all items
    for (int section = 0; section < [self.collectionView numberOfSections]; section++) {
        NSMutableArray *sectionAttributes = [@[] mutableCopy];
        for (NSUInteger index = 0; index < numberOfColumns; index++) {
            CGSize itemSize = [self.itemsSize[index] CGSizeValue];
            
            // We create the UICollectionViewLayoutAttributes object for each item and add it to our array.
            // We will use this later in layoutAttributesForItemAtIndexPath:
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:section];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height));
            
            
            for (int i = 0; i <= noOfStickyColumns; i++){
                if ((section == 0 && index == i)){
                    attributes.zIndex = 1024;
                    break;
                }else {
                    for (int j = 0; j <= noOfStickyColumns; j++) {
                        if ((section == 0 || index == j)) {
                            attributes.zIndex = 1023;
                            break;
                        }
                    }
                }
            }
            
            if (section == 0) {
                CGRect frame = attributes.frame;
                frame.origin.y = self.collectionView.contentOffset.y;
                attributes.frame = frame; // Stick to the top
            }
            
            for (int i = 0; i <= noOfStickyColumns; i++) {
                if (index == i){
                    CGRect frame = attributes.frame;
                    if (index == 0) {
                        frame.origin.x = self.collectionView.contentOffset.x;
                    }else if (index == 1){
                        frame.origin.x = self.collectionView.contentOffset.x + (index * [self space_between_cells]);
                    }else{
                        frame.origin.x = self.collectionView.contentOffset.x + [self space_between_cells] + ((index -1) * [self space_between_cells]);
                    }
                    
                    attributes.frame = frame;
                    
                }
            }
     
            [sectionAttributes addObject:attributes];
            
            xOffset = xOffset+itemSize.width;
            column++;
            
            // Create a new row if this was the last column
            if (column == numberOfColumns) {
                if (xOffset > contentWidth) {
                    contentWidth = xOffset;
                }
                
                // Reset values
                column = 0;
                xOffset = 0;
                yOffset += itemSize.height;
            }
        }
        [self.itemAttributes addObject:sectionAttributes];
    }
    
    // Get the last item to calculate the total height of the content
    UICollectionViewLayoutAttributes *attributes = [[self.itemAttributes lastObject] lastObject];
    contentHeight = attributes.frame.origin.y+attributes.frame.size.height;
    self.contentSize = CGSizeMake(contentWidth, contentHeight);
}

- (CGSize)collectionViewContentSize
{
    return self.contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.itemAttributes[indexPath.section][indexPath.row];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [@[] mutableCopy];
    for (NSArray *section in self.itemAttributes) {
        [attributes addObjectsFromArray:[section filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
            return CGRectIntersectsRect(rect, [evaluatedObject frame]);
        }]]];
    }
    
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES; // Set this to YES to call prepareLayout on every scroll
}

- (CGSize)sizeForItemWithColumnIndex:(NSUInteger)columnIndex
{
    //NSString *text = [NSString stringWithFormat:@"Col %lu", (unsigned long)columnIndex];
  
    //CGSize size = [text sizeWithAttributes: @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:10]}];

    return CGSizeMake([self space_between_cells], 35);
    //return CGSizeMake([@(size.width + 9) floatValue], 30); // Extra space of 9px for all the items
}

- (void)calculateItemsSize
{
    for (NSUInteger index = 0; index < numberOfColumns; index++) {
        if (self.itemsSize.count <= index) {
            CGSize itemSize = [self sizeForItemWithColumnIndex:index];
            NSValue *itemSizeValue = [NSValue valueWithCGSize:itemSize];
            [self.itemsSize addObject:itemSizeValue];
        }
    }
}

@end
