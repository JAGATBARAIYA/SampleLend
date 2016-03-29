//
//  CatList.m
//  Lend
//
//  Created by Manish on 06/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import "CatList.h"
#import "ItemList.h"

@implementation CatList

- (id)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if(self){
        if(dict[@"categoryid"]!=[NSNull null])
            self.intCategoryID = [dict[@"categoryid"] integerValue];
        
        if(dict[@"categoryname"]!=[NSNull null])
            self.strCategoryName = dict[@"categoryname"];
        
        NSArray *arrItems = dict[@"Items"];
        if(arrItems.count!=0){
            [arrItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ItemList *itemList = [ItemList dataWithDictionary:(NSDictionary *)obj];
                
                if(!_arrCatItemList)
                    _arrCatItemList = [[NSMutableArray alloc] init];
                [_arrCatItemList addObject:itemList];
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
