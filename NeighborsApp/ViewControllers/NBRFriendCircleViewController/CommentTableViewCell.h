//
//  CommentTableViewCell.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/16.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "FriendCircleContentEntity.h"

@class CommentTableViewCell;

@protocol CommentTableViewCellDelegate
- (void) commentTableViewCell : (CommentTableViewCell*) _cell tapSubImageViews : (UIImageView*) tapView allSubImageViews : (NSMutableArray *) _allSubImageviews;
@end

@interface CommentTableViewCell : UITableViewCell


@property (nonatomic, strong) EGOImageView          *avterImageView;
@property (nonatomic, strong) UILabel               *nikeNameLable;
@property (nonatomic, strong) UILabel               *contentLable;
@property (nonatomic, strong) UILabel               *addressLable;
@property (nonatomic, strong) UILabel               *commitDateLable;
@property (nonatomic, strong) UILabel               *loogCountLable;
@property (nonatomic, strong) UILabel               *pointApprovesLable;
@property (nonatomic, strong) UILabel               *contentCountLable;
@property (nonatomic, assign) id<CommentTableViewCellDelegate> delegate;

+ (CGFloat) heightWithEntity : (FriendCircleContentEntity*) _dateEntity;

- (void) setDateEntity : (FriendCircleContentEntity*) _dateEntity;

@end
