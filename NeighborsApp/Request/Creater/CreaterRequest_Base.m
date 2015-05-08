//
//  CreaterRequest_Base.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/2.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Base.h"
#import "NBRBaseViewController.h"
#import "ASIFormDataRequest.h"

@implementation CreaterRequest_Base

+ (NSString*) URLStringWithMethod:(NSString *)_method parmsDict:(NSDictionary *)_parmsDict
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
            [requestURL appendFormat:@"?token=%@&imei=", [AppSessionMrg shareInstance].userEntity.token];
        }
        else
        {
            [requestURL appendFormat:@"&token=%@&imei=", [AppSessionMrg shareInstance].userEntity.token];
        }
    }
    
    NSString *utf8String = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return utf8String;
}

+ (NSURL*) URLWithMethod : (NSString*) _method parmsDict : (NSDictionary*) _parmsDict
{
    NSString *utf8String = [CreaterRequest_Base URLStringWithMethod:_method parmsDict:_parmsDict];
    
    NSURL *url = [NSURL URLWithString:utf8String];
    
    return url;
}

+ (ASIHTTPRequest*) RequestWithURL : (NSURL*) _url requestMethod : (REQUEST_METHOD) _method
{
    switch (_method)
    {
        default:
        case REQUEST_METHOD_GET:
        {
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:_url];
            [request setRequestMethod:@"GET"];
            [request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
            [request setTimeOutSeconds:25];
            
            return request;
        }
            break;
            
        case REQUEST_METHOD_POST:
        {
            NSString *baseUrl = [_url.absoluteString componentsSeparatedByString:@"?"][0];
            NSString *keyAndValue = [_url.absoluteString componentsSeparatedByString:@"?"][1];
            keyAndValue = [keyAndValue stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:baseUrl]];
            [request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
            [request setTimeOutSeconds:25];
            [request setRequestMethod:@"POST"];
            
            NSArray  *allKeyAndValue = [keyAndValue componentsSeparatedByString:@"&"];
            
            for (NSString *subKeyValue in allKeyAndValue)
            {
                NSArray *result = [subKeyValue componentsSeparatedByString:@"="];
                [request addPostValue:result[1] forKey:result[0]];
            }
            
            return request;
        }
            break;
    }
}

+ (ASIHTTPRequest*) GetRequestWithMethod : (NSString*) _method
                               parmsDict : (NSDictionary*) _parmsDict
                           requestMethod : (REQUEST_METHOD) _requestMethod
{
    NSURL *requestUrl = [CreaterRequest_Base URLWithMethod:_method parmsDict:_parmsDict];
    
    return [CreaterRequest_Base RequestWithURL:requestUrl requestMethod:_requestMethod];
}

+ (BOOL) CheckErrorResponse : (NSDictionary*) _jsonDict errorAlertInViewController : (NBRBaseViewController*) _viewController
{

//    if ( ((NSNumber*)_jsonDict[@"data"][@"code"][@"state"]).integerValue !=0 )
    if ( [_jsonDict numberWithKeyPath:@"data\\code\\state"] != 0 )
    {
        [_viewController showBannerMsgWithString:_jsonDict[@"data"][@"code"][@"message"]];
        
        return NO;
    }
    
    return YES;
}

@end
