//
//  FileUpLoadHelper.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/6.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreaterRequest_Base.h"

@class FileUpLoadHelper;

@protocol FileUpLoadHelperDelegate <NSObject>

//单个图片下载完成
- (void) fileUpLoadHelper : (FileUpLoadHelper*) _helper downloadedIndex : (NSInteger) _index downloadTotal : (NSInteger) _total;

- (void) fileUpLoadHelper : (FileUpLoadHelper*) _helper allDownloadedResponseDictArr : (NSArray*) _dictArr;

- (void) fileUpLoadHelper : (FileUpLoadHelper*) _helper downloadedFialdWithIndex : (NSInteger) _index;

@end

@interface FileUpLoadHelper : CreaterRequest_Base

@property (nonatomic, assign) id<FileUpLoadHelperDelegate> delegate;

- (void) addUploadImage : (UIImage*) _image;

- (void) startUpload;

- (void) stopUpload;

@end




/* DEMO
 UIImage *uploadimg = [UIImage imageNamed:@"t_avter_0"];
 
 FileUpLoadHelper *upload = [[FileUpLoadHelper alloc] init];
 [upload setAllUploadedBlock:^(FileUpLoadHelper *helper, int sum, int curIndex, NSArray *responseDict) {
 NSLog(@"%@",responseDict);
 }];
 [upload addUploadImage:uploadimg];
 
 [upload startUpload];
 */