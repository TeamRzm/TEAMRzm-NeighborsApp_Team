//
//  C_AmrControllerHelper.m
//  ZS_IMSystem
//
//  Created by Martin.Ren on 13-3-18.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import "C_AmrControllerHelper.h"
#import "TranscodingDefine.h"


//对于使用者来说这个三个文件路径应该是完全不可见的,这里的三个文件用于在做格式转换。而在使用过程中全部以NSData 交换数据
#define CACHE_RECORDERFILES_CAF [NSHomeDirectory() stringByAppendingPathComponent: @"Documents/_cache__temp_recording.caf"]
#define CACHE_RECORDERFILES_AMR [NSHomeDirectory() stringByAppendingPathComponent: @"Documents/_cache__temp_recording.amr"]
#define CACHE_RECORDERFILES_WAV [NSHomeDirectory() stringByAppendingPathComponent: @"Documents/_cache__temp_recording.wav"]

#define CACHE_PLAYERFILES_AMR   [NSHomeDirectory() stringByAppendingPathComponent: @"Documents/_cache__temp_playering.amr"]

@implementation C_AmrControllerHelper

@synthesize delegate;

+ (C_AmrControllerHelper*) ShareAmrControllerHelper
{
    static C_AmrControllerHelper *instance;
    @synchronized(self)
    {
        if (!instance)
        {
            instance = [[C_AmrControllerHelper alloc] init];
        }
    }
    return instance;
}

- (id) init
{
    self = [super init];
    
    if (self)
    {
        _recorder = [[Recorder alloc] init];
        [_recorder setDelegate:self];
    }
    
    return self;
}

- (CGFloat) CurrPowerPorgess
{
    if ([_recorder isRecording])
    {
        return [_recorder averagePower];
    }
    else
    {
        return 0.0f;
    }
}

- (BOOL) IsRecodering
{
    return [_recorder isRecording];
}

- (BOOL) BeginRecoderAudio
{
   
    [self StopAmrAudio];
    if ([_recorder isRecording])
    {
        [_recorder stopRecording];
    }
    return [_recorder startRecording:CACHE_RECORDERFILES_CAF];
}

- (BOOL) EndRecoderAudio
{
    [_recorder stopRecording];
    return YES;
}

- (void) recoderDidStopRecodeingWithAudioLength:(NSTimeInterval)length
{
    TranscodingCafToAmr([CACHE_RECORDERFILES_CAF UTF8String], [CACHE_RECORDERFILES_AMR UTF8String]);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(amrControllerHelperDidEndRecoderAudioWithLength:)])
    {
        [self.delegate amrControllerHelperDidEndRecoderAudioWithLength:length];
    }
    return ;
}

- (void) StopAmrAudio
{
    if ([_player isPlaying])
    {
        [_player stop];
    }
    return ;
}

- (NSString*) RecoderFilePath
{
    return CACHE_RECORDERFILES_AMR;
}

- (BOOL) PlayAmrAudioWithFilePath : (NSString*) _amrFilePath
{
    //播放AMR之前需要讲AMR文件转换到WAV格式在进行播放
    TranscodingAmrToWav([_amrFilePath UTF8String], [CACHE_RECORDERFILES_WAV UTF8String]);
    
    NSError *err;
    
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:CACHE_RECORDERFILES_WAV] error:&err];
    
    [_player setDelegate:self];
    
    if (_player==nil)
    {
        NSLog(@"%@", [err description]);
    }
    _player.volume=1.0;
    
    [_player prepareToPlay];
    [_player play];
    
    return YES;
}

- (BOOL) PlayAmrAudioWithData : (NSData*) _amrFileData
{
    [_amrFileData writeToFile:CACHE_PLAYERFILES_AMR atomically:YES];
    
    return [self PlayAmrAudioWithFilePath:CACHE_PLAYERFILES_AMR];
}

- (BOOL) PlayAmrAudioWithUrl : (NSURL*) _amrFileUrl
{
    NSData *amrData = [NSData dataWithContentsOfURL:_amrFileUrl];
    
    return [self PlayAmrAudioWithData:amrData];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(willAmrPlayFinish)])
    {
        [self.delegate willAmrPlayFinish];
    }
    
    return ;
}

@end
