@AbapCatalog.sqlViewName: 'zss_cds015'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS denemeleri'
define view zss_cds015_ddl
  as select from    mara        as main
    left outer join nsdm_v_mard as m1 on  main.matnr = m1.matnr
                                      and m1.werks   = '1000'
    left outer join nsdm_v_mard as m2 on  main.matnr = m2.matnr
                                      and m2.werks   = '2700'
{
  main.matnr,
  m1.werks                       as m1_werks,
  m1.lgort                       as m1_lgort,
  m1.labst                       as m1_labst,

  m2.werks                       as m2_werks,
  m2.lgort                       as m2_lgort,
  m2.labst                       as m2_labst,

  coalesce( m2.labst, m1.labst ) as stok
} 
 