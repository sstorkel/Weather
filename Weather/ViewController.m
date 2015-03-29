//
//  ViewController.m
//  Weather
//
//  Created by Scott Storkel on 3/28/15.
//  Copyright (c) 2015 Scott Storkel. All rights reserved.
//

#import "ViewController.h"
#import "DWNetworkCenter.h"
#import "DWWeather.h"
#import <CoreLocation/CoreLocation.h>


@interface ViewController ()
{
    IBOutlet UITextField* locationField;
    IBOutlet UIActivityIndicatorView* activity;
    IBOutlet UITableView* tableView;
    
    BOOL useCoreLocationCoords;
}
@end



@implementation ViewController

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

#pragma mark - Event-Handling

- (IBAction)currentLocation:(id)sender
{
    NSLog(@"currentLocation");
}

#pragma mark - Textfield Handlng

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"Done!");
    [activity startAnimating];
    
    DWNetworkCenter* network = [DWNetworkCenter sharedInstance];
    [network getWeatherForCity:textField.text completion:^(NSDictionary* dict) {
        [self->activity stopAnimating];
        
        NSLog(@"%@", dict);
        DWWeather* currentWeather = [[DWWeather alloc] initWithJSON:dict];
    }];
}

//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    NSLog(@"editing");
//    return (textField.text.length > 0);
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"return");
    if (textField.text.length > 0)
        [textField resignFirstResponder];
    return NO;
}

@end
