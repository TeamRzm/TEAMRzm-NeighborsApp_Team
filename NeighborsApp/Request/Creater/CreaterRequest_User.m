//
//  CreaterRequest_User.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/2.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_User.h"

@implementation CreaterRequest_User

//注册
+ (ASIHTTPRequest*) CreateUserRegisterRequestWithUserName : (NSString*) _userName
                                                 password : (NSString*) _password
                                                     nick : (NSString*) _nick
                                                   verify : (NSString*) _verify
{
    NSDictionary *parmsDict = @{
                                @"username" : _userName,
                                @"password" : _password,
                                @"nick"     : _nick,
                                @"verify"   : _verify,
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_User GetRequestWithMethod:@"/api.user/register.cmd"
                                                              parmsDict:parmsDict
                                                          requestMethod:REQUEST_METHOD_GET];
    
    return request;
}


+ (ASIHTTPRequest*) CreateUserLoginRequestWithUserName : (NSString*) _userName
                                              password : (NSString*) _password
                                                verify : (NSString*) _verify
                                              clientId : (NSString*) _clientId
{
    NSDictionary *parmsDict = @{
                                @"username" : _userName,
                                @"password" : _password,
                                @"clientId" : _clientId,
                                @"verify"   : _verify,
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_User GetRequestWithMethod:@"/api.user/login.cmd"
                                                              parmsDict:parmsDict
                                                          requestMethod:REQUEST_METHOD_POST];
    request.cachePolicy = ASIDoNotReadFromCacheCachePolicy;
    
    return request;
}

@end
