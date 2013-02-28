//
//  CPCI_EventDetailVC.h
//  CafePride-CheckIn
//
//  Created by Bentley Holmes-Gull on 1/24/13.
//  Copyright (c) 2013 Playful Planet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "Individual.h"
#import "Popover_DatePicker.h"

@interface CPCI_EventDetailVC : UITableViewController <UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UIAlertViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>
{
    Individual* detail_IndividualData;
    NSUInteger* numSections;
    
    BOOL eventActive;
    BOOL viewPopped;
    
    // Arrays used by Search Controller
    NSMutableArray* filteredList;
    NSMutableArray* listContent;
    
    // The saved state of the search UI if a memory warning removed the view.
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
}

// Context required for saving and fetching data
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

// Values required to setup the detail view
@property (strong, nonatomic) Event *myEventData;
@property (strong, nonatomic) NSIndexPath *myIndexpath;
@property (strong, nonatomic) NSString *editmode;

// Event Dateproperties
@property (strong, nonatomic) IBOutlet UILabel *label_EventDate;
@property (strong, nonatomic) NSDate* eventDate;

// Date Picker Popover properties
@property (nonatomic, strong) UIPopoverController *datePickerViewPopover;
@property (nonatomic, strong) Popover_DatePicker *datePopoverContent;

//Attendee label and text properties
@property (strong, nonatomic) IBOutlet UITextField *textfield_Attendees;

// Properties for the individual data arrays
@property (nonatomic, strong) NSMutableArray *individualInfos;

// Properties for Search Bar functions
@property (nonatomic, retain) NSMutableArray *filteredList;
@property (nonatomic, retain) NSMutableArray *listContent;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

// Properties attached to buttons
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btn_Save;
@property (strong, nonatomic) IBOutlet UIButton *Btn_EventStatus;

// Methods triggered by buttons
- (IBAction)save:(id)sender;
- (IBAction)changeEventStatus:(id)sender;
- (IBAction)deleteEvent:(id)sender;

@end
