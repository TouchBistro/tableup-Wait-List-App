//
//  CGOwnerVenueViewController.h
//  WaitList
//
//  Created by Padraic Doyle on 10/12/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import "CGOwnerAccountInfoViewController.h"
#import <UIKit/UIKit.h>

@interface CGOwnerVenueViewController : UITableViewController

@property (nonatomic, strong) NSArray *restaurants;
@property (nonatomic, strong) CGOwnerAccountInfoViewController *ownerAccountInfoViewController;

@end
