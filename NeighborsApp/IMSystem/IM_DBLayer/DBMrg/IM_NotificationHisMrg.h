//
//  IM_NotificationHisMrg.h
//  BBG
//
//  Created by 7mallsevenk on 13-7-9.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IM_BaseMrg.h"
#import "IM_NotificationHistory_En.h"

@interface IM_NotificationHisMrg : IM_BaseMrg

+ (IM_NotificationHisMrg *) Instance;

#pragma mark ****************************** 基础操作数据方法 ********************************

//查询
- (NSMutableArray *) getHisNotiByCondition : (NSString *) _condition;

//增加
- (BOOL) insertHisNotiByEntity : (IM_NotificationHistory_En *) _en;

//修改
- (BOOL) updateHisNotiByCondition : (NSString *) _condition;

//删除
- (BOOL) deleteHisNotiByCondition : (NSString *) _condition;

#pragma mark *****************************************************************************




#pragma mark ****************************** 其他操作数据方法 ********************************


#pragma mark *****************************************************************************

//获得所有通知消息
- (NSMutableArray *)getHistoryNotifyWithUserName:(NSString *)UserName;
//获取未读通知消息数量
- (NSInteger)getSysNotifyUnreadCountWithUserName:(NSString *)UserName;
//删除某个通知消息
- (void)deleteNotifyWithUserName:(NSString *)UserName ID:(NSInteger)N_id;
//获取未读消息
-(NSMutableArray *)getSysNotifyUnreadWithUserName:(NSString *)username;
//更新消息状态
-(void)updateSysNotufyStatusWithStatus:(NSString *)status UserName:(NSString *)UserName;
-(void)updateSysMsgStateNotufyStatusWithStatus:(NSString *)status UserName:(NSString *)UserName;
//删除所有消息
-(void)deleteAllNotifyWithUserName:(NSString *)UserName;
//获得分页通知消息
- (NSMutableArray *)getHistoryPageNotifyWithUserName:(NSString *)UserName WithIndex:(NSInteger) _index;

@end
