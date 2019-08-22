//
//  MainVC.m
//  see
//
//  Created by Easer Liu on 2019/8/21.
//  Copyright © 2019 Easer Liu. All rights reserved.
//

#import "MainVC.h"
#import "MainCell.h"
#import "BaseModel.h"
#import "FlowLayout.h"
#import "DetailImageView.h"

#import <MJRefresh.h>

@interface MainVC ()<FlowLayoutDelegate>

@property (nonatomic, strong) NSMutableArray *models;
@property (nonatomic, weak) DetailImageView *detailImage;

@end

@implementation MainVC

static NSString * const reuseIdentifier = @"Cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Unsplash";
    ((FlowLayout*)self.collectionViewLayout).delegate = self;
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[MainCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self configMJRefresh];
    if (!self.models.count) {
        [self reloadFromCache];
        [self refreshData];
    }
    // Do any additional setup after loading the view.
}
-(void)configMJRefresh{
    //下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    //自动更改透明度
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    //上拉刷新
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    //自动更改透明度
    self.collectionView.mj_footer.automaticallyChangeAlpha = YES;
}
-(void)refreshData{
    NSLog(@"start refresh");
    //进入刷新状态
    [self.collectionView.mj_header beginRefreshing];
    [self getDataWithBlock:^(NSMutableArray*  _Nullable model) {
        self.models = model;
        [self refreshUI];
    }];
}
-(void)loadMoreData{
    NSLog(@"start loadMoreData");
    //进入加载状态
    [self.collectionView.mj_footer beginRefreshing];
    [self getDataWithBlock:^(NSMutableArray*  _Nullable model) {
        [self.models addObjectsFromArray:model];
        [self refreshUI];
    }];
}
//从缓存中加载model
-(void)reloadFromCache{
    NSMutableArray *arrM = [BaseModel modelsFromCache];
    if (arrM.count) {
        self.models = arrM;
        [self refreshUI];
    }
}
//获取model
-(void)getDataWithBlock:(void (^)(id  _Nullable model))block{
    [BaseModel getPhotoModelsWithBlock:^(NSURLSessionDataTask * _Nullable task, NSMutableArray*  _Nullable model, id  _Nullable responseObject, NSError * _Nullable error) {
        block(model);
//        结束MJRefresh的加载状态
        NSLog(@"end refresh or loadMoreData");
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
    }];
}
//刷新CollectionView
-(void)refreshUI{
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%s", __func__);
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __func__);
    MainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // Configure the cell
    [cell configWithModel:self.models[indexPath.row]];
    return cell;
}
//可拖动item
-(BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%s", __func__);
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath{
    NSLog(@"%s", __func__);
    NSInteger sRow = sourceIndexPath.row;
    NSInteger dRow = destinationIndexPath.row;
    NSLog(@"move from %ld to %ld", sRow, dRow);
    NSNumber *sNum = self.models[sRow];
    if (sRow>dRow) {
        [self.models insertObject:sNum atIndex:dRow];
        [self.models removeObjectAtIndex:sRow+1];
    }else{
        [self.models insertObject:sNum atIndex:dRow+1];
        [self.models removeObjectAtIndex:sRow];
    }
}
#pragma mark <UICollectionViewDelegate>
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    //    点击Item时显示大图
    [self.detailImage showWithURL:((BaseModel*)self.models[indexPath.row]).urlRaw fromRect:cell.frame];
    return NO;
}
#pragma mark <FlowLayoutDelegate>

- (CGFloat)flowLayout:(FlowLayout *)flowLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath{
    return ((BaseModel*)self.models[indexPath.row]).viewSize.height;
}
#pragma mark Setter and Getter
//懒加载
-(NSMutableArray *)models{
    if (_models == nil) {
        _models = [[NSMutableArray alloc] init];
    }
    return _models;
}

-(DetailImageView *)detailImage{
    if (_detailImage == nil) {
        DetailImageView *temp = [[DetailImageView alloc] init];
        temp.hidden = YES;
        [self.view addSubview:temp];
        _detailImage = temp;
        _detailImage.backgroundColor = [UIColor grayColor];
    }
    return _detailImage;
}
@end
