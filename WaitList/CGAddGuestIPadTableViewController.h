//
//  CGAddGuestIPadTableViewController.h
//  WaitList
//
//  Created by Padraic Doyle on 12/12/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import "CGRestaurant.h"
#import "CGUser.h"
#import "CGRestaurantFullWaitList.h"

#import <UIKit/UIKit.h>

@protocol CCAddGuestIPadDelegate
- (void) guestAdded:(CGRestaurantFullWaitList *) waitList;
- (void) stopSpinner;
- (void) startSpinner;
@end

@interface CGAddGuestIPadTableViewController : UITableViewController {
    id <CCAddGuestIPadDelegate> delegate;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButtonItem;
- (IBAction)cancel:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *numberInPartyTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *estimatedWaitTextField;
@property (strong, nonatomic) IBOutlet UITextField *tableNumberTextField;
@property (strong, nonatomic) IBOutlet UITextView *permanentNotesTextView;
@property (strong, nonatomic) IBOutlet UITextView *visitNotesTextView;

@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@property (strong, nonatomic) IBOutlet UILabel *visitLabel;
@property (strong, nonatomic) IBOutlet UILabel *longestWaitLabel;

@property (nonatomic, assign, getter=isDataLoaded) BOOL dataLoaded;

@property (nonatomic, strong) CGRestaurant *currentRestaurant;
@property (nonatomic, strong) CGUser *loggedInUser;

@property (nonatomic, strong) NSNumber *guestId;

@property (nonatomic, strong) NSNumber *totalParties;
@property (nonatomic, strong) NSNumber *totalGuests;
@property (nonatomic, strong) NSNumber *estimatedWait;
@property (strong, nonatomic) IBOutlet UIButton *noPhoneNumberButton;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

- (IBAction)noPhoneNumber:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)saveAndText:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIButton *saveAndSendButton;

@property (nonatomic, assign) id <CCAddGuestIPadDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@property (nonatomic, strong) NSString *waitListStatus1;
@property (nonatomic, strong) NSString *waitListStatus2;
@property (nonatomic, strong) NSString *waitListStatus3;
@property (nonatomic, strong) NSString *waitListStatus4;
@property (nonatomic, strong) NSString *waitListStatus5;

@property (nonatomic, strong) NSMutableArray *waitListStatuses;

@property (nonatomic, strong) NSNumber *statusNumber;


@end
