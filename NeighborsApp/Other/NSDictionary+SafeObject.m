//
//  NSDictionary+SafeObject.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/7.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NSDictionary+SafeObject.h"

@implementation NSDictionary(SafePath)

- (NSDictionary*) dictWithKeyPath : (NSString*) _keyPath
{
    NSArray *subKeys = [_keyPath componentsSeparatedByString:@"\\"];
    
    id currDict = self;
    
    for (NSString *subKey in subKeys)
    {
        if ([((NSDictionary*)currDict).allKeys containsObject:subKey])
        {
            currDict = currDict[subKey];
        }
        else
        {
            return @{};
        }
    }
    
    return currDict;
}

- (NSString*) stringWithKeyPath : (NSString*) _keyPath
{
    NSArray *subKeys = [_keyPath componentsSeparatedByString:@"\\"];
    
    id currDict = self;
    
    for (NSString *subKey in subKeys)
    {
        if ([((NSDictionary*)currDict).allKeys containsObject:subKey])
        {
            currDict = currDict[subKey];
        }
        else
        {
            return @"";
        }
    }
    
    return currDict;
}

- (NSArray*) arrayWithKeyPath : (NSString*) _keyPath
{
    NSArray *subKeys = [_keyPath componentsSeparatedByString:@"\\"];
    
    id currDict = self;
    
    for (NSString *subKey in subKeys)
    {
        if ([((NSDictionary*)currDict).allKeys containsObject:subKey])
        {
            currDict = currDict[subKey];
        }
        else
        {
            return 0;
        }
    }
    
    return currDict;
}

- (NSInteger) numberWithKeyPath : (NSString*) _keyPath
{
    NSArray *subKeys = [_keyPath componentsSeparatedByString:@"\\"];
    
    id currDict = self;
    
    for (NSString *subKey in subKeys)
    {
        if ([((NSDictionary*)currDict).allKeys containsObject:subKey])
        {
            currDict = currDict[subKey];
        }
        else
        {
            return 0;
        }
    }
    
    return ((NSNumber*)currDict).integerValue;
}

@end
