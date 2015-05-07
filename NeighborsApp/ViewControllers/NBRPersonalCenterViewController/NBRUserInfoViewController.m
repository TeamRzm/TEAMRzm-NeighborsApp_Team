//
//  NBRUserInfoViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/4.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRUserInfoViewController.h"
#import "CreaterRequest_User.h"

typedef enum
{
    INFOMATION_VIEWCONTROLLER_STATE_NONE,
    INFOMATION_VIEWCONTROLLER_STATE_NOMAL,
    INFOMATION_VIEWCONTROLLER_STATE_EDIT,
}INFOMATION_VIEWCONTROLLER_STATE;


@interface NBRUserInfoViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *boundTableView;
    
    NSArray     *nomalTitleArr;
    
    NSMutableArray *nomalTextFiedArr;
    
    ASIHTTPRequest  *userInfoRequest;
    
    EGOImageView  *avterImageView;
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
    
    avterImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"t_avter_9"]];
    avterImageView.frame = CGRectMake(kNBR_SCREEN_W - 60, 25, 50, 50);
    avterImageView.layer.cornerRadius = 2.0f;
    avterImageView.layer.masksToBounds = YES;
    
    
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
            subTextFied.textAlignment = NSTextAlignmentRight;
            
            [subArr addObject:subTextFied];
        }
        
        [nomalTextFiedArr addObject:subArr];
    }
    
    [self requestUserInfo];
    
    UIBarButtonItem *rightAddItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tianjia01"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarbuttonAction:)];
    self.navigationItem.rightBarButtonItem = rightAddItem;
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
        }
        
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
    }
    
    [boundTableView reloadData];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:.5f];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:boundTableView cache:YES];
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
            ((UITextField*)nomalTextFiedArr[1][2]).text = @"";
            ((UITextField*)nomalTextFiedArr[1][3]).text = [responseDict stringWithKeyPath:@"data\\result\\username"];
            ((UITextField*)nomalTextFiedArr[1][4]).text = @"";
            ((UITextField*)nomalTextFiedArr[1][5]).text = @"";
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
            return 100.0f;
        }
        else
        {
            return 44.0f;
        }
    }
    else if (self.viewControllerState == INFOMATION_VIEWCONTROLLER_STATE_EDIT)
    {
        if (indexPath.section == 0 && indexPath.row == 0) return 100.0f;
        if (indexPath.section == 1 && indexPath.row == 0) return 0.0f;
        if (indexPath.section == 1 && indexPath.row == 2) return 0.0f;
        if (indexPath.section == 1 && indexPath.row == 3) return 0.0f;
        
        return 44.0f;
    }
    
    return 0.0f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    cell.layer.masksToBounds = YES;
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kNBR_SCREEN_W, 44.0f)];
    titleLable.text = nomalTitleArr[indexPath.section][indexPath.row];
    titleLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f];
    titleLable.textColor = kNBR_ProjectColor_DeepBlack;
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        titleLable.frame = CGRectMake(10, 0, kNBR_SCREEN_W, 100.0f);
        [cell.contentView addSubview:avterImageView];
    }
    
    [cell.contentView addSubview:titleLable];
    [cell.contentView addSubview:nomalTextFiedArr[indexPath.section][indexPath.row]];
    
    return cell;
}

@end
