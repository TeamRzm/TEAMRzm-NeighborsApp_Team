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
    NSArray     *editTitleArr;
    
    NSMutableArray *nomalTextFiedArr;
    NSMutableArray *editTextFiedArr;
    
    ASIHTTPRequest  *userInfoRequest;
}

@property (nonatomic, assign) INFOMATION_VIEWCONTROLLER_STATE viewControllerState;

@end

@implementation NBRUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewControllerState = INFOMATION_VIEWCONTROLLER_STATE_NOMAL;
    
    boundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H) style:UITableViewStyleGrouped];
    boundTableView.delegate = self;
    boundTableView.dataSource = self;
    [self.view addSubview:boundTableView];
    
    
    //配置数据
    nomalTitleArr = @[
                      @[@"头像"],
                      @[@"账号",@"昵称",@"密码",@"手机号",@"性别",@"爱好",@"签名"],
                      ];
    
    editTitleArr = @[
                     @[@"头像"],
                     @[@"昵称",@"手机号",@"性别",@"爱好",@"签名"],
                      ];
    
    [self requestUserInfo];
    
    
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
            [boundTableView reloadData];
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
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.viewControllerState == INFOMATION_VIEWCONTROLLER_STATE_NOMAL)
    {
        return nomalTitleArr.count;
    }
    
    if (self.viewControllerState == INFOMATION_VIEWCONTROLLER_STATE_EDIT)
    {
        return editTitleArr.count;
    }
    
    return 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.viewControllerState == INFOMATION_VIEWCONTROLLER_STATE_NOMAL)
    {
        return ((NSArray*)nomalTitleArr[section]).count;
    }
    
    if (self.viewControllerState == INFOMATION_VIEWCONTROLLER_STATE_EDIT)
    {
        return ((NSArray*)editTitleArr[section]).count;
    }
    
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    
    if (self.viewControllerState == INFOMATION_VIEWCONTROLLER_STATE_NOMAL)
    {
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kNBR_SCREEN_W, 44.0f)];
        titleLable.text = nomalTitleArr[indexPath.section][indexPath.row];
        titleLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13.0f];
        titleLable.textColor = kNBR_ProjectColor_DeepBlack;
        
        [cell.contentView addSubview:titleLable];
        [cell.contentView addSubview:nomalTextFiedArr[indexPath.section][indexPath.row]];
    }
    
    if (self.viewControllerState == INFOMATION_VIEWCONTROLLER_STATE_EDIT)
    {
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kNBR_SCREEN_W, 44.0f)];
        titleLable.text = editTitleArr[indexPath.section][indexPath.row];
        titleLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13.0f];
        titleLable.textColor = kNBR_ProjectColor_DeepBlack;
        
        [cell.contentView addSubview:titleLable];
        [cell.contentView addSubview:editTextFiedArr[indexPath.section][indexPath.row]];
    }
    
    return cell;
}

@end
