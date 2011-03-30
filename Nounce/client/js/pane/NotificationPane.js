/*
 * Global variables
 */

applications = {};

/*
 * DOM accessors
 */

function applicationsDiv()
{
	return $("#applications");
}

function applicationDivMold()
{
	return $("#molds > .application");
}

function notificationDivMold()
{
	return $("#molds > .notification");
}

function saveApplication(application)
{
	applications[application.ID()] = application;
}

function clearApplication(application)
{
	applications[application.ID()] = null;
}

function applicationWithID(appID)
{
	return applications[appID];
}

function notificationWithID(notificationID)
{
	for (var a in applications) {
		var application = applications[a];
		for (var n in application.notifications()) {
			var notification = application.notifications()[n];
			if (notification.ID() == notificationID) {
				return notification;
			}
		}
	}
}

/*
 * Initialization
 */

$(document).ready(function() {
	/* Testing
	notify("TestApp-0", "test notification", "testing ...", "<form name='test'><input type='text' name='reply' style='width: 100%; box-sizing: border-box; -webkit-box-sizing: border-box;'><input type='submit' name='reply' class='submit' value='Reply'><input type='submit' name='forward' class='submit' value='Forward'></form>", null, "com.yourcompany.TestApp", "Test Application");
	notify("TestApp-1", "test notification 2", "testing again ...", null, null, "com.yourcompany.TestApp", "Test Application");
	notify("TestApp2-0", "test notification 3", "testing again 2 ...", "<form><input type='submit' name='reply' class='submit' value='Reply'><input type='text' name='reply'><input type='submit' name='forward' class='submit' value='Forward'></form>", null, "TestApp2", "Test Application 2");
	*/
});

/*
 * Functions
 */

function notify (notificationID, notificationTitle, notificationContent, notificationInput, notificationIconPath, fromAppID, fromAppName, isUpdate)
{
	var application = applicationWithID(fromAppID);
	
	if (!application) {
		var applicationDiv = applicationDivMold().clone();
		applicationsDiv().append(applicationDiv);
		
		application = new Application({
			ID: fromAppID,
			name: fromAppName,
		    wasHiddenCallback: applicationWasHidden,
		}, applicationDiv);
		
		saveApplication(application);
	}
	
	var notification = application.notificationWithID(notificationID);
	
	if (!notification && !isUpdate) {
		var notificationDiv = notificationDivMold().clone();
		
		notification = new Notification({
			ID: notificationID,
			application: application,
			title: notificationTitle,
			content: notificationContent,
			input: notificationInput,
			iconPath: notificationIconPath,
		    wasHiddenCallback: notificationWasHidden,
		    inputWasSubmittedCallback: notificationInputWasSubmitted
		}, notificationDiv);
		
		application.setNotification(notification);
	}
	else if (notification) {
		notification.setTitle(notificationTitle);
		notification.setContent(notificationContent);
		notification.setIconPath(notificationIconPath);
		
		notification.refreshDisplay();
	}
}

function hideNotification (notificationID)
{
	var notification = notificationWithID(notificationID);
	
	if (notification) {
		notification.hide();
	}
}

/*
 * Event listeners
 */

function applicationWasHidden(application)
{
	clearApplication(application);
}

function notificationWasHidden(notification)
{
	window.NotificationPaneController.UINotificationWasHidden_(notification.ID());
}

function notificationInputWasSubmitted(form, notification, buttonName)
{
	var inputData = JSON.stringify(form.serializeObject());
	window.NotificationPaneController.UIInputWasSubmittedForNotificationWithID_formName_buttonName_inputData_(notification.ID(), form.attr("name"), buttonName, inputData);
	
	// Reset form
	$(':input',form)
	.not(':button, :submit, :reset, :hidden')
	.val('')
	.removeAttr('checked')
	.removeAttr('selected');
}

/*
 * jQuery extensions / plugins
 */

jQuery.extend(jQuery.expr[':'], {
    focus: function(element) { 
        return element == document.activeElement; 
    }
});

function jqID(myID) { 
	return myID.replace(/(:|\.)/g,'\\$1');
}
