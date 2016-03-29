//
//  User.m
//  TravellingApp
//
//  Created by Manish Dudharejia on 15/10/14.
//  Copyright (c) 2014 Marvin. All rights reserved.
//

#define kUserID                 @"UserID"
#define kEmail                  @"Email"
#define kName                   @"Name"
#define kPhoneNumber            @"PhoneNumber"
#define kIsLogin                @"IsLogin"

#import "User.h"
#import "Helper.h"
#import "Constants.h"

@implementation User

+ (User*)sharedUser{
    static User *sharedUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        User *user = [Helper getCustomObjectToUserDefaults:kUserInformation];
        if(!user){
            sharedUser = [[User alloc] init];
        }else {
            sharedUser = user;
        }
    });
    return sharedUser;
}

- (instancetype)initWithDict:(NSDictionary*)dict{
    self = [super init];
    if (self) {

    }
    return self;
}

+ (User *)dataWithInfo:(NSDictionary*)dict{
    return [[self alloc] initWithDict:dict];
}

- (void)initWithDictionary:(NSDictionary*)dict{
    User *user = [User sharedUser];
    if(dict[@"userid"]!=[NSNull null])
        user.intUserId = [dict[@"userid"] integerValue];
    
    if(dict[@"email"]!=[NSNull null])
        user.strEmail = dict[@"email"];
    
    if(dict[@"name"]!=[NSNull null])
        user.strName = dict[@"name"];
    
    if(dict[@"phonenumber"]!=[NSNull null])
        user.strPhoneName = dict[@"phonenumber"];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInteger:self.intUserId forKey:kUserID];
    [encoder encodeObject:self.strEmail forKey:kEmail];
    [encoder encodeObject:self.strName forKey:kName];
    [encoder encodeObject:self.strPhoneName forKey:kPhoneNumber];
    [encoder encodeBool:self.login forKey:kIsLogin];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if( self != nil ) {
        self.intUserId = [decoder decodeIntegerForKey:kUserID];
        self.strEmail = [decoder decodeObjectForKey:kEmail];
        self.strName = [decoder decodeObjectForKey:kName];
        self.strPhoneName = [decoder decodeObjectForKey:kPhoneNumber];
        self.login = [decoder decodeBoolForKey:kIsLogin];
    }
    return self;
}

+ (BOOL)saveCredentials:(NSDictionary*)json{
    BOOL success = [json[@"success"] boolValue];
    if (success) {
        [[User sharedUser] initWithDictionary:json[@"userdata"]];
    }else {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:json[@"message"] image:kErrorImage];
    }
    return success;
}

@end
