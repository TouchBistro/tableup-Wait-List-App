//
//  CGUserDetailTableViewController.h
//  WaitList
//
//  Created by Padraic Doyle on 10/9/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGRestaurantWaitList.h"
#import "CGRestaurant.h"

@protocol CGGuestDetailTableViewControllerDelegate;

@interface CGGuestDetailTableViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *userActionView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *numberInPartyTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *estimatedWaitTextField;
@property (strong, nonatomic) IBOutlet UITextView *permanentNotesTextView;
@property (strong, nonatomic) IBOutlet UITextView *visitNotesTextView;

@property (strong, nonatomic) IBOutlet UILabel *timeAgoLabel;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, assign) id<CGGuestDetailTableViewControllerDelegate> delegate;

@property (nonatomic, strong) CGRestaurant *selectedRestaurant;
@property (strong, nonatomic) IBOutlet UIImageView *notifyImageView;
@property (strong, nonatomic) IBOutlet UILabel *textTimeSentAgoLabel;


- (IBAction)notify:(id)sender;
- (IBAction)remove:(id)sender;
- (IBAction)seated:(id)sender;

@property (strong, nonatomic) CGRestaurantWaitList *waitListee;
@property (strong, nonatomic) NSMutableArray *currentWaitList;

@end


@protocol CGGuestDetailTableViewControllerDelegate

- (void)guestDetailControllerDidFinish:(NSArray *)currentWaitList;

@end


