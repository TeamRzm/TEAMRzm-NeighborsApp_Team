/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioQueue.h>
#import <AudioToolbox/AudioFile.h>
#import <AudioToolbox/AudioConverter.h>

@class Recorder;

@protocol RecoderDelegate <NSObject>

- (void) recoderDidStopRecodeingWithAudioLength : (NSTimeInterval) length;

@end

#define NUM_BUFFERS 3
//#define kAudioConverterPropertyMaximumOutputPacketSize		'xops'
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

typedef struct
	{
		AudioFileID                 audioFile;
		AudioStreamBasicDescription dataFormat;
		AudioQueueRef               queue;
		AudioQueueBufferRef         buffers[NUM_BUFFERS];
		UInt32                      bufferByteSize; 
		SInt64                      currentPacket;
		BOOL                        recording;
	} RecordState;

@interface Recorder : NSObject {
	RecordState recordState;
    __unsafe_unretained id<RecoderDelegate>         delegate;
    NSDate      *recordStartTime;
}

@property (nonatomic, assign) id<RecoderDelegate> delegate;

- (BOOL)	isRecording;
- (float)	averagePower;
- (float)	peakPower;
- (float)	currentTime;
- (BOOL)    readyForStartRecodring : (NSString*) filePath;
- (BOOL)	startRecording: (NSString *) filePath;
- (void)	stopRecording;
- (void)	pause;
- (BOOL)	resume;
@end
