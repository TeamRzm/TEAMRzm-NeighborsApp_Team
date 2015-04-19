//
//  UIVIew+RadioBox.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/18.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIVIew_RadioBox : UIView

@property (nonatomic, assign) BOOL check;

+ (UIView*) CreateCheckRadioBoxWithFrame : (CGRect) frame;

@end
