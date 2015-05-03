//
//  Server.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/29.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Server : NSObject
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* hostName;
@property (nonatomic, copy) NSString* port;
@property (nonatomic, copy) NSString* path;

- (NSString*) createRequestServerURL;

@end
