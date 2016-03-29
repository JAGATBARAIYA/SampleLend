//
//  HomeVC.h
//  Lend
//
//  Created by Manish on 03/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LendBorrowVC.h"
#import "FriendsVC.h"
#import "CategoryVC.h"
#import "SettingVC.h"

@interface HomeVC : UIViewController<LendBorrowVCDelegate,FriendsVCDelegate,CategoryVCDelegate,SettingVCDelegate>

@property (strong, nonatomic) LendBorrowVC *lendBorrowVC;
@property (strong, nonatomic) FriendsVC *friendsVC;
@property (strong, nonatomic) CategoryVC *categoryVC;
@property (strong, nonatomic) SettingVC *settingVC;

@end
