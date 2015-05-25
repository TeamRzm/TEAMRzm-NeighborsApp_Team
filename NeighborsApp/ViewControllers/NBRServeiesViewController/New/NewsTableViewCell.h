//
//  NewsTableViewCell.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/25.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsTableViewCell;

@protocol NewsTableViewCellDelegate <NSObject>

- (void) newTabelViewCell : (NewsTableViewCell*) _cell tapSubImageViews : (UIImageView*) tapView;

@end

@interface NewsTableViewCell : UITableViewCell

@property (nonatomic, assign) id<NewsTableViewCellDelegate> delegate;
@property (nonatomic, readonly) NSMutableArray *subImageViews;
- (void) setDateDict : (NSDictionary*) _dict;
+ (CGFloat) heightWithDict : (NSDictionary*) _dict;

@end
