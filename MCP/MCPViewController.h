//
//  MCPViewController.h
//  MCP
//
//  Created by Bakers on 31/03/2014.
//  Copyright (c) 2014 Bakers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCPViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtGuess;
@property (weak, nonatomic) IBOutlet UITextView *tvHistory;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

- (IBAction)startGame:(id)sender;
- (IBAction)sendGuess:(id)sender;
- (IBAction)cancelGuessing:(id)sender;

@end
