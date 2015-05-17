//
//  IM_MsgHistoryMrg.h
//  BBG
//
//  Created by 7mallsevenk on 13-7-9.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IM_BaseMrg.h"
#import "IM_MsgHistory_En.h"

@interface IM_MsgHistoryMrg : IM_BaseMrg

+ (IM_MsgHistoryMrg *) Instance;

#pragma mark ****************************** 基础操作数据方法 ********************************

//查询
- (NSMutableArray *) getHisMsgByCondition : (NSString *) _condition;

//增加
- (BOOL) insertHisMsgByEntity : (IM_MsgHistory_En *) _en;

//修改
- (BOOL) updateHisMsgByCondition : (NSString *) _condition;

//删除
- (BOOL) deleteHisMsgByCondition : (NSString *) _condition;

#pragma mark *****************************************************************************




#pragma mark ****************************** 其他操作数据方法 ********************************


#pragma mark *****************************************************************************
- (IM_MsgHistory_En *) getMsgByFriendName:(NSString *)FriendName;

- (IM_MsgHistory_En *) getMsgInfoByMsg:(NSString *)FriendName;

- (NSMutableArray *) getChatMsgByFriendName:(NSString *)FriendName withSize:(NSInteger)size PageIndex:(NSInteger)pageindex;

-(NSInteger)getUnreadCountMsg;

- (BOOL) deleteHisMsgByFriendName : (NSString *) _friendname;

- (BOOL) updateHisMsgById : (NSInteger) _msgid withstatus:(NSString *)_status;

- (void)updateHisMsgStatusByID:(NSInteger)ID Status:(NSString *)statu;

-(BOOL) UpdateHisMsgToReadWithName:(NSString *) _name;
-(BOOL) UpdateDeleteFriendMessageToRead:(NSString *) _delfriendname;
@end
