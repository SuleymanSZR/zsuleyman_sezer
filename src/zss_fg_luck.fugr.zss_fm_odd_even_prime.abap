FUNCTION zss_fm_odd_even_prime .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_NUM) TYPE  ZSS_T0003_T
*"  EXPORTING
*"     REFERENCE(EV_EVEN) TYPE  INT1
*"     REFERENCE(EV_ODD) TYPE  INT1
*"     REFERENCE(EV_PRIME) TYPE  INT1
*"----------------------------------------------------------------------
  DATA: lv_check  TYPE int2,
        lv_flag   TYPE int1 VALUE 0.
  CLEAR : ev_odd , ev_even , ev_prime.

  LOOP AT it_num INTO DATA(is_num).
    IF is_num-num MOD 2 EQ 0.
      ev_even = ev_even + 1.
    ELSE.
      ev_odd = ev_odd + 1.
    ENDIF.
    lv_check = 2.
    CLEAR :lv_flag.
    WHILE lv_check <= is_num-num / 2 .
      IF ( is_num-num MOD lv_check ) EQ 0.
        lv_flag = 1.
        EXIT.
      ENDIF.
      lv_check = lv_check + 1.
    ENDWHILE.
    IF lv_flag EQ 1.
      ev_prime = ev_prime + 0.
    ELSE.
      ev_prime = ev_prime + 1.
    ENDIF.


  ENDLOOP.


ENDFUNCTION.
