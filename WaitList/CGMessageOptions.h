//
//  CGMessageOptions.h
//  WaitList
//
//  Created by Padraic Doyle on 2/12/13.
//  Copyright (c) 2013 Padraic Doyle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGMessageOptions : NSObject

@property (nonatomic, assign, getter=isWaitListOnlineReservationsEnabled) BOOL waitListOnlineReservationsEnabled;
@property (nonatomic, assign, getter=isWaitListAllowMessages) BOOL waitListAllowMessages;

@property (nonatomic, strong) NSString *waitListWelcomeMessage;
@property (nonatomic, strong) NSString *tableReadyTextMessage;
@property (nonatomic, strong) NSString *userWaitListPageMessage;

@end
