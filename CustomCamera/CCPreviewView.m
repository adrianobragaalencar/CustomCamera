//
//  CCPreviewView.m
//  CustomCamera
//
//  Created by Adriano Braga Alencar on 16/03/15.
//  Copyright (c) 2015 YattaTech. All rights reserved.
//

#import "CCPreviewView.h"

@implementation CCPreviewView

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.orientation = AVCaptureVideoOrientationLandscapeRight;
    }
    return self;
}

+ (Class)layerClass {
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session {
    return [(AVCaptureVideoPreviewLayer *)[self layer] session];
}

- (void)setSession:(AVCaptureSession *)session {
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)[self layer];
    [previewLayer setSession:session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    if (previewLayer.connection.supportsVideoOrientation) {
        previewLayer.connection.videoOrientation = self.orientation;
    }
}

@end
