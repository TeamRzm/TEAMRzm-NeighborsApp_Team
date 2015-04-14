//
//  NBRLoginViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/13.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRLoginViewController.h"
#import "NBRForgetPwdViewController.h"
#import "NBRRegViewController.h"
@interface NBRLoginViewController ()
{
    UITextField     *userNameTextField;
    UITextField     *pwdTextField;
    
    
    NSArray         *tableViewDateSource;
}
@end

@implementation NBRLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"登录";
    
    self.boundTabView.tableHeaderView = self.tableViewHeadView;
    self.boundTabView.tableFooterView = self.tableVieFootView;
    
    self.loginButton.layer.cornerRadius = 5.0f;
    self.loginButton.layer.masksToBounds = YES;
    
    self.regButton.layer.cornerRadius = 5.0f;
    self.regButton.layer.masksToBounds = YES;
    
    self.headPicImageView.layer.cornerRadius = self.headPicImageView.frame.size.width / 2.0f;
    self.headPicImageView.layer.masksToBounds = YES;
    
    userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, kNBR_SCREEN_W - 30, 44.0f)];
    userNameTextField.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f];
    userNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userNameTextField.textColor = kNBR_ProjectColor_DeepGray;
    userNameTextField.placeholder = @"账号/手机号码";
    [self setDoneStyleTextFile:userNameTextField];
    
    pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, kNBR_SCREEN_W - 30, 44.0f)];
    pwdTextField.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f];
    pwdTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    pwdTextField.textColor = kNBR_ProjectColor_DeepGray;
    pwdTextField.placeholder = @"请输入登陆密码";
    pwdTextField.secureTextEntry = YES;
    [self setDoneStyleTextFile:pwdTextField];
    
    tableViewDateSource = @[userNameTextField,pwdTextField];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetPwdButtonAction:)];
    [self.forgetPwdLable addGestureRecognizer:tapGesture];
    self.forgetPwdLable.userInteractionEnabled = YES;
}

- (void) forgetPwdButtonAction : (id) _sender
{
    NBRForgetPwdViewController *nVC = [[NBRForgetPwdViewController alloc] initWithNibName:@"NBRForgetPwdViewController" bundle:nil];
    
    [self.navigationController pushViewController:nVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableViewDateSource.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.contentView addSubview:tableViewDateSource[indexPath.row]];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)regButtonAction:(id)sender
{
    NBRRegViewController *nVC = [[NBRRegViewController alloc] initWithNibName:@"NBRForgetPwdViewController" bundle:nil];
    
    [self.navigationController pushViewController:nVC animated:YES];
}

- (IBAction)loginButtonAction:(id)sender
{
    if (userNameTextField.text.length <= 0)
    {
        [self showBannerMsgWithString:@"账号/手机号码"];
        return ;
    }
    
    if (pwdTextField.text.length <= 0)
    {
        [self showBannerMsgWithString:@"请输密码"];
        return ;
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [self showBannerMsgWithString:@"登录成功"];
    }];
}
@end
