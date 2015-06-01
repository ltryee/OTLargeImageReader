//
//  ViewController.m
//  OTLargeImageReaderDemo
//
//  Created by 史江浩 on 6/1/15.
//  Copyright (c) 2015 openthread. All rights reserved.
//

#import "ViewController.h"
#import "OTLargeImageReader.h"

@interface ViewController ()

@end

@implementation ViewController
{
    UIButton *_button;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
}

- (void)buttonTouched:(id)sender
{
    NSString *imagePath = @"/Users/openthread/Desktop/1.jpg";
    UIImage *thumnail = [OTLargeImageFileReader thumbImageFromLargeFile:imagePath
                                                       withMinPixelSize:1080
                                                              imageSize:CGSizeZero];
    [_button setImage:thumnail forState:UIControlStateNormal];
}

- (void)viewDidLayoutSubviews
{
    _button.frame = self.view.bounds;
}

@end
