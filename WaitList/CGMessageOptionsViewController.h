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

@interface CGMessageOptionsViewController : UIViewController <RKObjectLoaderDelegate, UITextViewDelegate>

@property (strong, nonatomic) CGRestaurant *currentRestaurant;

- (IBAction)cancel:(id)sender;
- (IBAction)allowSwitch:(id)sender;
- (IBAction)onlineReservationsSwitch:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *welcomeCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *tableReadyCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *waitListPageCountLabel;

@property (strong, nonatomic) IBOutlet UITextView *welcomeTextView;
@property (strong, nonatomic) IBOutlet UITextView *tableReadyTextView;
@property (strong, nonatomic) IBOutlet UITextView *waitListPageTextView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (assign, nonatomic) BOOL onlineReservation;
@property (assign, nonatomic) BOOL allowMessages;

@property (strong, nonatomic) IBOutlet UISwitch *allowMessagesSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *onlineReservationsSwitch;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)save:(id)sender;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
- (IBAction)managePreOrder:(id)sender;

@end
