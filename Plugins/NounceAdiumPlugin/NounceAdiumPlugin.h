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


@interface NounceAdiumPlugin : AIPlugin <AIChatObserver> {
	NSMutableDictionary *chats;
}

- (void) listen;

@end
