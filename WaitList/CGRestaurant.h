//
//  CGRestaurant.h
//  WaitList
//
//  Created by Padraic Doyle on 11/5/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGRestaurant : NSObject

@property (nonatomic, strong) NSNumber *restaurantId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address1;


@property (nonatomic, assign, getter=isWaitListOnlineReservationsEnabled) BOOL waitListOnlineReservationsEnabled;
@property (nonatomic, assign, getter=isWaitListAllowMessages) BOOL waitListAllowMessages;
@property (nonatomic, assign, getter=isPreOrderingEnabled) BOOL preOrderingEnabled;

@property (nonatomic, strong) NSString *waitListWelcomeMessage;
@property (nonatomic, strong) NSString *tableReadyTextMessage;
@property (nonatomic, strong) NSString *userWaitListPageMessage;
@property (nonatomic, strong) NSString *preOrderingMessage;


@end
