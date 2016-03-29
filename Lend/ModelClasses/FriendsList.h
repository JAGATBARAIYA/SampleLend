//
//  FriendsList.h
//  Lend
//
//  Created by Manish on 09/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendHeader.h"

@interface FriendsList : NSObject

@property (assign, nonatomic) NSInteger intFriendID;
@property (assign, nonatomic) NSInteger intFriendAutoID;
@property (strong, nonatomic) NSString *strName;
@property (strong, nonatomic) NSString *strEmail;
@property (strong, nonatomic) NSString *strPhoneNo;
@property (strong, nonatomic) NSString *strSmilyStatus;

@property (strong, nonatomic) NSMutableArray *arrItem;

@property (assign, nonatomic, getter=isOpen) BOOL open;

- (id)initWithDict:(NSDictionary *)dict;
+ (id)dataWithDictionary:(NSDictionary *)dict;

@end
