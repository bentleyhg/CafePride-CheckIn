//
//  DetailViewController.h
//  CafePride-CheckIn
//
//  Created by Bentley Holmes-Gull on 11/8/12.
//  Copyright (c) 2012 Playful Planet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
