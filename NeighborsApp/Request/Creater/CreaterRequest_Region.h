//
//  CreaterRequest_Region.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/7.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Base.h"

@interface CreaterRequest_Region : CreaterRequest_Base

//获取中国的行政区域信息
+ (ASIHTTPRequest*) CreateListRequest;



@end
