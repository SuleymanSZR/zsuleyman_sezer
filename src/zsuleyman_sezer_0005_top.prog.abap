*&---------------------------------------------------------------------*
*& Include          ZSULEYMAN_SEZER_0005_TOP
*&---------------------------------------------------------------------*
TABLES : sscrfields.
TYPES : BEGIN OF gty_list,
          ogrenci_no     TYPE zem_de_ogrno,
          ogrenci_adi    TYPE zem_de_ograd,
          ogrenci_soyadi TYPE zem_de_ogsoy,
          ogrenci_yasi   TYPE zem_de_ogyas,
        END OF gty_list.



*DATA : gt_list     TYPE TABLE OF zegt_suleyman_s001,
DATA : gt_list     TYPE TABLE OF gty_list,
       gs_list     LIKE LINE OF gt_list,
       gt_fieldcat TYPE slis_t_fieldcat_alv,
       gs_layout   TYPE slis_layout_alv.

DATA : gs_sel_button TYPE smp_dyntxt.

PARAMETERS : p_file TYPE localfile.

SELECTION-SCREEN FUNCTION KEY 1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file. "
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = 'P_FILE'
    IMPORTING
      file_name     = p_file.

AT SELECTION-SCREEN.
  CASE sscrfields-ucomm.
    WHEN 'FC01'.
      PERFORM download_temp using 'ZEM_OGRENCI'.
  ENDCASE.
