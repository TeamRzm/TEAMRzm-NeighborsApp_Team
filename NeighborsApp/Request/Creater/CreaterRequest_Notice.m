//
//  CreaterRequest_Notice.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/7.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Notice.h"

@implementation CreaterRequest_Notice

//获得我收到的消息列表 flag : {0:社区通知，1:好友申请通知}
+ (ASIHTTPRequest*) CreateListRequestWithIndex : (NSString*) index
                                          size : (NSString*) size
                                          flag : (NSString*) flag
{
    NSDictionary *parmsDict = @{
                                @"index"    : index,
                                @"size"     : size,
                                @"flag"     : flag,
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_Notice GetRequestWithMethod:@"/api.notice/list.cmd"
                                                              parmsDict:parmsDict
                                                          requestMethod:REQUEST_METHOD_GET];
    
    return request;
}

//标记已读消息
+ (ASIHTTPRequest*) CreateMarkRequestWithID : (NSString*) ID
{
    NSDictionary *parmsDict = @{
                                @"id"    : ID,
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_Notice GetRequestWithMethod:@"/api.notice/mark.cmd"
                                                                parmsDict:parmsDict
                                                            requestMethod:REQUEST_METHOD_POST];
    
    return request;
}


+ (ASIHTTPRequest*) CreateNotifyGetRequest
{
    NSDictionary *parmsDict = @{
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_Notice GetRequestWithMethod:@"/api.notify/get.cmd"
                                                                parmsDict:parmsDict
                                                            requestMethod:REQUEST_METHOD_POST];
    
    return request;
}

@end
