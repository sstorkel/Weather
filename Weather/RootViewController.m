//
//  ViewController.m
//  Weather
//
//  Created by Scott Storkel on 3/28/15.
//  Copyright (c) 2015 Scott Storkel. All rights reserved.
//

#import "RootViewController.h"
#import "DWNetworkCenter.h"
#import "DWWeather.h"
#import "WeatherDataViewController.h"



@interface RootViewController ()
{
    IBOutlet UITextField* locationField;
    IBOutlet UIActivityIndicatorView* activity;
    IBOutlet UIView* dataContainer;
    
    WeatherDataViewController* weatherVC;
    
    BOOL useCoreLocationCoords;
    CLLocationManager* lm;
    CLLocation* currentLocation;
}
@end



@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    useCoreLocationCoords = NO;
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedWeather"]) {
        // capture reference to weatherVC via the embedWeather segue
        weatherVC = segue.destinationViewController;
    }
}


#pragma mark -


- (void)refreshWeather
{
    DWNetworkCenter* network = [DWNetworkCenter sharedInstance];
    DWNetworkCompletionBlock completion = ^(NSDictionary* dict, NSError* error) {
        [self->activity stopAnimating];
        
        if (!error) {
            self->dataContainer.hidden = NO;
            DWWeather* currentWeather = [[DWWeather alloc] initWithJSON:dict];
            self->weatherVC.currentWeather = currentWeather;
        } else {
            [self handleNetworkError:error];
        }
    };
    
    [activity startAnimating];
    weatherVC.currentWeather = nil;
    
    if (useCoreLocationCoords) {
        [network getWeatherForLocation:currentLocation completion:completion];
    } else {
        [network getWeatherForCity:locationField.text completion:completion];
    }
}


#pragma mark - Event-Handling


- (IBAction)currentLocation:(id)sender
{
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    if (authStatus == kCLAuthorizationStatusDenied || authStatus == kCLAuthorizationStatusRestricted) {
        [self handleAuthError];
    } else {
        if (lm == nil) {
            lm = [CLLocationManager new];
            lm.delegate = self;
            lm.desiredAccuracy = kCLLocationAccuracyKilometer;
            lm.distanceFilter = 1000.0;
        }
        
        if (authStatus == kCLAuthorizationStatusNotDetermined) {
            [lm requestWhenInUseAuthorization];
        } else {
            [lm startUpdatingLocation];
        }
    }
}


#pragma mark - Textfield Handlng


- (void)textFieldDidEndEditing:(UITextField*)textField
{
    [self refreshWeather];
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if (textField.text.length > 0)
        [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    useCoreLocationCoords = NO;
}


#pragma mark - CLLocationManagerDelegate


- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"Authorization Status = %d", status);
    
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            /* just ignore this */
            break;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:
            [lm startUpdatingLocation];
            break;
            
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            [self handleAuthError];
            break;
    }
}

- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray*)locations
{
    NSLog(@"Location = %@", locations);
    
    if (!locationField.isFirstResponder) {
        // Need to validate the new coordinate before we do anything else
        CLLocation* loc = locations.firstObject;
        if (loc.timestamp.timeIntervalSinceNow < -5*60)
            // ignore coordinates more than 5 minutes old
            return;
        if (loc.horizontalAccuracy > kCLLocationAccuracyKilometer)
            return;
        
        // Looks like the data is valid. Time to do two things:
        // - tell CLLocationManager to stop delivering location updates, so we
        //   can conserve power
        //
        // - refresh the weather forecast
        //
        currentLocation = loc;
        [lm stopUpdatingLocation];
        useCoreLocationCoords = YES;
        
        [self refreshWeather];
    }
}

- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:error.localizedDescription
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

/*
 * This code is virtually identical to locationManager:didFailWithError: but 
 * conceptually we might want to handle network and CoreLocation errors differently 
 * (ex: by providing different error-messages, retry options, etc.) so we've kept 
 * the methods separate... for now.
 */
- (void)handleNetworkError:(NSError*)error
{
    // Ignore errors generated when operations are cancelled
    if (error.code != -999 ) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

/**
 * Handle CoreLocation authorization errors, by prompting the suer to reenable
 * Location Services via the Settings app
 */
- (void)handleAuthError
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Location Services are disabled for Weather. Please use the "
                                                             "Settings app to enable Location Services."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end






