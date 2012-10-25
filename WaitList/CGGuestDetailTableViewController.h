//
//  CGUserDetailTableViewController.h
//  WaitList
//
//  Created by Padraic Doyle on 10/9/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGRestaurantWaitList.h"

@protocol CGGuestDetailTableViewControllerDelegate;

@interface CGGuestDetailTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UIView *userActionView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *numberInPartyTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *estimatedWaitTextField;
@property (strong, nonatomic) IBOutlet UITextField *visitNotesTextField;
@property (strong, nonatomic) IBOutlet UITextField *permanentNotesTextField;

@property (strong, nonatomic) IBOutlet UILabel *timeAgoLabel;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, assign) id<CGGuestDetailTableViewControllerDelegate> delegate;


- (IBAction)notify:(id)sender;
- (IBAction)remove:(id)sender;
- (IBAction)seated:(id)sender;

@property (strong, nonatomic) CGRestaurantWaitList *waitListee;
@property (strong, nonatomic) NSMutableArray *currentWaitList;

@end


@protocol CGGuestDetailTableViewControllerDelegate

- (void)guestDetailControllerDidFinish:(NSArray *)currentWaitList;

@end


