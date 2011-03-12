//
//  NounceAdiumPlugin.h
//  NounceAdiumPlugin
//
//  Created by Chetan Surpur on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <Adium/AIPlugin.h>
#import <Adium/AIChatControllerProtocol.h>
#import <Adium/AIContentControllerProtocol.h>

#import <Adium/AISharedAdium.h>
#import <Adium/AIChat.h>
#import <Adium/AIContentMessage.h>
#import <Adium/AIListContact.h>

#import <Nounce/NCNotification.h>
#import <Nounce/NounceDelegateProtocol.h>

#import "NCAIChat.h"
#import "NCAIMessage.h"


@interface NounceAdiumPlugin : AIPlugin <AIChatObserver, NounceDelegate> {
	NSMutableDictionary *chats;
	NSMutableDictionary *chatForNotificationManifest;
}

- (void) listen;

- (void) messageReceived:(NSNotification *)notification;
- (void) messageSent:(NSNotification *)notification;
- (NSSet *)updateChat:(AIChat *)inChat keys:(NSSet *)inModifiedKeys silent:(BOOL)silent;
- (void)inputWasSubmittedForNotification:(NCNotification *)notification formName:(NSString *)formName buttonName:(NSString *)buttonName inputData:(NSDictionary *)inputData;

- (void) saveChat:(NCAIChat *)chat;
- (void) saveNotificationForChat:(NCAIChat *)chat notification:(NCNotification *)notification;
- (NCAIChat *)getChatWithID:(NSString *)chatID;
- (NCAIChat *)getChatForAIChat:(AIChat *)givenChat;
- (NCAIChat *)getChatForNotification:(NCNotification *)notification;
- (NCAIMessage *)getMessageForContentMessage:(AIContentMessage *)contentMessage sentByMe:(BOOL)isSentByMe;

- (void) appendMessageToChat:(NCAIChat *)chat message:(NCAIMessage *)message;
- (void) sendMessage:(NSString *)message forChat:(NCAIChat *)chat;
- (void) updateAndSubmitNotification:(NCAIChat *)chat numUnviewedMessages:(int)numUnviewedMessages;

@end
