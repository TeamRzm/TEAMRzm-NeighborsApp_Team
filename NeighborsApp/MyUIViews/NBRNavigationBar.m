//
//  NBRNavigationBar.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/14.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRNavigationBar.h"

@implementation NBRNavigationBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    CGSize imageSize = CGSizeMake(50, 50);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [kNBR_ProjectColor_StandBlue set];
//    [UIColorFromRGB(0x43A8EE) set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [[UINavigationBar appearance] setBackgroundImage:pressedColorImg forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTintColor:kNBR_ProjectColor_StandWhite];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName  : UIColorFromRGB(0xFFFFFF),
                                                           NSFontAttributeName             : [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:18.0f],
                                                           }];
}

@end
