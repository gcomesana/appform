-- SQL Manager 2007 for PostgreSQL 4.1.0.7
-- ---------------------------------------
-- Host      : localhost
-- Database  : appform
-- Version   : PostgreSQL 8.1.11 on i686-pc-mingw32, compiled by GCC gcc.exe (GCC) 3.4.2 (mingw-special)


SET search_path = public, pg_catalog;
ALTER TABLE ONLY public.question DROP CONSTRAINT fk_question_text;
ALTER TABLE ONLY public.hasrole DROP CONSTRAINT fk5463c1f018d7b381;
ALTER TABLE ONLY public.hasrole DROP CONSTRAINT fk5463c1f018da8a2b;
ALTER TABLE ONLY public.approle DROP CONSTRAINT approle_pkey;
ALTER TABLE ONLY public.hasrole DROP CONSTRAINT hasrole_pkey;
ALTER TABLE ONLY public.realize_performance DROP CONSTRAINT fk_realize__interview_intervie;
ALTER TABLE ONLY public.realize_performance DROP CONSTRAINT fk_realize__performan_performa;
ALTER TABLE ONLY public.realize_performance DROP CONSTRAINT fk_realize__user_real_appuser;
ALTER TABLE ONLY public.realize_performance DROP CONSTRAINT pk_realize_performance;
ALTER TABLE ONLY public.performance DROP CONSTRAINT fk_performa_isrealize_intervie;
ALTER TABLE ONLY public.performance DROP CONSTRAINT pk_performance;
ALTER TABLE ONLY public.interviewee DROP CONSTRAINT pk_interviewee;
ALTER TABLE ONLY public.can_be DROP CONSTRAINT fk_can_be_can_be2_question;
ALTER TABLE ONLY public.can_be DROP CONSTRAINT fk_can_be_can_be_text;
ALTER TABLE ONLY public.can_be DROP CONSTRAINT pk_can_be;
ALTER TABLE ONLY public.text DROP CONSTRAINT fk_text_is_formed_section;
ALTER TABLE ONLY public.text DROP CONSTRAINT pk_text;
ALTER TABLE ONLY public.section DROP CONSTRAINT fk_section_is_compos_intervie;
ALTER TABLE ONLY public.section DROP CONSTRAINT pk_section;
ALTER TABLE ONLY public.interview DROP CONSTRAINT fk_intervie_develop_appuser;
ALTER TABLE ONLY public.interview DROP CONSTRAINT pk_interview;
ALTER TABLE ONLY public.appuser DROP CONSTRAINT pk_appuser;
ALTER TABLE ONLY public.answer DROP CONSTRAINT fk_answer_isrespond_question;
ALTER TABLE ONLY public.answer DROP CONSTRAINT pk_answer;
ALTER TABLE ONLY public.question DROP CONSTRAINT fk_question_hastype_answerty;
ALTER TABLE ONLY public.question DROP CONSTRAINT pk_question;
ALTER TABLE ONLY public.answertype DROP CONSTRAINT pk_answertype;
ALTER TABLE ONLY public.pg_ts_cfgmap DROP CONSTRAINT pg_ts_cfgmap_pkey;
ALTER TABLE ONLY public.pg_ts_cfg DROP CONSTRAINT pg_ts_cfg_pkey;
ALTER TABLE ONLY public.pg_ts_parser DROP CONSTRAINT pg_ts_parser_pkey;
ALTER TABLE ONLY public.pg_ts_dict DROP CONSTRAINT pg_ts_dict_pkey;
DROP INDEX public.is_formed_fk;
DROP INDEX public.text_pk;
DROP INDEX public.is_composed_fk;
DROP INDEX public.section_pk;
DROP INDEX public.interviewee_realize_fk;
DROP INDEX public.performance_realize_fk;
DROP INDEX public.user_realize_fk;
DROP INDEX public.realize_performance_pk;
DROP INDEX public.hastype_fk;
DROP INDEX public.question_pk;
DROP INDEX public.isrealized_fk;
DROP INDEX public.performance_pk;
DROP INDEX public.interviewee_pk;
DROP INDEX public.develop_fk;
DROP INDEX public.interview_pk;
DROP INDEX public.can_be2_fk;
DROP INDEX public.can_be_fk;
DROP INDEX public.can_be_pk;
DROP INDEX public.appuser_pk;
DROP INDEX public.answertype_pk;
DROP INDEX public.isresponded_fk;
DROP INDEX public.answer_pk;
DROP SEQUENCE public.hasrole_idhasrole_seq;
DROP SEQUENCE public.approle_idrole_seq;
DROP TABLE public.approle;
DROP TABLE public.hasrole;
DROP SEQUENCE public.hibernate_sequence;
DROP TABLE public.realize_performance;
DROP SEQUENCE public.realize_performance_idrealize_seq;
DROP TABLE public.performance;
DROP SEQUENCE public.performance_idperformance_seq;
DROP TABLE public.interviewee;
DROP SEQUENCE public.interviewee_idinterviewee_seq;
DROP TABLE public.can_be;
DROP TABLE public.text;
DROP SEQUENCE public.text_idtext_seq;
DROP TABLE public.section;
DROP SEQUENCE public.section_idsection_seq;
DROP TABLE public.interview;
DROP SEQUENCE public.interview_idinterview_seq;
DROP TABLE public.appuser;
DROP SEQUENCE public.appuser_iduser_seq;
DROP TABLE public.answer;
DROP SEQUENCE public.answer_idanswer_seq;
DROP TABLE public.question;
DROP SEQUENCE public.question_idquestion_seq;
DROP TABLE public.answertype;
DROP SEQUENCE public.answertype_idanstype_seq;
DROP TABLE public.pg_ts_cfgmap;
DROP TABLE public.pg_ts_cfg;
DROP TABLE public.pg_ts_parser;
DROP TABLE public.pg_ts_dict;
--
-- Structure for table pg_ts_dict (OID = 16642) : 
--
CREATE TABLE public.pg_ts_dict (
    dict_name pg_catalog.text NOT NULL,
    dict_init regprocedure,
    dict_initoption pg_catalog.text,
    dict_lexize regprocedure NOT NULL,
    dict_comment pg_catalog.text
);
--
-- Structure for table pg_ts_parser (OID = 16668) : 
--
CREATE TABLE public.pg_ts_parser (
    prs_name pg_catalog.text NOT NULL,
    prs_start regprocedure NOT NULL,
    prs_nexttoken regprocedure NOT NULL,
    prs_end regprocedure NOT NULL,
    prs_headline regprocedure NOT NULL,
    prs_lextype regprocedure NOT NULL,
    prs_comment pg_catalog.text
);
--
-- Structure for table pg_ts_cfg (OID = 16693) : 
--
CREATE TABLE public.pg_ts_cfg (
    ts_name pg_catalog.text NOT NULL,
    prs_name pg_catalog.text NOT NULL,
    locale pg_catalog.text
);
--
-- Structure for table pg_ts_cfgmap (OID = 16700) : 
--
CREATE TABLE public.pg_ts_cfgmap (
    ts_name pg_catalog.text NOT NULL,
    tok_alias pg_catalog.text NOT NULL,
    dict_name pg_catalog.text[]
);
--
-- Definition for sequence answertype_idanstype_seq (OID = 26847) : 
--
-- CREATE SEQUENCE public.answertype_idanstype_seq
--     START WITH 1
--     INCREMENT BY 1
--     NO MAXVALUE
--     NO MINVALUE
--     CACHE 1;
--
-- Structure for table answertype (OID = 26849) : 
--
CREATE TABLE public.answertype (
    idanstype serial NOT NULL,
    name varchar(128),
    description varchar(128)
) WITHOUT OIDS;
--
-- Definition for sequence question_idquestion_seq (OID = 26854) : 
--
-- CREATE SEQUENCE public.question_idquestion_seq
--     START WITH 1
--     INCREMENT BY 1
--     NO MAXVALUE
--     NO MINVALUE
--     CACHE 1;
--
-- Structure for table question (OID = 26856) : 
--
CREATE TABLE public.question (
    idquestion serial NOT NULL,
    idanstype integer NOT NULL,
    mandatory boolean DEFAULT false,
    codtext integer NOT NULL
) WITHOUT OIDS;
--
-- Definition for sequence answer_idanswer_seq (OID = 26866) : 
--
-- CREATE SEQUENCE public.answer_idanswer_seq
--     START WITH 1
--     INCREMENT BY 1
--     NO MAXVALUE
--     NO MINVALUE
--     CACHE 1;
--
-- Structure for table answer (OID = 26868) : 
--
CREATE TABLE public.answer (
    idanswer serial NOT NULL,
    idquestion integer NOT NULL,
    content varchar(128)
) WITHOUT OIDS;
--
-- Definition for sequence appuser_iduser_seq (OID = 26889) : 
--
-- CREATE SEQUENCE public.appuser_iduser_seq
--     INCREMENT BY 1
--     NO MAXVALUE
--     NO MINVALUE
--     CACHE 1;
--
-- Structure for table appuser (OID = 26891) : 
--
CREATE TABLE public.appuser (
    iduser serial NOT NULL,
    nickname varchar(32),
    passwd varchar(32),
    name varchar(128),
    midname varchar(128),
    lastname varchar(128)
) WITHOUT OIDS;
--
-- Definition for sequence interview_idinterview_seq (OID = 26897) : 
--
-- CREATE SEQUENCE public.interview_idinterview_seq
--     START WITH 1
--     INCREMENT BY 1
--     NO MAXVALUE
--     NO MINVALUE
--     CACHE 1;
--
-- Structure for table interview (OID = 26899) : 
--
CREATE TABLE public.interview (
    idinterview serial NOT NULL,
    iduser integer NOT NULL,
    name varchar(128),
    description varchar(128)
) WITHOUT OIDS;
--
-- Definition for sequence section_idsection_seq (OID = 26909) : 
--
-- CREATE SEQUENCE public.section_idsection_seq
--     START WITH 1
--     INCREMENT BY 1
--     NO MAXVALUE
--     NO MINVALUE
--     CACHE 1;
--
-- Structure for table section (OID = 26911) : 
--
CREATE TABLE public.section (
    idsection serial NOT NULL,
    idinterview integer NOT NULL,
    name varchar(128),
    description varchar(128),
    section_order integer DEFAULT 1 NOT NULL
) WITHOUT OIDS;
--
-- Definition for sequence text_idtext_seq (OID = 26921) : 
--
-- CREATE SEQUENCE public.text_idtext_seq
--     START WITH 1
--     INCREMENT BY 1
--     NO MAXVALUE
--     NO MINVALUE
--     CACHE 1;
--
-- Structure for table text (OID = 26923) : 
--
CREATE TABLE public.text (
    idtext serial NOT NULL,
    idsection integer NOT NULL,
    content varchar(10240) NOT NULL,
    "order" integer
) WITHOUT OIDS;
--
-- Structure for table can_be (OID = 26936) : 
--
CREATE TABLE public.can_be (
    idtext integer NOT NULL,
    idquestion integer NOT NULL
) WITHOUT OIDS;
--
-- Definition for sequence interviewee_idinterviewee_seq (OID = 26972) : 
--
-- CREATE SEQUENCE public.interviewee_idinterviewee_seq
--     START WITH 1
--     INCREMENT BY 1
--     NO MAXVALUE
--     NO MINVALUE
--     CACHE 1;
--
-- Structure for table interviewee (OID = 26974) : 
--
CREATE TABLE public.interviewee (
    idinterviewee serial NOT NULL,
    externalid integer
) WITHOUT OIDS;
--
-- Definition for sequence performance_idperformance_seq (OID = 26980) : 
--
-- CREATE SEQUENCE public.performance_idperformance_seq
--     START WITH 1
--     INCREMENT BY 1
--     NO MAXVALUE
--     NO MINVALUE
--     CACHE 1;
--
-- Structure for table performance (OID = 26982) : 
--
CREATE TABLE public.performance (
    idperformance serial NOT NULL,
    idinterview integer NOT NULL,
    date date,
    place varchar(256),
    num_order integer
) WITHOUT OIDS;
--
-- Definition for sequence realize_performance_idrealize_seq (OID = 26996) : 
--
-- CREATE SEQUENCE public.realize_performance_idrealize_seq
--     START WITH 1
--     INCREMENT BY 1
--     NO MAXVALUE
--     NO MINVALUE
--     CACHE 1;
--
-- Structure for table realize_performance (OID = 26998) : 
--
CREATE TABLE public.realize_performance (
    idrealize serial NOT NULL,
    idinterviewee integer NOT NULL,
    idperformance integer NOT NULL,
    iduser integer NOT NULL
) WITHOUT OIDS;
--
-- Definition for sequence hibernate_sequence (OID = 28126) : 
--
CREATE SEQUENCE public.hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Structure for table hasrole (OID = 28353) : 
--
CREATE TABLE public.hasrole (
    idhasrole serial NOT NULL,
    idapprole integer,
    idappuser integer
) WITHOUT OIDS;
--
-- Structure for table approle (OID = 28357) : 
--
CREATE TABLE public.approle (
    idrole integer NOT NULL,
    description varchar(255),
    name varchar(255)
) WITHOUT OIDS;
--
-- Definition for sequence approle_idrole_seq (OID = 28374) : 
--
CREATE SEQUENCE public.approle_idrole_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence hasrole_idhasrole_seq (OID = 28376) : 
--
CREATE SEQUENCE public.hasrole_idhasrole_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for index answer_pk (OID = 26878) : 
--
CREATE UNIQUE INDEX answer_pk ON answer USING btree (idanswer);
--
-- Definition for index isresponded_fk (OID = 26879) : 
--
CREATE INDEX isresponded_fk ON answer USING btree (idquestion);
--
-- Definition for index answertype_pk (OID = 26880) : 
--
CREATE UNIQUE INDEX answertype_pk ON answertype USING btree (idanstype);
--
-- Definition for index appuser_pk (OID = 26896) : 
--
CREATE UNIQUE INDEX appuser_pk ON appuser USING btree (iduser);
--
-- Definition for index can_be_pk (OID = 26950) : 
--
CREATE UNIQUE INDEX can_be_pk ON can_be USING btree (idtext, idquestion);
--
-- Definition for index can_be_fk (OID = 26951) : 
--
CREATE INDEX can_be_fk ON can_be USING btree (idtext);
--
-- Definition for index can_be2_fk (OID = 26952) : 
--
CREATE INDEX can_be2_fk ON can_be USING btree (idquestion);
--
-- Definition for index interview_pk (OID = 26970) : 
--
CREATE UNIQUE INDEX interview_pk ON interview USING btree (idinterview);
--
-- Definition for index develop_fk (OID = 26971) : 
--
CREATE INDEX develop_fk ON interview USING btree (iduser);
--
-- Definition for index interviewee_pk (OID = 26979) : 
--
CREATE UNIQUE INDEX interviewee_pk ON interviewee USING btree (idinterviewee);
--
-- Definition for index performance_pk (OID = 26992) : 
--
CREATE UNIQUE INDEX performance_pk ON performance USING btree (idperformance);
--
-- Definition for index isrealized_fk (OID = 26993) : 
--
CREATE INDEX isrealized_fk ON performance USING btree (idinterview);
--
-- Definition for index question_pk (OID = 26994) : 
--
CREATE UNIQUE INDEX question_pk ON question USING btree (idquestion);
--
-- Definition for index hastype_fk (OID = 26995) : 
--
CREATE INDEX hastype_fk ON question USING btree (idanstype);
--
-- Definition for index realize_performance_pk (OID = 27018) : 
--
CREATE UNIQUE INDEX realize_performance_pk ON realize_performance USING btree (idrealize);
--
-- Definition for index user_realize_fk (OID = 27019) : 
--
CREATE INDEX user_realize_fk ON realize_performance USING btree (iduser);
--
-- Definition for index performance_realize_fk (OID = 27020) : 
--
CREATE INDEX performance_realize_fk ON realize_performance USING btree (idperformance);
--
-- Definition for index interviewee_realize_fk (OID = 27021) : 
--
CREATE INDEX interviewee_realize_fk ON realize_performance USING btree (idinterviewee);
--
-- Definition for index section_pk (OID = 27022) : 
--
CREATE UNIQUE INDEX section_pk ON section USING btree (idsection);
--
-- Definition for index is_composed_fk (OID = 27023) : 
--
CREATE INDEX is_composed_fk ON section USING btree (idinterview);
--
-- Definition for index text_pk (OID = 27024) : 
--
CREATE UNIQUE INDEX text_pk ON text USING btree (idtext);
--
-- Definition for index is_formed_fk (OID = 27025) : 
--
CREATE INDEX is_formed_fk ON text USING btree (idsection);
--
-- Definition for index pg_ts_dict_pkey (OID = 16647) : 
--
ALTER TABLE ONLY pg_ts_dict
    ADD CONSTRAINT pg_ts_dict_pkey PRIMARY KEY (dict_name);
--
-- Definition for index pg_ts_parser_pkey (OID = 16673) : 
--
ALTER TABLE ONLY pg_ts_parser
    ADD CONSTRAINT pg_ts_parser_pkey PRIMARY KEY (prs_name);
--
-- Definition for index pg_ts_cfg_pkey (OID = 16698) : 
--
ALTER TABLE ONLY pg_ts_cfg
    ADD CONSTRAINT pg_ts_cfg_pkey PRIMARY KEY (ts_name);
--
-- Definition for index pg_ts_cfgmap_pkey (OID = 16705) : 
--
ALTER TABLE ONLY pg_ts_cfgmap
    ADD CONSTRAINT pg_ts_cfgmap_pkey PRIMARY KEY (ts_name, tok_alias);
--
-- Definition for index pk_answertype (OID = 26852) : 
--
ALTER TABLE ONLY answertype
    ADD CONSTRAINT pk_answertype PRIMARY KEY (idanstype);
--
-- Definition for index pk_question (OID = 26859) : 
--
ALTER TABLE ONLY question
    ADD CONSTRAINT pk_question PRIMARY KEY (idquestion);
--
-- Definition for index fk_question_hastype_answerty (OID = 26861) : 
--
ALTER TABLE ONLY question
    ADD CONSTRAINT fk_question_hastype_answerty FOREIGN KEY (idanstype) REFERENCES answertype(idanstype) ON UPDATE RESTRICT ON DELETE CASCADE;
--
-- Definition for index pk_answer (OID = 26871) : 
--
ALTER TABLE ONLY answer
    ADD CONSTRAINT pk_answer PRIMARY KEY (idanswer);
--
-- Definition for index fk_answer_isrespond_question (OID = 26873) : 
--
ALTER TABLE ONLY answer
    ADD CONSTRAINT fk_answer_isrespond_question FOREIGN KEY (idquestion) REFERENCES question(idquestion) ON UPDATE RESTRICT ON DELETE CASCADE;
--
-- Definition for index pk_appuser (OID = 26894) : 
--
ALTER TABLE ONLY appuser
    ADD CONSTRAINT pk_appuser PRIMARY KEY (iduser);
--
-- Definition for index pk_interview (OID = 26902) : 
--
ALTER TABLE ONLY interview
    ADD CONSTRAINT pk_interview PRIMARY KEY (idinterview);
--
-- Definition for index fk_intervie_develop_appuser (OID = 26904) : 
--
ALTER TABLE ONLY interview
    ADD CONSTRAINT fk_intervie_develop_appuser FOREIGN KEY (iduser) REFERENCES appuser(iduser) ON UPDATE RESTRICT ON DELETE CASCADE;
--
-- Definition for index pk_section (OID = 26914) : 
--
ALTER TABLE ONLY section
    ADD CONSTRAINT pk_section PRIMARY KEY (idsection);
--
-- Definition for index fk_section_is_compos_intervie (OID = 26916) : 
--
ALTER TABLE ONLY section
    ADD CONSTRAINT fk_section_is_compos_intervie FOREIGN KEY (idinterview) REFERENCES interview(idinterview) ON UPDATE RESTRICT ON DELETE CASCADE;
--
-- Definition for index pk_text (OID = 26929) : 
--
ALTER TABLE ONLY text
    ADD CONSTRAINT pk_text PRIMARY KEY (idtext);
--
-- Definition for index fk_text_is_formed_section (OID = 26931) : 
--
ALTER TABLE ONLY text
    ADD CONSTRAINT fk_text_is_formed_section FOREIGN KEY (idsection) REFERENCES section(idsection) ON UPDATE RESTRICT ON DELETE CASCADE;
--
-- Definition for index pk_can_be (OID = 26938) : 
--
ALTER TABLE ONLY can_be
    ADD CONSTRAINT pk_can_be PRIMARY KEY (idtext, idquestion);
--
-- Definition for index fk_can_be_can_be_text (OID = 26940) : 
--
ALTER TABLE ONLY can_be
    ADD CONSTRAINT fk_can_be_can_be_text FOREIGN KEY (idtext) REFERENCES text(idtext) ON UPDATE RESTRICT ON DELETE CASCADE;
--
-- Definition for index fk_can_be_can_be2_question (OID = 26945) : 
--
ALTER TABLE ONLY can_be
    ADD CONSTRAINT fk_can_be_can_be2_question FOREIGN KEY (idquestion) REFERENCES question(idquestion) ON UPDATE RESTRICT ON DELETE CASCADE;
--
-- Definition for index pk_interviewee (OID = 26977) : 
--
ALTER TABLE ONLY interviewee
    ADD CONSTRAINT pk_interviewee PRIMARY KEY (idinterviewee);
--
-- Definition for index pk_performance (OID = 26985) : 
--
ALTER TABLE ONLY performance
    ADD CONSTRAINT pk_performance PRIMARY KEY (idperformance);
--
-- Definition for index fk_performa_isrealize_intervie (OID = 26987) : 
--
ALTER TABLE ONLY performance
    ADD CONSTRAINT fk_performa_isrealize_intervie FOREIGN KEY (idinterview) REFERENCES interview(idinterview) ON UPDATE RESTRICT ON DELETE CASCADE;
--
-- Definition for index pk_realize_performance (OID = 27001) : 
--
ALTER TABLE ONLY realize_performance
    ADD CONSTRAINT pk_realize_performance PRIMARY KEY (idrealize);
--
-- Definition for index fk_realize__user_real_appuser (OID = 27003) : 
--
ALTER TABLE ONLY realize_performance
    ADD CONSTRAINT fk_realize__user_real_appuser FOREIGN KEY (iduser) REFERENCES appuser(iduser) ON UPDATE RESTRICT ON DELETE CASCADE;
--
-- Definition for index fk_realize__performan_performa (OID = 27008) : 
--
ALTER TABLE ONLY realize_performance
    ADD CONSTRAINT fk_realize__performan_performa FOREIGN KEY (idperformance) REFERENCES performance(idperformance) ON UPDATE RESTRICT ON DELETE CASCADE;
--
-- Definition for index fk_realize__interview_intervie (OID = 27013) : 
--
ALTER TABLE ONLY realize_performance
    ADD CONSTRAINT fk_realize__interview_intervie FOREIGN KEY (idinterviewee) REFERENCES interviewee(idinterviewee) ON UPDATE RESTRICT ON DELETE CASCADE;
--
-- Definition for index hasrole_pkey (OID = 28355) : 
--
ALTER TABLE ONLY hasrole
    ADD CONSTRAINT hasrole_pkey PRIMARY KEY (idhasrole);
--
-- Definition for index approle_pkey (OID = 28362) : 
--
ALTER TABLE ONLY approle
    ADD CONSTRAINT approle_pkey PRIMARY KEY (idrole);
--
-- Definition for index fk5463c1f018da8a2b (OID = 28364) : 
--
ALTER TABLE ONLY hasrole
    ADD CONSTRAINT fk5463c1f018da8a2b FOREIGN KEY (idappuser) REFERENCES appuser(iduser);
--
-- Definition for index fk5463c1f018d7b381 (OID = 28369) : 
--
ALTER TABLE ONLY hasrole
    ADD CONSTRAINT fk5463c1f018d7b381 FOREIGN KEY (idapprole) REFERENCES approle(idrole);
--
-- Definition for index fk_question_text (OID = 28378) : 
--
ALTER TABLE ONLY question
    ADD CONSTRAINT fk_question_text FOREIGN KEY (codtext) REFERENCES text(idtext) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Comments
--
COMMENT ON SCHEMA public IS 'Standard public schema';
COMMENT ON COLUMN public.question.mandatory IS 'This field indicates whether or not a question gotta be answered';
COMMENT ON COLUMN public.question.codtext IS 'Reference to the heading text for this question';
COMMENT ON COLUMN public.section."order" IS 'The order of this section in the interview';
COMMENT ON COLUMN public.text."order" IS 'The hipothetical order of this text in a section. For presentation purposes only';
