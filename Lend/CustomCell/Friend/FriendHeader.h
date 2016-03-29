//
//  FriendHeader.h
//  Lend
//
//  Created by Manish on 16/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsList.h"

@class FriendsList;
@class FriendHeader;

@protocol FriendHeaderDelegate <NSObject>
- (void)friendHeader:(FriendHeader *)view sectionOpened:(NSInteger)section;
- (void)friendHeader:(FriendHeader *)view sectionClosed:(NSInteger)section;
- (void)friendHeader:(FriendHeader *)view friendList:(FriendsList *)friendList;
@end

@interface FriendHeader : UITableViewHeaderFooterView

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnToggleIcon;
@property (strong, nonatomic) IBOutlet UIButton *btnBg;
@property (strong, nonatomic) IBOutlet UIImageView *imgSmily;

@property (strong, nonatomic) FriendsList *friendList;

@property (assign, nonatomic) id<FriendHeaderDelegate> delegate;

- (void)toggleOpenWithUserAction:(BOOL)userAction;

@end
