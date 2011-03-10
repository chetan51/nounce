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
	return $("#"+appID, applicationsDiv());
}

function notificationDivWithID (notificationID, applicationDiv)
{
	return $("#"+notificationID);
}

/*
 * Initialization
 */

$(document).ready(function() {
	/* Testing
	notify("TestApp-0", "test notification", "testing ...", "<form><input type='text' name='reply' style='width: 100%; box-sizing: border-box; -webkit-box-sizing: border-box;'><input type='submit' name='reply' class='submit' value='Reply'><input type='submit' name='forward' class='submit' value='Forward'></form>", "TestApp", "Test Application");
	notify("TestApp-1", "test notification 2", "testing again ...", null, "TestApp", "Test Application");
	notify("TestApp2-0", "test notification 3", "testing again 2 ...", "<form><input type='submit' name='reply' class='submit' value='Reply'><input type='text' name='reply'><input type='submit' name='forward' class='submit' value='Forward'></form>", "TestApp2", "Test Application 2");
	*/
});

/*
 * Functions
 */

function notify (notificationID, notificationTitle, notificationContent, notificationInput, fromAppID, fromAppName)
{
	var applicationDiv = applicationDivWithID(fromAppID);
	if (!applicationDiv.length) {
		applicationDiv = applicationDivMold().clone();
		applicationsDiv().append(applicationDiv);
	}
	
	applicationDiv.children(".name").html(fromAppName);
	
	var notificationDiv = notificationDivWithID(notificationID, applicationDiv);
	if (!notificationDiv.length) {
		notificationDiv = notificationDivMold().clone();
		applicationDiv.children(".notifications").append(notificationDiv);
		
		if (notificationInput) {
			notificationDiv.children(".input").html(notificationInput);
			notificationDiv.children(".input").show();
			
			// Add event listeners
			notificationDiv.children(".input").find("input[type='submit']").click(function(e) {
				notificationInputButtonWasClicked(e, $(this), notificationID);
			});
		}
		
		// Add event listeners
		notificationDiv.hover(notificationWasHoveredIn, notificationWasHoveredOut);
	}
	
	notificationDiv.children(".title").html(notificationTitle);
	notificationDiv.children(".content").html(notificationContent);
	
	placeholderDiv().hide();
	applicationsDiv().show();
}

function submitNotificationInputForm(form, notificationID, buttonName)
{
	var inputData = JSON.stringify(form.serializeObject());
	window.NotificationPaneController.inputWasSubmittedForNotificationWithID_formName_buttonName_inputData_(notificationID, form.attr("name"), buttonName, inputData);
	
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

function notificationInputButtonWasClicked(e, button, notificationID)
{
	if (button.hasClass("submit")) {
		submitNotificationInputForm(button.parents("form"), notificationID, button.attr("name"));
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

/*
 * AppController event listeners
 */

/*
 * jQuery extensions / plugins
 */

jQuery.extend(jQuery.expr[':'], {
    focus: function(element) { 
        return element == document.activeElement; 
    }
});
