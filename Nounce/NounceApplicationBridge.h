//
//  NounceApplicationBridge.h
//  Nounce
//
//  Created by Chetan Surpur on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NCNotification.h"
#import "NounceDelegateProtocol.h"


@interface NounceApplicationBridge : NSObject {
	id<NounceDelegate> delegate;
}

@property (assign) id delegate;

+ (id)sharedBridge;

- (void) notify:(NCNotification *)notification;

@end
