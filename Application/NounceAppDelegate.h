//
//  NounceAppDelegate.h
//  Nounce
//
//  Created by Chetan Surpur on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Nounce/NCNotification.h>
#import "NCNotificationCenter.h"
#import "NCViewController.h"

@interface NounceAppDelegate : NSObject <NSApplicationDelegate> {
	NCNotificationCenter *notificationCenter;
	NCViewController *viewController;
	
    NSWindow *window;
	IBOutlet NSArrayController *applicationViews;
}

@property (assign) IBOutlet NSWindow *window;

- (void) listen;
- (void) notify:(NCNotification *)notification;

@end
