//
//  WeatherDataViewController.m
//  Weather
//
//  Created by Scott Storkel on 3/29/15.
//  Copyright (c) 2015 Scott Storkel. All rights reserved.
//

#import "WeatherDataViewController.h"
#import "DWWeather.h"



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
}


 - (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.rowHeight = 44;
}


/*
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/

#pragma mark - Table view data source

/*
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}
*/

/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
*/

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
