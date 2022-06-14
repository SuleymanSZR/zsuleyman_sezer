@AbapCatalog.sqlViewName: 'zss_cds018'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS association'
define view zss_cds018_ddl
  as select from zug_t_depo as depo
  association [1..*] to zug_t_matnr as _matnr on depo.depo_id = _matnr.depo_id
//  association [1..1] to zug_t_matnr as _matnr on depo.depo_id = _matnr.depo_id
// 1..1 oldugu zaman gösterirken satır sayısını 1..* şeklinde gösterir  
// ama aynı olan depo_id lerini  saymaz bu örnek için 5 satır gösterir 4 satır sayar 
{
//left outer join şeklinde çalışarak verileri bize getirmektedir.
// 1..* şekilde oldugu zaman ör. sum işlemi yaptıgımda , depo_id 123 olanın içinde 2 tane matnr olan varsa 
// onları da baz alarak ikisini de toplar  örnek için 123 - 200 diğerleri 100
// 1..1 için aynı işlem yapıldıgı zaman hepsi için 100 kapasite vardır.

    depo.depo_id,
    _matnr.matnr,
    depo.stok as kapasite
  } 
 