//
//  Individual.h
//  CafePride-CheckIn
//
//  Created by Bentley Holmes-Gull on 1/28/13.
//  Copyright (c) 2013 Playful Planet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Individual : NSManagedObject

@property (nonatomic, retain) NSString * attendance_eligibility;
@property (nonatomic, retain) NSString * attendance_status;
@property (nonatomic, retain) NSDate * date_of_birth;
@property (nonatomic, retain) NSNumber * individual_id;
@property (nonatomic, retain) NSNumber * isPresent;
@property (nonatomic, retain) NSString * name_first;
@property (nonatomic, retain) NSString * name_last;
@property (nonatomic, retain) NSString * name_preferred;
@property (nonatomic, retain) NSData * profile_image;
@property (nonatomic, retain) NSString * user_notes;

@end
