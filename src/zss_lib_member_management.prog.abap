*&---------------------------------------------------------------------*
*& Report ZSS_LIB_MEMBER_MANAGEMENT
*&---------------------------------------------------------------------*
REPORT zss_lib_member_management.

INCLUDE: zss_lib_member_management_top,
         zss_lib_member_management_cls,
         zss_lib_member_management_mdl.

START-OF-SELECTION.

  go_library = NEW lcl_library( ).
  go_library->start_of_selection( ).
