//
//  ComentDetailViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/19.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "ComentDetailViewController.h"
#import "CommitNewContentViewController.h"
#import "FriendCircleContentEntity.h"
#import "CommentTableViewCell.h"
#import "CommentEntity.h"
#import "SubCommentTableViewCell.h"
#import "XHImageViewer.h"
#import "aya_MultimediaKeyBoard.h"
#import "CreaterRequest_Logroll.h"
#import "CreaterRequest_Show.h"
#import "RefreshControl.h"

@interface ComentDetailViewController ()<UITableViewDataSource, UITableViewDelegate,CommentTableViewCellDelegate,XHImageViewerDelegate,aya_MultimediaKeyBoardDelegate,RefreshControlDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    BOOL        isOwner;
    UITableView *boundTableView;
    
    NSMutableArray  *commentList;
    
    NSArray         *zanNameList;
    
    NSMutableArray  *boundTableViewDateSource;
    
    aya_MultimediaKeyBoard  *keyBoard;
    
    
    BOOL            *hasLoading;
    RefreshControl  *refreshController;
    
    ASIHTTPRequest  *replayCommentRequest;
    ASIHTTPRequest  *repliesRequest;
    ASIHTTPRequest  *acceptRequest;
    ASIHTTPRequest  *removeRequest;
    NSInteger       dataIndex;
    NSInteger       totalRecord;
    
    NSIndexPath     *selectCommentIndexPath;
    UIActionSheet   *commentActionSheet;
    
    UIAlertView     *deleteFCAlert;
}
@end

@implementation ComentDetailViewController

- (void) replayWithContent : (NSString*) _content
{
    if (self.isWarning)
    {
        replayCommentRequest = [CreaterRequest_Show CreateShowReplyRequestWithID:[self.dataEntity.dataDict stringWithKeyPath:@"showId"] info:_content files:nil];
    }
    else
    {
        replayCommentRequest = [CreaterRequest_Logroll CreateLogrollReplyRequestWithID:[self.dataEntity.dataDict stringWithKeyPath:@"logrollId"] info:_content files:nil];
    }
    
    __weak ASIHTTPRequest *blockRequest = replayCommentRequest;
    
    [blockRequest setCompletionBlock:^{
        
        [self removeLoadingView];
        
        NSDictionary *responseDict = blockRequest.responseString.JSONValue;
        
        if ([CreaterRequest_Logroll CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            [self showBannerMsgWithString:[responseDict stringWithKeyPath:@"data\\code\\message"]];
        }
        
        dataIndex = 0;
        [self requestReplies];
        
    }];
    
    [self setDefaultRequestFaild:blockRequest];
    
    [self addLoadingView];
    [replayCommentRequest startAsynchronous];

}

//删除评论
- (void) deleteReplyWithIndex : (NSIndexPath *) _index
{
    CommentEntity *subComment = boundTableViewDateSource[_index.section][_index.row];
    
    if (self.isWarning)
    {
        removeRequest = [CreaterRequest_Show CreateDeleteRequestWithID:subComment.ID type:@"1"];
    }
    else
    {
        removeRequest = [CreaterRequest_Logroll CreateDeleteRequestWithID:subComment.ID type:@"1"];
    }
    
    __weak ASIHTTPRequest *blockRequest = removeRequest;
    
    [blockRequest setCompletionBlock:^{
        [self removeLoadingView];
        NSDictionary *responseDict = blockRequest.responseString.JSONValue;
        
        if ([CreaterRequest_Logroll CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            [self showBannerMsgWithString:[responseDict stringWithKeyPath:@"data\\code\\message"]];
            
            dataIndex = 0;
            [self requestReplies];
        }
    }];
    
    [self setDefaultRequestFaild:blockRequest];
    
    [self addLoadingView];
    [removeRequest startAsynchronous];

}

//删除该里手帮
- (void) deleteRequest
{
    if (self.isWarning)
    {
        removeRequest = [CreaterRequest_Show CreateDeleteRequestWithID:self.dataEntity.dataDict[@"showId"] type:@"0"];
    }
    else
    {
        removeRequest = [CreaterRequest_Logroll CreateDeleteRequestWithID:self.dataEntity.dataDict[@"logrollId"] type:@"0"];
    }
    
    __weak ASIHTTPRequest *blockRequest = removeRequest;
    
    [blockRequest setCompletionBlock:^{
        [self removeLoadingView];
        NSDictionary *responseDict = blockRequest.responseString.JSONValue;
        
        if ([CreaterRequest_Logroll CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            if (self.isWarning)
            {
                [self showBannerMsgWithString:@"该安全预警信息已成功删除"];
            }
            else
            {
                [self showBannerMsgWithString:@"该里手帮信息已成功删除"];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    [self setDefaultRequestFaild:blockRequest];
    
    [removeRequest startAsynchronous];
    [self addLoadingView];
}

//接受该回复为最佳答案
- (void) acceptReplyWithIndex : (NSIndexPath *) _index
{
    CommentEntity *subComment = boundTableViewDateSource[_index.section][_index.row];
    
    if (self.isWarning)
    {
        acceptRequest = [CreaterRequest_Show CreateAcceptRequestWithID:subComment.ID];
    }
    else
    {
        acceptRequest = [CreaterRequest_Logroll CreateAcceptRequestWithID:subComment.ID];
    }
    
    __weak ASIHTTPRequest *blockRequest = acceptRequest;
    
    [blockRequest setCompletionBlock:^{
        
        [self removeLoadingView];
        
        NSDictionary *responseDict = blockRequest.responseString.JSONValue;
        
        if ([CreaterRequest_Logroll CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            [self showBannerMsgWithString:[responseDict stringWithKeyPath:@"data\\code\\message"]];
            
            dataIndex = 0;
            [self requestReplies];
        }
        
    }];
    
    [self setDefaultRequestFaild:acceptRequest];
    
    [self addLoadingView];
    [acceptRequest startAsynchronous];
}

- (void) requestReplies
{
    if (self.isWarning)
    {
        repliesRequest = [CreaterRequest_Show CreateShowRepliesRequestWithID:[self.dataEntity.dataDict stringWithKeyPath:@"showId"] index:ITOS(dataIndex) size:kNBR_PAGE_SIZE_STR];
    }
    else
    {
        repliesRequest = [CreaterRequest_Logroll CreateLogrollListRequestWithID:[self.dataEntity.dataDict stringWithKeyPath:@"logrollId"] index:ITOS(dataIndex) size:kNBR_PAGE_SIZE_STR];
    }
    
    __weak ASIHTTPRequest *blockRequest = repliesRequest;
    
    [blockRequest setCompletionBlock:^{
        
        [self removeLoadingView];
        
        NSDictionary *responseDict = blockRequest.responseString.JSONValue;
        
        if ([CreaterRequest_Logroll CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            NSArray *contentEntityDictArr = [responseDict arrayWithKeyPath:@"data\\result\\data"];
            totalRecord = [responseDict numberWithKeyPath:@"data\\result\\totalRecord"];
            
            NSMutableArray *commentArray = [[NSMutableArray alloc] init];
            if (dataIndex == 0)
            {
                [refreshController finishRefreshingDirection:RefreshDirectionBottom];
                
                [boundTableViewDateSource[1] removeAllObjects];
            }
            
            for (int i = 0; i < contentEntityDictArr.count; i++)
            {
                NSDictionary *entityDict = contentEntityDictArr[i];
                
                CommentEntity *commentEntity = [[CommentEntity alloc] init];
                commentEntity.avterIconURL = [entityDict stringWithKeyPath:@"userInfo\\avater"];
                commentEntity.userName = [entityDict stringWithKeyPath:@"userInfo\\nickName"];
                commentEntity.content = [entityDict stringWithKeyPath:@"content"];
                commentEntity.commitDate = [self nowDateStringForDistanceDateString:[entityDict stringWithKeyPath:@"created"]];
                commentEntity.ID = [entityDict stringWithKeyPath:@"replyId"];
                commentEntity.ownerID = [entityDict stringWithKeyPath:@"userInfo\\userId"];
                
                if ([entityDict numberWithKeyPath:@"accept"])
                {
                    [boundTableViewDateSource[1] addObject:commentEntity];
                }
                else
                {
                    [commentArray addObject:commentEntity];
                }
            }
            
            
            NSMutableArray *insertIndexPath = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < commentArray.count; i++)
            {
                [insertIndexPath addObject:[NSIndexPath indexPathForRow:((NSMutableArray*)boundTableViewDateSource[2]).count + i inSection:2]];
            }
            
            if (dataIndex == 0)
            {
                [boundTableViewDateSource[2] removeAllObjects];
            }
            
            [boundTableViewDateSource[2] addObjectsFromArray:commentArray];
            
            if (dataIndex == 0)
            {
                [boundTableView reloadData];
            }
            else
            {
                [boundTableView insertRowsAtIndexPaths:insertIndexPath withRowAnimation:UITableViewRowAnimationAutomatic];
            }

            return ;
        }
    }];
    
    [blockRequest setFailedBlock:^{
        [refreshController finishRefreshingDirection:RefreshDirectionBottom];
        [self removeLoadingView];
        [self showBannerMsgWithString:@"网络连接失败，请您检查您的网络设置"];
    }];
    
    [self addLoadingView];
    [repliesRequest startAsynchronous];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isOwner = NO;
    if (self.isWarning)
    {
        self.title = @"安全预警详情";
    }
    else
    {
        self.title = @"里手帮详情";
    }

    commentList = [[NSMutableArray alloc] init];
    boundTableViewDateSource = [[NSMutableArray alloc] init];
    
    
    boundTableViewDateSource = [[NSMutableArray alloc] initWithArray:@[
                                                                       self.dataEntity,
                                                                       [[NSMutableArray alloc] init],
                                                                       [[NSMutableArray alloc] init],
                                                                       ]];
    boundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kNBR_SCREEN_W, kNBR_SCREEN_H - 64 - 40) style:UITableViewStyleGrouped];
    boundTableView.delegate = self;
    boundTableView.dataSource = self;
    boundTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
//    boundTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    [self.view addSubview:boundTableView];
    
    refreshController = [[RefreshControl alloc] initWithScrollView:boundTableView delegate:self];
    refreshController.topEnabled = YES;
    
    //键盘
    
    if ([AppSessionMrg shareInstance].isInVillage)
    {
        keyBoard = [[aya_MultimediaKeyBoard alloc] initWithKeyBoardTypeIsComment:YES];
        keyBoard.backgroundColor = [UIColor whiteColor];
        [keyBoard setDelegate:self];
        [self.view addSubview:keyBoard];
    }
    
    [self requestReplies];
    [self isMyCommitDate];
}

- (void) shouldDeleteComment
{
    deleteFCAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否确定删除该里手帮" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [deleteFCAlert show];
}

//当前登陆游湖的主题
- (void) isMyCommitDate
{
    if ([[self.dataEntity.dataDict stringWithKeyPath:@"userId"] isEqualToString:[AppSessionMrg shareInstance].userEntity.userId])
    {
        isOwner = YES;
        
        UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(shouldDeleteComment)];
        
        [deleteItem setTitleTextAttributes:@{
                                             NSForegroundColorAttributeName  : UIColorFromRGB(0xFFFFFF),
                                             NSFontAttributeName             : [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:15.0f],
                                             }
                                  forState:UIControlStateNormal];
        
        self.navigationItem.rightBarButtonItem = deleteItem;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || (((NSMutableArray*)boundTableViewDateSource[1]).count <= 0 && section == 1))
    {
        return 0.1f;
    }
    else
    {
        return 30;
    }
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 || (((NSMutableArray*)boundTableViewDateSource[1]).count <= 0 && section == 1) ||
        (((NSMutableArray*)boundTableViewDateSource[2]).count <= 0 && section == 2))
    {
        return [[UIView alloc] init];
    }
    else
    {
        UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, 30)];
        sectionHeaderView.backgroundColor = kNBR_ProjectColor_BackGroundGray;
        sectionHeaderView.layer.borderColor = kNBR_ProjectColor_LineLightGray.CGColor;
        sectionHeaderView.layer.borderWidth = 0.5f;
        
        UILabel *sectionHeaderLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kNBR_SCREEN_W - 30, 30)];
        sectionHeaderLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:14.0f];
        sectionHeaderLable.textColor = kNBR_ProjectColor_DeepBlack;
        sectionHeaderLable.text = section == 1 ? @"最佳回答" : @"其他回答";
        [sectionHeaderView addSubview:sectionHeaderLable];
        
        return sectionHeaderView;
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return boundTableViewDateSource.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return ((NSArray*)boundTableViewDateSource[section]).count;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return [CommentTableViewCell heightWithEntity:boundTableViewDateSource[indexPath.section]] - 30;
    }
    else
    {
        return [SubCommentTableViewCell HeightWithEntity:boundTableViewDateSource[indexPath.section][indexPath.row]];
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        CommentTableViewCell *cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
        
        cell.delegate = self;
        
        cell.layer.masksToBounds = YES;
        
        FriendCircleContentEntity *cellEntity = boundTableViewDateSource[indexPath.section];
        
        [cell setDateEntity:cellEntity];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else
    {
        CommentEntity *cellEntity = boundTableViewDateSource[indexPath.section][indexPath.row];
        
        SubCommentTableViewCell *cell = [[SubCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
        
        [cell setDataEntity:cellEntity];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 || indexPath.section == 1)
    {
        selectCommentIndexPath = indexPath;
        
        CommentEntity *subComment = boundTableViewDateSource[indexPath.section][indexPath.row];
        
        if ([subComment.ownerID isEqualToString:[AppSessionMrg shareInstance].userEntity.userId])
        {
            if (isOwner)
            {
                //表示评论是登陆用户发的，主题也是登陆用户发的
                if (indexPath.section == 1)
                {
                    commentActionSheet = [[UIActionSheet alloc] initWithTitle:@"对该评论进行操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil];
                }
                else
                {
                    commentActionSheet = [[UIActionSheet alloc] initWithTitle:@"对该评论进行操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"接受该答复", nil];
                }
            }
            else
            {
                commentActionSheet = [[UIActionSheet alloc] initWithTitle:@"对该评论进行操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil];
            }
        }
        else
        {
            //评论是其他用户发的，主题是自己的
            if (isOwner)
            {
                commentActionSheet = [[UIActionSheet alloc] initWithTitle:@"对该评论进行操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"接受该答复", nil];
            }
        }
        
        if (commentActionSheet)
        {
            [commentActionSheet showInView:self.view];
        }
    }
}

- (void) commentTableViewCell : (CommentTableViewCell*) _cell tapSubImageViews : (UIImageView*) tapView allSubImageViews : (NSMutableArray *) _allSubImageviews
{
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    imageViewer.delegate = self;
    [imageViewer showWithImageViews:_allSubImageviews selectedView:tapView];
}

- (void)imageViewer:(XHImageViewer *)imageViewer  willDismissWithSelectedView:(UIImageView*)selectedView
{
    
    return ;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (((NSMutableArray*)boundTableViewDateSource[2]).count +  ((NSMutableArray*)boundTableViewDateSource[1]).count >= totalRecord)
    {
        return ;
    }
    
    UITableViewCell *lastCell = [boundTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:((NSMutableArray*)boundTableViewDateSource[2]).count - 1 inSection:2]];
    
    if ([boundTableView.visibleCells containsObject:lastCell])
    {
        if (hasLoading)
        {
            return ;
        }
        
        dataIndex ++;
        [self requestReplies];
    }
}

- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ( actionSheet == commentActionSheet )
    {
        CommentEntity *subComment = boundTableViewDateSource[selectCommentIndexPath.section][selectCommentIndexPath.row];
        
        if ([subComment.ownerID isEqualToString:[AppSessionMrg shareInstance].userEntity.userId])
        {
            if (isOwner)
            {
                //表示评论是登陆用户发的，主题也是登陆用户发的
                if (selectCommentIndexPath.section == 1)
                {
                    if (buttonIndex == 0)
                    {
                        [self deleteReplyWithIndex:selectCommentIndexPath];
                    }
                }
                else
                {
                    if (buttonIndex == 0)
                    {
                        [self deleteReplyWithIndex:selectCommentIndexPath];
                    }
                    else if (buttonIndex == 1)
                    {
                        [self acceptReplyWithIndex:selectCommentIndexPath];
                    }
                }
            }
            else
            {
                if (buttonIndex == 0)
                {
                    [self deleteReplyWithIndex:selectCommentIndexPath];
                }
            }
        }
        else
        {
            //评论是其他用户发的，主题是自己的
            if (isOwner)
            {
                if (buttonIndex == 0)
                {
                    [self acceptReplyWithIndex:selectCommentIndexPath];
                }
            }
        }
    }
}

#pragma mark -- Keyboard Delegate
//Keyboard Delegate
- (void) ayaKeyBoard:(aya_MultimediaKeyBoard*) _keyboard willChangedKeyBoardStatus : (KEYBOARD_STATUS) _status currKeyboardHeight : (CGFloat) _height
{
    
}

- (void) ayaKeyBoard:(aya_MultimediaKeyBoard*) _keyboard willFinishInputMsg : (NSString*) _string
{
    if (_string.length > 0)
    {
        [self replayWithContent:_string];
    }
    [keyBoard hidekeyboardview];
}

- (void) ayaKeyBoard:(aya_MultimediaKeyBoard*) _keyboard willSelectOtherBoardIndex : (NSInteger) _index
{
    
}

- (void) ayaKeyBoard:(aya_MultimediaKeyBoard*) _keyboard willFinishInputAmrData : (NSData*) _amrStrame timeLen : (NSTimeInterval) _timeLen
{
    
}

- (void) ayaKeyBoard:(aya_MultimediaKeyBoard*) _keyboard quikLookImg : (UIImage*) _limg
{
    
}

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction
{
    dataIndex = 0;
    [self requestReplies];
}

#pragma mark -- UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == deleteFCAlert)
    {
        if (buttonIndex == 1)
        {
            [self deleteRequest];
        }
    }
}

@end
