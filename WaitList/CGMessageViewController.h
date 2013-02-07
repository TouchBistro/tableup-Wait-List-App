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

@interface CGMessageViewController : UITableViewController <RKObjectLoaderDelegate, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *messageDetailLabel;

@property (strong, nonatomic) CGRestaurantWaitList *waitListee;
@property (strong, nonatomic) CGRestaurant *currentRestaurant;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;
@property (strong, nonatomic) IBOutlet UIView *messageView;
@property (strong, nonatomic) IBOutlet UILabel *characterCountLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;


- (IBAction)send:(id)sender;

@end