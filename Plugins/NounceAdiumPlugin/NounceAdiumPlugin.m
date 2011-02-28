//
//  NounceAdiumPlugin.m
//  NounceAdiumPlugin
//
//  Created by Chetan Surpur on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NounceAdiumPlugin.h"
#import <Adium/AISharedAdium.h>
#import <Adium/AIChat.h>
#import <Adium/AIContentMessage.h>
#import <Adium/AIListContact.h>


@implementation NounceAdiumPlugin

- (void)installPlugin
{
	newMessages = [[NSMutableDictionary alloc] init];
	
	[self listen];
}

- (void) listen
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageReceived:) name:CONTENT_MESSAGE_RECEIVED object:nil];	
}

- (void) messageReceived:(NSNotification *)notification
{
	int numUnviewedMessages = [(AIChat *)[[notification userInfo] objectForKey:@"AIChat"] unviewedContentCount];
	AIContentMessage *contentMessage = (AIContentMessage *)[[notification userInfo] objectForKey:@"AIContentObject"];
	AIListContact *sender = (AIListContact *)[contentMessage source];
	
	if (numUnviewedMessages > 0) {
		NSMutableArray *messages;
		
		if ([newMessages objectForKey:[sender UID]]) {
			messages = [newMessages objectForKey:[sender UID]];
			[messages addObject:contentMessage];
		}
		else {
			messages = [NSMutableArray arrayWithObject:contentMessage];
			[newMessages setObject:messages forKey:[sender UID]];
		}
		
		NSString *notificationContent = @"";
		NSString *format;
		
		NSEnumerator *messagesEnumerator = [messages objectEnumerator];
		AIContentMessage *message;
		int count = 0;
		
		while (message = [messagesEnumerator nextObject]) {
			format = count == 0 ? @"<b>%@</b>: %@" : @"<br><b>%@</b>: %@";
			
			notificationContent = [notificationContent
								   stringByAppendingFormat:format,
								   [sender longDisplayName],
								   [message messageString]];
			
			count++;
		}
		
		NSLog(@"%@", notificationContent);
	}
}

- (void)uninstallPlugin
{
    [newMessages release];
}

@end
