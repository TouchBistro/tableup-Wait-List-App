//
//  CGLoginViewController.h
//  WaitList
//
//  Created by Padraic Doyle on 10/18/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGOwnerAccountInfoViewController.h"
#import "CGUser.h"

@interface CGLoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIScrollView *scroller;

@property (strong, nonatomic) CGUser *loggedInUser;

- (IBAction)login:(id)sender;
- (IBAction)loginFacebook:(id)sender;

@end
