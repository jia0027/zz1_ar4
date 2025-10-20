@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM資料拋轉MES'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZZ1_I_BOM 
    with parameters
        @Environment.systemField: #SYSTEM_DATE
        P_KeyDate : sydate
    as select from I_MaterialBOMLink as a
    left outer join I_BOMComponentWithKeyDate( P_KeyDate : $parameters.P_KeyDate ) as b  on b.BillOfMaterial = a.BillOfMaterial and b.BillOfMaterialVariant = a.BillOfMaterialVariant
    left outer join I_BillOfMaterialHeaderDEX_2 as c on c.BillOfMaterialCategory = b.BillOfMaterialCategory  and c.BillOfMaterial = a.BillOfMaterial and c.BillOfMaterialVariant = a.BillOfMaterialVariant
{
    key a.BillOfMaterial,
    key a.BillOfMaterialVariant, //替代BOM群組
    key a.Material,
    key a.Plant,
    key a.BillOfMaterialVariantUsage, //BOM使用
    key b.BillOfMaterialCategory,
    key b.BillOfMaterialItemNodeNumber,
    b.BillOfMaterialComponent, //元件
    b.AlternativeItemGroup, //替代項目群組
    b.AlternativeItemPriority, //優先順序
    b.BillOfMaterialItemUnit, //單位
    @Semantics.quantity.unitOfMeasure: 'BillOfMaterialItemUnit'
    b.BillOfMaterialItemQuantity, //元件用量
    b.BOMItemRecordCreationDate, //元件建立紀錄
    b.BOMItemLastChangeDate, //元件最後修改日期
    b.LastChangeDateTime, //最後修改日期時間
    c.BOMIsArchivedForDeletion //刪除旗標
}
