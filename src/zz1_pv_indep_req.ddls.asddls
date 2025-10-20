@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '獨立需求上傳 Projection View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZZ1_PV_INDEP_REQ as projection on ZZ1_I_INDEP_REQ
{
    key indep_uuid,
      @UI: {
             lineItem: [{ position:10    }]      
      }
      @EndUserText.label: '工廠'         
    Werks,
    Machine,
      @UI: {
             lineItem: [{ position:20    }]      
      }
      @EndUserText.label: '料號'         
    Matnr,
    Total,  
    @EndUserText.label: '日期1'    
    Date1,
    @EndUserText.label: '日期2'    
    Date2,     
    @EndUserText.label: '日期3' 
    Date3,
    @EndUserText.label: '日期4' 
    Date4,
    @EndUserText.label: '日期5' 
    Date5,
    @EndUserText.label: '日期6' 
    Date6,
    @EndUserText.label: '日期7' 
    Date7,
    @EndUserText.label: '日期8' 
    Date8,
    @EndUserText.label: '日期9' 
    Date9,
    @EndUserText.label: '日期10' 
    Date10,
    @EndUserText.label: '日期11' 
    Date11,
    @EndUserText.label: '日期12' 
    Date12,
    @EndUserText.label: '日期13' 
    Date13,
    @EndUserText.label: '日期14' 
    Date14,
    @EndUserText.label: '日期15' 
    Date15,
    @EndUserText.label: '日期16' 
    Date16,
    @EndUserText.label: '日期17' 
    Date17,
    @EndUserText.label: '日期18' 
    Date18,
    @EndUserText.label: '日期19' 
    Date19,
    @EndUserText.label: '日期20' 
    Date20,
    @EndUserText.label: '日期21' 
    Date21,
    @EndUserText.label: '日期22' 
    Date22,
    @EndUserText.label: '日期23' 
    Date23,
    @EndUserText.label: '日期24' 
    Date24,
    @EndUserText.label: '日期25' 
    Date25,
    @EndUserText.label: '日期26' 
    Date26,
    @EndUserText.label: '日期27' 
    Date27,
    @EndUserText.label: '日期28' 
    Date28,
    @EndUserText.label: '日期29' 
    Date29,
    @EndUserText.label: '日期30' 
    Date30,
    @EndUserText.label: '日期31' 
    Date31,
    @EndUserText.label: '日期32' 
    Date32,
    @EndUserText.label: '日期33' 
    Date33,
    @EndUserText.label: '日期34' 
    Date34,
    @EndUserText.label: '日期35' 
    Date35,
    @EndUserText.label: '日期36' 
    Date36,
    @EndUserText.label: '日期37' 
    Date37,
    @EndUserText.label: '日期38' 
    Date38,
    @EndUserText.label: '日期39' 
    Date39,
    @EndUserText.label: '日期40' 
    Date40,
    @EndUserText.label: '日期41' 
    Date41,
    @EndUserText.label: '日期42' 
    Date42,
    @EndUserText.label: '日期43' 
    Date43,
    @EndUserText.label: '日期44' 
    Date44,
    @EndUserText.label: '日期45' 
    Date45,
    @EndUserText.label: '日期46' 
    Date46,
    @EndUserText.label: '日期47' 
    Date47,
    @EndUserText.label: '日期48' 
    Date48,
    @EndUserText.label: '日期49' 
    Date49,
    @EndUserText.label: '日期50' 
    Date50,
    @EndUserText.label: '日期51' 
    Date51,
    @EndUserText.label: '日期52' 
    Date52,
    @EndUserText.label: '日期53' 
    Date53,
    @EndUserText.label: '日期54' 
    Date54,
    @EndUserText.label: '日期55' 
    Date55,
    @EndUserText.label: '日期56' 
    Date56,
    @EndUserText.label: '日期57' 
    Date57,
    @EndUserText.label: '日期58' 
    Date58,
    @EndUserText.label: '日期59' 
    Date59,
    @EndUserText.label: '日期60' 
    Date60,
      @UI: {
             lineItem: [{ position:30    }]      
      }
      @EndUserText.label: '訊息'         
    Msg,
      @UI: {
             lineItem: [{ position:40    }]      
      }
      @EndUserText.label: '寫入日期'       
    insert_date,
      @UI: {
             lineItem: [{ position:50    }]      
      }
      @EndUserText.label: '寫入時間'       
    insert_time,
      @UI: {
             lineItem: [{ position:60    }]      
      }
      @EndUserText.label: '建立者'       
    insert_user
}
