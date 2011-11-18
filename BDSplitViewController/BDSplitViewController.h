//
//  BDSplitViewController.h
//  SlidingMasterDemo
//
//  Created by Bryan Dunbar on 11/18/11.
//  Copyright 2011 Bryan Dunbar. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BD_SPLIT_VIEW_CONTROLLER_SLIDE_ANIMATION_DURATION 0.25

@interface BDSplitViewController : UISplitViewController <UISplitViewControllerDelegate> {
    id _realDelegate;
}
    

@property (nonatomic,assign) BOOL masterIsVisible;
@property (nonatomic,readonly) UIViewController *detailViewController;
@property (nonatomic,readonly) UIViewController *masterViewController;

-(void)showMasterView;
-(void)showMasterView:(BOOL)animated;

-(void)hideMasterView;
-(void)hideMasterView:(BOOL)animated;

@end
