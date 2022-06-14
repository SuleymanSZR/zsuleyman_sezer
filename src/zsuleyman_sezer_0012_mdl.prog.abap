*&---------------------------------------------------------------------*
*& Include          ZSULEYMAN_SEZER_0012_MDL
*&---------------------------------------------------------------------*

**************   0100   **************
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR '0100'.

  go_luck->set_screen( ).
ENDMODULE.

MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN '&BACK'.
      LEAVE TO SCREEN 0.
    WHEN '&EXIT'.
      LEAVE PROGRAM.
    WHEN '&CHECK'.
      go_luck->input( ).
    WHEN '&PARA'.
      IF gv_eklenecek_para IS NOT INITIAL.
        CALL SCREEN 0200 STARTING AT 10 10 ENDING AT 70 15.
      ELSE.
        MESSAGE s024(zsuleymans) DISPLAY LIKE 'E'.  "Yüklenecek miktarı giriniz.
      ENDIF.
    WHEN '&DENE'.
      go_luck->check_draw( ).

  ENDCASE.

ENDMODULE.

**************   0200   **************
MODULE status_0200 OUTPUT.
  SET PF-STATUS '0200'.
* SET TITLEBAR 'xxx'.
ENDMODULE.

MODULE user_command_0200 INPUT.
  CASE sy-ucomm.
    WHEN '&OK'.
      go_luck->add_balance( ).
    WHEN '&CANCEL'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.

**************   0300   **************
MODULE status_0300 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR '0100'.

  go_luck->set_screen2( ).
ENDMODULE.


MODULE user_command_0300 INPUT.
  CASE sy-ucomm.
    WHEN '&BACK'.
      LEAVE TO SCREEN 0.
    WHEN '&EXIT'.
      LEAVE PROGRAM.
    WHEN '&MAKE_DRAW'.
      go_luck->check_draw( ).
    WHEN '&BUY_TICKET'.
      go_luck->buy_ticket( ).
    WHEN '&SHOW_TICKETS'.
      go_luck->prize_check( ).
  ENDCASE.
ENDMODULE.
