//
//  NBRMyMessageViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/3/26.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRMyMessageViewController.h"
#import "NBRLoginViewController.h"
#import "NBRConversationViewController.h"
#import "NBRFriendInfoViewController.h"
#import "NBRFriendApplyViewController.h"
#import "NBRCommunityNoticeViewController.h"


#import "IMUserEntity.h"
#import "MessageEntity.h"
#import "ConversationEntity.h"

#import "CreaterRequest_User.h"


@interface NBRMyMessageViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UIScrollView        *boundScrollView;
    UITableView         *leftTableView;
    UITableView         *rightTableView;
    
    //页面中切换我的消息，我的邻居使用的视图
    UIView              *segmentChangedView;
    UILabel             *leftChagnedLable;
    UILabel             *rightChangedLabel;
    UIView              *selectTagView;
    
    NSMutableArray      *leftTableViewDateSource;
    NSMutableArray      *rightTableViewDateSource;
    
    ASIHTTPRequest      *friendListReq;
    
    
#ifdef CONFIG_TEST_DATE
    NSMutableArray  *testUsers;
    NSMutableArray *testMessagees;
#endif
}

@end

@implementation NBRMyMessageViewController

#ifdef CONFIG_TEST_DATE
- (void) initTestDate
{
    NSInteger testDateCount = 10;
    
    //测试数据4个用户
    NSArray *testUserName    = @[@"八戒",@"悟空",@"白龙马",@"皇上",@"张三",@"李四",@"Alex",@"Well",@"妹子",@"帅哥"];
    
    testUsers = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < testDateCount; i++)
    {
        IMUserEntity *newUser = [[IMUserEntity alloc] init];
        newUser.avterUrl = [@"" stringByAppendingFormat:@"t_avter_%d",i];
        newUser.nickName = testUserName[i];
        [testUsers addObject:newUser];
    }
    
    NSArray *testMsgContents = @[@"今天物业气死我，真拿他们没办法。很郁闷。",
                                 @"物业管理费太贵了，真没良心",
                                 @"昨天又没有找到车位，那么多车物业那边也不说处理一下",
                                 @"态度真差，到底我们是业主还是他们是业主？"];
    
    //4条消息，用于建立会话
    testMessagees = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < testDateCount; i++)
    {
        MessageEntity *newEntity = [[MessageEntity alloc] init];
        newEntity.content = testMsgContents[rand() % testMsgContents.count];
        newEntity.from = testUsers[i];
        [testMessagees addObject:newEntity];
    }
    
    
    //4建立测试会话
    for (int i = 0; i < testDateCount; i++)
    {
        ConversationEntity *newEntity = [[ConversationEntity alloc] init];
        newEntity.lastMessage = testMessagees[i];
        [leftTableViewDateSource addObject:newEntity];
    }
    
//    rightTableViewDateSource = [[NSMutableArray alloc] initWithArray:@[
//                                                                      @{@"新家园小区"     : @[
//                                                                                leftTableViewDateSource[0],
//                                                                                leftTableViewDateSource[1],
//                                                                                leftTableViewDateSource[2],
//                                                                                leftTableViewDateSource[3]]
//                                                                        },
//                                                                      
//                                                                      @{@"米兰春天"      : @[
//                                                                                leftTableViewDateSource[4],
//                                                                                leftTableViewDateSource[5],
//                                                                                leftTableViewDateSource[6],
//                                                                                leftTableViewDateSource[7]]
//                                                                        },
//                                                                      
//                                                                      @{@"湘江世纪城小区" : @[
//                                                                                leftTableViewDateSource[4],
//                                                                                leftTableViewDateSource[5],
//                                                                                leftTableViewDateSource[6],
//                                                                                leftTableViewDateSource[7]]
//                                                                        },
//                                                                      ]];
    
}
#endif

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    leftTableViewDateSource     = [[NSMutableArray alloc] init];
    rightTableViewDateSource    = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = kNBR_ProjectColor_BackGroundGray;
    
#ifdef CONFIG_TEST_DATE
    [self initTestDate];
#endif
    
    segmentChangedView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kNBR_SCREEN_W, 40.0f)];
    
    UIView *breakLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, kNBR_SCREEN_W, 1.0f)];
    breakLineView.backgroundColor = UIColorFromRGB(0xCBD3DB);
    
    selectTagView = [[UIView alloc] initWithFrame:CGRectMake(0, 38.0f, kNBR_SCREEN_W / 2.0f, 2.0f)];
    selectTagView.backgroundColor = kNBR_ProjectColor_StandBlue;
    
    leftChagnedLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W / 2.0f, 40.0f)];
    leftChagnedLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:14.0f];
    leftChagnedLable.textAlignment = NSTextAlignmentCenter;
    leftChagnedLable.textColor = kNBR_ProjectColor_DeepGray;
    leftChagnedLable.backgroundColor = kNBR_ProjectColor_BackGroundGray;
    leftChagnedLable.text = @"我的消息";
    leftChagnedLable.userInteractionEnabled = YES;
    UITapGestureRecognizer *leftChangedGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftMenuChangedAction:)];
    [leftChagnedLable addGestureRecognizer:leftChangedGesture];
    
    rightChangedLabel = [[UILabel alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W / 2.0f, 0, kNBR_SCREEN_W / 2.0f, 40.0f)];
    rightChangedLabel.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:14.0f];
    rightChangedLabel.textAlignment = NSTextAlignmentCenter;
    rightChangedLabel.textColor = kNBR_ProjectColor_DeepGray;
    rightChangedLabel.backgroundColor = kNBR_ProjectColor_BackGroundGray;
    rightChangedLabel.text = @"我的邻居";
    rightChangedLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *rightChangedGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightMenuChangedAction:)];
    [rightChangedLabel addGestureRecognizer:rightChangedGesture];
    
    [segmentChangedView addSubview:leftChagnedLable];
    [segmentChangedView addSubview:rightChangedLabel];
    [segmentChangedView addSubview:breakLineView];
    [segmentChangedView addSubview:selectTagView];
    
    //容器
    boundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + 40, kNBR_SCREEN_W, kNBR_SCREEN_H - 64 - 40 - 49)];
    boundScrollView.contentSize = CGSizeMake(kNBR_SCREEN_W * 2.0f, kNBR_SCREEN_H);
    boundScrollView.scrollEnabled = NO;
    boundScrollView.showsHorizontalScrollIndicator = NO;
    boundScrollView.pagingEnabled = YES;
    
    //我的消息
    leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H - 64 - 40 - 49) style:UITableViewStyleGrouped];
    leftTableView.backgroundColor = kNBR_ProjectColor_BackGroundGray;
    leftTableView.delegate = self;
    leftTableView.dataSource = self;
    
    //我的邻居
    rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W, 0, kNBR_SCREEN_W, kNBR_SCREEN_H - 64 - 40 - 49) style:UITableViewStylePlain];
    rightTableView.backgroundColor = kNBR_ProjectColor_BackGroundGray;
    rightTableView.delegate = self;
    rightTableView.dataSource = self;
    
    [boundScrollView addSubview:leftTableView];
    [boundScrollView addSubview:rightTableView];
    
    [self.view addSubview:segmentChangedView];
    [self.view addSubview:boundScrollView];
    
    [self LoadMyFriendsList];
    
}

#pragma mark  Data Mehtod
-(void) LoadMyFriendsList
{
    UserEntity *userEntity = [AppSessionMrg shareInstance].userEntity ;
    friendListReq = [CreaterRequest_User CreateUserFriendGetRequestWithPhone:userEntity.userName];
    __weak ASIHTTPRequest *blockSelf = friendListReq;
    
    [blockSelf setCompletionBlock:^{
        NSDictionary *reponseDict = blockSelf.responseString.JSONValue;
        [self removeLoadingView];
        
        if ([CreaterRequest_User CheckErrorResponse:reponseDict errorAlertInViewController:self])
        {
            rightTableViewDateSource = (NSMutableArray *)[reponseDict arrayWithKeyPath:@"data\\result"];
            [rightTableView reloadData];

        }
    }];
    
    [self setDefaultRequestFaild:blockSelf];
    
    [self addLoadingView];
    [friendListReq startAsynchronous];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) leftMenuChangedAction : (id) sender
{
    //切换到我的消息
    [boundScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [UIView animateWithDuration:.25f animations:^{
        selectTagView.frame = CGRectMake(0, 38.0f, kNBR_SCREEN_W / 2.0f, 2.0f);
    }];

}

- (void) rightMenuChangedAction : (id) sender
{
    //切换到我的邻居
    [boundScrollView setContentOffset:CGPointMake(kNBR_SCREEN_W, 0) animated:YES];
    [UIView animateWithDuration:.25f animations:^{
        selectTagView.frame = CGRectMake(kNBR_SCREEN_W / 2.0f, 38.0f, kNBR_SCREEN_W / 2.0f, 2.0f);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark UITabelViewDelegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == leftTableView)
    {
        return 1;
    }
    else if (tableView == rightTableView)
    {
        return rightTableViewDateSource.count;
    }
    
    return 1.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == leftTableView)
    {
        return 0.1f;
    }
    else if (tableView == rightTableView)
    {
        return 35.0f;
    }
    
    return 0.0f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == leftTableView)
    {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    
    NSDictionary *sectionDictory = rightTableViewDateSource[section];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, 35.0f)];
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 35.0f / 2.0f - 18.5f / 2.0f, 14, 18.5)];
    iconView.image = [UIImage imageNamed:@"xiaoQuAddressIcon"];
    headerView.backgroundColor = kNBR_ProjectColor_BackGroundGray;
    [headerView addSubview:iconView];
    
    UILabel *sectionTitleView = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, kNBR_SCREEN_W - 30.0f, 35.0f)];
    sectionTitleView.text = sectionDictory[@"villageName"];
    sectionTitleView.textColor = UIColorFromRGB(0x2283CA);
    sectionTitleView.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.0f];
    [headerView addSubview:sectionTitleView];
    
    return headerView;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == leftTableView)
    {
        return leftTableViewDateSource.count;
    }
    else if (tableView == rightTableView)
    {
        return [rightTableViewDateSource[section][@"members"] count];
    }
    
    return 1;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.0f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (tableView == leftTableView)
    {
        ConversationEntity *subConversation = leftTableViewDateSource[indexPath.row];
    
        //头像
        EGOImageView *avterImgView = [[EGOImageView alloc] initWithPlaceholderImage: [UIImage imageNamed:subConversation.lastMessage.from.avterUrl]];
        avterImgView.frame = CGRectMake(10.0f, 56 / 2.0f - 43 / 2.0f, 43, 43);
        avterImgView.layer.cornerRadius = avterImgView.frame.size.width / 2.0f;
        avterImgView.layer.masksToBounds = YES;
        [cell.contentView addSubview:avterImgView];
        
        avterImgView.tag = indexPath.row;
        [avterImgView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AvterImageClicked:)];
        [avterImgView addGestureRecognizer:gesture];
        
        
        UIView *tagView = [UIView CreateTopTagNumberView:[NSString stringWithFormat:@"%d",rand() % 5 + 1]];
        tagView.frame = CGRectMake(10.0f + 10 + 43 - 21, 56 / 2.0f - 43 / 2.0f, 15.0f, 15.0f);
        [cell.contentView addSubview:tagView];
        
        //标题
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(68.0f,
                                                                        11,
                                                                        kNBR_SCREEN_W - 68.0f - 10,
                                                                        15)];
        titleLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.0f];
        titleLable.textColor = kNBR_ProjectColor_DeepGray;
        titleLable.text = subConversation.lastMessage.from.nickName;
        
        //内容
        UILabel *contentLable = [[UILabel alloc] initWithFrame:CGRectMake(68.0f,
                                                                          33,
                                                                          kNBR_SCREEN_W - 68.0f - 10,
                                                                          10)];
        contentLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:12.0f];
        contentLable.textColor = UIColorFromRGB(0x999999);
        contentLable.text = subConversation.lastMessage.content;
        
        
        //接收时间
        UILabel *revieTimeLable = [[UILabel alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W - 70 - 10, 12, 70, 15)];
        revieTimeLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:12.0f];
        revieTimeLable.textAlignment = NSTextAlignmentRight;
        revieTimeLable.backgroundColor = [UIColor clearColor];
        revieTimeLable.textColor = UIColorFromRGB(0x999999);
        revieTimeLable.text = @"刚刚";
        
        [cell.contentView addSubview:titleLable];
        [cell.contentView addSubview:contentLable];
        [cell.contentView addSubview:revieTimeLable];
    }
    else if (tableView == rightTableView)
    {
        NSDictionary *sectionDictory = rightTableViewDateSource[indexPath.section];
        
        ConversationEntity *subConversation = sectionDictory.allValues[0][indexPath.row];
        
        //头像
        EGOImageView *avterImgView = [[EGOImageView alloc] initWithPlaceholderImage: [UIImage imageNamed:subConversation.lastMessage.from.avterUrl]];
        avterImgView.frame = CGRectMake(10.0f, 56 / 2.0f - 43 / 2.0f, 43, 43);
        avterImgView.layer.cornerRadius = avterImgView.frame.size.width / 2.0f;
        avterImgView.layer.masksToBounds = YES;
        [cell.contentView addSubview:avterImgView];
        avterImgView.tag = indexPath.row;
        [avterImgView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AvterImageClicked:)];
        [avterImgView addGestureRecognizer:gesture];

        
        //标题
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(68.0f,
                                                                        0,
                                                                        kNBR_SCREEN_W - 68.0f - 10,
                                                                        56.0f)];
        titleLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:15.0f];
        titleLable.textColor = kNBR_ProjectColor_DeepGray;
        titleLable.text = subConversation.lastMessage.from.nickName;

        [cell.contentView addSubview:avterImgView];
        [cell.contentView addSubview:titleLable];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == leftTableView)
    {
        if (indexPath.row == 0)
        {
            NBRCommunityNoticeViewController *notice = [[NBRCommunityNoticeViewController alloc] init];
            [notice setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:notice animated:YES];
            
        }
        else if(indexPath.row == 1)
        {
            NBRFriendApplyViewController *applyview = [[NBRFriendApplyViewController alloc] init];
            [applyview setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:applyview animated:YES];
        }
        else
        {
            NBRConversationViewController *nVC = [[NBRConversationViewController alloc] initWithNibName:@"NBRConversationViewController" bundle:nil];
            nVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:nVC animated:YES];
        }
    }
    else
    {
        NBRConversationViewController *nVC = [[NBRConversationViewController alloc] initWithNibName:@"NBRConversationViewController" bundle:nil];
        nVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:nVC animated:YES];
    }
}

#pragma mark Gesture Method

-(void) AvterImageClicked:(UITapGestureRecognizer *) _gesture
{
    NBRFriendInfoViewController *infoview = [[NBRFriendInfoViewController alloc] init];
    [infoview setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:infoview animated:YES];
    
}
@end
