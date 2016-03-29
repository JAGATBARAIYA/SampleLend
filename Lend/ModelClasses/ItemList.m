//
//  ItemList.m
//  Lend
//
//  Created by Manish on 06/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import "ItemList.h"

@implementation ItemList

- (id)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if(self){
        if(dict[@"itemid"]!=[NSNull null])
            self.intItemID = [dict[@"itemid"] integerValue];
        
        if(dict[@"itemuserid"]!=[NSNull null])
            self.intItemUserID = [dict[@"itemuserid"] integerValue];

        if(dict[@"categoryid"]!=[NSNull null])
            self.intCatID = [dict[@"categoryid"] integerValue];

        if(dict[@"name"]!=[NSNull null])
            self.strItemName = dict[@"name"];
        
        if(dict[@"returndate"]!=[NSNull null])
            self.strReturnDate = dict[@"returndate"];
        
        if(dict[@"itemtype"]!=[NSNull null])
            self.strItemType = dict[@"itemtype"];
        
        if(dict[@"itemstatus"]!=[NSNull null])
            self.strItemStatus = dict[@"itemstatus"];

    }
    return self;
}

+ (id)dataWithDictionary:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

@end
