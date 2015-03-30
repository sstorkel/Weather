//
//  ViewController.h
//  Weather
//
//  Created by Scott Storkel on 3/28/15.
//  Copyright (c) 2015 Scott Storkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface RootViewController : UIViewController <UITextFieldDelegate, CLLocationManagerDelegate>

- (void)refreshWeather;
@end

