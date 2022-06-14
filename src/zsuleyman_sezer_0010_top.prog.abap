*&---------------------------------------------------------------------*
*& Include          ZSS_LIB_BOOK_MANAGEMENT_TOP
*&---------------------------------------------------------------------*
CLASS lcl_library DEFINITION DEFERRED.
"genel tanımlar
DATA: gt_book    TYPE TABLE OF zss_lib_book,
      gt_fieldcat TYPE lvc_t_fcat,
      gs_fieldcat TYPE lvc_s_fcat,
      gs_layout   TYPE lvc_s_layo.


"class tanımları
DATA: go_library TYPE REF TO lcl_library,
      go_alv     TYPE REF TO cl_gui_alv_grid.
