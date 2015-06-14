//
//  AddPlotCertViewController.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/23.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRBaseViewController.h"

@interface AddPlotCertViewController : NBRBaseViewController

@property (nonatomic, strong) NSDictionary *plotDict;
@property (nonatomic, copy)   NSString     *houseInfo;
@property (nonatomic, copy)   NSString     *ownerName;
@property (nonatomic, copy)   NSString     *ownerTelNum;

@end
