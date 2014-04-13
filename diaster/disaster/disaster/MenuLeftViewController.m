//
//  MenuLeftViewController.m
//  MonCoco-Weather
//
//  Created by paul favier on 22/10/13.
//  Copyright (c) 2013 MonCocoPilote. All rights reserved.
//

#import "MenuLeftViewController.h"
#import "IIViewDeckController.h"
#import "AppDelegate.h"

@interface MenuLeftViewController ()

@end

@implementation MenuLeftViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)degreC
{
    [self postNotificationWithString:@"Portrait"];
    [self.viewDeckController closeOpenView];
    
}

-(IBAction)degreF
{
    [self postNotificationWithString:@"NoPortrait"];
    [self.viewDeckController closeOpenView];
    
}

- (void)postNotificationWithString:(NSString *)orientation //post notification method and logic
{
    /*--
     * Prefixing a notification name with a unique identifier,
     such as 'MT' for MobileTuts, reduces the chances of a message name conflict.
     * Be sure to use a unique and description name for the dictionary's key.
     --*/
    
    NSString *notificationName = @"MTPostNotificationTut";
    NSString *key = @"OrientationStringValue";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:orientation forKey:key];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:dictionary];
}

@end
