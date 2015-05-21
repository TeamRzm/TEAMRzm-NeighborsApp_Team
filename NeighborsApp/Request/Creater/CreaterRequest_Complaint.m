//
//  CreaterRequest_ComplaintViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/20.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Complaint.h"

@interface CreaterRequest_Complaint()

@end

@implementation CreaterRequest_Complaint

+ (ASIHTTPRequest*) CreateComplaintPostRequestWithContact : (NSString *) _contact
                                                    phone : (NSString *) _phone
                                                  address : (NSString *) _address
                                                  content : (NSString *) _content
                                                    files : (NSArray  *) _files
                                                     type : (NSString *) _type
{
    NSMutableString *filesString = [[NSMutableString alloc] initWithString:@""];
    
    for (NSString *subString in _files)
    {
        [filesString appendFormat:@"&files[]=%@", subString];
    }
    
    NSDictionary *parmsDict = @{
                                @"contact"      : _contact,
                                @"phone"        : _phone,
                                @"addresss"     : _address,
                                @"content"      : _content,
                                @"type"         : _type,
                                };
    
    NSString *requestURLString = [CreaterRequest_Complaint URLStringWithMethod:@"/api.complaint/post.cmd" parmsDict:parmsDict];
    
    requestURLString = [requestURLString stringByAppendingString:filesString];
    
    NSURL *url = [NSURL URLWithString:requestURLString];
    
    return [CreaterRequest_Complaint RequestWithURL:url requestMethod:REQUEST_METHOD_POST];
}

+ (ASIHTTPRequest*) CreateComplaintListRequestWithType : (NSString *) _type
                                                  flag : (NSString *) _flag
                                                 index : (NSString *) _index
                                                  size : (NSString *) _size
{
    NSDictionary *parmsDict = @{
                                @"type"      : _type,
                                @"flag"      : _flag,
                                @"index"     : ITOS(_index.integerValue + 1),
                                @"size"      : _size,
                                };
    
    NSString *requestURLString = [CreaterRequest_Complaint URLStringWithMethod:@"/api.complaint/list.cmd" parmsDict:parmsDict];
    
    NSURL *url = [NSURL URLWithString:requestURLString];
    
    return [CreaterRequest_Complaint RequestWithURL:url requestMethod:REQUEST_METHOD_GET];
}

@end
