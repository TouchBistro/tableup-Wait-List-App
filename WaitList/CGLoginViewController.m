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
#import <RestKit/RestKit.h>

@interface CGLoginViewController ()

@end

@implementation CGLoginViewController

@synthesize scroller;
@synthesize passwordTextField;
@synthesize usernameTextField;
@synthesize loggedInUser;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 1000)];
    
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

- (IBAction)loginFacebook:(id)sender {
    CGAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [appDelegate.session closeAndClearTokenInformation];
        
    } else {
        if (appDelegate.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
            [self updateView];
        }];
    }
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



@end
