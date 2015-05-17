//
//  CreateRequest_Server.h
//  NeighborsApp
//
//  Created by jason on 15/5/17.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Base.h"

@interface CreateRequest_Server : CreaterRequest_Base

//获取小区物业动态 数据标识，默认为0
//0：小区动态
//1：小区推荐动态（用于服务首页显示banner使用)
//2:业委会公告
//3:业委会会议记录
+(ASIHTTPRequest *) CreateDynamicOfPropertyInfoWithIndex:(NSString *) _index
                                                    Flag:(NSString *) _flag
                                                    Size:(NSString *) _size;

//获取当前小区花名册
+(ASIHTTPRequest *) CreateSmallRosterInfoList;


@end
