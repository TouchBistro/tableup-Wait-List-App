//
//  CGOwnerVenueViewController.m
//  WaitList
//
//  Created by Padraic Doyle on 10/12/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import "CGOwnerVenueViewController.h"
#import "CGOwnerAccountInfoViewController.h"
#import "CGRestaurant.h"

@interface CGOwnerVenueViewController ()

@end

@implementation CGOwnerVenueViewController

@synthesize restaurants;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        UIImage *navBarImg = [UIImage imageNamed:@"appHeader.png"];
        [self.navigationController.navigationBar setBackgroundImage:navBarImg forBarMetrics:UIBarMetricsDefault];
        
    }
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        UIImage *navBarImg = [UIImage imageNamed:@"appHeader.png"];
        [self.navigationController.navigationBar setBackgroundImage:navBarImg forBarMetrics:UIBarMetricsDefault];
        
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.restaurants.count;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"restaurantCell";
    CGRestaurant *restaurant = [self.restaurants objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (restaurant != nil){
        cell.textLabel.text = restaurant.name;
        cell.detailTextLabel.text = restaurant.address1;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRestaurant *selectedRestaurant = [self.restaurants objectAtIndex:indexPath.row];
    
    if (selectedRestaurant){
        self.ownerAccountInfoViewController.currentRestaurant = selectedRestaurant;
        [self.ownerAccountInfoViewController.currentVenueButton setTitle:selectedRestaurant.name forState:UIControlStateNormal];

    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
