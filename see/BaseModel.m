//
//  BaseModel.m
//  see
//
//  Created by Easer Liu on 2019/8/21.
//  Copyright © 2019 Easer Liu. All rights reserved.
//

#import "BaseModel.h"
#import "APIs.h"

#import <AFNetworking.h>
#import <MJExtension.h>

@implementation BaseModel
+(void)getPhotoModelsWithBlock:(void (^)(NSURLSessionDataTask * _Nullable, id  _Nullable model, id  _Nullable responseObject, NSError * _Nullable error))block
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET: [self url]
      parameters:[self parameters] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
          NSMutableArray *models = [[NSMutableArray alloc] init];
          if (arr.count) {
              [self cacheModelsArray:arr];
              [arr enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                  BaseModel *model = [BaseModel mj_objectWithKeyValues:obj];
                  [model fixViewHeight];
                  [models addObject:model];
              }];
          }
          
          block(task, models, responseObject, nil);
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"请求失败");
          block(task, nil, nil, error);
      }];
}
-(void)fixViewHeight{
    CGFloat width = [UIScreen mainScreen].bounds.size.width * 0.4;
    self.viewSize = CGSizeMake(width, width * self.height / self.width);
}
+(NSString*)url{
    return [NSString stringWithFormat:@"%@/%@", [APIs host], [APIs photoList]];
}
+(NSDictionary*)parameters{
    return [APIs clientId];
}
+(void)cacheModelsArray:(NSArray*)arr{
    if (arr.count) {
        NSString *filePath =[self cachePath];
        NSString *pathResult = [arr writeToFile:filePath atomically:YES] ? @"通过path存入成功" : @"通过path存入失败";
        NSLog(@"%@",pathResult);
    }
    
}
//缓存中获取models
+(NSMutableArray*)modelsFromCache{
    NSString *filePath =[self cachePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:filePath];
    NSMutableArray * models = nil;
    if (isExist) {
        NSArray* modelsArr = [[NSArray alloc] initWithContentsOfFile:filePath];
        if (modelsArr.count) {
            [modelsArr enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BaseModel *model = [BaseModel mj_objectWithKeyValues:obj];
                [model fixViewHeight];
                [models addObject:model];
            }];
            
        }
    }
    return models;
}
//缓存路径
+(NSString*)cachePath{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask,YES)firstObject]stringByAppendingPathComponent:@"models.plist"];
}
#pragma mark MJExtension
//映射property与JSON
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID" : @"id",
             @"username" : @"user.username",
             @"profileImage" : @"user.profile_image.medium",
             @"urlRaw" : @"urls.raw",
             @"urlRegular" : @"urls.regular",
             @"urlSmall" : @"urls.small",
             };
}
@end
