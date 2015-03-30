//
//  WeatherDataViewController.m
//  Weather
//
//  Created by Scott Storkel on 3/29/15.
//  Copyright (c) 2015 Scott Storkel. All rights reserved.
//

#import "WeatherDataViewController.h"
#import "DWWeather.h"
#import "RootViewController.h"
#import <MapKit/MapKit.h>



@interface WeatherDataViewController ()
{
    IBOutlet UILabel* locationName;
    IBOutlet UILabel* summaryConditions;
    
    IBOutlet UILabel* temperatureLabel;
    IBOutlet UILabel* rainLabel;
    IBOutlet UILabel* humidityLabel;
    IBOutlet UILabel* windLabel;
    IBOutlet UILabel* sunriseLabel;
    IBOutlet UILabel* sunsetLabel;
    IBOutlet UILabel* pressureLabel;
    
    IBOutlet MKMapView* mapView;
}
@end



@implementation WeatherDataViewController

- (void)setCurrentWeather:(DWWeather*)weather
{
    _currentWeather = weather;
    
    locationName.text = [NSString stringWithFormat:@"%@, %@", _currentWeather.locationName, _currentWeather.locationCountry];
    summaryConditions.text = weather.descriptionForWeatherID;
    
    temperatureLabel.text = [NSString stringWithFormat:@"%1.1f° F", _currentWeather.temp];
    
    rainLabel.text = [NSString stringWithFormat:@"%.000f\" over the next 3 hours", _currentWeather.rain];
    
    humidityLabel.text = [NSString stringWithFormat:@"%1.f%%", _currentWeather.humidity];
    
    windLabel.text = [NSString stringWithFormat:@"%@ at %.1fmph", _currentWeather.windDirectionString, _currentWeather.windSpeed];
    
    sunriseLabel.text = [NSDateFormatter localizedStringFromDate:_currentWeather.sunrise
                                                       dateStyle:NSDateFormatterNoStyle
                                                       timeStyle:NSDateFormatterLongStyle];
    
    sunsetLabel.text = [NSDateFormatter localizedStringFromDate:_currentWeather.sunset
                                                      dateStyle:NSDateFormatterNoStyle
                                                      timeStyle:NSDateFormatterLongStyle];
    
    pressureLabel.text = [NSString stringWithFormat:@"%.1f inHg", _currentWeather.pressure];
    
    MKCoordinateRegion r = MKCoordinateRegionMakeWithDistance(_currentWeather.coordinates, 7500, 7500);
    [mapView setRegion:r animated:YES];
}


 - (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = 44;
}


- (IBAction)refreshWeather:(id)sender
{
    UIRefreshControl* refresh = sender;
    RootViewController* root = (RootViewController*)self.parentViewController;
    [root refreshWeather];
    
    [refresh endRefreshing];
    
}
@end
