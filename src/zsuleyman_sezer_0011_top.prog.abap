*&---------------------------------------------------------------------*
*& Include          ZSS_LIB_MEMBER_MANAGEMENT_TOP2
*&---------------------------------------------------------------------*
CLASS lcl_library DEFINITION DEFERRED.
"genel tanımlar
DATA: gt_member        TYPE TABLE OF zss_lib_member,
      gs_member        like LINE OF gt_member,
      gt_fieldcat      TYPE lvc_t_fcat,
      gs_fieldcat      TYPE lvc_s_fcat,
      gs_layout        TYPE lvc_s_layo.



"class tanımları
DATA: go_library TYPE REF TO lcl_library,
      go_alv     TYPE REF TO cl_gui_alv_grid.
