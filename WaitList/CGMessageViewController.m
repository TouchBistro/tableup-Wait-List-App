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
#import <RestKit/RestKit.h>

@interface CGMessageViewController ()

@end

@implementation CGMessageViewController

@synthesize messageDetailLabel;
@synthesize messageTextField;
@synthesize currentRestaurant;

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
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:message.dateCreated];
    
    if (message.isRestaurantSent){
        cell.fromLabel.textAlignment = NSTextAlignmentRight;
        cell.fromLabel.textColor = [UIColor greenColor];
        
        NSString *fromLabel = @"From Me - ";
        fromLabel = [fromLabel stringByAppendingString:dateString];
        
        cell.fromLabel.text = fromLabel;
    }else{
        cell.fromLabel.textAlignment = NSTextAlignmentLeft;
        cell.fromLabel.textColor = [UIColor blueColor];
        
        NSString *fromLabel = @"From ";
        fromLabel = [fromLabel stringByAppendingString:self.waitListee.guest.name];
        fromLabel = [fromLabel stringByAppendingString:@" - "];
        fromLabel = [fromLabel stringByAppendingString:dateString];
        
        cell.fromLabel.text = fromLabel;
    }
    
    cell.messageTextView.text = message.message;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)viewDidUnload {
    [self setMessageTextField:nil];
    [self setMessageDetailLabel:nil];
    [super viewDidUnload];
}
- (IBAction)send:(id)sender {
    if (self.messageTextField.text.length > 0){
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
        
        [params setObject:self.messageTextField.text forKey:@"message"];
        
        [[RKClient sharedClient] post:urlString params:params delegate:self];
        
        CGMessage *newMessage = [[CGMessage alloc] init];
       
        newMessage.message = self.messageTextField.text;
        newMessage.restaurantSent = YES;
        newMessage.dateCreated = [NSDate date];
        
        [self.waitListee.messages insertObject:newMessage atIndex:0];
        
        [self.tableView reloadData];
        
        self.messageTextField.text = @"";
        [self.messageTextField resignFirstResponder];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Message" message:@"Message can not be blank." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
    }
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
}

@end
