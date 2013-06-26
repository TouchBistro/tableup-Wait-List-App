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

#import <QuartzCore/QuartzCore.h>
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
    self.showRemoved = NO;
    
    NSString *url = @"/restaurants/";
    url = [url stringByAppendingString:self.currentRestaurant.restaurantId.stringValue];
    url = [url stringByAppendingString:@"/waitlist"];
    
    if (self.showRemoved){
        url = [url stringByAppendingString:@"/removed"];
    }
    
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
        [self addTopHeader];
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
        
        self.waitListStatus1 = fullWaitList.waitListStatus1;
        self.waitListStatus2 = fullWaitList.waitListStatus2;
        self.waitListStatus3 = fullWaitList.waitListStatus3;
        self.waitListStatus4 = fullWaitList.waitListStatus4;
        self.waitListStatus5 = fullWaitList.waitListStatus5;
        
        [self addTopHeader];
        
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
        cell.statusImageView.hidden = YES;
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
        
        if (waitListee.hasPreOrderItems){
            cell.partySizeImageView.image = [UIImage imageNamed:@"partySizePreOrder.png"];
        }else{
            cell.partySizeImageView.image = [UIImage imageNamed:@"partySize.png"];
        }
        
        if (waitListee.hasUnreadMessages){
            cell.contentView.backgroundColor = [UIColor colorWithRed:227.0/255.0 green:201.0/255.0 blue:214.0/255.0 alpha:1.0];
        }else{
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        
        if (waitListee.statusNumber){
            cell.statusImageView.hidden = NO;
            if ([waitListee.statusNumber intValue] == 1){
                UIImage *image = [UIImage imageNamed:@"statusRed"];
                cell.statusImageView.image = image;
            }else if ([waitListee.statusNumber intValue] == 2){
                UIImage *image = [UIImage imageNamed:@"statusBlue"];
                cell.statusImageView.image = image;
            }else if ([waitListee.statusNumber intValue] == 3){
                UIImage *image = [UIImage imageNamed:@"statusOrange"];
                cell.statusImageView.image = image;
            }else if ([waitListee.statusNumber intValue] == 4){
                UIImage *image = [UIImage imageNamed:@"statusYellow"];
                cell.statusImageView.image = image;
            }else if ([waitListee.statusNumber intValue] == 5){
                UIImage *image = [UIImage imageNamed:@"statusBlack"];
                cell.statusImageView.image = image;
            }
        }
        
        CALayer *bottomBorder = [CALayer layer];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = cell.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f].CGColor, (id)[UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0f].CGColor, nil];
        [cell.layer insertSublayer:gradient atIndex:0];
        
		bottomBorder.backgroundColor = [UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0f].CGColor;
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
    
    if (self.showRemoved){
        url = [url stringByAppendingString:@"/removed"];
    }
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:url delegate:self];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self setDataLoaded:FALSE];
    
    NSString *url = @"/restaurants/";
    url = [url stringByAppendingString:self.currentRestaurant.restaurantId.stringValue];
    url = [url stringByAppendingString:@"/waitlist"];
    
    if (self.showRemoved){
        url = [url stringByAppendingString:@"/removed"];
    }
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:url delegate:self];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:300.0 target:self selector:@selector(refreshMyTableView) userInfo:nil repeats:YES];
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
                
                addGuestController.waitListStatus1 = self.waitListStatus1;
                addGuestController.waitListStatus2 = self.waitListStatus2;
                addGuestController.waitListStatus3 = self.waitListStatus3;
                addGuestController.waitListStatus4 = self.waitListStatus4;
                addGuestController.waitListStatus5 = self.waitListStatus5;
                
                [addGuestController setWaitListTableViewController:segue.sourceViewController];
                [addGuestController setLoggedInUser:self.loggedInUser];
                [addGuestController setCurrentRestaurant:self.currentRestaurant];
            }
        }
    }else if ([[segue identifier] isEqualToString:@"guestDetail"]){
        CGGuestDetailTableViewController *guestDetailTableViewController = [segue destinationViewController];
        
        if (guestDetailTableViewController != nil){
            guestDetailTableViewController.waitListStatus1 = self.waitListStatus1;
            guestDetailTableViewController.waitListStatus2 = self.waitListStatus2;
            guestDetailTableViewController.waitListStatus3 = self.waitListStatus3;
            guestDetailTableViewController.waitListStatus4 = self.waitListStatus4;
            guestDetailTableViewController.waitListStatus5 = self.waitListStatus5;
            
            [guestDetailTableViewController setSelectedRestaurant:self.currentRestaurant];
            [guestDetailTableViewController setWaitListee:[self.waitListers objectAtIndex:self.tableView.indexPathForSelectedRow.row]];
            guestDetailTableViewController.waitListerHasBeenRemoved = self.showRemoved;
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
            customView.backgroundColor = [UIColor colorWithRed:227.0/255.0 green:201.0/255.0 blue:214.0/255.0 alpha:1.0];
            
            CALayer *bottomBorder = [CALayer layer];
            bottomBorder.frame = CGRectMake(0.0f, customView.frame.size.height - 1, customView.frame.size.width, 1.0f);
            bottomBorder.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:149.0/255.0 blue:175.0/255.0 alpha:1.0].CGColor;
            
            CALayer *topBorder = [CALayer layer];
            topBorder.frame = CGRectMake(0.0f, 0, customView.frame.size.width, 1.0f);
            topBorder.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:149.0/255.0 blue:175.0/255.0 alpha:1.0].CGColor;
            
            [customView.layer addSublayer:bottomBorder];
            [customView.layer addSublayer:topBorder];
            
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:customView.frame];
            headerLabel.backgroundColor = [UIColor clearColor];
//            headerLabel.font = [UIFont systemFontOfSize:10];
            headerLabel.frame = CGRectMake(0,0,self.view.frame.size.width,15);
            headerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
            
            NSString *unreadMessageString = @"You have ";
            unreadMessageString = [unreadMessageString stringByAppendingString:self.numberOfUnreadMessages.stringValue];
            unreadMessageString = [unreadMessageString stringByAppendingString:@" unread messages."];
            headerLabel.text = unreadMessageString;
            
            headerLabel.textAlignment = UITextAlignmentCenter;
            headerLabel.textColor = [UIColor colorWithRed:99.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1.0];
            
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

-(void) addTopHeader {
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.tableView.bounds.size.width,60)];
    
    NSString *label = @"Parties: ";
    label = [label stringByAppendingString:self.totalParties.stringValue];
    label = [label stringByAppendingString:@" / Guests: "];
    label = [label stringByAppendingString:self.totalGuests.stringValue];
    label = [label stringByAppendingString:@" / Estimated Wait: "];
    label = [label stringByAppendingString:self.estimatedWait.stringValue];
    label = [label stringByAppendingString:@" mins"];
    
    self.waitListHeaderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.removeHeaderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [self.waitListHeaderButton addTarget:self
                                  action:@selector(waitListHeaderButtonPressed:)
                        forControlEvents:UIControlEventTouchDown];
    [self.waitListHeaderButton setTitle:@"View WaitList" forState:UIControlStateNormal];
    self.waitListHeaderButton.titleLabel.font = [UIFont boldSystemFontOfSize:10.0];
    [self.waitListHeaderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.waitListHeaderButton.frame = CGRectMake(40, 5, 120.0, 40.0);
    
    [self.removeHeaderButton addTarget:self
                                action:@selector(removeHeaderButtonPressed:)
                      forControlEvents:UIControlEventTouchDown];
    [self.removeHeaderButton setTitle:@"Seated & Removed" forState:UIControlStateNormal];
    self.removeHeaderButton.titleLabel.font = [UIFont boldSystemFontOfSize:10.0];
    [self.removeHeaderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.removeHeaderButton.frame = CGRectMake(160, 5, 120.0, 40.0);
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,35,self.tableView.bounds.size.width,30)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:10];
    headerLabel.text =  label;
    headerLabel.textColor = [UIColor colorWithRed:99.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1.0];
    headerLabel.shadowColor = [UIColor whiteColor];
    headerLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
    headerLabel.textAlignment = UITextAlignmentCenter;
    
    [customView addSubview:headerLabel];
    
    if (self.showRemoved){
        UIImage *waitListBackground = [UIImage imageNamed:@"buttonBackgroundGreyLEFT.png"];
        UIImage *removeBackground = [UIImage imageNamed:@"buttonBackgroundPinkRIGHT.png"];
        
        UIImage *newImage = [waitListBackground stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
        
        [self.waitListHeaderButton setBackgroundImage:newImage forState:UIControlStateNormal];
        [self.removeHeaderButton setBackgroundImage:removeBackground forState:UIControlStateNormal];
        
        [self.waitListHeaderButton setTitleColor:[UIColor colorWithRed:99.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.removeHeaderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        UIImage *waitListBackground = [UIImage imageNamed:@"buttonBackgroundPinkLEFT.png"];
        UIImage *removeBackground = [UIImage imageNamed:@"buttonBackgroundGreyRIGHT.png"];
        UIImage *newImage = [waitListBackground stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
        
        [self.waitListHeaderButton setBackgroundImage:newImage forState:UIControlStateNormal];
        [self.removeHeaderButton setBackgroundImage:removeBackground forState:UIControlStateNormal];
        
        [self.waitListHeaderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.removeHeaderButton setTitleColor:[UIColor colorWithRed:99.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    
    [customView addSubview:self.removeHeaderButton];
    [customView addSubview:self.waitListHeaderButton];
    
    self.tableView.tableHeaderView = customView;
}

-(void) waitListHeaderButtonPressed: (id) sender {
    UIImage *waitListBackground = [UIImage imageNamed:@"buttonBackgroundPinkLEFT.png"];
    UIImage *removeBackground = [UIImage imageNamed:@"buttonBackgroundGreyRIGHT.png"];
    UIImage *newImage = [waitListBackground stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];

    [self.waitListHeaderButton setBackgroundImage:newImage forState:UIControlStateNormal];
    [self.removeHeaderButton setBackgroundImage:removeBackground forState:UIControlStateNormal];
    
    [self.waitListHeaderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.removeHeaderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.showRemoved = NO;
    
    [self refreshMyTableView];
}

-(void) removeHeaderButtonPressed: (id) sender {
    UIImage *waitListBackground = [UIImage imageNamed:@"buttonBackgroundGreyLEFT.png"];
    UIImage *removeBackground = [UIImage imageNamed:@"buttonBackgroundPinkRIGHT.png"];
    
    UIImage *newImage = [waitListBackground stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
    
    [self.waitListHeaderButton setBackgroundImage:newImage forState:UIControlStateNormal];
    [self.removeHeaderButton setBackgroundImage:removeBackground forState:UIControlStateNormal];
    
    [self.waitListHeaderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.removeHeaderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.showRemoved = YES;
    
    [self refreshMyTableView];
}



@end
