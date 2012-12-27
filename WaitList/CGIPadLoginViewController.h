//
//  CGIPadLoginViewController.h
//  WaitList
//
//  Created by Padraic Doyle on 12/11/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import "CGUser.h"
#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface CGIPadLoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) IBOutlet FBLoginView *facebookLoginView;


@property (strong, nonatomic) CGUser *loggedInUser;

- (IBAction)login:(id)sender;

@end
