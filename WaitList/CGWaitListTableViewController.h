//
//  CGWaitListTableViewController.h
//  WaitList
//
//  Created by Padraic Doyle on 10/19/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGGuestDetailTableViewController.h"
#import "CGRestaurant.h"
#import "CGUser.h"

@interface CGWaitListTableViewController : UITableViewController <CGGuestDetailTableViewControllerDelegate>{
    UIRefreshControl *refreshControl;
    
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

@property (strong, nonatomic) UIButton *waitListHeaderButton;
@property (strong, nonatomic) UIButton *removeHeaderButton;

-(void) refreshMyTableView;
-(void) retrieveWaitListForDisplay;

- (IBAction)accountInfo:(id)sender;

- (void)guestDetailControllerDidFinish:(NSArray *)currentWaitList;


@end
