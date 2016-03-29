//
//  CategoryVC.h
//  Lend
//
//  Created by Manish on 04/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryVC;

@protocol CategoryVCDelegate <NSObject>

- (void)categoryVC:(CategoryVC *)controller;

@end

@interface CategoryVC : UIViewController

@property (assign, nonatomic) id<CategoryVCDelegate> delegate;

@end
