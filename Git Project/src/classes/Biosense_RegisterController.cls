public without sharing class Biosense_RegisterController {

    public String inputCaptcha {get; set;}
    Integer captchaNumber;
    private List<Integer> codes;

    //This methods simply returns a random number between 0 and the size of the character list
    public Integer randomNumber() {
        Integer random = Math.Round(Math.Random() * codes.Size());
        if (random == codes.size()) {
            random--;
        }
        return random;
    }

    public string ImagePath {get; set;}

    public Integer getCaptchaNumber() {
        captchaNumber = codes[randomNumber()];
        return captchaNumber;
    }

    @TestVisible
    private Map<Integer,String> pathByCode = new Map<Integer,String> {
        1 => 'cap/3123.png', //agsm
        2 => 'cap/241q.png', //arts
        3 => 'cap/214q.png', //awot
        4 => 'cap/46aq.png', //azxb
        5 => 'cap/64et.png', //bgfa
        6 => 'cap/325q.png', //fjag
        7 => 'cap/5qty.png', //grty
        8 => 'cap/124q.png', //gwhs
        9 => 'cap/241k.png', //hgfd
        10 => 'cap/51yq.png', //hjas
        11 => 'cap/75ur.png', //hjyt
        12 => 'cap/734y.png', //hres
        13 => 'cap/075e.png', //jhtr
        14 => 'cap/623y.png', //jkty
        15 => 'cap/2135.png', //jpkt
        16 => 'cap/627r.png', //jtbf
        17 => 'cap/35bq.png', //kbvw
        18 => 'cap/86i5.png', //kjsw
        19 => 'cap/1526.png', //kjwr
        20 => 'cap/053q.png', //kqrw
        21 => 'cap/416q.png', //kweh
        22 => 'cap/5126.png', //kywm
        23 => 'cap/5236.png', //lasq
        24 => 'cap/6236.png', //mkjs
        25 => 'cap/64g4.png', //mntr
        26 => 'cap/86y5.png', //mxbt
        27 => 'cap/53t3.png', //mytw
        28 => 'cap/5371.png', //nhtm
        29 => 'cap/5127.png', //npbv
        30 => 'cap/9e25.png', //ojsy
        31 => 'cap/64u5.png', //omnj
        32 => 'cap/64u6.png', //payr
        33 => 'cap/095r.png', //poas
        34 => 'cap/75kj.png', //ptre
        35 => 'cap/86o7.png', //pyfs
        36 => 'cap/53y5.png', //pytw
        37 => 'cap/3456.png', //rcxh
        38 => 'cap/6i74.png', //sdkj
        39 => 'cap/4664.png', //skrb
        40 => 'cap/46k7.png', //snkt
        41 => 'cap/75ol.png', //trqw
        42 => 'cap/4k75.png', //twer
        43 => 'cap/2411.png', //twks
        44 => 'cap/75u5.png', //urtm
        45 => 'cap/14j4.png', //xbcn
        46 => 'cap/979j.png', //xkjs
        47 => 'cap/53h7.png', //xstr
        48 => 'cap/25h5.png', //ykbf
        49 => 'cap/52v2.png', //ypas
        50 => 'cap/6j95.png' //zeqw
    };

    @TestVisible
    private Map<Integer,String> codeByCaptchaNumber = new Map<Integer,String> {
        1 => 'agsm',
        2 => 'arts',
        3 => 'awot',
        4 => 'azxb',
        5 => 'bgfa',
        6 => 'fjag',
        7 => 'grty',
        8 => 'gwhs',
        9 => 'hgfd',
        10 => 'hjas',
        11 => 'hjyt',
        12 => 'hres',
        13 => 'jhtr',
        14 => 'jkty',
        15 => 'jpkt',
        16 => 'jtbf',
        17 => 'kbvw',
        18 => 'kjsw',
        19 => 'kjwr',
        20 => 'kqrw',
        21 => 'kweh',
        22 => 'kywm',
        23 => 'lasq',
        24 => 'mkjs',
        25 => 'mntr',
        26 => 'mxbt',
        27 => 'mytw',
        28 => 'nhtm',
        29 => 'npbv',
        30 => 'ojsy',
        31 => 'omnj',
        32 => 'payr',
        33 => 'poas',
        34 => 'ptre',
        35 => 'pyfs',
        36 => 'pytw',
        37 => 'rcxh',
        38 => 'sdkj',
        39 => 'skrb',
        40 => 'snkt',
        41 => 'trqw',
        42 => 'twer',
        43 => 'twks',
        44 => 'urtm',
        45 => 'xbcn',
        46 => 'xkjs',
        47 => 'xstr',
        48 => 'ykbf',
        49 => 'ypas',
        50 => 'zeqw'
    };

    public void resetCaptcha() {
        Integer tmpCaptchaNumber = captchaNumber;
        captchaNumber = codes[randomNumber()];
        if (captchaNumber == tmpCaptchaNumber) {
            captchaNumber = codes[randomNumber()];
        }
        ImagePath = pathByCode.get(captchaNumber);
    }

    public String firstName {get; set;}
    public String lastName {get; set;}
    public String username {get; set;}
    public String email {get; set;}
    public String confirmEmail {get; set;}
    public String company {get; set;}
    public String password {get; set {password = value == NULL ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == NULL ? value : value.trim(); } }
    public String communityNickname {get; set { communityNickname = value == NULL ? value : value.trim(); } }
    private String prefix = (Type.forName('cfsp__CFSP_Config__c') != NULL) ? 'cfsp__' : '';

    public List<RegisterField> registerSettings {get; private set;}
    public class RegisterField {
        public Boolean enabled {get; set;}
        public String objectName {get; set;}
        public String field {get; set;}
        public String fieldType {get; set;}
        public String label {get; set;}
        public FieldInstance instance {get; set;}
        public Integer sequence {get; set;}
        public Boolean required {get; set;}
        public RegisterField(String objectName) {
            this.objectName = objectName;
        }
    }
    public class FieldInstance {
        public SObject value {get; set;}
        public String objectName {get; set;}
        public String field {get; set;}

        public FieldInstance(String objectName, String field) {
            this.value = (SObject)Type.forName(objectName).newInstance();
            this.field = field;
        }
    }
    /*
    * Wrapper Class for the Registration settings
    */
    public class RegistrationSettingsClass {
        // default account for create a new portal user
        public String portalAccountId {get; set;}

        // items of the email mapping
        public List<RegistrationItem> items {get; set;}

        // unused
        // profileId of the new customer portal user
        public String portalUserProfileId {get; set;}

        // send email to Account owner that a new User has been created
        public Boolean enableEmailNotificationNewUser {get; set;}
        // send email to specified emal address that a new Lead has been created
        public Boolean enableEmailNotificationNewLead {get; set;}

        // enable email mapping
        public Boolean enableEmailMapping {get; set;}
        public Boolean enableCreateLead {get; set;}
        public Boolean allowUnknownUsers {get; set;}

        public Boolean limitSelfRegistration {get; set;}
        public LogicFields logicFields {get; set;}
        public String limitSelfRegistrationSOQL {get; set;}

    }
    /*
    * Wrapper Class for the Registration settings
    */
    public class RegistrationItem {
        public String emailDomain {get; set;}
        public String AccountId {get; set;}
        public String AccountName {get; set;}
    }
    public class LogicFields {
        public String logic {get; set;}
        public List<Field> fields {get; set;}
    }
    public class Field {
        public Integer index {get; set;}
        public String objectName {get; set;}
        public String field {get; set;}
        public String operator {get; set;}
        public FieldInstance instance {get; set;}

        public Field() {}

        public Field(Integer index) {
            this.index = index;
        }
    }
    public RegistrationSettingsClass registrationSettingsVar {get; set;}

    public Boolean hideAllControls {get; set;}
    public String severity {
        get {
            String type = '';

            for (ApexPages.Message msg : ApexPages.getMessages()) {
                type = String.valueOf(msg.getSeverity()).toLowerCase();
                break;
            }
            return type;
        }
        set;}

    public Boolean pageHasMessages {get {return ApexPages.hasMessages();}}

    public String getDynamicTemplate() {
        List<String> CommonList = new List<String>{'Common'};
        List<cfsp__CFSP_Config__c> configurationRecords = [SELECT cfsp__Name__c, cfsp__Data__c FROM cfsp__CFSP_Config__c WHERE cfsp__Name__c IN :CommonList LIMIT :MAX_COUNT_CONFIGURATIONS];
        String commonData = configurationRecords[0].cfsp__Data__c;
        Map<String, Object> data = (Map<String, Object>)JSON.deserializeUntyped(commonData);
        String templatePage = (data.get('templatePage') != NULL && data.get('templatePage') != '') ? (String)data.get('templatePage') : Page.cfsp__CFSP_Template.getURL().split('/')[2];

        return templatePage;
    }

    public String getRedirectRegisterPage() {
        List<String> CommonList = new List<String>{'Common'};
        List<cfsp__CFSP_Config__c> configurationRecords = [SELECT cfsp__Name__c, cfsp__Data__c FROM cfsp__CFSP_Config__c WHERE cfsp__Name__c IN :CommonList LIMIT :MAX_COUNT_CONFIGURATIONS];
        String registrationData = configurationRecords[0].cfsp__Data__c;
        Map<String, Object> data = (Map<String, Object>)JSON.deserializeUntyped(registrationData);
        String redirectRegisterPage = (data.get('redirectRegisterPage') != NULL) ? (String)data.get('redirectRegisterPage') : Page.cfsp__CFSP_Login.getURL().split('/')[2];
        if (prefix != 'cfsp__') {
            if (redirectRegisterPage.equalsIgnoreCase('c__CFSP_FindLearning') || redirectRegisterPage.equalsIgnoreCase('cfsp__CFSP_FindLearning')) {
                redirectRegisterPage = ((Boolean)data.get('anonymousSearching') == true || (Boolean)data.get('enabledAnonymousRedirectUrl') == true) ? redirectRegisterPage : Page.Biosense_Register.getURL().split('/')[2]+'?un=true';
            }
        }
        else {
            if (redirectRegisterPage.startsWithIgnoreCase('cfsp__')) {
                if (redirectRegisterPage.equalsIgnoreCase('cfsp__CFSP_FindLearning')) {
                    redirectRegisterPage = ((Boolean)data.get('anonymousSearching') == true || (Boolean)data.get('enabledAnonymousRedirectUrl') == true) ? redirectRegisterPage : Page.Biosense_Register.getURL().split('/')[2]+'?un=true';
                }
                else {
                    redirectRegisterPage = Page.Biosense_Register.getURL().split('/')[2]+'?un=true';
                }
            }
        }

        return redirectRegisterPage;
    }

    public Biosense_RegisterController () {
        //codes = new List<Integer>{1,2,3,4,5,6};
        codes = new List<Integer>();
        for (Integer i=1; i<=50; i++) {
            codes.add(i);
        }
        captchaNumber = codes[randomNumber()];
        ImagePath = pathByCode.get(captchaNumber);

        this.hideAllControls = false;
        String isUnauthorizedRegistered = ApexPages.currentPage().getParameters().get('un');
        if (isUnauthorizedRegistered == 'true') {
            this.hideAllControls = true;
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, Label.cfsp.CFSP_PAGE_ACCOUNT_LABEL_REGISTRATION_EMAIL);
            ApexPages.addMessage(msg);
        }

        this.registerSettings = getRegisterSettings();
    }

    private List<RegisterField> getRegisterSettings() {
        List<String> registerList = new List<String>{'Register'} ;
        List<cfsp__CFSP_Config__c> configurationRecords = [SELECT cfsp__Name__c, cfsp__Data__c FROM cfsp__CFSP_Config__c WHERE cfsp__Name__c IN :registerList LIMIT :MAX_COUNT_CONFIGURATIONS];
        String data = configurationRecords[0].cfsp__Data__c;
        return initFields((List<RegisterField>)JSON.deserializeStrict(data, List<RegisterField>.class));
    }

    private List<RegisterField> initFields(List<RegisterField> fields) {
        Map<String, String> labelsMap = new Map<String, String>();
        Map<String, Schema.SObjectField> contactFieldsMap = Contact.sObjectType.getDescribe().fields.getMap();
        for (String fieldName: contactFieldsMap.keySet()) {
            labelsMap.put(fieldName, contactFieldsMap.get(fieldName).getDescribe().getLabel());
        }
        Map<String, Schema.SObjectField> userFieldsMap = User.sObjectType.getDescribe().fields.getMap();
        for (String fieldName: userFieldsMap.keySet()) {
            labelsMap.put(fieldName, userFieldsMap.get(fieldName).getDescribe().getLabel());
        }
        for (RegisterField field : fields) {
            field.label = labelsMap.containsKey(field.field.toLowerCase()) ? labelsMap.get(field.field.toLowerCase()) : field.label;
            field.label = labelsMap.get(field.field.toLowerCase());
            field.instance = new FieldInstance(field.objectName, field.field);
        }
        return fields;
    }

    private Boolean validateRequiredFields() {
        Boolean hasErrors = false;

        //validate Captcha
        if (!String.isBlank(inputCaptcha)) {
            inputCaptcha = inputCaptcha.trim();
            if (inputCaptcha != codeByCaptchaNumber.get(captchaNumber)) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.BIOSENSE_WORD_VERIFICATION_INCORRECT);
                ApexPages.addMessage(msg);
                hasErrors = true;
            }
        }
        else {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.BIOSENSE_WORD_VERIFICATION_IS_REQUIRED);
            ApexPages.addMessage(msg);
            hasErrors = true;
        }

        // validate FirstName
        if (!String.isBlank(firstName)) {
            firstName = firstName.trim();
            /*
            String firstNameReqexp = '([a-zA-Z0-9_\\-\\s\']{2,60})';

            if (!Pattern.matches(firstNameReqexp, firstName)) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.CFSP_PAGE_ACCOUNT_ERROR_FIRST_NAME_INVALID);
                ApexPages.addMessage(msg);
                hasErrors = true;
            }
            */
        }
        else {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.cfsp.CFSP_PAGE_ACCOUNT_ERROR_FIRST_NAME_REQUIRED);
            ApexPages.addMessage(msg);
            hasErrors = true;
        }

        // validate LastName
        if (!String.isBlank(lastName)) {
            lastName = lastName.trim();
            /*
            String lastNameReqexp = '([a-zA-Z0-9_\\-\\s\']{2,60})';

            if (!Pattern.matches(lastNameReqexp, lastName)) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.cfsp.CFSP_PAGE_ACCOUNT_ERROR_LAST_NAME_INVALID);
                ApexPages.addMessage(msg);
                hasErrors = true;
            }
            */
        }
        else {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.cfsp.CFSP_PAGE_ACCOUNT_ERROR_LAST_NAME_REQUIRED);
            ApexPages.addMessage(msg);
            hasErrors = true;
        }

        // validate UserName
        if (!String.isBlank(username)) {
            username = username.trim();
            String usernameRegexp = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';

            if (!Pattern.matches(usernameRegexp, username)) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.cfsp.CFSP_PAGE_ACCOUNT_ERROR_USERNAME_INVALID+' '+Label.cfsp.CFSP_PAGE_ACCOUNT_LABEL_USERNAME_TITLE+': '+Label.cfsp.CFSP_PAGE_ACCOUNT_LABEL_USERNAME_PLACEHOLDER);
                ApexPages.addMessage(msg);
                hasErrors = true;
            }

            List<User> existUser = [SELECT Id FROM User WHERE Username =: username AND isActive = true LIMIT 1];
            if (!existUser.isEmpty()) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.cfsp.CFSP_PAGE_ACCOUNT_ERROR_USERNAME_DUPLICATE);
                ApexPages.addMessage(msg);
                hasErrors = true;
            }
        }
        else {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.cfsp.CFSP_PAGE_ACCOUNT_ERROR_USERNAME_REQUIRED);
            ApexPages.addMessage(msg);
            hasErrors = true;
        }

        // validate Email
        if (!String.isBlank(email)) {
            email = email.trim();
            String emailRegexp = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';

            if (!Pattern.matches(emailRegexp, email)) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.cfsp.CFSP_PAGE_ACCOUNT_ERROR_EMAIL_INVALID);
                ApexPages.addMessage(msg);
                hasErrors = true;
            }
        }
        else {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.cfsp.CFSP_PAGE_ACCOUNT_ERROR_EMAIL_REQUIRED);
            ApexPages.addMessage(msg);
            hasErrors = true;
        }
        
        // validate confirmEemail
        if (!String.isBlank(confirmEmail)) {
            confirmEmail = confirmEmail.trim();
            String emailRegexp = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';

            if (!Pattern.matches(emailRegexp, confirmEmail)) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.BIOSENSE_INVALID_CONFIRM_EMAIL);
                ApexPages.addMessage(msg);
                hasErrors = true;
            }
            else if (confirmEmail != email) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.BIOSENSE_CONFIRM_EMAIL_SHOULD_BE_AS_EMAIL);
                ApexPages.addMessage(msg);
                hasErrors = true;
            }
        }
        else {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.BIOSENSE_CONFIRM_EMAIL_IS_REQUIRED);
            ApexPages.addMessage(msg);
            hasErrors = true;
        }

        // validate CommunityNickname
        if (username != NULL && username.length() > 5) {
            communityNickname = username.substring(0, username.length() - 5) + DateTime.now().format('mm-ss');
        }

        // validate Company
        if (!String.isBlank(company)) {
            company = company.trim();
        }
        else {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.cfsp.CFSP_PAGE_ACCOUNT_ERROR_COMPANY_REQUIRED);
            ApexPages.addMessage(msg);
            hasErrors = true;
        }

        return hasErrors;
    }

    private Boolean validateAdditionalFields() {
        Boolean hasErrors = false;
        return hasErrors;
    }

    private static final Integer MAX_COUNT_CONFIGURATIONS = 20;

    public PageReference registerUser() {

        Boolean hasErrorsStandardFields = validateRequiredFields();
        Boolean hasErrorsAdditionalFields = validateAdditionalFields();
        if (hasErrorsStandardFields || hasErrorsAdditionalFields) return NULL;

        List<String> RegistrationList = new List<String>{'Registration'};
        List<cfsp__CFSP_Config__c> configurationRecords = [SELECT cfsp__Name__c, cfsp__Data__c FROM cfsp__CFSP_Config__c WHERE cfsp__Name__c IN :RegistrationList LIMIT :MAX_COUNT_CONFIGURATIONS];
        String registrationData = configurationRecords[0].cfsp__Data__c;
        RegistrationSettingsClass registrationSettings = (RegistrationSettingsClass)JSON.deserializeStrict(registrationData, RegistrationSettingsClass.class);

        Boolean enableEmailMapping = (registrationSettings.enableEmailMapping != NULL) ? registrationSettings.enableEmailMapping : false;
        Boolean allowUnknownUsers = (registrationSettings.allowUnknownUsers != NULL) ? registrationSettings.allowUnknownUsers : false;
        Boolean enableCreateLead = (registrationSettings.enableCreateLead != NULL) ? registrationSettings.enableCreateLead : false;
        Boolean limitSelfRegistration = (registrationSettings.limitSelfRegistration != NULL) ? registrationSettings.limitSelfRegistration : false;
        String limitSelfRegistrationSOQL = (!String.isBlank(registrationSettings.limitSelfRegistrationSOQL)) ? registrationSettings.limitSelfRegistrationSOQL : NULL;

        String userId;
        // set accountId by default AccountId from settings
        String defaultAccountId = registrationSettings.portalAccountId;

        String queryContact = 'SELECT Id, Name, Email, AccountId FROM Contact WHERE Email = ' + '\'' + String.escapeSingleQuotes(email) + '\'';
        queryContact += ' AND Id NOT IN (SELECT ContactId FROM User WHERE Email = ' + '\'' + String.escapeSingleQuotes(email) + '\'' + ' AND isActive = true AND IsPortalEnabled = true)';
        queryContact += (limitSelfRegistration && limitSelfRegistrationSOQL != NULL) ? (' AND (' +limitSelfRegistrationSOQL  + ')'): '';
        queryContact += ' LIMIT 1';

        List<Contact> currentContact = Database.query(queryContact);
        Boolean isExistContact = (!currentContact.isEmpty());

        User newUser = new User(FirstName = firstName, LastName = lastName, Username = username, Email = email, CommunityNickname = communityNickname);

        if (enableEmailMapping) {
            String mappedAccountId = getAccountIdByAccountEmailDomainMapping(this.email);

            // not found mapped AccountId for current email address and use default accountId
            if (mappedAccountId == NULL) {
                if (allowUnknownUsers) {
                    if (enableCreateLead) {
                        // create Lead and send custom email confirmation
                        createLead(registrationSettings);
                    }
                    else {
                        defaultAccountId = isExistContact ? String.valueOf(currentContact[0].AccountId) : defaultAccountId;
                        // register new User with default settings and send system email confirmation
                        userId = Site.createPortalUser(newUser, defaultAccountId, NULL, true);
                        updateAdditionalFieldsInExistContact(userId);
                        updateAdditionalFieldsInUser(userId);
                    }
                }
                else {
                    // show deny message
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.cfsp.CFSP_PAGE_ACCOUNT_ERROR_EMAIL_DOMAIN_IS_NOT_ALLOWED);
                    ApexPages.addMessage(msg);
                }
            }
            // found mapped accountId and get this
            else {
                // create portal user with mapped AccountId
                String ovverridenProfileId = getProfileIdByAccountEmailDomainMapping(this.email);

                if (ovverridenProfileId != NULL) {
                    // ovverride ProfileId
                    newUser.ProfileId = ovverridenProfileId;
                    // create new Contact with mappedAccountId
                    Contact newContact = (!currentContact.isEmpty()) ? currentContact[0] : createNewContact(mappedAccountId);
                    //create new Portal User with ovveriden ProfileId
                    userId = createUser(newUser, newContact);

                    if (!currentContact.isEmpty()) {
                        updateAdditionalFieldsInExistContact(userId);
                    }
                }
                else {
                    userId = Site.createPortalUser(newUser, mappedAccountId, NULL, true);
                    updateAdditionalFieldsInExistContact(userId);
                    updateAdditionalFieldsInUser(userId);
                }
            }
        }
        else {
            if (limitSelfRegistration) {
                if (isExistContact) {
                    // create new User without create new Contact record and system email confirmation
                    userId = Site.createPortalUser(newUser, currentContact[0].AccountId, NULL, true);
                    updateAdditionalFieldsInExistContact(userId);
                    updateAdditionalFieldsInUser(userId);
                }
                else {
                    // show deny message
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.cfsp.CFSP_PAGE_ACCOUNT_ERROR_EMAIL_DOMAIN_IS_NOT_ALLOWED);
                    ApexPages.addMessage(msg);
                }
            }
            else {
                // register new User with default settings and send system email confirmation
                userId = Site.createPortalUser(newUser, defaultAccountId, NULL, true);
                updateAdditionalFieldsInExistContact(userId);
                updateAdditionalFieldsInUser(userId);
            }
        }

        if (userId != NULL) {
            // registr portal user as consumer user
            createConsumerUser(userId);

            //return new PageReference(((Site.getPrefix() != NULL) ? Site.getPrefix() : '') + '/apex/'+getRedirectRegisterPage()+ (getRedirectRegisterPage().contains('?un=true') ? '&':'?')+ 'm=true');
            return new PageReference((Site.getPathPrefix()) + '/apex/'+getRedirectRegisterPage()+ (getRedirectRegisterPage().contains('?un=true') ? '&':'?')+ 'm=true');

        }

        return NULL;
    }

    @future(callout=true)
    public static void createConsumerUser(String userId) {
        try {
            lmscons.ConsumerUserWebservice.ConsumerUser_Create(userId, false);
        }
        catch (Exception e) {}
    }

    private void updateAdditionalFieldsInUser(String userId) {
        if (userId != NULL) {
            List<User> existUser = [
                SELECT
                    Id
                FROM
                    User
                WHERE
                    Id = :userId AND lmscons__Cornerstone_ID__c = NULL
                LIMIT 1
            ];

            if (!existUser.isEmpty() && this.registerSettings != NULL && this.registerSettings != NULL && !this.registerSettings.isEmpty()) {
                updateUser(existUser[0]);
            }
        }
    }

    @TestVisible
    private void updateAdditionalFieldsInExistContact(String userId) {
        if (userId != NULL) {
            List<Contact> existContact = [
                SELECT
                    Id
                FROM
                    Contact
                WHERE
                    Id IN (SELECT ContactId FROM User WHERE Id = :userId AND lmscons__Cornerstone_ID__c = NULL)
                LIMIT 1
            ];

            if (!existContact.isEmpty() && this.registerSettings != NULL && this.registerSettings != NULL && !this.registerSettings.isEmpty()) {
                updateContact(existContact[0]);
            }
        }
    }

    private String getAccountIdByAccountEmailDomainMapping(String email) {
        String accountId;
        String emailDomain = email.split('@')[1];

        List<cfsp__CFSP_Email_Domain_To_Account__c> accountEmailDomain = [
            SELECT
                cfsp__Account__c
            FROM
                cfsp__CFSP_Email_Domain_To_Account__c
            WHERE
                cfsp__Email_Domain__c = :emailDomain
            LIMIT 1
        ];

        if (!accountEmailDomain.isEmpty()) {
            accountId = accountEmailDomain[0].cfsp__Account__c;
        }

        return accountId;
    }


    private String getProfileIdByAccountEmailDomainMapping(String email) {
        String profileId;
        String emailDomain = email.split('@')[1];

        List<cfsp__CFSP_Email_Domain_To_Account__c> accountEmailDomain = [
            SELECT
                cfsp__Profile__c
            FROM
                cfsp__CFSP_Email_Domain_To_Account__c
            WHERE
                cfsp__Email_Domain__c = :emailDomain
            LIMIT 1
        ];

        if (!accountEmailDomain.isEmpty()) {
            profileId = accountEmailDomain[0].cfsp__Profile__c;
        }

        return profileId;
    }

    @TestVisible
    private User updateUser(User user) {
        if (user != NULL && user.Id != NULL) {
            SObject userAsSObjectForUpdate = (SObject)user;

            for (RegisterField field : this.registerSettings) {
                if (field.objectName.equalsIgnoreCase('user')) {
                    userAsSObjectForUpdate.put(field.field, field.instance.value.get(field.field));
                }
            }

            user = (User)userAsSObjectForUpdate;

            try {
                Database.SaveResult updateSaveResult = Database.update(user, false);

                if (updateSaveResult.isSuccess() == false) {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, json.serialize(updateSaveResult.getErrors()));
                    ApexPages.addMessage(msg);
                }
            }
            catch (Exception e) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
                ApexPages.addMessage(msg);
            }
        }

        return user;
    }

    @TestVisible
    private Contact updateContact(Contact contact) {
        if (contact != NULL && contact.Id != NULL) {

            SObject contactAsSObjectForUpdate = (SObject)contact;

            for (RegisterField field : this.registerSettings) {
                if (field.objectName.equalsIgnoreCase('contact')) {
                    contactAsSObjectForUpdate.put(field.field, field.instance.value.get(field.field));
                }
            }

            contact = (Contact)contactAsSObjectForUpdate;

            try {
                //Database.update(contact);
                Database.SaveResult updateSaveResult = Database.update(contact, false);

                if (updateSaveResult.isSuccess() == false) {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, json.serialize(updateSaveResult.getErrors()));
                    ApexPages.addMessage(msg);
                }
            }
            catch (Exception e) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
                ApexPages.addMessage(msg);
            }
        }

        return contact;
    }

    private Contact createNewContact(String accountId) {
        SObject newContact = (SObject)Type.forName('Contact').newInstance();

        newContact.put('FirstName', this.firstName);
        newContact.put('LastName', this.lastName);
        newContact.put('Email', this.email);
        newContact.put('AccountId', accountId);

        for (RegisterField field : this.registerSettings) {
            if (field.objectName.equalsIgnoreCase('contact')) {
                newContact.put(field.field, field.instance.value.get(field.field));
            }
        }

        try {
            Database.SaveResult insertSaveResult = Database.insert(newContact, false);

            if (insertSaveResult.isSuccess() == false) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, insertSaveResult.getErrors()[0].getMessage());
                ApexPages.addMessage(msg);
            }
        }
        catch (Exception e) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(msg);
        }

        return (Contact)newContact;
    }

    private String createUser(User newUser, Contact existContact) {
        newUser.put('ContactId', existContact.Id);
        newUser.put('EmailEncodingKey', 'UTF-8');
        newUser.put('LanguageLocaleKey', UserInfo.getLocale());
        newUser.put('LocaleSidKey', UserInfo.getLocale());
        newUser.put('Alias', newUser.firstName.substring(0,1) + ((newUser.lastName.length() > 7) ? newUser.lastName.substring(0, 7) : newUser.lastName.substring(0, newUser.lastName.length())));
        newUser.put('TimeZoneSidKey', UserInfo.getTimeZone().toString());

        for (RegisterField field : this.registerSettings) {
            if (field.objectName.equalsIgnoreCase('user')) {
                newUser.put(field.field, field.instance.value.get(field.field));
            }
        }

        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;

        try {
            Database.SaveResult insertSaveResult = Database.insert(newUser, dmo);

            if (insertSaveResult.isSuccess() == false) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, insertSaveResult.getErrors()[0].getMessage());
                ApexPages.addMessage(msg);
            }
        }
        catch (Exception e) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(msg);
        }

        return newUser.Id;
    }

    private void createLead(RegistrationSettingsClass registrationSettings) {
        try {
            // create lead;
            Lead newLead = new Lead(
                FirstName = firstName,
                LastName = lastName,
                Email = email,
                Company = company
            );

            insert newLead;

            // send notification
            if (registrationSettings.enableEmailNotificationNewLead) {
                sendWorkflowEmailNotificationNewLead(newLead.Id);
            }

            this.hideAllControls = true;
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, Label.cfsp.CFSP_PAGE_ACCOUNT_LABEL_CREATED_LEAD_SUCCESSFULLY);
            ApexPages.addMessage(msg);
        }
        catch (Exception e) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(msg);
        }
    }

    private static void sendWorkflowEmailNotificationNewLead(String newLeadId) {
        String recipientId = Site.getAdminId();
        String recipientEmail = Site.getAdminEmail();

        try {
            cfsp__CFSP_EmailNotification__c email = new cfsp__CFSP_EmailNotification__c(
                cfsp__Status__c = 'New',
                cfsp__Recipient__c = recipientId,
                cfsp__Email__c = recipientEmail,
                cfsp__Lead__c = newLeadId,
                cfsp__Type__c = 'NEW_LEAD_CREATED'
            );

            insert email;
        }
        catch (Exception e) {
            system.debug('--error=' + e.getMessage());
        }
    }

    @TestVisible
    private static void sendWorkflowEmailNotificationNewUser(String accountId, String userId) {
        List<Account> accountOwner = [SELECT Id, OwnerId, Owner.Email FROM Account WHERE Id = :accountId LIMIT 1];
        List<User> newContact = [SELECT Id, ContactId FROM User WHERE id = :userId LIMIT 1];

        String recipientId = (!accountOwner.isEmpty()) ? accountOwner[0].OwnerId : NULL;
        String recipientEmail = (!accountOwner.isEmpty()) ? accountOwner[0].Owner.Email : NULL;
        String contactId = (!newContact.isEmpty()) ? newContact[0].ContactId : NULL;

        try {
            cfsp__CFSP_EmailNotification__c email = new cfsp__CFSP_EmailNotification__c(
                cfsp__Status__c = 'New',
                cfsp__Recipient__c = recipientId,
                cfsp__Email__c = recipientEmail,
                cfsp__Contact__c = contactId,
                cfsp__Type__c = 'NEW_USER_CREATED'
            );

            insert email;
        }
        catch (Exception e) {
            system.debug('--error=' + e.getMessage());
        }
    }

    @future
    public static void deleteCompleteEmailNotificationRecords(List<String> recordIdsToDelete) {

        List<cfsp__CFSP_EmailNotification__c> recordsToDelete = [SELECT Id FROM cfsp__CFSP_EmailNotification__c WHERE Id IN :recordIdsToDelete LIMIT 5000];

        try {
            Database.delete(recordsToDelete);
        }
        catch(Exception e) {
            system.debug('--error-' + e.getMessage());
        }
    }

}