//
//  AddPlotCertViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/23.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "AddPlotCertViewController.h"
#import "CreaterRequest_Village.h"
#import "SearchPlotListViewController.h"

@interface AddPlotCertViewController () <UITableViewDataSource, UITableViewDelegate,SearchPlotListViewControllerDelegate>
{
    UITableView     *boundTableView;
    NSArray         *titlesArr;
    NSMutableArray  *textFieldArr;
    
    ASIHTTPRequest  *commentApplyVillage;
    
    
    NSDictionary    *selectPlotDict;
}
@end

@implementation AddPlotCertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加认证";
    
    titlesArr = @[
                  @"所在小区",
                  @"业主姓名",
                  @"业主电话",
                  @"联系人",
                  @"联系电话",
                  @"与业主关系",
                  @"楼层信息",
                  ];
    
    textFieldArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < titlesArr.count; i++)
    {
        UITextField *newTextFiled;
        if (i == 0)
        {
           newTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, kNBR_SCREEN_W - 40, 40.0f)];
        }
        else
        {
           newTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, kNBR_SCREEN_W - 20, 40.0f)];
        }
        
        [self setDoneStyleTextFile:newTextFiled];
        newTextFiled.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13.0f];
        newTextFiled.textAlignment = NSTextAlignmentRight;
        [textFieldArr addObject:newTextFiled];
    }
    
    ((UITextField*)textFieldArr[0]).userInteractionEnabled = NO;
    ((UITextField*)textFieldArr[0]).placeholder = @"请选择";
    
    boundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H) style:UITableViewStyleGrouped];
    boundTableView.delegate = self;
    boundTableView.dataSource = self;
    [self.view addSubview:boundTableView];
    
    
    UIView *tableViewFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, 40)];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(15, 0, kNBR_SCREEN_W - 30, 40);
    commitButton.backgroundColor = kNBR_ProjectColor_StandBlue;
    commitButton.layer.cornerRadius = 5.0f;
    commitButton.layer.masksToBounds = YES;
    commitButton.titleLabel.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:15.0f];
    [commitButton setTitle:@"提交认证" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commentToVerifty) forControlEvents:UIControlEventTouchUpInside];
    [tableViewFootView addSubview:commitButton];
    
    boundTableView.tableFooterView = tableViewFootView;
}

- (void) commentToVerifty
{
    if (!selectPlotDict)
    {
        [self showBannerMsgWithString:@"请选择所在小区"];
        
        return;
    }
    
    for (int i = 0; i < titlesArr.count; i++)
    {
        if (((UITextField*)textFieldArr[i]).text.length <= 0)
        {
            [self showBannerMsgWithString:[NSString stringWithFormat:@"请输入%@",titlesArr[i]]];
            
            return;
        }
    }
    
//    @"所在小区",     0
//    @"业主姓名",     1
//    @"业主电话",     2
//    @"联系人",       3
//    @"联系电话",     4
//    @"与业主关系",   5
//    @"楼层信息",     6
    
    commentApplyVillage = [CreaterRequest_Village CreateApplyRequestWithID:[selectPlotDict stringWithKeyPath:@"villageId"]
                                                                      data:@""
                                                                     phone:((UITextField*)textFieldArr[4]).text
                                                                   contact:((UITextField*)textFieldArr[3]).text
                                                                 ownerName:((UITextField*)textFieldArr[1]).text
                                                                 ownerType:((UITextField*)textFieldArr[5]).text
                                                                     house:((UITextField*)textFieldArr[6]).text];
    
    __weak ASIHTTPRequest *blockRequest = commentApplyVillage;
    
    [blockRequest setCompletionBlock:^{
        [self removeLoadingView];
        
        NSDictionary *responseDict = blockRequest.responseString.JSONValue;
        
        if ([CreaterRequest_Village CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            [self showBannerMsgWithString:[responseDict stringWithKeyPath:@"data\\code\\message"]];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            return ;
        }
        
    }];
    
    [self setDefaultRequestFaild:blockRequest];
    
    [blockRequest startAsynchronous];
    [self addLoadingView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView Delegate
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titlesArr.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  40;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    //业主姓名Lable
    UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kNBR_SCREEN_W - 20, 40.0f)];
    nameLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.0f];
    nameLable.textColor = kNBR_ProjectColor_DeepBlack;
    nameLable.textAlignment = NSTextAlignmentLeft;
    nameLable.text = titlesArr[indexPath.row];
    [cell.contentView addSubview:nameLable];
    
    [cell.contentView addSubview:textFieldArr[indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        SearchPlotListViewController *nVC = [[SearchPlotListViewController alloc] initWithNibName:nil bundle:nil];
        nVC.delegate = self;

        [self.navigationController pushViewController:nVC animated:YES];
    }
}

#pragma mark -SearchViewController Delegate

- (void) searchPlotListViewController : (SearchPlotListViewController*) _viewcontroller didselectDict : (NSDictionary*) _dict
{
    selectPlotDict = _dict;
    ((UITextField*)textFieldArr[0]).text = _dict[@"name"];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
