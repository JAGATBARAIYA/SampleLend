//
//  CategoryDetailVC.h
//  Lend
//
//  Created by Manish on 10/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatList.h"
#import "ItemList.h"

@interface CategoryDetailVC : UIViewController

@property (strong, nonatomic) CatList *catList;
@property (strong, nonatomic) ItemList *itemList;
@property (assign, nonatomic) BOOL fromFriend;

@property (assign, nonatomic) BOOL isBorrower;

@end
