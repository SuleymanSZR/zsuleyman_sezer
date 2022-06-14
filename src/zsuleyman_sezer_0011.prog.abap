*&---------------------------------------------------------------------*
*& Report ZSS_LIB_MEMBER_MANAGEMENT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsuleyman_sezer_0011.

INCLUDE ZSULEYMAN_SEZER_0011_TOP.
*INCLUDE: zss_lib_member_management_top2,
INCLUDE ZSULEYMAN_SEZER_0011_CLS.
*         zss_lib_member_management_cls2,
INCLUDE ZSULEYMAN_SEZER_0011_MDL.
*         zss_lib_member_management_mdl2.


START-OF-SELECTION.

  go_library = NEW lcl_library( ).
  go_library->start_of_selection( ).

END-OF-SELECTION.
  go_library->call_screen( ).
