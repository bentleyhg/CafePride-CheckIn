//
//  CPCI_MainEventList.h
//  CafePride-CheckIn
//
//  Created by Bentley Holmes-Gull on 1/24/13.
//  Copyright (c) 2013 Playful Planet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface CPCI_MainEventList : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>
{
    Event* event;
    BOOL adding_new;
    
    // Search list arrays
    NSMutableArray* filteredList;
    NSMutableArray* listContent;
    
    // The saved state of the search UI if a memory warning removed the view.
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
}

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSArray *eventArray;

// Properties for Search Bar functions
@property (nonatomic, retain) NSMutableArray *filteredList;
@property (nonatomic, retain) NSMutableArray *listContent;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

- (IBAction)addNewEvent:(id)sender;

@end