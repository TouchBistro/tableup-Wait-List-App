//
//  CGWaitListTableViewController.h
//  WaitList
//
//  Created by Padraic Doyle on 10/19/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGGuestDetailTableViewController.h"


@interface CGWaitListTableViewController : UITableViewController <CGGuestDetailTableViewControllerDelegate>{
    UIRefreshControl *refreshControl;
    
}

@property (nonatomic, strong) NSMutableArray *waitListers;
@property (nonatomic, assign, getter=isDataLoaded) BOOL dataLoaded;

-(void) refreshMyTableView;
-(void) retrieveWaitListForDisplay;


- (void)guestDetailControllerDidFinish:(NSArray *)currentWaitList;


@end
