*&---------------------------------------------------------------------*
*& Report zsuleyman_sezer_0013
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsuleyman_sezer_0013.

START-OF-SELECTION.

*  SELECT *
*    FROM zem_cds01
*    INTO TABLE @DATA(lt_cds20).

*  cl_salv_table=>factory( IMPORTING r_salv_table = DATA(lo_alv)
*                          CHANGING  t_table      = lt_cds20 ).
*  lo_alv->display( ).    "semantic

  SELECT *
    FROM zss_cds010( p_islem = '+',
                     p_sayi  = 10 )
    INTO TABLE @DATA(lt_cds10).

  cl_salv_table=>factory( IMPORTING r_salv_table = DATA(lo_alv)
                          CHANGING  t_table      = lt_cds10 ).
  lo_alv->display( ).  "parameters
