//
//  aya_coreTextView.m
//  CoreTextView
//
//  Created by Martin.Ren on 13-7-10.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import "aya_coreTextView.h"
#import "aya_markupParser.h"

#import <CoreText/CoreText.h>

@implementation aya_coreTextView

- (id) initWithMarkUpString : (NSString*) _markUpString width : (CGFloat) _width x : (CGFloat) _x y : (CGFloat) _y
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];

        imagesData = [[NSMutableArray alloc] init];
        parser = [[aya_markupParser alloc] init];
        
        attString = [parser attrStringFromMarkup:_markUpString];
        images = parser.images;
        urlRanges = parser.urlRanges;
        
        CGFloat frameHeight = [self getAttributedStringHeightWithString:attString WidthValue:_width];
        
        CGRect drawingRect = CGRectMake(_x, _y, _width, frameHeight);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, drawingRect);
        _coreTextFrame = CTFramesetterCreateFrame(_coreTextFramerSetter,CFRangeMake(0,0), path, NULL);
        CGPathRelease(path);
        
        [self setFrame:CGRectMake(_x, _y, _width, frameHeight)];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) addLineWithY : (CGFloat) _y width : (CGFloat) _width
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _y, _width, 1)];
    [self addSubview:lineView];
    [lineView setBackgroundColor:[UIColor blueColor]];
}

-(void)attachImagesWithFrame:(CTFrameRef)f content : (CGContextRef) _content
{
    //drawing images
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(f);
    
    CGPoint origins[[lines count]];
    CTFrameGetLineOrigins(f, CFRangeMake(0, 0), origins);
    
    int imgIndex = 0;
    
    
    int imgLocation;
    NSDictionary* nextImage;
    if ([images count] != 0)
    {        
        nextImage = [images objectAtIndex:imgIndex];
        imgLocation = [[nextImage objectForKey:@"location"] intValue];
        
        //find images for the current column
        CFRange frameRange = CTFrameGetVisibleStringRange(f);
        
        while ( imgLocation < frameRange.location )
        {
            imgIndex++;
            
            if (imgIndex >= [images count])
            {
                break;
            }
            
            nextImage = [images objectAtIndex:imgIndex];
            imgLocation = [[nextImage objectForKey:@"location"] intValue];
        }
    }
    
    NSUInteger lineIndex = 0;
    for (id lineObj in lines)
    {
        CTLineRef line = (__bridge CTLineRef)lineObj;
        
        CGContextSetTextPosition(_content, origins[lineIndex].x, origins[lineIndex].y);
        CTLineDraw(line, _content);
        
        for (id runObj in (__bridge NSArray *)CTLineGetGlyphRuns(line))
        {
            CTRunRef run = (__bridge CTRunRef)runObj;
            CFRange runRange = CTRunGetStringRange(run);
            
            if ([images count] && runRange.location <= imgLocation && runRange.location+runRange.length > imgLocation )
            {
                CGRect runBounds;
                CGFloat ascent;//height above the baseline
                CGFloat descent;//height below the baseline
                runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
                runBounds.size.height = ascent + descent;
                
                CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
                runBounds.origin.x = origins[lineIndex].x + self.frame.origin.x + xOffset;
                runBounds.origin.y = origins[lineIndex].y + self.frame.origin.y;
                runBounds.origin.y -= descent;
                
                UIImage *img = [UIImage imageNamed: [nextImage objectForKey:@"fileName"] ];
                CGPathRef pathRef = CTFrameGetPath(f);
                CGRect colRect = CGPathGetBoundingBox(pathRef);
                
                CGRect imgBounds = CGRectOffset(runBounds, colRect.origin.x, self.frame.origin.y);
                 [imagesData addObject:[NSArray arrayWithObjects:img, NSStringFromCGRect(imgBounds) , nil]];

                imgIndex++;
                if (imgIndex < [images count])
                {
                    nextImage = [images objectAtIndex: imgIndex];
                    imgLocation = [[nextImage objectForKey: @"location"] intValue];
                }
            }
        }
        lineIndex++;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (!attString)
    {
        return ;
    }

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGMutablePathRef path = CGPathCreateMutable(); //1
    CGPathAddRect(path, NULL, self.bounds );

    CTFrameRef frame = _coreTextFrame;
    
    [self attachImagesWithFrame:frame content:context];
    
    CFRelease(path);
    
    for (NSArray* imageData in imagesData)
    {
        if ([imageData count] > 1)
        {
            UIImage* img = [imageData objectAtIndex:0];
            CGRect imgBounds = CGRectFromString([imageData objectAtIndex:1]);
            CGContextDrawImage(context, imgBounds, img.CGImage);
        }
    }
}

- (void) dealloc
{
    attString = nil;
    images = nil;
    CFRelease(_coreTextFrame);
    CFRelease(_coreTextFramerSetter);
}

- (CGFloat)getAttributedStringHeightWithString:(NSAttributedString *)  string  WidthValue:(int) width
{
    CGFloat total_height = 0;
    
    _coreTextFramerSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)string);    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, width, 2048);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(_coreTextFramerSetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);    
    NSArray *linesArray = (__bridge NSArray *) CTFrameGetLines(textFrame);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    total_height = 2048 - line_y + (int) descent +1;    //+1为了纠正descent转换成int小数点后舍去的值
    
    CFRelease(textFrame);
    
    return total_height;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //获取UITouch对象
    UITouch *touch = [touches anyObject];
    //获取触摸点击当前view的坐标位置
    CGPoint location = [touch locationInView:self];

    //获取每一行
    CFArrayRef lines = CTFrameGetLines(_coreTextFrame);
    CGPoint origins[CFArrayGetCount(lines)];
    //获取每行的原点坐标
    CTFrameGetLineOrigins(_coreTextFrame, CFRangeMake(0, 0), origins);
    CTLineRef line = NULL;
    CGPoint lineOrigin = CGPointZero;
    for (int i= 0; i < CFArrayGetCount(lines); i++)
    {
        CGPoint origin = origins[i];
        CGPathRef path = CTFrameGetPath(_coreTextFrame);
        //获取整个CTFrame的大小
        CGRect rect = CGPathGetBoundingBox(path);

        //坐标转换，把每行的原点坐标转换为uiview的坐标体系
        CGFloat y = rect.origin.y + rect.size.height - origin.y;

        //判断点击的位置处于那一行范围内
        if ((location.y <= y) && (location.x >= origin.x))
        {
            line = CFArrayGetValueAtIndex(lines, i);
            lineOrigin = origin;
            break;
        }
    }
    
    location.x -= lineOrigin.x;
    //获取点击位置所处的字符位置，就是相当于点击了第几个字符
    CFIndex index = CTLineGetStringIndexForPosition(line, location);

    //判断点击的字符是否在需要处理点击事件的字符串范围内，这里是hard code了需要触发事件的字符串范围
    for (NSString *rangStr in urlRanges)
    {
        NSRange subUrlRange = NSRangeFromString(rangStr);
        
        if (index >= subUrlRange.location && index <= subUrlRange.location + subUrlRange.length)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(aya_coreTextView:willClickUrlUnit:)])
            {
                NSString *urlStr = [[attString string] substringWithRange:subUrlRange];
                
                if (![urlStr hasPrefix:@"http://"])
                {
                    urlStr = [NSString stringWithFormat:@"http://%@", urlStr];
                }
                
                [self.delegate aya_coreTextView:self willClickUrlUnit:urlStr];
            }
        }   
    }
}

@end
