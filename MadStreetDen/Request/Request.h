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

typedef enum {
    
    MOREPRODUCTLISTREQUEST = 0,
    SEARCHPRODUCTLISTREQUEST,
    FILTERPRODUCTREQUEST
    
} REQUEST_TYPE;

@interface Request : NSObject <NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property (nonatomic, assign) REQUEST_TYPE requestType;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSMutableDictionary *reqParameters;
@property (nonatomic, assign) id <RequestDelegate> reqDelegate;
- (void) callProductRequest:(REQUEST_TYPE)reqType withDelegate:(id<RequestDelegate>)delegate;
@end
