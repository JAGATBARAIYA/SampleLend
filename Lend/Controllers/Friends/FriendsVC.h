//
//  FriendsVC.h
//  Lend
//
//  Created by Manish on 04/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FriendsVC;

@protocol FriendsVCDelegate <NSObject>

- (void)friendsVC:(FriendsVC *)controller;

@end

@interface FriendsVC : UIViewController

@property (assign, nonatomic) id<FriendsVCDelegate> delegate;

@end
