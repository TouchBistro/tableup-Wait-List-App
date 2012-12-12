//
//  CGAccountViewController.h
//  WaitList
//
//  Created by Padraic Doyle on 12/11/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import "CGRestaurant.h"
#import <UIKit/UIKit.h>

@protocol CCAccountViewDelegate
- (void)restaurantSelected:(CGRestaurant *)restaurant;
@end


@interface CGAccountViewController : UITableViewController {
    NSMutableArray *_restaurants;
    id <CCAccountViewDelegate> delegate;
}

@property (nonatomic, retain) NSMutableArray *restaurants;
@property (nonatomic, assign) id <CCAccountViewDelegate> delegate;

@end
