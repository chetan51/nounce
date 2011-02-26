/*
 * Defaults and constants
 */


/*
 * Global variables
 */

notificationPaneVisible = false;

/*
 * Accessors and setters of global variables
 */


/*
 * DOM accessors
 */

function getApplicationsDiv()
{
	return $("#applications");
}

/*
 * Initialization
 */

$(document).ready(function() {
	// Set up listeners
	getApplicationsDiv().click(clickedApplicationsDiv);
});

/*
 * Functions
 */

/*
 * Event listeners
 */

function clickedApplicationsDiv(e)
{
	if (!notificationPaneVisible) {
		window.AppController.NCShowGeneralNotificationsClicked();
	}
	else {
		window.AppController.NCHideGeneralNotificationsClicked();
	}
	
	notificationPaneVisible = !notificationPaneVisible;
}