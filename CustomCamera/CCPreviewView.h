//
//  CCPreviewView.h
//  CustomCamera
//
//  Created by Adriano Braga Alencar on 16/03/15.
//  Copyright (c) 2015 YattaTech. All rights reserved.
//

@interface CCPreviewView : UIView

@property (nonatomic) AVCaptureSession         *session;
@property (nonatomic) AVCaptureVideoOrientation orientation;

@end
