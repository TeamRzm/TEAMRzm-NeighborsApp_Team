//
//  CreaterRequest_Verify.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/2.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Base.h"

@interface CreaterRequest_Verify : CreaterRequest_Base

//获取验证码 flag {0:注册,1:找回密码,2:产权认证}
+ (ASIHTTPRequest*) CreateVerifyRequestWithPhone : (NSString*) _phoneNumber
                                            type : (NSString*) _type
                                            flag : (NSString*) _flag;

@end
