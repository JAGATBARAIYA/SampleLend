//
//  HomeVC.m
//  Lend
//
//  Created by Manish on 03/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import "HomeVC.h"
#import "Constants.h"

@interface HomeVC ()

@end

@implementation HomeVC

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
    _lendBorrowVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LendBorrowVC"];

    UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:_lendBorrowVC];
    navController.navigationBar.hidden = YES;
    _lendBorrowVC.delegate = self;
    CGRect aRect = [[UIScreen mainScreen] bounds];
    [navController.view setFrame:(CGRect){0, 91, aRect.size.width, aRect.size.height-91}];
    
    [self addChildViewController:navController];
    [self.view addSubview:navController.view];
    [self didMoveToParentViewController:navController];
}

#pragma mark - Button Click Event

- (IBAction)btnHomeTapped:(id)sender{
    [[self view] endEditing:TRUE];

    _lendBorrowVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LendBorrowVC"];
    
    UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:_lendBorrowVC];
    navController.navigationBar.hidden = YES;
    _lendBorrowVC.delegate = self;
    CGRect aRect = [[UIScreen mainScreen] bounds];
    [navController.view setFrame:(CGRect){0, 91, aRect.size.width, aRect.size.height-91}];
    
    [self addChildViewController:navController];
    [self.view addSubview:navController.view];
    [self didMoveToParentViewController:navController];
}

- (IBAction)btnFriendTapped:(id)sender{
    [[self view] endEditing:TRUE];

    _friendsVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FriendsVC"];
    UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:_friendsVC];
    navController.navigationBar.hidden = YES;

    _friendsVC.delegate = self;
    
    CGRect aRect = [[UIScreen mainScreen] bounds];
    
    [navController.view setFrame:(CGRect){0, 91, aRect.size.width, aRect.size.height-91}];
    
    [self addChildViewController:navController];
    [self.view addSubview:navController.view];
    [self didMoveToParentViewController:navController];
}

- (IBAction)btnCategoryTapped:(id)sender{
    [[self view] endEditing:TRUE];

    _categoryVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CategoryVC"];
    UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:_categoryVC];
    navController.navigationBar.hidden = YES;

    _categoryVC.delegate = self;
    
    CGRect aRect = [[UIScreen mainScreen] bounds];
    
    [navController.view setFrame:(CGRect){0, 91, aRect.size.width, aRect.size.height-91}];
    
    [self addChildViewController:navController];
    [self.view addSubview:navController.view];
    [self didMoveToParentViewController:navController];
}

- (IBAction)btnSettingTapped:(id)sender{
    [[self view] endEditing:TRUE];

    _settingVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingVC"];
    UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:_settingVC];
    navController.navigationBar.hidden = YES;

    _settingVC.delegate = self;
    
    CGRect aRect = [[UIScreen mainScreen] bounds];
    
    [navController.view setFrame:(CGRect){0, 91, aRect.size.width, aRect.size.height-91}];
    
    [self addChildViewController:navController];
    [self.view addSubview:navController.view];
    [self didMoveToParentViewController:navController];
}

#pragma mark - Delegate Methods

- (void)lendBorrowVC:(LendBorrowVC *)controller{
    [_lendBorrowVC removeFromParentViewController];
    [_lendBorrowVC.view removeFromSuperview];
    [_lendBorrowVC willMoveToParentViewController:nil];
}

- (void)friendsVC:(FriendsVC *)controller{
    [_friendsVC removeFromParentViewController];
    [_friendsVC.view removeFromSuperview];
    [_friendsVC willMoveToParentViewController:nil];
}

- (void)categoryVC:(CategoryVC *)controller{
    [_categoryVC removeFromParentViewController];
    [_categoryVC.view removeFromSuperview];
    [_categoryVC willMoveToParentViewController:nil];
}

- (void)settingVC:(SettingVC *)controller{
    [_settingVC removeFromParentViewController];
    [_settingVC.view removeFromSuperview];
    [_settingVC willMoveToParentViewController:nil];
    [User sharedUser].login = NO;
    [Helper addCustomObjectToUserDefaults:[User sharedUser] key:kUserInformation];
    
    for (UIViewController *aVC in self.navigationController.viewControllers)
    {
        if ([aVC isKindOfClass:[LoginVC class]])
        {
            LoginVC *aLoginVC = (LoginVC *)aVC;
            [self.navigationController popToViewController:aLoginVC animated:YES];
            return;
        }
        else if ([aVC isKindOfClass:[SignUpVC class]])
        {
            [self.navigationController setViewControllers:@[[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"], [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"]] animated:NO];
            
            for (UIViewController *innerVC in self.navigationController.viewControllers)
            {
                if ([aVC isKindOfClass:[LoginVC class]])
                {
                    LoginVC *aLoginVC = (LoginVC *)innerVC;
                    [self.navigationController popToViewController:aLoginVC animated:YES];
                    return;
                }
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Touch Event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[self view] endEditing:TRUE];
}

@end
