//
//  ImageCell.h
//  Lend
//
//  Created by Manish on 18/11/15.
//  Copyright © 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@property (assign, nonatomic) BOOL isImage;

@end
