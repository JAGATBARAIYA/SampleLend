//
//  CategoryCell.m
//  Lend
//
//  Created by Manish on 06/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import "CategoryCell.h"
#import "Constants.h"

@implementation CategoryCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setFriendList:(FriendsList *)friendList{
    _friendList = friendList;
    [_tblList reloadData];
    
    CGRect frame = _tblList.frame;
    frame.size.height = [self heightForFriendCollectionView];
    _tblList.frame = frame;
}

- (CGFloat)heightForFriendCollectionView{
    FriendsList *friendList = _friendList;
    CGFloat height = friendList.arrItem.count * 50;
    return height;
}

- (void)setCategoryList:(CatList *)categoryList{
    _categoryList = categoryList;
    [_tblList reloadData];

    CGRect frame = _tblList.frame;
    frame.size.height = [self heightForCollectionView];
    _tblList.frame = frame;
}

- (CGFloat)heightForCollectionView{
    CatList *catList = _categoryList;
    CGFloat height = catList.arrCatItemList.count * 50;
    return height;
}

#pragma mark - UITableView delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_categoryList) {
        return _categoryList.arrCatItemList.count;
    }else{
        return _friendList.arrItem.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_categoryList) {
        ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
        if (cell == nil)
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ItemCell" owner:self options:nil] objectAtIndex:0];

        ItemList *itemList;
        if (_categoryList) {
            itemList = _categoryList.arrCatItemList[indexPath.row];
        }else{
            itemList =  _friendList.arrItem[indexPath.row];
        }
        if ([itemList.strItemType isEqualToString:@"1"]) {
            cell.contentView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:112.0/255.0 blue:32.0/255.0 alpha:1.0];
        }else{
            cell.contentView.backgroundColor = [UIColor colorWithRed:17.0/255.0 green:44.0/255.0 blue:147.0/255.0 alpha:1.0];
        }

        if ([itemList.strItemStatus isEqualToString:@"1"]) {
            cell.contentView.backgroundColor = [UIColor colorWithRed:75.0/255.0 green:182.0/255.0 blue:73.0/255.0 alpha:1.0];
            cell.imgView.image = [UIImage imageNamed:@"done"];
        }

        cell.lblName.text = itemList.strItemName;
        cell.lblDate.text = [Helper dateStringFromString:itemList.strReturnDate format:@"yyyy-MM-dd" toFormat:kDateFormat];
        cell.btnDelete.tag = indexPath.row;

        [cell.btnDelete addTarget:self action:@selector(btnDeleteItemTapped:) forControlEvents:UIControlEventTouchUpInside];

        return cell;

    }else{
        FriendItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendItemCell"];
        if (cell == nil)
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FriendItemCell" owner:self options:nil] objectAtIndex:0];

        ItemList *itemList;
        if (_categoryList) {
            itemList = _categoryList.arrCatItemList[indexPath.row];
        }else{
            itemList =  _friendList.arrItem[indexPath.row];
        }
        if ([itemList.strItemType isEqualToString:@"1"]) {
            cell.contentView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:112.0/255.0 blue:32.0/255.0 alpha:1.0];
        }else{
            cell.contentView.backgroundColor = [UIColor colorWithRed:17.0/255.0 green:44.0/255.0 blue:147.0/255.0 alpha:1.0];
        }

        if ([itemList.strItemStatus isEqualToString:@"1"]) {
            cell.contentView.backgroundColor = [UIColor colorWithRed:75.0/255.0 green:182.0/255.0 blue:73.0/255.0 alpha:1.0];
            cell.imgView.image = [UIImage imageNamed:@"done"];
        }

        cell.lblName.text = itemList.strItemName;
        cell.lblDate.text = [Helper dateStringFromString:itemList.strReturnDate format:@"yyyy-MM-dd" toFormat:kDateFormat];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ItemList *itemList = nil;
    if (_categoryList) {
        itemList = _categoryList.arrCatItemList[indexPath.row];
        if ([_delegate respondsToSelector:@selector(categoryCell:categoryCell:)]) {
            [_delegate categoryCell:itemList categoryCell:_categoryList];
        }
    }else{
        itemList = _friendList.arrItem[indexPath.row];
        if ([_delegate respondsToSelector:@selector(friendCell:)]) {
            [_delegate friendCell:itemList];
        }
    }
}

- (IBAction)btnDeleteItemTapped:(UIButton *)sender{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:msgDeleteTitle andMessage:msgDeleteItem];
    alertView.buttonsListStyle = SIAlertViewButtonsListStyleNormal;
    [alertView addButtonWithTitle:@"YES"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              [MBProgressHUD showHUDAddedTo:self.superview.superview animated:YES];
                              ItemList *itemList;

                              if (_categoryList) {
                                  itemList = _categoryList.arrCatItemList[sender.tag];
                              }else{
                                  itemList =  _friendList.arrItem[sender.tag];
                              }

                              [WebClient requestWithUrlWithResultVerificationWithLoder:kDeleteItem parmeters:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserId],@"itemid":[NSNumber numberWithInteger:itemList.intItemID]} success:^(NSDictionary *response) {
                                  [MBProgressHUD hideAllHUDsForView:self.superview.superview animated:YES];
                                  if (response) {
                                      [MBProgressHUD hideAllHUDsForView:self.superview.superview animated:YES];
                                      if (_categoryList) {
                                          [_categoryList.arrCatItemList removeObjectAtIndex:sender.tag];
                                      }else{
                                          [_friendList.arrItem removeObjectAtIndex:sender.tag];
                                      }

                                      if ([_delegate respondsToSelector:@selector(reloadItemData:)]) {
                                          [_delegate reloadItemData:itemList];
                                      }

                                  }else{
                                      [MBProgressHUD hideAllHUDsForView:self.superview.superview animated:YES];
                                      [[TKAlertCenter defaultCenter] postAlertWithMessage:response[@"message"] image:kErrorImage];
                                  }
                              } failure:^(NSError *error) {
                                  [MBProgressHUD hideAllHUDsForView:self.superview.superview animated:YES];
                                  [[TKAlertCenter defaultCenter] postAlertWithMessage:msgInternetSlow image:kErrorImage];
                              }];
                          }];
    [alertView addButtonWithTitle:@"NO"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {

                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}

@end
