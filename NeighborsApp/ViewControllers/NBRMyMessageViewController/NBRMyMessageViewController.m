//
//  NBRMyMessageViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/3/26.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRMyMessageViewController.h"
#import "NBRLoginViewController.h"

#import "IMUserEntity.h"
#import "MessageEntity.h"
#import "ConversationEntity.h"

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
    
    NSInteger           segmentIndex;
    
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
}
#endif

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    leftTableViewDateSource     = [[NSMutableArray alloc] init];
    rightTableViewDateSource    = [[NSMutableArray alloc] init];
    
    segmentIndex = 0;
    
    self.view.backgroundColor = kNBR_ProjectColor_BackGroundGray;
    
#ifdef CONFIG_TEST_DATE
    [self initTestDate];
#endif
    
    segmentChangedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, 40.0f)];
    
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
    
    rightChangedLabel = [[UILabel alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W / 2.0f, 0, kNBR_SCREEN_W / 2.0f, 40.0f)];
    rightChangedLabel.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:14.0f];
    rightChangedLabel.textAlignment = NSTextAlignmentCenter;
    rightChangedLabel.textColor = kNBR_ProjectColor_DeepGray;
    rightChangedLabel.backgroundColor = kNBR_ProjectColor_BackGroundGray;
    rightChangedLabel.text = @"我的邻居";
    
    [segmentChangedView addSubview:leftChagnedLable];
    [segmentChangedView addSubview:rightChangedLabel];
    [segmentChangedView addSubview:breakLineView];
    [segmentChangedView addSubview:selectTagView];
    
    //容器
    boundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W * 2.0f, kNBR_SCREEN_H)];
    
    //我的消息
    leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40.0f, kNBR_SCREEN_W, kNBR_SCREEN_H - 40.0f - 49 - 25) style:UITableViewStyleGrouped];
    leftTableView.backgroundColor = kNBR_ProjectColor_BackGroundGray;
    leftTableView.delegate = self;
    leftTableView.dataSource = self;
    
    //我的邻居
    rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W, 40.0f, kNBR_SCREEN_W, kNBR_SCREEN_H - 40.0f - 49 - 25) style:UITableViewStyleGrouped];
    rightTableView.backgroundColor = kNBR_ProjectColor_BackGroundGray;
    rightTableView.delegate = self;
    rightTableView.dataSource = self;
    
    [boundScrollView addSubview:segmentChangedView];
    [boundScrollView addSubview:leftTableView];
    [boundScrollView addSubview:rightTableView];
    
    [self.view addSubview:boundScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)leftBarButtonItemActions:(id)sender
{
    NBRLoginViewController *nVC = [[NBRLoginViewController alloc] initWithNibName:@"NBRLoginViewController" bundle:nil];
    
    UINavigationController *nNavVC = [[UINavigationController alloc] initWithRootViewController:nVC];
    
    [self.tabBarController presentViewController:nNavVC animated:YES completion:^{
        
    }];
}


#pragma mark UITabelViewDelegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (segmentIndex == 0)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1f;
    }
    
    return 0.0f;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (segmentIndex == 0)
    {
        return leftTableViewDateSource.count;
    }
    else
    {
        return rightTableViewDateSource.count;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.0f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (segmentIndex == 0)
    {
        ConversationEntity *subConversation = leftTableViewDateSource[indexPath.row];
    
        //头像
        EGOImageView *avterImgView = [[EGOImageView alloc] initWithPlaceholderImage: [UIImage imageNamed:subConversation.lastMessage.from.avterUrl]];
        avterImgView.frame = CGRectMake(10.0f, 56 / 2.0f - 43 / 2.0f, 43, 43);
        avterImgView.layer.cornerRadius = avterImgView.frame.size.width / 2.0f;
        avterImgView.layer.masksToBounds = YES;
        [cell.contentView addSubview:avterImgView];
        
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
    
    return cell;
}
@end
