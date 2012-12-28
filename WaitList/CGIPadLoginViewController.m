//
//  CGIPadLoginViewController.m
//  WaitList
//
//  Created by Padraic Doyle on 12/11/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import "CGIPadLoginViewController.h"
#import "CGUtils.h"
#import "CGWaitListTableActionsViewController.h"
#import "CGAddGuestIPadTableViewController.h"
#import <RestKit/RestKit.h>
#import <FacebookSDK/FacebookSDK.h>


@interface CGIPadLoginViewController ()

@end

@implementation CGIPadLoginViewController

- (void)viewDidLoad
{
    self.facebookLoginView.delegate = self;
//    [self.facebookLoginView sizeToFit];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsUserId];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPassword];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsUsername];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kFbUid];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
                        [self performSegueWithIdentifier: @"loginIPadSuccess" sender: self];
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
        
        UINavigationController *navController = [segue destinationViewController];
        
        if (navController != nil){
            CGWaitListTableActionsViewController *waitListTableViewController = (CGWaitListTableActionsViewController *)navController.topViewController;
            
            if (waitListTableViewController != nil){
                waitListTableViewController.loggedInUser = self.loggedInUser;
                waitListTableViewController.currentRestaurant = [self.loggedInUser.ownedRestaurants objectAtIndex:0];
            }
        }
    }
}

- (void)viewDidUnload {
    [self setUsernameTextField:nil];
    [self setPasswordTextField:nil];
    [super viewDidUnload];
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





@end
