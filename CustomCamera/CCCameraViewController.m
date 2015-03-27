//
//  ViewController.m
//  CustomCamera
//
//  Created by Adriano Braga Alencar on 16/03/15.
//  Copyright (c) 2015 YattaTech. All rights reserved.
//

#import "CCCameraViewController.h"
#import "CCCameraVideoFileWriter.h"
#import "CCPreviewView.h"
#import "CCCameraWriterProtocol.h"
#import "CCDeviceUtil.h"
#import "AppDelegate.h"
#import <MobileCoreServices/MobileCoreServices.h>
#ifdef CUSTOM_WRITER
    #import "CCCameraVideoWriter.h"
#elif defined CUSTOM_FILE_WRITER
    #import "CCCameraVideoFileWriter.h"
#else
    #error "CameraWriter not defined"
#endif

@interface CCCameraViewController () {
    id<CCCameraWriterProtocol> _cameraWriter;
}
    
@end

@implementation CCCameraViewController

- (void)viewDidLoad {
#ifdef CUSTOM_WRITER
    [self checkDeviceAuthorizationStatus];
    _cameraWriter       = [[CCCameraVideoWriter alloc] init];
#elif defined CUSTOM_FILE_WRITER
    _cameraWriter       = [[CCCameraVideoFileWriter alloc] init];
#else
    #error "CameraWriter not defined"
#endif
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [_cameraWriter configure:^(AVCaptureVideoOrientation orientation) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CCPreviewView *cameraView = (CCPreviewView *)self.view;
            cameraView.orientation    = orientation;
            cameraView.session        = _cameraWriter.session;
            [_cameraWriter startRunning];
        });
    }];
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [_cameraWriter stopRunning];
    [super viewDidDisappear:animated];
}

- (IBAction)buttonRecordTapped:(id)sender {
    if ([_cameraWriter isRecording]) {
        [_cameraWriter saveVideo:^(NSURL *url) {
            [CCDeviceUtil exportVideoToAlbum:url
                                  completion:^{
                                      exit(0);
                                  }];
        }];
    } else {
        [_cameraWriter recordVideo];
    }
}

- (void)checkDeviceAuthorizationStatus {
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                             completionHandler:^(BOOL granted) {
        if (!granted)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"Alert!"
                                            message:@"CustomCamera doesn't have permission to use Camera, please change privacy settings"
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            });
        }
    }];
}

@end
