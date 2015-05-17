//
//  IM_ReqFriendHisMrg.m
//  BBG
//
//  Created by 7mallsevenk on 13-7-9.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import "IM_ReqFriendHisMrg.h"

@implementation IM_ReqFriendHisMrg


-(id)init
{
    if(self = [super init])
    {
        
    }
    return self;
}

+ (IM_ReqFriendHisMrg *) Instance
{
    static IM_ReqFriendHisMrg *instance;
	@synchronized(self)
    {
		if(!instance)
        {
			instance = [[IM_ReqFriendHisMrg alloc] init];
		}
	}
	return instance;
}

#pragma mark ****************************** 基础操作数据方法 ********************************

- (NSMutableArray *) getHisReqFriendByCondition : (NSString *) _condition
{
    NSString *idStr = [self _lockWithMethodName:@"getHisReqFriendByCondition"];
    
    NSMutableArray *return_arr = [[NSMutableArray alloc] init];
    
    
    NSString *sqlcom_select ;
    
    sqlcom_select = [NSString stringWithFormat:@"select * from tbl_RequestFriendHistory %@",_condition];
    
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
            IM_RequestFriendHistory_En *en = [[IM_RequestFriendHistory_En alloc] init];
            
            en.R_Id             =   sqlite3_column_int(statement, 0);
            en.R_Owner          =   sqlite3_safe_column_text(statement, 1);
            en.R_From           =   sqlite3_safe_column_text(statement, 2);
            en.R_Msg            =   sqlite3_safe_column_text(statement, 3);
            en.R_Status         =   sqlite3_safe_column_text(statement, 4);
            en.R_LastUpdateTime =   sqlite3_safe_column_text(statement, 5);
            
            [return_arr addObject:en];
        }
    }
    else
    {
        NSLog(@"%@",[NSString stringWithUTF8String:eorInfo]);
    }
    
    sqlite3_finalize(statement);
    
    [self _closeDataBase];
    
    [self _unlockWithMethodName:@"getHisReqFriendByCondition" LockId:idStr];
    
    return  return_arr;
}

-(BOOL) insertHisReqFriendByEntity : (IM_RequestFriendHistory_En *) _en
{
    NSString *idStr = [self _lockWithMethodName:@"insertHisReqFriendByEntity"];
    
    BOOL insert_result = false;
    
    if (![self _openDataBase])
    {
        return false;
    }
    
    NSString *sqlcom_insert = [NSString stringWithFormat:
                               @"insert into tbl_RequestFriendHistory values (NULL, '%@', '%@', '%@', '%@','%@')",
                               getInsertString(_en.R_Owner),
                               getInsertString(_en.R_From),
                               getInsertString(_en.R_Msg),
                               getInsertString(_en.R_Status),
                               [self getDateStr:_en.R_LastUpdateTime]];
    
    int error_code = 0;
    
    if ((error_code = sqlite3_exec(data_base, [sqlcom_insert UTF8String], NULL, NULL, NULL)) == SQLITE_OK)
    {
        insert_result = true;
        NSLog(@"insert hisFriendReq ok!");
    }
    else
    {
        NSLog(@"insert hisFriendReq fail!: %s.", sqlite3_errmsg(data_base));
    }
    
    [self _closeDataBase];
    
    [self _unlockWithMethodName:@"insertHisReqFriendByEntity" LockId:idStr];
    
    return insert_result;
}

-(BOOL) updateHisReqFriendByCondition : (NSString *) _condition
{
    NSString *idStr = [self _lockWithMethodName:@"updateHisReqFriendByCondition"];
    
    BOOL update_resulte = false;
    
    if (![self _openDataBase])
    {
        return false;
    }
    
    NSString *sqlcom_update = [NSString stringWithFormat:@"update tbl_RequestFriendHistory %@",_condition];
    
    if (sqlite3_exec(data_base, [sqlcom_update UTF8String], NULL, NULL, NULL) == SQLITE_OK)
    {
        update_resulte = true;
        NSLog(@"update hisFriendReq Success.");
    }
    else
    {
        NSLog(@"update hisFriendReq fail.");
    }
    
    [self _closeDataBase];
    
    [self _unlockWithMethodName:@"updateHisReqFriendByCondition" LockId:idStr];
    
    return update_resulte;
}

- (BOOL) deleteHisReqFriendByCondition : (NSString *) _condition
{
    NSString *idStr = [self _lockWithMethodName:@"deleteHisReqFriendByCondition"];
    
    BOOL delete_resulte = false;
    
    if (![self _openDataBase])
    {
        return false;
    }
    
    NSString *sql_del = [NSString stringWithFormat:@"delete from tbl_RequestFriendHistory %@",_condition];
    
    if (sqlite3_exec(data_base, [sql_del UTF8String], NULL, NULL, NULL) == SQLITE_OK)
    {
        delete_resulte = true;
        NSLog(@"delete hisFriendReq Success.");
    }
    else
    {
        NSLog(@"delete hisFriendReq fail.");
    }
    
    [self _closeDataBase];
    
    [self _unlockWithMethodName:@"deleteHisReqFriendByCondition" LockId:idStr];
    
    return delete_resulte;
}

#pragma mark ****************************** 其他操作数据方法 ********************************

@end
