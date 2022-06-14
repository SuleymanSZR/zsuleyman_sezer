@AbapCatalog.sqlViewName: 'zss_cds019'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK // Not Allowed oldugu zaman access control e takılmaz
@EndUserText.label: 'CDS Access Control'
define view zss_cds019_ddl
  as select from scarr
{
  *
} 
 