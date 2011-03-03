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
	id *callbackObject;
	SEL callbackSelector;
}

@property (retain) NSString *ID;
@property (retain) NCApplication *fromApp;
@property (retain) NSString *title;
@property (retain) NSString *content;
@property (retain) NSString *input;
@property (assign) id *callbackObject;
@property SEL callbackSelector;

+ (NCNotification *) notificationWithTitle:(NSString *)title
								   content:(NSString *)content
									 input:(NSString *)input;

@end
