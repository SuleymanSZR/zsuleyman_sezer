*&---------------------------------------------------------------------*
*& Include          ZSULEYMAN_SEZER_0012_TOP
*&---------------------------------------------------------------------*
CLASS lcl_luck DEFINITION DEFERRED.

DATA: go_luck TYPE REF TO lcl_luck,
      go_alv  TYPE REF TO cl_gui_alv_grid.

DATA : gv_balance TYPE int4." value 500.

TYPES: BEGIN OF gty_luck,
         num1 TYPE int4,
         num2 TYPE int4,
         num3 TYPE int4,
         num4 TYPE int4,
         num5 TYPE int4,
         num6 TYPE int4,
       END OF gty_luck.


TYPES: BEGIN OF gty_card,
         first_4  TYPE int4,
         second_4 TYPE int4,
         third_4  TYPE int4,
         fourth_4 TYPE int4,
       END OF gty_card.

DATA: gs_output TYPE gty_luck,
      gt_input  TYPE TABLE OF gty_luck,
      gs_input  LIKE LINE OF gt_input.

DATA:
  gs_card           TYPE gty_card,
  gv_cvv            TYPE int4,
  gv_eklenecek_para TYPE int4.
DATA :
  gv_ticket_type  TYPE zss_ticket_de,   "bilet türü
  gv_ticket_draw  TYPE datum,           "çekiliş günü
  gv_ticket_date  TYPE datum,           "bilet tarihi
  gv_ticket_count TYPE int4.            "bilet adeti
DATA :
  gt_fieldcat TYPE lvc_t_fcat,          "alv için
  gs_fieldcat TYPE lvc_s_fcat,
  gs_layout   TYPE lvc_s_layo,
  gt_cekilis  TYPE TABLE OF zss_t0006,  "çekiliş
  gs_cekilis  TYPE zss_t0006.
DATA :
  gv_fieldcat TYPE char7.

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS : p_rad1 RADIOBUTTON GROUP rb1 DEFAULT 'X',
             p_rad2 RADIOBUTTON GROUP rb1,
             p_rad3 RADIOBUTTON GROUP rb1,
             p_rad4 RADIOBUTTON GROUP rb1.
SELECTION-SCREEN : END OF BLOCK b1.
