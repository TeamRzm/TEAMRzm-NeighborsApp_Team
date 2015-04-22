//
//  FeedBackViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/23.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "FeedBackViewController.h"
#import "FriendCircleContentEntity.h"
#import "CommentTableViewCell.h"
#import "CommentEntity.h"
#import "SubCommentTableViewCell.h"
#import "XHImageViewer.h"
#import "aya_MultimediaKeyBoard.h"

@interface FeedBackViewController ()<UITableViewDataSource, UITableViewDelegate,CommentTableViewCellDelegate,XHImageViewerDelegate,aya_MultimediaKeyBoardDelegate>
{
    UITableView *boundTableView;
    
    NSMutableArray  *commentList;
    
    NSMutableArray  *boundTableViewDateSource;
    
    aya_MultimediaKeyBoard  *keyBoard;
}
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"里手帮详情";
    
    commentList = [[NSMutableArray alloc] init];
    boundTableViewDateSource = [[NSMutableArray alloc] init];
    
    CommentEntity *commentEntity = [[CommentEntity alloc] init];
    commentEntity.avterIconURL = @"t_avter_2";
    commentEntity.userName = @"邻家小妹";
    commentEntity.content = @"意见反馈，意见反馈，意见反馈，好政策啊，咱们都要支持！来点个赞了。么么哒！！哈哈哈哈哈要够长,换行测试";
    commentEntity.commitDate = @"2015年12月14日";
    
    boundTableViewDateSource = [[NSMutableArray alloc] initWithArray:@[
                                                                       commentEntity,
                                                                       commentEntity,
                                                                       commentEntity,
                                                                       commentEntity,
                                                                       ]];
    boundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H) style:UITableViewStyleGrouped];
    boundTableView.delegate = self;
    boundTableView.dataSource = self;
    boundTableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    [self.view addSubview:boundTableView];
    
    //键盘
    keyBoard = [[aya_MultimediaKeyBoard alloc] initWithKeyBoardTypeIsComment:YES];
    keyBoard.backgroundColor = [UIColor whiteColor];
    [keyBoard setDelegate:self];
    [self.view addSubview:keyBoard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .1f;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return boundTableViewDateSource.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SubCommentTableViewCell HeightWithEntity:boundTableViewDateSource[indexPath.row]];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentEntity *cellEntity = boundTableViewDateSource[indexPath.row];
    
    SubCommentTableViewCell *cell = [[SubCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    
    [cell setDataEntity:cellEntity];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
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


#pragma mark -- Keyboard Delegate
//Keyboard Delegate
- (void) ayaKeyBoard:(aya_MultimediaKeyBoard*) _keyboard willChangedKeyBoardStatus : (KEYBOARD_STATUS) _status currKeyboardHeight : (CGFloat) _height
{
    
}

- (void) ayaKeyBoard:(aya_MultimediaKeyBoard*) _keyboard willFinishInputMsg : (NSString*) _string
{
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

@end
