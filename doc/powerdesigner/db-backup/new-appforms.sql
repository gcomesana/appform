/*==============================================================*/
/* DBMS name:      PostgreSQL 8                                 */
/* Created on:     17/03/2008 18:43:08                          */
/*==============================================================*/


drop index ISRESPONDED_FK;

drop index ANSWER_PK;

drop table ANSWER;

drop index ANSWERTYPE_PK;

drop table ANSWERTYPE;

drop index APPROLE_PK;

drop table APPROLE;

drop index APPUSER_PK;

drop table APPUSER;

drop index HAS_REF_FK;

drop index CAN_JUMP2_FK;

drop index JUMP_TO_FK;

drop index COND_JUMP_PK;

drop table COND_JUMP;

drop index RDBMS_FK;

drop index DATASOURCE_PK;

drop table DATASOURCE;

drop index DSTYPE_PK;

drop table DSTYPE;

drop index HAELEMS_FK;

drop table ENUMITEM;

drop index HAS_ENUMTYPE_FK;

drop index RELATIONSHIP_17_FK;

drop index ENUMTYPE_PK;

drop table ENUMTYPE;

drop index HASROLE2_FK;

drop index HASROLE_FK;

drop index HASROLE_PK;

drop table HASROLE;

drop index DEVELOP_FK;

drop index INTERVIEW_PK;

drop table INTERVIEW;

drop index INTERVIEWEE_PK;

drop table INTERVIEWEE;

drop index IS_STORED_IN2_FK;

drop index IS_STORED_IN_FK;

drop index IS_STORED_IN_PK;

drop table IS_STORED_IN;

drop index CONTAINS_FK;

drop index CAN_HAVE_FK;

drop index IS_FORMED_FK;

drop index ITEM_PK;

drop table ITEM;

drop index ISREALIZED_FK;

drop index PERFORMANCE_PK;

drop table PERFORMANCE;

drop index ITEMISAQUESTION_FK;

drop index CAN_JUMP_FK;

drop index HASENUM_FK;

drop index HASTYPE_FK;

drop index QUESTION_PK;

drop table QUESTION;

drop index INTERVIEWEE_REALIZE_FK;

drop index PERFORMANCE_REALIZE_FK;

drop index USER_REALIZE_FK;

drop index REALIZE_PERFORMANCE_PK;

drop table REALIZE_PERFORMANCE;

drop index IS_COMPOSED_FK;

drop index SECTION_PK;

drop table SECTION;

drop index ITEMISATEXT_FK;

drop index TEXT_PK;

drop table TEXT;

/*==============================================================*/
/* Table: ANSWERTYPE                                            */
/*==============================================================*/
create table ANSWERTYPE (
   IDANSTYPE            SERIAL               not null,
   NAME                 VARCHAR(128)         null,
   DESCRIPTION          VARCHAR(128)         null,
   "ORDER"              INT4                 null,
   constraint PK_ANSWERTYPE primary key (IDANSTYPE)
);

/*==============================================================*/
/* Table: ENUMTYPE                                              */
/*==============================================================*/
create table ENUMTYPE (
   IDANSTYPE            INT4                 not null,
   IDENTYPE             SERIAL               not null,
   ANS_IDANSTYPE        INT4                 null,
   NAME                 VARCHAR(128)         null,
   DESCRIPTION          VARCHAR(128)         null,
   "ORDER"              INT4                 null,
   constraint PK_ENUMTYPE primary key (IDANSTYPE, IDENTYPE),
   constraint AK_ID_ENUMTYPE unique (IDENTYPE),
   constraint FK_ENUMTYPE_RELATIONS_ANSWERTY foreign key (ANS_IDANSTYPE)
      references ANSWERTYPE (IDANSTYPE)
      on delete cascade on update restrict,
   constraint FK_ENUMTYPE_HAS_ENUMT_ANSWERTY foreign key (IDANSTYPE)
      references ANSWERTYPE (IDANSTYPE)
      on delete cascade on update restrict
);

/*==============================================================*/
/* Table: APPUSER                                               */
/*==============================================================*/
create table APPUSER (
   IDUSER               SERIAL               not null,
   NICKNAME             VARCHAR(32)          null,
   PASSWD               VARCHAR(32)          null,
   NAME                 VARCHAR(128)         null,
   MIDNAME              VARCHAR(128)         null,
   LASTNAME             VARCHAR(128)         null,
   constraint PK_APPUSER primary key (IDUSER)
);

/*==============================================================*/
/* Table: INTERVIEW                                             */
/*==============================================================*/
create table INTERVIEW (
   IDINTERVIEW          SERIAL               not null,
   IDUSER               INT4                 not null,
   NAME                 VARCHAR(128)         null,
   DESCRIPTION          VARCHAR(128)         null,
   constraint PK_INTERVIEW primary key (IDINTERVIEW),
   constraint FK_INTERVIE_DEVELOP_APPUSER foreign key (IDUSER)
      references APPUSER (IDUSER)
      on delete cascade on update restrict
);

/*==============================================================*/
/* Table: SECTION                                               */
/*==============================================================*/
create table SECTION (
   IDSECTION            SERIAL               not null,
   IDINTERVIEW          INT4                 not null,
   NAME                 VARCHAR(128)         null,
   DESCRIPTION          VARCHAR(128)         null,
   "ORDER"              INT4                 null,
   constraint PK_SECTION primary key (IDSECTION),
   constraint FK_SECTION_IS_COMPOS_INTERVIE foreign key (IDINTERVIEW)
      references INTERVIEW (IDINTERVIEW)
      on delete cascade on update restrict
);

/*==============================================================*/
/* Table: ITEM                                                  */
/*==============================================================*/
create table ITEM (
   IDITEM               SERIAL               not null,
   IDSECTION            INT4                 not null,
   ITE_IDITEM           INT4                 null,
   QUE_IDITEM           INT4                 null,
   IDQUESTION           INT4                 null,
   ITEM_ORDER           INT4                 null,
   CONTENT              VARCHAR(10240)       null,
   constraint PK_ITEM primary key (IDITEM),
   constraint FK_ITEM_IS_FORMED_SECTION foreign key (IDSECTION)
      references SECTION (IDSECTION)
      on delete cascade on update restrict,
   constraint FK_ITEM_CAN_HAVE_QUESTION foreign key (QUE_IDITEM, IDQUESTION)
      references QUESTION (IDITEM, IDQUESTION)
      on delete cascade on update restrict,
   constraint FK_ITEM_CONTAINS_ITEM foreign key (ITE_IDITEM)
      references ITEM (IDITEM)
      on delete cascade on update restrict
);

/*==============================================================*/
/* Table: ENUMITEM                                              */
/*==============================================================*/
create table ENUMITEM (
   IDANSTYPE            INT4                 not null,
   IDENTYPE             INT4                 not null,
   IDENUMITEM           SERIAL               not null,
   NAME                 VARCHAR(128)         not null,
   DESCRIPTION          VARCHAR(128)         null,
   VALUE                VARCHAR(256)         null,
   constraint AK_ID_ENUMITEM unique (IDENUMITEM),
   constraint FK_ENUMITEM_HAELEMS_ENUMTYPE foreign key (IDANSTYPE, IDENTYPE)
      references ENUMTYPE (IDANSTYPE, IDENTYPE)
      on delete cascade on update restrict
);

/*==============================================================*/
/* Table: COND_JUMP                                             */
/*==============================================================*/
create table COND_JUMP (
   NAME                 VARCHAR(128)         null,
   IDCONDJUMP           SERIAL               not null,
   QUE_IDITEM           INT4                 not null,
   IDQUESTION           INT4                 not null,
   IDITEM               INT4                 not null,
   OPERATOR             INT4                 not null default 1,
   constraint PK_COND_JUMP primary key (IDCONDJUMP),
   constraint AK_ID_COND_JUM unique (IDCONDJUMP),
   constraint FK_COND_JUM_JUMP_TO_ITEM foreign key (IDITEM)
      references ITEM (IDITEM)
      on delete cascade on update restrict,
   constraint FK_COND_JUM_CAN_JUMP2_QUESTION foreign key (QUE_IDITEM, IDQUESTION)
      references QUESTION (IDITEM, IDQUESTION)
      on delete cascade on update restrict,
   constraint FK_COND_JUM_HAS_REF_ENUMITEM foreign key ()
      references ENUMITEM
      on delete cascade on update restrict
);

/*==============================================================*/
/* Table: QUESTION                                              */
/*==============================================================*/
create table QUESTION (
   IDITEM               INT4                 not null,
   IDQUESTION           SERIAL               not null,
   ENU_IDANSTYPE        INT4                 null,
   IDENTYPE             INT4                 null,
   IDCONDJUMP           INT4                 not null,
   IDANSTYPE            INT4                 not null,
   IDSECTION            INT4                 null,
   ITE_IDITEM           INT4                 null,
   "ORDER"              INT4                 null,
   CONTENT              VARCHAR(10240)       null,
   MANDATORY            BOOL                 null,
   constraint PK_QUESTION primary key (IDITEM, IDQUESTION),
   constraint FK_QUESTION_HASTYPE_ANSWERTY foreign key (IDANSTYPE)
      references ANSWERTYPE (IDANSTYPE)
      on delete cascade on update restrict,
   constraint FK_QUESTION_HASENUM_ENUMTYPE foreign key (ENU_IDANSTYPE, IDENTYPE)
      references ENUMTYPE (IDANSTYPE, IDENTYPE)
      on delete cascade on update restrict,
   constraint FK_QUESTION_CAN_JUMP_COND_JUM foreign key (IDCONDJUMP)
      references COND_JUMP (IDCONDJUMP)
      on delete cascade on update restrict,
   constraint FK_QUESTION_ITEMISAQU_ITEM foreign key (IDITEM)
      references ITEM (IDITEM)
      on delete cascade on update restrict
);

/*==============================================================*/
/* Table: ANSWER                                                */
/*==============================================================*/
create table ANSWER (
   IDANSWER             SERIAL               not null,
   IDITEM               INT4                 not null,
   IDQUESTION           INT4                 not null,
   "ORDER"              INT4                 null,
   VALUE                VARCHAR(256)         null,
   constraint PK_ANSWER primary key (IDANSWER),
   constraint FK_ANSWER_ISRESPOND_QUESTION foreign key (IDITEM, IDQUESTION)
      references QUESTION (IDITEM, IDQUESTION)
      on delete cascade on update restrict
);

/*==============================================================*/
/* Index: ANSWER_PK                                             */
/*==============================================================*/
create unique index ANSWER_PK on ANSWER (
IDANSWER
);

/*==============================================================*/
/* Index: ISRESPONDED_FK                                        */
/*==============================================================*/
create  index ISRESPONDED_FK on ANSWER (
IDITEM,
IDQUESTION
);

/*==============================================================*/
/* Index: ANSWERTYPE_PK                                         */
/*==============================================================*/
create unique index ANSWERTYPE_PK on ANSWERTYPE (
IDANSTYPE
);

/*==============================================================*/
/* Table: APPROLE                                               */
/*==============================================================*/
create table APPROLE (
   IDROLE               SERIAL               not null,
   NAME                 VARCHAR(128)         null,
   DESCRIPTION          VARCHAR(128)         null,
   constraint PK_APPROLE primary key (IDROLE)
);

/*==============================================================*/
/* Index: APPROLE_PK                                            */
/*==============================================================*/
create unique index APPROLE_PK on APPROLE (
IDROLE
);

/*==============================================================*/
/* Index: APPUSER_PK                                            */
/*==============================================================*/
create unique index APPUSER_PK on APPUSER (
IDUSER
);

/*==============================================================*/
/* Index: COND_JUMP_PK                                          */
/*==============================================================*/
create unique index COND_JUMP_PK on COND_JUMP (
IDCONDJUMP
);

/*==============================================================*/
/* Index: JUMP_TO_FK                                            */
/*==============================================================*/
create  index JUMP_TO_FK on COND_JUMP (
IDITEM
);

/*==============================================================*/
/* Index: CAN_JUMP2_FK                                          */
/*==============================================================*/
create  index CAN_JUMP2_FK on COND_JUMP (
QUE_IDITEM,
IDQUESTION
);

/*==============================================================*/
/* Index: HAS_REF_FK                                            */
/*==============================================================*/
create  index HAS_REF_FK on COND_JUMP (

);

/*==============================================================*/
/* Table: DSTYPE                                                */
/*==============================================================*/
create table DSTYPE (
   IDDSTYPE             SERIAL               not null,
   NAME                 VARCHAR(128)         null,
   PORT                 INT2                 null,
   constraint PK_DSTYPE primary key (IDDSTYPE)
);

/*==============================================================*/
/* Table: DATASOURCE                                            */
/*==============================================================*/
create table DATASOURCE (
   IDDATASOURCE         SERIAL               not null,
   IDDSTYPE             INT4                 not null,
   DSNAME               VARCHAR(128)         null,
   DSSERVER             VARCHAR(128)         null,
   ORGANIZATION         VARCHAR(256)         null,
   constraint PK_DATASOURCE primary key (IDDATASOURCE),
   constraint FK_DATASOUR_RDBMS_DSTYPE foreign key (IDDSTYPE)
      references DSTYPE (IDDSTYPE)
      on delete cascade on update restrict
);

/*==============================================================*/
/* Index: DATASOURCE_PK                                         */
/*==============================================================*/
create unique index DATASOURCE_PK on DATASOURCE (
IDDATASOURCE
);

/*==============================================================*/
/* Index: RDBMS_FK                                              */
/*==============================================================*/
create  index RDBMS_FK on DATASOURCE (
IDDSTYPE
);

/*==============================================================*/
/* Index: DSTYPE_PK                                             */
/*==============================================================*/
create unique index DSTYPE_PK on DSTYPE (
IDDSTYPE
);

/*==============================================================*/
/* Index: HAELEMS_FK                                            */
/*==============================================================*/
create  index HAELEMS_FK on ENUMITEM (
IDANSTYPE,
IDENTYPE
);

/*==============================================================*/
/* Index: ENUMTYPE_PK                                           */
/*==============================================================*/
create unique index ENUMTYPE_PK on ENUMTYPE (
IDANSTYPE,
IDENTYPE
);

/*==============================================================*/
/* Index: RELATIONSHIP_17_FK                                    */
/*==============================================================*/
create  index RELATIONSHIP_17_FK on ENUMTYPE (
ANS_IDANSTYPE
);

/*==============================================================*/
/* Index: HAS_ENUMTYPE_FK                                       */
/*==============================================================*/
create  index HAS_ENUMTYPE_FK on ENUMTYPE (
IDANSTYPE
);

/*==============================================================*/
/* Table: HASROLE                                               */
/*==============================================================*/
create table HASROLE (
   IDUSER               INT4                 not null,
   IDROLE               INT4                 not null,
   constraint PK_HASROLE primary key (IDUSER, IDROLE),
   constraint FK_HASROLE_HASROLE_APPUSER foreign key (IDUSER)
      references APPUSER (IDUSER)
      on delete cascade on update restrict,
   constraint FK_HASROLE_HASROLE2_APPROLE foreign key (IDROLE)
      references APPROLE (IDROLE)
      on delete cascade on update restrict
);

/*==============================================================*/
/* Index: HASROLE_PK                                            */
/*==============================================================*/
create unique index HASROLE_PK on HASROLE (
IDUSER,
IDROLE
);

/*==============================================================*/
/* Index: HASROLE_FK                                            */
/*==============================================================*/
create  index HASROLE_FK on HASROLE (
IDUSER
);

/*==============================================================*/
/* Index: HASROLE2_FK                                           */
/*==============================================================*/
create  index HASROLE2_FK on HASROLE (
IDROLE
);

/*==============================================================*/
/* Index: INTERVIEW_PK                                          */
/*==============================================================*/
create unique index INTERVIEW_PK on INTERVIEW (
IDINTERVIEW
);

/*==============================================================*/
/* Index: DEVELOP_FK                                            */
/*==============================================================*/
create  index DEVELOP_FK on INTERVIEW (
IDUSER
);

/*==============================================================*/
/* Table: INTERVIEWEE                                           */
/*==============================================================*/
create table INTERVIEWEE (
   IDINTERVIEWEE        SERIAL               not null,
   EXTERNALID           INT4                 null,
   constraint PK_INTERVIEWEE primary key (IDINTERVIEWEE)
);

/*==============================================================*/
/* Index: INTERVIEWEE_PK                                        */
/*==============================================================*/
create unique index INTERVIEWEE_PK on INTERVIEWEE (
IDINTERVIEWEE
);

/*==============================================================*/
/* Table: IS_STORED_IN                                          */
/*==============================================================*/
create table IS_STORED_IN (
   IDINTERVIEWEE        INT4                 not null,
   IDDATASOURCE         INT4                 not null,
   constraint PK_IS_STORED_IN primary key (IDINTERVIEWEE, IDDATASOURCE),
   constraint FK_IS_STORE_IS_STORED_INTERVIE foreign key (IDINTERVIEWEE)
      references INTERVIEWEE (IDINTERVIEWEE)
      on delete cascade on update restrict,
   constraint FK_IS_STORE_IS_STORED_DATASOUR foreign key (IDDATASOURCE)
      references DATASOURCE (IDDATASOURCE)
      on delete cascade on update restrict
);

/*==============================================================*/
/* Index: IS_STORED_IN_PK                                       */
/*==============================================================*/
create unique index IS_STORED_IN_PK on IS_STORED_IN (
IDINTERVIEWEE,
IDDATASOURCE
);

/*==============================================================*/
/* Index: IS_STORED_IN_FK                                       */
/*==============================================================*/
create  index IS_STORED_IN_FK on IS_STORED_IN (
IDINTERVIEWEE
);

/*==============================================================*/
/* Index: IS_STORED_IN2_FK                                      */
/*==============================================================*/
create  index IS_STORED_IN2_FK on IS_STORED_IN (
IDDATASOURCE
);

/*==============================================================*/
/* Index: ITEM_PK                                               */
/*==============================================================*/
create unique index ITEM_PK on ITEM (
IDITEM
);

/*==============================================================*/
/* Index: IS_FORMED_FK                                          */
/*==============================================================*/
create  index IS_FORMED_FK on ITEM (
IDSECTION
);

/*==============================================================*/
/* Index: CAN_HAVE_FK                                           */
/*==============================================================*/
create  index CAN_HAVE_FK on ITEM (
QUE_IDITEM,
IDQUESTION
);

/*==============================================================*/
/* Index: CONTAINS_FK                                           */
/*==============================================================*/
create  index CONTAINS_FK on ITEM (
ITE_IDITEM
);

/*==============================================================*/
/* Table: PERFORMANCE                                           */
/*==============================================================*/
create table PERFORMANCE (
   IDPERFORMANCE        SERIAL               not null,
   IDINTERVIEW          INT4                 not null,
   DATE                 DATE                 null,
   PLACE                VARCHAR(256)         null,
   NUM_ORDER            INT4                 null,
   constraint PK_PERFORMANCE primary key (IDPERFORMANCE),
   constraint FK_PERFORMA_ISREALIZE_INTERVIE foreign key (IDINTERVIEW)
      references INTERVIEW (IDINTERVIEW)
      on delete cascade on update restrict
);

/*==============================================================*/
/* Index: PERFORMANCE_PK                                        */
/*==============================================================*/
create unique index PERFORMANCE_PK on PERFORMANCE (
IDPERFORMANCE
);

/*==============================================================*/
/* Index: ISREALIZED_FK                                         */
/*==============================================================*/
create  index ISREALIZED_FK on PERFORMANCE (
IDINTERVIEW
);

/*==============================================================*/
/* Index: QUESTION_PK                                           */
/*==============================================================*/
create unique index QUESTION_PK on QUESTION (
IDITEM,
IDQUESTION
);

/*==============================================================*/
/* Index: HASTYPE_FK                                            */
/*==============================================================*/
create  index HASTYPE_FK on QUESTION (
IDANSTYPE
);

/*==============================================================*/
/* Index: HASENUM_FK                                            */
/*==============================================================*/
create  index HASENUM_FK on QUESTION (
ENU_IDANSTYPE,
IDENTYPE
);

/*==============================================================*/
/* Index: CAN_JUMP_FK                                           */
/*==============================================================*/
create  index CAN_JUMP_FK on QUESTION (
IDCONDJUMP
);

/*==============================================================*/
/* Index: ITEMISAQUESTION_FK                                    */
/*==============================================================*/
create  index ITEMISAQUESTION_FK on QUESTION (
IDITEM
);

/*==============================================================*/
/* Table: REALIZE_PERFORMANCE                                   */
/*==============================================================*/
create table REALIZE_PERFORMANCE (
   IDREALIZE            SERIAL               not null,
   IDPERFORMANCE        INT4                 not null,
   IDUSER               INT4                 not null,
   IDINTERVIEWEE        INT4                 not null,
   constraint PK_REALIZE_PERFORMANCE primary key (IDREALIZE),
   constraint FK_REALIZE__USER_REAL_APPUSER foreign key (IDUSER)
      references APPUSER (IDUSER)
      on delete cascade on update restrict,
   constraint FK_REALIZE__PERFORMAN_PERFORMA foreign key (IDPERFORMANCE)
      references PERFORMANCE (IDPERFORMANCE)
      on delete cascade on update restrict,
   constraint FK_REALIZE__INTERVIEW_INTERVIE foreign key (IDINTERVIEWEE)
      references INTERVIEWEE (IDINTERVIEWEE)
      on delete cascade on update restrict
);

/*==============================================================*/
/* Index: REALIZE_PERFORMANCE_PK                                */
/*==============================================================*/
create unique index REALIZE_PERFORMANCE_PK on REALIZE_PERFORMANCE (
IDREALIZE
);

/*==============================================================*/
/* Index: USER_REALIZE_FK                                       */
/*==============================================================*/
create  index USER_REALIZE_FK on REALIZE_PERFORMANCE (
IDUSER
);

/*==============================================================*/
/* Index: PERFORMANCE_REALIZE_FK                                */
/*==============================================================*/
create  index PERFORMANCE_REALIZE_FK on REALIZE_PERFORMANCE (
IDPERFORMANCE
);

/*==============================================================*/
/* Index: INTERVIEWEE_REALIZE_FK                                */
/*==============================================================*/
create  index INTERVIEWEE_REALIZE_FK on REALIZE_PERFORMANCE (
IDINTERVIEWEE
);

/*==============================================================*/
/* Index: SECTION_PK                                            */
/*==============================================================*/
create unique index SECTION_PK on SECTION (
IDSECTION
);

/*==============================================================*/
/* Index: IS_COMPOSED_FK                                        */
/*==============================================================*/
create  index IS_COMPOSED_FK on SECTION (
IDINTERVIEW
);

/*==============================================================*/
/* Table: TEXT                                                  */
/*==============================================================*/
create table TEXT (
   IDITEM               INT4                 not null,
   IDTEXTw              SERIAL               not null,
   IDSECTION            INT4                 null,
   ITE_IDITEM           INT4                 null,
   IDQUESTION           INT4                 null,
   ITE_ORDER            INT4                 null,
   CONTENT              VARCHAR(10240)       null,
   "ORDER"              INT4                 null,
   constraint PK_TEXT primary key (IDITEM, IDTEXT2),
   constraint FK_TEXT_ITEMISATE_ITEM foreign key (IDITEM)
      references ITEM (IDITEM)
      on delete cascade on update restrict
);

/*==============================================================*/
/* Index: TEXT_PK                                               */
/*==============================================================*/
create unique index TEXT_PK on TEXT (
IDITEM,
IDTEXT2
);

/*==============================================================*/
/* Index: ITEMISATEXT_FK                                        */
/*==============================================================*/
create  index ITEMISATEXT_FK on TEXT (
IDITEM
);

