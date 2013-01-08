//
//  CGLoginViewController.m
//  WaitList
//
//  Created by Padraic Doyle on 10/18/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import "CGLoginViewController.h"
#import "CGUtils.h"
#import "CGUser.h"
#import "CGAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <RestKit/RestKit.h>

@interface CGLoginViewController ()

@end

@implementation CGLoginViewController

@synthesize scroller;
@synthesize passwordTextField;
@synthesize usernameTextField;
@synthesize loggedInUser;
@synthesize facebookLoginView;
@synthesize loginButton;
@synthesize loginNavigationBar;

@synthesize activityView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 800)];
    
    // Create Login View so that the app will be granted "status_update" permission.
    self.facebookLoginView.delegate = self;
    [self.facebookLoginView sizeToFit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    if ([self.loginNavigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        UIImage *navBarImg = [UIImage imageNamed:@"appHeader.png"];
        [self.loginNavigationBar setBackgroundImage:navBarImg forBarMetrics:UIBarMetricsDefault];
        
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsUserId];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPassword];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsUsername];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kFbUid];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setUsernameTextField:nil];
    [self setPasswordTextField:nil];
    [self setFacebookLoginView:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setLoginButton:nil];
    [self setLoginNavigationBar:nil];
    [self setActivityView:nil];
    [super viewDidUnload];
}
- (IBAction)login:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    if (self.usernameTextField.text != nil){
        [params setObject:self.usernameTextField.text forKey:@"username"];
    }
    
    if (self.passwordTextField.text != nil){
        [params setObject:self.passwordTextField.text forKey:@"password" ];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:self.usernameTextField.text forKey:kUserDefaultsUsername];
    [[NSUserDefaults standardUserDefaults] setValue:self.passwordTextField.text forKey:kPassword];
    
    [[RKClient sharedClient] post:@"/waitlist/login" params:params delegate:self];
    
    self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview: activityView];
    
    self.activityView.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.activityView startAnimating];
}


- (void)updateView {
    // get the app delegate, so that we can reference the session property
    CGAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    if (appDelegate.session.isOpen) {
        // valid account UI is shown whenever the session is open
    }
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
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
                    CGUser *user = result.asObject;
                    if (user != nil){
                        [self setLoggedInUser:user];
                        [[NSUserDefaults standardUserDefaults] setValue:user.userId forKey:kUserDefaultsUserId];
                        [self performSegueWithIdentifier: @"loginSuccess" sender: self];
                    }
                }
            }
        }else{
            [[[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Login Failed. Please Try Again." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
        }
    }
    
    [self.activityView stopAnimating];
        
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    UINavigationController *navController = [segue destinationViewController];
    
    if (navController != nil){
        self.passwordTextField.text = @"";
        
        CGOwnerAccountInfoViewController  *ownerAccountInfoController = (CGOwnerAccountInfoViewController *)navController.topViewController;
        if (ownerAccountInfoController != nil){
            ownerAccountInfoController.loggedInUser = [self loggedInUser];
        }
    }
}

#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
    if (user && user.id){
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        
        [params setObject:user.id forKey:@"fbUid"];
        [[NSUserDefaults standardUserDefaults] setValue:user.id  forKey:kPassword]; //set the password to the fbuid...we dont use it for facebook
        [[NSUserDefaults standardUserDefaults] setValue:user.id forKey:kUserDefaultsUsername];
        [[NSUserDefaults standardUserDefaults] setValue:user.id forKey:kFbUid];
        
        
        
        [[RKClient sharedClient] post:@"/waitlist/facebook/login" params:params delegate:self];
    }
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    self.scroller.contentInset = contentInsets;
    self.scroller.scrollIndicatorInsets = contentInsets;
    
    // Step 3: Scroll the target text field into view.
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    if (!CGRectContainsPoint(aRect, self.loginButton.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.loginButton.frame.origin.y - (keyboardSize.height-68));
        [self.scroller setContentOffset:scrollPoint animated:YES];
    }
}

- (void) keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scroller.contentInset = contentInsets;
    self.scroller.scrollIndicatorInsets = contentInsets;
}

- (IBAction)dismissKeyboard:(id)sender
{
    [self.passwordTextField resignFirstResponder];
}



@end
