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
}

@property (retain) NCApplication *application;

@end
