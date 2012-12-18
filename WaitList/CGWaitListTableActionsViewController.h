//
//  CGWaitListTableActionsViewController.h
//  WaitList
//
//  Created by Padraic Doyle on 12/11/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGRestaurant.h"
#import "CGAccountViewController.h"
#import "CGUser.h"
#import "CGAddGuestIPadTableViewController.h"

@interface CGWaitListTableActionsViewController : UITableViewController <CCAccountViewDelegate, CCAddGuestIPadDelegate>{
    UIRefreshControl *refreshControl;
    __weak UIPopoverController *playAllPopover;
}

@property (nonatomic, strong) NSMutableArray *waitListers;
@property (nonatomic, assign, getter=isDataLoaded) BOOL dataLoaded;
@property (nonatomic, strong) CGRestaurant *currentRestaurant;
@property (nonatomic, strong) CGUser *loggedInUser;

@property (nonatomic, strong) NSNumber *totalParties;
@property (nonatomic, strong) NSNumber *totalGuests;
@property (nonatomic, strong) NSNumber *estimatedWait;

@property (nonatomic, retain) CGAddGuestIPadTableViewController *addGuestController;
@property (nonatomic, retain) UIPopoverController *addGuestPopover;

- (IBAction)showAccount:(id)sender;
- (IBAction)showAddGuest:(id)sender;

-(void) refreshMyTableView;
-(void) retrieveWaitListForDisplay;
-(IBAction)accountInfo:(id)sender;


@end
