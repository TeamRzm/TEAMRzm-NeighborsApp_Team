//
//  FaceImgCode.m
//  BBG
//
//  Created by Martin.Ren on 13-4-12.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import "FaceImgCode.h"

@implementation FaceImgCode

+ (FaceImgCode*) Instance
{
    static FaceImgCode *instance;
    @synchronized(self)
    {
        if (!instance)
        {
            instance = [[FaceImgCode alloc] init];
        }
    }
    
    return instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        NSString *defaultPath = [[NSBundle mainBundle] pathForResource:@"FaceImgCode" ofType:@"plist"];
        faceImgCodePlist = [[NSMutableDictionary alloc] initWithContentsOfFile:defaultPath];
    }
    return self;
}

- (NSString*) FaceCodeToFileName : (NSString*) _faceCode
{
    NSArray *allkeys = [faceImgCodePlist allKeys];
    
    for (NSString *subkey in allkeys)
    {
        NSString *value = [faceImgCodePlist valueForKey:subkey];
        
        if ([value isEqualToString:_faceCode])
        {
            return subkey;
        }
    }
    
    return @"";
}

- (NSString*) FileNameToFaceCode : (NSString*) _fileName
{
    return [faceImgCodePlist valueForKey:_fileName];
}

@end
