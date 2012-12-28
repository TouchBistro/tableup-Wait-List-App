//
//  CGAddGuestIPadTableViewController.m
//  WaitList
//
//  Created by Padraic Doyle on 12/12/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import "CGAddGuestIPadTableViewController.h"
#import "CGUtils.h"
#import "CGRestaurantWaitListWaitTime.h"
#import "CGRestaurantFullWaitList.h"
#import "CGRestaurantGuest.h"
#import <RestKit/RestKit.h>

@interface CGAddGuestIPadTableViewController ()

@end

@implementation CGAddGuestIPadTableViewController

@synthesize cancelButtonItem;

@synthesize phoneNumberTextField;
@synthesize nameTextField;
@synthesize emailTextField;
@synthesize visitNotesTextView;
@synthesize permanentNotesTextView;

@synthesize numberInPartyTextField;
@synthesize estimatedWaitTextField;
@synthesize visitLabel;
@synthesize longestWaitLabel;

@synthesize activityView;

@synthesize saveButton;
@synthesize saveAndSendButton;

@synthesize spinner;

@synthesize currentRestaurant;
@synthesize loggedInUser;

@synthesize guestId;

@synthesize totalGuests;
@synthesize totalParties;
@synthesize estimatedWait;

@synthesize noPhoneNumberButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [super viewDidLoad];
    [self.phoneNumberTextField setDelegate:self];
    
    [self setDataLoaded:NO];
    self.saveButton.hidden = YES;
    self.saveAndSendButton.hidden = YES;
    self.noPhoneNumberButton.hidden = NO;
    
    self.visitLabel.hidden = YES;
    self.longestWaitLabel.hidden = YES;
    
    self.spinner.center = self.view.center;
    
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
    
}

- (void)viewDidUnload
{
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
    [self setNoPhoneNumberButton:nil];
    [self setPhoneNumberLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)save:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserId];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
    
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
        
        if (self.guestId){
            [params setObject:self.guestId forKey:@"guestId"];
        }
        
        if (self.tableNumberTextField.text.length > 0){
            [params setObject:self.tableNumberTextField.text forKey:@"tableNumber"];
        }
        
        NSString *urlString = @"/restaurants/";
        urlString = [urlString stringByAppendingString:self.currentRestaurant.restaurantId.stringValue];
        urlString = [urlString stringByAppendingString:@"/waitlist"];
        
        [[RKClient sharedClient] post:urlString params:params delegate:self];
        
        [self.spinner startAnimating];
        [self.view addSubview:spinner];
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
        
        if (self.tableNumberTextField.text.length > 0){
            [params setObject:self.tableNumberTextField.text forKey:@"tableNumber"];
        }
        
        if (self.guestId){
            [params setObject:self.guestId forKey:@"guestId"];
        }
        
        NSString *urlString = @"/restaurants/";
        urlString = [urlString stringByAppendingString:self.currentRestaurant.restaurantId.stringValue];
        urlString = [urlString stringByAppendingString:@"/waitlist"];
        
        [[RKClient sharedClient] post:urlString params:params delegate:self];
        
        [self.spinner startAnimating];
        [self.view addSubview:spinner];
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
                                
                                self.visitLabel.hidden = NO;
                                self.longestWaitLabel.hidden = NO;
                            }
                            
                        }
                    }
                }
            }
        }
        
        [self.spinner stopAnimating];
        [self.spinner removeFromSuperview];
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
                            [self.delegate guestAdded:fullWaitList];
                        }
                        
                    }
                }
            }else{
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went wrong" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
            }
            
        }
        
        [self.spinner stopAnimating];
        [self.spinner removeFromSuperview];
        
        [self.activityView stopAnimating];
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

#pragma mark - Table view data source
-(void) textFieldDidEndEditing: (UITextField * ) textField {
    NSString *phoneNumber = self.phoneNumberTextField.text;
    
    if (phoneNumber == nil){
        [[[UIAlertView alloc] initWithTitle:@"Phone Number" message:@"The phone number entered is not the proper length.  Please fix." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }else if (phoneNumber != nil && phoneNumber.length != 10){
        [[[UIAlertView alloc] initWithTitle:@"Phone Number" message:@"A phone number must be 10 digits.  Please re-enter." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }else{
        NSString *url = @"/restaurants/";
        url = [url stringByAppendingString:self.currentRestaurant.restaurantId.stringValue];
        url = [url stringByAppendingString:@"/phonenumber/guests/"];
        url = [url stringByAppendingString:phoneNumber];
        
        [[RKClient sharedClient] get:url delegate:self];
        
        [self.spinner startAnimating];
        [self.view addSubview:spinner];
        
        self.noPhoneNumberButton.hidden = YES;
        
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
        UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.tableView.bounds.size.width,30)];
        
        NSString *label = @"Parties: ";
        label = [label stringByAppendingString:self.totalParties.stringValue];
        label = [label stringByAppendingString:@" / Guests: "];
        label = [label stringByAppendingString:self.totalGuests.stringValue];
        label = [label stringByAppendingString:@" / Estimated Wait: "];
        label = [label stringByAppendingString:self.estimatedWait.stringValue];
        label = [label stringByAppendingString:@" mins"];
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.font = [UIFont systemFontOfSize:10];
        headerLabel.frame = CGRectMake(0,0,self.tableView.bounds.size.width,30);
        headerLabel.text =  label;
        headerLabel.textAlignment = UITextAlignmentCenter;
        [customView addSubview:headerLabel];
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
        return 0.0;
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

@end
