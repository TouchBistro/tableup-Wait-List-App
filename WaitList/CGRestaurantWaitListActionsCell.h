//
//  CGRestaurantWaitListActionsCell.h
//  WaitList
//
//  Created by Padraic Doyle on 12/11/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGRestaurantWaitListActionsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *estimatedWaitTime;
@property (strong, nonatomic) IBOutlet UILabel *textSentTimeAgo;
@property (strong, nonatomic) IBOutlet UILabel *numberInParty;
@property (strong, nonatomic) IBOutlet UIImageView *notifyImage;
@property (strong, nonatomic) IBOutlet UILabel *visitNotesLabel;
@property (strong, nonatomic) IBOutlet UILabel *tableNumberLabel;
@property (strong, nonatomic) IBOutlet UIImageView *addOnlineImageView;


@property (strong, nonatomic) IBOutlet UIButton *notifyButton;
@property (strong, nonatomic) IBOutlet UIButton *seatedButton;
@property (strong, nonatomic) IBOutlet UIButton *removeButton;
@property (strong, nonatomic) IBOutlet UIButton *messageButton;
@property (strong, nonatomic) IBOutlet UIImageView *partySizeImageView;

@end
