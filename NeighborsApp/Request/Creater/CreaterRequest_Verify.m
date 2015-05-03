//
//  CreaterRequest_Verify.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/2.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Verify.h"

@implementation CreaterRequest_Verify


+ (ASIHTTPRequest*) CreateVerifyRequestWithPhone : (NSString*) _phoneNumber
                                            type : (NSString*) _type
                                            flag : (NSString*) _flag
{
    NSDictionary *parmsDict = @{
                                    @"phone"    : _phoneNumber,
                                    @"type"     : _type,
                                    @"flag"     : _flag,
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_Verify GetRequestWithMethod:@"/api.verify/getVerify.cmd"
                                                              parmsDict:parmsDict
                                                          requestMethod:REQUEST_METHOD_POST];
    
    return request;

}

@end
