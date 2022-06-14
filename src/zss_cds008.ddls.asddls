@AbapCatalog.sqlViewName: 'zss_cds008'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS denemeleri'
define view zss_cds008_ddl
  as select from eket
    inner join   ekpo as ekpo1 on  eket.ebeln = ekpo1.ebeln
                               and eket.ebelp = ekpo1.ebelp
    inner join   ekpo as ekpo2 on  eket.ebeln = ekpo2.ebeln
                               and eket.ebelp = ekpo2.ebelp
    inner join   ekko          on ekko.ebeln = ekpo1.ebeln


{
  key ekko.ebeln,
  key ekpo1.ebelp,
      eket.menge,
      eket.wemng,
      eket.menge - eket.wemng as zacikmiktar,
      ekpo1.menge as zmenge2,
      ekpo2.menge as zmenge3,
      case 
      when ekko.ebeln = '4500000000' 
      then ekpo2.menge + ekpo1.menge
      when ekko.ebeln = '4500000001'
      then ekpo2.menge - ekpo1.menge
      end as zmenge
      //case
      //when eket.menge = eket.wemng
      //then 'X'
      //when eket.menge <> eket.wemng
      //then ''
      //end as gosterge

}
//where eket.menge <> eket.wemng  
 