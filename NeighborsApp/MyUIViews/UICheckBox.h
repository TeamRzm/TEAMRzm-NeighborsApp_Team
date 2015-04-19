//
//  UICheckBox.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/18.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UICheckBox;

typedef void(^UICheckBoxBlock)(UICheckBox *sender);

@interface UICheckBox : UIView
@property (nonatomic, assign) BOOL check;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UICheckBoxBlock checkBlock;

- (id) initWithFrame:(CGRect)frame scale : (CGFloat) _scale;

@end
