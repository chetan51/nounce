//
//  NounceTestApplicationAppDelegate.h
//  NounceTestApplication
//
//  Created by Chetan Surpur on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Nounce/NCNotification.h>
#import <Nounce/NCEvent.h>
#import <Nounce/NCNotificationManager.h>

@interface NounceTestApplicationAppDelegate : NSObject <NSApplicationDelegate> {
	
}

- (void) firstNotificationEvent:(NCEvent *)event forNotification:(NCNotification *)notification;

@end
