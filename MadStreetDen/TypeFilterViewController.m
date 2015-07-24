//
//  TypeFilterViewController.m
//  MadStreetDen
//
//  Created by GANESH BASKER on 23/07/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "TypeFilterViewController.h"
#import "ProductListGridViewController.h"
#import "AppDelegate.h"

@interface TypeFilterViewController ()

@end

@implementation TypeFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [@"Filter" uppercaseString];
    genderArray = [[NSMutableArray alloc] init];
    filterTypeArray = [[NSMutableArray alloc] init];
}

- (IBAction)filterClicked:(UIButton *)sender {
    
    UIButton *selectedButton = sender;
    BOOL selected = selectedButton.selected;
    NSLog(@"Tag: %lu %d",selectedButton.tag,selected);
    
    [selectedButton setSelected:!selected];
    if (!selected == YES) {
        [selectedButton setBackgroundColor:[UIColor lightGrayColor]];
        [filterTypeArray addObject:selectedButton.titleLabel.text];
    }else {
        [selectedButton setBackgroundColor:[UIColor clearColor]];
        [filterTypeArray removeObjectIdenticalTo:selectedButton.titleLabel.text];
    }
}

-(IBAction)genderBtnClicked:(UIButton *)sender{
    
    UIButton *selectedButton = sender;
    BOOL selected = selectedButton.selected;
    [selectedButton setSelected:!selected];
    if (!selected == YES) {
        [selectedButton setBackgroundColor:[UIColor lightGrayColor]];
        [genderArray addObject:selectedButton.titleLabel.text];

    }else {
        [selectedButton setBackgroundColor:[UIColor clearColor]];
        [genderArray addObject:selectedButton.titleLabel.text];

    }
}

-(IBAction)searchBtnClicked:(id)sender{
    [self showActivityIndicator];
    
    if (genderArray.count == 0){
        [genderArray addObject:@"MEN"];
        
    }if (filterTypeArray.count == 0){
        [filterTypeArray addObject:@"Shirts"];
    }
        Request *req = [[Request alloc] init];
        [req.reqParameters setValue:@"crop_2015071905301437283831xjg9d:0" forKey:@"MADsearchID"];
        [req.reqParameters setValue:@"7212070341" forKey:@"appID"];
        [req.reqParameters setValue:@"q4s7cgotmj3irpc7i0tc" forKey:@"appSecret"];
        [req.reqParameters setValue:@"10" forKey:@"numResults"];
        [req.reqParameters setValue:@"true" forKey:@"details"];
        [req.reqParameters setValue:genderArray forKey:@"gender"];
        [req.reqParameters setValue:filterTypeArray forKey:@"MADkeywords"];
        [req callProductRequest:FILTERPRODUCTREQUEST withDelegate:self];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestDidFinishLoadingWithResponse:(NSMutableDictionary *)responseDict
{
    ProductListGridViewController *rootViewController = (ProductListGridViewController *)[[self.navigationController viewControllers]objectAtIndex:0];
    [rootViewController setDataArray:[responseDict objectForKey:@"color"]];
    [rootViewController requestDidFinishLoadingWithResponse:responseDict];
    [self hideActivityIndicator];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
