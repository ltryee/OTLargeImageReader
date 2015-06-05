//
//  AppDelegate.m
//  OTLargeImageReaderMacDemo
//
//  Created by 史江浩 on 6/4/15.
//  Copyright (c) 2015 openthread. All rights reserved.
//

#import "AppDelegate.h"
#import "OTLargeImageReader.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSImageView *imageView;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"haruhi_suzumiya_with_long_hair" ofType:@"png"];
    [OTLargeImageFileReader thumbImageFromLargeFile:imagePath
                                   withMaxPixelSize:1080
                                          imageSize:CGSizeZero
                                           callback:^(NSImage *compressedImage) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   self.imageView.image = compressedImage;
                                               });
                                           }];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    [self.window makeKeyAndOrderFront:NSApp];
    return YES;
}

@end
