//
//  CGRestaurantWaitListWaitTime.h
//  WaitList
//
//  Created by Padraic Doyle on 12/4/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGRestaurantWaitListWaitTime : NSObject

@property (nonatomic, strong) NSNumber *waitListWaitTimeId;
@property (nonatomic, strong) NSDate *dateCreated;
@property (nonatomic, strong) NSNumber *totalWaitTime;
@property (nonatomic, strong) NSNumber *numberInParty;




@end
