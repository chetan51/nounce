//
//  NCNotificationCenter.h
//  Nounce
//
//  Created by Chetan Surpur on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Nounce/NCApplication.h>
#import <Nounce/NCNotification.h>


@interface NCNotificationCenter : NSObject {
	NSMutableDictionary *applications;
	NSMutableDictionary *notifications;
}

+ (NCNotificationCenter*)sharedNotificationCenter;

- (void) notify:(NCNotification *)notification;

- (NCNotification *) notificationWithID:(NSString *)notificationID;

- (void) submitFormForNotificationWithID:(NSString *)notificationID inputData:(NSDictionary *)inputData formName:(NSString *)formName buttonName:(NSString *)buttonName;

@end
