//
//  MainCell.h
//  see
//
//  Created by Easer Liu on 2019/8/21.
//  Copyright © 2019 Easer Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BaseModel;

@interface MainCell : UICollectionViewCell

-(void)configWithModel:(BaseModel*)model;

@end

NS_ASSUME_NONNULL_END
