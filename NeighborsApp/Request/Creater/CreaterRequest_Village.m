//
//  CreaterRequest_Village.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/7.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Village.h"

@implementation CreaterRequest_Village

//获取附近小区列表
+ (ASIHTTPRequest*) CreateNearRequestWithLat : (NSString*) lat
                                         lng : (NSString*) lng
                                        size : (NSString*) size
{
    NSDictionary *parmsDict = @{
                                @"lat"      : lat,
                                @"lng"      : lng,
                                @"size"     : size,
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_Village GetRequestWithMethod:@"/api.village/near.cmd"
                                                              parmsDict:parmsDict
                                                          requestMethod:REQUEST_METHOD_GET];
    
    return request;
}

//关键字查询小区
+ (ASIHTTPRequest*) CreateListRequestWithSearchID : (NSString*) searchID
                                              key : (NSString*) key
                                             size : (NSString*) size
{
    NSDictionary *parmsDict = @{
                                @"id"       : searchID,
                                @"key"      : key,
                                @"size"     : size,
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_Village GetRequestWithMethod:@"/api.village/search.cmd"
                                                                 parmsDict:parmsDict
                                                             requestMethod:REQUEST_METHOD_GET];
    
    return request;
}

//按照区域查询小区
+ (ASIHTTPRequest*) CreateListRequestWithID : (NSString*) ID
                                       code : (NSString*) code
{
    NSDictionary *parmsDict = @{
                                @"id"       : ID,
                                @"code"     : code,
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_Village GetRequestWithMethod:@"/api.village/list.cmd"
                                                                 parmsDict:parmsDict
                                                             requestMethod:REQUEST_METHOD_GET];
    
    return request;
}

//入住某小区
+ (ASIHTTPRequest*) CreateApplyRequestWithID : (NSString*) ID
                                        data : (NSString*) data
                                       phone : (NSString*) phone
                                     contact : (NSString*) contact
                                   ownerName : (NSString*) ownerName
                                   ownerType : (NSString*) ownerType
                                       house : (NSString*) house
{
    NSDictionary *parmsDict = @{
                                @"id"       : ID,
                                @"data"     : data, //邀请码？？？ 字段为data 不是code？？
                                @"phone"    : phone,
                                @"contact"  : contact,
                                @"ownerName": ownerName,
                                @"ownerType": ownerType,
                                @"house"    : house,
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_Village GetRequestWithMethod:@"/api.village/apply.cmd"
                                                                 parmsDict:parmsDict
                                                             requestMethod:REQUEST_METHOD_POST];
    
    return request;
}

//我入住的小区
+ (ASIHTTPRequest*) CreateListAppLinesRequest
{
    NSDictionary *parmsDict = @{
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_Village GetRequestWithMethod:@"/api.village/listApplies.cmd"
                                                                 parmsDict:parmsDict
                                                             requestMethod:REQUEST_METHOD_GET];
    
    return request;
}

//删除我入住的某个小区
+ (ASIHTTPRequest*) CreateDeleteAppLinesRequestWithID : (NSString*) ID
{
    NSDictionary *parmsDict = @{
                                @"id"   : ID,
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_Village GetRequestWithMethod:@"/api.village/delete.cmd"
                                                                 parmsDict:parmsDict
                                                             requestMethod:REQUEST_METHOD_POST];
    
    return request;
}

//切换当前xiaoqu
+ (ASIHTTPRequest*) CreateExchangeRequestWithID : (NSString*) ID
{
    NSDictionary *parmsDict = @{
                                @"id"   : ID,
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_Village GetRequestWithMethod:@"/api.village/exchange.cmd"
                                                                 parmsDict:parmsDict
                                                             requestMethod:REQUEST_METHOD_POST];
    
    return request;
}

@end
