//
//  Popover_ImagePicker.h
//  CafePride-CheckIn
//
//  Created by Bentley Holmes-Gull on 12/29/12.
//  Copyright (c) 2012 Playful Planet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Popover_ImagePickerDelegate;

@interface Popover_ImagePicker : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    id <Popover_ImagePickerDelegate> delegate;
}
@property (nonatomic, assign) id <Popover_ImagePickerDelegate> delegate;
@property (nonatomic, retain) UIImagePickerController *imagePickerController;
@end

@protocol Popover_ImagePickerDelegate
- (void)didTakePicture:(UIImage *)picture;
- (void)didFinishWithCamera;
@end