//
//  CCCameraVideoWriter.m
//  CustomCamera
//
//  Created by Adriano Braga Alencar on 16/03/15.
//  Copyright (c) 2015 YattaTech. All rights reserved.
//

#import "CCCameraVideoWriter.h"
#import "CCDeviceUtil.h"

@interface CCCameraVideoWriter() <AVCaptureVideoDataOutputSampleBufferDelegate> {
    AVCaptureVideoDataOutput *_videoDataOutput;
    AVAssetWriter            *_writer;
    AVAssetWriterInput       *_writerInput;
}

@end

@implementation CCCameraVideoWriter

- (void) configure: (DidConfigFinish)finish {
    [super configure:finish];
    dispatch_async(sessionQueue, ^{
        AVCaptureDevice *videoDevice                   = [CCDeviceUtil deviceWithMediaType:AVMediaTypeVideo
                                                                        preferringPosition:AVCaptureDevicePositionBack];
        [CCDeviceUtil configureCameraForHighestFrameRate:videoDevice];
        videoDeviceInput                               = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
        _videoDataOutput                               = [[AVCaptureVideoDataOutput alloc]init];
        _videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
        [[_videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:YES];
        if ([session canAddInput:videoDeviceInput]) {
            [session addInput:videoDeviceInput];
        }
        if ([session canAddOutput:_videoDataOutput]) {
            _videoDataOutput.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                             [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA], (id)kCVPixelBufferPixelFormatTypeKey,
                                             nil];
            [session addOutput:_videoDataOutput];
            AVCaptureConnection *connection = [_videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
            [self configureAVCaptureConnection:connection];
            [_videoDataOutput setSampleBufferDelegate:self queue:sessionQueue];
        }
        finish(orientation);
    });
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {
    CFRetain(sampleBuffer);
    dispatch_async(sessionQueue, ^{
        if ([self isRecording]) {
            if (_writer.status == AVAssetWriterStatusUnknown) {
                if ([_writer startWriting]) {
                    [_writer startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp(sampleBuffer)];
                }
            }
            if (_writer.status == AVAssetWriterStatusWriting) {
                if (_writerInput.readyForMoreMediaData) {
                    [_writerInput appendSampleBuffer:sampleBuffer];
                }
            }
        }
        CFRelease(sampleBuffer);
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
        NSURL *url     = [[NSURL alloc] initFileURLWithPath:fileOutputPath];
        self.recording = NO;
        [_writerInput markAsFinished];
        [_writer finishWritingWithCompletionHandler:^{
            completion(url);
        }];
    });
}

- (void) recordVideo {
    NSLog(@"Start recording video");
    NSURL *url = [[NSURL alloc] initFileURLWithPath:fileOutputPath];
    DELETE_FILE(url);
    dispatch_async(sessionQueue, ^{
        _writer      = [[AVAssetWriter alloc] initWithURL: url
                                                 fileType:AVFileTypeQuickTimeMovie
                                                    error:nil];
        _writerInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeVideo
                                                      outputSettings:VideoSettings];
        _writerInput.expectsMediaDataInRealTime = YES;
        if ([_writer canAddInput:_writerInput]) {
            [_writer addInput:_writerInput];
        }
        self.recording = YES;
    });
}

@end
