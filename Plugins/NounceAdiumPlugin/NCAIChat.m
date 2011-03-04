//
//  NCAIChat.m
//  NounceAdiumPlugin
//
//  Created by Chetan Surpur on 2/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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

- (void) dealloc
{
	[self setAiChat:nil];
	[self setAiSender:nil];
	[self setAiMe:nil];
	[self setName:nil];
	[self setNewMessages:nil];
	[self setCurrentNotification:nil];
	[super dealloc];
}

@end
