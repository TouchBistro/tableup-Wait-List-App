//
//  CGRestaurantWaitListCell.m
//  WaitList
//
//  Created by Padraic Doyle on 10/19/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import "CGRestaurantWaitListCell.h"

@implementation CGRestaurantWaitListCell

@synthesize name;
@synthesize estimatedWaitTime;
@synthesize estimatedWaitTimeRemaining;
@synthesize textSentTimeAgo;
@synthesize numberInParty;
@synthesize addOnlineImage;
@synthesize tableNumberLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
