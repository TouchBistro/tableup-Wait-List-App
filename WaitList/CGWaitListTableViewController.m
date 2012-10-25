//
//  CGWaitListTableViewController.m
//  WaitList
//
//  Created by Padraic Doyle on 10/19/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import "CGWaitListTableViewController.h"
#import "CGRestaurantWaitList.h"
#import "CGRestaurantWaitListCell.h"
#import "CGAddGuestViewController.h"
#import "CGGuestDetailTableViewController.h"
#import <RestKit/RestKit.h>

@interface CGWaitListTableViewController ()

@end

@implementation CGWaitListTableViewController

@synthesize waitListers;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/restaurants/1/waitlist" delegate:self];
    
    [super viewDidLoad];
    [self setDataLoaded:FALSE];

    refreshControl = [[UIRefreshControl alloc] init];
    
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Pull to refresh"];
    
    [refreshControl addTarget:self action:@selector(refreshMyTableView) forControlEvents:UIControlEventValueChanged];
        
    self.refreshControl = refreshControl;
    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    RKLogInfo(@"Load collection of Wait Listers: %@", objects);
    self.waitListers = [[NSMutableArray alloc] initWithArray:objects];
    self.dataLoaded = TRUE;
    [self.tableView reloadData];
    
    [refreshControl endRefreshing];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataLoaded){
        return self.waitListers.count;
    }else{
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"inVenueCell";
    
    CGRestaurantWaitList *waitListee = [self.waitListers objectAtIndex:indexPath.row];
    
    CGRestaurantWaitListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil){
        cell = [[CGRestaurantWaitListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (waitListee != nil){
        cell.name.text = waitListee.guest ? waitListee.guest.name : nil;
        
        if (waitListee.estimatedWait != nil){
            NSString *estimatedWait = waitListee.estimatedWait.stringValue;
            estimatedWait = [estimatedWait stringByAppendingString:@" mins"];
            
            cell.estimatedWaitTime.text = estimatedWait;
        }
        
        if (waitListee.timeOnWaitList != nil){
            NSString *timeOnWaitList = @"(";
            timeOnWaitList = [timeOnWaitList stringByAppendingString:waitListee.timeOnWaitList.stringValue];
            timeOnWaitList = [timeOnWaitList stringByAppendingString:@")"];
            
            cell.estimatedWaitTimeRemaining.text = timeOnWaitList;
        }
        
        if (waitListee.timeSinceTextSent != nil){
            NSString *timeSinceTextSent = waitListee.timeSinceTextSent.stringValue;
            timeSinceTextSent = [timeSinceTextSent stringByAppendingString:@" mins ago"];
            
            cell.textSentTimeAgo.text = timeSinceTextSent;
        }else{
            cell.textSentTimeAgo.text = @"";
        }
        
        if (waitListee.numberInParty != nil){
            NSString *numberInParty = waitListee.numberInParty.stringValue;
            
            cell.numberInParty.text = numberInParty;
        }
    }
    
    return cell;
}



#pragma mark - Table view delegate

- (void)viewDidUnload {
    [super viewDidUnload];
}

-(void)refreshMyTableView{
    
    //set the title while refreshing
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Refreshing Waitlist"];
    //set the date and time of refreshing
    NSDateFormatter *formattedDate = [[NSDateFormatter alloc]init];
    [formattedDate setDateFormat:@"MMM d, h:mm a"];
    NSString *lastupdated = [NSString stringWithFormat:@"Last Updated on %@",[formattedDate stringFromDate:[NSDate date]]];
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:lastupdated];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/restaurants/1/waitlist" delegate:self];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self setDataLoaded:FALSE];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/restaurants/1/waitlist" delegate:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"newGuest"]){
        UINavigationController *navController = [segue destinationViewController];
        
        if (navController != nil){
            CGAddGuestViewController *addGuestController = (CGAddGuestViewController *)navController.topViewController;

            if (addGuestController != nil){
                [addGuestController setWaitListTableViewController:segue.sourceViewController];
            }
        }
    }else if ([[segue identifier] isEqualToString:@"guestDetail"]){
        CGGuestDetailTableViewController *guestDetailTableViewController = [segue destinationViewController];
        
        if (guestDetailTableViewController != nil){
            [guestDetailTableViewController setWaitListee:[self.waitListers objectAtIndex:self.tableView.indexPathForSelectedRow.row]];
        }
    }
}

- (void)guestDetailControllerDidFinish:(NSArray *)currentWaitList{
    if (currentWaitList){
        [self.waitListers removeAllObjects];
        [self.waitListers addObjectsFromArray:currentWaitList];
        [self.tableView reloadData];
    }
}



@end
