*&---------------------------------------------------------------------*
*& Report ZSULEYMAN_SEZER_CLS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsuleyman_sezer_0002.

INCLUDE : zsuleyman_sezer_cls_top,
          zsuleyman_sezer_cls_cls.

START-OF-SELECTION.

  DATA : go_alv TYPE REF TO lcl_salv.

  CREATE OBJECT go_alv.


*  CALL METHOD go_alv->get_data( ).
*  CALL METHOD go_alv->display_salv( ).
  go_alv->get_data( ).
  go_alv->display_salv( ).     "iki şekilde de kullanımı var hangisini kullanmak istersem.
