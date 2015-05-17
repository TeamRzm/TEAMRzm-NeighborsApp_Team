//
//  XGSign.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/17.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XGSign : NSObject

+ (NSString*) XGSignWithMehod : (NSString*) _pushOrGet
                      hostURL : (NSString*) _hostURLString
                        parms : (NSDictionary*) _parms
                    timestamp : (NSString*) _timestamp
                    secretKey : (NSString*) _secretKey;

@end
