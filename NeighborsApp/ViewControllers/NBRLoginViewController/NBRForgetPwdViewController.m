//
//  NBRForgetPwdViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/14.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRForgetPwdViewController.h"

@interface NBRForgetPwdViewController ()
{
    UITextField         *phoneNumberTextField;
    UITextField         *checkCodeTextField;
    UITextField         *pwdTextField;
    UITextField         *rePwdTextField;
    UIButton            *getCheckCodeButton;
    
    
    NSArray             *tableViewDateSource;
    NSArray             *tableViewCellTitles;
}
@end

@implementation NBRForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
    self.title = @"忘记密码";
    
    self.commitButton.layer.cornerRadius = 5.0f;
    self.commitButton.layer.masksToBounds = YES;
    
    
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
    
    
    getCheckCodeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    getCheckCodeButton.frame = CGRectMake(200, 0.0f, 320.0f - 200, 44.0f);
    getCheckCodeButton.backgroundColor = kNBR_ProjectColor_StandBlue;
    getCheckCodeButton.titleLabel.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.0f];
    [getCheckCodeButton setTitleColor:kNBR_ProjectColor_StandWhite forState:UIControlStateNormal];
    [getCheckCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    
    tableViewDateSource = @[
                            @[phoneNumberTextField,checkCodeTextField],
                            @[pwdTextField,rePwdTextField],
                            ];
    
    tableViewCellTitles = @[
                            @[@"手机号",@"验证码"],
                            @[@"密码",@"确认"],
                            ];
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
    
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        [cell.contentView addSubview:getCheckCodeButton];
    }
    
    return cell;
}

@end
