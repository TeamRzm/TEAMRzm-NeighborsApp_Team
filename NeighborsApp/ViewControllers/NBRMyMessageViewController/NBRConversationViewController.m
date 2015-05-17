//
//  NBRConversationViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/14.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRConversationViewController.h"
#import "NBRChatSettingViewController.h"


#import "MessageEntity.h"
#import "IMUserEntity.h"
#import "MLEmojiLabel.h"
#import "EGOImageView.h"

#import "XGPusher.h"

#import "aya_MultimediaKeyBoard.h"

@interface NBRConversationViewController ()<UITableViewDataSource, UITableViewDelegate,aya_MultimediaKeyBoardDelegate>
{
    NSMutableArray      *messageDateSources;
    IMUserEntity        *owner;
    IMUserEntity        *target;
    UITableView         *boundTableView;
    
    NSMutableParagraphStyle *contentViewStyle;
    
    aya_MultimediaKeyBoard  *keyBoard;
    
    UIButton *hidebutton;
    NSIndexPath *lastindexpath;
    UIImagePickerController *pickview;
    
    UIImageView *contentbgview;
    
    
}
@end

@implementation NBRConversationViewController

#ifdef CONFIG_TEST_DATE
- (void) configTestDate
{
    NSArray *msgArrs = @[
                         @"Hi，你好。",
                         @"我是你的邻居",
                         @"今天物业又来找麻烦了",
                         @"我们的物业真的好差哦！！",
                         @"物业管理费真的有点贵，停车不方便，垃圾臭，保安和工作人员态度也不好。",
                         @"今天有个活动，要不要一起去参加？嘿嘿。"
                         ];
    
    for (int i = 0; i < 10; i++)
    {
        MessageEntity *subMessage = [[MessageEntity alloc] init];
        subMessage.content = msgArrs[rand() % msgArrs.count];
        [messageDateSources addObject:subMessage];
        subMessage.M_LastUpdateTime = [NSDate date];
        subMessage.M_Msg = msgArrs[rand() % msgArrs.count];
        if (i%2==0)
        {
            subMessage.M_From = @"you";
            subMessage.M_To = @"me";
        }
        else
        {
            subMessage.M_From = @"me";
            subMessage.M_To = @"you";
        }
    }
}
#endif

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"邻家小妹";
    // Do any additional setup after loading the view from its nib.
    
    contentbgview = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, kNBR_SCREEN_H-44.0f-154.0f, kNBR_SCREEN_W, 154.0f)];
    [contentbgview setImage:[UIImage imageNamed:@"bg01"]];
    [self.view addSubview:contentbgview];
    
    contentViewStyle = [[NSMutableParagraphStyle alloc] init];
    contentViewStyle.lineHeightMultiple = 1;
    contentViewStyle.lineSpacing = 3.5;
    
    messageDateSources = [[NSMutableArray alloc] init];
    boundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H-44.0f) style:UITableViewStylePlain];
    boundTableView.delegate = self;
    boundTableView.dataSource = self;
    boundTableView.backgroundColor = [UIColor clearColor];
    boundTableView.backgroundView = nil;
    boundTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:boundTableView];
    
    
    //键盘
    keyBoard = [[aya_MultimediaKeyBoard alloc] initWithKeyBoardTypeIsComment:NO];
    keyBoard.backgroundColor = [UIColor whiteColor];
    [keyBoard setDelegate:self];
//    [keyBoard setAlpha:1.0f];
//    [keyBoard setHidden:YES];
    [self.view addSubview:keyBoard];
    
#ifdef CONFIG_TEST_DATE
    [self configTestDate];
#endif
    
    [self NavigationRightItemButtonImage:@"me02"];
    
    [self  selectLastCell];
    
    
   
    
    
}

#pragma mark navigation Method
// 设置右边图标
-(void)  NavigationRightItemButtonImage:(NSString *) imgname;
{
    UIButton *rightbt = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbt setFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f)];
    [rightbt setImage:[UIImage imageNamed:imgname] forState:UIControlStateNormal];
    [rightbt setImage:[UIImage imageNamed:imgname] forState:UIControlStateHighlighted];
    [rightbt addTarget:self action:@selector(NavigatinRightItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithCustomView:rightbt];
    [self.navigationItem setRightBarButtonItem:rightitem];
}

-(void) NavigatinRightItemClicked:(UIButton *) sender
{
    NBRChatSettingViewController *settingview = [[NBRChatSettingViewController alloc] init];
    [self.navigationController pushViewController:settingview animated:YES];
    
}


-(void) selectLastCell
{
    if ([messageDateSources count]>0)
    {
        [boundTableView  scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messageDateSources count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview delegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messageDateSources.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIFont *msgContetFont = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f];
//    MessageEntity *msgEntity = messageDateSources[indexPath.row];
//    
//    
//    
//    CGRect tempRect = [msgEntity.content boundingRectWithSize:CGSizeMake(200.0f, 1000)
//                                                      options:NSStringDrawingUsesLineFragmentOrigin
//                                                   attributes:@{
//                                                                NSFontAttributeName : msgContetFont,
//                                                                NSParagraphStyleAttributeName : contentViewStyle
//                                                                }
//                                                      context:nil];
//    
//    if (tempRect.size.height + 16 <= 43)
//    {
//        return 43 + 30;
//    }
//    else
//    {
//        return tempRect.size.height + 16 + 10 + 30;
//    }
    ChatListCell *cell = (ChatListCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell ReturnCellHeight];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
//    
//    cell.backgroundColor = [UIColor clearColor];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    CGFloat msgContentViewWidth = 200;
//    UIFont *msgContetFont = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f];
//    
//    MessageEntity *msgEntity = messageDateSources[indexPath.row];
//    
//    CGRect tempRect = [msgEntity.content boundingRectWithSize:CGSizeMake(msgContentViewWidth, 1000)
//                                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                                   attributes:@{
//                                                                NSFontAttributeName : msgContetFont,
//                                                                NSParagraphStyleAttributeName : contentViewStyle
//                                                                }
//                                                      context:nil];
//
//    CGFloat cellHeight = [self tableView:tableView heightForRowAtIndexPath:indexPath] - 30;
//    
//    if (indexPath.row % 2 == 0)
//    {
//        //左边消息
//        //头像
//        EGOImageView  *avterView = [[EGOImageView alloc] initWithFrame:CGRectMake(10.0f, cellHeight / 2.0f - 43.0f / 2.0f, 43, 43)];
//        avterView.layer.cornerRadius = avterView.frame.size.height / 2.0f;
//        avterView.layer.masksToBounds = YES;
//        avterView.image = [UIImage imageNamed:@"t_avter_0"];
//        [cell.contentView addSubview:avterView];
//        
//        //消息背景
//        UIImageView *msgContentBgView = [[UIImageView alloc] initWithFrame:CGRectMake(63,
//                                                                                      cellHeight / 2.0f - (tempRect.size.height + 16) / 2.0f,
//                                                                                      tempRect.size.width + 16,
//                                                                                      tempRect.size.height + 16)];
//        
//        msgContentBgView.image = [[UIImage imageNamed:@"leftMessageBox"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 20, 10, 10)];
//        [cell.contentView addSubview:msgContentBgView];
//        
//        //消息内容
//        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:msgEntity.content];
//        
//        [attString addAttributes:@{
//                                   NSFontAttributeName : msgContetFont,
//                                   NSParagraphStyleAttributeName : contentViewStyle
//                                   }
//                           range:NSMakeRange(0, msgEntity.content.length)];
//        
//        
//        UILabel *msgContentLable = [[UILabel alloc] initWithFrame:CGRectMake(8,
//                                                                             8,
//                                                                             tempRect.size.width,
//                                                                             tempRect.size.height)];
//        
//        msgContentLable.numberOfLines = 0;
//        msgContentLable.font = msgContetFont;
//        msgContentLable.textColor = kNBR_ProjectColor_DeepBlack;
//        msgContentLable.attributedText = attString;
//        
//        [msgContentBgView addSubview:msgContentLable];
//    }
//    else
//    {
//        //右边消息
//        //头像
//        EGOImageView  *avterView = [[EGOImageView alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W - 10 - 43, cellHeight / 2.0f - 43.0f / 2.0f, 43, 43)];
//        avterView.layer.cornerRadius = avterView.frame.size.height / 2.0f;
//        avterView.layer.masksToBounds = YES;
//        avterView.image = [UIImage imageNamed:@"t_avter_2"];
//        [cell.contentView addSubview:avterView];
//        
//        //消息背景
//        UIImageView *msgContentBgView = [[UIImageView alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W - 63 - tempRect.size.width - 16,
//                                                                                      cellHeight / 2.0f - (tempRect.size.height + 16) / 2.0f,
//                                                                                      tempRect.size.width + 16,
//                                                                                      tempRect.size.height + 16)];
//        
//        msgContentBgView.image = [[UIImage imageNamed:@"rightMessageBox"] resizableImageWithCapInsets:UIEdgeInsetsMake(14.0f, 3.5f, 15.0f, 17)];
//        [cell.contentView addSubview:msgContentBgView];
//        
//        //消息内容
//        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:msgEntity.content];
//        [attString addAttributes:@{
//                                   NSFontAttributeName : msgContetFont,
//                                   NSParagraphStyleAttributeName : contentViewStyle
//                                   }
//                           range:NSMakeRange(0, msgEntity.content.length)];
//        
//        UILabel *msgContentLable = [[UILabel alloc] initWithFrame:CGRectMake(7, 7, tempRect.size.width, tempRect.size.height)];
//        msgContentLable.numberOfLines = 0;
//        msgContentLable.font = msgContetFont;
//        msgContentLable.textColor = kNBR_ProjectColor_DeepBlack;
//        msgContentLable.attributedText = attString;
//
//        [msgContentBgView addSubview:msgContentLable];
//    }
    
    static NSString *CellIdentifier     =   @"ChatRightCell";
    static NSString *CellIdentifier1    =   @"ChatLeftCell";
    
    MessageEntity *enity=[messageDateSources objectAtIndex:indexPath.row];
    
    if([enity.M_From isEqualToString:@"me"])
    {
        ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell    =[[ChatListCell alloc]initRightCellUnitWithModel:enity className:CellIdentifier Withdelegate:self];
        }
        
        [cell configRightCellUnitWithModel:enity className:CellIdentifier];
        cell.backgroundColor=[UIColor clearColor];
        return cell;
    }
    else
    {
        ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil)
        {
            cell   =[[ChatListCell alloc]initCellUnitWithModel:enity className:CellIdentifier1 Withdelegate:self];
        }
        [cell configCellUnitWithModel:enity className:CellIdentifier1];
        cell.backgroundColor=[UIColor clearColor];
        
        return cell;
    }

    
//    return cell;
}


#pragma mark KeyBoardDelegate
#pragma mark keyboarddelegate
-(void)ayaKeyBoard:(aya_MultimediaKeyBoard *)_keyboard quikLookImg:(UIImage *)_limg
{
    
}

-(void)ayaKeyBoard:(aya_MultimediaKeyBoard *)_keyboard willChangedKeyBoardStatus:(KEYBOARD_STATUS)_status currKeyboardHeight:(CGFloat)_height
{
    
    if (_status == KEYBOARD_STATUS_TEXT || _status == KEYBOARD_STATUS_FACE || _status == KEYBOARD_STATUS_OTHER )
    {
        [UIView animateWithDuration:0.25 animations:^{
            
            
            [boundTableView setFrame:CGRectMake(0.0f,-_height+44.0f, boundTableView.frame.size.width, kNBR_SCREEN_H-45.0f)];
        }];
        [self  selectLastCell];
        if (hidebutton)
        {
            [hidebutton removeFromSuperview];
        }
        hidebutton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, kNBR_SCREEN_H-_height-60.0f)];
        [hidebutton setBackgroundColor:[UIColor clearColor]];
        [hidebutton addTarget:self action:@selector(HideKeyboard) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:hidebutton];
        [self.view bringSubviewToFront:keyBoard];
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^
         {
             
             [boundTableView setFrame:CGRectMake(boundTableView.frame.origin.x, 0.0, boundTableView.frame.size.width, kNBR_SCREEN_H-45.0f)];
             
             [self selectLastCell];
         }];
        if (hidebutton)
        {
            [hidebutton removeFromSuperview];
            hidebutton = nil;
        }
        
        
    }
    
}

-(void)ayaKeyBoard:(aya_MultimediaKeyBoard *)_keyboard willFinishInputAmrData:(NSData *)_amrStrame timeLen:(NSTimeInterval)_timeLen
{
    MessageEntity *enity =[[MessageEntity alloc]init];
    enity.M_Status =    @"Sended";
    
    enity.M_Msg =[NSString stringWithFormat:@"[voice]%@,%.0f[/voice]",@"",_timeLen];
    enity.M_From=@"me";
    enity.M_To  =@"you";
    NSDateFormatter *ft1 = [[NSDateFormatter alloc] init];
    [ft1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [ft1 setDoesRelativeDateFormatting:YES];
    [ft1 setDateStyle:NSDateFormatterShortStyle];
    [ft1 setTimeStyle:NSDateFormatterNoStyle];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: [NSDate date]];
    
    NSDate *localeDate = [[NSDate date]  dateByAddingTimeInterval: interval];
    
    enity.M_LastUpdateTime=localeDate;
    enity.M_Owner=@"me";
    
    [messageDateSources addObject:enity];
    lastindexpath = [NSIndexPath indexPathForRow:[messageDateSources count]-1 inSection:0];
    [boundTableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:lastindexpath, nil] withRowAnimation:UITableViewRowAnimationNone];
    [self selectLastCell];
    
}
-(void)ayaKeyBoard:(aya_MultimediaKeyBoard *)_keyboard willFinishInputMsg:(NSString *)_string
{
    MessageEntity *enity =[[MessageEntity alloc]init];
    enity.M_Status =    @"Sended";
    enity.M_Msg = _string;
    enity.M_From=@"me";
    enity.M_To  =@"you";
    NSDateFormatter *ft1 = [[NSDateFormatter alloc] init];
    [ft1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [ft1 setDoesRelativeDateFormatting:YES];
    [ft1 setDateStyle:NSDateFormatterShortStyle];
    [ft1 setTimeStyle:NSDateFormatterNoStyle];
    
//    MessageEntity *subMessage = [[MessageEntity alloc] init];
//    subMessage.content = _string;
//    
//    [messageDateSources addObject:subMessage];
//    
//    [boundTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:messageDateSources.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//    
//    [boundTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:messageDateSources.count-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
    [messageDateSources addObject:enity];
    lastindexpath = [NSIndexPath indexPathForRow:[messageDateSources count]-1 inSection:0];
    [boundTableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:lastindexpath, nil] withRowAnimation:UITableViewRowAnimationNone];
    
    [self selectLastCell];
    
}
-(void)ayaKeyBoard:(aya_MultimediaKeyBoard *)_keyboard willSelectOtherBoardIndex:(NSInteger)_index
{
    switch (_index)
    {
        case 0:
        {
            if(pickview == nil)
            {
                pickview = [[UIImagePickerController alloc] init];
                
                [pickview setDelegate:self];
            }
            if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"当前设备无法拍照" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
                return ;
            }
            [pickview setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self presentViewController:pickview animated:YES completion:nil];        }
            break;
        case 1:
        {
            if(pickview == nil)
            {
                pickview = [[UIImagePickerController alloc] init];
                [pickview setDelegate:self];
            }
            [pickview setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [self presentViewController:pickview animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
    
}

-(void) HideKeyboard
{
    [keyBoard hidekeyboardview];
    [hidebutton removeFromSuperview];
    hidebutton = nil;
}

#pragma mark UIImagePickerController  delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"])
    {
        UIImage *temimage = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage * originImage= [self compressImageWith:temimage width:kNBR_SCREEN_W height:kNBR_SCREEN_H];
        
        MessageEntity *enity =[[MessageEntity alloc]init];
        enity.M_Status =    @"Sended";
        enity.M_Msg =[NSString stringWithFormat:@"[img]%@[/img]",@"t_avter_4,50X50"];
        enity.M_From=@"me";
        enity.M_To  =@"you";
        NSDateFormatter *ft1 = [[NSDateFormatter alloc] init];
        [ft1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [ft1 setDoesRelativeDateFormatting:YES];
        [ft1 setDateStyle:NSDateFormatterShortStyle];
        [ft1 setTimeStyle:NSDateFormatterNoStyle];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: [NSDate date]];
        NSDate *localeDate = [[NSDate date]  dateByAddingTimeInterval: interval];
        enity.M_LastUpdateTime=localeDate;
        enity.M_Owner=@"me";
        [messageDateSources addObject:enity];
        
        lastindexpath = [NSIndexPath indexPathForRow:[messageDateSources count]-1 inSection:0];
        
        [boundTableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:lastindexpath, nil] withRowAnimation:UITableViewRowAnimationNone];
        
        [self selectLastCell];
        
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    return;
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIImage *)compressImageWith:(UIImage *)image width:(float)width height:(float)height
{
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    
    float widthScale = imageWidth /640;
    float heightScale = imageHeight;
    float newwidth = imageWidth;
    if (imageWidth >= 640)
    {
        newwidth = 640.0f;
        heightScale = imageHeight / widthScale;
    }
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(newwidth, heightScale));
    
    [image drawInRect:CGRectMake(0, 0, newwidth , heightScale)];
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
    
}


- (void) dealloc
{
    return;
}


@end
