  /*==============================================================*/
  /* DBMS name:      PostgreSQL 8                                 */
  /* Created on:     18/03/2008 15:29:41                          */
  /*==============================================================*/
  
  /*
  drop table ANSWER;
  
  drop table ANSWERTYPE;
  
  drop table ANSWER_ITEM;
  
  drop table ENUMITEM;
  
  drop table ENUMTYPE;
  
  drop table ITEM;
  
  drop table QUESTION;
  
  drop table SECTION;
  
  drop table TEXT;
  */
 
  /*==============================================================*/
  /* Table: HOSPITAL                                              */
  /* This table keeps the hospitals as said in the specification  */
  /* document. This is gonna be useful to create artifical groups */
  /* of users...                                                  */
  /*==============================================================*/
  create table HOSPITAL (
    IDHOSP               SERIAL               not null,
    NAME                 VARCHAR(128)         NOT null,
    HOSPCOD              INT4                 NOT NULL,
    C_DATE               TIMESTAMP            default now(),
    U_DATE               TIMESTAMP,
    
    constraint PK_HOSPITAL primary key (IDHOSP)
  );
  
  
  /*==============================================================*/
  /* Table: ROLE                                                  */
  /*==============================================================*/
  create table ROLE (
    IDROLE               SERIAL               not null,
    NAME                 VARCHAR(128)         null,
    DESCRIPTION          VARCHAR(128)         null,
    C_DATE               TIMESTAMP            default now(),
    U_DATE               TIMESTAMP,
    
    constraint PK_ROLE primary key (IDROLE)
  );
  
  
  /*==============================================================*/
  /* Table: APPUSER                                               */
  /* We use the hospital FK because the users belong to a group   */
  /* The constraint is restrict because if a user is deleted, the */
  /* hospital doesent have to be removed                          */
  /*==============================================================*/
  create table APPUSER (
    IDUSER               SERIAL               not null,
    USERNAME             VARCHAR(128)         NOT null,
    PASSWD               VARCHAR(128)         NOT NULL,
    C_DATE               TIMESTAMP            default now(),
    U_DATE               TIMESTAMP,
    CODHOSP              INT4,
    COUNTRY              VARCHAR(16),
    
    constraint PK_APPUSER primary key (IDUSER),
    constraint FK_HOSPITAL_USER foreign key (CODHOSP)
      references HOSPITAL (idhosp)
      on delete restrict on update restrict
  );
  
 
  /*==============================================================*/
  /* Table: APPGROUP                                              */
  /* [06.08]Added:                                                */
  /*                                                              */
  /* tmpl_holder, boolean (actually int4). it will be true if the */
  /* group is able/allowed to support template assignment         */
  /* parent, int4. it is the field to support group hierarchy (for*/
  /* future developments)                                         */
  /* The foreign key actions mean that if the referencing group   */
  /* is deleted, the foreign key goes to null, and if the         */
  /* referencing group is updated, just cascade the update        */
  /*==============================================================*/
  create table APPGROUP (
     IDGROUP              SERIAL               not null,
     NAME                 VARCHAR(128)         null,
     CODGROUP             VARCHAR(128)         null,

	 tmpl_holder		  int4	default 0,
	 parent               int4	default null,

	 CODGROUP_TYPE        INT4 DEFAULT NULL,

     constraint PK_APPGROUP primary key (IDGROUP)
     constraint FK_PARENT_GROUP foreign key (parent)
        references APPGROUP (IDGROUP)
		on delete set default on update cascade;

     constraint FK_GROUPTYPE foreign key (CODGROUP_TYPE)
        references GROUPTYPE (IDGROUPTYPE)
		on delete set default on update cascade;
  );
  

  /*==============================================================*/
  /* Table: GROUPTYPE                                             */
  /* [added 06.08.2008] This is to set a kind of semantic group   */
  /* such that, in such a way, the differentiation between groups */
  /* in a semantic level can be defined programmatically          */
  /*==============================================================*/
  create table GROUPTYPE (
	IDGROUPTYPE          SERIAL                NOT NULL,
	NAME				 VARCHAR(128)		   NOT NULL,
	DESCRIPTION			 VARCHAR(1024),

	constraint PK_GROUPTYPE PRIMARY KEY (IDGROUPTYPE)
  )
  
  
  /*==============================================================*/
  /* Table: REL_GRP_APPUSR                                        */
  /* from 02.06 at home */
  /*==============================================================*/
  create table REL_GRP_APPUSR (
     IDGRP_USR            SERIAL               NOT NULL,
     CODGROUP              INT4                 not null,
     CODUSER               INT4                 not null,
     constraint PK_REL_GRP_APPUSR primary key (IDGRP_USR),
     constraint FK_REL_GRP__REL_GRP_A_APPGROUP foreign key (CODGROUP)
        references APPGROUP (IDGROUP)
        on delete cascade on update cascade,
     constraint FK_REL_GRP__REL_GRP_A_APPUSER foreign key (CODUSER)
        references APPUSER (IDUSER)
        on delete cascade on update cascade
  );
  
  
  /*==============================================================*/
  /* Table: USER_ROLE                                             */
  /* Table relationship M:N between user and role                 */
  /*==============================================================*/
  create table USER_ROLE (
    IDUSER_ROLE         SERIAL    NOT NULL,
    CODUSER             INT4      NOT NULL,
    CODROLE             INT4      NOT NULL,
    USERNAME             VARCHAR(128)         null,
    ROLENAME             VARCHAR(128)         null,
    constraint PK_USER_ROLE primary key (IDUSER_ROLE),
    
		constraint FK_USERROLE_USER foreign key (CODUSER)
      references APPUSER (IDUSER)
      on delete cascade on update cascade,
      
    constraint FK_USERROLE_ROLE foreign key (CODROLE)
      references ROLE (IDROLE)
      on delete cascade on update cascade
/*      
    constraint FK_USERROLE_USERNAME foreign key (USERNAME)
      references APPUSER (USERNAME)
      on delete cascade on update cascade,
      
    constraint FK_USERROLE_ROLENAME foreign key (ROLENAME)
      references ROLE (NAME)
      on delete cascade on update cascade
*/      
  );
  
  
  /*==============================================================*/
  /* Table: PATIENT                                               */
  /* This table contains the data for a patient                   */
  /* The field CODPATIENT, which can be confusing, keeps the code */
  /* for the patient for this study and he is an structured id    */
  /* (for more info, see the project documentation                */
  /*==============================================================*/
  create table PATIENT (
    IDPAT                SERIAL               not null,
    NAME                 VARCHAR(256),
    CODPATIENT           VARCHAR(15)          NOT NULL,
    ADDRESS              VARCHAR(512),
    PHONE                VARCHAR (20),
    NUMHC                VARCHAR(32),
    C_DATE               TIMESTAMP           default now(),
    U_DATE               TIMESTAMP,
    
    CONSTRAINT "patient_codpatient_key" UNIQUE("codpatient"),
    constraint PK_PATIENT primary key (IDPATIENT)
  );
  
  
  
  /*==============================================================*/
  /* Table: PROJECT                                               */
  /*==============================================================*/
  create table PROJECT (
    IDPRJ                SERIAL               not null,
    NAME                 VARCHAR(128)         null,
    DESCRIPTION          VARCHAR(128)         null,
    C_DATE               TIMESTAMP            default now(),
    U_DATE               TIMESTAMP,
    
    constraint PK_PROJECT primary key (IDPRJ)
  );

  
  /*==============================================================*/
  /* Table: REL_PRJ_APPUSERS                                      */
  /*==============================================================*/
  create table REL_PRJ_APPUSERS (
     idprj_usrs           SERIAL               NOT NULL,
     CODPRJ                INT4                 not null,
     CODUSER               INT4                 not null,
     constraint PK_REL_PRJ_APPUSERS primary key (IDPRJ_USRS),
     constraint FK_REL_PRJ__REL_PRJ_A_PROJECT foreign key (CODPRJ)
        references PROJECT (IDPRJ)
        on delete cascade on update cascade,
     constraint FK_REL_PRJ__REL_PRJ_A_APPUSER foreign key (CODUSER)
        references APPUSER (IDUSER)
        on delete cascade on update cascade
  );
  
  
  /*==============================================================*/
  /* Table: INTERVIEW                                             */
  /* 19.08, source attribute and fk_cloned_from added.            */
  /* This attribute is added in 	                              */
  /* order to have a reference or anchor to gather interviews from*/
  /* different groups but same meaning. The further purpose is    */
  /* to be able to make queries across all interviews. The further*/
  /* relationship is just a parent-child relationship             */
  /*==============================================================*/
  create table INTERVIEW (
    IDINTERVIEW          SERIAL               not null,
    NAME                 VARCHAR(128)         null,
    DESCRIPTION          VARCHAR(128)         null,
    
    CODPRJ               INT4,
    CODUSR               INT4	default null,
--	CODGRP				 int4 	default null,
    C_DATE               TIMESTAMP            default now(),
    U_DATE               TIMESTAMP,   
	source				 int4				  default null,

	constraint PK_INTERVIEW primary key (IDINTERVIEW),
    constraint FK_INTERVIEW_IS_FORMED_PROJECT foreign key (CODPRJ)
        references PROJECT (IDPRJ)
        on delete cascade on update cascade,
/*
	constraint FK_INTERVIEW_BELONGS_GROUP foreign key (CODGRP)
        references APPGROUP (IDGROUP)
        on delete set default on update set default
*/        
    constraint FK_INTERVIEW_BELONGS_USER foreign key (CODUSR)
        references APPUSER (IDUSER)
        on delete set default on update set default
	
	constraint FK_CLONED_FROM foreign key (SOURCE)
        references INTERVIEW (IDINTERVIEW)
        on delete set default on update cascade
-- or on delete restrict, maybe		
  );
  


  /*==============================================================*/
  /* Table: USER_ROLE                                             */
  /* Table relationship M:N between INTERVIEW and GROUP           */
  /* in order to be able to clone interview based on the group    */
  /* which are gonna belong to                                    */
  /*==============================================================*/
  create table INTRV_GROUP (
    IDINTRV_GROUP		 SERIAL    NOT NULL,
    CODINTRV             INT4      NOT NULL,
    CODGROUP             INT4      NOT NULL,
    
    constraint PK_INTRV_GROUP primary key (IDINTRV_GROUP),
    
	constraint FK_INTRVGROUP_INTRV foreign key (CODINTRV)
      references INTERVIEW (IDINTERVIEW)
      on delete cascade on update cascade,
      
    constraint FK_INTRVGROUP_GROUP foreign key (CODGROUP)
      references APPGROUP (IDGROUP)
      on delete cascade on update cascade
  );



  /*==============================================================*/
  /* Table: INTR_INSTANCE                                         */
  /* An interview instance, when applied to a patient by an user
   * CODINTERVIEW is to see what is the interview template        */
  /*==============================================================*
  create table INTR_INSTANCE (
     IDINSTANCE           SERIAL               not null,
     place                varchar(256),
     date_ini             timestamp,
     date_end             timestamp,
	   CODINTERVIEW		      INT4				   NOT NULL,
     
     constraint PK_INTR_INSTANCE primary key (IDINSTANCE),
     constraint FK_INSTANCE_INTERVIEW foreign key (CODINTERVIEW)
        references INTERVIEW (IDINTERVIEW)
        on delete restrict on update restrict
  );
  */
  
  
  /*==============================================================*/
  /* Table: SECTION                                               */
  /*==============================================================*/
  create table SECTION (
     IDSECTION            SERIAL               not null,
     NAME                 VARCHAR(128)         null,
     DESCRIPTION          VARCHAR(128)         null,
     SECTION_ORDER        INT4                 null,
     CODINTERVIEW         INT4,
     
     C_DATE               TIMESTAMP            default now(),
     U_DATE               TIMESTAMP,
     constraint PK_SECTION primary key (IDSECTION),
     constraint FK_SECTION_IS_FORMED_INTERVIEW foreign key (CODINTERVIEW)
        references INTERVIEW (IDINTERVIEW)
        on delete cascade on update cascade
  );
  
  /*==============================================================*/
  /* Table: ITEM                                                  */
  /* (Usuarlly idsectin gotta be not null, but this is allowed in */
  /*  order to create item objects without section related at the */
  /*  beginning)                                                  */
  /* The highlight field will hold the type of highlight for the  */
  /* content of the item: 0 normal, 1 bold, 2 italic, 3 underline */
  /*==============================================================*/
  create table ITEM (
     IDITEM               SERIAL               not null,
     IDSECTION            INT4,--                 not null,
     ITE_IDITEM           INT4                 null,
     CONTENT              VARCHAR(10240)       null,
     ITEM_ORDER           INT4                 null,
     HIGHLIGHT			  INT4,
     
     C_DATE               TIMESTAMP            default now(),
     U_DATE               TIMESTAMP,
     constraint PK_ITEM primary key (IDITEM),
     constraint FK_ITEM_IS_FORMED_SECTION foreign key (IDSECTION)
        references SECTION (IDSECTION)
        on delete cascade on update cascade,
     constraint FK_ITEM_CONTAINS_ITEM foreign key (ITE_IDITEM)
        references ITEM (IDITEM)
        on delete restrict on update cascade
  );
  
  
  /*==============================================================*/
  /* Table: QUESTION                                              */
  /* The codquestion is to name the code of a question as is in   */
  /* spec document inside a section (h2a, e1...).				  */
  /* The MANDATORY field is set to avoid deleting that question   */
  /* from the administration tool								  */
  /*==============================================================*/
  create table QUESTION (
     IDQUESTION           SERIAL               not null,
     codquestion					varchar(16),
--     CODITEM              INT4                 not null,
     MANDATORY            INT4                 default 0,
     REPEATABLE           INT4                 null,
     constraint PK_QUESTION primary key (IDQUESTION),
     constraint FK_QUESTION_ITEMISA2_ITEM foreign key (IDQUESTION)
        references ITEM (IDITEM)
        on delete cascade on update cascade
  );
  
  /*==============================================================*/
  /* Table: TEXT                                                  */
  /*==============================================================*/
  create table TEXT (
-- This one should be fk but hibernate doesnt allow it  
--     CODITEM               INT4                 not null,
     IDTEXT                 SERIAL               not null,
     HIGHLIGHTED            INT4,
     constraint PK_TEXT primary key (IDTEXT),
     constraint FK_TEXT_ITEMISA_ITEM foreign key (IDTEXT)
        references ITEM (IDITEM)
        on delete cascade on update cascade
  );
  
  
  /*==============================================================*
   * Table: ANSWER                                                *
   * The answer for a question in a instance of interview (with a patient)
   * With iditem/idquestion, you can know the question
   * With codintr_ins you can know the interview instance (and, then
   * the patient, if so)
   * With answer_order is possible to have several rows with the same
   * idquestion/iditem and several answers in order (ex. frequency) 
   *==============================================================*/
  create table ANSWER (
     IDANSWER             SERIAL               not null,
     IDITEM               INT4                 not null,
     IDQUESTION           INT4                 not null,

     CODINTR_INS		  INT4				   not null,
     theValue             VARCHAR(512)         null,
     ANSWER_ORDER         INT4                 null,
     
	 constraint PK_ANSWER primary key (IDANSWER),
     constraint FK_ANSWER_ISRESPOND_QUESTION foreign key (IDQUESTION)
        references QUESTION (IDQUESTION)
        on delete cascade on update cascade 
/*,
 	 constraint FK_ANSWER_INTRINST foreign key (CODINTR_INS)
        references INTR_INSTANCE (IDINSTANCE)
        on delete cascade on update cascade
*/        
  );
  
  
  /*==============================================================*/
  /* Table: ANSWER_ITEM                                           */
  /* 19.08. Added attribute CODINTRV and FK_ANSITEM_INTRV foreign */
  /* key to relate an answer_item with its interview owner. This  */
  /* is necessary to difference the types only among languages    */
  /*==============================================================*/
  create table ANSWER_ITEM (
     IDANSITEM            SERIAL               not null,
--     IDQUESTION           INT4                 not null,
     ANSWER_ORDER         INT4                 null,
     NAME                 VARCHAR(128)         null,
     DESCRIPTION          VARCHAR(128)         null,

	 CODINTRV             int4,
     constraint PK_ANSWER_ITEM primary key (IDANSITEM)
     constraint FK_ANSITEM_INTRV foreign key (CODINTRV)
        references INTERVIEW (IDINTERVIEW)
        on delete cascade on update cascade
/*     constraint FK_ANSWER_I_EXPECTS_QUESTION foreign key (IDQUESTION)
        references QUESTION (IDQUESTION)
        on delete restrict on update restrict*/
  );
  



	
  /*==============================================================*/
  /* Table: PERFORMANCE                                           */
  /* New form 02.06 (made at home)                                */
  /* Stores the state of an interview for a patient done by some  */
  /* user. The LAST_SEC field is to remember what was the last    */
  /* section performed and to be able to retrieve it later        */
  /* 02.09. Added codgroup, because the performance has to be	  */
  /* related with a group to keep the performances even although  */
  /* all group users are deleted. it is the same approach for     */
  /* interviews                                                   */
  /*==============================================================*/
  create table PERFORMANCE (
     IDPERFORMANCE        SERIAL               not null,
     CODUSER               INT4                 null,
     CODINTERVIEW          INT4                 null,
     CODPAT                INT4                 null,
     CODGROUP              int4			default null,
	 
     DATE_INI              TIMESTAMP        default now(),
     DATE_END             TIMESTAMP,
     PLACE                VARCHAR(256)         null,
     NUM_ORDER            INT4                 null,
     LAST_SEC             int4    		default 1,
     constraint PK_PERFORMANCE primary key (IDPERFORMANCE),
     constraint FK_PERFORMA_REL_APPUS_APPUSER foreign key (CODUSER)
        references APPUSER (IDUSER)
        on delete SET NULL on update cascade,
	 constraint FK_PERFORMA_REL_GROUP foreign key (CODGROUP)
        references APPGROUP (IDGROUP)
        on delete cascade on update cascade,
	
     constraint FK_PERFORMA_REL_INTRV_INTERVIE foreign key (CODINTERVIEW)
        references INTERVIEW (IDINTERVIEW)
        on delete cascade on update cascade,
     constraint FK_PERFORMA_REL_PAT_P_PATIENT foreign key (CODPAT)
        references PATIENT (IDPAT)
        on delete cascade on update cascade
  );
  
  

  
-- This next table is due to the M-N relationship between answer types and
-- questions.
-- 24.07, added the pattern field. This field has to be here, not in
-- answertype table because a different pattern has to be able to be applied
-- to every question 
  /*==============================================================*/
  /* Table: QUESTION_ANSITEM                                      */
  /*==============================================================*/
  create table QUESTION_ANSITEM (
     ID                   SERIAL            not null,
     CODANSITEM            INT4               not null,
     CODQUESTION           INT4                 not null,
     ANSWER_ORDER         INT4                 null,
     PATTERN			varchar(256),
     
     constraint PK_QUESTION_ANSITEM primary key (ID),
     constraint FK_ANSWER_ITEM foreign key (CODANSITEM)
        references ANSWER_ITEM (IDANSITEM)
        on delete cascade on update cascade,
        
     constraint FK_QUESTION foreign key (CODQUESTION)
        references QUESTION (IDQUESTION)
        on delete cascade on update cascade
  );
  
  /*==============================================================*/
  /* Table: ANSWERTYPE                                            */
  /*==============================================================*/
  create table ANSWERTYPE (
--     CODANSITEM           INT4                 not null,
     IDANSTYPE          INT4               not null,
     pattern            VARCHAR(256),
     constraint PK_ANSWERTYPE primary key (IDANSTYPE),
     constraint FK_ANSWERTY_ISONEOF_ANSWER_I foreign key (IDANSTYPE)
        references ANSWER_ITEM (IDANSITEM)
        on delete cascade on update cascade
  );
  
  /*==============================================================*/
  /* Table: ENUMTYPE                                              */
  /*==============================================================*/
  create table ENUMTYPE (
--     CODANSITEM            INT4                 not null,
     IDENUMTYPE           INT4               not null,
     NUMITEMS             INT4,
     constraint PK_ENUMTYPE primary key (IDENUMTYPE),
     constraint FK_ENUMTYPE_ISONEOF2_ANSWER_I foreign key (IDENUMTYPE)
        references ANSWER_ITEM (IDANSITEM)
        on delete cascade on update cascade
  );
  
  /*==============================================================*/
  /* Table: ENUMITEM                                              */
  /*==============================================================*/
  create table ENUMITEM (
     IDENUMITEM           SERIAL               not null,
     CODENUMTYPE           INT4                 not null,
     NAME                 VARCHAR(128)         null,
     DESCRIPTION          VARCHAR(128)         null,
     theValue             VARCHAR(256)         null,
     listorder            INT4                 null,
     constraint PK_ENUMITEM primary key (IDENUMITEM),
     constraint FK_ENUMITEM_CONTAINS_ENUMTYPE foreign key (CODENUMTYPE)
        references ENUMTYPE (IDENUMTYPE)
        on delete cascade on update cascade
  );
  
  
/*==============================================================*/
/* Table: PAT_GIVES_ANSWER2QUES                                 */
/* from 02.06 at home */
/*==============================================================*/
create table PAT_GIVES_ANSWER2QUES (
   IDP_A_Q              SERIAL               not null,
   CODPAT                INT4                 null,
   CODANSWER             INT4                 null,
   CODQUESTION           INT4                 null,
   
   ANSWER_NUMBER        INT4                 null,
   ANSWER_ORDER         INT4                 null,
   answer_grp						INT4                 null,
   constraint PK_PAT_GIVES_ANSWER2QUES primary key (IDP_A_Q),
   constraint FK_PAT_GIVE_REL_QUES__QUESTION foreign key (CODQUESTION)
      references QUESTION (IDQUESTION)
      on delete cascade on update cascade,
   constraint FK_PAT_GIVE_REL_PAT_A_PATIENT foreign key (CODPAT)
      references PATIENT (IDPAT)
      on delete cascade on update cascade,
   constraint FK_PAT_GIVE_REL_ANS_P_ANSWER foreign key (CODANSWER)
      references ANSWER (IDANSWER)
      on delete cascade on update cascade
);


-- DEFAULT SETUP
-- INSERT DEFAULT PATIENT (NULL PATIENT, TO ENABLE PREVIEW)
-- BASIC TYPES (LABEL, NUMBER AND DECIMAL) TO ENABLE PATTERNS AND BASIC TYPING
begin
insert into patient (codpatient) values '00000000';

insert into answer_item (idansitem, name, description) 
values (100, 'Label', 'Type of answer for representing strings or labels');
insert into answertype (idanstype) values (100);

insert into answer_item (idansitem, name, description) 
values (101, 'Number', 'Type of answer for representing integers');
insert into answertype (idanstype) values (101);

insert into answer_item (idansitem, name, description) 
values (102, 'Decimal', 'Floating point numbers type');
insert into answertype (idanstype) values (102);

-- Yes-No-NC default datatype
insert into answer_item (idansitem, name, description) 
values (110, 'Yes-No', 'Enumerated type for Yes-No-Not Known');

insert into enumtype (idenumtype) values (110);

insert into enumitem (codenumtype, name, thevalue, listorder)
values (110, 'Yes', 1, 1);
insert into enumitem (codenumtype, name, thevalue, listorder)
values (110, 'No', 2, 2);
insert into enumitem (codenumtype, name, thevalue, listorder)
values (110, 'Not known', 8, 3);

insert into grouptype (idgrouptype, name, description)
values (1, 'COUNTRY', 'This type of groups can hold a template');

insert into grouptype (idgrouptype, name, description)
values (2, 'HOSPITAL', 'This type of group share the same patiens among their users');

commit;