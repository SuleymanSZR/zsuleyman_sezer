*&---------------------------------------------------------------------*
*& Include          ZSS_LIB_MEMBER_MANAGEMENT_CLS2
*&---------------------------------------------------------------------*

CLASS lcl_library DEFINITION.
  PUBLIC SECTION.
    METHODS:
      start_of_selection,
      clear_all,
      get_data,
      set_fieldcat,
      set_layout,
      refresh_alv,
      display_alv,
      call_screen,
      kullanici_ekle,
      kullanici_sil,
      kullanici_pasif,
      kitap_ver,
      kitap_iade,
      get_selected_rows.


    DATA :
      ls_stable        TYPE lvc_s_stbl,
      lt_selected_rows TYPE lvc_t_row,
      ls_selected_rows TYPE lvc_s_row,
      lv_lines         TYPE i.


ENDCLASS. "lcl_library DEFINITION

CLASS lcl_library IMPLEMENTATION.
  METHOD start_of_selection.
    me->clear_all( ).
    me->get_data( ).
  ENDMETHOD.

  METHOD get_data.

    SELECT *
      FROM zss_lib_member
      INTO TABLE @gt_member
      WHERE pasif NE 'X'.
*    BREAK egt_suleyman.
    me->set_fieldcat( ).
    me->set_layout( ).

  ENDMETHOD.

  METHOD clear_all.

  ENDMETHOD.

  METHOD display_alv.

    go_alv = NEW cl_gui_alv_grid(
            i_parent          = cl_gui_container=>screen0 ).

    CALL METHOD go_alv->set_table_for_first_display
      EXPORTING
        is_layout       = gs_layout
      CHANGING
        it_outtab       = gt_member
        it_fieldcatalog = gt_fieldcat.

  ENDMETHOD.

  METHOD call_screen.
    CHECK:
      lines( gt_member ) NE 0.
    CALL SCREEN 0100.
  ENDMETHOD.

  METHOD get_selected_rows.
    CLEAR:  lt_selected_rows,
            ls_selected_rows,
            lv_lines.

    CALL METHOD go_alv->get_selected_rows
      IMPORTING
        et_index_rows = lt_selected_rows   " Indexes of Selected Rows
*       et_row_no     =     " Numeric IDs of Selected Rows
      .
  ENDMETHOD.

  METHOD set_fieldcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZSS_LIB_MEMBER_S'
      CHANGING
        ct_fieldcat      = gt_fieldcat.

  ENDMETHOD.

  METHOD set_layout.
    gs_layout-zebra = 'X'.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-col_opt = abap_true.
    gs_layout-sel_mode    = 'D'.
  ENDMETHOD.

  METHOD kullanici_pasif.

  ENDMETHOD.

  METHOD kullanici_ekle.

    DATA:
      lt_sval   TYPE TABLE OF sval,
      ls_sval   TYPE sval,
      lv_return TYPE i.


    REFRESH : lt_sval.
    CLEAR : ls_sval.
    ls_sval-tabname   = 'ZSS_LIB_MEMBER'.
    ls_sval-fieldname = 'TC'.
    ls_sval-fieldtext = 'T Kimlik No'.
    ls_sval-field_obl = 'X'.
    APPEND ls_sval TO lt_sval.
    CLEAR ls_sval.
    ls_sval-tabname   = 'ZSS_LIB_MEMBER'.
    ls_sval-fieldname = 'ADI'.
    APPEND ls_sval TO lt_sval.
    CLEAR ls_sval.
    ls_sval-tabname   = 'ZSS_LIB_MEMBER'.
    ls_sval-fieldname = 'SOYADI'.
    APPEND ls_sval TO lt_sval.
    CLEAR ls_sval.
    ls_sval-tabname   = 'ZSS_LIB_MEMBER'.
    ls_sval-fieldname = 'PASIF'.
    APPEND ls_sval TO lt_sval.
    CLEAR ls_sval.


    CALL FUNCTION 'POPUP_GET_VALUES'
      EXPORTING
        popup_title     = 'Kullanıcı'
      TABLES
        fields          = lt_sval
      EXCEPTIONS
        error_in_fields = 1
        OTHERS          = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    CLEAR : gs_member.
    LOOP AT lt_sval ASSIGNING FIELD-SYMBOL(<lfs_sval>).
      CASE <lfs_sval>-fieldname.
        WHEN 'TC'.
          gs_member-tc = <lfs_sval>-value.
        WHEN 'ADI'.
          gs_member-adi = <lfs_sval>-value.
        WHEN 'SOYADI'.
          gs_member-soyadi = <lfs_sval>-value.
        WHEN 'PASIF'.
          gs_member-pasif = <lfs_sval>-value.
      ENDCASE.
    ENDLOOP.

    SELECT COUNT(*)
    FROM zss_lib_member
    INTO @DATA(lv_data)
    WHERE tc EQ @gs_member-tc.

    IF lv_data > 0.
      MESSAGE s006(zsuleymans) DISPLAY LIKE 'E'.
    ELSE.
      MODIFY zss_lib_member FROM gs_member.
    ENDIF.

  ENDMETHOD.

  METHOD kullanici_sil.
    me->get_selected_rows( ).

    lv_lines = lines( lt_selected_rows ).
    IF lv_lines EQ 0.
      MESSAGE s000(zsuleymans) DISPLAY LIKE 'E'.
    ELSEIF lv_lines EQ 1.
      READ TABLE  gt_member INTO gs_member INDEX 1.
      DELETE FROM zss_lib_member WHERE tc EQ gs_member-tc.
    ENDIF.

  ENDMETHOD.

  METHOD kitap_ver.

  ENDMETHOD.

  METHOD kitap_iade.

  ENDMETHOD.

  METHOD refresh_alv.
    CLEAR: ls_stable.
    ls_stable-row = 'X'.
    ls_stable-col = 'X'.

    CALL METHOD go_alv->refresh_table_display
      EXPORTING
        i_soft_refresh = ''
        is_stable      = ls_stable.
  ENDMETHOD. "refresh_alv

ENDCLASS.
