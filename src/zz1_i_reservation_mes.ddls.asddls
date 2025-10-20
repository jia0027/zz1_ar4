@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '預留單拋轉MES'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZZ1_I_RESERVATION_MES as select from I_ReservationDocumentHeader as head
    left outer join I_ReservationDocumentItem as item on head.Reservation = item.Reservation
    left outer join I_MaterialDocumentItem_2 as mseg on item.Reservation = mseg.Reservation and item.ReservationItem = mseg.ReservationItem 
    left outer join I_MfgOrderOperationComponent as mo on mo.Reservation = item.Reservation and mo.ReservationItem = item.ReservationItem
{
    key head.Reservation , //預留單號
    key item.ReservationItem  , //預留單項次
    key item.RecordType,
    cast('' as abap.char(4)) as order_type, //單據類別
    head.IssuingOrReceivingPlant , //廠別 (目標工廠)
    head.CostCenter,//成本中心
    cast('' as abap.char(10)) as reason_code,//原因代碼
    head.GoodsMovementType,//異動類型
    cast('' as abap.char(10)) as dept_id,//單據部門
    item.Supplier,//供應商
    cast('' as abap.char(10)) as from_erp,//是否來自ERP
    cast('' as abap.char(10)) as upload_erp,//是否拋ERP
    cast('' as abap.char(10)) as status,//單據狀態
    head.GoodsRecipientName,//文件表頭內文
    cast('' as abap.char(10)) as mvt_reason,//異動類型(用戶選擇)
    cast('' as abap.char(10)) as receipt_no,//發票號碼
    head.OrderID,//關聯單號
    cast('' as abap.char(10)) as create_userid,//建單人
    head.ReservationDate,//預留日期
    cast('' as abap.char(10)) as update_userid,//異動人
    cast('' as abap.char(10)) as update_time,//異動人 
    cast('' as abap.char(10)) as close_time,//單據關閉時間
    cast('' as abap.char(10)) as enabled,//是否啟用
    item.ReservationItemText,//備註
    item.PurchasingDocument,//採購單號
    item.PurchasingDocumentItem, //採購項次
    cast('' as abap.char(10)) as sap_order_no,//ERP單據回寫
    cast('' as abap.char(10)) as sap_doc_year,//SAP文件年度
    cast('' as abap.char(10)) as customs_no,//報關單號
    item.Product, //物料
    item.BaseUnit,
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    item.ResvnItmRequiredQtyInBaseUnit, //需求數量
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    item.ResvnItmWithdrawnQtyInBaseUnit, //已發數量
    cast('' as abap.char(10)) as pdline_id,//線別
    cast('' as abap.char(10)) as machine_id,//機台
    cast('' as abap.char(10)) as station_no,//站位
    mo.ManufacturingOrderOperation_2, //製程
    item.Plant ,//來源工廠
    item.StorageLocation ,//來源儲存地點
    item.IssuingOrReceivingStorageLoc,  //目標儲存地點
    cast('' as abap.char(10)) as overissue_flag, //是否允許超發
    cast('' as abap.char(10)) as document_no, //ERP庫存單號
    cast('' as abap.char(10)) as document_year //物料文件年度

}
