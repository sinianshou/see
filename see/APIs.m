//
//  APIs.m
//  see
//
//  Created by Easer Liu on 2019/8/21.
//  Copyright © 2019 Easer Liu. All rights reserved.
//

#import "APIs.h"
#define CLIENTID @"d992c4691c1ba965d85688ab7607847b46c336d4b22f3f670a6d4cbde959bd3e"

@implementation APIs

+(NSString*)host{
    return @"http://api.unsplash.com";
}
+(NSString*)photoList{
    return @"photos";
}
+(NSDictionary*)clientId{
    return @{@"client_id":CLIENTID};
}
@end
