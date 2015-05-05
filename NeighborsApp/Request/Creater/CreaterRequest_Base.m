//
//  CreaterRequest_Base.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/2.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Base.h"
#import "NBRBaseViewController.h"

@implementation CreaterRequest_Base

+ (NSURL*) URLStringWithMethod : (NSString*) _method parmsDict : (NSDictionary*) _parmsDict
{
    NSMutableString *requestURL = [[NSMutableString alloc] initWithString:CURRENT_SERVER.createRequestServerURL];
    
    [requestURL appendFormat:@"%@", _method];
    
    BOOL appendChar = NO;
    
    for (NSString *subKey in _parmsDict)
    {
        if (!appendChar)
        {
            [requestURL appendFormat:@"?%@=%@", subKey, _parmsDict[subKey]];
            appendChar = YES;
        }
        else
        {
            [requestURL appendFormat:@"&%@=%@", subKey, _parmsDict[subKey]];
        }
    }
    
    if ([AppSessionMrg shareInstance].userEntity.token.length > 0)
    {
        if (_parmsDict.count == 0)
        {
            [requestURL appendFormat:@"?token=%@", [AppSessionMrg shareInstance].userEntity.token];
        }
        else
        {
            [requestURL appendFormat:@"&token=%@", [AppSessionMrg shareInstance].userEntity.token];
        }
    }
    
    NSString *utf8String = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:utf8String];
    
    return url;
}

+ (ASIHTTPRequest*) RequestWithURL : (NSURL*) _url requestMethod : (REQUEST_METHOD) _method
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:_url];
    
    switch (_method)
    {
        case REQUEST_METHOD_GET:
        {
            [request setRequestMethod:@"GET"];
        }
            break;
            
        case REQUEST_METHOD_POST:
        {
            [request setRequestMethod:@"POST"];
        }
            break;
            
        default:
        {
            [request setRequestMethod:@"GET"];
        }
            break;
    }
    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
    [request setTimeOutSeconds:25];
    
    return request;
}

+ (ASIHTTPRequest*) GetRequestWithMethod : (NSString*) _method
                               parmsDict : (NSDictionary*) _parmsDict
                           requestMethod : (REQUEST_METHOD) _requestMethod
{
    NSURL *requestUrl = [CreaterRequest_Base URLStringWithMethod:_method parmsDict:_parmsDict];
    
    return [CreaterRequest_Base RequestWithURL:requestUrl requestMethod:_requestMethod];
}

+ (BOOL) CheckErrorResponse : (NSDictionary*) _jsonDict errorAlertInViewController : (NBRBaseViewController*) _viewController
{
    if ( ((NSNumber*)_jsonDict[@"data"][@"code"][@"state"]).integerValue !=0 )
    {
        [_viewController showBannerMsgWithString:_jsonDict[@"data"][@"code"][@"message"]];
        
        return NO;
    }
    
    return YES;
}

@end
