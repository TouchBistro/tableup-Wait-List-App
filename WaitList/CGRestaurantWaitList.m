//
//  CGRestaurantWaitList.m
//  WaitList
//
//  Created by Padraic Doyle on 10/18/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import "CGRestaurantWaitList.h"

@implementation CGRestaurantWaitList

@synthesize waitListId;
@synthesize estimatedWait;
@synthesize numberInParty;

@synthesize visitNotes;
@synthesize tableNumber;

@synthesize reserveOnline;

@synthesize timeTableReadyTextSent;
@synthesize timeSeated;
@synthesize timeRemovedFromWaitList;

@synthesize dateCreated;
@synthesize lastUpdated;

@synthesize guest;

@synthesize timeOnWaitList;
@synthesize timeSinceTextSent;


- (NSDictionary*)elementToPropertyMappings {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"id", @"waitListId",
            @"estimatedWait", @"estimatedWait",
            @"numberInParty", @"numberInParty",
            @"visitNotes", @"visitNotes",
            @"reserveOnline", @"reserveOnline",
            @"timeTableReadyTextSent", @"timeTableReadyTextSent",
            @"timeSeated", @"timeSeated",
            @"timeRemovedFromWaitList", @"timeRemovedFromWaitList",
            @"dateCreated", @"dateCreated",
            @"lastUpdated", @"lastUpdated",
            @"guest", @"guest",
            nil];
}

@end
