//
//  CGRestaurantGuest.h
//  WaitList
//
//  Created by Padraic Doyle on 10/18/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGRestaurantGuest : NSObject

@property (nonatomic, strong) NSNumber *guestId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *permanentNotes;
@property (nonatomic, strong) NSString *guestRestaurantURLString;
@property (nonatomic, strong) NSString *shortenedGuestRestaurantURLString;
@property (nonatomic, strong) NSNumber *totalNumberOfVisits;
@property (nonatomic, strong) NSDate *lastVisit;

@property (nonatomic, strong) NSNumber *averageWait;
@property (nonatomic, strong) NSNumber *averageParty;

@property (nonatomic, strong) NSMutableArray *waitListHistory;

@end
