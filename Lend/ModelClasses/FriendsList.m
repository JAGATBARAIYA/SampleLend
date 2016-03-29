//
//  FriendsList.m
//  Lend
//
//  Created by Manish on 09/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import "FriendsList.h"
#import "ItemList.h"

@implementation FriendsList

- (id)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if(self){
        if(dict[@"friendid"]!=[NSNull null])
            self.intFriendID = [dict[@"friendid"] integerValue];
        
        if(dict[@"friendautoid"]!=[NSNull null])
            self.intFriendAutoID = [dict[@"friendautoid"] integerValue];

        if(dict[@"name"]!=[NSNull null])
            self.strName = dict[@"name"];
        
        if(dict[@"email"]!=[NSNull null])
            self.strEmail = dict[@"email"];
        
        if(dict[@"phonenumber"]!=[NSNull null])
            self.strPhoneNo = dict[@"phonenumber"];
        
        if(dict[@"isReturnstatus"]!=[NSNull null])
            self.strSmilyStatus = dict[@"isReturnstatus"];

        NSArray *arrItemsList = dict[@"Items"];
        if(arrItemsList.count!=0){
            [arrItemsList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ItemList *itemList = [ItemList dataWithDictionary:(NSDictionary *)obj];
                
                if(!_arrItem)
                    _arrItem = [[NSMutableArray alloc] init];
                [_arrItem addObject:itemList];
            }];
        }
        _open = NO;
    }
    return self;
}

+ (id)dataWithDictionary:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

@end
