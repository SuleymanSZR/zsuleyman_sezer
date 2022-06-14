*&---------------------------------------------------------------------*
*& Include          ZSS_LIB_MEMBER_MANAGEMENT_MDL
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS_0100'.
  SET TITLEBAR '0100'.

*  go_library->prepare_alv( ).
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
      go_library->kullanici_ekle( ).
    WHEN '&SIL'.
      go_library->kullanici_sil( ).
    WHEN '&PASIF'.
      go_library->kullanici_pasif( ).
    WHEN '&VER'.
      go_library->kitap_ver( ).
    WHEN '&IADE'.
      go_library->kitap_iade( ).
    WHEN '&GOSTER'.
      go_library->goster( ).
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS 'STATUS_0200'.
  SET TITLEBAR '0100'.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  CLEAR: gv_error.
  CASE sy-ucomm.
    WHEN '&F2' OR '&F3'.
      LEAVE TO SCREEN 0.
    WHEN '&F5'.
      IF go_library IS NOT INITIAL.
        go_library->get_data2( ).
        go_library->refresh_alv_2( ).
      ENDIF.
    WHEN '&SEC'.
      go_library->kitap_sec( ).
  ENDCASE.
ENDMODULE.
