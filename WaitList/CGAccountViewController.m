//
//  CGAccountViewController.m
//  WaitList
//
//  Created by Padraic Doyle on 12/11/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import "CGAccountViewController.h"
#import "CGRestaurant.h"

@interface CGAccountViewController ()

@end

@implementation CGAccountViewController

@synthesize restaurants = _restaurants;
@synthesize delegate = _delegate;

// Add viewDidLoad like the following:
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0){
        return self.restaurants.count;
    }else{
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *restaurantName = [[_restaurants objectAtIndex:indexPath.row] name];
    cell.textLabel.text = restaurantName;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0){
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.tableView.bounds.size.width,60)];
        customView.backgroundColor = self.tableView.backgroundColor;
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0,0,self.tableView.bounds.size.width,60)];
        
        textView.text = @"Below are restaurants to which you have been granted admin access AND that have signed up for the Wait List Feature.  Tap a restaurant to see it's wait list.";
        textView.textAlignment = UITextAlignmentCenter;
        textView.backgroundColor = nil;
        textView.editable = NO;
        
        [customView addSubview:textView];
        return customView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        return 60.0;
    }else{
        return 0.0;
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate != nil) {
        CGRestaurant *restaurant = [_restaurants objectAtIndex:indexPath.row];
        [self.delegate restaurantSelected:restaurant];
    }
}

- (IBAction)logOut:(id)sender {
    [self.delegate logOut];
}

@end