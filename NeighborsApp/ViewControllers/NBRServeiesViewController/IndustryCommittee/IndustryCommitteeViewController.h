//
//  IndustryCommitteeViewController.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/27.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRBaseViewController.h"
#import "EGOImageView.h"


@interface IndustryCommitteeViewController : NBRBaseViewController
@property (weak, nonatomic) IBOutlet UIScrollView *boundScrollview;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageIcones;
@property (weak, nonatomic) IBOutlet EGOImageView *zoneIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@end
