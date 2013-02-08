//
//  CGMessageOptionsViewController.m
//  WaitList
//
//  Created by Padraic Doyle on 2/8/13.
//  Copyright (c) 2013 Padraic Doyle. All rights reserved.
//

#import "CGMessageOptionsViewController.h"
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


@synthesize scrollView;

- (void)viewDidLoad
{
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        UIImage *navBarImg = [UIImage imageNamed:@"appHeader.png"];
        [self.navigationController.navigationBar setBackgroundImage:navBarImg forBarMetrics:UIBarMetricsDefault];
        
    }
    
    if (self.currentRestaurant){
        if (self.currentRestaurant.isWaitListAllowMessages){
            [self.allowMessagesSwitch setOn:YES];
        }else{
            [self.allowMessagesSwitch setOn:NO];
        }
        
        if (self.currentRestaurant.isWaitListOnlineReservationsEnabled){
            [self.onlineReservationsSwitch setOn:YES];
        }else{
            [self.onlineReservationsSwitch setOn:NO];
        }
        
        if (self.currentRestaurant.waitListWelcomeMessage){
            self.welcomeTextView.text = self.currentRestaurant.waitListWelcomeMessage;
            NSNumber *stringLength = [NSNumber numberWithInteger:139 - self.currentRestaurant.waitListWelcomeMessage.length];
            self.welcomeCountLabel.text = stringLength.stringValue;
        }
        
        if (self.currentRestaurant.tableReadyTextMessage){
            self.tableReadyTextView.text = self.currentRestaurant.tableReadyTextMessage;
            NSNumber *stringLength = [NSNumber numberWithInteger:139 - self.currentRestaurant.tableReadyTextMessage.length];
            self.tableReadyCountLabel.text = stringLength.stringValue;
        }
        
        if (self.currentRestaurant.userWaitListPageMessage){
            self.waitListPageTextView.text = self.currentRestaurant.userWaitListPageMessage;
            NSNumber *stringLength = [NSNumber numberWithInteger:250 - self.currentRestaurant.userWaitListPageMessage.length];
            self.waitListPageCountLabel.text = stringLength.stringValue;
        }
    }
    
    self.scrollView.delegate = self;
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 1000)];
    
    [self setupTextView:self.waitListPageTextView];
    [self setupTextView:self.tableReadyTextView];
    [self setupTextView:self.welcomeTextView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
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
    if (self.welcomeTextView.text.length <= 139 && self.tableReadyTextView.text.length <= 139 && self.waitListPageTextView.text.length <= 250){
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
            [params setObject:self.waitListPageTextView.text forKey:@"waitListWelcomeMessage"];
            self.currentRestaurant.userWaitListPageMessage = self.waitListPageTextView.text;
        }
        
        if (self.tableReadyTextView.text != nil){
            [params setObject:self.tableReadyTextView.text forKey:@"tableReadyTextMessage"];
            self.currentRestaurant.tableReadyTextMessage = self.tableReadyTextView.text;
        }
        
        if (self.welcomeTextView.text != nil){
            [params setObject:self.welcomeTextView.text forKey:@"waitListWelcomeMessage" ];
            self.currentRestaurant.waitListWelcomeMessage = self.welcomeTextView.text;
        }
        
        if (self.onlineReservationsSwitch.on){
            [params setObject:@"true" forKey:@"isWaitListOnlineReservationsEnabled" ];
            self.currentRestaurant.waitListOnlineReservationsEnabled = YES;
        }else{
            [params setObject:@"false" forKey:@"isWaitListOnlineReservationsEnabled" ];
            self.currentRestaurant.waitListOnlineReservationsEnabled = NO;
        }
        
        if (self.allowMessagesSwitch.on){
            [params setObject:@"true" forKey:@"isWaitListAllowMessages" ];
            self.currentRestaurant.waitListAllowMessages = YES;
        }else{
            [params setObject:@"false" forKey:@"isWaitListAllowMessages" ];
            self.currentRestaurant.waitListAllowMessages = NO;
        }
        
        
        [[RKClient sharedClient] post:@"/waitlist/restaurant/messageoptions" params:params delegate:self];
        [self dismissViewControllerAnimated:YES completion:nil];
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
        remainingCharacters = [[NSNumber alloc] initWithInt:139 - self.tableReadyTextView.text.length];
        self.tableReadyCountLabel.text = remainingCharacters.stringValue;
        
        if (remainingCharacters.intValue > 0){
            tableReadyCountLabel.textColor = [UIColor blackColor];
        }else{
            tableReadyCountLabel.textColor = [UIColor redColor];
        }
    }else if (textView == self.welcomeTextView){
        remainingCharacters = [[NSNumber alloc] initWithInt:139 - self.welcomeTextView.text.length];
        self.welcomeCountLabel.text = remainingCharacters.stringValue;
        
        if (remainingCharacters.intValue > 0){
            welcomeCountLabel.textColor = [UIColor blackColor];
        }else{
            welcomeCountLabel.textColor = [UIColor redColor];
        }
    }
    
    
}

@end
