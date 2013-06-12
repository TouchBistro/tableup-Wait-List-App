//
//  CGMessageOptionsModalViewController.h
//  WaitList
//
//  Created by Padraic Doyle on 2/12/13.
//  Copyright (c) 2013 Padraic Doyle. All rights reserved.
//

#import "CGRestaurant.h"
#import <UIKit/UIKit.h>

@interface CGMessageOptionsModalViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) CGRestaurant *currentRestaurant;

- (IBAction)allowSwitch:(id)sender;
- (IBAction)onlineReservationsSwitch:(id)sender;
- (IBAction)close:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *welcomeCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *tableReadyCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *waitListPageCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *preOrderCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *feedbackLabel;


@property (strong, nonatomic) IBOutlet UITextView *welcomeTextView;
@property (strong, nonatomic) IBOutlet UITextView *tableReadyTextView;
@property (strong, nonatomic) IBOutlet UITextView *waitListPageTextView;
@property (strong, nonatomic) IBOutlet UITextView *preOrderTextView;
@property (strong, nonatomic) IBOutlet UITextView *feedbackTextView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (assign, nonatomic) BOOL onlineReservation;
@property (assign, nonatomic) BOOL allowMessages;

@property (strong, nonatomic) IBOutlet UISwitch *allowMessagesSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *preOrderSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *feedbackSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *onlineReservationsSwitch;


@property (strong, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)save:(id)sender;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
- (IBAction)managePreOrder:(id)sender;

@end
