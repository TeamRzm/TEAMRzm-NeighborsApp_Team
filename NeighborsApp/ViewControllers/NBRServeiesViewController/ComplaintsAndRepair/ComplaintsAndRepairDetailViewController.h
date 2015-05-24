//
//  ComplaintsAndRepairDetailViewController.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/24.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRBaseViewController.h"

#import "ComplaintsCell.h"

@interface ComplaintsAndRepairDetailViewController : NBRBaseViewController


- (id) initWithDetaiDataDict : (NSDictionary*) dataDict mode : (COMPLAINT_CELL_MODE) _mode;


@end
