//
//  PlotCertListViewController.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/23.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRBaseViewController.h"

@class PlotCertListViewController;

@protocol PlotCertListViewControllerDelegate <NSObject>

- (void) plotCertListViewController : (PlotCertListViewController*) viewController selectAddressDict : (NSDictionary *) _dict;

@end

@interface PlotCertListViewController : NBRBaseViewController

- (id) initWithSelect : (BOOL) _isSelectMode selectDelegate : (id<PlotCertListViewControllerDelegate>) delegate;

@end
