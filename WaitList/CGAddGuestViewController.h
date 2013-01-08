//
//  CGAddGuestViewController.h
//  WaitList
//
//  Created by Padraic Doyle on 10/9/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "CGRestaurant.h"
#import "CGUser.h"
#import "CGWaitListTableViewController.h"

@protocol CGAddGuestViewDelete
-(void) guestAdded: (CGRestaurantGuest *) guest;
@end

@interface CGAddGuestViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate>


@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButtonItem;
- (IBAction)cancel:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextField;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *numberInPartyTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *estimatedWaitTextField;
@property (strong, nonatomic) IBOutlet UITextField *tableNumberField;

@property (strong, nonatomic) IBOutlet UITextView *permanentNotesTextView;
@property (strong, nonatomic) IBOutlet UITextView *visitNotesTextView;


@property (strong, nonatomic) CGWaitListTableViewController *waitListTableViewController;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (strong, nonatomic) IBOutlet UILabel *visitLabel;
@property (strong, nonatomic) IBOutlet UILabel *longestWaitLabel;

@property (nonatomic, assign, getter=isDataLoaded) BOOL dataLoaded;

@property (nonatomic, strong) CGRestaurant *currentRestaurant;
@property (nonatomic, strong) CGUser *loggedInUser;

@property (nonatomic, strong) NSNumber *guestId;

@property (nonatomic, strong) NSNumber *totalParties;
@property (nonatomic, strong) NSNumber *totalGuests;
@property (nonatomic, strong) NSNumber *estimatedWait;


- (IBAction)save:(id)sender;
- (IBAction)saveAndText:(id)sender;
- (IBAction)noPhoneNumber:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIButton *saveAndSendButton;
@property (strong, nonatomic) IBOutlet UIButton *noPhoneNumberButton;



@end
