@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '中信付款清單'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zz1_I_paymentlist as select from I_PaymentProposalPayment as a
//    left outer join I_PaymentProposalItem as b on a.PaymentRunDate = b.PaymentRunDate and a.PaymentRunID = b.PaymentRunID and a.PaymentDocument = b.PaymentDocument and a.Supplier = b.PaymentDocument
    left outer join zz1_I_paymentlist2 as b on a.PaymentRunDate = b.PaymentRunDate and a.PaymentRunID = b.PaymentRunID and a.PaymentDocument = b.PaymentDocument and a.Supplier = b.Supplier
    left outer join I_Bank_2 as bk on a.PayeeBankKey = bk.BankInternalID
    left outer join I_PaymentProgramControl as c on a.PaymentRunDate = c.PaymentRunDate and a.PaymentRunID = c.PaymentRunID
    left outer join I_Supplier as d on a.Supplier = d.Supplier
    left outer join I_Currency as e on a.PaymentCurrency = e.Currency
{  
    key a.PaymentRunDate,
    key a.PaymentRunID,
    key a.PaymentDocument,
    @Consumption.valueHelpDefinition: [ 
      { entity:  { name:    'I_CompanyCodeStdVH',
                   element: 'CompanyCode' }
      }]      
    key a.PayingCompanyCode,
    @Consumption.valueHelpDefinition: [ 
      { entity:  { name:    'I_RegionVH',
                   element: 'Country' }
      }]     
    a.BankCountry,
    a.BankAccount, 
    a.PayeeBankAccount,
    a.PayeeBankDetailReference,
    concat(a.PayeeBankAccount,a.PayeeBankDetailReference) as PayeeBankAccount2,
    a.PayeeBankAccountHolderName,
    case when left( bk.BankName , 4 ) = '中国银行' then '中行'
//        else a.PayeeBankKey
        else bk.BankName
        end as PayeeBankKey1,
    case when left( bk.BankName , 4 ) = '中国银行' then '中行'
        else a.PayeeBankKey
        end as PayeeBankKey2,
    a.PaymentCurrency,
//    @Semantics.amount.currencyCode: 'PaymentCurrency'
//    abs(a.PaymentAmountInPaytCurrency) as PaymentAmountInPaytCurrency,
//    cast(  abs(a.PaymentAmountInPaytCurrency) as abap.char(30)) as PaymentAmountInPaytCurrency,
//    cast( currency_conversion(
//            amount           => abs(a.PaymentAmountInPaytCurrency) * power( base => 10 , exponent => coalesce(e.Decimals,2)),
//            source_currency  => a.PaymentCurrency,
//            target_currency  => a.PaymentCurrency,
//            exchange_rate_date => $session.system_date,
//            client           => $session.client,
//            round            => 'X'
//          ) as abap.char(30) ) as PaymentAmountInPaytCurrency,
    cast(
        abs( cast( a.PaymentAmountInPaytCurrency as abap.dec(31,2) ) ) *
        case coalesce( e.Decimals, 2 )         /* 或 c.CurrencyDecimalPlaces */
          when 0 then 100
          when 1 then 10
          when 2 then 1
          else 1
        end
        as abap.char(40)
      ) as PaymentAmountInPaytCurrency,        
    @Semantics.businessDate.at: true
//    a.PostingDate,
    cast( a.PostingDate as abap.char(8)) as PostingDate, 
    b.DocumentItemText,
    //a.Supplier,
    cast( '' as abap.char(40)) as Supplier,
    cast( '' as abap.char(40)) as text1,
    case when d.IsNaturalPerson is not initial then '个人'
        else '单位'
        end as text2,
    cast( '' as abap.char(40)) as text3,
    cast( '' as abap.char(40)) as text4,
    cast( '' as abap.char(40)) as text5
}   where a.PaymentRunIsProposal <> 'X';
    
