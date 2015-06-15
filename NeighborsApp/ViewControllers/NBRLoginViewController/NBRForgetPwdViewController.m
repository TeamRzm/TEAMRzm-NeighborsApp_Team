//
//  NBRForgetPwdViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/14.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRForgetPwdViewController.h"
#import "CreaterRequest_Verify.h"
#import "CreaterRequest_User.h"

@interface NBRForgetPwdViewController ()
{
    UILabel            *getCheckCodeButton;
    
    NSDate              *checkCodeButtomTimerStartTime;
    NSTimer             *checkCodeButtonTimer;
    
    ASIHTTPRequest      *verifyRequest;
    ASIHTTPRequest      *forgotPwdRequest;
}
@end

@implementation NBRForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
    self.title = @"忘记密码";
    
    self.commitButton.layer.cornerRadius = 5.0f;
    self.commitButton.layer.masksToBounds = YES;
    
    nickTextField = [[UITextField alloc] initWithFrame:CGRectMake(55, 0, 260, 44.0f)];
    nickTextField.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f];
    nickTextField.textColor = kNBR_ProjectColor_DeepGray;
    nickTextField.placeholder = @"请输入昵称";
    [self setDoneStyleTextFile:nickTextField];
    
    phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(55, 0, 260, 44.0f)];
    phoneNumberTextField.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f];
    phoneNumberTextField.textColor = kNBR_ProjectColor_DeepGray;
    phoneNumberTextField.placeholder = @"请输入手机号码";
    [self setDoneStyleTextFile:phoneNumberTextField];
    
    
    checkCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(55, 0, 145, 44.0f)];
    checkCodeTextField.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f];
    checkCodeTextField.textColor = kNBR_ProjectColor_DeepGray;
    checkCodeTextField.placeholder = @"请输入验证码";
    checkCodeTextField.secureTextEntry = YES;
    [self setDoneStyleTextFile:checkCodeTextField];
    
    
    pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(55, 0, 260, 44.0f)];
    pwdTextField.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f];
    pwdTextField.textColor = kNBR_ProjectColor_DeepGray;
    pwdTextField.placeholder = @"请输入密码";
    pwdTextField.secureTextEntry = YES;
    [self setDoneStyleTextFile:pwdTextField];
    
    
    rePwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(55, 0, 260, 44.0f)];
    rePwdTextField.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f];
    rePwdTextField.textColor = kNBR_ProjectColor_DeepGray;
    rePwdTextField.placeholder = @"请确认密码";
    rePwdTextField.secureTextEntry = YES;
    [self setDoneStyleTextFile:rePwdTextField];
    
    
    getCheckCodeButton = [[UILabel alloc] initWithFrame:CGRectMake(200, 0.0f, 320.0f - 200, 44.0f)];
    getCheckCodeButton.backgroundColor = kNBR_ProjectColor_StandBlue;
    getCheckCodeButton.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.0f];
    getCheckCodeButton.numberOfLines = 0;
    getCheckCodeButton.textAlignment = NSTextAlignmentCenter;
    getCheckCodeButton.textColor = kNBR_ProjectColor_StandWhite;
    getCheckCodeButton.text = @"获取验证码";
    getCheckCodeButton.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(senderCheckCode)];
    [getCheckCodeButton addGestureRecognizer:tapGesture];
    
    
    tableViewDateSource = @[
                            @[phoneNumberTextField,checkCodeTextField],
                            @[pwdTextField,rePwdTextField],
                            ];
    
    tableViewCellTitles = @[
                            @[@"手机号",@"验证码"],
                            @[@"密码",@"确认"],
                            ];
}

- (void) timerIntervalAction
{
    NSTimeInterval timeIntervalFromStartTime = [checkCodeButtomTimerStartTime timeIntervalSinceDate:[NSDate date]];
    
    NSInteger sec = (int)(60.0f + timeIntervalFromStartTime);
    
    NSString *buttonTitle;
    
    if (sec > 0)
    {
        buttonTitle = [NSString stringWithFormat:@"重新获取验证码\n(%d)秒", sec];
        getCheckCodeButton.userInteractionEnabled = NO;
    }
    else
    {
        buttonTitle = @"获取验证码";
        getCheckCodeButton.userInteractionEnabled = YES;
        checkCodeButtonTimer.fireDate = [NSDate distantFuture];
    }
    
    getCheckCodeButton.text = buttonTitle;
}

- (void) checkCodeButtonTimerAction
{
    checkCodeButtonTimer = [NSTimer scheduledTimerWithTimeInterval:.5f target:self selector:@selector(timerIntervalAction) userInfo:nil repeats:YES];
    
    checkCodeButtonTimer.fireDate = [NSDate date];
    
    checkCodeButtomTimerStartTime = [NSDate date];
}

- (void) senderCheckCode
{
    if (phoneNumberTextField.text.length <= 0)
    {
        [self showBannerMsgWithString:@"请输入手机号"];
        
        return ;
    }
    
    verifyRequest = [CreaterRequest_Verify CreateVerifyRequestWithPhone:phoneNumberTextField.text type:@"0" flag:@"1"];
    
    __weak ASIHTTPRequest *blockRequest = verifyRequest;
    
    [blockRequest setCompletionBlock:^{
        
        [self removeLoadingView];
        
        NSDictionary *responseDict = [blockRequest.responseString JSONValue];
        
        if ([CreaterRequest_Verify CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            [self showBannerMsgWithString:[responseDict stringWithKeyPath:@"data\\code\\message"]];
            
            [self checkCodeButtonTimerAction];
        }
        else
        {
            NSLog(@"%@", blockRequest.responseString);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return tableViewDateSource.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray*)(tableViewDateSource[section])).count;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        return self.commitButtonView;
    }
    else
    {
        return nil;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        return self.commitButtonView.frame.size.height;
    }
    else
    {
        return 15.0f;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 44.0f)];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    titleLable.text = tableViewCellTitles[indexPath.section][indexPath.row];
    titleLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.0f];
    titleLable.textColor = kNBR_ProjectColor_DeepGray;
    titleLable.textAlignment = NSTextAlignmentRight;
    
    [cell.contentView addSubview:titleLable];
    [cell.contentView addSubview:tableViewDateSource[indexPath.section][indexPath.row]];
    
    if ([titleLable.text isEqualToString:@"验证码"])
    {
        [cell.contentView addSubview:getCheckCodeButton];
    }
    return cell;
}

- (IBAction)commitButtonTouchUpInSide:(id)sender
{
    [self resignFirstResponder];
    
    if (phoneNumberTextField.text.length <= 0)
    {
        [self showBannerMsgWithString:@"请输入手机号"];
        
        return ;
    }
    
    if (checkCodeTextField.text.length <= 0)
    {
        [self showBannerMsgWithString:@"请输入验证码"];
        
        return ;
    }
    
    if (pwdTextField.text.length <= 0)
    {
        [self showBannerMsgWithString:@"请输入登陆密码"];
        
        return ;
    }
    
    if (rePwdTextField.text.length <= 0)
    {
        [self showBannerMsgWithString:@"请输入再次登陆密码"];
        
        return ;
    }
    
    if (![pwdTextField.text isEqualToString:rePwdTextField.text])
    {
        [self showBannerMsgWithString:@"两次输入的登陆密码不一致"];
        
        return ;
    }

    
    forgotPwdRequest = [CreaterRequest_User CreateForgotPwdRequestWithUserName:phoneNumberTextField.text
                                                                      password:[rePwdTextField.text encodeBase64PasswordStringWithVerift:checkCodeTextField.text]
                                                                        verify:checkCodeTextField.text];
    
    __weak ASIHTTPRequest* blockRequest = forgotPwdRequest;
    
    
    [blockRequest setCompletionBlock:^{
        [self removeLoadingView];
        
        NSDictionary *responseDict = [blockRequest.responseString JSONValue];
        
        if ([CreaterRequest_Verify CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            [self showBannerMsgWithString:[responseDict stringWithKeyPath:@"data\\code\\message"]];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSLog(@"%@", blockRequest.responseString);
        }
    }];
    
    [self setDefaultRequestFaild:blockRequest];
    
    [forgotPwdRequest startAsynchronous];
    [self addLoadingView];
}
@end
