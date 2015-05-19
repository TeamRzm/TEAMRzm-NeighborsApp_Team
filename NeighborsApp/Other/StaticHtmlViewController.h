//
//  StaticHtmlViewController.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/19.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRBaseViewController.h"

@interface StaticHtmlViewController : NBRBaseViewController

- (id) initWithHtmlString : (NSString *) htmlString;

- (void) setHtmlString : (NSString *) htmlString;

@end
