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
#import "CGOwnerAccountInfoViewController.h"
#import "CGRestaurantFullWaitList.h"
#import <RestKit/RestKit.h>

@interface CGWaitListTableViewController ()

@end

@implementation CGWaitListTableViewController

@synthesize waitListers;

@synthesize totalGuests;
@synthesize totalParties;
@synthesize estimatedWait;
@synthesize unreadMessages;
@synthesize numberOfUnreadMessages;

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
    NSString *url = @"/restaurants/";
    url = [url stringByAppendingString:self.currentRestaurant.restaurantId.stringValue];
    url = [url stringByAppendingString:@"/waitlist"];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:url delegate:self];
    
    [super viewDidLoad];
    [self setDataLoaded:FALSE];

    refreshControl = [[UIRefreshControl alloc] init];
    
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Pull to refresh"];
    
    [refreshControl addTarget:self action:@selector(refreshMyTableView) forControlEvents:UIControlEventValueChanged];
        
    self.refreshControl = refreshControl;
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        UIImage *navBarImg = [UIImage imageNamed:@"appHeader.png"];
        [self.navigationController.navigationBar setBackgroundImage:navBarImg forBarMetrics:UIBarMetricsDefault];
        
    }
    
    if (self.totalParties && self.totalGuests && self.estimatedWait){
        UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,300,30)];
        
        NSString *label = @"Parties: ";
        label = [label stringByAppendingString:self.totalParties.stringValue];
        label = [label stringByAppendingString:@" / Guests: "];
        label = [label stringByAppendingString:self.totalGuests.stringValue];
        label = [label stringByAppendingString:@" / Estimated Wait: "];
        label = [label stringByAppendingString:self.estimatedWait.stringValue];
        label = [label stringByAppendingString:@" mins"];
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.font = [UIFont systemFontOfSize:10];
        headerLabel.frame = CGRectMake(0,0,300,30);
        headerLabel.text =  label;
        headerLabel.textAlignment = UITextAlignmentCenter;
        
        [customView addSubview:headerLabel];
        self.tableView.tableHeaderView = customView;
    }

    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    RKLogInfo(@"Load collection of Wait Listers: %@", objects);
    //should only have 1 object
    CGRestaurantFullWaitList *fullWaitList = [objects objectAtIndex:0];
    
    if (fullWaitList){
        self.waitListers = [[NSMutableArray alloc] initWithArray:fullWaitList.waitListers];
        self.totalParties = fullWaitList.totalParties;
        self.totalGuests = fullWaitList.totalGuests;
        self.estimatedWait = fullWaitList.estimatedWait;
        self.unreadMessages = fullWaitList.unreadMessages;
        self.numberOfUnreadMessages = fullWaitList.numberOfUnreadMessages;
        
        UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.tableView.bounds.size.width,30)];
        
        NSString *label = @"Parties: ";
        label = [label stringByAppendingString:self.totalParties.stringValue];
        label = [label stringByAppendingString:@" / Guests: "];
        label = [label stringByAppendingString:self.totalGuests.stringValue];
        label = [label stringByAppendingString:@" / Estimated Wait: "];
        label = [label stringByAppendingString:self.estimatedWait.stringValue];
        label = [label stringByAppendingString:@" mins"];
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,self.tableView.bounds.size.width,30)];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.font = [UIFont systemFontOfSize:10];
        headerLabel.text =  label;
        headerLabel.textAlignment = UITextAlignmentCenter;
        
        [customView addSubview:headerLabel];
        self.tableView.tableHeaderView = customView;
        
        self.dataLoaded = TRUE;
        [self.tableView reloadData];
        
    }
    
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
        cell.addOnlineImage.hidden = YES;
        cell.tableNumberLabel.hidden = YES;
        cell.name.text = waitListee.guest ? waitListee.guest.name : nil;
        
        if (waitListee.estimatedWait != nil){
            NSString *estimatedWaitString = waitListee.estimatedWait.stringValue;
            
            if (waitListee.timeOnWaitList != nil){
                estimatedWaitString = [estimatedWaitString stringByAppendingString:@" mins ("];
                estimatedWaitString = [estimatedWaitString stringByAppendingString:waitListee.timeOnWaitList.stringValue];
                estimatedWaitString = [estimatedWaitString stringByAppendingString:@")"];
            }else{
                estimatedWaitString = [estimatedWaitString stringByAppendingString:@" mins"];
            }
            
            cell.estimatedWaitTime.text = estimatedWaitString;
        }
        
        
        
        if (waitListee.timeSinceTextSent != nil){
            NSString *timeSinceTextSent = waitListee.timeSinceTextSent.stringValue;
            timeSinceTextSent = [timeSinceTextSent stringByAppendingString:@" mins ago"];
            
            cell.textSentTimeAgo.text = timeSinceTextSent;
            cell.notifyImage.hidden = NO;
        }else{
            cell.textSentTimeAgo.text = @"";
            cell.notifyImage.hidden = YES;
        }
        
        if (waitListee.visitNotes != nil){
            NSString *visitNotes = waitListee.visitNotes;
            
            cell.visitNotesLabel.text = visitNotes;
        }else{
            cell.visitNotesLabel.text = @"";
        }
        
        if (waitListee.numberInParty != nil){
            NSString *numberInParty = waitListee.numberInParty.stringValue;
            
            cell.numberInParty.text = numberInParty;
        }
        
        if (waitListee.tableNumber != nil){
            cell.tableNumberLabel.hidden = NO;
            cell.tableNumberLabel.text = waitListee.tableNumber;
            cell.tableNumberLabel.textColor = [UIColor colorWithRed:173.0/255.0 green:98.0/255.0 blue:137.0/255.0 alpha:1];
            cell.tableNumberLabel.font = [UIFont boldSystemFontOfSize:10.0];
        }
        
        if (waitListee.reserveOnline){
            UIImage *image = [UIImage imageNamed:@"addOnline.png"];
            cell.addOnlineImage.image = image;
            cell.addOnlineImage.hidden = NO;
        }else{
            if (waitListee.guest.phoneNumber == nil){
                UIImage *image = [UIImage imageNamed:@"noPhoneRed.png"];
                cell.addOnlineImage.image = image;
                cell.addOnlineImage.hidden = NO;
            }
        }
        
        if (waitListee.hasUnreadMessages){
            cell.contentView.backgroundColor = [UIColor grayColor];
        }else{
            cell.contentView.backgroundColor = [UIColor whiteColor];
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
    
    NSString *url = @"/restaurants/";
    url = [url stringByAppendingString:self.currentRestaurant.restaurantId.stringValue];
    url = [url stringByAppendingString:@"/waitlist"];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:url delegate:self];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self setDataLoaded:FALSE];
    
    NSString *url = @"/restaurants/";
    url = [url stringByAppendingString:self.currentRestaurant.restaurantId.stringValue];
    url = [url stringByAppendingString:@"/waitlist"];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:url delegate:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"newGuest"]){
        UINavigationController *navController = [segue destinationViewController];
        
        if (navController != nil){
            CGAddGuestViewController *addGuestController = (CGAddGuestViewController *)navController.topViewController;

            if (addGuestController != nil){
                addGuestController.totalParties = self.totalParties;
                addGuestController.totalGuests = self.totalGuests;
                addGuestController.estimatedWait = self.estimatedWait;
                
                [addGuestController setWaitListTableViewController:segue.sourceViewController];
                [addGuestController setLoggedInUser:self.loggedInUser];
                [addGuestController setCurrentRestaurant:self.currentRestaurant];
            }
        }
    }else if ([[segue identifier] isEqualToString:@"guestDetail"]){
        CGGuestDetailTableViewController *guestDetailTableViewController = [segue destinationViewController];
        
        if (guestDetailTableViewController != nil){
            [guestDetailTableViewController setSelectedRestaurant:self.currentRestaurant];
            [guestDetailTableViewController setWaitListee:[self.waitListers objectAtIndex:self.tableView.indexPathForSelectedRow.row]];
        }
        
//        self.title = @"WaitList";
        
    }else if ([[segue identifier] isEqualToString:@"accountInfo"]){
        UINavigationController *navController = [segue destinationViewController];
        
        if (navController != nil){
            CGOwnerAccountInfoViewController  *ownerAccountInfoController = (CGOwnerAccountInfoViewController *)navController.topViewController;
            if (ownerAccountInfoController != nil){
                ownerAccountInfoController.loggedInUser = [self loggedInUser];
            }
        }
    }
}

- (IBAction)accountInfo:(id)sender {
//    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)guestDetailControllerDidFinish:(NSArray *)currentWaitList{
    if (currentWaitList){
        [self.waitListers removeAllObjects];
        [self.waitListers addObjectsFromArray:currentWaitList];
        [self.tableView reloadData];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0){
        if (self.unreadMessages){
            UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,15)];
            
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:customView.frame];
            headerLabel.backgroundColor = [UIColor clearColor];
            headerLabel.font = [UIFont systemFontOfSize:10];
            headerLabel.frame = CGRectMake(0,0,300,15);
            
            NSString *unreadMessageString = @"You have ";
            unreadMessageString = [unreadMessageString stringByAppendingString:self.numberOfUnreadMessages.stringValue];
            unreadMessageString = [unreadMessageString stringByAppendingString:@" unread messages."];
            headerLabel.text = unreadMessageString;
            
            headerLabel.textAlignment = UITextAlignmentCenter;
            headerLabel.textColor = [UIColor purpleColor];
            
            [customView addSubview:headerLabel];
            headerLabel = nil;
            
            return customView;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0){
         if (self.unreadMessages){
             return 15;
         }else{
             return 0;
         }
        
    }else{
        return 0;
    }
}



@end
