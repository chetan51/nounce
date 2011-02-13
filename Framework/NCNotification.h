//
//  NCNotification.h
//  Nounce
//
//  Created by Chetan Surpur on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <NCApplication.h>


@interface NCNotification : NSObject {
	NSNumber *ID;
	NCApplication *fromApp;
	NSString *title;
	NSString *textMessage;
}

@property (retain) NSNumber *ID;
@property (retain) NCApplication *fromApp;
@property (retain) NSString *title;
@property (retain) NSString *textMessage;

@end
