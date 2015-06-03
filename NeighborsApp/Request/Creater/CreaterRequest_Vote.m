//
//  CreaterRequest_Vote.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/6/4.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Vote.h"

@implementation CreaterRequest_Vote

+ (ASIHTTPRequest*) CreateVoteListRequestWithIndex : (NSString*) _index
                                              size : (NSString*) _size
                                              flag : (NSString*) _flag
{
    NSDictionary *parmsDict = @{
                                @"flag"      : _flag,
                                @"index"     : ITOS(_index.integerValue + 1),
                                @"size"      : _size,
                                };
    
    NSString *requestURLString = [CreaterRequest_Vote URLStringWithMethod:@"/api.vote/list.cmd" parmsDict:parmsDict];
    
    NSURL *url = [NSURL URLWithString:requestURLString];
    
    return [CreaterRequest_Vote RequestWithURL:url requestMethod:REQUEST_METHOD_GET];
}

+ (ASIHTTPRequest*)CreateVoteAddRequestWithID : (NSString*) _ID
                                         flag : (NSString*) _flag
{
    NSDictionary *parmsDict = @{
                                @"flag"      : _flag,
                                @"id"        : _ID,
                                };
    
    NSString *requestURLString = [CreaterRequest_Vote URLStringWithMethod:@"/api.vote/vote.cmd" parmsDict:parmsDict];
    
    NSURL *url = [NSURL URLWithString:requestURLString];
    
    return [CreaterRequest_Vote RequestWithURL:url requestMethod:REQUEST_METHOD_GET];
}

@end
