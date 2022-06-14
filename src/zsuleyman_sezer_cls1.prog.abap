*&---------------------------------------------------------------------*
*& Include          ZSULEYMAN_SEZER_CLS1
*&---------------------------------------------------------------------*

CLASS lcl_alv DEFINITION.
  PUBLIC SECTION.

    TYPES : BEGIN OF gty_mara,
              matnr TYPE matnr,
              ernam TYPE ernam,
              laeda TYPE laeda,
              matkl TYPE matkl,
              ntgew TYPE ntgew,
              gewei TYPE gewei,
            END OF gty_mara.

    DATA : gs_mara     TYPE gty_mara,
           gt_mara     TYPE TABLE OF gty_mara,
           gt_fieldcat TYPE lvc_t_fcat,
           gs_fieldcat TYPE lvc_s_fcat,
           gs_layout   TYPE lvc_s_layo.

    "class tanımları
    DATA : go_alv      TYPE REF TO cl_gui_alv_grid,
           go_cont     TYPE REF TO cl_gui_custom_container,
           go_split    TYPE REF TO cl_gui_splitter_container,
           go_subcont1 TYPE REF TO cl_gui_container,
           go_subcont2 TYPE REF TO cl_gui_container,
           go_doc      TYPE REF TO  cl_dd_document.

    METHODS : get_data,
      set_fieldcat,
      set_layout,
      display_alv_full,
      display_alv_cont,
      display_alv_event,
      delete_data.

    METHODS : handle_hotspot_click FOR EVENT hotspot_click
     OF cl_gui_alv_grid IMPORTING e_column_id
                                  e_row_id
                                  es_row_no,

    handle_data_changed FOR EVENT data_changed
     OF cl_gui_alv_grid IMPORTING er_data_changed,

    handle_toolbar FOR EVENT toolbar
     OF cl_gui_alv_grid IMPORTING e_interactive
                                  e_object,

    handle_user_command FOR EVENT user_command
     OF cl_gui_alv_grid IMPORTING e_ucomm.

ENDCLASS.


CLASS lcl_alv IMPLEMENTATION.

  METHOD get_data.
    SELECT matnr,
           ernam,
           laeda,
           matkl,
           ntgew,
           gewei
      FROM mara
      INTO TABLE @gt_mara.
  ENDMETHOD.

  METHOD set_fieldcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZSZR_S0002'
      CHANGING
        ct_fieldcat      = gt_fieldcat.

    LOOP AT gt_fieldcat ASSIGNING FIELD-SYMBOL(<lfs_fieldcat>).

      CASE <lfs_fieldcat>-fieldname.
        WHEN 'MATNR' .
          <lfs_fieldcat>-hotspot = abap_true.
        WHEN 'MATKL'.
          <lfs_fieldcat>-edit = abap_true.
*	       WHEN OTHERS.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.


  METHOD set_layout.

    gs_layout-zebra = 'X'.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-col_opt = abap_true.

  ENDMETHOD.


  METHOD display_alv_full.
*    CREATE OBJECT go_alv.

    go_alv = NEW cl_gui_alv_grid(
        i_parent          = cl_gui_container=>screen0 ).

    CALL METHOD go_alv->set_table_for_first_display
      EXPORTING
        is_layout       = gs_layout   " Layout
      CHANGING
        it_outtab       = gt_mara   " Output Table
        it_fieldcatalog = gt_fieldcat.    " Field Catalog

  ENDMETHOD.

  METHOD display_alv_cont.

    CREATE OBJECT go_cont
      EXPORTING
        container_name = 'CC_CONT'.    " Name of the Screen CustCtrl Name to Link Container To

    CREATE OBJECT go_alv
      EXPORTING
        i_parent = go_cont.    " Parent Container

    CALL METHOD go_alv->set_table_for_first_display
      EXPORTING
        is_layout       = gs_layout   " Layout
      CHANGING
        it_outtab       = gt_mara   " Output Table
        it_fieldcatalog = gt_fieldcat.    " Field Catalog

  ENDMETHOD.


  METHOD display_alv_event.

    DATA : lv_text   TYPE sdydo_text_element,
           lv_backgr TYPE sdydo_key VALUE 'ALV_BACKGROUND'.

    IF go_alv IS INITIAL.

      go_cont = NEW cl_gui_custom_container(
          container_name = 'CC_CONT' ).

      go_split = NEW cl_gui_splitter_container(
          parent                  = go_cont
          rows                    = 2
          columns                 = 1 ).

      go_split->get_container(
        EXPORTING
          row       =  1
          column    =  1
        RECEIVING
          container =  go_subcont1 ).

      go_split->get_container(
        EXPORTING
          row       =  2
          column    =  1
        RECEIVING
          container =  go_subcont2 ).

      go_split->set_row_height(
        EXPORTING
          id                =  1
          height            =  20  ).

      go_doc = NEW cl_dd_document(
          style            = 'ALV_GRID' ).

      lv_text = 'OO ALV Event'.
      go_doc->add_text(
        EXPORTING
          text          = lv_text
          sap_style     = cl_dd_document=>heading
          sap_color     = cl_dd_document=>list_positive
          sap_fontsize  = cl_dd_document=>list_heading ).

      go_doc->set_document_background(
          picture_id = lv_backgr ).

      go_doc->display_document(
        EXPORTING
          parent             = go_subcont1 ).

      go_alv = NEW cl_gui_alv_grid(
          i_parent          = go_subcont2 ).

      "hücre değiştirir değiştirmez değişiklik tamamlanır
      go_alv->register_edit_event(
        EXPORTING
          i_event_id = cl_gui_alv_grid=>mc_evt_modified ).

      SET HANDLER handle_hotspot_click FOR go_alv.
      SET HANDLER handle_data_changed FOR go_alv.
      SET HANDLER handle_toolbar FOR go_alv.
      SET HANDLER handle_user_command for go_alv.

      CALL METHOD go_alv->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout   " Layout
        CHANGING
          it_outtab       = gt_mara   " Output Table
          it_fieldcatalog = gt_fieldcat.    " Field Catalog


    ENDIF.

    go_alv->refresh_table_display( ).

  ENDMETHOD.

  METHOD handle_hotspot_click.

    DATA:lv_date TYPE datum.

    READ TABLE gt_mara ASSIGNING FIELD-SYMBOL(<lfs_mara>) INDEX e_row_id.

    CALL FUNCTION 'CONVERT_DATE_TO_EXTERNAL'
      EXPORTING
        date_internal = <lfs_mara>-laeda
      IMPORTING
        date_external = lv_date.

    DATA(lv_message) =  |Bu malzeme | & | | & | { <lfs_mara>-ernam } | & | | & | tarafından | & | | & | { lv_date } | & |tarihinde oluşturulmuştur. | .

    MESSAGE lv_message TYPE 'I'.

  ENDMETHOD.

  METHOD handle_data_changed.
    DATA  : ls_mod_cell TYPE lvc_s_modi,
            ls_zvkt     TYPE zvkt_t0041.

    LOOP AT er_data_changed->mt_mod_cells INTO ls_mod_cell.
      READ TABLE gt_mara INTO DATA(ls_mara) INDEX ls_mod_cell-row_id.

      ls_zvkt-ernam = ls_mara-ernam.
      ls_zvkt-gewei = ls_mara-gewei.
      ls_zvkt-laeda = ls_mara-laeda.
*      ls_zvkt-matkl = ls_mara-matkl.
      ls_zvkt-matkl = ls_mod_cell-value.
      ls_zvkt-matnr = ls_mara-matnr.
      ls_zvkt-ntgew = ls_mara-ntgew.

      MODIFY zvkt_t0041 FROM ls_zvkt.
      IF sy-subrc EQ 0.
        COMMIT WORK AND WAIT.
      ELSE.
        ROLLBACK WORK.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD handle_toolbar.

    DATA : ls_toolbar TYPE stb_button.

    ls_toolbar-function = '&SIL'.
    ls_toolbar-text = 'Sil'.
    ls_toolbar-icon = '@11@'.
    APPEND ls_toolbar TO e_object->mt_toolbar.
*    Clear : ls_toolbar.  "birden çok yapılacaksa olması gerekli

  ENDMETHOD.

  METHOD handle_user_command.
    CASE e_ucomm .
      WHEN '&SIL'.
        delete_data( ).
    ENDCASE.
    go_alv->refresh_table_display( ).
  ENDMETHOD.


  METHOD delete_data.

    DATA : lt_rows TYPE lvc_t_row,
           ls_rows TYPE lvc_s_row.

    go_alv->get_selected_rows(
      IMPORTING
        et_index_rows = lt_rows ).

    LOOP AT lt_rows INTO ls_rows.
      DELETE gt_mara INDEX ls_rows-index.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
