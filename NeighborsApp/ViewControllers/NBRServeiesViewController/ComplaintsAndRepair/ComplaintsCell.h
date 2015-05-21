//
//  ComplaintsCell.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/21.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    COMPLAINT_CELL_MODE_COMPLAINT, //投诉用cell
    COMPLAINT_CELL_MODE_REPAIR,     //报修用cell
}COMPLAINT_CELL_MODE;

@class ComplaintsCell;

@protocol ComplaintsCellDelegate <NSObject>

- (void) complaintsCell : (ComplaintsCell*) _cell tapSubImageViews : (UIImageView*) tapView allSubImageViews : (NSMutableArray *) _allSubImageviews;

@end

@interface ComplaintsCell : UITableViewCell

@property (nonatomic, assign) id<ComplaintsCellDelegate> delegate;

- (void) setDataDict : (NSDictionary *) dict cellMode : (COMPLAINT_CELL_MODE) _mode;
+ (CGFloat) heightForDataDict : (NSDictionary *) dict;

@end
