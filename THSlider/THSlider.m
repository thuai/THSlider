//
//  THSlider.m
//  SubclassUISlider
//
//  Created by lazy-thuai on 14-4-7.
//  Copyright (c) 2014年 lazy-ios-thuai. All rights reserved.
//

#import "THSlider.h"

#define LMRGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define LMRGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define RED_D14242                              LMRGBCOLOR(0xd1, 0x42, 0x42)

@interface THThumbView : UIView
@property (nonatomic, strong) UIImage *drawImage;
@end

@implementation THThumbView

@synthesize drawImage = _drawImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.opaque = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGRect imageRect = [self getDrawRectFromBounds:rect];
    [self.drawImage drawInRect:imageRect];
}

- (CGRect)getDrawRectFromBounds:(CGRect)bounds
{
    CGSize imageSize = [self.drawImage size];
    CGFloat x = floor((CGRectGetWidth(bounds) - imageSize.width) / 2);
    CGFloat y = floor((CGRectGetHeight(bounds) - imageSize.height) / 2);
    return CGRectMake(x, y, imageSize.width, imageSize.height);
}

#pragma mark - Setters & Getters

- (UIImage *)drawImage
{
    return _drawImage;
}

- (void)setDrawImage:(UIImage *)drawImage
{
    _drawImage = drawImage;
    [self setNeedsDisplay];
}

- (CGSize)thumbImageSize
{
    return self.drawImage.size;
}

@end


@interface THSlider ()
@property (nonatomic, strong) THThumbView *thumbImageView;
@end

@implementation THSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.clipsToBounds = NO;
        
        // the default height of track is 3 pt
        _sliderTrackHeight = 3;
        
        // initialize the defalt color
        _trackBackgroundColor = [UIColor blackColor];
        _trackBufferedColor = [UIColor blueColor];
        _trackProgressColor = RED_D14242;
        
        self.thumbImage = [UIImage imageNamed:@"thumb"];
        
        CGRect imageViewBounds = CGRectMake(0, 0, CGRectGetHeight(frame), CGRectGetHeight(frame));
        CGFloat x = (CGRectGetWidth(imageViewBounds) - [self thumbImageHalfWith] ) / 2;
        CGRect imageViewFrame = CGRectOffset(imageViewBounds, -x, 0);
        _thumbImageView = [[THThumbView alloc] initWithFrame:imageViewFrame];
        _thumbImageView.drawImage = self.thumbImage;
        _thumbImageView.contentMode = UIViewContentModeCenter;
        _thumbImageView.userInteractionEnabled = YES;
        [self addSubview:_thumbImageView];

    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetShouldAntialias(context, YES);
    
    CGRect drawRect = [self trackRectFromSliderBounds:rect];
    CGContextSetFillColorWithColor(context, self.trackBackgroundColor.CGColor);
    [self drawRectangleInContext:context inRect:drawRect withRadius:self.trackCornerRadius];
    CGContextFillPath(context);
    
    CGContextSetFillColorWithColor(context, self.trackBufferedColor.CGColor);
    drawRect = [self trackRectFromSliderBounds:rect];
    drawRect.size.width = self.bufferValue * drawRect.size.width;
    [self drawRectangleInContext:context inRect:drawRect withRadius:self.trackCornerRadius];
    CGContextFillPath(context);
    
    CGContextSetFillColorWithColor(context, self.trackProgressColor.CGColor);
    drawRect = [self trackRectFromSliderBounds:rect];
    CGFloat validWidth = [self trackValidRectOfBounds].size.width;
    drawRect.size.width = self.progressValue * validWidth;
    [self drawRectangleInContext:context inRect:drawRect withRadius:self.trackCornerRadius];
    CGContextFillPath(context);
}

#pragma mark - Setters & Getters

- (void)setProgressValue:(CGFloat)progressValue
{
    _progressValue = progressValue;
    [self reframeThumbView];
    [self setNeedsDisplay];
}

- (void)setBufferValue:(CGFloat)bufferValue
{
    _bufferValue = bufferValue;
    [self setNeedsDisplay];
}

#pragma mark - UIView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (CGRectContainsPoint(self.thumbImageView.frame, point)
        || CGRectContainsPoint(self.bounds, point))
    {
        return self;
    }
    return [super hitTest:point withEvent:event];
}

#pragma mark - UIControl

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView:self];
    if (self.touchChangeValueEnable)
    {
        [self changeThumbOriginFromLocation:location];
        return YES;
    }
    
    if (CGRectContainsPoint(self.thumbImageView.frame, location))
    {
        return YES;
    }
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView:self];
    [self changeThumbOriginFromLocation:location];
    return YES;
}

#pragma mark - Private Methods

- (void)drawRectangleInContext:(CGContextRef)context inRect:(CGRect)rect withRadius:(CGFloat)radius
{
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + radius);
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height - radius);
    CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, radius, M_PI, M_PI / 2, 1);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height);
    CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + radius);
    CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, 0.0f, -M_PI / 2, 1);
    CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y);
    CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + radius, radius, -M_PI / 2, M_PI, 1);
}

- (CGFloat)thumbImageHalfWith
{
    return floor([self.thumbImage size].width / 2);
}

- (CGRect)trackRectFromSliderBounds:(CGRect)bounds
{
    CGFloat y = floor((CGRectGetHeight(bounds) - self.sliderTrackHeight) / 2);
    return CGRectMake(0, y, CGRectGetWidth(bounds), self.sliderTrackHeight);
}

- (CGRect)trackValidRectOfBounds
{
    CGFloat offsetX = [self thumbImageHalfWith];
    return CGRectInset(self.bounds, offsetX * 2, 0);
}

- (CGPoint)limitPoint:(CGPoint)location inBounds:(CGRect)bounds
{
    CGFloat minX = [self thumbImageHalfWith] - self.sliderTrackHeight;
    if (location.x < minX)
    {
        return CGPointMake(minX, location.y);
    }
    CGFloat maxX = CGRectGetWidth(bounds) - minX;
    if (location.x > maxX)
    {
        return CGPointMake(maxX, location.y);
    }
    return location;
}

- (void)reframeThumbView
{
    CGFloat newLocation = self.progressValue * CGRectGetWidth([self trackValidRectOfBounds]);
    CGRect newFrame = self.thumbImageView.frame;
    newFrame.origin.x = newLocation - floor((CGRectGetWidth(self.thumbImageView.frame)) / 2);
    self.thumbImageView.frame = newFrame;
}

- (void)changeThumbOriginFromLocation:(CGPoint)location
{
    CGPoint newLocation = [self limitPoint:location inBounds:self.bounds];
    CGFloat value = newLocation.x / CGRectGetWidth([self trackValidRectOfBounds]);
    [self setProgressValue:value];
}

@end
