*&---------------------------------------------------------------------*
*& Include          ZSS_LIB_MEMBER_MANAGEMENT_MDL2
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module status_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR '0100'.

  go_library->display_alv( ).
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  user_command_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN '&BACK'.
      LEAVE TO SCREEN 0.
    WHEN '&F5'.
      IF go_library IS NOT INITIAL.
        go_library->get_data( ).
        go_library->refresh_alv( ).
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
  ENDCASE.
ENDMODULE.
