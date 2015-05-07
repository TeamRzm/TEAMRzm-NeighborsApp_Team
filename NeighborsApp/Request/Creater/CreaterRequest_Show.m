//
//  CreaterRequest_Show.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/8.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Show.h"

@implementation CreaterRequest_Show

+ (ASIHTTPRequest*) CreateShowListRequestWithIndex : (NSString*) _index
                                              size : (NSString*) _size
                                              type : (NSString*) _type
{
    NSDictionary *parmsDict = @{
                                @"index"    : ITOS((_index.integerValue + 1)),
                                @"size"     : _size,
                                @"type"     : _type,
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_Show GetRequestWithMethod:@"/api.show/list.cmd"
                                                              parmsDict:parmsDict
                                                          requestMethod:REQUEST_METHOD_GET];
    
    return request;
}

@end
