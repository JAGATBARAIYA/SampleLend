    //
//  CategoryDetailVC.m
//  Lend
//
//  Created by Manish on 10/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import "CategoryDetailVC.h"
#import "Constants.h"
#import "Itemphoto.h"
#import <objc/runtime.h>

@interface CategoryDetailVC ()<NIDropDownDelegate,QBImagePickerControllerDelegate,UIImagePickerControllerDelegate>
{
    NIDropDown *dropDown;
}

@property (strong, nonatomic) IBOutlet MSTextField *txtName;
@property (strong, nonatomic) IBOutlet MSTextField *txtDate;
@property (strong, nonatomic) IBOutlet MSTextField *txtCategory;

@property (strong, nonatomic) IBOutlet UIButton *btnName;
@property (strong, nonatomic) IBOutlet UIButton *btnCategory;
@property (strong, nonatomic) IBOutlet UIButton *btnAddPhoto;
@property (strong, nonatomic) IBOutlet UIButton *btnEdit;
@property (strong, nonatomic) IBOutlet UIButton *btnReturn;
@property (strong, nonatomic) IBOutlet UIButton *btnDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *photoView;
@property (strong, nonatomic) IBOutlet UIImageView *imgDefault;
@property (strong, nonatomic) IBOutlet UIView *imgDefaultView;
@property (strong, nonatomic) IBOutlet UIImageView *imgAdd;

@property (strong, nonatomic) NSMutableArray *arrCategory;
@property (strong, nonatomic) NSMutableArray *arrUserList;
@property (strong, nonatomic) NSMutableArray *arrOldImagesList;
@property (strong, nonatomic) NSMutableArray *arrNewImageList;

@property (assign, nonatomic) NSInteger intCatID;
@property (assign, nonatomic) NSInteger intFriendID;

@property (strong, nonatomic) itemDetails *itemDetails;

@end

@implementation CategoryDetailVC

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
    _arrOldImagesList = [[NSMutableArray alloc]init];
    _arrNewImageList = [[NSMutableArray alloc]init];
    
    _lblTitle.text = _itemList.strItemName;
    _intCatID = _itemList.intCatID;
    _intFriendID = _itemList.intItemUserID;
    
    _imgDefaultView.layer.borderWidth = 2.0;
    _imgDefaultView.layer.borderColor = [[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1.0] CGColor];

    if (_isBorrower) {
        _lblTitle.backgroundColor = _btnAddPhoto.backgroundColor = [UIColor colorWithRed:17.0/255.0 green:44.0/255.0 blue:147.0/255.0 alpha:1.0];
        _txtName.placeholder = @"BORROWED FROM {NAME}";
    }else{
        _txtName.placeholder = @"LENT TO {NAME}";
    }
    
    [self getCatDetails];
    [self getUserList];
    [self getCategoryList];
}

- (void)getCatDetails{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebClient requestWithUrlWithResultVerificationWithLoder:kGetItemDetail parmeters:@{@"itemid":[NSNumber numberWithInteger:_itemList.intItemID],@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserId]} success:^(NSDictionary *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@",response);
        if (response) {
            if(response[@"itemdata"]){
                
                _itemDetails = [itemDetails modelObjectWithDictionary:response[@"itemdata"]];
                
                if ([_itemDetails.itemeditstatus isEqualToString:@"1"]) {
                    _btnName.enabled = _btnDate.enabled = _btnCategory.enabled = _btnAddPhoto.enabled = _btnEdit.enabled = _btnReturn.enabled = YES;
                    _btnEdit.hidden = _btnAddPhoto.hidden = _btnReturn.hidden = _imgAdd.hidden = NO;
                }else{
                    _btnName.enabled = _btnDate.enabled = _btnCategory.enabled = _btnAddPhoto.enabled = _btnEdit.enabled = _btnReturn.enabled = NO;
                    _btnEdit.hidden = _btnAddPhoto.hidden = _btnReturn.hidden = _imgAdd.hidden = YES;
                }
                
                if ([_itemList.strItemStatus isEqualToString:@"1"]) {
                    _btnName.enabled = _btnDate.enabled = _btnCategory.enabled = _btnAddPhoto.enabled = _btnEdit.enabled = _btnReturn.enabled = NO;
                    _btnEdit.hidden = _btnAddPhoto.hidden = _btnReturn.hidden = _imgAdd.hidden = YES;
                }

                if (_fromFriend) {
                    _btnName.enabled = _btnDate.enabled = _btnCategory.enabled = _btnAddPhoto.enabled = _btnEdit.enabled = _btnReturn.enabled = NO;
                    _btnEdit.hidden = _btnAddPhoto.hidden = _btnReturn.hidden = _imgAdd.hidden = YES;
                }

                _intCatID = [_itemDetails.categoryid integerValue];
                _txtCategory.text = _itemDetails.category;
                _txtDate.text = [Helper dateStringFromString:_itemDetails.returndate format:@"yyyy-MM-dd" toFormat:kDateFormat];
                if (_isBorrower) {
                    _txtName.text = [_itemDetails.lendusername capitalizedString];
                }else{
                    _txtName.text = [_itemDetails.borrowusername capitalizedString];
                }
                _arrOldImagesList = [_itemDetails.itemphoto mutableCopy];

                if (_arrOldImagesList) {
                    objc_setAssociatedObject(self, @"OldImage", _arrOldImagesList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                }

                _pageControl.numberOfPages = _arrOldImagesList.count;
                if (_arrOldImagesList.count == 0) {
                    _pageControl.numberOfPages = 0;
                }
            }else {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Data Not Availabel" image:kErrorImage];
            }
            [_collectionView reloadData];
            _imgDefaultView.hidden = _arrOldImagesList.count!=0;
        }else{
            [[TKAlertCenter defaultCenter] postAlertWithMessage:response[@"message"] image:kErrorImage];
            _imgDefaultView.hidden = _arrOldImagesList.count!=0;
        }
        [_collectionView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgInternetSlow image:kErrorImage];
    }];
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
              //  [[TKAlertCenter defaultCenter] postAlertWithMessage:msgCategoryNotFound image:kErrorImage];
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
             //   [[TKAlertCenter defaultCenter] postAlertWithMessage:msgFriendNotFound image:kErrorImage];
            }
        }else{
            [[TKAlertCenter defaultCenter] postAlertWithMessage:response[@"message"] image:kErrorImage];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgInternetSlow image:kErrorImage];
    }];
}

#pragma mark - Button Tapped Event

- (IBAction)btnEditTapped:(id)sender{
    if ([self isValidDetails]) {
        @try
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];

            NSString *returnDate = [NSString stringWithFormat:@"%@",[Helper dateStringFromString:_txtDate.text format:@"dd/MM/yyyy" toFormat:@"yyyy-MM-dd"]];

            NSDictionary *parameters = @{@"itemid":[NSNumber numberWithInteger:_itemList.intItemID],@"name":_lblTitle.text,@"categoryid":[NSNumber numberWithInteger:_intCatID],@"itemuserid":[NSNumber numberWithInteger:_intFriendID],@"returndate":returnDate,@"itemtype":_itemList.strItemType,@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserId],@"itemphotocount":[NSNumber numberWithInteger:_arrNewImageList.count]};

//            NSString *strURL = @"http://e2msol.com/lendApp/api/Webservices/updateiteminfo";
            NSString *strURL = @"http://devser.net/lendApp/api/Webservices/updateiteminfo";

            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager.requestSerializer setValue:kLend_API_KEY forHTTPHeaderField:@"PC-API-KEY"];
            [manager POST:strURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
             {
                 int aIndex = 1;
                 for (UIImage *aImage in _arrNewImageList)
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

- (IBAction)btnReturnedTapped:(id)sender{
    if ([self isValidDetails]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [WebClient requestWithUrlWithResultVerificationWithLoder:kItemStatus parmeters:@{@"itemid":[NSNumber numberWithInteger:_itemList.intItemID],@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserId]} success:^(NSDictionary *response) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSLog(@"%@",response);
            if (response) {
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

- (IBAction)btnDateTapped:(id)sender{
    [dropDown hideDropDown:nil];
    [self showDatePickerView];
}

- (IBAction)btnCategoryTapped:(id)sender{
    [self btnCloseTapped:nil];
    _btnCategory.selected = YES;
    _btnName.selected = NO;
    if(dropDown == nil) {
        CGFloat f = 50 * _arrCategory.count;
        dropDown = [[NIDropDown alloc]showDropDown:sender height:&f arr:_arrCategory direction:@"down" type:@"CatList"];
//        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :_arrCategory :@"down" type:@"CatList"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)btnNameTapped:(id)sender{
    [self btnCloseTapped:nil];
    _btnCategory.selected = NO;
    _btnName.selected = YES;
    if(dropDown == nil) {
        CGFloat f = 50 * _arrUserList.count;
        dropDown = [[NIDropDown alloc]showDropDown:sender height:&f arr:_arrUserList direction:@"down" type:@"FriendList"];
//        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :_arrUserList :@"down" type:@"FriendList"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)btnRightTapped:(id)sender{
    _pickerView.hidden = YES;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDateFormat];
    NSString *value = [dateFormatter stringFromDate:_datePicker.date];
    _txtDate.text = [value uppercaseString];
}

- (IBAction)btnCloseTapped:(id)sender{
    _pickerView.hidden = YES;
}

- (IBAction)btnClosePhotoViewTapped:(id)sender{
    _photoView.hidden = YES;
}

- (IBAction)btnEditPhotoTapped:(UIButton *)sender{
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

- (IBAction)btnDeletePhotoTapped:(UIButton *)sender{
    if ([_itemDetails.itemeditstatus isEqualToString:@"1"]) {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:msgDeleteTitle andMessage:msgDeleteDesc];
        alertView.buttonsListStyle = SIAlertViewButtonsListStyleNormal;
        [alertView addButtonWithTitle:@"YES"
                                 type:SIAlertViewButtonTypeDestructive
                              handler:^(SIAlertView *alert) {
                                  [MBProgressHUD showHUDAddedTo:self.view animated:YES];

                                  CGPoint touchPoint = [sender convertPoint:CGPointZero toView:_collectionView];
                                  NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:touchPoint];
                                  ImageCell *cell = (ImageCell *) [_collectionView cellForItemAtIndexPath:indexPath];
                                  if (!cell.isImage) {
                                      [_collectionView performBatchUpdates:^{
                                          [_arrOldImagesList removeObjectAtIndex:sender.tag];
                                          [_arrNewImageList removeObject:cell.imgView.image];

                                          NSIndexPath *indexPath =[NSIndexPath indexPathForRow:sender.tag inSection:0];
                                          [_collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                                      } completion:^(BOOL finished) {
                                          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                          _pageControl.numberOfPages = _arrOldImagesList.count;
                                          _imgDefaultView.hidden = _arrOldImagesList.count!=0;
                                      }];
                                  }
                                  else{
                                      Itemphoto *removeItemPhoto = _arrOldImagesList[sender.tag];
                                      [WebClient requestWithUrlWithResultVerificationWithLoder:kDeletePhoto parmeters:@{@"itemphotoid":[NSNumber numberWithInteger:[removeItemPhoto.itemphotoid integerValue]]} success:^(NSDictionary *response) {
                                          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                          if (response) {
                                              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                              [_arrOldImagesList removeObjectAtIndex:sender.tag];
                                              [_collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:sender.tag inSection:0]]];
                                              _pageControl.numberOfPages = _arrOldImagesList.count;
                                              _imgDefaultView.hidden = _arrOldImagesList.count!=0;
                                          }else{
                                              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                              [[TKAlertCenter defaultCenter] postAlertWithMessage:response[@"message"] image:kErrorImage];
                                          }
                                      } failure:^(NSError *error) {
                                          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                          [[TKAlertCenter defaultCenter] postAlertWithMessage:msgInternetSlow image:kErrorImage];
                                      }];
                                  }
                              }];
        [alertView addButtonWithTitle:@"NO"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alert) {
                                  
                              }];
        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
        [alertView show];
    }else{

    }
}

#pragma mark - QBImagePickerControllerDelegate

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets{
    _photoView.hidden = YES;
    for (PHAsset *objAsset in assets)
    {
        [[PHImageManager defaultManager] requestImageForAsset:objAsset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
         {
             if ([info objectForKey:PHImageErrorKey] == nil)
             {
                 [_arrNewImageList addObject:result];
                 [_arrOldImagesList addObject:result];
                 _pageControl.numberOfPages = _arrOldImagesList.count;
                 [_collectionView reloadData];
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
    [_arrNewImageList addObject:img];
    [_arrOldImagesList addObject:img];
    _pageControl.numberOfPages = _arrOldImagesList.count;
    [_collectionView reloadData];

    if (img) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Photo Added Successfully." image:kRightImage];
    }else{
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Photo Not Added Successfully." image:kErrorImage];
    }
    _photoView.hidden = YES;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UICollectionView Delegate Method

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    return _arrOldImagesList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];

    id obj = _arrOldImagesList[indexPath.row];
    Itemphoto *itemPhoto= _arrOldImagesList[indexPath.row];

    if (![obj isKindOfClass:[UIImage class]]) {
        NSURL *imgURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,itemPhoto.path]];

        [cell.imgView setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"no_images"] options:SDWebImageRefreshCached usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        cell.btnDelete.tag = indexPath.row;
        cell.isImage = YES;

        objc_setAssociatedObject(self, @"Image", imgURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    }else{

        cell.imgView.image = _arrOldImagesList[indexPath.row];
        cell.btnDelete.tag = indexPath.row;
        cell.isImage = NO;

        if (cell.imgView.image) {
            [cell.imgView removeActivityIndicator];
        }

        objc_setAssociatedObject(self, @"Image", _arrOldImagesList[indexPath.row], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if ([_itemDetails.itemeditstatus isEqualToString:@"1"]) {
        cell.btnDelete.hidden = NO;
    }else{
        cell.btnDelete.hidden = YES;
    }

    if (_fromFriend) {
        cell.btnDelete.hidden = YES;
    }

    cell.imgView.contentMode = UIViewContentModeScaleAspectFill;
    [cell.btnDelete addTarget:self action:@selector(btnDeletePhotoTapped:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return _collectionView.frame.size;
}

#pragma mark - Scroll View delegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _pageControl.currentPage = self.collectionView.contentOffset.x / _collectionView.frame.size.width;
}

#pragma mark - Show Picker View

- (void)showDatePickerView{
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
    }else if (_btnName.selected){
        _txtName.text = sender.strTitle;
        _intFriendID = sender.intFriendID;
    }
    dropDown = nil;
    sender = nil;
}

#pragma mark - Validate Information

- (BOOL)isValidDetails{
    if(!_txtName.text || [_txtName.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgSelectLendBy image:kErrorImage];
        return NO;
    }else if(!_txtCategory.text || [_txtCategory.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgSelectCategory image:kErrorImage];
        return NO;
    }else if (!_txtDate.text || [_txtDate.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgSelectReturnDate image:kErrorImage];
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
    [dropDown hideDropDown:nil];
}

@end
