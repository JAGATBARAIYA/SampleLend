//
//  Constants.h
//  TMBomb
//
//  Created by Manish Dudharejia on 04/07/15.
//  Copyright (c) 2015 Manish Dudharejia. All rights reserved.
//
#ifndef TMBomb_Constants_h
#define TMBomb_Constants_h

#pragma mark - Import Files

#import "SignUpVC.h"
#import "LoginVC.h"
#import "HomeVC.h"
#import "ForgotPasswordVC.h"
#import "SettingVC.h"
#import "FriendsVC.h"
#import "CategoryVC.h"
#import "AddFriendVC.h"
#import "AddLendVC.h"
#import "AddBorrowVC.h"
#import "LendBorrowVC.h"
#import "CategoryDetailVC.h"
#import "EditFriendVC.h"
#import "ChangePinVC.h"

#import "User.h"
#import "CatList.h"
#import "FriendsList.h"
#import "ItemList.h"
#import "itemDetails.h"


#import "CategoryHeader.h"
#import "FriendHeader.h"
#import "CategoryCell.h"
#import "ItemCell.h"
#import "FriendItemCell.h"
#import "ImageCell.h"
#import "AccordionHeaderView.h"
#import "CellSubMenu.h"
#import "TableViewCellFirst.h"

#import "Helper.h"
#import "MSTextField.h"
#import "AFNetworking.h"
#import "WebClient.h"
#import "MBProgressHUD.h"
#import "TKAlertCenter.h"
#import "SFHFKeychainUtils.h"
#import "NIDropDown.h"
#import "FZAccordionTableView.h"
#import "QBImagePicker.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "SIAlertView.h"
#import <MessageUI/MessageUI.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

#pragma mark - WebServices

#define kDefaultErrorCode                       500

//Demo URL
//#define BASE_URL                                @"http://e2msol.com/lendApp/api/Webservices/"
//#define ImageURL                                @"http://e2msol.com/lendApp"

//Live URL
#define BASE_URL                                @"http://devser.net/lendApp/api/Webservices/"
#define ImageURL                                @"http://devser.net/lendApp"


#define kLend_API_KEY                           @"wvP3G3tne2P5F7oEUtSv9aKUK07J206c"

#define kLogin                                  BASE_URL@"login"
#define kSignUp                                 BASE_URL@"signup"
#define kForgotPassword                         BASE_URL@"forgot_password"
#define kUpdateProfile                          BASE_URL@"updateprofileinfo"
#define kAddFriend                              BASE_URL@"add_friend"
#define kGetItem                                BASE_URL@"get_item"
#define kGetFriendList                          BASE_URL@"get_friend"
#define kGetItemList                            BASE_URL@"itemlist"
#define kAddCategory                            BASE_URL@"add_category"
#define KRemoveFriend                           BASE_URL@"removefriend"
#define kAddItem                                BASE_URL@"add_item"
#define kGetCategoryList                        BASE_URL@"get_category"
#define kGetUserList                            BASE_URL@"get_friend"
#define kGetItemDetail                          BASE_URL@"get_item_details"
#define kEditItem                               BASE_URL@"updateiteminfo"
#define kItemStatus                             BASE_URL@"itemstatus"
#define kEditFriend                             BASE_URL@"updatefriendinfo"
#define kDeletePhoto                            BASE_URL@"deletephoto"
#define kChangePin                              BASE_URL@"changepin"
#define kDeleteItem                             BASE_URL@"removeitem"

#define kAppDelegate                            ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define kStoryboard                             [UIStoryboard storyboardWithName:@"Main" bundle:nil]

#define kErrorImage                             [UIImage imageNamed:@"error"]
#define kRightImage                             [UIImage imageNamed:@"right"]

#define kRandomPasswordString                   @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define kUserDirectoryPath                      NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)

#define kDeviceTokenKey                         @"DeviceToken"
#define kdeviceToken                            [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceTokenKey]

#define kUserInformation                        @"UserInformation"
#define kDateFormat                             @"dd/MM/yyyy"

#define kdeviceType                             @"2"

#define IPHONE4S                                [UIScreen mainScreen].bounds.size.height==480
#define IPHONE5S                                [UIScreen mainScreen].bounds.size.height==568
#define IPHONE6                                 [UIScreen mainScreen].bounds.size.height==667
#define IPHONE6PLUS                             [UIScreen mainScreen].bounds.size.height==736
#define IPAD                                    [UIScreen mainScreen].bounds.size.height==1024

#define msgEnterName                            @"Please enter name."
#define msgEnterEmail                           @"Please enter email address."
#define msgEnterPhoneNumber                     @"Please enter phone number."
#define msgEnterPassword                        @"Please enter pin."
#define msgEnterConfirmPass                     @"Please enter confirm pin."
#define msgEnterValidEmail                      @"Please enter a valid email address."
#define msgEnterValidPhoneNo                    @"Please enter valid phone number."
#define msgConfirmPassNotMatch                  @"Pin and confirm pin do not match."
#define msgEnterItemName                        @"Please enter item name."
#define msgSelectCategory                       @"Please select category."
#define msgSelectLendBy                         @"Please select lent by."
#define msgSelectBorrowedBy                     @"Please select borrowed by."
#define msgSelectReturnDate                     @"Please select return date."
#define msgDeleteTitle                          @"Delete"
#define msgDeleteDesc                           @"Are you sure you want to delete this photo?"
#define msgItemNotFound                         @"No items available."
#define msgFriendNotFound                       @"No friends available."
#define msgCategoryNotFound                     @"No categories available."
#define msgInternetSlow                         @"Internet connection is too slow or not connected. Please try again."
#define msgPinValidation                        @"Please enter 4 digit pin."
#define msgEnterValidPin                        @"Incorrect Pin. Please enter a valid pin."
#define msgDeleteItem                           @"Are you sure you want to delete this item?"

#endif
