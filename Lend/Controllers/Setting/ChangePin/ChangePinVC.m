//
//  ChangePinVC.m
//  Lend
//
//  Created by Manish on 09/03/16.
//  Copyright © 2016 E2M. All rights reserved.
//

#import "ChangePinVC.h"
#import "Constants.h"

@interface ChangePinVC ()

@property (strong, nonatomic) IBOutlet MSTextField *txtPin;
@property (strong, nonatomic) IBOutlet MSTextField *txtConfirmPin;

@end

@implementation ChangePinVC

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Click Event

- (IBAction)btnChangeTapped:(id)sender{
    if ([self isValidPin]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [WebClient requestWithUrlWithResultVerificationWithLoder:kChangePin parmeters:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserId],@"userpin":_txtPin.text} success:^(NSDictionary *response) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([response[@"success"] boolValue] == YES) {
                if (response) {
                    [Helper addToNSUserDefaults:response[@"userpin"] forKey:@"PIN"];
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

- (BOOL)isValidPin{
    if(!_txtPin.text || [_txtPin.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterPassword image:kErrorImage];
        return NO;
    }else if(!_txtConfirmPin.text || [_txtConfirmPin.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterConfirmPass image:kErrorImage];
        return NO;
    }

    if (_txtPin.text.length < 4) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgPinValidation image:kErrorImage];
        return NO;
    }
    if (![_txtPin.text isEqualToString:_txtConfirmPin.text]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgConfirmPassNotMatch image:kErrorImage];
        return NO;
    }

    return YES;
}

#pragma mark - UITextField Delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(doneClicked:)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    textField.inputAccessoryView = keyboardDoneButtonView;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.text.length >= 4 && range.length == 0)
        return NO;
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)doneClicked:(id)sender{
    [self.view endEditing:YES];
}

#pragma mark - Touch Event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[self view] endEditing:TRUE];
}

@end
