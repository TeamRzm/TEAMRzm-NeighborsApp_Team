//
//  CommitNewContentViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/18.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CommitNewContentViewController.h"
#import "UITextView+Placeholder.h"
#import "UICheckBox.h"
#import "CTAssetsPickerController.h"
#import "XHImageViewer.h"
#import "FileUpLoadHelper.h"
#import "CreaterRequest_Logroll.h"
#import "CreaterRequest_Show.h"

const CGFloat   CommitImageViewHeightAndWidth = 62.8;
const NSInteger CommitImageViewWidthCount     = 5;

@interface CommitNewContentViewController () <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,CTAssetsPickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,XHImageViewerDelegate,FileUpLoadHelperDelegate>
{
    UITableView *boundTableView;
    
    UITextView  *commentInpuTextView;
    
    UICheckBox  *checkBox1;
    UICheckBox  *checkBox2;
    
    UICheckBoxBlock checkBoxBlock1;
    UICheckBoxBlock checkBoxBlock2;
    
    UIView          *selectImgView;
    NSMutableArray  *selectImgDatas;
    NSMutableArray  *currentSelectImageViews;
    UIView          *addImageButton;
    
    CTAssetsPickerController *imageSelectPicker;
    
    
    UILongPressGestureRecognizer            *currLongPressGesture;
    
    
    FileUpLoadHelper *uploadHelper;
    ASIHTTPRequest *commentUploadRequest;
}

@end

@implementation CommitNewContentViewController

- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 0xAAAAAA)
    {
        if (buttonIndex == 0)
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.navigationController presentViewController:picker animated:YES completion:^{
                
            }];
            
            return ;
        }
        else if (buttonIndex == 1)
        {
            imageSelectPicker = [[CTAssetsPickerController alloc] init];
            imageSelectPicker.assetsFilter         = [ALAssetsFilter allAssets];
            imageSelectPicker.showsCancelButton    = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);
            imageSelectPicker.delegate             = self;
            imageSelectPicker.selectedAssets       = [NSMutableArray arrayWithArray:selectImgDatas];
            
            [self presentViewController:imageSelectPicker animated:YES completion:nil];
            
            return ;
        }
    }
    else if (actionSheet.tag == 0xCCCCCC)
    {
        if (buttonIndex == 0)
        {
            NSInteger assetIndex = [currentSelectImageViews indexOfObject:currLongPressGesture.view];
            [selectImgDatas removeObjectAtIndex:assetIndex];

            [currentSelectImageViews removeObject:currLongPressGesture.view];
            
            [self drawSendImageUIWithAnimation:UITableViewRowAnimationNone];
            
            currLongPressGesture = nil;
            
            return ;
        }
        else if (buttonIndex == 1)
        {
            imageSelectPicker = [[CTAssetsPickerController alloc] init];
            imageSelectPicker.assetsFilter         = [ALAssetsFilter allAssets];
            imageSelectPicker.showsCancelButton    = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);
            imageSelectPicker.delegate             = self;
            imageSelectPicker.selectedAssets       = [NSMutableArray arrayWithArray:selectImgDatas];
            
            [self presentViewController:imageSelectPicker animated:YES completion:nil];
            
            return ;
        }
    }
}

- (void) addImgButtonAction : (id) sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"照片库", nil];
    actionSheet.tag = 0xAAAAAA;
    [actionSheet showInView:self.view];
}

- (void) drawSendImageUIWithAnimation : (UITableViewRowAnimation) _animation
{
    NSInteger imgsViewHIndex = (selectImgDatas.count + 1) / CommitImageViewWidthCount  + ((selectImgDatas.count + 1) % CommitImageViewWidthCount == 0 ? 0 : 1);
    CGSize imgsViewSize = CGSizeMake(CommitImageViewHeightAndWidth * CommitImageViewWidthCount, imgsViewHIndex * CommitImageViewHeightAndWidth);
    
    if (!addImageButton)
    {
        addImageButton = [UIView CreateAddButtonWithFrame:CGRectMake(0, 0, CommitImageViewHeightAndWidth - 5, CommitImageViewHeightAndWidth - 5) color:kNBR_ProjectColor_LightGray];
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImgButtonAction:)];
        [addImageButton addGestureRecognizer:tapGesture];
    }
    
    
    if (!selectImgView)
    {
        selectImgView = [[UIView alloc] initWithFrame:CGRectMake(5, 225 - CommitImageViewHeightAndWidth, imgsViewSize.width, CommitImageViewHeightAndWidth * imgsViewSize.height)];
    }
    else
    {
        [selectImgView removeFromSuperview];
        selectImgView = [[UIView alloc] initWithFrame:CGRectMake(5, 225 - CommitImageViewHeightAndWidth, imgsViewSize.width, CommitImageViewHeightAndWidth * imgsViewSize.height)];
    }
    
    currentSelectImageViews = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < selectImgDatas.count + 1 ; i++)
    {
        
        if (i == selectImgDatas.count)
        {
            //最后一个元素
            addImageButton.frame = CGRectMake((i % CommitImageViewWidthCount) * CommitImageViewHeightAndWidth, (i / CommitImageViewWidthCount) * CommitImageViewHeightAndWidth, CommitImageViewHeightAndWidth - 5, CommitImageViewHeightAndWidth - 5);
            [selectImgView addSubview:addImageButton];
        }
        else
        {
            UIImageView *subImageView = [[UIImageView alloc] initWithFrame:CGRectMake((i % CommitImageViewWidthCount) * CommitImageViewHeightAndWidth,
                                                                                      (i / CommitImageViewWidthCount) * CommitImageViewHeightAndWidth,
                                                                                      CommitImageViewHeightAndWidth - 5,
                                                                                      CommitImageViewHeightAndWidth - 5)];
            subImageView.layer.cornerRadius = 3.0f;
            subImageView.layer.masksToBounds = 3.0f;
            subImageView.userInteractionEnabled = YES;
            subImageView.tag = 0xCCCC;
            
            UITapGestureRecognizer *subImageViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subSelectImageViewTapGestureAction:)];
            [subImageView addGestureRecognizer:subImageViewTapGesture];
            
            UILongPressGestureRecognizer *subImageViewLongPressGesture  = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(subSelectImageViewLongPressAction:)];
            [subImageView addGestureRecognizer:subImageViewLongPressGesture];
            
            ALAsset *subAsset = selectImgDatas[i];
            
            UIImage *image;
            
            if (subAsset.defaultRepresentation)
            {
                image = [UIImage imageWithCGImage:subAsset.defaultRepresentation.fullScreenImage
                                            scale:1.0f
                                      orientation:UIImageOrientationUp];
            }
            
            subImageView.image = image;

            [currentSelectImageViews addObject:subImageView];
            [selectImgView addSubview:subImageView];
        }
    }
    
    [boundTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:_animation];
}

//长按单个图片
- (void) subSelectImageViewLongPressAction : (UILongPressGestureRecognizer*) _gesture
{
    if (currLongPressGesture)
    {
        return ;
    }
    
    currLongPressGesture = _gesture;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"重新选择", nil];
    actionSheet.tag = 0xCCCCCC;
    [actionSheet showInView:self.view];
}

//点击单个选择的图片，放大显示
- (void) subSelectImageViewTapGestureAction : (UITapGestureRecognizer*) _gesture
{
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    imageViewer.delegate = self;
    [imageViewer showWithImageViews:currentSelectImageViews selectedView:(UIImageView *)_gesture.view];
}

- (void)imageViewer:(XHImageViewer *)imageViewer  willDismissWithSelectedView:(UIImageView*)selectedView
{
    return;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"发布里手帮";
    
    selectImgDatas = [[NSMutableArray alloc] init];
    
    boundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H) style:UITableViewStyleGrouped];
    boundTableView.delegate = self;
    boundTableView.dataSource = self;
    [self.view addSubview:boundTableView];
    
    commentInpuTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, kNBR_SCREEN_W - 20, 170 - 20)];
    commentInpuTextView.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f];
    commentInpuTextView.returnKeyType = UIReturnKeyDone;
    

    [self resignFirstResponderWithView:commentInpuTextView];
    [commentInpuTextView setPlaceHolder:@"请输入..."];
    
    checkBox1 = [[UICheckBox alloc] initWithFrame:CGRectMake(10, 40.0f / 2.0f - 25.0f / 2.0f, 25, 25)];
    checkBox1.tintColor = kNBR_ProjectColor_StandBlue;
    checkBox1.check = YES;
    
    checkBox2 = [[UICheckBox alloc] initWithFrame:CGRectMake(10, 40.0f / 2.0f - 25.0f / 2.0f, 25, 25)];
    checkBox2.tintColor = kNBR_ProjectColor_StandBlue;
    checkBox2.check = NO;
    
    __weak CommitNewContentViewController *blockSelf = self;
    
    [checkBox1 setCheckBlock:^(UICheckBox* sender){
        [blockSelf changedCheckBox:sender];
    }];
    
    [checkBox2 setCheckBlock:^(UICheckBox* sender){
        [blockSelf changedCheckBox:sender];
    }];
    
    [self drawSendImageUIWithAnimation:UITableViewRowAnimationAutomatic];
    
    //提交按钮
    UIView *tableViewFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, 75)];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(15, 30, kNBR_SCREEN_W - 30, 40);
    commitButton.backgroundColor = kNBR_ProjectColor_StandBlue;
    commitButton.layer.cornerRadius = 5.0f;
    commitButton.layer.masksToBounds = YES;
    commitButton.titleLabel.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:15.0f];
    [commitButton setTitle:@"确认发布" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commentNewContent) forControlEvents:UIControlEventTouchUpInside];
    [tableViewFootView addSubview:commitButton];
    
    
    boundTableView.tableFooterView = tableViewFootView;
}

- (void) commentNewContent
{
    if (commentInpuTextView.text <= 0)
    {
        [self showBannerMsgWithString:@"请输入内容"];
        
        return ;
    }
    
    uploadHelper = [[FileUpLoadHelper alloc] init];
    uploadHelper.delegate = self;
    
    for (int i = 0; i < selectImgDatas.count; i++)
    {
        ALAsset *subAsset = selectImgDatas[i];
        
        UIImage *image;
        
        if (subAsset.defaultRepresentation)
        {
            image = [UIImage imageWithCGImage:subAsset.defaultRepresentation.fullScreenImage
                                        scale:1.0f
                                  orientation:UIImageOrientationUp];
        }
        
        [uploadHelper addUploadImage:image];
    }
    
    [self addLoadingView];
    [uploadHelper startUpload];
}

#pragma mark UploadDelegate
- (void) fileUpLoadHelper : (FileUpLoadHelper*) _helper downloadedIndex : (NSInteger) _index downloadTotal : (NSInteger) _total
{
    return ;
}

- (void) fileUpLoadHelper : (FileUpLoadHelper*) _helper allDownloadedResponseDictArr : (NSArray*) _dictArr
{
    NSMutableArray *filesArr = [[NSMutableArray alloc] init];
    
    for (NSDictionary *subDict in _dictArr)
    {
        [filesArr addObject:subDict[@"fileId"]];
    }
    
    if (self.mode == COMMIT_TO_MODE_SHOW)
    {
        commentUploadRequest = [CreaterRequest_Show  CreateShowPostReuqetWithInfo:commentInpuTextView.text tag:@"0" flag:@"1" files:filesArr];
    }
    else
    {
        commentUploadRequest = [CreaterRequest_Logroll CreateLogrollCommitRequestWithTitle:@"NoTitle" info:commentInpuTextView.text files:filesArr tag:@"0"];
    }
    
    __weak ASIHTTPRequest *blockRequest = commentUploadRequest;
    
    [blockRequest setCompletionBlock:^{
        
        [self removeLoadingView];
        
        NSDictionary *responseDict = [blockRequest.responseString JSONValue];
        
        if ([CreaterRequest_Logroll CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            [self showBannerMsgWithString:[responseDict stringWithKeyPath:@"data\\code\\message"]];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            return ;
        }
        
        return ;
    }];
    
    [self setDefaultRequestFaild:commentUploadRequest];
    
    [commentUploadRequest startAsynchronous];

    return ;
}

- (void) fileUpLoadHelper : (FileUpLoadHelper*) _helper downloadedFialdWithIndex : (NSInteger) _index
{
    [self removeLoadingView];
    return ;
}

- (void) changedCheckBox : (UICheckBox*) sender
{
    if (sender == checkBox1 && checkBox1.check)
    {
        return ;
    }
    
    if (sender == checkBox2 && checkBox2.check)
    {
        return ;
    }
    
    checkBox1.check = !checkBox1.check;
    checkBox2.check = !checkBox2.check;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 2;
    }
    
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        NSInteger imgsViewHIndex = (selectImgDatas.count + 1) / CommitImageViewWidthCount  + ((selectImgDatas.count + 1) % CommitImageViewWidthCount == 0 ? 0 : 1);
        CGSize imgsViewSize = CGSizeMake(CommitImageViewHeightAndWidth * CommitImageViewWidthCount, imgsViewHIndex * CommitImageViewHeightAndWidth);
        
        return 170 + imgsViewSize.height;
    }
    else
    {
        return 40;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1f;
    }
    else
    {
        return 15.0f;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        [self changedCheckBox:checkBox1];
    }
    else if (indexPath.section == 1 && indexPath.row == 1)
    {
        [self changedCheckBox:checkBox2];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        [cell.contentView addSubview:commentInpuTextView];
        [cell.contentView addSubview:selectImgView];
    }
    
    if (indexPath.section == 1)
    {
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, kNBR_SCREEN_W - 40, 40)];
        titleLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13.0f];
        titleLable.textColor = kNBR_ProjectColor_DeepBlack;
        
        if (indexPath.row == 0)
        {
            titleLable.text = @"所有小区可见";
            [cell.contentView addSubview:checkBox1];
        }
        else if (indexPath.row == 1)
        {
            titleLable.text = @"本小区可见";
            [cell.contentView addSubview:checkBox2];
        }
        
        [cell.contentView addSubview:titleLable];
    }
    
    
    return cell;
}


- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    selectImgDatas = [[NSMutableArray alloc] initWithArray:assets];
    
    [imageSelectPicker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    [self drawSendImageUIWithAnimation:UITableViewRowAnimationAutomatic];
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldEnableAsset:(ALAsset *)asset
{
    // Enable video clips if they are at least 5s
    if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
    {
        NSTimeInterval duration = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
        return lround(duration) >= 5;
    }
    else
    {
        return YES;
    }
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset
{
    if (picker.selectedAssets.count >= 10)
    {
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"Attention"
                                   message:@"Please select not more than 10 assets"
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"OK", nil];
        
        [alertView show];
    }
    
    if (!asset.defaultRepresentation)
    {
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"Attention"
                                   message:@"Your asset has not yet been downloaded to your device"
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"OK", nil];
        
        [alertView show];
    }
    
    return (picker.selectedAssets.count < 10 && asset.defaultRepresentation != nil);
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"])
    {
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
//        EditImageViewController *edit_vc = [[EditImageViewController alloc] init];
//        [edit_vc setSourceImg:originImage];
//        [edit_vc setEditImageDelegate:self];
//        [picker pushViewController:edit_vc animated:YES];
    }
    return;
}


@end
