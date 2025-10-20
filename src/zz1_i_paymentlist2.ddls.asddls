@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '中信付款清單篩選文件日期'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zz1_I_paymentlist2 as select from I_PaymentProposalItem
{
      key PaymentRunDate,
      key PaymentRunID,
      key Supplier,
      key min ( AccountingDocument ) as AccountingDocument,
      min( DocumentDate ) as DocumentDate,
      PaymentDocument,
      DocumentItemText
} where PaymentRunIsProposal <> 'X'
group by PaymentRunDate,PaymentRunID,PaymentDocument,Supplier,DocumentItemText
