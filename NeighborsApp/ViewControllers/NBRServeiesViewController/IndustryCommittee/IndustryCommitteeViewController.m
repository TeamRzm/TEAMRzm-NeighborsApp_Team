//
//  IndustryCommitteeViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/27.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "IndustryCommitteeViewController.h"
#import "CreaterRequest_Owner.h"
#import "TextShowerViewController.h"
#import "NBRDynamicofPropertyViewController.h"

@interface IndustryCommitteeViewController ()
{
    ASIHTTPRequest  *infoRequest;
    NSDictionary    *infoResposneDict;
}
@end

@implementation IndustryCommitteeViewController

- (void) requestInfo
{
    infoRequest = [CreaterRequest_Owner CreateInfoRequest];
    
    __weak ASIHTTPRequest* blockRequest = infoRequest;
    
    [blockRequest setCompletionBlock:^{
        [self removeLoadingView];
        NSDictionary *responseDict = blockRequest.responseString.JSONValue;

        if ([CreaterRequest_Owner CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            infoResposneDict = responseDict;
            self.titleLable.text = [responseDict stringWithKeyPath:@"data\\result\\realName"];
            
            if (self.titleLable.text.length <= 0)
            {
                self.titleLable.text = @"未知";
            }
            
            return ;
        }
    }];
    
    [self setDefaultRequestFaild:infoRequest];
    
    [self addLoadingView];
    [blockRequest startAsynchronous];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"业委会";
    
    for (UIImageView *subImageIcon in self.imageIcones)
    {
        subImageIcon.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTapGesture:)];
        [subImageIcon addGestureRecognizer:tapGesture];
    }
    
    self.zoneIcon.backgroundColor = [UIColor whiteColor];
    self.zoneIcon.layer.cornerRadius = self.zoneIcon.frame.size.width / 2.0f;
    self.zoneIcon.layer.masksToBounds = YES;
    
    // Do any additional setup after loading the view from its nib.
    [self.boundScrollview addSubview:self.contentView];
    self.boundScrollview.contentSize = CGSizeMake(CGRectGetWidth(self.contentView.frame),
                                                  CGRectGetHeight(self.contentView.frame));
    
    [self requestInfo];
}

- (void) iconTapGesture : (UITapGestureRecognizer*) _tapGesture
{
    switch (_tapGesture.view.tag)
    {
        case 0:
        {
            NBRDynamicofPropertyViewController *dynViewController = [[NBRDynamicofPropertyViewController alloc] initWithMode:DYNAMICO_PROPERTY_VIEWCONTROLLER_MODE_INDUSTRY];
            
            [self.navigationController pushViewController:dynViewController animated:YES];
            
            return ;
        }
            break;
            
        case 4:
        {
            TextShowerViewController *textShowVc = [[TextShowerViewController alloc] initWithViewControllerTitle:@"业委会规章"
                                                                                                      textString:[infoResposneDict stringWithKeyPath:@"data\\result\\info"]
                                                                                                         textFont:[UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f]
                                                                                                       textColor:kNBR_ProjectColor_DeepGray];
            
            [self.navigationController pushViewController:textShowVc animated:YES];
            
            return ;
        }
            break;
            
        default:
            break;
    }
    
    [self showBannerMsgWithString:@"敬请期待"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
