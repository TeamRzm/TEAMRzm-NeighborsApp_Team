//
//  XGMessage.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/17.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "XGMessage.h"
#import "SBJson.h"
#import "NSDictionary+SafeObject.h"

@implementation XGMessage


- (NSString*) getMessgeJSONString
{
    NSDictionary *apnsDict = @{
                               @"aps"   : @{
                                                @"alert" : _alert
                                            },
                               @"F"     : _from,
                               @"T"     : _to,
                               @"C"     : _content,
                               @"FD"    : _fromDeviceToken,
                               @"TD"    : _toDeviceToken,
                               };
    
    return apnsDict.JSONRepresentation;
}

- (id) initWithJSON : (NSString*) _jSonString
{
    self = [super init];
    if (self)
    {
        NSDictionary *messageDict = _jSonString.JSONValue;
        
        _alert              = [messageDict stringWithKeyPath:@"aps\\alert"];
        _from               = [messageDict stringWithKeyPath:@"F"];
        _to                 = [messageDict stringWithKeyPath:@"T"];
        _content            = [messageDict stringWithKeyPath:@"C"];
        _toDeviceToken      = [messageDict stringWithKeyPath:@"TD"];
        _fromDeviceToken    = [messageDict stringWithKeyPath:@"FD"];
    }
    
    return self;
}

@end
