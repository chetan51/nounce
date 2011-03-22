//
//  NCNotificationPaneController.m
//  Nounce
//
//  Created by Chetan Surpur on 3/8/11.
//  Copyright 2011 Chetan Surpur. All rights reserved.
//

#import "NCNotificationPaneController.h"
#import "NounceAppDelegate.h"
#import <Nounce/NCNounceProtocol.h>
#import <Nounce/NCNotification.h>


#import "JSON.h"


@implementation NCNotificationPaneController

@synthesize notificationWindow;

#pragma mark Initialization and destruction

- (id)init {
	if((self = [super initWithWindowNibName:@"NotificationPane"])) {
		[self window]; // causing window to load
	}
	
	return self;
}

- (void)windowDidLoad
{
	[self setupNotificationWindow];
	[self setupNotificationPane];
	
	// Listen for events
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(notificationWasPosted:)
	 name:NCNotificationWasPostedEvent
	 object:nil];
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(notificationWasHidden:)
	 name:NCNotificationWasHiddenEvent
	 object:nil];
	
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(notificationStatusWasSelected:)
	 name:NCNotificationStatusWasSelectedEvent
	 object:nil];
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(notificationStatusWasUnselected:)
	 name:NCNotificationStatusWasUnselectedEvent
	 object:nil];
	
	// (TODO: make this user-configurable)
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(notificationPaneDidLoseFocus:)
	 name:NSWindowDidResignKeyNotification
	 object:notificationWindow];
}

- (void)setupNotificationWindow
{
	NSRect screenRect = [[NSScreen mainScreen] frame];
	NSRect windowRect = [notificationWindow frame];
	
	// Stretch window fully vertically, minus the system menu bar
	windowRect.size.height = screenRect.size.height - 20;
	
	// Place window on top right of the screen
	windowRect.origin.y = 0;
	
	[notificationWindow setFrame:windowRect display:YES];
}

- (void)setupNotificationPane
{
	// Set up the delegate of the notificationPane for relevant events
    [notificationPane setDrawsBackground:NO];
    [notificationPane setUIDelegate:self];
    [notificationPane setFrameLoadDelegate:self];
	[notificationPane setEditingDelegate:self];
    
    // Configure notification pane to let JavaScript talk to this object
    [[notificationPane windowScriptObject] setValue:self forKey:@"NotificationPaneController"];
    
    // Load the HTML content
    NSString *resourcesPath = [[NSBundle mainBundle] resourcePath];
    NSString *htmlPath = [resourcesPath stringByAppendingString:@"/NotificationPane.html"];
    [[notificationPane mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlPath]]];
}

#pragma mark Functions

- (void)showNotificationPane
{
	[NSApp activateIgnoringOtherApps:YES]; // allows windows of this app to become front
	[notificationWindow setAlphaValue:0.0];
	[notificationWindow makeKeyAndOrderFront:nil];
    [[notificationWindow animator] setAlphaValue:1.0];	
}

- (void)hideNotificationPane
{
	[NSApp hide:nil]; // give focus back to previous app
	[notificationWindow orderOut:nil];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:NCNotificationPaneWasHiddenEvent
														object:NCNounceAppID];
}

#pragma mark UI event handlers

- (void)UIInputWasSubmittedForNotificationWithID:(NSString *)notificationID
										formName:(NSString *)formName
									  buttonName:(NSString *)buttonName
									   inputData:(NSString *)inputData
{
	// Parse input data JSON
	SBJsonParser *parser = [SBJsonParser new];
	NSDictionary *inputDataDictionary = [parser objectWithString:inputData error:nil];
	[parser release];
	
	// Broadcast event
	NounceAppDelegate *appDelegate = (NounceAppDelegate *)[[NSApplication sharedApplication] delegate];
	NCNotification *notification = [appDelegate.notificationController notificationWithID:notificationID];
	NSData *archivedNotification = [NSKeyedArchiver archivedDataWithRootObject:notification];
	[[NSNotificationCenter defaultCenter] postNotificationName:NCInputWasSubmittedEvent
														object:NCNounceAppID
													  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
																archivedNotification, @"Notification",
																inputDataDictionary, @"InputData",
																formName, @"FormName",
																buttonName, @"ButtonName",
																nil]];
}

- (void)UINotificationWasHidden:(NSString *)notificationID
{
	NounceAppDelegate *appDelegate = (NounceAppDelegate *)[[NSApplication sharedApplication] delegate];
	NCNotification *notification = [appDelegate.notificationController notificationWithID:notificationID];
	NSData *archivedNotification = [NSKeyedArchiver archivedDataWithRootObject:notification];
	[[NSNotificationCenter defaultCenter] postNotificationName:NCNotificationWasHiddenEvent
														object:NCNounceAppID
													  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
																archivedNotification, @"Notification",
																nil]];
}

- (void)UINotificationPaneWasHidden
{
	if ([[self notificationWindow] isVisible]) {
		[self hideNotificationPane];
	}
}

#pragma mark General event handlers

- (void)notificationWasPosted:(NSNotification *)notificationWasPostedEvent
{
	NCNotification *notification = [NSKeyedUnarchiver unarchiveObjectWithData:[[notificationWasPostedEvent userInfo] objectForKey:@"Notification"]];
	
	NSArray *args = [NSArray arrayWithObjects:
					 [notification ID],
					 [notification title] ? [notification title] : (NSString *)[NSNull null],
					 [notification content] ? [notification content] : (NSString *)[NSNull null],
					 [notification input] ? [notification input] : (NSString *)[NSNull null],
					 [[notification icon] path] ? [[notification icon] path] : (NSString *)[NSNull null],
					 [[notification fromApp] ID],
					 [[notification fromApp] name] ? [[notification fromApp] name] : (NSString *)[NSNull null],
					 [notification isUpdate] ? [NSNumber numberWithBool:[notification isUpdate]] : (NSNumber *)[NSNull null],
					 nil];
	[[notificationPane windowScriptObject] callWebScriptMethod:@"notify" withArguments:args];
}

- (void)notificationWasHidden:(NSNotification *)notificationWasHiddenEvent
{
	if (![[notificationWasHiddenEvent object] isEqual:NCNounceAppID]) {
		NCNotification *notification = [NSKeyedUnarchiver unarchiveObjectWithData:[[notificationWasHiddenEvent userInfo] objectForKey:@"Notification"]];
		
		NSArray *args = [NSArray arrayWithObjects:
						 [notification ID],
						 nil];
		[[notificationPane windowScriptObject] callWebScriptMethod:@"hideNotification" withArguments:args];
	}
}

- (void)notificationStatusWasSelected:(NSNotification *)notificationStatusWasSelectedEvent
{
	if (![[self notificationWindow] isVisible]) {
		[self showNotificationPane];
	}
}

- (void)notificationStatusWasUnselected:(NSNotification *)notificationStatusWasUnselectedEvent
{
	if ([[self notificationWindow] isVisible]) {
		[self hideNotificationPane];
	}
}

- (void)notificationPaneDidLoseFocus:(NSNotification *)notificationPaneDidLoseFocusEvent
{
	if ([[self notificationWindow] isVisible]) {
		[self hideNotificationPane];
	}
}

#pragma mark WebView Delegate

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
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
	return YES;
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
