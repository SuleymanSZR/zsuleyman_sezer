*&---------------------------------------------------------------------*
*& Include          ZSS_LIB_BOOK_MANAGEMENT_TOP
*&---------------------------------------------------------------------*

CLASS lcl_library DEFINITION DEFERRED.

DATA: go_library    TYPE REF TO lcl_library,
      gv_tabname    TYPE tabname,
      gt_book       TYPE TABLE OF zss_lib_book,
      gs_book       LIKE LINE OF gt_book,
      gv_error      TYPE char1.

CONSTANTS: gc_output TYPE tabname VALUE 'ZSS_LIB_BOOK'.
