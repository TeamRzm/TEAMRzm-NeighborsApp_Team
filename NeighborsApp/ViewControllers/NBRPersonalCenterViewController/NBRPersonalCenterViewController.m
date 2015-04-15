//
//  NBRPersonalCenterViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/3/26.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRPersonalCenterViewController.h"
#import "EGOImageView.h"

@interface NBRPersonalCenterViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView     *boundTableView;
    
    UIView          *tableViewHeadView;
    
    EGOImageView    *avterImageView;
    UILabel         *nikeNameLable;
    UILabel         *sorceLable;
    
    //顶部三个按钮，里手去帮，我的活动，安全预警
    UIButton        *tableViewHeadViewButtons[3];
    NSString        *tableViewHeadViewTitle[3];
    NSString        *tableViewHeadViewIconImg[3];
    
    
    //TableViewCellDateSource
    NSArray         *boundTableViewDateSource;
}
@end

@implementation NBRPersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    boundTableViewDateSource = @[
                                 @[
                                     @{@"Title" : @"小区认证",
                                       @"Icon"  : @"me01"},
                                     
                                     @{@"Title" : @"好友分享",
                                       @"Icon"  : @"me02"},
                                     
                                     @{@"Title" : @"意见反馈",
                                       @"Icon"  : @"me03"}
                                     ],
                                 @[
                                     @{@"Title" : @"个性设置",
                                       @"Icon"  : @"me04"},
                                     ],
                                 
                                 @[
                                     @{@"Title" : @"版本检测",
                                       @"Icon"  : @"me05"},
                                     
                                     @{@"Title" : @"免责声明",
                                       @"Icon"  : @"me06"},
                                     
                                     @{@"Title" : @"关于我们",
                                       @"Icon"  : @"me07"},
                                     ]
                                 ];
    
    
    boundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H) style:UITableViewStyleGrouped];
    boundTableView.delegate = self;
    boundTableView.dataSource = self;
    [self.view addSubview:boundTableView];
    
    //HeadView
    tableViewHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, 79.0f + 40.0f)];
    tableViewHeadView.backgroundColor = kNBR_ProjectColor_StandBlue;
    
    //顶部三个按钮
    tableViewHeadViewTitle[0] = @"          里手帮";
    tableViewHeadViewTitle[1] = @"         我的活动";
    tableViewHeadViewTitle[2] = @"         安全预警";
    
    tableViewHeadViewIconImg[0] = @"lishoubang";
    tableViewHeadViewIconImg[1] = @"menhuodong";
    tableViewHeadViewIconImg[2] = @"yujing";
    
    CGFloat buttonFixX[3] = {20,16,16};
    
    for (int i = 0; i < 3; i++)
    {
        tableViewHeadViewButtons[i] = [UIButton buttonWithType:UIButtonTypeCustom];
        tableViewHeadViewButtons[i].frame = CGRectMake(kNBR_SCREEN_W / 3.0f * i, 79.0f, kNBR_SCREEN_W / 3.0f, 40.0f);
        tableViewHeadViewButtons[i].backgroundColor = UIColorFromRGB(0xFFFFFF);
        tableViewHeadViewButtons[i].titleLabel.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:12.0f];
        [tableViewHeadViewButtons[i] setTitleColor:kNBR_ProjectColor_StandBlue forState:UIControlStateNormal];
        [tableViewHeadViewButtons[i] setTitle:tableViewHeadViewTitle[i] forState:UIControlStateNormal];
        
        UIImage *iconImg = [UIImage imageNamed:tableViewHeadViewIconImg[i]];
        UIImageView *iconView = [[UIImageView alloc] initWithImage:iconImg];
        [iconView addTopTagNumberView:@"9" fixOrigin:CGPointMake(1, -8.0f)];
        iconView.frame = CGRectMake(buttonFixX[i], 40.0f / 2.0f - iconImg.size.height / 2.0f, iconImg.size.width, iconImg.size.height);
        [tableViewHeadViewButtons[i] addSubview:iconView];
        
        [tableViewHeadView addSubview:tableViewHeadViewButtons[i]];
    }
    
    //头像
    avterImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"t_avter_9"]];
    avterImageView.layer.cornerRadius = 3.0f;
    avterImageView.layer.masksToBounds = YES;
    avterImageView.frame = CGRectMake(10, 79 / 2.0f - 50.0f / 2.0f, 50, 50);
    [tableViewHeadView addSubview:avterImageView];
    
    //昵称
    nikeNameLable = [[UILabel alloc] initWithFrame:CGRectMake(75.0f, avterImageView.frame.origin.y + 5, kNBR_SCREEN_W - 75 - 10, 20)];
    nikeNameLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.0f];
    nikeNameLable.textColor = UIColorFromRGB(0xFFFFFF);
    nikeNameLable.text = @"邻家小妹";
    [tableViewHeadView addSubview:nikeNameLable];
    
    //积分
    sorceLable = [[UILabel alloc] initWithFrame:CGRectMake(75.0f, avterImageView.frame.origin.y + 5 + 22, kNBR_SCREEN_W - 75 - 10, 20)];
    sorceLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:10.0f];
    sorceLable.textColor = UIColorFromRGB(0xFFFFFF);
    sorceLable.text = @"积分 21024";
    [tableViewHeadView addSubview:sorceLable];
    
    //4个分割线装饰按钮
    UIView *breakLineTop = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 79.0f, kNBR_SCREEN_W, 0.5)];
    UIView *breakLineBottom = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 79.0f + 40, kNBR_SCREEN_W, 0.5)];
    UIView *breakLineContent1 = [[UIView alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W / 3.0f * 0, 79.0f, 0.5, 40.0f)];
    UIView *breakLineContent2 = [[UIView alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W / 3.0f * 1, 79.0f, 0.5, 40.0f)];
    UIView *breakLineContent3 = [[UIView alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W / 3.0f * 2, 79.0f, 0.5, 40.0f)];
    UIView *breakLineContent4 = [[UIView alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W / 3.0f * 3, 79.0f, 0.5, 40.0f)];
    
    breakLineTop.backgroundColor = kNBR_ProjectColor_LightGray;
    breakLineBottom.backgroundColor = kNBR_ProjectColor_LightGray;
    breakLineContent1.backgroundColor = kNBR_ProjectColor_LightGray;
    breakLineContent2.backgroundColor = kNBR_ProjectColor_LightGray;
    breakLineContent3.backgroundColor = kNBR_ProjectColor_LightGray;
    breakLineContent4.backgroundColor = kNBR_ProjectColor_LightGray;
    
    [tableViewHeadView addSubview:breakLineTop];
    [tableViewHeadView addSubview:breakLineBottom];
    [tableViewHeadView addSubview:breakLineContent1];
    [tableViewHeadView addSubview:breakLineContent2];
    [tableViewHeadView addSubview:breakLineContent3];
    [tableViewHeadView addSubview:breakLineContent4];
    
    boundTableView.tableHeaderView = tableViewHeadView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 10.0f;
    }
    else
    {
        return 5.0f;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0f;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return boundTableViewDateSource.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray*)boundTableViewDateSource[section]).count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary *cellDict = boundTableViewDateSource[indexPath.section][indexPath.row];
    
    UIImage *iconImg = [UIImage imageNamed:cellDict[@"Icon"]];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40.0f / 2.0f - iconImg.size.height / 2.0f, iconImg.size.width, iconImg.size.height)];
    iconImageView.image = iconImg;

    UILabel *titileLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImageView.frame.origin.x + iconImageView.frame.size.width + 10.0f, 0, kNBR_SCREEN_W - iconImageView.frame.size.width + 10 * 2, 40.0f)];
    titileLabel.text = cellDict[@"Title"];
    titileLabel.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13.0f];
    titileLabel.textColor = kNBR_ProjectColor_DeepBlack;
    
    [cell.contentView addSubview:iconImageView];
    [cell.contentView addSubview:titileLabel];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellDict = boundTableViewDateSource[indexPath.section][indexPath.row];
    [self showBannerMsgWithString:[NSString stringWithFormat:@"\"%@\"模块，即将推出,敬请期待。",cellDict[@"Title"]]];
}

@end
