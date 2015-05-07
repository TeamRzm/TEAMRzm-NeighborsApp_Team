//
//  SearchPlotListViewController.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/8.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRBaseViewController.h"

@class SearchPlotListViewController;

@protocol SearchPlotListViewControllerDelegate <NSObject>

- (void) searchPlotListViewController : (SearchPlotListViewController*) _viewcontroller didselectDict : (NSDictionary*) _dict;

@end

@interface SearchPlotListViewController : NBRBaseViewController

@property (nonatomic, assign) id<SearchPlotListViewControllerDelegate> delegate;

@end
