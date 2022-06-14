@AbapCatalog.sqlViewName: 'zss_cds010'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Parameters'
define view zss_cds010_ddl
  with parameters
    p_islem : abap.char( 1 ),
    p_sayi  : abap.int1
  as select from ekpo
{
  ebeln,
  ebelp,
  menge,
  $parameters.p_islem as zislem,
  $parameters.p_sayi  as zsayi,
  case
  $parameters.p_islem
  when '+'
  then  menge + $parameters.p_sayi
  when '-'
  then  menge - $parameters.p_sayi
  when '*'
  then  menge * $parameters.p_sayi
  end                 as zsonuc
} 
 