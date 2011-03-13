//
//  NCAIChat.m
//  NounceAdiumPlugin
//
//  Created by Chetan Surpur on 2/28/11.
//  Copyright 2011 Chetan Surpur. All rights reserved.
//

#import "NCAIChat.h"


@implementation NCAIChat

@synthesize ID;
@synthesize aiChat;
@synthesize aiSender;
@synthesize aiMe;
@synthesize name;
@synthesize newMessages;
@synthesize currentNotification;
@synthesize notificationDisplayCount;
@synthesize notificationMarkedForHiding;

#pragma mark Initializers and destructors

- (id)init
{
	if (self = [super init]) {
		[self resetNotificationDisplayCount];
		[self setNotificationMarkedForHiding:FALSE];
	}
	
	return self;
}

#pragma mark Accessors and setters

- (void)incrementNotificationDisplayCount
{
	NSNumber *previousCount = [self notificationDisplayCount];
	[self setNotificationDisplayCount:[NSNumber numberWithInt:([previousCount intValue]+1)]];
}

- (void)resetNotificationDisplayCount
{
	[self setNotificationDisplayCount:[NSNumber numberWithInt:0]];
}

@end
