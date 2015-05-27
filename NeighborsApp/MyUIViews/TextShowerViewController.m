//
//  TextShowerViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/27.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "TextShowerViewController.h"

@interface TextShowerViewController ()
{
    UIScrollView    *boundScrollView;
    UILabel         *boundLable;
    
    
    NSString        *boundText;
    UIColor         *boundColor;
    UIFont          *boundFont;
}

@end

@implementation TextShowerViewController


- (id) initWithViewControllerTitle : (NSString*) viewControllerTitle
                        textString : (NSString*) textString
                          textFont : (UIFont*)   textFont
                         textColor : (UIColor*)  textColor
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self)
    {
        self.title = viewControllerTitle;
        boundFont = textFont;
        boundText = textString;
        boundColor = textColor;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDictionary *boundTextFormat = @{
                                      NSFontAttributeName            : boundFont,
                                      NSForegroundColorAttributeName : boundColor,
                                      };
    
    CGRect textFrame = [boundText boundingRectWithSize:CGSizeMake(kNBR_SCREEN_W - 20, MAXFLOAT)
                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                            attributes:boundTextFormat
                                               context:nil];
    
    boundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H)];
    if (CGRectGetHeight(textFrame) < kNBR_SCREEN_H)
    {
        boundScrollView.contentSize = CGSizeMake(textFrame.size.width, kNBR_SCREEN_H);
    }
    else
    {
        boundScrollView.contentSize = CGSizeMake(CGRectGetWidth(textFrame), CGRectGetHeight(textFrame));
    }
    
    [self.view addSubview:boundScrollView];
    
    boundLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(textFrame), CGRectGetHeight(textFrame))];
    boundLable.attributedText = [[NSAttributedString alloc] initWithString:boundText attributes:boundTextFormat];
    boundLable.numberOfLines = 0;
    [boundScrollView addSubview:boundLable];
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
