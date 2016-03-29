//
//  Itemphoto.m
//
//  Created by Manish  on 19/11/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "Itemphoto.h"


NSString *const kItemphotoPath = @"path";
NSString *const kItemphotoItemphotoid = @"itemphotoid";


@interface Itemphoto ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Itemphoto

@synthesize path = _path;
@synthesize itemphotoid = _itemphotoid;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.path = [self objectOrNilForKey:kItemphotoPath fromDictionary:dict];
            self.itemphotoid = [self objectOrNilForKey:kItemphotoItemphotoid fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.path forKey:kItemphotoPath];
    [mutableDict setValue:self.itemphotoid forKey:kItemphotoItemphotoid];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.path = [aDecoder decodeObjectForKey:kItemphotoPath];
    self.itemphotoid = [aDecoder decodeObjectForKey:kItemphotoItemphotoid];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_path forKey:kItemphotoPath];
    [aCoder encodeObject:_itemphotoid forKey:kItemphotoItemphotoid];
}

- (id)copyWithZone:(NSZone *)zone
{
    Itemphoto *copy = [[Itemphoto alloc] init];
    
    if (copy) {

        copy.path = [self.path copyWithZone:zone];
        copy.itemphotoid = [self.itemphotoid copyWithZone:zone];
    }
    
    return copy;
}


@end
