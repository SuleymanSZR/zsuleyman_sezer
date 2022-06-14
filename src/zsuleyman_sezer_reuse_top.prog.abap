*&---------------------------------------------------------------------*
*& Include          ZSULEYMAN_SEZER_REUSE_TOP
*&---------------------------------------------------------------------*

TABLES : vbak.
SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : so_vbeln FOR vbak-vbeln.
SELECTION-SCREEN : END OF BLOCK b1.


SELECTION-SCREEN : BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
PARAMETERS : r_grid  RADIOBUTTON GROUP rb1,
             r_list  RADIOBUTTON GROUP rb1,
             r_popup RADIOBUTTON GROUP rb1.
SELECTION-SCREEN : END OF BLOCK b2.


TYPES : BEGIN OF gty_table,
          vbeln      TYPE vbeln_va,
          kunnr      TYPE kunag,
          netwr      TYPE netwr_ak,
          waerk      TYPE waerk,
          vkorg      TYPE vkorg,
          erdat      TYPE erdat,
          spart      TYPE spart,
          line_color TYPE char4,
          cell_color TYPE slis_t_specialcol_alv,
        END OF gty_table.

DATA: gs_cellcolor  TYPE slis_specialcol_alv.

DATA : gs_table    TYPE gty_table,
       gt_table    TYPE TABLE OF gty_table,
       gt_fieldcat TYPE  slis_t_fieldcat_alv,
       gs_layout   TYPE  slis_layout_alv.
