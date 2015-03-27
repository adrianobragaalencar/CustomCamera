//
//  CCCameraWriterProtocol.h
//  CustomCamera
//
//  Created by Adriano Braga Alencar on 17/03/15.
//  Copyright (c) 2015 YattaTech. All rights reserved.
//

@protocol CCCameraWriterProtocol <NSObject>

@required

@property (nonatomic) AVCaptureSession          *session;
@property (nonatomic) dispatch_queue_t           sessionQueue;
@property (nonatomic, getter = isRecording) BOOL recording;

@optional

- (void) configure: (DidConfigFinish) finish;
- (void) startRunning;
- (void) stopRunning;
- (void) saveVideo: (DidVideoSave) completion;
- (void) recordVideo;

@end
