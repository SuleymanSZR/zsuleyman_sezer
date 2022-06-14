@AbapCatalog.sqlViewName: 'ZSS_CDS005'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS denemeleri'
define view zss_cds005_dll
  as select from zss_lib_member 
{
  key zss_lib_member.mandt as Mandt,
  key zss_lib_member.tc,
      adi,
      soyadi
} 
 