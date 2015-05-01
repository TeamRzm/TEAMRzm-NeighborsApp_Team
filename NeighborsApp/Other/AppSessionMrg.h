//
//  AppSessionMrg.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/1.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSessionMrg : NSObject

+ (AppSessionMrg*) shareInstance;

- (void)    setSessionValue : (id) _value withKey : (NSString*) _key isSandBox : (BOOL) _inSandBox;
- (id)      getSessionWithKey : (NSString*) _key;
- (BOOL)    removeSessionWithKey : (NSString*) _key;

@end
