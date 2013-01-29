//
//  CGMessageViewController.h
//  WaitList
//
//  Created by Padraic Doyle on 1/23/13.
//  Copyright (c) 2013 Padraic Doyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGRestaurantWaitList.h"
#import "CGRestaurant.h"
#import <RestKit/RestKit.h>

@interface CGMessageViewController : UITableViewController <RKObjectLoaderDelegate>

@property (strong, nonatomic) IBOutlet UITextField *messageTextField;
@property (strong, nonatomic) IBOutlet UILabel *messageDetailLabel;

@property (strong, nonatomic) CGRestaurantWaitList *waitListee;
@property (strong, nonatomic) CGRestaurant *currentRestaurant;


- (IBAction)send:(id)sender;

@end
