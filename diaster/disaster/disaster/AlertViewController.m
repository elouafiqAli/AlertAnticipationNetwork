//
//  AlertViewController.m
//  disaster
//
//  Created by Ali Elouafiq on 4/13/14.
//  Copyright (c) 2014 bobox. All rights reserved.
//

#import "AlertViewController.h"
#import "FFCircularProgressView.h"
#import "AppDelegate.h"
#import "IIViewDeckController.h"

@interface AlertViewController ()
@property (strong) FFCircularProgressView *circularPV;
@end

@implementation AlertViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.circularPV = [[FFCircularProgressView alloc] initWithFrame:CGRectMake(240, 50, 50, 50)];
        degrecf =1;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //You are going to find the current date ! BEGIN
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"EEEE"];
    NSDate *now = [[NSDate alloc] init];
    NSString *week = [dateFormatter stringFromDate:now];
    [todaydate setText:week];
    // END
    
    
    // Users now Co-ordinates properties - BEGIN
    ucco = [[CLLocationManager alloc]init];
    if ([CLLocationManager locationServicesEnabled])
    {
        ucco.delegate = self;
        ucco.desiredAccuracy = kCLLocationAccuracyBest;
        ucco.distanceFilter = 1000.0f;
        [ucco startUpdatingLocation];
    }
    // END
    
    
    
}

-(void)locationManager: (CLLocationManager *) manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // This method (function) will obtain the users co-ordinates and then display them in the info section labels
    // as well as using them passing them to the Wunderground JSON URL which will in turn, return the weather
    // information for the users location.
    
    NSString *lat = [[NSString alloc] initWithFormat:@"%g", newLocation.coordinate.latitude];
    
    NSString *lng = [[NSString alloc] initWithFormat:@"%g", newLocation.coordinate.longitude];
    
    // Fetches the JSON feed from Wundergound website.
    NSLog(@"test");
    NSString *urlString = [NSString stringWithFormat:API_KEY_WUNDERGOUND, lat, lng];
    NSLog(@"%@",urlString);
    NSURLRequest *theRequest = [NSURLRequest requestWithURL: [NSURL URLWithString:urlString]];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(theConnection){
        responseData = [[NSMutableData alloc] init];
    }
    
    else {
        NSLog(@"failed");
    }
}

#pragma mark - Delegates for Weather Data

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    [responseData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"Failed: %@", [error description]];
    NSLog(@"%@", msg);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // For more information about what items such as "wind_string" and "local_tz_offset" return, have a look
    // at the JSON feed example provided with this Xcode project.
    
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&myError];
    NSArray *results = [res objectForKey:@"current_observation"];
    NSString *loc = [[results valueForKey:@"display_location"] valueForKey:@"city"];
    NSString *todaysimage = [results valueForKey:@"icon"];
    
    // Weather forecast information is in a different part of the JSON feed. We need to access
    // the "forecast" section before we can download the forecast information.
    NSArray *results_two = [res objectForKey:@"forecast"];
    NSArray *forecast_images = [[[results_two valueForKey:@"txt_forecast"] valueForKey:@"forecastday"] valueForKey:@"icon"];
    // Download the weather forecast information information in °C and °F.
    forecast_report_c = [[[[results_two valueForKey:@"simpleforecast"] valueForKey:@"forecastday"] valueForKey:@"high"]valueForKey:@"celsius"];
    
    
    
    forecast_report_f = [[[[results_two valueForKey:@"simpleforecast"] valueForKey:@"forecastday"] valueForKey:@"high"]valueForKey:@"fahrenheit"];
    d0imgweather.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", todaysimage]];
    // Sets the images for the weather forecast section.
    d1imgweather.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", forecast_images[0]]];
    d2imgweather.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", forecast_images[1]]];
    d3imgweather.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", forecast_images[2]]];
    
    
    
    
    // Downdload the current temprature in °C anf °F.
    tmpC = [results valueForKey:@"temp_c"];
    tmpF = [results valueForKey:@"temp_f"];
    NSString *tmplabel = [tmpC description];
    
    
    // Displays the current temprature in °C anf °F on the stats page.
    todayTemp.text = [NSString stringWithFormat: @"%.f°", [tmplabel doubleValue]];
    
    forecast_d1_report.text = [NSString stringWithFormat: @"%.@°",[forecast_report_c[0] description]];
    forecast_d2_report.text = [NSString stringWithFormat: @"%.@°",[forecast_report_c[1] description]];
    forecast_d3_report.text = [NSString stringWithFormat: @"%.@°",[forecast_report_c[2] description]];
    date_array = [[[[results_two valueForKey:@"simpleforecast"] valueForKey:@"forecastday"] valueForKey:@"date"]valueForKey:@"weekday"];
    todaydate_1.text = [NSString stringWithFormat: @"%.@",[date_array[1] description]];
    todaydate_2.text = [NSString stringWithFormat: @"%.@",[date_array[2] description]];
    todaydate_3.text = [NSString stringWithFormat: @"%.@",[date_array[3] description]];
    
    
    // I am combining the location code (Eg: UK, USA, IR, etc..) with the location name.
    combined_loc = [NSString stringWithFormat: @"%@", loc];
    location_name.text = [combined_loc description];
    
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
}


-(IBAction)d0
{
    
    [UIView beginAnimations:@"ResizeAnimation" context:NULL];
    [UIView setAnimationDuration:0.7f];
    
    d0img.frame = CGRectMake(20, 44, 280, 284);
    d0button.frame = CGRectMake(20, 44, 280, 284);
    d1img.frame = CGRectMake(20, 345, 280, 56);
    d1button.frame = CGRectMake(20, 345, 280, 56);
    d2img.frame = CGRectMake(20, 417, 280, 56);
    d2button.frame = CGRectMake(20, 417, 280, 56);
    d3img.frame = CGRectMake(20, 490, 280, 56);
    d3button.frame = CGRectMake(20, 490, 280, 56);
    d0imgweather.frame = CGRectMake(85, 155, 150, 150);
    d1imgweather.frame = CGRectMake(250, 353, 40, 40);
    d2imgweather.frame = CGRectMake(250, 425, 40, 40);
    d3imgweather.frame = CGRectMake(250, 501, 40, 40);
    todayTemp.frame = CGRectMake(49, 57, 121, 96);
    todayTemp.font = [UIFont systemFontOfSize:80];
    forecast_d1_report.frame = CGRectMake(28, 358, 55, 36);
    forecast_d1_report.font = [UIFont systemFontOfSize:30];
    forecast_d2_report.frame = CGRectMake(28, 430, 55, 36);
    forecast_d2_report.font = [UIFont systemFontOfSize:30];
    forecast_d3_report.frame = CGRectMake(28, 503, 55, 36);
    forecast_d3_report.font = [UIFont systemFontOfSize:30];
    // location_name.frame = CGRectMake(176, 45, 114, 21);
    todaydate.frame = CGRectMake(45, 135, 114, 21);
    todaydate_1.frame = CGRectMake(103,364, 114, 21);
    todaydate_2.frame = CGRectMake(103,437, 114, 21);
    todaydate_3.frame = CGRectMake(103,507, 114, 21);
    [UIView commitAnimations];
    
    
}

-(IBAction)d1
{
    
    
    [UIView beginAnimations:@"ResizeAnimation" context:NULL];
    [UIView setAnimationDuration:0.7f];
    
    d0img.frame = CGRectMake(20, 44, 280, 56);
    d0button.frame = CGRectMake(20, 44, 280, 56);
    d1img.frame = CGRectMake(20, 117, 280, 284);
    d1button.frame = CGRectMake(20, 117, 280, 284);
    d2img.frame = CGRectMake(20, 417, 280, 56);
    d2button.frame = CGRectMake(20, 417, 280, 56);
    d3img.frame = CGRectMake(20, 490, 280, 56);
    d3button.frame = CGRectMake(20, 490, 280, 56);
    d0imgweather.frame = CGRectMake(250, 48, 40, 40);
    d1imgweather.frame = CGRectMake(85, 230, 150, 150);
    d2imgweather.frame = CGRectMake(250, 425, 40, 40);
    d3imgweather.frame = CGRectMake(250, 501, 40, 40);
    todayTemp.frame = CGRectMake(28, 54, 55, 36);
    todayTemp.font = [UIFont systemFontOfSize:30];
    forecast_d1_report.frame = CGRectMake(49, 127, 121, 96);
    forecast_d1_report.font = [UIFont systemFontOfSize:80];
    forecast_d2_report.frame = CGRectMake(28, 430, 55, 36);
    forecast_d2_report.font = [UIFont systemFontOfSize:30];
    forecast_d3_report.frame = CGRectMake(28, 503, 55, 36);
    forecast_d3_report.font = [UIFont systemFontOfSize:30];
    // location_name.frame = CGRectMake(100, 50, 114, 21);
    todaydate.frame = CGRectMake(100,63, 114, 21);
    todaydate_1.frame = CGRectMake(45,210, 114, 21);
    todaydate_2.frame = CGRectMake(103,437, 114, 21);
    todaydate_3.frame = CGRectMake(103,507, 114, 21);
    [UIView commitAnimations];
    
    
}

-(IBAction)d2
{
    
    [UIView beginAnimations:@"ResizeAnimation" context:NULL];
    [UIView setAnimationDuration:0.7f];
    
    d0img.frame = CGRectMake(20, 44, 280, 56);
    d0button.frame = CGRectMake(20, 44, 280, 56);
    d1img.frame = CGRectMake(20, 117, 280, 56);
    d1button.frame = CGRectMake(20, 117, 280, 56);
    d2img.frame = CGRectMake(20, 189, 280, 284);
    d2button.frame = CGRectMake(20, 189, 280, 284);
    d3img.frame = CGRectMake(20, 490, 280, 56);
    d3button.frame = CGRectMake(20, 490, 280, 56);
    d0imgweather.frame = CGRectMake(250, 48, 40, 40);
    d1imgweather.frame = CGRectMake(250, 122, 40, 40);
    d2imgweather.frame = CGRectMake(85, 310, 150, 150);
    d3imgweather.frame = CGRectMake(250, 501, 40, 40);
    todayTemp.frame = CGRectMake(28, 54, 55, 36);
    todayTemp.font = [UIFont systemFontOfSize:30];
    forecast_d1_report.frame = CGRectMake(28, 127, 55, 36);
    forecast_d1_report.font = [UIFont systemFontOfSize:30];
    forecast_d2_report.frame = CGRectMake(49, 199, 121, 96);
    forecast_d2_report.font = [UIFont systemFontOfSize:80];
    forecast_d3_report.frame = CGRectMake(28, 503, 55, 36);
    forecast_d3_report.font = [UIFont systemFontOfSize:30];
    // location_name.frame = CGRectMake(100, 50, 114, 21);
    todaydate.frame = CGRectMake(100,63, 114, 21);
    todaydate_1.frame = CGRectMake(103,135, 114, 21);
    todaydate_2.frame = CGRectMake(45,280, 114, 21);
    todaydate_3.frame = CGRectMake(103,507, 114, 21);
    [UIView commitAnimations];
    
    
}

-(IBAction)d3
{
    [UIView beginAnimations:@"ResizeAnimation" context:NULL];
    [UIView setAnimationDuration:0.7f];
    
    d0img.frame = CGRectMake(20, 44, 280, 56);
    d0button.frame = CGRectMake(20, 44, 280, 56);
    d1img.frame = CGRectMake(20, 117, 280, 56);
    d1button.frame = CGRectMake(20, 117, 280, 56);
    d2img.frame = CGRectMake(20, 189, 280, 56);
    d2button.frame = CGRectMake(20, 189, 280, 56);
    d3img.frame = CGRectMake(20, 262, 280, 284);
    d3button.frame = CGRectMake(20, 279, 280, 284);
    d0imgweather.frame = CGRectMake(250, 48, 40, 40);
    d1imgweather.frame = CGRectMake(250, 122, 40, 40);
    d2imgweather.frame = CGRectMake(250, 202, 40, 40);
    d3imgweather.frame = CGRectMake(85, 390, 150, 150);
    todayTemp.frame = CGRectMake(28, 54, 55, 36);
    todayTemp.font = [UIFont systemFontOfSize:30];
    forecast_d1_report.frame = CGRectMake(28, 127, 55, 36);
    forecast_d1_report.font = [UIFont systemFontOfSize:30];
    forecast_d2_report.frame = CGRectMake(28, 199, 55, 36);
    forecast_d2_report.font = [UIFont systemFontOfSize:30];
    forecast_d3_report.frame = CGRectMake(49, 275, 121, 96);
    forecast_d3_report.font = [UIFont systemFontOfSize:80];
    // location_name.frame = CGRectMake(100, 50, 114, 21);
    todaydate.frame = CGRectMake(100,63, 114, 21);
    todaydate_1.frame = CGRectMake(103,135, 114, 21);
    todaydate_2.frame = CGRectMake(103,205, 114, 21);
    todaydate_3.frame = CGRectMake(45,360, 114, 21);
    [UIView commitAnimations];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

