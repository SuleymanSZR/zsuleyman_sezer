*&---------------------------------------------------------------------*
*& Report ZSULEYMAN_SEZER_0006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsuleyman_sezer_0006.


DATA: lt_table TYPE TABLE OF zss_t0001,
      ls_table TYPE zss_t0001.
*DATA: lt_table TYPE TABLE OF zegt_suleyman_t1,
*      ls_table TYPE zegt_suleyman_t1.
PARAMETERS p_file TYPE localfile.

START-OF-SELECTION.

select * from zss_t0001
         INTO TABLE lt_table.
  CALL FUNCTION 'ZSS_EXCEL_DOWNLOAD'
    EXPORTING
      iv_subject = 'Sayfa'
      it_data    = lt_table.
*   IT_TITLE            =
*   IT_COMPONENTS       =.
