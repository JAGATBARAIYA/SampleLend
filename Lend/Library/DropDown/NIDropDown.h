//
//  NIDropDown.h
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIDropDown;
@protocol NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender;
@end

@interface NIDropDown : UIView <UITableViewDelegate, UITableViewDataSource>
{
    NSString *animationDirection;
}

@property (nonatomic, retain) id <NIDropDownDelegate> delegate;

@property (nonatomic, retain) NSString *animationDirection;
@property (strong, nonatomic) NSString *strTitle;
@property(nonatomic, strong) UIButton *btnSender;
@property (assign, nonatomic) NSInteger intFriendID;
@property (assign, nonatomic) NSInteger intCatID;

-(void)hideDropDown:(UIButton *)b;
- (id)showDropDown:(UIButton *)b height:(CGFloat *)height arr:(NSArray *)arr direction:(NSString *)direction type:(NSString *)type;

@end
