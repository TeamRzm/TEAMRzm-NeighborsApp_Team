//
//  XGPusher.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/17.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XGMessage.h"

typedef enum
{
    XGPUSH_ENVIRONEMNT_UNKOWN,
    XGPUSH_ENVIRONEMNT_PROD,
    XGPUSH_ENVIRONEMNT_DEV
}XGPUSH_ENVIRONEMNT;

@interface XGPusher : NSObject

+ (XGPusher*) shareInstance;

//配置信鸽
- (void) configWithSecretKey : (NSString*) _secretKey
                    accessId : (NSString*) _accessID
                 environment : (XGPUSH_ENVIRONEMNT) _environment;

//发送消息
- (void) pushMessage : (XGMessage*) message;

@end
