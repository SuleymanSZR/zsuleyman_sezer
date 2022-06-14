*&---------------------------------------------------------------------*
*& Include          ZSULEYMAN_SEZER_TOP
*&---------------------------------------------------------------------*
CLASS lcl_alv DEFINITION DEFERRED.
TABLES : mara.

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS : so_matnr for mara-matnr.
SELECTION-SCREEN : END OF BLOCK b1.

SELECTION-SCREEN : BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
PARAMETERS : p_full RADIOBUTTON GROUP rb1 DEFAULT 'X',
             p_cont RADIOBUTTON GROUP rb1,
             p_event RADIOBUTTON GROUP rb1.
SELECTION-SCREEN : END OF BLOCK b2.

DATA : go_oo_alv TYPE REF TO lcl_alv.
