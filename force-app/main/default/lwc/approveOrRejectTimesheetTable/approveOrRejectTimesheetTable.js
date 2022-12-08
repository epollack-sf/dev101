import { LightningElement, api } from 'lwc';

export default class ApproveOrRejectTimesheetTable extends LightningElement {
    // properties are used to save state of component/application
    @api timesheets;
    @api buttonVariant;
    selectedTimesheets;
    
    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Employee', fieldName: 'EmployeeName' },
        { label: 'Status', fieldName: 'Status__c' },
        { label: 'Number of Hours', fieldName: 'Total_Hours__c' }
    ];

    toggleModal() {
        this.template.querySelector('c-modal').toggleModal();
    }

    getSelectedRows(event) {
        const selectedRows = event.detail.selectedRows;
        this.selectedTimesheets = selectedRows;

        console.log(JSON.stringify(selectedRows));
    }

    rejectTimesheets() {
        let detail = {
            timesheetsToReject: this.selectedTimesheets
        };

        // event name should be all lowercase
        const rejectTimesheetEvent = new CustomEvent('rejecttimesheets', { detail: detail });

        console.log('Firing reject event');
        console.log(rejectTimesheetEvent);

        this.dispatchEvent(rejectTimesheetEvent);
    }

    approveTimesheets() {
        this.dispatchEvent(new CustomEvent('approvetimesheets', {
            detail: {
                timesheetsToApprove: this.selectedTimesheets
            }
        }));
    }
}