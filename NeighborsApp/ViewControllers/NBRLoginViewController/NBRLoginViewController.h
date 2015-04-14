//
//  NBRLoginViewController.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/13.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRBaseViewController.h"
#import "EGOImageView.h"

@interface NBRLoginViewController : NBRBaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *tableViewHeadView;
@property (strong, nonatomic) IBOutlet UIView *tableVieFootView;
@property (weak, nonatomic) IBOutlet EGOImageView *headPicImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *regButton;
@property (weak, nonatomic) IBOutlet UILabel *forgetPwdLable;
@property (weak, nonatomic) IBOutlet UITableView *boundTabView;

- (IBAction)loginButtonAction:(id)sender;
- (IBAction)regButtonAction:(id)sender;

@end
