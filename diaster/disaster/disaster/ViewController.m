//
//  ViewController.m
//  disaster
//
//  Created by Ali Elouafiq on 4/12/14.
//  Copyright (c) 2014 bobox. All rights reserved.
//


#import "ViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface ViewController ()<MCBrowserViewControllerDelegate, MCSessionDelegate, UITextFieldDelegate>

@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCSession *mySession;
@property (nonatomic, strong) MCPeerID *myPeerID;
//Subscribe
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) UIButton *subscribeButton;
//
@property (nonatomic, strong) UIButton *browserButton;
@property (nonatomic, strong) UITextView *textBox;
@property (nonatomic, strong) UITextField *chatBox;

@end



@implementation ViewController

// Main Frame Window to Chat
- (void) setUpUI{
    //Subscribe
    self.subscribeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.subscribeButton setTitle:@"Subscribe" forState:UIControlStateNormal];
    self.subscribeButton.frame = CGRectMake(130, 20, 80, 40);
    [self.view addSubview:self.subscribeButton];
    
    //  Setup the browse button
    self.browserButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.browserButton setTitle:@"Browse" forState:UIControlStateNormal];
    self.browserButton.frame = CGRectMake(40, 20,60, 30);
    [self.view addSubview:self.browserButton];

    //  Setup TextBox
    self.textBox = [[UITextView alloc] initWithFrame: CGRectMake(40, 150, 240, 270)];
    self.textBox.editable = NO;
    self.textBox.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview: self.textBox];
    
    //  Setup ChatBox
    self.chatBox = [[UITextField alloc] initWithFrame: CGRectMake(40, 60, 240, 70)];
    self.chatBox.backgroundColor = [UIColor lightGrayColor];
    self.chatBox.returnKeyType = UIReturnKeySend;
    [self.view addSubview:self.chatBox];
    
    [self.browserButton addTarget:self action:@selector(showBrowserVC) forControlEvents:UIControlEventTouchUpInside];
    [self.subscribeButton addTarget:self action:@selector(showAlert) forControlEvents:UIControlEventTouchUpInside];
    
    self.chatBox.delegate = self;
    
}

//Setting up multiple IDs
- (void) setUpMultipeer{
    //  Setup peer ID
    self.myPeerID = [[MCPeerID alloc] initWithDisplayName:@"samaka"];
    
    //  Setup session
    self.mySession = [[MCSession alloc] initWithPeer:self.myPeerID];
    
    //  Setup BrowserViewController
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"chat" session:self.mySession];
    
    //  Setup Advertiser
    self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"chat" discoveryInfo:nil session:self.mySession];
    [self.advertiser start];
    self.browserVC.delegate = self;
    self.mySession.delegate = self;
    
}
- (void) getNotification{
    // URL String
    //
    //NSURLRequest  *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://bit.ly/data_JSON"]];
    //NSURLResponse * response = nil;
    //NSError * error = nil;
    
    // NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
    //                                       returningResponse:&response
    //                                                   error:&error];
    
    //NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    //if (error)
    //NSLog(@"JSONObjectWithData error: %@", error);
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"sunnh",@"type",@"atay",@"an earth Quack zilzaal", nil];
    //for (NSMutableDictionary *dictionary in array)
    //{
    self.type = dictionary[@"type"];
    self.message= dictionary[@"message"];
    
    //}
}
- (void)showAlert{
    //NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"sunnh",@"type",@"n earth Quack zilzaal",@"message", nil];
    //self.type = dictionary[@"type"];
    //self.message= dictionary[@"message"];
    
    NSURLRequest  *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://pastebin.com/raw.php?i=6J7SPVcM"]];
    NSURLResponse * response;
    NSError * error = nil;
    
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                           returningResponse:&response
                                                       error:nil];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    self.type = dictionary[@"type"];
    self.message= dictionary[@"message"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.type
                                                    message:self.message
                                                   delegate:nil
                                          cancelButtonTitle:@"GOOD LUCK"
                                          otherButtonTitles:nil];
        [alert show];
        return;
}
// Action setting BrowserVC
- (void) showBrowserVC{
    [self presentViewController:self.browserVC animated:YES completion:nil];
}
//************* COMMUNICATION MANAGEMENT **********
- (void) sendText{
    //  Retrieve text from chat box and clear chat box
    NSString *message = self.chatBox.text;
    self.chatBox.text = @"";
    
    //  Convert text to NSData
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    //  Send data to connected peers
    NSError *error;
    [self.mySession sendData:data toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataUnreliable error:&error];
    
    //  Append your own text to text box
    [self receiveMessage: message fromPeer: self.myPeerID];
}

- (void) receiveMessage: (NSString *) message fromPeer: (MCPeerID *) peer{
    //  Create the final text to append
    NSString *finalText;
    if (peer == self.myPeerID) {
        finalText = [NSString stringWithFormat:@"\nme: %@\n", message];
    }
    else{
        finalText = [NSString stringWithFormat:@"\n%@: %@\n", peer.displayName, message];
    }
    
    //  Append text to text box
    self.textBox.text = [self.textBox.text stringByAppendingString:finalText];
}
//*************************************************

//############# PROTOCOL IMPLEMENTATION #######

#pragma marks MCSessionDelegate
// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    //  Decode data back to NSString
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //  append message to text box on main thread
    dispatch_async(dispatch_get_main_queue(),^{
        [self receiveMessage: message fromPeer: peerID];
    });
}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    
}

//#############################################

// Consistency
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setUpUI];
    [self setUpMultipeer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) dismissBrowserVC{
    [self.browserVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma marks MCBrowserViewControllerDelegate
// Notifies the delegate, when the user taps the done button
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [self dismissBrowserVC];
}
#pragma marks UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self sendText];
    return YES;
}
// Notifies delegate that the user taps the cancel button.
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [self dismissBrowserVC];
}

@end
