//
//  IM_FriendMrg.h
//  BBG
//
//  Created by 7mallsevenk on 13-7-9.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IM_BaseMrg.h"
#import "IM_Friend_En.h"

@interface IM_FriendMrg : IM_BaseMrg

+ (IM_FriendMrg *) Instance;

#pragma mark ****************************** 基础操作数据方法 ********************************

//查询
- (NSMutableArray *) getFriendByCondition : (NSString *) _condition;

//增加
- (BOOL) insertFriendByEntity : (IM_Friend_En *) _en;

//修改
- (BOOL) updateFriendByCondition : (NSString *) _condition;

//删除
- (BOOL) deleteFriendByCondition : (NSString *) _condition;

//根据用户名查询
- (IM_Friend_En *) getFriendInfoByFriendName : (NSString *) _friendname;

#pragma mark *****************************************************************************




#pragma mark ****************************** 其他操作数据方法 ********************************


#pragma mark *****************************************************************************

-(NSString *) getFriendIconByFriendName:(NSString *)FriendName Owner:(NSString *)owner;

-(void) updateFriendaccount:(IM_Friend_En *)enity;

- (NSMutableArray *)getUserFriendListWithUserName:(NSString *)UserName;

- (BOOL) removeFriendShipWithUserName : (NSString *) _shipId;
-(BOOL) updateFriendInfoWithUserName:(IM_Friend_En *)enity;

-(void)deleteFriendDataByHisName:(NSString *)friendName;

-(void)updateFrienddeleteFlagbyFriendName:(NSString *)username;
@end
