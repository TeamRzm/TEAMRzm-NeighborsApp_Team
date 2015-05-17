//
//  NBRChatSettingViewController.h
//  NeighborsApp
//
//  Created by jason on 15/5/16.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRBaseViewController.h"

@interface NBRChatSettingViewController : NBRBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableview;
    NSMutableArray *settingArr;
}

@end
