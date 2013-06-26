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
#import "CGGuestDetailModalViewController.h"
#import "CGMessageModalViewController.h"

@interface CGWaitListTableActionsViewController : UITableViewController <CCAccountViewDelegate, CCAddGuestIPadDelegate, CGGuestDetailModalViewDelegate, CGMessageModalViewDelegate>{
    UIRefreshControl *refreshControl;
    __weak UIPopoverController *addGuestPopover;
    __weak UIPopoverController *accountPopover;
}

@property (nonatomic, strong) NSMutableArray *waitListers;
@property (nonatomic, assign, getter=isDataLoaded) BOOL dataLoaded;
@property (nonatomic, strong) CGRestaurant *currentRestaurant;
@property (nonatomic, strong) CGUser *loggedInUser;

@property (nonatomic, strong) NSNumber *totalParties;
@property (nonatomic, strong) NSNumber *totalGuests;
@property (nonatomic, strong) NSNumber *estimatedWait;

@property (nonatomic, assign) BOOL unreadMessages;
@property (nonatomic, strong) NSNumber *numberOfUnreadMessages;

@property (nonatomic, retain) CGAddGuestIPadTableViewController *addGuestController;
@property (nonatomic, retain) UIPopoverController *addGuestPopover;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (strong, nonatomic) IBOutlet UINavigationItem *navBarItem;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *messageOptionsBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addGuestBarButtonItem;


- (IBAction)showMessageOptions:(id)sender;

- (IBAction)showAccount:(id)sender;
- (IBAction)showAddGuest:(id)sender;

-(void) readMessages;

-(void) refreshMyTableView;
-(void) retrieveWaitListForDisplay;
-(IBAction)accountInfo:(id)sender;

@property (strong, nonatomic) UIButton *waitListHeaderButton;
@property (strong, nonatomic) UIButton *removeHeaderButton;

@property (assign, nonatomic) BOOL showRemoved;

@property (nonatomic, strong) NSString *waitListStatus1;
@property (nonatomic, strong) NSString *waitListStatus2;
@property (nonatomic, strong) NSString *waitListStatus3;
@property (nonatomic, strong) NSString *waitListStatus4;
@property (nonatomic, strong) NSString *waitListStatus5;

@end
