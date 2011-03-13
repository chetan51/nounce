//
//  NounceAdiumPlugin.m
//  NounceAdiumPlugin
//
//  Created by Chetan Surpur on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NounceAdiumPlugin.h"
#import <Nounce/NounceApplicationBridge.h>


@implementation NounceAdiumPlugin

- (void)installPlugin
{
	chats									= [[NSMutableDictionary alloc] init];
	chatForNotificationManifest				= [[NSMutableDictionary alloc] init];
	
	[[NounceApplicationBridge sharedBridge] setDelegate:self];
	
	[self listen];
}

- (void)listen
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageReceived:) name:CONTENT_MESSAGE_RECEIVED object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageSent:) name:CONTENT_MESSAGE_SENT object:nil];
	
	[adium.chatController registerChatObserver:self];
}

- (void)uninstallPlugin
{
    [chats release];
	[chatForNotificationManifest release];
}

/* 
 * Event listeners
 */

- (void)messageReceived:(NSNotification *)notification
{
	AIChat *updatedChat = (AIChat *)[[notification userInfo] objectForKey:@"AIChat"];
	AIContentMessage *contentMessage = (AIContentMessage *)[[notification userInfo] objectForKey:@"AIContentObject"];
	
	NCAIMessage *message = [self getMessageForContentMessage:contentMessage sentByMe:NO];
	NCAIChat *chat = [self getChatForAIChat:updatedChat];
	
	[chat setAiSender:[contentMessage source]];
	[chat setAiMe:[contentMessage destination]];
	
	[chat incrementNotificationDisplayCount];
	[self appendMessageToChat:chat message:message];
}

- (void)messageSent:(NSNotification *)notification
{
	AIChat *updatedChat = (AIChat *)[[notification userInfo] objectForKey:@"AIChat"];
	AIContentMessage *contentMessage = (AIContentMessage *)[[notification userInfo] objectForKey:@"AIContentObject"];
	
	NCAIMessage *message = [self getMessageForContentMessage:contentMessage sentByMe:YES];
	NCAIChat *chat = [self getChatForAIChat:updatedChat];
	
	[chat setAiSender:[contentMessage destination]];
	[chat setAiMe:[contentMessage source]];
	
	[self appendMessageToChat:chat message:message];
	[self updateAndSubmitNotification:chat numUnviewedMessages:[[chat notificationDisplayCount] intValue]];
}

- (NSSet *)updateChat:(AIChat *)inChat keys:(NSSet *)inModifiedKeys silent:(BOOL)silent
{
	if ([inModifiedKeys containsObject:KEY_UNVIEWED_CONTENT]) {
		NCAIChat *chat = [self getChatForAIChat:inChat]; // TODO: Error handling if chat is nil
		[self updateAndSubmitNotification:chat numUnviewedMessages:[[chat notificationDisplayCount] intValue]];
	}
	else if ([inModifiedKeys containsObject:KEY_TYPING]) {
		
	}
	
	return nil;
}

- (void)inputWasSubmittedForNotification:(NCNotification *)notification formName:(NSString *)formName buttonName:(NSString *)buttonName inputData:(NSDictionary *)inputData
{
	NCAIChat *chat;
	if (chat = [self getChatForNotification:notification]) {
		[self sendMessage:[inputData objectForKey:@"reply"] forChat:chat];
		[chat setNotificationMarkedForHiding:TRUE];
	}
	
	[self updateAdiumAboutStatusForChat:chat];
}

- (void)notificationWasHidden:(NCNotification *)notification
{
	NCAIChat *chat = [self getChatForNotification:notification];
	
	[chat resetNotificationDisplayCount];
	[self updateAdiumAboutStatusForChat:chat];
}

- (void)notificationPaneWasHidden
{
	[self hideNotificationsForAllMarkedChats];
}

/* 
 * Accessors and Setters
 */

- (void)saveChat:(NCAIChat *)chat
{
	[chats setObject:chat forKey:[chat ID]];
}

- (void)saveNotificationForChat:(NCAIChat *)chat notification:(NCNotification *)notification
{
	[chat setCurrentNotification:notification];
	[chatForNotificationManifest setObject:[chat ID] forKey:[[chat currentNotification] ID]];
}

- (NCAIChat *)getChatWithID:(NSString *)chatID
{
	return [[[chats objectForKey:chatID] retain] autorelease];
}

- (NCAIChat *)getChatForAIChat:(AIChat *)givenChat
{
	NCAIChat *chat = [[[chats objectForKey:[givenChat uniqueChatID]] retain] autorelease];
	
	if (!chat) {
		chat = [[[NCAIChat alloc] init] autorelease];
		[chat setID:[givenChat uniqueChatID]];
		[chat setAiChat:givenChat];
		[chat setNewMessages:[[[NSMutableArray alloc] init] autorelease]];
		if ([givenChat name]) {
			[chat setName:[givenChat name]];
		}
		else {
			[chat setName:[NSString stringWithFormat:@"Chat with %@", [[givenChat listObject] displayName]]];
		}
	}
	
	return chat;
}

- (NCAIChat *)getChatForNotification:(NCNotification *)notification
{
	NSString *chatID;
	if (chatID = [chatForNotificationManifest objectForKey:[notification ID]]) {
		return [self getChatWithID:chatID];
	}
	else {
		return nil;
	}
}

- (NCAIMessage *)getMessageForContentMessage:(AIContentMessage *)contentMessage sentByMe:(BOOL)isSentByMe
{
	AIListContact *senderContact = (AIListContact *)[contentMessage source];
	
	NCAIMessage *message = [[[NCAIMessage alloc] init] autorelease];
	[message setMessage:[contentMessage messageString]];
	[message setIsSenderSelf:isSentByMe];
	[message setSenderName:[senderContact displayName]];
	
	return message;
}

/* 
 * Functions
 */

- (void)appendMessageToChat:(NCAIChat *)chat message:(NCAIMessage *)message
{
	[[chat newMessages] addObject:message];
	[self saveChat:chat];
}

- (void)sendMessage:(NSString *)message forChat:(NCAIChat *)chat
{
	NSAttributedString *attributedMessage = [[[NSAttributedString alloc] initWithString:message] autorelease];
	
	AIContentMessage *contentObject = [AIContentMessage messageInChat:[chat aiChat]
														   withSource:[chat aiMe]
														  destination:[chat aiSender]
																 date:[NSDate dateWithTimeIntervalSinceNow:0]
															  message:attributedMessage
															autoreply:[[[chat aiChat] account] supportsAutoReplies]];
	
	[adium.contentController sendContentObject:contentObject];
}

- (void)updateAndSubmitNotification:(NCAIChat *)chat numUnviewedMessages:(int)numUnviewedMessages
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
						"<input type='text' name='reply' style='width: 100%; box-sizing: border-box; -webkit-box-sizing: border-box;'>"
						"<input type='submit' name='reply' class='submit' value='Reply' style='position: absolute; left: -9999px'>"
						"</form>"];
	}
	
	[self saveChat:chat];
	[self saveNotificationForChat:chat notification:notification];
	
	if (messageCount) {	
		// Send notification to Nounce
		[[NounceApplicationBridge sharedBridge] notify:notification];
	}
	else {
		// Tell Nounce to hide the notification
		[[NounceApplicationBridge sharedBridge] hideNotification:notification];
	}
}

- (void)hideNotificationsForAllMarkedChats
{
	NSEnumerator *chatsEnumerator = [chats objectEnumerator];
	NCAIChat *chat;
	
	while (chat = [chatsEnumerator nextObject]) {
		if ([chat notificationMarkedForHiding]) {
			[chat resetNotificationDisplayCount];
			[chat setNotificationMarkedForHiding:FALSE];
			[self updateAndSubmitNotification:chat numUnviewedMessages:[[chat notificationDisplayCount] intValue]];
		}
	}
}

- (void)updateAndSubmitNotificationsForAllChats
{
	NSEnumerator *chatsEnumerator = [chats objectEnumerator];
	NCAIChat *chat;
	
	while (chat = [chatsEnumerator nextObject]) {
		[self updateAndSubmitNotification:chat numUnviewedMessages:[[chat notificationDisplayCount] intValue]];
	}
}

- (void)updateAdiumAboutStatusForChat:(NCAIChat *)chat
{
	// Tell Adium that we saw and responded to the chat
	[adium.interfaceController chatDidBecomeActive:[chat aiChat]];
	[adium.interfaceController chatDidBecomeActive:nil];	
}

@end
