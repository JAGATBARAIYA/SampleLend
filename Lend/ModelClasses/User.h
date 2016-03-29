//
//  User.h
//  TravellingApp
//
//  Created by Manish Dudharejia on 15/10/14.
//  Copyright (c) 2014 Marvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (assign, nonatomic) NSInteger intUserId;

@property (strong, nonatomic) NSString *strEmail;
@property (strong, nonatomic) NSString *strName;
@property (strong, nonatomic) NSString *strPhoneName;

@property (assign, nonatomic, getter=isLogin) BOOL login;

+ (User*)sharedUser;

+ (User *)dataWithInfo:(NSDictionary*)dict;
- (void)initWithDictionary:(NSDictionary*)dict;

+ (BOOL)saveCredentials:(NSDictionary*)json;

@end