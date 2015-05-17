//
//  ChatListCell.m
//  BBG
//
//  Created by user on 13-7-9.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import "ChatListCell.h"

@implementation ChatListCell
@synthesize loadingview;
@synthesize cellheight;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
//接收方cell生成
-(id)initCellUnitWithModel:(id)_module className:(NSString *)_className Withdelegate:(id<ChatListCellDelegate>) _delegate
{
    self  = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_className];
    if (self)
    {
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        delegate = _delegate;
        timelb = [[UILabel alloc] initWithFrame:CGRectMake(100, 5.0f, 120, 30.0f)];
        [timelb setBackgroundColor:[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]];
        [timelb setFont:[UIFont systemFontOfSize:10.0f]];
        [timelb setTextColor:[UIColor whiteColor]];
        [timelb.layer setCornerRadius:4.0];
        [timelb.layer setMasksToBounds:YES];
        
        [self addSubview:timelb];
        
        iconimage = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"t_avter_2"] delegate:nil];
        [iconimage setFrame:CGRectMake(10.0f, 30.0f, 45.0f, 45.0f)];
        [iconimage setContentMode:UIViewContentModeScaleAspectFit];
        [iconimage setBackgroundColor:kNBR_ProjectColor_StandWhite];
        iconimage.layer.cornerRadius = 4.0;
        [iconimage.layer setMasksToBounds:YES];
        [iconimage setImageURL:[NSURL URLWithString:@"t_avter_2"]];
        iconimage.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GoToZone:)];
        [iconimage addGestureRecognizer:tap];
        
        [self addSubview:iconimage];
        
        loadingview = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingview setFrame:CGRectMake(iconimage.frame.origin.x+(iconimage.frame.size.height/2.0-10.0f), iconimage.frame.origin.y + iconimage.frame.size.height+5.0f, 20.0, 20.0)];
        [loadingview startAnimating];
        [self addSubview:loadingview];
        
        userlabel = [[UILabel alloc] initWithFrame:CGRectMake(iconimage.frame.origin.x+iconimage.frame.size.width, iconimage.frame.origin.y, 200.0f, 0.0f)];
        [userlabel setBackgroundColor:[UIColor clearColor]];
        [userlabel setFont:[UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f]];
        [userlabel setTextColor:kNBR_ProjectColor_DeepBlack];
        [userlabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:userlabel];
        
        
        
        resendchatbt = [[UIButton alloc] initWithFrame:CGRectMake(iconimage.frame.origin.x+(iconimage.frame.size.height/2.0-10.0f), iconimage.frame.origin.y + iconimage.frame.size.height+5.0f, 20.0, 20.0)];
        [resendchatbt setBackgroundColor:[UIColor clearColor]];
        [resendchatbt setBackgroundImage:[UIImage imageNamed:@"Chat_ReSendMessage_bg"] forState:UIControlStateNormal];
        [resendchatbt addTarget:self action:@selector(ReSendMessage) forControlEvents:UIControlEventTouchUpInside];
        [resendchatbt setAlpha:0.0];
        
        [self addSubview:resendchatbt];
        
        
        bgimageview  = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"leftMessageBox"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 20, 10, 10)]];
        [self addSubview:bgimageview];
        [bgimageview setUserInteractionEnabled:YES];
        
        textView = [[UIView alloc] initWithFrame:CGRectMake(20.0f, 10.0f, 200, 40.0f)];
        [textView setBackgroundColor:[UIColor clearColor]];
        [bgimageview addSubview:textView];
        
        sendimgview = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"t_avter_4"] delegate:nil];
        [sendimgview setFrame:CGRectMake(20.0f, 10.0f, 100.0, 0.0f)];
         [sendimgview setContentMode:UIViewContentModeScaleAspectFit];
        [sendimgview setUserInteractionEnabled:YES];
        UITapGestureRecognizer *imgtag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GoToImage:)];
        [sendimgview addGestureRecognizer:imgtag];
        
        [self addSubview:sendimgview];
        
        vodiobg = [[UIButton alloc] initWithFrame:CGRectMake(20.0f, 10.0f, 40, 40.0*66.0/54.0)];
        [vodiobg setBackgroundColor:[UIColor clearColor]];
        [vodiobg setImage:[UIImage imageNamed:@"chatfrom_voice_playing"] forState:UIControlStateNormal];
        [vodiobg addTarget:self action:@selector(PlayVoice) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:vodiobg];
        
        voicelb  = [[UILabel alloc] initWithFrame:CGRectMake(iconimage.frame.origin.x+iconimage.frame.size.width+60.0f, 10.0f, 54.0f, 0.0f)];
        [voicelb setBackgroundColor:[UIColor clearColor]];
        [voicelb setFont:[UIFont systemFontOfSize:12.0f]];
        [voicelb setTextColor:kNBR_ProjectColor_DeepBlack];
        [voicelb setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:voicelb];

        
    }
   
    return self;
    
    
}


//发送方cell生成
-(id)initRightCellUnitWithModel:(id)_module className:(NSString *)_className Withdelegate:(id<ChatListCellDelegate>) _delegate
{
    self  = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_className];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        delegate = _delegate;
        timelb = [[UILabel alloc] initWithFrame:CGRectMake(100, 5.0f, 120, 30.0f)];
        [timelb setBackgroundColor:[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]];
        [timelb setFont:[UIFont systemFontOfSize:10.0f]];
        [timelb setTextColor:[UIColor whiteColor]];
        [timelb.layer setCornerRadius:4.0];
        [timelb.layer setMasksToBounds:YES];
        
        [self addSubview:timelb];
        
        
        iconimage = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"t_avter_1"] delegate:nil];
        [iconimage setFrame:CGRectMake(kNBR_SCREEN_W-45.0-10.0f, 30.0f, 45.0f, 45.0f)];
        [iconimage setContentMode:UIViewContentModeScaleAspectFit];
        [iconimage setBackgroundColor:kNBR_ProjectColor_LightGray];
        iconimage.layer.cornerRadius = 4.0;
        [iconimage.layer setMasksToBounds:YES];
        iconimage.userInteractionEnabled = YES;
        [iconimage setImageURL:[NSURL URLWithString:@"t_avter_1"]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GoToZone:)];
        [iconimage addGestureRecognizer:tap];
        [self addSubview:iconimage];
        
        loadingview = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingview setFrame:CGRectMake(iconimage.frame.origin.x+(iconimage.frame.size.height/2.0-10), iconimage.frame.origin.y + iconimage.frame.size.height+5.0, 20.0, 20.0)];
        [loadingview startAnimating];
        
        [self addSubview:loadingview];
        
        userlabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, iconimage.frame.origin.y, iconimage.frame.origin.x-20.0f, 0.0f)];
        [userlabel setBackgroundColor:[UIColor clearColor]];
        [userlabel setFont:[UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f]];
        [userlabel setTextColor:kNBR_ProjectColor_DeepBlack];
        [userlabel setTextAlignment:NSTextAlignmentRight];
        [self addSubview:userlabel];

        
        
        resendchatbt = [[UIButton alloc] initWithFrame:CGRectMake(iconimage.frame.origin.x+(iconimage.frame.size.height/2.0-10), iconimage.frame.origin.y + iconimage.frame.size.height+5.0, 20.0, 20.0)];
        [resendchatbt setBackgroundColor:[UIColor clearColor]];
        [resendchatbt setAlpha:0.0];
        [resendchatbt setBackgroundImage:[UIImage imageNamed:@"Chat_ReSendMessage_bg"] forState:UIControlStateNormal];
        [resendchatbt addTarget:self action:@selector(ReSendMessage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:resendchatbt];
        
        
        bgimageview = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"rightMessageBox"] resizableImageWithCapInsets:UIEdgeInsetsMake(14.0f, 3.5f, 15.0f, 17)]];
        [bgimageview setUserInteractionEnabled:YES];

        
        [self addSubview:bgimageview];
        
        textView = [[UIView alloc] initWithFrame:CGRectMake(20.0f, 10.0f, 200, 40.0f)];
        [textView setBackgroundColor:[UIColor clearColor]];
        [bgimageview addSubview:textView];
        
        
        sendimgview = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@""] delegate:nil];
        [sendimgview setFrame:CGRectMake(20.0f, 10.0f, 100.0f, 0.0f)];
        [sendimgview setContentMode:UIViewContentModeScaleAspectFit];
        [sendimgview setUserInteractionEnabled:YES];
        UITapGestureRecognizer *imgtag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GoToImage:)];
        [sendimgview addGestureRecognizer:imgtag];
        
        [self addSubview:sendimgview];
        
        vodiobg = [[UIButton alloc] initWithFrame:CGRectMake(20.0f, 10.0f, 40.0, 40.0*66/54.0)];
        [vodiobg setBackgroundColor:[UIColor clearColor]];
        [vodiobg setImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
        [vodiobg addTarget:self action:@selector(PlayVoice) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:vodiobg];
        
        voicelb  = [[UILabel alloc] initWithFrame:CGRectMake(iconimage.frame.origin.x-60.0f, 60.0f, 54.0f, 0.0f)];
        [voicelb setBackgroundColor:[UIColor clearColor]];
        [voicelb setFont:[UIFont systemFontOfSize:12.0f]];
        [voicelb setTextColor:kNBR_ProjectColor_DeepBlack];
        [voicelb setTextAlignment:NSTextAlignmentRight];
        [self addSubview:voicelb];
        
    }
    return self;
}


//接收方cell 赋值

-(void)configCellUnitWithModel:(id)_module className:(NSString *)_className
{
    MsgModule = _module;
    if ([[MsgModule.M_Status lowercaseString] isEqualToString:@"sending"])
    {
        [loadingview startAnimating];
        [resendchatbt setAlpha:0.0];
    }
    else if ([[MsgModule.M_Status lowercaseString] isEqualToString:@"failed"])
    {
        [loadingview stopAnimating];
        [resendchatbt setAlpha:1.0];
    }
    else
    {
        [resendchatbt setAlpha:0.0];
        [loadingview stopAnimating];
    }
    
    [userlabel setText:MsgModule.M_From];
    
    NSDateFormatter *ft = [[NSDateFormatter alloc] init];
    [ft setDateFormat:@"MM-dd HH:mm:ss"];
    [timelb setText:[NSString stringWithFormat:@" %@ ",[ft stringFromDate:MsgModule.M_LastUpdateTime]]];
    [timelb sizeToFit];
    [timelb setFrame:CGRectMake(kNBR_SCREEN_W/2.0- timelb.frame.size.width/2.0f, timelb.frame.origin.y, timelb.frame.size.width, timelb.frame.size.height)];
    
    if (textlb)
    {
        [textlb removeFromSuperview];
    }
    if ([self GetImageUrl:MsgModule.M_Msg])
    {
        [textView setAlpha:0.0f];
        [vodiobg setAlpha:0.0];
        [sendimgview setAlpha:1.0];
        [voicelb setAlpha:0.0];
        [sendimgview setFrame:CGRectMake(sendimgview.frame.origin.x, sendimgview.frame.origin.y, sendimgview.frame.size.width, 100.0f)];
        [sendimgview setImageURL:[NSURL URLWithString:[self GetImageUrl:MsgModule.M_Msg]]];
        [sendimgview setPlaceholderImage:[UIImage imageNamed:[self GetImageUrl:MsgModule.M_Msg]]];
        
        [bgimageview setFrame:CGRectMake(iconimage.frame.origin.x+iconimage.frame.size.width+10.0f, userlabel.frame.origin.y+userlabel.frame.size.height, sendimgview.frame.size.width+30.0f, sendimgview.frame.size.height + 20.0f)];
         [sendimgview setFrame:CGRectMake(bgimageview.frame.origin.x+17.0f, bgimageview.frame.origin.y+10.0, sendimgview.frame.size.width, sendimgview.frame.size.height)];
        
    }
    else if ([self GetVidioUrl:MsgModule.M_Msg])
    {
        [textView setAlpha:0.0f];
        [sendimgview setAlpha:0.0];
        [vodiobg setAlpha:1.0];
        [voicelb setAlpha:1.0];
        [vodiobg setFrame:CGRectMake(vodiobg.frame.origin.x, vodiobg.frame.origin.y, vodiobg.frame.size.width, vodiobg.frame.size.height)];
        if (MsgModule.M_Msg.length > 0)
        {
            NSArray *tem = [[self GetVidioUrl:MsgModule.M_Msg] componentsSeparatedByString:@","];
            if ([tem count]>=2)
            {
                [voicelb setText:[NSString stringWithFormat:@"%@\"",[tem objectAtIndex:1]]];
            }
        }
        [voicelb setFrame:CGRectMake(voicelb.frame.origin.x, voicelb.frame.origin.y, voicelb.frame.size.width, 25.0)];
        
        [bgimageview setFrame:CGRectMake(iconimage.frame.origin.x+iconimage.frame.size.width+10.0f, userlabel.frame.origin.y+userlabel.frame.size.height, vodiobg.frame.size.width+60.0f, vodiobg.frame.size.height-10)];
        
        [vodiobg setFrame:CGRectMake(bgimageview.frame.origin.x+30.0f, bgimageview.frame.origin.y-5.0, vodiobg.frame.size.width, vodiobg.frame.size.height)];
        
        [voicelb setFrame:CGRectMake(bgimageview.frame.origin.x+bgimageview.frame.size.width+10.0f, bgimageview.frame.origin.y+bgimageview.frame.size.height/2.0 - voicelb.frame.size.height/2.0f, voicelb.frame.size.width, 25.0)];
        
        
    }
    
    else
    {
        [sendimgview setAlpha:0.0];
        [vodiobg setAlpha:0.0];
        [textView setAlpha:1.0];
        [voicelb setAlpha:0.0];
        CGSize defaultSize = CGSizeMake(200, 22);
        
        NSString *chatMsg = nil;
        
        if (MsgModule.M_Msg.length == 0)
        {
            MsgModule.M_Msg = @" ";
        }
        if (MsgModule.M_Msg  || MsgModule.M_Msg.length > 0)
        {
            CGSize labelSize = CGSizeZero;
            if ([MsgModule.M_Msg isKindOfClass:[NSString class]])
            {
                NSArray *arr = [self GetTextFacecount:MsgModule.M_Msg];
                NSString *str =[NSString stringWithFormat:@" %@ ",MsgModule.M_Msg] ;
                for (NSString *tem in arr)
                {
                    str = [str stringByReplacingOccurrencesOfString:tem withString:@""];
                }
                str = [str stringByReplacingOccurrencesOfString:@"[url]" withString:@""];
                str = [str stringByReplacingOccurrencesOfString:@"[/url]" withString:@""];
                chatMsg = str;
                
                UIFont *font = [UIFont fontWithName:@"Helvetica" size:15];
                labelSize = [str sizeWithFont:font constrainedToSize:CGSizeMake(200.0f, 2048.0f) lineBreakMode:NSLineBreakByCharWrapping];
                defaultSize.width = labelSize.width +24.0*[arr count]>200?200:labelSize.width +24.0*[arr count];
                defaultSize.height = labelSize.height;
            }
            if ([self isHasUrl:MsgModule.M_Msg])
            {
                [bgimageview setUserInteractionEnabled:YES];
            }
            else
            {
                [bgimageview setUserInteractionEnabled:NO];
            }
        }
        
        textlb = [[aya_coreTextView alloc] initWithMarkUpString:MsgModule.M_Msg width:defaultSize.width x:0.0f y:0.0f];
        [textlb setDelegate:self];
        [textView setFrame:CGRectMake(10.0, 7.0f, defaultSize.width, textlb.frame.size.height)];
        [textView setBackgroundColor:[UIColor clearColor]];
        [textView addSubview:textlb];
        [bgimageview setFrame:CGRectMake(iconimage.frame.origin.x+iconimage.frame.size.width+10.0f, userlabel.frame.origin.y+userlabel.frame.size.height, textlb.frame.size.width+30.0f, textlb.frame.size.height + 20.0)];
        [textView setFrame:CGRectMake(bgimageview.frame.size.width/2.0-textlb.frame.size.width/2.0f, bgimageview.frame.size.height/2.0-textlb.frame.size.height/2.0f, textView.frame.size.width, textView.frame.size.height)];
    }
    
    cellheight = 10.0+bgimageview.frame.origin.y+bgimageview.frame.size.height+10.0f;
    
}


//发送方cell 赋值
    
-(void)configRightCellUnitWithModel:(id)_module className:(NSString *)_className
{
    MsgModule = _module;
    if ([[MsgModule.M_Status lowercaseString] isEqualToString:@"sending"])
    {
        [loadingview startAnimating];
        [resendchatbt setAlpha:0.0];
    }
    else if ([[MsgModule.M_Status lowercaseString] isEqualToString:@"failed"])
    {
        [loadingview stopAnimating];
        [resendchatbt setAlpha:1.0];
    }

    else
    {
        [loadingview stopAnimating];
        [resendchatbt setAlpha:0.0];
    }
    [iconimage setImageURL:[NSURL URLWithString:@"t_avter_1"]];
    
    [userlabel setText:MsgModule.M_From];
    
    NSDateFormatter *ft = [[NSDateFormatter alloc] init];
    [ft setDateFormat:@"MM-dd HH:mm:ss"];
    NSTimeInterval intval=[[NSTimeZone systemTimeZone] secondsFromGMT];
    [timelb setText:[NSString stringWithFormat:@" %@ ",[ft stringFromDate:[MsgModule.M_LastUpdateTime dateByAddingTimeInterval:-intval]]]];
    [timelb sizeToFit];
    [timelb setFrame:CGRectMake(kNBR_SCREEN_W/2.0- timelb.frame.size.width/2.0f, timelb.frame.origin.y, timelb.frame.size.width, timelb.frame.size.height)];
    
    if (textlb)
    {
        [textlb removeFromSuperview];
    }
    if ([self GetImageUrl:MsgModule.M_Msg])
    {
        NSLog(@"imageurl == %@",[self GetImageUrl:MsgModule.M_Msg]);
        [textView setAlpha:0.0f];
        [vodiobg setAlpha:0.0];
        [sendimgview setAlpha:1.0];
        [voicelb setAlpha:0.0];
        [sendimgview setFrame:CGRectMake(sendimgview.frame.origin.x, sendimgview.frame.origin.y, sendimgview.frame.size.width, 100.0f)];
        
        [sendimgview setPlaceholderImage:[UIImage imageNamed:[self GetImageUrl:MsgModule.M_Msg]]];
        [sendimgview setImageURL:[NSURL URLWithString:[self GetImageUrl:MsgModule.M_Msg]]];
        [sendimgview setBackgroundColor:[UIColor redColor]];
        [bgimageview setFrame:CGRectMake(iconimage.frame.origin.x-30.0-sendimgview.frame.size.width-10.0, userlabel.frame.origin.y+userlabel.frame.size.height, sendimgview.frame.size.width+30.0f, sendimgview.frame.size.height + 20.0)];
        
        [sendimgview setFrame:CGRectMake(bgimageview.frame.origin.x +13.0, bgimageview.frame.origin.y+10.0f, sendimgview.frame.size.width, sendimgview.frame.size.height)];
        
    }
    else if ([self GetVidioUrl:MsgModule.M_Msg])
    {
        [textView setAlpha:0.0f];
        [sendimgview setAlpha:0.0];
        [vodiobg setAlpha:1.0];
        [voicelb setAlpha:1.0];
        [voicelb setFrame:CGRectMake(voicelb.frame.origin.x, voicelb.frame.origin.y, voicelb.frame.size.width, 25.0)];
        if (MsgModule.M_Msg.length > 0)
        {
            NSString *str = [self GetVidioUrl:MsgModule.M_Msg];
            NSArray *tem = [str componentsSeparatedByString:@","];
            if ([tem count]>=2)
            {
                [voicelb setText:[NSString stringWithFormat:@"%@\"",[tem objectAtIndex:1]]];
            }
        }
        [vodiobg setFrame:CGRectMake(vodiobg.frame.origin.x, vodiobg.frame.origin.y, vodiobg.frame.size.width,  vodiobg.frame.size.height)];
        [bgimageview setFrame:CGRectMake(kNBR_SCREEN_W-iconimage.frame.size.width-22.0-60.0-vodiobg.frame.size.width, userlabel.frame.origin.y+userlabel.frame.size.height, vodiobg.frame.size.width+60, vodiobg.frame.size.height-10)];
        
        [vodiobg setFrame:CGRectMake(bgimageview.frame.origin.x+24.0, bgimageview.frame.origin.y-5.0f, vodiobg.frame.size.width,vodiobg.frame.size.height)];
        
         [voicelb setFrame:CGRectMake(bgimageview.frame.origin.x-voicelb.frame.size.width-10.0f, bgimageview.frame.origin.y+bgimageview.frame.size.height/2.0 - voicelb.frame.size.height/2.0f, voicelb.frame.size.width, 25.0)];
        
    }
    
    else
    {
        [sendimgview setAlpha:0.0];
        [vodiobg setAlpha:0.0];
        [textView setAlpha:1.0];
        [voicelb setAlpha:0.0];
        CGSize defaultSize = CGSizeMake(200, 22);
        
        NSString *chatMsg = [NSString stringWithFormat:@" %@ ",MsgModule.M_Msg];
        
        if (MsgModule.M_Msg  || MsgModule.M_Msg.length > 0)
        {
            CGSize labelSize = CGSizeZero;
            if ([MsgModule.M_Msg isKindOfClass:[NSString class]])
            {
                NSArray *arr = [self GetTextFacecount:MsgModule.M_Msg];
                NSString *str = [NSString stringWithFormat:@" %@ ",MsgModule.M_Msg];
                for (NSString *tem in arr)
                {
                    str = [str stringByReplacingOccurrencesOfString:tem withString:@""];
                }
                str = [str stringByReplacingOccurrencesOfString:@"[url]" withString:@""];
                str = [str stringByReplacingOccurrencesOfString:@"[/url]" withString:@""];
                chatMsg = str;
                
                
                UIFont *font = [UIFont fontWithName:@"Helvetica" size:15];
                labelSize = [str sizeWithFont:font constrainedToSize:CGSizeMake(200.0f, 2048.0f) lineBreakMode:NSLineBreakByCharWrapping];
                defaultSize.width = labelSize.width +24.0*[arr count]>200?200:labelSize.width +24.0*[arr count];
                defaultSize.height = labelSize.height;
            }
            if ([self isHasUrl:MsgModule.M_Msg])
            {
                [bgimageview setUserInteractionEnabled:YES];
            }
            else
            {
                [bgimageview setUserInteractionEnabled:NO];
            }
        }
        
        if (MsgModule.M_Msg.length == 0)
        {
            MsgModule.M_Msg = @" ";
        }
        
        textlb = [[aya_coreTextView alloc] initWithMarkUpString:MsgModule.M_Msg width:defaultSize.width x:0.0f y:0.0f];
        [textlb setDelegate:self];
        [textView setFrame:CGRectMake(10.0, 7.0f, textlb.frame.size.width, textlb.frame.size.height)];
        [textView addSubview:textlb];
        [bgimageview setFrame:CGRectMake(iconimage.frame.origin.x-10.0-textView.frame.size.width-30, userlabel.frame.origin.y+userlabel.frame.size.height, textView.frame.size.width+30.0f, textView.frame.size.height + 20.0)];
        [textView setFrame:CGRectMake(bgimageview.frame.size.width/2.0-textView.frame.size.width/2.0f, bgimageview.frame.size.height/2.0-textView.frame.size.height/2.0f, textView.frame.size.width, textView.frame.size.height)];
        
    }
    cellheight = 10.0+bgimageview.frame.origin.y+bgimageview.frame.size.height+10.0f;
    
    
}

-(void)aya_coreTextView:(aya_coreTextView *)_coreTextView willClickUrlUnit:(NSString *)_url
{
    if (delegate && [delegate respondsToSelector:@selector(ChatListCellGoToWebViewWithCell:WithMode:WithUrl:)])
    {
        [delegate ChatListCellGoToWebViewWithCell:self WithMode:MsgModule WithUrl:_url];
    }
}

-(void) StopLoadingview
{
    [loadingview stopAnimating];
}

-(NSString *) GetImageUrl:(NSString *)_org
{
    NSString *returnstr =nil;
    if ([_org hasPrefix:@"[img]"])
    {
        NSRange rang;
        rang.length = _org.length - 11;
        rang.location = 5;
        returnstr = [_org substringWithRange:rang];
        NSArray *temarr = [returnstr componentsSeparatedByString:@","];
        if ([temarr count]>0)
        {
            returnstr = [temarr objectAtIndex:0];
        }
        
    }
    return returnstr;
}

-(NSArray *) GetTextFacecount:(NSString *) _org
{
    NSRegularExpression* regex = [[NSRegularExpression alloc]
                                  initWithPattern:REGEX_FACESTRING
                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                  error:nil];
    NSArray* chunks = [regex matchesInString:_org options:0 range:NSMakeRange(0, [_org length])];
    NSUInteger currSeek = 0;
    NSMutableArray *cottArr = [[NSMutableArray alloc] init];
    NSBundle            *bundle = [NSBundle mainBundle];
    NSString            *path = [bundle pathForResource:@"face" ofType:@"xml"];
    NSDictionary *faceImgCodePlist = [[NSDictionary alloc] initWithContentsOfFile:path];
//    NSString *defaultPath = [[NSBundle mainBundle] pathForResource:@"FaceImgCode" ofType:@"plist"];
//    NSMutableDictionary *faceImgCodePlist = [[NSMutableDictionary alloc] initWithContentsOfFile:defaultPath];
    for (NSTextCheckingResult *b in chunks)
    {
        NSString *checkMarkStr = @"";
        
        NSRange textRange = NSMakeRange(currSeek, b.range.location - currSeek);
        checkMarkStr = [_org substringWithRange:textRange];
        
        checkMarkStr = [_org substringWithRange:b.range];
        if ([faceImgCodePlist objectForKey:checkMarkStr])
        {
            [cottArr addObject:checkMarkStr];
        }
        
        
        currSeek = (b.range.location + b.range.length);
    }
    return cottArr;
}

-(NSString *) GetVidioUrl:(NSString *)_org
{
    NSString *returnstr =nil;
    if ([_org hasPrefix:@"[voice]"])
    {
        NSRange rang;
        rang.length = _org.length - 15;
        rang.location = 7;
        returnstr = [_org substringWithRange:rang];
    }
    return returnstr;
}

-(BOOL) isHasUrl:(NSString *) _urlstr
{
    BOOL isurl = NO;
    NSRegularExpression* regex = [[NSRegularExpression alloc]
                                  initWithPattern:REGEX_URLSTRING
                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                  error:nil];
    NSArray* chunks = [regex matchesInString:_urlstr options:0 range:NSMakeRange(0, [_urlstr length])];
    NSUInteger currSeek = 0;
    NSMutableArray *cottArr = [[NSMutableArray alloc] init];
    NSString *defaultPath = [[NSBundle mainBundle] pathForResource:@"FaceImgCode" ofType:@"plist"];
    NSMutableDictionary *faceImgCodePlist = [[NSMutableDictionary alloc] initWithContentsOfFile:defaultPath];
    for (NSTextCheckingResult *b in chunks)
    {
        NSString *checkMarkStr = @"";
        
        NSRange textRange = NSMakeRange(currSeek, b.range.location - currSeek);
        checkMarkStr = [_urlstr substringWithRange:textRange];
        
        checkMarkStr = [_urlstr substringWithRange:b.range];
        if ([faceImgCodePlist objectForKey:checkMarkStr])
        {
            [cottArr addObject:checkMarkStr];
        }
        currSeek = (b.range.location + b.range.length);
    }
    if ([chunks count]>0)
    {
        isurl = YES;
    }
    return isurl;
}


-(float)ReturnCellHeight
{
    return cellheight;
}

-(void) PlayVoice
{
    if (delegate && [delegate respondsToSelector:@selector(ChatListCellPlayVoiceWithCell:WithModel:)])
    {
        [delegate ChatListCellPlayVoiceWithCell:self WithModel:MsgModule];
    }
}

-(void) GoToImage:(UITapGestureRecognizer *)_gestur
{
    if (delegate && [delegate respondsToSelector:@selector(ChatListCellClickImageWithCell:WithModel:)])
    {
        [delegate ChatListCellClickImageWithCell:self WithModel:MsgModule];
    }
}

-(void) ReSendMessage
{
    if (delegate && [delegate respondsToSelector:@selector(ChatListCellReSendMesssageWithCell:WithMode:)])
    {
        [delegate ChatListCellReSendMesssageWithCell:self WithMode:MsgModule];
    }

}

-(void) GoToZone:(UITapGestureRecognizer *) _gestur
{
    if (delegate  && [delegate respondsToSelector:@selector(ChatListCellGoToZoneWithCell:WithMode:)])
    {
        [delegate ChatListCellGoToZoneWithCell:self WithMode:MsgModule];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
