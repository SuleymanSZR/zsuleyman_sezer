@AbapCatalog.sqlViewName: 'zss_cds017'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS association'
define view zss_cds017_ddl 
as select from acdoca as acd 
association [0..1] to zss_cds016_ddl as _company on acd.rbukrs = _company.bukrs
{
    acd.rldnr,
    acd.rbukrs,
    acd.gjahr,
    acd.belnr,
    
    _company.zland,
    _company.butxt,
    _company._t5.natio as znatio
    
} 
 