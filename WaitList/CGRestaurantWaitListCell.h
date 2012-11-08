//
//  CGRestaurantWaitListCell.h
//  WaitList
//
//  Created by Padraic Doyle on 10/19/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGRestaurantWaitListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *estimatedWaitTime;
@property (strong, nonatomic) IBOutlet UILabel *estimatedWaitTimeRemaining;
@property (strong, nonatomic) IBOutlet UILabel *textSentTimeAgo;
@property (strong, nonatomic) IBOutlet UILabel *numberInParty;
@property (strong, nonatomic) IBOutlet UIImageView *notifyImage;

@end
