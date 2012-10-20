//
//  CGAddGuestViewController.m
//  WaitList
//
//  Created by Padraic Doyle on 10/9/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import "CGAddGuestViewController.h"
#import <RestKit/RestKit.h>

@interface CGAddGuestViewController ()

@end

@implementation CGAddGuestViewController
@synthesize navItem;
@synthesize cancelButtonItem;

@synthesize phoneNumberTextField;
@synthesize nameTextField;
@synthesize emailTextField;
@synthesize visitNotesTextField;
@synthesize permanentNotesTextField;
@synthesize numberInPartyTextField;
@synthesize estimatedWaitTextField;


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setNavItem:nil];
    [self setCancelButtonItem:nil];
    [self setPhoneNumberTextField:nil];
    [self setNameTextField:nil];
    [self setNumberInPartyTextField:nil];
    [self setEmailTextField:nil];
    [self setEstimatedWaitTextField:nil];
    [self setVisitNotesTextField:nil];
    [self setPermanentNotesTextField:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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


- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)save:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:@"10" forKey:@"userId"];
    [params setObject:@"admin" forKey:@"password"];
    
    if (self.phoneNumberTextField.text != nil){
        [params setObject:self.phoneNumberTextField.text forKey:@"phoneNumber"];
    }
    
    if (self.nameTextField.text != nil){
        [params setObject:self.nameTextField.text forKey:@"name" ];
    }
    
    if (self.numberInPartyTextField.text != nil){
        [params setObject:self.numberInPartyTextField.text forKey:@"numberInParty"];
    }
    
    if (self.estimatedWaitTextField.text != nil){
        [params setObject:self.estimatedWaitTextField.text forKey:@"estimatedWait"];
    }
    
    if (self.emailTextField.text != nil){
        [params setObject:self.emailTextField.text forKey:@"email"];
    }
    
    if (self.visitNotesTextField.text != nil){
        [params setObject:self.visitNotesTextField.text forKey:@"visitNotes"];
    }
    
    if (self.permanentNotesTextField.text != nil){
        [params setObject:self.permanentNotesTextField.text forKey:@"permanentNotes"];
    }
    
    [[RKClient sharedClient] post:@"/restaurants/1/waitlist" params:params delegate:self];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    if ([request isPOST]) {
        if ([response isOK]) {
            if ([response isJSON]) {
                NSLog(@"Got a JSON response back from our POST!");
            }
        }
    }
    
//    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)saveAndText:(id)sender {
}
@end
