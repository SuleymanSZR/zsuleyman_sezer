FUNCTION ZSS_POPUP_FM.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_START_COLUMN) TYPE  I DEFAULT 25
*"     REFERENCE(I_START_LINE) TYPE  I DEFAULT 6
*"     REFERENCE(I_END_COLUMN) TYPE  I DEFAULT 100
*"     REFERENCE(I_END_LINE) TYPE  I DEFAULT 10
*"     REFERENCE(I_TITLE) TYPE  STRING DEFAULT 'ALV'
*"  TABLES
*"      IT_ALV TYPE  STANDARD TABLE
*"----------------------------------------------------------------------
*”———————————————————————-
*”*”Local interface:
*”  IMPORTING
*”    REFERENCE(I_START_COLUMN) TYPE  I DEFAULT 25
*”    REFERENCE(I_START_LINE)   TYPE  I DEFAULT 6
*”    REFERENCE(I_END_COLUMN)   TYPE  I DEFAULT 100
*”    REFERENCE(I_END_LINE)     TYPE  I DEFAULT 10
*”    REFERENCE(I_TITLE) TYPE  STRING DEFAULT ‘ALV’
*”  TABLES
*”      IT_ALV TYPE  STANDARD TABLE
*”———————————————————————-

   DATA:
    go_popup  TYPE REF TO cl_reca_gui_f4_popup,
    gf_choice TYPE flag.

   CALL METHOD cl_reca_gui_f4_popup=>factory_grid
    EXPORTING
      it_f4value    = it_alv[]
      if_multi      = abap_false
      id_title      = i_title
    RECEIVING
      ro_f4_instance = go_popup.

   CALL METHOD go_popup->display
    EXPORTING
      id_start_column = i_start_column
      id_start_line  = i_start_line
      id_end_column  = i_end_column
      id_end_line    = i_end_line
    IMPORTING
      et_result      = it_alv[]
      ef_cancelled    = gf_choice.

ENDFUNCTION.
