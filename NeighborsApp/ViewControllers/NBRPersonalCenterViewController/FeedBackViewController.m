//
//  FeedBackViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/23.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "FeedBackViewController.h"
#import "UITextView+Placeholder.h"
#import "CreateRequest_Server.h"


@interface FeedBackViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *boundTableView;
    UITextView  *inputTextView;
    
    ASIHTTPRequest *feekBackRequest;
}
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"意见反馈";
    
    boundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H) style:UITableViewStyleGrouped];
    boundTableView.delegate = self;
    boundTableView.dataSource = self;
    boundTableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    boundTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:boundTableView];
    
    inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, kNBR_SCREEN_W - 20, 200)];
    inputTextView.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f];
    inputTextView.layer.masksToBounds = YES;
    inputTextView.layer.cornerRadius = 3.0f;
    inputTextView.layer.borderColor = [UIColor grayColor].CGColor;
    inputTextView.layer.borderWidth = 0.5f;
    [inputTextView setPlaceHolder:@"请输入..."];
    [self performSelector:@selector(perfromDelayToBecom) withObject:nil afterDelay:1.0f];
    
    //提交按钮
    UIView *tableViewFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, 40)];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(15, 0, kNBR_SCREEN_W - 30, 40);
    commitButton.backgroundColor = kNBR_ProjectColor_StandBlue;
    commitButton.layer.cornerRadius = 5.0f;
    commitButton.layer.masksToBounds = YES;
    commitButton.titleLabel.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:15.0f];
    [commitButton setTitle:@"提交反馈" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commitFackBack:) forControlEvents:UIControlEventTouchUpInside];
    [tableViewFootView addSubview:commitButton];
    
    
    boundTableView.tableFooterView = tableViewFootView;
}

- (void) perfromDelayToBecom
{
    [inputTextView becomeFirstResponder];
}

- (void) commitFackBack : (UIButton*) sender
{
    if (inputTextView.text.length <= 0)
    {
        [self showBannerMsgWithString:@"请输入反馈的内容。"];
        return ;
    }
    
    feekBackRequest = [CreateRequest_Server CreateFeedBackRequestWithInfo:inputTextView.text type:@""];
    
    __weak ASIHTTPRequest *blockRequest = feekBackRequest;
    
    [blockRequest setCompletionBlock:^{
        
        [self removeLoadingView];
        
        NSDictionary *responseDict = blockRequest.responseString.JSONValue;
        
        if ([CreateRequest_Server CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            [self showBannerMsgWithString:@"反馈成功"];
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
        
    }];
    
    [self setDefaultRequestFaild:blockRequest];
    
    [self addLoadingView];
    [feekBackRequest startAsynchronous];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0f;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220.0f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:inputTextView];
    
    return cell;
}

@end
