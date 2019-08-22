//
//  DetailImageView.m
//  see
//
//  Created by Easer Liu on 2019/8/21.
//  Copyright © 2019 Easer Liu. All rights reserved.
//

#import "DetailImageView.h"
#import "MBProgressHUD.h"

@interface DetailImageView ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIButton *closeBN;
//用以判断在下拉退出时，防止透明度出现不正常现象的标识
@property (nonatomic, assign) NSInteger isZooming;
@property (nonatomic, assign) NSInteger endDragging;

@end
@implementation DetailImageView

-(instancetype)init{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.minimumZoomScale = 1.0f;
        self.maximumZoomScale = 3.0f;
    }
    return self;
}
-(void)showWithURL:(NSString*)url fromRect:(CGRect)rect{
    self.isZooming = 0;
    self.endDragging = 0;
        self.frame = rect;
        self.alpha = 0;
        self.hidden = NO;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"holder"] options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
        self.closeBN.frame = CGRectMake(0, 0, 44, 44);
        [UIView animateWithDuration:0.5 animations:^{
            [self setAlpha:1];
            self.frame = [UIScreen mainScreen].bounds;
        }];
}
-(void)hidenSelf{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.zoomScale = 1.0;
    }];
}

#pragma mark -- UIScrollViewDelegate
//返回需要缩放的视图控件 缩放过程中
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

//开始缩放
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    NSLog(@"开始缩放");
    self.isZooming = 1;
}
//结束缩放
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    NSLog(@"结束缩放");
    self.isZooming = 0;
}

//缩放中
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    // 延中心点缩放
//    CGFloat imageScaleWidth = scrollView.zoomScale * self.bounds.size.width;
//    CGFloat imageScaleHeight = scrollView.zoomScale * self.bounds.size.height;
//    
//    CGFloat imageX = 0;
//    CGFloat imageY = 0;
//    imageX = floorf((self.frame.size.width - imageScaleWidth) / 2.0);
//    imageY = floorf((self.frame.size.height - imageScaleHeight) / 2.0);
//    self.imageView.frame = CGRectMake(imageX, imageY, imageScaleWidth, imageScaleHeight);
//    
//}

//下拉到一定高度改变透明度
static CGFloat lim = -50;   //判定退出的下拉高度
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY<0 && !self.isZooming && !self.endDragging) {
        CGFloat scale = offsetY / lim;
        scale = scale > 1 ? 1 : scale;
        self.alpha = 1 - scale * 0.3;
    }else if(self.isZooming){
        self.alpha = 1;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.endDragging = 0;
}
//下拉超过一定高度松手后会消失退出
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (scrollView.contentOffset.y < lim) {
        self.endDragging = 1;
        [self hidenSelf];
    }
}

#pragma mark Setter and Getter
-(UIImageView *)imageView{
    if (!_imageView) {
        UIImageView *temp = [[UIImageView alloc] init];
        temp.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:temp];
        [temp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.equalTo(self);
        }];
        _imageView = temp;
    }
    return _imageView;
}
-(UIButton*)closeBN{
    if (!_closeBN) {
        UIButton *bn = [[UIButton alloc] init];
        [bn addTarget:self action:@selector(hidenSelf) forControlEvents:UIControlEventTouchUpInside];
        [bn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [self addSubview:bn];
        _closeBN = bn;
    }
    return _closeBN;
}
@end
