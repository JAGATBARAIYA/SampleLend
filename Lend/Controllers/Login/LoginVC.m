//
//  LoginVC.m
//  Lend
//
//  Created by Manish on 03/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import "LoginVC.h"
#import "Constants.h"

@interface LoginVC ()

@property (strong, nonatomic) IBOutlet MSTextField *txtEmail;
@property (strong, nonatomic) IBOutlet MSTextField *txtPassword;

@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;

@property (strong, nonatomic) IBOutlet UIView *mainView;

@end

@implementation LoginVC

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)viewWillDisappear:(BOOL)animated{
    _txtEmail.text = _txtPassword.text = @"";
}

- (void)viewWillAppear:(BOOL)animated{
    if (_isLogin) {
        HomeVC *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
        [self.navigationController pushViewController:homeVC animated:YES];
    }

    if ([Helper getFromNSUserDefaults:@"PIN"]) {
        _txtEmail.hidden = YES;
    }else{
        _txtEmail.hidden = NO;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    _btnLogin.layer.cornerRadius = _btnCancel.layer.cornerRadius = 10.0;
    _btnLogin.layer.borderWidth = _btnCancel.layer.borderWidth = 3.0;
    _btnLogin.layer.borderColor = _btnCancel.layer.borderColor = [[UIColor colorWithRed:242.0/255.0 green:113.0/255.0 blue:33.0/255.0 alpha:1.0]CGColor];
    _btnLogin.layer.masksToBounds = _btnCancel.layer.masksToBounds = YES;

}

#pragma mark - Button Click Event

- (IBAction)btnLoginTapped:(id)sender{
    if ([Helper getFromNSUserDefaults:@"PIN"]) {
        if ([self isValidPin]) {
            if ([[Helper getFromNSUserDefaults:@"PIN"] isEqualToString:_txtPassword.text]) {
                [User sharedUser].login = YES;
                [Helper addCustomObjectToUserDefaults:[User sharedUser] key:kUserInformation];
                [SFHFKeychainUtils storeUsername:[User sharedUser].strEmail andPassword:_txtPassword.text forServiceName:[User sharedUser].strEmail updateExisting:YES error:nil];
                HomeVC *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
                [self.navigationController pushViewController:homeVC animated:NO];
            }else{
                [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterValidPin image:kErrorImage];
            }
        }
    }else{
        if ([self isValidLoginDetails]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [WebClient requestWithUrlWithResultVerificationWithLoder:kLogin parmeters:@{@"email":_txtEmail.text,@"password":_txtPassword.text} success:^(NSDictionary *response) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if ([response[@"success"] boolValue] == YES) {
                    NSLog(@"%@",response);
                    if (response) {
                        if([User saveCredentials:response]) {
                            [Helper addToNSUserDefaults:_txtPassword.text forKey:@"PIN"];
                            [User sharedUser].login = YES;
                            [Helper addCustomObjectToUserDefaults:[User sharedUser] key:kUserInformation];
                            [SFHFKeychainUtils storeUsername:[User sharedUser].strEmail andPassword:_txtPassword.text forServiceName:[User sharedUser].strEmail updateExisting:YES error:nil];
                            HomeVC *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
                            [self.navigationController pushViewController:homeVC animated:NO];
                        }
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
}

- (IBAction)btnForgotPasswordTapped:(id)sender{
    [self doneClicked:nil];
    ForgotPasswordVC *forgotPasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordVC"];
    [self.navigationController pushViewController:forgotPasswordVC animated:YES];
}

- (IBAction)btnCancelTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Validate Information

- (BOOL)isValidPin{
//   if(!_txtEmail.text || [_txtEmail.text isEmptyString]){
//        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterEmail image:kErrorImage];
//        return NO;
//    }else
    if(!_txtPassword.text || [_txtPassword.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterPassword image:kErrorImage];
        return NO;
    }
    if (_txtPassword.text.length < 4) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgPinValidation image:kErrorImage];
        return NO;
    }

//    if(![_txtEmail.text isValidEmail]){
//        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterValidEmail image:kErrorImage];
//        return NO;
//    }
    return YES;
}

- (BOOL)isValidLoginDetails{
   if(!_txtEmail.text || [_txtEmail.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterEmail image:kErrorImage];
        return NO;
    }else if(!_txtPassword.text || [_txtPassword.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterPassword image:kErrorImage];
        return NO;
    }
    if (_txtPassword.text.length < 4) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgPinValidation image:kErrorImage];
        return NO;
    }
    if(![_txtEmail.text isValidEmail]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterValidEmail image:kErrorImage];
        return NO;
    }
    return YES;
}

#pragma mark - UITextField Delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == _txtPassword) {
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        [keyboardDoneButtonView sizeToFit];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleDone target:self
                                                                      action:@selector(doneClicked:)];
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
        textField.inputAccessoryView = keyboardDoneButtonView;
    }

    CGRect frame = _mainView.frame;
    if (IPHONE4S) {
        frame.origin.y = -80;
    }else if (IPHONE5S){
        frame.origin.y = -100;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        _mainView.frame = frame;
    }];
    [UIView commitAnimations];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _txtPassword) {
        if (textField.text.length >= 4 && range.length == 0)
            return NO;
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = _mainView.frame;
        frame.origin.y = 0;
        _mainView.frame = frame;
    }];
    [UIView commitAnimations];

    return YES;
}

- (IBAction)doneClicked:(id)sender{
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = _mainView.frame;
        frame.origin.y = 0;
        _mainView.frame = frame;
    }];
    [UIView commitAnimations];

    [self.view endEditing:YES];
}

#pragma mark - Touch Event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[self view] endEditing:TRUE];
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = _mainView.frame;
        frame.origin.y = 0;
        _mainView.frame = frame;
    }];
    [UIView commitAnimations];
}

@end
