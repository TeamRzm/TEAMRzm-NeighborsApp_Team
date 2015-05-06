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

typedef void (^FileUploadHelperBlock)(FileUpLoadHelper *helper, int sum, int curIndex);
typedef void (^FileUploadHelperAllFinishedBlock)(FileUpLoadHelper *helper, int sum, int curIndex, NSArray *responseDict);

@interface FileUpLoadHelper : CreaterRequest_Base

//每一个文件上传成功时调用
@property (nonatomic, assign) FileUploadHelperBlock everUploadedBlock;

//全部上传成功时候调用
@property (nonatomic, assign) FileUploadHelperAllFinishedBlock allUploadedBlock;

//出现错误
@property (nonatomic, assign) FileUploadHelperBlock faildBlock;


- (void) setAllUploadedBlock:(FileUploadHelperAllFinishedBlock)allUploadedBlock;
- (void) setEverUploadedBlock:(FileUploadHelperBlock)everUploadedBlock;
- (void) setFaildBlock:(FileUploadHelperBlock)faildBlock;

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