*&---------------------------------------------------------------------*
*& Include          ZSS_LIB_MEMBER_MANAGEMENT_TOP
*&---------------------------------------------------------------------*

CLASS lcl_library DEFINITION DEFERRED.
TABLES : zss_lib_member, zss_lib_book, zss_lib_borrow, zss_lib_data.
DATA: go_library TYPE REF TO lcl_library,
      gv_tabname TYPE tabname,
      gt_member  TYPE TABLE OF zss_lib_member,
      gt_book    TYPE TABLE OF zss_lib_book,
      gt_book2   TYPE TABLE OF zss_lib_book,
      gt_borrow  TYPE TABLE OF zss_lib_borrow,
      gt_data    TYPE TABLE OF zss_lib_data,
      gs_member  LIKE LINE OF gt_member,
      gs_book    LIKE LINE OF gt_book,
      gs_borrow  LIKE LINE OF gt_borrow,
      gs_data    LIKE LINE OF gt_data,
      gv_error   TYPE char1.

CONSTANTS: gc_output  TYPE tabname VALUE 'ZSS_LIB_MEMBER',
           gc_output2 TYPE tabname VALUE 'ZSS_LIB_BOOK'.
