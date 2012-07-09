

/*==============================================================*/
/* DBMS name:      PostgreSQL 8                                 */
/* Created on:     01/06/2008 12:33:16                          */
/*==============================================================*/

/*
drop table ANSWER;

drop table ANSWER_ITEM;

drop table APPGROUP;

drop table APPROLE;

drop table APPUSER;

drop table EXPECTS;

drop table INTERVIEW;

drop table PATIENT;

drop table PAT_GIVES_ANSWER2QUES;

drop table PERFORMANCE;

drop table PROJECT;

drop table QUESTION;

drop table REL_GRP_APPUSR;

drop table REL_PRJ_APPUSERS;

drop table REL_ROLE_USR;
*/
/*==============================================================*/
/* Table: ANSWER_ITEM                                           */
/*==============================================================*/
create table ANSWER_ITEM (
   IDANSITEM            SERIAL               not null,
   ANSWER_ORDER         INT4                 null,
   NAME                 VARCHAR(128)         null,
   DESCRIPTION          VARCHAR(128)         null,
   constraint PK_ANSWER_ITEM primary key (IDANSITEM)
);

/*==============================================================*/
/* Table: ANSWER                                                */
/*==============================================================*/
create table ANSWER (
   IDANSWER             SERIAL               not null,
   CODANSITEM            INT4                 not null,
   VALUE                VARCHAR(256)         null,
   ANSWER_ORDER         INT4                 null,
   constraint PK_ANSWER primary key (IDANSWER),
   constraint FK_ANSWER_REL_ANSW__ANSWER_I foreign key (CODANSITEM)
      references ANSWER_ITEM (IDANSITEM)
      on delete cascade on update cascade
);

/*==============================================================*/
/* Table: APPGROUP                                              */
/* As the patient code, this will be a code for the group       */
/* within the project (it could be corresponding with the user  */
/* id)
/*==============================================================*/
create table APPGROUP (
   IDGROUP              SERIAL               not null,
   NAME                 VARCHAR(128)         null,
   CODGROUP             VARCHAR(128)         null,
   constraint PK_APPGROUP primary key (IDGROUP)
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
/* Table: QUESTION                                              */
/*==============================================================*/
create table QUESTION (
   IDQUESTION           SERIAL               not null,
   MANDATORY            BOOL                 null,
   constraint PK_QUESTION primary key (IDQUESTION)
);

/*==============================================================*/
/* Table: EXPECTS                                               */
/*==============================================================*/
create table EXPECTS (
   IDEXPECTS            SERIAL               NOT NULL,
   CODQUESTION           INT4                 not null,
   CODANSITEM            INT4                 not null,
   --   constraint PK_EXPECTS primary key (IDQUESTION, IDANSITEM),
	 constraint PK_EXPECTS primary key (IDEXPECTS),
   constraint FK_EXPECTS_EXPECTS_QUESTION foreign key (CODQUESTION)
      references QUESTION (IDQUESTION)
      on delete cascade on update cascade,
   constraint FK_EXPECTS_EXPECTS2_ANSWER_I foreign key (CODANSITEM)
      references ANSWER_ITEM (IDANSITEM)
      on delete cascade on update cascade
);

/*==============================================================*/
/* Table: PROJECT                                               */
/*==============================================================*/
create table PROJECT (
   IDPRJ                SERIAL               not null,
   NAME                 VARCHAR(128)         null,
   DESCRP               VARCHAR(128)         null,
   constraint PK_PROJECT primary key (IDPRJ)
);

/*==============================================================*/
/* Table: INTERVIEW                                             */
/*==============================================================*/
create table INTERVIEW (
   IDINTERVIEW          SERIAL               not null,
   CODPRJ                INT4                 null,
   NAME                 VARCHAR(128)         null,
   DESCRIPTION          VARCHAR(128)         null,
   constraint PK_INTERVIEW primary key (IDINTERVIEW),
   constraint FK_INTERVIE_REL_PRJ_I_PROJECT foreign key (CODPRJ)
      references PROJECT (IDPRJ)
      on delete cascade on update cascade
);

/*==============================================================*/
/* Table: PATIENT                                               */
/*==============================================================*/
create table PATIENT (
   IDPAT                SERIAL               not null,
   NUMHC                VARCHAR(15)          null,
   PATIENTCODE          VARCHAR(18)          null,
   constraint PK_PATIENT primary key (IDPAT)
);

/*==============================================================*/
/* Table: PAT_GIVES_ANSWER2QUES                                 */
/* This is the table to relate patient with questions and       */
/* answers                                                      */
/*==============================================================*/
create table PAT_GIVES_ANSWER2QUES (
   IDP_A_Q              SERIAL               not null,
   CODPAT                INT4                 null,
   CODANSWER             INT4                 null,
   CODQUESTION           INT4                 null,
   ANSWER_NUMBER        INT4                 null,
   ANSWER_ORDER         INT4                 null,
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

/*==============================================================*/
/* Table: PERFORMANCE                                           */
/* This is the table which implements the ternary relationship  */
/* to know the interviews made for one user (which implies the  */
/* group) to many patients
/*==============================================================*/
create table PERFORMANCE (
   IDPERFORMANCE        SERIAL               not null,
   CODUSER               INT4                 null,
   CODINTERVIEW          INT4                 null,
   CODPAT                INT4                 null,
   theDate              timestamp            null,
   PLACE                VARCHAR(256)         null,
   NUM_ORDER            INT4                 null,
   constraint PK_PERFORMANCE primary key (IDPERFORMANCE),
   constraint FK_PERFORMA_REL_APPUS_APPUSER foreign key (CODUSER)
      references APPUSER (IDUSER)
      on delete cascade on update cascade,
   constraint FK_PERFORMA_REL_INTRV_INTERVIE foreign key (CODINTERVIEW)
      references INTERVIEW (IDINTERVIEW)
      on delete cascade on update cascade,
   constraint FK_PERFORMA_REL_PAT_P_PATIENT foreign key (CODPAT)
      references PATIENT (IDPAT)
      on delete cascade on update cascade
);

/*==============================================================*/
/* Table: REL_GRP_APPUSR                                        */
/*==============================================================*/
create table REL_GRP_APPUSR (
   IDGRP_USR            SERIAL               NOT NULL,
   CODGROUP              INT4                 not null,
   CODUSER               INT4                 not null,
--   constraint PK_REL_GRP_APPUSR primary key (IDGROUP, IDUSER),
   constraint PK_REL_ROLE_USR primary key (IDGRP_USR),
   constraint FK_REL_GRP__REL_GRP_A_APPGROUP foreign key (CODGROUP)
      references APPGROUP (IDGROUP)
      on delete cascade on update cascade,
   constraint FK_REL_GRP__REL_GRP_A_APPUSER foreign key (CODUSER)
      references APPUSER (IDUSER)
      on delete cascade on update cascade
);

/*==============================================================*/
/* Table: REL_PRJ_APPUSERS                                      */
/*==============================================================*/
create table REL_PRJ_APPUSERS (
   IDPRJ_USRS            SERIAL               NOT NULL,
   CODPRJ                INT4                 not null,
   CODUSER               INT4                 not null,
--   constraint PK_REL_PRJ_APPUSERS primary key (IDPRJ, IDUSER),
   constraint PK_REL_PRJ_USR primary key (IDPRJ_USRS),
   constraint FK_REL_PRJ__REL_PRJ_A_PROJECT foreign key (CODPRJ)
      references PROJECT (IDPRJ)
      on delete cascade on update cascade,
   constraint FK_REL_PRJ__REL_PRJ_A_APPUSER foreign key (CODUSER)
      references APPUSER (IDUSER)
      on delete cascade on update cascade
);

/*==============================================================*/
/* Table: REL_ROLE_USR                                          */
/*==============================================================*/
create table REL_ROLE_USR (
   IDROLE_USR            SERIAL               NOT NULL,
   CODUSER               INT4                 not null,
   CODROLE               INT4                 not null,
--   constraint PK_REL_ROLE_USR primary key (IDUSER, IDROLE),
   constraint PK_REL_ROLE_USR primary key (IDROLE_USR),
   constraint FK_REL_ROLE_REL_ROLE__APPUSER foreign key (CODUSER)
      references APPUSER (IDUSER)
      on delete cascade on update cascade,
   constraint FK_REL_ROLE_REL_ROLE__APPROLE foreign key (CODROLE)
      references APPROLE (IDROLE)
      on delete cascade on update cascade
);

