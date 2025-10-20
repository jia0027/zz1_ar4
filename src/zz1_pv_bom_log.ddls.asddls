@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'BOM 拋轉MES LOG Projection View'
@UI: {
     headerInfo: {
                typeName: 'LOG ',
                typeNamePlural: 'LOG '
     }
}
@UI.presentationVariant: [
  {
    qualifier: 'Header',
    visualizations: [{type: #AS_LINEITEM }]
  }
]
@UI.selectionVariant: [
  {
    text: 'Header',
    qualifier: 'Header'
  }
]
define root view entity ZZ1_PV_BOM_LOG 
    provider contract transactional_query as projection on ZZ1_I_BOM_LOG
{
        @UI.facet: [
                       { id:            'ALL',
                         purpose:         #STANDARD,
                         type:            #COLLECTION,
                         label:           '資料',
                         position:        10
                       }
                    ]
                    
        @UI: {
                 lineItem: [{ position:10  }],
                selectionField: [{ position:10  }]
               }
        @EndUserText.label: '表頭物料'
        @Search.defaultSearchElement: true    
        key part_no,
        @UI: {
                 lineItem: [{ position:30  }],
                selectionField: [{ position: 30 }]
               }
        @EndUserText.label: '元件'    
        key item_part_no,
        @UI: {
                 lineItem: [{ position:20  }],
                selectionField: [{ position: 20 }]
               }
        @EndUserText.label: '工廠'            
        key plant,
        @UI: {
                 lineItem: [{ position:  40}],
                selectionField: [{ position: 40 }]
               }
        @EndUserText.label: '序號'    
        key serial_no,
        @UI: {
                 lineItem: [{ position: 50 }],
                selectionField: [{ position: 50 }]
               }
        @EndUserText.label: '拋轉類型'    
        data_status,
        @UI: {
                 lineItem: [{ position: 60 }],
                selectionField: [{ position:60  }]
               }
        @EndUserText.label: '元件替代群組'    
        item_group,
        @UI: {
                 lineItem: [{ position: 70 }],
                selectionField: [{ position:70  }]
               }
        @EndUserText.label: '元件替代群組優先順序'    
        item_group_index,
        unit,
        @UI: {
                 lineItem: [{ position:  80}],
                selectionField: [{ position:  80}]
               }
        @EndUserText.label: '元件用量'    
        item_count,
        @UI: {
                 lineItem: [{ position:  90}],
                selectionField: [{ position: 90 }]
               }
        @EndUserText.label: '上傳日期'    
        process_date,
        @UI: {
                 lineItem: [{ position: 100 }],
                selectionField: [{ position: 100 }]
               }
        @EndUserText.label: '上傳時間'    
        process_time,
        @UI: {
                 lineItem: [{ position: 110 }],
                selectionField: [{ position: 110 }]
               }
        @EndUserText.label: '上傳者'    
        process_user,
        @UI: {
                 lineItem: [{ position: 120 }],
                selectionField: [{ position:120  }]
               }
        @EndUserText.label: '上傳狀態'    
        update_status,
        @UI: {
                 lineItem: [{ position: 130 }],
                selectionField: [{ position: 130 }]
               }
        @EndUserText.label: '訊息'    
        message   
}
