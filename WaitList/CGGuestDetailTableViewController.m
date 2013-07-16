//
//  CGUserDetailTableViewController.m
//  WaitList
//
//  Created by Padraic Doyle on 10/9/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import "CGGuestDetailTableViewController.h"
#import "CGRestaurantGuest.h"
#import "CGWaitListTableViewController.h"
#import "CGUtils.h"
#import "CGRestaurantWaitListWaitTime.h"
#import "CGMessageViewController.h"
#import "ActionSheetPicker.h"

#import <RestKit/RestKit.h>

@interface CGGuestDetailTableViewController ()

@end

@implementation CGGuestDetailTableViewController

@synthesize userActionView;
@synthesize tableView;

@synthesize phoneNumberTextField;
@synthesize nameTextField;
@synthesize numberInPartyTextField;
@synthesize emailTextField;
@synthesize estimatedWaitTextField;
@synthesize tableNumberTextField;
@synthesize visitNotesTextView;
@synthesize timeAgoLabel;

@synthesize waitListee;
@synthesize currentWaitList;

@synthesize delegate;

@synthesize activityView;

@synthesize notifyImageView;
@synthesize textTimeSentAgoLabel;

@synthesize permanentNotesTextView;

@synthesize visitsLabel;
@synthesize wait1Label;
@synthesize wait2Label;
@synthesize wait3Label;
@synthesize wait4Label;
@synthesize wait5Label;

@synthesize messageBarButtonItem;

- (void)viewDidLoad
{
    self.visitsLabel.hidden = YES;
    self.wait1Label.hidden = YES;
    self.wait2Label.hidden = YES;
    self.wait3Label.hidden = YES;
    self.wait4Label.hidden = YES;
    self.wait5Label.hidden = YES;
    
    if (self.waitListee && self.waitListee.guest){
        
        if (self.waitListee.guest.phoneNumber){
            self.phoneNumberTextField.text = self.waitListee.guest.phoneNumber;
        }else{
            self.phoneNumberTextField.text = @"Phone number not provided.";
            self.phoneNumberTextField.textColor = [UIColor lightGrayColor];
            self.phoneNumberLabel.textColor = [UIColor lightGrayColor];
            
            self.messageBarButtonItem.enabled = NO;
            self.notifyButton.enabled = NO;
            self.phoneNumberTextField.enabled = NO;
            
        }
        self.nameTextField.text = self.waitListee.guest.name;
        self.emailTextField.text = self.waitListee.guest.email;
        self.estimatedWaitTextField.text = self.waitListee.estimatedWait ? self.waitListee.estimatedWait.stringValue : nil;
        self.tableNumberTextField.text = self.waitListee.tableNumber;
        self.visitNotesTextView.text = self.waitListee.visitNotes;
        self.permanentNotesTextView.text = self.waitListee.guest.permanentNotes;
        
        self.numberInPartyTextField.text = self.waitListee.numberInParty.stringValue;
        
        NSString *timeAgoString = self.waitListee.estimatedWait.stringValue;
        timeAgoString = [timeAgoString stringByAppendingString:@" mins ("];
        timeAgoString = [timeAgoString stringByAppendingString:self.waitListee.timeOnWaitList.stringValue];
        timeAgoString = [timeAgoString stringByAppendingString:@")"];
        
        self.timeAgoLabel.text = timeAgoString;
        
        if (waitListee.timeSinceTextSent != nil){
            NSString *timeSinceTextSent = waitListee.timeSinceTextSent.stringValue;
            timeSinceTextSent = [timeSinceTextSent stringByAppendingString:@" mins ago"];
            
            self.textTimeSentAgoLabel.text = timeSinceTextSent;
            self.notifyImageView.hidden = NO;
        }else{
            self.textTimeSentAgoLabel.text = @"";
            self.notifyImageView.hidden = YES;
        }
        
        if (self.waitListee.guest.waitListHistory && [self.waitListee.guest.waitListHistory count] > 0){
            NSString *label = @"Visits: ";
            label = [label stringByAppendingString:self.waitListee.guest.totalNumberOfVisits.stringValue];
            label = [label stringByAppendingString:@" / Avg Wait: "];
            label = [label stringByAppendingString:self.waitListee.guest.averageWait.stringValue];
            label = [label stringByAppendingString:@" mins / Avg Party: "];
            label = [label stringByAppendingString:self.waitListee.guest.averageParty.stringValue];
            label = [label stringByAppendingString:@" ppl"];
            
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM/dd/yy"];
            
            NSUInteger indexInArray = 0;
            for (CGRestaurantWaitListWaitTime *longestWaitInfo in self.waitListee.guest.waitListHistory) {
                NSString *dateCreated = [formatter stringFromDate:longestWaitInfo.dateCreated];
                NSString *longestWait = @"Longest Wait: ";
                longestWait = [longestWait stringByAppendingString:longestWaitInfo.totalWaitTime.stringValue];
                longestWait = [longestWait stringByAppendingString:@" mins "];
                longestWait = [longestWait stringByAppendingString:dateCreated];
                longestWait = [longestWait stringByAppendingString:@" ("];
                longestWait = [longestWait stringByAppendingString:longestWaitInfo.numberInParty.stringValue];
                longestWait = [longestWait stringByAppendingString:@" ppl)"];
                
                if (indexInArray == 0){
                    self.wait1Label.text = longestWait;
                    self.wait1Label.hidden = NO;
                }else if (indexInArray == 1){
                    self.wait2Label.text = longestWait;
                    self.wait2Label.hidden = NO;
                }else if (indexInArray == 2){
                    self.wait3Label.text = longestWait;
                    self.wait3Label.hidden = NO;
                }else if (indexInArray == 3){
                    self.wait4Label.text = longestWait;
                    self.wait4Label.hidden = NO;
                }else if (indexInArray == 4){
                    self.wait5Label.text = longestWait;
                    self.wait5Label.hidden = NO;
                }
                
                indexInArray++;
            }
            
            self.visitsLabel.text = label;
            self.visitsLabel.hidden = NO;
        }
    }
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        UIImage *navBarImg = [UIImage imageNamed:@"appHeader.png"];
        [self.navigationController.navigationBar setBackgroundImage:navBarImg forBarMetrics:UIBarMetricsDefault];
        
    }
    
    UIImage *buttonImage = [[UIImage imageNamed:@"headerButton.png"]  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 16, 0, 16)];
    [self.messageBarButtonItem setBackgroundImage:buttonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    
    
    UITapGestureRecognizer *scrolltap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(dismissKeyboard)];
    
    [scrolltap setCancelsTouchesInView:NO];
    [self.tableView addGestureRecognizer:scrolltap];
    
    
    if (self.waitListerHasBeenRemoved){
        self.addPartyButton.hidden = NO;
        
        self.notifyButton.hidden = YES;
        self.seatedButton.hidden = YES;
        self.removeButton.hidden = YES;
    }else{
        self.notifyButton.hidden = NO;
        self.seatedButton.hidden = NO;
        self.removeButton.hidden = NO;
        
        self.addPartyButton.hidden = YES;
    }
    
    self.waitListStatuses = [[NSMutableArray alloc] init];
    
    if (self.waitListStatus1.length > 0 || self.waitListStatus2.length > 0 || self.waitListStatus3.length > 0
        || self.waitListStatus4.length > 0 || self.waitListStatus4.length > 0){
        [self.waitListStatuses addObject:@"No Status"];
    }
    
    if (self.waitListStatus1.length > 0){
        [self.waitListStatuses addObject:self.waitListStatus1];
    }
    
    if (self.waitListStatus2.length > 0){
        [self.waitListStatuses addObject:self.waitListStatus2];
    }
    
    if (self.waitListStatus3.length > 0){
        [self.waitListStatuses addObject:self.waitListStatus3];
    }
    
    if (self.waitListStatus4.length > 0){
        [self.waitListStatuses addObject:self.waitListStatus4];
    }
    
    if (self.waitListStatus5.length > 0){
        [self.waitListStatuses addObject:self.waitListStatus5];
    }
    
    
    if (self.waitListee.statusNumber){
        if ([self.waitListee.statusNumber intValue] == 1){
            self.statusLabel.text = self.waitListStatus1;
        }else if ([self.waitListee.statusNumber intValue] == 2){
            self.statusLabel.text = self.waitListStatus2;
        }else if ([self.waitListee.statusNumber intValue] == 3){
            self.statusLabel.text = self.waitListStatus3;
        }else if ([self.waitListee.statusNumber intValue] == 4){
            self.statusLabel.text = self.waitListStatus4;
        }else if ([self.waitListee.statusNumber intValue] == 5){
            self.statusLabel.text = self.waitListStatus5;
        }
    }
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleStatusLabelTap:)];
    
    [singleFingerTap setCancelsTouchesInView:NO];
    [self.statusLabel setUserInteractionEnabled:YES];
    [self.statusLabel addGestureRecognizer:singleFingerTap];
    
    [super viewDidLoad];
    
//    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/restaurants/1/guests" delegate:self];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    RKLogInfo(@"Load collection of Guests: %@", objects);
}

- (void)viewDidUnload
{
    [self setUserActionView:nil];
    [self setTableView:nil];
    [self setTimeAgoLabel:nil];
    
    [self setPhoneNumberTextField:nil];
    [self setNameTextField:nil];
    [self setNumberInPartyTextField:nil];
    [self setEmailTextField:nil];
    [self setEstimatedWaitTextField:nil];
    [self setTimeAgoLabel:nil];
    
    [self setNotifyImageView:nil];
    [self setTimeAgoLabel:nil];
    [self setTextTimeSentAgoLabel:nil];
    [self setPermanentNotesTextView:nil];
    [self setVisitNotesTextView:nil];
    [self setVisitsLabel:nil];
    [self setWait1Label:nil];
    [self setWait2Label:nil];
    [self setWait3Label:nil];
    [self setWait4Label:nil];
    [self setWait5Label:nil];
    [self setTableNumberTextField:nil];
    [self setNotifyButton:nil];
    [self setPhoneNumberLabel:nil];
    [self setMessageBarButtonItem:nil];
    [self setSeatedButton:nil];
    [self setRemoveButton:nil];
    [self setAddPartyButton:nil];
    [self setStatusLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)addPartyToWaitList:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserId];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
    
    [params setObject:userId forKey:@"userId"];
    [params setObject:password forKey:@"password"];
    
    NSString *fbUid = [[NSUserDefaults standardUserDefaults] objectForKey:kFbUid];
    if (fbUid != nil){
        [params setObject:fbUid forKey:@"fbUid"];
    }
    
    NSString *urlString = @"/restaurants/";
    urlString = [urlString stringByAppendingString:self.selectedRestaurant.restaurantId.stringValue];
    urlString = [urlString stringByAppendingString:@"/waitlist/"];
    urlString = [urlString stringByAppendingString:self.waitListee.waitListId.stringValue];
    urlString = [urlString stringByAppendingString:@"/addPartyBackToWaitList"];
    
    [[RKClient sharedClient] post:urlString params:params delegate:self];
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.tableView addSubview: activityView];
    
    self.activityView.center = CGPointMake(240,160);
    [self.activityView startAnimating];
}

- (IBAction)notify:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserId];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
    
    [params setObject:userId forKey:@"userId"];
    [params setObject:password forKey:@"password"];
    
    NSString *fbUid = [[NSUserDefaults standardUserDefaults] objectForKey:kFbUid];
    if (fbUid){
        [params setObject:fbUid forKey:@"fbUid"];
    }
    
    NSString *urlString = @"/restaurants/";
    urlString = [urlString stringByAppendingString:self.selectedRestaurant.restaurantId.stringValue];
    urlString = [urlString stringByAppendingString:@"/waitlist/"];
    urlString = [urlString stringByAppendingString:self.waitListee.waitListId.stringValue];
    urlString = [urlString stringByAppendingString:@"/text"];
    
    [[RKClient sharedClient] post:urlString params:params delegate:self];
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.tableView addSubview: activityView];
    
    self.activityView.center = CGPointMake(240,160);
    [self.activityView startAnimating];
}

- (IBAction)remove:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserId];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
    
    [params setObject:userId forKey:@"userId"];
    [params setObject:password forKey:@"password"];
    
    NSString *fbUid = [[NSUserDefaults standardUserDefaults] objectForKey:kFbUid];
    if (fbUid){
        [params setObject:fbUid forKey:@"fbUid"];
    }
    
    NSString *urlString = @"/restaurants/";
    urlString = [urlString stringByAppendingString:self.selectedRestaurant.restaurantId.stringValue];
    urlString = [urlString stringByAppendingString:@"/waitlist/"];
    urlString = [urlString stringByAppendingString:self.waitListee.waitListId.stringValue];
    urlString = [urlString stringByAppendingString:@"/remove"];
    
    [[RKClient sharedClient] post:urlString params:params delegate:self];
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.tableView addSubview: activityView];
    
    self.activityView.center = CGPointMake(240,160);
    [self.activityView startAnimating];
}

- (IBAction)seated:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserId];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
    
    [params setObject:userId forKey:@"userId"];
    [params setObject:password forKey:@"password"];
    
    NSString *fbUid = [[NSUserDefaults standardUserDefaults] objectForKey:kFbUid];
    if (fbUid != nil){
        [params setObject:fbUid forKey:@"fbUid"];
    }
    
    NSString *urlString = @"/restaurants/";
    urlString = [urlString stringByAppendingString:self.selectedRestaurant.restaurantId.stringValue];
    urlString = [urlString stringByAppendingString:@"/waitlist/"];
    urlString = [urlString stringByAppendingString:self.waitListee.waitListId.stringValue];
    urlString = [urlString stringByAppendingString:@"/seat"];
    
    [[RKClient sharedClient] post:urlString params:params delegate:self];
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.tableView addSubview: activityView];
    
    self.activityView.center = CGPointMake(240,160);
    [self.activityView startAnimating];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    [self returnFromSave];
    
    NSString *urlString = [request.URL absoluteString];
    NSRange isRange = [urlString rangeOfString:@"update" options:NSCaseInsensitiveSearch];

    if (isRange.location == NSNotFound && [request isPOST]) {
        if ([response isOK]) {
            if ([response isJSON]) {
                NSLog(@"Got a JSON response back from our POST!");
                
                NSString* JSONString = [response bodyAsString];
                NSString* MIMEType = @"application/json";
                NSError* error = nil;
                
                id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:MIMEType];
                id parsedData = [parser objectFromString:JSONString error:&error];
                if (parsedData == nil && error) {
                    NSLog(@"ERROR: JSON parsing error");
                }
                
                RKObjectMappingProvider* mappingProvider = [RKObjectManager sharedManager].mappingProvider;
                RKObjectMapper* mapper = [RKObjectMapper mapperWithObject:parsedData mappingProvider:mappingProvider];
                RKObjectMappingResult* result = [mapper performMapping];
                
                if (result) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }
    }
    
    
}


#pragma mark - TextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [self.navigationItem setHidesBackButton:YES animated:YES];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    [self.navigationItem setHidesBackButton:YES animated:YES];
}


-(void) textFieldDidEndEditing: (UITextField * ) textField {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSNumber *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserId];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
    
    NSString *fbUid = [[NSUserDefaults standardUserDefaults] objectForKey:kFbUid];
    if (fbUid != nil){
        [params setObject:fbUid forKey:@"fbUid"];
    }
    
    [params setObject:userId.stringValue forKey:@"userId"];
    [params setObject:password forKey:@"password"];
    
    NSString *urlString = @"/restaurants/";
    urlString = [urlString stringByAppendingString:self.selectedRestaurant.restaurantId.stringValue];
    urlString = [urlString stringByAppendingString:@"/waitlist/"];
    urlString = [urlString stringByAppendingString:self.waitListee.waitListId.stringValue];
    urlString = [urlString stringByAppendingString:@"/update"];
    
    if (textField == self.nameTextField){
        if ([self.nameTextField.text length] == 0){
            self.nameTextField.text = self.waitListee.guest.name;
            
            [[[UIAlertView alloc] initWithTitle:@"Name" message:@"Name can not be blank." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
        }else if (![self.nameTextField.text isEqualToString:self.waitListee.guest.name]){
            
            [params setObject:self.nameTextField.text forKey:@"name"];
            [params setObject:self.waitListee.guest.guestId forKey:@"guestId"];
            
            [self prepareForSave];
            [[RKClient sharedClient] post:urlString params:params delegate:self];
        }
    }else if (textField == self.numberInPartyTextField){
        if ([self.numberInPartyTextField.text length] == 0){
            self.numberInPartyTextField.text = self.waitListee.numberInParty.stringValue;
            
            [[[UIAlertView alloc] initWithTitle:@"Guests" message:@"Guests can not be blank." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
        }else if (![self.numberInPartyTextField.text isEqualToString:self.waitListee.numberInParty.stringValue]){
            
            [params setObject:self.numberInPartyTextField.text forKey:@"numberInParty"];
            
            [self prepareForSave];
            [[RKClient sharedClient] post:urlString params:params delegate:self];
        }
    }else if (textField == self.phoneNumberTextField){
        if ([self.phoneNumberTextField.text length] == 0){
            self.phoneNumberTextField.text = self.waitListee.guest.phoneNumber;
            
            [[[UIAlertView alloc] initWithTitle:@"Phone Number" message:@"Phone Number can not be blank." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
        }else if (self.phoneNumberTextField.text.length != 10){
            [[[UIAlertView alloc] initWithTitle:@"Phone Number" message:@"A phone number must be 10 digits.  Please re-enter." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }else if (![self.phoneNumberTextField.text isEqualToString:self.waitListee.guest.phoneNumber]){
            
            [params setObject:self.phoneNumberTextField.text forKey:@"phoneNumber"];
            [params setObject:self.waitListee.guest.guestId forKey:@"guestId"];
            
            [self prepareForSave];
            [[RKClient sharedClient] post:urlString params:params delegate:self];
        }
    }else if (textField == self.estimatedWaitTextField){
        if ([self.estimatedWaitTextField.text length] == 0){
            self.estimatedWaitTextField.text = self.waitListee.estimatedWait.stringValue;
            
            [[[UIAlertView alloc] initWithTitle:@"Estimated Wait" message:@"Estimated Wait can not be blank." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
        }else if (![self.estimatedWaitTextField.text isEqualToString:self.waitListee.estimatedWait.stringValue]){
            
            [params setObject:self.estimatedWaitTextField.text forKey:@"estimatedWait"];
            
            [self prepareForSave];
            [[RKClient sharedClient] post:urlString params:params delegate:self];
        }
    }else if (textField == self.emailTextField){
        if (![self.emailTextField.text isEqualToString:self.waitListee.guest.email]){
            
            [params setObject:self.emailTextField.text forKey:@"email"];
            [params setObject:self.waitListee.guest.guestId forKey:@"guestId"];
            
            [self prepareForSave];
            [[RKClient sharedClient] post:urlString params:params delegate:self];
        }
    }else if (textField == self.tableNumberTextField){
        if (![self.tableNumberTextField.text isEqualToString:self.waitListee.tableNumber]){
            
            [params setObject:self.tableNumberTextField.text forKey:@"tableNumber"];
            
            [self prepareForSave];
            [[RKClient sharedClient] post:urlString params:params delegate:self];
        }
    }
}

-(void) textViewDidEndEditing: (UITextView * ) textView{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSNumber *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserId];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
    
    NSString *fbUid = [[NSUserDefaults standardUserDefaults] objectForKey:kFbUid];
    if (fbUid != nil){
        [params setObject:fbUid forKey:@"fbUid"];
    }
    
    [params setObject:userId.stringValue forKey:@"userId"];
    [params setObject:password forKey:@"password"];
    
    NSString *urlString = @"/restaurants/";
    urlString = [urlString stringByAppendingString:self.selectedRestaurant.restaurantId.stringValue];
    urlString = [urlString stringByAppendingString:@"/waitlist/"];
    urlString = [urlString stringByAppendingString:self.waitListee.waitListId.stringValue];
    urlString = [urlString stringByAppendingString:@"/update"];
    
    if (textView == self.permanentNotesTextView){
        if (self.visitNotesTextView.text != self.waitListee.visitNotes){
            [params setObject:self.permanentNotesTextView.text forKey:@"permanentNotes"];
            [params setObject:self.waitListee.guest.guestId forKey:@"guestId"];
            
            [self prepareForSave];
            [[RKClient sharedClient] post:urlString params:params delegate:self];
        }
    }else if (textView == self.visitNotesTextView){
        if (self.visitNotesTextView.text != self.waitListee.visitNotes){
            
            [params setObject:self.visitNotesTextView.text forKey:@"visitNotes"];
            
            [self prepareForSave];
            [[RKClient sharedClient] post:urlString params:params delegate:self];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return NO;
}

- (void) viewWillDisappear: (BOOL) animated {
    [super viewWillDisappear: animated];
    // Force any text fields that might be being edited to end so the text is stored
    [self.view.window endEditing: NO];
}

-(void)dismissKeyboard {
    
    UITextField *activeTextField = nil;
    UITextView *activeTextView = nil;
    
    if ([phoneNumberTextField isEditing]){
        activeTextField = phoneNumberTextField;
    }else if ([nameTextField isEditing]){
        activeTextField = nameTextField;
    }else if ([numberInPartyTextField isEditing]){
        activeTextField = numberInPartyTextField;
    }else if ([emailTextField isEditing]){
        activeTextField = emailTextField;
    }else if ([estimatedWaitTextField isEditing]){
        activeTextField = estimatedWaitTextField;
    }else if ([permanentNotesTextView isFirstResponder]){
        activeTextView = permanentNotesTextView;
    }else if ([visitNotesTextView isFirstResponder]){
        activeTextView = visitNotesTextView;
    }else if ([tableNumberTextField isEditing]){
        activeTextField = tableNumberTextField;
    }
    
    if (activeTextField) [activeTextField resignFirstResponder];
    if (activeTextView) [activeTextView resignFirstResponder];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"messageSegue"]){
        CGMessageViewController *messageViewController  = [segue destinationViewController];
        messageViewController.waitListee = self.waitListee;
        messageViewController.currentRestaurant = self.selectedRestaurant;
    }
}

- (void)prepareForSave{
    [self startSpinner];
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.tableView addSubview: activityView];
    
    self.activityView.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.activityView startAnimating];
}

- (void)returnFromSave{
    [self stopSpinner];
    [self.navigationItem setHidesBackButton:NO animated:YES];
    [self.activityView stopAnimating];
    [self.activityView removeFromSuperview];
}

- (void)handleStatusLabelTap:(UITapGestureRecognizer *)recognizer {
    if (recognizer.view == self.statusLabel){
        
        if (self.waitListStatuses.count > 0){
            [ActionSheetStringPicker showPickerWithTitle:@"Choose Status" rows:self.waitListStatuses initialSelection:0 target:self successAction:@selector(statusWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:self.statusLabel];
        }else{
            [[[UIAlertView alloc] initWithTitle:@"Setup" message:@"You do not have any waitlist statuses set up." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
        }
    }
}

- (void)statusWasSelected:(NSNumber *)selectedIndex element:(id)element{
    NSString *selectedStatus = [self.waitListStatuses objectAtIndex:[selectedIndex intValue]];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    if ([selectedStatus isEqualToString:@"No Status"]){
        self.statusLabel.text = @"Tap to add status";
        [params setObject:[NSNumber numberWithInt:-1] forKey:@"statusNumber"];
    }else{
        self.statusLabel.text = selectedStatus;
        
        if ([selectedStatus isEqualToString:self.waitListStatus1]){
            self.waitListee.statusNumber = [NSNumber numberWithInt:1];
        }else if ([selectedStatus isEqualToString:self.waitListStatus2]){
            self.waitListee.statusNumber = [NSNumber numberWithInt:2];
        }else if ([selectedStatus isEqualToString:self.waitListStatus3]){
            self.waitListee.statusNumber = [NSNumber numberWithInt:3];
        }else if ([selectedStatus isEqualToString:self.waitListStatus4]){
            self.waitListee.statusNumber = [NSNumber numberWithInt:4];
        }else if ([selectedStatus isEqualToString:self.waitListStatus5]){
            self.waitListee.statusNumber = [NSNumber numberWithInt:5];
        }
        
        [params setObject:self.waitListee.statusNumber forKey:@"statusNumber"];
    }
    
    
    
    NSNumber *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserId];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
    
    NSString *fbUid = [[NSUserDefaults standardUserDefaults] objectForKey:kFbUid];
    if (fbUid != nil){
        [params setObject:fbUid forKey:@"fbUid"];
    }
    
    [params setObject:userId.stringValue forKey:@"userId"];
    [params setObject:password forKey:@"password"];
    
    NSString *urlString = @"/restaurants/";
    urlString = [urlString stringByAppendingString:self.selectedRestaurant.restaurantId.stringValue];
    urlString = [urlString stringByAppendingString:@"/waitlist/"];
    urlString = [urlString stringByAppendingString:self.waitListee.waitListId.stringValue];
    urlString = [urlString stringByAppendingString:@"/update"];
    
    
    
    [self prepareForSave];
    [[RKClient sharedClient] post:urlString params:params delegate:self];
    
}

- (void) startSpinner {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Saving";
    hud.userInteractionEnabled = NO;
}

- (void) stopSpinner {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}



@end
