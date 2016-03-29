//
//  SignUpVC.m
//  Lend
//
//  Created by Manish on 03/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import "SignUpVC.h"
#import "Constants.h"

@interface SignUpVC ()

@property (strong, nonatomic) IBOutlet MSTextField *txtName;
@property (strong, nonatomic) IBOutlet MSTextField *txtEmail;
@property (strong, nonatomic) IBOutlet MSTextField *txtPhoneNo;
@property (strong, nonatomic) IBOutlet MSTextField *txtPassword;
@property (strong, nonatomic) IBOutlet MSTextField *txtConfirmPass;

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIButton *btnSignUp;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;

@end

@implementation SignUpVC

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
    _btnSignUp.layer.shadowColor = _btnCancel.layer.shadowColor = [UIColor blackColor].CGColor;
    _btnSignUp.layer.shadowOpacity = _btnCancel.layer.shadowOpacity = 0.3;
    _btnSignUp.layer.shadowRadius = _btnCancel.layer.shadowRadius = 3;
    _btnSignUp.layer.shadowOffset = _btnCancel.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);

    _btnSignUp.layer.cornerRadius = _btnCancel.layer.cornerRadius = 10.0;
    _btnSignUp.layer.borderWidth = _btnCancel.layer.borderWidth = 3.0;
    _btnSignUp.layer.borderColor = _btnCancel.layer.borderColor = [[UIColor colorWithRed:242.0/255.0 green:113.0/255.0 blue:33.0/255.0 alpha:1.0]CGColor];
    _btnSignUp.layer.masksToBounds = _btnCancel.layer.masksToBounds = YES;
}

#pragma mark - Button Click Event

- (IBAction)btnSignUpTapped:(id)sender{
    if ([self isValidDetails]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [WebClient requestWithUrlWithResultVerificationWithLoder:kSignUp parmeters:@{@"name":_txtName.text,@"email":_txtEmail.text,@"phonenumber":_txtPhoneNo.text,@"password":_txtPassword.text,@"devicetype":@2,@"devicetoken":@"123"} success:^(NSDictionary *response) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([response[@"success"] boolValue] == YES) {
                if (response) {
                    if([User saveCredentials:response]) {
                        [Helper addToNSUserDefaults:_txtPassword.text forKey:@"PIN"];
                        [User sharedUser].login = YES;
                        [Helper addCustomObjectToUserDefaults:[User sharedUser] key:kUserInformation];
                        [SFHFKeychainUtils storeUsername:[User sharedUser].strEmail andPassword:_txtPassword.text forServiceName:[User sharedUser].strEmail updateExisting:YES error:nil];

                        HomeVC *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
                        [self.navigationController pushViewController:homeVC animated:YES];
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

- (IBAction)btnCancelTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Validate Information

- (BOOL)isValidDetails{
    if(!_txtName.text || [_txtName.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterName image:kErrorImage];
        return NO;
    }else if(!_txtEmail.text || [_txtEmail.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterEmail image:kErrorImage];
        return NO;
    }else if(!_txtPhoneNo.text || [_txtPhoneNo.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterPhoneNumber image:kErrorImage];
        return NO;
    }else if(!_txtPassword.text || [_txtPassword.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterPassword image:kErrorImage];
        return NO;
    }else if(!_txtConfirmPass.text || [_txtConfirmPass.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterConfirmPass image:kErrorImage];
        return NO;
    }
    if(![_txtEmail.text isValidEmail]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterValidEmail image:kErrorImage];
        return NO;
    }
    if (_txtPassword.text.length < 4) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgPinValidation image:kErrorImage];
        return NO;
    }
    if (_txtPhoneNo.text.length < 8 || _txtPhoneNo.text.length > 15) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterValidPhoneNo image:kErrorImage];
        return NO;
    }
    if(![_txtPassword.text isEqualToString:_txtConfirmPass.text]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgConfirmPassNotMatch image:kErrorImage];
        return NO;
    }
    return YES;
}

#pragma mark - UITextField Delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == _txtPhoneNo || textField == _txtPassword || textField == _txtConfirmPass) {
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
        frame.origin.y = -150;
    }else if (IPHONE5S){
        frame.origin.y = -140;
    }else if (IPHONE6 || IPHONE6PLUS){
        frame.origin.y = -130;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        _mainView.frame = frame;
    }];
    [UIView commitAnimations];
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

    if (textField == _txtPassword || textField == _txtConfirmPass) {
        if (textField.text.length >= 4 && range.length == 0)
            return NO;
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
    [self doneClicked:nil];
}

@end
