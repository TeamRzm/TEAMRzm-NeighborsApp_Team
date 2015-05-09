//
//  CommitActivityContentViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/19.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CommitActivityContentViewController.h"
#import "UICheckBox.h"
#import "FileUpLoadHelper.h"

#import "CreaterRequest_Activity.h"

@interface CommitActivityContentViewController () <UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,FileUpLoadHelperDelegate>
{
    UITableView     *boundTableView;
    
    NSArray         *cellTitiles;
    NSArray         *cellTextFieldPlaceHolder;
    NSMutableArray  *cellTextFields;
    
    UIView          *tableViewHeaderView;
    UIImageView     *headImageView;
    
    UICheckBox      *checkBox1;
    UICheckBox      *checkBox2;
    
    UICheckBoxBlock checkBoxBlock1;
    UICheckBoxBlock checkBoxBlock2;
    
    
    UIDatePicker *datePicker;
    UIToolbar    *datePickerToolBar;
    
    UITextField  *currEditTextField;
    
    
    ASIHTTPRequest   *postActivityRequest;
    FileUpLoadHelper *activityBgUpLoader;
    BOOL isSelectImage;
}
@end

@implementation CommitActivityContentViewController

- (void) toolBarDone
{
    [UIView animateWithDuration:.25f animations:^{
        datePicker.frame = CGRectMake(0, kNBR_SCREEN_H, kNBR_SCREEN_W, 216.0f);
        datePickerToolBar.frame = CGRectMake(0, kNBR_SCREEN_H, kNBR_SCREEN_W, 40.0f);
        [self unInsertBoundTableView];
    }];
}

- (void) datePickerChangedDate : (UIDatePicker*) picker
{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.timeZone = [NSTimeZone systemTimeZone];
    formater.dateFormat = @"yyyy年M月d日 HH:mm";
    currEditTextField.text = [formater stringFromDate:picker.date];
}

- (void) insertBoundTableView
{
    boundTableView.contentInset = UIEdgeInsetsMake(64, 0, 300, 0);
}

- (void) unInsertBoundTableView
{
    boundTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self insertBoundTableView];
}

- (void) resignFirstResponderWithView : (UIView*) _resgignView
{
    [super resignFirstResponderWithView:_resgignView];
    [self unInsertBoundTableView];
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([cellTextFields indexOfObject:textField] == 1 ||
        [cellTextFields indexOfObject:textField] == 2 ||
        [cellTextFields indexOfObject:textField] == 6 ||
        [cellTextFields indexOfObject:textField] == 7)
    {
        if (!datePicker)
        {
            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kNBR_SCREEN_H, kNBR_SCREEN_W, 216.0f)];
            datePicker.backgroundColor = [UIColor whiteColor];
            datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            [datePicker addTarget:self action:@selector(datePickerChangedDate:) forControlEvents:UIControlEventValueChanged];
            
            datePickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kNBR_SCREEN_H, kNBR_SCREEN_W, 40.0f)];
            UIBarButtonItem *lineItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:Nil action:Nil];
            lineItem.width = 245;
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(toolBarDone)];
            [datePickerToolBar setItems:@[lineItem, doneButton]];
            
            [self.view addSubview:datePickerToolBar];
            [self.view addSubview:datePicker];
        }
        
        [currEditTextField resignFirstResponder];
        currEditTextField = textField;
        
        //上次选择的时间还原
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        formater.timeZone = [NSTimeZone systemTimeZone];
        formater.dateFormat = @"yyyy年M月d日 HH:mm";
        
        if (textField.text.length > 0)
        {
            NSDate *selectDate = [formater dateFromString:textField.text];
            
            [datePicker setDate:selectDate animated:YES];
        }
        else
        {
            [datePicker setDate:[NSDate date] animated:YES];
            [self datePickerChangedDate:datePicker];
        }
        
        [UIView animateWithDuration:.25f animations:^{
            datePicker.frame = CGRectMake(0, kNBR_SCREEN_H - 216.0f, kNBR_SCREEN_W, 216.0f);
            datePickerToolBar.frame = CGRectMake(0, kNBR_SCREEN_H - 216 - 40, kNBR_SCREEN_W, 40.0f);
        }];
        
        return NO;
    }
    
    if (datePicker && datePicker.frame.origin.y < kNBR_SCREEN_H)
    {
        [UIView animateWithDuration:.25f animations:^{
            datePicker.frame = CGRectMake(0, kNBR_SCREEN_H, kNBR_SCREEN_W, 216.0f);
            datePickerToolBar.frame = CGRectMake(0, kNBR_SCREEN_H, kNBR_SCREEN_W, 40.0f);
        }];
    }
    
    currEditTextField = textField;
    return YES;
}

- (void) selectActivityBackGround
{
    [self takePhotoWithCount:1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发布活动";
    isSelectImage = NO;
    
    cellTitiles = @[
                    @"活动主题",
                    @"活动开始时间",
                    @"活动结束时间",
                    @"活动地点",
                    @"活动人数",
                    @"活动费用",
                    @"报名开始日期",
                    @"报名结束日期",
                    @"联系人",
                    @"联系电话",
                    ];
    
    cellTextFieldPlaceHolder = @[
                                 @"请输入活动主题",
                                 @"请选择活动开始时间",
                                 @"请选择活动结束时间",
                                 @"请输入活动地点",
                                 @"请输入活动人数",
                                 @"请输入活动费用",
                                 @"请选择报名开始日期",
                                 @"请选择报名结束日期",
                                 @"请输入联系人",
                                 @"请输入联系电话",
                                 ];
    
    cellTextFields = [[NSMutableArray alloc] init];
    for (int i = 0; i < cellTitiles.count; i++)
    {
        UITextField *subTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, kNBR_SCREEN_W - 100 - 10, 40.0f)];
        subTextFiled.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f];
        subTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        subTextFiled.placeholder = cellTextFieldPlaceHolder[i];
        subTextFiled.delegate = self;
        [self setDoneStyleTextFile:subTextFiled];
        
        [cellTextFields addObject:subTextFiled];
        
        if (i == 4 || i == 5 || i == 9)
        {
            subTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        }
    }
    
    boundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H) style:UITableViewStyleGrouped];
    boundTableView.delegate = self;
    boundTableView.dataSource = self;
    [self.view addSubview:boundTableView];
    
    //headerView
    tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, 155)];
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W / 2.0f - (330 * 0.9) / 2.0f, 155 / 2.0f - (150.0f * 0.9) / 2.0f, 330 * 0.9, 150 * 0.9)];
    headImageView.image = [UIImage imageNamed:@"pic03"];
    headImageView.contentMode = UIViewContentModeScaleAspectFit;
    headImageView.userInteractionEnabled = YES;
    headImageView.backgroundColor = [UIColor grayColor];
    [tableViewHeaderView addSubview:headImageView];
    boundTableView.tableHeaderView = tableViewHeaderView;
    
    UITapGestureRecognizer *headImageViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectActivityBackGround)];
    [tableViewHeaderView addGestureRecognizer:headImageViewTapGesture];
    
    
    checkBox1 = [[UICheckBox alloc] initWithFrame:CGRectMake(10, 40.0f / 2.0f - 25.0f / 2.0f, 25, 25)];
    checkBox1.tintColor = kNBR_ProjectColor_StandBlue;
    checkBox1.check = YES;
    
    checkBox2 = [[UICheckBox alloc] initWithFrame:CGRectMake(10, 40.0f / 2.0f - 25.0f / 2.0f, 25, 25)];
    checkBox2.tintColor = kNBR_ProjectColor_StandBlue;
    checkBox2.check = NO;
    
    __weak CommitActivityContentViewController *blockSelf = self;
    
    [checkBox1 setCheckBlock:^(UICheckBox* sender){
        [blockSelf changedCheckBox:sender];
    }];
    
    [checkBox2 setCheckBlock:^(UICheckBox* sender){
        [blockSelf changedCheckBox:sender];
    }];
    
    //提交按钮
    UIView *tableViewFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, 70)];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(15, 10, kNBR_SCREEN_W - 30, 40);
    commitButton.backgroundColor = kNBR_ProjectColor_StandBlue;
    commitButton.layer.cornerRadius = 5.0f;
    commitButton.layer.masksToBounds = YES;
    commitButton.titleLabel.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:15.0f];
    [commitButton setTitle:@"确认发布" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(postThisActivity) forControlEvents:UIControlEventTouchUpInside];
    [tableViewFootView addSubview:commitButton];
    
    
    boundTableView.tableFooterView = tableViewFootView;

}

- (void) postThisActivity
{
    for (int i = 0; i < cellTitiles.count; i++)
    {
        if ( ((UITextField*)cellTextFields[i]).text.length <= 0 )
        {
            [self showBannerMsgWithString:[NSString stringWithFormat:@"请输入%@",cellTitiles[i]]];
            
            return ;
        }
    }

    activityBgUpLoader = [[FileUpLoadHelper alloc] init];
    activityBgUpLoader.delegate = self;
    [activityBgUpLoader addUploadImage:headImageView.image];
    [self addLoadingView];
    [activityBgUpLoader startUpload];
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

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return cellTitiles.count;
    }
    else if (section == 1)
    {
        return 2;
    }
    
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.0f;
    }
    else
    {
        return 5;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.0f;
    }
    else
    {
        return 5;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    
    if (indexPath.section == 1)
    {
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, kNBR_SCREEN_W - 40, 40)];
        titleLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.0f];
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
    else
    {
        NSString *celltitle = cellTitiles[indexPath.row];
        UITextField *cellTextFiled = cellTextFields[indexPath.row];
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 40.0f)];
        titleLable.text = celltitle;
        titleLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.0f];
        titleLable.textColor = kNBR_ProjectColor_DeepBlack;
        titleLable.textAlignment = NSTextAlignmentRight;
        
        [cell.contentView addSubview:titleLable];
        [cell.contentView addSubview:cellTextFiled];
    }
    return cell;
}


- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [super assetsPickerController:picker didFinishPickingAssets:assets];
    
    if (selectImgDatas.count > 0)
    {
        headImageView.image = [self imageFromAssert:assets[0]];
        isSelectImage = YES;
    }
    
    return ;
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
    
    postActivityRequest = [CreaterRequest_Activity CreateActivityPostRequestWithTitle:((UITextField*)cellTextFields[0]).text
                                                                                begin:((UITextField*)cellTextFields[1]).text
                                                                                  end:((UITextField*)cellTextFields[2]).text
                                                                                joins:((UITextField*)cellTextFields[4]).text
                                                                                  tag:@"0"
                                                                                phone:((UITextField*)cellTextFields[9]).text
                                                                            constract:((UITextField*)cellTextFields[8]).text
                                                                              address:((UITextField*)cellTextFields[3]).text
                                                                             regstart:((UITextField*)cellTextFields[6]).text
                                                                               regend:((UITextField*)cellTextFields[7]).text
                                                                                  fee:((UITextField*)cellTextFields[5]).text
                                                                              content:((UITextField*)cellTextFields[0]).text
                                                                                files:filesArr];
    
    __weak ASIHTTPRequest *blockReqeust = postActivityRequest;
    
    [blockReqeust setCompletionBlock:^{
        [self removeLoadingView];
        NSDictionary *responseDict = blockReqeust.responseString.JSONValue;
        
        if ([CreaterRequest_Activity CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            [self showBannerMsgWithString:[responseDict stringWithKeyPath:@"data\\code\\message"]];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    
    [self setDefaultRequestFaild:blockReqeust];
    
    [postActivityRequest startAsynchronous];
}

- (void) fileUpLoadHelper : (FileUpLoadHelper*) _helper downloadedFialdWithIndex : (NSInteger) _index
{
    [self removeLoadingView];
    return ;
}

@end
