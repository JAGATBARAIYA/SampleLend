//
//  CatList.h
//  Lend
//
//  Created by Manish on 06/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryHeader.h"

@interface CatList : NSObject

@property (assign, nonatomic) NSInteger intCategoryID;
@property (strong, nonatomic) NSString *strCategoryName;

@property (strong, nonatomic) NSMutableArray *arrCatItemList;

@property (assign, nonatomic, getter=isOpen) BOOL open;

- (id)initWithDict:(NSDictionary *)dict;
+ (id)dataWithDictionary:(NSDictionary *)dict;

@end
