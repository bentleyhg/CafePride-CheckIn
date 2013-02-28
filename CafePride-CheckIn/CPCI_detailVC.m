//
//  CPCI_detailVC.m
//  CafePride-CheckIn
//
//  Created by Bentley Holmes-Gull on 11/9/12.
//  Copyright (c) 2012 Playful Planet. All rights reserved.
//

#import "CPCI_detailVC.h"
#import "CPCI_masterVC.h"
#import "Individual.h"
#import "Individual_Details.h"
#import "Btn_Attendance.h"
#import "Popover_DatePicker.h"
#import "Popover_ImagePicker.h"

@interface CPCI_detailVC ()

@end

@implementation CPCI_detailVC
// Values required to setup the detail view
@synthesize myIndivData;
@synthesize editmode;

// Navigation Bar Buttons
@synthesize btn_Save;
@synthesize btn_delete;

// Text Fields and buttons set via Storyboard
// Name related properties
@synthesize textfield_name_preferred;
@synthesize textfield_name_first;
@synthesize textfield_name_last;

// Date of Birth properties
@synthesize label_date_of_birth;
@synthesize date_of_birth;
@synthesize datePickerViewPopover;
@synthesize datePopoverContent;

// Image Picker Properties
@synthesize imageViewPopover;
@synthesize imagePopoverContent;
@synthesize profileImageView;

// Attendance status properties
@synthesize label_AttendanceStatus;
@synthesize label_AttendanceEligibility;

//Notes Properties
@synthesize textfield_Notes;

// Context required for saving and fetching data
@synthesize managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark View Initialization
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //Set up the buttons used to set attendance status and eligibility
    CGRect btnFrame = CGRectMake(20.0, 320.0, 400.0, 50);
    attendanceButtons = [[Btn_Attendance alloc] initWithFrame:btnFrame];
    [attendanceButtons addMiniButtons];
    attendanceButtons.managedObjectContext = self.managedObjectContext;
    [self.view addSubview:attendanceButtons];
    
    btnFrame = CGRectMake(20.0, 433.0, 400.0, 50);
    eligibilityButtons = [[Btn_AttendanceEligibility alloc] initWithFrame:btnFrame];
    [eligibilityButtons addButtons];
    eligibilityButtons.managedObjectContext = self.managedObjectContext;
    [self.view addSubview:eligibilityButtons];
    
    // Set up the actions that will be triggered when the attendance and
    // eligibility buttons are tapped
    [attendanceButtons.btn_CheckIn addTarget:self
                    action:@selector(setLabel:)
          forControlEvents:UIControlEventTouchUpInside];
    [attendanceButtons.btn_OnBreak addTarget:self
                                      action:@selector(setLabel:)
                            forControlEvents:UIControlEventTouchUpInside];
    [attendanceButtons.btn_CheckOut addTarget:self
                                      action:@selector(setLabel:)
                            forControlEvents:UIControlEventTouchUpInside];
    
    [eligibilityButtons.btn_Eligible addTarget:self
                                      action:@selector(setLabel:)
                            forControlEvents:UIControlEventTouchUpInside];
    [eligibilityButtons.btn_AgedOut addTarget:self
                                        action:@selector(setLabel:)
                              forControlEvents:UIControlEventTouchUpInside];
    [eligibilityButtons.btn_Banned addTarget:self
                                        action:@selector(setLabel:)
                              forControlEvents:UIControlEventTouchUpInside];
    
    // Check to see which editmode we are in
    if ([editmode isEqualToString:@"addnew"]){
        // load the "Add New interface
        [self load_AddNewMode];
    }else if ([editmode isEqualToString:@"standard"]){
        // load "Standard" edit mode]
        [self load_StandardMode];
    }
    
    // Prepare the popover that the Date Picker uses
     datePopoverContent= [[Popover_DatePicker alloc] init];
	
	// Setup the popover for use by the datePicker view.
	self.datePickerViewPopover = [[UIPopoverController alloc] initWithContentViewController:datePopoverContent];
	self.datePickerViewPopover.popoverContentSize = CGSizeMake(320.0, 320.0);
    self.datePickerViewPopover.delegate = self;
    
    // Prepare the popover that the Image Picker uses
    imagePopoverContent = [[Popover_ImagePicker alloc] init];
    imagePopoverContent.delegate = self;
    
    // Prepare the popover that the ImagePicker uses
    self.imageViewPopover = [[UIPopoverController alloc] initWithContentViewController:imagePopoverContent];
	self.imageViewPopover.popoverContentSize = CGSizeMake(320.0, 320.0);
    self.imageViewPopover.delegate = self;
}

-(void)setLabel:(UIButton*) sender
{
    label_AttendanceStatus.text = attendanceButtons.myAttendanceStatus;
    label_AttendanceEligibility.text = eligibilityButtons.myEligibilityStatus;
}

-(void)load_AddNewMode
{
    // This function contains the logic needed to load the "Add New" edit mode. In the "Add New"
    // edit mode users enter the starting data needed for adding a new individual to the data
    // store
    
    btn_Save.title = @"Add";
    
    // Set the Attendance Status buttons and fields to their initial states
    [attendanceButtons.btn_CheckOut setSelected:TRUE];
    attendanceButtons.myAttendanceStatus = @"Checked-Out";
    label_AttendanceStatus.text = @"Checked Out";
    
    eligibilityButtons.myEligibilityStatus = @"Eligible";
    label_AttendanceEligibility.text = @"Eligible";
}

- (void) load_StandardMode
{
    // This function contains the logic needed to load the standard edit mode. In the standard
    // edit mode users can edit data about a specific individual in the data store
    
    // Set the save Btn text
    btn_Save.title = @"Save";
    
    // Populate basic info fields
    myIndivData = myIndivData;
    
    textfield_name_preferred.text = myIndivData.name_preferred;
    textfield_name_first.text = myIndivData.name_first;
    textfield_name_last.text = myIndivData.name_last;
    
    //populate detail fields
    Individual_Details *indiv_details = myIndivData.details;
    
    // format the date for string output
    NSString *datestring = [self dateToString:indiv_details.date_of_birth];
    label_date_of_birth.text = datestring;
    
    // Set the Attendance Status buttons to their correct states
    if ([indiv_details.attendance_status isEqualToString:@"Checked-In"]) {
        [attendanceButtons.btn_CheckIn setSelected:TRUE];
        label_AttendanceStatus.text = @"Checked In";
    }
    
    if ([indiv_details.attendance_status isEqualToString:@"On-Break"]) {
        [attendanceButtons.btn_OnBreak setSelected:TRUE];
        label_AttendanceStatus.text = @"On Break";
    }
    
    if ([indiv_details.attendance_status isEqualToString:@"Checked-Out"]) {
        [attendanceButtons.btn_CheckOut setSelected:TRUE];
        label_AttendanceStatus.text = @"On Break";
    }
    
    // Set the Attendance Eligibility buttons to their initial states
    if ([indiv_details.attendance_eligibility isEqualToString:@"Eligible"]) {
        [eligibilityButtons.btn_Eligible setSelected:TRUE];
        label_AttendanceEligibility.text = @"Eligible";
    }
    
    if ([indiv_details.attendance_eligibility isEqualToString:@"Aged Out"]) {
        [eligibilityButtons.btn_AgedOut setSelected:TRUE];
        label_AttendanceEligibility.text = @"Aged Out";
    }
    
    if ([indiv_details.attendance_eligibility isEqualToString:@"Banned"]) {
        [eligibilityButtons.btn_Banned setSelected:TRUE];
        label_AttendanceEligibility.text = @"Banned";
    }
    
    attendanceButtons.myAttendanceStatus = indiv_details.attendance_status;
    eligibilityButtons.myEligibilityStatus = indiv_details.attendance_eligibility;
    
    // Set Profile Image
    UIImage *image = [UIImage imageWithData:myIndivData.profile_Image];
    [profileImageView setImage:image];
    
    // Set User Notes
    textfield_Notes.text = indiv_details.user_notes;
}

- (NSString*)dateToString:(NSDate*)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMMM d, YYYY"];
    
    Individual_Details *indiv_details = myIndivData.details;
    NSString *dateString = [dateFormat stringFromDate:indiv_details.date_of_birth];
    
    return dateString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Date Picking
- (IBAction)setDate:(id)sender {
    // Present the popover from the button that was tapped in the detail view.
    UIButton *tappedButton = (UIButton *)sender;
	[datePickerViewPopover presentPopoverFromRect:tappedButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    
    [datePopoverContent.picker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
}

- (void)dateChanged{
    // Save the new date both locally and to the data store
    NSDate *myDate = datePopoverContent.picker.date;
    date_of_birth = myDate;
    myIndivData.details.date_of_birth = myDate;
    
    // Present the date as a nice readable string
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMMM d, YYYY"];
    NSString *prettyVersion = [dateFormat stringFromDate:myDate];
    
    label_date_of_birth.text = prettyVersion;
}

#pragma mark Image Picking
-(IBAction)changePhoto:(id)sender
{
    UIButton *tappedButton = (UIButton *)sender;
	[imageViewPopover presentPopoverFromRect:tappedButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

#pragma mark -
#pragma mark Popover_ImagePickerDelegate

// as a delegate we are being told a picture was taken
- (void)didTakePicture:(UIImage *)picture
{
    [profileImageView setImage:picture];
}

-(void)didFinishWithCamera
{
    
}


#pragma mark Saving
- (IBAction)save:(id)sender {
    
    // check to see which type of saving we need based on the editmode
    if ([editmode isEqualToString:@"standard"])
    {
        [self saveStandard];
    }else{
        [self saveNew];
    }
}

-(void)saveStandard
{
    // Standard mode save functionality
    
    // Prepare this individual's basic info for saving 
    myIndivData.name_preferred = textfield_name_preferred.text;
    myIndivData.name_first = textfield_name_first.text;
    myIndivData.name_last = textfield_name_last.text;
    
    // Prepare this individual's details for saving 
    Individual_Details *indiv_details = myIndivData.details;
    indiv_details.attendance_eligibility = eligibilityButtons.myEligibilityStatus;
    indiv_details.attendance_status = attendanceButtons.myAttendanceStatus;
    
    // Prepare the profile image for saving
    NSData * imageData = UIImageJPEGRepresentation(profileImageView.image, 100.0);
    myIndivData.profile_Image = imageData;
    
    //Prepare notes for saving
    indiv_details.user_notes = textfield_Notes.text;
    
    // Start saving using the current save context
    [self.managedObjectContext save:nil];
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    // Move back to the main View controller
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) saveNew
{
    // First, check to see the user has entered required bits of data
    BOOL required_data_entered = TRUE;
    required_data_entered = [self checkEntries];
    if(required_data_entered)
    {
        // Required data was filled out, complete the save
        [self complete_new_save];
    }else{
        // Required fields have been left empty, display an alert to the user letting them know
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Did you forget?"
                                                        message:@"Fields have been left blank, please enter information for each text field"
                                                       delegate:nil
                                              cancelButtonTitle:@"Fine, I'll fix it"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(BOOL)checkEntries
{
    BOOL required_data_entered = TRUE;
    
    if([textfield_name_preferred.text isEqualToString:@""])
    {
        required_data_entered = FALSE;
    }
    if([textfield_name_first.text isEqualToString:@""])
    {
        required_data_entered = FALSE;
    }
    if([textfield_name_last.text isEqualToString:@""])
    {
        required_data_entered = FALSE;
    }
    
    return required_data_entered;
}

-(void) complete_new_save
{
    // Use the text values entered by the user to create a NEW individual entry, and save it
    // to the data store.
    
    // If the user has entered acceptable data for all required data fields, we'll commit the new data to the data store
    
    // Find out how many Individuals are currently stored in the Data Store
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Individual" inManagedObjectContext:self.managedObjectContext]];
    
    [request setIncludesSubentities:NO]; //Omit subentities. Default is YES (i.e. include subentities)
    
    NSError *err;
    NSInteger count = [self.managedObjectContext countForFetchRequest:request error:&err];
    
    // Prepare the new data for saving
    Individual *new_indiv = [NSEntityDescription insertNewObjectForEntityForName:@"Individual"inManagedObjectContext:self.managedObjectContext];
    
    // Prepare basic info for saving
    new_indiv.individual_id = [NSNumber numberWithInt:(count + 1)];
    new_indiv.name_preferred = textfield_name_preferred.text;
    new_indiv.name_first = textfield_name_first.text;
    new_indiv.name_last = textfield_name_last.text;
    
    // Prepare the profile image for saving
    NSData * imageData = UIImageJPEGRepresentation(profileImageView.image, 100.0);
    new_indiv.profile_Image = imageData;
    
    
    // Prepare details for saving
    Individual_Details *new_indiv_details = [NSEntityDescription insertNewObjectForEntityForName:@"Individual_Details" inManagedObjectContext:self.managedObjectContext];
    
    new_indiv_details.date_of_birth = date_of_birth;
    new_indiv_details.attendance_status = attendanceButtons.myAttendanceStatus;
    new_indiv_details.attendance_eligibility = eligibilityButtons.myEligibilityStatus;
    new_indiv_details.user_notes = textfield_Notes.text;
    
    new_indiv.details = new_indiv_details;
    
    // Complete the save using our save context
    [self.managedObjectContext save:nil];
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    // Move back to the Master view controller
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)delete_indiv:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Are you sure?"
                          message:@"This action will permanently delete this individual's data"
                          delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Delete it!", nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		NSLog(@"user pressed OK");
        [self completeDelete];
	}
	else {
		NSLog(@"user pressed Cancel");
	}
}

-(void)completeDelete {
    if ([editmode isEqualToString:@"standard"]) 
        [managedObjectContext deleteObject:myIndivData];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
