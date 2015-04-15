//
//  aya_MultimediaKeyBoard.h
//  BBG
//
//  Created by Martin.Ren on 13-7-16.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "C_AmrControllerHelper.h"

typedef enum
{
    KEYBOARD_STATUS_NONE,
    KEYBOARD_STATUS_AUDIO,
    KEYBOARD_STATUS_TEXT,
    KEYBOARD_STATUS_FACE,
    KEYBOARD_STATUS_OTHER,
}KEYBOARD_STATUS;

@class aya_MultimediaKeyBoard;

@protocol  aya_MultimediaKeyBoardDelegate <NSObject>

- (void) ayaKeyBoard:(aya_MultimediaKeyBoard*) _keyboard willChangedKeyBoardStatus : (KEYBOARD_STATUS) _status currKeyboardHeight : (CGFloat) _height;

- (void) ayaKeyBoard:(aya_MultimediaKeyBoard*) _keyboard willFinishInputMsg : (NSString*) _string;

- (void) ayaKeyBoard:(aya_MultimediaKeyBoard*) _keyboard willSelectOtherBoardIndex : (NSInteger) _index;

- (void) ayaKeyBoard:(aya_MultimediaKeyBoard*) _keyboard willFinishInputAmrData : (NSData*) _amrStrame timeLen : (NSTimeInterval) _timeLen;

@optional
- (void) ayaKeyBoard:(aya_MultimediaKeyBoard*) _keyboard quikLookImg : (UIImage*) _limg;

@end

@interface aya_MultimediaKeyBoard : UIView<UITextViewDelegate, C_AmrControllerHelperDelegate,UIActionSheetDelegate>
{
    CGRect              currKeyboardFrame;
    CGRect              currSysKeyboarFrame;
    CGRect              lastSelfFrame;
    
    KEYBOARD_STATUS     currStatus;
    
    NSDictionary        *faceResDict;
    
    BOOL                isSuccessAmrRecoded;
    
    NSTimer             *powerSetTimer;
    
    UILabel             *_RecodeTimeLabel;
    
    NSTimer             *timerRecode;
    
    NSInteger           timenum;
    UIScrollView       *faceScroll;
    UIPageControl      *facepagecontrol;
    NSMutableArray     *curfacekeyall;
    
    UILabel            *placeholderlabel;
    
    UIImage            *commentImgDate;
    
    BOOL               isCommentKeyboardType;
}

@property (nonatomic, assign) BOOL isCommentKeyboardType;
@property (nonatomic, strong) UIImage            *commentImgDate;
@property (nonatomic, assign) KEYBOARD_STATUS                    currStatus;
@property (nonatomic, assign) id<aya_MultimediaKeyBoardDelegate> delegate;

@property (nonatomic, strong) UITextView *inputTextView;
@property (nonatomic, copy)   NSString *placeholderstr;


- (void) changeKeyBoardStatus : (KEYBOARD_STATUS) _keyBoardStatus;

- (void) hidekeyboardview;

- (id) initWithKeyBoardTypeIsComment : (BOOL) _comment;

@end
