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

//修改密码
+ (ASIHTTPRequest*) CreateUpdatePwdRequestWithOpwd : (NSString*) _opwd
                                          password : (NSString*) _password
                                            verify : (NSString*) _verify;

//获取用户信息
+ (ASIHTTPRequest*) CreateUserInfoRequest;

//更新用户信息
+ (ASIHTTPRequest*) CreateUpdateRequestWithPhone : (NSString*) _phone
                                             sex : (NSString*) _sex
                                        nickName : (NSString*) _nickName
                                          avatar : (NSString*) _avatar
                                       signature : (NSString*) _signature
                                           habit : (NSString*) _habit;

//获取用户好友
+ (ASIHTTPRequest*) CreateUserFriendGetRequestWithPhone : (NSString*) _phone;

//获取好友申请列表
+ (ASIHTTPRequest*) CreateApplyFriendListRequest;

//发送消息

+(ASIHTTPRequest *) CreateSendSingleMessageWithToken:(NSString *) _token
                                             WithMsg:(NSString *) _msg;




@end
