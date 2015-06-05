//
//  ViewController.m
//  OTLargeImageReaderDemo
//
//  Created by 史江浩 on 6/1/15.
//  Copyright (c) 2015 openthread. All rights reserved.
//

#import "ViewController.h"
#import "OTLargeImageReader.h"
#import "UIImage+TraditionalCompress.h"

@interface ViewController ()

@end

@implementation ViewController
{
    UIImageView *_backgroundImageView;
    UIButton *_imageReaderButton;
    UIButton *_imageContextButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_backgroundImageView];
    
    _imageReaderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_imageReaderButton setTitle:@"Compress image using OTLargeImageReader" forState:UIControlStateNormal];
    [_imageReaderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_imageReaderButton addTarget:self action:@selector(largeImageReaderButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_imageReaderButton];
    
    _imageContextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_imageContextButton setTitle:@"Compress image using CGContext" forState:UIControlStateNormal];
    [_imageContextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_imageContextButton addTarget:self action:@selector(contextButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_imageContextButton];
}

- (void)largeImageReaderButtonTouched:(id)sender
{
    NSString *imagePath = [[self class] imagePath];
    UIImage *thumbnail = [OTLargeImageFileReader thumbImageFromLargeFile:imagePath
                                                       withMinPixelSize:1080
                                                              imageSize:CGSizeZero];
    _backgroundImageView.image = thumbnail;
}

- (void)contextButtonTouched:(id)sender
{
    UIImage *image = [UIImage imageWithContentsOfFile:[[self class] imagePath]];
    UIImage *compressedImage = [image imageByScalingProportionallyToSize:CGSizeMake(1080, 1080)];
    _backgroundImageView.image = compressedImage;
    image = nil;
}

- (void)viewDidLayoutSubviews
{
    _backgroundImageView.frame = self.view.bounds;
    _imageReaderButton.frame = CGRectMake(0,
                                          0,
                                          CGRectGetWidth(self.view.frame),
                                          CGRectGetHeight(self.view.frame) / 2);
    _imageContextButton.frame = CGRectMake(0,
                                           CGRectGetHeight(self.view.frame) / 2,
                                           CGRectGetWidth(self.view.frame),
                                           CGRectGetHeight(self.view.frame) / 2);
}

+ (NSString *)imagePath
{
    static NSString *cachePath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cachePath = [[NSBundle mainBundle] pathForResource:@"haruhi_suzumiya_with_long_hair" ofType:@"png"];
    });
    return cachePath;
}

@end
