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
        
        tmp = [jsonData valueForKeyPath:@"sys.sunrise"];
        int sunrise = tmp.intValue;
        _sunrise = [NSDate dateWithTimeIntervalSince1970:sunrise];
        
        NSString* lat = [jsonData valueForKeyPath:@"coord.lat"];
        NSString* lon = [jsonData valueForKeyPath:@"coord.lon"];
        if (lat && lon) {
            double latitude = [lat doubleValue];
            double longitude = [lon doubleValue];
            _coordinates = CLLocationCoordinate2DMake(latitude, longitude);
        }
        
        
        tmp = [jsonData valueForKeyPath:@"main.humidity"];
        _humidity = tmp.doubleValue;
        
        tmp = [jsonData valueForKeyPath:@"main.temp"];
        _temp = tmp.doubleValue;
        
        tmp = [jsonData valueForKeyPath:@"main.temp_max"];
        _tempMax = tmp.doubleValue;
        
        tmp = [jsonData valueForKeyPath:@"main.temp_min"];
        _tempMin = tmp.doubleValue;
    }
    return self;
}
@end
