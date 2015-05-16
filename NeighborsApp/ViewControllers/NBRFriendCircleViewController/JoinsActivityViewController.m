//
//  JoinsActivityViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/16.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "JoinsActivityViewController.h"

#import "CreaterRequest_Activity.h"

@interface JoinsActivityViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView     *boundTabelView;
    NSArray         *titleArr;
    NSMutableArray  *textFiledArr;
    
    ASIHTTPRequest  *joinRequest;
}

@end

@implementation JoinsActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"报名信息填写";
    
    titleArr = @[
                 @"联系人",
                 @"联系电话",
                 @"报名人数",
                 ];
    
    textFiledArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < titleArr.count; i++)
    {
        UITextField *subTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, kNBR_SCREEN_W - 20, 40.0f)];
        [self setDoneStyleTextFile:subTextField];
        subTextField.textAlignment = NSTextAlignmentRight; 
        [textFiledArr addObject:subTextField];
        
        subTextField.placeholder = [NSString stringWithFormat:@"请输入%@",titleArr[i]];
        
        if (i == 1)
        {
            subTextField.keyboardType = UIKeyboardTypePhonePad;
        }
        
        if (i == 2)
        {
            subTextField.keyboardType = UIKeyboardTypeNumberPad;
        }
    }
    
    boundTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H) style:UITableViewStyleGrouped];
    boundTabelView.delegate = self;
    boundTabelView.dataSource = self;
    [self.view addSubview:boundTabelView];

//    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    commitButton.titleLabel.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13.0f];
//    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
//    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [commitButton addTarget:self action:@selector(joinRequest) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBarbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:commitButton];
//    self.navigationItem.rightBarButtonItem = rightBarbuttonItem;
    
    //提交按钮
    UIView *tableViewFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, 50)];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(15, 10, kNBR_SCREEN_W - 30, 40);
    commitButton.backgroundColor = kNBR_ProjectColor_StandBlue;
    commitButton.layer.cornerRadius = 5.0f;
    commitButton.layer.masksToBounds = YES;
    commitButton.titleLabel.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:15.0f];
    [commitButton setTitle:@"确认报名" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(joinRequest) forControlEvents:UIControlEventTouchUpInside];
    [tableViewFootView addSubview:commitButton];
    
    boundTabelView.tableFooterView = tableViewFootView;
}

- (void) joinRequest
{
    [self resignFirstResponderWithView:nil];
    
    for (int i = 0; i < titleArr.count; i++)
    {
        UITextField *subTextFiled = textFiledArr[i];
        
        if (subTextFiled.text.length <= 0)
        {
            [self showBannerMsgWithString:[NSString stringWithFormat:@"请输入%@",titleArr [i]]];
            
            return ;
        }
    }
    
    NSString *inputPhone = ((UITextField*)textFiledArr[1]).text;
    NSString *inputCotrace = ((UITextField*)textFiledArr[0]).text;
    NSString *inputCount = ((UITextField*)textFiledArr[2]).text;
    
    joinRequest = [CreaterRequest_Activity CreateJoinRequestWithID:self.activityEntity.activityID
                                                             phone:inputPhone
                                                          contrace:inputCotrace
                                                             count:inputCount];
    
    __weak ASIHTTPRequest *blockRequest = joinRequest;
    
    [blockRequest setCompletionBlock:^{
        [self removeLoadingView];
        NSDictionary *responseDict = blockRequest.responseString.JSONValue;
        
        if ([CreaterRequest_Activity CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            [self showBannerMsgWithString:[responseDict stringWithKeyPath:@"data\\code\\message"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    
    [self setDefaultRequestFaild:blockRequest];
    
    [self addLoadingView];
    [joinRequest startAsynchronous];
    
    return ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITableView Delegate

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArr.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 40.0f)];
    titleLable.text = titleArr[indexPath.row];
    titleLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.0f];
    titleLable.textColor = kNBR_ProjectColor_DeepBlack;
    titleLable.textAlignment = NSTextAlignmentLeft;
    
    [cell.contentView addSubview:titleLable];
    [cell.contentView addSubview:textFiledArr[indexPath.row]];
    return cell;
}

@end
