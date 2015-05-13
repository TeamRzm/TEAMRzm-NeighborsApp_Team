//
//  ComentDetailViewController.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/19.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRBaseViewController.h"
#import "FriendCircleContentEntity.h"

@interface ComentDetailViewController : NBRBaseViewController

@property (nonatomic, strong) FriendCircleContentEntity *dataEntity;

//设置是否是安全预警的详情
@property (nonatomic, assign) BOOL isWarning;

@end
