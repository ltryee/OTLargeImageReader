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

@interface OTLargeImageFileReader : NSObject

+ (CGSize)getImageEXIFSizeFromFilePath:(NSString *)filePath error:(NSError **)error;

+ (UIImage *)thumbImageFromLargeFile:(NSString *)filePath withMaxPixelSize:(CGFloat)maxPixelSize imageSize:(CGSize)imageSize;

+ (UIImage *)thumbImageFromLargeFile:(NSString *)filePath withMinPixelSize:(CGFloat)minPixelSize imageSize:(CGSize)imageSize;

@end
