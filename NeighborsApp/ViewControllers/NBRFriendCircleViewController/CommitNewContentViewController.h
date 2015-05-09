//
//  CommitNewContentViewController.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/18.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRBaseViewController.h"

typedef enum
{
    COMMIT_TO_MODE_SHOW,    //预警
    COMMIT_TO_MODE_LOR,     //里手帮
}COMMIT_TO_MODE;

@interface CommitNewContentViewController : NBRBaseViewController

@property (nonatomic, assign) COMMIT_TO_MODE mode;

@end
