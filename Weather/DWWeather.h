//
//  DWWeather.h
//  Weather
//
//  Created by Scott Storkel on 3/28/15.
//  Copyright (c) 2015 Scott Storkel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>



@interface DWWeather : NSObject

@property (nonatomic, strong) NSDate* retrievalTime;

@property (nonatomic, strong) NSDate* sunrise;
@property (nonatomic, strong) NSDate* sunset;
@property (nonatomic, assign) CLLocationCoordinate2D coordinates;
@property (nonatomic, copy)   NSString* locationName;
@property (nonatomic, assign) double humidity;
@property (nonatomic, assign) double temp;
@property (nonatomic, assign) double tempMin;
@property (nonatomic, assign) double tempMax;
@property (nonatomic, assign) double rain;

@property (nonatomic, assign) float windSpeed;
@property (nonatomic, assign) float windGust;
@property (nonatomic, assign) int windDirection;

@property (nonatomic, copy)   NSString* weatherIcon;
@property (nonatomic, copy)   NSString* weatherDescription;

- (instancetype)initWithJSON:(NSDictionary*)jsonData;

@end
