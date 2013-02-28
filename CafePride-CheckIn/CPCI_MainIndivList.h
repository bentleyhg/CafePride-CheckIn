//
//  CPCI_MainIndivList.h
//  CafePride-CheckIn
//
//  Created by Bentley Holmes-Gull on 1/24/13.
//  Copyright (c) 2013 Playful Planet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Individual.h"

@interface CPCI_MainIndivList : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>
{
    
    Individual* detail_IndividualData;
    BOOL adding_new;                    
    
    // Lists used by the search controller
    NSMutableArray* filteredList;       
    NSMutableArray* listContent;
    
    // The saved state of the search UI if a memory warning removed the view.
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
    
}

// Properties used for loading and displaying CoreData objects
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSArray *individualInfos;

// Properties for Search Bar functions
@property (nonatomic, retain) NSMutableArray *filteredList;
@property (nonatomic, retain) NSMutableArray *listContent;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

- (IBAction)addNew:(id)sender;

@end