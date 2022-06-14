*&---------------------------------------------------------------------*
*& Report ZSULEYMAN_SEZER_0009
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsuleyman_sezer_0009.

*DATA: lt_table TYPE TABLE OF ZSS_VBAP,
*      ls_table TYPE ZSS_VBAP.
*
*START-OF-SELECTION.
*
*  SELECT * FROM ZSS_VBAP
*           INTO TABLE lt_table.
*  CALL FUNCTION 'ZSS_EXCEL_DOWNLOAD'
*    EXPORTING
*      iv_subject = 'Sayfa'
*      it_data    = lt_table.


*DATA lv_fiyat TYPE wrbtr.
*DATA lv_char TYPE char30.
*DATA lv_char2 TYPE char30.
*lv_fiyat = '12000.24'.
**lv_char = lv_fiyat.
*
*CALL FUNCTION 'HRCM_AMOUNT_TO_STRING_CONVERT'   "tam sayıyı ondalıklıya çevirme
*EXPORTING
*    betrg                         = lv_fiyat
**   WAERS                         = ' '
**   NEW_DECIMAL_SEPARATOR         =
*    NEW_THOUSANDS_SEPARATOR       = '.'
*IMPORTING
*   STRING                        = lv_char
*.
*
*CONDENSE lv_char.


*DATA: BEGIN OF sentence,
*        word1 TYPE c LENGTH 30 VALUE 'She',
*        word2 TYPE c LENGTH 30 VALUE 'feeds',
*        word3 TYPE c LENGTH 30 VALUE 'you',
*        word4 TYPE c LENGTH 30 VALUE 'tea',
*        word5 TYPE c LENGTH 30 VALUE 'and',
*        word6 TYPE c LENGTH 30 VALUE 'oranges',
*      END OF sentence,
*      text TYPE string.
*
*text = sentence.
*CONDENSE text.    "uzunluktan boşluk kaldırma
*
*WRITE : sentence,
*        text.

DATA: lv_sayi TYPE int4,
      i       TYPE int1 VALUE 1.

DATA: lt_num TYPE TABLE OF zss_t0003,
      ls_num LIKE LINE OF lt_num.

WHILE i < 10.

  CALL FUNCTION 'GENERAL_GET_RANDOM_INT'
    EXPORTING
      range  = 9999
    IMPORTING
      random = lv_sayi.
  ls_num-num = lv_sayi.
  APPEND ls_num TO lt_num.
  i = i + 1.
ENDWHILE.



BREAK-POINT.
