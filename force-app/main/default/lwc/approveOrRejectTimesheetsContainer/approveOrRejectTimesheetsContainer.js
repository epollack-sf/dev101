import { LightningElement, api, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getTimesheetsByProject from '@salesforce/apex/ApproveOrRejectTimesheetsController.getTimesheetsByProject';
import rejectTimesheets from '@salesforce/apex/ApproveOrRejectTimesheetsController.rejectTimesheets';
import approveTimesheets from '@salesforce/apex/ApproveOrRejectTimesheetsController.approveTimesheets';

export default class ApproveOrRejectTimesheetsContainer extends LightningElement {
    @api recordId;
    @api buttonVariant;
    timesheets; // property on class -- VanillaJS
    wiredTimesheetResponse;


    @wire(getTimesheetsByProject, { projectId: '$recordId' })
    wiredTimesheets(value) {
        this.wiredTimesheetResponse = value; // returns framework object that contains timesheets
        
        if (value.data) {
            //value.data.map(timesheet => {
            //    timesheet.EmployeeName = timesheet.Employee__r.Name;
            //    return timesheet;
            //});

            this.timesheets = value.data;
        }
        
        if (value.error) {
            console.warn(value.error);
        }
    }
    // lifecycle function: called whenever the component is inserted on page
    connectedCallback() {
/*  Example of imperative function call. SEE SIMILARITIES BETWEEN THIS AND WIRE

        // key must match parameter name in Apex method
        getTimesheetsByProject({ projectId: this.recordId })
            .then(response => {
                console.log(response);

                response.forEach(timesheet => {
                    timesheet.EmployeeName = timesheet.Employee__r.Name;
                });

                this.timesheets = response;
            })
            .catch(error => {
                console.warn(error);
            });
*/
    }

    // to combine the timesheet handlers, you can add data attributes to the html for context

    handleTimesheetsRejected(event) {
        console.log('handling reject event');
        console.log(event);
        let timesheetsToReject = event.detail.timesheetsToReject;

        rejectTimesheets({ timesheets: timesheetsToReject })
            .then(response => {
                // console.log('timesheets successfully rejected');
                // timesheetsToReject = response;

                this.showNotification('Success', 'Timesheets successfully rejected');
                refreshApex(this.wiredTimesheetResponse);
            })
            .catch(error => {
                console.warn(error);
                this.showNotification('Error',
                                        'There was an issue saving timesheets. Please contact an administrator.',
                                        'error');
            });
    }

    handleTimesheetsApproved(event) {
        approveTimesheets({ timesheets: event.detail.timesheetsToApprove })
            .then(response => {
                // console.log("timesheets successfully approved");
                this.showNotification('Success', 'Timesheets successfully approved');
                refreshApex(this.wiredTimesheetResponse);
            })
            .catch(error => {
                console.warn(error);
                this.showNotification('Error',
                                        'There was an issue approving timesheets',
                                        'error');
            })
    }

    showNotification(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({
            title: title,
            message: message,
            variant: variant || 'success' // can use default parameter instead, but this example shows truthy/falsy
        }));
    }
}