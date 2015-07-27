//
//  ProductListGridViewController.m
//  MadStreetDen
//
//  Created by GANESH BASKER on 18/07/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "ProductListGridViewController.h"
#import "ProductGridCollectionViewCell.h"
#import "TypeFilterViewController.h"
@interface ProductListGridViewController ()

@end

@implementation ProductListGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"MAD STREET DEN"; 
    
    Request *req = [[Request alloc] init];
    [req callProductRequest:MOREPRODUCTLISTREQUEST withDelegate:self];
    [self showActivityIndicator];
    
    [productCollection registerNib:[UINib nibWithNibName:@"ProductGridCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ProductGridCell"];
    [self setUpRightBarButton];
    [self setUpLeftBarButton];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(150, 255)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [productCollection setCollectionViewLayout:flowLayout];
    
   

    // Do any additional setup after loading the view.
}

-(void) setUpRightBarButton{
    
    
    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [customBtn setImage:[UIImage imageNamed:@"CameraICon"] forState:UIControlStateNormal];
    [customBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [customBtn addTarget:self action:@selector(loadCamera) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cameraBtn = [[UIBarButtonItem alloc] initWithCustomView:customBtn];
    [self.navigationItem setRightBarButtonItem:cameraBtn];

}

-(void) setUpLeftBarButton{
    
    
    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [customBtn setImage:[UIImage imageNamed:@"1437681890_45_Menu.png"] forState:UIControlStateNormal];
    [customBtn setFrame:CGRectMake(0, 0, 20, 20)];
    [customBtn addTarget:self action:@selector(showTypeFilter) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *typeBtn = [[UIBarButtonItem alloc] initWithCustomView:customBtn];
    [self.navigationItem setLeftBarButtonItem:typeBtn];
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ProductGridCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductGridCell" forIndexPath:indexPath];
    

    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    
    dispatch_async(queue, ^{
        
        NSURL *imgUrl = [NSURL URLWithString:[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"productImage"]];
        UIImage* productImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:imgUrl]];
        if (productImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                cell.productImage.image = productImage;
                cell.productTitle.text = [[[self.dataArray objectAtIndex:indexPath.row]valueForKey:@"brand"] uppercaseString];
                cell.productDesc.text = [[self.dataArray objectAtIndex:indexPath.row]valueForKey:@"productName"];
            });
        }
    });
    return cell;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProductDetailViewController *productDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"productDetailVC"];
    productDetailVC.detailProductDict = [self.dataArray objectAtIndex:indexPath.row];
    [productDetailVC setProductsArray:self.dataArray];
    [self.navigationController pushViewController:productDetailVC animated:YES];
    


}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellSpacing =(IS_IPHONE_6P) ? 6.0: 5.0; //Define the space between each cell
    CGFloat leftRightMargin = 15.0; //If defined in Interface Builder for "Section Insets"
    CGFloat numColumns = 2.0; //The total number of columns you want
    
    CGFloat totalCellSpace = cellSpacing * (numColumns - 1);
    CGFloat screenWidth = [UIScreen mainScreen ].bounds.size.width;
    CGFloat width = (screenWidth - leftRightMargin - totalCellSpace) / numColumns;
    CGFloat height = 255.0; //whatever height you want
    
    return CGSizeMake(width, height);
    
   // return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 10)/2,255); //use height whatever you wants.
}
//#pragma mark collection view cell paddings
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 5.0;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 5.0;
//}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    UIEdgeInsets edgeInset;
    if (IS_IPHONE_5) {
        edgeInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }else if (IS_IPHONE_6){
        edgeInset = UIEdgeInsetsMake(0, 10, 0, -15);
    }else if (IS_IPHONE_6P){
        edgeInset = UIEdgeInsetsMake(0, 20, 0, -20);
    }else{
        edgeInset = UIEdgeInsetsMake(0, 0, 0, 0);

    }
    return edgeInset;
}




-(void)requestDidFinishLoadingWithResponse:(NSMutableDictionary *)responseDict
{

    if (self.dataArray.count == 0) {
        self.dataArray = [responseDict objectForKey:@"data"];
    }
    NSLog(@"dataArray : %@",self.dataArray);
    [self hideActivityIndicator];
    [productCollection reloadData];

}

- (void)loadCamera {
    
}

- (void)showTypeFilter {
    //typeFilterVC
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TypeFilterViewController *typeFilterVC = [storyboard instantiateViewControllerWithIdentifier:@"typeFilterVC"];
    [self.navigationController pushViewController:typeFilterVC animated:YES];
    
}

-(void)requestDidFailWithError:(NSError *)error{


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
