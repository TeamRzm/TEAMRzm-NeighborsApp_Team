//
//  NSDictionary+SafeObject.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/7.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SafeNSDictionary : NSDictionary

- (id) objectForKey:(id)aKey;
- (id) valueForKey:(NSString *)key;

@end
