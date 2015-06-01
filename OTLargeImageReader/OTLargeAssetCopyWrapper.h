//
//  NMLargeAssetCopyWrapper.h
//  NeteaseMusic
//
//  Created by 史江浩 on 5/31/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface OTLargeAssetCopyWrapper : NSObject

//Save asset image to a sandbox path
+ (BOOL)saveAsset:(ALAsset *)photoAsset
           toPath:(NSString *)path
            error:(NSError **)error;

//Save asset image to a sandbox path
+ (BOOL)saveAsset:(ALAsset *)photoAsset
           toPath:(NSString *)path
  shouldOverwrite:(BOOL)shouldOverwrite
       bufferSize:(long)bufferSize
            error:(NSError **)error;


//Save asset image to a sandbox path in background thread
+ (void)saveAsset:(ALAsset *)photoAsset
           toPath:(NSString *)path
         callback:(void(^)(BOOL successed, NSError *error))callback;

//Save asset image to a sandbox path in background thread
+ (void)saveAsset:(ALAsset *)photoAsset
           toPath:(NSString *)path
  shouldOverwrite:(BOOL)shouldOverwrite
       bufferSize:(long)bufferSize
         callback:(void(^)(BOOL successed, NSError *error))callback;

@end
