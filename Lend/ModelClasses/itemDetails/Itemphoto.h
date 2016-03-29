//
//  Itemphoto.h
//
//  Created by Manish  on 19/11/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Itemphoto : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *itemphotoid;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
