//
//  XGSign.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/17.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "XGSign.h"

@implementation XGSign

+ (NSString*) XGSignWithMehod : (NSString*) _pushOrGet
                      hostURL : (NSString*) _hostURLString
                        parms : (NSDictionary*) _parms
                    timestamp : (NSString*) _timestamp
                    secretKey : (NSString*) _secretKey
{
    _hostURLString = [_hostURLString stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    
    NSMutableString *signResult = [[NSMutableString alloc] init];
    
    [signResult appendString:_pushOrGet];
    [signResult appendString:_hostURLString];

    NSArray *sortKeyArr = [_parms.allKeys sortedArrayUsingSelector:@selector(compare:)];
    
    for (NSString *subKey in sortKeyArr)
    {
        [signResult appendFormat:@"%@=%@",subKey,_parms[subKey]];
    }
    
    [signResult appendFormat:@"timestamp=%@%@",_timestamp,_secretKey];
    
    NSString *resultMD5Str = [signResult md5Str];
    
    return resultMD5Str;
}

@end
