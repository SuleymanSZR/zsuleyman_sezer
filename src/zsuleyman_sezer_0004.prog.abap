*&---------------------------------------------------------------------*
*& Report ZSULEYMAN_SEZER_0004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsuleyman_sezer_0004.

INCLUDE : zsuleyman_sezer_0004_top,
          zsuleyman_sezer_0004_frm,
          zsuleyman_sezer_0004_pbo,
          zsuleyman_sezer_0004_pai.

START-OF-SELECTION.

  PERFORM : get_data,
            set_fieldcat.
 "<dyn_table> assign edilmişse ve boş değilse ekrana gitsin.
  IF <dyn_table> IS ASSIGNED AND <dyn_table> IS NOT INITIAL.
    CALL SCREEN 0100.
  ENDIF.
