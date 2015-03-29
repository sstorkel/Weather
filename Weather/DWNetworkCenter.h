//
//  DWNetworkCenter.h
//  Weather
//
//  Created by Scott Storkel on 3/28/15.
//  Copyright (c) 2015 Scott Storkel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

typedef void (^DWNetworkCompletionBlock)(NSDictionary* dict);

@interface DWNetworkCenter : NSObject

+ (instancetype)sharedInstance;

- (void)getWeatherForCity:(NSString*)city completion:(DWNetworkCompletionBlock)completionBlock;
- (void)getWeatherForLocation:(CLLocation*)location completion:(DWNetworkCompletionBlock)completionBlock;

@end
