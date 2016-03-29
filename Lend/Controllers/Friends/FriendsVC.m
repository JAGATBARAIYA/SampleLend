//
//  FriendsVC.m
//  Lend
//
//  Created by Manish on 04/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import "FriendsVC.h"
#import "Constants.h"

@interface FriendsVC ()<FriendHeaderDelegate,CategoryCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tblView;

@property (strong, nonatomic) NSMutableArray *arrFriendList;
@property (nonatomic) NSInteger openSectionIndex;

@end

@implementation FriendsVC

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)viewWillAppear:(BOOL)animated{
    [self getFriendList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    _arrFriendList = [[NSMutableArray alloc]init];
    _tblView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self getFriendList];
}

#pragma mark - Button Click Event

- (IBAction)btnAddTapped:(id)sender{
    AddFriendVC *addFriendVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddFriendVC"];
    [self.navigationController pushViewController:addFriendVC animated:YES];
}

- (void)getFriendList{
    self.openSectionIndex = NSNotFound;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebClient requestWithUrlWithResultVerificationWithLoder:kGetFriendList parmeters:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserId]} success:^(NSDictionary *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@",response);
        [_arrFriendList removeAllObjects];
        if (response) {
            NSArray *listResult = response[@"Frienddata"];
            if(listResult.count!=0){
                [listResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    FriendsList *friendList = [FriendsList dataWithDictionary:obj];
                    [_arrFriendList addObject:friendList];
                }];
                [_tblView reloadData];
            }else {
              //  [[TKAlertCenter defaultCenter] postAlertWithMessage:msgFriendNotFound image:kErrorImage];
            }
        }else{
            [[TKAlertCenter defaultCenter] postAlertWithMessage:response[@"message"] image:kErrorImage];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgInternetSlow image:kErrorImage];
    }];
}

#pragma mark - UITableView delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    FriendHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FriendHeader"];
    if(!headerView){
        headerView = [[NSBundle mainBundle] loadNibNamed:@"FriendHeader" owner:self options:nil][0];
    }
    FriendsList *friendList = _arrFriendList[section];
    headerView.friendList = friendList;
    headerView.lblTitle.text = [friendList.strName capitalizedString];
    headerView.btnBg.selected = friendList.open;
    headerView.btnToggleIcon.selected = friendList.open;
    headerView.btnToggleIcon.tag = section;
    headerView.delegate = self;
    headerView.tag = section;
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrFriendList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendsList *friendList = _arrFriendList[indexPath.section];
    CGFloat height = friendList.arrItem.count * 50;
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    FriendsList *friendList = _arrFriendList[section];
    return friendList.open?1:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CategoryCell";
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CategoryCell" owner:self options:nil] objectAtIndex:0];
    
    FriendsList *friendList = _arrFriendList[indexPath.section];
    cell.friendList = friendList;
    cell.delegate = self;
    return cell;
}

#pragma mark - Age Category Header View delegate methods

- (void)friendHeader:(FriendHeader *)view sectionOpened:(NSInteger)section{
    FriendsList *friendList = _arrFriendList[section];
    [self openSection:friendList section:section];
}

- (void)openSection:(FriendsList *)friend section:(NSInteger)section{
    friend.open = YES;
    
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    
    if (previousOpenSectionIndex != NSNotFound) {
        FriendsList *friendList = _arrFriendList[previousOpenSectionIndex];
        friendList.open = NO;
        
        FriendHeader *headerView = (FriendHeader*)[_tblView headerViewForSection:previousOpenSectionIndex];
        [headerView toggleOpenWithUserAction:NO];
        
        [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:0 inSection:previousOpenSectionIndex]];
    }
    
    [_tblView beginUpdates];
    [_tblView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
    [_tblView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
    [_tblView endUpdates];
    
    self.openSectionIndex = section;
}

- (void)friendHeader:(FriendHeader *)view sectionClosed:(NSInteger)section{
    FriendsList *friendList = _arrFriendList[section];
    friendList.open = NO;
    
    [_tblView beginUpdates];
    [_tblView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
    [_tblView endUpdates];
    
    self.openSectionIndex = NSNotFound;
}

- (void)friendHeader:(FriendHeader *)view friendList:(FriendsList *)friendList{
    EditFriendVC *editFriendVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditFriendVC"];
    editFriendVC.friendDetails = friendList;
    [self.navigationController pushViewController:editFriendVC animated:YES];
}

#pragma mark - Category Cell Delegate Method

- (void)friendCell:(ItemList *)item{
    CategoryDetailVC *categoryDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryDetailVC"];
    categoryDetailVC.itemList = item;
    if ([item.strItemType isEqualToString:@"2"]) {
        categoryDetailVC.isBorrower = YES;
    }else{
        categoryDetailVC.isBorrower = NO;
    }
    categoryDetailVC.fromFriend = YES;
    [self.navigationController pushViewController:categoryDetailVC animated:YES];
}

- (void)categoryCell:(ItemList *)item categoryCell:(CatList *)category{

}

#pragma mark - Touch Event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[self view] endEditing:TRUE];
}

@end
