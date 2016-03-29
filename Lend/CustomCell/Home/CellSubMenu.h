//
//  CellSubMenu.h
//  Baggage
//
//  Created by E2M164 on 03/10/15.
//  Copyright © 2015 E2M164. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellSubMenu : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblText;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UIView *viewBG;
@property (strong , nonatomic) IBOutlet UIButton *btnDelete;

@end
