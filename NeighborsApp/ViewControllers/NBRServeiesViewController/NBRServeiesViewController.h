//
//  NBRServeiesViewController.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/3/26.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRBaseViewController.h"

@interface NBRServeiesViewController : NBRBaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UITableView *myTableview;
    NSMutableArray *titleNameArr;
    NSMutableArray *logoArr;
    UIScrollView   *headerScrollview;
    NSMutableArray *scrollDataArr;
    UIPageControl *pagcontrol;
    NSInteger     *selectpage;
    
    ASIHTTPRequest *dynamicRecReq;
    
}

@end
