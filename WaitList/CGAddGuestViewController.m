//
//  CGAddGuestViewController.m
//  WaitList
//
//  Created by Padraic Doyle on 10/9/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import "CGAddGuestViewController.h"
#import "CGUtils.h"
#import "CGRestaurantWaitListWaitTime.h"
#import "CGRestaurantFullWaitList.h"
#import <RestKit/RestKit.h>
#import "ActionSheetPicker.h"

@interface CGAddGuestViewController ()

@end

@implementation CGAddGuestViewController
@synthesize navItem;
@synthesize cancelButtonItem;

@synthesize phoneNumberTextField;
@synthesize nameTextField;
@synthesize emailTextField;
@synthesize visitNotesTextView;
@synthesize permanentNotesTextView;

@synthesize numberInPartyTextField;
@synthesize estimatedWaitTextField;
@synthesize waitListTableViewController;
@synthesize visitLabel;
@synthesize longestWaitLabel;

@synthesize activityView;

@synthesize saveButton;
@synthesize saveAndSendButton;

@synthesize currentRestaurant;
@synthesize loggedInUser;

@synthesize guestId;

@synthesize totalGuests;
@synthesize totalParties;
@synthesize estimatedWait;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.phoneNumberTextField setDelegate:self];
    
    [self setDataLoaded:NO];
    self.saveButton.hidden = YES;
    self.saveAndSendButton.hidden = YES;
    
    self.visitLabel.hidden = YES;
    self.longestWaitLabel.hidden = YES;
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    
    self.phoneNumberTextField.inputAccessoryView = numberToolbar;
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        UIImage *navBarImg = [UIImage imageNamed:@"appHeader.png"];
        [self.navigationController.navigationBar setBackgroundImage:navBarImg forBarMetrics:UIBarMetricsDefault];
        
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handleStatusLabelTap:)];
    
    [singleFingerTap setCancelsTouchesInView:NO];
    [self.statusLabel setUserInteractionEnabled:YES];
    [self.statusLabel addGestureRecognizer:singleFingerTap];
    
    
    self.waitListStatuses = [[NSMutableArray alloc] init];
    
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
    
}

- (void)viewDidUnload
{
    [self setNavItem:nil];
    [self setCancelButtonItem:nil];
    [self setPhoneNumberTextField:nil];
    [self setNameTextField:nil];
    [self setNumberInPartyTextField:nil];
    [self setEmailTextField:nil];
    [self setEstimatedWaitTextField:nil];
    
    [self setSaveButton:nil];
    [self setSaveAndSendButton:nil];
    [self setGuestId:nil];
    
    [self setPermanentNotesTextView:nil];
    [self setVisitNotesTextView:nil];
    [self setVisitLabel:nil];
    [self setLongestWaitLabel:nil];
    [self setTableNumberField:nil];
    [self setNoPhoneNumberButton:nil];
    [self setPhoneNumberLabel:nil];
    [self setStatusLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark - Table view delegate


- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)save:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserId];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
    
    NSString *fbUid = [[NSUserDefaults standardUserDefaults] objectForKey:kFbUid];
    if (fbUid != nil){
        [params setObject:fbUid forKey:@"fbUid"];
    }
    
    [params setObject:userId forKey:@"userId"];
    [params setObject:password forKey:@"password"];
    
    if (self.nameTextField.text.length > 0 && self.numberInPartyTextField.text.length > 0 && self.estimatedWaitTextField.text.length > 0)
    {
        if (self.phoneNumberTextField.text.length > 0){
            [params setObject:self.phoneNumberTextField.text forKey:@"phoneNumber"];
        }
        
        if (self.nameTextField.text.length > 0){
            [params setObject:self.nameTextField.text forKey:@"name" ];
        }
        
        if (self.numberInPartyTextField.text.length > 0){
            [params setObject:self.numberInPartyTextField.text forKey:@"numberInParty"];
        }
        
        if (self.estimatedWaitTextField.text.length > 0){
            [params setObject:self.estimatedWaitTextField.text forKey:@"estimatedWait"];
        }
        
        if (self.emailTextField.text.length > 0){
            [params setObject:self.emailTextField.text forKey:@"email"];
        }
        
        if (self.visitNotesTextView.text.length > 0){
            [params setObject:self.visitNotesTextView.text forKey:@"visitNotes"];
        }
        
        if (self.permanentNotesTextView.text.length > 0){
            [params setObject:self.permanentNotesTextView.text forKey:@"permanentNotes"];
        }
        
        if (self.tableNumberField.text.length > 0){
            [params setObject:self.tableNumberField.text forKey:@"tableNumber"];
        }
        
        if (self.guestId){
            [params setObject:self.guestId forKey:@"guestId"];
        }
        
        if (self.statusNumber){
            [params setObject:self.statusNumber forKey:@"statusNumber"];
        }
        
        NSString *urlString = @"/restaurants/";
        urlString = [urlString stringByAppendingString:self.currentRestaurant.restaurantId.stringValue];
        urlString = [urlString stringByAppendingString:@"/waitlist"];
        
        [[RKClient sharedClient] post:urlString params:params delegate:self];
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.view addSubview: activityView];
        
        self.activityView.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);;
        [self.activityView startAnimating];
        
    }else{
        if (self.nameTextField.text.length == 0){
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Name required." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
        }else if (self.numberInPartyTextField.text.length == 0) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Number of guests required." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
        }else if (self.estimatedWaitTextField.text.length == 0) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Estimated wait required." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
        }
    }
    
}

- (IBAction)saveAndText:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserId];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
    
    NSString *fbUid = [[NSUserDefaults standardUserDefaults] objectForKey:kFbUid];
    if (fbUid != nil){
        [params setObject:fbUid forKey:@"fbUid"];
    }
    
    [params setObject:userId forKey:@"userId"];
    [params setObject:password forKey:@"password"];
    
    [params setObject:@"true" forKey:@"sendText"];
    
    if (self.phoneNumberTextField.text.length > 0 && self.nameTextField.text.length > 0 &&
        self.numberInPartyTextField.text.length > 0 && self.estimatedWaitTextField.text.length > 0)
    {
        if (self.phoneNumberTextField.text.length > 0){
            [params setObject:self.phoneNumberTextField.text forKey:@"phoneNumber"];
        }
        
        if (self.nameTextField.text.length > 0){
            [params setObject:self.nameTextField.text forKey:@"name" ];
        }
        
        if (self.numberInPartyTextField.text.length > 0){
            [params setObject:self.numberInPartyTextField.text forKey:@"numberInParty"];
        }
        
        if (self.estimatedWaitTextField.text.length > 0){
            [params setObject:self.estimatedWaitTextField.text forKey:@"estimatedWait"];
        }
        
        if (self.emailTextField.text.length > 0){
            [params setObject:self.emailTextField.text forKey:@"email"];
        }
        
        if (self.visitNotesTextView.text.length > 0){
            [params setObject:self.visitNotesTextView.text forKey:@"visitNotes"];
        }
        
        if (self.permanentNotesTextView.text.length > 0){
            [params setObject:self.permanentNotesTextView.text forKey:@"permanentNotes"];
        }
        
        if (self.guestId){
            [params setObject:self.guestId forKey:@"guestId"];
        }
        
        if (self.tableNumberField.text.length > 0){
            [params setObject:self.tableNumberField.text forKey:@"tableNumber"];
        }
        
        if (self.statusNumber){
            [params setObject:self.statusNumber forKey:@"statusNumber"];
        }
        
        NSString *urlString = @"/restaurants/";
        urlString = [urlString stringByAppendingString:self.currentRestaurant.restaurantId.stringValue];
        urlString = [urlString stringByAppendingString:@"/waitlist"];
        
        [[RKClient sharedClient] post:urlString params:params delegate:self];
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.view addSubview: activityView];
        
        self.activityView.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
        [self.activityView startAnimating];
    }else{
        if (self.phoneNumberTextField.text.length == 0){
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Phone number required." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
        }else if (self.nameTextField.text.length == 0){
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Name required." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
        }else if (self.numberInPartyTextField.text.length == 0) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Number of guests required." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
        }else if (self.estimatedWaitTextField.text.length == 0) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Estimated wait required." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
        }
    }
}

- (IBAction)noPhoneNumber:(id)sender {
    self.noPhoneNumberButton.hidden = YES;
    self.phoneNumberLabel.textColor = [UIColor lightGrayColor];
    self.phoneNumberTextField.enabled = NO;
    self.saveAndSendButton.hidden = YES;
    
    [self setDataLoaded:YES];
    
    [self.tableView reloadData];
    
    self.saveButton.hidden = NO;
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSString * path = [request resourcePath];
    
    NSRange isRange = [path rangeOfString:@"phonenumber" options:NSCaseInsensitiveSearch];
    if(isRange.location != NSNotFound) {
        if ([request isGET]) {
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
                        CGRestaurantGuest *guest = result.asObject;
                        
                        if (guest){
                            self.visitLabel.hidden = NO;
                            self.longestWaitLabel.hidden = NO;
                            
                            self.nameTextField.text = guest.name;
                            self.emailTextField.text = guest.email;
                            self.permanentNotesTextView.text = guest.permanentNotes;
                            self.guestId = guest.guestId;
                            
                            
                            if (guest.waitListHistory && [guest.waitListHistory count] > 0){
                                NSString *label = @"Visits: ";
                                label = [label stringByAppendingString:guest.totalNumberOfVisits.stringValue];
                                label = [label stringByAppendingString:@" / Avg Wait: "];
                                label = [label stringByAppendingString:guest.averageWait.stringValue];
                                label = [label stringByAppendingString:@" mins / Avg Party: "];
                                label = [label stringByAppendingString:guest.averageParty.stringValue];
                                label = [label stringByAppendingString:@" ppl"];
                                
                                CGRestaurantWaitListWaitTime *longestWaitInfo = [guest.waitListHistory objectAtIndex:0];
                                
                                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                [formatter setDateFormat:@"MM/dd/yy"];
                                
                                NSString *dateCreated = [formatter stringFromDate:longestWaitInfo.dateCreated];
                                
                                NSString *longestWait = @"Longest Wait: ";
                                longestWait = [longestWait stringByAppendingString:longestWaitInfo.totalWaitTime.stringValue];
                                longestWait = [longestWait stringByAppendingString:@" mins "];
                                longestWait = [longestWait stringByAppendingString:dateCreated];
                                longestWait = [longestWait stringByAppendingString:@" ("];
                                longestWait = [longestWait stringByAppendingString:longestWaitInfo.numberInParty.stringValue];
                                longestWait = [longestWait stringByAppendingString:@" ppl)"];
                                
                                self.visitLabel.text = label;
                                self.longestWaitLabel.text = longestWait;
                            }

                        }
                    }
                }
            }
        }
        
        [self.activityView stopAnimating];
        [self.activityView removeFromSuperview];
        [self setDataLoaded:YES];
        
        [self.tableView reloadData];
        
        self.saveButton.hidden = NO;
        self.saveAndSendButton.hidden = NO;
        
    }else{
        if ([request isPOST]) {
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
                        
                        NSArray *resultArray = result.asCollection;
                        CGRestaurantFullWaitList *fullWaitList = [resultArray objectAtIndex:0];
                        
                        if (fullWaitList){
                            [self.waitListTableViewController.waitListers removeAllObjects];
                            [self.waitListTableViewController.waitListers addObjectsFromArray:fullWaitList.waitListers];
                            [self.waitListTableViewController.tableView reloadData];
                        }
                        
                    }
                }
            }else{
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went wrong" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
            }
            
        }
        
        [self.activityView stopAnimating];
        [self.activityView removeFromSuperview];
        
        [self dismissModalViewControllerAnimated:YES];
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataLoaded){
        return 2;
    }else{
        return 1;
    }
}


-(void)cancelNumberPad{
    [phoneNumberTextField resignFirstResponder];
    phoneNumberTextField.text = @"";
}

-(void)doneWithNumberPad{
    [phoneNumberTextField resignFirstResponder];
}


#pragma mark - TextFieldDelegate
-(void) textFieldDidEndEditing: (UITextField * ) textField {
    NSString *phoneNumber = self.phoneNumberTextField.text;
    
    if (phoneNumber != nil){
        if (phoneNumber != nil && phoneNumber.length != 10){
            [[[UIAlertView alloc] initWithTitle:@"Phone Number" message:@"A phone number must be 10 digits.  Please re-enter." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }else{
            NSString *url = @"/restaurants/";
            url = [url stringByAppendingString:self.currentRestaurant.restaurantId.stringValue];
            url = [url stringByAppendingString:@"/phonenumber/guests/"];
            url = [url stringByAppendingString:phoneNumber];
            
            self.noPhoneNumberButton.hidden = YES;
            [[RKClient sharedClient] get:url delegate:self];
            
            self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [self.view addSubview: activityView]; 
            
            self.activityView.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);;
            [self.activityView startAnimating];
        }
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Phone Number" message:@"The phone number entered is not the proper length.  Please fix." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.noPhoneNumberButton.hidden = YES;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return NO;
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
    }
    
    if (activeTextField) [activeTextField resignFirstResponder];
    if (activeTextView) [activeTextView resignFirstResponder];

}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0){
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,30)];
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:customView.frame];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:10];
        headerLabel.frame = CGRectMake(0,0,300,30);
        
        headerLabel.text =  @"Parties: ";
        headerLabel.text = [headerLabel.text stringByAppendingString:self.totalParties.stringValue];
        headerLabel.text = [headerLabel.text stringByAppendingString:@" / Guests: "];
        headerLabel.text = [headerLabel.text stringByAppendingString:self.totalGuests.stringValue];
        headerLabel.text = [headerLabel.text stringByAppendingString:@" / Estimated Wait: "];
        headerLabel.text = [headerLabel.text stringByAppendingString:self.estimatedWait.stringValue];
        headerLabel.text = [headerLabel.text stringByAppendingString:@" mins"];
        
        
        headerLabel.textAlignment = UITextAlignmentCenter;
        headerLabel.textColor = [UIColor colorWithRed:99.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1.0];
        headerLabel.shadowColor = [UIColor whiteColor];
    	headerLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
        
        [customView addSubview:headerLabel];
        headerLabel = nil;
        
        return customView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        return 30;
    }else{
        return 0;
    }
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
    
    self.statusLabel.text = selectedStatus;
    
    if ([selectedStatus isEqualToString:self.waitListStatus1]){
        self.statusNumber = [NSNumber numberWithInt:1];
    }else if ([selectedStatus isEqualToString:self.waitListStatus2]){
        self.statusNumber = [NSNumber numberWithInt:2];
    }else if ([selectedStatus isEqualToString:self.waitListStatus3]){
        self.statusNumber = [NSNumber numberWithInt:3];
    }else if ([selectedStatus isEqualToString:self.waitListStatus4]){
        self.statusNumber = [NSNumber numberWithInt:4];
    }else if ([selectedStatus isEqualToString:self.waitListStatus5]){
        self.statusNumber = [NSNumber numberWithInt:5];
    }
}


@end
