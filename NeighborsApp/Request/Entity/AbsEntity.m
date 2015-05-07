//
//  AbsEntity.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/3.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "AbsEntity.h"
#import <objc/runtime.h>

@implementation AbsEntity

- (id) initWithDict : (NSDictionary*) _entityDict
{
    self = [super init];
    
    if (self)
    {
        Ivar*           ivarList;
        unsigned int    ivarCount;
        
        ivarList = class_copyIvarList([self class], &ivarCount);
        
        for (int i = 0; i < ivarCount; i++)
        {
            Ivar subIvar = ivarList[i];
            
            NSString *ivarName = [[NSString stringWithUTF8String:ivar_getName(subIvar)] substringFromIndex:1];
            
            if (ivarName && [_entityDict.allKeys containsObject:ivarName])
            {
                object_setIvar(self, subIvar, _entityDict[ivarName]);
            }
        }
    }
    return self;
}

- (NSDictionary*) dictEntity
{
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    
    
    Ivar*           ivarList;
    unsigned int    ivarCount;
    
    ivarList = class_copyIvarList([self class], &ivarCount);
    
    for (int i = 0; i < ivarCount; i++)
    {
        Ivar subIvar = ivarList[i];
        
        NSString *ivarName = [[NSString stringWithUTF8String:ivar_getName(subIvar)] substringFromIndex:1];
        
        id objectIvar = object_getIvar(self, subIvar);
        
        if (objectIvar)
        {
            resultDict[ivarName] = object_getIvar(self, subIvar);
        }
    }
    
    return resultDict;
}

@end
