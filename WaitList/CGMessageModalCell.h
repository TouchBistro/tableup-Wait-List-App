//
//  CGMessageModalCell.h
//  WaitList
//
//  Created by Padraic Doyle on 1/29/13.
//  Copyright (c) 2013 Padraic Doyle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGMessageModalCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *fromLabel;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;

@end
