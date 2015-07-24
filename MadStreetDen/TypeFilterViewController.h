//
//  TypeFilterViewController.h
//  MadStreetDen
//
//  Created by GANESH BASKER on 23/07/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Request.h"
#import "BaseViewController.h"

@interface TypeFilterViewController : BaseViewController <RequestDelegate>
{
    NSMutableArray *filterTypeArray;
    NSMutableArray *genderArray;
}
-(IBAction)genderBtnClicked:(id)sender;
- (IBAction)filterClicked:(UIButton *)sender ;
-(IBAction)searchBtnClicked:(id)sender;
@end
