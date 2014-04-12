//
//  MCPAppDelegate.h
//  MCP
//
//  Created by Bakers on 31/03/2014.
//  Copyright (c) 2014 Bakers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCPHandler.h"

@interface MCPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) MCPHandler *mpcHandler;

@end
