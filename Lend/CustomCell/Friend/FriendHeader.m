//
//  FriendHeader.m
//  Lend
//
//  Created by Manish on 16/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import "FriendHeader.h"
#import "Constants.h"

@implementation FriendHeader

- (void)awakeFromNib {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
    [self addGestureRecognizer:tapGesture];
}

- (IBAction)toggleOpen:(id)sender {
    [self toggleOpenWithUserAction:YES];
}

- (IBAction)btnEditTapped:(id)sender{
    if ([_delegate respondsToSelector:@selector(friendHeader:friendList:)]) {
        [_delegate friendHeader:self friendList:_friendList];
    }
}

- (void)setFriendList:(FriendsList *)friendList{
    _friendList = friendList;
    if ([_friendList.strSmilyStatus isEqualToString:@"1"]) {
        _imgSmily.image = [UIImage imageNamed:@"smile_happy"];
    }else if ([_friendList.strSmilyStatus isEqualToString:@"2"]) {
        _imgSmily.image = [UIImage imageNamed:@"smile_ok"];
    }else if ([_friendList.strSmilyStatus isEqualToString:@"3"]) {
        _imgSmily.image = [UIImage imageNamed:@"smile_sad"];
    }else{
        _imgSmily.image = [UIImage imageNamed:@""];
    }
}

- (void)toggleOpenWithUserAction:(BOOL)userAction {
    if (_friendList.arrItem.count) {
        _btnToggleIcon.selected = !_btnToggleIcon.selected;
        _btnBg.selected = !_btnBg.selected;

        if(userAction){
            if(_btnToggleIcon.selected){
                if ([_delegate respondsToSelector:@selector(friendHeader:sectionOpened:)]) {
                    [_delegate friendHeader:self sectionOpened:self.tag];
                }
            }else {
                if ([_delegate respondsToSelector:@selector(friendHeader:sectionClosed:)]) {
                    [_delegate friendHeader:self sectionClosed:self.tag];
                }
            }
        }
    }else{
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgItemNotFound image:kErrorImage];
    }
}

@end
