//
//  TextShowerViewController.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/27.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRBaseViewController.h"

@interface TextShowerViewController : NBRBaseViewController
{
    
}

- (id) initWithViewControllerTitle : (NSString*) viewControllerTitle
                        textString : (NSString*) textString
                          textFont : (UIFont*)   textFont
                         textColor : (UIColor*)  textColor;

@end
