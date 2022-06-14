@AbapCatalog.sqlViewName: 'zss_cds021'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS association'
define view zss_cds021_ddl
  as select from zss_cds020_ddl
{
  bukrs,
  belnr,
  gjahr,
  /* Associations */
  //        _bs[inner].buzei,
  _ac[inner].buzei,
  _ac[inner].ksl,
  _bs

} 
 