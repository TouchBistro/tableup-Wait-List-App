//
//  CGAddGuestViewController.m
//  WaitList
//
//  Created by Padraic Doyle on 10/9/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import "CGAddGuestViewController.h"
#import "CGUtils.h"
#import <RestKit/RestKit.h>

@interface CGAddGuestViewController ()

@end

@implementation CGAddGuestViewController
@synthesize navItem;
@synthesize cancelButtonItem;

@synthesize phoneNumberTextField;
@synthesize nameTextField;
@synthesize emailTextField;
@synthesize visitNotesTextField;
@synthesize permanentNotesTextField;
@synthesize numberInPartyTextField;
@synthesize estimatedWaitTextField;
@synthesize waitListTableViewController;

@synthesize activityView;

@synthesize saveButton;
@synthesize saveAndSendButton;

@synthesize spinner;

@synthesize currentRestaurant;
@synthesize loggedInUser;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.phoneNumberTextField setDelegate:self];
    
    [self setDataLoaded:NO];
    self.saveButton.hidden = YES;
    self.saveAndSendButton.hidden = YES;
    
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
    [self setVisitNotesTextField:nil];
    [self setPermanentNotesTextField:nil];
    
    [self setSaveButton:nil];
    [self setSaveAndSendButton:nil];
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
    
    [params setObject:userId forKey:@"userId"];
    [params setObject:password forKey:@"password"];
    
    if (self.phoneNumberTextField.text.length > 0 && self.nameTextField.text.length > 0 &&
        self.numberInPartyTextField.text.length > 0 && self.estimatedWaitTextField.text.length > 0 && self.emailTextField.text.length > 0)
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
        
        if (self.visitNotesTextField.text.length > 0){
            [params setObject:self.visitNotesTextField.text forKey:@"visitNotes"];
        }
        
        if (self.permanentNotesTextField.text.length > 0){
            [params setObject:self.permanentNotesTextField.text forKey:@"permanentNotes"];
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
        }else if (self.emailTextField.text.length == 0) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Email required" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
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
                            self.permanentNotesTextField.text = guest.permanentNotes;
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
                        [self.waitListTableViewController.waitListers removeAllObjects];
                        [self.waitListTableViewController.waitListers addObjectsFromArray:resultArray];
                        [self.waitListTableViewController.tableView reloadData];
                        
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



- (IBAction)saveAndText:(id)sender {
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
        NSString *url = @"/restaurants/";
        url = [url stringByAppendingString:self.currentRestaurant.restaurantId.stringValue];
        url = [url stringByAppendingString:@"/phonenumber/guests/"];
        url = [url stringByAppendingString:phoneNumber];
        
        [[RKClient sharedClient] get:url delegate:self];
        
        [self.spinner startAnimating];
        [self.view addSubview:spinner];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return NO;
}


@end
