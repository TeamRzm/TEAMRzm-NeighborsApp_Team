//
//  SubCommentTableViewCell.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/20.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommentEntity.h"
#import "EGOImageView.h"

@interface SubCommentTableViewCell : UITableViewCell
@property (nonatomic, strong) EGOImageView *avterImageView;
@property (nonatomic, strong) UILabel   *nikeNameLable;
@property (nonatomic, strong) UILabel   *contentLable;
@property (nonatomic, strong) UILabel   *commitnDateLable;

- (void) setDataEntity : (CommentEntity*) _entity;
+ (CGFloat) HeightWithEntity : (CommentEntity*) _entity;
@end
