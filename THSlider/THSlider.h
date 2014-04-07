//
//  THSlider.h
//  SubclassUISlider
//
//  Created by lazy-thuai on 14-4-7.
//  Copyright (c) 2014年 lazy-ios-thuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THSlider : UIControl

// the height of the track of slider
@property (nonatomic, assign) CGFloat sliderTrackHeight;
@property (nonatomic, assign) CGFloat trackCornerRadius;

// the background color of the track
@property (nonatomic, strong) UIColor *trackBackgroundColor;
// the color of the progress track
@property (nonatomic, strong) UIColor *trackProgressColor;
// the color of the buffer track
@property (nonatomic, strong) UIColor *trackBufferedColor;

@property (nonatomic, strong) UIImage *thumbImage;

/* the value from 0 to 1.0, and default is 0.1 */
@property (nonatomic, assign) CGFloat progressValue;
/* the value from 0 to 1.0, and defautl value is 0.5 */
@property (nonatomic, assign) CGFloat bufferValue;

/**
 * if you want to change the progress value when tap the slier, set touchChangeValueEnable=YES;
 * the default value is NO;
 */
@property (nonatomic, assign) BOOL touchChangeValueEnable;
@end
