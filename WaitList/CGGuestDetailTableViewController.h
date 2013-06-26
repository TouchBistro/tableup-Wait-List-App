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
#import <RestKit/RestKit.h>

@protocol CGGuestDetailTableViewControllerDelegate;

@interface CGGuestDetailTableViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate, RKObjectLoaderDelegate, RKRequestDelegate>

@property (strong, nonatomic) IBOutlet UIView *userActionView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextField;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *numberInPartyTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *tableNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *estimatedWaitTextField;
@property (strong, nonatomic) IBOutlet UITextView *permanentNotesTextView;
@property (strong, nonatomic) IBOutlet UITextView *visitNotesTextView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *messageBarButtonItem;

@property (strong, nonatomic) IBOutlet UILabel *timeAgoLabel;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, assign) id<CGGuestDetailTableViewControllerDelegate> delegate;

@property (nonatomic, strong) CGRestaurant *selectedRestaurant;
@property (strong, nonatomic) IBOutlet UIImageView *notifyImageView;
@property (strong, nonatomic) IBOutlet UILabel *textTimeSentAgoLabel;
@property (strong, nonatomic) IBOutlet UILabel *visitsLabel;
@property (strong, nonatomic) IBOutlet UILabel *wait1Label;
@property (strong, nonatomic) IBOutlet UILabel *wait2Label;
@property (strong, nonatomic) IBOutlet UILabel *wait3Label;
@property (strong, nonatomic) IBOutlet UILabel *wait4Label;
@property (strong, nonatomic) IBOutlet UILabel *wait5Label;

@property (strong, nonatomic) IBOutlet UIButton *notifyButton;
@property (strong, nonatomic) IBOutlet UIButton *seatedButton;
@property (strong, nonatomic) IBOutlet UIButton *removeButton;
@property (strong, nonatomic) IBOutlet UIButton *addPartyButton;


@property (assign, nonatomic) BOOL waitListerHasBeenRemoved;


- (IBAction)addPartyToWaitList:(id)sender;
- (IBAction)notify:(id)sender;
- (IBAction)remove:(id)sender;
- (IBAction)seated:(id)sender;

- (void)prepareForSave;
- (void)returnFromSave;

@property (strong, nonatomic) CGRestaurantWaitList *waitListee;
@property (strong, nonatomic) NSMutableArray *currentWaitList;

@property (nonatomic, strong) NSString *waitListStatus1;
@property (nonatomic, strong) NSString *waitListStatus2;
@property (nonatomic, strong) NSString *waitListStatus3;
@property (nonatomic, strong) NSString *waitListStatus4;
@property (nonatomic, strong) NSString *waitListStatus5;

@property (nonatomic, strong) NSMutableArray *waitListStatuses;

@property (nonatomic, strong) NSNumber *statusNumber;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@end


@protocol CGGuestDetailTableViewControllerDelegate

- (void)guestDetailControllerDidFinish:(NSArray *)currentWaitList;

@end


