//
//  NBRDynamicofPropertyViewController.h
//  NeighborsApp
//
//  Created by jason on 15/5/17.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRBaseViewController.h"

@interface NBRDynamicofPropertyViewController : NBRBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableview;
    NSMutableArray *dataArr;
    ASIHTTPRequest *dynamicReq;
}

@end
