//
//  NBRFriendCircleViewController.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/3/26.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRBaseViewController.h"

typedef enum
{
    FRIENDCIRCLECONTROLLER_MODE_NONE,
    FRIENDCIRCLECONTROLLER_MODE_NOMAL,
    FRIENDCIRCLECONTROLLER_MODE_LOROLL,
    FRIENDCIRCLECONTROLLER_MODE_ACTIVITY,
    FRIENDCIRCLECONTROLLER_MODE_WARNNING,
} FRIENDCIRCLECONTROLLER_MODE;

@interface NBRFriendCircleViewController : NBRBaseViewController

- (id) initWithMode : (FRIENDCIRCLECONTROLLER_MODE) _mode;

@end