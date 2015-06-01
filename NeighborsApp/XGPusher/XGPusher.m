//
//  XGPusher.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/17.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "XGPusher.h"
#import "XGSign.h"
#import "ASIHTTPRequest.h"


@interface XGPusher()
{
    NSString            *xgPushSecretKey;
    NSString            *xgAccessID;
    XGPUSH_ENVIRONEMNT  xgPushEnvironement;
}
@end

@implementation XGPusher


+ (XGPusher*) shareInstance
{
    static XGPusher* staticPusher;
    
    if (!staticPusher)
    {
        staticPusher = [[XGPusher alloc] init];
    }
    
    return staticPusher;
}

//配置信鸽
- (void) configWithSecretKey : (NSString*) _secretKey
                    accessId : (NSString*) _accessID
                 environment : (XGPUSH_ENVIRONEMNT) _environment
{
    xgPushSecretKey = _secretKey;
    xgPushEnvironement = _environment;
    xgAccessID = _accessID;
    
    return ;
}

//发送消息
- (void) pushMessage : (XGMessage*) message
{
    NSString *pushUrl = @"http://openapi.xg.qq.com/v2/push/single_device";
    
    NSTimeInterval stampTimeInterval = [[NSDate date] timeIntervalSince1970];
    
    NSString *timeStampString = [NSString stringWithFormat:@"%.0f", stampTimeInterval];
    
    NSString *messageJson = [message getMessgeJSONString];
    
    //接口参数
    NSDictionary *parmsDict = @{
                                @"access_id"    : xgAccessID,
                                @"timestamp"    : timeStampString,
                                @"device_token" : message.toDeviceToken,
                                @"message_type" : @"0",
                                @"message"      : @"",//messageJson,
                                @"expire_time"  : @"259200", //保存三天
                                @"environment"  : ITOS(xgPushEnvironement),
                                @"valid_time"   : @"",
                                @"send_time"    : @"",
                                @"multi_pkg"    : @"",
                                };
    
    NSString *sign = [XGSign XGSignWithMehod:@"GET"
                                     hostURL:@"openapi.xg.qq.com/v2/push/single_device"
                                       parms:parmsDict
                                   timestamp:timeStampString
                                   secretKey:xgPushSecretKey];
    
    NSMutableString *resultRequestURLString = [[NSMutableString alloc] initWithString:pushUrl];
    
    BOOL addFlag = NO;
    
    NSArray *sortKeyArr = [parmsDict.allKeys sortedArrayUsingSelector:@selector(compare:)];

    
    for (NSString *subKey in sortKeyArr)
    {
        if (!addFlag)
        {
            [resultRequestURLString appendFormat:@"?%@=%@", subKey, parmsDict[subKey]];
            addFlag = YES;
        }
        else
        {
            [resultRequestURLString appendFormat:@"&%@=%@", subKey, parmsDict[subKey]];
        }
    }
    
    [resultRequestURLString appendFormat:@"&sign=%@",sign];
    
    NSString *urlEncodeString = [resultRequestURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ASIHTTPRequest *sendMessageRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlEncodeString]];
    sendMessageRequest.requestMethod = @"GET";
    
    __weak ASIHTTPRequest *blockRequest = sendMessageRequest;
    
    [blockRequest setCompletionBlock:^{
        NSLog(@"%@", blockRequest.url);
        NSLog(@"%@", blockRequest.responseString);
        return ;
    }];
    
    [blockRequest setFailedBlock:^{
        return ;
    }];
    
    [sendMessageRequest startSynchronous];
}

@end
