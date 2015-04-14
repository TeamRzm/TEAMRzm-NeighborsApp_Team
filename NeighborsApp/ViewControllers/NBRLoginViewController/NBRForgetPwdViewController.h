//
//  NBRForgetPwdViewController.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/14.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRBaseViewController.h"

@interface NBRForgetPwdViewController : NBRBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (strong, nonatomic) IBOutlet UIView *commitButtonView;
@property (weak, nonatomic) IBOutlet UITableView *boundTableView;

@end
