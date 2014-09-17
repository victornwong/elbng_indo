import org.victor.*;

lbhand = new ListboxHandler();
sqlhand = new SqlFuncs();
kiboo = new Generals();
guihand = new GuiFuncs();

// popup at bottom.. check and reuse
// ---- Customer search popup stuff ---- can be used in other modules

void showCustomerInfo(String iarcode)
{
	r = sqlhand.getCompanyRecord(iarcode);
	if(r == null) return;

	kk = kiboo.checkNullString(r.get("customer_name")) + "\n" +
	kiboo.checkNullString(r.get("address1")) + "\n" +
	kiboo.checkNullString(r.get("address2")) + "\n" +
	kiboo.checkNullString(r.get("address3")) + "\n" +
	kiboo.checkNullString(r.get("Address4")) + "\nTel: " + kiboo.checkNullString(r.get("telephone_no")) + "\n" +
	"Fax: " +	kiboo.checkNullString(r.get("fax_no")) + "\nContact: " + kiboo.checkNullString(r.get("contact_person1")) + 
	"\nEmail: " + kiboo.checkNullString(r.get("E_mail"));

	selectcustomer_meta_lbl.setValue(kk);

/*
	cfind_company_lbl.setValue(kiboo.checkNullString_RetWat(r.get("customer_name"),"---UNDEFINED---"));
	cfind_address1_lbl.setValue(kiboo.checkNullString_RetWat(r.get("address1"),"------"));
	cfind_address2_lbl.setValue(kiboo.checkNullString_RetWat(r.get("address2"),"------"));
	cfind_address3_lbl.setValue(kiboo.checkNullString_RetWat(r.get("address3"),"------"));
	//cfind_address4_lbl.setValue(kiboo.checkNullString_RetWat(r.get("Address4"),"------"));
	cfind_tel_lbl.setValue(kiboo.checkNullString_RetWat(r.get("telephone_no"),"-----"));
	cfind_fax_lbl.setValue(kiboo.checkNullString_RetWat(r.get("fax_no"),"-----"));
	cfind_contact_lbl.setValue(kiboo.checkNullString_RetWat(r.get("contact_person1"),"-----"));
	cfind_email_lbl.setValue(kiboo.checkNullString_RetWat(r.get("E_mail"),"-----"));
*/
	// if(iarcode.equals("BLACKLIST")) custinfo_gb.setStyle("background:#FF3333");
}

class searchcustomersLB_Listener implements org.zkoss.zk.ui.event.EventListener
{
	public void onEvent(Event event) throws UiException
	{
		selitem = event.getReference();
		tarcode = lbhand.getListcellItemLabel(selitem,0);
		showCustomerInfo(tarcode);
	}
}
sechacustmerclicker = new searchcustomersLB_Listener();

// onDoubleClick listener for searchCustomers()
class searchcustLBDoubleClick_Listener implements org.zkoss.zk.ui.event.EventListener
{
	public void onEvent(Event event) throws UiException
	{
		selectcustomer_popup.close();
		selitem = customers_lb.getSelectedItem();
		sarcode = lbhand.getListcellItemLabel(selitem,0);
		if(sarcode.equals("BLACKLIST")) return;

		comprec = sqlhand.getCompanyRecord(sarcode);
		if(comprec != null)
		{
			searchCustomer_callback(comprec); // define this in other mods using this
		}
	}
}
searchsutomerdc_obj = new searchcustLBDoubleClick_Listener();

void searchCustomers()
{
Object[] clients_lb_headers = {
	new listboxHeaderObj("AR_CODE",true),
	new listboxHeaderObj("Company",true),
	};
	
	schtext = kiboo.replaceSingleQuotes(cust_search_tb.getValue());
	if(schtext.equals("")) return;
	Listbox newlb = lbhand.makeVWListbox(foundcustomer_holder, clients_lb_headers, "customers_lb", 5);
	sqlstm = "select top 50 ar_code,customer_name,credit_period from customer where " +
	"ar_code like '%" + schtext + "%' or " +
	"customer_name like '%" + schtext + "%' or " +
	"address1 like '%" + schtext + "%' or " +
	"address2 like '%" + schtext + "%' or " +
	"address3 like '%" + schtext + "%' or " +
	"address4 like '%" + schtext + "%' or " +
	"contact_person1 like '%" + schtext + "%' " +
	"order by customer_name";

	custrecs = sqlhand.gpSqlGetRows(sqlstm);

	if(custrecs.size() == 0) return;
	newlb.setRows(10);
	newlb.addEventListener("onSelect", sechacustmerclicker );
	ArrayList kabom = new ArrayList();
	for(dpi : custrecs)
	{
		credp = kiboo.checkNullString(dpi.get("credit_period"));
		arcode = kiboo.checkNullString(dpi.get("ar_code"));
		if(credp.equals("BLACKLIST")) arcode = "BLACKLIST";
		kabom.add(arcode);
		kabom.add( kiboo.checkNullString(dpi.get("customer_name")) );
		lbhand.insertListItems(newlb,kiboo.convertArrayListToStringArray(kabom),"false","");
		kabom.clear();
	}
	lbhand.setDoubleClick_ListItems(newlb, searchsutomerdc_obj);
}
// ---- ENDOF Customer search popup stuff ----


/*
the popup:

<!-- select customer popup -->
<popup id="selectcustomer_popup">
<div style="padding:3px">
<hbox>
<groupbox width="400px">
	<caption label="Search" />
	<hbox>
		<label value="Search text" style="font-size:9px" />
		<textbox id="cust_search_tb" width="150px" style="font-size:9px" />
		<button label="Find" style="font-size:9px" onClick="searchCustomers()" />
	</hbox>
	<separator height="3px" />
	<div id="foundcustomer_holder" />
</groupbox>

<groupbox id="custinfo_gb" width="300px" >
	<caption label="Customer info" />
	<grid>
		<columns>
			<column label="" />
			<column label="" />
		</columns>
		<rows>
		<row>
			<label value="Company" style="font-size:9px" />
			<label id="cfind_company_lbl" style="font-size:9px" />
		</row>
		<row>
			<label value="Address1" style="font-size:9px" />
			<label id="cfind_address1_lbl" style="font-size:9px" />
		</row>
		<row>
			<label value="Address2" style="font-size:9px" />
			<label id="cfind_address2_lbl" style="font-size:9px" />
		</row>
		<row>
			<label value="Address3" style="font-size:9px" />
			<label id="cfind_address3_lbl" style="font-size:9px" />
		</row>
		<row>
			<label value="Contact " style="font-size:9px" />
			<label id="cfind_contact_lbl" style="font-size:9px" />
		</row>
		<row>
			<label value="Email" style="font-size:9px" />
			<label id="cfind_email_lbl" style="font-size:9px" />
		</row>
		<row>
			<label value="Tel" style="font-size:9px" />
			<label id="cfind_tel_lbl" style="font-size:9px" />
		</row>
		<row>
			<label value="Fax" style="font-size:9px" />
			<label id="cfind_fax_lbl" style="font-size:9px" />
		</row>
		</rows>
	</grid>
</groupbox>

</hbox>
<separator height="3px" />
<button label="X Close" style="font-size:9px" onClick="selectcustomer_popup.close()" />
</div>
</popup>
<!-- ENDOF select customer popup -->

*/

