@AbapCatalog.sqlViewName: 'zss_cds007'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS denemeleri'
define view zss_cds007_dll as select from vbak as vk 
 inner join vbap as vp on vk.vbeln = vp.vbeln
{
  key vk.vbeln,
  key posnr,
  kwmeng,
  cast(div(kwmeng,3) as abap.curr( 13, 1 )) as zdiv,
  division(kwmeng, 3, 3) as zdivision,
  ceil(division(kwmeng, 3, 2)) as zceil,
  floor(division(kwmeng, 3, 2)) as zfloor,
  ROUND(division(kwmeng, 3, 3),1)  as zround1,  
  ROUND(division(kwmeng, 3, 3),2)  as zround2,  
  concat_with_space(vk.vbeln, posnr, 1) as zconcat,
  concat(ltrim(vk.vbeln, '0'), posnr) as zconcat2,
  
  $session.user as zuser,
  cast($session.system_date as abap.dats ) as zdate,
  $session.system_language as zlangu,
  $session.client as zclient
 
} 
 