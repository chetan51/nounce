//
//  NCNotification.h
//  Nounce
//
//  Created by Chetan Surpur on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NCApplication.h"


@interface NCNotification : NSObject {
	NSString *ID;
	NCApplication *fromApp;
	NSString *title;
	NSString *content;
	NSString *input;
	NSObject *callbackObject;
	SEL callbackSelector;
}

@property (copy) NSString *ID;
@property (retain) NCApplication *fromApp;
@property (copy) NSString *title;
@property (copy) NSString *content;
@property (copy) NSString *input;
@property (assign) NSObject *callbackObject;
@property SEL callbackSelector;

+ (NCNotification *) notificationWithTitle:(NSString *)title
								   content:(NSString *)content
									 input:(NSString *)input;

- (void) setObserver:(NSObject *)object selector:(SEL)selector;

@end
