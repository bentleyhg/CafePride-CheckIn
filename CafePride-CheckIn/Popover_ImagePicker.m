//
//  Popover_ImagePicker.m
//  CafePride-CheckIn
//
//  Created by Bentley Holmes-Gull on 12/29/12.
//  Copyright (c) 2012 Playful Planet. All rights reserved.
//

#import "Popover_ImagePicker.h"

@implementation Popover_ImagePicker
@synthesize delegate = _delegate;
@synthesize imagePickerController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
    [self.view addSubview:imagePickerController.view];
    [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    [self setupImagePicker:sourceType];
}

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    self.imagePickerController.sourceType = sourceType;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        // user wants to use the camera interface
        //
        self.imagePickerController.showsCameraControls = NO;
        if ([[self.imagePickerController.cameraOverlayView subviews] count] == 0)
        {
            // setup our custom overlay view for the camera
            //
            // ensure that our custom view's frame fits within the parent frame
            CGRect overlayViewFrame = self.imagePickerController.cameraOverlayView.frame;
            CGRect newFrame = CGRectMake(0.0,
                                         CGRectGetHeight(overlayViewFrame) -
                                         self.view.frame.size.height - 10.0,
                                         CGRectGetWidth(overlayViewFrame),
                                         self.view.frame.size.height + 10.0);
            self.view.frame = newFrame;
            [self.imagePickerController.cameraOverlayView addSubview:self.view];
        }
    }
}

#pragma mark UIImagePickerControllerDelegate

// this get called when an image has been chosen from the library or taken from the camera
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    // give the taken picture to our delegate
    if (self.delegate)
        [self.delegate didTakePicture:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.delegate didFinishWithCamera];    // tell our delegate we are finished with the picker
    
}

@end
