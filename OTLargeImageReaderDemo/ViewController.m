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
    UIImageView *_imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [self.view addSubview:_imageView];
    
    
}

- (void)viewDidLayoutSubviews
{
    _imageView.frame = self.view.bounds;
}

@end
