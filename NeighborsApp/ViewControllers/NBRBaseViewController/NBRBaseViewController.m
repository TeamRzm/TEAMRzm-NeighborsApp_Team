//
//  NBRBaseViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/13.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRBaseViewController.h"

@interface NBRBaseViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CTAssetsPickerControllerDelegate,CLLocationManagerDelegate>
{
    CTAssetsPickerController *imageSelectPicker;
    NSInteger                 selectImgaeCount;
    
    AddressBlock             addressSuccessBlock;
    AddressBlock             addressFaildBlock;
}


@property (nonatomic, retain) CLLocationManager* locationMgr;
@property (nonatomic, retain) CLGeocoder* clGeocoder;// iso 5.0及5.0以上SDK版本使

@end

@implementation NBRBaseViewController

- (void) startGetLoction
{
    self.locationMgr = [[CLLocationManager alloc] init];
    
    //设置代理
    self.locationMgr.delegate = self;
    
    // 设置定位精度
    // kCLLocationAccuracyNearestTenMeters:精度10米
    // kCLLocationAccuracyHundredMeters:精度100 米
    // kCLLocationAccuracyKilometer:精度1000 米
    // kCLLocationAccuracyThreeKilometers:精度3000米
    // kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
    // kCLLocationAccuracyBestForNavigation:导航情况下最高精度，一般要有外接电源时才能使用
    self.locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
    
    // distanceFilter是距离过滤器，为了减少对定位装置的轮询次数，位置的改变不会每次都去通知委托，而是在移动了足够的距离时才通知委托程序
    // 它的单位是米，这里设置为至少移动1000再通知委托处理更新;
    self.locationMgr.distanceFilter = 1000.0f;
    
    //开始定位
    [self.locationMgr startUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *cl = [locations objectAtIndex:0];
    NSLog(@"纬度--%f",cl.coordinate.latitude);
    NSLog(@"经度--%f",cl.coordinate.longitude);
    
    [self.locationMgr stopUpdatingLocation];
    addressFaildBlock(cl);
}


//获取定位失败回调方法
#pragma mark - location Delegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.locationMgr stopUpdatingLocation];
    addressFaildBlock(nil);
}


- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        selectImgaeCount = 0;
    }
    return self;
}

- (void) dissmissLeftButtonAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) takePhoto
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"照片库", nil];
    actionSheet.tag = 0xAAAAAA;
    [actionSheet showInView:self.view];
}

- (void) takePhotoWithCount : (NSInteger) _count
{
    [self takePhoto];
    selectImgaeCount = _count;
}

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
}

- (void) setNavgationBarLeftButtonIsDissmissViewController
{
    UIButton *dissmissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dissmissButton.frame = CGRectMake(0, 0, 12, 19.5);
    [dissmissButton setImage:[UIImage imageNamed:@"backFlag"] forState:UIControlStateNormal];
    [dissmissButton addTarget:self action:@selector(dissmissLeftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:dissmissButton];
    
    self.navigationItem.leftBarButtonItem = leftButton;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    CGSize imageSize = CGSizeMake(50, 50);
//    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
//    [kNBR_ProjectColor_StandBlue set];
//    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
//    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    [[UINavigationBar appearance] setBackgroundImage:pressedColorImg forBarMetrics:UIBarMetricsDefault];
//    
//    [[UINavigationBar appearance] setTintColor:kNBR_ProjectColor_StandWhite];
//    
//    [[UINavigationBar appearance] setTitleTextAttributes:@{
//                                                           NSForegroundColorAttributeName  : UIColorFromRGB(0xFFFFFF),
//                                                           NSFontAttributeName             : [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:18.0f],
//                                                           }];
    
    self.view.backgroundColor = kNBR_ProjectColor_BackGroundGray;
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] init];
    
    [backButtonItem setTitleTextAttributes:@{
                                             NSForegroundColorAttributeName  : UIColorFromRGB(0xFFFFFF),
                                             NSFontAttributeName             : [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:15.0f],
                                             }
                                  forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = backButtonItem;
    
}

- (void) showBannerMsgWithString : (NSString *)_msg tappedBlock:(void (^)(ALAlertBanner *alertBanner))tappedBlock
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:appDelegate.window style:ALAlertBannerStyleWarning position:ALAlertBannerPositionBottom title:@"温馨提示" subtitle:_msg tappedBlock:^(ALAlertBanner *alertBanner)
                             {
                                 tappedBlock(alertBanner);
                             }];
    
    banner.secondsToShow = 3.0f;
    banner.showAnimationDuration = .25f;
    banner.hideAnimationDuration = .25f;
    [banner show];
}

- (void) showBannerMsgWithString : (NSString*) _msg
{
    [self showBannerMsgWithString:_msg tappedBlock:^(ALAlertBanner *alertBanner) {
        [alertBanner hide];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) resignFirstResponderWithView : (UIView*) _resgignView
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}

- (void) setDoneStyleTextFile : (UITextField*) _textFiled
{
    _textFiled.returnKeyType = UIReturnKeyDone;
    _textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textFiled.textColor = kNBR_ProjectColor_DeepGray;
    _textFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textFiled.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f];
    [_textFiled addTarget:self action:@selector(resignFirstResponderWithView:) forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void) setDefaultRequestFaild : (ASIHTTPRequest*) _request
{
    [_request setFailedBlock:^{
        [self removeLoadingView];
        [self showBannerMsgWithString:@"网络连接失败，请您检查您的网络设置"];
    }];
}

- (UIImage*) imageFromAssert : (ALAsset*) alasset
{
    ALAsset *subAsset = alasset;
    
    UIImage *image;
    
    if (subAsset.defaultRepresentation)
    {
        image = [UIImage imageWithCGImage:subAsset.defaultRepresentation.fullScreenImage
                                    scale:1.0f
                              orientation:UIImageOrientationUp];
    }
    
    return image;
}


- (void) addLoadingView
{
    [KVNProgress showWithParameters:@{
                                      KVNProgressViewParameterStatus: @"正在加载...",
                                      KVNProgressViewParameterBackgroundType: @(KVNProgressBackgroundTypeSolid),
                                      KVNProgressViewParameterFullScreen: @(NO)
                                      }];
    
    return ;
}

- (void) removeLoadingView
{
    [KVNProgress dismiss];
    
    return ;
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    selectImgDatas = [[NSMutableArray alloc] initWithArray:assets];
    
    [imageSelectPicker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    return ;
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
    if (picker.selectedAssets.count >= (selectImgaeCount == 0 ? 10 : selectImgaeCount))
    {
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                   message:[NSString stringWithFormat:@"请不要选择超过%d张照片", selectImgaeCount == 0 ? 10 : selectImgaeCount]
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"我知道了", nil];
        
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
    
    return (picker.selectedAssets.count < (selectImgaeCount == 0 ? 10 : selectImgaeCount) && asset.defaultRepresentation != nil);
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

+ (NSString*) nowDateStringForDistanceDateString : (NSString*) _dateString
{
    NSString *createdTime = _dateString;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    dateFormatter.dateFormat = @"LLL d,yyyy hh:mm:ss a";
    
    NSDate *createdDate = [dateFormatter dateFromString:createdTime];
    NSTimeInterval distanceSec = [[NSDate date] timeIntervalSinceDate:createdDate];
    
    NSTimeInterval sec = distanceSec;
    
    //六十秒
    if (sec / 60 <= 5 )
    {
        createdTime = @"刚刚";
    }
    
    if (sec / 60 > 5)
    {
        createdTime = [NSString stringWithFormat:@"%d分钟前", (int)sec / 60];
    }
    
    if (sec / 3600 > 1)
    {
        createdTime = [NSString stringWithFormat:@"%d小时前", (int)sec / 3600];
    }
    
    //大于六小时，小于24小时
    if (sec / 3600 > 6.0f && sec / 3600 < 24.0f)
    {
        NSDateFormatter *formarter = [[NSDateFormatter alloc] init];
        [formarter setTimeZone:[NSTimeZone systemTimeZone]];
        formarter.dateFormat = @"今天 H:mm";
        
        createdTime = [NSString stringWithFormat:@"%@", [formarter stringFromDate:createdDate]];
    }
    
    //大于二十四小时小雨48小时
    if (sec / 3600 > 24 && sec / 3600 < 48)
    {
        NSDateFormatter *formarter = [[NSDateFormatter alloc] init];
        [formarter setTimeZone:[NSTimeZone systemTimeZone]];
        formarter.dateFormat = @"昨天 H:mm";
        
        createdTime = [NSString stringWithFormat:@"%@", [formarter stringFromDate:createdDate]];
    }
    
    //大于48小时小于72小时
    if (sec / 3600 > 24 && sec / 3600 < 72)
    {
        NSDateFormatter *formarter = [[NSDateFormatter alloc] init];
        [formarter setTimeZone:[NSTimeZone systemTimeZone]];
        formarter.dateFormat = @"前天 H:mm";
        
        createdTime = [NSString stringWithFormat:@"%@", [formarter stringFromDate:createdDate]];
    }
    
    if (sec / 3600 > 72)
    {
        NSDateFormatter *defulatFormat = [[NSDateFormatter alloc] init];
        [defulatFormat setTimeZone:[NSTimeZone systemTimeZone]];
        defulatFormat.dateFormat = @"M月d日 H:mm";
        createdTime = [NSString stringWithFormat:@"%@", [defulatFormat stringFromDate:createdDate]];
    }
    
    //大于一个月
    if (sec / 3600 > 24 * 31)
    {
        NSDateFormatter *formarter = [[NSDateFormatter alloc] init];
        [formarter setTimeZone:[NSTimeZone systemTimeZone]];
        formarter.dateFormat = @"YY年M月d日 H:mm";
        
        createdTime = [NSString stringWithFormat:@"%@", [formarter stringFromDate:createdDate]];
    }
    
    return createdTime;
}

- (void) startGetLoctionWithSuccessBlock : (AddressBlock) successBlock
                              faildBlock : (AddressBlock) faildBlock
{
    [self startGetLoction];
    
    addressSuccessBlock = successBlock;
    addressFaildBlock = faildBlock;
}

- (NSString*) nowDateStringForDistanceDateString : (NSString*) _dateString
{
    NSString *createdTime = _dateString;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    dateFormatter.dateFormat = @"LLL d,yyyy hh:mm:ss a";
    
    NSDate *createdDate = [dateFormatter dateFromString:createdTime];
    NSTimeInterval distanceSec = [[NSDate date] timeIntervalSinceDate:createdDate];
    
    NSTimeInterval sec = distanceSec;
    
    //六十秒
    if (sec / 60 <= 5 )
    {
        createdTime = @"刚刚";
    }
    
    if (sec / 60 > 5)
    {
        createdTime = [NSString stringWithFormat:@"%d分钟前", (int)sec / 60];
    }
    
    if (sec / 3600 > 1)
    {
        createdTime = [NSString stringWithFormat:@"%d小时前", (int)sec / 3600];
    }
    
    //大于六小时，小于24小时
    if (sec / 3600 > 6.0f && sec / 3600 < 24.0f)
    {
        NSDateFormatter *formarter = [[NSDateFormatter alloc] init];
        [formarter setTimeZone:[NSTimeZone systemTimeZone]];
        formarter.dateFormat = @"今天 H:mm";
        
        createdTime = [NSString stringWithFormat:@"%@", [formarter stringFromDate:createdDate]];
    }
    
    //大于二十四小时小雨48小时
    if (sec / 3600 > 24 && sec / 3600 < 48)
    {
        NSDateFormatter *formarter = [[NSDateFormatter alloc] init];
        [formarter setTimeZone:[NSTimeZone systemTimeZone]];
        formarter.dateFormat = @"昨天 H:mm";
        
        createdTime = [NSString stringWithFormat:@"%@", [formarter stringFromDate:createdDate]];
    }
    
    //大于48小时小于72小时
    if (sec / 3600 > 24 && sec / 3600 < 72)
    {
        NSDateFormatter *formarter = [[NSDateFormatter alloc] init];
        [formarter setTimeZone:[NSTimeZone systemTimeZone]];
        formarter.dateFormat = @"前天 H:mm";
        
        createdTime = [NSString stringWithFormat:@"%@", [formarter stringFromDate:createdDate]];
    }
    
    if (sec / 3600 > 72)
    {
        NSDateFormatter *defulatFormat = [[NSDateFormatter alloc] init];
        [defulatFormat setTimeZone:[NSTimeZone systemTimeZone]];
        defulatFormat.dateFormat = @"M月d日 H:mm";
        createdTime = [NSString stringWithFormat:@"%@", [defulatFormat stringFromDate:createdDate]];
    }
    
    //大于一个月
    if (sec / 3600 > 24 * 31)
    {
        NSDateFormatter *formarter = [[NSDateFormatter alloc] init];
        [formarter setTimeZone:[NSTimeZone systemTimeZone]];
        formarter.dateFormat = @"YY年M月d日 H:mm";
        
        createdTime = [NSString stringWithFormat:@"%@", [formarter stringFromDate:createdDate]];
    }
    
    return createdTime;
    
}

+ (NSDate*) dateWithString : (NSString*) _string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    dateFormatter.dateFormat = @"LLL d,yyyy hh:mm:ss a";
    
    return [dateFormatter dateFromString:_string];
}

- (NSDate*) dateWithString : (NSString*) _string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    dateFormatter.dateFormat = @"LLL d,yyyy hh:mm:ss a";
    
    return [dateFormatter dateFromString:_string];
}

@end
