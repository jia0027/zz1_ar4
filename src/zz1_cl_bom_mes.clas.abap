CLASS zz1_cl_bom_mes DEFINITION
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



CLASS ZZ1_CL_BOM_MES IMPLEMENTATION.


    METHOD if_apj_dt_exec_object~get_parameters.
        " Return the supported selection parameters here
        et_parameter_def = VALUE #(

          ( selname = 'P_ALL' kind = if_apj_dt_exec_object=>parameter datatype = 'C' length = 3 param_text =
            '全部執行' changeable_ind = abap_true )
          ( selname = 'P_DATE' kind = if_apj_dt_exec_object=>parameter datatype = 'D' length = 8 param_text =
            '日期' changeable_ind = abap_true )
        ).
*        et_parameter_def = VALUE #(
*            ( selname = 'P_DATE' kind = if_apj_dt_exec_object=>select_option datatype = 'D' length = 8 param_text =
*            '日期' changeable_ind = abap_true )
*        ).
        " Return the default parameters values here
        et_parameter_val = VALUE #(
        "  ( selname = 'S_ID' kind = if_apj_dt_exec_object=>select_option sign = 'I' option = 'EQ' low = '1001'  )
          ( selname = 'P_DATE' kind = if_apj_dt_exec_object=>parameter sign = 'I' option = 'EQ' low = cl_abap_context_info=>get_system_date( ) )
          ( selname = 'P_ALL' kind = if_apj_dt_exec_object=>parameter sign = 'I' option = 'EQ' low = abap_false )
         ).
    ENDMETHOD.


    METHOD if_apj_rt_exec_object~execute.
    "Execution logic when the job is started
    DATA P_ALL TYPE c LENGTH 3.
    DATA P_date TYPE d.
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
    DATA: lwa_head TYPE zz1_i_bom,
          lt_head  TYPE STANDARD TABLE OF zz1_i_bom,
          lt_log TYPE STANDARD TABLE OF zz1_bom_log,
          l_num TYPE zz1_bom_log-serial_no ,
          lwa_log TYPE zz1_bom_log,
          lwa_log2 TYPE zz1_bom_log,
          lt_log2 TYPE STANDARD TABLE OF zz1_bom_log,
          l_date TYPE zz1_bom_log-process_date,
          l_time TYPE zz1_bom_log-process_time,
          l_time2 TYPE string,
          l_date2 TYPE string,
          l_process_date TYPE zz1_bom_log-process_date,
          l_process_time TYPE zz1_bom_log-process_time,
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
      LOOP AT it_parameters INTO DATA(ls_parameter).
          CASE ls_parameter-selname.

            WHEN 'P_ALL'.
                P_ALL = ls_parameter-low.
            WHEN 'P_DATE'.
                p_date = ls_parameter-low.
*               APPEND VALUE #( sign = ls_parameter-sign
*                               option = ls_parameter-option
*                               low = ls_parameter-low
*                               high = ls_parameter-high ) TO s_date.
          ENDCASE.
      ENDLOOP.
      try.
          data(l_log) = cl_bali_log=>create_with_header( cl_bali_header_setter=>create( object =
                           'ZZ1_BOM_LOG' subobject = 'ZZ1_BOM' ) ).
      catch cx_bali_runtime.
           "handle exception
           a = 2.
      ENDTRY.
    DATA:
      BEGIN OF  lwa_eBOMDetail,
          ITEM_PART_NO(30),
          ITEM_GROUP(10),
          ITEM_GROUP_INDEX(2),
          ITEM_COUNT(22),
          PROCESS_NAME(25),
          VERSION(16),
          LOCATION(1000),
          SATGE_Flag(10),
          BOM_LEVEL(20),
          Data_Status(1),
      END OF lwa_eBOMDetail ,
      BEGIN OF  lwa_data1,
          PART_NO(30),
          ITEM_BOM_ID(20),
          VERSION(10),
          PLANT(4),
          eBOMDetail LIKE STANDARD TABLE OF lwa_eBOMDetail,
      END OF lwa_data1 ,
      lt_data1 LIKE STANDARD TABLE OF lwa_data1,
      lwa_bom TYPE zz1_i_bom,
      lwa_bom2 TYPE zz1_i_bom,
      lwa_bom3 TYPE zz1_i_bom,
      lt_bom TYPE STANDARD TABLE OF zz1_i_bom,
      lt_bom2 TYPE STANDARD TABLE OF zz1_i_bom,
      lt_bom3 TYPE STANDARD TABLE OF zz1_i_bom.
    DATA:lwa_object TYPE ZZ1_I_ObjectCharacteristics,
         lt_object TYPE STANDARD TABLE OF ZZ1_I_ObjectCharacteristics.
    SELECT * FROM ZZ1_I_ObjectCharacteristics WHERE ClfnObjectTable = 'MARA' AND Class = 'Z_MATERIAL_CL01' AND Characteristic = 'Z_MY_MC_106'
        INTO CORRESPONDING FIELDS OF TABLE @lt_object.
    SELECT * FROM zz1_i_bom INTO CORRESPONDING FIELDS OF TABLE @lt_bom.
    SORT lt_bom BY Material plant BillOfMaterialComponent.
    lt_bom2 = lt_bom.
    DELETE ADJACENT DUPLICATES FROM lt_bom2 COMPARING Material plant.
    lt_bom3 = lt_bom.
    SORT lt_bom3 BY Material plant AlternativeItemGroup AlternativeItemPriority DESCENDING.
    DELETE ADJACENT DUPLICATES FROM lt_bom3 COMPARING Material plant AlternativeItemGroup.
    SELECT * FROM zz1_i_bom_log INTO CORRESPONDING FIELDS OF TABLE @lt_log.
    SORT lt_log BY part_no item_part_no serial_no DESCENDING.
    DELETE ADJACENT DUPLICATES FROM lt_log COMPARING part_no item_part_no.
    l_date = sy-datum.
    l_time = sy-uzeit.
    LOOP AT lt_bom2 INTO lwa_bom2.
        CLEAR : lwa_data1.
        lwa_data1-part_no = lwa_bom2-Material.
        lwa_data1-plant = lwa_bom2-Plant.
        LOOP AT lt_bom INTO lwa_bom WHERE Material = lwa_bom2-Material AND plant = lwa_bom2-Plant .
            CLEAR : lwa_log,lwa_eBOMDetail,lwa_log2,lwa_object.
            READ TABLE lt_object INTO lwa_object WITH KEY ClfnObjectID = lwa_bom-BillOfMaterialComponent.
            IF lwa_object-CharcValue = '3'.
                CONTINUE.
            ENDIF.
            IF P_ALL IS NOT INITIAL.
                READ TABLE lt_log INTO lwa_log WITH KEY part_no = lwa_bom-Material plant = lwa_bom-Plant item_part_no = lwa_bom-BillOfMaterialComponent.
                IF sy-subrc IS INITIAL.
                    l_time2 = lwa_bom-LastChangeDateTime.
                    IF (  lwa_log-process_date >= l_time2+0(8) AND lwa_log-process_time >= l_time2+8(6) )  AND ( lwa_log-process_date <= l_date AND lwa_log-process_time <= l_time ).
                    ELSE.
                        CONTINUE.
                    ENDIF.
                ELSE.
                ENDIF.
            ENDIF.
            IF lwa_log-data_status IS INITIAL.
                lwa_eBOMDetail-data_status = '1'.
            ELSEIF lwa_log-data_status = '1' OR lwa_log-data_status = '2'.
                lwa_eBOMDetail-data_status = '2'.
            ELSEIF lwa_bom-BOMIsArchivedForDeletion IS NOT INITIAL.
                lwa_eBOMDetail-data_status = '3'.
            ENDIF.
            lwa_eBOMDetail-item_part_no = lwa_bom-BillOfMaterialComponent.
            lwa_eBOMDetail-item_group = lwa_bom-AlternativeItemGroup.
            READ TABLE lt_bom3 WITH KEY Material = lwa_bom-Material  plant = lwa_bom-Plant BillOfMaterialComponent = lwa_bom-BillOfMaterialComponent
             AlternativeItemGroup = lwa_bom-AlternativeItemGroup AlternativeItemPriority = lwa_bom-AlternativeItemPriority TRANSPORTING NO FIELDS.
            IF sy-subrc IS INITIAL.
                lwa_eBOMDetail-item_group_index = 'Y'.
            ELSE.
                lwa_eBOMDetail-item_group_index = 'N'.
            ENDIF.
            lwa_eBOMDetail-item_count = lwa_bom-BillOfMaterialItemQuantity.
            APPEND lwa_eBOMDetail TO lwa_data1-ebomdetail.
            MOVE-CORRESPONDING lwa_ebomdetail TO lwa_log2.
            CLEAR: l_num.
            lwa_log2-unit = lwa_bom-BillOfMaterialItemUnit.
            lwa_log2-client = sy-mandt.
            SELECT SINGLE MAX( serial_no ) FROM zz1_bom_log WHERE part_no = @lwa_bom-Material AND item_part_no = @lwa_bom-BillOfMaterialComponent AND plant = @lwa_bom-Plant INTO @l_num."
            lwa_log2-serial_no = l_num + 1 .
            lwa_log2-process_date  = l_date  .
            lwa_log2-process_time  = l_time.
            lwa_log2-process_user = sy-uname.
            APPEND lwa_log2 to lt_log2.
        ENDLOOP.

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
        IF l_status-code = 200.
            lwa_log2-update_status = 'S'.
        ELSE.
            lwa_log2-update_status = 'F'.
            lwa_log2-message = l_status-reason.
        ENDIF.
        MODIFY lt_log2 FROM lwa_log2 TRANSPORTING update_status message WHERE part_no = lwa_bom2-Material AND plant = lwa_bom2-Plant.
    ENDLOOP.
    MODIFY zz1_bom_log FROM TABLE @lt_log2.
    ENDMETHOD.


    METHOD if_oo_adt_classrun~main.
        "Execution logic when the job is started
        DATA P_ALL TYPE c LENGTH 3.
        DATA P_date TYPE d.
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
        DATA: lwa_head TYPE zz1_i_bom,
              lt_head  TYPE STANDARD TABLE OF zz1_i_bom,
              lt_log TYPE STANDARD TABLE OF zz1_bom_log,
              l_num TYPE zz1_bom_log-serial_no ,
              lwa_log TYPE zz1_bom_log,
              lwa_log2 TYPE zz1_bom_log,
              lt_log2 TYPE STANDARD TABLE OF zz1_bom_log,
              l_date TYPE zz1_bom_log-process_date,
              l_time TYPE zz1_bom_log-process_time,
              l_time2 TYPE string,
              l_date2 TYPE string,
              l_process_date TYPE zz1_bom_log-process_date,
              l_process_time TYPE zz1_bom_log-process_time,
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
*          DELETE FROM zz1_bom_log WHERE process_date = @sy-datum.
          try.
              data(l_log) = cl_bali_log=>create_with_header( cl_bali_header_setter=>create( object =
                               'ZZ1_BOM_LOG' subobject = 'ZZ1_BOM' ) ).
          catch cx_bali_runtime.
               "handle exception
               a = 2.
          ENDTRY.
        DATA:
          BEGIN OF  lwa_eBOMDetail,
              ITEM_PART_NO(30),
              ITEM_GROUP(10),
              ITEM_GROUP_INDEX(2),
              ITEM_COUNT(22),
              PROCESS_NAME(25),
              VERSION(16),
              LOCATION(1000),
              SATGE_Flag(10),
              BOM_LEVEL(20),
              Data_Status(1),
          END OF lwa_eBOMDetail ,
          BEGIN OF  lwa_data1,
              PART_NO(30),
              ITEM_BOM_ID(20),
              VERSION(10),
              PLANT(4),
              eBOMDetail LIKE STANDARD TABLE OF lwa_eBOMDetail,
          END OF lwa_data1 ,
          lt_data1 LIKE STANDARD TABLE OF lwa_data1,
          lwa_bom TYPE zz1_i_bom,
          lwa_bom2 TYPE zz1_i_bom,
          lwa_bom3 TYPE zz1_i_bom,
          lt_bom TYPE STANDARD TABLE OF zz1_i_bom,
          lt_bom2 TYPE STANDARD TABLE OF zz1_i_bom,
          lt_bom3 TYPE STANDARD TABLE OF zz1_i_bom.
        DATA:lwa_object TYPE ZZ1_I_ObjectCharacteristics,
             lt_object TYPE STANDARD TABLE OF ZZ1_I_ObjectCharacteristics.
        SELECT * FROM ZZ1_I_ObjectCharacteristics WHERE ClfnObjectTable = 'MARA' AND Class = 'Z_MATERIAL_CL01' AND Characteristic = 'Z_MY_MC_106'
            INTO CORRESPONDING FIELDS OF TABLE @lt_object.
        SELECT * FROM zz1_i_bom INTO CORRESPONDING FIELDS OF TABLE @lt_bom.
        SORT lt_bom BY Material plant BillOfMaterialComponent.
        lt_bom2 = lt_bom.
        DELETE ADJACENT DUPLICATES FROM lt_bom2 COMPARING Material plant.
        lt_bom3 = lt_bom.
        SORT lt_bom3 BY Material plant AlternativeItemGroup AlternativeItemPriority DESCENDING.
        DELETE ADJACENT DUPLICATES FROM lt_bom3 COMPARING Material plant AlternativeItemGroup.
        SELECT * FROM zz1_bom_log INTO CORRESPONDING FIELDS OF TABLE @lt_log.
        SORT lt_log BY part_no plant item_part_no serial_no DESCENDING.
        DELETE ADJACENT DUPLICATES FROM lt_log COMPARING part_no plant item_part_no.
        l_date = sy-datum.
        l_time = sy-uzeit.
        LOOP AT lt_bom2 INTO lwa_bom2.
            CLEAR : lwa_data1.
            lwa_data1-part_no = lwa_bom2-Material.
            lwa_data1-plant = lwa_bom2-Plant.
            LOOP AT lt_bom INTO lwa_bom WHERE Material = lwa_bom2-Material AND plant = lwa_bom2-Plant .
                CLEAR : lwa_log,lwa_eBOMDetail,lwa_log2,lwa_object.
                READ TABLE lt_object INTO lwa_object WITH KEY ClfnObjectID = lwa_bom-BillOfMaterialComponent.
                IF lwa_object-CharcValue = '3'.
                    CONTINUE.
                ENDIF.
*                IF P_ALL IS INITIAL.
*                    READ TABLE lt_log INTO lwa_log WITH KEY part_no = lwa_bom-Material plant = lwa_bom-Plant item_part_no = lwa_bom-BillOfMaterialComponent.
*                    IF sy-subrc IS INITIAL.
*                        l_time2 = lwa_bom-LastChangeDateTime.
**                        IF (  lwa_log-process_date >= l_time2+0(8) AND lwa_log-process_time >= l_time2+8(6) )  AND ( lwa_log-process_date <= l_date AND lwa_log-process_time <= l_time ).
*                        IF (  l_time2+0(8) >= lwa_log-process_date AND l_time2+8(6) >= lwa_log-process_time )  AND ( l_time2+0(8) <= l_date AND l_time2+8(6) <= l_time ).
*                        ELSE.
*                            CONTINUE.
*                        ENDIF.
*                    ELSE.
*                    ENDIF.
*                ENDIF.
                IF lwa_log-data_status IS INITIAL.
                    lwa_eBOMDetail-data_status = '1'.
                ELSEIF lwa_log-data_status = '1' OR lwa_log-data_status = '2'.
                    lwa_eBOMDetail-data_status = '2'.
                ENDIF.
                IF lwa_bom-BOMIsArchivedForDeletion IS NOT INITIAL.
                    lwa_eBOMDetail-data_status = '3'.
                ENDIF.
                lwa_eBOMDetail-item_part_no = lwa_bom-BillOfMaterialComponent.
                lwa_eBOMDetail-item_group = lwa_bom-AlternativeItemGroup.
                READ TABLE lt_bom3 WITH KEY Material = lwa_bom-Material  plant = lwa_bom-Plant BillOfMaterialComponent = lwa_bom-BillOfMaterialComponent
                 AlternativeItemGroup = lwa_bom-AlternativeItemGroup AlternativeItemPriority = lwa_bom-AlternativeItemPriority TRANSPORTING NO FIELDS.
                IF sy-subrc IS INITIAL.
                    lwa_eBOMDetail-item_group_index = 'Y'.
                ELSE.
                    lwa_eBOMDetail-item_group_index = 'N'.
                ENDIF.
                lwa_eBOMDetail-item_count = lwa_bom-BillOfMaterialItemQuantity.
                APPEND lwa_eBOMDetail TO lwa_data1-ebomdetail.
                MOVE-CORRESPONDING lwa_ebomdetail TO lwa_log2.
                CLEAR: l_num.
                lwa_log2-part_no = lwa_bom2-Material.
                lwa_log2-unit = lwa_bom-BillOfMaterialItemUnit.
                lwa_log2-client = sy-mandt.
                lwa_log2-plant = lwa_bom2-Plant.
                SELECT SINGLE MAX( serial_no ) FROM zz1_bom_log WHERE part_no = @lwa_bom-Material AND item_part_no = @lwa_bom-BillOfMaterialComponent AND plant = @lwa_bom-Plant INTO @l_num."
                lwa_log2-serial_no = l_num + 1 .
                lwa_log2-process_date  = l_date  .
                lwa_log2-process_time  = l_time.
                lwa_log2-process_user = sy-uname.
                APPEND lwa_log2 to lt_log2.
            ENDLOOP.

            "將資料轉成JSON
*            l_req_json = /ui2/cl_json=>serialize( data = lwa_data1 pretty_name = /ui2/cl_json=>pretty_mode-low_case ).
*            FREE: lr_http_destination, lr_web_http_client, lr_request, lr_response.
*            try.
*                lr_http_destination = cl_http_destination_provider=>create_by_url( i_url = l_url ).
*            catch cx_http_dest_provider_error INTO DATA(lr_data).
*                a = 2.
*            ENDTRY.
*
*            try.
*                lr_web_http_client = cl_web_http_client_manager=>create_by_http_destination( i_destination = lr_http_destination ).
*            catch cx_web_http_client_error INTO DATA(lr_data2).
*                a = 2.
*            ENDTRY.
*            lr_request = lr_web_http_client->get_http_request( ).
*            CLEAR: lwa_header , lt_header.
*            lwa_header-name = 'Content-Type'.
*            lwa_header-value = 'Application/JSON'.
*            APPEND lwa_header TO lt_header.
*            lr_request->set_header_fields( i_fields = lt_header ).
*            lr_request->set_text( i_text = l_req_json ).
*            try.
*              lr_response = lr_web_http_client->execute( i_method = if_web_http_client=>post ).
*            catch cx_web_http_client_error INTO lr_data2.
*              a = 2.
*            ENDTRY.
*            IF lr_response IS BOUND.
*              l_status = lr_response->get_status( ).
*              l_text = lr_response->get_text( ).
*              try.
*                lr_web_http_client->close( ).
*              catch cx_web_http_client_error INTO lr_data2.
*                a = 2.
*              ENDTRY.
*            ENDIF.
            IF l_status-code = 200.
                lwa_log2-update_status = 'S'.
            ELSE.
                lwa_log2-update_status = 'F'.
                lwa_log2-message = l_status-reason.
            ENDIF.
            MODIFY lt_log2 FROM lwa_log2 TRANSPORTING update_status message WHERE part_no = lwa_bom2-Material AND plant = lwa_bom2-Plant.
        ENDLOOP.
        MODIFY zz1_bom_log FROM TABLE @lt_log2.
    ENDMETHOD.
ENDCLASS.
