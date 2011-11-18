//
//  BDMasterViewController.h
//  BDSplitViewControllerDemo
//
//  Created by Bryan Dunbar on 11/18/11.
//  Copyright (c) 2011 Great American Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BDDetailViewController;

@interface BDMasterViewController : UITableViewController

@property (strong, nonatomic) BDDetailViewController *detailViewController;

@end
