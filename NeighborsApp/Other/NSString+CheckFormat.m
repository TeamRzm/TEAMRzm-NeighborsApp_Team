//
//  NSString+CheckFormat.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/2.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NSString+CheckFormat.h"

@implementation NSString(CheckFormat)

- (BOOL) isZeroLenth
{
    if (self.length > 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
