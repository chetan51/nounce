//
//  NCNotificationController.h
//  Nounce
//
//  Created by Chetan Surpur on 3/10/11.
//  Copyright 2011 Chetan Surpur. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Nounce/NCNotification.h>


@interface NCNotificationController : NSObject {
	NSMutableDictionary *notifications;
}

@property (retain) NSMutableDictionary *notifications;

- (NCNotification *)notificationWithID:(NSString *)ID;
- (void)setNotification:(NCNotification *)notification;

@end
