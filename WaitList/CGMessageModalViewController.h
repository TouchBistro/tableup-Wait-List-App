//
//  CGMessageModalViewController.h
//  WaitList
//
//  Created by Padraic Doyle on 1/29/13.
//  Copyright (c) 2013 Padraic Doyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGRestaurant.h"
#import "CGRestaurantWaitList.h"
#import <RestKit/RestKit.h>

@interface CGMessageModalViewController : UITableViewController <RKObjectLoaderDelegate, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *messageDetailLabel;

@property (strong, nonatomic) CGRestaurantWaitList *waitListee;
@property (strong, nonatomic) CGRestaurant *currentRestaurant;

@property (strong, nonatomic) IBOutlet UIView *messageView;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;

@property (strong, nonatomic) IBOutlet UILabel *characterCountLabel;

- (IBAction)close:(id)sender;
- (IBAction)send:(id)sender;

@end
