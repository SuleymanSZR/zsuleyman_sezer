*&---------------------------------------------------------------------*
*& Include          ZSULEYMAN_SEZER_0015_TOP
*&---------------------------------------------------------------------*
CLASS lcl_calendar DEFINITION DEFERRED.

DATA: go_calendar TYPE REF TO lcl_calendar,
      go_grid     TYPE REF TO cl_gui_alv_grid.

DATA: gt_table    TYPE REF TO data,
      gs_table    TYPE REF TO data,
      gt_fieldcat TYPE lvc_t_fcat,
      gs_fieldcat TYPE lvc_s_fcat,
      gs_layout   TYPE lvc_s_layo.

FIELD-SYMBOLS: <dyn_table> TYPE STANDARD TABLE,
               <gfs_table>,
               <gfs1>.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS    :  p_month  TYPE  /bi0/oicalmonth.
SELECTION-SCREEN END OF BLOCK b1.
