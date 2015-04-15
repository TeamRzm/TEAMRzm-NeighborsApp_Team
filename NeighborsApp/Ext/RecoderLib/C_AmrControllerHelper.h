//
//  C_AmrControllerHelper.h
//  ZS_IMSystem
//
//  Created by Martin.Ren on 13-3-18.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "Recorder.h"

@protocol C_AmrControllerHelperDelegate <NSObject>

- (void) amrControllerHelperDidEndRecoderAudioWithLength:(NSTimeInterval)length;

@optional
- (void) willAmrPlayFinish;

@end

@interface C_AmrControllerHelper : NSObject<RecoderDelegate,AVAudioPlayerDelegate>
{
    Recorder        *_recorder;
    AVAudioPlayer   *_player;
    
    __unsafe_unretained id<C_AmrControllerHelperDelegate> delegate;
    

}

@property (nonatomic, assign) id<C_AmrControllerHelperDelegate> delegate;

+ (C_AmrControllerHelper*) ShareAmrControllerHelper;

//开始录制Amr
- (BOOL) BeginRecoderAudio;

//停止录制Amr
- (BOOL) EndRecoderAudio;

//是否正在录制
- (BOOL) IsRecodering;

//当前mic的音高
- (CGFloat) CurrPowerPorgess;

//获取最后一次录音得到的文件位置
- (NSString*) RecoderFilePath;

//使用本地文件路径播放一个Amr文件
- (BOOL) PlayAmrAudioWithFilePath : (NSString*) _amrFilePath;

//使用内存中的Amr文件数据播放
- (BOOL) PlayAmrAudioWithData : (NSData*) _amrFileData;

//直接播放一个Amr的Url
- (BOOL) PlayAmrAudioWithUrl : (NSURL*) _amrFileUrl;

- (void) StopAmrAudio;

@end
