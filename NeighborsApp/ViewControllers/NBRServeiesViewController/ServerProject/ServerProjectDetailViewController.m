//
//  ServerProjectDetailViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/6/12.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "ServerProjectDetailViewController.h"
#import "EGOImageView.h"

@interface ServerProjectDetailViewController ()
{
    UIScrollView *boundScrollView;
    NSDictionary *serverProjectDict;
}
@end

@implementation ServerProjectDetailViewController

- (id) initWithDict : (NSDictionary*) _dataDict
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self)
    {
        serverProjectDict = _dataDict;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"服务详情";
    
    boundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H)];
    boundScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:boundScrollView];
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kNBR_SCREEN_W, 40.0f)];
    titleLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:14.0f];
    titleLable.textColor = kNBR_ProjectColor_StandBlue;
    titleLable.numberOfLines = 2;
    titleLable.text = [serverProjectDict stringWithKeyPath:@"name"];
    [boundScrollView addSubview:titleLable];
    
    
    NSString *contentString = [serverProjectDict stringWithKeyPath:@"content"];
    
    NSDictionary *contentFormat = @{
                                    NSFontAttributeName : [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f],
                                    NSForegroundColorAttributeName : kNBR_ProjectColor_DeepGray,
                                    };
    
    CGRect contentFrame = [contentString boundingRectWithSize:CGSizeMake(kNBR_SCREEN_W - 20, 1000)
                                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                   attributes:contentFormat
                                                      context:nil];
    
    UILabel *contentLable = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                      50,
                                                                      kNBR_SCREEN_W - 20,
                                                                      contentFrame.size.height)];
    
    NSAttributedString *contentAttString = [[NSAttributedString alloc] initWithString:contentString attributes:contentFormat];
    contentLable.attributedText = contentAttString;
    contentLable.numberOfLines = 0;
    [boundScrollView addSubview:contentLable];
    
    EGOImageView *logoImageView = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 55 + contentFrame.size.height + 5, 120, 80)];
    logoImageView.imageURL = [NSURL URLWithString:[serverProjectDict arrayWithKeyPath:@"files"][0][@"url"]];
    [boundScrollView addSubview:logoImageView];
    
    
    UIView *telphoneView = [[UIView alloc] initWithFrame:CGRectMake(10, logoImageView.frame.origin.y + 85, kNBR_SCREEN_W - 20, 25.0f)];
    telphoneView.userInteractionEnabled = YES;
    UITapGestureRecognizer *callTelGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callConstract)];
    [telphoneView addGestureRecognizer:callTelGesture];
    
    telphoneView.backgroundColor = UIColorFromRGB(0xECF1F5);
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 5, 10, 14)];
    iconView.image = [UIImage imageNamed:@"dianhua"];
    [telphoneView addSubview:iconView];
    
    UILabel *telLable = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, kNBR_SCREEN_W - 40, 25.0f)];
    telLable.font = [UIFont systemFontOfSize:13.f];
    telLable.text = [serverProjectDict stringWithKeyPath:@"constract"];
    [telphoneView addSubview:telLable];
    
    [boundScrollView addSubview:telphoneView];
    boundScrollView.contentSize = CGSizeMake(kNBR_SCREEN_W, telphoneView.frame.origin.y + telphoneView.frame.size.height);
}

- (void) callConstract
{
    [self callTel:[serverProjectDict stringWithKeyPath:@"constract"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
