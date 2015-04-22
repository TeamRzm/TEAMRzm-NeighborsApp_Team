//
//  ActivityTableViewCell.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/18.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "ActivityDateEntity.h"

@interface ActivityTableViewCell : UITableViewCell

- (void) configWithEntity : (ActivityDateEntity*) _entity;
- (void) configWithEntity : (ActivityDateEntity*) _entity isDetail : (BOOL) _isDetail;

+ (CGFloat) heightWithEntity : (ActivityDateEntity *) _entity;
+ (CGFloat) heightWithEntity : (ActivityDateEntity *) _entity isDetail : (BOOL) _isDetail;

@end
