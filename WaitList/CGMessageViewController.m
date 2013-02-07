//
//  CGMessageViewController.m
//  WaitList
//
//  Created by Padraic Doyle on 1/23/13.
//  Copyright (c) 2013 Padraic Doyle. All rights reserved.
//

#import "CGMessageViewController.h"
#import "CGMessageCell.h"
#import "CGMessage.h"
#import "CGUtils.h"
#import <QuartzCore/QuartzCore.h>
#import <RestKit/RestKit.h>

@interface CGMessageViewController ()

@end

@implementation CGMessageViewController

@synthesize messageDetailLabel;
@synthesize currentRestaurant;
@synthesize messageTextView;
@synthesize messageView;
@synthesize characterCountLabel;
@synthesize backButton;

- (void)viewDidLoad
{
    self.messageDetailLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString *messageDetail = @"Previous Messages with ";
    messageDetail = [messageDetail stringByAppendingString:self.waitListee.guest.name];
    messageDetail = [messageDetail stringByAppendingString:@" - Party of "];
    messageDetail = [messageDetail stringByAppendingString:self.waitListee.numberInParty.stringValue];
    
    self.messageDetailLabel.text = messageDetail;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserId];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
    
    NSString *fbUid = [[NSUserDefaults standardUserDefaults] objectForKey:kFbUid];
    if (fbUid != nil){
        [params setObject:fbUid forKey:@"fbUid"];
    }
    
    [params setObject:userId forKey:@"userId"];
    [params setObject:password forKey:@"password"];
    
    NSString *urlString = @"/restaurants/";
    urlString = [urlString stringByAppendingString:self.currentRestaurant.restaurantId.stringValue];
    urlString = [urlString stringByAppendingString:@"/waitlist/"];
    urlString = [urlString stringByAppendingString:self.waitListee.waitListId.stringValue];
    urlString = [urlString stringByAppendingString:@"/messages/read"];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.messageView.frame.size.height - 1, self.messageView.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor blackColor].CGColor;
    
    [self.messageView.layer addSublayer:bottomBorder];
    
    [self.messageTextView.layer setCornerRadius:10.0f];
    [self.messageTextView.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.messageTextView.layer setBorderWidth:1.0f];
    self.messageTextView.clipsToBounds = YES;
    self.messageTextView.delegate = self;
    
    [[RKClient sharedClient] post:urlString params:params delegate:self];
    
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.waitListee.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MessageCell";
    
    CGMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil){
        cell = [[CGMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    CGMessage *message = [self.waitListee.messages objectAtIndex:indexPath.row];

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm"];
    NSString *dateString = [dateFormatter stringFromDate:message.dateCreated];
    
    if (message.isRestaurantSent){
        cell.fromLabel.textAlignment = NSTextAlignmentRight;
        cell.fromLabel.textColor = [UIColor colorWithRed:137.0/255.0 green:173.0/255.0 blue:98.0/255.0 alpha:1];
        
        NSString *fromLabel = @"From Me - ";
        fromLabel = [fromLabel stringByAppendingString:dateString];
        
        cell.fromLabel.text = fromLabel;
    }else{
        cell.fromLabel.textAlignment = NSTextAlignmentLeft;
        cell.fromLabel.textColor = [UIColor colorWithRed:98.0/255.0 green:137.0/255.0 blue:173.0/255.0 alpha:1];
        
        NSString *fromLabel = @"From ";
        fromLabel = [fromLabel stringByAppendingString:self.waitListee.guest.name];
        fromLabel = [fromLabel stringByAppendingString:@" - "];
        fromLabel = [fromLabel stringByAppendingString:dateString];
        
        cell.fromLabel.text = fromLabel;
    }
    
    cell.messageTextView.text = message.message;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)viewDidUnload {
    [self setMessageDetailLabel:nil];
    [self setMessageTextView:nil];
    [self setMessageView:nil];
    [self setCharacterCountLabel:nil];
    [self setBackButton:nil];
    [super viewDidUnload];
}
- (IBAction)send:(id)sender {
    if (self.messageTextView.text.length > 0){
        if (self.messageTextView.text.length <= 115){
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            
            NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserId];
            NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
            
            NSString *fbUid = [[NSUserDefaults standardUserDefaults] objectForKey:kFbUid];
            if (fbUid != nil){
                [params setObject:fbUid forKey:@"fbUid"];
            }
            
            [params setObject:userId forKey:@"userId"];
            [params setObject:password forKey:@"password"];
            
            NSString *urlString = @"/restaurants/";
            urlString = [urlString stringByAppendingString:self.currentRestaurant.restaurantId.stringValue];
            urlString = [urlString stringByAppendingString:@"/waitlist/"];
            urlString = [urlString stringByAppendingString:self.waitListee.waitListId.stringValue];
            urlString = [urlString stringByAppendingString:@"/messages/send"];
            
            [params setObject:self.messageTextView.text forKey:@"message"];
            
            [[RKClient sharedClient] post:urlString params:params delegate:self];
            
            CGMessage *newMessage = [[CGMessage alloc] init];
            
            newMessage.message = self.messageTextView.text;
            newMessage.restaurantSent = YES;
            newMessage.dateCreated = [NSDate date];
            
            [self.waitListee.messages insertObject:newMessage atIndex:0];
            
            [self.tableView reloadData];
            
            self.messageTextView.text = @"";
            [self.messageTextView resignFirstResponder];
        }else{
            [[[UIAlertView alloc] initWithTitle:@"Message" message:@"Message can not be over 115 characters." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Message" message:@"Message can not be blank." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
}

-(void)textViewDidChange:(UITextView *)textView
{
    NSNumber *remainingCharacters = [[NSNumber alloc] initWithInt:115 - self.messageTextView.text.length];
    characterCountLabel.text = remainingCharacters.stringValue;
    
    if (remainingCharacters.intValue > 0){
        characterCountLabel.textColor = [UIColor blackColor];
    }else{
        characterCountLabel.textColor = [UIColor redColor];
    }
}

    

@end
