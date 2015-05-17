//
//  IM_NotificationHisMrg.m
//  BBG
//
//  Created by 7mallsevenk on 13-7-9.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import "IM_NotificationHisMrg.h"
#define MessagePage 10
@implementation IM_NotificationHisMrg


-(id)init
{
    if(self = [super init])
    {
        
    }
    return self;
}

+ (IM_NotificationHisMrg *) Instance
{
    static IM_NotificationHisMrg *instance;
	@synchronized(self)
    {
		if(!instance)
        {
			instance = [[IM_NotificationHisMrg alloc] init];
		}
	}
	return instance;
}

#pragma mark ****************************** 基础操作数据方法 ********************************

- (NSMutableArray *) getHisNotiByCondition : (NSString *) _condition
{
   
    
    NSMutableArray *return_arr = [[NSMutableArray alloc] init];
    
    
    NSString *sqlcom_select ;
    
    sqlcom_select = [NSString stringWithFormat:@"select * from tbl_NotificationHistory %@",_condition];
    
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
            IM_NotificationHistory_En *en = [[IM_NotificationHistory_En alloc] init];
            
            en.N_Id             =   sqlite3_column_int(statement, 0);
            en.N_MsgID          =   sqlite3_safe_column_text(statement, 1);
            en.N_Title          =   sqlite3_safe_column_text(statement, 2);
            en.N_Owner          =   sqlite3_safe_column_text(statement, 3);
            en.N_From           =   sqlite3_safe_column_text(statement, 4);
            en.N_To             =   sqlite3_safe_column_text(statement, 5);
            en.N_Msg            =   sqlite3_safe_column_text(statement, 6);
            en.N_Status         =   sqlite3_safe_column_text(statement, 7);
            en.N_ReveivedEvent  =   sqlite3_safe_column_text(statement, 8);
            en.N_ReadedEvent    =   sqlite3_safe_column_text(statement, 9);
            en.N_ClickEvent     =   sqlite3_safe_column_text(statement, 10);
            en.N_LastUpdateTime =   sqlite3_safe_column_text(statement, 11);
            en.N_MsgCode =          sqlite3_safe_column_text(statement,12);
            en.N_MsgState      =    sqlite3_safe_column_text(statement, 13);
            
            [return_arr addObject:en];
        }
    }
    else
    {
        NSLog(@"%@",[NSString stringWithUTF8String:eorInfo]);
    }
    
    sqlite3_finalize(statement);
    
    [self _closeDataBase];
    
   
    
    return  return_arr;
}

-(BOOL) insertHisNotiByEntity : (IM_NotificationHistory_En *) _en
{
    NSString *idStr = [self _lockWithMethodName:@"insertHisNotiByEntity"];
    
    BOOL insert_result = false;
    
    if (![self _openDataBase])
    {
        return false;
    }
    
    NSString *sqlcom_insert = [NSString stringWithFormat:
                               @"insert into tbl_NotificationHistory values (NULL, '%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",
                               getInsertString(_en.N_MsgID),
                               getInsertString(_en.N_Title),
                               getInsertString(_en.N_Owner),
                               getInsertString(_en.N_From),
                               getInsertString(_en.N_To),
                               getInsertString(_en.N_Msg),
                               getInsertString(_en.N_Status),
                               getInsertString(_en.N_ReveivedEvent),
                               getInsertString(_en.N_ReadedEvent),
                               getInsertString(_en.N_ClickEvent),
                               [self getDateStr:_en.N_LastUpdateTime],
                               getInsertString(_en.N_MsgCode),
                               getInsertString(_en.N_MsgState)];
    
    int error_code = 0;
    
    if ((error_code = sqlite3_exec(data_base, [sqlcom_insert UTF8String], NULL, NULL, NULL)) == SQLITE_OK)
    {
        insert_result = true;
        NSLog(@"insert HisNoti ok!");
    }
    else
    {
        NSLog(@"insert HisNoti fail!: %s.", sqlite3_errmsg(data_base));
    }
    
    [self _closeDataBase];
    
    [self _unlockWithMethodName:@"insertHisNotiByEntity" LockId:idStr];
    
    return insert_result;
}

-(BOOL) updateHisNotiByCondition : (NSString *) _condition
{
   
    
    BOOL update_resulte = false;
    
    if (![self _openDataBase])
    {
        return false;
    }
    
    NSString *sqlcom_update = [NSString stringWithFormat:@"update tbl_NotificationHistory %@",_condition];
    
    if (sqlite3_exec(data_base, [sqlcom_update UTF8String], NULL, NULL, NULL) == SQLITE_OK)
    {
        update_resulte = true;
        NSLog(@"update HisNoti Success.");
    }
    else
    {
        NSLog(@"update HisNoti fail.");
    }
    
    [self _closeDataBase];
    
    
    
    return update_resulte;
}

- (BOOL) deleteHisNotiByCondition : (NSString *) _condition
{
    
    
    BOOL delete_resulte = false;
    
    if (![self _openDataBase])
    {
        return false;
    }
    
    NSString *sql_del = [NSString stringWithFormat:@"delete from tbl_NotificationHistory %@",_condition];
    
    if (sqlite3_exec(data_base, [sql_del UTF8String], NULL, NULL, NULL) == SQLITE_OK)
    {
        delete_resulte = true;
        NSLog(@"delete HisNoti Success.");
    }
    else
    {
        NSLog(@"delete HisNoti fail.");
    }
    
    [self _closeDataBase];
    
   
    
    return delete_resulte;
}

#pragma mark ****************************** 其他操作数据方法 ********************************

- (NSMutableArray *)getHistoryNotifyWithUserName:(NSString *)UserName
{
        NSString *idStr     =   [self _lockWithMethodName:@"getHisNotiByCondition"];
        NSString *wherestr  =   [NSString stringWithFormat:@"where N_Owner in ('%@','@')",UserName];
        NSMutableArray *arr =   [self getHisNotiByCondition:wherestr];
        [self _unlockWithMethodName:@"getHisNotiByCondition" LockId:idStr];
        return arr;
}

-(NSMutableArray *)getHistoryPageNotifyWithUserName:(NSString *)UserName WithIndex:(NSInteger)_index
{
    NSString *idStr     =   [self _lockWithMethodName:@"getHisNotiByCondition"];
    NSString *wherestr  =   [NSString stringWithFormat:@"where N_Owner in ('%@','@') ORDER BY N_Id LIMIT %d,%d",UserName,_index*MessagePage,MessagePage];
    NSMutableArray *arr =   [self getHisNotiByCondition:wherestr];
    [self _unlockWithMethodName:@"getHisNotiByCondition" LockId:idStr];
    return arr;
}

-(NSInteger)getSysNotifyUnreadCountWithUserName:(NSString *)UserName
{
    NSString *idStr     =   [self _lockWithMethodName:@"getHisNotiByCondition"];
    NSString *wherestr  =   [NSString stringWithFormat:@"where N_Owner in ('%@','@') and N_Status='Received'",UserName];
    NSMutableArray *arr =   [self getHisNotiByCondition:wherestr];
    [self _unlockWithMethodName:@"getHisNotiByCondition" LockId:idStr];
    return arr.count;
}

- (void)deleteNotifyWithUserName:(NSString *)UserName ID:(NSInteger)N_id
{
    NSString *idStr = [self _lockWithMethodName:@"deleteHisNotiByCondition"];
    NSString *wherestr  =[NSString stringWithFormat:@"where N_Owner='%@' and N_Id=%d",UserName,N_id];
    [self deleteHisNotiByCondition:wherestr];
    [self _unlockWithMethodName:@"deleteHisNotiByCondition" LockId:idStr];
}

-(NSMutableArray *)getSysNotifyUnreadWithUserName:(NSString *)username
{
    NSString *idStr     =   [self _lockWithMethodName:@"getHisNotiByCondition"];
    NSString *wherestr  =   [NSString stringWithFormat:@"where N_Owner in ('%@','@') and N_Status='Received'",username];
    NSMutableArray *arr =   [self getHisNotiByCondition:wherestr];
    [self _unlockWithMethodName:@"getHisNotiByCondition" LockId:idStr];
    return arr;
}

-(void)updateSysNotufyStatusWithStatus:(NSString *)status UserName:(NSString *)UserName
{
    NSString *idStr = [self _lockWithMethodName:@"updateHisNotiByCondition"];
    NSString *wherestr  =   [NSString stringWithFormat:@"set N_status='%@' where N_Owner in ('%@','@')",status,UserName];
    [self updateHisNotiByCondition:wherestr];
    [self _unlockWithMethodName:@"updateHisNotiByCondition" LockId:idStr];
}

-(void)updateSysMsgStateNotufyStatusWithStatus:(NSString *)status UserName:(NSString *)UserName
{
    NSString *idStr = [self _lockWithMethodName:@"updateSysMsgStateNotufyStatusWithStatus"];
    NSString *wherestr  =   [NSString stringWithFormat:@"set N_status='%@' where N_Owner in ('%@','@')",status,UserName];
    [self updateHisNotiByCondition:wherestr];
    [self _unlockWithMethodName:@"updateSysMsgStateNotufyStatusWithStatus" LockId:idStr];
}

-(void)deleteAllNotifyWithUserName:(NSString *)UserName
{
    NSString *idStr = [self _lockWithMethodName:@"deleteHisNotiByCondition"];
    NSString *wherestr  =[NSString stringWithFormat:@"where N_Owner in ('%@','@')",UserName];
    [self deleteHisNotiByCondition:wherestr];
    [self _unlockWithMethodName:@"deleteHisNotiByCondition" LockId:idStr];

}
@end
