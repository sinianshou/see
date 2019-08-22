//
//  FlowLayout.h
//  see
//
//  Created by Easer Liu on 2019/8/21.
//  Copyright © 2019 Easer Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FlowLayout;
@protocol FlowLayoutDelegate <NSObject>

- (CGFloat)flowLayout:(FlowLayout *)flowLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface FlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<FlowLayoutDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
