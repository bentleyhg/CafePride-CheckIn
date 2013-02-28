//
//  CPCI_masterVC.h
//  CafePride-CheckIn
//
//  Created by Bentley Holmes-Gull on 1/24/13.
//  Copyright (c) 2013 Playful Planet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPCI_masterVC : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *btn_IndivList;
@property (strong, nonatomic) IBOutlet UIButton *btn_EventList;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

- (IBAction)goEventList:(id)sender;
- (IBAction)goIndivList:(id)sender;

@end
