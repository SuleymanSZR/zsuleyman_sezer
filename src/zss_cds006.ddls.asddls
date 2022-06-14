@AbapCatalog.sqlViewName: 'zss_cds006'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS denemeleri'
define view zss_cds006_ddl as select from zss_lib_member as member
left outer join zss_lib_borrow as borrow
    on member.tc = borrow.tc 
left outer join zss_lib_book as book 
    on book.kitapid = borrow.kitapid    
{
    member.tc,
    member.adi,
    member.soyadi,
    book.kitapadi,
    borrow.borrow_date,
    borrow.return_date
} 
 