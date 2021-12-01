public with sharing class osf_TriggerFactory {
    private static final Map<SObjectType, String> SOBJECT_TYPE_TO_CLASS_NAME = new Map<SObjectType, String> {
        Order.SObjectType => 'osf_OrderTriggerHandler'
    };

    public static void createHandler(Schema.sObjectType so_type) {
        osf_TriggerInt handler = getHandler(so_type);
        if (handler == null) {
            throw new osf_TriggerException('No Trigger Handler registered for Object Type: ' + so_type);
        }
        execute(handler);
    }

    private static osf_TriggerInt getHandler(Schema.sObjectType so_type) {
        if(SOBJECT_TYPE_TO_CLASS_NAME.containsKey(so_type)) {
            Type t = Type.forName(SOBJECT_TYPE_TO_CLASS_NAME.get(so_type));
            osf_TriggerInt sobject_handler = (osf_TriggerInt) t.newInstance();
            return sobject_handler;
        }
        return null;
    }

    private static void execute(osf_TriggerInt handler) {
        if(Trigger.isBefore) {
            fireTriggerIsBefore(handler);
        } else {
            fireTriggerIsAfter(handler);
        }
    }

    private static void fireTriggerIsBefore(osf_TriggerInt handler) {
        if(Trigger.isDelete) {
            for(SObject so: Trigger.old) {
                handler.beforeDelete(so);
            }
        } else if(Trigger.isInsert) {
            for(SObject so: Trigger.new) {
                handler.beforeInsert(so);
            }
        } else if(Trigger.isUpdate) {
            for(SObject so: Trigger.old) {
                handler.beforeUpdate(so, Trigger.newMap.get(so.Id));
            }
        }
    }

    private static void fireTriggerIsAfter(osf_TriggerInt handler) {
        if(Trigger.isDelete) {
            for(SObject so: Trigger.old) {
                handler.afterDelete(so);
            }
        } else if(Trigger.isInsert) {
            for(SObject so: Trigger.new) {
                handler.afterInsert(so);
            }
        } else if(Trigger.isUpdate) {
            for(SObject so: Trigger.old) {
                handler.afterUpdate(so, Trigger.newMap.get(so.Id));
            }
        } else if(Trigger.isUndelete) {
            for(SObject so: Trigger.new) {
                handler.afterUndelete(so);
            }
        }
    }
}