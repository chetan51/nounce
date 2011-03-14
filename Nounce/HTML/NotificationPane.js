/*
 * DOM accessors
 */

function applicationsDiv()
{
	return $("#applications");
}

function placeholderDiv()
{
	return $("#placeholder");
}

function applicationDivMold()
{
	return $("#molds > .application");
}

function notificationDivMold()
{
	return $("#molds > .notification");
}

function applicationDivWithID (appID)
{
	return $("#"+jqID(appID), applicationsDiv());
}

function notificationDivWithID (notificationID, applicationDiv)
{
	return $("#"+jqID(notificationID));
}

function applicationDivForNotificationDiv (notificationDiv)
{
	return notificationDiv.parents(".application");
}

function formForInputButton (button)
{
	return button.parents("form");
}

function notificationDivForInputButton (button)
{
	return button.parents(".notification");
}

function controlsForNotificationDiv (notificationDiv)
{
	return $("> .controls", notificationDiv);
}

function hideButtonForNotificationDiv (notificationDiv)
{
	return $("> .hide", controlsForNotificationDiv(notificationDiv));
}

function notificationDivForHideButton (button)
{
	return button.parents(".notification");
}

/*
 * Initialization
 */

$(document).ready(function() {
	/* Testing
	notify("TestApp-0", "test notification", "testing ...", "<form name='test'><input type='text' name='reply' style='width: 100%; box-sizing: border-box; -webkit-box-sizing: border-box;'><input type='submit' name='reply' class='submit' value='Reply'><input type='submit' name='forward' class='submit' value='Forward'></form>", "com.yourcompany.TestApp", "Test Application");
	notify("TestApp-1", "test notification 2", "testing again ...", null, "com.yourcompany.TestApp", "Test Application");
	notify("TestApp2-0", "test notification 3", "testing again 2 ...", "<form><input type='submit' name='reply' class='submit' value='Reply'><input type='text' name='reply'><input type='submit' name='forward' class='submit' value='Forward'></form>", "TestApp2", "Test Application 2");
	*/
});

/*
 * Functions
 */

function notify (notificationID, notificationTitle, notificationContent, notificationInput, fromAppID, fromAppName, isUpdate)
{
	var applicationDiv = applicationDivWithID(fromAppID);
	if (!applicationDiv.length) {
		applicationDiv = applicationDivMold().clone();
		applicationDiv.attr("id", fromAppID);
		applicationsDiv().append(applicationDiv);
	}
	
	applicationDiv.children(".name").html(fromAppName);
	
	var notificationDiv = notificationDivWithID(notificationID, applicationDiv);
	if (!notificationDiv.length) {
		notificationDiv = notificationDivMold().clone();
		notificationDiv.attr("id", notificationID);
		applicationDiv.children(".notifications").append(notificationDiv);
		
		if (notificationInput) {
			notificationDiv.children(".input").html(notificationInput);
			notificationDiv.children(".input").show();
			
			// Add event listeners
			notificationDiv.children(".input").find("input[type='submit']").click(notificationInputButtonWasClicked);
		}
		
		// Add event listeners
		notificationDiv.hover(notificationWasHoveredIn, notificationWasHoveredOut);
		hideButtonForNotificationDiv(notificationDiv).click(notificationHideWasClicked);
	}
	notificationDiv.children(".title").html(notificationTitle);
	notificationDiv.children(".content").html(notificationContent);
	
	placeholderDiv().hide();
	applicationsDiv().show();
}

function hideNotification (notificationID)
{
	var notificationDiv = notificationDivWithID(notificationID);
	var applicationDiv = applicationDivForNotificationDiv(notificationDiv);
	
	notificationDiv.remove();
	
	if (!applicationDiv.children(".notifications").children().length) {
		applicationDiv.remove();
	}
	
	if (!applicationsDiv().children().length) {
		applicationsDiv().hide();
		placeholderDiv().show();
		window.NotificationPaneController.UINotificationPaneWasHidden();
	}
	
	window.NotificationPaneController.UINotificationWasHidden_(notificationID);
}

function submitNotificationInputForm(form, notificationID, buttonName)
{
	var inputData = JSON.stringify(form.serializeObject());
	window.NotificationPaneController.UIInputWasSubmittedForNotificationWithID_formName_buttonName_inputData_(notificationID, form.attr("name"), buttonName, inputData);
	
	// Reset form
	$(':input',form)
	.not(':button, :submit, :reset, :hidden')
	.val('')
	.removeAttr('checked')
	.removeAttr('selected');
}

/*
 * Event listeners
 */

function notificationWasHoveredIn(e)
{
	$(this).find("input").animate({'opacity': ".95"});
}

function notificationWasHoveredOut(e)
{
	if (!$(this).find("input").is(":focus")) {
		$(this).find("input").animate({'opacity': ".45"});
	}
}

function notificationInputButtonWasClicked(e)
{	
	if ($(this).hasClass("submit")) {
		submitNotificationInputForm(formForInputButton($(this)), notificationDivForInputButton($(this)).attr("id"), $(this).attr("name"));
	}
	/*
	else if (button.hasClass("show-form")) {
		var targetForm = button.attr('rel');
		if (targetForm) {

		}
	}
	*/
	
	e.stopPropagation();               
	e.preventDefault();
}

function notificationHideWasClicked(e)
{
	var notificationDiv = notificationDivForHideButton($(this));
	hideNotification(notificationDiv.attr("id"));
}

/*
 * NotificationPaneController event listeners
 */

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
