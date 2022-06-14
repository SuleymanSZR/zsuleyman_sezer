*&---------------------------------------------------------------------*
*& Report ZSULEYMAN_SEZER_0007
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

REPORT zsuleyman_sezer_0007.

INCLUDE :zsuleyman_sezer_0007_top,
         zsuleyman_sezer_0007_cls,
         zsuleyman_sezer_0007_mdl.


START-OF-SELECTION.

  go_report = NEW lcl_report( ).
  go_report->start_of_selection( ).

  IF gt_output IS NOT INITIAL.
    CALL SCREEN 0100.
  ELSE.
    MESSAGE s001(zzy_0001) DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.
