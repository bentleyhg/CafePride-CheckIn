//
//  Individual_Details.h
//  CafePride-CheckIn
//
//  Created by Bentley Holmes-Gull on 11/12/12.
//  Copyright (c) 2012 Playful Planet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Individual;

@interface Individual_Details : NSManagedObject

@property (nonatomic, retain) NSDate * date_of_birth;
@property (nonatomic, retain) NSString * attendance_status;
@property (nonatomic, retain) NSString * attendance_eligibility;
@property (nonatomic, retain) NSString * user_notes;
@property (nonatomic, retain) Individual *info;
@property (nonatomic) Boolean isPresent;

@end
