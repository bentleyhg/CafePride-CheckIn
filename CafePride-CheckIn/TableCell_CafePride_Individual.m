//
//  TableCell_CafePride_Individual.m
//  CafePride-CheckIn
//
//  Subclass of standard table cell, customized for the specific needs of the Cafe Pride Check-i app.
//  This customized version contains additional properties and methods that help to load and display
//  important data about Cafe Pride attendees from the main table view.
//
//  Created by Bentley Holmes-Gull on 1/1/13.
//  Copyright (c) 2013 Playful Planet. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TableCell_CafePride_Individual.h"
#import "Individual.h"
#import "Event.h"
#import "Btn_Attendance.h"

@implementation TableCell_CafePride_Individual
@synthesize myAttendanceButtons;
@synthesize myProfileImageView;
@synthesize myIndivData;
@synthesize myEventData;
@synthesize Label_Main;
@synthesize Label_Subtitle;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    
    return self;
}

// Creates a 75 x 75 image view for displaying thumbnail view of an individual's profile pic
// in the table cell.
-(void)setProfileImage
{
    BOOL addImage = NO;
    
    // Position values for Profile Image
    NSInteger x_pos = 5.0;
    NSInteger y_pos = 20.0;
    NSInteger imageWidth = 75.0;
    NSInteger imageHeight = 75.0;
    
    CGRect imageFrame = CGRectMake(x_pos, y_pos, imageWidth, imageHeight);
    
    // Check to see if the Profile image already exists, we don't want to add the image again if
    // it is already there
    if (myProfileImageView == nil) {
        addImage = YES;
        myProfileImageView = [[UIImageView alloc] initWithFrame:imageFrame];
    }
    
    // Create an image using the stored image data for this individual
    UIImage *image = [UIImage imageWithData:myIndivData.profile_image];
    [myProfileImageView setImage:image];
    
    // Code for putting rounded corners on the Thumbnail Image
    CALayer* imageLayer = [myProfileImageView layer];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setCornerRadius:7.0];
    
    // Add the image view to the cell as a subview if needed
    if (addImage) {
        [self addSubview:myProfileImageView];
    }
}

- (void)setLabels
{
    BOOL add_text = NO;
    
    // If the main label has not been created yet, initialize it and assign text styles here
    // Position values for Main Label Text
    NSInteger x_pos = 100.0;
    NSInteger y_pos = 30.0;
    NSInteger textWidth = 270.0;
    NSInteger textHeight = 22.0;
    
    CGRect prefFrame = CGRectMake(x_pos, y_pos, textWidth, textHeight);
    if (Label_Main == nil){
        add_text = YES;
        Label_Main = [[UILabel alloc] initWithFrame:prefFrame];
        Label_Main.font = [UIFont boldSystemFontOfSize: 18.f];
        Label_Main.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
        Label_Main.textColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1.0];
        Label_Main.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        Label_Main.shadowOffset = CGSizeMake(2.0, 2.0);
    }
    
    // If the subtitle label has not been created yet, initialize it and assign text styles here
    // Position values for Subtitle label Text
    x_pos = 100.0;
    y_pos = 55.0;
    textWidth = 270.0;
    textHeight = 22.0;
    
    CGRect givenFrame = CGRectMake(x_pos, y_pos, textWidth, textHeight);
    if (Label_Subtitle == nil) {
        add_text = YES;
        Label_Subtitle = [[UILabel alloc] initWithFrame:givenFrame];
        Label_Subtitle.font = [UIFont italicSystemFontOfSize:16.f];
        Label_Subtitle.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
        Label_Subtitle.textColor = [UIColor colorWithRed:100.0 green:100.0 blue:100.0 alpha:1.0];
    }
    
    // Add the image view to the cell as a subview if needed
    if (add_text) {
        [self addSubview:Label_Main];
        [self addSubview:Label_Subtitle];
    }
}

// Takes data from the Event object and then uses that to create and display the event details
-(void)setEventDetails
{
    
    // Set the format the date will be displayed in and use that to create an easy to read string
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMMM d, YYYY"];
    NSString *prettyDate = [dateFormat stringFromDate:myEventData.date];
    
    // Set the text using the event date
    Label_Main.text = prettyDate;
    
    // Set the text using the number of attendees
    Label_Subtitle.text = [NSString stringWithFormat:@" Number of Attendees: %@", myEventData.numAttendees];
}

// Takes data from the Individual object and then uses that to create and display the individual's details
-(void)setDetailText
{
    Label_Main.text = myIndivData.name_preferred;
    Label_Subtitle.text = [NSString stringWithFormat:@"%@ , %@", myIndivData.name_last, myIndivData.name_first];
}

// Sets up the buttons used to set the attendance data for individuals
-(void)addButtons:(NSManagedObjectContext*) moc
{
    BOOL addButtons = NO;

    // Position values for Attendance Buttons
    NSInteger x_pos = 300.0;
    NSInteger y_pos = 0.0;
    NSInteger ButtonsWidth = 444.0;
    NSInteger ButtonsHeight = 100.0;
    
    // Create button object and set starting values
    CGRect btnFrame = CGRectMake(x_pos, y_pos, ButtonsWidth, ButtonsHeight);
    if (myAttendanceButtons == nil) {
        addButtons = YES;
        myAttendanceButtons = [[Btn_Attendance alloc] initWithFrame:btnFrame];
        myAttendanceButtons.managedObjectContext = moc;
        myAttendanceButtons.myIndividual = myIndivData;
        [myAttendanceButtons addNormalButtons];
    }
    
    // Set target functons for each button
    [myAttendanceButtons.btn_CheckIn addTarget:self
                           action:@selector(checkIn:)
                 forControlEvents:UIControlEventTouchUpInside];
    [myAttendanceButtons.btn_OnBreak addTarget:self
                           action:@selector(goOnBreak:)
                 forControlEvents:UIControlEventTouchUpInside];
    [myAttendanceButtons.btn_CheckOut addTarget:self
                           action:@selector(checkOut:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    // Set the appropriate starting graphic based on the Indivudual's attendance status
    if ([myIndivData.attendance_status isEqualToString:@"Checked-In"]) {
        // Individual is Checked-In
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RowBG_CheckedIN.png"]];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RowBG_CheckedIN-Over.png"]];
        
        [myAttendanceButtons.btn_CheckIn setSelected:TRUE];
    }
    
    if ([myIndivData.attendance_status isEqualToString:@"On-Break"]) {
        // Individual is On-Break
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RowBG_OnBREAK.png"]];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RowBG_OnBREAK-Over.png"]];
        [myAttendanceButtons.btn_OnBreak setSelected:TRUE];
    }
    
    if ([myIndivData.attendance_status isEqualToString:@"Checked-Out"]) {
        // Individual is Checked-Out
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RowBG_CheckedOUT.png"]];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RowBG_CheckedOUT-Over.png"]];
        [myAttendanceButtons.btn_CheckOut setSelected:TRUE];
    }
    
    // Add the Attendence Button view to the cell as a subview
    if (addButtons) {
        [self addSubview:myAttendanceButtons];
    }
}

// Cleanup function that removes attendance buttons if needed
-(void)removeButtons
{
    [myAttendanceButtons removeFromSuperview];
    myAttendanceButtons = nil;
}

// Local functionality for buttons, updates graphics to reflect an Individual's new
// attendance status
-(void)checkIn:(UIButton*)sender
{
    UIImageView *newBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RowBG_CheckedIN.png"]];
    [self setBackgroundView:newBG];
}

-(void)goOnBreak:(UIButton*)sender
{
    UIImageView *newBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RowBG_OnBREAK.png"]];
    [self setBackgroundView:newBG];
}

-(void)checkOut:(UIButton*)sender
{
    UIImageView *newBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RowBG_CheckedOUT.png"]];
    [self setBackgroundView:newBG];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
