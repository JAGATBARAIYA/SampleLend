//
//  CategoryCell.h
//  Lend
//
//  Created by Manish on 06/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatList.h"
#import "ItemList.h"
#import "FriendsList.h"

@class CategoryCell;

@protocol CategoryCellDelegate<NSObject>

- (void)categoryCell:(ItemList *)item categoryCell:(CatList *)category;
- (void)reloadItemData:(ItemList *)item;
- (void)friendCell:(ItemList *)item;

@end

@interface CategoryCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITableView *tblList;

@property (strong, nonatomic) CatList *categoryList;
@property (strong, nonatomic) FriendsList *friendList;

@property (assign, nonatomic) id<CategoryCellDelegate> delegate;

@end
