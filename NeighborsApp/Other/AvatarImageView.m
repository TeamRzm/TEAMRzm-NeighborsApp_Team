//
//  AvatarImageView.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/6/8.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "AvatarImageView.h"
#import "NBRFriendInfoViewController.h"

@interface AvatarImageView()
{
    UIViewController *pushedViewController;
    NSDictionary *userInfomationDict;
}

@end

@implementation AvatarImageView

- (void) enableAvatarModeWithUserInfoDict : (NSDictionary*) dict pushedView : (UIViewController*) _viewController
{
    if (!userInfomationDict && !pushedViewController)
    {
        userInfomationDict = dict;
        pushedViewController = _viewController;
        
        UITapGestureRecognizer *avatarTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTap:)];
        [self addGestureRecognizer:avatarTapGesture];
        self.userInteractionEnabled = YES;
    }
}

- (void) avatarTap : (UITapGestureRecognizer*) gesture
{
    NBRFriendInfoViewController *friendInfoVC = [[NBRFriendInfoViewController alloc] initWithNibName:nil bundle:nil];
    friendInfoVC.userInfoDict = userInfomationDict;
    friendInfoVC.hidesBottomBarWhenPushed = YES;
    [pushedViewController.navigationController pushViewController:friendInfoVC animated:YES];
}


@end
