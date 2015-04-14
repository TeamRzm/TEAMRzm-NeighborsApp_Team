//
//  UIImageView+TopTag.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/14.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "UIView+TopTag.h"

@implementation UIView(TopTag)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (UIView*) CreateTopTagNumberView : (NSString*) _tagString
{
    UILabel *tagView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15.0f, 15.0f)];
    tagView.layer.cornerRadius = 15.0f / 2.0f;
    tagView.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:10.0f];
    tagView.backgroundColor = UIColorFromRGB(0xFEAE2F);
    tagView.textColor = UIColorFromRGB(0xFFFFFF);
    tagView.textAlignment = NSTextAlignmentCenter;
    tagView.layer.masksToBounds = YES;
    tagView.tag = 0xAAAA;

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.25f];
    tagView.text = _tagString;
    [UIView commitAnimations];
    
    return tagView;
}

@end
