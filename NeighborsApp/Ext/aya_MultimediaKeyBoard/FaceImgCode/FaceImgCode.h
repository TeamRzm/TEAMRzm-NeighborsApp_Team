//
//  FaceImgCode.h
//  BBG
//
//  Created by Martin.Ren on 13-4-12.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaceImgCode : NSObject
{
    NSMutableDictionary     *faceImgCodePlist;
}

+ (FaceImgCode*) Instance;

- (NSString*) FaceCodeToFileName : (NSString*) _faceCode;

- (NSString*) FileNameToFaceCode : (NSString*) _fileName;

@end
