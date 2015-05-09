//
//  CommentEntity.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/21.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentEntity : NSObject
@property (nonatomic, copy) NSString *avterIconURL;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *commitDate;
@property (nonatomic, copy) NSString *ID;

@end
