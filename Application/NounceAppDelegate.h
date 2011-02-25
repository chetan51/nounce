//
//  NounceAppDelegate.h
//  Nounce
//
//  Created by Chetan Surpur on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <Nounce/NCNotification.h>
#import "NCNotificationCenter.h"

@interface NounceAppDelegate : NSObject <NSApplicationDelegate> {
	NCNotificationCenter *notificationCenter;
	
    NSWindow *notificationWindow;
	IBOutlet WebView *notificationPane;
	
    NSStatusItem *statusItem;
	IBOutlet WebView *notificationStatus;
}

@property (assign) IBOutlet NSWindow *notificationWindow;

- (void) setupNotificationWindow;
- (void) setupNotificationPane;
- (void) setupNotificationStatus;

- (void) listen;
- (void) notify:(NCNotification *)notification;

- (void) NPNotify:(NCNotification *)notification;

- (void)NPLog:(NSString *)message;

@end
