public with sharing class Biosense_CertificationDateController {

	public Integer monthNumber {get;set;}
	public String certificateDate {get;set;}

	public DateTime certificationDate {
		get {
			return certificationDate;
		}
		set {
			monthNumber = value.month();
			certificateDate = value.format('dd, yyyy');
			certificationDate = value;
		}
	}

}