//
//  TableCell_CafePride_Individual.h
//  CafePride-CheckIn
//
//  Subclass of standard table cell, customized for the specific needs of the Cafe Pride Check-i app.
//  This customized version contains additional properties and methods that help to load and display
//  important data about Cafe Pride attendees from the main table view.
//
//  Created by Bentley Holmes-Gull on 1/1/13.
//  Copyright (c) 2013 Playful Planet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Individual.h"
#import "Event.h"
#import "Btn_Attendance.h"

@interface TableCell_CafePride_Individual : UITableViewCell

// CoreData Objects
@property (strong, nonatomic) Individual* myIndivData;
@property (strong, nonatomic) Event* myEventData;

// Display Properties
@property (strong, nonatomic) Btn_Attendance *myAttendanceButtons;
@property (strong, nonatomic) UIImageView* myProfileImageView;
@property (strong, nonatomic) UILabel *Label_Main;
@property (strong, nonatomic) UILabel *Label_Subtitle;

// Functions for seting the graphics and data for this TableCell
-(void)setProfileImage;
-(void)setLabels;
-(void)setEventDetails;
-(void)setDetailText;
-(void)addButtons:(NSManagedObjectContext*)moc;
-(void)removeButtons;

@end
