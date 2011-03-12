//
//  NCAISender.h
//  NounceAdiumPlugin
//
//  Created by Chetan Surpur on 2/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Nounce/NCNotification.h>

#import <Adium/AIPlugin.h>
#import <Adium/AIChat.h>
#import <Adium/AIListContact.h>


@interface NCAIChat : NSObject {
	NSString *ID;
	AIChat *aiChat;
	AIListObject *aiSender;
	AIListObject *aiMe;
	NSString *name;
	NSMutableArray *newMessages;
	NCNotification *currentNotification;
	NSNumber *notificationDisplayCount;
	BOOL notificationMarkedForHiding;
}

@property (copy) NSString *ID;
@property (retain) AIChat *aiChat;
@property (retain) AIListObject *aiSender;
@property (retain) AIListObject *aiMe;
@property (copy) NSString *name;
@property (retain) NSMutableArray *newMessages;
@property (retain) NCNotification *currentNotification;
@property (retain) NSNumber *notificationDisplayCount;
@property (assign) BOOL notificationMarkedForHiding;

- (void)incrementNotificationDisplayCount;
- (void)resetNotificationDisplayCount;

@end
