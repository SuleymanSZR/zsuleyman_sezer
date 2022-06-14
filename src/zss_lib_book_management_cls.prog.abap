*&---------------------------------------------------------------------*
*& Include          ZSS_LIB_MEMBER_MANAGEMENT_CLS
*&---------------------------------------------------------------------*

CLASS lcl_library DEFINITION.
  PUBLIC SECTION.
    METHODS:
      start_of_selection,
      get_data,
      get_report,
      prepare_alv,
      display_alv CHANGING cs_alvgird TYPE REF TO cl_gui_alv_grid
                           cs_layout  TYPE lvc_s_layo
                           cs_variant TYPE disvariant
                           ct_output  TYPE ANY TABLE
                           ct_fielcat TYPE lvc_t_fcat,
      refresh_alv CHANGING cs_alvgird TYPE REF TO cl_gui_alv_grid,
      refresh_alv_2,
      get_selected_rows,
      kitap_ekle,
      kitap_sil.

  PROTECTED SECTION.
    "ALV Tanımlamaları
    DATA: lv_cc            TYPE scrfname VALUE 'CC',
          lo_container     TYPE REF TO cl_gui_custom_container,
          lo_alvgrid       TYPE REF TO cl_gui_alv_grid,
          lt_fc            TYPE lvc_t_fcat,
          ls_layout        TYPE lvc_s_layo,
          ls_variant       TYPE disvariant,
          ls_stable        TYPE lvc_s_stbl,
          lt_sort          TYPE lvc_t_sort,
          lt_selected_rows TYPE lvc_t_row,
          ls_selected_rows TYPE lvc_s_row,
          lv_lines         TYPE i.

  PRIVATE SECTION.
    METHODS:
      handle_data_changed  FOR EVENT data_changed   OF cl_gui_alv_grid IMPORTING er_data_changed,
      handle_hotspot_click FOR EVENT hotspot_click  OF cl_gui_alv_grid IMPORTING e_row_id
                                                                                   e_column_id
                                                                                   es_row_no,
      handle_toolbar       FOR EVENT toolbar        OF cl_gui_alv_grid IMPORTING e_object
                                                                                   e_interactive,
      handle_user_command  FOR EVENT user_command   OF cl_gui_alv_grid IMPORTING e_ucomm,
      clear_all,
      clear_alv,
      create_container    IMPORTING iv_cont_name TYPE scrfname
                          CHANGING  cs_container TYPE REF TO cl_gui_custom_container
                                    cs_alv_grid  TYPE REF TO cl_gui_alv_grid,
      create_container2   CHANGING  cs_alv_grid  TYPE REF TO cl_gui_alv_grid,
      create_layout       IMPORTING iv_title     TYPE lvc_title
                          EXPORTING es_layout    TYPE lvc_s_layo,
      create_variant      IMPORTING iv_handle    TYPE slis_handl
                          EXPORTING es_variant   TYPE disvariant,
      create_fcat         EXPORTING et_fc        TYPE lvc_t_fcat,
      modify_fcat         IMPORTING iv_field     TYPE lvc_fname
                                    iv_text      TYPE string
                          CHANGING  ct_fc        TYPE lvc_t_fcat,
      modify_fcat_edit    IMPORTING iv_field     TYPE lvc_fname
                          CHANGING  ct_fc        TYPE lvc_t_fcat,
      modify_fcat_no_out  IMPORTING iv_field     TYPE lvc_fname
                          CHANGING  ct_fc        TYPE lvc_t_fcat,
      modify_fcat_hotspot IMPORTING iv_field     TYPE lvc_fname
                          CHANGING  ct_fc        TYPE lvc_t_fcat,
      modify_fcat_chkbox  IMPORTING iv_field     TYPE lvc_fname
                          CHANGING  ct_fc        TYPE lvc_t_fcat,
      modify_fcat_color   IMPORTING iv_field     TYPE lvc_fname
                                    iv_color     TYPE lvc_emphsz
                          CHANGING  ct_fc        TYPE lvc_t_fcat,
      event_receiver      CHANGING cs_alvgird    TYPE REF TO cl_gui_alv_grid,
      get_tabname         IMPORTING iv_tabname   TYPE tabname.
ENDCLASS. "lcl_library DEFINITION

*----------------------------------------------------------------------*
* CLASS gcl_report IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lcl_library IMPLEMENTATION.
  METHOD handle_data_changed.

  ENDMETHOD. "handle_data_changed

  METHOD handle_hotspot_click.

  ENDMETHOD. "handle_hotspot_click

  METHOD handle_toolbar.

  ENDMETHOD. "handle_toolbar

  METHOD handle_user_command.

  ENDMETHOD. "handle_user_command

  METHOD clear_all.
    CLEAR:    gv_tabname,
              gv_error,
              gs_book.

    REFRESH:  gt_book.
  ENDMETHOD."clear_all

  METHOD start_of_selection.
    me->clear_all( ).
    me->get_report( ).
  ENDMETHOD. "start_of_selection

  METHOD get_data.
    me->clear_all( ).

    SELECT *
      FROM zss_lib_book
      INTO TABLE @gt_book.

  ENDMETHOD. "get_data

  METHOD get_report.
    me->get_data( ).

    IF gt_book IS NOT INITIAL.
      CALL SCREEN 0100.
    ELSE.
      MESSAGE s005(zsuleymans) DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.
  ENDMETHOD. "get_report

  METHOD clear_alv.
    CLEAR:  lo_container,
            lo_alvgrid,
            ls_layout,
            ls_variant.
    "lt_fc.

    FREE: lo_container,
          lo_alvgrid.

  ENDMETHOD. "clear_alv

  METHOD prepare_alv.
    IF lo_alvgrid IS INITIAL.
      me->get_tabname( iv_tabname = gc_output ).
      me->create_container( EXPORTING iv_cont_name = lv_cc
                            CHANGING  cs_container = lo_container
                                      cs_alv_grid  = lo_alvgrid ).
*      me->create_container2( CHANGING  cs_alv_grid  = lo_alvgrid ).
      me->create_layout(  EXPORTING iv_title       = ' '
                          IMPORTING es_layout      = ls_layout ).
      me->create_variant( EXPORTING iv_handle      = 'A'
                          IMPORTING es_variant     = ls_variant ).
      me->create_fcat(    IMPORTING et_fc          = lt_fc ).
*      me->event_receiver( CHANGING  cs_alvgird     = lo_alvgrid ).
      me->display_alv(    CHANGING  cs_alvgird     = lo_alvgrid
                                    cs_layout      = ls_layout
                                    cs_variant     = ls_variant
                                    ct_output      = gt_book
                                    ct_fielcat     = lt_fc ).
    ELSE .
      me->refresh_alv( CHANGING  cs_alvgird = lo_alvgrid ).
    ENDIF.
  ENDMETHOD. "prepare_alv

  METHOD create_container.
*    CREATE OBJECT co_alv_grid
*      EXPORTING
*        i_parent = cl_gui_custom_container=>screen0.

    CREATE OBJECT cs_container
      EXPORTING
        container_name = iv_cont_name.

    CREATE OBJECT cs_alv_grid
      EXPORTING
        i_parent = cs_container.

  ENDMETHOD. "create_container

  METHOD create_container2.
    CREATE OBJECT cs_alv_grid
      EXPORTING
        i_parent = cl_gui_custom_container=>screen0.
  ENDMETHOD. "create_container2

  METHOD create_layout.
    es_layout-zebra       = abap_true.
    es_layout-smalltitle  = abap_true.
    es_layout-cwidth_opt  = abap_true.
    es_layout-sel_mode    = 'D'.
    es_layout-grid_title  = iv_title.
    es_layout-info_fname  = 'COLOR'."Style
  ENDMETHOD. "create_layout

  METHOD create_variant.
    es_variant-handle = iv_handle.
    es_variant-report = sy-repid.
  ENDMETHOD. "create_variant

  METHOD create_fcat.
    DATA: lv_text TYPE string,
          ls_fcat TYPE lvc_s_fcat.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = gv_tabname
      CHANGING
        ct_fieldcat            = et_fc
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.
  ENDMETHOD. "create_fcat
  METHOD modify_fcat.
    READ TABLE ct_fc ASSIGNING FIELD-SYMBOL(<lfs_fc>) WITH KEY fieldname = iv_field.
    IF sy-subrc EQ 0.
      <lfs_fc>-scrtext_s = iv_text.
      <lfs_fc>-scrtext_m = iv_text.
      <lfs_fc>-scrtext_l = iv_text.
      <lfs_fc>-reptext   = iv_text.
      <lfs_fc>-coltext   = iv_text.
      <lfs_fc>-col_opt   = abap_true.
    ENDIF.
  ENDMETHOD. "modify_fcat

  METHOD modify_fcat_edit.
*    READ TABLE ct_fc ASSIGNING FIELD-SYMBOL(<lfs_fc>) WITH KEY fieldname = iv_field.
*    IF sy-subrc EQ 0.
*      <lfs_fc>-edit = abap_true.
*    ENDIF.
  ENDMETHOD. "modify_fcat_edit

  METHOD modify_fcat_no_out.
*    READ TABLE ct_fc ASSIGNING FIELD-SYMBOL(<lfs_fc>) WITH KEY fieldname = iv_field.
*    IF sy-subrc EQ 0.
*      <lfs_fc>-no_out = abap_true.
*    ENDIF.
  ENDMETHOD. "modify_fcat_no_out

  METHOD modify_fcat_hotspot.
*    READ TABLE ct_fc ASSIGNING FIELD-SYMBOL(<lfs_fc>) WITH KEY fieldname = iv_field.
*    IF sy-subrc EQ 0.
*      <lfs_fc>-hotspot = abap_true.
*    ENDIF.
  ENDMETHOD. "modify_fcat_no_out

  METHOD modify_fcat_chkbox.
*    READ TABLE ct_fc ASSIGNING FIELD-SYMBOL(<lfs_fc>) WITH KEY fieldname = iv_field.
*    IF sy-subrc EQ 0.
*      <lfs_fc>-checkbox = abap_true.
*    ENDIF.
  ENDMETHOD. "modify_fcat_chkbox

  METHOD modify_fcat_color.
*    READ TABLE ct_fc ASSIGNING FIELD-SYMBOL(<lfs_fc>) WITH KEY fieldname = iv_field.
*    IF sy-subrc EQ 0.
*      <lfs_fc>-emphasize = iv_color.
*    ENDIF.
  ENDMETHOD. "modify_fcat_color

  METHOD event_receiver.
    SET HANDLER me->handle_data_changed  FOR cs_alvgird.
    SET HANDLER me->handle_hotspot_click FOR cs_alvgird.
    SET HANDLER me->handle_toolbar       FOR cs_alvgird.
    SET HANDLER me->handle_user_command  FOR cs_alvgird.
  ENDMETHOD. "event_receiver

  METHOD display_alv.
    CALL METHOD cs_alvgird->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified
      EXCEPTIONS
        error      = 1
        OTHERS     = 2.

    CALL METHOD cs_alvgird->set_table_for_first_display
      EXPORTING
        is_layout       = cs_layout
        is_variant      = cs_variant
        i_save          = 'A'
      CHANGING
        it_outtab       = ct_output
        it_fieldcatalog = ct_fielcat.
  ENDMETHOD. "display_alv

  METHOD refresh_alv.
    CLEAR: ls_stable.
    ls_stable-row = 'X'.
    ls_stable-col = 'X'.

    CALL METHOD cs_alvgird->refresh_table_display
      EXPORTING
        i_soft_refresh = ''
        is_stable      = ls_stable.
  ENDMETHOD. "refresh_alv

  METHOD refresh_alv_2.
    CLEAR: ls_stable.
    ls_stable-row = 'X'.
    ls_stable-col = 'X'.

    CALL METHOD lo_alvgrid->refresh_table_display
      EXPORTING
        i_soft_refresh = ''
        is_stable      = ls_stable.
  ENDMETHOD. "refresh_alv_2

  METHOD get_tabname.
    gv_tabname = iv_tabname.
  ENDMETHOD. "get_tabname

  METHOD get_selected_rows.
    CLEAR:  lt_selected_rows,
            ls_selected_rows,
            lv_lines.

    CALL METHOD lo_alvgrid->get_selected_rows
      IMPORTING
        et_index_rows = lt_selected_rows.

  ENDMETHOD.

  METHOD kitap_ekle.
    DATA:
      lt_sval   TYPE TABLE OF sval,
      ls_sval   TYPE sval,
      lv_return TYPE i.


    REFRESH : lt_sval.
    CLEAR : ls_sval.
    ls_sval-tabname   = 'ZSS_LIB_BOOK'.
    ls_sval-fieldname = 'KITAPID'.
    ls_sval-fieldtext = 'Kitap ID'.
    ls_sval-field_obl = 'X'.
    APPEND ls_sval TO lt_sval.
    CLEAR ls_sval.
    ls_sval-tabname   = 'ZSS_LIB_BOOK'.
    ls_sval-fieldname = 'KITAPADET'.
    APPEND ls_sval TO lt_sval.
    CLEAR ls_sval.
    ls_sval-tabname   = 'ZSS_LIB_BOOK'.
    ls_sval-fieldname = 'KITAPADI'.
    APPEND ls_sval TO lt_sval.
    CLEAR ls_sval.

    CALL FUNCTION 'POPUP_GET_VALUES'
      EXPORTING
        popup_title     = 'Kitap Ekle'
      TABLES
        fields          = lt_sval
      EXCEPTIONS
        error_in_fields = 1
        OTHERS          = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    CLEAR : gs_book.
    LOOP AT lt_sval ASSIGNING FIELD-SYMBOL(<lfs_sval>).
      CASE <lfs_sval>-fieldname.
        WHEN 'KITAPID'.
          gs_book-kitapid = <lfs_sval>-value.
        WHEN 'KITAPADET'.
          gs_book-kitapadet = <lfs_sval>-value.
        WHEN 'KITAPADI'.
          gs_book-kitapadi = <lfs_sval>-value.
      ENDCASE.
    ENDLOOP.

    SELECT COUNT(*)
    FROM zss_lib_book
    INTO @DATA(lv_data)
    WHERE kitapid EQ @gs_book-kitapid.

    IF lv_data > 0.
      MESSAGE s010(zsuleymans) DISPLAY LIKE 'E'.
    ELSE.
      MODIFY zss_lib_book FROM gs_book.
      IF sy-subrc EQ 0.
        COMMIT WORK AND WAIT.
        go_library->get_data( ).
        go_library->refresh_alv_2( ).
      ELSE.
        ROLLBACK WORK.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD kitap_sil.
    me->get_selected_rows( ).
    CLEAR : gs_book.
    lv_lines = lines( lt_selected_rows ).
    IF lv_lines EQ 0.
      MESSAGE s000(zsuleymans) DISPLAY LIKE 'E'.
    ELSEIF lv_lines EQ 1.

      LOOP AT lt_selected_rows INTO ls_selected_rows.
        READ TABLE gt_book ASSIGNING FIELD-SYMBOL(<lfs_book>) INDEX ls_selected_rows-index.
        IF sy-subrc EQ 0.
          gs_book-kitapid = <lfs_book>-kitapid.
        ENDIF.
      ENDLOOP.

      DELETE FROM zss_lib_book WHERE kitapid EQ gs_book-kitapid.
      IF sy-subrc EQ 0.
        COMMIT WORK AND WAIT.
        go_library->get_data( ).
        go_library->refresh_alv_2( ).
        MESSAGE s009(zsuleymans) DISPLAY LIKE 'S'.
      ELSE.
        ROLLBACK WORK.
        MESSAGE s008(zsuleymans) DISPLAY LIKE 'E'.
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS. "lcl_library IMPLEMENTATION
