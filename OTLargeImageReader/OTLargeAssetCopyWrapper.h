//
//  NMLargeAssetCopyWrapper.h
//  NeteaseMusic
//
//  Created by 史江浩 on 5/31/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

/**
 *  Save an ALAsset's full image to a local path.
 */
@interface OTLargeAssetCopyWrapper : NSObject

/**
 *  Save asset image to a sandbox path. 
 *  Default buffer size is 256k, file at target path will be overwrite.
 *
 *  @param photoAsset The photo ALAsset to.
 *  @param path       The path to save the full image.
 *  @param error      If error occurs, returns to this param.
 *
 *  @return YES if save successed. Otherwise NO.
 */
+ (BOOL)saveAsset:(ALAsset *)photoAsset
           toPath:(NSString *)path
            error:(NSError **)error;

/**
 *  Save asset image to a sandbox path in background thread.
 *  Default buffer size is 256k, file at target path will be overwrite.
 *
 *  @param photoAsset The photo ALAsset to.
 *  @param path       The path to save the full image.
 *  @param callback   The callback for result.
 */
+ (void)saveAsset:(ALAsset *)photoAsset
           toPath:(NSString *)path
         callback:(void(^)(BOOL successed, NSError *error))callback;

/**
 *  Save asset image to a sandbox path. May specific the buffer size and should overwrite.
 *
 *  @param photoAsset      The photo ALAsset to.
 *  @param path            The path to save the full image.
 *  @param shouldOverwrite If file exist at path, whether it should be overwrited.
 *  @param bufferSize      Specific the buffer size to copy the image.
 *  @param error           If error occurs, returns to this param.
 *
 *  @return YES if save successed. Otherwise NO.
 */
+ (BOOL)saveAsset:(ALAsset *)photoAsset
           toPath:(NSString *)path
  shouldOverwrite:(BOOL)shouldOverwrite
       bufferSize:(long)bufferSize
            error:(NSError **)error;

/**
 *  Save asset image to a sandbox path. May specific the buffer size and should overwrite.
 *
 *  @param photoAsset      The photo ALAsset to.
 *  @param path            The path to save the full image.
 *  @param shouldOverwrite If file exist at path, whether it should be overwrited.
 *  @param bufferSize      Specific the buffer size to copy the image.
 *  @param callback        The callback for result.
 */
+ (void)saveAsset:(ALAsset *)photoAsset
           toPath:(NSString *)path
  shouldOverwrite:(BOOL)shouldOverwrite
       bufferSize:(long)bufferSize
         callback:(void(^)(BOOL successed, NSError *error))callback;

@end
