//
//  BaseModel.h
//  see
//
//  Created by Easer Liu on 2019/8/21.
//  Copyright © 2019 Easer Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseModel : NSObject

@property (nonatomic, copy) NSString* ID;
@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSString* urlRaw;
@property (nonatomic, copy) NSString* urlRegular;
@property (nonatomic, copy) NSString* urlSmall;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, copy) NSString* profileImage;

+(void)getPhotoModelsWithBlock:(void (^)(NSURLSessionDataTask * _Nullable task, id  _Nullable model, id  _Nullable responseObject, NSError * _Nullable error))block;
+(NSMutableArray*)modelsFromCache;
@end

NS_ASSUME_NONNULL_END
