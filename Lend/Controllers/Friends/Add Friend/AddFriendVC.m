//
//  AddFriendVC.m
//  Lend
//
//  Created by Manish on 05/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import "AddFriendVC.h"
#import "Constants.h"

@interface AddFriendVC ()<MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet MSTextField *txtName;
@property (strong, nonatomic) IBOutlet MSTextField *txtEmail;
@property (strong, nonatomic) IBOutlet MSTextField *txtPhoneNo;

@property (strong, nonatomic) IBOutlet UIView *mainView;

@end

@implementation AddFriendVC

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

}

#pragma mark - Button Click Event

- (IBAction)btnAddTapped:(id)sender{
    if ([self isValidDetails]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [WebClient requestWithUrlWithResultVerificationWithLoder:kAddFriend parmeters:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserId],@"name":_txtName.text,@"email":_txtEmail.text,@"phonenumber":_txtPhoneNo.text} success:^(NSDictionary *response) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSLog(@"%@",response);
            if ([response[@"success"] boolValue]) {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:response[@"message"] image:kRightImage];
                [self clearFields];
                [self doneClicked:nil];
                if ([MFMessageComposeViewController canSendText]) {
                    MFMessageComposeViewController *messageComposer =
                    [[MFMessageComposeViewController alloc] init];
                    NSString *message = @"https://itunes.apple.com/us/app/lendapp/id1090807820?ls=1&mt=8 \n\n Please download the Lend app from this link.";
                    [messageComposer setBody:message];
                    messageComposer.messageComposeDelegate = self;
                    [self presentViewController:messageComposer animated:YES completion:nil];
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

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    }
    if (_txtPhoneNo.text.length < 8 || _txtPhoneNo.text.length > 15) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterValidPhoneNo image:kErrorImage];
        return NO;
    }
    if(![_txtEmail.text isValidEmail]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterValidEmail image:kErrorImage];
        return NO;
    }
    return YES;
}

#pragma mark - UITextField Delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == _txtPhoneNo) {
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
        frame.origin.y = -50;
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
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = _mainView.frame;
        frame.origin.y = 0;
        _mainView.frame = frame;
    }];
    [UIView commitAnimations];
}

- (void)clearFields{
    _txtName.text = _txtEmail.text = _txtPhoneNo.text = @"";
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
