//
//  Server.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/29.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "Server.h"

@implementation Server

- (NSString*) createRequestServerURL
{
    NSMutableString *url = [[NSMutableString alloc] initWithString:self.hostName];
    
    if (self.port && self.port.length > 0)
    {
        [url appendFormat:@":%@", self.port];
    }
    
    if (self.path && self.path.length > 0)
    {
        [url appendFormat:@"\%@", self.path];
    }
    
    return url;
}

@end
