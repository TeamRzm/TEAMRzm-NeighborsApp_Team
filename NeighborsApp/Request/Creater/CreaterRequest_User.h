//
//  CreaterRequest_User.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/2.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Base.h"

@interface CreaterRequest_User : CreaterRequest_Base

//注册
+ (ASIHTTPRequest*) CreateUserRegisterRequestWithUserName : (NSString*) _userName
                                                 password : (NSString*) _password
                                                     nick : (NSString*) _nick
                                                   verify : (NSString*) _verify;



//登录
+ (ASIHTTPRequest*) CreateUserLoginRequestWithUserName : (NSString*) _userName
                                              password : (NSString*) _password
                                                verify : (NSString*) _verify
                                              clientId : (NSString*) _clientId;

//忘记密码
+ (ASIHTTPRequest*) CreateForgotPwdRequestWithUserName : (NSString*) _userName
                                              password : (NSString*) _password
                                                verify : (NSString*) _verify;


@end
