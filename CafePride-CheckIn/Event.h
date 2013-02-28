//
//  Event.h
//  CafePride-CheckIn
//
//  Created by Bentley Holmes-Gull on 1/27/13.
//  Copyright (c) 2013 Playful Planet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSData * attendees;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * numAttendees;

@end
