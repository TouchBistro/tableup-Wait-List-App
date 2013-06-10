//
//  CGOwnerAccountInfoViewController.m
//  WaitList
//
//  Created by Padraic Doyle on 11/5/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import "CGOwnerAccountInfoViewController.h"
#import "CGRestaurant.h"
#import "CGLoginViewController.h"
#import "CGWaitListTableViewController.h"
#import "CGOwnerVenueViewController.h"
#import "CGMessageOptionsViewController.h"
#import "CGUtils.h"

@interface CGOwnerAccountInfoViewController ()

@end

@implementation CGOwnerAccountInfoViewController

@synthesize loggedInUser;
@synthesize currentVenueButton;
@synthesize currentRestaurant;

- (void)viewDidLoad
{
    if (loggedInUser != nil && loggedInUser.ownedRestaurants != nil){
        
        if ([loggedInUser.ownedRestaurants count] > 0){
            self.currentRestaurant = [loggedInUser.ownedRestaurants objectAtIndex:0];
            
            if (currentRestaurant != nil){
                [self.currentVenueButton setTitle:currentRestaurant.name forState:UIControlStateNormal];
            }
            
            self.adminMessageTextView.hidden = YES;
        }else{
            self.currentVenueLabel.hidden = YES;
            self.currentVenueButton.hidden = YES;
            self.changeRestaurantButton.hidden = YES;
            
            self.adminMessageTextView.hidden = NO;
            self.adminMessageTextView.text = @"You are currently not an Owner Admin for a Wait List enabled restaurant.  For more information or to enable the Wait List feature for a restaurant you own, visit http://citygusto.com/waitlist.";
        }
        
        
    }
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        UIImage *navBarImg = [UIImage imageNamed:@"appHeader.png"];
        [self.navigationController.navigationBar setBackgroundImage:navBarImg forBarMetrics:UIBarMetricsDefault];
        
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCurrentVenueLabel:nil];
    [self setChangeRestaurantButton:nil];
    [self setAdminMessageTextView:nil];
    [super viewDidUnload];
    [self setCurrentVenueButton:nil];
    [self setCurrentRestaurant:nil];
    [self setLoggedInUser:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"waitList"]){
        UINavigationController *navController = [segue destinationViewController];
        
        if (navController != nil){
            CGWaitListTableViewController *waitList = (CGWaitListTableViewController *)navController.topViewController;
            
            if (waitList != nil){
                [waitList setCurrentRestaurant:self.currentRestaurant];
                [waitList setLoggedInUser:self.loggedInUser];
            }
        }
    }else if ([[segue identifier] isEqualToString:@"venueList"]){
        CGOwnerVenueViewController *venueListController = [segue destinationViewController];
        if (venueListController != nil){
            [venueListController setRestaurants:self.loggedInUser.ownedRestaurants];
            [venueListController setOwnerAccountInfoViewController:self];
        }
    }else if ([[segue identifier] isEqualToString:@"messageOptionsSegue"]){
        UINavigationController *navController = [segue destinationViewController];
        
        if (navController != nil){
            CGMessageOptionsViewController *messageOptionsController = (CGMessageOptionsViewController *)navController.topViewController;
            
            if (messageOptionsController != nil){
                [messageOptionsController setCurrentRestaurant:self.currentRestaurant];
            }
        }
    }
    
}


- (IBAction)logOut:(id)sender {
    [self setLoggedInUser:nil];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsUserId];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPassword];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsUsername];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kFbUid];
    
    [self dismissModalViewControllerAnimated:YES];
}



- (IBAction)help:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://citygusto.com/waitlist/training"]];
}
@end
