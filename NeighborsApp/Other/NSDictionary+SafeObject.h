//
//  NSDictionary+SafeObject.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/7.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(SafePath)

- (NSDictionary*) dictWithKeyPath : (NSString*) _keyPath;

- (NSString*) stringWithKeyPath : (NSString*) _keyPath;

- (NSInteger) numberWithKeyPath : (NSString*) _keyPath;

- (NSArray*) arrayWithKeyPath : (NSString*) _keyPath;

@end
