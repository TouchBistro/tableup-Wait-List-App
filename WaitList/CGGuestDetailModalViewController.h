//
//  CGGuestDetailModalViewController.h
//  WaitList
//
//  Created by Padraic Doyle on 12/18/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGRestaurant.h"
#import "CGRestaurantWaitList.h"
#import "CGRestaurantFullWaitList.h"

@protocol CGGuestDetailModalViewDelegate
-(void) guestEdited:(CGRestaurantFullWaitList *) waitList;
@end

@interface CGGuestDetailModalViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate>{
    id <CGGuestDetailModalViewDelegate>  delegate;
}

@property (strong, nonatomic) id <CGGuestDetailModalViewDelegate> delegate;

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

@property (nonatomic, strong) CGRestaurant *selectedRestaurant;
@property (strong, nonatomic) IBOutlet UIImageView *notifyImageView;
@property (strong, nonatomic) IBOutlet UILabel *textTimeSentAgoLabel;
@property (strong, nonatomic) IBOutlet UILabel *visitsLabel;
@property (strong, nonatomic) IBOutlet UILabel *wait1Label;
@property (strong, nonatomic) IBOutlet UILabel *wait2Label;
@property (strong, nonatomic) IBOutlet UILabel *wait3Label;
@property (strong, nonatomic) IBOutlet UILabel *wait4Label;
@property (strong, nonatomic) IBOutlet UILabel *wait5Label;

- (IBAction)close:(id)sender;

- (IBAction)notify:(id)sender;
- (IBAction)remove:(id)sender;
- (IBAction)seated:(id)sender;

@property (strong, nonatomic) CGRestaurantWaitList *waitListee;
//@property (strong, nonatomic) NSMutableArray *currentWaitList;

@end
