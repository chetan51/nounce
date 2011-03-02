//
//  NCAISender.h
//  NounceAdiumPlugin
//
//  Created by Chetan Surpur on 2/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Nounce/NCNotification.h>


@interface NCAIChat : NSObject {
	NSString *ID;
	NSString *name;
	NSMutableArray *newMessages;
	NCNotification *currentNotification;
}

@property (retain) NSString *ID;
@property (retain) NSString *name;
@property (retain) NSMutableArray *newMessages;
@property (retain) NCNotification *currentNotification;

@end
