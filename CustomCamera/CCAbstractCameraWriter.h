//
//  CCAbstractCameraWriter.h
//  CustomCamera
//
//  Created by Adriano Braga Alencar on 17/03/15.
//  Copyright (c) 2015 YattaTech. All rights reserved.
//

#import "CCCameraWriterProtocol.h"

@interface CCAbstractCameraWriter : NSObject<CCCameraWriterProtocol>
{
    AVCaptureSession         *session;
    AVCaptureDeviceInput     *videoDeviceInput;
    NSString                 *fileOutputPath;
    NSDictionary             *VideoSettings;
    dispatch_queue_t          sessionQueue;
    AVCaptureVideoOrientation orientation;
}

@property (nonatomic) AVCaptureSession          *session;
@property (nonatomic) dispatch_queue_t           sessionQueue;
@property (nonatomic, getter = isRecording) BOOL recording;

- (void) configureAVCaptureConnection: (AVCaptureConnection *) connection;

@end
