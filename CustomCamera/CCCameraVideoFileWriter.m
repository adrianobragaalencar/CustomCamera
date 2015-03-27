//
//  CCCameraVideoFileWriter.m
//  CustomCamera
//
//  Created by Adriano Braga Alencar on 17/03/15.
//  Copyright (c) 2015 YattaTech. All rights reserved.
//

#import "CCCameraVideoFileWriter.h"
#import "CCDeviceUtil.h"

@interface CCCameraVideoFileWriter() <AVCaptureFileOutputRecordingDelegate> {
    AVCaptureMovieFileOutput *_videoDataOutput;
    __strong DidVideoSave     _completion;
}

@end

@implementation CCCameraVideoFileWriter

- (void) configure: (DidConfigFinish) finish {
    [super configure:finish];
    dispatch_async(sessionQueue, ^{
        AVCaptureDevice *videoDevice         = [CCDeviceUtil deviceWithMediaType:AVMediaTypeVideo
                                                            preferringPosition:AVCaptureDevicePositionBack];
        videoDeviceInput                     = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
        _videoDataOutput                     = [[AVCaptureMovieFileOutput alloc]init];
        _videoDataOutput.maxRecordedDuration = CMTimeMake(MaxDuration, 600);
        if ([session canAddInput:videoDeviceInput]) {
            [session addInput:videoDeviceInput];
        }
        if ([session canAddOutput:_videoDataOutput]) {
            [session addOutput:_videoDataOutput];
            AVCaptureConnection *connection = [_videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
            [self configureAVCaptureConnection:connection];
        }
        finish(orientation);
    });
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
      fromConnections:(NSArray *)connections
                error:(NSError *)error {
    dispatch_async(sessionQueue, ^{
        if (_completion) {
            _completion(outputFileURL);
        }
    });
}

- (void) startRunning {
    NSLog(@"start Running");
    dispatch_async(sessionQueue, ^{
        [session startRunning];
    });
}

- (void) stopRunning {
    NSLog(@"Stop Running");
    dispatch_async(sessionQueue, ^{
        [session stopRunning];
    });
}

- (void) saveVideo: (DidVideoSave) completion {
    NSLog(@"Stop recording video");
    NSLog(@"Start saving video");
    dispatch_async(sessionQueue, ^{
        [_videoDataOutput stopRecording];
        _completion = completion;
    });
}

- (void) recordVideo {
    NSLog(@"Start recording video");
    NSURL *url = [[NSURL alloc] initFileURLWithPath:fileOutputPath];
    DELETE_FILE(url);
    dispatch_async(sessionQueue, ^{
        [_videoDataOutput startRecordingToOutputFileURL:url recordingDelegate:self];
        self.recording = YES;
    });
}

@end

