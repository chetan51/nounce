//
//  NounceAdiumPlugin.m
//  NounceAdiumPlugin
//
//  Created by Chetan Surpur on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NounceAdiumPlugin.h"
#import "NCAISender.h"

#import <Nounce/NCNotification.h>
#import <Nounce/NCNotificationManager.h>

#import <Adium/AISharedAdium.h>
#import <Adium/AIChat.h>
#import <Adium/AIContentMessage.h>
#import <Adium/AIListContact.h>


@implementation NounceAdiumPlugin

- (void)installPlugin
{
	senders = [[NSMutableDictionary alloc] init];
	
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
	AIListContact *senderContact = (AIListContact *)[contentMessage source];
	
	if (numUnviewedMessages > 0) {
		// Get / create sender
		NCAISender *sender;
		
		if ([senders objectForKey:[senderContact UID]]) {
			sender = [senders objectForKey:[senderContact UID]];
		}
		else {
			sender = [[[NCAISender alloc] init] autorelease];
			[sender setNewMessages:[[NSMutableArray alloc] init]];
		}
		
		[[sender newMessages] addObject:contentMessage];
		[senders setObject:sender forKey:[senderContact UID]];

		// Create notification content with the new messages from this sender
		NSString *notificationContent = @"";
		NSString *format;
		
		NSEnumerator *messagesEnumerator = [[sender newMessages] objectEnumerator];
		AIContentMessage *message;
		int count = 0;
		
		while (message = [messagesEnumerator nextObject]) {
			format = count == 0 ? @"<b>%@</b>: %@" : @"<br><b>%@</b>: %@";
			
			notificationContent = [notificationContent
								   stringByAppendingFormat:format,
								   [senderContact longDisplayName],
								   [message messageString]];
			
			count++;
		}
		
		// Build notification for Nounce
		NCNotification *notification;
		
		if ([sender currentNotification]) {
			notification = [sender currentNotification];
			[notification setContent:notificationContent];
		}
		else {
			notification = [NCNotification
							notificationWithTitle:[NSString stringWithFormat:@"Instant Message From %@", [senderContact longDisplayName]]
							content:notificationContent
							input:@"<form>"
							"<input type='text' name='reply' value='message'>"
							"<input type='submit' name='reply' class='submit' value='Reply'>"
							"</form>"];
		}
		
		[sender setCurrentNotification:notification];
		
		// Send notification to Nounce
		[NCNotificationManager notify:notification];
	}
}

- (void)uninstallPlugin
{
    [senders release];
}

@end
