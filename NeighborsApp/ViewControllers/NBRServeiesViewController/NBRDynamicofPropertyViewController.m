//
//  NBRDynamicofPropertyViewController.m
//  NeighborsApp
//
//  Created by jason on 15/5/17.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRDynamicofPropertyViewController.h"
#import "CreateRequest_Server.h"

#import "NewsTableViewCell.h"
#import "XHImageViewer.h"

#import "RefreshControl.h"
#import "NBRNewsDetailViewController.h"

@interface NBRDynamicofPropertyViewController ()<NewsTableViewCellDelegate,XHImageViewerDelegate,RefreshControlDelegate>
{
    RefreshControl *refreshController;
    
    NSInteger       totalRecord;
    NSInteger       pageIndex;
    BOOL            isLoading;
    
    DYNAMICO_PROPERTY_VIEWCONTROLLER_MODE viewControllerMode;
}
@end

@implementation NBRDynamicofPropertyViewController

- (id) initWithMode : (DYNAMICO_PROPERTY_VIEWCONTROLLER_MODE) _mode
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        viewControllerMode = _mode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    switch (viewControllerMode)
    {
        case DYNAMICO_PROPERTY_VIEWCONTROLLER_MODE_ZONE:
        {
            [self setTitle:@"物业动态"];
        }
            break;
            
        case DYNAMICO_PROPERTY_VIEWCONTROLLER_MODE_INDUSTRY:
        {
            [self setTitle:@"业委会公告"];
        }
            break;
            
        default:
            [self setTitle:@"为定义类型"];
            return ;
            break;
    }

    [self initSubView];
    [self GetDynamicList];
}

#pragma mark Init Method
-(void) initSubView
{
    dataArr = [[NSMutableArray alloc] init];
    
    myTableview =[[UITableView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, kNBR_SCREEN_W, kNBR_SCREEN_H - 64.0f) style:UITableViewStyleGrouped];
    [myTableview setBackgroundView:nil];
    [myTableview setDelegate:self];
    [myTableview setDataSource:self];
    
    refreshController = [[RefreshControl alloc] initWithScrollView:myTableview delegate:self];
    refreshController.topEnabled = YES;
    
    [self.view addSubview:myTableview];
}

-(void) GetDynamicList
{
    dynamicReq = [CreateRequest_Server CreateDynamicOfPropertyInfoWithIndex:ITOS(pageIndex) Flag:ITOS(viewControllerMode) Size:kNBR_PAGE_SIZE_STR];
    __weak ASIHTTPRequest *selfblock = dynamicReq;
    [selfblock setCompletionBlock:^{
        
        [refreshController finishRefreshingDirection:RefreshDirectionTop];
        
        NSDictionary *reponseDict = selfblock.responseString.JSONValue;
        
        [self removeLoadingView];
        
        if ([CreateRequest_Server CheckErrorResponse:reponseDict errorAlertInViewController:self])
        {
            totalRecord = [reponseDict numberWithKeyPath:@"data\\result\\totalRecord"];
            
            if (pageIndex == 0)
            {
                dataArr = (NSMutableArray *)[reponseDict arrayWithKeyPath:@"data\\result\\data"];
            }
            else
            {
                [dataArr addObjectsFromArray:[reponseDict arrayWithKeyPath:@"data\\result\\data"]];
            }
            
            [myTableview reloadData];
        }
    }];
    
    [self setDefaultRequestFaild:selfblock];
    
    [self addLoadingView];
    [dynamicReq startAsynchronous];
    
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [dataArr count];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0f;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *subDict = dataArr[indexPath.section];
    
    NewsTableViewCell *cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    cell.delegate = self;
    
    [cell setDateDict:subDict numerOfLine:3];
    
    return cell;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *subDict = dataArr[indexPath.section];
    
    return [NewsTableViewCell heightWithDict:subDict numberOfLine:3];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *subDict = dataArr[indexPath.section];
    
    NBRNewsDetailViewController *detaillViewController = [[NBRNewsDetailViewController alloc] initWithNibName:nil bundle:nil];
    detaillViewController.dataDict = subDict;
    
    [self.navigationController pushViewController:detaillViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) newTabelViewCell : (NewsTableViewCell*) _cell tapSubImageViews : (UIImageView*) tapView
{
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    imageViewer.delegate = self;
    [imageViewer showWithImageViews:_cell.subImageViews selectedView:tapView];
}

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction
{
    if (direction == RefreshDirectionTop)
    {
        pageIndex = 0;
        [self GetDynamicList];
    }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (dataArr.count >= totalRecord)
    {
        return ;
    }
    
    UITableViewCell *lastCell = [myTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:dataArr.count - 1]];
    
    if ([myTableview.visibleCells containsObject:lastCell])
    {
        if (isLoading)
        {
            return ;
        }
        
        pageIndex++;
        
        [self GetDynamicList];
    }
}

@end
