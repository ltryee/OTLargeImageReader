//
//  OTLargeImageFileReader.h
//  NeteaseMusic
//
//  Created by 史江浩 on 5/31/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <UIKit/UIKit.h>

/**
 *  Get thumbnail from a large image, get rid of a terrible memory peak.
 */
@interface OTLargeImageFileReader : NSObject

/**
 *  Get image size by EXIF, without read the full image file.
 *
 *  @param filePath The image path to get EXIF size.
 *  @param error    If an error occurs, upon return contains an NSError object that describes the problem. \n Pass NULL if you do not want error information.
 *
 *  @return The image size in EXIF.
 */
+ (CGSize)getImageEXIFSizeFromFilePath:(NSString *)filePath error:(NSError **)error;

+ (UIImage *)thumbImageFromLargeFile:(NSString *)filePath withMaxPixelSize:(CGFloat)maxPixelSize imageSize:(CGSize)imageSize;

+ (void)thumbImageFromLargeFile:(NSString *)filePath withMaxPixelSize:(CGFloat)maxPixelSize imageSize:(CGSize)imageSize callback:(void(^)(UIImage *))callback;

+ (UIImage *)thumbImageFromLargeFile:(NSString *)filePath withMinPixelSize:(CGFloat)minPixelSize imageSize:(CGSize)imageSize;

+ (void)thumbImageFromLargeFile:(NSString *)filePath withMinPixelSize:(CGFloat)minPixelSize imageSize:(CGSize)imageSize callback:(void(^)(UIImage *))callback;

@end
