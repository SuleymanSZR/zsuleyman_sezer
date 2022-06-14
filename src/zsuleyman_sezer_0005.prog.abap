*&---------------------------------------------------------------------*
*& Report ZSULEYMAN_SEZER_0005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSULEYMAN_SEZER_0005.

INCLUDE : ZSULEYMAN_SEZER_0005_top,
          ZSULEYMAN_SEZER_0005_frm.

INITIALIZATION.
PERFORM : add_button.

START-OF-SELECTION.

PERFORM : get_data,
          set_fieldcat,
          set_layout.

PERFORM : display_alv.
