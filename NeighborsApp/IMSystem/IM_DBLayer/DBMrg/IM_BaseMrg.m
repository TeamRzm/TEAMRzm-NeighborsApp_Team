//
//  IM_BaseMrg.m
//  BBG
//
//  Created by 7mallsevenk on 13-7-9.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import "IM_BaseMrg.h"

sqlite3      *data_base = NULL;

@implementation IM_BaseMrg

@synthesize signalArr;

+ (BOOL) CloseLongtimeOpenDbbase
{
    if (data_base != NULL)
    {
        if (sqlite3_close(data_base) == SQLITE_OK)
        {
            data_base = NULL;
            return YES;
        }
    }
    else
    {
        return YES;
    }
    
    return NO;
}

-(id)init
{
    if(self = [super init])
    {
        [self InitDataBaseName:@"IM_DB3.sqlite"];
        self.signalArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(BOOL) InitDataBaseName : (NSString*) path
{
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filename = [documentsDirectory stringByAppendingPathComponent:path];
    data_base_path = filename;
    return YES;
}

-(BOOL) _openDataBase
{
    if (NULL != data_base)
    {
        return YES;
    }
    
    NSError *error;
    NSString *path = data_base_path;
    BOOL success;
	NSFileManager *fm = [NSFileManager defaultManager];
	
	success = [fm fileExistsAtPath:path];
    
	if(!success)
    {
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"IM_DB3.sqlite"];
        success = [fm copyItemAtPath:defaultDBPath toPath:path error:&error];
		if(!success)
        {
            NSLog(@"%@",[error localizedDescription]);
            return NO;
		}
	}
    
	if(!success)
    {
        NSLog(@"OpenDB Filed.");
        return NO;
	}
	
	//open the db
    if (sqlite3_open([path UTF8String], &data_base) != SQLITE_OK)
    {
        sqlite3_close(data_base);
        data_base = nil;
        NSLog(@"OpenDB Filed.");
        return NO;
    }
    else
    {
        NSLog(@"OpenDB Success.");
    }
    
    return YES;
}

-(BOOL) _closeDataBase
{
    return YES;
    
    if (data_base != nil)
    {
        if (sqlite3_close(data_base) == SQLITE_OK)
        {
            NSLog(@"Close DB Success.");
            return YES;
        }
        else
        {
            NSLog(@"Close DB Filed.");
            return NO;
        }
    }
    NSLog(@"The DBObject is't instance.");
    return YES;
}

#pragma mark --------comme fuction
- (NSString *) getDateStr : (NSDate *) _insertDate
{
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    [fm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if (_insertDate == nil)
    {
        return @"";
    }
    else
    {
        return [fm stringFromDate:_insertDate];
    }
}

#pragma mark ------ request lock

- (NSString*) _lockWithMethodName : (NSString*) _methodName
{
    @synchronized(self)
    {
        //调用时间戳
        NSTimeInterval timeStempDate = [[NSDate date] timeIntervalSince1970];
        
        NSString *methodThreadId = [NSString stringWithFormat:@"%@_%f_%d", _methodName, timeStempDate, rand() % 1000];
        
        [self.signalArr addObject:methodThreadId];
        
        NSString *currentFirstMehodId = nil;
        do
        {
            currentFirstMehodId = [self.signalArr objectAtIndex:0];
            
        }while (![currentFirstMehodId isEqualToString:methodThreadId]);
        
        return methodThreadId;
    }
}

- (void) _unlockWithMethodName : (NSString*) _methodName
                        LockId : (NSString*) _lockId
{    
    for (NSString *subId in self.signalArr)
    {
        if ([subId isEqualToString:_lockId])
        {
            [self.signalArr removeObject:subId];
            return;
        }
    }
    
    return ;
}

- (void) threadMethodTest:(NSString*) _callInfo
{
    NSLog(@"%@进入线程队列。",_callInfo);
    NSString *lockID = [self _lockWithMethodName:@"threadMethodTest"];
    
    [NSThread sleepForTimeInterval:rand() % 2];
    
    NSLog(@"%@结束！", _callInfo);
    
    [self _unlockWithMethodName:@"threadMethodTest" LockId:lockID];
}


@end
