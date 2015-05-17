//
//  NBRServeiesViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/3/26.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRServeiesViewController.h"
#import "NBRDynamicofPropertyViewController.h"
#import "NBRSmallRosterViewController.h"

#import "CreateRequest_Server.h"



@interface NBRServeiesViewController ()

@end

@implementation NBRServeiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"服务"];
    [self initSubView];
    [self SetBaseNavigationRightItemWithTitle:@"切换"];
    
    [self GetDynamicList];
    
    
}

#pragma mark Init Method
-(void) initSubView
{
    titleNameArr = [[NSMutableArray alloc] init];
    [titleNameArr addObject:[NSArray arrayWithObjects:@"物业动态",@"投诉与报修",@"业委会", nil]];
    [titleNameArr addObject:[NSArray arrayWithObjects:@"物业花名册",@"特约服务", nil]];
    
    logoArr = [[NSMutableArray alloc] init];
    [logoArr addObject:[NSArray arrayWithObjects:@"wuyedongtai",@"tousuyubaoxiu",@"yeweihui", nil]];
    [logoArr addObject:[NSArray arrayWithObjects:@"wuyehuamingce",@"teyuefuwu", nil]];
    

    myTableview =[[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kNBR_SCREEN_W, kNBR_SCREEN_H) style:UITableViewStyleGrouped];
    [myTableview setBackgroundView:nil];
    [myTableview setBackgroundColor:[UIColor clearColor]];
    [myTableview setDelegate:self];
    [myTableview setDataSource:self];
    [myTableview setRowHeight:kNBR_SCREEN_W/3.0f];
    [myTableview setSeparatorColor:[UIColor clearColor]];
    [myTableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view addSubview:myTableview];
    
    [self CreateHeaderView];
    
    
}

-(void) CreateHeaderView
{
    scrollDataArr = [[NSMutableArray alloc] initWithObjects:@"t_avter_1",@"t_avter_2",@"t_avter_3", nil];
    
    UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kNBR_SCREEN_W, 140.0f)];
    [myTableview setTableHeaderView:headerview];
    
    headerScrollview = [[UIScrollView alloc] initWithFrame:headerview.frame];
    [headerScrollview setPagingEnabled:YES];
    [headerScrollview setDelegate:self];
    [headerScrollview setShowsHorizontalScrollIndicator:NO];
    [headerScrollview setShowsVerticalScrollIndicator:NO];
    [headerScrollview setContentSize:CGSizeMake(kNBR_SCREEN_W*scrollDataArr.count, headerScrollview.frame.size.height)];
    [headerview addSubview:headerScrollview];
    
    for (int  j = 0; j<scrollDataArr.count; j++)
    {
        //头像
        EGOImageView *avterImgView = [[EGOImageView alloc] initWithPlaceholderImage: [UIImage imageNamed:scrollDataArr[j]]];
        avterImgView.frame = CGRectMake(0+j*kNBR_SCREEN_W, 0.0f,kNBR_SCREEN_W,headerScrollview.frame.size.height);
        avterImgView.tag = j;
        [avterImgView setContentMode:UIViewContentModeScaleAspectFit];
        [headerScrollview addSubview:avterImgView];
    }
    
    UIView *bottonview = [[UIView alloc] initWithFrame:CGRectMake(0.0f, headerview.frame.size.height-20.0f, kNBR_SCREEN_W, 20.0f)];
    [bottonview setBackgroundColor:[UIColor whiteColor]];
    [bottonview setAlpha:0.7];
    [headerview addSubview:bottonview];
    
     pagcontrol = [[UIPageControl alloc] initWithFrame:bottonview.frame];
    [pagcontrol setNumberOfPages:scrollDataArr.count];
    [pagcontrol setCurrentPageIndicatorTintColor:kNBR_ProjectColor_DeepGray];
    [pagcontrol setPageIndicatorTintColor:kNBR_ProjectColor_MidGray];
    [pagcontrol addTarget:self action:@selector(PageValueChange:) forControlEvents:UIControlEventValueChanged];
    [pagcontrol setCurrentPage:0];
    [headerview addSubview:pagcontrol];
    

}

//获取推荐的动态
-(void) GetDynamicList
{
    dynamicRecReq = [CreateRequest_Server CreateDynamicOfPropertyInfoWithIndex:@"1" Flag:@"1" Size:@"10"];
    __weak ASIHTTPRequest *selfblock = dynamicRecReq;
    [selfblock setCompletionBlock:^{
        NSDictionary *reponseDict = selfblock.responseString.JSONValue;
        [self removeLoadingView];
        
        if ([CreateRequest_Server CheckErrorResponse:reponseDict errorAlertInViewController:self])
        {
            scrollDataArr = (NSMutableArray *)[reponseDict arrayWithKeyPath:@"data\\result\\data"];
            
        }
    }];
    
    [self setDefaultRequestFaild:selfblock];
    
    [self addLoadingView];
    [dynamicRecReq startAsynchronous];
    
}


#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleNameArr count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    NSArray *subnameArr = titleNameArr[indexPath.row];
    NSArray *sublogoArr = logoArr[indexPath.row];
    for (int i =0; i<[subnameArr count]; i++)
    {
        UIView *contentview = [[UIView alloc] initWithFrame:CGRectMake(0.0f+i*kNBR_SCREEN_W/3, 0.0f, kNBR_SCREEN_W/3.0f, kNBR_SCREEN_W/3.0f)];
        [contentview setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:contentview];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ItemLogoClicked:)];
        [contentview setUserInteractionEnabled:YES];
        [contentview addGestureRecognizer:gesture];
        [contentview setTag:(indexPath.row*3+i)];
        
        //头像
        UIImageView *logoview = [[UIImageView alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W/6-74/2, 10.0f, 74.0f, 74.0f)];
        [logoview setImage:[UIImage imageNamed:sublogoArr[i]]];
        [contentview addSubview:logoview];
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, logoview.frame.origin.y+5.0f+logoview.frame.size.height, contentview.frame.size.width,20.0f)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:14.0f]];
        [titleLabel setTextColor:kNBR_ProjectColor_DeepGray];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setText:subnameArr[i]];
        [contentview addSubview:titleLabel];
        
        
    }
    
    
    
    return cell;
    
}

#pragma mark gesture Method
-(void) ItemLogoClicked:(UIGestureRecognizer *) _gesture
{
    NSLog(@"_gesture tag == %d",_gesture.view.tag);
    switch (_gesture.view.tag)
    {
        case 0:
        {
            NBRDynamicofPropertyViewController *dynamicview = [[NBRDynamicofPropertyViewController alloc] init];
            [dynamicview setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:dynamicview animated:YES];
            
        }
            break;
        case 3:
        {
            NBRSmallRosterViewController *rosterview = [[NBRSmallRosterViewController alloc] init];
            [rosterview setHidesBottomBarWhenPushed:YES];

            [self.navigationController pushViewController:rosterview animated:YES];
            
        }
            break;

            
        default:
            [self showBannerMsgWithString:@"功能开发过程中"];
            break;
    }
}

#pragma mark Navigation Method
-(void) SetBaseNavigationRightItemWithTitle:(NSString *) title
{
    UIButton *rightbt = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbt setFrame:CGRectMake(0.0f, 0.0f, 90.0f, 30.0f)];
    UIImage *image = [UIImage imageNamed:@"bg_btnbg_pressed"];
    image = [image stretchableImageWithLeftCapWidth:5.0f topCapHeight:25.0f];
    [rightbt setBackgroundColor:[UIColor colorWithPatternImage:image]];
    [rightbt setBackgroundColor:kNBR_ProjectColor_StandBlue];
    [rightbt setTitle:title forState:UIControlStateNormal];
    [rightbt.layer setCornerRadius:4.0f];
    UIFont *font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:16.0f];
    [rightbt setTitleColor:kNBR_ProjectColor_StandWhite forState:UIControlStateNormal];
    [rightbt.titleLabel setFont:font];
    [rightbt sizeToFit];
    [rightbt addTarget:self action:@selector(BaseNavigatinRightItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightbt setFrame:CGRectMake(0.0f, 0.0f, rightbt.frame.size.width+15.0f, 30.0f)];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithCustomView:rightbt];
    [self.navigationItem setRightBarButtonItem:rightitem];
}

-(void) BaseNavigatinRightItemClicked:(UIButton *) sender
{
    NSLog(@"right item clicked!");
}

#pragma mark scrollview delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger current = scrollView.contentOffset.x/kNBR_SCREEN_W;
    [pagcontrol setCurrentPage:current];
}

-(void) PageValueChange:(UIPageControl *) sender
{
    [headerScrollview setContentOffset:CGPointMake(sender.currentPage*kNBR_SCREEN_W, 0.0f) animated:YES];
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

@end
