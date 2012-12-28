//
//  CGWaitListTableActionsViewController.m
//  WaitList
//
//  Created by Padraic Doyle on 12/11/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import "CGWaitListTableActionsViewController.h"
#import "CGRestaurantWaitList.h"
#import "CGRestaurantWaitListCell.h"
#import "CGAddGuestViewController.h"
#import "CGGuestDetailTableViewController.h"
#import "CGOwnerAccountInfoViewController.h"
#import "CGRestaurantFullWaitList.h"
#import "CGRestaurantWaitListActionsCell.h"
#import "CGGuestDetailModalViewController.h"
#import "CGUtils.h"

#import <RestKit/RestKit.h>

@interface CGWaitListTableActionsViewController ()

@end

@implementation CGWaitListTableActionsViewController

@synthesize waitListers;

@synthesize totalGuests;
@synthesize totalParties;
@synthesize estimatedWait;
@synthesize currentRestaurant;


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
    self.currentRestaurant = [[CGRestaurant alloc] init];
    self.currentRestaurant = [self.loggedInUser.ownedRestaurants objectAtIndex:0];//[[NSNumber alloc] initWithInt:loggedInUser.ownedRestaurants];
    
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
    
    if (self.totalParties && self.totalGuests && self.estimatedWait){
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
    }
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        UIImage *navBarImg = [UIImage imageNamed:@"appHeaderiPad.png"];
        [self.navigationController.navigationBar setBackgroundImage:navBarImg forBarMetrics:UIBarMetricsDefault];
    }
    
}

- (void) notifyButtonTouchDownRepeat:(id)sender event:(UIEvent *)event
{
    CGRestaurantWaitListActionsCell *cell = (CGRestaurantWaitListActionsCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    
    UITouch *touch = [[event allTouches] anyObject];
    if(touch.tapCount == 2)
    {
        if (cell && indexPath){
            CGRestaurantWaitList *waitListee = [self.waitListers objectAtIndex:indexPath.row];
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            
            NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserId];
            NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
            
            NSString *fbUid = [[NSUserDefaults standardUserDefaults] objectForKey:kFbUid];
            if (fbUid != nil){
                [params setObject:fbUid forKey:@"fbUid"];
            }
            
            [params setObject:userId forKey:@"userId"];
            [params setObject:password forKey:@"password"];
            
            NSString *urlString = @"/restaurants/";
            urlString = [urlString stringByAppendingString:self.currentRestaurant.restaurantId.stringValue];
            urlString = [urlString stringByAppendingString:@"/waitlist/"];
            urlString = [urlString stringByAppendingString:waitListee.waitListId.stringValue];
            urlString = [urlString stringByAppendingString:@"/text"];
            
            if (cell.notifyImage.hidden == YES){
                NSString *timeSinceTextSent = @"0 mins ago";
                cell.textSentTimeAgo.text = timeSinceTextSent;
                cell.notifyImage.hidden = NO;
            }

            
            [[RKClient sharedClient] post:urlString params:params delegate:self];
            
        }
    }
}

- (void) seatedButtonTouchDownRepeat:(id)sender event:(UIEvent *)event
{
    CGRestaurantWaitListActionsCell *cell = (CGRestaurantWaitListActionsCell *)[sender superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    
    UITouch *touch = [[event allTouches] anyObject];
    if(touch.tapCount == 2)
    {
        if (cell && indexPath){
            CGRestaurantWaitList *waitListee = [self.waitListers objectAtIndex:indexPath.row];
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            
            NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserId];
            NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
            
            NSString *fbUid = [[NSUserDefaults standardUserDefaults] objectForKey:kFbUid];
            if (fbUid != nil){
                [params setObject:fbUid forKey:@"fbUid"];
            }
            
            [params setObject:userId forKey:@"userId"];
            [params setObject:password forKey:@"password"];
            
            NSString *urlString = @"/restaurants/";
            urlString = [urlString stringByAppendingString:self.currentRestaurant.restaurantId.stringValue];
            urlString = [urlString stringByAppendingString:@"/waitlist/"];
            urlString = [urlString stringByAppendingString:waitListee.waitListId.stringValue];
            urlString = [urlString stringByAppendingString:@"/seat"];
            
            [self.tableView beginUpdates];
            [self.waitListers removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath, nil]  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            
            [[RKClient sharedClient] post:urlString params:params delegate:self];
            
        }
    }
}

- (void) removeButtonTouchDownRepeat:(id)sender event:(UIEvent *)event
{
    CGRestaurantWaitListActionsCell *cell = (CGRestaurantWaitListActionsCell *)[sender superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    
    UITouch *touch = [[event allTouches] anyObject];
    if(touch.tapCount == 2)
    {
        if (cell && indexPath){
            CGRestaurantWaitList *waitListee = [self.waitListers objectAtIndex:indexPath.row];
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            
            NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserId];
            NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
            
            NSString *fbUid = [[NSUserDefaults standardUserDefaults] objectForKey:kFbUid];
            if (fbUid != nil){
                [params setObject:fbUid forKey:@"fbUid"];
            }
            
            [params setObject:userId forKey:@"userId"];
            [params setObject:password forKey:@"password"];
            
            NSString *urlString = @"/restaurants/";
            urlString = [urlString stringByAppendingString:self.currentRestaurant.restaurantId.stringValue];
            urlString = [urlString stringByAppendingString:@"/waitlist/"];
            urlString = [urlString stringByAppendingString:waitListee.waitListId.stringValue];
            urlString = [urlString stringByAppendingString:@"/remove"];
            
            
            [self.tableView beginUpdates];
            [self.waitListers removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath, nil]  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            
            
            [[RKClient sharedClient] post:urlString params:params delegate:self];
            
        }
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
    static NSString *CellIdentifier = @"inVenueActionCell";
    CGRestaurantWaitList *waitListee = [self.waitListers objectAtIndex:indexPath.row];
    
    CGRestaurantWaitListActionsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil){
        cell = [[CGRestaurantWaitListActionsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (waitListee != nil){
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
        
        
        cell.addOnlineImageView.hidden = YES;
        cell.tableNumberLabel.hidden = YES;
        
        if (waitListee.tableNumber != nil){
            cell.tableNumberLabel.hidden = NO;
            cell.tableNumberLabel.text = waitListee.tableNumber;
            cell.tableNumberLabel.textColor = [UIColor colorWithRed:173.0/255.0 green:98.0/255.0 blue:137.0/255.0 alpha:1];
            cell.tableNumberLabel.font = [UIFont boldSystemFontOfSize:10.0];
        }
        
        if (waitListee.reserveOnline){
            UIImage *image = [UIImage imageNamed:@"addOnline.png"];
            cell.addOnlineImageView.image = image;
            cell.addOnlineImageView.hidden = NO;
        }
        
        if (waitListee.guest.phoneNumber == nil){
            UIImage *image = [UIImage imageNamed:@"noPhoneRed.png"];
            cell.addOnlineImageView.image = image;
            cell.addOnlineImageView.hidden = NO;
            
            cell.notifyButton.enabled = NO;
        }
        
        
        [cell.notifyButton addTarget:self action:@selector(notifyButtonTouchDownRepeat:event:) forControlEvents:UIControlEventTouchDownRepeat];
        [cell.seatedButton addTarget:self action:@selector(seatedButtonTouchDownRepeat:event:) forControlEvents:UIControlEventTouchDownRepeat];
        [cell.removeButton addTarget:self action:@selector(removeButtonTouchDownRepeat:event:) forControlEvents:UIControlEventTouchDownRepeat];
    }
    
    return cell;
}


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

- (void)restaurantSelected:(CGRestaurant *)restaurant{
    self.currentRestaurant = restaurant;
//    [self.tableView reloadData];
    
    [self setDataLoaded:FALSE];
    
    NSString *url = @"/restaurants/";
    url = [url stringByAppendingString:self.currentRestaurant.restaurantId.stringValue];
    url = [url stringByAppendingString:@"/waitlist"];
    
    if (accountPopover){
        [accountPopover dismissPopoverAnimated:YES];
    }
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:url delegate:self];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"accountView"]){
        CGAccountViewController *accountViewController = [segue destinationViewController];
        accountViewController.delegate = self;
        accountViewController.restaurants = self.loggedInUser.ownedRestaurants;
        accountViewController.currentRestaurant = self.currentRestaurant;
        
        accountPopover =  [(UIStoryboardPopoverSegue *)segue popoverController];
    }
    else if ([[segue identifier] isEqualToString:@"addGuest"]){
        CGAddGuestIPadTableViewController *addGuestController = [segue destinationViewController];
        
        if (addGuestController != nil){
            addGuestController.totalParties = self.totalParties;
            addGuestController.totalGuests = self.totalGuests;
            addGuestController.estimatedWait = self.estimatedWait;
            addGuestController.delegate = self;
            
            [addGuestController setLoggedInUser:self.loggedInUser];
            [addGuestController setCurrentRestaurant:self.currentRestaurant];
            
            addGuestPopover =  [(UIStoryboardPopoverSegue *)segue popoverController];
        }
    }else if ([[segue identifier] isEqualToString:@"guestDetailSegue"]){
        UINavigationController *navController = [segue destinationViewController];
        CGGuestDetailModalViewController *guestDetail = (CGGuestDetailModalViewController *)navController.topViewController;
        
        if (guestDetail != nil){
            [guestDetail setSelectedRestaurant:self.currentRestaurant];
            [guestDetail setWaitListee:[self.waitListers objectAtIndex:self.tableView.indexPathForSelectedRow.row]];
            guestDetail.delegate = self;
        }
    }
}

- (void) guestAdded:(CGRestaurantFullWaitList *) waitList{
    [self.waitListers removeAllObjects];
    [self.waitListers addObjectsFromArray:waitList.waitListers];
    [self.tableView reloadData];
    
    if (addGuestPopover){
        [addGuestPopover dismissPopoverAnimated:YES];
    }

}

-(void) guestEdited:(CGRestaurantFullWaitList *) waitList{
    [self.waitListers removeAllObjects];
    [self.waitListers addObjectsFromArray:waitList.waitListers];
    [self.tableView reloadData];
}

- (void)logOut {
    if (accountPopover){
        [accountPopover dismissPopoverAnimated:YES];
    }
    
    [self setLoggedInUser:nil];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsUserId];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPassword];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsUsername];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kFbUid];
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
