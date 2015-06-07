//
//  AppSessionMrg.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/1.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "AppSessionMrg.h"

#define SANDBOX_SESSION_KEY @"SANDBOX_SESSION_KEY"

#define SANDBOX_SESSION_USER_ENTITY @"SANDBOX_SESSION_USER_ENTITY"

@interface AppSessionMrg()
{
    NSMutableDictionary *sessionDict;
    NSMutableDictionary *sandBoxSessionDict;
}

- (BOOL) writeToSandBox;
- (BOOL) readFromSandBox;

@end

@implementation AppSessionMrg

- (BOOL) writeToSandBox
{
    [[NSUserDefaults standardUserDefaults] setValue:sandBoxSessionDict forKey:SANDBOX_SESSION_KEY];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL) readFromSandBox;
{
    sandBoxSessionDict = [[NSUserDefaults standardUserDefaults] valueForKey:SANDBOX_SESSION_KEY];
    if (sandBoxSessionDict)
    {
        return YES;
    }
    
    return NO;
}

- (void)    userLogout
{
    _userEntity = nil;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SANDBOX_SESSION_USER_ENTITY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return ;
}

- (BOOL)    userIsLogin
{
    if (_userEntity && _userEntity.token.length > 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL) isInVillage
{
    if ([self userIsLogin])
    {
        if (_userEntity && _userEntity.region)
        {
            return YES;
        }
    }
    
    return NO;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        sessionDict = [[NSMutableDictionary alloc] init];
        
        if (![self readFromSandBox])
        {
            sandBoxSessionDict = [[NSMutableDictionary alloc] init];
        }
        
        NSDictionary *userentityDict = [[NSUserDefaults standardUserDefaults] objectForKey:SANDBOX_SESSION_USER_ENTITY];
        
        if (userentityDict)
        {
            _userEntity = [[UserEntity alloc] initWithDict:userentityDict];
        }
    }
    return self;
}

+ (AppSessionMrg*) shareInstance
{
    static AppSessionMrg *shareInstanceAppSectionMrgObject;
    
    if (!shareInstanceAppSectionMrgObject)
    {
        shareInstanceAppSectionMrgObject = [[AppSessionMrg alloc] init];
    }
    
    return shareInstanceAppSectionMrgObject;
}

- (void) saveLoginState : (UserEntity*) _entity
{
    _userEntity = _entity;
    
    [[NSUserDefaults standardUserDefaults] setObject:[_entity dictEntity] forKey:SANDBOX_SESSION_USER_ENTITY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)    setSessionValue : (id) _value withKey : (NSString*) _key isSandBox : (BOOL) _inSandBox
{
    if (_inSandBox)
    {
        [sandBoxSessionDict setObject:_value forKey:_key];
        [self writeToSandBox];
    }
    else
    {
        [sessionDict setObject:_value forKey:_key];
    }
}

- (id)      getSessionWithKey : (NSString*) _key
{
    if ([sandBoxSessionDict.allKeys containsObject:_key])
    {
        return sandBoxSessionDict[_key];
    }
    
    if ([sessionDict.allKeys containsObject:_key])
    {
        return sessionDict[_key];
    }
    
    return nil;
}

- (BOOL)    removeSessionWithKey : (NSString*) _key
{
    if ([sandBoxSessionDict.allKeys containsObject:_key])
    {
        [sandBoxSessionDict removeObjectForKey:_key];
        [self writeToSandBox];
        
        return YES;
    }
    
    if ([sessionDict.allKeys containsObject:_key])
    {
        [sessionDict removeObjectForKey:_key];
        
        return YES;
    }
    
    return NO;
}

@end
