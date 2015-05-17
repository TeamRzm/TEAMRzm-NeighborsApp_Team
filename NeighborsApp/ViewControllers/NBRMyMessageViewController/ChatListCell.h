//
//  ChatListCell.h
//  BBG
//
//  Created by user on 13-7-9.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "MessageEntity.h"
#import "aya_coreTextView.h"


#define REGEX_IMGSTRING @"\\[img\\]{1}([^\\[\\]])*\\[/img\\]"

#define REGEX_VOICESTRING @"\\[voice\\]{1}([^\\[\\]])*\\[/voice\\]"

#define REGEX_FACESTRING @"\\[em\\]{1}([^\\[\\]])*\\[/em\\]"

#define REGEX_URLSTRING @"\\[url\\]{1}([^\\[\\]])*\\[/url\\]"
@class ChatListCell;
@protocol ChatListCellDelegate <NSObject>

-(void) ChatListCellPlayVoiceWithCell:(ChatListCell *) _cell WithModel:(id) _model;
-(void) ChatListCellClickImageWithCell:(ChatListCell *) _cell WithModel:(id) _model;
-(void) ChatListCellReSendMesssageWithCell:(ChatListCell *) _cell WithMode:(id) _model;
-(void) ChatListCellGoToZoneWithCell:(ChatListCell *) _cell WithMode:(id) _model;
-(void) ChatListCellGoToWebViewWithCell:(ChatListCell *) _cell WithMode:(id) _model WithUrl:(NSString *) _url;
@end

@interface ChatListCell : UITableViewCell<aya_coreTextViewDelegate>
{
    EGOImageView *iconimage;//头像
    UILabel      *userlabel;
    UIImageView  *bgimageview;
    UILabel      *contentlb;
    UILabel      *timelb;
    float        cellheight;
    MessageEntity *MsgModule;
    MessageEntity      *LeftMsgModule;
    aya_coreTextView  *textlb;
    EGOImageView  *sendimgview;
    UIButton      *vodiobg;
    UIView       *textView;
    UILabel      *voicelb;
    UIActivityIndicatorView *loadingview;
    __unsafe_unretained id<ChatListCellDelegate> delegate;
    UIButton     *resendchatbt;
    
}

@property (nonatomic, strong) UIActivityIndicatorView *loadingview;
@property (nonatomic, assign) float        cellheight;

//发送方cell生成
-(id)initRightCellUnitWithModel:(id)_module className:(NSString *)_className Withdelegate:(id<ChatListCellDelegate>) _delegate;

-(id)initCellUnitWithModel:(id)_module className:(NSString *)_className Withdelegate:(id<ChatListCellDelegate>) _delegate;



//发送方cell 赋值
-(void)configRightCellUnitWithModel:(id)_module className:(NSString *)_className;
//接受方cell赋值
-(void)configCellUnitWithModel:(id)_module className:(NSString *)_className;


-(float) ReturnCellHeight;
@end
