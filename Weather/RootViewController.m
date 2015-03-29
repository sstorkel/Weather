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
#import <CoreLocation/CoreLocation.h>


@interface RootViewController ()
{
    IBOutlet UITextField* locationField;
    IBOutlet UIActivityIndicatorView* activity;
    IBOutlet UIView* dataContainer;
    
    WeatherDataViewController* weatherVC;
    
    BOOL useCoreLocationCoords;
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
    
}

#pragma mark - Event-Handling

- (IBAction)currentLocation:(id)sender
{
    NSLog(@"currentLocation");
}

#pragma mark - Textfield Handlng

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [activity startAnimating];
    
    DWNetworkCenter* network = [DWNetworkCenter sharedInstance];
    [network getWeatherForCity:textField.text completion:^(NSDictionary* dict) {
        [self->activity stopAnimating];
        
        self->dataContainer.hidden = NO;
        DWWeather* currentWeather = [[DWWeather alloc] initWithJSON:dict];
        self->weatherVC.currentWeather = currentWeather;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length > 0)
        [textField resignFirstResponder];
    return NO;
}

@end
