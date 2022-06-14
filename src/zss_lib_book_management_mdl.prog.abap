*&---------------------------------------------------------------------*
*& Include          ZSS_LIB_BOOK_MANAGEMENT_MDL
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS_0100'.
  SET TITLEBAR '0100'.

  go_library->prepare_alv( ).
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CLEAR: gv_error.
  CASE sy-ucomm.
    WHEN '&F2' OR '&F3'.
      LEAVE TO SCREEN 0.
    WHEN '&F5'.
      IF go_library IS NOT INITIAL.
        go_library->get_data( ).
        go_library->refresh_alv_2( ).
      ENDIF.
    WHEN '&EKLE'.
      go_library->kitap_ekle( ).
    WHEN '&SIL'.
      go_library->kitap_sil( ).
  ENDCASE.
ENDMODULE.
