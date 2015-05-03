//
//  RequestServerConfig.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/29.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "RequestServerConfig.h"

@interface RequestServerConfig()
{
    NSDictionary *configDict;
    
    NSString     *currentSelectServerName;
}
@end

@implementation RequestServerConfig

+ (RequestServerConfig*) shareInstance
{
    NSString *defaultPlistPath = [[NSBundle mainBundle] pathForResource:@"RequestServerConfig" ofType:@"plist"];
    
    return [self shareInstanceWithPlistPaht:defaultPlistPath];
}

+ (RequestServerConfig*) shareInstanceWithPlistPaht : (NSString*) _path
{
    static RequestServerConfig *shareInstanceConfig;
    
    if (!shareInstanceConfig)
    {
        shareInstanceConfig = [[RequestServerConfig alloc] initWithPlistPath:_path];
    }
    
    return shareInstanceConfig;
}

- (id) initWithPlistPath : (NSString*) _path
{
    self = [super init];
    
    if (self)
    {
        configDict = [[NSDictionary alloc] initWithContentsOfFile:_path];
        
        if (!configDict)
        {
            return nil;
        }
        
        currentSelectServerName = configDict.allKeys[0];
    }
    
    return self;
}

- (Server*) serverWithDict : (NSDictionary*) _dict
{
    Server *newServer = [[Server alloc] init];
    
    if ([_dict.allKeys containsObject:@"HostName"])
    {
        newServer.hostName = _dict[@"HostName"];
    }
    else
    {
        newServer.hostName = @"";
    }
    
    if ([_dict.allKeys containsObject:@"Path"])
    {
        newServer.path = _dict[@"Path"];
    }
    else
    {
        newServer.path = @"";
    }
    
    if ([_dict.allKeys containsObject:@"Port"])
    {
        newServer.port = _dict[@"Port"];
    }
    else
    {
        newServer.port = @"";
    }
    
    return newServer;
}

- (Server*)  getCurrentServer
{
    NSDictionary *currentServerDict = configDict[currentSelectServerName];
    
    return [self serverWithDict:currentServerDict];
}

- (NSArray*) getAllServerName
{
    return configDict.allKeys;
}

- (void)     changedServerWithIndex : (NSInteger) _index
{
    currentSelectServerName = configDict.allValues[_index];
}

- (void)     changedServerWithName : (NSString*) _name
{
    currentSelectServerName = configDict[_name];
}

- (NSString*)getCurrentHostUrl
{
    return [self getCurrentServer].createRequestServerURL;
}

@end

