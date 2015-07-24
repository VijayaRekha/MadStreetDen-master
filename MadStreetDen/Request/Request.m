//
//  Request.m
//  MadStreetDen
//
//  Created by GANESH BASKER on 18/07/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "Request.h"
#define BASE_URL @"https://fashion1.madstreetden.com"

@implementation Request

-(id)init{
    
    self = [super init];
    if (self){
        self.reqParameters = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (void) callProductRequest:(REQUEST_TYPE)reqType withDelegate:(id<RequestDelegate>)delegate {
    
    NSURL *reqUrl = nil;
    NSString *reqParam = nil;
    self.reqDelegate = delegate;
    
    switch (reqType) {
            
        case MOREPRODUCTLISTREQUEST: {
            reqUrl= [NSURL URLWithString:[NSString stringWithFormat:@"%@/more",BASE_URL]];
            reqParam=[NSString stringWithFormat:@"productID=MO296WA48MAHINDFAS&appID=7212070341&details=true&numResults=16&appSecret=q4s7cgotmj3irpc7i0tc"];
        }
        break;
        case FILTERPRODUCTREQUEST:{

            reqUrl= [NSURL URLWithString:[NSString stringWithFormat:@"%@/filter",BASE_URL]];
            //reqParam = [[self getParamStringFromDictionary]copy];
           reqParam = @"gender=['men']&MADkeywords=[[]]&MADsearchID=crop_2015071905301437283831xjg9d:0&appID=7212070341&details=true&numResults=16&appSecret=q4s7cgotmj3irpc7i0tc";
        }
        break;
        default:
        break;
    }
    NSString *paramLength=[NSString stringWithFormat:@"%lu",(unsigned long)[reqParam length]];
    NSData *PostData = [reqParam dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:reqUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:paramLength forHTTPHeaderField:@"Content-Lenght"];
    [request setHTTPBody:PostData];
    NSURLConnection *connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (NSMutableString *) getParamStringFromDictionary {
    //https://fashion1.madstreetden.com/filter/?gender=["women"]&MADkeywords=[[]]&MADsearchID=crop_201507170325143710350684s06:0&appID=7212070341&details=true&numResults=16&appSecret=q4s7cgotmj3irpc7i0tc
    NSMutableString *paramStr = [[NSMutableString alloc] init];
    
    for  (id key in self.reqParameters){
        
        if ([[self.reqParameters valueForKey:key] isKindOfClass:[NSMutableArray class]]){
            [paramStr appendFormat:@"%@=",key];
            NSArray *arr = [self.reqParameters valueForKey:key];
            for (NSString *val in arr){
                [paramStr appendString:[NSString stringWithFormat:@"[\"%@\"],",val]];
            }
            paramStr = [[paramStr substringToIndex:[paramStr length]-1] mutableCopy];
            NSLog(@"paramStr : %@",paramStr);
            
        }else{
            [paramStr appendString:[NSString stringWithFormat:@"&%@=%@&",key,[self.reqParameters valueForKey:key]]];
            paramStr = [[paramStr substringToIndex:[paramStr length]-1] mutableCopy];
            NSLog(@"paramStr : %@",paramStr);
            
        }
    }
  
    return paramStr;

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
