//
//  UIImage+UserInfo.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/6/8.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "UIImage+UserInfo.h"
#import "NBRFriendInfoViewController.h"

@implementation UIImageView(UserInfo)

- (void) enableAvatarModeWithUserInfoDict : (NSDictionary*) dict pushedView : (UIViewController*) _viewController
{
    return ;
    if (!self.userInfomationDict && !self.pushedViewController)
    {
        self.userInfomationDict = dict;
        self.pushedViewController = _viewController;
        
        UITapGestureRecognizer *avatarTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTap:)];
        [self addGestureRecognizer:avatarTapGesture];
        self.userInteractionEnabled = YES;
    }
}

- (void) avatarTap : (UITapGestureRecognizer*) gesture
{
    NBRFriendInfoViewController *friendInfoVC = [[NBRFriendInfoViewController alloc] initWithNibName:nil bundle:nil];
    friendInfoVC.userInfoDict = self.userInfomationDict;
    friendInfoVC.hidesBottomBarWhenPushed = YES;
    [self.pushedViewController.navigationController pushViewController:friendInfoVC animated:YES];
}

@end
