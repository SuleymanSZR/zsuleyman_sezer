*&---------------------------------------------------------------------*
*& Report ZSULEYMAN_SEZER_REUSE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsuleyman_sezer_0001.

INCLUDE : zsuleyman_sezer_reuse_top,
          zsuleyman_sezer_reuse_frm.

START-OF-SELECTION.

  PERFORM : get_data,
            set_fcat,
            set_layout.


  CASE abap_true.
    WHEN r_grid.
      PERFORM display_alv.
    WHEN r_list.
      PERFORM display_list.
    WHEN r_popup.
      PERFORM display_popup.
  ENDCASE.
