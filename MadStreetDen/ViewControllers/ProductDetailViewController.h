//
//  ProductDetailViewController.h
//  MadStreetDen
//
//  Created by Vijaya Rekha on 7/21/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailViewController : UIViewController
{
    IBOutlet UIImageView *productDetailImageView;
    IBOutlet UIView *transparentView;
    IBOutlet UIScrollView *scrollViw;
    IBOutlet UILabel *brandName;
    IBOutlet UILabel *brandDescription;
    
    
}

@property (nonatomic, retain) NSArray *productsArray;
@property (nonatomic, retain) NSDictionary *detailProductDict;

@end
