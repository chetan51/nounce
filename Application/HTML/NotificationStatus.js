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

function selectApplicationsDiv()
{
	getApplicationsDiv().removeClass("default").addClass("selected");	
}

function unselectApplicationsDiv()
{
	getApplicationsDiv().removeClass("selected").addClass("default");	
}

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
}

/*
 * AppController event listeners
 */

function UIShowGeneralNotifications()
{
	selectApplicationsDiv();
	notificationPaneVisible = true;
}

function UIHideGeneralNotifications()
{
	unselectApplicationsDiv();
	notificationPaneVisible = false;
}