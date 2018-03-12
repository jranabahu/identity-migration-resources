declare
  con_name varchar2(100);
  command varchar2(200);
  databasename VARCHAR2(100);
BEGIN
  databasename := 'SAMPLE';

  begin
    select constraint_name into con_name from all_constraints where table_name='IDN_OAUTH1A_REQUEST_TOKEN' AND UPPER(owner)=UPPER(databasename) AND constraint_type = 'R';

    if TRIM(con_name) is not null
    then
      command := 'ALTER TABLE IDN_OAUTH1A_REQUEST_TOKEN DROP CONSTRAINT ' || con_name;
      dbms_output.Put_line(command);
      execute immediate command;
    end if;

    exception
    when NO_DATA_FOUND
    then
    dbms_output.Put_line('Foreign key not found');
  end;
  begin
    select constraint_name into con_name from all_constraints where table_name='IDN_OAUTH1A_ACCESS_TOKEN' AND UPPER(owner)=UPPER(databasename) AND constraint_type = 'R';

    if TRIM(con_name) is not null
    then
      command := 'ALTER TABLE IDN_OAUTH1A_ACCESS_TOKEN DROP CONSTRAINT ' || con_name;
      dbms_output.Put_line(command);
      execute immediate command;
    end if;

    exception
    when NO_DATA_FOUND
    then
    dbms_output.Put_line('Foreign key not found');
  end;
  begin
    select constraint_name into con_name from all_constraints where table_name='IDN_OAUTH2_ACCESS_TOKEN' AND UPPER(owner)=UPPER(databasename) AND constraint_type = 'R';

    if TRIM(con_name) is not null
    then
      command := 'ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN DROP CONSTRAINT ' || con_name;
      dbms_output.Put_line(command);
      execute immediate command;
    end if;

    exception
    when NO_DATA_FOUND
    then
    dbms_output.Put_line('Foreign key not found');
  end;
  begin
    select constraint_name into con_name from all_constraints where table_name='IDN_OAUTH2_AUTHORIZATION_CODE' AND UPPER(owner)=UPPER(databasename) AND constraint_type = 'R';

    if TRIM(con_name) is not null
    then
      command := 'ALTER TABLE IDN_OAUTH2_AUTHORIZATION_CODE DROP CONSTRAINT ' || con_name;
      dbms_output.Put_line(command);
      execute immediate command;
    end if;

    exception
    when NO_DATA_FOUND
    then
    dbms_output.Put_line('Foreign key not found');
  end;

  begin
    select constraint_name into con_name from all_constraints where table_name='IDN_OAUTH_CONSUMER_APPS' AND UPPER(owner)=UPPER(databasename) AND constraint_type = 'P';

    if TRIM(con_name) is not null
    then
      command := 'ALTER TABLE IDN_OAUTH_CONSUMER_APPS DROP CONSTRAINT ' || con_name;
      dbms_output.Put_line(command);
      execute immediate command;
    end if;

    exception
    when NO_DATA_FOUND
    then
    dbms_output.Put_line('Primary key not found');
  end;
  begin
    select constraint_name into con_name from all_constraints where table_name='IDN_OAUTH2_ACCESS_TOKEN' AND UPPER(owner)=UPPER(databasename) AND constraint_type = 'P';

    if TRIM(con_name) is not null
    then
      command := 'ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN DROP CONSTRAINT ' || con_name;
      dbms_output.Put_line(command);
      execute immediate command;
    end if;

    exception
    when NO_DATA_FOUND
    then
    dbms_output.Put_line('Primary key not found');
  end;
  begin
    select constraint_name into con_name from all_constraints where table_name='IDN_AUTH_SESSION_STORE' AND UPPER(owner)=UPPER(databasename) AND constraint_type = 'P';

    if TRIM(con_name) is not null
    then
      command := 'ALTER TABLE IDN_AUTH_SESSION_STORE DROP CONSTRAINT ' || con_name;
      dbms_output.Put_line(command);
      execute immediate command;
    end if;

    exception
    when NO_DATA_FOUND
    then
    dbms_output.Put_line('Primary key not found');
  end;
  begin
    select constraint_name into con_name from all_constraints where table_name='IDN_OAUTH2_AUTHORIZATION_CODE' AND UPPER(owner)=UPPER(databasename) AND constraint_type = 'P';

    if TRIM(con_name) is not null
    then
      command := 'ALTER TABLE IDN_OAUTH2_AUTHORIZATION_CODE DROP CONSTRAINT ' || con_name;
      dbms_output.Put_line(command);
      execute immediate command;
    end if;

    exception
    when NO_DATA_FOUND
    then
    dbms_output.Put_line('Primary key not found');
  end;

  DECLARE
  COUNT_INDEXES INTEGER;
  BEGIN
    SELECT COUNT(*) INTO COUNT_INDEXES
      FROM USER_INDEXES
      WHERE INDEX_NAME = 'IDX_AT_CK_AU';

    IF COUNT_INDEXES > 0 THEN
      EXECUTE IMMEDIATE 'DROP INDEX IDX_AT_CK_AU';
    END IF;
  END;

  DECLARE
  COUNT_INDEXES INTEGER;
  BEGIN
    SELECT COUNT(*) INTO COUNT_INDEXES
      FROM USER_INDEXES
      WHERE INDEX_NAME = 'IDX_OAUTH_ACCTKN_CONK_UTYPE';

    IF COUNT_INDEXES > 0 THEN
      EXECUTE IMMEDIATE 'DROP INDEX IDX_OAUTH_ACCTKN_CONK_UTYPE';
    END IF;
  END;

END;
/

CREATE TABLE IDP_METADATA (
  ID INTEGER,
  IDP_ID INTEGER,
  NAME VARCHAR(255) NOT NULL,
  VALUE VARCHAR(255) NOT NULL,
  DISPLAY_NAME VARCHAR(255),
  TENANT_ID INTEGER DEFAULT -1,
  PRIMARY KEY (ID),
  CONSTRAINT IDP_METADATA_CONSTRAINT UNIQUE (IDP_ID, NAME),
  FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE)
/
CREATE SEQUENCE IDP_METADATA_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER IDP_METADATA_TRIG
BEFORE INSERT
ON IDP_METADATA
REFERENCING NEW AS NEW
FOR EACH ROW
  BEGIN
    SELECT IDP_METADATA_SEQ.nextval INTO :NEW.ID FROM dual;
  END;
/

INSERT INTO IDP_METADATA (IDP_ID, NAME, VALUE, DISPLAY_NAME, TENANT_ID) SELECT ID, 'SessionIdleTimeout', '15',
  'Session Idle Timeout', -1234 FROM IDP WHERE TENANT_ID = -1234 AND NAME = 'LOCAL'
/
INSERT INTO IDP_METADATA (IDP_ID, NAME, VALUE, DISPLAY_NAME, TENANT_ID) SELECT ID, 'RememberMeTimeout', '20160', 'RememberMe Timeout', -1234 FROM IDP WHERE TENANT_ID = -1234 AND NAME = 'LOCAL'
/

CREATE TABLE SP_METADATA (
  ID INTEGER,
  SP_ID INTEGER,
  NAME VARCHAR(255) NOT NULL,
  VALUE VARCHAR(255) NOT NULL,
  DISPLAY_NAME VARCHAR(255),
  TENANT_ID INTEGER DEFAULT -1,
  PRIMARY KEY (ID),
  CONSTRAINT SP_METADATA_CONSTRAINT UNIQUE (SP_ID, NAME),
  FOREIGN KEY (SP_ID) REFERENCES SP_APP(ID) ON DELETE CASCADE)
/
CREATE SEQUENCE SP_METADATA_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER SP_METADATA_TRIG
BEFORE INSERT
ON SP_METADATA
REFERENCING NEW AS NEW
FOR EACH ROW
  BEGIN
    SELECT SP_METADATA_SEQ.nextval INTO :NEW.ID FROM dual;
  END;
/

ALTER TABLE IDN_OAUTH_CONSUMER_APPS ADD ID INTEGER
/
CREATE SEQUENCE IDN_OAUTH_CONSUMER_APPS_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER IDN_OAUTH_CONSUMER_APPS_TRIG
BEFORE INSERT
ON IDN_OAUTH_CONSUMER_APPS
REFERENCING NEW AS NEW
FOR EACH ROW
  BEGIN
    SELECT IDN_OAUTH_CONSUMER_APPS_SEQ.nextval INTO :NEW.ID FROM dual;
  END;
/
UPDATE IDN_OAUTH_CONSUMER_APPS SET ID = IDN_OAUTH_CONSUMER_APPS_SEQ.NEXTVAL
/
ALTER TABLE IDN_OAUTH_CONSUMER_APPS ADD USER_DOMAIN VARCHAR(50)
/
ALTER TABLE IDN_OAUTH_CONSUMER_APPS ADD PRIMARY KEY (ID)
/
ALTER TABLE IDN_OAUTH_CONSUMER_APPS MODIFY CONSUMER_KEY VARCHAR (255)  NOT NULL
/
ALTER TABLE IDN_OAUTH_CONSUMER_APPS ADD CONSTRAINT CONSUMER_KEY_CONSTRAINT UNIQUE (CONSUMER_KEY)
/

ALTER TABLE IDN_OAUTH1A_REQUEST_TOKEN ADD CONSUMER_KEY_ID INTEGER
/
UPDATE IDN_OAUTH1A_REQUEST_TOKEN REQUEST_TOKEN set REQUEST_TOKEN.CONSUMER_KEY_ID = (select CONSUMER_APPS.ID from IDN_OAUTH_CONSUMER_APPS CONSUMER_APPS where CONSUMER_APPS.CONSUMER_KEY = REQUEST_TOKEN.CONSUMER_KEY)
/
ALTER TABLE IDN_OAUTH1A_REQUEST_TOKEN DROP COLUMN CONSUMER_KEY
/
ALTER TABLE IDN_OAUTH1A_REQUEST_TOKEN ADD FOREIGN KEY (CONSUMER_KEY_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE
/
ALTER TABLE IDN_OAUTH1A_REQUEST_TOKEN ADD TENANT_ID INTEGER DEFAULT -1
/

ALTER TABLE IDN_OAUTH1A_ACCESS_TOKEN ADD CONSUMER_KEY_ID INTEGER
/
UPDATE IDN_OAUTH1A_ACCESS_TOKEN ACCESS_TOKEN set ACCESS_TOKEN.CONSUMER_KEY_ID = (select CONSUMER_APPS.ID from IDN_OAUTH_CONSUMER_APPS CONSUMER_APPS where CONSUMER_APPS.CONSUMER_KEY = ACCESS_TOKEN.CONSUMER_KEY)
/
ALTER TABLE IDN_OAUTH1A_ACCESS_TOKEN DROP COLUMN CONSUMER_KEY
/
ALTER TABLE IDN_OAUTH1A_ACCESS_TOKEN ADD FOREIGN KEY (CONSUMER_KEY_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE
/
ALTER TABLE IDN_OAUTH1A_ACCESS_TOKEN ADD TENANT_ID INTEGER DEFAULT -1
/

ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ADD TOKEN_ID VARCHAR (255)
/
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ADD CONSUMER_KEY_ID INTEGER
/
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ADD GRANT_TYPE VARCHAR (50)
/
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ADD SUBJECT_IDENTIFIER VARCHAR(255)
/
UPDATE IDN_OAUTH2_ACCESS_TOKEN ACCESS_TOKEN set ACCESS_TOKEN.CONSUMER_KEY_ID = (select CONSUMER_APPS.ID from IDN_OAUTH_CONSUMER_APPS CONSUMER_APPS where CONSUMER_APPS.CONSUMER_KEY = ACCESS_TOKEN.CONSUMER_KEY)
/
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN DROP CONSTRAINT CON_APP_KEY
/
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN DROP COLUMN CONSUMER_KEY
/
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ADD TENANT_ID INTEGER
/
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ADD USER_DOMAIN VARCHAR(50)
/
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ADD REFRESH_TOKEN_TIME_CREATED TIMESTAMP
/
UPDATE IDN_OAUTH2_ACCESS_TOKEN SET REFRESH_TOKEN_TIME_CREATED = TIME_CREATED
/
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ADD REFRESH_TOKEN_VALIDITY_PERIOD NUMBER(19)
/
UPDATE IDN_OAUTH2_ACCESS_TOKEN SET REFRESH_TOKEN_VALIDITY_PERIOD = 84600000
/
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ADD TOKEN_SCOPE_HASH VARCHAR (32)
/
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN MODIFY TOKEN_STATE_ID VARCHAR (128) DEFAULT 'NONE' NOT NULL
/
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ADD CONSTRAINT CON_APP_KEY UNIQUE (CONSUMER_KEY_ID,AUTHZ_USER,TENANT_ID,USER_DOMAIN,USER_TYPE,TOKEN_SCOPE_HASH,TOKEN_STATE,TOKEN_STATE_ID)
/
CREATE INDEX IDX_AT_CK_AU ON IDN_OAUTH2_ACCESS_TOKEN(CONSUMER_KEY_ID, AUTHZ_USER, TOKEN_STATE, USER_TYPE)
/
CREATE INDEX IDX_TC ON IDN_OAUTH2_ACCESS_TOKEN(TIME_CREATED)
/
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ADD FOREIGN KEY (CONSUMER_KEY_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE
/

ALTER TABLE IDN_OAUTH2_RESOURCE_SCOPE ADD TENANT_ID INTEGER DEFAULT -1
/
ALTER TABLE IDN_OPENID_ASSOCIATIONS ADD TENANT_ID INTEGER DEFAULT -1
/
ALTER TABLE IDN_THRIFT_SESSION ADD TENANT_ID INTEGER DEFAULT -1
/

ALTER TABLE IDN_OAUTH2_AUTHORIZATION_CODE ADD CONSUMER_KEY_ID INTEGER
/
ALTER TABLE IDN_OAUTH2_AUTHORIZATION_CODE ADD TENANT_ID INTEGER
/
ALTER TABLE IDN_OAUTH2_AUTHORIZATION_CODE ADD USER_DOMAIN VARCHAR(50)
/
ALTER TABLE IDN_OAUTH2_AUTHORIZATION_CODE ADD STATE VARCHAR (25) DEFAULT 'ACTIVE'
/
ALTER TABLE IDN_OAUTH2_AUTHORIZATION_CODE ADD TOKEN_ID VARCHAR(255)
/
ALTER TABLE IDN_OAUTH2_AUTHORIZATION_CODE ADD CODE_ID VARCHAR (255)
/
ALTER TABLE IDN_OAUTH2_AUTHORIZATION_CODE ADD SUBJECT_IDENTIFIER VARCHAR(255)
/
UPDATE IDN_OAUTH2_AUTHORIZATION_CODE AUTHORIZATION_CODE set AUTHORIZATION_CODE.CONSUMER_KEY_ID = (select CONSUMER_APPS.ID from IDN_OAUTH_CONSUMER_APPS CONSUMER_APPS where CONSUMER_APPS.CONSUMER_KEY = AUTHORIZATION_CODE.CONSUMER_KEY)
/
ALTER TABLE IDN_OAUTH2_AUTHORIZATION_CODE DROP COLUMN CONSUMER_KEY
/
ALTER TABLE IDN_OAUTH2_AUTHORIZATION_CODE ADD FOREIGN KEY (CONSUMER_KEY_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE
/

CREATE TABLE IDN_OAUTH2_ACCESS_TOKEN_SCOPE (
  TOKEN_ID VARCHAR2 (255),
  TOKEN_SCOPE VARCHAR2 (60),
  TENANT_ID INTEGER DEFAULT -1,
  PRIMARY KEY (TOKEN_ID, TOKEN_SCOPE))
/

DROP TABLE IDN_SCIM_PROVIDER
/

ALTER TABLE IDN_IDENTITY_USER_DATA MODIFY (DATA_VALUE NULL)
/

UPDATE IDN_ASSOCIATED_ID set IDN_ASSOCIATED_ID.IDP_ID = (SELECT IDP.ID FROM IDP WHERE IDP.NAME = IDN_ASSOCIATED_ID.IDP_ID AND IDP.TENANT_ID = IDN_ASSOCIATED_ID.TENANT_ID )
/
ALTER TABLE IDN_ASSOCIATED_ID MODIFY (IDP_ID INTEGER)
/
ALTER TABLE IDN_ASSOCIATED_ID ADD DOMAIN_NAME VARCHAR2(255)
/
ALTER TABLE IDN_ASSOCIATED_ID ADD FOREIGN KEY (IDP_ID) REFERENCES IDP (ID) ON DELETE CASCADE
/

DELETE FROM IDN_AUTH_SESSION_STORE
/
ALTER TABLE IDN_AUTH_SESSION_STORE MODIFY (SESSION_ID NOT NULL)
/
ALTER TABLE IDN_AUTH_SESSION_STORE MODIFY (SESSION_TYPE NOT NULL)
/
ALTER TABLE IDN_AUTH_SESSION_STORE MODIFY (TIME_CREATED NUMBER(19) NOT NULL)
/
ALTER TABLE IDN_AUTH_SESSION_STORE ADD OPERATION VARCHAR(10) NOT NULL
/
ALTER TABLE IDN_AUTH_SESSION_STORE ADD TENANT_ID INTEGER DEFAULT -1
/
ALTER TABLE IDN_AUTH_SESSION_STORE ADD PRIMARY KEY (SESSION_ID, SESSION_TYPE, TIME_CREATED, OPERATION)
/

ALTER TABLE SP_APP ADD IS_USE_TENANT_DOMAIN_SUBJECT CHAR(1) DEFAULT '1' NOT NULL
/
ALTER TABLE SP_APP ADD IS_USE_USER_DOMAIN_SUBJECT CHAR(1) DEFAULT '1' NOT NULL
/
ALTER TABLE SP_APP ADD IS_DUMB_MODE CHAR(1) DEFAULT '0'
/
INSERT INTO IDP_AUTHENTICATOR (TENANT_ID, IDP_ID, NAME) SELECT -1234, ID, 'IDPProperties' FROM IDP WHERE TENANT_ID=-1234 AND NAME='LOCAL'
/
INSERT INTO IDP_AUTHENTICATOR (TENANT_ID, IDP_ID, NAME) SELECT -1234, ID, 'passivests' FROM IDP WHERE TENANT_ID=-1234 AND NAME='LOCAL'
/

INSERT INTO  IDP_AUTHENTICATOR_PROPERTY (TENANT_ID, AUTHENTICATOR_ID, PROPERTY_KEY,PROPERTY_VALUE, IS_SECRET ) SELECT -1234, IDP_AUTHENTICATOR.ID , 'IdPEntityId', 'localhost', '0' FROM IDP_AUTHENTICATOR,IDP WHERE IDP_AUTHENTICATOR.TENANT_ID = -1234 AND IDP_AUTHENTICATOR.NAME = 'passivests' AND IDP.NAME='LOCAL' AND IDP.ID = IDP_AUTHENTICATOR.IDP_ID
/

ALTER TABLE SP_INBOUND_AUTH MODIFY (INBOUND_AUTH_KEY NULL)
/

ALTER TABLE IDP_PROVISIONING_ENTITY ADD ENTITY_LOCAL_ID VARCHAR(255)
/

CREATE TABLE IDN_USER_ACCOUNT_ASSOCIATION (
  ASSOCIATION_KEY VARCHAR(255) NOT NULL,
  TENANT_ID INTEGER,
  DOMAIN_NAME VARCHAR(255) NOT NULL,
  USER_NAME VARCHAR(255) NOT NULL,
  PRIMARY KEY (TENANT_ID, DOMAIN_NAME, USER_NAME))
/
CREATE TABLE FIDO_DEVICE_STORE (
  TENANT_ID INTEGER,
  DOMAIN_NAME VARCHAR(255) NOT NULL,
  USER_NAME VARCHAR(45) NOT NULL,
  TIME_REGISTERED TIMESTAMP,
  KEY_HANDLE VARCHAR(200) NOT NULL,
  DEVICE_DATA VARCHAR(2048) NOT NULL,
  PRIMARY KEY (TENANT_ID, DOMAIN_NAME, USER_NAME, KEY_HANDLE))
/

CREATE TABLE WF_REQUEST (
  UUID VARCHAR2 (45),
  CREATED_BY VARCHAR2 (255),
  TENANT_ID INTEGER DEFAULT -1,
  OPERATION_TYPE VARCHAR2 (50),
  CREATED_AT TIMESTAMP,
  UPDATED_AT TIMESTAMP,
  STATUS VARCHAR2 (30),
  REQUEST BLOB,
  PRIMARY KEY (UUID))
/

CREATE TABLE WF_BPS_PROFILE (
  PROFILE_NAME VARCHAR2(45),
  HOST_URL_MANAGER VARCHAR2(45),
  HOST_URL_WORKER VARCHAR2(45),
  USERNAME VARCHAR2(45),
  PASSWORD VARCHAR2(1023),
  CALLBACK_HOST VARCHAR2 (45),
  TENANT_ID INTEGER DEFAULT -1,
  PRIMARY KEY (PROFILE_NAME, TENANT_ID))
/

CREATE TABLE WF_WORKFLOW(
  ID VARCHAR2 (45),
  WF_NAME VARCHAR2 (45),
  DESCRIPTION VARCHAR2 (255),
  TEMPLATE_ID VARCHAR2 (45),
  IMPL_ID VARCHAR2 (45),
  TENANT_ID INTEGER DEFAULT -1,
  PRIMARY KEY (ID))
/

CREATE TABLE WF_WORKFLOW_ASSOCIATION(
  ID INTEGER,
  ASSOC_NAME VARCHAR2 (45),
  EVENT_ID VARCHAR2(45),
  ASSOC_CONDITION VARCHAR2 (2000),
  WORKFLOW_ID VARCHAR2 (45),
  IS_ENABLED CHAR (1) DEFAULT '1',
  TENANT_ID INTEGER DEFAULT -1,
  PRIMARY KEY(ID),
  FOREIGN KEY (WORKFLOW_ID) REFERENCES WF_WORKFLOW(ID)ON DELETE CASCADE)
/

CREATE SEQUENCE WF_WORKFLOW_ASSOCIATION_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER WF_WORKFLOW_ASSOCIATION_TRIG
BEFORE INSERT
ON WF_WORKFLOW_ASSOCIATION
REFERENCING NEW AS NEW
FOR EACH ROW
  BEGIN
    SELECT WF_WORKFLOW_ASSOCIATION_SEQ.nextval
    INTO :NEW.ID
    FROM dual;
  END;
/

CREATE TABLE WF_WORKFLOW_CONFIG_PARAM(
  WORKFLOW_ID VARCHAR2 (45),
  PARAM_NAME VARCHAR2 (45),
  PARAM_VALUE VARCHAR2 (1000),
  PARAM_QNAME VARCHAR2 (45),
  PARAM_HOLDER VARCHAR2 (45),
  TENANT_ID INTEGER DEFAULT -1,
  PRIMARY KEY (WORKFLOW_ID, PARAM_NAME, PARAM_QNAME, PARAM_HOLDER),
  FOREIGN KEY (WORKFLOW_ID) REFERENCES WF_WORKFLOW(ID)ON DELETE CASCADE)
/

CREATE TABLE WF_REQUEST_ENTITY_RELATIONSHIP(
  REQUEST_ID VARCHAR2 (45),
  ENTITY_NAME VARCHAR2 (255),
  ENTITY_TYPE VARCHAR2 (50),
  TENANT_ID INTEGER DEFAULT -1,
  PRIMARY KEY(REQUEST_ID, ENTITY_NAME, ENTITY_TYPE, TENANT_ID),
  FOREIGN KEY (REQUEST_ID) REFERENCES WF_REQUEST(UUID)ON DELETE CASCADE)
/

CREATE TABLE WF_WORKFLOW_REQUEST_RELATION(
  RELATIONSHIP_ID VARCHAR2 (45),
  WORKFLOW_ID VARCHAR2 (45),
  REQUEST_ID VARCHAR2 (45),
  UPDATED_AT TIMESTAMP,
  STATUS VARCHAR (30),
  TENANT_ID INTEGER DEFAULT -1,
  PRIMARY KEY (RELATIONSHIP_ID),
  FOREIGN KEY (WORKFLOW_ID) REFERENCES WF_WORKFLOW(ID)ON DELETE CASCADE,
  FOREIGN KEY (REQUEST_ID) REFERENCES WF_REQUEST(UUID)ON DELETE CASCADE)
/
