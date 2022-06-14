*&---------------------------------------------------------------------*
*& Include          ZSULEYMAN_SEZER_REUSE_FRM
*&---------------------------------------------------------------------*


FORM get_data .

  SELECT vbeln,
         kunnr,
         netwr,
         waerk,
         vkorg,
         erdat,
         spart
    FROM vbak
    INTO CORRESPONDING FIELDS OF TABLE @gt_table
    WHERE vbak~vbeln IN @so_vbeln.

  LOOP AT gt_table INTO DATA(ls_table).
    IF ls_table-netwr EQ 2000.
      ls_table-line_color = 'C610'.
    ELSEIF ls_table-netwr EQ 300.
      ls_table-line_color = 'C110'.
    ENDIF.
*    MODIFY gt_table FROM ls_table.

    IF ls_table-waerk = 'TRY'.
      CLEAR gs_cellcolor.
      gs_cellcolor-fieldname = 'NETWR'.
      gs_cellcolor-color-col = 6.
      gs_cellcolor-color-int = 1.
      APPEND gs_cellcolor TO ls_table-cell_color.

      CLEAR gs_cellcolor.
      gs_cellcolor-fieldname = 'VBELN'.
      gs_cellcolor-color-col = 3.
      gs_cellcolor-color-int = 1.
      gs_cellcolor-color-inv = 1.
      APPEND gs_cellcolor TO ls_table-cell_color.

      CLEAR gs_cellcolor.
      gs_cellcolor-fieldname = 'VKORG'.
      gs_cellcolor-color-col = 5.
      gs_cellcolor-color-int = 1.
      gs_cellcolor-color-inv = 1.
      APPEND gs_cellcolor TO ls_table-cell_color.

    ELSEIF ls_table-waerk = 'USD'.
      CLEAR gs_cellcolor.
      gs_cellcolor-fieldname = 'NETWR'.
      gs_cellcolor-color-col = 3.
      gs_cellcolor-color-int = 1.
      gs_cellcolor-color-inv = 1.
      APPEND gs_cellcolor TO ls_table-cell_color.

    ENDIF.
    MODIFY gt_table FROM ls_table.

  ENDLOOP.

ENDFORM.


FORM set_fcat .

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = 'ZSZR_S0001'
    CHANGING
      ct_fieldcat      = gt_fieldcat.

ENDFORM.


FORM set_layout .

  gs_layout-zebra = abap_true.
*  gs_layout-zebra = 'X'.
  gs_layout-colwidth_optimize = abap_true.
  gs_layout-info_fieldname = 'LINE_COLOR'.
  gs_layout-coltab_fieldname = 'CELL_COLOR'.

ENDFORM.


FORM display_alv .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      is_layout   = gs_layout
      it_fieldcat = gt_fieldcat
    TABLES
      t_outtab    = gt_table.

ENDFORM.


FORM display_list .

  CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
    EXPORTING
      is_layout   = gs_layout
      it_fieldcat = gt_fieldcat
    TABLES
      t_outtab    = gt_table.


ENDFORM.


FORM display_popup .

  CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
    EXPORTING
      i_title          = 'POP-UP ALV'
      i_zebra          = 'X'
      i_tabname        = 1
      i_structure_name = 'ZSZR_S0001'
*     IT_FIELDCAT      =
    TABLES
      t_outtab         = gt_table.

ENDFORM.
