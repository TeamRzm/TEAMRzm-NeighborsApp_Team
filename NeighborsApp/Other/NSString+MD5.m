//
//  NSString+MD5.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/3.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NSString+MD5.h"
#import "NSString+base64.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString(MD5)

- (NSString*) encodeMD5PasswordStringWithCheckCode : (NSString*) _checkCode;
{
    NSString *encode1 = [self md5Str];
    
    encode1 = [encode1 stringByAppendingString:_checkCode];
    
    return [encode1 md5Str];
}

- (NSString*) encodeBase64PasswordStringWithVerift : (NSString*) _verift
{
    NSString *encode1 = [self stringByAppendingString:_verift];
    
    NSData *encodeData = [encode1 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *resultString = [NSString stringByEncodingData:encodeData];
    
    return resultString;
}


- (NSString *)md5Str
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

@end
