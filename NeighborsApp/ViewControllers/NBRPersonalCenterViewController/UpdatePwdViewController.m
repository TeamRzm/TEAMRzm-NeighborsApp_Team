//
//  UpdatePwdViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/11.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "UpdatePwdViewController.h"
#import "CreaterRequest_User.h"

@interface UpdatePwdViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView         *boundTabelView;
    
    NSArray             *titlesArr;
    NSMutableArray      *textFiledArray;
    
    ASIHTTPRequest      *updatePwdRequest;
}

@end

@implementation UpdatePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    
    // Do any additional setup after loading the view.
    boundTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H) style:UITableViewStyleGrouped];
    boundTabelView.delegate = self;
    boundTabelView.dataSource = self;
    [self.view addSubview:boundTabelView];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, 60)];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(15, 10, kNBR_SCREEN_W - 30, 40);
    commitButton.backgroundColor = kNBR_ProjectColor_StandBlue;
    commitButton.layer.cornerRadius = 5.0f;
    commitButton.layer.masksToBounds = YES;
    commitButton.titleLabel.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:15.0f];
    [commitButton setTitle:@"确认修改" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(updatePwdRequest) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:commitButton];
    boundTabelView.tableFooterView = footView;
    
    
    titlesArr = @[
                  @"旧密码",
                  @"新密码",
                  @"确认密码",
                  ];
    
    textFiledArray = [[NSMutableArray alloc] init];

    for (NSString *subTitle in titlesArr)
    {
        UITextField *subTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, kNBR_SCREEN_W - 20, 40.0f)];
        subTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self setDoneStyleTextFile:subTextFiled];
        subTextFiled.font = [UIFont systemFontOfSize:14.0f];
        subTextFiled.placeholder = [NSString stringWithFormat:@"请输入%@", subTitle];
        subTextFiled.textAlignment = NSTextAlignmentRight;
        subTextFiled.secureTextEntry = YES;
        
        [textFiledArray addObject:subTextFiled];
    }
}

- (void) updatePwdRequest
{
    for (int i = 0; i < titlesArr.count; i++)
    {
        if ( ((UITextField*)textFiledArray[i]).text.length <= 0 )
        {
            [self showBannerMsgWithString:[NSString stringWithFormat:@"请输入%@", titlesArr[i]]];
            
            return ;
        }
    }
    
    if ( ![((UITextField*)textFiledArray[1]).text isEqualToString:((UITextField*)textFiledArray[2]).text] )
    {
        [self showBannerMsgWithString:@"两次输入的密码不一致，请重新输入"];
        
        return ;
    }
    
    NSString *randVeriftCode = [NSString stringWithFormat:@"%6d", (int)rand() % 1000000];
    
    updatePwdRequest = [CreaterRequest_User CreateUpdatePwdRequestWithOpwd:[((UITextField*)textFiledArray[0]).text encodeMD5PasswordStringWithCheckCode:randVeriftCode]
                                                                  password:[((UITextField*)textFiledArray[1]).text encodeBase64PasswordStringWithVerift:randVeriftCode]
                                                                    verify:randVeriftCode];
    
    __weak ASIHTTPRequest *blockRequest = updatePwdRequest;
    
    [blockRequest setCompletionBlock:^{
        
        [self removeLoadingView];
        
        NSDictionary *responseDict = blockRequest.responseString.JSONValue;
        
        if ([CreaterRequest_User CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            [self showBannerMsgWithString:[responseDict stringWithKeyPath:@"data\\code\\message"]];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    [self setDefaultRequestFaild:blockRequest];
    [self addLoadingView];
    [updatePwdRequest startAsynchronous];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return .1f;
//}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titlesArr.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kNBR_SCREEN_W, 44.0f)];
    titleLable.text = titlesArr[indexPath.row];
    titleLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f];
    titleLable.textColor = kNBR_ProjectColor_DeepBlack;

    [cell.contentView addSubview:titleLable];
    [cell.contentView addSubview:textFiledArray[indexPath.row]];
    
    return cell;
}

@end
