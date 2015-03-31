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

@property (nonatomic, strong) NSDate* sunrise;  // in GMT
@property (nonatomic, strong) NSDate* sunset;   // in GMT
@property (nonatomic, assign) CLLocationCoordinate2D coordinates;
@property (nonatomic, copy)   NSString* locationName;
@property (nonatomic, copy)   NSString* locationCountry;
@property (nonatomic, assign) double humidity;  // % humidity
@property (nonatomic, assign) double temp;      // In Fahrenheit
@property (nonatomic, assign) double tempMin;   // In Fahrenheit
@property (nonatomic, assign) double tempMax;   // In Fahrenheit
@property (nonatomic, assign) double pressure;  // In inches of mercury (inHG)
@property (nonatomic, assign) double rain;

@property (nonatomic, assign) double windSpeed; // In miles/hour
@property (nonatomic, assign) double windGust;  // in miles/hour
@property (nonatomic, assign) int windDirection;

@property (nonatomic, copy)   NSString* weatherIcon;
@property (nonatomic, copy)   NSString* weatherDescription;
@property (nonatomic, copy)   NSString* weatherID;
@property (nonatomic, copy)   NSString* weatherSummary;

- (instancetype)initWithJSON:(NSDictionary*)jsonData;
- (NSString*)descriptionForWeatherID;
- (NSString*)windDirectionString;

@end
