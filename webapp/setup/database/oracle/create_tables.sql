CREATE TABLE CMS_USERS ( 
	USER_ID VARCHAR2(36) NOT NULL,
	USER_NAME VARCHAR2(128) NOT NULL,
	USER_PASSWORD VARCHAR2(64) NOT NULL,
	USER_FIRSTNAME VARCHAR2(128) NOT NULL,
	USER_LASTNAME VARCHAR2(128) NOT NULL,
	USER_EMAIL VARCHAR2(128) NOT NULL,
	USER_LASTLOGIN NUMBER NOT NULL,
	USER_FLAGS INT NOT NULL,
	USER_OU VARCHAR2(128) NOT NULL,
	USER_DATECREATED NUMBER NOT NULL,
	CONSTRAINT PK_USERS PRIMARY KEY(USER_ID) USING INDEX TABLESPACE ${indexTablespace},
	CONSTRAINT UK_USERS UNIQUE(USER_NAME, USER_OU) USING INDEX TABLESPACE ${indexTablespace}
);

CREATE INDEX CMS_USERS_01_IDX
	ON CMS_USERS (USER_NAME)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_USERS_02_IDX
	ON CMS_USERS (USER_OU)
	TABLESPACE ${indexTablespace};
	
CREATE TABLE CMS_USERDATA (
    USER_ID VARCHAR2(36) NOT NULL,
    DATA_KEY VARCHAR2(255) NOT NULL,
    DATA_VALUE BLOB,
    DATA_TYPE VARCHAR2(128) NOT NULL,
    CONSTRAINT PK_USERDATA PRIMARY KEY(USER_ID, DATA_KEY) USING INDEX TABLESPACE ${indexTablespace}
);

CREATE INDEX CMS_USERDATA_01_IDX
	ON CMS_USERDATA (USER_ID)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_USERDATA_02_IDX
	ON CMS_USERDATA (DATA_KEY)
	TABLESPACE ${indexTablespace};
	
CREATE TABLE CMS_GROUPS (
	GROUP_ID VARCHAR2(36) NOT NULL,
	PARENT_GROUP_ID VARCHAR2(36) NOT NULL,
	GROUP_NAME VARCHAR2(128) NOT NULL,
	GROUP_DESCRIPTION VARCHAR2(255) NOT NULL,
	GROUP_FLAGS INT NOT NULL,
	GROUP_OU VARCHAR2(128) NOT NULL,
	CONSTRAINT PK_GROUPS PRIMARY KEY(GROUP_ID) USING INDEX TABLESPACE ${indexTablespace},
	CONSTRAINT UK_GROUPS UNIQUE(GROUP_NAME, GROUP_OU) USING INDEX TABLESPACE ${indexTablespace}
);

CREATE INDEX CMS_GROUPS_01_IDX 
	ON CMS_GROUPS (PARENT_GROUP_ID)
	TABLESPACE ${indexTablespace};

CREATE INDEX CMS_GROUPS_02_IDX
	ON CMS_GROUPS (GROUP_NAME)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_GROUPS_03_IDX
	ON CMS_GROUPS (GROUP_OU)
	TABLESPACE ${indexTablespace};
	
CREATE TABLE CMS_GROUPUSERS (
	GROUP_ID VARCHAR2(36) NOT NULL,
	USER_ID VARCHAR2(36) NOT NULL,
	GROUPUSER_FLAGS INT NOT NULL,
	CONSTRAINT PK_GROUPUSERS PRIMARY KEY(GROUP_ID, USER_ID) USING INDEX TABLESPACE ${indexTablespace}
);

CREATE INDEX CMS_GROUPUSERS_01_IDX 
	ON CMS_GROUPUSERS (GROUP_ID)
	TABLESPACE ${indexTablespace};

CREATE INDEX CMS_GROUPUSERS_02_IDX 
	ON CMS_GROUPUSERS (USER_ID)
	TABLESPACE ${indexTablespace};

CREATE TABLE CMS_PROJECTS ( 
	PROJECT_ID VARCHAR2(36) NOT NULL,
	PROJECT_NAME VARCHAR2(200) NOT NULL,
	PROJECT_DESCRIPTION VARCHAR2(255) NOT NULL,
	PROJECT_FLAGS INT NOT NULL,
	PROJECT_TYPE INT NOT NULL,
	USER_ID VARCHAR2(36) NOT NULL,
	GROUP_ID VARCHAR2(36) NOT NULL,
	MANAGERGROUP_ID VARCHAR2(36) NOT NULL,
	DATE_CREATED NUMBER NOT NULL,
	PROJECT_OU VARCHAR2(128) NOT NULL,
	CONSTRAINT PK_PROJECTS PRIMARY KEY(PROJECT_ID) USING INDEX TABLESPACE ${indexTablespace},
	CONSTRAINT UK_PROJECTS UNIQUE(PROJECT_OU,PROJECT_NAME,DATE_CREATED) USING INDEX TABLESPACE ${indexTablespace}
);

CREATE INDEX CMS_PROJECTS_01_IDX
	ON CMS_PROJECTS (PROJECT_FLAGS)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_PROJECTS_02_IDX
	ON CMS_PROJECTS (GROUP_ID)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_PROJECTS_03_IDX
	ON CMS_PROJECTS (MANAGERGROUP_ID)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_PROJECTS_04_IDX
	ON CMS_PROJECTS (USER_ID)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_PROJECTS_05_IDX
	ON CMS_PROJECTS (PROJECT_NAME)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_PROJECTS_06_IDX
	ON CMS_PROJECTS (PROJECT_OU)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_PROJECTS_07_IDX
	ON CMS_PROJECTS (PROJECT_OU,PROJECT_NAME)
	TABLESPACE ${indexTablespace};
	
CREATE TABLE CMS_BACKUP_PROJECTS (
	PROJECT_ID VARCHAR2(36) NOT NULL,
	PROJECT_NAME VARCHAR2(255) NOT NULL,
	PROJECT_DESCRIPTION VARCHAR2(255) NOT NULL,
	PROJECT_TYPE INT NOT NULL,
	USER_ID VARCHAR2(36) NOT NULL,
	GROUP_ID VARCHAR2(36) NOT NULL,
	MANAGERGROUP_ID VARCHAR2(36) NOT NULL,
	DATE_CREATED NUMBER NOT NULL,
	PUBLISH_TAG INT NOT NULL,
	PROJECT_PUBLISHDATE NUMBER NOT NULL,
	PROJECT_PUBLISHED_BY VARCHAR2(36) NOT NULL,
	PROJECT_PUBLISHED_BY_NAME VARCHAR2(255),
	USER_NAME VARCHAR2(128),
	GROUP_NAME VARCHAR2(128),
	MANAGERGROUP_NAME VARCHAR2(128),			
	PROJECT_OU VARCHAR2(128) NOT NULL,
	CONSTRAINT PK_BACKUP_PROJECTS PRIMARY KEY(PUBLISH_TAG) USING INDEX TABLESPACE ${indexTablespace}
);
 
CREATE TABLE CMS_PROJECTRESOURCES (
	PROJECT_ID VARCHAR2(36) NOT NULL,
	RESOURCE_PATH VARCHAR2(1024),
	CONSTRAINT PK_PROJECTRESOURCES PRIMARY KEY(PROJECT_ID, RESOURCE_PATH) USING INDEX TABLESPACE ${indexTablespace}
);

CREATE INDEX CMS_PROJECTRESOURCES_01_IDX
	ON CMS_PROJECTRESOURCES (RESOURCE_PATH)
	TABLESPACE ${indexTablespace};

CREATE TABLE CMS_BACKUP_PROJECTRESOURCES (
	PUBLISH_TAG INT NOT NULL,
	PROJECT_ID VARCHAR2(36) NOT NULL,
	RESOURCE_PATH VARCHAR2(1024),
	CONSTRAINT PK_BACKUP_PROJECTRESOURCES PRIMARY KEY(PUBLISH_TAG, PROJECT_ID, RESOURCE_PATH) USING INDEX TABLESPACE ${indexTablespace}
);

CREATE TABLE CMS_OFFLINE_PROPERTYDEF ( 
	PROPERTYDEF_ID VARCHAR2(36) NOT NULL,
	PROPERTYDEF_NAME VARCHAR2(128) NOT NULL,
	CONSTRAINT PK_OFFLINE_PROPERTYDEF PRIMARY KEY(PROPERTYDEF_ID) USING INDEX TABLESPACE ${indexTablespace},
	CONSTRAINT UK_OFFLINE_PROPERTYDEF UNIQUE(PROPERTYDEF_NAME) USING INDEX TABLESPACE ${indexTablespace}
);

CREATE TABLE CMS_ONLINE_PROPERTYDEF ( 
	PROPERTYDEF_ID VARCHAR2(36) NOT NULL,
	PROPERTYDEF_NAME VARCHAR2(128) NOT NULL,
	CONSTRAINT PK_ONLINE_PROPERTYDEF PRIMARY KEY(PROPERTYDEF_ID) USING INDEX TABLESPACE ${indexTablespace},
	CONSTRAINT UK_ONLINE_PROPERTYDEF UNIQUE(PROPERTYDEF_NAME) USING INDEX TABLESPACE ${indexTablespace} 
);

CREATE TABLE CMS_BACKUP_PROPERTYDEF ( 
	PROPERTYDEF_ID VARCHAR2(36) NOT NULL,
	PROPERTYDEF_NAME VARCHAR2(128) NOT NULL,
	CONSTRAINT PK_BACKUP_PROPERTYDEF PRIMARY KEY(PROPERTYDEF_ID) USING INDEX TABLESPACE ${indexTablespace}
);

CREATE TABLE CMS_OFFLINE_PROPERTIES (
	PROPERTY_ID VARCHAR2(36) NOT NULL,
	PROPERTYDEF_ID VARCHAR2(36) NOT NULL,
	PROPERTY_MAPPING_ID VARCHAR2(36) NOT NULL,
	PROPERTY_MAPPING_TYPE INT NOT NULL,	
	PROPERTY_VALUE VARCHAR2(2048) NOT NULL,
	CONSTRAINT PK_OFFLINE_PROPERTIES PRIMARY KEY(PROPERTY_ID) USING INDEX TABLESPACE ${indexTablespace},
	CONSTRAINT UK_OFFLINE_PROPERTIES UNIQUE(PROPERTYDEF_ID, PROPERTY_MAPPING_ID) USING INDEX TABLESPACE ${indexTablespace}
	STORAGE (FREELISTS 10)
);

CREATE INDEX CMS_OFFLINE_PROPERTIES_01_IDX
	ON CMS_OFFLINE_PROPERTIES (PROPERTYDEF_ID)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_OFFLINE_PROPERTIES_02_IDX
	ON CMS_OFFLINE_PROPERTIES (PROPERTY_MAPPING_ID)
	TABLESPACE ${indexTablespace};

CREATE TABLE CMS_ONLINE_PROPERTIES (
	PROPERTY_ID VARCHAR2(36) NOT NULL,
	PROPERTYDEF_ID VARCHAR2(36) NOT NULL,
	PROPERTY_MAPPING_ID VARCHAR2(36) NOT NULL,
	PROPERTY_MAPPING_TYPE INT NOT NULL,	
	PROPERTY_VALUE VARCHAR2(2048) NOT NULL,
	CONSTRAINT PK_ONLINE_PROPERTIES PRIMARY KEY(PROPERTY_ID) USING INDEX TABLESPACE ${indexTablespace},
	CONSTRAINT UK_ONLINE_PROPERTIES UNIQUE(PROPERTYDEF_ID, PROPERTY_MAPPING_ID) USING INDEX TABLESPACE ${indexTablespace}
	STORAGE (FREELISTS 10)
);

CREATE INDEX CMS_ONLINE_PROPERTIES_01_IDX
	ON CMS_ONLINE_PROPERTIES (PROPERTYDEF_ID)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_ONLINE_PROPERTIES_02_IDX
	ON CMS_ONLINE_PROPERTIES (PROPERTY_MAPPING_ID)
	TABLESPACE ${indexTablespace};
	
CREATE TABLE CMS_BACKUP_PROPERTIES (
    BACKUP_ID VARCHAR2(36) NOT NULL,
	PROPERTY_ID VARCHAR2(36) NOT NULL,
	PROPERTYDEF_ID VARCHAR2(36) NOT NULL,
	PROPERTY_MAPPING_ID VARCHAR2(36) NOT NULL,
	PROPERTY_MAPPING_TYPE INT NOT NULL,	
	PROPERTY_VALUE VARCHAR2(2048) NOT NULL,
	PUBLISH_TAG INT,
	VERSION_ID INT NOT NULL,
	CONSTRAINT PK_BACKUP_PROPERTIES PRIMARY KEY(PROPERTY_ID) USING INDEX TABLESPACE ${indexTablespace}
);

CREATE INDEX CMS_BACKUP_PROPERTIES_01_IDX
	ON CMS_BACKUP_PROPERTIES (PROPERTYDEF_ID)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_BACKUP_PROPERTIES_02_IDX
	ON CMS_BACKUP_PROPERTIES (PROPERTY_MAPPING_ID)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_BACKUP_PROPERTIES_03_IDX
	ON CMS_BACKUP_PROPERTIES (PUBLISH_TAG)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_BACKUP_PROPERTIES_04_IDX
	ON CMS_BACKUP_PROPERTIES (PROPERTYDEF_ID, PROPERTY_MAPPING_ID)
	TABLESPACE ${indexTablespace};
	
CREATE TABLE CMS_ONLINE_ACCESSCONTROL (
	RESOURCE_ID VARCHAR2(36) NOT NULL,
	PRINCIPAL_ID VARCHAR2(36) NOT NULL,
	ACCESS_ALLOWED INT,
	ACCESS_DENIED INT,
	ACCESS_FLAGS INT,
	CONSTRAINT PK_ONLINE_ACCESSCONTROL PRIMARY KEY(RESOURCE_ID, PRINCIPAL_ID) USING INDEX TABLESPACE ${indexTablespace}
);
   
CREATE INDEX ONLINE_ACCESSCONTROL_01_IDX
	ON CMS_ONLINE_ACCESSCONTROL (PRINCIPAL_ID)
	TABLESPACE ${indexTablespace};
	
CREATE TABLE CMS_OFFLINE_ACCESSCONTROL (
	RESOURCE_ID VARCHAR2(36) NOT NULL,
	PRINCIPAL_ID VARCHAR2(36) NOT NULL,
	ACCESS_ALLOWED INT,
	ACCESS_DENIED INT,
	ACCESS_FLAGS INT,
	CONSTRAINT PK_OFFLINE_ACCESSCONTROL PRIMARY KEY(RESOURCE_ID, PRINCIPAL_ID) USING INDEX TABLESPACE ${indexTablespace}
);

CREATE INDEX OFFLINE_ACCESSCONTROL_01_IDX
	ON CMS_OFFLINE_ACCESSCONTROL (PRINCIPAL_ID)
	TABLESPACE ${indexTablespace};
	
CREATE TABLE CMS_PUBLISH_HISTORY (
	HISTORY_ID VARCHAR(36) NOT NULL,
	PUBLISH_TAG INT NOT NULL,
	STRUCTURE_ID VARCHAR2(36) NOT NULL,
	RESOURCE_ID VARCHAR2(36) NOT NULL,
	RESOURCE_PATH VARCHAR2(1024),
	RESOURCE_STATE INT NOT NULL,
	RESOURCE_TYPE INT NOT NULL,
	SIBLING_COUNT INT NOT NULL,	
	CONSTRAINT PK_PUBLISH_HISTORY PRIMARY KEY (HISTORY_ID, PUBLISH_TAG, STRUCTURE_ID, RESOURCE_PATH) USING INDEX TABLESPACE ${indexTablespace}
);

CREATE INDEX CMS_PUBLISH_HISTORY_01_IDX
	ON CMS_PUBLISH_HISTORY (PUBLISH_TAG)
	TABLESPACE ${indexTablespace};
	
CREATE TABLE CMS_RESOURCE_LOCKS (
  RESOURCE_PATH VARCHAR2(1024),
  USER_ID VARCHAR2(36) NOT NULL,
  PROJECT_ID VARCHAR2(36) NOT NULL,
  LOCK_TYPE INT NOT NULL
);

CREATE TABLE CMS_STATICEXPORT_LINKS (
	LINK_ID VARCHAR(36) NOT NULL,
	LINK_RFS_PATH VARCHAR2(1024),
	LINK_TYPE INT NOT NULL,
	LINK_PARAMETER VARCHAR2(1024),
	LINK_TIMESTAMP NUMBER NOT NULL,
	CONSTRAINT CMS_STATICEXPORT_LINKS PRIMARY KEY (LINK_ID) USING INDEX TABLESPACE ${indexTablespace}
);

CREATE INDEX CMS_STATICEXPORT_LINKS_01_IDX
	ON CMS_STATICEXPORT_LINKS (LINK_RFS_PATH)
	TABLESPACE ${indexTablespace};

CREATE TABLE CMS_OFFLINE_STRUCTURE (
	STRUCTURE_ID VARCHAR2(36) NOT NULL,
	RESOURCE_ID VARCHAR(36) NOT NULL,
	PARENT_ID VARCHAR2(36) NOT NULL,
	RESOURCE_PATH VARCHAR2(1024),
	STRUCTURE_STATE INT NOT NULL,	
	DATE_RELEASED NUMBER NOT NULL,
	DATE_EXPIRED NUMBER NOT NULL,	
	CONSTRAINT PK_OFFLINE_STRUCTURE PRIMARY KEY (STRUCTURE_ID) USING INDEX TABLESPACE ${indexTablespace}
	STORAGE (FREELISTS 10)
);

CREATE INDEX CMS_OFFLINE_STRUCTURE_01_IDX
	ON CMS_OFFLINE_STRUCTURE (STRUCTURE_ID, RESOURCE_PATH)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_OFFLINE_STRUCTURE_02_IDX
	ON CMS_OFFLINE_STRUCTURE (RESOURCE_PATH, RESOURCE_ID)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_OFFLINE_STRUCTURE_03_IDX
	ON CMS_OFFLINE_STRUCTURE (STRUCTURE_ID, RESOURCE_ID)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_OFFLINE_STRUCTURE_04_IDX
	ON CMS_OFFLINE_STRUCTURE (STRUCTURE_STATE)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_OFFLINE_STRUCTURE_05_IDX
	ON CMS_OFFLINE_STRUCTURE (PARENT_ID)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_OFFLINE_STRUCTURE_06_IDX
	ON CMS_OFFLINE_STRUCTURE (RESOURCE_ID)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_OFFLINE_STRUCTURE_07_IDX
	ON CMS_OFFLINE_STRUCTURE (RESOURCE_PATH)
	TABLESPACE ${indexTablespace};

CREATE TABLE CMS_ONLINE_STRUCTURE (
	STRUCTURE_ID VARCHAR2(36) NOT NULL,
	RESOURCE_ID VARCHAR(36) NOT NULL,
	PARENT_ID VARCHAR2(36) NOT NULL,
	RESOURCE_PATH VARCHAR2(1024),
	STRUCTURE_STATE INT NOT NULL,	
	DATE_RELEASED NUMBER NOT NULL,
	DATE_EXPIRED NUMBER NOT NULL,		
	CONSTRAINT PK_ONLINE_STRUCTURE PRIMARY KEY (STRUCTURE_ID) USING INDEX TABLESPACE ${indexTablespace}
	STORAGE (FREELISTS 10)
);

CREATE INDEX CMS_ONLINE_STRUCTURE_01_IDX
	ON CMS_ONLINE_STRUCTURE (STRUCTURE_ID, RESOURCE_PATH)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_ONLINE_STRUCTURE_02_IDX
	ON CMS_ONLINE_STRUCTURE (RESOURCE_PATH, RESOURCE_ID)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_ONLINE_STRUCTURE_03_IDX
	ON CMS_ONLINE_STRUCTURE (STRUCTURE_ID, RESOURCE_ID)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_ONLINE_STRUCTURE_04_IDX
	ON CMS_ONLINE_STRUCTURE (STRUCTURE_STATE)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_ONLINE_STRUCTURE_05_IDX
	ON CMS_ONLINE_STRUCTURE (PARENT_ID)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_ONLINE_STRUCTURE_06_IDX
	ON CMS_ONLINE_STRUCTURE (RESOURCE_ID)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_ONLINE_STRUCTURE_07_IDX
	ON CMS_ONLINE_STRUCTURE (RESOURCE_PATH)
	TABLESPACE ${indexTablespace};

CREATE TABLE CMS_BACKUP_STRUCTURE (
	BACKUP_ID VARCHAR2(36) NOT NULL,
    PUBLISH_TAG INT NOT NULL,
    VERSION_ID INT NOT NULL,
	STRUCTURE_ID VARCHAR2(36) NOT NULL,
	RESOURCE_ID VARCHAR2(36) NOT NULL,
	RESOURCE_PATH VARCHAR2(1024),
	STRUCTURE_STATE INT NOT NULL,
	DATE_RELEASED NUMBER NOT NULL,
	DATE_EXPIRED NUMBER NOT NULL,		
	CONSTRAINT PK_BACKUP_STRUCTURE PRIMARY KEY (BACKUP_ID) USING INDEX TABLESPACE ${indexTablespace}
);     

CREATE INDEX CMS_BACKUP_STRUCTURE_01_IDX
	ON CMS_BACKUP_STRUCTURE (STRUCTURE_ID, RESOURCE_PATH)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_BACKUP_STRUCTURE_02_IDX
	ON CMS_BACKUP_STRUCTURE (RESOURCE_PATH, RESOURCE_ID)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_BACKUP_STRUCTURE_03_IDX
	ON CMS_BACKUP_STRUCTURE (STRUCTURE_ID, RESOURCE_ID)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_BACKUP_STRUCTURE_04_IDX
	ON CMS_BACKUP_STRUCTURE (STRUCTURE_STATE)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_BACKUP_STRUCTURE_05_IDX
	ON CMS_BACKUP_STRUCTURE (RESOURCE_ID)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_BACKUP_STRUCTURE_06_IDX
	ON CMS_BACKUP_STRUCTURE (RESOURCE_PATH)
	TABLESPACE ${indexTablespace};

CREATE INDEX CMS_BACKUP_STRUCTURE_07_IDX
	ON CMS_BACKUP_STRUCTURE (PUBLISH_TAG)
	TABLESPACE ${indexTablespace};

CREATE INDEX CMS_BACKUP_STRUCTURE_08_IDX
	ON CMS_BACKUP_STRUCTURE (VERSION_ID)
	TABLESPACE ${indexTablespace};

CREATE TABLE CMS_OFFLINE_RESOURCES (
	RESOURCE_ID VARCHAR2(36) NOT NULL,
	RESOURCE_TYPE INT NOT NULL,
	RESOURCE_FLAGS INT NOT NULL,
	RESOURCE_STATE INT NOT NULL,
	RESOURCE_SIZE INT NOT NULL,
	SIBLING_COUNT INT NOT NULL,
	DATE_CREATED NUMBER NOT NULL,
	DATE_LASTMODIFIED NUMBER NOT NULL,
	USER_CREATED VARCHAR2(36) NOT NULL,
	USER_LASTMODIFIED VARCHAR2(36) NOT NULL,
	PROJECT_LASTMODIFIED VARCHAR2(36) NOT NULL,
	CONSTRAINT PK_OFFLINE_RESOURCES PRIMARY KEY(RESOURCE_ID) USING INDEX TABLESPACE ${indexTablespace}
	STORAGE (FREELISTS 10)
);

CREATE INDEX CMS_OFFLINE_RESOURCES_01_IDX
	ON CMS_OFFLINE_RESOURCES (PROJECT_LASTMODIFIED)
	TABLESPACE ${indexTablespace};

CREATE INDEX CMS_OFFLINE_RESOURCES_02_IDX
	ON CMS_OFFLINE_RESOURCES (PROJECT_LASTMODIFIED, RESOURCE_SIZE)
	TABLESPACE ${indexTablespace};

CREATE INDEX CMS_OFFLINE_RESOURCES_03_IDX
	ON CMS_OFFLINE_RESOURCES (RESOURCE_SIZE)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_OFFLINE_RESOURCES_04_IDX
	ON CMS_OFFLINE_RESOURCES (DATE_LASTMODIFIED)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_OFFLINE_RESOURCES_05_IDX
	ON CMS_OFFLINE_RESOURCES (RESOURCE_TYPE)
	TABLESPACE ${indexTablespace};

CREATE TABLE CMS_ONLINE_RESOURCES (
	RESOURCE_ID VARCHAR2(36) NOT NULL,
	RESOURCE_TYPE INT NOT NULL,
	RESOURCE_FLAGS INT NOT NULL,
	RESOURCE_STATE INT NOT NULL,
	RESOURCE_SIZE INT NOT NULL,
	SIBLING_COUNT INT NOT NULL,	
	DATE_CREATED NUMBER NOT NULL,
	DATE_LASTMODIFIED NUMBER NOT NULL,
	USER_CREATED VARCHAR2(36) NOT NULL,
	USER_LASTMODIFIED VARCHAR2(36) NOT NULL,
	PROJECT_LASTMODIFIED VARCHAR2(36) NOT NULL,
	CONSTRAINT PK_ONLINE_RESOURCES PRIMARY KEY(RESOURCE_ID) USING INDEX TABLESPACE ${indexTablespace}
	STORAGE (FREELISTS 10)
);

CREATE INDEX CMS_ONLINE_RESOURCES_01_IDX
	ON CMS_ONLINE_RESOURCES (PROJECT_LASTMODIFIED)
	TABLESPACE ${indexTablespace};

CREATE INDEX CMS_ONLINE_RESOURCES_02_IDX
	ON CMS_ONLINE_RESOURCES (PROJECT_LASTMODIFIED, RESOURCE_SIZE)
	TABLESPACE ${indexTablespace};

CREATE INDEX CMS_ONLINE_RESOURCES_03_IDX
	ON CMS_ONLINE_RESOURCES (RESOURCE_SIZE)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_ONLINE_RESOURCES_04_IDX
	ON CMS_ONLINE_RESOURCES (DATE_LASTMODIFIED)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_ONLINE_RESOURCES_05_IDX
	ON CMS_ONLINE_RESOURCES (RESOURCE_TYPE)
	TABLESPACE ${indexTablespace};

CREATE TABLE CMS_BACKUP_RESOURCES (
	BACKUP_ID VARCHAR2(36) NOT NULL,
	RESOURCE_ID VARCHAR2(36) NOT NULL,
	RESOURCE_TYPE INT NOT NULL,
	RESOURCE_FLAGS INT NOT NULL,
	RESOURCE_STATE INT NOT NULL,
	RESOURCE_SIZE INT NOT NULL,
	SIBLING_COUNT INT NOT NULL,	
	DATE_CREATED NUMBER NOT NULL,
	DATE_LASTMODIFIED NUMBER NOT NULL,
	USER_CREATED VARCHAR2(36) NOT NULL,
	USER_LASTMODIFIED VARCHAR2(36) NOT NULL,
	PROJECT_LASTMODIFIED VARCHAR2(36) NOT NULL,
	PUBLISH_TAG INT NOT NULL,
	VERSION_ID INT NOT NULL,
    USER_CREATED_NAME VARCHAR2(128) NOT NULL,
    USER_LASTMODIFIED_NAME VARCHAR2(128) NOT NULL,
	CONSTRAINT PK_BACKUP_RESOURCES PRIMARY KEY(BACKUP_ID) USING INDEX TABLESPACE ${indexTablespace},
	CONSTRAINT UK_BACKUP_RESOURCES UNIQUE(PUBLISH_TAG, RESOURCE_ID) USING INDEX TABLESPACE ${indexTablespace}
);

CREATE INDEX CMS_BACKUP_RESOURCES_01_IDX
	ON CMS_BACKUP_RESOURCES (PROJECT_LASTMODIFIED)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_BACKUP_RESOURCES_02_IDX
	ON CMS_BACKUP_RESOURCES (PROJECT_LASTMODIFIED, RESOURCE_SIZE)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_BACKUP_RESOURCES_03_IDX
	ON CMS_BACKUP_RESOURCES (RESOURCE_SIZE)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_BACKUP_RESOURCES_04_IDX
	ON CMS_BACKUP_RESOURCES (DATE_LASTMODIFIED)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_BACKUP_RESOURCES_05_IDX
	ON CMS_BACKUP_RESOURCES (RESOURCE_TYPE)
	TABLESPACE ${indexTablespace};

CREATE INDEX CMS_BACKUP_RESOURCES_06_IDX
	ON CMS_BACKUP_RESOURCES (RESOURCE_ID)
	TABLESPACE ${indexTablespace};

CREATE INDEX CMS_BACKUP_RESOURCES_07_IDX
	ON CMS_BACKUP_RESOURCES (PUBLISH_TAG)
	TABLESPACE ${indexTablespace};

CREATE TABLE CMS_OFFLINE_CONTENTS (
	CONTENT_ID VARCHAR2(36) NOT NULL,
	RESOURCE_ID VARCHAR2(36) NOT NULL,
	FILE_CONTENT BLOB NOT NULL,
	CONSTRAINT PK_OFFLINE_CONTENTS PRIMARY KEY(CONTENT_ID) USING INDEX TABLESPACE ${indexTablespace},
	CONSTRAINT UK_OFFLINE_CONTENTS UNIQUE(RESOURCE_ID) USING INDEX TABLESPACE ${indexTablespace}
)
STORAGE (INITIAL 256K NEXT 1M PCTINCREASE 0)
	LOB(FILE_CONTENT) STORE AS (
		CHUNK 32K PCTVERSION 20  
	    CACHE
);

CREATE TABLE CMS_ONLINE_CONTENTS (
	CONTENT_ID VARCHAR2(36) NOT NULL,
	RESOURCE_ID VARCHAR2(36) NOT NULL,
	FILE_CONTENT BLOB NOT NULL,
	CONSTRAINT PK_ONLINE_CONTENTS PRIMARY KEY(CONTENT_ID) USING INDEX TABLESPACE ${indexTablespace},
	CONSTRAINT UK_ONLINE_CONTENTS UNIQUE(RESOURCE_ID) USING INDEX TABLESPACE ${indexTablespace}
)
STORAGE (INITIAL 256K NEXT 1M PCTINCREASE 0)
	LOB(FILE_CONTENT) STORE AS (
        CHUNK 32K PCTVERSION 20  
        CACHE
);

CREATE TABLE CMS_BACKUP_CONTENTS (
	BACKUP_ID VARCHAR2(36) NOT NULL,
	CONTENT_ID VARCHAR2(36) NOT NULL,
	RESOURCE_ID VARCHAR2(36) NOT NULL,
	FILE_CONTENT BLOB NOT NULL,
	PUBLISH_TAG INT,
	VERSION_ID INT NOT NULL,
	CONSTRAINT PK_BACKUP_CONTENTS PRIMARY KEY(BACKUP_ID) USING INDEX TABLESPACE ${indexTablespace}
)	
STORAGE (INITIAL 256K NEXT 1M PCTINCREASE 0)
	LOB(FILE_CONTENT) STORE AS (
        CHUNK 32K PCTVERSION 20  
        CACHE
);

CREATE INDEX CMS_BACKUP_CONTENTS_01_IDX
	ON CMS_BACKUP_CONTENTS (PUBLISH_TAG)
	TABLESPACE ${indexTablespace};

CREATE INDEX CMS_BACKUP_CONTENTS_02_IDX
	ON CMS_BACKUP_CONTENTS (RESOURCE_ID)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_BACKUP_CONTENTS_03_IDX
	ON CMS_BACKUP_CONTENTS (CONTENT_ID)
	TABLESPACE ${indexTablespace};
	
CREATE TABLE CMS_ONLINE_RESOURCE_RELATIONS (
	RELATION_SOURCE_ID VARCHAR(36) NOT NULL,
	RELATION_SOURCE_PATH VARCHAR2(1024) NOT NULL,
	RELATION_TARGET_ID VARCHAR(36) NOT NULL,
	RELATION_TARGET_PATH VARCHAR2(1024) NOT NULL,
	RELATION_DATE_BEGIN NUMBER NOT NULL,
	RELATION_DATE_END NUMBER NOT NULL,
	RELATION_TYPE INT NOT NULL
);

CREATE INDEX CMS_ONLINE_RELATIONS_01_IDX
	ON CMS_ONLINE_RESOURCE_RELATIONS (RELATION_SOURCE_ID)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_ONLINE_RELATIONS_02_IDX
	ON CMS_ONLINE_RESOURCE_RELATIONS (RELATION_TARGET_ID)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_ONLINE_RELATIONS_03_IDX
	ON CMS_ONLINE_RESOURCE_RELATIONS (RELATION_SOURCE_PATH)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_ONLINE_RELATIONS_04_IDX
	ON CMS_ONLINE_RESOURCE_RELATIONS (RELATION_TARGET_PATH)
	TABLESPACE ${indexTablespace};

CREATE TABLE CMS_OFFLINE_RESOURCE_RELATIONS (
	RELATION_SOURCE_ID VARCHAR(36) NOT NULL,
	RELATION_SOURCE_PATH VARCHAR2(1024) NOT NULL,
	RELATION_TARGET_ID VARCHAR(36) NOT NULL,
	RELATION_TARGET_PATH VARCHAR2(1024) NOT NULL,
	RELATION_DATE_BEGIN NUMBER NOT NULL,
	RELATION_DATE_END NUMBER NOT NULL,
	RELATION_TYPE INT NOT NULL
);

CREATE INDEX CMS_OFFLINE_RELATIONS_01_IDX
	ON CMS_OFFLINE_RESOURCE_RELATIONS (RELATION_SOURCE_ID)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_OFFLINE_RELATIONS_02_IDX
	ON CMS_OFFLINE_RESOURCE_RELATIONS (RELATION_TARGET_ID)
	TABLESPACE ${indexTablespace};
	
CREATE INDEX CMS_OFFLINE_RELATIONS_03_IDX
	ON CMS_OFFLINE_RESOURCE_RELATIONS (RELATION_SOURCE_PATH)
	TABLESPACE ${indexTablespace};

CREATE INDEX CMS_OFFLINE_RELATIONS_04_IDX
	ON CMS_OFFLINE_RESOURCE_RELATIONS (RELATION_TARGET_PATH)
	TABLESPACE ${indexTablespace};