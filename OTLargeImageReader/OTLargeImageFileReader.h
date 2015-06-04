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

/**
 *  Generate a thumbnail from a large image from disk, get rid of a terrible memory peak.
 *
 *  @param filePath     The large file to read.
 *  @param maxPixelSize The max pixel size of the two edges of the image.
 *  @param imageSize    If you already know the size of image, pass it to here. Otherwise pass CGSizeZero. \n If pass CGSizeZero, this method will read the EXIF info for image size.
 *
 *  @return The result thumbnail. Nil if generate thumbnail failed.
 */
+ (UIImage *)thumbImageFromLargeFile:(NSString *)filePath withMaxPixelSize:(CGFloat)maxPixelSize imageSize:(CGSize)imageSize;

/**
 *  Generate a thumbnail from a large image from disk, get rid of a terrible memory peak.
 *  Excute and callback in a background thread.
 *
 *  @param filePath     The large file to read.
 *  @param maxPixelSize The max pixel size of the two edges of the image.
 *  @param imageSize    If you already know the size of image, pass it to here. Otherwise pass CGSizeZero. \n If pass CGSizeZero, this method will read the EXIF info for image size.

 *  @param callback     The callback of result image. Pass nil if generate thumbnail failed.
 */
+ (void)thumbImageFromLargeFile:(NSString *)filePath withMaxPixelSize:(CGFloat)maxPixelSize imageSize:(CGSize)imageSize callback:(void(^)(UIImage *))callback;

/**
 *  Generate a thumbnail from a large image from disk, get rid of a terrible memory peak.
 *
 *  @param filePath     The large file to read.
 *  @param minPixelSize The min pixel size of the two edges of the image.
 *  @param imageSize    If you already know the size of image, pass it to here. Otherwise pass CGSizeZero. \n If pass CGSizeZero, this method will read the EXIF info for image size.
 *
 *  @return The result thumbnail. Nil if generate thumbnail failed.
 */
+ (UIImage *)thumbImageFromLargeFile:(NSString *)filePath withMinPixelSize:(CGFloat)minPixelSize imageSize:(CGSize)imageSize;

/**
 *  Generate a thumbnail from a large image from disk, get rid of a terrible memory peak.
 *  Excute and callback in a background thread.
 *
 *  @param filePath     The large file to read.
 *  @param minPixelSize The min pixel size of the two edges of the image.
 *  @param imageSize    If you already know the size of image, pass it to here. Otherwise pass CGSizeZero. \n If pass CGSizeZero, this method will read the EXIF info for image size.
 
 *  @param callback     The callback of result image. Pass nil if generate thumbnail failed.
 */
+ (void)thumbImageFromLargeFile:(NSString *)filePath withMinPixelSize:(CGFloat)minPixelSize imageSize:(CGSize)imageSize callback:(void(^)(UIImage *))callback;

@end
