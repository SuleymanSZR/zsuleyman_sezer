*&---------------------------------------------------------------------*
*& Include          ZSULEYMAN_SEZER_0015_CLS
*&---------------------------------------------------------------------*
CLASS lcl_calendar DEFINITION.

  PUBLIC SECTION.
    TYPES : BEGIN OF gty_alv,
              day TYPE string,
            END OF gty_alv.

    DATA: gv_month     TYPE char2,
          gv_day_count TYPE int4,
          gv_day       TYPE scal-indicator,
          gt_alv       TYPE TABLE OF gty_alv.

    METHODS: start_of_selection,
      get_day,
      set_fieldcat,
      set_layout,
      display_alv,
      build_alv,
      build_fcat IMPORTING iv_col_pos   TYPE lvc_colpos
                           iv_fieldname TYPE lvc_fname
                           iv_scrtext_s TYPE string
                           iv_scrtext_m TYPE string
                           iv_scrtext_l TYPE string
                           iv_weekend   TYPE int1.

ENDCLASS. "end defination


CLASS lcl_calendar IMPLEMENTATION .

  METHOD start_of_selection.
    me->get_day( ).
  ENDMETHOD.

  METHOD build_fcat.

    CLEAR gs_fieldcat.
    gs_fieldcat-col_pos = iv_col_pos.
    gs_fieldcat-fieldname = iv_fieldname.
    gs_fieldcat-scrtext_s = iv_scrtext_s.
    gs_fieldcat-scrtext_m = iv_scrtext_m.
    gs_fieldcat-scrtext_l = iv_scrtext_l.
    gs_fieldcat-datatype = 'CHAR'.
    gs_fieldcat-intlen = 40.

    CASE iv_weekend.
      WHEN 1.
        gs_fieldcat-emphasize = 'C611'.
      WHEN OTHERS.
        gs_fieldcat-emphasize = 'C400'.
    ENDCASE.

    APPEND gs_fieldcat TO gt_fieldcat.
  ENDMETHOD.

  METHOD build_alv.

    CALL METHOD cl_alv_table_create=>create_dynamic_table
      EXPORTING
        it_fieldcatalog = gt_fieldcat
      IMPORTING
        ep_table        = gt_table.

    ASSIGN gt_table->* TO <dyn_table>.
    CREATE DATA gs_table LIKE LINE OF <dyn_table>.
    ASSIGN gs_table->* TO <gfs_table>.

    DATA(lv_counter) = 1.
    DATA(lv_max) = lines( gt_alv ).
    WHILE lv_counter <= lv_max.
      DATA lv_temp TYPE string.
      APPEND INITIAL LINE TO <dyn_table> ASSIGNING <gfs_table>.
      LOOP AT gt_alv INTO DATA(gs_alv).
        IF <gfs_table> IS ASSIGNED.
          READ TABLE gt_fieldcat INDEX lv_counter INTO DATA(ls_fcat).
          lv_temp = ls_fcat-fieldname.
          ASSIGN COMPONENT lv_temp OF STRUCTURE <gfs_table> TO <gfs1>.
          IF <gfs1> IS ASSIGNED.
            <gfs1> = gs_alv-day.
            lv_counter = lv_counter + 1.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDWHILE.
    me->display_alv( ).
  ENDMETHOD.

  METHOD get_day.
    gv_month = p_month+4(2).

    DATA: lv_initial_date   TYPE p0001-begda,
          lv_temp_date      TYPE p0001-begda,
          lv_year_month     TYPE string, "yıl-ay
          lv_year_month_day TYPE string, "yıl-ay-gun
          lv_result         TYPE gty_alv.

    DATA: lv_day       TYPE c,
          lv_last_date TYPE datum,
          lv_col_pos   TYPE lvc_colpos.

    lv_year_month = p_month.

    CONCATENATE lv_year_month '01' INTO lv_year_month_day.
    lv_initial_date = lv_year_month_day.
    lv_temp_date    = lv_year_month_day.

    CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'   "ayın kaç çektiğinin bulunması
      EXPORTING
        day_in            = lv_initial_date
      IMPORTING
        last_day_of_month = lv_last_date.

    lv_col_pos = 1.
    gv_day_count = lv_last_date+6(2).   "bulunan ayın son gününü değişene atar

    DATA: lv_month(10) TYPE c.
    SELECT SINGLE ltx
      FROM t247
      INTO @lv_month
      WHERE spras = 'TR'
      AND mnr = @p_month+4(2). "==> month.

    DATA: lv_field   TYPE string,
          lv_field_s TYPE string.
    DATA: lv_first_day TYPE char30.  "build_fcat fieldname ile aynı olmalı

    DO ( gv_day_count ) TIMES.

      CALL FUNCTION 'DATE_COMPUTE_DAY'
        EXPORTING
          date   = lv_temp_date
        IMPORTING
          day    = lv_day
        EXCEPTIONS
          OTHERS = 8.

      CASE lv_day.
        WHEN 1.
          lv_result-day = 'Pazartesi'.
        WHEN 2.
          lv_result-day = 'Salı'.
        WHEN 3.
          lv_result-day = 'Çarşamba'.
        WHEN 4.
          lv_result-day = 'Perşembe'.
        WHEN 5.
          lv_result-day = 'Cuma'.
        WHEN 6.
          lv_result-day = 'Cumartesi'.
        WHEN 7.
          lv_result-day = 'Pazar'.
      ENDCASE.

*      CALL FUNCTION 'CONVERT_DATE_TO_EXTERNAL'  "tarih dönüşümü 20220608  08.06.2022
*        EXPORTING
*          date_internal = lv_temp_date
*        IMPORTING
*          date_external = lv_field.
*      lv_first_day = lv_field(2).       "dönüşmüş halden gün alma
      lv_first_day = lv_temp_date+6(2).  "dönüştürmeden günü alma

      CONCATENATE lv_first_day space lv_month    INTO lv_field   SEPARATED BY space.  " alv de full gösterim
      CONCATENATE lv_first_day space lv_month(3) INTO lv_field_s SEPARATED BY space.  " alv de s için gösterim

      IF lv_day = 6 OR lv_day = 7 .
        me->build_fcat(
          EXPORTING
                  iv_col_pos   = lv_col_pos
                  iv_fieldname = lv_first_day
                  iv_scrtext_s = lv_field_s
                  iv_scrtext_m = lv_field
                  iv_scrtext_l = lv_field
                  iv_weekend = 1
        ).
      ELSE.
        me->build_fcat(
          EXPORTING
            iv_col_pos   = lv_col_pos
            iv_fieldname = lv_first_day
            iv_scrtext_s = lv_field_s
            iv_scrtext_m = lv_field
            iv_scrtext_l = lv_field
            iv_weekend = 0
        ).

      ENDIF.
      lv_temp_date = lv_temp_date + 1.
      lv_col_pos = lv_col_pos + 1.
      APPEND lv_result TO gt_alv.
    ENDDO.

    me->build_alv( ).
  ENDMETHOD.

  METHOD display_alv.
    IF go_grid IS INITIAL.
      me->set_layout( ).
      CREATE OBJECT go_grid
        EXPORTING
          i_parent = cl_gui_container=>screen0.    " Parent Container

      CALL METHOD go_grid->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout   " Layout
        CHANGING
          it_outtab       = <dyn_table>   " Output Table
          it_fieldcatalog = gt_fieldcat.   " Field Catalog
    ELSE.
      CALL METHOD go_grid->refresh_table_display.
    ENDIF.
    WRITE : 'a'.
  ENDMETHOD.

  METHOD set_fieldcat.

  ENDMETHOD.

  METHOD set_layout.
    gs_layout-cwidth_opt = 'X'.
    gs_layout-zebra = 'X'.
    gs_layout-ctab_fname = 'CELL_COLOR'.
  ENDMETHOD.
ENDCLASS.  "end implementation
