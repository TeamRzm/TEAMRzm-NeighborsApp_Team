//
//  IM_ConversationMrg.m
//  BBG
//
//  Created by 7mallsevenk on 13-7-9.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import "IM_ConversationMrg.h"
#import "AppSessionMrg.h"

@implementation IM_ConversationMrg

-(id)init
{
    if(self = [super init])
    {
        
    }
    return self;
}

+ (IM_ConversationMrg *) Instance
{
    static IM_ConversationMrg *instance;
	@synchronized(self)
    {
		if(!instance)
        {
			instance = [[IM_ConversationMrg alloc] init];
		}
	}
	return instance;
}

#pragma mark ****************************** 基础操作数据方法 ********************************

- (NSMutableArray *) getConversationByCondition : (NSString *) _condition
{
 //   NSString *idStr = [self _lockWithMethodName:@"getConversationByCondition"];
    
    NSMutableArray *return_arr = [[NSMutableArray alloc] init];
    
    
    NSString *sqlcom_select ;
    
    sqlcom_select = [NSString stringWithFormat:@"select * from tbl_Conversation %@",_condition];
    
    sqlite3_stmt *statement;
    
    const char   *eorInfo;
    
    if (![self _openDataBase])
    {
        return return_arr;
    }
    
    if (sqlite3_prepare(data_base, [sqlcom_select UTF8String], -1, &statement, &eorInfo) == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            IM_Conversation_En *en = [[IM_Conversation_En alloc] init];
            
            en.C_Id             =   sqlite3_column_int(statement, 0);
            en.C_UserName       =   sqlite3_safe_column_text(statement, 1);
            en.C_To             =   sqlite3_safe_column_text(statement, 2);
            en.C_UnReadMsgCount =   sqlite3_column_int(statement, 3);
            en.C_LastMsgId      =   sqlite3_column_int(statement, 4);
            NSString  *str = sqlite3_safe_column_text(statement, 5);
            NSDateFormatter *ft = [[NSDateFormatter alloc] init];
            [ft setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            en.C_LastUpdateTime = [ft dateFromString:str];
            [return_arr addObject:en];
        }
    }
    else
    {
        NSLog(@"%@",[NSString stringWithUTF8String:eorInfo]);
    }
    
    sqlite3_finalize(statement);
    
    [self _closeDataBase];
    
 //   [self _unlockWithMethodName:@"getConversationByCondition" LockId:idStr];
    
    return  return_arr;
}

-(BOOL) insertConversationByEntity : (IM_Conversation_En *) _en
{
    NSString *idStr = [self _lockWithMethodName:@"insertConversationByEntity"];
    
    BOOL insert_result = false;
    
    if (![self _openDataBase])
    {
        return false;
    }
    
    NSString *unReadCountStr = [NSString stringWithFormat:@"%d",_en.C_UnReadMsgCount];
    NSString *msgIdStr = [NSString stringWithFormat:@"%d",_en.C_LastMsgId];
    
    NSString *sqlcom_insert = [NSString stringWithFormat:
                               @"insert into tbl_Conversation values (NULL, '%@', '%@', '%@', '%@', '%@')",
                               getInsertString(_en.C_UserName),
                               getInsertString(_en.C_To),
                               getInsertString(unReadCountStr),
                               getInsertString(msgIdStr),
                               [self getDateStr:_en.C_LastUpdateTime]];
    
    int error_code = 0;
    
    if ((error_code = sqlite3_exec(data_base, [sqlcom_insert UTF8String], NULL, NULL, NULL)) == SQLITE_OK)
    {
        insert_result = true;
        NSLog(@"insert conversation ok!");
    }
    else
    {
        NSLog(@"insert conversation fail!: %s.", sqlite3_errmsg(data_base));
    }
    
    [self _closeDataBase];
    
    [self _unlockWithMethodName:@"insertConversationByEntity" LockId:idStr];
    
    return insert_result;
}

-(BOOL) updateConversationByCondition : (NSString *) _condition
{
//    NSString *idStr = [self _lockWithMethodName:@"updateConversationByCondition"];
    
    BOOL update_resulte = false;
    
    if (![self _openDataBase])
    {
        return false;
    }
    
    NSString *sqlcom_update = [NSString stringWithFormat:@"update tbl_Conversation %@",_condition];
    
    if (sqlite3_exec(data_base, [sqlcom_update UTF8String], NULL, NULL, NULL) == SQLITE_OK)
    {
        update_resulte = true;
        NSLog(@"update conversation Success.");
    }
    else
    {
        NSLog(@"update conversation fail.");
    }
    
    [self _closeDataBase];
    
//    [self _unlockWithMethodName:@"updateConversationByCondition" LockId:idStr];
    
    return update_resulte;
}

- (BOOL) deleteConversationByCondition : (NSString *) _condition
{
   
    
    BOOL delete_resulte = false;
    
    if (![self _openDataBase])
    {
        return false;
    }
    
    NSString *sql_del = [NSString stringWithFormat:@"delete from tbl_Conversation %@",_condition];
    
    if (sqlite3_exec(data_base, [sql_del UTF8String], NULL, NULL, NULL) == SQLITE_OK)
    {
        delete_resulte = true;
        NSLog(@"delete conversation Success.");
    }
    else
    {
        NSLog(@"delete conversation fail.");
    }
    
    [self _closeDataBase];
    
    
    
    return delete_resulte;
}

#pragma mark ****************************** 其他操作数据方法 ********************************
- (IM_Conversation_En *)getFriendConversationObjByFriendName:(NSString *)friendName
{
    NSString *idStr = [self _lockWithMethodName:@"getFriendConversationObjByFriendName"];
    NSString *wherestr=[NSString stringWithFormat:@"where C_To='%@' and C_UserName='%@'",friendName,[AppSessionMrg shareInstance].userEntity.userId];
    if([self getConversationByCondition:wherestr].count!=0)
    {
        IM_Conversation_En *enity=[[self getConversationByCondition:wherestr] lastObject];
        [self _unlockWithMethodName:@"getFriendConversationObjByFriendName" LockId:idStr];
        return enity;
    }
    [self _unlockWithMethodName:@"getFriendConversationObjByFriendName" LockId:idStr];
    return nil;
}

- (void) updateFriendConversation:(IM_Conversation_En *)friendObj
{
    NSString *idStr = [self _lockWithMethodName:@"updateFriendConversation"];
    NSString *wherestr=[NSString stringWithFormat:@" set C_UnReadMsgCount = %d,C_LastUpdateTime='%@',C_LastMsgId=%d where C_To='%@'",friendObj.C_UnReadMsgCount,[self getDateStr:friendObj.C_LastUpdateTime],friendObj.C_Id,friendObj.C_To];
    [self updateConversationByCondition:wherestr];
    [self _unlockWithMethodName:@"updateFriendConversation" LockId:idStr];
    return ;
}

- (NSMutableArray *)getConversationListByUserName
{
    NSString *idStr = [self _lockWithMethodName:@"getConversationListByUserName"];
    //找到登录用户所有的会话对象
    NSString *condition         =[NSString stringWithFormat:@"where  C_UserName='%@' Order by C_id desc",[AppSessionMrg shareInstance].userEntity.userId];
    NSMutableArray *arr         =   [self getConversationByCondition:condition];
    [self _unlockWithMethodName:@"getConversationListByUserName" LockId:idStr];
    return arr;
    
}

-(void)deleteConversationByFriendName:(NSString *)name
{
    NSString *idStr = [self _lockWithMethodName:@"deleteConversationByCondition"];
    NSString *wherestr  =[NSString stringWithFormat:@"where C_To='%@'",name];
    [self deleteConversationByCondition:wherestr];
    [self _unlockWithMethodName:@"deleteConversationByCondition" LockId:idStr];
}
@end
