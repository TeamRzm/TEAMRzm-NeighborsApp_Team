//
//  AddPlotCertSubInfoViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/6/12.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "AddPlotCertSubInfoViewController.h"
#import "SearchPlotListViewController.h"
#import "AddPlotCertViewController.h"

@interface AddPlotCertSubInfoViewController () <UITableViewDataSource, UITableViewDelegate,SearchPlotListViewControllerDelegate>
{
    UITableView *boundTableView;
    
    NSArray         *boundDataSource;
    NSMutableArray  *textFieldArr;
    NSArray         *boundPlaceHold;
    NSDictionary    *selectPlotDict;
}
@end

@implementation AddPlotCertSubInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加入住";
    boundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H) style:UITableViewStyleGrouped];
    boundTableView.delegate = self;
    boundTableView.dataSource = self;
    [self.view addSubview:boundTableView];
    
    boundDataSource = @[
                        @[@"选择小区",
                          @"房号"],
                        
                        @[@"业主姓名",
                          @"业主电话"],
                        ];
    
    boundPlaceHold  = @[
                        @[@"点击选择小区",
                          @"如A区5栋0206号"],
                        
                        @[@"请填写房产登记人姓名",
                          @"请填写房产登记人电话"],
                        ];
    
    textFieldArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < boundDataSource.count; i++)
    {
        NSMutableArray *subTextFiledArr = [[NSMutableArray alloc] init];
        NSArray *subArr = ((NSArray*)boundDataSource[i]);
        
        for (int j = 0; j < subArr.count; j++)
        {
            UITextField *newTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, kNBR_SCREEN_W - 20, 40.0f)];
            
            [self setDoneStyleTextFile:newTextFiled];
            newTextFiled.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13.0f];
            newTextFiled.textAlignment = NSTextAlignmentRight;
            newTextFiled.placeholder = boundPlaceHold[i][j];
            [subTextFiledArr addObject:newTextFiled];
        }
        
        [textFieldArr addObject:subTextFiledArr];
    }
    
    ((UITextField*)textFieldArr[0][0]).frame = CGRectMake(10, 0, kNBR_SCREEN_W - 40, 40.0f);
    ((UITextField*)textFieldArr[0][0]).userInteractionEnabled = NO;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, 90)];
    
    UILabel *footDescLale = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kNBR_SCREEN_W - 20, 40.0f)];
    footDescLale.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13.0f];
    footDescLale.textColor = kNBR_ProjectColor_StandRed;
    footDescLale.numberOfLines = 0;
    footDescLale.text = @"请补全该房屋业主在物业处预留的真实姓名和手机号，是作为审核入住信息的重要凭证。";
    footDescLale.textAlignment = NSTextAlignmentCenter;
    [footView addSubview:footDescLale];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(15, 50, kNBR_SCREEN_W - 30, 40);
    commitButton.backgroundColor = kNBR_ProjectColor_StandBlue;
    commitButton.layer.cornerRadius = 5.0f;
    commitButton.layer.masksToBounds = YES;
    commitButton.titleLabel.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:15.0f];
    [commitButton setTitle:@"下一步" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(nextStageWithAddPlot:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:commitButton];

    boundTableView.tableFooterView = footView;
    
    [self setDissMissLeftButtonWithTitle:@"取消添加"];
}

- (void) nextStageWithAddPlot : (UIButton*) sender
{
    if (!selectPlotDict)
    {
        [self showBannerMsgWithString:@"请选择所在小区"];
        
        return;
    }
    
    for (int i = 0; i < textFieldArr.count; i++)
    {
        NSArray *subArr = textFieldArr[i];
        
        for (int j = 0; j < subArr.count; j++)
        {
            UITextField *subTextField = subArr[j];
            
            if (subTextField.text.length <= 0)
            {
                [self showBannerMsgWithString:[NSString stringWithFormat:@"请输入%@", boundDataSource[i][j]]];
                
                return ;
            }
        }
    }
    
    AddPlotCertViewController *addPlotCertViewController = [[AddPlotCertViewController alloc] initWithNibName:nil bundle:nil];
    addPlotCertViewController.plotDict = selectPlotDict;
    addPlotCertViewController.houseInfo = ((UITextField*)textFieldArr[0][1]).text;
    addPlotCertViewController.ownerName = ((UITextField*)textFieldArr[1][0]).text;
    addPlotCertViewController.ownerTelNum = ((UITextField*)textFieldArr[1][1]).text;
    [self.navigationController pushViewController:addPlotCertViewController animated:YES];

    return ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITableViewDelegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return boundDataSource.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray*)boundDataSource[section]).count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
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
    nameLable.text = boundDataSource[indexPath.section][indexPath.row];
    [cell.contentView addSubview:nameLable];
    
    [cell.contentView addSubview:textFieldArr[indexPath.section][indexPath.row]];
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
    ((UITextField*)textFieldArr[0][0]).text = _dict[@"name"];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
