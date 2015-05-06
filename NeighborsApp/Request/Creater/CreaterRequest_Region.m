//
//  CreaterRequest_Region.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/7.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Region.h"

@implementation CreaterRequest_Region

+ (ASIHTTPRequest*) CreateListRequest
{
    NSDictionary *parmsDict = @{
                                @"id"      : @"1"
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_Region GetRequestWithMethod:@"/api.region/list.cmd"
                                                                parmsDict:parmsDict
                                                            requestMethod:REQUEST_METHOD_GET];
    
    return request;
}

@end
