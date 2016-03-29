//
//  EditFriendVC.m
//  Lend
//
//  Created by Manish on 17/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import "EditFriendVC.h"
#import "Constants.h"

@interface EditFriendVC ()

@property (strong, nonatomic) IBOutlet MSTextField *txtName;
@property (strong, nonatomic) IBOutlet MSTextField *txtPhoneNo;
@property (strong, nonatomic) IBOutlet MSTextField *txtEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation EditFriendVC

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    _lblTitle.text = _txtName.text = [_friendDetails.strName capitalizedString];
    _txtPhoneNo.text = _friendDetails.strPhoneNo;
    _txtEmail.text = _friendDetails.strEmail;
}

#pragma mark - Button Click Event

- (IBAction)btnEditTapped:(id)sender{
    if ([self isValidDetails]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [WebClient requestWithUrlWithResultVerificationWithLoder:kEditFriend parmeters:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserId],@"name":_txtName.text,@"friendid":[NSNumber numberWithInteger:_friendDetails.intFriendAutoID]} success:^(NSDictionary *response) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSLog(@"%@",response);
            if ([response[@"success"] boolValue]) {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:response[@"message"] image:kRightImage];
                [self doneClicked:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [[TKAlertCenter defaultCenter] postAlertWithMessage:response[@"message"] image:kErrorImage];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [[TKAlertCenter defaultCenter] postAlertWithMessage:msgInternetSlow image:kErrorImage];
        }];
    }
}

- (IBAction)btnRemoveTapped:(id)sender{
    if ([self isValidDetails]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [WebClient requestWithUrlWithResultVerificationWithLoder:KRemoveFriend parmeters:@{@"friendid":[NSNumber numberWithInteger:_friendDetails.intFriendAutoID]} success:^(NSDictionary *response) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSLog(@"%@",response);
            if ([response[@"success"] boolValue]) {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:response[@"message"] image:kRightImage];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [[TKAlertCenter defaultCenter] postAlertWithMessage:response[@"message"] image:kErrorImage];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [[TKAlertCenter defaultCenter] postAlertWithMessage:msgInternetSlow image:kErrorImage];
        }];
    }
}

#pragma mark - Validate Information

- (BOOL)isValidDetails{
    if(!_txtName.text || [_txtName.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterName image:kErrorImage];
        return NO;
    }else if(!_txtPhoneNo.text || [_txtPhoneNo.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterPhoneNumber image:kErrorImage];
        return NO;
    }
    if (_txtPhoneNo.text.length < 8 || _txtPhoneNo.text.length > 15) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterValidPhoneNo image:kErrorImage];
        return NO;
    }
    return YES;
}

#pragma mark - UITextField Delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == _txtPhoneNo) {
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        [keyboardDoneButtonView sizeToFit];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked:)];
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
        textField.inputAccessoryView = keyboardDoneButtonView;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _txtPhoneNo) {
        NSInteger length = [self getLength:textField.text];
        
        if(length == 10)
        {
            if(range.length == 0)
                return NO;
        }
        
        if(length == 3)
        {
            NSString *num = [self formatNumber:textField.text];
            textField.text = [NSString stringWithFormat:@"%@-",num];
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
        }
        else if(length == 6)
        {
            NSString *num = [self formatNumber:textField.text];
            
            textField.text = [NSString stringWithFormat:@"%@-%@-",[num  substringToIndex:3],[num substringFromIndex:3]];
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"%@-%@",[num substringToIndex:3],[num substringFromIndex:3]];
        }
    }
    return YES;
}

-(NSString*)formatNumber:(NSString*)mobileNumber {
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSLog(@"%@", mobileNumber);
    
    NSInteger length = [mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
        
    }
    
    return mobileNumber;
}

-(NSInteger)getLength:(NSString*)mobileNumber {
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSInteger length = [mobileNumber length];
    
    return length;
}

- (IBAction)doneClicked:(id)sender{
    [self.view endEditing:YES];
}

#pragma mark - Touch Event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[self view] endEditing:TRUE];
}

@end
