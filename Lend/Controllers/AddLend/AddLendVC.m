//
//  AddLendVC.m
//  Lend
//
//  Created by Manish on 06/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import "AddLendVC.h"
#import "Constants.h"
#import "QBImagePickerController.h"

#define CAMERA_OFF                  @"Enable camera from device settings"

@interface AddLendVC ()<NIDropDownDelegate,QBImagePickerControllerDelegate,UIImagePickerControllerDelegate>
{
    NIDropDown *dropDown;
    UIImagePickerController *aImagePicker;
}

@property (strong, nonatomic) IBOutlet MSTextField *txtItemName;
@property (strong, nonatomic) IBOutlet MSTextField *txtCategory;
@property (strong, nonatomic) IBOutlet MSTextField *txtLendBy;
@property (strong, nonatomic) IBOutlet MSTextField *txtReturnDate;

@property (strong, nonatomic) IBOutlet UIView *photoView;
@property (strong, nonatomic) IBOutlet UIView *guideView;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) IBOutlet UIButton *btnCategory;
@property (strong, nonatomic) IBOutlet UIButton *btnBorrowedBy;
@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic) NSMutableArray *arrCategory;
@property (strong, nonatomic) NSMutableArray *arrUserList;
@property (strong, nonatomic) NSMutableArray *arrImages;

@property (assign, nonatomic) NSInteger intCatID;
@property (assign, nonatomic) NSInteger intFriendID;

@end

@implementation AddLendVC

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
    _arrCategory = [[NSMutableArray alloc]init];
    _arrUserList = [[NSMutableArray alloc]init];
    _arrImages = [[NSMutableArray alloc]init];
    
    [self getCategoryList];
    [self getUserList];
}

- (void)getCategoryList{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebClient requestWithUrlWithResultVerificationWithLoder:kGetCategoryList parmeters:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserId]} success:^(NSDictionary *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            NSArray *listResult = response[@"Categorydata"];
            if(listResult.count!=0){
                [listResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    CatList *cat = [CatList dataWithDictionary:obj];
                    [_arrCategory addObject:cat];
                }];
            }else {
              //  [[TKAlertCenter defaultCenter] postAlertWithMessage:@"There is no list availabel." image:kErrorImage];
            }
        }else{
            [[TKAlertCenter defaultCenter] postAlertWithMessage:response[@"message"] image:kErrorImage];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgInternetSlow image:kErrorImage];
    }];
}

- (void)getUserList{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebClient requestWithUrlWithResultVerificationWithLoder:kGetUserList parmeters:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserId]} success:^(NSDictionary *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            NSArray *listResult = response[@"Frienddata"];
            if(listResult.count!=0){
                [listResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    FriendsList *friendList = [FriendsList dataWithDictionary:obj];
                    [_arrUserList addObject:friendList];
                }];
            }else {
               // [[TKAlertCenter defaultCenter] postAlertWithMessage:@"There is no list availabel." image:kErrorImage];
            }
        }else{
            [[TKAlertCenter defaultCenter] postAlertWithMessage:response[@"message"] image:kErrorImage];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgInternetSlow image:kErrorImage];
    }];
}

#pragma mark - Button Click Event

- (IBAction)btnAddTapped:(id)sender{
    if ([self isValidDetails]) {
        @try
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];

            NSString *returnDate = [NSString stringWithFormat:@"%@",[Helper dateStringFromString:_txtReturnDate.text format:@"dd/MM/yyyy" toFormat:@"yyyy-MM-dd"]];

            NSDictionary *parameters  = @{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserId],@"name":_txtItemName.text,@"categoryid":[NSNumber numberWithInteger:_intCatID],@"itemuserid":[NSNumber numberWithInteger:_intFriendID],@"returndate":returnDate,@"itemtype":@1,@"itemphotocount":[NSNumber numberWithInteger:_arrImages.count]};

            NSString *strURL = @"http://devser.net/lendApp/api/Webservices/add_item";
//            NSString *strURL = @"http://e2msol.com/lendApp/api/Webservices/add_item";

            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager.requestSerializer setValue:kLend_API_KEY forHTTPHeaderField:@"PC-API-KEY"];
            [manager POST:strURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
             {
                 int aIndex = 1;
                 for (UIImage *aImage in _arrImages)
                 {
                     NSData *aData = UIImageJPEGRepresentation(aImage, 0.8);
                     [formData appendPartWithFileData:aData name:[NSString stringWithFormat:@"itemphoto%d", aIndex] fileName:[NSString stringWithFormat:@"%.f%d.jpg", [[NSDate date] timeIntervalSince1970], aIndex] mimeType:@"image/jpeg"];
                     aIndex += 1;
                 }
             }
                  success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 
                 if ([responseObject[@"success"] integerValue] == 1)
                 {
                     [[TKAlertCenter defaultCenter] postAlertWithMessage:responseObject[@"message"] image:kRightImage];
                     [self.navigationController popViewControllerAnimated:YES];
                 }
                 else
                 {
                     if (responseObject != nil)
                     {
                         
                     }
                     else
                     {
                         
                     }
                     [[TKAlertCenter defaultCenter] postAlertWithMessage:responseObject[@"message"] image:kRightImage];
                 }
             }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 [[TKAlertCenter defaultCenter] postAlertWithMessage:msgInternetSlow image:kErrorImage];
             }];
        }
        @catch (NSException *exception)
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            NSLog(@"Exception %@ in %s on line %d",exception.description,__PRETTY_FUNCTION__,__LINE__);
        }
        @finally
        {
            
        }
    }
}

- (IBAction)btnAddPhotoTapped:(id)sender{
    _photoView.hidden = NO;
}

- (IBAction)btnGalleryTapped:(id)sender{

    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];

    if (status == PHAuthorizationStatusAuthorized)
    {
        [self showPhoto];
    }
    else if (status == PHAuthorizationStatusDenied)
    {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Enable the photos from device settings." image:kErrorImage];
    }
    else if (status == PHAuthorizationStatusNotDetermined)
    {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status)
        {
            if (status == PHAuthorizationStatusAuthorized)
            {
                [self showPhoto];
            }
            else
            {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Enable the photos from device settings." image:kErrorImage];
            }
        }];
    }
    else if (status == PHAuthorizationStatusRestricted)
    {
        // Restricted access - normally won't happen.
    }
}

- (void)showPhoto{
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.mediaType = QBImagePickerMediaTypeImage;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

- (IBAction)btnCameraTapped:(id)sender{

    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized)
    {
           [Helper showCamera:self];
    }
    else if(authStatus == AVAuthorizationStatusNotDetermined)
    {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
         {
             if(granted)
             {
                     [Helper showCamera:self];
             }
             else
             {
                 [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Enable the camera from device settings." image:kErrorImage];
                 return;
             }
         }];
    }
    else if (authStatus == AVAuthorizationStatusRestricted)
    {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Enable the camera from device settings." image:kErrorImage];
        return;
    }
    else
    {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Enable the camera from device settings." image:kErrorImage];
        return;
    }
}

- (IBAction)btnCategoryTapped:(id)sender{
    [_txtItemName resignFirstResponder];
    [self btnCloseTapped:nil];
    _btnCategory.selected = YES;
    _btnBorrowedBy.selected = NO;
    if(dropDown == nil) {
        CGFloat f = 50 * _arrCategory.count;
        dropDown = [[NIDropDown alloc]showDropDown:sender height:&f arr:_arrCategory direction:@"down" type:@"CatList"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)btnBorrowedByTapped:(id)sender{
    [_txtItemName resignFirstResponder];
    [self btnCloseTapped:nil];
    _btnCategory.selected = NO;
    _btnBorrowedBy.selected = YES;
    if(dropDown == nil) {
        CGFloat f = 50 * _arrUserList.count;
        dropDown = [[NIDropDown alloc]showDropDown:sender height:&f arr:_arrUserList direction:@"down" type:@"FriendList"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)btnHelpCategoryTapped:(id)sender{
    [_txtItemName resignFirstResponder];
    [dropDown hideDropDown:nil];
    _lblMessage.text = @"CHOOSE THE CATEGORY YOU WOULD LIKE THE ITEM TO BELONG TO. IF THE CATEGORY DOES NOT APPEAR NAVIGATE TO THE CATEGORY MENU AND ADD A NEW CATEGORY.";
    _guideView.hidden = NO;
}

- (IBAction)btnHelpBorrowedByTapped:(id)sender{
    [_txtItemName resignFirstResponder];
    [dropDown hideDropDown:nil];
    _lblMessage.text = @"SELECT YOUR FRIEND THAT WILL BE BORROWING THE ITEM. IF THEY DO NOT APPEAR IN THE LIST NAVIGATE TO THE FRIENDS MENU AND ADD YOUR NEW FRIEND.";
    _guideView.hidden = NO;
}

- (IBAction)btnOKTapped:(id)sender{
    _guideView.hidden = YES;
}

- (IBAction)btnReturnDateTapped:(id)sender{
    [_txtItemName resignFirstResponder];
    [dropDown hideDropDown:sender];
    [self showDatePickerView];
}

- (IBAction)btnRightTapped:(id)sender{
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = _mainView.frame;
        frame.origin.y = 0;
        _mainView.frame = frame;
    }];
    [UIView commitAnimations];

    _pickerView.hidden = YES;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDateFormat];
    NSString *value = [dateFormatter stringFromDate:_datePicker.date];
    _txtReturnDate.text = [value uppercaseString];
}

- (IBAction)btnCloseTapped:(id)sender{
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = _mainView.frame;
        frame.origin.y = 0;
        _mainView.frame = frame;
    }];
    [UIView commitAnimations];

    _pickerView.hidden = YES;
}

- (IBAction)btnClosePhotoViewTapped:(id)sender{
    _photoView.hidden = YES;
}

#pragma mark - QBImagePickerControllerDelegate

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets
{
    _photoView.hidden = YES;
    for (PHAsset *objAsset in assets)
    {
        [[PHImageManager defaultManager] requestImageForAsset:objAsset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
         {
             if ([info objectForKey:PHImageErrorKey] == nil)
             {
                 NSLog(@"%@", result);
                 [_arrImages addObject:result];
             }
         }];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    NSLog(@"Canceled.");
    _photoView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - ImagePicker Delegate Method

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    _photoView.hidden = YES;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    [_arrImages addObject:img];
    if (img) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Photo Added Successfully." image:kRightImage];
    }else{
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Photo Not Added Successfully." image:kErrorImage];
    }
    _photoView.hidden = YES;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Show Picker View

- (void)showDatePickerView{
    CGRect frame = _mainView.frame;
    if (IPHONE4S) {
        frame.origin.y = -70;
    }else if (IPHONE5S){
        frame.origin.y = -30;
    }

    [UIView animateWithDuration:0.4 animations:^{
        _mainView.frame = frame;
    }];
    [UIView commitAnimations];

    _pickerView.hidden = NO;
    _datePicker.hidden = NO;
    [self.view bringSubviewToFront:_datePicker];
//    [_datePicker setMinimumDate:[NSDate date]];
    _datePicker.datePickerMode = UIDatePickerModeDate;

    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_AU"];
    [_datePicker setLocale:locale];
}

#pragma mark - NIDropDown Delegate Method

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    if (_btnCategory.selected) {
        _txtCategory.text = sender.strTitle;
        _intCatID = sender.intCatID;
    }else if (_btnBorrowedBy.selected){
        _txtLendBy.text = sender.strTitle;
        _intFriendID = sender.intFriendID;
    }
    dropDown = nil;
    sender = nil;
}

#pragma mark - Validate Information

- (BOOL)isValidDetails{
    if(!_txtItemName.text || [_txtItemName.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterItemName image:kErrorImage];
        return NO;
    }else if(!_txtCategory.text || [_txtCategory.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgSelectCategory image:kErrorImage];
        return NO;
    }else if (!_txtLendBy.text || [_txtLendBy.text isEmptyString]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgSelectBorrowedBy image:kErrorImage];
        return NO;
    }else if (!_txtReturnDate.text || [_txtReturnDate.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgSelectReturnDate image:kErrorImage];
        return NO;
    }
    return YES;
}

#pragma mark - UITextField Delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [dropDown hideDropDown:nil];
    [self btnCloseTapped:nil];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Touch Event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[self view] endEditing:TRUE];
    [dropDown hideDropDown:nil];
    [self btnCloseTapped:nil];
}

@end
