//
//  itemDetails.m
//
//  Created by Manish  on 19/11/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "itemDetails.h"
#import "Itemphoto.h"


NSString *const kitemDetailsItemid = @"Itemid";
NSString *const kitemDetailsBorrowusername = @"borrowusername";
NSString *const kitemDetailsLendusername = @"lendusername";
NSString *const kitemDetailsItemname = @"Itemname";
NSString *const kitemDetailsCategoryid = @"Categoryid";
NSString *const kitemDetailsCategory = @"Category";
NSString *const kitemDetailsReturndate = @"Returndate";
NSString *const kitemDetailsItemphoto = @"itemphoto";
NSString *const kitemDetailsItemEditStatus = @"itemeditstatus";

@interface itemDetails ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation itemDetails

@synthesize itemid = _itemid;
@synthesize borrowusername = _borrowusername;
@synthesize lendusername = _lendusername;
@synthesize itemname = _itemname;
@synthesize categoryid = _categoryid;
@synthesize category = _category;
@synthesize returndate = _returndate;
@synthesize itemphoto = _itemphoto;
@synthesize itemeditstatus = _itemeditstatus;

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
            self.itemid = [self objectOrNilForKey:kitemDetailsItemid fromDictionary:dict];
            self.borrowusername = [self objectOrNilForKey:kitemDetailsBorrowusername fromDictionary:dict];
            self.lendusername = [self objectOrNilForKey:kitemDetailsLendusername fromDictionary:dict];
            self.itemname = [self objectOrNilForKey:kitemDetailsItemname fromDictionary:dict];
            self.categoryid = [self objectOrNilForKey:kitemDetailsCategoryid fromDictionary:dict];
            self.category = [self objectOrNilForKey:kitemDetailsCategory fromDictionary:dict];
            self.returndate = [self objectOrNilForKey:kitemDetailsReturndate fromDictionary:dict];
            self.itemeditstatus = [self objectOrNilForKey:kitemDetailsItemEditStatus fromDictionary:dict];

    NSObject *receivedItemphoto = [dict objectForKey:kitemDetailsItemphoto];
    NSMutableArray *parsedItemphoto = [NSMutableArray array];
    if ([receivedItemphoto isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedItemphoto) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedItemphoto addObject:[Itemphoto modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedItemphoto isKindOfClass:[NSDictionary class]]) {
       [parsedItemphoto addObject:[Itemphoto modelObjectWithDictionary:(NSDictionary *)receivedItemphoto]];
    }

    self.itemphoto = [NSArray arrayWithArray:parsedItemphoto];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.itemid forKey:kitemDetailsItemid];
    [mutableDict setValue:self.borrowusername forKey:kitemDetailsBorrowusername];
    [mutableDict setValue:self.lendusername forKey:kitemDetailsLendusername];
    [mutableDict setValue:self.itemname forKey:kitemDetailsItemname];
    [mutableDict setValue:self.categoryid forKey:kitemDetailsCategoryid];
    [mutableDict setValue:self.category forKey:kitemDetailsCategory];
    [mutableDict setValue:self.returndate forKey:kitemDetailsReturndate];
    [mutableDict setValue:self.itemeditstatus forKey:kitemDetailsItemEditStatus];
    NSMutableArray *tempArrayForItemphoto = [NSMutableArray array];
    for (NSObject *subArrayObject in self.itemphoto) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForItemphoto addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForItemphoto addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForItemphoto] forKey:kitemDetailsItemphoto];

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

    self.itemid = [aDecoder decodeObjectForKey:kitemDetailsItemid];
    self.borrowusername = [aDecoder decodeObjectForKey:kitemDetailsBorrowusername];
    self.lendusername = [aDecoder decodeObjectForKey:kitemDetailsLendusername];
    self.itemname = [aDecoder decodeObjectForKey:kitemDetailsItemname];
    self.categoryid = [aDecoder decodeObjectForKey:kitemDetailsCategoryid];
    self.category = [aDecoder decodeObjectForKey:kitemDetailsCategory];
    self.returndate = [aDecoder decodeObjectForKey:kitemDetailsReturndate];
    self.itemphoto = [aDecoder decodeObjectForKey:kitemDetailsItemphoto];
    self.itemeditstatus = [aDecoder decodeObjectForKey:kitemDetailsItemEditStatus];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_itemid forKey:kitemDetailsItemid];
    [aCoder encodeObject:_borrowusername forKey:kitemDetailsBorrowusername];
    [aCoder encodeObject:_lendusername forKey:kitemDetailsLendusername];
    [aCoder encodeObject:_itemname forKey:kitemDetailsItemname];
    [aCoder encodeObject:_categoryid forKey:kitemDetailsCategoryid];
    [aCoder encodeObject:_category forKey:kitemDetailsCategory];
    [aCoder encodeObject:_returndate forKey:kitemDetailsReturndate];
    [aCoder encodeObject:_itemphoto forKey:kitemDetailsItemphoto];
    [aCoder encodeObject:_itemeditstatus forKey:kitemDetailsItemEditStatus];
}

- (id)copyWithZone:(NSZone *)zone
{
    itemDetails *copy = [[itemDetails alloc] init];
    
    if (copy) {

        copy.itemid = [self.itemid copyWithZone:zone];
        copy.borrowusername = [self.borrowusername copyWithZone:zone];
        copy.lendusername = [self.lendusername copyWithZone:zone];
        copy.itemname = [self.itemname copyWithZone:zone];
        copy.categoryid = [self.categoryid copyWithZone:zone];
        copy.category = [self.category copyWithZone:zone];
        copy.returndate = [self.returndate copyWithZone:zone];
        copy.itemphoto = [self.itemphoto copyWithZone:zone];
        copy.itemeditstatus = [self.itemeditstatus copyWithZone:zone];
    }
    
    return copy;
}

@end
