//
//  CCDeviceUtil.h
//  CustomCamera
//
//  Created by Adriano Braga Alencar on 16/03/15.
//  Copyright (c) 2015 YattaTech. All rights reserved.
//

@interface CCDeviceUtil : NSObject

+ (AVCaptureDevice *)deviceWithMediaType:(NSString *) mediaType
                      preferringPosition:(AVCaptureDevicePosition) position;
+ (void) configureCameraForHighestFrameRate:(AVCaptureDevice *) device;
+ (void) exportVideoToAlbum: (NSURL *) url
                 completion: (DidExportComplete) completion;
+ (AVCaptureVideoOrientation) getVideoOrientation: (UIDeviceOrientation) orientation;

@end
