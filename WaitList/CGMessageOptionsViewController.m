//
//  CGMessageOptionsViewController.m
//  WaitList
//
//  Created by Padraic Doyle on 2/8/13.
//  Copyright (c) 2013 Padraic Doyle. All rights reserved.
//

#import "CGMessageOptionsViewController.h"
#import "CGMessageOptions.h"
#import <QuartzCore/QuartzCore.h>
#import <RestKit/RestKit.h>

#import "CGUtils.h"

@interface CGMessageOptionsViewController ()

@end

@implementation CGMessageOptionsViewController

@synthesize currentRestaurant;

@synthesize waitListPageTextView;
@synthesize tableReadyTextView;
@synthesize welcomeTextView;

@synthesize welcomeCountLabel;
@synthesize tableReadyCountLabel;
@synthesize waitListPageCountLabel;

@synthesize onlineReservation;
@synthesize allowMessages;

@synthesize allowMessagesSwitch;
@synthesize onlineReservationsSwitch;

@synthesize activityView;
@synthesize scrollView;

- (void)viewDidLoad
{
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        UIImage *navBarImg = [UIImage imageNamed:@"appHeader.png"];
        [self.navigationController.navigationBar setBackgroundImage:navBarImg forBarMetrics:UIBarMetricsDefault];
        
    }
    
    self.scrollView.delegate = self;
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 900)];
    
    [self setupTextView:self.waitListPageTextView];
    [self setupTextView:self.tableReadyTextView];
    [self setupTextView:self.welcomeTextView];
    [self setupTextView:self.preOrderTextView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserId];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
    
    NSString *fbUid = [[NSUserDefaults standardUserDefaults] objectForKey:kFbUid];
    if (fbUid != nil){
        [params setObject:fbUid forKey:@"fbUid"];
    }
    
    [params setObject:userId forKey:@"userId"];
    [params setObject:password forKey:@"password"];
    [params setObject:self.currentRestaurant.restaurantId forKey:@"restId"];
    
    [[RKClient sharedClient] get:@"/waitlist/restaurant/messageoptions" queryParameters:params delegate:self];
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityView];
    [self.activityView startAnimating];
    
    [super viewDidLoad];
}

-(void)setupTextView: (UITextView *) textView{
    [textView.layer setCornerRadius:10.0f];
    [textView.layer setBorderColor:[UIColor blackColor].CGColor];
    [textView.layer setBorderWidth:1.0f];
    textView.clipsToBounds = YES;
    textView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)allowSwitch:(id)sender {
    UISwitch *tempSwitch = (UISwitch *)sender;
    
    if (tempSwitch.on){
        self.allowMessages = YES;
    }
}

- (IBAction)onlineReservationsSwitch:(id)sender {
}
- (void)viewDidUnload {
    [self setWelcomeCountLabel:nil];
    [self setTableReadyCountLabel:nil];
    [self setWaitListPageCountLabel:nil];
    [self setWelcomeTextView:nil];
    [self setTableReadyTextView:nil];
    [self setWaitListPageTextView:nil];
    [self setScrollView:nil];
    [self setAllowMessagesSwitch:nil];
    [self setOnlineReservationsSwitch:nil];
    [self setSaveButton:nil];
    [self setAllowPreOrderingSwitch:nil];
    [self setPreOrderCountLabel:nil];
    [self setPreOrderTextView:nil];
    [super viewDidUnload];
}


- (void)keyboardWasShown:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // Step 3: Scroll the target text field into view.
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    if (!CGRectContainsPoint(aRect, self.saveButton.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.saveButton.frame.origin.y - (keyboardSize.height-68));
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void) keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (IBAction)dismissKeyboard:(id)sender
{
}

- (IBAction)save:(id)sender {
    if (self.welcomeTextView.text.length <= 127 && self.tableReadyTextView.text.length <= 160 && self.waitListPageTextView.text.length <= 250 && self.preOrderTextView.text.length <= 250){
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserId];
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
        
        NSString *fbUid = [[NSUserDefaults standardUserDefaults] objectForKey:kFbUid];
        if (fbUid != nil){
            [params setObject:fbUid forKey:@"fbUid"];
        }
        
        [params setObject:userId forKey:@"userId"];
        [params setObject:password forKey:@"password"];
        [params setObject:self.currentRestaurant.restaurantId forKey:@"restId"];
        
        
        if (self.waitListPageTextView.text != nil){
            [params setObject:self.waitListPageTextView.text forKey:@"userWaitListPageMessage"];
        }
        
        if (self.tableReadyTextView.text != nil){
            [params setObject:self.tableReadyTextView.text forKey:@"tableReadyTextMessage"];
        }
        
        if (self.welcomeTextView.text != nil){
            [params setObject:self.welcomeTextView.text forKey:@"waitListWelcomeMessage" ];
        }
        
        if (self.preOrderTextView.text != nil){
            [params setObject:self.preOrderTextView.text forKey:@"preOrderingMessage" ];
        }
        
        if (self.onlineReservationsSwitch.on){
            [params setObject:@"true" forKey:@"isWaitListOnlineReservationsEnabled" ];
        }else{
            [params setObject:@"false" forKey:@"isWaitListOnlineReservationsEnabled" ];
        }
        
        if (self.allowMessagesSwitch.on){
            [params setObject:@"true" forKey:@"isWaitListAllowMessages" ];
        }else{
            [params setObject:@"false" forKey:@"isWaitListAllowMessages" ];
        }
        
        if (self.allowPreOrderingSwitch.on){
            [params setObject:@"true" forKey:@"isPreOrderingEnabled" ];
        }else{
            [params setObject:@"false" forKey:@"isPreOrderingEnabled" ];
        }
        
        [self.activityView startAnimating];
        [[RKClient sharedClient] post:@"/waitlist/restaurant/messageoptions" params:params delegate:self];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Messages" message:@"Some of your messages are too long.  Please fix." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    NSNumber *remainingCharacters = nil;
    if (textView == self.waitListPageTextView){
        remainingCharacters = [[NSNumber alloc] initWithInt:250 - self.waitListPageTextView.text.length];
        self.waitListPageCountLabel.text = remainingCharacters.stringValue;
        
        if (remainingCharacters.intValue > 0){
            waitListPageCountLabel.textColor = [UIColor blackColor];
        }else{
            waitListPageCountLabel.textColor = [UIColor redColor];
        }
    }else if (textView == self.tableReadyTextView){
        remainingCharacters = [[NSNumber alloc] initWithInt:160 - self.tableReadyTextView.text.length];
        self.tableReadyCountLabel.text = remainingCharacters.stringValue;
        
        if (remainingCharacters.intValue > 0){
            tableReadyCountLabel.textColor = [UIColor blackColor];
        }else{
            tableReadyCountLabel.textColor = [UIColor redColor];
        }
    }else if (textView == self.welcomeTextView){
        remainingCharacters = [[NSNumber alloc] initWithInt:127 - self.welcomeTextView.text.length];
        self.welcomeCountLabel.text = remainingCharacters.stringValue;
        
        if (remainingCharacters.intValue > 0){
            welcomeCountLabel.textColor = [UIColor blackColor];
        }else{
            welcomeCountLabel.textColor = [UIColor redColor];
        }
    }else if (textView == self.preOrderTextView){
        remainingCharacters = [[NSNumber alloc] initWithInt:250 - self.preOrderTextView.text.length];
        self.preOrderCountLabel.text = remainingCharacters.stringValue;
        
        if (remainingCharacters.intValue > 0){
            self.preOrderCountLabel.textColor = [UIColor blackColor];
        }else{
            self.preOrderCountLabel.textColor = [UIColor redColor];
        }
    }
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
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
                    CGMessageOptions *messageOptions = result.asObject;
                    if (messageOptions){
                        if (messageOptions.isWaitListAllowMessages){
                            [self.allowMessagesSwitch setOn:YES];
                        }else{
                            [self.allowMessagesSwitch setOn:NO];
                        }
                        
                        if (messageOptions.isPreOrderingEnabled){
                            [self.allowPreOrderingSwitch setOn:YES];
                        }else{
                            [self.allowPreOrderingSwitch setOn:NO];
                        }
                        
                        if (messageOptions.isWaitListOnlineReservationsEnabled){
                            [self.onlineReservationsSwitch setOn:YES];
                        }else{
                            [self.onlineReservationsSwitch setOn:NO];
                        }
                        
                        if (messageOptions.waitListWelcomeMessage){
                            self.welcomeTextView.text = messageOptions.waitListWelcomeMessage;
                            NSNumber *stringLength = [NSNumber numberWithInteger:127 - messageOptions.waitListWelcomeMessage.length];
                            self.welcomeCountLabel.text = stringLength.stringValue;
                        }
                        
                        if (messageOptions.tableReadyTextMessage){
                            self.tableReadyTextView.text = messageOptions.tableReadyTextMessage;
                            NSNumber *stringLength = [NSNumber numberWithInteger:160 - messageOptions.tableReadyTextMessage.length];
                            self.tableReadyCountLabel.text = stringLength.stringValue;
                        }
                        
                        if (messageOptions.userWaitListPageMessage){
                            self.waitListPageTextView.text = messageOptions.userWaitListPageMessage;
                            NSNumber *stringLength = [NSNumber numberWithInteger:250 - messageOptions.userWaitListPageMessage.length];
                            self.waitListPageCountLabel.text = stringLength.stringValue;
                        }
                        
                        if (messageOptions.preOrderingMessage){
                            self.preOrderTextView.text = messageOptions.preOrderingMessage;
                            NSNumber *stringLength = [NSNumber numberWithInteger:250 - messageOptions.preOrderingMessage.length];
                            self.preOrderCountLabel.text = stringLength.stringValue;
                        }
                    }
                }
            }
        }
    }
    
    [self.activityView stopAnimating];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)managePreOrder:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://citygusto.com/restaurantPreOrdering/list/id?restaurantId=%@", self.currentRestaurant.restaurantId]]];
}
@end
