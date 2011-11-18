//
//  BDSplitViewController.m
//  SlidingMasterDemo
//
//  Created by Bryan Dunbar on 11/18/11.
//  Copyright 2011 Bryan Dunbar. All rights reserved.
//

#import "BDSplitViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface BDSplitViewController ()

-(void)commonInit;
-(void)applyDetailGestures:(UIViewController*)viewController;
-(void)handleSwipeLeft:(UIGestureRecognizer*)recognizer;
-(void)handleSwipeRight:(UIGestureRecognizer*)recognizer;

@end

@implementation BDSplitViewController
@synthesize masterIsVisible;


#pragma mark -
#pragma mark Initialization
-(id)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self commonInit];
    }
    return self;
}
-(void)commonInit {
    self.masterIsVisible = NO;
}

#pragma mark -
#pragma mark View Life Cycle
-(void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark -
#pragma mark Overrides
-(void)setViewControllers:(NSArray *)viewControllers {
    [super setViewControllers:viewControllers];
    
    // Set up the gesture recognizers on the detail view
    [self applyDetailGestures:self.detailViewController]; 
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        [self hideMasterView:YES];
    }
    
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

-(void)setDelegate:(id<UISplitViewControllerDelegate>)theDelegate {
            
    // We are proxying all the delegate calls
    _realDelegate = theDelegate;
    [super setDelegate:self];
}
-(id<UISplitViewControllerDelegate>)delegate {
    // We are proxying all the delegate calls
    return _realDelegate;
}

#pragma mark -
#pragma mark Public API
-(UIViewController*)masterViewController {
    return [self.viewControllers objectAtIndex:0];
}
-(UIViewController*)detailViewController {
    return [self.viewControllers objectAtIndex:1];
}

-(void)showMasterView {
    [self showMasterView:YES];
}
-(void)showMasterView:(BOOL)animated {
    
    if (UIInterfaceOrientationIsLandscape(self.detailViewController.interfaceOrientation)) {
        // get out, wrong orientation
        return;
    }
    
    if (!self.masterIsVisible) {
        self.masterIsVisible = YES;
        
        UIViewController *masterController = self.masterViewController;
        UIView *masterView = masterController.view;
        
        CGRect frame = masterView.frame;
        frame.origin.x += frame.size.width; // Don't know if this is always going to be ok
        
        // Add the shadow
        masterView.layer.masksToBounds = NO;
        masterView.layer.shouldRasterize = YES;
        masterView.layer.cornerRadius = 6;
        masterView.layer.shadowOpacity = 0.7;
        masterView.layer.shadowRadius = 8.0;
        masterView.layer.shadowOffset = CGSizeMake(8, 0);
        
        
        if (animated) {
            [UIView animateWithDuration:BD_SPLIT_VIEW_CONTROLLER_SLIDE_ANIMATION_DURATION animations:^{
                self.masterViewController.view.frame = frame;
            }];
        } else {
            self.masterViewController.view.frame = frame;
        }
        
    }
}

-(void)hideMasterView {
    [self hideMasterView:YES];
}
-(void)hideMasterView:(BOOL)animated {
    
    if (UIInterfaceOrientationIsLandscape(self.detailViewController.interfaceOrientation)) {
        // get out, wrong orientation
        return;
    }
    
    if (self.masterIsVisible) {
        self.masterIsVisible = NO;
        
        UIViewController *masterController = self.masterViewController;
        UIView *masterView = masterController.view;
        
        CGRect frame = masterView.frame;
        frame.origin.x -= frame.size.width; // Don't know if this is always going to be ok
        
        
        if (animated) {
            
            [UIView animateWithDuration:BD_SPLIT_VIEW_CONTROLLER_SLIDE_ANIMATION_DURATION 
                             animations:^{
                                 masterView.frame = frame;
                             } completion:^(BOOL finished) {
                                 
                                 // Remove the shadow
                                 masterView.layer.borderWidth = 0.0;
                                 masterView.layer.shadowOffset = CGSizeZero;
                                 masterView.layer.shadowRadius = 0.0;
                             }];
        } else {
            // Adjust the frame and remove the shadow
            masterView.frame = frame;
            masterView.layer.borderWidth = 0.0;
            masterView.layer.shadowOffset = CGSizeZero;
            masterView.layer.shadowRadius = 0.0;
        }
        
    }    
}


#pragma mark -
#pragma mark Private API
-(void)applyDetailGestures:(UIViewController *)viewController {
    // Swipes the master out
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [viewController.view addGestureRecognizer:swipeLeft];
    
    // Swipes the master in
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [viewController.view addGestureRecognizer:swipeRight];
}

-(void)handleSwipeLeft:(UIGestureRecognizer *)recognizer {
    [self hideMasterView:YES];
}
-(void)handleSwipeRight:(UIGestureRecognizer *)recognizer {
    [self showMasterView:YES];
}


#pragma mark -
#pragma mark UISplitViewController Delegate
- (void)splitViewController:(UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController:(UIPopoverController*)pc {
    
    
    // Override the action
    [barButtonItem setTarget:self];
    [barButtonItem setAction:@selector(showMasterView)];
    
    // Call the method on the real delegate
    if ([_realDelegate respondsToSelector:@selector(splitViewController:willHideViewController:withBarButtonItem:forPopoverController:)]) {
        [_realDelegate splitViewController:svc willHideViewController:aViewController withBarButtonItem:barButtonItem forPopoverController:pc];
    }
}

- (void)splitViewController:(UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {

    // Call the method on the real delegate
    if ([_realDelegate respondsToSelector:@selector(splitViewController:willHideViewController:withBarButtonItem:forPopoverController:)]) {
        [_realDelegate splitViewController:svc willShowViewController:aViewController invalidatingBarButtonItem:barButtonItem];
    }
}

-(void)splitViewController:(UISplitViewController *)svc popoverController:(UIPopoverController *)pc willPresentViewController:(UIViewController *)aViewController {
    
    // Call the method on the real delegate
    if ([_realDelegate respondsToSelector:@selector(splitViewController:popoverController:willPresentViewController:)]) {
        [_realDelegate splitViewController:svc popoverController:pc willPresentViewController:aViewController];
    }
}

-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    if ([_realDelegate respondsToSelector:@selector(splitViewController:shouldHideViewController:inOrientation:)]) {
        return [_realDelegate splitViewController:svc shouldHideViewController:vc inOrientation:orientation];
    } else {
        
        return UIInterfaceOrientationIsPortrait(orientation); // Default is to hide the VC in portrait
    }
}

@end


