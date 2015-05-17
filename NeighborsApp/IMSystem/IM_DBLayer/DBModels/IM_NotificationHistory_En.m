//
//  IN_NotificationHistory_En.m
//  BBG
//
//  Created by 7mallsevenk on 13-7-9.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import "IM_NotificationHistory_En.h"
#import "AppSessionMrg.h"
@implementation IM_NotificationHistory_En

@synthesize N_From;
@synthesize N_Title;
@synthesize N_MsgID;
@synthesize N_Id;
@synthesize N_Msg;
@synthesize N_Owner;
@synthesize N_Status;
@synthesize N_To;
@synthesize N_LastUpdateTime;
@synthesize N_ClickEvent;
@synthesize N_ReadedEvent;
@synthesize N_ReveivedEvent;
@synthesize N_MsgCode;
@synthesize N_MsgState;
-(id)initWithXMLstr:(NSString *)xml
{
    self    =   [super init];
    if(self)
    {
//        NSError* error = nil;
//        DDXMLDocument* xmlDoc = [[DDXMLDocument alloc] initWithXMLString:xml options:0 error:&error];
//        
//        if (error)
//        {
//            //非合法的xml
//            NSLog(@"%@",[error localizedDescription]);
//            return nil ;
//        }
//        
//        if (error)
//        {
//            //读取节点错误
//            NSLog(@"%@",[error localizedDescription]);
//            return nil;
//        }
//        DDXMLNode *child_node    = [[xmlDoc nodesForXPath:@"//ZSMsg"    error:nil] lastObject];
//         self.N_MsgCode           =   [[[child_node nodesForXPath:@"MsgCode"     error:nil] objectAtIndex:0] stringValue];
//        self.N_From           =   [[[child_node nodesForXPath:@"From"     error:nil] objectAtIndex:0] stringValue];
//        self.N_Msg            =   [[[child_node nodesForXPath:@"Body" error:nil] objectAtIndex:0] stringValue];
//        self.N_LastUpdateTime =   [self getTimeDateFromString:[[[child_node nodesForXPath:@"Time" error:nil] objectAtIndex:0] stringValue]];
//      //  self.N_MsgType        =     [[[child_node nodesForXPath:@"To"     error:nil] objectAtIndex:0] stringValue];
//        
//        self.N_Owner          =    [[[child_node nodesForXPath:@"To"     error:nil] objectAtIndex:0] stringValue];
//        self.N_Status         =   @"Received";
//        self.N_MsgState       =   @"Received";
//        self.N_To             =    [[[SessionMgr Instance]getSessionValueWithKey:SYSKEY_USERINFO] u_userNumber];
//        self.N_ClickEvent     =    [[[child_node nodesForXPath:@"ClickEvent" error:nil] objectAtIndex:0] stringValue];
//        self.N_ReadedEvent    =    [[[child_node nodesForXPath:@"ReadEvent" error:nil] objectAtIndex:0] stringValue];
//        self.N_ReveivedEvent  =    [[[child_node nodesForXPath:@"ReveivedEvent" error:nil] objectAtIndex:0] stringValue];
//        self.N_MsgID          =    [[[child_node nodesForXPath:@"MsgCode" error:nil] objectAtIndex:0] stringValue];
//        self.N_Title          =    [[[child_node nodesForXPath:@"From" error:nil] objectAtIndex:0] stringValue];

    }
    
    return self;
}
-(NSDate *)getTimeDateFromString:(NSString *)timestr
{
    NSDateFormatter *formatter= [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [formatter dateFromString:timestr];
}
@end
