//
//  CGRestaurantWaitList.h
//  WaitList
//
//  Created by Padraic Doyle on 10/18/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGRestaurantGuest.h"

@interface CGRestaurantWaitList : NSObject

@property (nonatomic, strong) NSNumber *waitListId;
@property (nonatomic, strong) NSNumber *estimatedWait;
@property (nonatomic, strong) NSNumber *numberInParty;

@property (nonatomic, strong) NSString *visitNotes;
@property (nonatomic, strong) NSString *tableNumber;

@property (nonatomic, assign, getter=isReserveOnline) BOOL reserveOnline;
@property (nonatomic, assign) BOOL hasPreOrderItems;
@property (nonatomic, assign) BOOL hasUnreadMessages;


@property (nonatomic, strong) NSDate *timeTableReadyTextSent;
@property (nonatomic, strong) NSDate *timeSeated;
@property (nonatomic, strong) NSDate *timeRemovedFromWaitList;

@property (nonatomic, strong) NSDate *dateCreated;
@property (nonatomic, strong) NSDate *lastUpdated;

@property (nonatomic, strong) NSNumber *timeOnWaitList;
@property (nonatomic, strong) NSNumber *timeSinceTextSent;

@property (nonatomic, strong) NSNumber *statusNumber;

@property (nonatomic, strong) CGRestaurantGuest *guest;

@property (nonatomic, strong) NSMutableArray *messages;

@end
