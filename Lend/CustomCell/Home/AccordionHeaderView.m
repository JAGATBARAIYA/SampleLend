//
//  AccordionHeaderView.m
//  FZAccordionTableViewExample
//
//  Created by Krisjanis Gaidis on 6/7/15.
//  Copyright (c) 2015 Fuzz Productions, LLC. All rights reserved.
//

#import "AccordionHeaderView.h"

@implementation AccordionHeaderView

-(void)setHeaderTitle:(NSString *)str bgcolor:(UIColor *)color{
    _lblTitle.text = str;
    self.viewBG.backgroundColor = color;
}

@end
