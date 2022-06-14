*&---------------------------------------------------------------------*
*& Include          ZSS_LIB_BOOK_MANAGEMENT_CLS
*&---------------------------------------------------------------------*

CLASS lcl_library DEFINITION.
  PUBLIC SECTION.
    METHODS:
      start_of_selection,
      clear_all,
      get_data,
      set_fieldcat,
      set_layout,
      display_alv,
      kitap_ekle,
      kitap_sil,
      call_screen,
      get_selected_rows.


    DATA :
      lo_alvgrid       TYPE REF TO cl_gui_alv_grid,
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
      FROM zss_lib_book
      INTO TABLE @gt_book.
*    BREAK egt_suleyman.
    me->set_fieldcat( ).
    me->set_layout( ).

  ENDMETHOD.

  METHOD clear_all.

  ENDMETHOD.

  METHOD get_selected_rows.
    CLEAR:  lt_selected_rows,
            ls_selected_rows,
            lv_lines.

    CALL METHOD lo_alvgrid->get_selected_rows
      IMPORTING
        et_index_rows = lt_selected_rows.

  ENDMETHOD.

  METHOD display_alv.

    go_alv = NEW cl_gui_alv_grid(
            i_parent          = cl_gui_container=>screen0 ).

    CALL METHOD go_alv->set_table_for_first_display
      EXPORTING
        is_layout       = gs_layout
      CHANGING
        it_outtab       = gt_book
        it_fieldcatalog = gt_fieldcat.

  ENDMETHOD.

  METHOD call_screen.
    CHECK:
      lines( gt_book ) NE 0.
    CALL SCREEN 0100.
  ENDMETHOD.

  METHOD set_fieldcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZSS_LIB_BOOK_S'
      CHANGING
        ct_fieldcat      = gt_fieldcat.
  ENDMETHOD.

  METHOD set_layout.
    gs_layout-zebra = 'X'.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-col_opt = abap_true.
  ENDMETHOD.

  METHOD kitap_ekle.

  ENDMETHOD.

  METHOD kitap_sil.

  ENDMETHOD.
ENDCLASS.
