//
//  NMLargeAssetCopyWrapper.m
//  NeteaseMusic
//
//  Created by 史江浩 on 5/31/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "OTLargeAssetCopyWrapper.h"

static const long kOTLargeAssetCopyDefaultBufferSize = 256 * 1024;

@implementation OTLargeAssetCopyWrapper

+ (BOOL)saveAsset:(ALAsset *)photoAsset
           toPath:(NSString *)path
            error:(NSError **)error
{
    return [self saveAsset:photoAsset
                    toPath:path
           shouldOverwrite:YES
                bufferSize:kOTLargeAssetCopyDefaultBufferSize
                     error:error];
}

+ (BOOL)saveAsset:(ALAsset *)photoAsset
           toPath:(NSString *)path
  shouldOverwrite:(BOOL)shouldOverwrite
       bufferSize:(long)bufferSize
            error:(NSError **)error
{
    BOOL pathIsValid = [self validatePath:path shouldOverwrite:shouldOverwrite error:error];
    if (!pathIsValid)
    {
        return NO;
    }
    
    BOOL createSuccessed = [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    if (!createSuccessed)
    {
        if (error)
        {
            NSString *reason = [NSString stringWithFormat:@"Create file failed at path %@.", path];
            *error = [NSError errorWithDomain:@"OTLargeImageReaderSaveAssetFailed"
                                         code:1004
                                     userInfo:@{@"reason" : reason}];
        }
        return NO;
    }
    
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
    if (!handle)
    {
        if (error)
        {
            NSString *reason = [NSString stringWithFormat:@"File handle init failed at path %@.", path];
            *error = [NSError errorWithDomain:@"OTLargeImageReaderSaveAssetFailed"
                                         code:1005
                                     userInfo:@{@"reason" : reason}];
        }
        return NO;
    }

    ALAssetRepresentation *rep = photoAsset.defaultRepresentation;
    
    long long offset = 0;
    void *dataBuffer = malloc(bufferSize);
    NSError *internalError;
    do
    {
        NSUInteger readByteLength = [rep getBytes:dataBuffer fromOffset:offset length:bufferSize error:&internalError];
        if(internalError)
        {
            break;
        }
        offset += readByteLength;
        ssize_t writedLength = write([handle fileDescriptor], dataBuffer, readByteLength);
        if (writedLength == -1)
        {
            NSString *reason = [NSString stringWithFormat:@"File handle write file failed at path %@.", path];
            internalError = [NSError errorWithDomain:@"OTLargeImageReaderSaveAssetFailed"
                                                code:1005
                                            userInfo:@{@"reason" : reason}];
            break;
        }
    }
    while (offset < rep.size);
    
    free(dataBuffer);
    [handle closeFile];

    if (internalError)
    {
        if(error)
        {
            *error = internalError;
        }
        return NO;
    }
    
    if (error)
    {
        *error = nil;
    }
    return YES;
}

//private method. Path at here must be a valid path
+ (BOOL)validatePath:(NSString *)path shouldOverwrite:(BOOL)shouldOverwrite error:(NSError **)error
{
    //Path is not an NSString
    if (![path isKindOfClass:[NSString class]])
    {
        if (error)
        {
            NSString *reason = [NSString stringWithFormat:@"Path %@ is not an NSString.", path];
            *error = [NSError errorWithDomain:@"OTLargeImageReaderSaveAssetFailed"
                                         code:1001
                                     userInfo:@{@"reason" : reason}];
        }
        return NO;
    }
    
    //File already exist
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        if (shouldOverwrite)//overwrite existing file
        {
            BOOL removeSuccessed = [[NSFileManager defaultManager] removeItemAtPath:path error:error];
            if (!removeSuccessed)
            {
                return NO;
            }
        }
        else//do not overwrite
        {
            if (error)
            {
                NSString *reason = [NSString stringWithFormat:@"File already exist at path %@.", path];
                *error = [NSError errorWithDomain:@"OTLargeImageReaderSaveAssetFailed"
                                             code:1002
                                         userInfo:@{@"reason" : reason}];
            }
            return NO;
        }
    }
    
    //Super path exist and is not a directory
    NSString *superPath = [path stringByDeletingLastPathComponent];
    BOOL isDirectory = NO;
    BOOL superPathExist = [[NSFileManager defaultManager] fileExistsAtPath:superPath isDirectory:&isDirectory];
    if (superPathExist && !isDirectory)
    {
        if (error)
        {
            NSString *reason = [NSString stringWithFormat:@"File already exist at super path %@.", superPath];
            *error = [NSError errorWithDomain:@"OTLargeImageReaderSaveAssetFailed"
                                         code:1003
                                     userInfo:@{@"reason" : reason}];
        }
        return NO;
    }
    
    //Super path not exist, create it
    if (!superPathExist)
    {
        BOOL createSuccessed = [[NSFileManager defaultManager] createDirectoryAtPath:superPath
                                                         withIntermediateDirectories:YES
                                                                          attributes:nil
                                                                               error:error];
        if (!createSuccessed)
        {
            return NO;
        }
    }
    return YES;
}

//Save asset image to a sandbox path in background thread
+ (void)saveAsset:(ALAsset *)photoAsset
           toPath:(NSString *)path
         callback:(void(^)(BOOL successed, NSError *error))callback
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        BOOL successed = [self saveAsset:photoAsset toPath:path error:&error];
        callback(successed, error);
    });
}

//Save asset image to a sandbox path in background thread
+ (void)saveAsset:(ALAsset *)photoAsset
           toPath:(NSString *)path
  shouldOverwrite:(BOOL)shouldOverwrite
       bufferSize:(long)bufferSize
         callback:(void(^)(BOOL successed, NSError *error))callback
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        BOOL successed = [self saveAsset:photoAsset toPath:path shouldOverwrite:shouldOverwrite bufferSize:bufferSize error:&error];
        callback(successed, error);
    });
}

@end
