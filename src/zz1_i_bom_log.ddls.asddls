@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM資料拋轉MES LOG'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZZ1_I_BOM_LOG as select from zz1_bom_log
{
    key part_no,
    key item_part_no,
    key plant,
    key serial_no,
    data_status,
    item_group,
    item_group_index,
    unit,
    item_count,
    process_date,
    process_time,
    process_user,
    update_status,
    message
}
