//
//  CategoryVC.m
//  Lend
//
//  Created by Manish on 04/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import "CategoryVC.h"
#import "Constants.h"

@interface CategoryVC ()<CategoryHeaderDelegate,CategoryCellDelegate>

@property (strong, nonatomic) IBOutlet MSTextField *txtName;

@property (strong, nonatomic) IBOutlet UIView *addView;
@property (strong, nonatomic) IBOutlet UITableView *tblView;

@property (strong, nonatomic) NSMutableArray *arrCat;
@property (nonatomic) NSInteger openSectionIndex;

@end

@implementation CategoryVC

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)viewWillAppear:(BOOL)animated{
    [self getCatList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    _arrCat = [[NSMutableArray alloc]init];
    _tblView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self getCatList];
}

#pragma mark - Button Click Event

- (IBAction)btnAddCategoryTapped:(id)sender{
    _addView.hidden = NO;
    [self addTableView];
}

- (IBAction)btnAddTapped:(id)sender{
    if ([self isValidDetails]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [WebClient requestWithUrlWithResultVerificationWithLoder:kAddCategory parmeters:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserId],@"name":_txtName.text} success:^(NSDictionary *response) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [_txtName resignFirstResponder];
            NSLog(@"%@",response);
            if ([response[@"success"] boolValue]) {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:response[@"message"] image:kRightImage];
                [self getCatList];
                _txtName.text = @"";
                _addView.hidden = YES;
                [self removeTableView];
            }else{
                [[TKAlertCenter defaultCenter] postAlertWithMessage:response[@"message"] image:kErrorImage];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [[TKAlertCenter defaultCenter] postAlertWithMessage:msgInternetSlow image:kErrorImage];
        }];
    }
}

- (void)addTableView{
    [UIView animateWithDuration:0.7 animations:^{
        CGRect newframe=_tblView.frame;
        if (IPHONE4S || IPHONE5S) {
            newframe.origin.y = 160;
            newframe.size.height = [UIScreen mainScreen].bounds.size.height-251;
        }else if (IPHONE6){
            newframe.origin.y = 195;
            newframe.size.height = [UIScreen mainScreen].bounds.size.height-286;
        }else if (IPHONE6PLUS){
            newframe.origin.y = 220;
            newframe.size.height = [UIScreen mainScreen].bounds.size.height-312;
        }
        _tblView.frame=newframe;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)removeTableView{
    [UIView animateWithDuration:0.7 animations:^{
        CGRect newframe=_tblView.frame;
        if (IPHONE4S || IPHONE5S) {
            newframe.origin.y = 55;
            newframe.size.height = [UIScreen mainScreen].bounds.size.height-146;
        }else if (IPHONE6){
            newframe.origin.y = 65;
            newframe.size.height = [UIScreen mainScreen].bounds.size.height-156;
        }else if (IPHONE6PLUS){
            newframe.origin.y = 73;
            newframe.size.height = [UIScreen mainScreen].bounds.size.height-165;
        }
        _tblView.frame=newframe;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - Validate Information

- (BOOL)isValidDetails{
    if(!_txtName.text || [_txtName.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterName image:kErrorImage];
        return NO;
    }
    return YES;
}

#pragma mark - UITextField Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)getCatList{
    self.openSectionIndex = NSNotFound;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebClient requestWithUrlWithResultVerificationWithLoder:kGetItem parmeters:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserId]} success:^(NSDictionary *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@",response);
        if (response) {
            [_arrCat removeAllObjects];
            NSArray *listResult = response[@"Categorydata"];
            if(listResult.count!=0){
                _tblView.hidden = NO;
                [listResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    CatList *cat = [CatList dataWithDictionary:obj];
                    [_arrCat addObject:cat];
                }];
                [_tblView reloadData];
            }else {
                _tblView.hidden = YES;
            }
        }else{
            [[TKAlertCenter defaultCenter] postAlertWithMessage:msgCategoryNotFound image:kErrorImage];

           // [[TKAlertCenter defaultCenter] postAlertWithMessage:response[@"message"] image:kErrorImage];
            _tblView.hidden = YES;
        }
        [_tblView reloadData];
    } failure:^(NSError *error) {
        _tblView.hidden = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgInternetSlow image:kErrorImage];
    }];
}

#pragma mark - UITableView delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CategoryHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CategoryHeader"];
    if(!headerView){
        headerView = [[NSBundle mainBundle] loadNibNamed:@"CategoryHeader" owner:self options:nil][0];
    }
    CatList *catList = _arrCat[section];
    headerView.categoryList = catList;
    headerView.lblTitle.text = catList.strCategoryName;
    headerView.lblCount.text = [NSString stringWithFormat:@"(%ld)",(unsigned long)catList.arrCatItemList.count];
    if (catList.arrCatItemList.count == 0) {
        catList.open = NO;
    }
    headerView.btnBg.selected = catList.open;
    headerView.btnToggleIcon.selected = catList.open;
    headerView.btnToggleIcon.tag = section;
    headerView.delegate = self;
    headerView.tag = section;
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrCat.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CatList *catList = _arrCat[indexPath.section];
    CGFloat height = catList.arrCatItemList.count * 50;
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CatList *catList = _arrCat[section];
    return catList.open?1:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CategoryCell";
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CategoryCell" owner:self options:nil] objectAtIndex:0];
    
    CatList *catList = _arrCat[indexPath.section];
    cell.categoryList = catList;
    cell.delegate = self;
    return cell;
}

#pragma mark - Category Header View delegate methods

- (void)categoryHeader:(CategoryHeader *)view sectionOpened:(NSInteger)section{
    CatList *catList = _arrCat[section];
    [self openSection:catList section:section];
}

- (void)openSection:(CatList*)category section:(NSInteger)section{
    category.open = YES;
    
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    
    if (previousOpenSectionIndex != NSNotFound) {
        CatList *catList = _arrCat[previousOpenSectionIndex];
        catList.open = NO;
        
        CategoryHeader *headerView = (CategoryHeader*)[_tblView headerViewForSection:previousOpenSectionIndex];
        [headerView toggleOpenWithUserAction:NO];
        
        [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:0 inSection:previousOpenSectionIndex]];
    }
    
    [_tblView beginUpdates];
    [_tblView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
    [_tblView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
    [_tblView endUpdates];
    
    self.openSectionIndex = section;
}

- (void)categoryHeader:(CategoryHeader *)view sectionClosed:(NSInteger)section{
    CatList *catList = _arrCat[section];
    catList.open = NO;
    
    [_tblView beginUpdates];
    [_tblView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
    [_tblView endUpdates];
    
    self.openSectionIndex = NSNotFound;
}

#pragma mark - Category Cell Delegate Method

- (void)categoryCell:(ItemList *)item categoryCell:(CatList *)category{
    CategoryDetailVC *categoryDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryDetailVC"];
    categoryDetailVC.catList = category;
    categoryDetailVC.itemList = item;
    if ([item.strItemType isEqualToString:@"2"]) {
        categoryDetailVC.isBorrower = YES;
    }else{
        categoryDetailVC.isBorrower = NO;
    }
    categoryDetailVC.fromFriend = NO;

    [self.navigationController pushViewController:categoryDetailVC animated:YES];
}

- (void)reloadItemData:(ItemList *)item{
    [_tblView reloadData];
}

- (void)friendCell:(ItemList *)item{

}

#pragma mark - Touch Event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[self view] endEditing:TRUE];
}

@end
