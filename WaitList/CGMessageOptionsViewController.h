//
//  CGMessageOptionsViewController.h
//  WaitList
//
//  Created by Padraic Doyle on 2/8/13.
//  Copyright (c) 2013 Padraic Doyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "CGRestaurant.h"

@interface CGMessageOptionsViewController : UIViewController <RKObjectLoaderDelegate, UITextViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) CGRestaurant *currentRestaurant;

- (IBAction)cancel:(id)sender;
- (IBAction)allowSwitch:(id)sender;
- (IBAction)onlineReservationsSwitch:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *welcomeCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *tableReadyCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *waitListPageCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *preOrderCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *feedbackCountLabel;

@property (strong, nonatomic) IBOutlet UITextView *welcomeTextView;
@property (strong, nonatomic) IBOutlet UITextView *tableReadyTextView;
@property (strong, nonatomic) IBOutlet UITextView *waitListPageTextView;
@property (strong, nonatomic) IBOutlet UITextView *preOrderTextView;
@property (strong, nonatomic) IBOutlet UITextView *feedbackTextView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (assign, nonatomic) BOOL onlineReservation;
@property (assign, nonatomic) BOOL allowMessages;
@property (assign, nonatomic) BOOL allowPreOrdering;

@property (strong, nonatomic) IBOutlet UISwitch *allowPreOrderingSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *allowMessagesSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *onlineReservationsSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *feedbackSwitch;

@property (strong, nonatomic) IBOutlet UIButton *saveButton;

- (IBAction)save:(id)sender;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
- (IBAction)managePreOrder:(id)sender;


@property (strong, nonatomic) IBOutlet UITextField *waitListStatus1;
@property (strong, nonatomic) IBOutlet UITextField *waitListStatus2;
@property (strong, nonatomic) IBOutlet UITextField *waitListStatus3;
@property (strong, nonatomic) IBOutlet UITextField *waitListStatus4;
@property (strong, nonatomic) IBOutlet UITextField *waitListStatus5;


@end
