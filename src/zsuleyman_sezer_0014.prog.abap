*&---------------------------------------------------------------------*
*& Report ZSULEYMAN_SEZER_0014
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsuleyman_sezer_0014.
DATA : l_where TYPE string.

CONSTANTS: c_quotes TYPE char1 VALUE ''''.

PARAMETERS : p_werks TYPE marc-werks.

CONCATENATE 'WERKS' space '=' space
            c_quotes p_werks c_quotes 'AND' space
            'PERKZ' space '=' space
            c_quotes 'M' c_quotes
       INTO l_where RESPECTING BLANKS.

SELECT *
  FROM marc
  INTO TABLE @DATA(i_marc)
  WHERE (l_where).
BREAK egt_suleyman.
