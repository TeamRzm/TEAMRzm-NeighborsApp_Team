//
//  NBRBaseViewController.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/13.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "ALAlertBanner.h"
#import "SIAlertView.h"
#import "UIView+TopTag.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "KVNProgress.h"
#import "EGOImageView.h"

#import "CTAssetsPickerController.h"

@interface NBRBaseViewController : UIViewController
{
    NSMutableArray           *selectImgDatas;
}

- (void) resignFirstResponderWithView : (UIView*) _resgignView;
- (void) resignFirstResponder;
- (void) setDoneStyleTextFile : (UITextField*) _textFiled;

- (void) setDissMissLeftButton;

- (void) setDissMissLeftButtonWithTitle : (NSString *) _leftTitle;

- (void) showBannerMsgWithString : (NSString*) _msg;

- (void) showBannerMsgWithString : (NSString *)_msg tappedBlock:(void (^)(ALAlertBanner *alertBanner))tappedBlock;

- (void) setDefaultRequestFaild : (ASIHTTPRequest*) _request;

- (void) addLoadingView;

- (void) removeLoadingView;

- (void) setNavgationBarLeftButtonIsDissmissViewController;

- (void) takePhoto;

- (void) takePhotoWithCount : (NSInteger) _count;

//拨打电话
- (void) callTel : (NSString*) telString;

//验证小区入住情况，如果没有入住将引到入住
- (BOOL) checkJoinVillage;

//获得目标时间距离当前时间的字符串，比如 “x分钟前，x小时前，今天，昨天。等等格式”
- (NSString*) nowDateStringForDistanceDateString : (NSString*) _dateString;
+ (NSString*) nowDateStringForDistanceDateString : (NSString*) _dateString;

//例如 Apr 29, 2015 12:00:00 AM
- (NSDate*) dateWithString : (NSString*) _string;
+ (NSDate*) dateWithString : (NSString*) _string;

- (NSString*) stringWithString : (NSString*) _string;
+ (NSString*) stringWithString : (NSString*) _string;



//按需重写的Delegate
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets;

//获取图片
- (UIImage*) imageFromAssert : (ALAsset*) alasset;





@end
