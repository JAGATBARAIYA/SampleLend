//
//  SettingVC.h
//  Lend
//
//  Created by Manish on 03/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingVC;

@protocol SettingVCDelegate <NSObject>

- (void)settingVC:(SettingVC *)controller;

@end

@interface SettingVC : UIViewController

@property (assign, nonatomic) id<SettingVCDelegate> delegate;

@end
