//
//  ActivityDateEntity.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/18.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum
{
    ACTIVITY_STATE_UNKOWN,      //未知
    ACTIVITY_STATE_RES,         //接受报名
    ACTIVITY_STATE_STARTING,    //已经开始
    ACTIVITY_STATE_END,         //已经结束
    ACTIVITY_STATE_VAIL,        //已经过期
}ACTIVITY_STATE;


@interface ActivityDateEntity : NSObject
//活动海报
@property (nonatomic, copy) NSString* backGounrdUrl;

//报名时间
@property (nonatomic, copy) NSString* regDate;

//显示活动状态比如 15/20 标示总额20个已经报名15个
@property (nonatomic, copy) NSString* leftTagStr;

//活动标题
@property (nonatomic, copy) NSString* titile;

//活动发布时间
@property (nonatomic, copy) NSString* commitDate;

//价格，如果价格小于0.0，则显示免费
@property (nonatomic, copy) NSString* price;

//ID
@property (nonatomic, copy) NSString* activityID;

@property (nonatomic, strong) NSDictionary *dateDict;

@property (nonatomic, assign) ACTIVITY_STATE activityState;
@end
