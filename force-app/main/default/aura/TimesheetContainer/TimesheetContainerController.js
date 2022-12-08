({
    doInit : function(component, event, helper) {
        var projectId = component.get('v.recordId');
        
        helper.getTimesheets(component, helper, projectId);
    }
})
