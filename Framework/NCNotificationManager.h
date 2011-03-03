//
//  NCNotificationManager.h
//  Nounce
//
//  Created by Chetan Surpur on 2/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NCNotification.h"

@interface NCNotificationManager : NSObject {
	
}

static NSMutableDictionary *notifications;

+ (NCNotification *) notificationWithID:(NSString *)notificationID;
+ (void) setNotification:(NCNotification *)notification forID:(NSString *)ID;

+ (void) listen;

+ (void) notify:(NCNotification *)notification;

@end
