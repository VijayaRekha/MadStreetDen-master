//
//  BaseViewController.h
//  MadStreetDen
//
//  Created by GANESH BASKER on 18/07/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController{

    UIActivityIndicatorView *activity;
}
- (void) showActivityIndicator;
-(void) hideActivityIndicator;

@end
