*&---------------------------------------------------------------------*
*& Include          ZSULEYMAN_SEZER_0012_CLS
*&---------------------------------------------------------------------*

CLASS lcl_luck DEFINITION.
  PUBLIC SECTION.
    METHODS : start_of_selection,
      get_balance,
      input,
      output,
      set_screen,   "screen 0100
      set_screen2,  "screen 0300
      prize,
      add_balance,
      buy_ticket,
      check_draw,
      random_num  IMPORTING iv_num TYPE int4
                  EXPORTING ev_num TYPE int4,
      random_numbers  IMPORTING iv_max_num TYPE int4
                                iv_min_num TYPE int4
                                iv_count   TYPE int4
                      EXPORTING et_bilet   TYPE zss_t0003_t,
      random_draw_numbers IMPORTING iv_loop_count TYPE int2
                                    iv_max_num    TYPE int4
                                    iv_min_num    TYPE int4
                          EXPORTING ev_string     TYPE string,
      set_fieldcat,
      set_layout,
      display_alv_draw,
      display_alv_buy,
      display_alv_tickets,
      get_selected_rows,
      buy_ticket_confirm,
      prize_check,
      prize_won IMPORTING iv_ikramiye  TYPE int4
                          iv_odul_turu TYPE string
                CHANGING  cs_ticket    TYPE zss_t0007.

  PROTECTED SECTION.
    DATA : lt_num     TYPE TABLE OF zss_t0003,   "input
           ls_num     LIKE LINE OF lt_num,
           lt_num2    TYPE TABLE OF zss_t0003,   "output
           ls_num2    LIKE LINE OF lt_num2,
           lt_ticket  TYPE TABLE OF zss_t0007,   "buy_ticket
           ls_ticket  LIKE LINE OF lt_ticket,
           lt_ticket2 TYPE TABLE OF zss_t0003,   "buy_ticket   random_numbers dan dönen tablo
           ls_ticket2 LIKE LINE OF lt_ticket2,
           ls_balance TYPE zss_t0005,            "gv_balance
           lv_count   TYPE int4.

    DATA : lt_selected_rows TYPE lvc_t_row,      "get_selected_rows
           ls_selected_rows TYPE lvc_s_row,
           lv_lines         TYPE i.

    DATA : lt_winning TYPE TABLE OF zss_t0003,   "check_draw  çekilen sayılar için
           ls_winning LIKE LINE OF lt_winning.

    DATA : lt_won_ticket TYPE TABLE OF zss_t0007.   "display_tickets  kazanılan bilet

    METHODS :
     handle_toolbar      FOR EVENT toolbar
                         OF cl_gui_alv_grid IMPORTING e_interactive
                                                      e_object,
     handle_user_command FOR EVENT user_command
                         OF cl_gui_alv_grid IMPORTING e_ucomm.                                             .

ENDCLASS. "lcl_luck definition

CLASS lcl_luck IMPLEMENTATION.
  METHOD start_of_selection.
    me->get_balance( ).

    CASE abap_true.
      WHEN p_rad1.
        CALL SCREEN 0100.
        me->input( ).
      WHEN OTHERS.
        CALL SCREEN 0300.
    ENDCASE.

  ENDMETHOD.

  METHOD get_balance.
    SELECT SINGLE balance
      FROM zss_t0005
      INTO gv_balance.
  ENDMETHOD.

  METHOD set_screen.

    LOOP AT SCREEN.
      IF screen-group1 EQ 'G1'.    "bakiye gösterimi
        screen-active    = COND #( WHEN gv_balance GE 50 THEN 1
                                   ELSE 0 ).
        screen-invisible = COND #( WHEN gv_balance GE 50 THEN 0
                                   ELSE 1 ).
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD set_screen2.

    LOOP AT SCREEN.
      IF screen-group1 EQ 'G1'.  "Bilet al gösterimi
        CASE abap_true.
          WHEN p_rad2.
            screen-active = 1.
            screen-invisible = 0.
            MODIFY SCREEN.
          WHEN OTHERS.
            screen-active = 0.
            screen-invisible = 1.
            MODIFY SCREEN.
        ENDCASE.
      ELSEIF screen-group1 EQ 'G2'.  "Çekiliş tarihinin 3-4 de gösterimi
        CASE abap_true.
          WHEN p_rad2.
            screen-active = 0.
            screen-invisible = 1.
            MODIFY SCREEN.
          WHEN OTHERS.
            screen-active = 1.
            screen-invisible = 0.
            MODIFY SCREEN.
        ENDCASE.
      ELSEIF screen-group1 EQ 'G3'.   "biletlerimi göster butonu
        CASE abap_true.
          WHEN p_rad3.
            screen-active = 1.
            screen-invisible = 0.
            MODIFY SCREEN.
          WHEN OTHERS.
            screen-active = 0.
            screen-invisible = 1.
            MODIFY SCREEN.
        ENDCASE.
      ELSEIF screen-group1 EQ 'G4'.   "çekiliş yap butonu
        CASE abap_true.
          WHEN p_rad4.
            screen-active = 1.
            screen-invisible = 0.
            MODIFY SCREEN.
          WHEN OTHERS.
            screen-active = 0.
            screen-invisible = 1.
            MODIFY SCREEN.
        ENDCASE.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD input.

    IF gs_input-num1 IS INITIAL OR gs_input-num2 IS INITIAL OR gs_input-num3 IS INITIAL OR
       gs_input-num4 IS INITIAL OR gs_input-num5 IS INITIAL OR gs_input-num6 IS INITIAL.
      MESSAGE s013(zsuleymans) DISPLAY LIKE 'E'.   "Lütfen tüm alanları doldurun
      EXIT.

      "ardışık sayının mutlak kontrolü
    ELSEIF ( abs( gs_input-num1 - gs_input-num2 ) = 1 AND abs( gs_input-num2 - gs_input-num3 ) = 1 ) OR
           ( abs( gs_input-num2 - gs_input-num3 ) = 1 AND abs( gs_input-num3 - gs_input-num4 ) = 1 ) OR
           ( abs( gs_input-num3 - gs_input-num4 ) = 1 AND abs( gs_input-num4 - gs_input-num5 ) = 1 ) OR
           ( abs( gs_input-num4 - gs_input-num5 ) = 1 AND abs( gs_input-num5 - gs_input-num6 ) = 1 )  .

      MESSAGE s014(zsuleymans) DISPLAY LIKE 'E'.   "3 Ardışık sayı kullanılamaz!
      EXIT.

    ELSE.
      ls_num-num = gs_input-num1.
      APPEND ls_num TO lt_num.
      ls_num-num = gs_input-num2.
      APPEND ls_num TO lt_num.
      ls_num-num = gs_input-num3.
      APPEND ls_num TO lt_num.
      ls_num-num = gs_input-num4.
      APPEND ls_num TO lt_num.
      ls_num-num = gs_input-num5.
      APPEND ls_num TO lt_num.
      ls_num-num = gs_input-num6.
      APPEND ls_num TO lt_num.

      SORT lt_num BY num.
      DELETE ADJACENT DUPLICATES FROM lt_num COMPARING num. "aynı sayıları silerek iki defa girilme kontrolü
    ENDIF.

    "1-49 arası kontrol
    CLEAR : ls_num.
    LOOP AT lt_num INTO ls_num.
      IF ls_num-num LT 1 OR ls_num-num GT 49.
        MESSAGE s015(zsuleymans) DISPLAY LIKE 'E'. "Girilen sayı 1 ile 49 arasında olmalı
        EXIT.
      ENDIF.
    ENDLOOP.

    "sayı tekrarı
    lv_count = lines( lt_num ).
    IF lv_count LT 6.
      MESSAGE s016(zsuleymans) DISPLAY LIKE 'E'. "Aynı sayı iki kere kullanılamaz
      EXIT.
    ENDIF.

    " tek-çift-asal
    DATA :lv_even  TYPE int1,
          lv_odd   TYPE int1,
          lv_prime TYPE int1.

    CLEAR : lv_even , lv_odd, lv_prime.
    CALL FUNCTION 'ZSS_FM_ODD_EVEN_PRIME'
      EXPORTING
        it_num   = lt_num
      IMPORTING
        ev_even  = lv_even
        ev_odd   = lv_odd
        ev_prime = lv_prime.
    "fonk dan dönen değere göre tek-çift-asal kontrolü , fonk dan veri varsa 0 dan farklı döner.
    IF lv_even EQ 0.
      MESSAGE s017(zsuleymans) DISPLAY LIKE 'E'.   "Çift sayıda girilmelidir.
      EXIT.
    ELSEIF lv_odd EQ 0.
      MESSAGE s018(zsuleymans) DISPLAY LIKE 'E'.   "Tek sayıda girilmelidir.
      EXIT.
    ELSEIF lv_prime EQ 0.
      MESSAGE s019(zsuleymans) DISPLAY LIKE 'E'.   "Asal sayıda girilmelidir.
      EXIT.
    ENDIF.
    gv_balance = gv_balance - 50.

    ls_balance-balance = gv_balance.
    MODIFY zss_t0005 FROM ls_balance.
    IF sy-subrc EQ 0.
      COMMIT WORK AND WAIT.
    ELSE.
      ROLLBACK WORK.
    ENDIF.
    me->output( ).
    me->prize( ).
  ENDMETHOD.

  METHOD random_num.

    CALL FUNCTION 'GENERAL_GET_RANDOM_INT'
      EXPORTING
        range  = iv_num
      IMPORTING
        random = ev_num.

  ENDMETHOD.

  METHOD random_numbers.
    DATA: lv_temp         TYPE zss_t0003-num,
          lv_count_loop   TYPE int4,
          lt_random_bilet TYPE TABLE OF zss_t0003,
          ls_random_bilet LIKE LINE OF lt_random_bilet.
    CLEAR : lv_count.
    REFRESH: lt_random_bilet.

    lv_count_loop = iv_count.
    WHILE lv_count_loop > 0.
      CALL FUNCTION 'QF05_RANDOM_INTEGER'
        EXPORTING
          ran_int_max = iv_max_num
          ran_int_min = iv_min_num
        IMPORTING
          ran_int     = lv_temp.

      TRY.
          DATA(row) = lt_random_bilet[ num = lv_temp ].
        CATCH cx_sy_itab_line_not_found.
      ENDTRY.

      IF row IS INITIAL.
        ls_random_bilet-num = lv_temp.
        APPEND ls_random_bilet TO lt_random_bilet.
        lv_count_loop = lv_count_loop - 1.
      ENDIF.

      CLEAR row.
      CLEAR ls_random_bilet.
    ENDWHILE.

    et_bilet = lt_random_bilet.
*    SORT et_bilet BY num.

  ENDMETHOD.

  METHOD random_draw_numbers.

    DATA:lv_temp  TYPE char10,
         it_table TYPE zss_t0003_t,
         lv_count TYPE int1.

    CLEAR ev_string.
    CALL FUNCTION 'ZSS_FM_RANDOM_LOOP'
      EXPORTING
        iv_loop_count   = iv_loop_count
        iv_max_num      = iv_max_num
        iv_min_num      = iv_min_num
      IMPORTING
        et_random_table = it_table.

    LOOP AT it_table INTO DATA(ls_count).
      IF ls_count IS NOT INITIAL.
        lv_count = lv_count + 1.
      ENDIF.
    ENDLOOP.

    IF lv_count EQ 1.
      LOOP AT it_table INTO DATA(ls_table).
        ev_string = ls_table-num.
      ENDLOOP.
    ELSE.
      LOOP AT it_table INTO ls_table.
        lv_temp = ls_table-num.
        CONCATENATE lv_temp '-' ev_string INTO ev_string.
      ENDLOOP.
      CONDENSE ev_string NO-GAPS.
    ENDIF.

  ENDMETHOD.

  METHOD output.
    DATA: lv_temp TYPE int4.

    CLEAR: gs_output, lv_count.
    REFRESH :lt_num2.

    me->random_num( EXPORTING iv_num = 49 IMPORTING ev_num = lv_temp ).
    gs_output-num1 = lv_temp.

    me->random_num( EXPORTING iv_num = 49 IMPORTING ev_num = lv_temp ).
    gs_output-num2 = lv_temp.

    me->random_num( EXPORTING iv_num = 49 IMPORTING ev_num = lv_temp ).
    gs_output-num3 = lv_temp.

    me->random_num( EXPORTING iv_num = 49 IMPORTING ev_num = lv_temp ).
    gs_output-num4 = lv_temp.

    me->random_num( EXPORTING iv_num = 49 IMPORTING ev_num = lv_temp ).
    gs_output-num5 = lv_temp.

    me->random_num( EXPORTING iv_num = 49 IMPORTING ev_num = lv_temp ).
    gs_output-num6 = lv_temp.

    IF ( abs( gs_output-num1 - gs_output-num2 ) = 1 AND abs( gs_output-num2 - gs_output-num3 ) = 1 ) OR
       ( abs( gs_output-num2 - gs_output-num3 ) = 1 AND abs( gs_output-num3 - gs_output-num4 ) = 1 ) OR
       ( abs( gs_output-num3 - gs_output-num4 ) = 1 AND abs( gs_output-num4 - gs_output-num5 ) = 1 ) OR
       ( abs( gs_output-num4 - gs_output-num5 ) = 1 AND abs( gs_output-num5 - gs_output-num6 ) = 1 )  .
      me->output( ).

    ELSE.

      ls_num2-num = gs_output-num1.
      APPEND ls_num2 TO lt_num2.
      ls_num2-num = gs_output-num2.
      APPEND ls_num2 TO lt_num2.
      ls_num2-num = gs_output-num3.
      APPEND ls_num2 TO lt_num2.
      ls_num2-num = gs_output-num4.
      APPEND ls_num2 TO lt_num2.
      ls_num2-num = gs_output-num5.
      APPEND ls_num2 TO lt_num2.
      ls_num2-num = gs_output-num6.
      APPEND ls_num2 TO lt_num2.

      SORT lt_num2 BY num.
      DELETE ADJACENT DUPLICATES FROM lt_num2 COMPARING num.

      lv_count = lines( lt_num2 ).
      IF lv_count LT 6.
        me->output( ).
      ENDIF.

      CLEAR : ls_num2.
      LOOP AT lt_num2 INTO ls_num2.
        IF ls_num2-num LT 1 OR ls_num2-num GT 49.
          me->output( ).
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD prize.
    DATA : lv_prize   TYPE int4,
           lv_message TYPE string,
           lv_count_s TYPE string,
           lv_prize_s TYPE string.
    CLEAR : lv_count, lv_prize.

    SORT lt_num2 BY num.
    LOOP AT lt_num INTO ls_num.
      READ TABLE lt_num2 TRANSPORTING NO FIELDS WITH KEY num = ls_num-num BINARY SEARCH.
      IF sy-subrc EQ 0.
        lv_count = lv_count + 1.
      ENDIF.
    ENDLOOP.

    IF lv_count GE 2.
      SELECT SINGLE prize
        FROM zss_t0004
        WHERE known = @lv_count
        INTO @lv_prize.

      lv_count_s = lv_count.
      lv_prize_s = lv_prize.
      CONCATENATE lv_count_s ' adet bildiniz kazancınız : ' space lv_prize_s ' TL' INTO lv_message.
      MESSAGE lv_message TYPE 'S' DISPLAY LIKE 'E'.

    ELSEIF lv_count EQ 1.
      MESSAGE s020(zsuleymans) DISPLAY LIKE 'E'. "Bir adet sayı bildiniz. Tekrar deneyiniz...
    ELSE.
      MESSAGE s021(zsuleymans) DISPLAY LIKE 'E'. "Hiç bilemediniz. Tekrar deneyiniz...
    ENDIF.

    gv_balance = gv_balance + lv_prize.

    ls_balance-balance = gv_balance.
    MODIFY zss_t0005 FROM ls_balance.
    IF sy-subrc EQ 0.
      COMMIT WORK AND WAIT.
    ELSE.
      ROLLBACK WORK.
    ENDIF.

  ENDMETHOD.

  METHOD add_balance.
    IF ( ( gs_card-first_4  GE 1 AND gs_card-first_4  LE 9999 ) AND
         ( gs_card-second_4 GE 1 AND gs_card-second_4 LE 9999 ) AND
         ( gs_card-third_4  GE 1 AND gs_card-third_4  LE 9999 ) AND
         ( gs_card-fourth_4 GE 1 AND gs_card-fourth_4 LE 9999 ) ).

      IF ( gv_cvv LE 999 AND gv_cvv GE 1 ).
        gv_balance = gv_balance + gv_eklenecek_para.

        ls_balance-balance = gv_balance.
        MODIFY zss_t0005 FROM ls_balance.
        IF sy-subrc EQ 0.
          COMMIT WORK AND WAIT.
        ELSE.
          ROLLBACK WORK.
        ENDIF.

        CLEAR: gv_eklenecek_para, gs_card, gv_cvv .
        LEAVE TO SCREEN 0.
      ELSE.
        MESSAGE s022(zsuleymans) DISPLAY LIKE 'E'. "CVV numarası girilmelidir!
        EXIT.
      ENDIF.

    ELSE.
      MESSAGE s023(zsuleymans) DISPLAY LIKE 'E'.  "Kart numarası 16 hane girilmelidir!
      EXIT.
    ENDIF.
  ENDMETHOD.

  METHOD buy_ticket.
    IF gv_ticket_count IS NOT INITIAL AND gv_ticket_date IS NOT INITIAL  AND gv_ticket_type IS NOT INITIAL.
      IF gv_ticket_date GE sy-datum.
        me->random_numbers(
          EXPORTING
            iv_min_num  = 1000000
            iv_max_num  = 9999999
            iv_count    = gv_ticket_count
          IMPORTING
            et_bilet    = lt_ticket2
        ).
        ls_ticket-kullanici = sy-uname.
        ls_ticket-mandt = sy-mandt.
        ls_ticket-tarih = gv_ticket_date.
        ls_ticket-bilet_turu = gv_ticket_type.
        LOOP AT lt_ticket2 INTO ls_ticket2.
          ls_ticket-num = ls_ticket2-num.
          APPEND ls_ticket TO lt_ticket.
        ENDLOOP.
        go_luck->display_alv_buy( ).
      ELSE.
        MESSAGE s027(zsuleymans) DISPLAY LIKE 'E'.
        EXIT.
      ENDIF.
    ELSE.
      MESSAGE s025(zsuleymans) DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.

  ENDMETHOD.

  METHOD check_draw.
    DATA : lv_temp  TYPE string,
           lv_temp2 TYPE int4.

    DATA: lv_string_temp TYPE string.

    REFRESH : lt_winning.
    CLEAR: ls_winning, lv_string_temp.

    IF gv_ticket_draw IS NOT INITIAL.
      IF gv_ticket_draw GE sy-datum.

        me->random_draw_numbers( EXPORTING iv_loop_count = 1
                                           iv_max_num    = 9999999
                                           iv_min_num    = 1000000
                                 IMPORTING ev_string      = lv_string_temp  ).   "Çekilen 7 sayı
        gs_cekilis-yedi = lv_string_temp.
        CLEAR lv_string_temp.

        me->random_numbers( EXPORTING iv_max_num = 999999
                                      iv_min_num = 100000
                                      iv_count   = 5
                            IMPORTING et_bilet   = lt_winning ).                 "Çekilen 6 lı sayı
        LOOP AT lt_winning INTO ls_winning.
          lv_temp = ls_winning-num.
          CONCATENATE lv_temp '-' lv_string_temp INTO lv_string_temp.
        ENDLOOP.
        CONDENSE lv_string_temp NO-GAPS.                                         "içindeki bütün boşlukları kaldırır.
        gs_cekilis-alti = lv_string_temp.
        REFRESH : lt_winning.
        CLEAR: ls_winning, lv_string_temp.

        me->random_numbers( EXPORTING iv_max_num = 99999
                                      iv_min_num = 10000
                                      iv_count   = 10
                            IMPORTING et_bilet   = lt_winning ).                 "Çekilen 5 li sayı
        LOOP AT lt_winning INTO ls_winning.
          lv_temp = ls_winning-num.
          CONCATENATE lv_temp '-' lv_string_temp INTO lv_string_temp.
        ENDLOOP.
        CONDENSE lv_string_temp NO-GAPS.
        gs_cekilis-bes = lv_string_temp.
        REFRESH : lt_winning.
        CLEAR: ls_winning, lv_string_temp.

        me->random_numbers( EXPORTING iv_max_num = 9999
                                      iv_min_num = 1000
                                      iv_count   = 15
                            IMPORTING et_bilet   = lt_winning ).                 "Çekilen 4 lü sayı
        LOOP AT lt_winning INTO ls_winning.
          lv_temp = ls_winning-num.
          CONCATENATE lv_temp '-' lv_string_temp INTO lv_string_temp.
        ENDLOOP.
        CONDENSE lv_string_temp NO-GAPS.
        gs_cekilis-dort = lv_string_temp.
        REFRESH : lt_winning.
        CLEAR: ls_winning, lv_string_temp.

        me->random_numbers( EXPORTING iv_max_num = 999
                                      iv_min_num = 100
                                      iv_count   = 20
                            IMPORTING et_bilet   = lt_winning ).                 "Çekilen 3 lü sayı
        LOOP AT lt_winning INTO ls_winning.
          lv_temp = ls_winning-num.
          CONCATENATE lv_temp '-' lv_string_temp INTO lv_string_temp.
        ENDLOOP.
        CONDENSE lv_string_temp NO-GAPS.
        gs_cekilis-uc = lv_string_temp.
        REFRESH : lt_winning.
        CLEAR: ls_winning, lv_string_temp.

        me->random_numbers( EXPORTING iv_max_num = 99
                                      iv_min_num = 10
                                      iv_count   = 25
                            IMPORTING et_bilet   = lt_winning ).                 "Çekilen 2 li sayı
        LOOP AT lt_winning INTO ls_winning.
          lv_temp = ls_winning-num.
          CONCATENATE lv_temp '-' lv_string_temp INTO lv_string_temp.
        ENDLOOP.
        CONDENSE lv_string_temp NO-GAPS.
        gs_cekilis-iki = lv_string_temp.
        REFRESH : lt_winning.
        CLEAR: ls_winning, lv_string_temp.

        me->random_numbers( EXPORTING iv_max_num = 9
                                      iv_min_num = 1
                                      iv_count   = 2
                            IMPORTING et_bilet   = lt_winning ).                 "Amorti sayısı
        LOOP AT lt_winning INTO ls_winning.
          lv_temp = ls_winning-num.
          CONCATENATE lv_temp '-' lv_string_temp INTO lv_string_temp.
        ENDLOOP.
        CONDENSE lv_string_temp NO-GAPS.
        gs_cekilis-tek = lv_string_temp.
        REFRESH : lt_winning.
        CLEAR: ls_winning, lv_string_temp.


        " fonksiyonun içinde aynı sayılar çıktıgında istenilen sayı adeti tutmadıgı için vazgeçildi.
*      me->random_draw_numbers( EXPORTING iv_loop_count = 5
*                                         iv_max_num    = 999999
*                                         iv_min_num    = 100000
*                               IMPORTING ev_string      = lv_string_temp  ).   "Çekilen 6 sayı
*      gs_cekilis-alti = lv_string_temp.
*      CLEAR lv_string_temp.
*
*
*      me->random_draw_numbers( EXPORTING iv_loop_count = 10
*                                         iv_max_num    = 99999
*                                         iv_min_num    = 10000
*                               IMPORTING ev_string      = lv_string_temp  ).   "Çekilen 5 sayı
*      gs_cekilis-bes = lv_string_temp.
*      CLEAR lv_string_temp.
*
*
*      me->random_draw_numbers( EXPORTING iv_loop_count = 15
*                                         iv_max_num    = 9999
*                                         iv_min_num    = 1000
*                               IMPORTING ev_string      = lv_string_temp  ).   "Çekilen 4 sayı
*      gs_cekilis-dort = lv_string_temp.
*      CLEAR lv_string_temp.
*
*
*      me->random_draw_numbers( EXPORTING iv_loop_count = 20
*                                         iv_max_num    = 999
*                                         iv_min_num    = 100
*                               IMPORTING ev_string      = lv_string_temp  ).   "Çekilen 3 sayı
*      gs_cekilis-uc = lv_string_temp.
*      CLEAR lv_string_temp.
*
*
*      me->random_draw_numbers( EXPORTING iv_loop_count = 25
*                                         iv_max_num    = 99
*                                         iv_min_num    = 10
*                               IMPORTING ev_string      = lv_string_temp  ).    "Çekilen 2 sayı
*      gs_cekilis-iki = lv_string_temp.
*      CLEAR lv_string_temp.
*
*
*      me->random_draw_numbers( EXPORTING iv_loop_count = 2
*                                         iv_max_num    = 9
*                                         iv_min_num    = 1
*                               IMPORTING ev_string      = lv_string_temp  ).   "Amorti sayısı
*      gs_cekilis-tek = lv_string_temp.
*      CLEAR lv_string_temp.

        gs_cekilis-tarih = gv_ticket_draw.
        gs_cekilis-mandt = sy-mandt.
        INSERT zss_t0006 FROM gs_cekilis.
        IF sy-subrc EQ 0.
          COMMIT WORK AND WAIT.
          SELECT *
            FROM zss_t0006
            INTO TABLE gt_cekilis.
          SORT gt_cekilis BY tarih.
        ELSE.
          ROLLBACK WORK.
          MESSAGE s026(zsuleymans) DISPLAY LIKE 'E'. "Girilen tarihte tek çekiliş yapılabilir. Daha önce çekiliş yapılmıştır.
          EXIT.
        ENDIF.
        CLEAR: gs_cekilis.
      ELSE.
        MESSAGE s029(zsuleymans) DISPLAY LIKE 'E'.   "Geçmiş tarihte çekiliş yapıldı. Tekrar çekiliş yapılamaz!
        EXIT.
      ENDIF.
    ELSE.
      MESSAGE s025(zsuleymans) DISPLAY LIKE 'E'.     "Tüm alanları giriniz!!!
      EXIT.
    ENDIF.

    me->display_alv_draw( ).
  ENDMETHOD.

  METHOD set_fieldcat.
    IF gv_fieldcat EQ 'DRAW'.
      CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
        EXPORTING
          i_structure_name = 'ZSZR_S0010'
        CHANGING
          ct_fieldcat      = gt_fieldcat.
    ELSEIF gv_fieldcat EQ 'BUY'.
      CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
        EXPORTING
          i_structure_name = 'ZSZR_S0011'
        CHANGING
          ct_fieldcat      = gt_fieldcat.
    ELSEIF gv_fieldcat EQ 'TICKETS'.
      CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
        EXPORTING
          i_structure_name = 'ZSZR_S0012'
        CHANGING
          ct_fieldcat      = gt_fieldcat.
    ENDIF.
  ENDMETHOD.

  METHOD set_layout.
    gs_layout-zebra      = 'X'.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-col_opt    = abap_true.
    gs_layout-sel_mode   = 'D'.
  ENDMETHOD.

  METHOD display_alv_draw.
    gv_fieldcat = 'DRAW'.
    me->set_fieldcat( ).
    me->set_layout( ).
    CLEAR gv_fieldcat.

    go_alv = NEW cl_gui_alv_grid(
        i_parent          = cl_gui_container=>screen0 ).

    CALL METHOD go_alv->set_table_for_first_display
      EXPORTING
        is_layout       = gs_layout
      CHANGING
        it_outtab       = gt_cekilis
        it_fieldcatalog = gt_fieldcat.

  ENDMETHOD.

  METHOD display_alv_buy.
    gv_fieldcat = 'BUY'.
    me->set_fieldcat( ).
    me->set_layout( ).
    CLEAR gv_fieldcat.

    go_alv = NEW cl_gui_alv_grid(
        i_parent          = cl_gui_container=>screen0 ).

    SET HANDLER handle_toolbar FOR go_alv.
    SET HANDLER handle_user_command FOR go_alv.

    CALL METHOD go_alv->set_table_for_first_display
      EXPORTING
        is_layout       = gs_layout
      CHANGING
        it_outtab       = lt_ticket
        it_fieldcatalog = gt_fieldcat.

  ENDMETHOD.

  METHOD display_alv_tickets.
    gv_fieldcat = 'TICKETS'.
    me->set_fieldcat( ).
    me->set_layout( ).
    CLEAR gv_fieldcat.

    go_alv = NEW cl_gui_alv_grid(
        i_parent          = cl_gui_container=>screen0 ).

    CALL METHOD go_alv->set_table_for_first_display
      EXPORTING
        is_layout       = gs_layout
      CHANGING
        it_outtab       = lt_won_ticket
        it_fieldcatalog = gt_fieldcat.

  ENDMETHOD.

  METHOD handle_toolbar.
    DATA : ls_toolbar TYPE stb_button.

    ls_toolbar-function = '&BUY'.
    ls_toolbar-text = 'Bilet Satın Al'.
    ls_toolbar-icon = '@2K@'.
    APPEND ls_toolbar TO e_object->mt_toolbar.
  ENDMETHOD.

  METHOD handle_user_command.
    CASE e_ucomm .
      WHEN '&BUY'.
        me->buy_ticket_confirm( ).    "Seçilen bilet satırlarının alınması
    ENDCASE.
  ENDMETHOD.

  METHOD get_selected_rows.
    CLEAR: lt_selected_rows,
           ls_selected_rows,
           lv_lines.

    CALL METHOD go_alv->get_selected_rows
      IMPORTING
        et_index_rows = lt_selected_rows.
  ENDMETHOD.

  METHOD buy_ticket_confirm.
    me->get_selected_rows( ).
    DATA : lt_buy_ticket TYPE TABLE OF zss_t0007.
    CLEAR : ls_ticket.

    lv_lines = lines( lt_selected_rows ).
    IF lv_lines EQ 0.
      MESSAGE s000(zsuleymans) DISPLAY LIKE 'E'.
    ELSEIF lv_lines GE 1.

      LOOP AT lt_selected_rows INTO ls_selected_rows.
        READ TABLE lt_ticket ASSIGNING FIELD-SYMBOL(<lfs_ticket>) INDEX ls_selected_rows-index.
        IF sy-subrc EQ 0.
          ls_ticket-mandt      = <lfs_ticket>-mandt.
          ls_ticket-kullanici  = <lfs_ticket>-kullanici.
          ls_ticket-num        = <lfs_ticket>-num.
          ls_ticket-bilet_turu = <lfs_ticket>-bilet_turu.
          ls_ticket-tarih      = <lfs_ticket>-tarih.
          APPEND ls_ticket TO lt_buy_ticket.
        ENDIF.
      ENDLOOP.
      CLEAR : ls_ticket.
      INSERT zss_t0007 FROM TABLE lt_buy_ticket.
      IF sy-subrc EQ 0.
        COMMIT WORK AND WAIT.
        MESSAGE s028(zsuleymans) DISPLAY LIKE 'S'.
        LOOP AT lt_ticket INTO ls_ticket.
          READ TABLE lt_buy_ticket TRANSPORTING NO FIELDS WITH KEY num = ls_ticket-num BINARY SEARCH.
          IF sy-subrc EQ 0.
            DELETE lt_ticket WHERE num EQ ls_ticket-num AND bilet_turu EQ gv_ticket_type.
          ENDIF.
        ENDLOOP.
        go_alv->refresh_table_display( ).
      ELSE.
        ROLLBACK WORK.
      ENDIF.

    ENDIF.

  ENDMETHOD.

  METHOD prize_check.

    SELECT *
      FROM zss_t0006
      INTO TABLE @DATA(lt_draws)
      WHERE tarih EQ @gv_ticket_draw.
    IF sy-subrc NE 0.
      MESSAGE s030(zsuleymans) DISPLAY LIKE 'E'.   "Girilen tarihte çekiliş bulunmamaktadır.
      EXIT.
    ENDIF.

    SELECT *
      FROM zss_t0007
      INTO TABLE @DATA(lt_tickets)
      WHERE tarih EQ @gv_ticket_draw.
    IF sy-subrc NE 0.
      MESSAGE s031(zsuleymans) DISPLAY LIKE 'E'.   "Girilen tarihte biletiniz bulunmamaktadır.
      EXIT.
    ENDIF.
    LOOP AT lt_tickets INTO DATA(ls_ticket).
      READ TABLE lt_draws INTO DATA(ls_draw) WITH KEY tarih = ls_ticket-tarih BINARY SEARCH.

      IF sy-subrc EQ 0.
        IF ls_draw-yedi EQ ls_ticket-num.
          me->prize_won( EXPORTING iv_ikramiye  = 1000000
                                   iv_odul_turu = 'Büyük İkramiye'
                         CHANGING  cs_ticket    = ls_ticket ).
          APPEND ls_ticket TO lt_won_ticket.
          CONTINUE.

        ELSEIF ls_draw-alti CS ls_ticket-num+1(6) .
          me->prize_won( EXPORTING iv_ikramiye  = 500000
                                   iv_odul_turu = 'Son Altı'
                         CHANGING  cs_ticket    = ls_ticket ).
          APPEND ls_ticket TO lt_won_ticket.
          CONTINUE.

        ELSEIF ls_draw-bes CS ls_ticket-num+2(5) .
          me->prize_won( EXPORTING iv_ikramiye  = 150000
                                   iv_odul_turu = 'Son Beş'
                         CHANGING  cs_ticket    = ls_ticket ).
          APPEND ls_ticket TO lt_won_ticket.
          CONTINUE.

        ELSEIF ls_draw-dort CS ls_ticket-num+3(4) .
          me->prize_won( EXPORTING iv_ikramiye  = 50000
                                   iv_odul_turu = 'Son Dört'
                         CHANGING  cs_ticket    = ls_ticket ).
          APPEND ls_ticket TO lt_won_ticket.
          CONTINUE.

        ELSEIF ls_draw-uc CS ls_ticket-num+4(3) .
          me->prize_won( EXPORTING iv_ikramiye  = 10000
                                   iv_odul_turu = 'Son Üç'
                         CHANGING  cs_ticket    = ls_ticket ).
          APPEND ls_ticket TO lt_won_ticket.
          CONTINUE.

        ELSEIF ls_draw-iki CS ls_ticket-num+5(2) .
          me->prize_won( EXPORTING iv_ikramiye  = 1000
                                   iv_odul_turu = 'Son İki'
                         CHANGING  cs_ticket    = ls_ticket ).
          APPEND ls_ticket TO lt_won_ticket.
          CONTINUE.

        ELSEIF ls_draw-tek CS ls_ticket-num+6(1) .
          me->prize_won( EXPORTING iv_ikramiye  = 200
                                   iv_odul_turu = 'Amorti'
                         CHANGING  cs_ticket    = ls_ticket ).
          APPEND ls_ticket TO lt_won_ticket.
          CONTINUE.
        ENDIF.
      ENDIF.
    ENDLOOP.

    MODIFY zss_t0007 FROM TABLE lt_won_ticket.
    IF sy-subrc EQ 0.
      COMMIT WORK AND WAIT.
    ELSE.
      ROLLBACK WORK.
    ENDIF.

    CLEAR : lt_won_ticket.

    SELECT *
      FROM zss_t0007
      INTO TABLE lt_won_ticket
      WHERE tarih EQ gv_ticket_draw.
    me->display_alv_tickets( ).

  ENDMETHOD.

  METHOD prize_won.
    DATA lv_ikramiye TYPE int4.
    lv_ikramiye = iv_ikramiye.
    CASE cs_ticket-bilet_turu.
      WHEN '1'.
        lv_ikramiye = iv_ikramiye.
        cs_ticket-odul_turu = iv_odul_turu.
        cs_ticket-ikramiye = lv_ikramiye.
      WHEN '0.5'.
        lv_ikramiye = iv_ikramiye / 2.
        cs_ticket-odul_turu = iv_odul_turu.
        cs_ticket-ikramiye = lv_ikramiye.
      WHEN '0.25'.
        lv_ikramiye = iv_ikramiye / 4.
        cs_ticket-odul_turu = iv_odul_turu.
        cs_ticket-ikramiye = lv_ikramiye.
    ENDCASE.

  ENDMETHOD.

ENDCLASS. "lcl_luck implementation
