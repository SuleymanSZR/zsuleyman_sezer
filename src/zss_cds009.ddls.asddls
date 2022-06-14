@AbapCatalog.sqlViewName: 'zss_cds009'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS denemeleri'
define view zss_cds009_ddl 
as select from zem_dil 
{ //zem_dil(kullanıcının bildiği diller) tablosundaki seçili olan dillerin kaç tane seçildiğini bulmak için , 
    key userid,
    concat(concat(concat(concat(rus, ita), isp), fra), ing) as zdil_x,   //iç içe concat kullanarak sağa doğru büyümeyi() kontrol eder.
    length(concat(concat(concat(concat(rus, ita), isp), fra), ing)) as zdil_count
} 
 