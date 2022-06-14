*&---------------------------------------------------------------------*
*& Include          ZSULEYMAN_SEZER_0005_FRM
*&---------------------------------------------------------------------*

FORM get_data .
*  gs_list-ogrenci_no = '123456789'.
*  gs_list-ogrenci_adi = 'Süleyman'.
*  gs_list-ogrenci_soyadi = 'sezer'.
*  APPEND gs_list TO gt_list.
  DATA : lt_raw TYPE truxs_t_text_data.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
      i_line_header        = abap_true " başlık varsa 2. satrıdan veri alır , false başlık yok
      i_tab_raw_data       = lt_raw
      i_filename           = p_file
    TABLES
      i_tab_converted_data = gt_list
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
*  IF sy-subrc <> 0.
*    MESSAGE text-001 TYPE 'I'.
*  ENDIF.

  BREAK egt_suleyman.

ENDFORM.


FORM set_fieldcat .
  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
*     I_PROGRAM_NAME   =
*     I_INTERNAL_TABNAME           =
      i_structure_name = 'ZSS_S0001'
*      i_structure_name = 'ZEGT_SULEYMAN_S001'
*      i_structure_name = 'ZEGT_STRUCTER_EXCEL_UPLOAD'
    CHANGING
      ct_fieldcat      = gt_fieldcat.

ENDFORM.


FORM set_layout .
  gs_layout-zebra = abap_true.
  gs_layout-colwidth_optimize = abap_true.
ENDFORM.


FORM display_alv .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = gs_layout
      it_fieldcat        = gt_fieldcat
    TABLES
      t_outtab           = gt_list
*   EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.

FORM add_button .
  gs_sel_button-icon_id = icon_xls.
  gs_sel_button-icon_text = 'Şablon'.
  gs_sel_button-quickinfo = 'Şablonu indir'.
  sscrfields-functxt_01 = gs_sel_button.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DOWNLOAD_TEMP
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*      -->P_       text
*&---------------------------------------------------------------------*
FORM download_temp  USING pv_object TYPE w3objid.
  DATA : ls_return TYPE bapiret2.
  CALL FUNCTION 'Z_EXPORT_TEMPLATE'
    EXPORTING
      iv_object_name = pv_object
    IMPORTING
      es_return      = ls_return.

  IF ls_return-type = 'E'.
    MESSAGE ID ls_return-id TYPE 'I' NUMBER ls_return-number.
  ENDIF.

ENDFORM.
