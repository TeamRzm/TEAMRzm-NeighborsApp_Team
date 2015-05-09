//
//  CreaterRequest_Activity.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/7.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Activity.h"

@implementation CreaterRequest_Activity

+ (ASIHTTPRequest*) CreateActivityRequestWithIndex:(NSString *)_index size:(NSString *)_size flag:(NSString *)_flag
{
    NSDictionary *parmsDict = @{
                                @"flag"     : _flag,
                                @"index"    : ITOS((_index.integerValue + 1)),
                                @"size"     : _size,
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_Activity GetRequestWithMethod:@"/api.activity/list.cmd"
                                                                  parmsDict:parmsDict
                                                              requestMethod:REQUEST_METHOD_GET];
    
    return request;
}

//获取某活动的报名人员信息表
+ (ASIHTTPRequest*) CreateJoinsRequestWithID : (NSString*) ID
                                       index : (NSString*) index
                                        size : (NSString*) size
{
    NSDictionary *parmsDict = @{
                                @"id"       : ID,
                                @"index"    : index,
                                @"size"     : size,
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_Activity GetRequestWithMethod:@"/api.activity/joins.cmd"
                                                                  parmsDict:parmsDict
                                                              requestMethod:REQUEST_METHOD_GET];
    
    return request;
}

//报名参加某活动
+ (ASIHTTPRequest*) CreateJoinRequestWithID : (NSString*) ID
                                      phone : (NSString*) phone
                                   contrace : (NSString*) contract
                                      count : (NSString*) count
{
    NSDictionary *parmsDict = @{
                                @"id"       : ID,
                                @"phone"    : phone,
                                @"contract" : contract,
                                @"count"    : count,
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_Activity GetRequestWithMethod:@"/api.activity/join.cmd"
                                                                  parmsDict:parmsDict
                                                              requestMethod:REQUEST_METHOD_POST];
    
    return request;
}

+ (ASIHTTPRequest*) CreateActivityPostRequestWithTitle : (NSString*) title
                                                 begin : (NSString*) begin
                                                   end : (NSString*) end
                                                 joins : (NSString*) joins
                                                   tag : (NSString*) tag
                                                 phone : (NSString*) phone
                                             constract : (NSString*) constract
                                               address : (NSString*) address
                                              regstart : (NSString*) regstart
                                                regend : (NSString*) regend
                                                   fee : (NSString*) fee
                                               content : (NSString*) content
                                                 files : (NSArray*)  files
{
    NSMutableString *filesString = [[NSMutableString alloc] initWithString:@""];
    
    for (NSString *subString in files)
    {
        [filesString appendFormat:@"&files[]=%@", subString];
    }
    
    NSDictionary *parmsDict = @{
                                @"title"        : title,
                                @"begin"        : begin,
                                @"end"          : end,
                                @"joins"        : joins,
                                @"tag"          : tag,
                                @"phone"        : phone,
                                @"contact"      : constract,
                                @"address"      : address,
                                @"regstart"     : regstart,
                                @"regend"       : regend,
                                @"fee"          : fee,
                                @"content"      : content,
                                @"files"        : files,
                                };
    
    NSString *requestURLString = [CreaterRequest_Activity URLStringWithMethod:@"/api.activity/create.cmd" parmsDict:parmsDict];
    
    requestURLString = [requestURLString stringByAppendingString:filesString];
    
    NSURL *url = [NSURL URLWithString:requestURLString];
    
    return [CreaterRequest_Activity RequestWithURL:url requestMethod:REQUEST_METHOD_POST];

}

@end
