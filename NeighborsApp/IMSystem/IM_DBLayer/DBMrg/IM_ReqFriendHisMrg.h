//
//  IM_ReqFriendHisMrg.h
//  BBG
//
//  Created by 7mallsevenk on 13-7-9.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IM_BaseMrg.h"
#import "IM_RequestFriendHistory_En.h"

@interface IM_ReqFriendHisMrg : IM_BaseMrg

+ (IM_ReqFriendHisMrg *) Instance;

#pragma mark ****************************** 基础操作数据方法 ********************************

//查询
- (NSMutableArray *) getHisReqFriendByCondition : (NSString *) _condition;

//增加
- (BOOL) insertHisReqFriendByEntity : (IM_RequestFriendHistory_En *) _en;

//修改
- (BOOL) updateHisReqFriendByCondition : (NSString *) _condition;

//删除
- (BOOL) deleteHisReqFriendByCondition : (NSString *) _condition;

#pragma mark *****************************************************************************




#pragma mark ****************************** 其他操作数据方法 ********************************


#pragma mark *****************************************************************************


@end
