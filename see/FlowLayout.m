//
//  FlowLayout.m
//  see
//
//  Created by Easer Liu on 2019/8/21.
//  Copyright © 2019 Easer Liu. All rights reserved.
//

#import "FlowLayout.h"
@interface FlowLayout()
/** 存放所有的布局属性 */
@property (nonatomic, strong) NSMutableArray * attrsArr;
/** 存放所有列的当前高度 */
@property (nonatomic, strong) NSMutableArray *columnHeights;
/** 内容的高度 */
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, assign) CGFloat columnMargin;
@property (nonatomic, assign) CGFloat rowMargin;

@end

@implementation FlowLayout
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        CGFloat wid = [UIScreen mainScreen].bounds.size.width * 0.4;
        self.itemSize = CGSizeMake(wid, wid);
        CGFloat inset = wid / 6;
        self.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
        _columnMargin = inset;
        _rowMargin = inset;
    }
    return self;
}
//实现瀑布流的部分代码，但与可拖拽有冲突，暂时注释掉
/*
- (void)prepareLayout{
    NSLog(@"%s", __func__);
    [super prepareLayout];

    self.contentHeight = 0;

    // 清除之前计算的所有高度
    [self.columnHeights removeAllObjects];

    // 设置每一列默认的高度
    for (NSInteger i = 0; i < 2 ; i ++) {
        [self.columnHeights addObject:@(0)];
    }


    // 清楚之前所有的布局属性
    [self.attrsArr removeAllObjects];

    // 开始创建每一个cell对应的布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];

    for (int i = 0; i < count; i++) {

        // 创建位置
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];

        // 获取indexPath位置上cell对应的布局属性
        UICollectionViewLayoutAttributes * attrs = [self layoutAttributesForItemAtIndexPath:indexPath];

        [self.attrsArr addObject:attrs];
    }

}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%s", __func__);
    // 创建布局属性
    UICollectionViewLayoutAttributes * attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    //collectionView的宽度
    CGFloat collectionViewW = self.collectionView.frame.size.width;

    // 设置布局属性的frame

    CGFloat cellW = (collectionViewW - self.sectionInset.left - self.sectionInset.right - 1 * self.columnMargin) / 2;
    CGFloat cellH = [self.delegate flowLayout:self heightForItemAtIndexPath:indexPath];


    // 找出最短的那一列
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];

    for (int i = 1; i < 2; i++) {

        // 取得第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];

        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }

    CGFloat cellX = self.sectionInset.left + destColumn * (cellW + self.columnMargin);
    CGFloat cellY = minColumnHeight;
    if (cellY != self.sectionInset.top) {

        cellY += self.rowMargin;
    }

    attrs.frame = CGRectMake(cellX, cellY, cellW, cellH);

    // 更新最短那一列的高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));

    // 记录内容的高度 - 即最长那一列的高度
    CGFloat maxColumnHeight = [self.columnHeights[destColumn] doubleValue];
    if (self.contentHeight < maxColumnHeight) {
        self.contentHeight = maxColumnHeight;
    }

    return attrs;
}


 //决定cell的布局属性
 
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSLog(@"%s", __func__);
    return self.attrsArr;
}


 // 内容的高度
 
- (CGSize)collectionViewContentSize{
    NSLog(@"%s", __func__);
    return CGSizeMake(0, self.contentHeight + self.sectionInset.bottom);
}
*/

#pragma mark 懒加载
- (NSMutableArray *)attrsArr{
    if (!_attrsArr) {
        _attrsArr = [NSMutableArray array];
    }
    
    return _attrsArr;
}

- (NSMutableArray *)columnHeights{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    
    return _columnHeights;
}
@end
