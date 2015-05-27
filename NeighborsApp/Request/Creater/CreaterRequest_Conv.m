//
//  CreaterRequest_Conv.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/7.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Conv.h"

@implementation CreaterRequest_Conv

+ (ASIHTTPRequest*) CreateListRequestWithIndex : (NSString*) index
                                          size : (NSString*) size
                                           lat : (NSString*) lat
                                           lng : (NSString*) lng
{
    NSDictionary *parmsDict = @{
                                @"index"    : ITOS(index.integerValue+1),
                                @"size"     : size,
                                @"lat"      : lat,
                                @"lng"      : lng,
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_Conv GetRequestWithMethod:@"/api.conv/list.cmd"
                                                              parmsDict:parmsDict
                                                          requestMethod:REQUEST_METHOD_GET];
    
    return request;
}

@end
