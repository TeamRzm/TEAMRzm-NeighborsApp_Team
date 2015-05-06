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
                                @"index"    : _index,
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
    NSMutableString *filesString = [[NSMutableString alloc] init];
    
    for (NSString *subString in _files)
    {
        [filesString appendFormat:@"%@,", subString];
    }
    
    NSString *resultFiels = @"";
    
    if (filesString.length > 0)
    {
        resultFiels = [filesString substringToIndex:filesString.length - 1];
    }
    
    NSDictionary *parmsDict = @{
                                @"title"    : _title,
                                @"info"     : _info,
                                @"files"    : resultFiels,
                                @"tag"      : _tag,
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_Logroll GetRequestWithMethod:@"/api.logroll/post.cmd"
                                                                 parmsDict:parmsDict
                                                             requestMethod:REQUEST_METHOD_POST];
    
    return request;
}

@end
