*&---------------------------------------------------------------------*
*& Report ZSS_LIB_BOOK_MANAGEMENT
*&---------------------------------------------------------------------*
REPORT zsuleyman_sezer_0010.

INCLUDE ZSULEYMAN_SEZER_0010_TOP.
INCLUDE ZSULEYMAN_SEZER_0010_CLS.
INCLUDE ZSULEYMAN_SEZER_0010_MDL.

START-OF-SELECTION.

  go_library = NEW lcl_library( ).
  go_library->start_of_selection( ).

END-OF-SELECTION.
  go_library->call_screen( ).
