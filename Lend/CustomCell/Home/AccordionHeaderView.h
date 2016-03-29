//
//  AccordionHeaderView.h
//  FZAccordionTableViewExample
//
//  Created by Krisjanis Gaidis on 6/7/15.
//  Copyright (c) 2015 Fuzz Productions, LLC. All rights reserved.
//

#import "FZAccordionTableView.h"

static const CGFloat kDefaultAccordionHeaderViewHeight = 50.0;
static NSString *const kAccordionHeaderViewReuseIdentifier = @"AccordionHeaderViewReuseIdentifier";

@interface AccordionHeaderView : FZAccordionTableViewHeaderView

@property (strong, nonatomic)IBOutlet UILabel *lblTitle;
@property (strong, nonatomic)IBOutlet UILabel *lblCount;
@property (strong, nonatomic)IBOutlet UIView *viewBG;
@property (strong, nonatomic)IBOutlet UIButton *btnArrow;

-(void)setHeaderTitle:(NSString *)str bgcolor:(UIColor *)color;

@end
