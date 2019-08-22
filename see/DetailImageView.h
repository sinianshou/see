//
//  DetailImageView.h
//  see
//
//  Created by Easer Liu on 2019/8/21.
//  Copyright © 2019 Easer Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailImageView : UIScrollView

-(void)showWithURL:(NSString*)url fromRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
