//
//  Btn_Attendance.h
//  CafePride-CheckIn
//
//  Created by Bentley Holmes-Gull on 11/26/12.
//  Copyright (c) 2012 Playful Planet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Individual.h"

@interface Btn_Attendance : UIView
{
    BOOL isSimple;
}

// Properties required for saving data to the data store
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic) Individual* myIndividual;

// Button Properties
@property (strong, nonatomic) UIButton* btn_IsPresent;
@property (strong, nonatomic) UIButton* btn_CheckIn;
@property (strong, nonatomic) UIButton* btn_OnBreak;
@property (strong, nonatomic) UIButton* btn_CheckOut;

@property (strong, nonatomic) UIButton* btn_Eligible;
@property (strong, nonatomic) UIButton* btn_AgedOut;
@property (strong, nonatomic) UIButton* btn_Banned;

// Attendance status Properties
@property (strong, nonatomic) NSString* myAttendanceStatus;
@property (strong, nonatomic) NSString* myEligibilityStatus;

@property (nonatomic) BOOL attendanceBool;

// Methods for preparing the button views
-(void)addNormalButtons;
-(void)addEligibilityButtons;
-(void)addMiniButtons;

// Methods for setting and saving the attendance status
-(void)isPresent:(UIButton*)sender;
-(void)checkIn:(UIButton*)sender;
-(void)goOnBreak:(UIButton*)sender;
-(void)checkOut:(UIButton*)sender;

// Methods for setting and saving the eligibility status
-(void)setEligible:(UIButton*)sender;
-(void)setAgedOut:(UIButton*)sender;
-(void)setBanned:(UIButton*)sender;


@end
