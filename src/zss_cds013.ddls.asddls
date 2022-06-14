@AbapCatalog.sqlViewName: 'zss_cds013'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS iç içe cds'
define view zss_cds013_ddl
  with parameters
    p_lgort2 : abap.char( 4 )
  as select from zss_cds012_ddl ( p_lgort : $parameters.p_lgort2 ) as z
    inner join   makt                                              as m on  z.matnr = m.matnr
                                                                        and spras   = 'T'
{
  z.matnr,
  maktx,
  zfark
} 
 