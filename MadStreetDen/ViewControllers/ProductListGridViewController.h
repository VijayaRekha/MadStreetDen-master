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
#import "TOCropViewController.h"

@interface ProductListGridViewController : BaseViewController <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,RequestDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TOCropViewControllerDelegate>{
    IBOutlet UICollectionView *productCollection;
    UIImagePickerController *picker;
}
@property (nonatomic, retain)    NSArray *dataArray;
@property (nonatomic, retain) UIImage *originalImage;
@property (nonatomic, retain) __block UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIImage *cropImage;

@end
