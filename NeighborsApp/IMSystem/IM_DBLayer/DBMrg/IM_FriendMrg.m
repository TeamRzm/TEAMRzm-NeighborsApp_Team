//
//  IM_FriendMrg.m
//  BBG
//
//  Created by 7mallsevenk on 13-7-9.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import "IM_FriendMrg.h"

#import "AppSessionMrg.h"

@implementation IM_FriendMrg

-(id)init
{
    if(self = [super init])
    {
        
    }
    return self;
}

+ (IM_FriendMrg *) Instance
{
    static IM_FriendMrg *instance;
	@synchronized(self)
    {
		if(!instance)
        {
			instance = [[IM_FriendMrg alloc] init];
		}
	}
	return instance;
}

#pragma mark ****************************** 基础操作数据方法 ********************************

- (NSMutableArray *) getFriendByCondition : (NSString *) _condition
{
//    NSString *idStr = [self _lockWithMethodName:@"getFriendByCondition"];
    
    NSMutableArray *return_arr = [[NSMutableArray alloc] init];
    
    
    NSString *sqlcom_select ;
    
    sqlcom_select = [NSString stringWithFormat:@"select * from tbl_Friend %@",_condition];
    
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
            IM_Friend_En *en = [[IM_Friend_En alloc] init];
            en.F_Id             =   sqlite3_column_int(statement, 0);
            en.F_Owner          =   sqlite3_safe_column_text(statement, 1);
            en.F_UserName       =   sqlite3_safe_column_text(statement, 2);
            en.F_Nikename       =   sqlite3_safe_column_text(statement, 3);
            en.F_Picurl         =   sqlite3_safe_column_text(statement, 4);
            en.F_Both           =   sqlite3_safe_column_text(statement, 5);
            en.F_Sex            =   sqlite3_safe_column_text(statement, 6);
            en.F_Constellation  =   sqlite3_safe_column_text(statement, 7);
            en.F_LastUpdateTime =   sqlite3_safe_column_text(statement, 8);
            en.F_Remark         =   sqlite3_safe_column_text(statement, 9);
            en.F_FriendShipID   =   sqlite3_safe_column_text(statement, 10);
            en.F_Age            =   sqlite3_safe_column_text(statement, 11);
            en.F_DelFlag        =   sqlite3_safe_column_text(statement, 12);
            [return_arr addObject:en];
        }
    }
    else
    {
        NSLog(@"%@",[NSString stringWithUTF8String:eorInfo]);
    }
    
    sqlite3_finalize(statement);
    
    [self _closeDataBase];
    
//    [self _unlockWithMethodName:@"getFriendByCondition" LockId:idStr];
    
    return  return_arr;
}

-(BOOL) insertFriendByEntity : (IM_Friend_En *) _en
{
    NSString *idStr = [self _lockWithMethodName:@"insertFriendByEntity"];
    
    BOOL insert_result = false;
    
    if (![self _openDataBase])
    {
        return false;
    }
    
    NSString *sqlcom_insert = [NSString stringWithFormat:
                               @"insert into tbl_Friend values (NULL, '%@', '%@', '%@', '%@','%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",
                               getInsertString(_en.F_Owner),
                               getInsertString(_en.F_UserName),
                               getInsertString(_en.F_Nikename),
                               getInsertString(_en.F_Picurl),
                               [self getDateStr:_en.F_Both],
                               getInsertString(_en.F_Sex),
                               getInsertString(_en.F_Constellation),
                               [self getDateStr:_en.F_LastUpdateTime],
                               getInsertString(_en.F_Remark),
                               getInsertString(_en.F_FriendShipID),
                               getInsertString(_en.F_Age),
                               getInsertString(_en.F_DelFlag)];
    
    int error_code = 0;
    
    if ((error_code = sqlite3_exec(data_base, [sqlcom_insert UTF8String], NULL, NULL, NULL)) == SQLITE_OK)
    {
        insert_result = true;
        NSLog(@"insert friend ok!");
    }
    else
    {
        NSLog(@"insert friend bad!: %s.", sqlite3_errmsg(data_base));
    }
    
    [self _closeDataBase];
    
    [self _unlockWithMethodName:@"insertFriendByEntity" LockId:idStr];
    
    return insert_result;
}


-(BOOL) updateFriendByCondition : (NSString *) _condition
{
//    NSString *idStr = [self _lockWithMethodName:@"updateFriendByCondition"];
    
    BOOL update_resulte = false;
    
    if (![self _openDataBase])
    {
        return false;
    }
    
    NSString *sqlcom_update = [NSString stringWithFormat:@"update tbl_Friend %@",_condition];
    
    if (sqlite3_exec(data_base, [sqlcom_update UTF8String], NULL, NULL, NULL) == SQLITE_OK)
    {
        update_resulte = true;
        NSLog(@"update friend Success.");
    }
    else
    {
        NSLog(@"update friend Filed.");
    }
    
    [self _closeDataBase];
    
//    [self _unlockWithMethodName:@"updateFriendByCondition" LockId:idStr];
    
    return update_resulte;
}

-(BOOL)updateFriendInfoWithUserName:(IM_Friend_En *)enity
{
    IM_Friend_En *currentfriend = [self getFriendInfoByFriendName:enity.F_UserName];
    if (enity.F_Picurl == nil)
    {
        enity.F_Picurl = currentfriend.F_Picurl;
    }
    NSString *idStr = [self _lockWithMethodName:@"updateFriendInfoWithUserName"];
    BOOL update_resulte = false;
   
    NSString *sqlstr = [NSString stringWithFormat:@"set F_Both='%@',F_Nikename = '%@',F_Picurl = '%@',F_Sex = '%@',F_Age = '%@',F_LastUpdateTime = '%@' ,F_DelFlag = '%@' where F_UserName = '%@'",enity.F_Both,enity.F_Nikename,enity.F_Picurl,enity.F_Sex,enity.F_Age,enity.F_LastUpdateTime,enity.F_DelFlag,enity.F_UserName];
    if (enity.F_Both == nil)
    {
        sqlstr = [NSString stringWithFormat:@"set F_Both='',F_Nikename = '%@',F_Picurl = '%@',F_Sex = '%@',F_Age = '%@',F_LastUpdateTime = '%@',F_DelFlag = '%@'  where F_UserName = '%@'",enity.F_Nikename,enity.F_Picurl,enity.F_Sex,enity.F_Age,enity.F_LastUpdateTime,enity.F_DelFlag,enity.F_UserName];
    }
    update_resulte = [self updateFriendByCondition:sqlstr];
    [self _unlockWithMethodName:@"updateFriendInfoWithUserName" LockId:idStr];
    
    return update_resulte;
}

- (BOOL) deleteFriendByCondition : (NSString *) _condition
{
  
    
    BOOL delete_resulte = false;
    
    if (![self _openDataBase])
    {
        return false;
    }
    
    NSString *sql_del = [NSString stringWithFormat:@"delete from tbl_Friend %@",_condition];
    
    if (sqlite3_exec(data_base, [sql_del UTF8String], NULL, NULL, NULL) == SQLITE_OK)
    {
        delete_resulte = true;
        NSLog(@"delete friend Success.");
    }
    else
    {
        NSLog(@"delete friend Filed.");
    }
    
    [self _closeDataBase];
    
  
    
    return delete_resulte;
}

-(IM_Friend_En *)getFriendInfoByFriendName:(NSString *)_friendname
{
    NSString *idStr = [self _lockWithMethodName:@"getFriendInfoByFriendName"];
    NSString *owner = [AppSessionMrg shareInstance].userEntity.userId;
    IM_Friend_En *en = [[IM_Friend_En alloc] init];
    NSString *sqlcom_select ;
    
    sqlcom_select = [NSString stringWithFormat:@"select * from tbl_Friend where F_UserName='%@' and F_Owner = '%@' ",_friendname,owner];
    
    sqlite3_stmt *statement;
    
    const char   *eorInfo;
    
    if (![self _openDataBase])
    {
        return en;
    }
    
    if (sqlite3_prepare(data_base, [sqlcom_select UTF8String], -1, &statement, &eorInfo) == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            
            en.F_Id             =   sqlite3_column_int(statement, 0);
            en.F_Owner          =   sqlite3_safe_column_text(statement, 1);
            en.F_UserName       =   sqlite3_safe_column_text(statement, 2);
            en.F_Nikename       =   sqlite3_safe_column_text(statement, 3);
            en.F_Picurl         =   sqlite3_safe_column_text(statement, 4);
            en.F_Both           =   sqlite3_safe_column_text(statement, 5);
            en.F_Sex            =   sqlite3_safe_column_text(statement, 6);
            en.F_Constellation  =   sqlite3_safe_column_text(statement, 7);
            en.F_LastUpdateTime =   sqlite3_safe_column_text(statement, 8);
            en.F_Remark         =   sqlite3_safe_column_text(statement, 9);
        }
    }
    else
    {
        NSLog(@"%@",[NSString stringWithUTF8String:eorInfo]);
    }
    
    sqlite3_finalize(statement);
    
    [self _closeDataBase];
    
    [self _unlockWithMethodName:@"getFriendInfoByFriendName" LockId:idStr];
    
    return  en;

}

#pragma mark ****************************** 其他操作数据方法 ********************************

-(NSString *)getFriendIconByFriendName:(NSString *)FriendName Owner:(NSString *)owner
{
     NSString *idStr = [self _lockWithMethodName:@"getFriendByCondition"];
    NSString *wherestr=[NSString stringWithFormat:@"where F_UserName='%@' and F_Owner='%@'",FriendName,owner];
    if([self getFriendByCondition:wherestr].count!=0)
    {
        IM_Friend_En *friend=[[self getFriendByCondition:wherestr] lastObject];
        [self _unlockWithMethodName:@"getFriendByCondition" LockId:idStr];
        return friend.F_Picurl;
    }
    [self _unlockWithMethodName:@"getFriendByCondition" LockId:idStr];
    return nil;
}

-(void)updateFriendaccount:(IM_Friend_En *)enity
{
    NSString *idStr = [self _lockWithMethodName:@"updateFriendByCondition"];
    NSString *wherestr=[NSString  stringWithFormat:@"set F_Picurl='%@',F_Both='%@',F_Constellation='%@',F_LastUpdateTime='%@',F_Nikename='%@',F_Owner='%@',F_Sex='%@',F_Age='%@',F_DelFlag = '%@' where F_UserName='%@'",enity.F_Picurl,enity.F_Both,enity.F_Constellation,enity.F_LastUpdateTime,enity.F_Nikename,enity.F_Owner,enity.F_Sex,enity.F_Age,enity.F_DelFlag,enity.F_UserName];
    [self updateFriendByCondition:wherestr];
    [self _unlockWithMethodName:@"updateFriendByCondition" LockId:idStr];
}

-(NSMutableArray *)getUserFriendListWithUserName:(NSString *)UserName
{
    NSString *idStr = [self _lockWithMethodName:@"getFriendByCondition"];
    NSString *wherestr=[NSString stringWithFormat:@"where F_Owner='%@' and F_DelFlag='0'",UserName];
    if([self getFriendByCondition:wherestr].count!=0)
    {
        NSMutableArray *arr =   [self getFriendByCondition:wherestr];
        [self _unlockWithMethodName:@"getFriendByCondition" LockId:idStr];
        return arr;
    }
    [self _unlockWithMethodName:@"getFriendByCondition" LockId:idStr];
    return nil;
}

- (BOOL) removeFriendShipWithUserName : (NSString *) _userName
{
    NSString *idStr = [self _lockWithMethodName:@"removeFriendShipWithUserName"];
    NSString *conditionStr = [NSString stringWithFormat:@"set F_DelFlag = '1' where F_UserName = '%@'",_userName];
    BOOL return_result = [self updateFriendByCondition:conditionStr];
    [self _unlockWithMethodName:@"removeFriendShipWithUserName" LockId:idStr];
    return return_result;
}
-(void)deleteFriendDataByHisName:(NSString *)friendName
{
      NSString *idStr       =   [self _lockWithMethodName:@"deleteFriendByCondition"];
      NSString *wherestr    =   [NSString stringWithFormat:@"where F_UserName='%@' and F_Owner='%@'",friendName,[AppSessionMrg shareInstance].userEntity.userId];
      [self deleteFriendByCondition:wherestr];
      [self _unlockWithMethodName:@"deleteFriendByCondition" LockId:idStr];
}

-(void)updateFrienddeleteFlagbyFriendName:(NSString *)username
{
    NSString *idStr = [self _lockWithMethodName:@"updateFriendByCondition"];
    NSString *owner = [AppSessionMrg shareInstance].userEntity.userId;
    NSString *wherestr=[NSString stringWithFormat:@"set F_DelFlag='1' where F_UserName='%@' and F_Owner='%@'",username,owner];
    [self updateFriendByCondition:wherestr];
    [self _unlockWithMethodName:@"updateFriendByCondition" LockId:idStr];
}
@end
