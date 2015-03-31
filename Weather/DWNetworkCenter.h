//
//  DWNetworkCenter.h
//  Weather
//
//  Created by Scott Storkel on 3/28/15.
//  Copyright (c) 2015 Scott Storkel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

typedef void (^DWNetworkCompletionBlock)(NSDictionary* dict, NSError* err);



/*
 * Design Note:
 *
 * We route all network requests through this singleton class so that it's easier 
 * to handle things like URL-creation (ex: adding '&APPID=xxxx' to all URLs), 
 * caching, and threading all in one place.
 */
@interface DWNetworkCenter : NSObject

+ (instancetype)sharedInstance;

- (void)getWeatherForCity:(NSString*)city completion:(DWNetworkCompletionBlock)completionBlock;
- (void)getWeatherForLocation:(CLLocation*)location completion:(DWNetworkCompletionBlock)completionBlock;

@end
