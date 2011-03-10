//
//  NCNotificationPaneController.h
//  Nounce
//
//  Created by Chetan Surpur on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>


@interface NCNotificationPaneController : NSWindowController {
    IBOutlet NSWindow *notificationWindow;
	IBOutlet WebView *notificationPane;
}

@property (assign) NSWindow *notificationWindow;

- (void) setupNotificationWindow;
- (void) setupNotificationPane;

- (void)showNotificationPane;
- (void)hideNotificationPane;

@end
