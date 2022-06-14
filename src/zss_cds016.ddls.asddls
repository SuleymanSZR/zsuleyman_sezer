@AbapCatalog.sqlViewName: 'zss_cds016'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS association'
define view zss_cds016_ddl
  as select from t001 as t1
  association [1] to t005t as _t5 on  $projection.zland = _t5.land1
  //  association [1] to t005t as _t5 on  t1.land1  = _t5.land1
                                 // and _t5.land1         = 'TR'
                                  and _t5.spras         = 'T'
{
  t1.bukrs,
  t1.land1 as zland,
  t1.butxt,

  //  _t5.land1 //ad-hoc ass


  //public
  _t5
} 
 