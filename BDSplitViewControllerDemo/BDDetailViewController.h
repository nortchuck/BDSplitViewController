//
//  BDDetailViewController.h
//  BDSplitViewControllerDemo
//
//  Created by Bryan Dunbar on 11/18/11.
//  Copyright (c) 2011 Great American Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
