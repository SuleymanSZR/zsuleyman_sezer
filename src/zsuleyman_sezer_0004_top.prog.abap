*&---------------------------------------------------------------------*
*& Include          ZSULEYMAN_SEZER_0004_TOP
*&---------------------------------------------------------------------*

DATA: gt_alv    TYPE TABLE OF zegt_ogrl_t0001,
      gt_ilkodu TYPE TABLE OF zegt_ogrl_t0001,
      gt_malzm  TYPE TABLE OF zegt_ogrl_t0001,
      gt_fcat   TYPE lvc_t_fcat,
      gs_fcat   TYPE lvc_s_fcat.

*"dinamik veriler için
DATA : go_table TYPE REF TO data,
       gs_table TYPE REF TO data.

DATA : go_grid TYPE REF TO cl_gui_alv_grid,
       gs_layout TYPE lvc_s_layo.

FIELD-SYMBOLS : <dyn_table> TYPE STANDARD TABLE,
                <gfs_table>,
                <gfs1>.
