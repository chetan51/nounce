//
//  NCNotification.h
//  Nounce
//
//  Created by Chetan Surpur on 2/12/11.
//  Copyright 2011 Chetan Surpur. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NCApplication.h"
#import "NCIcon.h"


@interface NCNotification : NSObject {
	NSString *ID;
	NCApplication *fromApp;
	NSString *title;
	NSString *content;
	NSString *input;
	NCIcon *icon;
	BOOL isUpdate;
}

@property (copy) NSString *ID;
@property (retain) NCApplication *fromApp;
@property (copy) NSString *title;
@property (copy) NSString *content;
@property (copy) NSString *input;
@property (retain) NCIcon *icon;
@property (assign) BOOL isUpdate;

+ (NCNotification *)notificationWithTitle:(NSString *)title
								  content:(NSString *)content
									input:(NSString *)input;

@end
