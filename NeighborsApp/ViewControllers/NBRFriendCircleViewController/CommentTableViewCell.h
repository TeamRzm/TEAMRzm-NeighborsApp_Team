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

/*
 //头像URL
 @property (nonatomic, copy) NSString *avterURL;
 //内容
 @property (nonatomic, copy) NSString *content;
 //发布的图片URL
 @property (nonatomic, copy) NSArray *contentImgURLList;
 //地址
 @property (nonatomic, copy) NSString *address;
 //时间
 @property (nonatomic, copy) NSString *commitDate;
 //查看次数
 @property (nonatomic, copy) NSString *lookCount;
 //点赞次数
 @property (nonatomic, copy) NSString *pointApproves;
 //评论数量
 @property (nonatomic, copy) NSString *commentCount;
 */

@interface CommentTableViewCell : UITableViewCell

- (void) setDateEntity : (FriendCircleContentEntity*) _dateEntity;

+ (CGFloat) heightWithEntity : (FriendCircleContentEntity*) _dateEntity;

@end
