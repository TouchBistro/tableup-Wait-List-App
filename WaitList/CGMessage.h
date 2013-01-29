//
//  CGMessage.h
//  WaitList
//
//  Created by Padraic Doyle on 1/23/13.
//  Copyright (c) 2013 Padraic Doyle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGMessage : NSObject

@property (nonatomic, strong) NSNumber *messageId;

@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign, getter=isRestaurantSent) BOOL restaurantSent;

@property (nonatomic, strong) NSDate *dateCreated;
@property (nonatomic, assign) BOOL hasBeenRead;

@end
