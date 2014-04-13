//
//  AlertViewController.h
//  disaster
//
//  Created by Ali Elouafiq on 4/13/14.
//  Copyright (c) 2014 bobox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>

// You have to put your API Key for Wundergound into this URL - PUT_YOUR_KEY_HERE
#define API_KEY_WUNDERGOUND @"http://api.wunderground.com/api/PUT_YOUR_KEY_HERE/conditions/forecast/q/%@,%@.json"

@interface AlertViewController : UIViewController
{
    int degrecf;
    // The today's temperature in big
    IBOutlet UILabel *todayTemp;
    
    // Used to have the users current co-ordinates.
    CLLocationManager *ucco;
    // Used to store the weather data downloaded from the JSON feed.
    NSMutableData *responseData;
    // Contains the current temperature in degrees celcius and fareheit.
    NSArray *tmpC;
    NSArray *tmpF;
    // Displays the weather forecast information in °C and °F.
    NSArray *forecast_report_c;
    NSArray *forecast_report_f;
    // Displays the relevant weather report for each day of the weather forecast.
    IBOutlet UILabel *forecast_d1_report;
    IBOutlet UILabel *forecast_d2_report;
    IBOutlet UILabel *forecast_d3_report;
    
    //the uibutton and the imageview to move the image
    IBOutlet UIImageView *d0imgweather;
    IBOutlet UIImageView *d1imgweather;
    IBOutlet UIImageView *d2imgweather;
    IBOutlet UIImageView *d3imgweather;
    IBOutlet UIImageView *d0img;
    IBOutlet UIImageView *d1img;
    IBOutlet UIImageView *d2img;
    IBOutlet UIImageView *d3img;
    IBOutlet UIButton *d0button;
    IBOutlet UIButton *d1button;
    IBOutlet UIButton *d2button;
    IBOutlet UIButton *d3button;
    
    // This string contains the users location (County or general area and country code).
    IBOutlet NSString *combined_loc;
    // Displays the users current location based on (Co-ordinates).
    IBOutlet UILabel *location_name;
    // The today's date (D/M/Y)
    NSArray *date_array;
    IBOutlet UILabel *todaydate;
    IBOutlet UILabel *todaydate_1;
    IBOutlet UILabel *todaydate_2;
    IBOutlet UILabel *todaydate_3;
    
}

-(IBAction)d0;
-(IBAction)d1;
-(IBAction)d2;
-(IBAction)d3;

@end
