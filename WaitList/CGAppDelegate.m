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
#import "CGRestaurant.h"
#import "CGUser.h"
#import "CGRestaurantWaitListWaitTime.h"
#import "CGRestaurantFullWaitList.h"

#import "CGUtils.h"
#import "CGLoginViewController.h"

#import <RestKit/RestKit.h>


@implementation CGAppDelegate

@synthesize session = _session;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
//    [RKClient clientWithBaseURL:[[NSURL alloc] initWithString:@"http://localhost:8080/MattsMenus/mobile"]];
//    [RKObjectManager objectManagerWithBaseURL:[[NSURL alloc] initWithString:@"http://localhost:8080/MattsMenus/mobile"]];
    
    [RKClient clientWithBaseURL:[[NSURL alloc] initWithString:@"http://citygusto.com/mobile"]];
    [RKObjectManager objectManagerWithBaseURL:[[NSURL alloc] initWithString:@"http://citygusto.com/mobile"]];
    
    RKObjectMapping *waitListWaitTimeMapping = [RKObjectMapping mappingForClass:[CGRestaurantWaitListWaitTime class]];
    [waitListWaitTimeMapping mapKeyPath:@"id" toAttribute:@"waitListWaitTimeId"];
    [waitListWaitTimeMapping mapKeyPath:@"totalWaitTime" toAttribute:@"totalWaitTime"];
    [waitListWaitTimeMapping mapKeyPath:@"dateCreated" toAttribute:@"dateCreated"];
    [waitListWaitTimeMapping mapKeyPath:@"numberInParty" toAttribute:@"numberInParty"];
    
    
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
    [guestMapping mapKeyPath:@"averageWait" toAttribute:@"averageWait"];
    [guestMapping mapKeyPath:@"averageParty" toAttribute:@"averageParty"];
    
    [guestMapping mapKeyPath:@"waitListHistory" toRelationship:@"waitListHistory" withMapping:waitListWaitTimeMapping];
    
    RKObjectMapping *waitListMapping = [RKObjectMapping mappingForClass:[CGRestaurantWaitList class]];
    [waitListMapping mapKeyPath:@"id" toAttribute:@"waitListId"];
    [waitListMapping mapKeyPath:@"estimatedWait" toAttribute:@"estimatedWait"];
    [waitListMapping mapKeyPath:@"numberInParty" toAttribute:@"numberInParty"];
    [waitListMapping mapKeyPath:@"visitNotes" toAttribute:@"visitNotes"];
    [waitListMapping mapKeyPath:@"tableNumber" toAttribute:@"tableNumber"];
    [waitListMapping mapKeyPath:@"reserveOnline" toAttribute:@"reserveOnline"];
    [waitListMapping mapKeyPath:@"timeTableReadyTextSent" toAttribute:@"timeTableReadyTextSent"];
    [waitListMapping mapKeyPath:@"timeSeated" toAttribute:@"timeSeated"];
    [waitListMapping mapKeyPath:@"timeRemovedFromWaitList" toAttribute:@"timeRemovedFromWaitList"];
    [waitListMapping mapKeyPath:@"timeSinceTextSent" toAttribute:@"timeSinceTextSent"];
    [waitListMapping mapKeyPath:@"timeOnWaitList" toAttribute:@"timeOnWaitList"];
    [waitListMapping mapKeyPath:@"dateCreated" toAttribute:@"dateCreated"];
    [waitListMapping mapKeyPath:@"lastUpdated" toAttribute:@"lastUpdated"];
        
    [waitListMapping mapKeyPath:@"guest" toRelationship:@"guest" withMapping:guestMapping];
    
    RKObjectMapping *fullWaitListMapping = [RKObjectMapping mappingForClass:[CGRestaurantFullWaitList class]];
    [fullWaitListMapping mapKeyPath:@"id" toAttribute:@"fullWaitListId"];
    [fullWaitListMapping mapKeyPath:@"totalGuests" toAttribute:@"totalGuests"];
    [fullWaitListMapping mapKeyPath:@"totalParties" toAttribute:@"totalParties"];
    [fullWaitListMapping mapKeyPath:@"estimatedWait" toAttribute:@"estimatedWait"];
    
    [fullWaitListMapping mapKeyPath:@"waitListers" toRelationship:@"waitListers" withMapping:waitListMapping];
    
    RKObjectMapping *restaurantMapping = [RKObjectMapping mappingForClass:[CGRestaurant class]];
    [restaurantMapping mapKeyPath:@"id" toAttribute:@"restaurantId"];
    [restaurantMapping mapKeyPath:@"name" toAttribute:@"name"];
    [restaurantMapping mapKeyPath:@"address1" toAttribute:@"address1"];
    
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[CGUser class]];
    [userMapping mapKeyPath:@"id" toAttribute:@"userId"];
    [userMapping mapKeyPath:@"username" toAttribute:@"username"];
    [userMapping mapKeyPath:@"firstname" toAttribute:@"firstname"];
    [userMapping mapKeyPath:@"lastname" toAttribute:@"lastname"];
    
    [userMapping mapKeyPath:@"ownedRestaurants" toRelationship:@"ownedRestaurants" withMapping:restaurantMapping];
    
    [[RKObjectManager sharedManager].mappingProvider setMapping:guestMapping forKeyPath:@"guests"];
//    [[RKObjectManager sharedManager].mappingProvider setMapping:waitListMapping forKeyPath:@"waitlisters"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:userMapping forKeyPath:@"user"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:fullWaitListMapping forKeyPath:@"waitList"];
    
    
    UIImage *image = [[UIImage imageNamed:@"headerButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 10, 1, 10)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
    
    
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
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [FBSession.activeSession close];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

@end
