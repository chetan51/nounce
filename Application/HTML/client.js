/*
 * Defaults and constants
 */


/*
 * Initialization
 */

$(document).ready(function() {
	window.AppController.NPLog_("initialized client");
});

/*
 * Functions
 */

function notify (notificationID, notificationTitle, notificationContent, fromAppID, fromAppName)
{
	window.AppController.NPLog_("notifying with title: " + notificationTitle);
}
