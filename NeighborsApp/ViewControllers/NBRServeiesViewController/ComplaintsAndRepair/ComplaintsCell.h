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
    COMPLAINT_CELL_MODE_COMPLAINT,  //投诉用cell
    COMPLAINT_CELL_MODE_REPAIR,     //报修用cell
}COMPLAINT_CELL_MODE;

@class ComplaintsCell;

@protocol ComplaintsCellDelegate <NSObject>

- (void) complaintsCell : (ComplaintsCell*) _cell tapSubImageViews : (UIImageView*) tapView allSubImageViews : (NSMutableArray *) _allSubImageviews;

@end

@interface ComplaintsCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, assign) id<ComplaintsCellDelegate> delegate;

- (id) initWithCellMode : (COMPLAINT_CELL_MODE) _mode dataDict : (NSDictionary*) _obejctDataDict isDetail : (BOOL) _isDetail;

+ (CGFloat) heightForDataDict : (NSDictionary *) dict isDetail : (BOOL) _isDetail;

@end
