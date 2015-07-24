//
//  ProductDetailViewController.m
//  MadStreetDen
//
//  Created by Vijaya Rekha on 7/21/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "ProductDetailViewController.h"

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *imgUrl = [NSURL URLWithString:[self.detailProductDict valueForKey:@"productImage"]];
    productDetailImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgUrl]];
    brandName.text = [[self.detailProductDict valueForKey:@"brand"] uppercaseString];
    brandDescription.text = [self.detailProductDict valueForKey:@"productName"];
    self.title = brandName.text;
    [self loadScrollView];
  
    
}

-(void) loadScrollView{
    
    for (int i = 0; i<[self.productsArray count]; i++) {
        NSURL *imgUrl = [NSURL URLWithString:[[self.productsArray valueForKey:@"productImage"] objectAtIndex:i]];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgUrl]];
        CGRect rect = CGRectMake(i*105, 10, 90, scrollViw.frame.size.height);
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:rect];
        imgV.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture:)];
        tapGesture1.numberOfTapsRequired = 1;
        imgV.tag = i;
        [imgV addGestureRecognizer:tapGesture1];
        
        imgV.contentMode=UIViewContentModeScaleToFill;
        [imgV setImage:image];
        [scrollViw addSubview:imgV];
    }
    
    [scrollViw setContentOffset:CGPointMake(0, 0)];
    [scrollViw setContentSize:CGSizeMake(104.99 * self.productsArray.count, scrollViw.frame.size.height)];
    
}

- (void) tapGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    UIImageView *imgV = (UIImageView *)gestureRecognizer.view;
    brandName.text = [[[self.productsArray valueForKey:@"brand"] objectAtIndex:imgV.tag] uppercaseString];
    self.title = brandName.text;

    NSURL *imgUrl = [NSURL URLWithString:[[self.productsArray valueForKey:@"productImage"] objectAtIndex:imgV.tag]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgUrl]];
    productDetailImageView.image = image;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
