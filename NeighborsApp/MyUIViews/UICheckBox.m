//
//  UICheckBox.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/18.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "UICheckBox.h"

@interface UICheckBox()
{
    UIView *checkBgView;
    UIView *checkFrView;
}

@end

@implementation UICheckBox

- (id) initWithFrame:(CGRect)frame scale : (CGFloat) _scale
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        checkBgView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) / 2.0f - CGRectGetWidth(frame) * _scale / 2.0f,
                                                               CGRectGetHeight(frame) / 2.0f - CGRectGetHeight(frame) * _scale / 2.0f,
                                                               CGRectGetWidth(frame) * _scale,
                                                               CGRectGetHeight(frame) * _scale)];
        checkBgView.layer.cornerRadius = CGRectGetWidth(frame) * _scale / 2.0f;
        checkBgView.layer.masksToBounds = YES;
        checkBgView.layer.borderColor = [UIColor grayColor].CGColor;
        checkBgView.layer.borderWidth = 1.0f;
        checkBgView.userInteractionEnabled = NO;
        
        checkFrView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) / 2.0f - CGRectGetWidth(frame) * 0.5 / 2.0f * _scale,
                                                               CGRectGetHeight(frame) / 2.0f - CGRectGetWidth(frame) * 0.5 / 2.0f * _scale,
                                                               CGRectGetWidth(frame) * 0.5 * _scale,
                                                               CGRectGetHeight(frame) * 0.5 * _scale)];
        checkFrView.layer.cornerRadius = CGRectGetWidth(checkFrView.frame) / 2.0f;
        checkFrView.layer.masksToBounds = YES;
        checkFrView.userInteractionEnabled = NO;
        
        [self addSubview:checkBgView];
        [self addSubview:checkFrView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewCheckAction:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void) viewCheckAction : (id) sender
{
    if (_checkBlock)
    {
        _checkBlock(self);
    }
}

- (id) initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame scale:0.8];
}

- (void) setCheck:(BOOL) _tcheck
{
    _check = _tcheck;
    if (_tcheck)
    {
        checkBgView.layer.borderColor = _tintColor.CGColor;
        checkFrView.backgroundColor = _tintColor;
    }
    else
    {
        checkBgView.layer.borderColor = [UIColor grayColor].CGColor;
        checkFrView.backgroundColor = [UIColor clearColor];
    }
}

@end
