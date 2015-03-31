//
//  DWNetworkCenter.m
//  Weather
//
//  Created by Scott Storkel on 3/28/15.
//  Copyright (c) 2015 Scott Storkel. All rights reserved.
//

#import "DWNetworkCenter.h"
#import <AFNetworking/AFNetworking.h>
#import <CoreLocation/CoreLocation.h>


static const NSString* APPID = @"58abcad7dc09bfcd9d42b1f7a0e02e96";


@interface DWNetworkCenter ()
{
    AFHTTPRequestOperation* currentRequest;
}
@end


@implementation DWNetworkCenter

+ (instancetype)sharedInstance
{
    static DWNetworkCenter* theInstance = nil;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^{
        theInstance = [self new];
    });
    
    return theInstance;
}

- (void)getWeatherFromURL:(NSString*)url completion:(DWNetworkCompletionBlock)completionBlock
{
    NSLog(@"%@", url);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if (currentRequest) {
        // Our simple weather app can only have one open network request at a time,
        // so if the user initiates a new request, we should cancel the existing
        // request
        //
        NSLog(@"request cancelled");
        [currentRequest cancel];
    }
    
    currentRequest = [manager GET:url
                       parameters:nil
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              self->currentRequest = nil;
                              completionBlock(responseObject, nil);
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              self->currentRequest = nil;
                              completionBlock(nil, error);
                          }];
}

- (void)getWeatherForCity:(NSString*)city completion:(DWNetworkCompletionBlock)completionBlock
{
    NSString* encodedCity = [city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@&APPID=%@&units=imperial", encodedCity, APPID];
    [self getWeatherFromURL:url completion:completionBlock];
}

- (void)getWeatherForLocation:(CLLocation*)location completion:(DWNetworkCompletionBlock)completionBlock
{
    NSString* url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&APPID=%@&units=imperial", location.coordinate.latitude, location.coordinate.longitude, APPID];
    [self getWeatherFromURL:url completion:completionBlock];
}

@end
