//
//  CreaterRequest_Base.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/2.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestServerConfig.h"
#import "ASIHTTPRequest.h"
#import "AppSessionMrg.h"

@class NBRBaseViewController;

typedef enum
{
    REQUEST_METHOD_GET,
    REQUEST_METHOD_POST,
} REQUEST_METHOD;

@interface CreaterRequest_Base : NSObject

+ (NSURL*) URLStringWithMethod : (NSString*) _method parmsDict : (NSDictionary*) _parmsDict;

+ (ASIHTTPRequest*) RequestWithURL : (NSURL*) _url requestMethod : (REQUEST_METHOD) _method;

+ (ASIHTTPRequest*) GetRequestWithMethod : (NSString*) _method
                               parmsDict : (NSDictionary*) _parmsDict
                           requestMethod : (REQUEST_METHOD) _requestMethod;

+ (BOOL) CheckErrorResponse : (NSDictionary*) _jsonDict errorAlertInViewController : (NBRBaseViewController*) _viewController;

@end
