({
    getTimesheets : function(component, helper, projectId) {
        var action = component.get('c.getTimesheetsByProject');

        action.setParams({
            projectId: projectId
        });

        action.setCallback(this, function (response) {
            // determines if the async function was successful
            /*
                getStata(): gets the status of response, either Success or Fail
                getReturnValue(): gets value from response
                getError(): returns error if getState() != Success
            */
            if (response.getState() === 'SUCCESS') {
                var timesheets = response.getReturnValue();

                component.set('v.timesheets', timesheets);

                console.log(timesheets);
            } else {
                console.warn(response.getError());
            }
        })

        $A.enqueueAction(action);
    }
})
