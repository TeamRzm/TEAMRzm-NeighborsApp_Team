//
//  NBRCommunityNoticeViewController.h
//  NeighborsApp
//
//  Created by jason on 15/5/16.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRBaseViewController.h"

@interface NBRCommunityNoticeViewController : NBRBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableview;
    NSMutableArray *noticeArr;
    NSInteger      currentindx;
}

@end
