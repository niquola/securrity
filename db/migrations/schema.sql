--db:securrity
--db:fhirbase
--{{{
    -- drop table securrity_schema_migrations;
    drop schema IF EXISTS securrity cascade;
    create schema securrity;
    create extension IF NOT EXISTS "uuid-ossp";

    create table securrity.users (
      user_id uuid primary key default uuid_generate_v4(),
      name varchar unique not null,
      encrypted_password varchar,
      status varchar
    );

    create table securrity.sessions (
      session_id uuid primary key default uuid_generate_v4(),
      started_at timestamp,
      ended_at timestamp
    );

    create table securrity.operations (
      operation_id uuid primary key default uuid_generate_v4(),
      code varchar unique not null,
      display_name varchar,
      description text,
      locked boolean
    );

    create table securrity.objects (
      object_id uuid primary key default uuid_generate_v4(),
      code varchar unique not null,
      display_name varchar,
      type varchar,
      definition text,
      functional_model varchar,
      source varchar,
      locked boolean
    );

    create table securrity.roles (
      role_id uuid primary key default uuid_generate_v4(),
      display_name varchar unique not null,
      description text
    );

    create table securrity.user_roles (
      user_id uuid references securrity.users (user_id),
      role_id uuid references securrity.roles (role_id)
    );

    create table securrity.session_role (
      session_id uuid references securrity.sessions(session_id),
      role_id uuid references securrity.roles(role_id)
    );

    create table securrity.permissions (
      permission_id uuid primary key default uuid_generate_v4(),
      code varchar unique not null,
      display_name varchar,
      description text,
      object_id uuid references securrity.objects(object_id),
      operation_id uuid references securrity.operations(operation_id)
    );

    create table securrity.role_permissions (
      role_id uuid references securrity.roles(role_id),
      permission_id uuid references securrity.permissions(permission_id)
    );

    insert into securrity.operations (code, display_name, description) VALUES
      ('P1001', 'OPERATE', 'Act on an object or objects.'),
      ('P1002', 'CREATE', 'Fundamental operation in an Information System (IS) that results only in the act of bringing an object into existence.'),
      ('P1003', 'READ', 'Fundamental operation in an Information System (IS) that results only in the flow of information about an object to a subject.'),
      ('P1004', 'UPDATE', 'Fundamental operation in an Information System (IS) that results only in the revision or alteration of an object.'),
      ('P1005', 'APPEND', 'Fundamental operation in an Information System (IS) that results only in the addition of information to an object already in existence.'),
      ('P1006', 'ANNOTATE', 'Add commentary, explanatory notes, critical notes or similar content to an object.'),
      ('P1007', 'DELETE', 'Fundamental operation in an Information System (IS) that results only in the removal of information about an object from memory or storage.'),
      ('P1008', 'PURGE', 'Operation that results in the permanent, unrecoverable removal of information about an object from memory or storage (e.g. by multiple overwrites with a series of random bits).'),
      ('P1009', 'EXECUTE', 'Fundamental operation in an IS that results only in initiating performance of a single or set of programs (i.e., software objects).'),
      ('P1010', 'REPRODUCE', 'Produce another online or offline object with the same content as the original. [Use of Reproduce does not imply any form of Copy]'),
      ('P1011', 'COPY', 'Produce another online object with the same content as the original.'),
      ('P1012', 'BACKUP', 'Produce another object with the same content as the original for potential recovery, i.e., create a spare copy.'),
      ('P1013', 'RESTORE', 'Return/recreate content to original content. Produce another object with the same content as one previously backed up, i.e., recreate a readily usable copy.'),
      ('P1014', 'EXPORT', 'Reproduce an object (or a portion thereof) so that the data leaves the control of the security subsystem.'),
      ('P1015', 'PRINT', 'Render an object in printed form (typically hardcopy). '),
      ('P1016', 'DERIVE', 'Make another object with content based on but different from that of an existing object.'),
      ('P1017', 'CONVERT', 'Derive another object with the same content in a different form (different data model, different representation, and/or different format).'),
      ('P1018', 'EXCERPT', 'Derive another object which includes part but not all of the original content. '),
      ('P1019', 'TRANSLATE', 'Derive object in a different natural language, e.g., from English to Spanish.'),
      ('P1020', 'MOVE', 'Relocate (the content of) an object.'),
      ('P1021', 'ARCHIVE', 'Move (the content of) an object to long term storage.'),
      ('P1022', 'REPLACE', 'Replace an object with another object. The replaced object becomes obsolete in the process.'),
      ('P1023', 'FORWARD', 'Communicate (the content of) an object to another covered entity. '),
      ('P1024', 'TRANSFER', 'Communicate (the content of) an object to an external clearinghouse without examining the content. '),
      ('P1025', 'SIGN', 'Affix authentication information (i.e. An electronic signature) to an object so that its origin and integrity can be verified.'),
      ('P1026', 'VERIFY', 'Determine whether an object has been altered and whether its signature was affixed by the claimed signer.')
     ;

    insert into securrity.objects
    ( code , display_name , type , definition, functional_model, source )
    VALUES
      ('B2001', 'Account Receivable', 'R', 'A record of an account for collecting charges, reversals, adjustments and payments, including deductibles, copayments, coinsurance (financial transactions) credited or debited to the account receivable account for a patient`s encounter.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2002', 'Administrative Ad Hoc Report', 'R', 'A record of information generated on an ad hoc (one time) basis that contains administrative data; no clinical data will be included.', 'DC.1.1.5', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2003', 'Administrative Report', 'R', 'A record of data (patient-specific and/or summary) generated for a variety of administrative purposes.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2004', 'ADT (Admission, Discharge, Transfer) Function', 'W', 'The administrative functions of patient registration status, admission, discharge, and transfer.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2005', 'Admission Record', 'R', 'A record of patient registration upon being admitted to (accepted into) hospital.', '', 'ASTM E1239-04'),
      ('B2006', 'Advance Directive', 'R', 'A record of a living will written by the patient to the physician in case of incapacitation to give further instructions.', 'DC.1.3.2', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2007', 'Alert', 'R', 'A record of a brief online notices that is issued to users as they complete a cycle through the menu system. An alert is designed to provide interactive notification of pending computing activities, such as the need to reorder supplies or review a patient`s clinical test results.', 'DC.1.8.6, DC.2.1.2, DC.2.5.1, DC.2.6.2, DC.2.6.3', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2008', 'Ambulance Run Report', 'R', 'See On-site Care Record', '', 'Emergency Responder Electronic Health Record, Detailed Use Case, ONCHIT, 2006.'),
      ('B2009', 'Appointment Schedule', 'R', 'A record of an appointment representing a booked slot or group of slots on a schedule, relating to one or more services or resources. Two examples might include a patient visit scheduled at a clinic, and a reservation for a piece of equipment. A record of an appointment including past, present, and future appointments.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2010', 'Appointment Schedule Function', 'W', 'The process of interacting with systems and applications for the purpose of scheduling time for healthcare resources or patient care', 'S.1.6', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2011', 'Assessment', 'R', 'A record of a clinical evaluation consisting of a careful and complete history from the patient (or those who have information about the patient) and the reason(s) for their need of medical care in order to establish a diagnosis.', 'DC.1.5, DC.2.1.2', 'Adapted from Tabers Cyclopedic Medical Dictionary, 1993'),
      ('B2012', 'Audit Trail', 'R', 'A record of access attempts and resource usage to verify enforcement of business, data integrity, security, and access-control rules.', 'IN.2.2', 'ISO TS 18308, EHR-S FM, Chapter 5, Section IN.2.2'),
      ('B2013', 'Billing Attachment', 'R', 'A record of the processing of financial transactions related to the provision of healthcare services including the processing of eligibility verification, prior authorization, pre-determination, claims and remittance advice. The processing of patient information in the context of the EHR for reimbursement support.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2014', 'Blood Bank Order', 'R', 'A record of a request for whole blood or certain derived blood components.', 'DC.17.2.3, DC 2.4.5.1', 'Adapted from Tabers Cyclopedic Medical Dictionary, 1993'),
      ('B2015', 'Blood Product Administration Record', 'R', 'A record of the blood products or certain derived blood components administered to a particular patient.', 'DC.17.2.3, DC 2.4.5.1', 'EHR-S FM, Chapter 3, Section DC.2.4.5.1'),
      ('B2016', 'Biologic Order', 'R', 'A record of a request for (general) medicinal compounds that are prepared from living organisms and their products. Includes serums, vaccines, antigents and antitoxins.', 'DC.17.2.3, DC 2.4.5.1', 'Adapted from Tabers Cyclopedic Medical Dictionary, 1993'),
      ('B2017', 'Business Rule', 'R', 'A record of computable statement that alter system behavior in accordance with specified policies or clinical algorithms. Alerts that provide clinical decision support typically rely on underlying business rules.', 'IN.6', 'EHR-S FM, Chapter 5, Section IN.6'),
      ('B2018', 'Care Plan', 'R', 'A record of expected or planned activities, including observations, goals, services, appointments and procedures, usually organized in phases or sessions, which have the objective of organizing and managing health care activity for the patient, often focused upon one or more of the patient’s health care problems.', 'DC.1.6.1, DC.1.6.2', 'EHR-S Functional Model, Glossary'),
      ('B2019', 'Chief Complaint', 'R', 'A record of the reason for the episode/encounter and patient’s complaints and symptoms reflecting their own perceptions of their needs. The nature and duration of symptoms that caused the patient to seek medical attention, as stated in the patient’s own words.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2020', 'Claims and Reimbursement', 'R', 'A record of a request for payment from third-party payors for health-care-related services received by a patient.', 'S.3.3.4, S.3.3.5', 'HL7 Claims and Reimbursement Glossary HL7 RBAC Task Force'),
      ('B2021', 'Clinical Ad Hoc Report', 'R', 'A record of information generated on an ad hoc (one time) basis that contains clinical data.', 'DC.1.1.5', 'EHR-S FM, Chapter 3 Section DC.1.1.5; HL7 RBAC Task Force'),
      ('B2022', 'Clinical Guideline', 'R', 'A record that describes the processes used to evaluate and treat a patient having a specific diagnosis, condition, or symptom. Clinical practice guidelines are found in the literature under many names - practice parameters, practice guidelines, patient care protocols, standards of practice, clinical pathways or highways, care maps, and other descriptive names. Clinical practice guidelines should be evidence-based, authoritative, efficacious and effective within the targeted patient populations.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2023', 'Clinical Report', 'R', 'A record that summarizes clinical, as opposed to administrative, information about a patient.', 'DC.1.1.4', 'EHR-S FM specification, Chapter 3 Section DC.1.1.4; HL7 RBAC Task Force'),
      ('B2024', 'Coding', 'W', 'A process where medical records produced by the health care provider are translated into a code that identifies each diagnosis and procedure utilized in treating the patient. ', 'S.3.2.1, S.3.2.2', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2025', 'Consent Directive (informational)', 'R', 'A record of a patient`s consent or dissent to collection, access, use or disclosure of individually identifiable health information as permitted under the applicable privacy policies about which they have been informed.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2026', 'Consent Directive (consent to treat)', 'R', 'A record of a patient`s consent indicating that (s)he has been informed of the nature of the treatment, risks, complications, alternative forms of treatment and treatment consequences and has authorized that treatment. ', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2027', 'Consult Order', 'R', 'A record of a request for a consult (service/sub-specialty evaluation) or procedure (i.e. Electrocardiogram) to be completed for a patient. Referral of a patient by the primary care physician to another hospital service/ specialty, to obtain a medical opinion based on patient evaluation and completion of any procedures, modalities, or treatments the consulting specialist deems necessary to render a medical opinion.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2028', 'Consultation Finding', 'R', 'A record of the recommendations made by the consulting practitioner.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2029', 'Current Directory of Provider Information', 'R', 'The current directory of provider information in accordance with relevant laws, regulations, and conventions, including full name, address or physical location, and a 24x7 telecommunications address (e.g. phone or pager access number) to support delivery of effective healthcare.', 'S.1.3.7', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2030', 'De-identified Patient Data', 'R', 'A record of patient data from which important identifiers (Birth date, gender, address, age, etc) have been removed before they can be used for research or other purposes.', 'S.1.5', 'http://www.informatics-review.com/wiki/index.php/De-Identified_Patient_Data http://www.informatics-review.com/wiki/index.php/De-Identified_Patient_Data'),
      ('B2031', 'Diet Order', 'R', 'A record of a patient diet. A patient may have only one effective diet order at a time.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2032', 'Discharge Summary', 'R', 'A record of a summary of hospitalization to the Primary Care Provider (PCP) who will follow the patient in clinic after his/her stay or to the admitting doctor at next hospitalization.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2033', 'Do Not Resusitate (DNR) Order', 'R', 'A record in the patient`s medical record instructing the medical staff not to try to revive the patient if breathing or heartbeat has stopped. ', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2034', 'Durable Medical Equipment Order', 'R', 'A record of a request for durable medical equipment. ', 'DC.1.7.2.1', ' http://www.ssa.gov/OP_Home/ssact/title18/1861.htm#n http://www.ssa.gov/OP_Home/ssact/title18/1861.htm#n'),
      ('B2035', 'Emergency Care Record', 'R', 'A record of patient care given in an Emergency Department.', '', 'Emergency Responder Electronic Health Record, Detailed Use Case, ONCHIT, 2006.'),
      ('B2036', 'Emergency Contact Information', 'R', 'A record of a information required to contact an individual selected by the patient in case of an emergency.', '', 'Emergency Responder Electronic Health Record, Detailed Use Case, ONCHIT, 2006.'),
      ('B2037', 'Emergency healthcare resource information', 'R', 'A record of health care resources (such as beds, operating theatres, medical supplies, and vaccines) that are available in response to local or national emergencies.', 'S.1.7', 'EHR-S FM, Chapter 4, Section S.1.7'),
      ('B2038', 'Encounter Data', 'R', 'A record of data relating to treatment or service rendered by a provider to a patient. Used in determining the level of service.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2039', 'Explanation of Benefits (EOB)', 'R', 'A record which identifies paid amount, adjudication results and informational items for invoice grouping. The provider may forward EOB details from a primary payor unaltered to a secondary adjudicator for co-ordination of benefits.', 'S.3.3.2', 'HL7 Claims and Reimbursement glossary '),
      ('B2040', 'External Clinical Information', 'R', 'A record of clinical data and documentation (such as diagnostic images) from outside the institution`s Electronic Health Record system.', 'DC.1.1.3.1', 'EHR-S FM, Chapter 3, Section DC.1.1.3.1'),
      ('B2041', 'Family History', 'R', 'A record of the patient family`s relationships, major illnesses and causes of death.', 'PH.2.5.8', 'PHRS Functional Model, Release 1, May 2008.'),
      ('B2042', 'Formulary', 'R', 'A record of the list of medications that are a benefit for an individual or a defined group.', 'DC.1.7.1', 'HL7 Claims and Reimbursement glossary '),
      ('B2043', 'Genetic Information', 'R', 'A record of a genetic test that reveals information about a patient`s genotype, mutations or chromosomal changes.', 'PH.2.5.9', 'PHRS Functional Model, Release 1, May 2008. '),
      ('B2044', 'Health Outcome Record', 'R', 'A record of the effects of the health care process on patients and populations. Examples of health outcome records include chronic disease and morbidity, physical functional status, and quality of life.', 'S.2.1', ' http://www.nlm.nih.gov/nichsr/corelib/houtcomes.html http://www.nlm.nih.gov/nichsr/corelib/houtcomes.html'),
      ('B2045', 'Health Record Extraction ', 'R', 'A record of patient data aggregated for analysis, reporting, or distribution. May include de-identified patient data.', 'IN.2.4', 'EHR-S FM, Chapter 5, Section IN.2.4'),
      ('B2046', 'Health Status Data', 'R', 'A record of the state of the health of a specified individual, group, or population. This item lists the data elements and indicators used in the data set to describe the health status of an individual or target population(s).', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2047', 'History and Physical', 'R', 'A record of a patient`s history and physical examinations. ', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2048', 'Immunization List', 'R', 'A detailed record of the immunizations administered to a patient over a given time period.', 'DC.1.4.4', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2049', 'Inpatient Medication Order', 'R', 'A record of (a) the identity of the drug to be administered, (b) dosage of the drug, (c) route by which the drug is to be administered, (d) time and/or frequency of administration, (e) registration number and address for a controlled substance.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2050', 'Inter-Provider Communication', 'W', 'The process of supporting electronic messaging (inbound and outbound) between providers to trigger or respond to pertinent actions in the care process and document non-electronic communication (such as phone calls, correspondence or other encounters). Messaging among providers involved in the care process can range from real time communication (for example, fulfillment of an injection while the patient is in the exam room), to asynchronous communication (for example, consult reports between physicians).', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2051', 'Laboratory Order', 'R', 'A record of a request for clinical laboratory services for a specified patient.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2052', 'Master Patient Index', 'R', 'A record used for the tracking of patient information by assigning each patient an identifying series of characters.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2053', 'Medical History ', 'R', 'A record of information about a patient`s medical, procedural/surgical, social and family history that can provide information useful in formulating a diagnosis and providing medical care to the patient.', 'DC.1.2', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2054', 'Medication Administration Record (M.A.R.)', 'R', 'A record of a medication administration is generated by the EHR, based upon the medical orders and the patient`s plan of care. This document is used to conduct rounds and dispense medications. (i.e. The medication bar code, patient wristband, and the provider bar are used to uniquely identify each administration of a medication in the hospital and nursing home settings.) ', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2055', 'Nursing Order', 'R', 'A record of a request to a nurse in a ward regarding nursing procedures for a patient.', 'DC.1.6.2, DC.1.7.1, DC.1.7.2, DC.1.7.3', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2056', 'On-Site Care Record', 'R', 'A record that is used to collect information at the scene of a healthcare incident by on-site care providers. On-site healthcare is often provided in emergency situations. Also called Ambulance Run Report.', '', 'Emergency Responder Electronic Health Record, Detailed Use Case, ONCHIT, 2006.'),
      ('B2057', 'Order Set', 'R', 'A record of a pre-filled ordering template, or electronic protocol, that is derived from evidence based best practice guidelines. The collection of proposed acts within the order set has been developed and edited to promote consistent and effective organization of health care activity. ', 'DC.1.6.2, DC.1.7.1, DC.1.7.2, DC.1.7.3', 'HL7 Glossary, (1) Kamal J, Rogers P, Saltz J, Mekhjian HS. Information Warehouse as a Tool to Analyze Computerized Physician Order Entry Order Set Utilization: Opportunities for Improvement. In: AMIA 2003 Symposium Proceedings; 2003; Washington, DC; 2003. p. 336-41.'),
      ('B2058', 'Outpatient Prescription Order', 'R', 'A record of a request for a prescription medication to be dispensed to an outpatient.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2059', 'Past Visits', 'R', 'A record of all prior admissions to a facility that may have been documented in Provider Visit notes, Non-Visit Encounter notes, and Non-Scheduled Provider Visit notes.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2060', 'Patient Acuity', 'R', 'A record of the measurement of the intensity of care required for a patient accomplished by a registered nurse. There are six categories ranging from minimal care (I) to intensive care (VI).', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2061', 'Patient Allergy or Adverse Reaction', 'R', 'A record of a misguided reaction to a foreign substance by the immune system, the body system of defense against foreign invaders, particularly pathogens (the agents of infection). This includes noxious reaction from the administration of over-the-counter, prescription, or investigational/research drugs. ', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2062', 'Patient Bed Assignment', 'R', 'A record of the available beds to which a patient can be assigned to optimize care and minimize risk (such as exposure to contagious patients).', 'S.1.4.4', 'EHR-S FM, Chapter 4, Section S.1.4.4'),
      ('B2063', 'Patient Demographics (see also Patient Identification)', 'R', 'A record of the patient`s demographic characteristics (such as age, gender, race/ethnicity, marital status, and occupation).', 'DC.2.5.1, DC.2.6.1, DC.3.2.5', 'http://www.usc.edu/schools/medicine/departments/preventive_medicine/divisions/epidemiology/research/csp/CSPedia/WebHelp/Patient_Demographics/Patient_Demographics_Introduction.htm http://www.usc.edu/schools/medicine/departments/preventive_medicine/divisions/epidemiology/research/csp/CSPedia/WebHelp/Patient_Demographics/Patient_Demographics_Introduction.htm'),
      ('B2064', 'Patient Education', 'W', 'A teaching program or information data sheet given to patients concerning their own health needs.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2065', 'Patient health data from administrative or financial sources', 'R', 'A record of patient health data extracted from administrative or financial information sources. Such derived data should be clearly labeled to distinguish it from clinically authenticated data.', 'DC 1.1.3.3', 'EHR-S FM, Chapter 3, Section S.1.1.3.3'),
      ('B2066', 'Patient Identification (see also Patient Demographic)', 'R', 'A record of permanent identifying and demographic information about a patient used by applications as the main means of communicating this information to other systems.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2067', 'Patient-Specific Instructions', 'R', 'A record of specific directions given to a patient in connection with his or her health care. Examples include directions for taking medication, for activities that are required or prohibited shortly before or after a surgical procedure, or for a regimen to be followed after discharge from a hospital.', 'DC.1.7.1, DC.1.7.2.1, DC.1.9', 'EHR-S FM, Chapter 3 Sections DC.1.7.1, DC.1.7.2.1, and DC.1.9'),
      ('B2068', 'Patient Location Information', 'R', 'A record of a patient`s location within the premises of a health care facility during an episode of care.', 'S.1.4.2', 'EHR-S FM, Chapter 4 Section S.1.4.2'),
      ('B2069', 'Patient Lookup (see also Patient Demographic)', 'W', 'A process by which the user queries the EHR for patient information by criteria such as name, date of birth, last name, and sex. ', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2070', 'Patient Originated Data', 'R', 'A record containing data provided by the patient. Such a record should be clearly labelled to distinguish it from clinically authenticated data entered by a provider.', 'DC.1.1.3.2', 'EHR-S FM, Chapter 3, Section DC.1.1.3.2'),
      ('B2071', 'Patient/Family Preferences', 'R', 'A record of patient/family preferences and concerns, such as with native speaking language, medication choice, invasive testing, and consent and advance directives. Improves patient safety and facilitates self-health management. ', 'DC.1.3.1', 'EHR-S FM, Chapter 3, Section DC.1.3.2, ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2072', 'Patient Residence Information', 'R', 'A record of the patient`s residence, for the purpose of providing in-home health services or providing transportion assistance.', 'S.1.4.3', 'EHR-S FM, Chapter 4, Section S.1.4.3'),
      ('B2073', 'Patient Test Report', 'R', 'A record of the result of any test or procedure performed on a patient or patient specimen.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2074', 'Point of Care Testing Results', 'R', 'A record of the results of a diagnostic test performed at or near the site of patient care.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2075', 'Population Group', 'R', 'A record which includes information from a group of individuals united by a common factor (e.g., geographic location, ethnicity, disease, age, gender)', 'DC.2.2.2', 'NCI Thesaurus/A7589551'),
      ('B2076', 'Prescription Costing Information', 'R', 'A record of the cost of a prescription.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2077', 'Problem List', 'R', 'A record of brief statements that catalog a patient’s medical, nursing, dental, social, preventative and psychiatric events and issues that are relevant to that patient’s health care (e.g., signs, symptoms, and defined conditions).', 'DC.1.1.4, DC.1.4.3', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2078', 'Progress Note', 'R', 'A record of a description of the health care provider’s observations, their interpretations and conclusions about the clinical course of the patient or the steps taken, or to be taken, in the care of the patient.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2079', 'Prosthetic Order', 'R', 'A record of a request for an appropriate prosthetic that affects the care and treatment of the beneficiary.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2080', 'Provider Access Level', 'R', 'A record showing the system resources that each practitioner in a provider directory is authorized to use.', 'S.1.3.1', 'EHR-S FM, Chapter 4, Section S.1.3.1'),
      ('B2081', 'Provider Caseload Information', 'R', 'A record of the caseload (i.e., panel of patients) for a given provider. Information about the caseload or panel includes such things as whether or not a new member/patient/client can be added. ', 'S.1.3.6', 'EHR-S FM, Chapter 4, Section S.1.3.6'),
      ('B2082', 'Provider Group Information', 'R', 'A record, directory, registry or repository containing information about teams or groups of providers.', 'S.1.3.5', 'EHR-S FM, Chapter 4, Section S.1.3.5'),
      ('B2083', 'Provider Location Information', 'R', 'A record of the location of a provider within a facility, at offices outside a facility, and when on call.', 'S.1.3.2, S.1.3.3, S.1.3.4', 'EHR-S FM, Chapter 4, Sections S.1.3.2, S.1.3.3, and S.1.3.4'),
      ('B2084', 'Public Health Report', 'R', 'A record of information submitted to public health authorities regarding a particular patient', 'DC.1.1.4, S.3.3.6', 'EHR-S FM, Chapter 3 Section DC.1.1.4 and Chapter 4 Section S.3.3.6'),
      ('B2085', 'Quality of Care Information', 'R', 'A record containing information used by performance and accountability measures for health care delivery', 'S.2.1.2', 'EHR-S FM, Chapter 4, Section S.2.1.2'),
      ('B2086', 'Radiology Order', 'R', 'A record of a request for radiology and diagnostic services for a specified patient.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2087', 'Record Tracking', 'W', 'A process for managing and tracking the location of patient medical records.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2088', 'Referral Information', 'R', 'A record of a referral of a patient from one health care provider to another, regardless of whether a provider is internal or external to the organization ', 'DC.1.7.2.4', 'EHR-S FM, Chapter 3, Section S.1.7.2.4'),
      ('B2089', 'Registration', 'R', 'A record of information for legal or other records. Information may be gathered by interview or other source documentation.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2090', 'Release of Information', 'R', 'A record of a request by a patient or patient representative to release specified medical information to a third party.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2091', 'Remotely Monitored Device Data', 'R', 'A record of information from a medical device measuring a patient`s physiological, diagnostic, medication tracking or activities of daily living measurements in a non-clinical setting remote from the healthcare provider. Such information can be communicated to the provider`s EHR or the patient`s PHR directly.', 'PH.3.1.2, S.3.1.4', 'PHRS Functional Model, Release 1, May 2008, EHR-S FM, Chapter 3, Section S.3.1.4'),
      ('B2092', 'Research Protocol', 'R', 'A record describing an action plan for a research study, including enrollment criteria, interventions to be performed, and data to be collected.', 'DC.2.2.3', 'EHR-S FM, Chapter 3, Section DC.2.2.3'),
      ('B2093', 'Result Interpretation', 'R', 'A record of how results (from diagnostic tests) were interpreted in the concext of the patient`s health care data.', 'DC.2.4.3', 'EHR-S FM, Chapter 3, Section S.2.4.3'),
      ('B2094', 'Service Authorization', 'R', 'A record of information needed to support verification of medical necessity and prior authorization of services at the appropriate juncture in the encounter workflow.', 'S.3.3.3', 'EHR-S FM, Chapter 4, Section S.3.3.3.'),
      ('B2095', 'Service Request', 'R', 'A record of a request for additional clinical information.', 'S.3.3.4', 'EHR-S FM, Chapter 4, Section S.3.3.4.'),
      ('B2096', 'Skin Test Order', 'R', 'A request for an epicutaneous or intradermal application of a sensitizer for demonstration of either delayed or immediate hypersensitivity. Used in diagnosis of hypersensitivity or as a test for cellular immunity.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2097', 'Standing Order(s) PRN', 'R', 'Standing Orders - The record of a request to be carried out. PRN orders - a record of a request to be carried out as needed.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2098', 'Supply Order', 'R', 'A record of a request for a quantity of manufactured material to be specified either by name, ID, or optionally, the manufacturer.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2099', 'Surgical Report', 'R', 'A report containing information regarding the surgical team, diagnoses, surgical interventions, and the method of anesthesia.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2100', 'Task Assignment', 'R', 'A record of the assignment or delegation of health care tasks to appropriate parties', 'DC.3.3.1', 'EHR-S FM, Chapter 3, Section DC.3.3.1'),
      ('B2101', 'Transcription', 'W', 'The process of dictating or otherwise documenting information into an electronic format. ', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2102', 'Transfer Summary', 'R', 'A record of a patient`s health information necessary to facilitate the transition of the patient from one healthcare provider to another and enable efficient and effective care.', '', 'FORE Library: HIM Body of Knowledge'),
      ('B2103', 'Treatment Plan', 'R', 'See Care Plan.', '', '(see Care Plan)'),
      ('B2104', 'Verbal and Telephone Order', 'R', 'A record describing the healthcare services requested in a verbal or telephone communication.', '', 'ANSI/HL7 V3 RBAC, R1-2008'),
      ('B2105', 'Vital Signs/Patient Measurements', 'R', 'A record of physical signs that indicate an individual is alive, such as heart beat, breathing rate, temperature, and blood pressure. These signs may be observed, measured, (documented in the patient’s chart) and monitored to assess an individual`s level of physical functioning. ', '', 'ANSI/HL7 V3 RBAC, R1-2008')
     ;
--}}}
