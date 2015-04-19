//
//  CommitActivityContentViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/19.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CommitActivityContentViewController.h"
#import "UICheckBox.h"

@interface CommitActivityContentViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView     *boundTableView;
    
    NSArray         *cellTitiles;
    NSArray         *cellTextFieldPlaceHolder;
    NSMutableArray  *cellTextFields;
    
    UIView          *tableViewHeaderView;
    
    UICheckBox  *checkBox1;
    UICheckBox  *checkBox2;
    
    UICheckBoxBlock checkBoxBlock1;
    UICheckBoxBlock checkBoxBlock2;
}
@end

@implementation CommitActivityContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发布活动";
    
    cellTitiles = @[
                    @"活动主题",
                    @"活动时间",
                    @"活动地点",
                    @"活动人数",
                    @"活动费用",
                    @"报名日期",
                    @"联系人",
                    @"联系电话",
                    ];
    
    cellTextFieldPlaceHolder = @[
                                 @"请输入活动主题",
                                 @"请输入活动时间",
                                 @"请输入活动地点",
                                 @"请输入活动人数",
                                 @"请输入活动费用",
                                 @"请输入报名日期",
                                 @"请输入联系人",
                                 @"请输入联系电话",
                                 ];
    
    cellTextFields = [[NSMutableArray alloc] init];
    for (int i = 0; i < cellTitiles.count; i++)
    {
        UITextField *subTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(70.0f, 0, kNBR_SCREEN_W - 60 - 10, 40.0f)];
        subTextFiled.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f];
        subTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        subTextFiled.placeholder = cellTextFieldPlaceHolder[i];
        [self setDoneStyleTextFile:subTextFiled];
        
        [cellTextFields addObject:subTextFiled];
    }
    
    boundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H) style:UITableViewStyleGrouped];
    boundTableView.delegate = self;
    boundTableView.dataSource = self;
    [self.view addSubview:boundTableView];
    
    //headerView
    tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, 155)];
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W / 2.0f - (330 * 0.9) / 2.0f, 155 / 2.0f - (150.0f * 0.9) / 2.0f, 330 * 0.9, 150 * 0.9)];
    headImageView.image = [UIImage imageNamed:@"pic03"];
    headImageView.userInteractionEnabled = YES;
    [tableViewHeaderView addSubview:headImageView];
    boundTableView.tableHeaderView = tableViewHeaderView;
    
    
    checkBox1 = [[UICheckBox alloc] initWithFrame:CGRectMake(10, 40.0f / 2.0f - 25.0f / 2.0f, 25, 25)];
    checkBox1.tintColor = kNBR_ProjectColor_StandBlue;
    checkBox1.check = YES;
    
    checkBox2 = [[UICheckBox alloc] initWithFrame:CGRectMake(10, 40.0f / 2.0f - 25.0f / 2.0f, 25, 25)];
    checkBox2.tintColor = kNBR_ProjectColor_StandBlue;
    checkBox2.check = NO;
    
    __weak CommitActivityContentViewController *blockSelf = self;
    
    [checkBox1 setCheckBlock:^(UICheckBox* sender){
        [blockSelf changedCheckBox:sender];
    }];
    
    [checkBox2 setCheckBlock:^(UICheckBox* sender){
        [blockSelf changedCheckBox:sender];
    }];
    
    //提交按钮
    UIView *tableViewFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, 70)];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(15, 10, kNBR_SCREEN_W - 30, 40);
    commitButton.backgroundColor = kNBR_ProjectColor_StandBlue;
    commitButton.layer.cornerRadius = 5.0f;
    commitButton.layer.masksToBounds = YES;
    commitButton.titleLabel.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:15.0f];
    [commitButton setTitle:@"确认发布" forState:UIControlStateNormal];
    [tableViewFootView addSubview:commitButton];
    
    
    boundTableView.tableFooterView = tableViewFootView;

}

- (void) changedCheckBox : (UICheckBox*) sender
{
    if (sender == checkBox1 && checkBox1.check)
    {
        return ;
    }
    
    if (sender == checkBox2 && checkBox2.check)
    {
        return ;
    }
    
    checkBox1.check = !checkBox1.check;
    checkBox2.check = !checkBox2.check;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return cellTitiles.count;
    }
    else if (section == 1)
    {
        return 2;
    }
    
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.0f;
    }
    else
    {
        return 5;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.0f;
    }
    else
    {
        return 5;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    
    if (indexPath.section == 1)
    {
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, kNBR_SCREEN_W - 40, 40)];
        titleLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.0f];
        titleLable.textColor = kNBR_ProjectColor_DeepBlack;
        
        if (indexPath.row == 0)
        {
            titleLable.text = @"所有小区可见";
            [cell.contentView addSubview:checkBox1];
        }
        else if (indexPath.row == 1)
        {
            titleLable.text = @"本小区可见";
            [cell.contentView addSubview:checkBox2];
        }
        
        [cell.contentView addSubview:titleLable];
    }
    else
    {
        NSString *celltitle = cellTitiles[indexPath.row];
        UITextField *cellTextFiled = cellTextFields[indexPath.row];
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 55, 40.0f)];
        titleLable.text = celltitle;
        titleLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.0f];
        titleLable.textColor = kNBR_ProjectColor_DeepBlack;
        titleLable.textAlignment = NSTextAlignmentRight;
        
        [cell.contentView addSubview:titleLable];
        [cell.contentView addSubview:cellTextFiled];
    }
    return cell;
}

@end
