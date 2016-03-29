//
//  CategoryHeader.h
//  Lend
//
//  Created by Manish on 06/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatList.h"

@class CatList;

@class CategoryHeader;

@protocol CategoryHeaderDelegate <NSObject>
- (void)categoryHeader:(CategoryHeader *)view sectionOpened:(NSInteger)section;
- (void)categoryHeader:(CategoryHeader *)view sectionClosed:(NSInteger)section;
@end

@interface CategoryHeader : UITableViewHeaderFooterView

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblCount;
@property (strong, nonatomic) IBOutlet UIButton *btnToggleIcon;
@property (strong, nonatomic) IBOutlet UIButton *btnBg;

@property (strong, nonatomic) CatList *categoryList;

@property (assign, nonatomic) id<CategoryHeaderDelegate> delegate;

- (void)toggleOpenWithUserAction:(BOOL)userAction;

@end
