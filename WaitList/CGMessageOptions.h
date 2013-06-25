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
@property (nonatomic, assign, getter=isPreOrderingEnabled) BOOL preOrderingEnabled;
@property (nonatomic, assign, getter=isFeedbackEnabled) BOOL feedbackEnabled;

@property (nonatomic, strong) NSString *waitListWelcomeMessage;
@property (nonatomic, strong) NSString *tableReadyTextMessage;
@property (nonatomic, strong) NSString *userWaitListPageMessage;
@property (nonatomic, strong) NSString *preOrderingMessage;
@property (nonatomic, strong) NSString *feedbackMessage;

@property (nonatomic, strong) NSString *waitListStatus1;
@property (nonatomic, strong) NSString *waitListStatus2;
@property (nonatomic, strong) NSString *waitListStatus3;
@property (nonatomic, strong) NSString *waitListStatus4;
@property (nonatomic, strong) NSString *waitListStatus5;

@end
