//
//  ForgotPasswordVC.m
//  Lend
//
//  Created by Manish on 03/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import "ForgotPasswordVC.h"
#import "Constants.h"

@interface ForgotPasswordVC ()

@property (strong, nonatomic) IBOutlet MSTextField *txtEmail;

@property (strong, nonatomic) IBOutlet UIButton *btnSend;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;

@end

@implementation ForgotPasswordVC

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    _btnSend.layer.cornerRadius = _btnCancel.layer.cornerRadius = 10.0;
    _btnSend.layer.borderWidth = _btnCancel.layer.borderWidth = 3.0;
    _btnSend.layer.borderColor = _btnCancel.layer.borderColor = [[UIColor colorWithRed:242.0/255.0 green:113.0/255.0 blue:33.0/255.0 alpha:1.0]CGColor];
    _btnSend.layer.masksToBounds = _btnCancel.layer.masksToBounds = YES;
}

#pragma mark - Button Click Event

- (IBAction)btnSendTapped:(id)sender{
    if ([self isValidDetails]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [WebClient requestWithUrlWithResultVerificationWithLoder:kForgotPassword parmeters:@{@"email":_txtEmail.text} success:^(NSDictionary *response) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([response[@"success"] boolValue] == YES) {
                if (response) {
                    [Helper addToNSUserDefaults:response[@"password"] forKey:@"PIN"];
                    [[TKAlertCenter defaultCenter] postAlertWithMessage:response[@"message"] image:kRightImage];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }else{
                [[TKAlertCenter defaultCenter] postAlertWithMessage:response[@"message"] image:kErrorImage];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [[TKAlertCenter defaultCenter] postAlertWithMessage:msgInternetSlow image:kErrorImage];
        }];
    }
}

- (IBAction)btnCancelTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Validate Information

- (BOOL)isValidDetails{
    if(!_txtEmail.text || [_txtEmail.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterEmail image:kErrorImage];
        return NO;
    }
    if(![_txtEmail.text isValidEmail]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterValidEmail image:kErrorImage];
        return NO;
    }
    return YES;
}

#pragma mark - UITextField Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Touch Event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[self view] endEditing:TRUE];
}

@end
