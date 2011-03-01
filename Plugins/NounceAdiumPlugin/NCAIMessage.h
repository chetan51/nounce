//
//  NCAIMessage.h
//  NounceAdiumPlugin
//
//  Created by Chetan Surpur on 2/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NCAIMessage : NSObject {
	BOOL isSenderSelf;
	NSString *senderName;
	NSString *message;
}

@property BOOL isSenderSelf;
@property (retain) NSString *senderName;
@property (retain) NSString *message;

@end
