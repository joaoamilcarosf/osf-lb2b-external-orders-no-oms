public with sharing class osf_OrderTriggerHandler implements osf_TriggerInt {
    public void beforeInsert(SObject so) {}

    public void beforeUpdate(SObject old_so, SObject so) {}

    public void beforeDelete(SObject so) {}

    public void afterInsert(SObject so) {}

    public void afterUpdate(SObject old_so, SObject so) {
        if(((Order) old_so).Status != 'Activated' && ((Order) so).Status == 'Activated') {
            new osf_OrderIntegrator().createOrderSummary(((Order) so).Id);
        }
    }

    public void afterDelete(SObject so) {}

    public void afterUndelete(SObject so) {}
}