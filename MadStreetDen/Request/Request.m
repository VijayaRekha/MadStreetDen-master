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


@end
