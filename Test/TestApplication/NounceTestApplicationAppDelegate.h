//
//  NounceTestApplicationAppDelegate.h
//  NounceTestApplication
//
//  Created by Chetan Surpur on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Nounce/NCEvent.h>

@interface NounceTestApplicationAppDelegate : NSObject <NSApplicationDelegate> {
	
}

- (void) firstNotificationEvent:(NCEvent *)event;

@end
