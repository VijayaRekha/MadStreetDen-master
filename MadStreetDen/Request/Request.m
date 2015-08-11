//
//  Request.m
//  MadStreetDen
//
//  Created by GANESH BASKER on 18/07/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "Request.h"
#define BASE_URL @"https://fashion1.madstreetden.com"
static NSString *productID = @"MO296WA48MAHINDFAS";
static  NSString *appID = @"7212070341";
static NSString *appSecretkey = @"q4s7cgotmj3irpc7i0tc";
static NSString *productDetails = @"true";


@implementation Request

+(Request *) sharedManager{
    
    static Request *sharedInstance=nil;
    static dispatch_once_t  oncePredecate;
    
    dispatch_once(&oncePredecate,^{
        sharedInstance=[[Request alloc] init];
    });
    return sharedInstance;
}

/** Get Random Products **/

- (void) discoverProductsWithNumberOfResults:(NSString *)results
                             requestDelegate:(id<RequestDelegate>)delegate{
    
    self.requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/discover",BASE_URL]];
    self.reqDelegate = delegate;
    self.requestParameters = [NSString stringWithFormat:@"appID=%@&details=%@&numResults=%@&appSecret=%@",appID,productDetails,results,appSecretkey];
    [self callProductService];
    
}

/** Get More Products **/

- (void) getMoreProductsWithProductId:(NSString *)productID
                      numberOfResults:(NSString *)results
                      requestDelegate:(id<RequestDelegate>)delegate {
    
    self.requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/more",BASE_URL]];
    self.reqDelegate = delegate;
    self.requestParameters = [NSString stringWithFormat:@"productID=%@&appID=%@&details=%@&numResults=%@&appSecret=%@",productID,appID,productDetails,results,appSecretkey];
    [self callProductService];
    
}

/** Get Filtered Produts **/

- (void) getFilteredProductsWithMADSearchID:(NSString *)MADSearchID
                            numberOfResults:(NSString *)results
                              genderDetails:(NSString *)gender
                                MADKeywords:(NSString *)keywords
                            requestDelegate:(id<RequestDelegate>)delegate  {
    
    self.requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/filter",BASE_URL]];
    self.reqDelegate = delegate;
    self.requestParameters = [NSString stringWithFormat:@"MADsearchID=%@&appID=%@&details=%@&numResults=%@&appSecret=%@&gender=%@&MADkeywords=%@",MADSearchID,appID,productDetails,results,appSecretkey,gender,keywords];
    [self callProductService];
    
}


-(void) callProductService{
    
    NSString *paramLength=[NSString stringWithFormat:@"%lu",(unsigned long)[self.requestParameters length]];
    NSData *PostData = [self.requestParameters dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.requestURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:paramLength forHTTPHeaderField:@"Content-Lenght"];
    [request setHTTPBody:PostData];
    NSURLConnection *connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    self.responseData = [[NSMutableData alloc] init];
    
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [self.responseData appendData:data];
    
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSError *error;
    
    id response = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"Response : %@", response);
    NSMutableDictionary *responseDictionary = (NSMutableDictionary *)response;
    if ([[responseDictionary valueForKey:@"status"]isEqualToString:@"success"]) {
        [self.reqDelegate requestDidFinishLoadingWithResponse:responseDictionary];
    }else{
        
        
        
    }
    
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"Error Description : %@", error.description);
    [self.reqDelegate requestDidFailWithError:error];
    
    
}

- (void) uploadWithOriginalImage :(UIImage *)originalImage andCroppedImage:(UIImage *)cropedImage requestDelegate:(id<RequestDelegate>)delegate {
    NSString *urlString = @"https://fashion1.madstreetden.com/search" ;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"xPOST"];

    
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];

    //original file
    NSData *imageData = UIImagePNGRepresentation(originalImage);
   [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: attachment; name=\"input\"; filename=\".png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // file
    NSData *imageDataForCrop = UIImagePNGRepresentation(cropedImage);
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: attachment; name=\"roiInput\"; filename=\".png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageDataForCrop]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //roiRect, appID, appSecret, numResults, details, faceRect

    // Text parameter1
    NSString *param1 = @"1,2,100,100";
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"roiRect\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:param1] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    // Another text parameter
    NSString *param2 = appID;
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"appID\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:param2] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Another text parameter
    NSString *appSecret_ = appSecretkey;
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"appSecret\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:appSecret_] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Another text parameter
    NSString *numResults = @"10";
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"numResults\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:numResults] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Another text parameter
    NSString *details = productDetails;
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"details\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:details] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Another text parameter
    NSString *faceRect = @"0,0,0,0";
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"details\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:faceRect] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    // set request body
    [request setHTTPBody:body];

    //return and test
    NSURLConnection *connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
//    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//
//    NSLog(@"%@", returnString);
    }


@end
