*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lhc_zz1_cl_indep_req DEFINITION INHERITING FROM cl_abap_behavior_handler.
    PUBLIC SECTION.
        DATA t_del TYPE TABLE FOR UPDATE zz1_i_indep_req.
        DATA wa_del LIKE LINE OF t_del.
        DATA t_del2 TYPE STANDARD TABLE OF zz1_i_indep_req.
        DATA:w_check(1).
        DATA: l_pass TYPE string VALUE 'Innatech@MIYABI2025TEST',
              w_clients(3) VALUE 'AR4',
              w_clientd(3) VALUE 'BTY',
              w_clientt(3) VALUE 'N8X',
              w_clientp(3) VALUE 'PHK'.


    PRIVATE SECTION.
        METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
          IMPORTING REQUEST requested_authorizations FOR zz1_i_indep_req RESULT result.

        METHODS update FOR DETERMINE ON SAVE
          IMPORTING keys FOR zz1_i_indep_req~update
          CHANGING reported TYPE data.

ENDCLASS.
CLASS lhc_zz1_cl_indep_req IMPLEMENTATION.

METHOD get_global_authorizations.
ENDMETHOD.

METHOD update.
    DATA: l_headurl TYPE string .
    DATA: l_patchurl TYPE string .

    DATA: l_password TYPE string,
          l_name     TYPE string.
    DATA: l_auth(500).
    DATA: l_body TYPE string.
    DATA: lr_http_destination TYPE REF TO if_http_destination.
    DATA: lr_web_http_client TYPE REF TO if_web_http_client.
    DATA: lr_request TYPE REF TO if_web_http_request.
    DATA: lr_response TYPE REF TO if_web_http_response.
    DATA: l_url TYPE string.
    DATA: lwa_header TYPE if_web_http_request=>name_value_pair,
          lt_header  TYPE if_web_http_request=>name_value_pairs.
    DATA: l_status TYPE if_web_http_response=>http_status .
    DATA: l_text TYPE string.
    DATA :a TYPE c LENGTH 1.
    DATA: lt_del      TYPE STANDARD TABLE OF zz1_i_indep_req,
          lwa_del     TYPE zz1_i_indep_req,
          l_kpein     TYPE p LENGTH 5 DECIMALS 0 VALUE 1.
    DATA lt_indep TYPE TABLE FOR UPDATE zz1_i_indep_req.
    DATA lwa_indep TYPE STRUCTURE FOR UPDATE zz1_i_indep_req.
    DATA : BEGIN OF lwa_data,
          werks TYPE c LENGTH 4,
          matnr TYPE c LENGTH 40,
          date1 TYPE c LENGTH 40,
          date2 TYPE c LENGTH 40,
          date3 TYPE c LENGTH 40,
          date4 TYPE c LENGTH 40,
          date5 TYPE c LENGTH 40,
          date6 TYPE c LENGTH 40,
          date7 TYPE c LENGTH 40,
          date8 TYPE c LENGTH 40,
          date9 TYPE c LENGTH 40,
          date10  TYPE c LENGTH 40,
          date11  TYPE c LENGTH 40,
          date12  TYPE c LENGTH 40,
          date13  TYPE c LENGTH 40,
          date14  TYPE c LENGTH 40,
          date15  TYPE c LENGTH 40,
          date16  TYPE c LENGTH 40,
          date17  TYPE c LENGTH 40,
          date18  TYPE c LENGTH 40,
          date19  TYPE c LENGTH 40,
          date20  TYPE c LENGTH 40,
          date21  TYPE c LENGTH 40,
          date22  TYPE c LENGTH 40,
          date23  TYPE c LENGTH 40,
          date24  TYPE c LENGTH 40,
          date25  TYPE c LENGTH 40,
          date26  TYPE c LENGTH 40,
          date27  TYPE c LENGTH 40,
          date28  TYPE c LENGTH 40,
          date29  TYPE c LENGTH 40,
          date30  TYPE c LENGTH 40,
          date31  TYPE c LENGTH 40,
          date32  TYPE c LENGTH 40,
          date33  TYPE c LENGTH 40,
          date34  TYPE c LENGTH 40,
          date35  TYPE c LENGTH 40,
          date36  TYPE c LENGTH 40,
          date37  TYPE c LENGTH 40,
          date38  TYPE c LENGTH 40,
          date39  TYPE c LENGTH 40,
          date40  TYPE c LENGTH 40,
          date41  TYPE c LENGTH 40,
          date42  TYPE c LENGTH 40,
          date43  TYPE c LENGTH 40,
          date44  TYPE c LENGTH 40,
          date45  TYPE c LENGTH 40,
          date46  TYPE c LENGTH 40,
          date47  TYPE c LENGTH 40,
          date48  TYPE c LENGTH 40,
          date49  TYPE c LENGTH 40,
          date50  TYPE c LENGTH 40,
          date51  TYPE c LENGTH 40,
          date52  TYPE c LENGTH 40,
          date53  TYPE c LENGTH 40,
          date54  TYPE c LENGTH 40,
          date55  TYPE c LENGTH 40,
          date56  TYPE c LENGTH 40,
          date57  TYPE c LENGTH 40,
          date58  TYPE c LENGTH 40,
          date59  TYPE c LENGTH 40,
          date60  TYPE c LENGTH 40,
          insert_date TYPE d,
          insert_time TYPE sy-uzeit,
          insert_user TYPE sy-uname,
      END OF lwa_data,
      BEGIN OF to_PlndIndepRqmtItem,
        Product TYPE c LENGTH 40,
        Plant TYPE c LENGTH 4,
        PlndIndepRqmtPeriod TYPE c LENGTH 8,
        PeriodType TYPE c LENGTH 1 VALUE 'D',
        PlannedQuantity TYPE c LENGTH 40,
      END OF to_PlndIndepRqmtItem,
      BEGIN OF lwa_data2,
        Product TYPE c LENGTH 40,
        Plant TYPE c LENGTH 4,
        to_PlndIndepRqmtItem LIKE STANDARD TABLE OF to_PlndIndepRqmtItem,
      END OF lwa_data2,
      BEGIN OF wa_data4,
         value TYPE c LENGTH 500,
      END OF wa_data4,
      BEGIN OF wa_data3,
         code    TYPE c LENGTH 500,
         message LIKE wa_data4,
      END OF wa_data3,
      BEGIN OF lwa_res_err,
         error LIKE wa_data3,
      END OF lwa_res_err    .

    DATA : lw_field(10),
           l_count TYPE i,
           l_count_c(3),
           l_date TYPE sy-datum,
           l_time TYPE sy-uzeit,
           l_user TYPE sy-uname.
    FIELD-SYMBOLS : <quan> TYPE ANY ,
                    <date> TYPE ANY .
    "讀取EXCEL資料
    READ ENTITIES OF zz1_i_indep_req IN LOCAL MODE
        ENTITY zz1_i_indep_req
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_result)
        FAILED DATA(lt_failed)
        REPORTED DATA(lt_reported).
    DATA: lwa_result LIKE LINE OF lt_result ,
          lwa_result2 LIKE LINE OF lt_result ,
          lt_result2 LIKE lt_result.
      lt_result2 = lt_result.
      delete lt_result INDEX 1.
      l_date = sy-datum.
      l_time = sy-uzeit.
      l_user = sy-uname.
      LOOP AT lt_result INTO lwa_result.
          clear lwa_indep.
          MOVE-CORRESPONDING lwa_result to lwa_indep.
          lwa_indep-insert_date = l_date.
          lwa_indep-insert_time = l_time.
          lwa_indep-insert_user = l_user.
          clear:lwa_data2.
          l_count = 0.
          lwa_data2-product = lwa_result-matnr.
          lwa_data2-plant  = lwa_result-Werks.
          READ TABLE lt_result2 INTO lwa_result2 INDEX 1.
          to_PlndIndepRqmtItem-periodtype = 'D'.
          to_PlndIndepRqmtItem-product = lwa_result-matnr.
          to_PlndIndepRqmtItem-plant = lwa_result-Werks.
          DO 60 TIMES.
            l_count += 1.
            l_count_c = l_count.
            CONDENSE l_count_c NO-GAPS.
            CONCATENATE 'DATE' l_count_c INTO lw_field.
            ASSIGN COMPONENT lw_field OF STRUCTURE lwa_result TO <quan>.
            ASSIGN COMPONENT lw_field OF STRUCTURE lwa_result2 TO <date>.
            IF <date> IS ASSIGNED.
                clear : to_PlndIndepRqmtItem-plndindeprqmtperiod , to_PlndIndepRqmtItem-plannedquantity.
                to_PlndIndepRqmtItem-plndindeprqmtperiod+0(4) = <date>+0(4).
                to_PlndIndepRqmtItem-plndindeprqmtperiod+4(2) = <date>+5(2).
                to_PlndIndepRqmtItem-plndindeprqmtperiod+6(2) = <date>+8(2).
                IF to_PlndIndepRqmtItem-plndindeprqmtperiod IS INITIAL.
                    EXIT.
                ELSE.
                    IF <quan> IS ASSIGNED.
                        to_PlndIndepRqmtItem-plannedquantity = <quan>.
                        IF to_PlndIndepRqmtItem-plannedquantity IS INITIAL.
                            CONTINUE.
                        ELSE.
                            APPEND to_PlndIndepRqmtItem TO lwa_data2-to_plndindeprqmtitem.
                        ENDIF.
                    ELSE.
                        CONTINUE.
                    ENDIF.
                ENDIF.
            ELSE.
                CONTINUE.
            ENDIF.
          ENDDO.
          "CALL API
          CLEAR:  l_body, lt_header.
          lt_header =
             VALUE #(
               ( name = 'Accept' value = 'application/json'  )
               ( name = 'Content-Type' value = 'application/json'  )
*                     ( name = 'If-Match' value = '*'  )
               ).
          l_body = /ui2/cl_json=>serialize( data = lwa_data2 pretty_name = /ui2/cl_json=>pretty_mode-low_case ).
          REPLACE ALL OCCURRENCES OF:
              'plant' IN l_body WITH 'Plant',
              'product' IN l_body WITH 'Product',
              'to_plndindeprqmtitem' IN l_body WITH 'to_PlndIndepRqmtItem',
              'plndindeprqmtperiod' IN l_body WITH 'PlndIndepRqmtPeriod',
              'periodtype' IN l_body WITH 'PeriodType',
              'plannedquantity' IN l_body WITH 'PlannedQuantity'
              .
          CLEAR: l_url, l_status, l_text.
          FREE: lr_http_destination, lr_web_http_client, lr_request, lr_response.
          IF  sy-sysid = w_clientd.
            l_url = `https://my430203-api.s4hana.cloud.sap/sap/opu/odata/sap/API_PLND_INDEP_RQMT_SRV/PlannedIndepRqmt`.
          ELSEIF sy-sysid = w_clientt.
*            l_url = `https://my417295-api.s4hana.cloud.sap/sap/opu/odata/sap/API_PLND_INDEP_RQMT_SRV/PlannedIndepRqmt`.
          ELSEIF sy-sysid = w_clientp.
*            l_url = `https://my422106-api.s4hana.cloud.sap/sap/opu/odata/sap/API_PLND_INDEP_RQMT_SRV/PlannedIndepRqmt`.
          ELSEIF sy-sysid = w_clients.
            l_url = `https://my427098-api.s4hana.cloud.sap/sap/opu/odata/sap/API_PLND_INDEP_RQMT_SRV/PlannedIndepRqmt`.
          ENDIF.
          TRY.
              lr_http_destination = cl_http_destination_provider=>create_by_url( i_url = l_url ).
            CATCH cx_http_dest_provider_error INTO DATA(lr_data).
              a = 5.
          ENDTRY.
          TRY.
              lr_web_http_client = cl_web_http_client_manager=>create_by_http_destination( i_destination = lr_http_destination ).
            CATCH cx_web_http_client_error INTO DATA(lr_data2).
              a = 6.
          ENDTRY.
          lr_request = lr_web_http_client->get_http_request( ).
          l_name = 'InnatechMIYABI2025TEST'.
          l_password = l_pass.
          lr_request->set_authorization_basic( i_username = l_name i_password = l_password ).
          lr_request->set_header_fields( i_fields = lt_header ).
          lr_request->set_text( i_text = l_body ).
          TRY.
              lr_web_http_client->set_csrf_token( ).
              lr_response = lr_web_http_client->execute( i_method = if_web_http_client=>post ).
            CATCH cx_web_http_client_error INTO lr_data2.
              a = 7.
          ENDTRY.
          IF lr_response IS BOUND.
            l_status = lr_response->get_status( ).
            l_text = lr_response->get_text( ).
            TRY.
                lr_web_http_client->close( ).
              CATCH cx_web_http_client_error INTO lr_data2.
                a = 8.
            ENDTRY.
          ENDIF.
          IF l_status-code <> '200' AND l_status-code <> '201'.
              /ui2/cl_json=>deserialize( "將資料按照Json格式解譯放入ITAB
                  EXPORTING
                    json        =  l_text
                    pretty_name = /ui2/cl_json=>pretty_mode-low_case
                  CHANGING
                    data        = lwa_res_err ).
              lwa_indep-msg = lwa_res_err-error-message-value.
          ELSE.
             lwa_indep-Msg = '已寫入成功'.
          ENDIF.
          APPEND lwa_indep TO lt_indep.
*          /ui2/cl_json=>deserialize( EXPORTING json = l_text pretty_name = /ui2/cl_json=>pretty_mode-none CHANGING data = lwa_res ).
    ENDLOOP.
    MODIFY ENTITIES OF zz1_i_indep_req IN LOCAL MODE
    ENTITY zz1_i_indep_req UPDATE SET FIELDS WITH lt_indep
    MAPPED DATA(lt_mapp_mod)
    REPORTED DATA(report_mod)
    FAILED DATA(failed_mod).
    "清除資料庫中日期行
    MODIFY ENTITIES OF zz1_i_indep_req IN LOCAL MODE
    ENTITY zz1_i_indep_req DELETE FROM VALUE #( (  indep_uuid = lwa_result2-indep_uuid ) ).
ENDMETHOD.
ENDCLASS.
