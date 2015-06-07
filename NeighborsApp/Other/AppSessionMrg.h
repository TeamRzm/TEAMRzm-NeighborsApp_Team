//
//  AppSessionMrg.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/1.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserEntity.h"

@interface AppSessionMrg : NSObject

//信鸽DevieToken
@property (nonatomic, copy) NSString *XGDeviceToken;
@property (nonatomic, strong, setter=saveLoginState:) UserEntity *userEntity;

+ (AppSessionMrg*) shareInstance;


- (BOOL)    userIsLogin;

//是否入住小区
- (BOOL)    isInVillage;
- (void)    userLogout;
- (void)    saveLoginState : (UserEntity*) _entity;
- (void)    setSessionValue : (id) _value withKey : (NSString*) _key isSandBox : (BOOL) _inSandBox;
- (id)      getSessionWithKey : (NSString*) _key;
- (BOOL)    removeSessionWithKey : (NSString*) _key;

@end
