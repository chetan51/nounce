//
//  NCNounceProtocol.h
//  Nounce
//
//  Created by Chetan Surpur on 3/8/11.
//  Copyright 2011 Chetan Surpur. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NCNounceProtocol : NSObject {

}

@end

#define NCNounceAppID							@"Nounce"

#define NCNotificationWasPostedEvent			@"Nounce_NotificationWasPosted"
#define NCNotificationWasHiddenEvent			@"Nounce_NotificationWasHidden"
#define NCInputWasSubmittedEvent				@"Nounce_InputWasSubmitted"

#define NCNotificationStatusWasSelectedEvent	@"Nounce_NotificationStatusWasSelected"
#define NCNotificationStatusWasUnselectedEvent	@"Nounce_NotificationStatusWasUnselectedEvent"

#define NCNotificationPaneWasHiddenEvent		@"Nounce_NotificationPaneWasHidden"