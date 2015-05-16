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

+ (ASIHTTPRequest*) CreateForgotPwdRequestWithUserName : (NSString*) _userName
                                              password : (NSString*) _password
                                                verify : (NSString*) _verify
{
    NSDictionary *parmsDict = @{
                                @"username" : _userName,
                                @"password" : _password,
                                @"verify"   : _verify,
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_User GetRequestWithMethod:@"/api.user/forgot.cmd"
                                                              parmsDict:parmsDict
                                                          requestMethod:REQUEST_METHOD_POST];
    request.cachePolicy = ASIDoNotReadFromCacheCachePolicy;
    
    return request;
}

+ (ASIHTTPRequest*) CreateUserInfoRequest
{
    NSDictionary *parmsDict = @{
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_User GetRequestWithMethod:@"/api.user/info.cmd"
                                                              parmsDict:parmsDict
                                                          requestMethod:REQUEST_METHOD_POST];
    request.cachePolicy = ASIDoNotReadFromCacheCachePolicy;
    
    return request;
}

+ (ASIHTTPRequest*) CreateUpdatePwdRequestWithOpwd : (NSString*) _opwd
                                          password : (NSString*) _password
                                            verify : (NSString*) _verify
{
    NSDictionary *parmsDict = @{
                                @"opwd"     : _opwd,
                                @"password" : _password,
                                @"verify"   : _verify,
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_User GetRequestWithMethod:@"/api.user/updatePwd.cmd"
                                                              parmsDict:parmsDict
                                                          requestMethod:REQUEST_METHOD_POST];
    request.cachePolicy = ASIDoNotReadFromCacheCachePolicy;
    
    return request;
}

//更新用户信息
+ (ASIHTTPRequest*) CreateUpdateRequestWithPhone : (NSString*) _phone
                                             sex : (NSString*) _sex
                                        nickName : (NSString*) _nickName
                                          avatar : (NSString*) _avatar
                                       signature : (NSString*) _signature
                                           habit : (NSString*) _habit
{
    NSDictionary *parmsDict = @{
                                @"phone"       : _phone,
                                @"sex"         : _sex,
                                @"nickName"    : _nickName,
                                @"avatar"      : _avatar,
                                @"signature"   : _signature,
                                @"habit"       : _habit,
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_User GetRequestWithMethod:@"/api.user/update.cmd"
                                                              parmsDict:parmsDict
                                                          requestMethod:REQUEST_METHOD_POST];
    request.cachePolicy = ASIDoNotReadFromCacheCachePolicy;
    
    return request;
}

//获取用户好友
+ (ASIHTTPRequest*) CreateUserFriendGetRequestWithPhone : (NSString*) _phone;
{
    NSDictionary *parmsDict = @{
                                @"phone"       : _phone
                                };
    
    ASIHTTPRequest *request = [CreaterRequest_User GetRequestWithMethod:@"/api.friend/list.cmd"
                                                              parmsDict:parmsDict
                                                          requestMethod:REQUEST_METHOD_GET];
    request.cachePolicy = ASIDoNotReadFromCacheCachePolicy;
    
    return request;

}

//获取好友申请列表
+ (ASIHTTPRequest*) CreateApplyFriendListRequest
{
    ASIHTTPRequest *request = [CreaterRequest_User GetRequestWithMethod:@"/api.friend/applies.cmd"
                                                              parmsDict:nil
                                                          requestMethod:REQUEST_METHOD_GET];
    request.cachePolicy = ASIDoNotReadFromCacheCachePolicy;
    
    return request;

}



@end
