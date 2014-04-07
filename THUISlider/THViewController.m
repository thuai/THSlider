//
//  THViewController.m
//  SubclassUISlider
//
//  Created by lazy-thuai on 14-4-7.
//  Copyright (c) 2014年 lazy-ios-thuai. All rights reserved.
//

#import "THViewController.h"
#import "THSlider.h"

@interface THViewController ()

@end

@implementation THViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _slider = [[THSlider alloc] initWithFrame:CGRectMake(30, 30, 200, 40)];
    [self.view addSubview:_slider];
   
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onTimerEvent) userInfo:nil repeats:YES];
}

- (void)onTimerEvent
{
    [self changeBufferValue];
    [self changeProgressValue];
}

- (void)changeProgressValue
{
    if (self.slider.progressValue > 1)
    {
        self.slider.progressValue = 0;
        self.slider.bufferValue = 0;
    }
    self.slider.progressValue += 0.05;
}

- (void)changeBufferValue
{
    self.slider.bufferValue = self.slider.bufferValue > 1 ? 1 : self.slider.bufferValue;
    self.slider.bufferValue += 0.07;
}
@end
