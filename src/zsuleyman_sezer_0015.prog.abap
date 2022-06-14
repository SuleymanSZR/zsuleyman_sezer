*&---------------------------------------------------------------------*
*& Report ZSULEYMAN_SEZER_0015
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsuleyman_sezer_0015.

INCLUDE : zsuleyman_sezer_0015_top,
          zsuleyman_sezer_0015_cls,
          zsuleyman_sezer_0015_mdl.

START-OF-SELECTION.

  go_calendar = NEW lcl_calendar( ).
  IF  p_month IS NOT INITIAL.
    go_calendar->start_of_selection( ).
  ELSE.
    MESSAGE s025(zsuleymans) DISPLAY LIKE 'E'.
  ENDIF.
