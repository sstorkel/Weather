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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedWeather"]) {
        // capture reference to weatherVC via the embedWeather segue
        weatherVC = segue.destinationViewController;
    }
}

- (void)refreshWeather
{
    DWNetworkCenter* network = [DWNetworkCenter sharedInstance];
    DWNetworkCompletionBlock completion = ^(NSDictionary* dict) {
        [self->activity stopAnimating];
        
        self->dataContainer.hidden = NO;
        DWWeather* currentWeather = [[DWWeather alloc] initWithJSON:dict];
        self->weatherVC.currentWeather = currentWeather;
    };
    
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
        // Can't use CoreLocation; prompt user to re-enable
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
    [activity startAnimating];
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
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [lm startUpdatingLocation];
    } else {
        [self handleAuthError];
    }
}

- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray*)locations
{
    NSLog(@"Location = %@", locations);
    if (!locationField.isFirstResponder) {
        // Need to validate the new coordinate before we do anything else
        CLLocation* loc = locations.firstObject;
        if (loc.timestamp.timeIntervalSinceNow < -5*60)
            return;
        if (loc.horizontalAccuracy > kCLLocationAccuracyKilometer)
            return;
        
        // Looks like the date is valid; get weather for current coords
        [activity startAnimating];
        
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






