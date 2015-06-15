//
//  NBRNewsDetailViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/6/15.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRNewsDetailViewController.h"
#import "EGOImageView.h"

@interface NBRNewsDetailViewController ()
{
    UIScrollView    *boundScrollView;
    
    UILabel         *titleLable;
    UILabel         *dateLable;
    EGOImageView    *contentImage;
    UILabel         *contentLable;
}
@end

@implementation NBRNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"动态详情";
    
    boundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H)];
    [self.view addSubview:boundScrollView];
    
    titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kNBR_SCREEN_W - 20, 40.0f)];
    titleLable.numberOfLines = 2;
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.textColor = kNBR_ProjectColor_DeepBlack;
    titleLable.text = [self.dataDict stringWithKeyPath:@"title"];
    titleLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:14.0f];
    [boundScrollView addSubview:titleLable];
    

    NSString *commitDate = [NSString stringWithFormat:@"发布时间：%@", [self stringWithString:[self.dataDict stringWithKeyPath:@"created"]]];
    dateLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 45 + 5, kNBR_SCREEN_W - 20, 20)];
    dateLable.textColor = kNBR_ProjectColor_DeepGray;
    dateLable.text = commitDate;
    dateLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:12.0f];
    dateLable.textAlignment = NSTextAlignmentCenter;
    [boundScrollView addSubview:dateLable];
    
    contentImage = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 70.0f, kNBR_SCREEN_W - 20, 140.0f)];
    contentImage.imageURL = [NSURL URLWithString:[self.dataDict stringWithKeyPath:@"image"]];
    contentImage.layer.masksToBounds = YES;
    contentImage.contentMode = UIViewContentModeScaleAspectFill;
    [boundScrollView addSubview:contentImage];
    
    
    NSString *contentString = [self.dataDict stringWithKeyPath:@"info"];
    
    NSDictionary *contentFormat = @{
                                        NSFontAttributeName : [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:15.0f],
                                        NSForegroundColorAttributeName : kNBR_ProjectColor_DeepBlack,
                                    };
    
    CGRect tempTitleFrame = [contentString boundingRectWithSize:CGSizeMake(kNBR_SCREEN_W - 20, 1000)
                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                     attributes:contentFormat
                                                        context:nil];
    contentLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 215, tempTitleFrame.size.width, tempTitleFrame.size.height)];
    contentLable.numberOfLines = 0;
    
    NSAttributedString *arrString = [[NSAttributedString alloc] initWithString:contentString attributes:contentFormat];
    contentLable.attributedText = arrString;
    [boundScrollView addSubview:contentLable];
    
    boundScrollView.contentSize = CGSizeMake(kNBR_SCREEN_W, contentLable.frame.origin.y + contentLable.frame.size.height + 10);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
