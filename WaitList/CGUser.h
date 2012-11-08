//
//  CGUser.h
//  WaitList
//
//  Created by Padraic Doyle on 11/5/12.
//  Copyright (c) 2012 Padraic Doyle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGUser : NSObject

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *username;

@property (nonatomic, strong) NSString *firstname;
@property (nonatomic, strong) NSString *lastname;

@property (nonatomic, strong) NSMutableArray *ownedRestaurants;

@end
