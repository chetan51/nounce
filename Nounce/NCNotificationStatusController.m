//
//  NCNotificationStatusController.m
//  Nounce
//
//  Created by Chetan Surpur on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCNotificationStatusController.h"
#import <Nounce/NCNounceProtocol.h>
#import <Nounce/NCNotification.h>

#define DEFAULTSTATUSITEMLENGTH 100.0

@implementation NCNotificationStatusController

#pragma mark Initialization and destruction

- (id)init {
	if(self = [super initWithNibName:@"NotificationStatus" bundle:nil]) {
		[self view]; // cause view to load
	}
	
	return self;
}

- (void)loadView
{
    [super loadView];

	[self setupNotificationStatus];
	
	// Listen for events
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(notificationWasPosted:)
	 name:NCNotificationWasPostedEvent
	 object:nil];
}

- (void)setupNotificationStatus
{
	// Create notification status WebView
    float width = DEFAULTSTATUSITEMLENGTH;
    float height = [[NSStatusBar systemStatusBar] thickness];
    NSRect viewFrame = NSMakeRect(0, 0, width, height);
	notificationStatus = [[[WebView alloc] initWithFrame:viewFrame frameName:@"NCNotificationStatus" groupName:@"NCNotificationUI"] autorelease];
	[[[notificationStatus mainFrame] frameView] setAllowsScrolling:NO];
	
	// Set up the delegate of the notificationStatus for relevant events
    [notificationStatus setDrawsBackground:NO];
    [notificationStatus setUIDelegate:self];
    [notificationStatus setFrameLoadDelegate:self];
	[notificationStatus setEditingDelegate:self];
	
	// Configure notification status to let JavaScript talk to this object
    [[notificationStatus windowScriptObject] setValue:self forKey:@"NotificationStatusController"];
	
    // Load the HTML content
    NSString *resourcesPath = [[NSBundle mainBundle] resourcePath];
    NSString *htmlPath = [resourcesPath stringByAppendingString:@"/NotificationStatus.html"];
    [[notificationStatus mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlPath]]];
}

#pragma mark Functions


#pragma mark Event handlers

- (void)notificationWasPosted:(NSNotification *)notificationWasPostedEvent
{
	NCNotification *notification = [NSKeyedUnarchiver unarchiveObjectWithData:[[notificationWasPostedEvent userInfo] objectForKey:@"Notification"]];
	
	NSArray *args = [NSArray arrayWithObjects:
					 [notification ID],
					 [notification title] ? [notification title] : (NSString *)[NSNull null],
					 [notification content] ? [notification content] : (NSString *)[NSNull null],
					 [notification input] ? [notification input] : (NSString *)[NSNull null],
					 [[notification fromApp] ID],
					 [[notification fromApp] name] ? [[notification fromApp] name] : (NSString *)[NSNull null],
					 nil];
	[[notificationStatus windowScriptObject] callWebScriptMethod:@"notify" withArguments:args];	
}

- (void)notificationStatusWasSelectedForApplicationWithID:(NSString *)applicationID
{
	[[NSNotificationCenter defaultCenter] postNotificationName:NCNotificationStatusWasSelectedEvent
														object:NCNounceAppID
													  userInfo:[NSDictionary dictionaryWithObject:applicationID ? applicationID : (NSString *)[NSNull null]
																						   forKey:@"SelectedApplication"]];
}
	 
- (void)notificationStatusWasUnselected
{
	[[NSNotificationCenter defaultCenter] postNotificationName:NCNotificationStatusWasUnselectedEvent
														object:NCNounceAppID];	
}

#pragma mark WebView Delegate

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
	// Add to system status bar
	float width = DEFAULTSTATUSITEMLENGTH;
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:width] retain];
	[statusItem setView:notificationStatus];
}

- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element 
    defaultMenuItems:(NSArray *)defaultMenuItems
{
    return nil; // disable contextual menu
}

- (BOOL)webView:(WebView *)webView shouldChangeSelectedDOMRange:(DOMRange *)currentRange 
	 toDOMRange:(DOMRange *)proposedRange 
	   affinity:(NSSelectionAffinity)selectionAffinity 
 stillSelecting:(BOOL)flag
{
	return NO; // disable text selection
}

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)aSelector
{
	/*
	 if (aSelector == @selector(showMessage:)) {
	 return NO;
	 }
	 */
	
	return NO; // for development
}

@end