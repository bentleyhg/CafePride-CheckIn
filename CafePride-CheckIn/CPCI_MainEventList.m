//
//  CPCI_MainEventList.m
//  CafePride-CheckIn
//
//  Created by Bentley Holmes-Gull on 1/24/13.
//  Copyright (c) 2013 Playful Planet. All rights reserved.
//

#import "CPCI_MainEventList.h"
#import "CPCI_EventDetailVC.h"
#import "Event.h"
#import "TableCell_CafePride_Individual.h"

@interface CPCI_MainEventList ()

@end

@implementation CPCI_MainEventList
@synthesize managedObjectContext;
@synthesize eventArray;
@synthesize savedScopeButtonIndex;
@synthesize savedSearchTerm;
@synthesize searchWasActive;
@synthesize filteredList;
@synthesize listContent;

#pragma mark Initialization
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Fetch stored data for individuals registered for Cafe Pride
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
    
    [fetchRequest setEntity:entity];
    NSError *error;
    self.eventArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // create a filtered list that will contain products for the search results table.
	filteredList = [NSMutableArray arrayWithCapacity:[self.eventArray count]];
    
    // restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    // Update the Event array with any new Data Entities
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Event" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.eventArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
	 If the requesting table view is the search display controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
	 */
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredList count];
    }
	else
	{
        return [self.eventArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event *thisEvent = nil;
    
    static NSString *kCellID = @"cellID";
	TableCell_CafePride_Individual *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    if (cell == nil)
	{
		cell = [[TableCell_CafePride_Individual alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        tableView.backgroundColor = [UIColor blackColor];
        tableView.rowHeight = 100;
        if ([filteredList count] > 0) {
            if (indexPath.row + 1 <= [filteredList count]) {
                thisEvent = [filteredList objectAtIndex:indexPath.row];
            }
        }
    }else{
        thisEvent = [eventArray objectAtIndex:indexPath.row];
    }
    
    // Pass the selected evet's data to the cell
    cell.myEventData = thisEvent;
    
    // Set up the cell with a title and subtitle using the Event data fetched earlier...
    [cell setLabels];
    [cell setEventDetails];
    
    // Set the graphics for this cell
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RowBG_Green.png"]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RowBG_Green-Over.png"]];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Prepare the individual data associated with the selected row
    if (tableView == self.searchDisplayController.searchResultsTableView){
        event = [filteredList objectAtIndex:indexPath.row];
    }else{
        event = [eventArray objectAtIndex:indexPath.row];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"toEventDetail" sender: self];
}

// This will get called too before the view appears
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toEventDetail"]) {
        
        // Get destination view
        CPCI_EventDetailVC *vc = [segue destinationViewController];
        
        // Set needed values for the Detail view before loading
        vc.myEventData = event;
        vc.managedObjectContext = self.managedObjectContext;
        
        // Determine if we are adding a new individual, so we can load the proper edit mode
        if (adding_new) {
            vc.editmode = @"addnew";
            adding_new = false;
        }else{
            vc.editmode = @"standard";
        }
    }
}

- (IBAction)addNewEvent:(id)sender
{
    // Triggered when the "Add New Individual" Button is pressed. Triggers a move to the detail
    // view with blank data fields
    adding_new = true;
    [self performSegueWithIdentifier:@"toEventDetail" sender: self];
}

@end
