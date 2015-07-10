
//
//  OTLargeImageFileReader.m
//  NeteaseMusic
//
//  Created by 史江浩 on 5/31/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "OTLargeImageFileReader.h"

@implementation OTLargeImageFileReader

+ (CGSize)getImageEXIFSizeFromFilePath:(NSString *)filePath error:(NSError **)error
{
    //Create the image source (from path)
    CGImageSourceRef src = CGImageSourceCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:filePath], NULL);
    if (!src)
    {
        if (error)
        {
            NSString *reason = [NSString stringWithFormat:@"Gen source ref failed at path : %@", filePath];
            *error = [NSError errorWithDomain:@"OTLargeImageReadEXIFError" code:2001 userInfo:@{@"reason": reason}];
        }
        return CGSizeZero;
    }
    
    NSDictionary *imagePropertiesDictionary;
    imagePropertiesDictionary = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(src,0, NULL));
    CFRelease(src);
    
    //Get EXIF data
    NSDictionary  *exif = imagePropertiesDictionary[(__bridge NSString *)kCGImagePropertyExifDictionary];
    if (!exif)
    {
        if (error)
        {
            NSString *reason = [NSString stringWithFormat:@"Get EXIF failed at path : %@", filePath];
            *error = [NSError errorWithDomain:@"OTLargeImageReadEXIFError" code:2002 userInfo:@{@"reason": reason}];
        }
        return CGSizeZero;
    }
    
    //Return size
    NSNumber *width = exif[(__bridge NSString *)kCGImagePropertyExifPixelXDimension];
    NSNumber *height = exif[(__bridge NSString *)kCGImagePropertyExifPixelYDimension];
    CGSize result = CGSizeMake(width.doubleValue, height.doubleValue);
    return result;
}

//private method
//maxPixelSize MUST BE a valid value.
+ (UIImage *)thumbImageFromLargeFile:(NSString *)filePath withConfirmedMaxPixelSize:(CGFloat)maxPixelSize
{
    // Create the image source (from path)
    CGImageSourceRef src = CGImageSourceCreateWithURL((__bridge CFURLRef) [NSURL fileURLWithPath:filePath], NULL);
    if (!src) {
        return nil;
    }
    
    // To create image source from UIImage, use this
    // NSData* pngData =  UIImagePNGRepresentation(image);
    // CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)pngData, NULL);
    
    // Create thumbnail options
    CFDictionaryRef options = (__bridge CFDictionaryRef) @{
                                                           (id) kCGImageSourceCreateThumbnailWithTransform : @YES,
                                                           (id) kCGImageSourceCreateThumbnailFromImageAlways : @YES,
                                                           (id) kCGImageSourceThumbnailMaxPixelSize : @(maxPixelSize)
                                                           };
    // Generate the thumbnail
    CGImageRef thumbnail = CGImageSourceCreateThumbnailAtIndex(src, 0, options);
    CFRelease(src);
    if (!thumbnail) {
        return nil;
    }
    
    UIImage *image = [[UIImage alloc] initWithCGImage:thumbnail];
    CFRelease(thumbnail);
    return image;
}

+ (UIImage *)thumbImageFromLargeFile:(NSString *)filePath withMaxPixelSize:(CGFloat)maxPixelSize imageSize:(CGSize)imageSize
{
    if (CGSizeEqualToSize(imageSize, CGSizeZero))
    {
        imageSize = [self getImageEXIFSizeFromFilePath:filePath error:nil];
    }
    
    if (CGSizeEqualToSize(imageSize, CGSizeZero))
        //If maxPixelSize not passed and get EXIF failed
    {
        //do nothing here, use maxPixelSize
    }
    else if (MAX(imageSize.width, imageSize.height) < maxPixelSize)
    {
        //If larger dimonsion of original image less than pressed image, return original one
        maxPixelSize = MAX(imageSize.width, imageSize.height);
    }
    
    UIImage *image = [self thumbImageFromLargeFile:filePath withConfirmedMaxPixelSize:maxPixelSize];
    return image;
}

+ (void)thumbImageFromLargeFile:(NSString *)filePath withMaxPixelSize:(CGFloat)maxPixelSize imageSize:(CGSize)imageSize callback:(void(^)(UIImage *))callback
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self thumbImageFromLargeFile:filePath withMaxPixelSize:maxPixelSize imageSize:imageSize];
        callback(image);
    });
}

+ (UIImage *)thumbImageFromLargeFile:(NSString *)filePath withMinPixelSize:(CGFloat)minPixelSize imageSize:(CGSize)imageSize
{
    if (CGSizeEqualToSize(imageSize, CGSizeZero))
    {
        imageSize = [self getImageEXIFSizeFromFilePath:filePath error:nil];
    }
    
    CGFloat maxPixelSize = 0;
    if (CGSizeEqualToSize(imageSize, CGSizeZero))
    {
        //If minPixelSize not passed and get EXIF failed
        //Use minPixelSize as maxPixelSize
        maxPixelSize = minPixelSize;
    }
    else
    {
        //If image size already passed or get EXIF successed
        if (MIN(imageSize.width, imageSize.height) < minPixelSize)
            //If smaller dimonsion of original image less than pressed image, return original one
        {
            minPixelSize = MIN(imageSize.width, imageSize.height);
        }
        maxPixelSize = round((MAX(imageSize.width, imageSize.height) / MIN(imageSize.width, imageSize.height)) * minPixelSize);
    }
    UIImage *image = [self thumbImageFromLargeFile:filePath withConfirmedMaxPixelSize:maxPixelSize];
    return image;
}

+ (void)thumbImageFromLargeFile:(NSString *)filePath withMinPixelSize:(CGFloat)minPixelSize imageSize:(CGSize)imageSize callback:(void(^)(UIImage *))callback
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self thumbImageFromLargeFile:filePath withMinPixelSize:minPixelSize imageSize:imageSize];
        callback(image);
    });
}

//Unused method now, for future feature usage.
void OTLargeImageCGImageWriteToFile(CGImageRef image, NSString *path)
{
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:path];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);
    CGImageDestinationAddImage(destination, image, nil);
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"Failed to write image to %@", path);
    }
    CFRelease(destination);
}

@end
