@AbapCatalog.sqlViewName: 'zss_cds011'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS iç içe cds'
define view zss_cds011_ddl
  as select from nsdm_v_mseg
{
  mblnr,
  mjahr,
  zeile,
  lgort,
  matnr,
  meins,
  case   // koşul vermeden de çalışır.
  when
    bwart = '101' then menge
  when
    bwart = '102' then menge * -1
  end as zfark

}
// where koşulları Süslü parantez dışında yazılır.
where
     bwart = '101'
  or bwart = '102' 
 