//
//  Request.h
//  MadStreetDen
//
//  Created by GANESH BASKER on 18/07/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RequestDelegate <NSObject>
@required
-(void)requestDidFinishLoadingWithResponse:(NSMutableDictionary *)responseDict;
-(void)requestDidFailWithError:(NSError *)error;
@end



@interface Request : NSObject <NSURLConnectionDelegate,NSURLConnectionDataDelegate>{
    
    BOOL isProductDetailsRequired;
    
}
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, assign) id <RequestDelegate> reqDelegate;


+(Request *) sharedManager;
@property (nonatomic, retain) NSURL *requestURL;
@property (nonatomic, retain) NSString *requestParameters;
-(void) discoverProductsWithNumberOfResults:(NSString *)results requestDelegate:(id<RequestDelegate>)delegate;
- (void) getMoreProductsWithProductId:(NSString *)productID numberOfResults:(NSString *)results requestDelegate:(id<RequestDelegate>)delegate;
- (void) getFilteredProductsWithMADSearchID:(NSString *)MADSearchID numberOfResults:(NSString *)results
                              genderDetails:(NSString *)gender
                                MADKeywords:(NSString *)keywords
                            requestDelegate:(id<RequestDelegate>)delegate;
@end
