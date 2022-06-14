@AbapCatalog.sqlViewName: 'zss_cds014'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS User sayısı'
define view zss_cds014_ddl 
    as select from e070 as req_head 
    left outer join zug_cds_004_ddl as req_item 
                 on req_head.trkorr = req_item.trkorr 
 {
    key req_head.as4user,
    count( * ) as total_count ,
    sum( req_item.total_object ) as total_object
} group by as4user //, req_item.total_object 
/** kullanıcı bazında kaç request olduğu bilgisi ve 
        bu requestlerin her biri altında kaç adet obje 
        olduğu bilgisinin hesaplatılması 
*/
      
 