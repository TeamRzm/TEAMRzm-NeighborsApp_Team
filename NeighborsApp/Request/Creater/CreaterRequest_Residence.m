//
//  CreaterRequest_Residence.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/25.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Residence.h"

@implementation CreaterRequest_Residence


+ (ASIHTTPRequest*) CreateResidenceNewsRequestWithFlag : (NSString*) _flag
                                                  size : (NSString*) _size
                                                 index : (NSString*) _index
{
    NSDictionary *parmsDict = @{
                                @"flag"      : _flag,
                                @"index"     : ITOS(_index.integerValue + 1),
                                @"size"      : _size,
                                };
    
    NSString *requestURLString = [CreaterRequest_Residence URLStringWithMethod:@"/api.residence/news.cmd" parmsDict:parmsDict];
    
    NSURL *url = [NSURL URLWithString:requestURLString];
    
    return [CreaterRequest_Residence RequestWithURL:url requestMethod:REQUEST_METHOD_GET];
}

@end
