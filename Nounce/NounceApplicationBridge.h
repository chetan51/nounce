//
//  NounceApplicationBridge.h
//  Nounce
//
//  Created by Chetan Surpur on 3/7/11.
//  Copyright 2011 Chetan Surpur. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NCNotification.h"
#import "NounceDelegateProtocol.h"


@interface NounceApplicationBridge : NSObject {
	id<NounceDelegate> delegate;
	
	NSMutableDictionary *notifications;
}

@property (assign) id delegate;

+ (id)sharedBridge;

- (NCNotification *)notificationWithID:(NSString *)notificationID;

- (void) notify:(NCNotification *)notification;
- (void)hideNotification:(NCNotification *)notification;

@end
