@AbapCatalog.sqlViewName: 'zss_cds012'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS iç içe cds'
define view zss_cds012_ddl
  with parameters
    p_lgort : abap.char( 4 )
  as select from zss_cds011_ddl
{
  matnr,
  sum(zfark) as zfark

}
where
  lgort = $parameters.p_lgort
group by
  matnr 
 