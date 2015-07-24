//
//  ProductGridCollectionViewCell.h
//  MadStreetDen
//
//  Created by Vijaya Rekha on 7/21/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductGridCollectionViewCell : UICollectionViewCell
@property (nonatomic, retain) IBOutlet UIImageView *productImage;
@property (nonatomic, retain) IBOutlet UILabel *productTitle;
@property (nonatomic, retain) IBOutlet UILabel *productDesc;
@end
