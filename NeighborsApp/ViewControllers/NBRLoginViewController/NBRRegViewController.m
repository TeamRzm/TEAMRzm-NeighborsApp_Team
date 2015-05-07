//
//  NBRRegViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/14.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRRegViewController.h"
#import "CreaterRequest_User.h"
#import "CreaterRequest_Verify.h"
#import "UserEntity.h"

@interface NBRRegViewController ()
{
    ASIHTTPRequest *verifyRequest;
    ASIHTTPRequest *regRequest;
}
@end

@implementation NBRRegViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    
    tableViewDateSource = @[
                            @[nickTextField,phoneNumberTextField,checkCodeTextField],
                            @[pwdTextField,rePwdTextField],
                            ];
    
    tableViewCellTitles = @[
                            @[@"昵称",@"手机号",@"验证码"],
                            @[@"密码",@"确认"],
                            ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) senderCheckCode
{
    if (phoneNumberTextField.text.length <= 0)
    {
        [self showBannerMsgWithString:@"请输入手机号"];
        
        return ;
    }
    
    verifyRequest = [CreaterRequest_Verify CreateVerifyRequestWithPhone:phoneNumberTextField.text type:@"0" flag:@"0"];

    __weak ASIHTTPRequest *blockRequest = verifyRequest;
    
    [blockRequest setCompletionBlock:^{
        
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
}


- (IBAction)commitButtonTouchUpInSide:(id)sender
{
    
    if (nickTextField.text.length <= 0)
    {
        [self showBannerMsgWithString:@"请输入昵称"];
        
        return ;
    }
    
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
    
    regRequest = [CreaterRequest_User CreateUserRegisterRequestWithUserName:phoneNumberTextField.text
                                                                   password:[rePwdTextField.text encodeBase64PasswordStringWithVerift:checkCodeTextField.text]
                                                                       nick:nickTextField.text
                                                                     verify:checkCodeTextField.text];
    
    __weak ASIHTTPRequest* blockRequest = regRequest;
    
    
    [blockRequest setCompletionBlock:^{
        [self addLoadingView];
        NSDictionary *responseDict = [blockRequest.responseString JSONValue];
        
        if ([CreaterRequest_Verify CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            [self showBannerMsgWithString:[responseDict stringWithKeyPath:@"data\\code\\message"]];
        }
        else
        {
            NSLog(@"%@", blockRequest.responseString);
        }
    }];
    
    [self setDefaultRequestFaild:blockRequest];
    
    [regRequest startAsynchronous];
    [self removeLoadingView];
    
    return;
}

@end
