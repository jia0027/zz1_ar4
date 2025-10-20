@Search.searchable: true
@Metadata.allowExtensions: true
@EndUserText.label: '付款清單 PV VIEW'
@UI: {
     headerInfo: {
                typeName: '付款清單',
                typeNamePlural: '付款清單'
     }
}

define root view entity zz1_pv_paymentlist as projection on zz1_I_paymentlist
{
    @UI.facet: [
                   { id:            'ALL',
                     purpose:         #STANDARD,
                     type:            #COLLECTION,
                     label:           '資料',
                     position:        10
                   },
                   
                   { type: #FIELDGROUP_REFERENCE ,
                     label : '表頭資料',
                     targetQualifier: 'head' ,
                     parentId: 'ALL',
                     id: 'DNhead' ,
                     position: 10
                   },
                   { type: #FIELDGROUP_REFERENCE ,
                     label : '明細資料',
                     targetQualifier: 'item' ,
                     parentId: 'ALL' ,
                     id : 'DNitem' ,
                     position: 20
                   }
               ]
    @UI: {
           selectionField: [{ position: 30 }]
       }
    @EndUserText.label: '執行日期'
    @Search.defaultSearchElement: true                
    key PaymentRunDate,
    @UI: {
           selectionField: [{ position: 40 }]
       }
    @EndUserText.label: '識別'     
    key PaymentRunID,
    key PaymentDocument,
    @UI: {
           selectionField: [{ position: 10 }]
       }
    @EndUserText.label: '付款公司代碼'      
    key PayingCompanyCode,
    @UI: {
           selectionField: [{ position: 20 }]
       }
    @EndUserText.label: '銀行所在國家/地區'       
    BankCountry,
    @UI: {
           lineItem: [{ position: 10}]
       }
    @EndUserText.label: '付款人账号'    
    BankAccount, 
    @UI: {
           lineItem: [{ position: 20}]
       }
    @EndUserText.label: '收款人账号'        
    PayeeBankAccount2,
//    @UI: {
//           lineItem: [{ position: 10}]
//       }
//    @EndUserText.label: ''        
//    PayeeBankDetailReference,
    @UI: {
           lineItem: [{ position: 30}]
       }
    @EndUserText.label: '收款人户名'        
    PayeeBankAccountHolderName,
    @UI: {
           lineItem: [{ position: 40}]
       }
    @EndUserText.label: '收款人开户行'        
    PayeeBankKey1,
    @UI: {
           lineItem: [{ position: 50}]
       }
    @EndUserText.label: '收款行CNAPS行号'        
    PayeeBankKey2,
    @UI: {
           lineItem: [{ position: 60}]
       }
    @EndUserText.label: '收款行清算行号'        
    text1,
    @UI: {
           lineItem: [{ position: 70}]
       }
    @EndUserText.label: '收款人类型'        
    text2,
    PaymentCurrency,    
    @UI: {
           lineItem: [{ position: 80}]
       }
    @EndUserText.label: '付款金额'        
//    @Semantics.amount.currencyCode: 'PaymentCurrency'
    PaymentAmountInPaytCurrency,
    @UI: {
           lineItem: [{ position: 90}]
       }
    @EndUserText.label: '付费账号'        
    text3,    
    @UI: {
           lineItem: [{ position: 100}]
       }
    @EndUserText.label: '指定付款日期'      
    PostingDate,    
    @UI: {
           lineItem: [{ position: 110}]
       }
    @EndUserText.label: '用途'        
    DocumentItemText,
    @UI: {
           lineItem: [{ position: 120}]
       }
    @EndUserText.label: '客户业务编号'        
    Supplier,
    @UI: {
           lineItem: [{ position: 130}]
       }
    @EndUserText.label: '收款人Email'        
    text4,
            @UI: {
           lineItem: [{ position: 140}]
       }
    @EndUserText.label: '交易处理方式'        
    text5
    
} 
