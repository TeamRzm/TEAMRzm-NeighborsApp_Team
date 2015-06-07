//
//  NewsTableViewCell.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/25.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "EGOImageView.h"
#import "XHImageViewer.h"

#define NewsTitleFormat @{\
NSFontAttributeName : [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:16.0f],\
NSForegroundColorAttributeName : kNBR_ProjectColor_StandBlue,\
}

#define NewsContentFormat @{\
NSFontAttributeName : [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:15.0f],\
NSForegroundColorAttributeName : kNBR_ProjectColor_DeepBlack,\
}

#define NesDescriptFormat @{\
NSFontAttributeName : [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f],\
NSForegroundColorAttributeName : kNBR_ProjectColor_DeepGray,\
}


typedef struct {
    CGRect titleFrame;
    CGRect contentFrame;
    CGRect imageFrame;
    CGRect addressFrame;
    CGRect timeFrame;
} NewTableViewCellHeightStruct;

@interface NewsTableViewCell() <XHImageViewerDelegate>
{
    UILabel             *titleLable;
    UILabel             *contentLable;
    EGOImageView        *imageView;
    NSInteger           contentLineNumber;
}

@end

@implementation NewsTableViewCell

- (id) initWithContentNumberOfLine : (NSInteger) numberOfLine
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    
    if (self)
    {
        contentLineNumber = numberOfLine;
    }
    return self;
}

- (void) setDateDict : (NSDictionary*) _dict numerOfLine : (NSInteger) numberOfLine
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _subImageViews = [[NSMutableArray alloc] init];
    
    NewTableViewCellHeightStruct heightStruct = [NewsTableViewCell heighStureWithDict:_dict numberOfLine:numberOfLine];
    
    //标题
    titleLable = [[UILabel alloc] initWithFrame:heightStruct.titleFrame];
    titleLable.attributedText = [[NSAttributedString alloc] initWithString:[_dict stringWithKeyPath:@"title"] attributes:NewsTitleFormat];
    titleLable.numberOfLines = 0;
    [self.contentView addSubview:titleLable];
    
    //内容
    contentLable = [[UILabel alloc] initWithFrame:CGRectMake(heightStruct.contentFrame.origin.x,
                                                             heightStruct.contentFrame.origin.y,
                                                             kNBR_SCREEN_W - 20,
                                                             heightStruct.contentFrame.size.height)];
    
    contentLable.attributedText = [[NSAttributedString alloc] initWithString:[_dict stringWithKeyPath:@"info"] attributes:NewsContentFormat];
    contentLable.numberOfLines = numberOfLine;
    contentLable.layer.masksToBounds = YES;
    [self.contentView addSubview:contentLable];
    
    //图片
    if ([_dict stringWithKeyPath:@"image"].length > 0)
    {
        imageView = [[EGOImageView alloc] initWithFrame:heightStruct.imageFrame];
        imageView.imageURL = [NSURL URLWithString:[_dict stringWithKeyPath:@"image"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:imageView];
        
        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOutImage:)];
        [imageView addGestureRecognizer:tapImage];
    }
    
    return ;
}

- (void) zoomOutImage:(UITapGestureRecognizer*) tapView
{
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    imageViewer.delegate = self;
    [imageViewer showWithImageViews:@[tapView.view] selectedView:tapView.view];
}

- (void) tapGestureWithObject : (UITapGestureRecognizer*) gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(newTabelViewCell:tapSubImageViews:)])
    {
        [self.delegate newTabelViewCell:self tapSubImageViews:(UIImageView*)gesture.view];
    }
}

+ (NewTableViewCellHeightStruct) heighStureWithDict : (NSDictionary *) _dict numberOfLine : (NSInteger) numerOfLine
{
    NewTableViewCellHeightStruct heightStruce;
    
    CGRect tempTitleFrame = [[_dict stringWithKeyPath:@"title"] boundingRectWithSize:CGSizeMake(kNBR_SCREEN_W - 20, 1000)
                                                                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                          attributes:NewsTitleFormat
                                                                             context:nil];
    
    heightStruce.titleFrame = CGRectMake(10,
                                         5,
                                         CGRectGetWidth(tempTitleFrame),
                                         CGRectGetHeight(tempTitleFrame)
                                         );
    
    
    NSString *contentString;
    
    if (numerOfLine == 0)
    {
        contentString = [_dict stringWithKeyPath:@"info"];
    }
    else
    {
        contentString = @"\n\n\n";
    }
    
    CGRect tempContentFrame = [contentString boundingRectWithSize:CGSizeMake(kNBR_SCREEN_W - 20, 1000)
                                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                       attributes:NewsContentFormat context:nil];
    
    
    heightStruce.contentFrame = CGRectMake(10,
                                           heightStruce.titleFrame.origin.y + CGRectGetHeight(heightStruce.titleFrame),
                                           CGRectGetWidth(tempContentFrame),
                                           CGRectGetHeight(tempContentFrame)
                                           );
    
    
    if ([_dict stringWithKeyPath:@"image"].length <= 0)
    {
        heightStruce.imageFrame = heightStruce.contentFrame;
    }
    else
    {
        heightStruce.imageFrame = CGRectMake(10,
                                             heightStruce.contentFrame.origin.y + CGRectGetHeight(heightStruce.contentFrame),
                                             300,
                                             140);
    }
    
    return heightStruce;
}

+ (CGFloat) heightWithDict : (NSDictionary*) _dict numberOfLine : (NSInteger) numberofLine
{
    NewTableViewCellHeightStruct heightStruct = [NewsTableViewCell heighStureWithDict:_dict numberOfLine:numberofLine];
    
    return heightStruct.imageFrame.origin.y + heightStruct.imageFrame.size.height + 8;
}

@end
