*&---------------------------------------------------------------------*
*& Report ZSULEYMAN_SEZER_0012
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsuleyman_sezer_0012.

INCLUDE : zsuleyman_sezer_0012_top,
          zsuleyman_sezer_0012_cls,
          zsuleyman_sezer_0012_mdl.

START-OF-SELECTION.
  go_luck = NEW lcl_luck( ).
  go_luck->start_of_selection( ).
