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
        self.currentRestaurant = [loggedInUser.ownedRestaurants objectAtIndex:0];
        
        if (currentRestaurant != nil){
            [self.currentVenueButton setTitle:currentRestaurant.name forState:UIControlStateNormal];
        }
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
    }
    
}


- (IBAction)logOut:(id)sender {
    [self setLoggedInUser:nil];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsUserId];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPassword];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsUsername];
    
    [self dismissModalViewControllerAnimated:YES];
}
@end
