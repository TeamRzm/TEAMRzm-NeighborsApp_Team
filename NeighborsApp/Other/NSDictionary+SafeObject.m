//
//  NSDictionary+SafeObject.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/7.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NSDictionary+SafeObject.h"

@implementation SafeNSDictionary

- (id) objectForKey:(id)aKey
{
    if ([self.allKeys containsObject:aKey])
    {
        return self[aKey];
    }
    else
    {
        return NULL;
    }
}

- (id) valueForKey:(NSString *)key
{
    if ([self.allKeys containsObject:key])
    {
        return self[key];
    }
    else
    {
        return NULL;
    }
}

@end
