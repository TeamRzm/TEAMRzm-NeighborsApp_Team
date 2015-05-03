//
//  AppSessionMrg.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/1.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserEntity.h"

#define XG_CLIENT_ID @"XG_CLIENT_ID"

@interface AppSessionMrg : NSObject

@property (nonatomic, strong) UserEntity *userEntity;


+ (AppSessionMrg*) shareInstance;

- (void)    setSessionValue : (id) _value withKey : (NSString*) _key isSandBox : (BOOL) _inSandBox;
- (id)      getSessionWithKey : (NSString*) _key;
- (BOOL)    removeSessionWithKey : (NSString*) _key;

@end
