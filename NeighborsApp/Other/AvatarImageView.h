//
//  AvatarImageView.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/6/8.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvatarImageView : UIImageView

- (void) enableAvatarModeWithUserInfoDict : (NSDictionary*) dict pushedView : (UIViewController*) _viewController;

@end
