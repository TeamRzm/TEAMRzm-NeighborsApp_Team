//
//  MaintenanceFundViewController.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/31.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRBaseViewController.h"

@interface MaintenanceFundViewController : NBRBaseViewController

@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *fundSumLable;
@property (weak, nonatomic) IBOutlet UILabel *inFund;
@property (weak, nonatomic) IBOutlet UILabel *outFund;

@property (nonatomic, copy) NSString *fundUsedString;
@property (nonatomic, copy) NSString *fundLeftString;

@end
