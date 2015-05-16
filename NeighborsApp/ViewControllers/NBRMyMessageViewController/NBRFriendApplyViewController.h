//
//  NBRFriendApplyViewController.h
//  NeighborsApp
//
//  Created by jason on 15/5/16.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRBaseViewController.h"

@interface NBRFriendApplyViewController : NBRBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableview;
    NSMutableArray *applyData;
    ASIHTTPRequest *applyRequst;
}
@end
