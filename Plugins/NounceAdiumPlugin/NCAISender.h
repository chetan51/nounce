//
//  NCAISender.h
//  NounceAdiumPlugin
//
//  Created by Chetan Surpur on 2/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Nounce/NCNotification.h>


@interface NCAISender : NSObject {
	NSMutableArray *newMessages;
	NCNotification *currentNotification;
}

@property (retain) NSMutableArray *newMessages;
@property (retain) NCNotification *currentNotification;

@end
