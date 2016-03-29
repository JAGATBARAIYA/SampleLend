//
//  itemDetails.h
//
//  Created by Manish  on 19/11/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface itemDetails : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *itemid;
@property (nonatomic, strong) NSString *borrowusername;
@property (nonatomic, strong) NSString *lendusername;
@property (nonatomic, strong) NSString *itemname;
@property (nonatomic, strong) NSString *categoryid;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *returndate;
@property (nonatomic, strong) NSArray *itemphoto;
@property (nonatomic, strong) NSString *itemeditstatus;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
