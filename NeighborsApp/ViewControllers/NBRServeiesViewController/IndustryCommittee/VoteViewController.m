//
//  VoteViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/6/4.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "VoteViewController.h"
#import "CreaterRequest_Vote.h"
#import "RefreshControl.h"

@interface VoteViewController ()<UITableViewDataSource, UITableViewDelegate,RefreshControlDelegate>
{
    UITableView *boundTableView;
    NSMutableArray  *boundDataSource;
    NSInteger       pageIndex;
    BOOL            isLoading;
    NSInteger       totalCount;
    RefreshControl  *refreshController;
    
    
    ASIHTTPRequest  *voteListRequest;
    ASIHTTPRequest  *voteAddRequest;
}

@end

@implementation VoteViewController

- (void) requestVoteList
{
    voteListRequest = [CreaterRequest_Vote CreateVoteListRequestWithIndex:ITOS(pageIndex) size:kNBR_PAGE_SIZE_STR flag:@"2"];
    
    __weak ASIHTTPRequest *blockRequest = voteListRequest;
    
    [blockRequest setCompletionBlock:^{
        
        isLoading = NO;
        
        [self removeLoadingView];
        
        [refreshController finishRefreshingDirection:RefreshDirectionTop];
        
        NSDictionary *responseDict = blockRequest.responseString.JSONValue;
        
        if ([CreaterRequest_Vote CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            totalCount = [responseDict numberWithKeyPath:@"data\\result\\totalRecord"];
            
            if (pageIndex == 0)
            {
                boundDataSource = [[NSMutableArray alloc] initWithArray:[responseDict arrayWithKeyPath:@"data\\result\\data"]];
            }
            
            [boundDataSource addObjectsFromArray:[responseDict arrayWithKeyPath:@"data\\result\\data"]];
            
            [boundTableView reloadData];
            
            return ;
        }
        
    }];
    
    [blockRequest setFailedBlock:^{
        isLoading = NO;
        [self removeLoadingView];
        [refreshController finishRefreshingDirection:RefreshDirectionTop];
        [self showBannerMsgWithString:@"网络连接失败，请您检查您的网络设置"];
    }];
    
    [self addLoadingView];
    [blockRequest startAsynchronous];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"投票箱";
    // Do any additional setup after loading the view.
    boundDataSource = [[NSMutableArray alloc] init];
    
    boundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kNBR_SCREEN_W, kNBR_SCREEN_H - 64) style:UITableViewStyleGrouped];
    boundTableView.delegate = self;
    boundTableView.dataSource = self;
    [self.view addSubview:boundTableView];
    
    refreshController = [[RefreshControl alloc] initWithScrollView:boundTableView delegate:self];
    refreshController.topEnabled = YES;
    
    [self requestVoteList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- UITabelViewdelegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return boundDataSource.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .1f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *subCellDict = boundDataSource[indexPath.section];
    
    //标题
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kNBR_SCREEN_W - 20, 30)];
    titleLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:14.0f];
    titleLable.textColor = kNBR_ProjectColor_StandBlue;
    titleLable.text = [subCellDict stringWithKeyPath:@"title"];
    [titleLable addBreakLineWithPosition:VIEW_BREAKLINE_POSITION_BOTTOM style:VIEW_BREAKLINE_STYLE_SOLID width:kNBR_SCREEN_W - 20];
    [cell.contentView addSubview:titleLable];
    
    //状态
    UILabel *stateLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kNBR_SCREEN_W - 20, 30)];
    stateLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13.0f];
    stateLable.textColor = kNBR_ProjectColor_MidGray;
    stateLable.text = @"策略未知";
    stateLable.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:stateLable];
    
    //内容
    NSMutableParagraphStyle *contentViewStyle = [[NSMutableParagraphStyle alloc] init];
    contentViewStyle.lineHeightMultiple = 1;
    contentViewStyle.lineSpacing = 4.0f;
    contentViewStyle.paragraphSpacing = 3.0f;

    NSDictionary *contentForamt = @{
                                    NSParagraphStyleAttributeName     : contentViewStyle,
                                    NSFontAttributeName : [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13.5f],
                                    NSForegroundColorAttributeName : kNBR_ProjectColor_DeepBlack,
                                    };
    
    CGRect contentRect3Lines = [@"\n\n\n" boundingRectWithSize:CGSizeMake(kNBR_SCREEN_W - 20, 1000)
                                                       options:NSStringDrawingUsesLineFragmentOrigin |
                                                               NSStringDrawingUsesFontLeading
                                                    attributes:contentForamt
                                                       context:nil];
    
    NSAttributedString *contentAttString = [[NSAttributedString alloc] initWithString:[subCellDict stringWithKeyPath:@"info"]
                                                                           attributes:contentForamt];

    UILabel *contentLable = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                      stateLable.frame.origin.y + stateLable.frame.size.height,
                                                                      kNBR_SCREEN_W - 20,
                                                                      CGRectGetHeight(contentRect3Lines))];
    contentLable.layer.masksToBounds = YES;
    contentLable.numberOfLines = 3;
    contentLable.attributedText = contentAttString;
    [cell.contentView addSubview:contentLable];
    
    //小区标示，时间
    UIImageView *addressLogo = [[UIImageView alloc] initWithFrame:CGRectMake(contentLable.frame.origin.x,
                                                                             contentLable.frame.origin.y + contentLable.frame.size.height,
                                                                             8.5,
                                                                             11)];
    addressLogo.image = [UIImage imageNamed:@"xiaoQuAddressIcon"];
    [cell.contentView addSubview:addressLogo];
    
    //地点
    UIFont *addressContentFont = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:12.0f];
    CGSize addressStringSize = [@"小区名" sizeWithAttributes:@{NSFontAttributeName : addressContentFont}];
    
    UILabel *addressLable = [[UILabel alloc] initWithFrame:CGRectMake(contentLable.frame.origin.x + 11,
                                                                      contentLable.frame.origin.y + contentLable.frame.size.height,
                                                                      addressStringSize.width,
                                                                      addressStringSize.height)];
    
    addressLable.attributedText = [[NSAttributedString alloc] initWithString:@"小区名" attributes:@{
                                                                                                 NSFontAttributeName : addressContentFont,
                                                                                                 NSForegroundColorAttributeName : kNBR_ProjectColor_StandBlue,
                                                                                                 }];
    [cell.contentView addSubview:addressLable];
    
    //时间
    CGSize commitDateStringSize = [[subCellDict stringWithKeyPath:@"created"] sizeWithAttributes:@{
                                                                                                    NSFontAttributeName : addressContentFont,
                                                                                                    NSForegroundColorAttributeName : kNBR_ProjectColor_MidGray,
                                                                                                   }];
    UILabel *commitDateLable = [[UILabel alloc] initWithFrame:CGRectMake(addressLable.frame.origin.x + addressStringSize.width + 10,
                                                                         addressLable.frame.origin.y + (CGRectGetHeight(addressLable.frame) / 2.0f) - commitDateStringSize.height / 2.0f,
                                                                         commitDateStringSize.width,
                                                                         commitDateStringSize.height)];
    
    NSString *tempDateString = [self nowDateStringForDistanceDateString:[subCellDict stringWithKeyPath:@"created"]];
    
    commitDateLable.attributedText = [[NSAttributedString alloc] initWithString:tempDateString attributes:@{
                                                                                                            NSFontAttributeName : addressContentFont,
                                                                                                            NSForegroundColorAttributeName : kNBR_ProjectColor_MidGray,
                                                                                                            }];
    
    [cell.contentView addSubview:commitDateLable];
    
    //投票按钮
    UILabel *yesLable = [[UILabel alloc] initWithFrame:CGRectMake(0, addressLable.frame.origin.y + addressLable.frame.size.height + 15, kNBR_SCREEN_W / 2.0f, 27.0f)];
    yesLable.backgroundColor = kNBR_ProjectColor_StandBlue;
    yesLable.textColor = kNBR_ProjectColor_StandWhite;
    yesLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.5];
    yesLable.textAlignment = NSTextAlignmentCenter;
    yesLable.text = [NSString stringWithFormat:@"同意 %d", [subCellDict numberWithKeyPath:@"yes"]];
    yesLable.userInteractionEnabled = YES;
    yesLable.tag = indexPath.section;
    UITapGestureRecognizer *voteYesTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapYes:)];
    [yesLable addGestureRecognizer:voteYesTapGesture];
    [cell.contentView addSubview:yesLable];
    
    UILabel *noLable = [[UILabel alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W / 2.0f, addressLable.frame.origin.y + addressLable.frame.size.height + 15, kNBR_SCREEN_W / 2.0f, 27.0f)];
    noLable.backgroundColor = kNBR_ProjectColor_StandBlue;
    noLable.textColor = kNBR_ProjectColor_StandWhite;
    noLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.5];
    noLable.text = [NSString stringWithFormat:@"反对 %d", [subCellDict numberWithKeyPath:@"no"]];
    noLable.textAlignment = NSTextAlignmentCenter;
    noLable.userInteractionEnabled = YES;
    noLable.tag = indexPath.section;
    UITapGestureRecognizer *voteNoTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNo:)];
    [yesLable addGestureRecognizer:voteNoTapGesture];
    [cell.contentView addSubview:noLable];
    
    //装饰的一个小使徒 VS
    UILabel *vsLable = [[UILabel alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W / 2.0f - 32.0f / 2.0f,
                                                                 yesLable.frame.origin.y - 32.0f / 2.0f,
                                                                 32,
                                                                 32)];
    vsLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.5f];
    vsLable.backgroundColor = kNBR_ProjectColor_StandBlue;
    vsLable.tag = indexPath.section;
    vsLable.textColor = kNBR_ProjectColor_StandWhite;
    vsLable.text = @"VS";
    vsLable.textAlignment = NSTextAlignmentCenter;
    vsLable.layer.borderColor = kNBR_ProjectColor_StandWhite.CGColor;
    vsLable.layer.borderWidth = 3.0f;
    vsLable.layer.masksToBounds = YES;
    vsLable.layer.cornerRadius = 32.0f / 2.0f;
    
    [cell.contentView addSubview:vsLable];
    
    return cell;
}

- (void) voteAddByID : (NSString*) _ID isYES: (BOOL) _isYES
{
    voteAddRequest = [CreaterRequest_Vote CreateVoteAddRequestWithID:_ID flag:_isYES ? @"0" : @"1"];
    
    __weak ASIHTTPRequest *blockRequest = voteAddRequest;
    
    [blockRequest setCompletionBlock:^{
        isLoading = NO;
        [self removeLoadingView];
        NSDictionary *responseDict = blockRequest.responseString.JSONValue;
        
        if ([CreaterRequest_Vote CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            [self showBannerMsgWithString:[responseDict stringWithKeyPath:@"data\\code\\message"]];
            return ;
        }
    }];
    
    
    [blockRequest setFailedBlock:^{
        isLoading = NO;
        [refreshController finishRefreshingDirection:RefreshDirectionTop];
        [self removeLoadingView];
        [self showBannerMsgWithString:@"网络连接失败，请您检查您的网络设置"];
    }];
    [self addLoadingView];
    [blockRequest startAsynchronous];
}

- (void) tapYes : (UITapGestureRecognizer*) gesture
{
    NSDictionary *subDict = boundDataSource[gesture.view.tag];
    
    [self voteAddByID:[subDict stringWithKeyPath:@"voteId"] isYES:YES];
}

- (void) tapNo : (UITapGestureRecognizer*) gesture
{
    NSDictionary *subDict = boundDataSource[gesture.view.tag];
    
    [self voteAddByID:[subDict stringWithKeyPath:@"voteId"] isYES:NO];
}

- (void) refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction
{
    if (direction == RefreshDirectionTop)
    {
        pageIndex = 0;
        [self requestVoteList];
    }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (boundDataSource.count >= totalCount)
    {
        return ;
    }
    
    UITableViewCell *lastCell = [boundTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:boundDataSource.count - 1]];
    
    if ([boundTableView.visibleCells containsObject:lastCell])
    {
        if (isLoading)
        {
            return ;
        }
        
        pageIndex++;
        
        [self requestVoteList];
    }
}

@end
