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

@property (nonatomic, strong) CGRestaurant *currentRestaurant;

@end
