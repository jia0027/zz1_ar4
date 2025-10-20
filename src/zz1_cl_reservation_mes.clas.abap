CLASS zz1_cl_reservation_mes DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    INTERFACES if_apj_dt_exec_object.
    INTERFACES if_apj_rt_exec_object.
    DATA: w_pass TYPE string VALUE 'TIMESHEETRECORD@Innatech003',"未建立
          w_clientd(3) VALUE 'N8M',"未建立
          w_clientt(3) VALUE 'N8X',"未建立
          w_clientp(3) VALUE 'PHK'."未建立
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZZ1_CL_RESERVATION_MES IMPLEMENTATION.


    METHOD if_apj_dt_exec_object~get_parameters.

    " Return the supported selection parameters here
    et_parameter_def = VALUE #(

      ( selname = 'P_CLNT' kind = if_apj_dt_exec_object=>parameter datatype = 'C' length = 3 param_text =
        '環境' changeable_ind = abap_true )"DEV QAS PRD
    ).
    et_parameter_def = VALUE #(
        ( selname = 'S_DATE' kind = if_apj_dt_exec_object=>select_option datatype = 'D' length = 8 param_text =
        '日期' changeable_ind = abap_true )
    ).
    " Return the default parameters values here
    et_parameter_val = VALUE #(
    "  ( selname = 'S_ID' kind = if_apj_dt_exec_object=>select_option sign = 'I' option = 'EQ' low = '1001'  )
      ( selname = 'S_DATE' kind = if_apj_dt_exec_object=>select_option sign = 'I' option = 'BT' low = cl_abap_context_info=>get_system_date( )  high = cl_abap_context_info=>get_system_date( ) )
    "  ( selname = 'P_SIMUL' kind = if_apj_dt_exec_object=>parameter sign = 'I' option = 'EQ' low =
    "    abap_true )
     ).

    ENDMETHOD.


    METHOD if_apj_rt_exec_object~execute.
    "Execution logic when the job is started
    DATA p_clnt TYPE c LENGTH 3.
    DATA: s_date TYPE RANGE OF d,
        a(2).
    DATA: l_headurl TYPE string .
    DATA: l_patchurl TYPE string .

    DATA: l_password TYPE string ,
          l_name TYPE string.
    DATA: l_url TYPE string.
    DATA: l_body TYPE string.
    DATA: lwa_header TYPE if_web_http_request=>name_value_pair,
           lt_header  TYPE if_web_http_request=>name_value_pairs.
    DATA: l_status TYPE if_web_http_response=>http_status .
    DATA: l_text TYPE string.

    DATA: lr_http_destination TYPE REF TO if_http_destination.
    DATA: lr_web_http_client TYPE REF TO if_web_http_client.
    DATA: lr_request TYPE REF TO if_web_http_request.
    DATA: lr_response TYPE REF TO if_web_http_response.
    DATA: lwa_head TYPE zz1_i_reservation_mes,
          lwa_item TYPE zz1_i_reservation_mes,
          lt_head  TYPE STANDARD TABLE OF zz1_i_reservation_mes,
          lt_item  TYPE STANDARD TABLE OF zz1_i_reservation_mes,
          lt_zutt01 TYPE STANDARD TABLE OF zz1_reser_log,
          l_num TYPE zz1_reser_log-serial_no ,
          lwa_zutt01 TYPE zz1_reser_log,
          l_date TYPE zz1_reser_log-process_date,
          l_time TYPE zz1_reser_log-process_time,
          l_process_date TYPE zz1_reser_log-process_date,
          l_process_time TYPE zz1_reser_log-process_time,
          l_check(1).

    DATA: l_err type string..
    DATA: cx_root TYPE REF TO cx_root.
    DATA: l_timestamp TYPE p.
    DATA: l_timestampf TYPE p.
    DATA: l_timestampul TYPE tzntstmpl.
    DATA: l_timestampus TYPE tzntstmps.
    DATA: l_tokenx TYPE xstring.
    DATA: l_keyx TYPE xstring.
    DATA: l_ivx TYPE xstring.
    DATA: l_cipher TYPE string.
    DATA: l_cipherx TYPE xstring.
    DATA: l_len TYPE i.
    DATA: l_res_json TYPE string.
    DATA: l_res_jsonx TYPE xstring.
    DATA: l_req_json TYPE string.
    DATA: l_req_jsonx TYPE xstring.
    DATA: l_req_ns_json TYPE string.
    DATA: l_req_ns_jsonx TYPE xstring.
    DATA:l_text2(200).
    " Getting the actual parameter values(Just for show. Not needed for the logic below)
      LOOP AT it_parameters INTO DATA(ls_parameter).
          CASE ls_parameter-selname.

            WHEN 'P_CLNT'.
                p_clnt = ls_parameter-low.
            WHEN 'S_DATE'.
               APPEND VALUE #( sign = ls_parameter-sign
                               option = ls_parameter-option
                               low = ls_parameter-low
                               high = ls_parameter-high ) TO s_date.
          ENDCASE.
      ENDLOOP.
      try.
          data(l_log) = cl_bali_log=>create_with_header( cl_bali_header_setter=>create( object =
                           'ZZ1_RESERVATION_LOG' subobject = 'ZZ1_RESERVATION' ) ).
      catch cx_bali_runtime.
           "handle exception
           a = 2.
      ENDTRY.

    DATA:BEGIN OF  lwa_data1,
          ORDER_NO(20),
          order_type(20),
          FACTORY_NAME(20),
          Cost_Center(30),
          reason_code(100),
          mvt(20),
          dept_id(10),
          VENDOR_ID(30),
          from_erp(10),
          upload_erp(1),
          status(2),
          DOCUMENT_CONTEXT(500),
          mvt_reason(50),
          receipt_no(100),
          RELATION_ORDER(50),
          create_userid(30),
          create_TIME(8),
          update_userid(30),
          UPDATE_TIME(8),
          close_time(8),
          enabled(10),
          REMARK(500),
          po(40),
          po_item(20),
          sap_order_no(50),
          sap_doc_year(4),
          customs_no(100),
      END OF lwa_data1 ,
      lt_data LIKE STANDARD TABLE OF lwa_data1,
      BEGIN OF lwa_data2,
          ORDER_NO(20),
          item_seq(6),
          PartNO(25),
          ISSUE_QTY(10),
          ACTUAL_QTY(10),
          work_order(10),
          pdline_id(20),
          machine_id(20),
          station_no(20),
          PROCESS_ID(20),
          SOURCE_PLANT(20),
          SOURCE_WHID(20),
          SOURCE_LOCID(20),
          TARGET_PLANT(20),
          TARGET_WHID(20),
          TARGET_LOCID(20),
          update_userid(30),
          UPDATE_TIME(8),
          remark(200),
          enabled(10),
          overissue_flag(1),
          document_no(30),
          document_year(30),
          status(2),
          emp_no(20),
          po(50),
          po_item(10),
      END OF lwa_data2,
      lwa_log TYPE ZZ1_UTT01,
      lt_log TYPE STANDARD TABLE OF zz1_utt01.
      SELECT * FROM  zz1_i_reservation_mes WHERE  ReservationDate IN @s_date
        INTO CORRESPONDING FIELDS OF TABLE @lt_item.
      lt_head = lt_item.
      DELETE ADJACENT DUPLICATES FROM lt_head COMPARING reservation.
      IF lt_item IS INITIAL."沒資料
        DATA(l_success_text2) = cl_bali_free_text_setter=>create( severity =
                        if_bali_constants=>C_SEVERITY_STATUS "c_severity_error
                        text = '無可執行之資料' ).
        try.
          l_log->add_item( item = l_success_text2 ).
        catch cx_bali_runtime.
          a = 2.
        endtry.
      ELSE. "call api
          LOOP AT lt_head INTO lwa_head.
              clear : lwa_data1.
              lwa_data1-order_no = lwa_head-reservation.
              lwa_data1-order_type = lwa_head-order_type .
              lwa_data1-factory_name = lwa_head-issuingOrReceivingPlant.
              lwa_data1-Cost_Center = lwa_head-CostCenter.
              lwa_data1-reason_code = lwa_head-reason_code.
              lwa_data1-mvt = lwa_head-GoodsMovementType.
              lwa_data1-dept_id = lwa_head-dept_id.
              lwa_data1-vendor_id = lwa_head-Supplier.
              lwa_data1-from_erp = lwa_head-from_erp.
              lwa_data1-upload_erp = lwa_head-upload_erp.
              lwa_data1-status = lwa_head-status.
              lwa_data1-document_context = lwa_head-GoodsRecipientName.
              lwa_data1-mvt_reason = lwa_head-mvt_reason.
              lwa_data1-receipt_no = lwa_head-receipt_no.
              lwa_data1-relation_order = lwa_head-OrderID.
              lwa_data1-create_userid = lwa_head-create_userid.
              lwa_data1-create_time = lwa_head-ReservationDate.
              lwa_data1-update_userid = lwa_head-update_userid.
              lwa_data1-update_time = lwa_head-update_time.
              lwa_data1-close_time = lwa_head-close_time.
              lwa_data1-enabled = lwa_head-enabled.
              lwa_data1-remark = lwa_head-ReservationItemText.
              lwa_data1-po = lwa_head-PurchasingDocument.
              lwa_data1-po_item = lwa_head-PurchasingDocumentItem.
              lwa_data1-sap_order_no = lwa_head-sap_order_no.
              lwa_data1-sap_doc_year = lwa_head-sap_doc_year.
              lwa_data1-customs_no = lwa_head-customs_no.
            "將資料轉成JSON
              l_req_json = /ui2/cl_json=>serialize( data = lwa_data1 pretty_name = /ui2/cl_json=>pretty_mode-low_case ).
              FREE: lr_http_destination, lr_web_http_client, lr_request, lr_response.
              try.
                 lr_http_destination = cl_http_destination_provider=>create_by_url( i_url = l_url ).
              catch cx_http_dest_provider_error INTO DATA(lr_data).
                a = 2.
              ENDTRY.

              try.
                lr_web_http_client = cl_web_http_client_manager=>create_by_http_destination( i_destination = lr_http_destination ).
              catch cx_web_http_client_error INTO DATA(lr_data2).
                a = 2.
              ENDTRY.
              lr_request = lr_web_http_client->get_http_request( ).
              CLEAR: lwa_header , lt_header.
              lwa_header-name = 'Content-Type'.
              lwa_header-value = 'Application/JSON'.
              APPEND lwa_header TO lt_header.
              lr_request->set_header_fields( i_fields = lt_header ).
              lr_request->set_text( i_text = l_req_json ).
              try.
                lr_response = lr_web_http_client->execute( i_method = if_web_http_client=>post ).
              catch cx_web_http_client_error INTO lr_data2.
                a = 2.
              ENDTRY.
              IF lr_response IS BOUND.
                l_status = lr_response->get_status( ).
                l_text = lr_response->get_text( ).
                try.
                  lr_web_http_client->close( ).
                catch cx_web_http_client_error INTO lr_data2.
                  a = 2.
                ENDTRY.
              ENDIF.
              IF l_status-code NE 200."取錯誤
                l_check = 'X'.
              ELSE. "正確
                  LOOP AT lt_item INTO lwa_item WHERE reservation = lwa_head-reservation.
                      clear : lwa_data2.
                      lwa_data2-ORDER_NO = lwa_item-reservation.
                      lwa_data2-item_seq = lwa_item-ReservationItem.
                      lwa_data2-partno = lwa_item-Product.
                      lwa_data2-issue_qty =  lwa_item-ResvnItmRequiredQtyInBaseUnit.
                      lwa_data2-actual_qty = lwa_item-ResvnItmWithdrawnQtyInBaseUnit.
                      lwa_data2-work_order = lwa_item-OrderID.
                      lwa_data2-pdline_id = lwa_item-pdline_id.
                      lwa_data2-machine_id = lwa_item-machine_id.
                      lwa_data2-station_no = lwa_item-station_no.
                      lwa_data2-process_id = lwa_item-ManufacturingOrderOperation_2.
                      lwa_data2-source_plant = lwa_item-Plant.
                      lwa_data2-source_whid = ''.
                      lwa_data2-source_locid = ''.
                      lwa_data2-target_plant = lwa_item-IssuingOrReceivingPlant.
                      lwa_data2-target_whid = ''.
                      lwa_data2-target_locid = lwa_item-IssuingOrReceivingStorageLoc.
                      lwa_data2-update_userid = lwa_item-update_userid.
                      lwa_data2-UPDATE_TIME = lwa_item-update_time.
                      lwa_data2-remark = lwa_item-ReservationItemText.
                      lwa_data2-enabled = lwa_item-enabled.
                      lwa_data2-overissue_flag = lwa_item-overissue_flag.
                      lwa_data2-document_no = lwa_item-document_no.
                      lwa_data2-document_year = lwa_item-document_year.
                      lwa_data2-status = lwa_item-status.
                      lwa_data2-emp_no =  ''.
                      lwa_data2-po = lwa_item-PurchasingDocument.
                      lwa_data2-po_item = lwa_item-PurchasingDocumentItem.
                    "將資料轉成JSON
                      l_req_json = /ui2/cl_json=>serialize( data = lwa_data2 pretty_name = /ui2/cl_json=>pretty_mode-low_case ).
                      FREE: lr_http_destination, lr_web_http_client, lr_request, lr_response.
                      try.
                         lr_http_destination = cl_http_destination_provider=>create_by_url( i_url = l_url ).
                      catch cx_http_dest_provider_error INTO lr_data.
                        a = 2.
                      ENDTRY.

                      try.
                        lr_web_http_client = cl_web_http_client_manager=>create_by_http_destination( i_destination = lr_http_destination ).
                      catch cx_web_http_client_error INTO lr_data2.
                        a = 2.
                      ENDTRY.
                      lr_request = lr_web_http_client->get_http_request( ).
                      CLEAR: lwa_header , lt_header.
                      lwa_header-name = 'Content-Type'.
                      lwa_header-value = 'Application/JSON'.
                      APPEND lwa_header TO lt_header.
                      lr_request->set_header_fields( i_fields = lt_header ).
                      lr_request->set_text( i_text = l_req_json ).
                      try.
                        lr_response = lr_web_http_client->execute( i_method = if_web_http_client=>post ).
                      catch cx_web_http_client_error INTO lr_data2.
                        a = 2.
                      ENDTRY.
                      IF lr_response IS BOUND.
                        l_status = lr_response->get_status( ).
                        l_text = lr_response->get_text( ).
                        try.
                          lr_web_http_client->close( ).
                        catch cx_web_http_client_error INTO lr_data2.
                          a = 2.
                        ENDTRY.
                      ENDIF.
                      IF l_status-code NE 200."取錯誤
                        l_check = 'X'.
                      ELSE. "正確
                      ENDIF.
                      CLEAR: lwa_zutt01 , l_num.
                      lwa_zutt01-reservation = lwa_item-Reservation.
                      lwa_zutt01-reservationitem = lwa_item-reservationitem.
                      lwa_zutt01-client = sy-mandt.
                      SELECT SINGLE MAX( serial_no ) FROM zz1_reser_log WHERE Reservation = @lwa_item-Reservation AND reservationitem = @lwa_item-Reservationitem INTO @l_num."
                      lwa_zutt01-serial_no = l_num + 1 .
                      lwa_zutt01-process_date  = l_process_date  .
                      lwa_zutt01-process_time  = l_process_time.
                      lwa_zutt01-process_user = sy-uname .

                      Clear: l_text2.
                      IF l_check = 'X'.
                        lwa_zutt01-update_status = 'F'."FAIL.
                        lwa_zutt01-message = l_status-reason.
                        CONCATENATE '預留單資料傳送失敗:' lwa_item-Reservation INTO l_text2.
                        l_success_text2 = cl_bali_free_text_setter=>create( severity =
                                  if_bali_constants=>C_SEVERITY_ERROR "c_severity_error
                                  text = l_text2 ).
                        try.
                          l_log->add_item( item = l_success_text2 ).
                        catch cx_bali_runtime.
                          a = 2.
                        endtry.
                      ELSE.
                        lwa_zutt01-update_status = 'S'."Success.
                        CONCATENATE '已傳送預留單:' lwa_head-Reservation INTO l_text2.
                        l_success_text2 = cl_bali_free_text_setter=>create( severity =
                                   if_bali_constants=>C_SEVERITY_STATUS "c_severity_error
                                   text = l_text2 ).
                       try.
                          l_log->add_item( item = l_success_text2 ).
                       catch cx_bali_runtime.
                          a = 2.
                        endtry.
                      ENDIF.
                      APPEND lwa_zutt01 TO lt_zutt01.
                  ENDLOOP.
              ENDIF.

          ENDLOOP.
          MODIFY zz1_reser_log FROM TABLE @lt_zutt01.
      ENDIF.
      TRY.
        cl_bali_log_db=>get_instance( )->save_log( log = l_log assign_to_current_appl_job = abap_true ).
      CATCH cx_bali_runtime.
          a = 2.
          "handle exception
      ENDTRY.
      COMMIT WORK.
    ENDMETHOD.


    METHOD if_oo_adt_classrun~main.
    ENDMETHOD.
ENDCLASS.
