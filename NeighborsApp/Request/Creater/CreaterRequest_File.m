//
//  CreaterRequest_File.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/6.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_File.h"

@implementation CreaterRequest_File

+ (ASIHTTPRequest*) CreateSaveFileInfoRequestWithURL : (NSString*) _url
                                                 len : (NSString*) _len
                                                mime : (NSString*) _mime
                                                type : (NSString*) _type
{
    NSDictionary *parmsDict = @{
                                @"url"      : _url,
                                @"len"      : _len,
                                @"mime"     : _mime,
                                @"type"     : _type,
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_File GetRequestWithMethod:@"/api.file/post.cmd"
                                                                 parmsDict:parmsDict
                                                             requestMethod:REQUEST_METHOD_GET];
    
    return request;
}

@end
