//
//  CGOwnerAccountInfoViewController.h
//  WaitList
//
//  Created by Padraic Doyle on 11/5/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGUser.h"
#import "CGRestaurant.h"

@interface CGOwnerAccountInfoViewController : UIViewController

@property (nonatomic, strong) CGUser *loggedInUser;
@property (strong, nonatomic) IBOutlet UIButton *currentVenueButton;
- (IBAction)logOut:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *currentVenueLabel;
@property (strong, nonatomic) IBOutlet UIButton *changeRestaurantButton;

@property (nonatomic, strong) CGRestaurant *currentRestaurant;
@property (strong, nonatomic) IBOutlet UITextView *adminMessageTextView;

@end
