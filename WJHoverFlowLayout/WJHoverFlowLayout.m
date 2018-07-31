//
//  WJHoverFlowLayout.m
//  gegejia
//
//  Created by 王杰 on 16/4/22.
//  Copyright © 2016年 王杰. All rights reserved.
//

#import "WJHoverFlowLayout.h"

@implementation WJHoverFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.section = -1;
    }
    return self;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *superArray = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    NSMutableIndexSet *sectionSet = [NSMutableIndexSet indexSet];//NSIndexSet  是个无符号整数集合。集合中的元素不可变的、不可重复。常被用来当作索引使用。就从它字面上理解，就叫做：索引集合
    //获取屏幕当前显示的section
    for (UICollectionViewLayoutAttributes *attributes in superArray) {
        if (attributes.representedElementCategory == UICollectionElementCategoryCell) [sectionSet addIndex:attributes.indexPath.section];//自动去重
    }
    
    //删除已经显示在屏幕上的headerView所对应的section
    for (UICollectionViewLayoutAttributes *attributes in superArray) {
        if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) [sectionSet removeIndex:attributes.indexPath.section];
    }
    
    //将已经离屏的header加入到superArray
    [sectionSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:idx]];
        if (attributes) [superArray addObject:attributes];
    }];
    
    //重新设置header的位置
    for (UICollectionViewLayoutAttributes *attributes in superArray) {
        if (![attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) continue;
        if (attributes.indexPath.section != self.section) continue;
        //拿到当前section中第一个和最后一个的indexPath
        NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:attributes.indexPath.section];
        if (numberOfItemsInSection == 0) continue;
        NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:attributes.indexPath.section];
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:MAX(0, numberOfItemsInSection) inSection:attributes.indexPath.section];
        UICollectionViewLayoutAttributes *firstItem = [self layoutAttributesForItemAtIndexPath:firstIndexPath];
        UICollectionViewLayoutAttributes *lastItem = [self layoutAttributesForItemAtIndexPath:lastIndexPath];
        
        //获取当前header的frame
        CGRect rect = attributes.frame;
        
        //当前滑动偏移的距离
        CGFloat offset = self.collectionView.contentOffset.y + 0;//间距改成0
    
        //起点
        CGFloat start = firstItem.frame.origin.y - rect.size.height;
        
        //当前悬停的header取的是offset，未悬停取的是start
        CGFloat maxY = MAX(offset, start);
        
        //终点
        CGFloat end = lastItem.frame.origin.y - rect.size.height - (numberOfItemsInSection % 2 == 0 ? lastItem.frame.size.height : 0);
        
        //悬停时maxY小于end,隐藏时maxY大于end的。
        rect.origin.y = MIN(maxY, end);
        
        attributes.frame = rect;
        
        //如果按照正常情况下,header离开屏幕被系统回收，而header的层次关系又与cell相等，如果不去理会，会出现cell在header上面的情况
        attributes.zIndex = 1;
    }
    return [superArray copy];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
