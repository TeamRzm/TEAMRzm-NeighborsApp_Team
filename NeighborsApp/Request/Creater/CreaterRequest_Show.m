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

+ (ASIHTTPRequest*) CreateShowPostReuqetWithInfo:(NSString *)_info tag:(NSString *)_tag flag:(NSString *)_flag files:(NSArray *)files
{
    NSMutableString *filesString = [[NSMutableString alloc] initWithString:@""];
    
    for (NSString *subString in files)
    {
        [filesString appendFormat:@"&files[]=%@", subString];
    }
    
    NSDictionary *parmsDict = @{
                                @"info"     : _info,
                                @"tag"      : _tag,
                                @"flag"     : _flag,
                                };
    
    NSString *requestURLString = [CreaterRequest_Show URLStringWithMethod:@"/api.show/post.cmd" parmsDict:parmsDict];
    
    requestURLString = [requestURLString stringByAppendingString:filesString];
    
    NSURL *url = [NSURL URLWithString:requestURLString];
    
    return [CreaterRequest_Show RequestWithURL:url requestMethod:REQUEST_METHOD_POST];
}

+ (ASIHTTPRequest*) CreateShowRepliesRequestWithID : (NSString*) ID
                                             index : (NSString*) index
                                              size : (NSString*) size
{
    NSDictionary *parmsDict = @{
                                @"id"    : ID,
                                @"index" : ITOS(index.integerValue + 1),
                                @"size"  : size,
                                };
    
    NSString *requestURLString = [CreaterRequest_Show URLStringWithMethod:@"/api.show/replies.cmd" parmsDict:parmsDict];
    
    NSURL *url = [NSURL URLWithString:requestURLString];
    
    return [CreaterRequest_Show RequestWithURL:url requestMethod:REQUEST_METHOD_GET];
}

//回复里帮信息
+ (ASIHTTPRequest*) CreateShowReplyRequestWithID : (NSString*) _ID
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
    
    NSString *requestURLString = [CreaterRequest_Show URLStringWithMethod:@"/api.show/reply.cmd" parmsDict:parmsDict];
    
    requestURLString = [requestURLString stringByAppendingString:filesString];
    
    NSURL *url = [NSURL URLWithString:requestURLString];
    
    return [CreaterRequest_Show RequestWithURL:url requestMethod:REQUEST_METHOD_POST];
}

//删除
//type {0,里手帮，1:回复消息}
+ (ASIHTTPRequest*) CreateDeleteRequestWithID : (NSString*) _ID
                                         type : (NSString*) _type
{
    NSDictionary *parmsDict = @{
                                @"id"    : _ID,
                                @"type"  : _type,
                                };
    
    NSString *requestURLString = [CreaterRequest_Show URLStringWithMethod:@"/api.show/remove.cmd" parmsDict:parmsDict];
    
    NSURL *url = [NSURL URLWithString:requestURLString];
    
    return [CreaterRequest_Show RequestWithURL:url requestMethod:REQUEST_METHOD_POST];
}

//接受回复
+ (ASIHTTPRequest*) CreateAcceptRequestWithID : (NSString*) _ID
{
    NSDictionary *parmsDict = @{
                                @"id"    : _ID,
                                };
    
    NSString *requestURLString = [CreaterRequest_Show URLStringWithMethod:@"/api.show/accept.cmd" parmsDict:parmsDict];
    
    NSURL *url = [NSURL URLWithString:requestURLString];
    
    return [CreaterRequest_Show RequestWithURL:url requestMethod:REQUEST_METHOD_POST];

}

@end
