//
//  CreaterRequest_Owner.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/26.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Owner.h"

@implementation CreaterRequest_Owner

+ (ASIHTTPRequest*) CreateInfoRequest
{
    NSDictionary *parmsDict = @{
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_Owner GetRequestWithMethod:@"/api.owner/info.cmd"
                                                              parmsDict:parmsDict
                                                          requestMethod:REQUEST_METHOD_GET];
    
    return request;
}

+ (ASIHTTPRequest*) CreateMemberListRequest
{
    NSDictionary *parmsDict = @{
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_Owner GetRequestWithMethod:@"/api.owner/members.cmd"
                                                               parmsDict:parmsDict
                                                           requestMethod:REQUEST_METHOD_GET];
    
    return request;
}

//读取业委会维修基金信息
+ (ASIHTTPRequest*) CreateFundRequestWithIndex : (NSString*) _index
                                          size : (NSString*) _size
                                         start : (NSString*) _start
                                           end : (NSString*) _end
{
    NSDictionary *parmsDict = @{
                                @"index"  : ITOS(_index.integerValue + 1),
                                @"size"   : _size,
                                @"start"  : _start,
                                @"end"    : _end,
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_Owner GetRequestWithMethod:@"/api.owner/fund.cmd"
                                                               parmsDict:parmsDict
                                                           requestMethod:REQUEST_METHOD_GET];
    
    return request;
}

@end
