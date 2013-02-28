//
//  Btn_Attendance.m
//  CafePride-CheckIn
//
//  Created by Bentley Holmes-Gull on 11/26/12.
//  Copyright (c) 2012 Playful Planet. All rights reserved.
//

#import "Btn_Attendance.h"
#import "Individual_Details.h"

@implementation Btn_Attendance
@synthesize myIndividual;
@synthesize myAttendanceStatus;
@synthesize myEligibilityStatus;
@synthesize attendanceBool;

@synthesize btn_IsPresent;
@synthesize btn_CheckIn;
@synthesize btn_OnBreak;
@synthesize btn_CheckOut;

@synthesize btn_Eligible;
@synthesize btn_AgedOut;
@synthesize btn_Banned;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// addNormalButtons creates and places buttons in the view. The Normal button size is 
// generally used for display in table views
-(void)addNormalButtons
{
    isSimple = NO;
    
    //Create the IsPresent button
    CGRect btnFrame = CGRectMake(0.0, 0.0, 100.0, 100);
    btn_IsPresent = [[UIButton alloc] initWithFrame:btnFrame];
    [self setBtnStyle:btn_IsPresent];
    [btn_IsPresent addTarget:self
                    action:@selector(isPresent:)
          forControlEvents:UIControlEventTouchUpInside];
    
    BOOL t = [myIndividual.isPresent boolValue];
    
    // Check to see if this individual is present, and then set the button graphics and text appropriately
    if (t) {
        attendanceBool = YES;
        [btn_IsPresent setBackgroundImage:[UIImage imageNamed:@"Btn_IsPresent_YES.png"] forState:UIControlStateNormal];
        [btn_IsPresent setBackgroundImage:[UIImage imageNamed:@"Btn_IsPresent_YES-Over.png"] forState:UIControlStateHighlighted];
        [btn_IsPresent setTitle:@"I was \n Here!" forState:normal];
    }else{
        attendanceBool = NO;
        [btn_IsPresent setBackgroundImage:[UIImage imageNamed:@"Btn_IsPresent_NO.png"] forState:UIControlStateNormal];
        [btn_IsPresent setBackgroundImage:[UIImage imageNamed:@"Btn_IsPresent_NO-Over.png"] forState:UIControlStateHighlighted];
        [btn_IsPresent setTitle:@"I'm \n Absent" forState:normal];
    }
    
    //Create the Check IN button
    btnFrame = CGRectMake(110.0, 0.0, 100.0, 100);
    btn_CheckIn = [[UIButton alloc] initWithFrame:btnFrame];
    [self setBtnStyle:btn_CheckIn];
    [btn_CheckIn addTarget:self
                    action:@selector(checkIn:)
          forControlEvents:UIControlEventTouchUpInside];
    
    [btn_CheckIn setBackgroundImage:[UIImage imageNamed:@"Btn_CheckIN.png"] forState:UIControlStateNormal];
    [btn_CheckIn setBackgroundImage:[UIImage imageNamed:@"Btn_CheckIN-Over.png"] forState:UIControlStateHighlighted];
    [btn_CheckIn setBackgroundImage:[UIImage imageNamed:@"Btn_CheckIN-On.png"] forState:UIControlStateSelected];
    
    [btn_CheckIn setTitle:@"Check\nIN" forState:normal];
    
    //Create the on BREAK button
    btnFrame = CGRectMake(220.0, 0, 100.0, 100);
    btn_OnBreak = [[UIButton alloc] initWithFrame:btnFrame];
    [self setBtnStyle:btn_OnBreak];
    [btn_OnBreak addTarget:self
                    action:@selector(goOnBreak:)
          forControlEvents:UIControlEventTouchUpInside];
    
    [btn_OnBreak setBackgroundImage:[UIImage imageNamed:@"Btn_OnBREAK.png"] forState:UIControlStateNormal];
    [btn_OnBreak setBackgroundImage:[UIImage imageNamed:@"Btn_OnBREAK-Over.png"] forState:UIControlStateHighlighted];
    [btn_OnBreak setBackgroundImage:[UIImage imageNamed:@"Btn_OnBREAK-On.png"] forState:UIControlStateSelected];
    [btn_OnBreak setTitle:@"On\nBREAK" forState:normal];
    
    //Create the Check OUT button
    btnFrame = CGRectMake(330.0, 0, 100.0, 100);
    btn_CheckOut = [[UIButton alloc] initWithFrame:btnFrame];
    [self setBtnStyle:btn_CheckOut];
    [btn_CheckOut addTarget:self
                    action:@selector(checkOut:)
          forControlEvents:UIControlEventTouchUpInside];
    
    [btn_CheckOut setBackgroundImage:[UIImage imageNamed:@"Btn_CheckOUT.png"] forState:UIControlStateNormal];
    [btn_CheckOut setBackgroundImage:[UIImage imageNamed:@"Btn_CheckOUT-Over.png"] forState:UIControlStateHighlighted];
    [btn_CheckOut setBackgroundImage:[UIImage imageNamed:@"Btn_CheckOUT-On.png"] forState:UIControlStateSelected];
    [btn_CheckOut setTitle:@"Check\nOUT" forState:normal];
    
    
    // Add these buttons to the view
    [self addSubview:btn_IsPresent];
    [self addSubview:btn_CheckIn];
    [self addSubview:btn_OnBreak];
    [self addSubview:btn_CheckOut];
}

// addEligibiltyButtons creates and places the buttons used to change an individual's attendance
// eligibility
-(void)addEligibilityButtons
{
    //Create the ELIGIBLE button
    CGRect btnFrame = CGRectMake(0.0, 0.0, 105.0, 50.0);
    btn_Eligible = [[UIButton alloc] initWithFrame:btnFrame];
    [self setBtnStyleMini:btn_Eligible];
    
    [btn_Eligible addTarget:self
                     action:@selector(setEligible:)
           forControlEvents:UIControlEventTouchUpInside];
    
    [btn_Eligible setBackgroundImage:[UIImage imageNamed:@"Btn_Mini_CheckIN.png"] forState:UIControlStateNormal];
    [btn_Eligible setBackgroundImage:[UIImage imageNamed:@"Btn_Mini_CheckIN-Over.png"] forState:UIControlStateHighlighted];
    [btn_Eligible setBackgroundImage:[UIImage imageNamed:@"Btn_Mini_CheckIN-On.png"] forState:UIControlStateSelected];
    [btn_Eligible setTitle:@"Eligible" forState:normal];
    
    //Create the AGED OUT button
    btnFrame = CGRectMake(150.0, 0.0, 105.0, 50.0);
    btn_AgedOut = [[UIButton alloc] initWithFrame:btnFrame];
    [self setBtnStyleMini:btn_AgedOut];
    
    [btn_AgedOut addTarget:self
                    action:@selector(setAgedOut:)
          forControlEvents:UIControlEventTouchUpInside];
    
    [btn_AgedOut setBackgroundImage:[UIImage imageNamed:@"Btn_Mini_OnBREAK.png"] forState:UIControlStateNormal];
    [btn_AgedOut setBackgroundImage:[UIImage imageNamed:@"Btn_Mini_OnBREAK-Over.png"] forState:UIControlStateHighlighted];
    [btn_AgedOut setBackgroundImage:[UIImage imageNamed:@"Btn_Mini_OnBREAK-On.png"] forState:UIControlStateSelected];
    [btn_AgedOut setTitle:@"Aged Out" forState:normal];
    
    //Create the BANNED button
    btnFrame = CGRectMake(295.0, 0.0, 105.0, 50.0);
    btn_Banned = [[UIButton alloc] initWithFrame:btnFrame];
    [self setBtnStyleMini:btn_Banned];
    
    [btn_Banned addTarget:self
                   action:@selector(setBanned:)
         forControlEvents:UIControlEventTouchUpInside];
    
    [btn_Banned setBackgroundImage:[UIImage imageNamed:@"Btn_Mini_CheckOUT.png"] forState:UIControlStateNormal];
    [btn_Banned setBackgroundImage:[UIImage imageNamed:@"Btn_Mini_CheckOUT-Over.png"] forState:UIControlStateHighlighted];
    [btn_Banned setBackgroundImage:[UIImage imageNamed:@"Btn_Mini_CheckOUT-On.png"] forState:UIControlStateSelected];
    [btn_Banned setTitle:@"Banned" forState:normal];
    
    
    // Add these buttons to the view
    [self addSubview:btn_Eligible];
    [self addSubview:btn_AgedOut];
    [self addSubview:btn_Banned];
}

// addMiniButtons creates and places a smaller version of the attendance buttons in the view.
// The "mini" versions of the buttons are generally used on detail screens, or as part of
// forms.
-(void)addMiniButtons
{
    isSimple = YES;
    
    //Create the Check IN button
    CGRect btnFrame = CGRectMake(0.0, 0.0, 105.0, 50);
    btn_CheckIn = [[UIButton alloc] initWithFrame:btnFrame];
    [self setBtnStyleMini:btn_CheckIn];
    [btn_CheckIn addTarget:self
                    action:@selector(checkIn:)
          forControlEvents:UIControlEventTouchUpInside];
    
    [btn_CheckIn setBackgroundImage:[UIImage imageNamed:@"Btn_Mini_CheckIN.png"] forState:UIControlStateNormal];
    [btn_CheckIn setBackgroundImage:[UIImage imageNamed:@"Btn_Mini_CheckIN-Over.png"] forState:UIControlStateHighlighted];
    [btn_CheckIn setBackgroundImage:[UIImage imageNamed:@"Btn_Mini_CheckIN-On.png"] forState:UIControlStateSelected];
    [btn_CheckIn setTitle:@"Check IN" forState:normal];
    
    //Create the on BREAK button
    btnFrame = CGRectMake(150.0, 0.0, 105.0, 50);
    btn_OnBreak = [[UIButton alloc] initWithFrame:btnFrame];
    [self setBtnStyleMini:btn_OnBreak];
    
    [btn_OnBreak addTarget:self
                    action:@selector(goOnBreak:)
          forControlEvents:UIControlEventTouchUpInside];
    
    [btn_OnBreak setBackgroundImage:[UIImage imageNamed:@"Btn_Mini_OnBREAK.png"] forState:UIControlStateNormal];
    [btn_OnBreak setBackgroundImage:[UIImage imageNamed:@"Btn_Mini_OnBREAK-Over.png"] forState:UIControlStateHighlighted];
    [btn_OnBreak setBackgroundImage:[UIImage imageNamed:@"Btn_Mini_OnBREAK-On.png"] forState:UIControlStateSelected];
    [btn_OnBreak setTitle:@"On BREAK" forState:normal];
    
    //Create the Check OUT button
    btnFrame = CGRectMake(295.0, 0.0, 105.0, 50);
    btn_CheckOut = [[UIButton alloc] initWithFrame:btnFrame];
    [self setBtnStyleMini:btn_CheckOut];
    
    [btn_CheckOut addTarget:self
                     action:@selector(checkOut:)
           forControlEvents:UIControlEventTouchUpInside];
    
    [btn_CheckOut setBackgroundImage:[UIImage imageNamed:@"Btn_Mini_CheckOUT.png"] forState:UIControlStateNormal];
    [btn_CheckOut setBackgroundImage:[UIImage imageNamed:@"Btn_Mini_CheckOUT-Over.png"] forState:UIControlStateHighlighted];
    [btn_CheckOut setBackgroundImage:[UIImage imageNamed:@"Btn_Mini_CheckOUT-On.png"] forState:UIControlStateSelected];
    [btn_CheckOut setTitle:@"Check OUT" forState:normal];
    
    
    // Add these buttons to the view
    [self addSubview:btn_CheckIn];
    [self addSubview:btn_OnBreak];
    [self addSubview:btn_CheckOut];
}

// Sets the style normally used for the attendance buttons
-(void)setBtnStyle:(UIButton *)btn
{
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    btn.titleLabel.font = [UIFont boldSystemFontOfSize: 18.f];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.numberOfLines = 2;
    btn.titleLabel.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    btn.titleLabel.shadowOffset = CGSizeMake(2.0, 2.0);
}

// Sets the style used for miniature versions of the attendance buttons
-(void)setBtnStyleMini:(UIButton *)btn
{
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 4, 0);
    btn.titleLabel.font = [UIFont boldSystemFontOfSize: 16.f];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    btn.titleLabel.shadowOffset = CGSizeMake(2.0, 2.0);
}

#pragma mark -Methods triggered by attendance buttons
// Checks to see if the individual is present, then adjusts the attendance button's graphics and text
// as needed
-(void)isPresent:(UIButton*)sender
{
    // handle graphics
    if (attendanceBool) {
        [self setPresent:NO];
    }else{
        [self setPresent:YES];
    }
}

-(void)setPresent: (BOOL)isPresent
{
    if(isPresent){
        myIndividual.isPresent = [NSNumber numberWithBool:YES];
        
        [btn_IsPresent setBackgroundImage:[UIImage imageNamed:@"Btn_IsPresent_YES.png"] forState:UIControlStateNormal];
        
        [btn_IsPresent setTitle:@"I was \n Here!" forState:normal];
        [self setPresence:YES];
    }else{
        myIndividual.isPresent = [NSNumber numberWithBool:NO];
        
        [btn_IsPresent setBackgroundImage:[UIImage imageNamed:@"Btn_IsPresent_NO.png"] forState:UIControlStateNormal];
        [btn_IsPresent setBackgroundImage:[UIImage imageNamed:@"Btn_IsPresent_NO-Over.png"] forState:UIControlStateHighlighted];
        
        [btn_IsPresent setTitle:@"I'm \n Absent" forState:normal];
        [self setPresence:NO];
    }
}

// Triggered by tapping CHECK IN button: Sets the individual's attendance status as checked-in, and
// updates button graphics and text as needed
-(void)checkIn:(UIButton*)sender
{
    [self setAttendanceStatus:@"Checked-In"];
    //[self setPresent:YES];
    
    // handle graphics
    [sender setSelected:TRUE];
    [btn_OnBreak setSelected:FALSE];
    [btn_CheckOut setSelected:FALSE];
}

// Triggered by tapping ON BREAK button: Sets the individual's attendance status as on-break, and
// updates button graphics and text as needed
-(void)goOnBreak:(UIButton*)sender
{
    [self setAttendanceStatus:@"On-Break"];
    
    [sender setSelected:TRUE];
    [btn_CheckIn setSelected:FALSE];
    [btn_CheckOut setSelected:FALSE];
    
}

// Triggered by tapping CHECK OUT button: Sets the individual's attendance status as check-out, and
// updates button graphics and text as needed
-(void)checkOut:(UIButton*)sender
{
    [self setAttendanceStatus:@"Checked-Out"];
    
    [sender setSelected:TRUE];
    [btn_CheckIn setSelected:FALSE];
    [btn_OnBreak setSelected:FALSE];
}

// Triggered by tapping the ELIGIBLE button: Sets the individual's attendance status as "eligible", and
// updates button graphics and text as needed
-(void)setEligible:(UIButton*)sender
{
    [self setAttendanceEligibility:@"Eligible"];
    
    // handle graphics
    [sender setSelected:TRUE];
    [btn_AgedOut setSelected:FALSE];
    [btn_Banned setSelected:FALSE];
}

// Triggered by tapping the AGED OUT button: Sets the individual's attendance status as "Aged Out", and
// updates button graphics and text as needed
-(void)setAgedOut:(UIButton*)sender
{
    [self setAttendanceEligibility:@"Aged Out"];
    
    // handle graphics
    [sender setSelected:TRUE];
    [btn_Eligible setSelected:FALSE];
    [btn_Banned setSelected:FALSE];
}

// Triggered by tapping the BANNED button: Sets the individual's attendance status as "Banned", and
// updates button graphics and text as needed
-(void)setBanned:(UIButton*)sender
{
    [self setAttendanceEligibility:@"Banned"];
    
    // handle graphics
    [sender setSelected:TRUE];
    [btn_Eligible setSelected:FALSE];
    [btn_AgedOut setSelected:FALSE];
}

-(void)setAttendanceEligibility:(NSString*)a_eligibility
{
    // Set the new eligibility status on the data entity
    myIndividual.attendance_eligibility = a_eligibility;
    
    // Set the new eligibility status locally
    myEligibilityStatus = a_eligibility;
    
    // Save the new data to the save context
    [self.managedObjectContext save:nil];
}

-(void)setAttendanceStatus:(NSString*)a_status
{
    // Set the new attendance status on the data entity
    myIndividual.attendance_status = a_status;
    
    // Set the new attendance status locally
    myAttendanceStatus = a_status;
    
    // Save the new data to the save context
    [self.managedObjectContext save:nil];
}

-(void)setPresence:(BOOL)presence
{
     myIndividual.isPresent = [NSNumber numberWithBool:presence];
     attendanceBool = presence;
    // Save the new data to the save context
    [self.managedObjectContext save:nil];
}

@end
