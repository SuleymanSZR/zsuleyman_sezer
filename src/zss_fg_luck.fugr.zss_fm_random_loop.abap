FUNCTION zss_fm_random_loop.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_LOOP_COUNT) TYPE  INT2
*"     REFERENCE(IV_MAX_NUM) TYPE  INT4
*"     REFERENCE(IV_MIN_NUM) TYPE  INT4
*"  EXPORTING
*"     REFERENCE(ET_RANDOM_TABLE) TYPE  ZSS_T0003_T
*"----------------------------------------------------------------------

  DATA: lv_temp        TYPE qf00-ran_int,
        lt_random_table TYPE TABLE OF zss_t0003,
        ls_random_table LIKE LINE OF lt_random_table.

  DO iv_loop_count TIMES.

    CALL FUNCTION 'QF05_RANDOM_INTEGER'
      EXPORTING
        ran_int_max = iv_max_num
        ran_int_min = iv_min_num
      IMPORTING
        ran_int     = lv_temp.
    ls_random_table-num = lv_temp.
    APPEND ls_random_table TO et_random_table.

    DATA(lv_line) = lines( et_random_table ).
    lt_random_table = et_random_table.

    SORT lt_random_table BY num.
    DELETE ADJACENT DUPLICATES FROM lt_random_table COMPARING num.

    IF lines( lt_random_table ) NE lines( et_random_table ).
      iv_loop_count = iv_loop_count + 1.
      CLEAR et_random_table.
      et_random_table = lt_random_table.
    ENDIF.

  ENDDO.




ENDFUNCTION.
