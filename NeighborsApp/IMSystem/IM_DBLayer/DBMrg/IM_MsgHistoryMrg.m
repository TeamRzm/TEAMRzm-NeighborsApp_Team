//
//  IM_MsgHistoryMrg.m
//  BBG
//
//  Created by 7mallsevenk on 13-7-9.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import "IM_MsgHistoryMrg.h"
#import "AppSessionMrg.h"


@implementation IM_MsgHistoryMrg

-(id)init
{
    if(self = [super init])
    {
        
    }
    return self;
}

+ (IM_MsgHistoryMrg *) Instance
{
    static IM_MsgHistoryMrg *instance;
	@synchronized(self)
    {
		if(!instance)
        {
			instance = [[IM_MsgHistoryMrg alloc] init];
		}
	}
	return instance;
}

#pragma mark ****************************** 基础操作数据方法 ********************************

- (NSMutableArray *) getHisMsgByCondition : (NSString *) _condition
{
 //   NSString *idStr = [self _lockWithMethodName:@"getHisMsgByCondition"];
    
    NSMutableArray *return_arr = [[NSMutableArray alloc] init];
    
    
    NSString *sqlcom_select ;
    
    sqlcom_select = _condition;
    
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
            IM_MsgHistory_En *en = [[IM_MsgHistory_En alloc] init];
            
            en.M_Id             =   sqlite3_column_int(statement, 0);
            en.M_Owner          =   sqlite3_safe_column_text(statement, 1);
            en.M_From           =   sqlite3_safe_column_text(statement, 2);
            en.M_To             =   sqlite3_safe_column_text(statement, 3);
            en.M_Msg            =   sqlite3_safe_column_text(statement, 4);
            en.M_Status         =   sqlite3_safe_column_text(statement, 5);
            en.M_ReveivedEvent  =   sqlite3_safe_column_text(statement, 6);
            en.M_ReadedEvent    =   sqlite3_safe_column_text(statement, 7);
            en.M_ClickEvent     =   sqlite3_safe_column_text(statement, 8);
            NSString  *str      =   sqlite3_safe_column_text(statement, 9);
            en.M_MsgCode        =   sqlite3_safe_column_text(statement, 10);
            en.M_MsgState       =   sqlite3_safe_column_text(statement, 11);
            NSDateFormatter *ft = [[NSDateFormatter alloc] init];
            [ft setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            en.M_Msg = [en.M_Msg stringByReplacingOccurrencesOfString:@"''" withString:@"'"];
            en.M_LastUpdateTime = [ft dateFromString:str];
            [return_arr addObject:en];
        }
    }
    else
    {
        NSLog(@"%@",[NSString stringWithUTF8String:eorInfo]);
    }
    
    sqlite3_finalize(statement);
    
    [self _closeDataBase];
    
 //   [self _unlockWithMethodName:@"getHisMsgByCondition" LockId:idStr];
    
    return  return_arr;
}

-(BOOL) insertHisMsgByEntity : (IM_MsgHistory_En *) _en
{
    NSString *idStr = [self _lockWithMethodName:@"insertHisMsgByEntity"];
    NSString *temmsg =[_en.M_Msg stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
//    _en.M_Msg = [_en.M_Msg stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    BOOL insert_result = false;
    
    if (![self _openDataBase])
    {
        return false;
    }
    NSString *sqlcom_insert = [NSString stringWithFormat:
                               @"insert into tbl_MsgHistory values (NULL, '%@', '%@', '%@', '%@','%@','%@','%@','%@','%@','%@','%@')",
                               getInsertString(_en.M_Owner),
                               getInsertString(_en.M_From),
                               getInsertString(_en.M_To),
                               getInsertString(temmsg),
                               getInsertString(_en.M_Status),
                               getInsertString(_en.M_ReveivedEvent),
                               getInsertString(_en.M_ReadedEvent),
                               getInsertString(_en.M_ClickEvent),
                               [self getDateStr:_en.M_LastUpdateTime],
                               getInsertString(_en.M_MsgCode),
                               getInsertString(_en.M_MsgState)];
    
    int error_code = 0;
    
    if ((error_code = sqlite3_exec(data_base, [sqlcom_insert UTF8String], NULL, NULL, NULL)) == SQLITE_OK)
    {
        insert_result = true;
        NSLog(@"insert hisMsg ok!");
    }
    else
    {
        NSLog(@"insert hisMsg fail!: %s.", sqlite3_errmsg(data_base));
    }
    
    [self _closeDataBase];
    
    [self _unlockWithMethodName:@"insertHisMsgByEntity" LockId:idStr];
    
    return insert_result;
}

-(BOOL) updateHisMsgByCondition : (NSString *) _condition
{
//    NSString *idStr = [self _lockWithMethodName:@"updateHisMsgByCondition"];
    
    BOOL update_resulte = false;
    
    if (![self _openDataBase])
    {
        return false;
    }
    
    NSString *sqlcom_update = [NSString stringWithFormat:@"update tbl_MsgHistory %@",_condition];
    
    if (sqlite3_exec(data_base, [sqlcom_update UTF8String], NULL, NULL, NULL) == SQLITE_OK)
    {
        update_resulte = true;
        NSLog(@"update hisMsg Success.");
    }
    else
    {
        NSLog(@"update hisMsg fail.");
    }
    
    [self _closeDataBase];
    
//    [self _unlockWithMethodName:@"updateHisMsgByCondition" LockId:idStr];
    
    return update_resulte;
}

-(BOOL)updateHisMsgById:(NSInteger)_msgid withstatus:(NSString *)_status
{
    NSString *idStr = [self _lockWithMethodName:@"updateHisMsgById"];
    
    BOOL update_resulte = false;
    
    if (![self _openDataBase])
    {
        return false;
    }
    
    NSString *sqlcom_update = [NSString stringWithFormat:@"update tbl_MsgHistory set M_Status ='%@' where M_Id = %d",_status,_msgid];
    
    if (sqlite3_exec(data_base, [sqlcom_update UTF8String], NULL, NULL, NULL) == SQLITE_OK)
    {
        update_resulte = true;
        NSLog(@"update hisMsg Success.");
    }
    else
    {
        NSLog(@"update hisMsg fail.");
    }
    
    [self _closeDataBase];
    
    [self _unlockWithMethodName:@"updateHisMsgById" LockId:idStr];
    
    return update_resulte;
}

-(BOOL) UpdateDeleteFriendMessageToRead:(NSString *) _delfriendname
{
    NSString *idStr = [self _lockWithMethodName:@"UpdateHisMsgToReadWithName"];
    
    BOOL update_resulte = false;
    
    if (![self _openDataBase])
    {
        return false;
    }
   
    NSString *sqlcom_update = [NSString stringWithFormat:@"update tbl_MsgHistory set M_Status ='Read' where M_To ='%@' and M_From = '%@'", [AppSessionMrg shareInstance].userEntity.userId,_delfriendname];
    
    if (sqlite3_exec(data_base, [sqlcom_update UTF8String], NULL, NULL, NULL) == SQLITE_OK)
    {
        update_resulte = true;
        NSLog(@"update hisMsg Success.");
    }
    else
    {
        NSLog(@"update hisMsg fail.");
    }
    
    [self _closeDataBase];
    
    [self _unlockWithMethodName:@"UpdateHisMsgToReadWithName" LockId:idStr];
    
    return update_resulte;

}

-(BOOL)UpdateHisMsgToReadWithName:(NSString *)_name
{
    NSString *idStr = [self _lockWithMethodName:@"UpdateHisMsgToReadWithName"];
    
    BOOL update_resulte = false;
    
    if (![self _openDataBase])
    {
        return false;
    }
    
    NSString *sqlcom_update = [NSString stringWithFormat:@"update tbl_MsgHistory set M_Status ='Read' where M_To ='%@' and M_Owner = '%@'",_name,_name];
    
    if (sqlite3_exec(data_base, [sqlcom_update UTF8String], NULL, NULL, NULL) == SQLITE_OK)
    {
        update_resulte = true;
        NSLog(@"update hisMsg Success.");
    }
    else
    {
        NSLog(@"update hisMsg fail.");
    }
    
    [self _closeDataBase];
    
    [self _unlockWithMethodName:@"UpdateHisMsgToReadWithName" LockId:idStr];
    
    return update_resulte;

}

- (BOOL) deleteHisMsgByCondition : (NSString *) _condition
{
    NSString *idStr = [self _lockWithMethodName:@"deleteHisMsgByCondition"];
    
    BOOL delete_resulte = false;
    
    if (![self _openDataBase])
    {
        return false;
    }
    
    NSString *sql_del = [NSString stringWithFormat:@"delete from tbl_MsgHistory %@",_condition];
    
    if (sqlite3_exec(data_base, [sql_del UTF8String], NULL, NULL, NULL) == SQLITE_OK)
    {
        delete_resulte = true;
        NSLog(@"delete hisMsg Success.");
    }
    else
    {
        NSLog(@"delete hisMsg fail.");
    }
    
    [self _closeDataBase];
    
    [self _unlockWithMethodName:@"deleteHisMsgByCondition" LockId:idStr];
    
    return delete_resulte;
}

-(BOOL)deleteHisMsgByFriendName:(NSString *)_friendname
{
    NSString *idStr = [self _lockWithMethodName:@"deleteHisMsgByFriendName"];
    
    BOOL delete_resulte = false;
    
    if (![self _openDataBase])
    {
        return false;
    }
//    [NSString stringWithFormat:@"where M_Owner = '%@' and (M_From ='%@' or M_To='%@')",[[[SessionMgr Instance] getSessionValueWithKey:SYSKEY_USERINFO] u_userNumber],targetname,[[[SessionMgr Instance] getSessionValueWithKey:SYSKEY_USERINFO] u_userNumber] ]
    NSString *sql_del = [NSString stringWithFormat:@"delete from tbl_MsgHistory where M_Owner = '%@' and (M_From ='%@' or M_To='%@')",[AppSessionMrg shareInstance].userEntity.userId,_friendname,_friendname];
    
    if (sqlite3_exec(data_base, [sql_del UTF8String], NULL, NULL, NULL) == SQLITE_OK)
    {
        delete_resulte = true;
        NSLog(@"delete hisMsg Success.");
    }
    else
    {
        NSLog(@"delete hisMsg fail.");
    }
    
    [self _closeDataBase];
    
    [self _unlockWithMethodName:@"deleteHisMsgByFriendName" LockId:idStr];
    
    return delete_resulte;

}

#pragma mark ****************************** 其他操作数据方法 ********************************

- (IM_MsgHistory_En *) getMsgByFriendName:(NSString *)FriendName

{
    NSString *idStr = [self _lockWithMethodName:@"getHisMsgByCondition"];
 //   NSString *wherestr=[NSString stringWithFormat:@"select * from tbl_MsgHistory where M_To='%@' and M_From='%@'",[[[SessionMgr Instance]getSessionValueWithKey:SYSKEY_USERINFO] u_userNumber],FriendName];
    NSString *wherestr=[NSString stringWithFormat:@"select *from (select * from tbl_MsgHistory where M_Owner='%@') where M_From ='%@' or M_To='%@'",[AppSessionMrg shareInstance].userEntity.userId,FriendName,FriendName];
    if([self getHisMsgByCondition:wherestr].count!=0)
    {
        IM_MsgHistory_En *enity=[[self getHisMsgByCondition:wherestr] lastObject];
        [self _unlockWithMethodName:@"getHisMsgByCondition" LockId:idStr];
        return enity;
    }
    [self _unlockWithMethodName:@"getHisMsgByCondition" LockId:idStr];
    return nil;
}


-(IM_MsgHistory_En *)getMsgInfoByMsg:(NSString *)FriendName
{
    NSString *idStr = [self _lockWithMethodName:@"getHisMsgByCondition"];
    FriendName =[FriendName stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    NSString *wherestr = [NSString stringWithFormat:@"select * from tbl_MsgHistory where M_Msg='%@'",FriendName];
    IM_MsgHistory_En *enity=[[self getHisMsgByCondition:wherestr] lastObject];
    if (enity.M_Msg)
    {
        [self _unlockWithMethodName:@"getHisMsgByCondition" LockId:idStr];
        return enity;
    }
    [self _unlockWithMethodName:@"getHisMsgByCondition" LockId:idStr];
    return nil;
}



-(NSMutableArray *)getChatMsgByFriendName:(NSString *)FriendName withSize:(NSInteger)size PageIndex:(NSInteger)pageindex
{
    NSString *idStr = [self _lockWithMethodName:@"getHisMsgByCondition"];
    NSString *wherestr=[NSString stringWithFormat:@"select *from (select * from tbl_MsgHistory where M_Owner='%@') where M_From ='%@' or M_To='%@' order by M_id desc limit %d,%d ",[AppSessionMrg shareInstance].userEntity.userId,FriendName,FriendName,size*pageindex,size*(pageindex+1)];
    NSMutableArray *arr=[self getHisMsgByCondition:wherestr];
    [self _unlockWithMethodName:@"getHisMsgByCondition" LockId:idStr];
    return arr;


}

-(NSInteger)getUnreadCountMsg
{
    NSString *idStr = [self _lockWithMethodName:@"getHisMsgByCondition"];
    NSString *wherestr =[NSString stringWithFormat:@"select *from (select * from tbl_MsgHistory where M_Owner='%@') where M_Status='Received'",[AppSessionMrg shareInstance].userEntity.userId];
    NSInteger num=[self getHisMsgByCondition:wherestr].count;
    [self _unlockWithMethodName:@"getHisMsgByCondition" LockId:idStr];
    return num;
}
-(void)updateHisMsgStatusByID:(NSInteger)ID Status:(NSString *)statu
{
     NSString *idStr = [self _lockWithMethodName:@"updateHisMsgById"];
    NSString *wherestr=[NSString stringWithFormat:@"set M_Status ='%@' where M_Id = %d and M_Status='Received'",statu,ID];
    [self updateHisMsgByCondition:wherestr];
    [self _unlockWithMethodName:@"updateHisMsgById" LockId:idStr];
}

@end
