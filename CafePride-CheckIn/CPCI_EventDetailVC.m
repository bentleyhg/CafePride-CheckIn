//
//  CPCI_EventDetailVC.m
//  CafePride-CheckIn
//
//  Created by Bentley Holmes-Gull on 1/24/13.
//  Copyright (c) 2013 Playful Planet. All rights reserved.
//

#import "CPCI_EventDetailVC.h"
#import "CPCI_IndivDetailVC.h"
#import "Individual.h"
#import "TableCell_CafePride_Individual.h"

@interface CPCI_EventDetailVC ()

@end

@implementation CPCI_EventDetailVC
// Values required to setup the detail view
@synthesize myEventData;
@synthesize editmode;
@synthesize searchWasActive;
@synthesize listContent;
@synthesize filteredList;
@synthesize savedSearchTerm;
@synthesize savedScopeButtonIndex;
@synthesize individualInfos;

// Navigation Bar Buttons
@synthesize btn_Save;
@synthesize Btn_EventStatus;

// Text Fields and buttons set via Storyboard
// Name related properties
@synthesize textfield_Attendees;

// Date of Birth properties
@synthesize label_EventDate;
@synthesize eventDate;
@synthesize datePickerViewPopover;
@synthesize datePopoverContent;

// Context required for saving and fetching data
@synthesize managedObjectContext;

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
	// Do any additional setup after loading the view.
    
    // Initialize section number and booleans
    numSections = 1;
    viewPopped = NO;
    
    // Fetch stored data for individuals registered for Cafe Pride
    
    // Use all of the individuals if this is a new event, setting them as "Checked Out"
    if ([editmode isEqualToString:@"addnew"])
    {
        // This is a new Event
        
        //Intialize the counter and the label counter's textfield display
        NSString * counterText = [NSString stringWithFormat:@"%d", 0];
        textfield_Attendees.text = counterText;
        
        //Initialize the date, and the date label using the current date
        NSDate *currentDate = [NSDate date];
        eventDate = currentDate;
        
        // Present the date as a nice readable string
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateStyle:NSDateFormatterShortStyle];
        NSString *prettyVersion = [dateFormat stringFromDate:currentDate];
        label_EventDate.text = prettyVersion;
        
        // Fetch stored data for all individuals registered for Cafe Pride
        self.individualInfos = [NSMutableArray arrayWithArray:[self loadAllIndividuals]];
        
        // Initialize the event as ACTIVE
        eventActive = YES;
        [Btn_EventStatus setBackgroundImage:[UIImage imageNamed:@"Btn_EventActive.png"] forState:normal];
        [Btn_EventStatus setTitle:@"Event is Open \n (tap to close)" forState:normal];
        
        
        // Go through the list of individuals and initialize their attendance status, setting
        // each individual's status to Checked-Out, and Absent
        for (NSInteger i = 0; i < [self.individualInfos count]; i++)
        {
            Individual *newIndiv;
            newIndiv = [self.individualInfos objectAtIndex:i];
            newIndiv.attendance_status = @"Checked-Out";
            newIndiv.isPresent = [NSNumber numberWithBool:NO];
        }
    }
    else
    {
        // We are accessing a saved event
        
        // Use event data to populate textfields and labels for the date and the counter
        textfield_Attendees.text = [NSString stringWithFormat:@"%@", myEventData.numAttendees];
        eventDate = myEventData.date;
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateStyle:NSDateFormatterShortStyle];
        NSString *prettyVersion = [dateFormat stringFromDate:myEventData.date];
        label_EventDate.text = prettyVersion;
        
        // create an array containing all of the individuals in the store
        NSArray * allIndivs = [self loadAllIndividuals];
        
        // Check to see if the event is open or closed
        eventActive = [myEventData.isActive boolValue];
        if (eventActive) {
            // The event is active, load the full list of individuals with attendance buttons
            [Btn_EventStatus setTitle:@"Event is Open \n (tap to close)" forState:normal];
            self.individualInfos = [NSArray arrayWithArray:allIndivs];
        }else{
            // The event is closed, we should only load the individuals who were saved as present
            [Btn_EventStatus setTitle:@"Event is Closed \n (tap to open)" forState:normal];
            NSArray *savedIndivs = [self loadSavedIndividuals];
            self.individualInfos = [NSArray arrayWithArray:savedIndivs];
        }
    }
    
    // Prepare the popover that the Date Picker uses
    datePopoverContent= [[Popover_DatePicker alloc] init];
	
	// Setup the popover for use by the datePicker view.
	self.datePickerViewPopover = [[UIPopoverController alloc] initWithContentViewController:datePopoverContent];
	self.datePickerViewPopover.popoverContentSize = CGSizeMake(320.0, 320.0);
    self.datePickerViewPopover.delegate = self;
    
    // create a filtered list that will contain products for the search results table.
	filteredList = [NSMutableArray arrayWithCapacity:[self.individualInfos count]];
    
    // restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
}

// Helper function that fetches all of the individuals from the CoreData store, and returns them as an
// array
-(NSArray*)loadAllIndividuals
{
    // Fetch stored data for individuals registered for Cafe Pride
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Individual" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *indivs = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return indivs;
}

// Helper function that only fetches individuals who were previously saved as present for this event
-(NSArray*)loadSavedIndividuals
{
    NSArray * allIndivs = [self loadAllIndividuals];
    NSMutableArray *savedIndivs = [NSKeyedUnarchiver unarchiveObjectWithData:myEventData.attendees];
    NSMutableArray * newArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [allIndivs count]; i++) {
        // Look through the entire list of individuals
        Individual * thisIndiv = [allIndivs objectAtIndex:i];
        NSString *thisName = thisIndiv.name_preferred;
        for (int j = 0; j < [savedIndivs count]; j++) {
            // Compare the name of the indiv from the main array to the one in the saved array
            NSString * compareName = [savedIndivs objectAtIndex:j];
            if ([thisName isEqualToString:compareName]) {
                [newArray addObject:thisIndiv];
            }
        }
    }
    return newArray;
}

// Helper function that creates and returns an array of individuals who are currently marked as "present"
// for this event
-(NSMutableArray*)loadArrayWithPresentIndivs
{
    NSMutableArray *nameArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.individualInfos count]; i++) {
        Individual *thisIndiv = [self.individualInfos objectAtIndex:i];
        BOOL t = [thisIndiv.isPresent boolValue];
        if (t) {
            [nameArray addObject:thisIndiv];
        }
    }
    
    return nameArray;
}

-(void)viewWillDisappear:(BOOL)animated
{
    // Before the view disappears, we'll save any changes that have been made to the individual
    // details if in standard mode
    if ([editmode isEqualToString:@"standard"]) {
        viewPopped = YES;
        [self saveStandard];
    }
}

- (void)viewDidUnload
{
	self.filteredList = nil;
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Individual *info;
    
    //Prepare the individual data associated with the selected row
    if (tableView == self.searchDisplayController.searchResultsTableView){
        info = [filteredList objectAtIndex:indexPath.row];
    }else{
        info = [individualInfos objectAtIndex:indexPath.row];
    }
    
    // Set the Individual ID, this will be used to load the correct detail view
    detail_IndividualData = info;
    
    // Prepare to segue
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"toIndivDetail" sender: self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return numSections;
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
        return [self.individualInfos count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Individual *info = nil;
    
    static NSString *kCellID = @"cellID";
	TableCell_CafePride_Individual *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    // If this cell doesn't exist yet, initialize it
    if (cell == nil)
	{
		cell = [[TableCell_CafePride_Individual alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    
    // If we are conducting a search, we'll pull information from the filteredList array
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        tableView.backgroundColor = [UIColor blackColor];
        tableView.rowHeight = 100;
        if ([filteredList count] > 0) {
            if (indexPath.row + 1 <= [filteredList count]) {
                info = [filteredList objectAtIndex:indexPath.row];
            }
        }
    // If we are looking at the standard table, we'll pull data from the individualInfos array
    }else{
        info = [self.individualInfos objectAtIndex:indexPath.row];
    }
    
    cell.myIndivData = info;
    
    // Set up the cell with a title and subtitle using the individual data fetched earlier...
    [cell setLabels];
    [cell setDetailText];
    
    // Prepare the profile image and button interface for this cell
    [cell setProfileImage];
    if (eventActive) {
        // if the event is active, load the attendance buttons so the user can easily change the user's
        // attendance status
        [cell addButtons:self.managedObjectContext];
    }else {
        // if the event is not active, we load the attendance buttons, but then remove them right away
        [cell addButtons:self.managedObjectContext];
        [cell removeButtons];
    }
    
    // Add a trigger to the cell's attendance button so that the event's numAttendees counter can be
    // updated automatically
    [cell.myAttendanceButtons.btn_IsPresent addTarget:self action:@selector(updateAttendanceNum:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

// Whenever a user's attendance has been changed, this function updates the number of attendees, and then
// displays the new number using the appropriate textfield
-(void)updateAttendanceNum:(UIButton*) sender
{
    int counter = 0;
    for (int i =0; i < [self.individualInfos count]; i++) {
        Individual * indiv = [self.individualInfos objectAtIndex:i];
        BOOL t = [indiv.isPresent boolValue];
        if (t) {
            counter++;
        }
    }
    
    NSString * counterText = [NSString stringWithFormat:@"%d", counter];
    textfield_Attendees.text = counterText;
}

#pragma mark Date Picking
// setDate is called when the user taps the "Set Date" button, and presents the date picker popover
- (IBAction)setDate:(id)sender
{
    // Present the popover from the button that was tapped in the detail view.
    UIButton *tappedButton = (UIButton *)sender;
	[datePickerViewPopover presentPopoverFromRect:tappedButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    [datePopoverContent.picker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
}

// Called when the done button is tapped from the Date Picker Popover. Removes the popover
- (void)dateChanged
{
    // Save the new date both locally and to the data store
    NSDate *myDate = datePopoverContent.picker.date;
    eventDate = myDate;
    
    // Present the date as a nice readable string
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    NSString *prettyVersion = [dateFormat stringFromDate:myDate];
    
    label_EventDate.text = prettyVersion;
}

#pragma mark Changing Event Status
// Tapping the "Change Event" button triggers this function.
// Changing an event either adds or removes functionality that allows users to make quick
// and easy changes to the event, and the attendance status of individuals
- (IBAction)changeEventStatus:(id)sender
{
    NSArray * newIndivArray;
    if (eventActive){
        // The event was active, so we're going to close it
        eventActive = NO;
        
        // Change the "Change Event's" button graphics and text
        [Btn_EventStatus setBackgroundImage:[UIImage imageNamed:@"Btn_DeleteIndividual.png"] forState:normal];
        [Btn_EventStatus setTitle:@"Event is Closed \n (tap to open)" forState:normal];
        
        // set the individual array so that it only contains individuals marked as 'present'
        newIndivArray = [self loadArrayWithPresentIndivs];
        self.individualInfos = [NSArray arrayWithArray:newIndivArray];
        
    }else{
        // The event was inactive, so we will open it
        eventActive = YES;
        
        // Change the "Change Event's" button graphics and text
        [Btn_EventStatus setBackgroundImage:[UIImage imageNamed:@"Btn_EventActive.png"] forState:normal];
        [Btn_EventStatus setTitle:@"Event is Open \n (tap to close)" forState:normal];
        
        // set the individual array so that it uses all of the individuals stored using CoreData
        newIndivArray = [self loadAllIndividuals];
        self.individualInfos = [NSArray arrayWithArray:newIndivArray];
    }
    
    // Reload the table view's data to give the user an up to date view of event data
    [self.tableView reloadData];
}

#pragma mark Saving
// Triggered when the user taps the save button
- (IBAction)save:(id)sender
{
    
    // check to see which type of saving we need based on the editmode
    if ([editmode isEqualToString:@"standard"])
    {
        [self saveStandard];
    }else{
        [self saveNew];
    }
}

// Standard mode save functionality
-(void)saveStandard
{
    // Standard mode save functionality
    
    // Prepare this individual's basic info for saving
    myEventData.date = eventDate;
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * num = [f numberFromString:textfield_Attendees.text];
    
    myEventData.numAttendees = num;
    
    NSMutableArray *nameArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.individualInfos count]; i++) {
        Individual *thisIndiv = [self.individualInfos objectAtIndex:i];
        BOOL t = [thisIndiv.isPresent boolValue];
        if (t) {
            NSString *thisName = thisIndiv.name_preferred;
            [nameArray addObject:thisName];
        }
    }
    
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:nameArray];
    myEventData.attendees = arrayData;
    
    myEventData.isActive = [NSNumber numberWithBool:eventActive];
    
    // Start saving using the current save context
    [self.managedObjectContext save:nil];
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    // Move back to the main View controller
    if (!viewPopped) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// Save functionality for a new Event
-(void) saveNew
{
    // Use the text values entered by the user to create a NEW event entry, and save it
    // to the data store.
    
    // If the user has entered acceptable data for all required data fields, we'll commit the new data to the data store
    
    // Find out how many Events are currently stored in the Data Store
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext]];
    
    [request setIncludesSubentities:NO]; //Omit subentities. Default is YES (i.e. include subentities)
        
    // Prepare the new data for saving
    Event *new_event = [NSEntityDescription insertNewObjectForEntityForName:@"Event"inManagedObjectContext:self.managedObjectContext];
    
    // Prepare basic info for saving
    new_event.date = eventDate;
    new_event.isActive = [NSNumber numberWithBool:eventActive];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * num = [f numberFromString:textfield_Attendees.text];
    new_event.numAttendees = num;
    
    NSMutableArray *nameArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.individualInfos count]; i++) {
        Individual *thisIndiv = [self.individualInfos objectAtIndex:i];
        BOOL t = [thisIndiv.isPresent boolValue];
        if (t) {
            NSString *thisName = thisIndiv.name_preferred;
            [nameArray addObject:thisName];
        }
    }
    
    
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:nameArray];
    new_event.attendees = arrayData;
    
    // Complete the save using our save context
    [self.managedObjectContext save:nil];
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    // Move back to the Master view controller
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Triggered upon pushing the "Delete Event" button. Launches a confirmation dialog requiring
// the user to confirm their choice to delete the individual
- (IBAction)deleteEvent:(id)sender
{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Are you sure?"
                              message:@"This action will permanently delete this Event's data"
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Delete it!", nil];
        
        [alert show];
}

// The alert view that comes up when attempting to deleting an event
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1) {
		NSLog(@"user pressed OK");
        [self completeDelete];
	}
	else {
		NSLog(@"user pressed Cancel");
	}
}

// This function finalizes the deletion of an event, then returns the user to the main event list
-(void)completeDelete
{
    if ([editmode isEqualToString:@"standard"])
        [managedObjectContext deleteObject:myEventData];
    
    [self.navigationController popViewControllerAnimated:YES];
}

// Called in preparation to segue to a new view

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toIndivDetail"]) {
        
        // Get destination view
        CPCI_IndivDetailVC *vc = [segue destinationViewController];
        
        // Set needed values for the Detail view before loading
        vc.myIndivData = detail_IndividualData;
        vc.managedObjectContext = self.managedObjectContext;
        vc.editmode = @"standard";
    }
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    /*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.filteredList removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
    
	for (Individual *indiv in individualInfos)
	{
        BOOL addIndiv = NO;
        // Compare the search text entered by the user against the preferred names of the individuals stored
        // in the individualInfos array
        NSComparisonResult result= [indiv.name_preferred compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        if (result == NSOrderedSame)
        {
            addIndiv = YES;
        }
        
        // Compare the search text entered by the user against the first names of the individuals stored
        // in the individualInfos array
        result = [indiv.name_first compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        
        if (result == NSOrderedSame)
        {
            addIndiv = YES;
        }
        
        // Compare the search text entered by the user against the last names of the individuals stored
        // in the individualInfos array
        result = [indiv.name_last compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        
        if (result == NSOrderedSame)
        {
            addIndiv = YES;
        }
        
        if (addIndiv) {
            [self.filteredList addObject:indiv];
        }
	}
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.tableView reloadData];
}

@end
