//
//  CPCI_masterVC.m
//  CafePride-CheckIn
//
//  Created by Bentley Holmes-Gull on 1/24/13.
//  Copyright (c) 2013 Playful Planet. All rights reserved.
//

#import "CPCI_masterVC.h"
#import "CPCI_MainIndivList.h"
#import "CPCI_MainEventList.h"

@interface CPCI_masterVC ()

@end

@implementation CPCI_masterVC
@synthesize managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Functions controlling segues
- (IBAction)goIndivList:(id)sender
{
    [self performSegueWithIdentifier:@"toIndivList" sender: self];
}
- (IBAction)goEventList:(id)sender
{
    [self performSegueWithIdentifier:@"toEventList" sender: self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toIndivList"]) {
        
        // Get destination view
        CPCI_MainIndivList *vc = [segue destinationViewController];
        vc.managedObjectContext = self.managedObjectContext;
    }
    
    if ([[segue identifier] isEqualToString:@"toEventList"]) {
        
        // Get destination view
        CPCI_MainEventList *vc = [segue destinationViewController];
        vc.managedObjectContext = self.managedObjectContext;
    }
}

@end
