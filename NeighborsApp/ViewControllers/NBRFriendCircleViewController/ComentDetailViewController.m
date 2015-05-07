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

@interface ComentDetailViewController ()<UITableViewDataSource, UITableViewDelegate,CommentTableViewCellDelegate,XHImageViewerDelegate,aya_MultimediaKeyBoardDelegate>
{
    UITableView *boundTableView;
    
    NSMutableArray  *commentList;
    
    NSArray         *zanNameList;
    
    NSMutableArray  *boundTableViewDateSource;
    
    aya_MultimediaKeyBoard  *keyBoard;
}
@end

@implementation ComentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"里手帮详情";

    commentList = [[NSMutableArray alloc] init];
    boundTableViewDateSource = [[NSMutableArray alloc] init];
    
    CommentEntity *commentEntity = [[CommentEntity alloc] init];
    commentEntity.avterIconURL = @"t_avter_2";
    commentEntity.userName = @"邻家小妹";
    commentEntity.content = @"好政策啊，咱们都要支持！来点个赞了。么么哒！！哈哈哈哈哈要够长.......................换行测试";
    commentEntity.commitDate = @"刚刚";
    
    boundTableViewDateSource = [[NSMutableArray alloc] initWithArray:@[
                                                                       self.dataEntity,
                                                                       @[commentEntity],
                                                                       @[commentEntity,
                                                                         commentEntity,
                                                                         commentEntity,
                                                                         commentEntity],
                                                                       ]];
    boundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H) style:UITableViewStylePlain];
    boundTableView.delegate = self;
    boundTableView.dataSource = self;
    boundTableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    [self.view addSubview:boundTableView];
    
    
    //键盘
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
    if (section == 0)
    {
        return 0.0f;
    }
    else
    {
        return 30;
    }
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
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
