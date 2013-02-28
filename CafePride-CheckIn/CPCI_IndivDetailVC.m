//
//  CPCI_IndivDetailVC.m
//  CafePride-CheckIn
//
//  Created by Bentley Holmes-Gull on 1/24/13.
//  Copyright (c) 2013 Playful Planet. All rights reserved.
//

#import "CPCI_IndivDetailVC.h"
#import "CPCI_MainIndivList.h"
#import "Individual.h"
#import "Btn_Attendance.h"
#import "Popover_DatePicker.h"
#import "Popover_ImagePicker.h"

@interface CPCI_IndivDetailVC ()

@end

@implementation CPCI_IndivDetailVC
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -View Initialization
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Initialize Booleans
    viewPopped = NO;
    
    //Set up the buttons used to set attendance eligibility
    
    CGRect btnFrame = CGRectMake(20.0, 570.0, 400.0, 50);
    eligibilityButtons = [[Btn_Attendance alloc] initWithFrame:btnFrame];
    [eligibilityButtons addEligibilityButtons];
    eligibilityButtons.managedObjectContext = self.managedObjectContext;
    [self.view addSubview:eligibilityButtons];
    
    // Set up the actions that will be triggered when eligibility buttons are tapped
    [eligibilityButtons.btn_Eligible addTarget:self
                                        action:@selector(setLabelText:)
                              forControlEvents:UIControlEventTouchUpInside];
    [eligibilityButtons.btn_AgedOut addTarget:self
                                       action:@selector(setLabelText:)
                             forControlEvents:UIControlEventTouchUpInside];
    [eligibilityButtons.btn_Banned addTarget:self
                                      action:@selector(setLabelText:)
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
    
    [datePopoverContent.Btn_Done addTarget:self action:@selector(dateDone:) forControlEvents:UIControlEventTouchUpInside];
    
    // Prepare the popover that the Image Picker uses
    imagePopoverContent = [[Popover_ImagePicker alloc] init];
    imagePopoverContent.delegate = self;
    
    // Prepare the popover that the ImagePicker uses
    self.imageViewPopover = [[UIPopoverController alloc] initWithContentViewController:imagePopoverContent];
	self.imageViewPopover.popoverContentSize = CGSizeMake(320.0, 320.0);
    self.imageViewPopover.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    // Before the view disappears, we'll save any changes that have been made to the individual
    // details if in standard mode
    if ([editmode isEqualToString:@"standard"]) {
        viewPopped = YES;
        [self saveStandard];
    }
}

// Loads the "Add New" edit mode.
//
// In the "Add New" edit mode users enter the starting data needed for adding a
// new individual to the data store
-(void)load_AddNewMode
{
    // set the save buttons title
    btn_Save.title = @"Add";
    
    // Set the Attendance eligibility buttons and fields to their initial states
    label_date_of_birth.text = @"Please enter a Date of Birth";
    eligibilityButtons.myEligibilityStatus = @"Eligible";
    label_AttendanceEligibility.text = @"Eligible";
}

// Loads the "Standard" edit mode.
//
// In the standard edit mode users can edit data about a specific individual in
// the data store
- (void) load_StandardMode
{    
    // set the save buttons title
    btn_Save.title = @"Save";
    
    // Populate basic info fields    
    textfield_name_preferred.text = myIndivData.name_preferred;
    textfield_name_first.text = myIndivData.name_first;
    textfield_name_last.text = myIndivData.name_last;
    
    // format the date for string output
    NSString *datestring = [self dateToString:myIndivData.date_of_birth];
    label_date_of_birth.text = datestring;

    // Set the Attendance Eligibility buttons to their initial states
    if ([myIndivData.attendance_eligibility isEqualToString:@"Eligible"]) {
        [eligibilityButtons.btn_Eligible setSelected:TRUE];
        label_AttendanceEligibility.text = @"Eligible";
    }
    
    if ([myIndivData.attendance_eligibility isEqualToString:@"Aged Out"]) {
        [eligibilityButtons.btn_AgedOut setSelected:TRUE];
        label_AttendanceEligibility.text = @"Aged Out";
    }
    
    if ([myIndivData.attendance_eligibility isEqualToString:@"Banned"]) {
        [eligibilityButtons.btn_Banned setSelected:TRUE];
        label_AttendanceEligibility.text = @"Banned";
    }
    
    // Pass the attendance status and eligibility to their respective button classes
    eligibilityButtons.myEligibilityStatus = myIndivData.attendance_eligibility;
    
    // Set Profile Image
    UIImage *image = [UIImage imageWithData:myIndivData.profile_image];
    [profileImageView setImage:image];
    
    // Set User Notes
    textfield_Notes.text = myIndivData.user_notes;
}

#pragma mark -Data management methods
// Updates labels after changes to attendance statuses have been made
-(void)setLabelText:(UIButton*) sender
{
    label_AttendanceEligibility.text = eligibilityButtons.myEligibilityStatus;
}

// Takes a NSdate object and converts it into a nice string for display
- (NSString*)dateToString:(NSDate*)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMMM d, YYYY"];
    
    NSString *dateString = [dateFormat stringFromDate:date];
    
    return dateString;
}

#pragma mark Date Picking
// setDate is called when the user taps the "Set Date" button, and presents the date picker popover
- (IBAction)setDate:(id)sender
{
    // Present the popover from the button that was tapped in the detail view.
    UIButton *tappedButton = (UIButton *)sender;
	[datePickerViewPopover presentPopoverFromRect:tappedButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    
    // Set up the an action to be called when the date has changed
    [datePopoverContent.picker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
}

// Called when the done button is tapped from the Date Picker Popover. Removes the popover
-(IBAction)dateDone:(id)sender
{
    [datePickerViewPopover dismissPopoverAnimated:YES];
}

// Called when the date has been changed, and saves the new date to a local variable, and through CoreData
- (void)dateChanged
{
    // Save the new date both locally and to the data store
    NSDate *myDate = datePopoverContent.picker.date;
    date_of_birth = myDate;
    myIndivData.date_of_birth = myDate;
    NSLog(@"Real date: %@", myDate);
    
    // Present the date as a nice readable string
    NSString *prettyVersion = [self dateToString:myDate];
    NSLog(@"Pretty date: %@", prettyVersion);
    label_date_of_birth.text = prettyVersion;
}

#pragma mark Image Picking
// Called when the user taps the "Change Photo" button
-(IBAction)changePhoto:(id)sender
{
    UIButton *tappedButton = (UIButton *)sender;
	[imageViewPopover presentPopoverFromRect:tappedButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

// as a delegate we are being told a picture was taken
- (void)didTakePicture:(UIImage *)picture
{
    [profileImageView setImage:picture];
}

-(void)didFinishWithCamera
{
    [imageViewPopover dismissPopoverAnimated:YES];
}


#pragma mark Saving
// Triggered when the user taps the save button
- (IBAction)save:(id)sender
{
    
    // check to see which type of saving we need based on the editmode
    if ([editmode isEqualToString:@"standard"])
    {
        [self saveStandard];
    }else{
        [self saveNew];
    }
}

// Standard mode save functionality
-(void)saveStandard
{
    // Prepare this individual's basic info for saving
    myIndivData.name_preferred = textfield_name_preferred.text;
    myIndivData.name_first = textfield_name_first.text;
    myIndivData.name_last = textfield_name_last.text;
    
    // Prepare this individual's details for saving
    myIndivData.attendance_eligibility = eligibilityButtons.myEligibilityStatus;
    
    // Prepare the profile image for saving
    NSData * imageData = UIImageJPEGRepresentation(profileImageView.image, 100.0);
    myIndivData.profile_image = imageData;
    
    //Prepare notes for saving
    myIndivData.user_notes = textfield_Notes.text;
    
    // Start saving using the current save context
    [self.managedObjectContext save:nil];
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    // Move back to the main View controller
    if (!viewPopped) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// Save functionality for a new Individual
-(void) saveNew
{
    // First, check to see the user has entered all the required bits of data
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

// Checks required fields for valid entries
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

// Completes the save of a new individual after it's passes a validity check
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
    new_indiv.profile_image = imageData;
    
    // Prepare details for saving
    new_indiv.date_of_birth = date_of_birth;
    new_indiv.attendance_eligibility = eligibilityButtons.myEligibilityStatus;
    new_indiv.user_notes = textfield_Notes.text;
    
    // Complete the save using our save context
    [self.managedObjectContext save:nil];
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    // Move back to the Master view controller
    [self.navigationController popViewControllerAnimated:YES];
}

// Triggered upon pushing the "Delete Individual" button. Launches a confirmation dialog requiring
// the user to confirm their choice to delete the individual
- (IBAction)delete_indiv:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Are you sure?"
                          message:@"This action will permanently delete this individual's data"
                          delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Delete it!", nil];
    
    [alert show];
}

// The alert view that comes up when attempting to deleting an individual
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1) {
        [self completeDelete];
	}
}

// This function finalizes the deletion of an individual, then returns the user to the main indiv list
-(void)completeDelete
{
    if ([editmode isEqualToString:@"standard"])
        [managedObjectContext deleteObject:myIndivData];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
