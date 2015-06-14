//
//  AddPlotCertViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/23.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "AddPlotCertViewController.h"
#import "CreaterRequest_Village.h"
#import "UICheckBox.h"

@interface AddPlotCertViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView     *boundTableView;
    NSArray         *titlesArr;
    NSArray         *placeHold;
    NSMutableArray  *textFieldArr;
    
    ASIHTTPRequest  *commentApplyVillage;
    
    UICheckBox      *cb_0;
    UICheckBox      *cb_1;
    UICheckBox      *cb_2;
    
    NSInteger       cbIndex;
}
@end

@implementation AddPlotCertViewController

- (void) resetCheckBoxWithSender : (UICheckBox *) checkBox
{
    cb_0.check = NO;
    cb_1.check = NO;
    cb_2.check = NO;

    checkBox.check = YES;
    cbIndex = checkBox.tag;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    cbIndex = -1;
    self.title = @"添加认证";
    
    titlesArr = @[
                  @"我的姓名",
                  @"我的电话",
                  ];
    
    placeHold = @[
                  @"请填写您的真实姓名",
                  @"请输入您的电话",
                  ];
    
    textFieldArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < titlesArr.count; i++)
    {
        UITextField *newTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, kNBR_SCREEN_W - 20, 40.0f)];
   
        [self setDoneStyleTextFile:newTextFiled];
        newTextFiled.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13.0f];
        newTextFiled.textAlignment = NSTextAlignmentRight;
        newTextFiled.placeholder = placeHold[i];
        [textFieldArr addObject:newTextFiled];
    }
    
    boundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H) style:UITableViewStyleGrouped];
    boundTableView.delegate = self;
    boundTableView.dataSource = self;
    [self.view addSubview:boundTableView];
    
    
    //FootView
    UIView *tableViewFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, 135)];
    
    //ChckBox
    cb_0 = [[UICheckBox alloc] initWithFrame:CGRectMake(10, 30 * 0 - 5, 35, 35) scale:.6];
    cb_0.tag = 0;
    [cb_0 setTintColor:kNBR_ProjectColor_StandRed];
    [tableViewFootView addSubview:cb_0];
    
    UILabel *cb_0DescLable = [[UILabel alloc] initWithFrame:CGRectMake(45, 30 * 0 - 5, 320.0f - 50 - 10, 35)];
    cb_0DescLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13.0f];
    cb_0DescLable.textColor = kNBR_ProjectColor_DeepGray;
    cb_0DescLable.text = @"房产证在我名下";
    [tableViewFootView addSubview:cb_0DescLable];
    
    cb_1 = [[UICheckBox alloc] initWithFrame:CGRectMake(10, 30 * 1 - 5, 35, 35) scale:.6];
    cb_1.tag = 1;
    [cb_1 setTintColor:kNBR_ProjectColor_StandRed];
    [tableViewFootView addSubview:cb_1];
    
    UILabel *cb_1DescLable = [[UILabel alloc] initWithFrame:CGRectMake(45, 30 * 1 - 5, 320.0f - 50 - 10, 35)];
    cb_1DescLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13.0f];
    cb_1DescLable.textColor = kNBR_ProjectColor_DeepGray;
    cb_1DescLable.text = @"我是业主家属";
    [tableViewFootView addSubview:cb_1DescLable];
    
    cb_2 = [[UICheckBox alloc] initWithFrame:CGRectMake(10, 30 * 2 - 5, 35, 35) scale:.6];
    cb_2.tag = 2;
    [cb_2 setTintColor:kNBR_ProjectColor_StandRed];
    [tableViewFootView addSubview:cb_2];
    
    UILabel *cb_2DescLable = [[UILabel alloc] initWithFrame:CGRectMake(45, 30 * 2 - 5, 320.0f - 50 - 10, 35)];
    cb_2DescLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13.0f];
    cb_2DescLable.textColor = kNBR_ProjectColor_DeepGray;
    cb_2DescLable.text = @"我是租客";
    [tableViewFootView addSubview:cb_2DescLable];
    
    __weak AddPlotCertViewController *blockSelf = self;
    
    [cb_0 setCheckBlock:^(UICheckBox *sender){
        [blockSelf resetCheckBoxWithSender:sender];
    }];
    
    [cb_1 setCheckBlock:^(UICheckBox *sender){
        [blockSelf resetCheckBoxWithSender:sender];
    }];
    
    [cb_2 setCheckBlock:^(UICheckBox *sender){
        [blockSelf resetCheckBoxWithSender:sender];
    }];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(15, 95, kNBR_SCREEN_W - 30, 40);
    commitButton.backgroundColor = kNBR_ProjectColor_StandBlue;
    commitButton.layer.cornerRadius = 5.0f;
    commitButton.layer.masksToBounds = YES;
    commitButton.titleLabel.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:15.0f];
    [commitButton setTitle:@"提交审核" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commentToVerifty) forControlEvents:UIControlEventTouchUpInside];
    [tableViewFootView addSubview:commitButton];
    
    boundTableView.tableFooterView = tableViewFootView;
}

- (void) commentToVerifty
{
    [self resignFirstResponder];
    
    for (int i = 0; i < titlesArr.count; i++)
    {
        if (((UITextField*)textFieldArr[i]).text.length <= 0)
        {
            [self showBannerMsgWithString:[NSString stringWithFormat:@"请输入%@",titlesArr[i]]];
            
            return;
        }
    }
    
    if (cbIndex == -1)
    {
        [self showBannerMsgWithString:@"请选择与业主的关系"];
        
        return;
    }
    
    commentApplyVillage = [CreaterRequest_Village CreateApplyRequestWithID:[self.plotDict stringWithKeyPath:@"villageId"]
                                                                      data:@""
                                                                     phone:((UITextField*)textFieldArr[1]).text
                                                                   contact:((UITextField*)textFieldArr[0]).text
                                                                 ownerName:self.ownerName
                                                                 ownerType:ITOS(cbIndex)
                                                                     house:self.houseInfo];
    
    __weak ASIHTTPRequest *blockRequest = commentApplyVillage;
    
    [blockRequest setCompletionBlock:^{
        [self removeLoadingView];
        
        NSDictionary *responseDict = blockRequest.responseString.JSONValue;
        
        if ([CreaterRequest_Village CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            [self showBannerMsgWithString:[responseDict stringWithKeyPath:@"data\\code\\message"]];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
            
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

@end
