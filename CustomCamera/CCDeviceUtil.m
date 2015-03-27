//
//  CCDeviceUtil.m
//  CustomCamera
//
//  Created by Adriano Braga Alencar on 16/03/15.
//  Copyright (c) 2015 YattaTech. All rights reserved.
//

#import "CCDeviceUtil.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation CCDeviceUtil

+ (AVCaptureDevice *)deviceWithMediaType:(NSString *) mediaType
                      preferringPosition:(AVCaptureDevicePosition) position {
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:mediaType]) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

+ (void) configureCameraForHighestFrameRate:(AVCaptureDevice *) device {
    AVCaptureDeviceFormat *bestFormat    = nil;
    AVFrameRateRange *bestFrameRateRange = nil;
    for (AVCaptureDeviceFormat *format in [device formats]) {
        for (AVFrameRateRange *range in format.videoSupportedFrameRateRanges) {
            if (range.maxFrameRate > bestFrameRateRange.maxFrameRate) {
                bestFormat         = format;
                bestFrameRateRange = range;
            }
        }
    }
    if (bestFormat) {
        if ([device lockForConfiguration:nil]) {
            device.activeFormat                = bestFormat;
            device.activeVideoMinFrameDuration = bestFrameRateRange.minFrameDuration;
            device.activeVideoMaxFrameDuration = bestFrameRateRange.minFrameDuration;
            [device unlockForConfiguration];
        }
    }
}

+ (void) exportVideoToAlbum: (NSURL *) url
                 completion: (DidExportComplete) completion {
    [CCDeviceUtil sizeFile:url];
    [[[ALAssetsLibrary alloc] init] writeVideoAtPathToSavedPhotosAlbum:url
                                                       completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            NSLog(@"Error while exporting video %@", error.description);
        }
        NSLog(@"Stop saving video");
        DELETE_FILE(url);
        completion();
    }];
}

+ (AVCaptureVideoOrientation) getVideoOrientation: (UIDeviceOrientation) orientation {
    // customize the method to set the device
    // orientation properly
    switch (orientation) {
        default:
            return AVCaptureVideoOrientationLandscapeRight;
    }
}

+ (void) sizeFile: (NSURL *) url {
    AVURLAsset *asset   = [[AVURLAsset alloc]initWithURL:url options:nil];
    float estimatedSize = 0.0 ;
    for (AVAssetTrack * track in [asset tracks]) {
        float rate      = ([track estimatedDataRate] / 8);
        float seconds   = CMTimeGetSeconds([track timeRange].duration);
        estimatedSize  += seconds * rate;
    }
    float sizeInMB = estimatedSize / 1024 / 1024;
    NSLog(@"Estimate file size %f", sizeInMB);
}

@end
