//
//  CGAppDelegate.m
//  WaitList
//
//  Created by Padraic Doyle on 10/9/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import "CGAppDelegate.h"
#import "CGRestaurantGuest.h"
#import "CGRestaurantWaitList.h"

#import <RestKit/RestKit.h>

@implementation CGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [RKClient clientWithBaseURL:[[NSURL alloc] initWithString:@"http://localhost:8080/MattsMenus/mobile"]];
    [RKObjectManager objectManagerWithBaseURL:[[NSURL alloc] initWithString:@"http://localhost:8080/MattsMenus/mobile"]];
    
    RKObjectMapping *guestMapping = [RKObjectMapping mappingForClass:[CGRestaurantGuest class]];
    [guestMapping mapKeyPath:@"id" toAttribute:@"guestId"];
    [guestMapping mapKeyPath:@"name" toAttribute:@"name"];
    [guestMapping mapKeyPath:@"email" toAttribute:@"email"];
    [guestMapping mapKeyPath:@"phoneNumber" toAttribute:@"phoneNumber"];
    [guestMapping mapKeyPath:@"guestRestaurantURL" toAttribute:@"guestRestaurantURLString"];
    [guestMapping mapKeyPath:@"shortenedGuestRestaurantURL" toAttribute:@"shortenedGuestRestaurantURLString"];
    [guestMapping mapKeyPath:@"permanentNotes" toAttribute:@"permanentNotes"];
    [guestMapping mapKeyPath:@"totalNumberOfVisits" toAttribute:@"totalNumberOfVisits"];
    [guestMapping mapKeyPath:@"lastVisit" toAttribute:@"lastVisit"];
    
    RKObjectMapping *waitListMapping = [RKObjectMapping mappingForClass:[CGRestaurantWaitList class]];
    [waitListMapping mapKeyPath:@"id" toAttribute:@"waitListId"];
    [waitListMapping mapKeyPath:@"estimatedWait" toAttribute:@"estimatedWait"];
    [waitListMapping mapKeyPath:@"numberInParty" toAttribute:@"numberInParty"];
    [waitListMapping mapKeyPath:@"visitNotes" toAttribute:@"visitNotes"];
    [waitListMapping mapKeyPath:@"reserveOnline" toAttribute:@"reserveOnline"];
    [waitListMapping mapKeyPath:@"timeTableReadyTextSent" toAttribute:@"timeTableReadyTextSent"];
    [waitListMapping mapKeyPath:@"timeSeated" toAttribute:@"timeSeated"];
    [waitListMapping mapKeyPath:@"timeRemovedFromWaitList" toAttribute:@"timeRemovedFromWaitList"];
    [waitListMapping mapKeyPath:@"timeSinceTextSent" toAttribute:@"timeSinceTextSent"];
    [waitListMapping mapKeyPath:@"timeOnWaitList" toAttribute:@"timeOnWaitList"];
    [waitListMapping mapKeyPath:@"dateCreated" toAttribute:@"dateCreated"];
    [waitListMapping mapKeyPath:@"lastUpdated" toAttribute:@"lastUpdated"];
        
    [waitListMapping mapKeyPath:@"guest" toRelationship:@"guest" withMapping:guestMapping];
    
    [[RKObjectManager sharedManager].mappingProvider setMapping:guestMapping forKeyPath:@"guests"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:waitListMapping forKeyPath:@"waitlisters"];
    
    return YES;
}


							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
