//
//  NSString+MoneyFormat.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/6/1.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NSString+MoneyFormat.h"

@implementation NSString(MoneyFormat)

- (NSString*) priceString
{
    CGFloat priceFloat = self.floatValue;
    
    NSString *priceString = [NSString stringWithFormat:@"%.2f", priceFloat];
    
    NSMutableString *copyString = [[NSMutableString alloc] initWithString:[priceString componentsSeparatedByString:@"."][0]];
    
    for (int i = copyString.length, j = 0; i > 3; i -= 3, j++)
    {
        [copyString insertString:@"," atIndex:copyString.length - ((j + 1) * 3 + j)];
    }
    
    [copyString appendFormat:@".%@", [priceString componentsSeparatedByString:@"."][1]];
    
    return copyString;
}

@end
