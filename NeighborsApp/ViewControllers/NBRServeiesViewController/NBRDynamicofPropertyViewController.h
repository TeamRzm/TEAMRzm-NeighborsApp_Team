//
//  NBRDynamicofPropertyViewController.h
//  NeighborsApp
//
//  Created by jason on 15/5/17.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRBaseViewController.h"


typedef enum
{
    DYNAMICO_PROPERTY_VIEWCONTROLLER_MODE_ZONE,                 //小区动态
    DYNAMICO_PROPERTY_VIEWCONTROLLER_MODE_ZONE_BANNER,          //小区动态banner
    DYNAMICO_PROPERTY_VIEWCONTROLLER_MODE_INDUSTRY,             //业委会公告
    DYNAMICO_PROPERTY_VIEWCONTROLLER_MODE_INDUSTRY_METT,        //业委会会议记录
}DYNAMICO_PROPERTY_VIEWCONTROLLER_MODE;

@interface NBRDynamicofPropertyViewController : NBRBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableview;
    NSMutableArray *dataArr;
    ASIHTTPRequest *dynamicReq;
}

- (id) initWithMode : (DYNAMICO_PROPERTY_VIEWCONTROLLER_MODE) _mode;

@end
