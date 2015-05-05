//
//  NBRBaseViewController.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/13.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ALAlertBanner.h"
#import "SIAlertView.h"
#import "UIView+TopTag.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "KVNProgress.h"
#import "EGOImageView.h"

@interface NBRBaseViewController : UIViewController

- (void) resignFirstResponderWithView : (UIView*) _resgignView;
- (void) setDoneStyleTextFile : (UITextField*) _textFiled;

- (void) showBannerMsgWithString : (NSString*) _msg;

- (void) showBannerMsgWithString : (NSString *)_msg tappedBlock:(void (^)(ALAlertBanner *alertBanner))tappedBlock;

- (void) setDefaultRequestFaild : (ASIHTTPRequest*) _request;

- (void) addLoadingView;

- (void) removeLoadingView;

- (void) setNavgationBarLeftButtonIsDissmissViewController;

- (void) takePhoto;

@end
