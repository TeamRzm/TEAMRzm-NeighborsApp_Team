//
//  NBRBaseViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/13.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRBaseViewController.h"

@interface NBRBaseViewController ()

@end

@implementation NBRBaseViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavgationBarBackGroundImg"] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTintColor:kNBR_ProjectColor_StandWhite];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName  : UIColorFromRGB(0xFFFFFF),
                                                           NSFontAttributeName             : [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:18.0f],
                                                           }];
    
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
    [_resgignView resignFirstResponder];
}

- (void) setDoneStyleTextFile : (UITextField*) _textFiled
{
    _textFiled.returnKeyType = UIReturnKeyDone;
    _textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_textFiled addTarget:self action:@selector(resignFirstResponderWithView:) forControlEvents:UIControlEventEditingDidEndOnExit];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
