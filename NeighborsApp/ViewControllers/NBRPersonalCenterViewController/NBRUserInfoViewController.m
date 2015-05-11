//
//  NBRUserInfoViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/4.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRUserInfoViewController.h"
#import "FileUpLoadHelper.h"
#import "CreaterRequest_User.h"
#import "UpdatePwdViewController.h"

typedef enum
{
    INFOMATION_VIEWCONTROLLER_STATE_NONE,
    INFOMATION_VIEWCONTROLLER_STATE_NOMAL,
    INFOMATION_VIEWCONTROLLER_STATE_EDIT,
}INFOMATION_VIEWCONTROLLER_STATE;


@interface NBRUserInfoViewController ()<UITableViewDataSource, UITableViewDelegate,FileUpLoadHelperDelegate,UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    UITableView *boundTableView;
    
    NSArray     *nomalTitleArr;
    
    NSMutableArray *nomalTextFiedArr;
    
    ASIHTTPRequest  *userInfoRequest;
    
    UIView        *footView;
    UIView        *logoutFootView;
    
    EGOImageView     *avterImageView;
    FileUpLoadHelper *avatarUploader;
    BOOL             isSelectImage;
    
    UIPickerView     *sexPicker;
    UIToolbar        *sexPickerToolBar;
}

@property (nonatomic, assign) INFOMATION_VIEWCONTROLLER_STATE viewControllerState;

@end

@implementation NBRUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户信息";
    // Do any additional setup after loading the view.
    self.viewControllerState = INFOMATION_VIEWCONTROLLER_STATE_NOMAL;
    self.view.backgroundColor = [UIColor blackColor];
    
    boundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H) style:UITableViewStyleGrouped];
    boundTableView.delegate = self;
    boundTableView.dataSource = self;
    [self.view addSubview:boundTableView];
    
    sexPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kNBR_SCREEN_H, kNBR_SCREEN_W, 216.0f)];
    sexPicker.delegate = self;
    sexPicker.dataSource = self;
    sexPicker.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:sexPicker];
    
    sexPickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kNBR_SCREEN_H, kNBR_SCREEN_W, 40.0f)];
    UIBarButtonItem *lineItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:Nil action:Nil];
    lineItem.width = 245;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(toolBarDone)];
    [sexPickerToolBar setItems:@[lineItem, doneButton]];
    [self.view addSubview:sexPickerToolBar];

    
    avterImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"defaultAvater"]];
    avterImageView.frame = CGRectMake(kNBR_SCREEN_W - 60, 80.0f / 2.0f - 50.0f / 2.0f, 50, 50);
    avterImageView.layer.cornerRadius = 2.0f;
    avterImageView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto)];
    [avterImageView addGestureRecognizer:avatarTap];
    
    
    //配置数据
    nomalTitleArr = @[
                      @[@"头像"],
                      @[@"账号",@"昵称",@"密码",@"手机号",@"性别",@"爱好",@"签名"],
                      ];
    
    nomalTextFiedArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < nomalTitleArr.count; i++)
    {
        NSMutableArray *subArr = [[NSMutableArray alloc] init];
        
        for (int j = 0; j < ((NSArray*)nomalTitleArr[i]).count; j++)
        {
            UITextField *subTextFied = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, kNBR_SCREEN_W - 20, 44.0f)];
            subTextFied.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [self setDoneStyleTextFile:subTextFied];
            subTextFied.font = [UIFont systemFontOfSize:14.0f];
            subTextFied.delegate = self;
            subTextFied.textAlignment = NSTextAlignmentRight;
            subTextFied.userInteractionEnabled = NO;
            
            [subArr addObject:subTextFied];
        }
        
        [nomalTextFiedArr addObject:subArr];
    }
    
    [self requestUserInfo];
    
    UIBarButtonItem *rightAddItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tianjia01"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarbuttonAction:)];
    self.navigationItem.rightBarButtonItem = rightAddItem;
    
    [self setLogoutTableViewFootView];
}

- (void) showSexPicker
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
    
    [UIView animateWithDuration:.25f animations:^{
        sexPicker.frame = CGRectMake(0, kNBR_SCREEN_H - 216 , kNBR_SCREEN_W, 216.0f);
        sexPickerToolBar.frame = CGRectMake(0, kNBR_SCREEN_H - 256, kNBR_SCREEN_W, 40.0f);
    } completion:^(BOOL finished) {
        if ( [((UITextField*)nomalTextFiedArr[1][4]).text isEqualToString:@"男"] )
        {
            [sexPicker selectRow:0 inComponent:0 animated:YES];
        }
        else
        {
            [sexPicker selectRow:1 inComponent:0 animated:YES];
        }
    }];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self toolBarDone];
    [self insertBoundTableView];
}

- (void) insertBoundTableView
{
    boundTableView.contentInset = UIEdgeInsetsMake(64, 0, 250, 0);
}

- (void) unInsertBoundTableView
{
    boundTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}

- (void) toolBarDone
{
    [UIView animateWithDuration:.25f animations:^{
        sexPicker.frame = CGRectMake(0, kNBR_SCREEN_H, kNBR_SCREEN_W, 216.0f);
        sexPickerToolBar.frame = CGRectMake(0, kNBR_SCREEN_H, kNBR_SCREEN_W, 40.0f);
        [self unInsertBoundTableView];
    }];
}

- (void) resignFirstResponderWithView : (UIView*) _resgignView
{
    [super resignFirstResponderWithView:_resgignView];
    [self unInsertBoundTableView];
}

- (void) uploadAvatar
{
    avatarUploader = [[FileUpLoadHelper alloc] init];
    avatarUploader.delegate = self;
    [avatarUploader addUploadImage:avterImageView.image];
    [avatarUploader startUpload];
    [self addLoadingView];
}

- (void) commitDateDictWithAvatar : (NSString*) _avatar
{
    NSString *sexId = [((UITextField*)nomalTextFiedArr[1][4]).text isEqualToString:@"男"] ? @"0" : @"1";
    
    userInfoRequest = [CreaterRequest_User CreateUpdateRequestWithPhone:((UITextField*)nomalTextFiedArr[1][3]).text
                                                                    sex:sexId
                                                               nickName:((UITextField*)nomalTextFiedArr[1][1]).text
                                                                 avatar:_avatar
                                                              signature:((UITextField*)nomalTextFiedArr[1][6]).text
                                                                  habit:((UITextField*)nomalTextFiedArr[1][5]).text];
    
    __weak ASIHTTPRequest *blockSelf = userInfoRequest;
    
    [blockSelf setCompletionBlock:^{
        NSDictionary *reponseDict = blockSelf.responseString.JSONValue;
        
        if ([CreaterRequest_User CheckErrorResponse:reponseDict errorAlertInViewController:self])
        {
            [self showBannerMsgWithString:[reponseDict stringWithKeyPath:@"data\\code\\message"]];
            
            [self rightBarbuttonAction:nil];
            
            [self requestUserInfo];
        }
    }];
    
    [self setDefaultRequestFaild:blockSelf];
    
    [self addLoadingView];
    [userInfoRequest startAsynchronous];
}

- (void) commitUpdateInfomation
{    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
    [self unInsertBoundTableView];
    [self toolBarDone];
    
    if (isSelectImage)
    {
        [self uploadAvatar];
    }
    else
    {
        [self commitDateDictWithAvatar:@""];
    }
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[AppSessionMrg shareInstance] userLogout];
        [self showBannerMsgWithString:@"注销成功"];
        
        [((AppDelegate*)[UIApplication sharedApplication].delegate) showLoginViewController];;
    }
}

- (void) logout
{
    UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否确认注销当前登录帐号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [logoutAlert show];
}

- (void) setLogoutTableViewFootView
{
    logoutFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, 50)];
    
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.frame = CGRectMake(15, 0, kNBR_SCREEN_W - 30, 40);
    logoutButton.backgroundColor = kNBR_ProjectColor_StandBlue;
    logoutButton.layer.cornerRadius = 5.0f;
    logoutButton.layer.masksToBounds = YES;
    logoutButton.titleLabel.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:15.0f];
    [logoutButton setTitle:@"注销当前登录账号" forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    
    [logoutFootView addSubview:logoutButton];
    [boundTableView setTableFooterView:logoutFootView];
    
    avterImageView.userInteractionEnabled = NO;
    [footView removeFromSuperview];
}

- (void) setEditTabelViewFootView
{
    avterImageView.userInteractionEnabled = YES;
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, 100)];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(15, 0, kNBR_SCREEN_W - 30, 40);
    commitButton.backgroundColor = kNBR_ProjectColor_StandBlue;
    commitButton.layer.cornerRadius = 5.0f;
    commitButton.layer.masksToBounds = YES;
    commitButton.titleLabel.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:15.0f];
    [commitButton setTitle:@"确认修改" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commitUpdateInfomation) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(15, 50, kNBR_SCREEN_W - 30, 40);
    cancelButton.backgroundColor = kNBR_ProjectColor_StandBlue;
    cancelButton.layer.cornerRadius = 5.0f;
    cancelButton.layer.masksToBounds = YES;
    cancelButton.titleLabel.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:15.0f];
    [cancelButton setTitle:@"取消编辑" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(rightBarbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [footView addSubview:commitButton];
    [footView addSubview:cancelButton];
    
    [boundTableView setTableFooterView:footView];
}

- (void) rightBarbuttonAction : (id) sender
{
    if (self.viewControllerState == INFOMATION_VIEWCONTROLLER_STATE_NOMAL)
    {
        self.viewControllerState = INFOMATION_VIEWCONTROLLER_STATE_EDIT;
        
        for (int i = 0; i < nomalTitleArr.count; i++)
        {
            for (int j = 0; j < ((NSArray*)nomalTitleArr[i]).count; j++)
            {
                ((UITextField*)nomalTextFiedArr[i][j]).userInteractionEnabled = YES;
            }
            
            ((UITextField*)nomalTextFiedArr[1][4]).userInteractionEnabled = NO;
        }
        
        [logoutFootView removeFromSuperview];
        [self setEditTabelViewFootView];
    }
    else if (self.viewControllerState == INFOMATION_VIEWCONTROLLER_STATE_EDIT)
    {
        self.viewControllerState = INFOMATION_VIEWCONTROLLER_STATE_NOMAL;
        
        for (int i = 0; i < nomalTitleArr.count; i++)
        {
            for (int j = 0; j < ((NSArray*)nomalTitleArr[i]).count; j++)
            {
                ((UITextField*)nomalTextFiedArr[i][j]).userInteractionEnabled = NO;
            }
        }
        
        [self setLogoutTableViewFootView];
    }
    
    [boundTableView reloadData];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:.5f];
    if (self.viewControllerState == INFOMATION_VIEWCONTROLLER_STATE_NOMAL)
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:boundTableView cache:YES];
    }
    else
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:boundTableView cache:YES];
    }
    [UIView commitAnimations];
}

- (void) requestUserInfo
{
    userInfoRequest = [CreaterRequest_User CreateUserInfoRequest];
    
    __weak ASIHTTPRequest *blockRequest = userInfoRequest;
    
    [blockRequest setCompletionBlock:^{
        [self removeLoadingView];
        
        NSDictionary *responseDict = [blockRequest.responseString JSONValue];
        
        if ([CreaterRequest_User CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            ((UITextField*)nomalTextFiedArr[1][0]).text = [responseDict stringWithKeyPath:@"data\\result\\username"];
            ((UITextField*)nomalTextFiedArr[1][1]).text = [responseDict stringWithKeyPath:@"data\\result\\nickName"];
            ((UITextField*)nomalTextFiedArr[1][3]).text = [responseDict stringWithKeyPath:@"data\\result\\phone"];
            ((UITextField*)nomalTextFiedArr[1][4]).text = [[responseDict stringWithKeyPath:@"data\\result\\sex"] isEqualToString:@"1"] ? @"女" : @"男";
            ((UITextField*)nomalTextFiedArr[1][5]).text = [responseDict stringWithKeyPath:@"data\\result\\habit"];
            ((UITextField*)nomalTextFiedArr[1][6]).text = [responseDict stringWithKeyPath:@"data\\result\\signature"];
            
            NSString *avatarUrl = [responseDict stringWithKeyPath:@"data\\result\\avatar"];
            
            if (avatarUrl && avatarUrl.length > 0)
            {
                isSelectImage = YES;
                avterImageView.imageURL = [NSURL URLWithString:avatarUrl];
            }
        }
        
        return ;
    }];
    
    [self setDefaultRequestFaild:blockRequest];
    
    [blockRequest startAsynchronous];
    [self addLoadingView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return nomalTitleArr.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray*)nomalTitleArr[section]).count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.viewControllerState == INFOMATION_VIEWCONTROLLER_STATE_NOMAL)
    {
        if (indexPath.section == 0)
        {
            return 80.0f;
        }
        else
        {
            return 44.0f;
        }
    }
    else if (self.viewControllerState == INFOMATION_VIEWCONTROLLER_STATE_EDIT)
    {
        if (indexPath.section == 0 && indexPath.row == 0) return 80.0f;
        if (indexPath.section == 1 && indexPath.row == 0) return 0.0f;
        if (indexPath.section == 1 && indexPath.row == 2) return 0.0f;
        
        return 44.0f;
    }
    
    return 0.0f;
}



- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    cell.layer.masksToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kNBR_SCREEN_W, 44.0f)];
    titleLable.text = nomalTitleArr[indexPath.section][indexPath.row];
    titleLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f];
    titleLable.textColor = kNBR_ProjectColor_DeepBlack;
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        titleLable.frame = CGRectMake(10, 0, kNBR_SCREEN_W, 80.0f);
        [cell.contentView addSubview:avterImageView];
    }
    
    [cell.contentView addSubview:titleLable];
    
    if (indexPath.section != 1 || (indexPath.row != 2))
    {
        [cell.contentView addSubview:nomalTextFiedArr[indexPath.section][indexPath.row]];
    }
    
    if (indexPath.section == 1 && indexPath.row == 2)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 2)
    {
        UpdatePwdViewController *nVC = [[UpdatePwdViewController alloc] initWithNibName:nil bundle:nil];
        
        [self.navigationController pushViewController:nVC animated:YES];
    }
    
    if (self.viewControllerState == INFOMATION_VIEWCONTROLLER_STATE_EDIT)
    {
        if (indexPath.section == 1 &&
            indexPath.row == 4)
        {
            [self showSexPicker];
        }
    }
}

#pragma mark -- FileUpLoadDelegate
- (void) fileUpLoadHelper:(FileUpLoadHelper *)_helper allDownloadedResponseDictArr:(NSArray *)_dictArr
{
    if (_dictArr.count > 0)
    {
        [self commitDateDictWithAvatar:_dictArr[0][@"url"]];
    }
}

- (void) fileUpLoadHelper:(FileUpLoadHelper *)_helper downloadedFialdWithIndex:(NSInteger)_index
{
    
}

- (void) fileUpLoadHelper:(FileUpLoadHelper *)_helper downloadedIndex:(NSInteger)_index downloadTotal:(NSInteger)_total
{
    
}

#pragma mark -- Select Avatar
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [super assetsPickerController:picker didFinishPickingAssets:assets];
    
    if (selectImgDatas.count > 0)
    {
        avterImageView.image = [self imageFromAssert:assets[0]];
        isSelectImage = YES;
    }
    
    return ;
}

#pragma mark -- UIPicker Delegate
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return row == 0 ? @"男" : @"女";
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row == 0)
    {
        ((UITextField*)nomalTextFiedArr[1][4]).text = @"男";
    }
    else
    {
        ((UITextField*)nomalTextFiedArr[1][4]).text = @"女";
    }
}


@end
