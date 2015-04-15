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
    tagView.alpha = 0.0f;
    
    [UIView animateWithDuration:.25f animations:^{
        tagView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];

    tagView.text = _tagString;
    
    return tagView;
}

- (void) addTopTagNumberView : (NSString*) _tagString fixOrigin : (CGPoint) _point
{
    if (nil == _tagString || [_tagString isEqualToString:@"0"])
    {
        [UIView animateWithDuration:0.25f animations:^{
            [self viewWithTag:0xAAAA].alpha = 0.0f;
        } completion:^(BOOL finished) {
            if ([self viewWithTag:0xAAAA])
            {
                [[self viewWithTag:0xAAAA] removeFromSuperview];
            }
        }];
        
        return;
    }
    
    if ([self viewWithTag:0xAAAA])
    {
        [[self viewWithTag:0xAAAA] removeFromSuperview];
    }
    
    UIView *tagView = [UIView CreateTopTagNumberView:_tagString];
    
    tagView.frame = CGRectMake(self.frame.size.width - 15.0f / 2.0f + _point.x, _point.y, 15.0f, 15.0f);
    
    [self addSubview:tagView];
    
    tagView.alpha = 0.0f;
    
    [UIView animateWithDuration:.25f animations:^{
        tagView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];

}

- (void) addTopTagNumberView : (NSString*) _tagString
{
    [self addTopTagNumberView:_tagString fixOrigin:CGPointMake(0, 0)];
}

@end
