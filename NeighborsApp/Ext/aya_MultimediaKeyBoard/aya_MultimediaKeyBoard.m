    //
//  aya_MultimediaKeyBoard.m
//  BBG
//
//  Created by Martin.Ren on 13-7-16.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import "aya_MultimediaKeyBoard.h"
#import "C_AmrControllerHelper.h"
#import "NSString+ContverHtml.h"

#define CRT_X(view) view.frame.origin.x
#define CRT_Y(view) view.frame.origin.y
#define CRT_W(view) view.frame.size.width
#define CRT_H(view) view.frame.size.height
#define FACEPAGESIZE   28
#define FACEROWCOUNT   4
#define FACECOLOMCOUNT 7

#define KEYBOARDHEGHT [[UIScreen mainScreen] bounds].size.height-44.0f

@interface aya_MultimediaKeyBoard()
{
    UIImage         *imgAudio;
    UIImage         *imgFace;
    UIImage         *imgKeyBoard;
    UIImage         *imgOther;
    
    
    
    UIView          *keyboardFace;
    UIView          *keyboardOther;
    UIView          *keyboardAudio;
}

//@property (nonatomic, strong) UIButton   *audioBtn;
@property (nonatomic, strong) UIButton   *faceBtn;
@property (nonatomic, strong) UIButton   *otherMsgBtn;
@property (nonatomic, strong) UIButton   *recoderBtn;
@end

@implementation aya_MultimediaKeyBoard

//@synthesize audioBtn;
@synthesize isCommentKeyboardType;
@synthesize commentImgDate;
@synthesize inputTextView;
@synthesize faceBtn;
@synthesize otherMsgBtn;
@synthesize delegate;
@synthesize currStatus;
@synthesize recoderBtn;
@synthesize placeholderstr;
- (void) setCurrMacPic
{
    CGFloat width = 80 * [C_AmrControllerHelper ShareAmrControllerHelper].CurrPowerPorgess * 1.5;
    
    if (width >= 80.0f)
    {
        width = 80.0f;
    }
    
    UIView *powerView = [keyboardAudio viewWithTag:0xffff];
    [powerView setFrame:CGRectMake(CRT_X(powerView), CRT_Y(powerView), width, CRT_H(powerView))];
}

- (void) otherKeyboardDidSelect : (UIButton*) _otherBtnSender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ayaKeyBoard:willSelectOtherBoardIndex:)])
    {
        [self.delegate ayaKeyBoard:self willSelectOtherBoardIndex:_otherBtnSender.tag];
    }
}

- (void) configAudioKeyBoard
{
    if (!keyboardAudio)
    {
        keyboardAudio = [[UIView alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W / 2.0f - 129.0f / 2.0f, (KEYBOARDHEGHT - 45) / 2.0f - 72.0f / 2.0f, 129, 72.0f)];
        [keyboardAudio setBackgroundColor:[UIColor darkGrayColor]];
        [keyboardAudio.layer setCornerRadius:8.0f];
        [keyboardAudio setAlpha:0.0f];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 129.0f, 72.0f)];
        [imgView setImage:[UIImage imageNamed:@"voicePower"]];
        
        UIView* powerView = [[UIView alloc] initWithFrame:CGRectMake(45, 1, 80, 70)];
        [powerView setBackgroundColor:[UIColor greenColor]];
        [powerView setTag:0xffff];
        [keyboardAudio addSubview:powerView];
        [keyboardAudio addSubview:imgView];
        
        _RecodeTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(60.0f, 81.0f, 20.0f, 20.0f)];
        [_RecodeTimeLabel setBackgroundColor:[UIColor clearColor]];
        [_RecodeTimeLabel setTextAlignment:NSTextAlignmentCenter];
        [_RecodeTimeLabel setFont:[UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14]];
        [_RecodeTimeLabel setTextColor:kNBR_ProjectColor_StandRed];
        [keyboardAudio addSubview:_RecodeTimeLabel];
    }
}

- (void) configOtherKeyboard
{
    if (self.isCommentKeyboardType)
    {
        return ;
    }
    else
    {
        UIButton *imgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [imgButton setTag:0];
        [imgButton addTarget:self action:@selector(otherKeyboardDidSelect:) forControlEvents:UIControlEventTouchUpInside];
        [imgButton setFrame:CGRectMake(10, 10, 35, 44)];
        [imgButton setBackgroundImage:[UIImage imageNamed:@"picTakPhoto"] forState:UIControlStateNormal];
        [keyboardOther addSubview:imgButton];
        
        
        UIButton *camerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [camerButton setTag:1];
        [camerButton addTarget:self action:@selector(otherKeyboardDidSelect:) forControlEvents:UIControlEventTouchUpInside];
        [camerButton setFrame:CGRectMake(10 + 40 + 15, 10, 35, 44)];
        [camerButton setBackgroundImage:[UIImage imageNamed:@"picLibriry"] forState:UIControlStateNormal];
        [keyboardOther addSubview:camerButton];
    }
}

- (void) configFaceKeyboard
{
    NSBundle            *bundle = [NSBundle mainBundle];
    NSString            *path = [bundle pathForResource:@"face" ofType:@"xml"];
    
    faceResDict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    faceScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, 216)];
    [faceScroll setDelegate:self];
    faceScroll.pagingEnabled = YES;
    [faceScroll setShowsHorizontalScrollIndicator:NO];
    [faceScroll setShowsVerticalScrollIndicator:NO];
    [keyboardFace addSubview:faceScroll];
    
    
    
    NSArray *faceAllKey = [faceResDict allKeys];
    curfacekeyall = [[NSMutableArray alloc] initWithObjects:@"[e]微笑[/e]",@"[e]撇嘴[/e]",@"[e]色[/e]",@"[e]发呆[/e]",@"[e]得意[/e]",@"[e]流泪[/e]",@"[e]害羞[/e]",@"[e]闭嘴[/e]",@"[e]睡[/e]",@"[e]大哭[/e]",@"[e]尴尬[/e]",@"[e]发怒[/e]",@"[e]调皮[/e]",@"[e]呲牙[/e]",@"[e]惊讶[/e]",@"[e]难过[/e]",@"[e]酷[/e]",@"[e]冷汗[/e]",@"[e]抓狂[/e]",@"[e]吐[/e]",@"[e]偷笑[/e]",@"[e]可爱[/e]",@"[e]白眼[/e]",@"[e]傲慢[/e]",@"[e]饥饿[/e]",@"[e]困[/e]",@"[e]惊恐[/e]",@"[e]无语[/e]",@"[e]憨笑[/e]",@"[e]大兵[/e]",@"[e]奋斗[/e]",@"[e]咒骂[/e]",@"[e]疑问[/e]",@"[e]嘘[/e]",@"[e]晕[/e]",@"[e]折磨[/e]",@"[e]衰[/e]",@"[e]骷髅[/e]",@"[e]敲打[/e]",@"[e]再见[/e]",@"[e]擦汗[/e]",@"[e]抠鼻[/e]",@"[e]鼓掌[/e]",@"[e]糗大了[/e]",@"[e]坏笑[/e]",@"[e]左哼哼[/e]",@"[e]右哼哼[/e]",@"[e]哈欠[/e]",@"[e]鄙视[/e]",@"[e]委屈[/e]",@"[e]快哭了[/e]",@"[e]阴险[/e]",@"[e]亲亲[/e]",@"[e]吓[/e]",@"[e]可怜[/e]",@"[e]菜刀[/e]",@"[e]西瓜[/e]",@"[e]啤酒[/e]",@"[e]篮球[/e]",@"[e]乒乓[/e]",@"[e]咖啡[/e]",@"[e]饭[/e]",@"[e]猪头[/e]",@"[e]玫瑰[/e]",@"[e]凋谢[/e]",@"[e]示爱[/e]",@"[e]爱心[/e]",@"[e]心碎了[/e]",@"[e]蛋糕[/e]",@"[e]闪电[/e]",@"[e]炸弹[/e]",@"[e]刀[/e]",@"[e]足球[/e]",@"[e]瓢虫[/e]",@"[e]便便[/e]",@"[e]月亮[/e]",@"[e]太阳[/e]",@"[e]礼物[/e]",@"[e]拥抱[/e]",@"[e]赞[/e]",@"[e]弱[/e]",@"[e]握手[/e]",@"[e]胜利[/e]",@"[e]抱拳[/e]",@"[e]勾引[/e]",@"[e]拳头[/e]",@"[e]差劲[/e]",@"[e]爱你[/e]",@"[e]不要[/e]",@"[e]好[/e]", nil];
    NSInteger pagecount = [faceAllKey count]%FACEPAGESIZE == 0 ?[faceAllKey count]/FACEPAGESIZE :[faceAllKey count]/FACEPAGESIZE + 1;
    [faceScroll setContentSize:CGSizeMake(kNBR_SCREEN_W * pagecount, 216)];
    if (pagecount >0)
    {
        facepagecontrol = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f,faceScroll.frame.size.height-30.0f, kNBR_SCREEN_W, 30.0f)];
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0f)
        {
            [facepagecontrol setCurrentPageIndicatorTintColor:kNBR_ProjectColor_DeepGray];
            [facepagecontrol setPageIndicatorTintColor:kNBR_ProjectColor_LightGray];
        }
        
        [facepagecontrol setCurrentPage:0];
        [facepagecontrol setNumberOfPages:pagecount];
        [keyboardFace addSubview:facepagecontrol];
    }
    int index = 0;
    for ( int p = 0; p<pagecount; p++)
    {
        for (int h = 0; h < FACEROWCOUNT; h++)
        {
            for (int w = 0; w < FACECOLOMCOUNT; w++)
            {
                if (h*FACECOLOMCOUNT+w ==FACEPAGESIZE-2)
                {
                    [curfacekeyall insertObject:@"删除" atIndex:index];
                    //删除
                    UIButton *Deletebt = [[UIButton alloc] initWithFrame:CGRectMake(10 + w * (kNBR_SCREEN_W / FACECOLOMCOUNT)+p * kNBR_SCREEN_W, 20 + h * 42, 30, 30)];
                    [Deletebt setBackgroundColor:[UIColor clearColor]];
                    
                    [Deletebt setBackgroundImage:[UIImage imageNamed:@"Comment_faceDelete"] forState:UIControlStateNormal];
                    [Deletebt addTarget:self action:@selector(DeletefaceTo) forControlEvents:UIControlEventTouchUpInside];
                    [faceScroll addSubview:Deletebt];
                }
                else if (h*7+w == FACEPAGESIZE-1)
                {
                    [curfacekeyall insertObject:@"发送" atIndex:index];
                    //                    [curfacekeyall addObject:@"发送"];
                    //
                    UIButton *sendfacebt = [[UIButton alloc] initWithFrame:CGRectMake(10 + w * (kNBR_SCREEN_W / FACECOLOMCOUNT)+p * kNBR_SCREEN_W, 20 + h * 42, 30, 30)];
                    [sendfacebt setBackgroundColor:[UIColor clearColor]];
                    [sendfacebt addTarget:self action:@selector(SendfaceTo) forControlEvents:UIControlEventTouchUpInside];
                    [sendfacebt setBackgroundImage:[UIImage imageNamed:@"Comment_faceSend"] forState:UIControlStateNormal];
                    [faceScroll addSubview:sendfacebt];
                }
                else
                {
                    if (index >= [curfacekeyall count])
                    {
                        [curfacekeyall insertObject:@"" atIndex:index];
                    }
                    else
                    {
                        UIButton *subfaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        [subfaceBtn addTarget:self action:@selector(didselectFaceBtn:) forControlEvents:UIControlEventTouchUpInside];
                        [subfaceBtn setTag:index];
                        [subfaceBtn setFrame:CGRectMake(10 + w * (kNBR_SCREEN_W / FACECOLOMCOUNT)+ p * kNBR_SCREEN_W, 20 + h * 42, 30, 30)];
                        [faceScroll addSubview:subfaceBtn];
                        
                        NSString *faceFileName = [faceResDict valueForKey:[curfacekeyall objectAtIndex:index]];
                        [subfaceBtn setBackgroundImage:[UIImage imageNamed:faceFileName] forState:UIControlStateNormal];
                    }
                    
                }
                
                
                index ++;
            }
        }
        
    }
    
}

- (void) didselectFaceBtn : (UIButton*) _sender
{
    //    NSArray *faceAllKey = [faceResDict allKeys];
    inputTextView.text = [inputTextView.text stringByAppendingFormat:@"%@",[curfacekeyall objectAtIndex:_sender.tag]];
    inputTextView.text  = [inputTextView.text tranStrToDisplayStr];
    
    [self textViewDidChange:inputTextView];
    [inputTextView setContentOffset:CGPointMake(0.0, inputTextView.contentSize.height - inputTextView.frame.size.height)];
    //    NSString *line5 = @"\n\n\n\n\n";
    //    CGSize   line5Size = [line5 sizeWithFont:inputTextView.font constrainedToSize: CGSizeMake(CRT_W(inputTextView), 500)  lineBreakMode:NSLineBreakByWordWrapping];
    //
    //    if (inputTextView.contentSize.height > line5Size.height)
    //    {
    //        [inputTextView setFrame:CGRectMake(CRT_X(inputTextView), CRT_Y(inputTextView), inputTextView.contentSize.width, line5Size.height)];
    //
    //        [self setFrame:CGRectMake(CRT_X(self), keyboardFace.frame.origin.y - (line5Size.height + 10), kNBR_SCREEN_W, line5Size.height + 10)];
    //
    //        [self resetOtherResInputBtn];
    //        return ;
    //    }
    //    else
    //    {
    //        [inputTextView setFrame:CGRectMake(CRT_X(inputTextView), CRT_Y(inputTextView), inputTextView.contentSize.width, inputTextView.contentSize.height)];
    //
    //        [self setFrame:CGRectMake(CRT_X(self), keyboardFace.frame.origin.y - (inputTextView.contentSize.height + 10), kNBR_SCREEN_W, inputTextView.contentSize.height + 10)];
    //        [self resetOtherResInputBtn];
    //        return ;
    //    }
}

- (void) changeKeyBoardStatus : (KEYBOARD_STATUS) _keyBoardStatus
{
  
    //    currStatus = _keyBoardStatus;
    if(currStatus == _keyBoardStatus)
    {
        _keyBoardStatus = KEYBOARD_STATUS_TEXT;
    }
    
    if (!keyboardOther.superview)
    {
        [self.superview addSubview:keyboardOther];
    }
    
    if (!keyboardFace.superview)
    {
        [self.superview addSubview:keyboardFace];
    }
    
    if (!keyboardAudio.superview)
    {
        [self.superview addSubview:keyboardAudio];
    }
    
    [self textViewDidChange:inputTextView];
    
    CGRect oldKeyBoardFrame;
    
    //计算当前自定义键盘的位置
    switch (currStatus)
    {
        case KEYBOARD_STATUS_NONE:
        {
            if (!([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f))
            {
                oldKeyBoardFrame = CGRectMake(0, KEYBOARDHEGHT - 20 - CRT_H(self), kNBR_SCREEN_W, CRT_H(self));
            }
            else
            {
                oldKeyBoardFrame = CGRectMake(0, kNBR_SCREEN_H - CRT_H(self), kNBR_SCREEN_W, CRT_H(self));
            }
        }
            break;
            
        case KEYBOARD_STATUS_AUDIO:
        {
            lastSelfFrame = self.frame;
            if (!([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f))
            {
                oldKeyBoardFrame = CGRectMake(0, KEYBOARDHEGHT - 20 - 45.0f, kNBR_SCREEN_W, 45.0f);
            }
            else
            {
                oldKeyBoardFrame = CGRectMake(0, kNBR_SCREEN_H - 45.0f, kNBR_SCREEN_W, 45.0f);
            }
        }
            break;
            
        case KEYBOARD_STATUS_TEXT:
        {
            if (!([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f))
            {
                oldKeyBoardFrame = CGRectMake(0, KEYBOARDHEGHT - 20 - CRT_H(self), kNBR_SCREEN_W,lastSelfFrame.size.height);
            }
            else
            {
                oldKeyBoardFrame = CGRectMake(0, kNBR_SCREEN_H - CRT_H(self), kNBR_SCREEN_W,lastSelfFrame.size.height);
            }
        }
            break;
            
        case KEYBOARD_STATUS_FACE:
        {
            if (!([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f))
            {
                oldKeyBoardFrame = CGRectMake(0, KEYBOARDHEGHT - 20  -CRT_H(self), kNBR_SCREEN_W, lastSelfFrame.size.height);
            }
            else
            {
                oldKeyBoardFrame = CGRectMake(0, kNBR_SCREEN_H  -CRT_H(self), kNBR_SCREEN_W, lastSelfFrame.size.height);
            }
        }
            break;
            
        case KEYBOARD_STATUS_OTHER:
        {
            if (!([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f))
            {
                oldKeyBoardFrame = CGRectMake(0, KEYBOARDHEGHT - 20 - CRT_H(self), kNBR_SCREEN_W, CRT_H(self));
            }
            else
            {
                oldKeyBoardFrame = CGRectMake(0, kNBR_SCREEN_H - CRT_H(self), kNBR_SCREEN_W, CRT_H(self));
            }
        }
            break;
            
        default:
        {
            if (!([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f))
            {
                oldKeyBoardFrame = CGRectMake(0, KEYBOARDHEGHT - 20 - CRT_H(self), kNBR_SCREEN_W, CRT_H(self));
            }
            else
            {
                oldKeyBoardFrame = CGRectMake(0, kNBR_SCREEN_H - CRT_H(self), kNBR_SCREEN_W, CRT_H(self));
            }
        }
            break;
    }
    [UIView beginAnimations:nil context:nil];
    switch (_keyBoardStatus)
    {
        case KEYBOARD_STATUS_NONE:
        {
            [inputTextView resignFirstResponder];
            //            [self textViewDidChange:inputTextView];
            [self setFrame:oldKeyBoardFrame];
            
            if (!([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f))
            {
                [keyboardFace  setFrame:CGRectMake(0, KEYBOARDHEGHT - 20, kNBR_SCREEN_W, 216)];
                [keyboardOther setFrame:CGRectMake(0, KEYBOARDHEGHT - 20, kNBR_SCREEN_W, 216)];
                [self setFrame:CGRectMake(0, KEYBOARDHEGHT - 20 - CRT_H(self), kNBR_SCREEN_W, CRT_H(self))];
            }
            else
            {
                [keyboardFace  setFrame:CGRectMake(0, kNBR_SCREEN_H, kNBR_SCREEN_W, 216)];
                [keyboardOther setFrame:CGRectMake(0, kNBR_SCREEN_H, kNBR_SCREEN_W, 216)];
                [self setFrame:CGRectMake(0, kNBR_SCREEN_H - CRT_H(self), kNBR_SCREEN_W, CRT_H(self))];
            }
            
            [self resetOtherResInputBtn];
            
           // [audioBtn setBackgroundImage:imgAudio forState:UIControlStateNormal];
            [faceBtn setBackgroundImage:imgFace forState:UIControlStateNormal];
            
            if (!self.isCommentKeyboardType)
            {
                [otherMsgBtn setBackgroundImage:imgOther forState:UIControlStateNormal];
            }
            
        }
            break;
            
        case KEYBOARD_STATUS_AUDIO:
        {
            [inputTextView resignFirstResponder];
            [self setFrame:oldKeyBoardFrame];
            //            [UIView animateWithDuration:0.25 animations:^{
            //               }];
            
            if (!([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f))
            {
                [keyboardFace  setFrame:CGRectMake(0, KEYBOARDHEGHT - 20, kNBR_SCREEN_W, 216)];
                [keyboardOther setFrame:CGRectMake(0, KEYBOARDHEGHT - 20, kNBR_SCREEN_W, 216)];
                [self setFrame:CGRectMake(0, KEYBOARDHEGHT - 20 - 45.0f, kNBR_SCREEN_W, 45.0f)];
            }
            else
            {
                [keyboardFace  setFrame:CGRectMake(0, kNBR_SCREEN_H, kNBR_SCREEN_W, 216)];
                [keyboardOther setFrame:CGRectMake(0, kNBR_SCREEN_H, kNBR_SCREEN_W, 216)];
                [self setFrame:CGRectMake(0, kNBR_SCREEN_H - 45.0f, kNBR_SCREEN_W, 45.0f)];
            }
            [self resetOtherResInputBtn];
            
          //  [audioBtn setBackgroundImage:imgKeyBoard forState:UIControlStateNormal];
            [faceBtn setBackgroundImage:imgFace forState:UIControlStateNormal];
            
            if (!self.isCommentKeyboardType)
            {
                [otherMsgBtn setBackgroundImage:imgOther forState:UIControlStateNormal];
            }
        }
            break;
            
        case KEYBOARD_STATUS_TEXT:
        {
            [UIView animateWithDuration:0.25 animations:^{
                [inputTextView becomeFirstResponder];
                [self setFrame:oldKeyBoardFrame];
            if (!([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f))
                {
                    [keyboardFace  setFrame:CGRectMake(0, KEYBOARDHEGHT - 20, kNBR_SCREEN_W, 216)];
                    [keyboardOther setFrame:CGRectMake(0, KEYBOARDHEGHT - 20, kNBR_SCREEN_W, 216)];
                    [self setFrame:CGRectMake(0, KEYBOARDHEGHT - 20 - CRT_H(self) - currSysKeyboarFrame.size.height, KEYBOARDHEGHT, CRT_H(self))];
                }
                else
                {
                    [keyboardFace  setFrame:CGRectMake(0, kNBR_SCREEN_H, kNBR_SCREEN_W, 216)];
                    [keyboardOther setFrame:CGRectMake(0, kNBR_SCREEN_H, kNBR_SCREEN_W, 216)];
                    [self setFrame:CGRectMake(0, kNBR_SCREEN_H - CRT_H(self) - currSysKeyboarFrame.size.height, KEYBOARDHEGHT, CRT_H(self))];
                }
                
              //  [audioBtn setBackgroundImage:imgAudio forState:UIControlStateNormal];
                [faceBtn setBackgroundImage:imgFace forState:UIControlStateNormal];
                if (!self.isCommentKeyboardType)
                {
                    [otherMsgBtn setBackgroundImage:imgOther forState:UIControlStateNormal];
                }
                
            }];
            
            
        }
            break;
            
        case KEYBOARD_STATUS_FACE:
        {
            [inputTextView resignFirstResponder];
            [self setFrame:oldKeyBoardFrame];
            
            if (!([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f))
            {
                [keyboardFace  setFrame:CGRectMake(0, KEYBOARDHEGHT - 20 - 216, kNBR_SCREEN_W, 216)];
                [keyboardOther setFrame:CGRectMake(0, KEYBOARDHEGHT - 20, kNBR_SCREEN_W, 216)];
                [self setFrame:CGRectMake(0, KEYBOARDHEGHT - 20 - lastSelfFrame.size.height - 216, kNBR_SCREEN_W, lastSelfFrame.size.height)];
            }
            else
            {
                [keyboardFace  setFrame:CGRectMake(0, kNBR_SCREEN_H - 216, kNBR_SCREEN_W, 216)];
                [keyboardOther setFrame:CGRectMake(0, kNBR_SCREEN_H, kNBR_SCREEN_W, 216)];
                [self setFrame:CGRectMake(0, kNBR_SCREEN_H - lastSelfFrame.size.height - 216, kNBR_SCREEN_W, lastSelfFrame.size.height)];
            }
            lastSelfFrame = self.frame;
         //   [audioBtn setBackgroundImage:imgAudio forState:UIControlStateNormal];
            [faceBtn setBackgroundImage:imgKeyBoard forState:UIControlStateNormal];
            if (!self.isCommentKeyboardType)
            {
                [otherMsgBtn setBackgroundImage:imgOther forState:UIControlStateNormal];
            }
        }
            break;
            
        case KEYBOARD_STATUS_OTHER:
        {
            [inputTextView resignFirstResponder];
            [self setFrame:oldKeyBoardFrame];
            
            if (!([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f))
            {
                [keyboardFace  setFrame:CGRectMake(0, KEYBOARDHEGHT - 20, kNBR_SCREEN_W, 216)];
                [keyboardOther setFrame:CGRectMake(0, KEYBOARDHEGHT - 20 - 216, kNBR_SCREEN_W, 216)];
                [self setFrame:CGRectMake(0, KEYBOARDHEGHT - 20 - CRT_H(inputTextView) - 216-10, kNBR_SCREEN_W, 10+CRT_H(inputTextView))];
            }
            else
            {
                [keyboardFace  setFrame:CGRectMake(0, kNBR_SCREEN_H, kNBR_SCREEN_W, 216)];
                [keyboardOther setFrame:CGRectMake(0, kNBR_SCREEN_H - 216, kNBR_SCREEN_W, 216)];
                [self setFrame:CGRectMake(0, kNBR_SCREEN_H - CRT_H(inputTextView) - 216-10, kNBR_SCREEN_W, 10+CRT_H(inputTextView))];
            }
            
           // [audioBtn setBackgroundImage:imgAudio forState:UIControlStateNormal];
            [faceBtn setBackgroundImage:imgFace forState:UIControlStateNormal];
            if (!self.isCommentKeyboardType)
            {
                [otherMsgBtn setBackgroundImage:imgKeyBoard forState:UIControlStateNormal];
            }
        }
            break;
            
        default:
            break;
    }
    
    if (_keyBoardStatus == KEYBOARD_STATUS_AUDIO)
    {
        [inputTextView setAlpha:0.0f];
        [recoderBtn setAlpha:1.0f];
    }
    else
    {
        [inputTextView setAlpha:1.0f];
        [recoderBtn setAlpha:0.0f];
    }
    [UIView commitAnimations];
    
    currStatus = _keyBoardStatus;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ayaKeyBoard:willChangedKeyBoardStatus:currKeyboardHeight:)])
    {
        if (!([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f))
        {
            [self.delegate ayaKeyBoard:self willChangedKeyBoardStatus:currStatus currKeyboardHeight:KEYBOARDHEGHT - 20 - self.frame.origin.y];
        }
        else
        {
            [self.delegate ayaKeyBoard:self willChangedKeyBoardStatus:currStatus currKeyboardHeight:kNBR_SCREEN_H - self.frame.origin.y];
        }
    }
}

- (void) commentOtherKeyBoardBtnClick : (UIButton*) _sender
{
    if (!commentImgDate)
    {
        UIActionSheet *picSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:@"图片库",@"直接拍照", nil];
        [picSheet setTag:0xFF01];
        [picSheet showInView:self];
    }
    else
    {
        UIActionSheet *picSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:@"预览", @"删除图片",nil];
        [picSheet setTag:0xFF02];
        [picSheet showInView:self];
    }
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 0xFF01)
    {
        switch (buttonIndex)
        {
            case 0:
            {
                //图片库
                if (self.delegate && [self.delegate respondsToSelector:@selector(ayaKeyBoard:willSelectOtherBoardIndex:)])
                {
                    [self.delegate ayaKeyBoard:self willSelectOtherBoardIndex:1];
                }
            }
                break;
                
            case 1:
            {
                //直接拍照
                if (self.delegate && [self.delegate respondsToSelector:@selector(ayaKeyBoard:willSelectOtherBoardIndex:)])
                {
                    [self.delegate ayaKeyBoard:self willSelectOtherBoardIndex:0];
                }
            }
                break;
                
            default:
                break;
        }
        return ;
    }
    
    if (actionSheet.tag == 0xFF02)
    {
        switch (buttonIndex)
        {
            case 0:
            {
                //预览
                if (self.delegate && [self.delegate respondsToSelector:@selector(ayaKeyBoard:quikLookImg:)])
                {
                    [self.delegate ayaKeyBoard:self quikLookImg:self.commentImgDate];
                }
            }
                break;
                
            case 1:
            {
                //删除图片
                [self setCommentImgDate:nil];
            }
                break;
                
            default:
                break;
        }
        return ;
    }
}

- (void) keyBoardChangedAction : (UIButton*) _sender
{
    [self changeKeyBoardStatus:(KEYBOARD_STATUS)_sender.tag];
}

- (id) init
{
    return [self initWithKeyBoardTypeIsComment:NO];
}

- (id) initWithKeyBoardTypeIsComment : (BOOL) _comment
{
    self = [super init];
    if (self)
    {
        self.isCommentKeyboardType = _comment;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        currStatus = KEYBOARD_STATUS_NONE;
        
        if (!([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f))
        {
            keyboardFace = [[UIView alloc] initWithFrame:CGRectMake(0, KEYBOARDHEGHT - 20, kNBR_SCREEN_W, 216)];
            keyboardOther= [[UIView alloc] initWithFrame:CGRectMake(0, KEYBOARDHEGHT - 20, kNBR_SCREEN_W, 216)];
        }
        else
        {
            keyboardFace = [[UIView alloc] initWithFrame:CGRectMake(0, kNBR_SCREEN_H, kNBR_SCREEN_W, 216)];
            keyboardOther= [[UIView alloc] initWithFrame:CGRectMake(0, kNBR_SCREEN_H, kNBR_SCREEN_W, 216)];
        }
        
        [keyboardFace setBackgroundColor:[UIColor whiteColor]];
        [keyboardOther setBackgroundColor:[UIColor whiteColor]];
        
        [self configFaceKeyboard];
        [self configOtherKeyboard];
        [self configAudioKeyBoard];
        
        
        imgAudio    = [UIImage imageNamed:@"chatting_setmode_voice_btn_normal"];
        imgKeyBoard = [UIImage imageNamed:@"chatting_setmode_keyboard_btn_normal"];
        imgFace     = [UIImage imageNamed:@"chatting_setmode_biaoqing_btn_normal"];
        imgOther    = [UIImage imageNamed:@"type_select_btn_nor"];
        
        currSysKeyboarFrame  = CGRectMake(0, KEYBOARDHEGHT, kNBR_SCREEN_W, 216);
        
        if (!([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f))
        {
            [self setFrame:CGRectMake(0, KEYBOARDHEGHT - 20 - 45.0f, kNBR_SCREEN_W, 45.0f)];
        }
        else
        {
            [self setFrame:CGRectMake(0, kNBR_SCREEN_H - 45.0f, kNBR_SCREEN_W, 45.0f)];
        }
        [self setBackgroundColor:[UIColor whiteColor]];
        lastSelfFrame = self.frame;
        
        //audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[audioBtn setTag:KEYBOARD_STATUS_AUDIO];
        //[audioBtn addTarget:self action:@selector(keyBoardChangedAction:) forControlEvents:UIControlEventTouchUpInside];
//        [audioBtn setFrame:CGRectMake(5.0f,
//                                      45.0f / 2.0f - 30.0f / 2.0f,
//                                      27.0f,
//                                      30.0f)];
        //[audioBtn setBackgroundImage:imgAudio forState:UIControlStateNormal];
        //[self addSubview:audioBtn];
        
        
        inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f,
                                                                     45.0f / 2.0f - 35.0f / 2.0f,
                                                                    235.0f,
                                                                     35.0f)];
        [inputTextView setDelegate:self];
        [inputTextView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [inputTextView setReturnKeyType:UIReturnKeySend];
        [inputTextView setTextAlignment:NSTextAlignmentLeft];
        [inputTextView setAutoresizesSubviews:YES];
        [inputTextView setFont:[UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13.0f]];
        [inputTextView.layer setCornerRadius:5.0f];
        [inputTextView.layer setBorderColor:[UIColor colorWithRed:52.0f/255.0f green:52.0f/255.0f blue:52.0f/255.0f alpha:1.0f].CGColor];
        [inputTextView.layer setBorderWidth:0.2f];
        
        
        
        
        [inputTextView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
        
        [self addSubview:inputTextView];
        [self textViewDidChange:inputTextView];
        
        if (self.isCommentKeyboardType)
        {
            //        去掉图片评论，修改输入框大小
            [inputTextView setFrame:CGRectMake(5.0f,
                                               45.0f / 2.0f - 35.0f / 2.0f,
                                               270.0f,
                                               35.0f)];
        }
        
        placeholderlabel=[[UILabel alloc]initWithFrame:CGRectMake(5.0f, 9.0f, 200.0f, 15.0f)];
        placeholderlabel.enabled=NO;
        placeholderlabel.backgroundColor=[UIColor clearColor];
        placeholderlabel.textAlignment=NSTextAlignmentLeft;
        placeholderlabel.textColor = kNBR_ProjectColor_LightGray;
        placeholderlabel.font=[UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f];
        [self.inputTextView addSubview:placeholderlabel];
        

        
        faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [faceBtn setTag:KEYBOARD_STATUS_FACE];
        [faceBtn addTarget:self action:@selector(keyBoardChangedAction:) forControlEvents:UIControlEventTouchUpInside];
        [faceBtn setFrame:CGRectMake(inputTextView.frame.origin.x + inputTextView.frame.size.width + 8.0f,
                                     45.0f / 2.0f - 30.0f / 2.0f,
                                     33.0f,
                                     33.0f)];
        [faceBtn setBackgroundImage:imgFace forState:UIControlStateNormal];
        [self addSubview:faceBtn];
        
        
        //other msg btn
        otherMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [otherMsgBtn setTag:KEYBOARD_STATUS_OTHER];
        [otherMsgBtn setContentMode:UIViewContentModeScaleAspectFit];
        [otherMsgBtn setFrame:CGRectMake(faceBtn.frame.origin.x + faceBtn.frame.size.width + 3.0f,
                                         45.0f / 2.0f - 33.0f / 2.0f,
                                         33.0f,
                                         33.0f)];
        
        if (self.isCommentKeyboardType)
        {
            [otherMsgBtn setBackgroundImage:[UIImage imageNamed:@"picCommenImg"] forState:UIControlStateNormal];
            [otherMsgBtn addTarget:self action:@selector(commentOtherKeyBoardBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        }
        else
        {
            [otherMsgBtn setBackgroundImage:imgOther forState:UIControlStateNormal];
            [otherMsgBtn addTarget:self action:@selector(keyBoardChangedAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        [self addSubview:otherMsgBtn];

        
        recoderBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [recoderBtn setFrame:CGRectMake( 5.0f,
                                        45.0f / 2.0f - 35.0f / 2.0f,
                                        235.0f,
                                        35.0f)];
        [recoderBtn.layer setMasksToBounds:YES];
        [recoderBtn setTitle:@"按住说话" forState:UIControlStateNormal];
        [recoderBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0f]];
        [recoderBtn.titleLabel setTextColor:[UIColor darkGrayColor]];
        [recoderBtn.layer setCornerRadius:5.0f];
        [recoderBtn setAlpha:0.0f];
        [recoderBtn addTarget:self action:@selector(beginRecodering:) forControlEvents:UIControlEventTouchDown];
        [recoderBtn addTarget:self action:@selector(successRecodered:) forControlEvents:UIControlEventTouchUpInside];
        [recoderBtn addTarget:self action:@selector(faildRecodered:) forControlEvents:UIControlEventTouchUpOutside];
        [self addSubview:recoderBtn];
        
        
        [self addObserver:self forKeyPath:@"commentImgDate" options:NSKeyValueObservingOptionNew context:Nil];
    }
    return self;
}

-(void)beginRecodering : (UIButton*) _sender
{
    [UIView animateWithDuration:.25f animations:^{
        [keyboardAudio setAlpha:1.0f];
    }];
    
    [[C_AmrControllerHelper ShareAmrControllerHelper] setDelegate:self];
    [[C_AmrControllerHelper ShareAmrControllerHelper] BeginRecoderAudio];
    
    isSuccessAmrRecoded = NO;
    
    powerSetTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/10.0f target:self selector:@selector(setCurrMacPic) userInfo:nil repeats:YES];
    
    timenum=30;
    timerRecode=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(UserIsRecodering) userInfo:nil repeats:YES];
    [_RecodeTimeLabel setText:[NSString stringWithFormat:@"%d",timenum]];
    
}
-(void)UserIsRecodering
{
    if(timenum>0)
    {
        timenum=timenum-1;
        [_RecodeTimeLabel setText:[NSString stringWithFormat:@"%d",timenum]];
    }
    else
    {
        [self successRecodered:recoderBtn];
        [timerRecode invalidate];
        timenum=30;
    }
}
-(void)successRecodered : (UIButton*) _sender
{
    
    [UIView animateWithDuration:.25f animations:^{
        [keyboardAudio setAlpha:0.0f];
    }];
    if(timenum!=30)
    {
        [[C_AmrControllerHelper ShareAmrControllerHelper] EndRecoderAudio];
        isSuccessAmrRecoded = YES;
    }
    [powerSetTimer invalidate];
    [timerRecode invalidate];
    
    timenum=30;
}

-(void)faildRecodered : (UIButton*) _sender
{
    [UIView animateWithDuration:.25f animations:^{
        [keyboardAudio setAlpha:0.0f];
    }];
    
    [[C_AmrControllerHelper ShareAmrControllerHelper] EndRecoderAudio];
    
    isSuccessAmrRecoded = NO;
    
    [powerSetTimer invalidate];
    [timerRecode invalidate];
    timenum=30;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    currSysKeyboarFrame = keyboardRect;
    
    [self textViewDidChange:inputTextView];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    currSysKeyboarFrame = keyboardRect;
}

- (void) resetOtherResInputBtn
{
   // [audioBtn setFrame:CGRectMake(CRT_X(audioBtn), self.frame.size.height - CRT_H(audioBtn) - 5, CRT_W(audioBtn), CRT_H(audioBtn))];
    [faceBtn setFrame:CGRectMake(CRT_X(faceBtn), self.frame.size.height - CRT_H(faceBtn) - 5, CRT_W(faceBtn), CRT_H(faceBtn))];
    [otherMsgBtn setFrame:CGRectMake(CRT_X(otherMsgBtn), self.frame.size.height - CRT_H(otherMsgBtn) - 5, CRT_W(otherMsgBtn), CRT_H(otherMsgBtn))];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"])
    {
        if (object == inputTextView)
        {
            if (!([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f))
            {
                return;
            }
            [self textViewDidChange:object];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(ayaKeyBoard:willChangedKeyBoardStatus:currKeyboardHeight:)])
            {
                if (currStatus != KEYBOARD_STATUS_NONE)
                {
                    if (!([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f))
                    {
                        [self.delegate ayaKeyBoard:self willChangedKeyBoardStatus:currStatus currKeyboardHeight:KEYBOARDHEGHT - 20 - self.frame.origin.y];
                    }
                    else
                    {
                        [self.delegate ayaKeyBoard:self willChangedKeyBoardStatus:currStatus currKeyboardHeight:kNBR_SCREEN_H - self.frame.origin.y];
                    }
                }
            }
        }
        return ;
    }
    
    if ([keyPath isEqualToString:@"commentImgDate"] && self.isCommentKeyboardType)
    {
        if (object == self)
        {
            UIImage *newImageView = [change objectForKey:NSKeyValueChangeNewKey];
            
            if (![newImageView isKindOfClass:[NSNull class]])
            {
                [self.otherMsgBtn setBackgroundImage:newImageView forState:UIControlStateNormal];
            }
            else
            {
                [self.otherMsgBtn setBackgroundImage:[UIImage imageNamed:@"picCommenImg"] forState:UIControlStateNormal];
            }
        }
        return ;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        if ([textView.text length] == 0)
        {
            if (self.isCommentKeyboardType)
            {
                [self.delegate ayaKeyBoard:self willFinishInputMsg:@""];
            }
            
            return NO;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(ayaKeyBoard:willFinishInputMsg:)])
        {
            NSString *retstr = textView.text;
            retstr = [retstr displayStrToTranStr];
            [textView setText:@""];
            [self.delegate ayaKeyBoard:self willFinishInputMsg:retstr];
            
        }
        return NO;
    }
    
    return YES;
}

-(void) SendfaceTo
{
//    if (inputTextView.text.length > 0)
//    {
//        
//    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(ayaKeyBoard:willFinishInputMsg:)])
    {
        NSString *retstr = inputTextView.text;
        retstr = [retstr displayStrToTranStr];
        [self.delegate ayaKeyBoard:self willFinishInputMsg:retstr];
        [inputTextView setText:@""];
        [self textViewDidChange:inputTextView];
    }
    
}

-(void) DeletefaceTo
{
    if (inputTextView.text.length > 0)
    {
        inputTextView.text = [inputTextView.text substringToIndex:inputTextView.text.length-1];
    }
    
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    currStatus = KEYBOARD_STATUS_TEXT;
    [self changeKeyBoardStatus:KEYBOARD_STATUS_TEXT];
}

- (void) textViewDidChange:(UITextView *)textView
{
    if(textView.text.length==0)
    {
        if(self.placeholderstr.length!=0)
        {
            CGFloat maxwidth=235.0f;
            CGSize size=[self.placeholderstr sizeWithFont:[UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f] constrainedToSize:CGSizeMake(maxwidth, 15.0f)];
            placeholderlabel.frame=CGRectMake(5.0f, 9.0f, size.width, size.height);
            placeholderlabel.text=self.placeholderstr;
        }
        else
        {
            placeholderlabel.text=@"";
        }
       
    }
    else
    {
        placeholderlabel.text=@"";
    }
    if (currStatus == KEYBOARD_STATUS_TEXT)
    {
        NSString *line5 = @"\n\n\n\n\n";
        CGSize   line5Size = [line5 sizeWithFont:textView.font constrainedToSize: CGSizeMake(CRT_W(textView), 500)  lineBreakMode:NSLineBreakByWordWrapping];
        
        if (inputTextView.text.length>0)
        {
            if (textView.contentSize.height > line5Size.height)
            {
                [inputTextView setFrame:CGRectMake(inputTextView.frame.origin.x, 5, textView.contentSize.width, line5Size.height)];
                if (!([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f))
                {
                    [self setFrame:CGRectMake(0, KEYBOARDHEGHT - 20 - (line5Size.height + 10)-currSysKeyboarFrame.size.height, kNBR_SCREEN_W, line5Size.height + 10)];
                }
                else
                {
                    [self setFrame:CGRectMake(0, kNBR_SCREEN_H - (line5Size.height + 10)-currSysKeyboarFrame.size.height, kNBR_SCREEN_W, line5Size.height + 10)];
                }
                lastSelfFrame = self.frame;
                // [self resetOtherResInputBtn];
            }
            else if (textView.contentSize.height ==35.0 )
            {
                [inputTextView setFrame:CGRectMake(inputTextView.frame.origin.x, 5, 235.0f,
                                                   35.0f)];
                
                if (!([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f))
                {
                    [self setFrame:CGRectMake(0,KEYBOARDHEGHT- 20 - (inputTextView.frame.size.height + 10)-currSysKeyboarFrame.size.height, kNBR_SCREEN_W, inputTextView.frame.size.height + 10)];
                }
                else
                {
                    [self setFrame:CGRectMake(0,kNBR_SCREEN_H - (inputTextView.frame.size.height + 10)-currSysKeyboarFrame.size.height, kNBR_SCREEN_W, inputTextView.frame.size.height + 10)];
                }
                
                lastSelfFrame = self.frame;
                [self resetOtherResInputBtn];
            }
            
            else
            {
                [inputTextView setFrame:CGRectMake(inputTextView.frame.origin.x, 5, textView.contentSize.width, textView.contentSize.height)];
                if (!([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f))
                {
                    [self setFrame:CGRectMake(0, KEYBOARDHEGHT  - 20 - (inputTextView.contentSize.height + 10)-currSysKeyboarFrame.size.height, kNBR_SCREEN_W, inputTextView.contentSize.height + 10)];
                }
                else
                {
                    [self setFrame:CGRectMake(0, kNBR_SCREEN_H - (inputTextView.contentSize.height + 10)-currSysKeyboarFrame.size.height, kNBR_SCREEN_W, inputTextView.contentSize.height + 10)];
                }
                lastSelfFrame = self.frame;
                [self resetOtherResInputBtn];
            }
            
        }
        else
        {
            [inputTextView setFrame:CGRectMake(inputTextView.frame.origin.x, 5,  textView.contentSize.width, textView.contentSize.height)];
            
            if (!([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f))
            {
                [self setFrame:CGRectMake(0, KEYBOARDHEGHT- 20 - (inputTextView.frame.size.height + 10)-currSysKeyboarFrame.size.height, kNBR_SCREEN_W, inputTextView.frame.size.height + 10)];
            }
            else
            {
                [self setFrame:CGRectMake(0, kNBR_SCREEN_H - (inputTextView.frame.size.height + 10)-currSysKeyboarFrame.size.height, kNBR_SCREEN_W, inputTextView.frame.size.height + 10)];
            }
            
            lastSelfFrame = self.frame;
            [self resetOtherResInputBtn];
        }
        
    }
    else
    {
        NSString *line5 = @"\n\n\n\n\n";
        CGSize   line5Size = [line5 sizeWithFont:textView.font constrainedToSize: CGSizeMake(CRT_W(textView), 500)  lineBreakMode:NSLineBreakByWordWrapping];
        
        if (inputTextView.text.length>0)
        {
            if (textView.contentSize.height > line5Size.height)
            {
                [inputTextView setFrame:CGRectMake(inputTextView.frame.origin.x, 5, textView.contentSize.width, line5Size.height)];
                if (!([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f))
                {
                    [self setFrame:CGRectMake(0,KEYBOARDHEGHT - 20 - (line5Size.height + 10)-216, kNBR_SCREEN_W, line5Size.height + 10)];
                }
                else
                {
                    [self setFrame:CGRectMake(0,kNBR_SCREEN_H - (line5Size.height + 10)-216, kNBR_SCREEN_W, line5Size.height + 10)];
                }
                lastSelfFrame = self.frame;
                [self resetOtherResInputBtn];
            }
            else if (textView.contentSize.height ==35.0 )
            {
                [inputTextView setFrame:CGRectMake(inputTextView.frame.origin.x, 5, 235.0f,
                                                   35.0f)];
                
                if (!([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f))
                {
                    [self setFrame:CGRectMake(0, KEYBOARDHEGHT- 20 - (inputTextView.frame.size.height + 10)-216, kNBR_SCREEN_W, inputTextView.frame.size.height + 10)];
                }
                else
                {
                    [self setFrame:CGRectMake(0, kNBR_SCREEN_H - (inputTextView.frame.size.height + 10)-216, kNBR_SCREEN_W, inputTextView.frame.size.height + 10)];
                }
                lastSelfFrame = self.frame;
                [self resetOtherResInputBtn];
            }
            
            else
            {
                [inputTextView setFrame:CGRectMake(inputTextView.frame.origin.x, 5, textView.contentSize.width, textView.contentSize.height)];
                
                if (!([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f))
                {
                    [self setFrame:CGRectMake(0, KEYBOARDHEGHT  - 20 - (textView.contentSize.height + 10)-216, kNBR_SCREEN_W, textView.contentSize.height + 10)];
                }
                else
                {
                    [self setFrame:CGRectMake(0, kNBR_SCREEN_H - (textView.contentSize.height + 10)-216, kNBR_SCREEN_W, textView.contentSize.height + 10)];
                }
                lastSelfFrame = self.frame;
                [self resetOtherResInputBtn];
            }
            
        }
        else
        {
            
            [inputTextView setFrame:CGRectMake(inputTextView.frame.origin.x, 5.0, 235.0f,
                                               35.0f)];
            
            if (!([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f))
            {
                [self setFrame:CGRectMake(0, KEYBOARDHEGHT- 20 - (inputTextView.frame.size.height + 10), kNBR_SCREEN_W, inputTextView.frame.size.height + 10)];
            }
            else
            {
                [self setFrame:CGRectMake(0, kNBR_SCREEN_H - (inputTextView.frame.size.height + 10), kNBR_SCREEN_W, inputTextView.frame.size.height + 10)];
            }
            
            if (currStatus == KEYBOARD_STATUS_FACE)
            {
                if (!([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f))
                {
                    [self setFrame:CGRectMake(0, KEYBOARDHEGHT- 20 - (inputTextView.frame.size.height + 10)-216, kNBR_SCREEN_W, inputTextView.frame.size.height + 10)];
                }
                else
                {
                    [self setFrame:CGRectMake(0, kNBR_SCREEN_H - (inputTextView.frame.size.height + 10)-216, kNBR_SCREEN_W, inputTextView.frame.size.height + 10)];
                }
            }
            lastSelfFrame = self.frame;
            [self resetOtherResInputBtn];
            
        }
        
    }
}

- (void) ResetKeyBoardFrame
{
    [inputTextView resignFirstResponder];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/kNBR_SCREEN_W;
    [facepagecontrol setCurrentPage:page];
}

-(void)hidekeyboardview
{
    [self changeKeyBoardStatus:KEYBOARD_STATUS_NONE];
    if (self.delegate && [self.delegate respondsToSelector:@selector(ayaKeyBoard:willChangedKeyBoardStatus:currKeyboardHeight:)])
    {
        float _height;
        if (inputTextView.text.length)
        {
            _height = CRT_H(self);
        }
        else
        {
            _height = 45.0;
        }
        [self.delegate ayaKeyBoard:self willChangedKeyBoardStatus:KEYBOARD_STATUS_NONE currKeyboardHeight:_height];
    }
}
- (void) dealloc
{
//            [self addObserver:self forKeyPath:@"commentImgDate" options:NSKeyValueObservingOptionNew context:Nil];
    [self removeObserver:self forKeyPath:@"commentImgDate"];
    [inputTextView removeObserver:self forKeyPath:@"contentSize"];
    [powerSetTimer invalidate];
    [timerRecode invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    return ;
}

- (void) amrControllerHelperDidEndRecoderAudioWithLength:(NSTimeInterval)length
{
    if (isSuccessAmrRecoded)
    {
        NSData *amrFileDate = [NSData dataWithContentsOfFile:[[C_AmrControllerHelper ShareAmrControllerHelper] RecoderFilePath]];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(ayaKeyBoard:willFinishInputAmrData:timeLen:)])
        {
            [self.delegate ayaKeyBoard:self willFinishInputAmrData:amrFileDate timeLen:length];
        }
    }
    else
    {
        
    }
}

@end
