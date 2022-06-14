@AbapCatalog.sqlViewAppendName: 'zss_ext_024'
@EndUserText.label: 'CDS extend'
extend view zss_cds005_dll with zss_cds024
  // ekleme yapılacak yer zss_cds005_dll  , append structure zss_ext_024
  // ddl uzantısı olması lazım , diğer şekilde hata alınır.
  // zss_ext_024 olarak arama yapıldıgında burada yapılan işlem görünür.

  association [1] to zss_lib_borrow as _borrow on zss_lib_member.tc = _borrow.tc
  // bir kişi de birden fazla kitap oldugu için çoklanmış gibi görünüyor
  association [1] to zss_lib_book as _book on $projection.kitapid = _book.kitapid
{
  pasif,
  _borrow.kitapid as kitapid,
  _book.kitapadi
}

/*
extend view sepm_sddl_salesorder_head with zug_cds_v0025
  association [1] to sepm_sddl_businesspartner as _zpartner on $projection.buyer_key = _zpartner.business_partner_key
{
  payment_method,
  payment_terms,
  _zpartner.business_partner_role
}
 */ 
 