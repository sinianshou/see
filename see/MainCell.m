//
//  MainCell.m
//  see
//
//  Created by Easer Liu on 2019/8/21.
//  Copyright © 2019 Easer Liu. All rights reserved.
//

#import "MainCell.h"
#import "BaseModel.h"

#import "MBProgressHUD.h"

@interface MainCell ()

@property (nonatomic, weak) UIImageView* imageView;
@property (nonatomic, weak) UIImageView* profileImage;

@end
@implementation MainCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.frame = self.contentView.bounds;
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self.contentView);
            make.center.equalTo(self.contentView);
        }];
    }
    return self;
}
//配置cell
-(void)configWithModel:(BaseModel*)model{
    if (model) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.urlRegular] placeholderImage:[UIImage imageNamed:@"holder"] options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
    }
}

#pragma mark Setter and Getter
-(UIImageView *)imageView{
    if (_imageView==nil) {
        UIImageView *tempIV = [[UIImageView alloc] init];
        tempIV.layer.cornerRadius = 15;
        tempIV.clipsToBounds = YES;
        [self.contentView addSubview:tempIV];
        _imageView = tempIV;
    }
    return _imageView;
}
@end
