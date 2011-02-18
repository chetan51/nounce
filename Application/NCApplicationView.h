//
//  NCApplicationView.h
//  Nounce
//
//  Created by Chetan Surpur on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Nounce/NCApplication.h"


@interface NCApplicationView : NSObject {
	NCApplication *application;
	
	NSArrayController *notifications;
}

@property (retain) NCApplication *application;
@property (retain) NSArrayController *notifications;

@end
