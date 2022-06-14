*&---------------------------------------------------------------------*
*& Report ZSULEYMAN_SEZER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsuleyman_sezer_0003.

INCLUDE : zsuleyman_sezer_top,
          zsuleyman_sezer_cls1,
          zsuleyman_sezer_pbo,
          zsuleyman_sezer_pai.

START-OF-SELECTION.

*CREATE OBJECT go_oo_alv.
go_oo_alv = new lcl_alv( ).

go_oo_alv->get_data( ).
go_oo_alv->set_layout( ).
go_oo_alv->set_fieldcat( ).

CASE abap_true.
  WHEN p_full.
    go_oo_alv->display_alv_full( ).
  WHEN p_cont.
    go_oo_alv->display_alv_cont( ).
  WHEN p_event.
    go_oo_alv->display_alv_event( ).
ENDCASE.

call SCREEN 0100.

* ZVKT_R_OOALV  hazır kullanıma hazır şablon
