*&---------------------------------------------------------------------*
*& Include          ZSS_LIB_MEMBER_MANAGEMENT_CLS
*&---------------------------------------------------------------------*

CLASS lcl_library DEFINITION.
  PUBLIC SECTION.
    METHODS:
      start_of_selection,
      get_data, "kişi
      get_data2, "kişideki kitaplar
      get_data3, "alınabilecek kitaplar
      get_report,
*      prepare_alv,
      prepare_alv  IMPORTING iv_struc_name TYPE dd02l-tabname,
      prepare_alv2 IMPORTING iv_struc_name TYPE dd02l-tabname,
      display_alv  CHANGING cs_alvgird TYPE REF TO cl_gui_alv_grid
                            cs_layout  TYPE lvc_s_layo
                            cs_variant TYPE disvariant
                            ct_output  TYPE ANY TABLE
                            ct_fielcat TYPE lvc_t_fcat,
      refresh_alv  CHANGING cs_alvgird     TYPE REF TO cl_gui_alv_grid,
      refresh_alv_2,
      get_selected_rows,
      kullanici_ekle,
      kullanici_sil,
      kullanici_pasif,
      kitap_ver,
      kitap_sec,
      kitap_iade,
      goster.

  PROTECTED SECTION.
    "ALV Tanımlamaları
    DATA: lv_cc            TYPE scrfname VALUE 'CC',
          lv_cc2           TYPE scrfname VALUE 'BOOK',
          lo_container     TYPE REF TO cl_gui_custom_container,
          lo_alvgrid       TYPE REF TO cl_gui_alv_grid,
          lt_fc            TYPE lvc_t_fcat,
*          iv_struc_name    TYPE dd02l-tabname,
          ls_layout        TYPE lvc_s_layo,
          ls_variant       TYPE disvariant,
          ls_stable        TYPE lvc_s_stbl,
          lt_sort          TYPE lvc_t_sort,
          lt_selected_rows TYPE lvc_t_row,
          ls_selected_rows TYPE lvc_s_row,
          lv_mesaj         TYPE char200,
          lv_lines         TYPE i,
          lv_adet_count    TYPE zss_kitapadet_de,
          ls_selfield      TYPE slis_selfield.


  PRIVATE SECTION.
    METHODS:
      handle_data_changed  FOR EVENT data_changed  OF cl_gui_alv_grid IMPORTING er_data_changed,
      handle_hotspot_click FOR EVENT hotspot_click OF cl_gui_alv_grid IMPORTING e_row_id
                                                                                  e_column_id
                                                                                  es_row_no,
      handle_toolbar       FOR EVENT toolbar       OF cl_gui_alv_grid IMPORTING e_object
                                                                                  e_interactive,
      handle_user_command  FOR EVENT user_command  OF cl_gui_alv_grid IMPORTING e_ucomm,
      clear_all,
      clear_alv,
      create_container     IMPORTING iv_cont_name TYPE scrfname
                           CHANGING  cs_container TYPE REF TO cl_gui_custom_container
                                     cs_alv_grid  TYPE REF TO cl_gui_alv_grid,
      create_container2    CHANGING  cs_alv_grid   TYPE REF TO cl_gui_alv_grid,
      create_layout        IMPORTING iv_title  TYPE lvc_title
                           EXPORTING es_layout TYPE lvc_s_layo,
      create_variant       IMPORTING iv_handle  TYPE slis_handl
                           EXPORTING es_variant TYPE disvariant,
      create_fcat          IMPORTING ev_struc_name TYPE dd02l-tabname
                           EXPORTING et_fc         TYPE lvc_t_fcat,
*      create_fcat          EXPORTING et_fc         TYPE lvc_t_fcat,
      modify_fcat          IMPORTING iv_field TYPE lvc_fname
                                     iv_text  TYPE string
                           CHANGING  ct_fc    TYPE lvc_t_fcat,
      modify_fcat_edit     IMPORTING iv_field TYPE lvc_fname
                           CHANGING  ct_fc    TYPE lvc_t_fcat,
      modify_fcat_no_out   IMPORTING iv_field TYPE lvc_fname
                           CHANGING  ct_fc    TYPE lvc_t_fcat,
      modify_fcat_hotspot  IMPORTING iv_field TYPE lvc_fname
                           CHANGING  ct_fc    TYPE lvc_t_fcat,
      modify_fcat_chkbox   IMPORTING iv_field TYPE lvc_fname
                           CHANGING  ct_fc    TYPE lvc_t_fcat,
      modify_fcat_color    IMPORTING iv_field TYPE lvc_fname
                                     iv_color TYPE lvc_emphsz
                           CHANGING  ct_fc    TYPE lvc_t_fcat,
      event_receiver       CHANGING cs_alvgird     TYPE REF TO cl_gui_alv_grid,
      get_tabname          IMPORTING iv_tabname    TYPE tabname,
      get_tabname2         IMPORTING iv_tabname    TYPE tabname.
ENDCLASS. "lcl_library DEFINITION

*----------------------------------------------------------------------*
* CLASS gcl_report IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lcl_library IMPLEMENTATION.
  METHOD handle_data_changed.

  ENDMETHOD. "handle_data_changed

  METHOD handle_hotspot_click.

*    CASE e_column_id.
*      WHEN 'KITAPID'.
*        READ TABLE gt_book INTO gs_book INDEX e_row_id.
*
*        me->kitap_sec( ).
*    ENDCASE.


  ENDMETHOD. "handle_hotspot_click

  METHOD handle_toolbar.

  ENDMETHOD. "handle_toolbar

  METHOD handle_user_command.

  ENDMETHOD. "handle_user_command

  METHOD clear_all.
    CLEAR:    gv_tabname,
              gv_error,
              gs_member.

    REFRESH:  gt_member.
  ENDMETHOD."clear_all

  METHOD start_of_selection.
    me->clear_all( ).
    me->get_report( ).
  ENDMETHOD. "start_of_selection

  METHOD get_data.
    me->clear_all( ).

    SELECT *
      FROM zss_lib_member
      INTO TABLE @gt_member
      WHERE pasif NE 'X'.
    me->prepare_alv( iv_struc_name = 'ZSS_LIB_MEMBER_S' ).
  ENDMETHOD. "get_data

  METHOD get_report.
    me->get_data( ).

    IF gt_member IS NOT INITIAL.
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
            ls_variant,
            lt_fc.

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
      me->create_fcat(    EXPORTING ev_struc_name  = iv_struc_name
                          IMPORTING et_fc          = lt_fc ).
*      me->create_fcat(    IMPORTING et_fc          = lt_fc ).
*      me->event_receiver( CHANGING  cs_alvgird     = lo_alvgrid ).
      me->display_alv(    CHANGING  cs_alvgird     = lo_alvgrid
                                    cs_layout      = ls_layout
                                    cs_variant     = ls_variant
                                    ct_output      = gt_member
                                    ct_fielcat     = lt_fc ).
    ELSE .
      me->refresh_alv( CHANGING  cs_alvgird = lo_alvgrid ).
    ENDIF.
  ENDMETHOD. "prepare_alv

  METHOD prepare_alv2.
    IF lo_alvgrid IS INITIAL.
*      me->get_tabname2( iv_tabname = gc_output2 ).
      me->create_container( EXPORTING iv_cont_name = lv_cc2
                            CHANGING  cs_container = lo_container
                                      cs_alv_grid  = lo_alvgrid ).
*      me->create_container2( CHANGING  cs_alv_grid  = lo_alvgrid ).
      me->create_layout(  EXPORTING iv_title       = ' '
                          IMPORTING es_layout      = ls_layout ).
      me->create_variant( EXPORTING iv_handle      = 'A'
                          IMPORTING es_variant     = ls_variant ).
      me->create_fcat(    EXPORTING ev_struc_name  = iv_struc_name
                          IMPORTING et_fc          = lt_fc ).
*      me->create_fcat(    IMPORTING et_fc          = lt_fc ).
*      me->event_receiver( CHANGING  cs_alvgird     = lo_alvgrid ).
      me->display_alv(    CHANGING  cs_alvgird     = lo_alvgrid
                                    cs_layout      = ls_layout
                                    cs_variant     = ls_variant
                                    ct_output      = gt_book
                                    ct_fielcat     = lt_fc ).
    ELSE .
      me->refresh_alv( CHANGING  cs_alvgird = lo_alvgrid ).
    ENDIF.
  ENDMETHOD. "prepare_alv2

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
*       i_structure_name       = gv_tabname
        i_structure_name       = ev_struc_name
      CHANGING
        ct_fieldcat            = et_fc
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.

    IF sy-subrc EQ 0.
      "field catalog ekranda göstermeme i#lemi
*      me->modify_fcat_no_out( EXPORTING iv_field = 'SELECT' CHANGING  ct_fc    = et_fc ).

      "field catalog hotspot
*      me->modify_fcat_hotspot( EXPORTING iv_field = 'TKNUM' CHANGING  ct_fc    = et_fc ).

      "field catalog tan#m de#i#tirme i#lemi
*      lv_text = TEXT-003.
*      me->modify_fcat( EXPORTING iv_field ='EDATU'
*                                 iv_text  = lv_text
*                       CHANGING  ct_fc    = et_fc ).
      "field catalog edite açma i#lemi
*      me->modify_fcat_edit( EXPORTING iv_field = 'DURUM' CHANGING  ct_fc    = et_fc ).
      "field catalog checkbox olarak gösterme i#lemi
*      me->modify_fcat_chkbox( EXPORTING iv_field = 'DURUM' CHANGING  ct_fc    = et_fc ).
      "field catalog hücre renklendirme
*      me->modify_fcat_color( EXPORTING  iv_field = 'ZTERM'
*                                        iv_color = 'C500'
*                             CHANGING   ct_fc    =  et_fc ).

    ENDIF.
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

  METHOD get_tabname2.
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

  METHOD get_data2. "kullanıcıda bulunan kitaplar
    REFRESH gt_borrow.
    SELECT *
      FROM zss_lib_borrow
      WHERE return_date IS NOT NULL
        AND tc EQ @gs_member-tc
      INTO TABLE @gt_borrow.
    DELETE gt_borrow WHERE return_date IS NOT INITIAL.
  ENDMETHOD.

  METHOD get_data3.
    "bütün kitaplar
    SELECT
      kitapid,
      kitapadet,
      kitapadi
     FROM zss_lib_book
     INTO CORRESPONDING FIELDS OF TABLE @gt_book
     WHERE kitapadet NE 0.

    "bütün kitaplardan daha önce aldıgı ve geri vermediği kitapların kaldırılması
    LOOP AT gt_book INTO gs_book.
      READ TABLE gt_borrow INTO gs_borrow WITH KEY kitapid = gs_book-kitapid .
      IF sy-subrc EQ 0.
        DELETE gt_book WHERE kitapid = gs_book-kitapid.
      ENDIF.
    ENDLOOP.
*IF gt_borrow is not initial .
*    SELECT
*        kitapid,
*        kitapadi,
*        kitapadet
*      FROM zss_lib_borrow
*      FOR ALL ENTRIES IN @gt_borrow
**      WHERE kitapid eq @gt_borrow-kitapid
*      WHERE kitapid ne @gt_borrow-kitapid
*      INTO TABLE @DATA(result).
*ENDIF.
  ENDMETHOD.

  METHOD kullanici_pasif.
    me->get_selected_rows( ).
    CLEAR : gs_member, gs_borrow.

    lv_lines = lines( lt_selected_rows ).
    IF lv_lines EQ 0.
      MESSAGE s000(zsuleymans) DISPLAY LIKE 'E'.
    ELSEIF lv_lines EQ 1.

      LOOP AT lt_selected_rows INTO ls_selected_rows.
        READ TABLE gt_member ASSIGNING FIELD-SYMBOL(<lfs_member>) INDEX ls_selected_rows-index.
        IF sy-subrc EQ 0.
          gs_member-tc = <lfs_member>-tc.
        ENDIF.
      ENDLOOP.

      me->get_data2( ).

      READ TABLE gt_borrow INTO gs_borrow INDEX 1. "fazla veri olsada tc değeri aynı oldugu için index 1 ile okuma yapıldı.    "WITH KEY tc = ls_deneme-tc.

      IF gs_borrow-tc IS NOT INITIAL.
        DATA(lv_member_count) = 1.
      ELSE.
        lv_member_count = 0.
      ENDIF.

      IF lv_member_count = 0.
        READ TABLE  gt_member INTO gs_member WITH KEY tc = gs_member-tc.
        IF gs_member-pasif NE 'X'.
          gs_member-pasif = 'X'.
        ENDIF.
        MODIFY zss_lib_member FROM gs_member.
        IF sy-subrc EQ 0.
          COMMIT WORK AND WAIT.
          go_library->get_data( ).
          go_library->refresh_alv_2( ).
        ELSE.
          ROLLBACK WORK.
        ENDIF.
      ELSE.
        MESSAGE s012(zsuleymans) DISPLAY LIKE 'E'.
      ENDIF.

    ELSE.
      MESSAGE s001(zsuleymans) DISPLAY LIKE 'E'.
    ENDIF.

  ENDMETHOD.

  METHOD kullanici_ekle.
    CLEAR : gs_member.
    DATA:
      lt_sval   TYPE TABLE OF sval,
      ls_sval   TYPE sval,
      lv_return TYPE i.


    REFRESH : lt_sval.
    CLEAR : ls_sval.
    ls_sval-tabname   = 'ZSS_LIB_MEMBER'.
    ls_sval-fieldname = 'TC'.
    ls_sval-fieldtext = 'TC Kimlik No'.
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
        popup_title     = 'Kullanıcı Ekle'
      TABLES
        fields          = lt_sval
      EXCEPTIONS
        error_in_fields = 1
        OTHERS          = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    LOOP AT lt_sval ASSIGNING FIELD-SYMBOL(<lfs_sval>).
      CASE <lfs_sval>-fieldname.
        WHEN 'TC'.
          gs_member-tc     = <lfs_sval>-value.
        WHEN 'ADI'.
          gs_member-adi    = <lfs_sval>-value.
        WHEN 'SOYADI'.
          gs_member-soyadi = <lfs_sval>-value.
        WHEN 'PASIF'.
          gs_member-pasif  = <lfs_sval>-value.
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

      IF sy-subrc EQ 0.
        COMMIT WORK AND WAIT.
        go_library->get_data( ).
        go_library->refresh_alv_2( ).
      ELSE.
        ROLLBACK WORK.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD kullanici_sil.
    me->get_selected_rows( ).
    CLEAR : gs_member.
    lv_lines = lines( lt_selected_rows ).
    IF lv_lines EQ 0.
      MESSAGE s000(zsuleymans) DISPLAY LIKE 'E'.
    ELSEIF lv_lines EQ 1.
      LOOP AT lt_selected_rows INTO ls_selected_rows.
        READ TABLE gt_member ASSIGNING FIELD-SYMBOL(<lfs_member>) INDEX ls_selected_rows-index.
        IF sy-subrc EQ 0.
          gs_member-tc = <lfs_member>-tc.
        ENDIF.
      ENDLOOP.

      DELETE FROM zss_lib_member WHERE tc EQ gs_member-tc.
      IF sy-subrc EQ 0.
        COMMIT WORK AND WAIT.
        go_library->get_data( ).
        go_library->refresh_alv_2( ).
        MESSAGE s007(zsuleymans) DISPLAY LIKE 'S'.
      ELSE.
        ROLLBACK WORK.
        MESSAGE s008(zsuleymans) DISPLAY LIKE 'E'.
      ENDIF.

    ELSE.
      MESSAGE s001(zsuleymans) DISPLAY LIKE 'E'.
    ENDIF.

  ENDMETHOD.

  METHOD kitap_ver.
    me->get_selected_rows( ).
*    me->clear_alv( ).    "Call screen 0200 için
    CLEAR : gs_member.
    lv_lines = lines( lt_selected_rows ).
    IF lv_lines EQ 0.
      MESSAGE s000(zsuleymans) DISPLAY LIKE 'E'.
    ELSEIF lv_lines EQ 1.
      LOOP AT lt_selected_rows INTO ls_selected_rows.
        READ TABLE gt_member ASSIGNING FIELD-SYMBOL(<lfs_member>) INDEX ls_selected_rows-index.
        IF sy-subrc EQ 0.
          gs_member-tc     = <lfs_member>-tc.
          gs_member-adi    = <lfs_member>-adi.
          gs_member-soyadi = <lfs_member>-soyadi.
        ENDIF.
      ENDLOOP. "kullanıcı bilgileri gs_member içinde

*      me->prepare_alv2( iv_struc_name = 'ZSS_LIB_BOOK_S' ).   " call screen
*      IF gt_book IS NOT INITIAL.
*        CALL SCREEN 0200.
*      ELSE.
*        MESSAGE s011(zsuleymans) DISPLAY LIKE 'E'.
*        EXIT.
*      ENDIF.

      me->get_data2( ).  "kullanıcının daha önce aldıp vermediği kitaplar
      me->get_data3( ).  "verilebilecek kitapların selecti

      CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
        EXPORTING
          i_title          = 'Ödünç Verilecek Kitaplar'
          i_zebra          = 'X'
          i_tabname        = 1
          i_structure_name = 'ZSS_LIB_BOOK_S'
        IMPORTING
          es_selfield      = ls_selfield
        TABLES
          t_outtab         = gt_book
        EXCEPTIONS
          program_error    = 1
          OTHERS           = 2.

      CLEAR :gs_book, gs_borrow.  "get_data3 method unda dolduruldugu için burda clear yaptım
                                  "get_data3 de daha önce almış oldugu kitabı kontrol ettiğim için , gs_borrow-borrow_date dolu olarak gelmekte

      READ TABLE gt_book INTO gs_book INDEX ls_selfield-tabindex.   "kitap bilgileri gs_book içinde
      lv_adet_count = gs_book-kitapadet.
      IF ls_selfield IS NOT INITIAL.
        IF lv_adet_count > 0.
*        IF    gs_borrow-borrow_date IS INITIAL
*          AND gs_borrow-return_date IS INITIAL.
*          OR  gs_borrow-borrow_date IS NOT INITIAL
*          AND gs_borrow-return_date IS NOT INITIAL.
          gs_borrow-kitapid     = gs_book-kitapid.
          gs_borrow-tc          = gs_member-tc.
          gs_borrow-borrow_date = sy-datum.
          lv_adet_count = lv_adet_count - 1.
*        ENDIF.

          gs_book-kitapadet = lv_adet_count.

          MODIFY zss_lib_book   FROM gs_book.
          MODIFY zss_lib_borrow FROM gs_borrow.
          IF sy-subrc EQ 0.
            COMMIT WORK AND WAIT.
            go_library->get_data3( ).
            go_library->refresh_alv_2( ).
          ELSE.
            ROLLBACK WORK.
          ENDIF.
        ENDIF.

      ENDIF.

    ELSE.
      MESSAGE s001(zsuleymans) DISPLAY LIKE 'E'.
    ENDIF.


*CALL FUNCTION 'POPUP_WITH_TABLE_DISPLAY'
*  EXPORTING
*    endpos_col         = 110
*    endpos_row         = 20
*    startpos_col       = 10
*    startpos_row       = 5
*    titletext          = 'Kitaplar'
** IMPORTING
**   CHOISE             =
*  TABLES
*    valuetab           = gt_book
** EXCEPTIONS
**   BREAK_OFF          = 1
**   OTHERS             = 2
*          .
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF.

*CALL FUNCTION 'ZSS_POPUP_FM'
** EXPORTING
**   I_START_COLUMN       = 25
**   I_START_LINE         = 6
**   I_END_COLUMN         = 100
**   I_END_LINE           = 10
**   I_TITLE              = 'ALV'
*  TABLES
*    it_alv               = gt_book
*          .

*  CALL FUNCTION 'RSPLSSE_ALV_POPUP'
*    EXPORTING
*      it_outtab              = gt_book
*      i_structure_name       = 'ZSS_LIB_BOOK_S'
**     I_START_COLUMN         = 30
**     I_START_ROW            = 10
**     I_WINDOW_WIDTH         = 30
**     I_WINDOW_HEIGTH        = 10
**     I_WINDOW_TITLE         =
*            .

*    lv_mesaj = gs_book-kitapadi.
*    MESSAGE lv_mesaj TYPE 'I'.

  ENDMETHOD.

  METHOD kitap_iade.
    me->get_selected_rows( ).
    CLEAR : gs_member, gs_borrow, gs_book.
    lv_lines = lines( lt_selected_rows ).
    IF lv_lines EQ 0.
      MESSAGE s000(zsuleymans) DISPLAY LIKE 'E'.
    ELSEIF lv_lines EQ 1.
      LOOP AT lt_selected_rows INTO ls_selected_rows.
        READ TABLE gt_member ASSIGNING FIELD-SYMBOL(<lfs_member>) INDEX ls_selected_rows-index.
        IF sy-subrc EQ 0.
          gs_member-tc     = <lfs_member>-tc.
          gs_member-adi    = <lfs_member>-adi.
          gs_member-soyadi = <lfs_member>-soyadi.
        ENDIF.
      ENDLOOP.

      me->get_data2( ).

      "kişinin elindeki kitapların popup ı
      CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
        EXPORTING
          i_title          = 'Ödünç Verilecek Kitaplar'
          i_zebra          = 'X'
          i_tabname        = 1
          i_structure_name = 'ZSS_LIB_BORROW_S'
        IMPORTING
          es_selfield      = ls_selfield
        TABLES
          t_outtab         = gt_borrow
        EXCEPTIONS
          program_error    = 1
          OTHERS           = 2.

      SELECT
        kitapid,
        kitapadet,
        kitapadi
       FROM zss_lib_book
       INTO CORRESPONDING FIELDS OF TABLE @gt_book2
       WHERE kitapadet NE 0.

      CLEAR lv_adet_count.
      LOOP AT gt_book2 INTO gs_book.
        lv_adet_count = gs_book-kitapadet.
        READ TABLE gt_borrow INDEX ls_selfield-tabindex INTO gs_borrow.
        IF gs_borrow-kitapid EQ gs_book-kitapid.
          gs_borrow-return_date = sy-datum.
          lv_adet_count = lv_adet_count + 1.
          EXIT.
        ENDIF.
      ENDLOOP.

      gs_book-kitapadet = lv_adet_count.
      IF gs_borrow IS NOT INITIAL.
        MODIFY zss_lib_book   FROM gs_book.
        MODIFY zss_lib_borrow FROM gs_borrow.
        IF sy-subrc EQ 0.
          COMMIT WORK AND WAIT.
          go_library->get_data3( ).
          go_library->refresh_alv_2( ).
        ELSE.
          ROLLBACK WORK.
        ENDIF.
      ENDIF.
    ELSE.
      MESSAGE s001(zsuleymans) DISPLAY LIKE 'E'.
    ENDIF.

*    BREAK egt_suleyman.
  ENDMETHOD.

  METHOD kitap_sec.
*    me->get_selected_rows( ).
*    CLEAR : gs_book.
*    lv_lines = lines( lt_selected_rows ).
*    IF lv_lines EQ 0.
*      MESSAGE s000(zsuleymans) DISPLAY LIKE 'E'.
*    ELSEIF lv_lines EQ 1.
*      LOOP AT lt_selected_rows INTO ls_selected_rows.
*        READ TABLE gt_book ASSIGNING FIELD-SYMBOL(<lfs_borrow>) INDEX ls_selected_rows-index.
*        IF sy-subrc EQ 0.
*          gs_book-kitapid   = <lfs_borrow>-kitapid.
*          gs_book-kitapadi  = <lfs_borrow>-kitapadi.
*          gs_book-kitapadet = <lfs_borrow>-kitapadet.
*        ENDIF.
*      ENDLOOP.
*
*    ELSE.
*      MESSAGE s001(zsuleymans) DISPLAY LIKE 'E'.
*    ENDIF.

*    lv_mesaj = gs_book-kitapadi.
*    MESSAGE lv_mesaj TYPE 'I'.
*    BREAK egt_suleyman.
  ENDMETHOD.

  METHOD goster.
    SELECT *
      FROM zss_lib_member
      INTO TABLE @gt_member.
    me->prepare_alv( iv_struc_name = 'ZSS_LIB_MEMBER_S' ).
  ENDMETHOD.

ENDCLASS. "lcl_library IMPLEMENTATION
