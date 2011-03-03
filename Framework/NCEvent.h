//
//  NCEvent.h
//  Nounce
//
//  Created by Chetan Surpur on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


typedef enum NCEventType
{
    NCEVENT_READ,
    NCEVENT_CLEARED,
    NCEVENT_INPUT_SUBMIT
} NCEventType;


@interface NCEvent : NSObject {
	NCEventType type;
}

@property (assign) NCEventType type;

@end
