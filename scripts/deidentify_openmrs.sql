SET
   FOREIGN_KEY_CHECKS = 0;
-- these TABLEs will not be used, so drop their contents
TRUNCATE TABLE concept_proposal_tag_map;
TRUNCATE TABLE concept_proposal;
TRUNCATE TABLE hl7_in_archive;
TRUNCATE TABLE hl7_in_error;
TRUNCATE TABLE hl7_in_queue;
TRUNCATE TABLE notification_alert_recipient;
TRUNCATE TABLE notification_alert;
TRUNCATE TABLE audit_log;
SET
   FOREIGN_KEY_CHECKS = 1;
-- randomize the person names (given_name and family_name to contain random 8 alpha-numeric characters)
UPDATE
   person_name
SET
   given_name = concat( 'AnnonFN-', char(round(rand()* 25) + 65), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97) ), 
   middle_name = concat( 'AnnonMN-', char(round(rand()* 25) + 65), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97) ), 
   family_name = concat( 'AnnonLN-', char(round(rand()* 25) + 65), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97) )
WHERE
   person_id NOT IN
   (
      SELECT
         person_id
      FROM
         provider
   )
;
-- randomize +/- 6 months for persons older than ~15 yrs old
UPDATE
   person
SET
   birthdate = date_add(birthdate, interval cast(rand()* 182 - 182 as signed) day)
WHERE
   birthdate is not null
   and datediff(now(), birthdate) > 15 * 365;
-- randomize +/- 3 months for persons between 15 and 5 years old
UPDATE
   person
SET
   birthdate = date_add(birthdate, interval cast(rand()* 91 - 91 as signed) day)
WHERE
   birthdate is not null
   and datediff(now(), birthdate) between 15 * 365 and 5 * 365;
-- randomize +/- 30 days for persons less than ~5 years old
UPDATE
   person
SET
   birthdate = date_add(birthdate, interval cast(rand()* 30 - 30 as signed) day)
WHERE
   birthdate is not null
   and datediff(now(), birthdate) < 5 * 365;
UPDATE
   person
SET
   birthdate_estimated = cast(rand() as signed);
-- randomize the death date +/- 3 months
UPDATE
   person
SET
   death_date = date_add(death_date, interval cast(rand()* 91 - 91 as signed) day)
WHERE
   death_date is not null;
UPDATE
   person
SET
   gender = 'M';
--
-- Clear out login info
--
UPDATE
   users
SET
   username = concat( 'AnonUSR', char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97) ),
   password = 'd45e5f75a92ed88b3ebe1d0868d07e7d69609b232e8a60daddd47ffc26e2825e0481b9e712b5ecf80deb29d26553fd126878a5a26f29e28f92b2cefc02ab9573',
   salt = '77ee0588fa43f003557d7dc26c66448ededc912a928cedc310698bf1839ee703258dcbfa0dbc0583fda93c7a4f60f49bec02afde244ff9d7e222ed30c6ecf81c',
   secret_question = null,
   secret_answer = null
WHERE
   username NOT IN
   (
      'admin',
      'reports-user'
   )
;
-- clear out the username/password stored IN the db
UPDATE
   global_property
SET
   property_value = 'admin'
WHERE
   property like '%.username';
UPDATE
   global_property
SET
   property_value = 'test'
WHERE
   property like '%.password';
-- Clearing out all the user properties except favouriteObsTemplates
DELETE
FROM
   user_property
WHERE
   property NOT IN
   (
      'favouriteObsTemplates'
   )
;
--
-- Shift the person addresses around
--
UPDATE
   person_address
SET
   address1 = concat('Annon-address1-', person_id),
   address2 = concat('Annon-address2-', person_id),
   address3 = concat('Annon-address3-', person_id),
   address4 = concat('Annon-address4-', person_id),
   address5 = concat('Annon-address5-', person_id),
   address6 = concat('Annon-address6-', person_id),
   county_district = concat('Annon-countyDistrict', person_id),
   city_village = concat('Annon-cityVillage', person_id),
   country = concat('Annon-country', person_id),
   state_province = null,
   postal_code = null,
   latitude = null,
   longitude = null,
   date_created = now(),
   date_voided = now();
--
-- Bahmni customized
--
-- identifiers (Assumes patient_identifier have been TRUNCATEd)
CREATE TABLE temp_patient_identifier_old(patient_id int, identifier varchar(256), PRIMARY KEY(patient_id));
INSERT INTO
   temp_patient_identifier_old
   SELECT
      patient_id,
      identifier
   FROM
      patient_identifier;
TRUNCATE patient_identifier;
INSERT INTO
   patient_identifier (patient_id, identifier, identifier_type, location_id, preferred, creator, date_created, voided, uuid)
   SELECT
      patient_id,
      concat('PT', patient_id),
      (
         Select
            patient_identifier_type_id
         FROM
            patient_identifier_type
         WHERE
            name = 'Patient Identifier'
      ),
      3,
      1,
      1,
      (
         SELECT
            timestamp(now()) - INTERVAL FLOOR( RAND( ) * 366) DAY
      ),
      0,
      uuid()
   FROM
      patient;
CREATE TABLE temp_person_uuid_old(person_id int, uuid varchar(256), PRIMARY KEY(person_id));
INSERT INTO
   temp_person_uuid_old
   SELECT
      person_id,
      uuid
   FROM
      person;
DROP TABLE temp_patient_identifier_old;
DROP TABLE temp_person_uuid_old;
--
-- Bahmni specific
--
TRUNCATE failed_events;
/* Database restoring issue with definer */
UPDATE
   `mysql`.`proc`
SET
   definer = 'openmrs-user@localhost'
WHERE
   definer like 'openmrs-user@%';
--
-- Malawi specific
--
/* for all person attribute WHERE Name is getting captured */

UPDATE
  person_attribute pa
  INNER JOIN
     person_attribute_type pat
     ON pat.person_attribute_type_id = pa.person_attribute_type_id
     AND pat.name LIKE '%Name%'
     AND pat.format = 'java.lang.String'
SET
  pa.value = concat('Annon-', char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97) );

/* for all person attribute WHERE Comments is getting captured */

UPDATE
 person_attribute pa
 INNER JOIN
    person_attribute_type pat
    ON pat.person_attribute_type_id = pa.person_attribute_type_id
    AND pat.name LIKE '%comment%'
    AND pat.format = 'java.lang.String'
SET
 pa.value = CONCAT('Annon-', SUBSTR('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', FLOOR(1.0 + RAND()* 62), 1), SUBSTR('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', FLOOR(1.0 + RAND()* 62), 1), SUBSTR('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', FLOOR(1.0 + RAND()* 62), 1), SUBSTR('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', FLOOR(1.0 + RAND()* 62), 1), SUBSTR('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', FLOOR(1.0 + RAND()* 62), 1), SUBSTR('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', FLOOR(1.0 + RAND()* 62), 1), SUBSTR('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', FLOOR(1.0 + RAND()* 62), 1), SUBSTR('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', FLOOR(1.0 + RAND()* 62), 1), '-', pat.person_attribute_type_id);

/* for all person attribute WHERE Phone number is getting captured */
UPDATE
person_attribute pa
INNER JOIN
   person_attribute_type pat
   ON pat.person_attribute_type_id = pa.person_attribute_type_id
   AND pat.name LIKE '%Phone%'
   AND pat.format = 'java.lang.String'
SET
pa.value = FLOOR(RAND() * 100000000);

/* Making National ID to random 6 digit number */

UPDATE
   person_attribute pa
   INNER JOIN
      person_attribute_type pat
      ON pat.person_attribute_type_id = pa.person_attribute_type_id
      AND pat.name IN
      (
         "National ID"
      )
      AND pat.format = 'java.lang.String'
SET
   pa.value = LPAD(FLOOR(RAND() * 999999.99), 6, '0');

/* Random longitude and latitude */

UPDATE
   person_attribute pa
   INNER JOIN
      person_attribute_type pat
      ON pat.person_attribute_type_id = pa.person_attribute_type_id
      AND pat.format = 'java.lang.String'
      and pat.name IN
      (
         'Latitude',
         'Longitude'
      )
SET
   pa.value = ROUND( 0.1 + RAND( ) * 99, 2 );

/* Other Language */

UPDATE
   person_attribute pa
   INNER JOIN
      person_attribute_type pat
      ON pat.person_attribute_type_id = pa.person_attribute_type_id
      AND pat.name LIKE '%Language%'
      AND pat.format = 'java.lang.String'
SET
   pa.value = CONCAT('Annon-', SUBSTR('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', FLOOR(1.0 + RAND()* 62), 1), SUBSTR('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', FLOOR(1.0 + RAND()* 62), 1), SUBSTR('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', FLOOR(1.0 + RAND()* 62), 1), SUBSTR('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', FLOOR(1.0 + RAND()* 62), 1), SUBSTR('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', FLOOR(1.0 + RAND()* 62), 1), SUBSTR('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', FLOOR(1.0 + RAND()* 62), 1), SUBSTR('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', FLOOR(1.0 + RAND()* 62), 1), SUBSTR('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', FLOOR(1.0 + RAND()* 62), 1), '-', pat.person_attribute_type_id);

/* OT annonymisation # annonymising Data captured during the creation of surgical appointment */

UPDATE
   surgical_appointment_attribute_type saat
   JOIN
      surgical_appointment_attribute saa
      ON saat.surgical_appointment_attribute_type_id = saa.surgical_appointment_attribute_type_id
      AND saat.format = 'java.lang.String'
      AND saat.name NOT IN
      (
         'estTimeHours',
         'estTimeMinutes',
         'cleaningTime'
      )
      AND saa.value IS NOT NULL
SET
   saa.value =
   CASE
      WHEN
         saat.name = 'procedure'
      THEN
         CONCAT( 'Annon-procedure-', char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97) )
      WHEN
         saat.name = 'notes'
      THEN
         CONCAT( 'Annon-notes-', char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97) )
      WHEN
         saat.name = 'surgicalAssistant'
      THEN
         CONCAT( 'Annon-surgicalAssistant-', char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97) )
      WHEN
         saat.name = 'anaesthetist'
      THEN
         CONCAT( 'Annon-anaesthetist-', char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97) )
      WHEN
         saat.name = 'scrubNurse'
      THEN
         CONCAT( 'Annon-scrubNurse-', char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97) )
      WHEN
         saat.name = 'circulatingNurse'
      THEN
         CONCAT( 'Annon-circulatingNurse-', char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97) )
      WHEN
         saat.name = 'Surgeon Name'
      THEN
         CONCAT( 'Annon-Surgeon Name-', char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97) )
      WHEN
         saat.name = 'Other Surgeon Name'
      THEN
         CONCAT( 'Annon-OtherSurgeonName-', char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97) )
      WHEN
         saat.name = 'Anaesthetist Technician'
      THEN
         CONCAT( 'Annon-AnaesthetistTechnician-', char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97) )
      WHEN
         saat.name = 'HIV Status'
      THEN
         CONCAT( 'Annon-HIV Status-', char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97) )
      ELSE
         CONCAT('Annon-RandomAttribute')
   END
;
/* Annonymising Notes while cancelling / postponing */
UPDATE
   surgical_appointment
SET
   notes = concat('Annon-surgicalNotes-', char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97) )
WHERE
   notes is not NULL ;
/*  Appointment scheduling Notes */
UPDATE
   patient_appointment
SET
   comments = CONCAT('Annon-AppointmentComments', char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97), char(round(rand()* 25) + 97) );

/*  as the following comments fields having some sensitive info */

UPDATE
   obs
SET
   value_text = 'Annonimized comment'
WHERE
   concept_id IN
   (
      SELECT
         concept_id
      FROM
         concept
      WHERE
         datatype_id = 3
   )
;
UPDATE
   obs
SET
   comments = 'Annon-TestNotes'
WHERE
   comments is not null;
/* updating notes for document obs if Any */
UPDATE
   obs
SET
   comments = 'Annon-Radiology Document'
WHERE
   concept_id IN
   (
      SELECT DISTINCT
         concept_id
      FROM
         concept_name
      WHERE
         name IN
         (
            'Document',
            'Impression'
         )
   )
;
/*  Updating the documentUrls to 'document url' */
UPDATE
   obs
SET
   value_text = 'Annon-document url'
WHERE
   concept_id IN
   (
      SELECT DISTINCT
         concept_id
      FROM
         concept_name
      WHERE
         name IN
         (
            'Document',
            'Impression'
         )
   )
;