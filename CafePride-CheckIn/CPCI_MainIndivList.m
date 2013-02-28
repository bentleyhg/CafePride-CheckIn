//
//  CPCI_MainIndivList.m
//  CafePride-CheckIn
//
//  Created by Bentley Holmes-Gull on 1/24/13.
//  Copyright (c) 2013 Playful Planet. All rights reserved.
//

#import "CPCI_MainIndivList.h"
#import "CPCI_IndivDetailVC.h"
#import "TableCell_CafePride_Individual.h"
#import "Individual.h"
#import "Individual_Details.h"

@interface CPCI_MainIndivList ()

@end

@implementation CPCI_MainIndivList
@synthesize managedObjectContext;
@synthesize individualInfos;

@synthesize savedScopeButtonIndex;
@synthesize savedSearchTerm;
@synthesize searchWasActive;
@synthesize filteredList;
@synthesize listContent;

// Initialization methods
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
    
    // Fetch stored CoreData for individuals registered for Cafe Pride
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Individual" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.individualInfos = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // create a filtered list that will contain products for the search results table.
	self.filteredList = [NSMutableArray arrayWithCapacity:[self.individualInfos count]];
    
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
    // Update the IndividualInfos array with any new Data Entities
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Individual" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.individualInfos = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Reload the data for the table so that changes are displayed correctly
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
	self.filteredList = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    // save the state of the search UI so that it can be restored if the view is re-created
    //self.searchWasActive = [self.searchDisplayController isActive];
    //self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    //self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
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
        return [self.individualInfos count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Individual *info = nil;
    static NSString *kCellID = @"cellID";
	
    // Determine the cell we are working with using the Reusable cell indentifier
	TableCell_CafePride_Individual *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    // If the cell has not yet been created, initialize it
    if (cell == nil)
	{
		cell = [[TableCell_CafePride_Individual alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        // If we are viewing search results, pull data from the filtered list created by the search query
        tableView.backgroundColor = [UIColor blackColor];
        tableView.rowHeight = 100;
        if ([filteredList count] > 0) {
            if (indexPath.row + 1 <= [filteredList count]) {
                info = [filteredList objectAtIndex:indexPath.row];
            }
        }
    }else{
        // If we are not looking at search results, pull data for all stored individuals
        info = [individualInfos objectAtIndex:indexPath.row];
    }
    
    cell.myIndivData = info;
    
    // Set up the cell with a title and subtitle using the individual data fetched earlier...
    [cell setLabels];
    [cell setDetailText];
    
    // Prepare the profile image and button interface for this cell
    [cell setProfileImage];
    
    // Set a neutral background color graphic for the UITableCell
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RowBG_Purple.png"]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RowBG_Purple-Over.png"]];

    return cell;
}

#pragma mark - Table view delegate

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

- (IBAction)addNew:(id)sender
{
    // Triggered when the "Add New Individual" Button is pressed. Triggers a move to the detail
    // view with blank data fields
    adding_new = true;
    [self performSegueWithIdentifier:@"toIndivDetail" sender: self];
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
        
        // Determine if we are adding a new individual, so we can load the proper edit mode
        if (adding_new) {
            vc.editmode = @"addnew";
            adding_new = false;
        }else{
            vc.editmode = @"standard";
        }
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
