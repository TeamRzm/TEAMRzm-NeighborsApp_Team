//
//  NSString+MD5.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/3.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(MD5)

- (NSString*)md5Str;

- (NSString*) encodeMD5PasswordStringWithCheckCode : (NSString*) _checkCode;

- (NSString*) encodeBase64PasswordStringWithVerift : (NSString*) _verift;

@end
