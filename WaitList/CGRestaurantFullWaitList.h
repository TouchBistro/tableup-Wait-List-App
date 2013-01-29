//
//  CGRestaurantFullWaitList.h
//  WaitList
//
//  Created by Padraic Doyle on 12/5/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGRestaurantFullWaitList : NSObject

@property (nonatomic, strong) NSNumber *fullWaitListId;

@property (nonatomic, strong) NSNumber *totalParties;
@property (nonatomic, strong) NSNumber *totalGuests;
@property (nonatomic, strong) NSNumber *estimatedWait;

@property (nonatomic, assign) BOOL unreadMessages;
@property (nonatomic, strong) NSNumber *numberOfUnreadMessages;

@property (nonatomic, strong) NSMutableArray *waitListers;



@end
