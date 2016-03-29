//
//  ItemList.h
//  Lend
//
//  Created by Manish on 06/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemList : NSObject

@property (assign, nonatomic) NSInteger intItemID;
@property (assign, nonatomic) NSInteger intItemUserID;
@property (assign, nonatomic) NSInteger intCatID;

@property (strong, nonatomic) NSString *strItemName;
@property (strong, nonatomic) NSString *strReturnDate;
@property (strong, nonatomic) NSString *strItemType;
@property (strong, nonatomic) NSString *strItemStatus;

- (id)initWithDict:(NSDictionary *)dict;
+ (id)dataWithDictionary:(NSDictionary *)dict;

@end
