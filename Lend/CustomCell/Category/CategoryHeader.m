//
//  CategoryHeader.m
//  Lend
//
//  Created by Manish on 06/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import "CategoryHeader.h"
#import "Constants.h"

@implementation CategoryHeader

- (void)awakeFromNib {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
    [self addGestureRecognizer:tapGesture];
}

- (IBAction)toggleOpen:(id)sender {
    [self toggleOpenWithUserAction:YES];
}

- (void)toggleOpenWithUserAction:(BOOL)userAction {
    if (_categoryList.arrCatItemList.count) {
        _btnToggleIcon.selected = !_btnToggleIcon.selected;
        _btnBg.selected = !_btnBg.selected;
        
        if(userAction){
            if(_btnToggleIcon.selected){
                if ([_delegate respondsToSelector:@selector(categoryHeader:sectionOpened:)]) {
                    [_delegate categoryHeader:self sectionOpened:self.tag];
                }
            }else {
                if ([_delegate respondsToSelector:@selector(categoryHeader:sectionClosed:)]) {
                    [_delegate categoryHeader:self sectionClosed:self.tag];
                }
            }
        }
    }else{
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgItemNotFound image:kErrorImage];
    }

}

@end
