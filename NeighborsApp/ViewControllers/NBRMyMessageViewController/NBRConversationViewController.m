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

#import "aya_MultimediaKeyBoard.h"

@interface NBRConversationViewController ()<UITableViewDataSource, UITableViewDelegate,aya_MultimediaKeyBoardDelegate>
{
    NSMutableArray      *messageDateSources;
    IMUserEntity        *owner;
    IMUserEntity        *target;
    UITableView         *boundTableView;
    
    NSMutableParagraphStyle *contentViewStyle;
    
    aya_MultimediaKeyBoard  *keyBoard;
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
    }
}
#endif

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"邻家小妹";
    // Do any additional setup after loading the view from its nib.
    contentViewStyle = [[NSMutableParagraphStyle alloc] init];
    contentViewStyle.lineHeightMultiple = 1;
    contentViewStyle.lineSpacing = 3.5;
    
    messageDateSources = [[NSMutableArray alloc] init];
    boundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H) style:UITableViewStyleGrouped];
    boundTableView.delegate = self;
    boundTableView.dataSource = self;
    boundTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:boundTableView];
    
    
    //键盘
    keyBoard = [[aya_MultimediaKeyBoard alloc] initWithKeyBoardTypeIsComment:YES];
    keyBoard.backgroundColor = [UIColor whiteColor];
    [keyBoard setDelegate:self];
//    [keyBoard setAlpha:1.0f];
//    [keyBoard setHidden:YES];
    [self.view addSubview:keyBoard];
    
#ifdef CONFIG_TEST_DATE
    [self configTestDate];
#endif
    
    [self NavigationRightItemButtonImage:@"me02"];
    
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    UIFont *msgContetFont = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f];
    MessageEntity *msgEntity = messageDateSources[indexPath.row];
    
    
    
    CGRect tempRect = [msgEntity.content boundingRectWithSize:CGSizeMake(200.0f, 1000)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{
                                                                NSFontAttributeName : msgContetFont,
                                                                NSParagraphStyleAttributeName : contentViewStyle
                                                                }
                                                      context:nil];
    
    if (tempRect.size.height + 16 <= 43)
    {
        return 43 + 30;
    }
    else
    {
        return tempRect.size.height + 16 + 10 + 30;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat msgContentViewWidth = 200;
    UIFont *msgContetFont = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f];
    
    MessageEntity *msgEntity = messageDateSources[indexPath.row];
    
    CGRect tempRect = [msgEntity.content boundingRectWithSize:CGSizeMake(msgContentViewWidth, 1000)
                                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                   attributes:@{
                                                                NSFontAttributeName : msgContetFont,
                                                                NSParagraphStyleAttributeName : contentViewStyle
                                                                }
                                                      context:nil];

    CGFloat cellHeight = [self tableView:tableView heightForRowAtIndexPath:indexPath] - 30;
    
    if (indexPath.row % 2 == 0)
    {
        //左边消息
        //头像
        EGOImageView  *avterView = [[EGOImageView alloc] initWithFrame:CGRectMake(10.0f, cellHeight / 2.0f - 43.0f / 2.0f, 43, 43)];
        avterView.layer.cornerRadius = avterView.frame.size.height / 2.0f;
        avterView.layer.masksToBounds = YES;
        avterView.image = [UIImage imageNamed:@"t_avter_0"];
        [cell.contentView addSubview:avterView];
        
        //消息背景
        UIImageView *msgContentBgView = [[UIImageView alloc] initWithFrame:CGRectMake(63,
                                                                                      cellHeight / 2.0f - (tempRect.size.height + 16) / 2.0f,
                                                                                      tempRect.size.width + 16,
                                                                                      tempRect.size.height + 16)];
        
        msgContentBgView.image = [[UIImage imageNamed:@"leftMessageBox"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 20, 10, 10)];
        [cell.contentView addSubview:msgContentBgView];
        
        //消息内容
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:msgEntity.content];
        
        [attString addAttributes:@{
                                   NSFontAttributeName : msgContetFont,
                                   NSParagraphStyleAttributeName : contentViewStyle
                                   }
                           range:NSMakeRange(0, msgEntity.content.length)];
        
        
        UILabel *msgContentLable = [[UILabel alloc] initWithFrame:CGRectMake(8,
                                                                             8,
                                                                             tempRect.size.width,
                                                                             tempRect.size.height)];
        
        msgContentLable.numberOfLines = 0;
        msgContentLable.font = msgContetFont;
        msgContentLable.textColor = kNBR_ProjectColor_DeepBlack;
        msgContentLable.attributedText = attString;
        
        [msgContentBgView addSubview:msgContentLable];
    }
    else
    {
        //右边消息
        //头像
        EGOImageView  *avterView = [[EGOImageView alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W - 10 - 43, cellHeight / 2.0f - 43.0f / 2.0f, 43, 43)];
        avterView.layer.cornerRadius = avterView.frame.size.height / 2.0f;
        avterView.layer.masksToBounds = YES;
        avterView.image = [UIImage imageNamed:@"t_avter_2"];
        [cell.contentView addSubview:avterView];
        
        //消息背景
        UIImageView *msgContentBgView = [[UIImageView alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W - 63 - tempRect.size.width - 16,
                                                                                      cellHeight / 2.0f - (tempRect.size.height + 16) / 2.0f,
                                                                                      tempRect.size.width + 16,
                                                                                      tempRect.size.height + 16)];
        
        msgContentBgView.image = [[UIImage imageNamed:@"rightMessageBox"] resizableImageWithCapInsets:UIEdgeInsetsMake(14.0f, 3.5f, 15.0f, 17)];
        [cell.contentView addSubview:msgContentBgView];
        
        //消息内容
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:msgEntity.content];
        [attString addAttributes:@{
                                   NSFontAttributeName : msgContetFont,
                                   NSParagraphStyleAttributeName : contentViewStyle
                                   }
                           range:NSMakeRange(0, msgEntity.content.length)];
        
        UILabel *msgContentLable = [[UILabel alloc] initWithFrame:CGRectMake(7, 7, tempRect.size.width, tempRect.size.height)];
        msgContentLable.numberOfLines = 0;
        msgContentLable.font = msgContetFont;
        msgContentLable.textColor = kNBR_ProjectColor_DeepBlack;
        msgContentLable.attributedText = attString;

        [msgContentBgView addSubview:msgContentLable];
    }
    
    
    return cell;
}


#pragma mark KeyBoardDelegate
#pragma mark keyboarddelegate
-(void)ayaKeyBoard:(aya_MultimediaKeyBoard *)_keyboard willChangedKeyBoardStatus:(KEYBOARD_STATUS)_status currKeyboardHeight:(CGFloat)_height
{
    return;
}

-(void)ayaKeyBoard:(aya_MultimediaKeyBoard *)_keyboard willFinishInputAmrData:(NSData *)_amrStrame timeLen:(NSTimeInterval)_timeLen
{
    [keyBoard.inputTextView resignFirstResponder];
    [keyBoard setAlpha:0.0f];
    [keyBoard setHidden:YES];
}

-(void)ayaKeyBoard:(aya_MultimediaKeyBoard *)_keyboard willFinishInputMsg:(NSString *)_string
{
    [keyBoard hidekeyboardview];
    
    MessageEntity *subMessage = [[MessageEntity alloc] init];
    subMessage.content = _string;
    
    [messageDateSources addObject:subMessage];
    
    [boundTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:messageDateSources.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [boundTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:messageDateSources.count-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
//    if (_string.length <= 0 && _keyboard.commentImgDate == nil)
//    {
//        UIAlertView *noInputAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert.Title", @"") message:@"亲，请输入评论内容。" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles: nil];
//        [noInputAlert show];
//        
//        return ;
//    }
}

- (void) ayaKeyBoard:(aya_MultimediaKeyBoard*) _keyboard willSelectOtherBoardIndex : (NSInteger) _index
{
    return ;
}

-(void)ayaKeyBoard:(aya_MultimediaKeyBoard *)_keyboard quikLookImg:(UIImage *)_limg
{
    return ;
}

- (void) dealloc
{
    return;
}


@end
