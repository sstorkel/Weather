//
//  DWWeather.m
//  Weather
//
//  Created by Scott Storkel on 3/28/15.
//  Copyright (c) 2015 Scott Storkel. All rights reserved.
//

#import "DWWeather.h"


static NSDictionary* weatherCodes;
                                      


@implementation DWWeather

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // NOTE: weather.description and weather.main don't seem to be an exact match
        // for these definitions from:
        //
        //      http://openweathermap.org/weather-conditions
        //
        // These descriptions seem more detailed, so might be useful
        //
        weatherCodes = @{
                         // Thunderstorm
                         @"200": @"Thunderstorm with light rain",
                         @"201": @"Thunderstorm with rain",
                         @"202": @"Thunderstorm with heavy rain",
                         @"210": @"Light thunderstorm",
                         @"211": @"Thunderstorm",
                         @"212": @"Heavy thunderstorm",
                         @"221": @"Ragged thunderstorm",
                         @"230": @"Thunderstorm with light drizzle",
                         @"231": @"Thunderstorm with drizzle",
                         @"232": @"Thunderstorm with heavy drizzle",
                         
                         // Drizzle
                         @"300": @"Light intensity drizzle",
                         @"301": @"Drizzle",
                         @"302": @"Heavy intensity drizzle",
                         @"310": @"Light intensity drizzle rain",
                         @"311": @"Drizzle rain",
                         @"312": @"Heavy intensity drizzle rain",
                         @"313": @"Shower rain and drizzle",
                         @"314": @"Heavy shower rain and drizzle",
                         @"321": @"Shower drizzle",
                         
                         // Rain
                         @"500": @"Light rain",
                         @"501": @"Moderate rain",
                         @"502": @"Heavy intensity rain",
                         @"503": @"Very heavy rain",
                         @"504": @"Extreme rain",
                         @"511": @"Freezing rain",
                         @"520": @"Light intensity shower rain",
                         @"521": @"Shower rain",
                         @"522": @"Heavy intensity shower rain",
                         @"531": @"Ragged shower rain",
                         
                         // Snow
                         @"600": @"Light snow",
                         @"601": @"Snow",
                         @"602": @"Heavy snow",
                         @"611": @"Sleet",
                         @"612": @"Shower sleet",
                         @"615": @"Light rain and snow",
                         @"616": @"Rain and snow",
                         @"620": @"Light shower snow",
                         @"621": @"Shower snow",
                         @"622": @"Heavy shower snow",
                         
                         // Atmosphere
                         @"701": @"Mist",
                         @"711": @"Smoke",
                         @"721": @"Haze",
                         @"731": @"Sand, dust whirls",
                         @"741": @"Fog",
                         @"751": @"Sand",
                         @"761": @"Dust",
                         @"762": @"Volcanic ash",
                         @"771": @"Squalls",
                         @"781": @"Tornado",
                         
                         // Clouds
                         @"800": @"Clear sky",
                         @"801": @"Few clouds",
                         @"802": @"Scattered clouds",
                         @"803": @"Broken clouds",
                         @"804": @"Overcast clouds",
                         
                         // Extreme
                         @"900": @"Tornado",
                         @"901": @"Tropical storm",
                         @"902": @"Hurricane",
                         @"903": @"Cold",
                         @"904": @"Hot",
                         @"905": @"Windy",
                         @"906": @"Hail",
                         
                         // Additional
                         @"951": @"Calm",
                         @"952": @"Light breeze",
                         @"953": @"Gentle breeze",
                         @"954": @"Moderate breeze",
                         @"955": @"Fresh breeze",
                         @"956": @"Strong breeze",
                         @"957": @"High wind, near gale",
                         @"958": @"Gale",
                         @"959": @"Severe gale",
                         @"960": @"Storm",
                         @"961": @"Violent storm",
                         @"962": @"Hurricane"
                         
                         };

    });
}


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
        // convert pressure from hPa to inHg
        _pressure *= (29.92 / 1013.25);
        
        
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
        NSNumber* n =[weatherDict valueForKey:@"id"];
        _weatherID = n.stringValue;
        
        
        // "wind" dictionary
        //
        // Wind speed is given in meters/second. We convert to miles/hour:
        //
        tmp = [jsonData valueForKeyPath:@"wind.deg"];
        _windDirection = tmp.intValue;
        
        
        tmp = [jsonData valueForKeyPath:@"wind.gust"];
        _windGust = tmp.doubleValue;
        _windGust = _windGust * (3600.0/1609.34);
        
        tmp = [jsonData valueForKeyPath:@"wind.speed"];
        _windSpeed = tmp.doubleValue;
        _windSpeed = _windSpeed * (3600.0/1609.34);
       
    }
    return self;
}

- (NSString*)descriptionForWeatherID
{
    return [weatherCodes valueForKey:_weatherID];
}

//
// Wind directions and primary angles:
//
// "Cardinal" directions
//     N =   0 degress
//     E =  90
//     S = 180
//     W = 270
//
// "Ordinal" directions
//    NE =  45
//    SE = 135
//    SW = 225
//    NW = 315
//
//  "Half-winds"
//   NNE =  22.5
//   ENE =  67.5
//   ESE = 112.5
//   SSE = 157.5
//   SSW = 202.5
//   WSW = 247.5
//   WNW = 292.5
//   NNW = 337.5
//
// Each wind starts 11.25 degress before the primary angle and ends 11.25 degrees
// past the primary angle

- (NSString*)windDirectionString
{
    static const double spread = 11.25;
    
    if (_windDirection > 360 || _windDirection < 0) return @"";
    
    if (_windDirection >= (360-spread) && _windDirection < (0+spread))
        return @"N";
    else if (_windDirection >= (22.5-spread) && _windDirection < (22.5+spread))
        return @"NNE";
    else if (_windDirection >= (45-spread) && _windDirection < (45+spread))
        return @"NE";
    else if (_windDirection >= (67.5-spread) && _windDirection < (67.5+spread))
        return @"ENE";
    else if (_windDirection >= (90-spread) && _windDirection < (90+spread))
        return @"E";
    else if (_windDirection >= (112.5-spread) && _windDirection < (112.5+spread))
        return @"ESE";
    else if (_windDirection >= (135-spread) && _windDirection < (135+spread))
        return @"SE";
    else if (_windDirection >= (157.5-spread) && _windDirection < (157.5+spread))
        return @"SSE";
    else if (_windDirection >= (180-spread) && _windDirection < (180+spread))
        return @"S";
    else if (_windDirection >= (202.5-spread) && _windDirection < (202.5+spread))
        return @"SSW";
    else if (_windDirection >= (225.5-spread) && _windDirection < (225.5+spread))
        return @"SW";
    else if (_windDirection >= (247.5-spread) && _windDirection < (247.5+spread))
        return @"WSW";
    else if (_windDirection >= (270-spread) && _windDirection < (270+spread))
        return @"W";
    else if (_windDirection >= (292.5-spread) && _windDirection < (292.5+spread))
        return @"WNW";
    else if (_windDirection >= (315-spread) && _windDirection < (315+spread))
        return @"NW";
    else if (_windDirection >= (337.5-spread) && _windDirection < (337.5+spread))
        return @"NNW";
    
    return @"";
}

@end

























