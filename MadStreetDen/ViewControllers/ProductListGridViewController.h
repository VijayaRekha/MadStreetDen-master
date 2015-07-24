//
//  ProductListGridViewController.h
//  MadStreetDen
//
//  Created by GANESH BASKER on 18/07/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BaseViewController.h"
#import "ProductDetailViewController.h"
#import "Request.h"


@interface ProductListGridViewController : BaseViewController <UICollectionViewDataSource, UICollectionViewDelegate,RequestDelegate>{
    IBOutlet UICollectionView *productCollection;
}
@property (nonatomic, retain)    NSArray *dataArray;

@end
