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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 800)];
    
    // Create Login View so that the app will be granted "status_update" permission.
    self.facebookLoginView.delegate = self;
    [self.facebookLoginView sizeToFit];
    
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
        [[RKClient sharedClient] post:@"/waitlist/facebook/login" params:params delegate:self];
    }
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
}



@end
