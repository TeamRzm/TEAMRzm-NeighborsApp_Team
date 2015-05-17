//
//  IM_ConversationMrg.h
//  BBG
//
//  Created by 7mallsevenk on 13-7-9.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IM_Conversation_En.h"
#import "IM_BaseMrg.h"

@interface IM_ConversationMrg : IM_BaseMrg

+ (IM_ConversationMrg *) Instance;

#pragma mark ****************************** 基础操作数据方法 ********************************

//查询
- (NSMutableArray *) getConversationByCondition : (NSString *) _condition;

//增加
- (BOOL) insertConversationByEntity : (IM_Conversation_En *) _en;

//修改
- (BOOL) updateConversationByCondition : (NSString *) _condition;

//删除
- (BOOL) deleteConversationByCondition : (NSString *) _condition;

#pragma mark *****************************************************************************




#pragma mark ****************************** 其他操作数据方法 ********************************


#pragma mark *****************************************************************************
- (IM_Conversation_En *)getFriendConversationObjByFriendName:(NSString *)friendName;

- (void) updateFriendConversation:(IM_Conversation_En *)friendObj;

- (NSMutableArray *)getConversationListByUserName;

-(void)deleteConversationByFriendName:(NSString *)name;

@end
