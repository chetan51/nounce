//
//  NounceAdiumPlugin.m
//  NounceAdiumPlugin
//
//  Created by Chetan Surpur on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NounceAdiumPlugin.h"


@implementation NounceAdiumPlugin

- (void)installPlugin
{
	chats = [[NSMutableDictionary alloc] init];
	
	[self listen];
}

- (void) listen
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageReceived:) name:CONTENT_MESSAGE_RECEIVED object:nil];	
	[adium.chatController registerChatObserver:self];
}

- (void)uninstallPlugin
{
    [chats release];
}

/* 
 * Event listeners
 */

- (void) messageReceived:(NSNotification *)notification
{
	AIChat *updatedChat = (AIChat *)[[notification userInfo] objectForKey:@"AIChat"];
	AIContentMessage *contentMessage = (AIContentMessage *)[[notification userInfo] objectForKey:@"AIContentObject"];
	
	NCAIMessage *message = [self getMessageForContentMessage:contentMessage];
	NCAIChat *chat = [self getChatForAIChat:updatedChat];
	[self appendMessageToChat:chat message:message];
}

- (NSSet *)updateChat:(AIChat *)inChat keys:(NSSet *)inModifiedKeys silent:(BOOL)silent
{	
	if ([inModifiedKeys containsObject:KEY_UNVIEWED_CONTENT]) {
		NCAIChat *chat = [self getChatForAIChat:inChat];
		[self updateAndSubmitNotification:chat numUnviewedMessages:[inChat unviewedContentCount]];
	}
	else if ([inModifiedKeys containsObject:KEY_TYPING]) {
		
	}
	
	return nil;
}

- (void) eventFromNotification:(NCEvent *)event
{
	if ([event type] == NCEVENT_INPUT_SUBMIT &&
		[[[event data] objectForKey:@"FormName"] isEqual:@"reply"] &&
		[[[event data] objectForKey:@"ButtonName"] isEqual:@"reply"])
	{
		NSDictionary *inputData = [[event data] objectForKey:@"InputData"];
		NSLog(@"%@", [inputData objectForKey:@"reply"]);
	}
}

/* 
 * Accessors
 */

- (NCAIChat *)getChatForAIChat:(AIChat *)givenChat
{
	NCAIChat *chat = [[[chats objectForKey:[givenChat uniqueChatID]] retain] autorelease];
	
	if (!chat) {
		chat = [[[NCAIChat alloc] init] autorelease];
		[chat setID:[givenChat uniqueChatID]];
		[chat setNewMessages:[[[NSMutableArray alloc] init] autorelease]];
		if ([givenChat name]) {
			[chat setName:[givenChat name]];
		}
		else {
			[chat setName:[NSString stringWithFormat:@"Chat with %@", [[givenChat listObject] ownDisplayName]]];
		}
	}
	
	return chat;
}

- (NCAIMessage *)getMessageForContentMessage:(AIContentMessage *)contentMessage
{
	AIListContact *senderContact = (AIListContact *)[contentMessage source];
	
	NCAIMessage *message = [[[NCAIMessage alloc] init] autorelease];
	[message setMessage:[contentMessage messageString]];
	[message setIsSenderSelf:NO];
	[message setSenderName:[senderContact ownDisplayName]];
	
	return message;
}

/* 
 * Functions
 */

- (void) appendMessageToChat:(NCAIChat *)chat message:(NCAIMessage *)message
{
	[[chat newMessages] addObject:message];
	[chats setObject:chat forKey:[chat ID]];
}

- (void) updateAndSubmitNotification:(NCAIChat *)chat numUnviewedMessages:(int)numUnviewedMessages
{
	// Create notification content with the new messages from this sender
	NSString *notificationContent = @"";
	NSString *format;
	
	NSEnumerator *messagesEnumerator = [[chat newMessages] reverseObjectEnumerator];
	NCAIMessage *message;
	int messageCount = 0;
	int messageCountOfNonSelfSenders = 0;
	
	while ((message = [messagesEnumerator nextObject]) && (messageCountOfNonSelfSenders < numUnviewedMessages)) {
		format = messageCount == 0 ? @"<b>%@</b>: %@" : @"<b>%@</b>: %@<br>";
		
		notificationContent = [[NSString stringWithFormat:format, [message senderName], [message message]]
							   stringByAppendingString:notificationContent];
		
		if (![message isSenderSelf]) {
			messageCountOfNonSelfSenders++;
		}
		messageCount++;
	}
	
	// Build notification for Nounce
	NCNotification *notification;
	
	if ([chat currentNotification]) {
		notification = [chat currentNotification];
		[notification setContent:notificationContent];
	}
	else {
		notification = [NCNotification
						notificationWithTitle:[chat name]
						content:notificationContent
						input:@"<form name='reply'>"
						"<input type='text' name='reply' value='message'>"
						"<input type='submit' name='reply' class='submit' value='Reply'>"
						"</form>"];
	}
	
	[notification setObserver:self selector:@selector(eventFromNotification:)];
	
	[chat setCurrentNotification:notification];
	
	// Send notification to Nounce
	[NCNotificationManager notify:notification];
}

@end
