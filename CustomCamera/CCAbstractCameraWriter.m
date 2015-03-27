//
//  CCAbstractCameraWriter.m
//  CustomCamera
//
//  Created by Adriano Braga Alencar on 17/03/15.
//  Copyright (c) 2015 YattaTech. All rights reserved.
//

#import "CCAbstractCameraWriter.h"
#import "CCDeviceUtil.h"

@implementation CCAbstractCameraWriter

@synthesize sessionQueue;
@synthesize session;

- (id) init {
    if (self = [super init]) {
        NSString *name  = [self generateFileName];
        fileOutputPath  = [NSTemporaryDirectory() stringByAppendingPathComponent:[name
                                                  stringByAppendingPathExtension:@"mov"]];
        VideoSettings   = @{ AVVideoCodecKey: AVVideoCodecH264,
                             AVVideoWidthKey: @1280,
                             AVVideoHeightKey: @720,
                             AVVideoCompressionPropertiesKey: @{ AVVideoAverageBitRateKey: @1680000,
                                    AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel,
                                    },
                            };
    }
    return self;
}

- (void) configure: (DidConfigFinish) finish {
    session      = [[AVCaptureSession alloc]init];
    sessionQueue = dispatch_queue_create("CameraRecorderQueue", DISPATCH_QUEUE_SERIAL);
    if ([session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        [session setSessionPreset:AVCaptureSessionPresetHigh];
    }
}

- (void) configureAVCaptureConnection: (AVCaptureConnection *) connection {
    if (connection.supportsVideoOrientation) {
        orientation                 = [CCDeviceUtil getVideoOrientation:[[UIDevice currentDevice] orientation]];
        connection.videoOrientation = orientation;
    }
}

- (NSString *)generateFileName {
    NSDate *time            = [NSDate date];
    NSDateFormatter* format = [NSDateFormatter new];
    [format setDateFormat:@"MM-dd-yyyy-hh-mm-ss"];
    NSString *timeString    = [format stringFromDate:time];
    return [NSString stringWithFormat:@"clip-%@", timeString];
}

@end
