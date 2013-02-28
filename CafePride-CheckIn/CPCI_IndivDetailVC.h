//
//  CPCI_IndivDetailVC.h
//  CafePride-CheckIn
//
//  Created by Bentley Holmes-Gull on 1/24/13.
//  Copyright (c) 2013 Playful Planet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Individual.h"
#import "Btn_Attendance.h"
#import "Popover_DatePicker.h"
#import "Popover_ImagePicker.h"


@interface CPCI_IndivDetailVC : UIViewController <UIImagePickerControllerDelegate, Popover_ImagePickerDelegate, UIPopoverControllerDelegate, UIAlertViewDelegate>
{
    // Attendance buttons for setting the current or initial attendance status
    Btn_Attendance *eligibilityButtons;
    
    BOOL viewPopped;
}

// Values required to setup the detail view
@property (strong, nonatomic) Individual *myIndivData;
@property (strong, nonatomic) NSIndexPath *myIndexpath;
@property (strong, nonatomic) NSString *editmode;

// Text Fields and buttons set via Storyboard
// Name related properties
@property (strong, nonatomic) IBOutlet UITextField *textfield_name_preferred;
@property (strong, nonatomic) IBOutlet UITextField *textfield_name_first;
@property (strong, nonatomic) IBOutlet UITextField *textfield_name_last;

// Date of Birth properties
@property (strong, nonatomic) IBOutlet UILabel *label_date_of_birth;
@property (strong, nonatomic) NSDate* date_of_birth;

// Date Picker Popover properties
@property (nonatomic, strong) UIPopoverController *datePickerViewPopover;
@property (nonatomic, strong) Popover_DatePicker *datePopoverContent;

// Image Picker Popover properties
@property (nonatomic, strong) UIPopoverController *imageViewPopover;
@property (nonatomic, strong) Popover_ImagePicker  *imagePopoverContent;

// Attendance status properties
@property (strong, nonatomic) IBOutlet UILabel *label_AttendanceEligibility;

//Notes Properties
@property (strong, nonatomic) IBOutlet UITextView *textfield_Notes;

// Context required for saving and fetching data
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

// Methods for setting the date using a Date Picker
- (IBAction)setDate:(id)sender;
- (void)dateChanged; // when the user has changed the date picke values (m/d/y)

// Methods for setting the profile image
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
- (IBAction)changePhoto:(id)sender;

// Methods triggered by buttons
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btn_Save;
- (IBAction)save:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btn_delete;
- (IBAction)delete_indiv:(id)sender;


@end
