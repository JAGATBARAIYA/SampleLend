//
//  LendBorrowVC.h
//  Lend
//
//  Created by Manish on 06/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LendBorrowVC;

@protocol LendBorrowVCDelegate <NSObject>

- (void)lendBorrowVC:(LendBorrowVC *)controller;

@end

@interface LendBorrowVC : UIViewController

@property (assign, nonatomic) id<LendBorrowVCDelegate> delegate;

@end
