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

#import <Adium/AISharedAdium.h>
#import <Adium/AIChat.h>
#import <Adium/AIContentMessage.h>
#import <Adium/AIListContact.h>

#import <Nounce/NCNotification.h>
#import <Nounce/NCNotificationManager.h>
#import <Nounce/NCEvent.h>

#import "NCAIChat.h"
#import "NCAIMessage.h"


@interface NounceAdiumPlugin : AIPlugin <AIChatObserver> {
	NSMutableDictionary *chats;
}

- (void) listen;

- (void) messageReceived:(NSNotification *)notification;
- (NSSet *)updateChat:(AIChat *)inChat keys:(NSSet *)inModifiedKeys silent:(BOOL)silent;
- (void) eventFromNotification:(NCEvent *)event;

- (NCAIChat *)getChatForAIChat:(AIChat *)givenChat;
- (NCAIMessage *)getMessageForContentMessage:(AIContentMessage *)contentMessage;

- (void) appendMessageToChat:(NCAIChat *)chat message:(NCAIMessage *)message;
- (void) updateAndSubmitNotification:(NCAIChat *)chat numUnviewedMessages:(int)numUnviewedMessages;

@end
