import { LightningElement, api } from 'lwc';

export default class CreateNewTimesheetButton extends LightningElement {
    @api projectId;

    toggleForm() {
        this.template.querySelector('c-modal').toggleModal();
    }
}