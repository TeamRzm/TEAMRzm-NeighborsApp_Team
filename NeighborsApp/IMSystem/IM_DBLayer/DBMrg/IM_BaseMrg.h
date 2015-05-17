//
//  IM_BaseMrg.h
//  BBG
//
//  Created by 7mallsevenk on 13-7-9.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

extern sqlite3 *data_base;

#define sqlite3_safe_column_text(stment, index) sqlite3_column_text(stment, index) == NULL ? @"" : [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, index)]

#define getInsertString(insetStr) insetStr == nil?@"":insetStr


@interface IM_BaseMrg : NSObject
{
    NSString     *data_base_path;
    NSMutableArray         *signalArr;
}

@property (atomic, strong)    NSMutableArray         *signalArr;

+ (BOOL) CloseLongtimeOpenDbbase;

-(BOOL) _openDataBase;

-(BOOL) _closeDataBase;


//时间格式转换到字符串
- (NSString *) getDateStr : (NSDate *) _insertDate;

//THIS_METHOD
- (NSString*) _lockWithMethodName : (NSString*) _methodName;

- (void) _unlockWithMethodName : (NSString*) _methodName
                        LockId : (NSString*) _lockId;

//- (void) threadMethodTest:(NSString*) _callInfo;

@end
