@AbapCatalog.sqlViewName: 'zss_cds023'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS denemeleri'
define view zss_cds023_ddl as select from zss_cds021_ddl{
 
 _bs.belnr,
 _bs.bukrs,
 _bs.buzei,
 _bs.zuonr
} 
 