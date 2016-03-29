//
//  LendBorrowVC.m
//  Lend
//
//  Created by Manish on 06/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import "LendBorrowVC.h"
#import "Constants.h"

static NSString *const kTableViewCellReuseIdentifier = @"TableViewCellReuseIdentifier";

@interface LendBorrowVC ()

@property (strong, nonatomic) NSMutableArray *arrLendItemList;
@property (strong, nonatomic) NSMutableArray *arrBorrowedItemList;

@property (weak, nonatomic) IBOutlet FZAccordionTableView *tableMain;
@property (assign, nonatomic) BOOL isOpenToggle;
@property (assign, nonatomic) BOOL isConfirmOpenToggle;
@property (assign, nonatomic) NSInteger intSection;

@end

@implementation LendBorrowVC

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)viewWillAppear:(BOOL)animated{
    [self getItemList];
    _isOpenToggle = _isConfirmOpenToggle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    _arrLendItemList = [[NSMutableArray alloc]init];
    _arrBorrowedItemList = [[NSMutableArray alloc]init];

    _tableMain.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self getItemList];
}

#pragma mark - Button Click Event

- (IBAction)btnAddClicked:(NSInteger)sender{
    if (sender == 0) {
        AddLendVC *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddLendVC"];
        [self.navigationController pushViewController:homeVC animated:YES];
    }else{
        AddBorrowVC *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddBorrowVC"];
        [self.navigationController pushViewController:homeVC animated:YES];
    }
}

#pragma mark - Get Item List

- (void)getItemList{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebClient requestWithUrlWithResultVerificationWithLoder:kGetItemList parmeters:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserId]} success:^(NSDictionary *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@",response);
        [_arrLendItemList removeAllObjects];
        [_arrBorrowedItemList removeAllObjects];
        if (response) {
            NSArray *listResult = response[@"Lentitemdata"];
            if(listResult.count!=0){
                [listResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    ItemList *itemList = [ItemList dataWithDictionary:obj];
                    [_arrLendItemList addObject:itemList];
                }];
                [_tableMain reloadData];
            }else {
               // [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Data Not Availabel" image:kErrorImage];
            }
            NSArray *result = response[@"Borrowitemdata"];
            if(result.count!=0){
                [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    ItemList *itemList = [ItemList dataWithDictionary:obj];
                    [_arrBorrowedItemList addObject:itemList];
                }];
                [_tableMain reloadData];
            }else {
                //[[TKAlertCenter defaultCenter] postAlertWithMessage:@"Data Not Availabel" image:kErrorImage];
            }

        }else{
            [[TKAlertCenter defaultCenter] postAlertWithMessage:response[@"message"] image:kErrorImage];
        }
        [_tableMain reloadData];

    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgInternetSlow image:kErrorImage];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _arrLendItemList.count+1;
    }else{
        return _arrBorrowedItemList.count+1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

NSArray *arrayAllData;

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kDefaultAccordionHeaderViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return [self tableView:tableView heightForHeaderInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TableViewCellFirst *SubView = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellFirst"];
        if(!SubView){
            SubView = [[NSBundle mainBundle] loadNibNamed:@"TableViewCellFirst" owner:self options:nil][0];
        }
        
        if (indexPath.section == 0)
            SubView.contentView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:112.0/255.0 blue:32.0/255.0 alpha:1.0];
        else
           SubView.contentView.backgroundColor = [UIColor colorWithRed:46.0/255.0 green:49.0/255.0 blue:146.0/255.0 alpha:1.0];
        
        SubView.btnAdd.tag = indexPath.row;
        [SubView.btnAdd addTarget:self action:@selector(btnAddClicked:) forControlEvents:UIControlEventTouchUpInside];
        return SubView;
    }else {
        CellSubMenu *SubView = [tableView dequeueReusableCellWithIdentifier:@"CellSubMenu"];
        if(!SubView){
            SubView = [[NSBundle mainBundle] loadNibNamed:@"CellSubMenu" owner:self options:nil][0];
        }
        ItemList *itemList = nil;
        
        if (indexPath.section == 0) {
            itemList = _arrLendItemList[indexPath.row-1];
            SubView.contentView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:112.0/255.0 blue:32.0/255.0 alpha:1.0];
            SubView.lblText.textColor = [UIColor colorWithRed:239.0/255.0 green:112.0/255.0 blue:32.0/255.0 alpha:1.0];
            SubView.lblDate.textColor = [UIColor colorWithRed:239.0/255.0 green:112.0/255.0 blue:32.0/255.0 alpha:1.0];
        }else{
            itemList = _arrBorrowedItemList[indexPath.row-1];
            SubView.contentView.backgroundColor = [UIColor colorWithRed:46.0/255.0 green:49.0/255.0 blue:146.0/255.0 alpha:1.0];
            SubView.lblText.textColor = [UIColor colorWithRed:17.0/255.0 green:44.0/255.0 blue:147.0/255.0 alpha:1.0];
            SubView.lblDate.textColor = [UIColor colorWithRed:17.0/255.0 green:44.0/255.0 blue:147.0/255.0 alpha:1.0];
        }
        SubView.lblText.text = itemList.strItemName;
        SubView.lblDate.text = [Helper dateStringFromString:itemList.strReturnDate format:@"yyyy-MM-dd" toFormat:kDateFormat];
        return SubView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    AccordionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kAccordionHeaderViewReuseIdentifier];
    if(!headerView){
        headerView = [[NSBundle mainBundle] loadNibNamed:@"AccordionHeaderView" owner:self options:nil][0];
    }
    if (section == 0) {
        [headerView setHeaderTitle:@"LENT ITEMS" bgcolor:[UIColor colorWithRed:239.0/255.0 green:112.0/255.0 blue:32.0/255.0 alpha:1.0]];
        headerView.lblCount.text = [NSString stringWithFormat:@"(%ld)",(unsigned long)_arrLendItemList.count];
    }else{
        [headerView setHeaderTitle:@"BORROWED ITEMS" bgcolor:[UIColor colorWithRed:46.0/255.0 green:49.0/255.0 blue:146.0/255.0 alpha:1.0]];
        headerView.lblCount.text = [NSString stringWithFormat:@"(%ld)",(unsigned long)_arrBorrowedItemList.count];
    }
    if (_intSection == section) {
        headerView.btnArrow.selected = _isOpenToggle;
    }
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self btnAddClicked:indexPath.section];
    }else{
        ItemList *itemList = nil;
        BOOL isBorrower;
        
        if (indexPath.section == 0) {
            itemList = _arrLendItemList[indexPath.row-1];
            isBorrower = NO;
        }else{
            itemList = _arrBorrowedItemList[indexPath.row-1];
            isBorrower = YES;
        }

        CategoryDetailVC *categoryDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryDetailVC"];
        categoryDetailVC.itemList = itemList;
        categoryDetailVC.isBorrower = isBorrower;
        [self.navigationController pushViewController:categoryDetailVC animated:YES];
    }
}

#pragma mark - <FZAccordionTableViewDelegate> -

- (void)tableView:(FZAccordionTableView *)tableView willOpenSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header {
}

- (void)tableView:(FZAccordionTableView *)tableView didOpenSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header {
    AccordionHeaderView *aView = (AccordionHeaderView *)[tableView headerViewForSection:section];
    aView.btnArrow.selected = !aView.btnArrow.selected;
    if (aView.btnArrow.selected) {
        _isConfirmOpenToggle = YES;
        _intSection = section;
    }
}

- (void)tableView:(FZAccordionTableView *)tableView willCloseSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header {
}

- (void)tableView:(FZAccordionTableView *)tableView didCloseSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header {
    AccordionHeaderView *aView = (AccordionHeaderView *)[tableView headerViewForSection:section];
    aView.btnArrow.selected = !aView.btnArrow.selected;
    if (aView.btnArrow.selected) {
        _isConfirmOpenToggle = YES;
        _intSection = section;
    }
}

#pragma mark - Touch Event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[self view] endEditing:TRUE];
}

@end
