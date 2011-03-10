//
//  NounceAppDelegate.h
//  Nounce
//
//  Created by Chetan Surpur on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "NCEventController.h"
#import "NCNotificationController.h"
#import "NCNotificationPaneController.h"
#import "NCNotificationStatusController.h"

@interface NounceAppDelegate : NSObject <NSApplicationDelegate> {
	NCEventController *eventController;
	NCNotificationController *notificationController;
	NCNotificationPaneController *notificationPaneController;
	NCNotificationStatusController *notificationStatusController;
}

@property (retain) NCEventController *eventController;
@property (retain) NCNotificationController *notificationController;
@property (retain) NCNotificationPaneController *notificationPaneController;
@property (retain) NCNotificationStatusController *notificationStatusController;

@end
