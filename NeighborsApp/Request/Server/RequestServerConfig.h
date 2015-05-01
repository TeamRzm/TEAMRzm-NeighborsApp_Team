//
//  RequestServerConfig.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/29.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Server.h"

@interface RequestServerConfig : NSObject

+ (RequestServerConfig*) shareInstance;
+ (RequestServerConfig*) shareInstanceWithPlistPaht : (NSString*) _path;

- (Server*)  getCurrentServer;
- (NSArray*) getAllServerName;
- (void)     changedServerWithIndex : (NSInteger) _index;
- (void)     changedServerWithName : (NSString*) _name;

@end
