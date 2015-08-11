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
#import <MobileCoreServices/MobileCoreServices.h>
#import <SDWebImage/UIImageView+WebCache.h>


@interface ProductListGridViewController ()

@end

@implementation ProductListGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"MAD STREET DEN";
    
    //  Request *req = [[Request alloc] init];
    //[req callProductRequest:MOREPRODUCTLISTREQUEST withDelegate:self];
    
    [[Request sharedManager]discoverProductsWithNumberOfResults:@"16" requestDelegate:self];
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
    [customBtn addTarget:self action:@selector(loadActionSheet) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - CollectionView Delegate Methods

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
        if (!self.activityIndicator) {
            self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            self.activityIndicator.center = cell.contentView.center;
            self.activityIndicator.hidesWhenStopped = YES;
            
            [cell.productImage sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageTransformAnimatedImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [self.activityIndicator removeFromSuperview];
                self.activityIndicator = nil;
            }];
            
            
            [cell.productImage addSubview:self.activityIndicator];
            [self.activityIndicator startAnimating];
        }
        
        
        [cell.productImage sd_setImageWithURL:imgUrl
                             placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    }];
        cell.productTitle.text = [[[self.dataArray objectAtIndex:indexPath.row]valueForKey:@"brand"] uppercaseString];
        cell.productDesc.text = [[self.dataArray objectAtIndex:indexPath.row]valueForKey:@"productName"];
       
    });
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProductDetailViewController *productDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"productDetailVC"];
    productDetailVC.detailProductDict = [self.dataArray objectAtIndex:indexPath.row];
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


#pragma mark - Request Delegate Methods


-(void)requestDidFinishLoadingWithResponse:(NSMutableDictionary *)responseDict
{
    
    if (self.dataArray.count == 0) {
        self.dataArray = [responseDict objectForKey:@"data"];
    }
    NSLog(@"dataArray : %@",self.dataArray);
    [self hideActivityIndicator];
    [productCollection reloadData];
    
}

- (void)loadActionSheet {
    if (NSClassFromString(@"UIAlertController")) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Camera Options"
                                              message:@"Take Photo / Open Gallery"
                                              preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cameraAction =  [UIAlertAction actionWithTitle:NSLocalizedString(@"Take Photo", @"")
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action)
                                        {
                                            [self initateCamera];
                                        }];
        
        
        [alertController addAction:cameraAction];
        UIAlertAction *galleryAction =  [UIAlertAction actionWithTitle:NSLocalizedString(@"Open Gallery", @"")
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action)
                                        {
                                            [self loadGallery];
                                        }];
        
        
        [alertController addAction:galleryAction];
        
        UIAlertAction *cancelAciton =  [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"")
                                                                style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction *action)
                                        {
                                            NSLog(@"Reset action");
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                        }];
        
        
        [alertController addAction:cancelAciton];
        [self presentViewController:alertController animated:YES completion:nil];

    }
    else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Camera Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Open Gallery", nil];
        [actionSheet showInView:self.view];
        
    }
    
}

#pragma mark - Actionsheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self initateCamera];
    }else if(buttonIndex == 1) {
        [self loadGallery];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)initateCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }else {
        NSLog(@"No Camera :-( ");
        
    }
}

- (void)loadGallery {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:^{
            
        }];

    }
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    self.originalImage = image;
    [self dismissViewControllerAnimated:YES completion:^{
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
        cropController.delegate = self;
        [self presentViewController:cropController animated:YES completion:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)showTypeFilter {
    //typeFilterVC
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TypeFilterViewController *typeFilterVC = [storyboard instantiateViewControllerWithIdentifier:@"typeFilterVC"];
    [self.navigationController pushViewController:typeFilterVC animated:YES];
    
}

-(void)requestDidFailWithError:(NSError *)error{
    
    
}

#pragma mark - Cropper Delegate -
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    self.cropImage = image;
  
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    

    [[Request sharedManager] uploadWithOriginalImage:self.originalImage andCroppedImage:self.cropImage requestDelegate:self];

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
