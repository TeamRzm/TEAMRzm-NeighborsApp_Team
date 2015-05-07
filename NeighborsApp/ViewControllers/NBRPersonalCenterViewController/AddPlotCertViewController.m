//
//  AddPlotCertViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/23.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "AddPlotCertViewController.h"
#import "CreaterRequest_Village.h"

@interface AddPlotCertViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView     *boundTableView;
    NSArray         *titlesArr;
    NSArray         *textFieldArr;
    
    ASIHTTPRequest  *listAppliesRequest;
}
@end

@implementation AddPlotCertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加认证";
    
    titlesArr = @[
                  @"所在小区",
                  @"业主姓名",
                  @"联系电话",
                  ];
    
    textFieldArr = @[
                     [[UITextField alloc] initWithFrame:CGRectMake(70, 0, kNBR_SCREEN_W - 70, 40.0f)],
                     [[UITextField alloc] initWithFrame:CGRectMake(70, 0, kNBR_SCREEN_W - 70, 40.0f)],
                     [[UITextField alloc] initWithFrame:CGRectMake(70, 0, kNBR_SCREEN_W - 70, 40.0f)],
                     ];
    
    for (int i = 0; i < textFieldArr.count; i++)
    {
        [self setDoneStyleTextFile:textFieldArr[i]];
    }
    
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
    [tableViewFootView addSubview:commitButton];
    
    boundTableView.tableFooterView = tableViewFootView;
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
    
    //业主姓名Lable
    UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 40.0f)];
    nameLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.0f];
    nameLable.textColor = kNBR_ProjectColor_DeepBlack;
    nameLable.text = titlesArr[indexPath.row];
    [cell.contentView addSubview:nameLable];
    
    [cell.contentView addSubview:textFieldArr[indexPath.row]];
    return cell;
}

- (void) requestList
{
    listAppliesRequest = [CreaterRequest_Village CreateListAppLinesRequest];
    
    __weak ASIHTTPRequest *blockReqeust = listAppliesRequest;
    
    [blockReqeust setCompletionBlock:^{
        [self removeLoadingView];
        
        NSDictionary *responseDict = [blockReqeust.responseString JSONValue];
        
        if ([CreaterRequest_Village CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            //成功
            return ;
        }
    }];
    
    [self setDefaultRequestFaild:listAppliesRequest];
    
    [blockReqeust startAsynchronous];
    [self addLoadingView];
    
}
@end
