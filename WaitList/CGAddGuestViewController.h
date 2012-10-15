//
//  CGAddGuestViewController.h
//  WaitList
//
//  Created by Padraic Doyle on 10/9/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGAddGuestViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButtonItem;
- (IBAction)cancel:(id)sender;

@end
