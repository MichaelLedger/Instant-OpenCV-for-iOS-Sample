//
//  ViewController.m
//  Recipe08_TakingPhotosFromCamera
//
//  Created by Gavin Xiang on 2021/4/1.
//

#import "ViewController.h"
#import "opencv2/imgcodecs/ios.h"
#import "opencv2/videoio/cap_ios.h"
#import "RetroFilter.hpp"

@interface ViewController () <CvPhotoCameraDelegate>
{
    UIImageView* resultView;
    RetroFilter::Parameters params;
}
@property (nonatomic, strong) CvPhotoCamera* photoCamera;
@property (weak, nonatomic) IBOutlet UIImageView *iv;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *startCaptureButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *takePhotoButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize camera
    _photoCamera = [[CvPhotoCamera alloc]
                   initWithParentView:self.iv];
    _photoCamera.delegate = self;
    _photoCamera.defaultAVCaptureDevicePosition =
    AVCaptureDevicePositionBack;
    _photoCamera.defaultAVCaptureSessionPreset =
    AVCaptureSessionPresetPhoto;
    _photoCamera.defaultAVCaptureVideoOrientation =
    AVCaptureVideoOrientationPortrait;
    
    // Load images
    UIImage* resImage = [UIImage imageNamed:@"scratches.png"];
    UIImageToMat(resImage, params.scratches);
    
    resImage = [UIImage imageNamed:@"fuzzy_border.png"];
    UIImageToMat(resImage, params.fuzzyBorder);
    
    [self.takePhotoButton setEnabled:NO];
}

- (IBAction)startCaptureButtonPressed:(UIBarButtonItem *)sender {
    [_photoCamera start];
//    [self.view addSubview:self.imageView];
    [self.takePhotoButton setEnabled:YES];
    [self.startCaptureButton setEnabled:NO];
}

- (IBAction)takePhotoButtonPressed:(UIBarButtonItem *)sender {
    [_photoCamera takePicture];
}

- (UIImage*)applyFilter:(UIImage*)inputImage;
{
    cv::Mat frame;
    UIImageToMat(inputImage, frame);
    
    params.frameSize = frame.size();
    RetroFilter retroFilter(params);
    
    cv::Mat finalFrame;
    retroFilter.applyToPhoto(frame, finalFrame);
    
    UIImage* result = MatToUIImage(finalFrame);
    return [UIImage imageWithCGImage:[result CGImage]
                               scale:1.0
                         orientation:UIImageOrientationLeftMirrored];
}

- (void)photoCamera:(CvPhotoCamera*)camera
      capturedImage:(UIImage *)image;
{
    [camera stop];
    resultView = [[UIImageView alloc]
                  initWithFrame:self.iv.bounds];
    
    UIImage* result = [self applyFilter:image];
    
    [resultView setImage:result];
//    [resultView setNeedsLayout];
//    [resultView layoutIfNeeded];
    [self.iv addSubview:resultView];
    
    [self.takePhotoButton setEnabled:NO];
    [self.startCaptureButton setEnabled:YES];
}

- (void)photoCameraCancel:(CvPhotoCamera*)camera;
{
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_photoCamera stop];
}

- (void)dealloc
{
    _photoCamera.delegate = nil;
}

@end


