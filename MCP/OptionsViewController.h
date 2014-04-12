//
//  OptionsViewController.h
//  MCP
//
//  Created by Bakers on 31/03/2014.
//  Copyright (c) 2014 Bakers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "MCPAppDelegate.h"

@interface OptionsViewController : UIViewController <MCBrowserViewControllerDelegate>

@property (strong, nonatomic) MCPAppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UITextField *txtPlayerName;
@property (weak, nonatomic) IBOutlet UISwitch *swVisible;
@property (weak, nonatomic) IBOutlet UITextView *tvPlayerList;

- (IBAction)disconnect:(id)sender;
- (IBAction)searchForPlayers:(id)sender;
- (IBAction)toggleVisibility:(id)sender;

@end