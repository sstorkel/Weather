//
//  DWWeather.m
//  Weather
//
//  Created by Scott Storkel on 3/28/15.
//  Copyright (c) 2015 Scott Storkel. All rights reserved.
//

#import "DWWeather.h"


@implementation DWWeather

- (instancetype)initWithJSON:(NSDictionary *)jsonData
{
    self = [super init];
    if (self) {
        NSString* tmp;
        
        // "coord" dictionary
        NSString* lat = [jsonData valueForKeyPath:@"coord.lat"];
        NSString* lon = [jsonData valueForKeyPath:@"coord.lon"];
        if (lat && lon) {
            double latitude = [lat doubleValue];
            double longitude = [lon doubleValue];
            _coordinates = CLLocationCoordinate2DMake(latitude, longitude);
        }
        
        
        // "main" dictionary
        tmp = [jsonData valueForKeyPath:@"main.humidity"];
        _humidity = tmp.doubleValue;
        
        tmp = [jsonData valueForKeyPath:@"main.temp"];
        _temp = tmp.doubleValue;
        
        tmp = [jsonData valueForKeyPath:@"main.temp_max"];
        _tempMax = tmp.doubleValue;
        
        tmp = [jsonData valueForKeyPath:@"main.temp_min"];
        _tempMin = tmp.doubleValue;
        
        tmp = [jsonData valueForKeyPath:@"main.pressure"];
        _pressure = tmp.doubleValue;
        
        
        // "name" key
        _locationName = [jsonData valueForKey:@"name"];
        
        
        // "rain" dictionary
        tmp = [jsonData valueForKeyPath:@"rain.3h"];
        _rain = tmp.doubleValue;
        
        
        // "sys" dictionary
        tmp = [jsonData valueForKeyPath:@"sys.sunrise"];
        int sunrise = tmp.intValue;
        _sunrise = [NSDate dateWithTimeIntervalSince1970:sunrise];
        
        tmp = [jsonData valueForKeyPath:@"sys.sunset"];
        int sunset = tmp.intValue;
        _sunset = [NSDate dateWithTimeIntervalSince1970:sunset];
        
         _locationCountry = [jsonData valueForKeyPath:@"sys.country"];
        
        
        // "weather" dictionary
        NSArray* a = [jsonData valueForKeyPath:@"weather"];
        NSDictionary* weatherDict = [a firstObject];
        
        _weatherDescription = [weatherDict valueForKey:@"description"];
        _weatherIcon = [weatherDict valueForKey:@"icon"];
        _weatherSummary = [weatherDict valueForKey:@"main"];
        tmp = [weatherDict valueForKey:@"id"];
        _weatherID = tmp.intValue;
        
        
        // "wind" dictionary
        tmp = [jsonData valueForKeyPath:@"wind.deg"];
        _windDirection = tmp.intValue;
        
        tmp = [jsonData valueForKeyPath:@"wind.gust"];
        _windGust = tmp.doubleValue;
        
        tmp = [jsonData valueForKeyPath:@"wind.speed"];
        _windSpeed = tmp.doubleValue;
       
    }
    return self;
}
@end
