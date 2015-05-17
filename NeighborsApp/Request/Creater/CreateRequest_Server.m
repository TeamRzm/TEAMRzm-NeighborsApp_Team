//
//  CreateRequest_Server.m
//  NeighborsApp
//
//  Created by jason on 15/5/17.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreateRequest_Server.h"

@implementation CreateRequest_Server

+(ASIHTTPRequest *)CreateDynamicOfPropertyInfoWithIndex:(NSString *)_index Flag:(NSString *)_flag Size:(NSString *)_size
{
    NSDictionary *parmsDict = @{
                                @"index"    : _index,
                                @"size"     : _size,
                                @"flag"     : _flag
                                };
    
    ASIHTTPRequest *request = [CreateRequest_Server GetRequestWithMethod:@"/api.residence/news.cmd"
                                                              parmsDict:parmsDict
                                                          requestMethod:REQUEST_METHOD_POST];
    
    return request;

}

//获取当前小区花名册
+(ASIHTTPRequest *) CreateSmallRosterInfoList
{
    NSDictionary *parmsDict = @{
                                                                };
    
    ASIHTTPRequest *request = [CreateRequest_Server GetRequestWithMethod:@"/api.residence/members.cmd"
                                                               parmsDict:parmsDict
                                                           requestMethod:REQUEST_METHOD_POST];
    
    return request;

}

@end
