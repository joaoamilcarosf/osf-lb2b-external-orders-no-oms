public class osf_OrderIntegrator {
    public osf_OrderIntegrator() {}

    public void runWorkflow() {
        
    }

    private Order insertOrder(Id accountId, Id ownerId, Date orderedDate, Date effectiveDate, String orderStatus, Id pricebookId, Id storeId, String currencyISOCode) {
        Order o = new Order(
            AccountId = accountId,
            OwnerId = ownerId,
            OrderedDate = orderedDate,
            EffectiveDate = effectiveDate,
            Status = orderStatus,
            Pricebook2Id = pricebookId,
            SalesStoreId = storeId,
            CurrencyIsoCode = currencyISOCode
        );
        insert o;
        return o;
    }

    private OrderDeliveryGroup insertOrderDeliveryGroup(Id orderId, Id orderDeliveryMethodId, String deliverTo, Date desiredDeliveryDate) {
        OrderDeliveryGroup odg = new OrderDeliveryGroup(
            OrderId = orderId,
            OrderDeliveryMethodId = orderDeliveryMethodId,
            DeliverToName = deliverTo,
            DesiredDeliveryDate = desiredDeliveryDate
        );
        insert odg;
        return odg;
    }

    private OrderItem insertOrderItem(Id orderItemId, Id productId, Id pricebookEntryId, Integer quantity, Decimal unitPrice, Decimal listPrice, Decimal totalLineAmount, Id orderDeliveryGroupId, String orderItemType) {
        OrderItem oi = new OrderItem(
            OrderId = orderItemId,
            Product2Id = productId,
            PricebookEntryId = pricebookEntryId,
            Quantity = quantity,
            UnitPrice = unitPrice, // Pricebook Entry
            ListPrice = listPrice, // Pricebook Entry
            TotalLineAmount = totalLineAmount, // Pricebook Entry
            OrderDeliveryGroupId = orderDeliveryGroupId,
            Type = orderItemType
        );
        insert oi;
        return oi;
    }

    private Order activateOrder(Order order) {
        order.Status = 'Activated';
        update order;
        return order;
    }

    public ConnectApi.OrderSummaryOutputRepresentation createOrderSummary(Id orderId) {
        ConnectApi.OrderSummaryInputRepresentation osir = new ConnectApi.OrderSummaryInputRepresentation();
        osir.orderId = orderId;
        osir.orderLifeCycleType = 'UNMANAGED';
        ConnectApi.OrderSummaryOutputRepresentation osor = ConnectApi.OrderSummaryCreation.createOrderSummary(osir);
        return osor;
    }
}
