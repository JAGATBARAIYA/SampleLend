//
//  ViewController.m
//  Lend
//
//  Created by Manish on 03/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIButton *btnSignUp;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;

@end

@implementation ViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)viewWillAppear:(BOOL)animated{
    [self rememberMeInformation];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    _btnSignUp.layer.shadowColor = _btnLogin.layer.shadowColor = [UIColor blackColor].CGColor;
    _btnSignUp.layer.shadowOpacity = _btnLogin.layer.shadowOpacity = 0.3;
    _btnSignUp.layer.shadowRadius = _btnLogin.layer.shadowRadius = 3;
    _btnSignUp.layer.shadowOffset = _btnLogin.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);

    _btnSignUp.layer.cornerRadius = _btnLogin.layer.cornerRadius = 10.0;
    _btnSignUp.layer.borderWidth = _btnLogin.layer.borderWidth = 3.0;
    _btnSignUp.layer.borderColor = _btnLogin.layer.borderColor = [[UIColor colorWithRed:242.0/255.0 green:113.0/255.0 blue:33.0/255.0 alpha:1.0]CGColor];
    _btnSignUp.layer.masksToBounds = _btnLogin.layer.masksToBounds = NO;
}

- (void)rememberMeInformation{
    User *user = [Helper getCustomObjectToUserDefaults:kUserInformation];
    if(user && user.login){
        HomeVC *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
        [self.navigationController pushViewController:homeVC animated:NO];
        return;
    }
}

#pragma mark - Button Click Event

- (IBAction)btnSignUpTapped:(id)sender{
    SignUpVC *signUpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpVC"];
    [self.navigationController pushViewController:signUpVC animated:YES];
}

- (IBAction)btnLoginTapped:(id)sender{
    LoginVC *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    [self.navigationController pushViewController:loginVC animated:YES];
}

@end
