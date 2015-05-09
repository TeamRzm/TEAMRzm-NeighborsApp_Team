//
//  CreaterRequest_Logroll.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/5.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Logroll.h"

@implementation CreaterRequest_Logroll

+ (ASIHTTPRequest*) CreateLogrollRequestWithIndex : (NSString*) _index
                                             size : (NSString*) _size
                                         accepted : (NSString*) _accepted
                                             isMy : (NSString*) _flag
{
    NSDictionary *parmsDict = @{
                                @"flag"     : _flag,
                                @"index"    : ITOS((_index.integerValue + 1)),
                                @"size"     : _size,
                                @"accepted" : _accepted,
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_Logroll GetRequestWithMethod:@"/api.logroll/list.cmd"
                                                              parmsDict:parmsDict
                                                          requestMethod:REQUEST_METHOD_GET];
    
    return request;
}

+ (ASIHTTPRequest*) CreateLogrollCommitRequestWithTitle : (NSString*) _title
                                                   info : (NSString*) _info
                                                  files : (NSArray*)  _files
                                                    tag : (NSString*) _tag
{
    NSMutableString *filesString = [[NSMutableString alloc] initWithString:@""];
    
    for (NSString *subString in _files)
    {
        [filesString appendFormat:@"&files[]=%@", subString];
    }
    
    NSDictionary *parmsDict = @{
                                @"title"    : _title,
                                @"info"     : _info,
                                @"tag"      : _tag,
                                };
    
    NSString *requestURLString = [CreaterRequest_Logroll URLStringWithMethod:@"/api.logroll/post.cmd" parmsDict:parmsDict];
    
    requestURLString = [requestURLString stringByAppendingString:filesString];
    
    NSURL *url = [NSURL URLWithString:requestURLString];
    
    return [CreaterRequest_Logroll RequestWithURL:url requestMethod:REQUEST_METHOD_POST];
}

+ (ASIHTTPRequest*) CreateLogrollReplyRequestWithID : (NSString*) _ID
                                               info : (NSString*) _info
                                              files : (NSArray*) _files
{
    NSMutableString *filesString = [[NSMutableString alloc] initWithString:@""];
    
    for (NSString *subString in _files)
    {
        [filesString appendFormat:@"&files[]=%@", subString];
    }
    
    NSDictionary *parmsDict = @{
                                @"id"    : _ID,
                                @"info"  : _info,
                                };
    
    NSString *requestURLString = [CreaterRequest_Logroll URLStringWithMethod:@"/api.logroll/reply.cmd" parmsDict:parmsDict];
    
    requestURLString = [requestURLString stringByAppendingString:filesString];
    
    NSURL *url = [NSURL URLWithString:requestURLString];
    
    return [CreaterRequest_Logroll RequestWithURL:url requestMethod:REQUEST_METHOD_POST];
}

+ (ASIHTTPRequest*) CreateLogrollListRequestWithID : (NSString*) _ID
                                             index : (NSString*) _index
                                              size : (NSString*) _size
{
    NSDictionary *parmsDict = @{
                                @"id"    : _ID,
                                @"index" : ITOS(_index.integerValue + 1),
                                @"size"  : _size,
                                };
    
    NSString *requestURLString = [CreaterRequest_Logroll URLStringWithMethod:@"/api.logroll/replies.cmd" parmsDict:parmsDict];
    
    NSURL *url = [NSURL URLWithString:requestURLString];
    
    return [CreaterRequest_Logroll RequestWithURL:url requestMethod:REQUEST_METHOD_GET];
}

@end
