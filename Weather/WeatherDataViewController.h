//
//  WeatherDataViewController.h
//  Weather
//
//  Created by Scott Storkel on 3/29/15.
//  Copyright (c) 2015 Scott Storkel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DWWeather;


@interface WeatherDataViewController : UITableViewController

@property (nonatomic, strong) DWWeather* currentWeather;

@end
