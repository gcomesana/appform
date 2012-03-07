--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'Standard public schema';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: answer; Type: TABLE; Schema: public; Owner: gcomesana; Tablespace: 
--

CREATE TABLE answer (
    idanswer integer NOT NULL,
    thevalue character varying(512),
    answer_order integer,
    codansitem integer NOT NULL
);


--
-- Name: answer_item; Type: TABLE; Schema: public; Owner: gcomesana; Tablespace: 
--

CREATE TABLE answer_item (
    idansitem integer NOT NULL,
    answer_order integer,
    name character varying(128),
    description character varying(128)
);



--
-- Name: answertype; Type: TABLE; Schema: public; Owner: gcomesana; Tablespace: 
--

CREATE TABLE answertype (
    idanstype integer NOT NULL,
    pattern character varying(256)
);


--
-- Name: appgroup; Type: TABLE; Schema: public; Owner: gcomesana; Tablespace: 
--

CREATE TABLE appgroup (
    idgroup integer NOT NULL,
    name character varying(128),
    codgroup character varying(128)
);



--
-- Name: appuser; Type: TABLE; Schema: public; Owner: gcomesana; Tablespace: 
--

CREATE TABLE appuser (
    iduser integer NOT NULL,
    username character varying(128) NOT NULL,
    passwd character varying(128) NOT NULL,
    c_date timestamp without time zone DEFAULT now(),
    u_date timestamp without time zone,
    codhosp integer,
    country character varying(16)
);



--
-- Name: enumitem; Type: TABLE; Schema: public; Owner: gcomesana; Tablespace: 
--

CREATE TABLE enumitem (
    idenumitem integer NOT NULL,
    codenumtype integer NOT NULL,
    name character varying(128),
    description character varying(128),
    thevalue character varying(256),
    listorder integer
);



--
-- Name: enumtype; Type: TABLE; Schema: public; Owner: gcomesana; Tablespace: 
--

CREATE TABLE enumtype (
    idenumtype integer NOT NULL,
    numitems integer
);


--
-- Name: hospital; Type: TABLE; Schema: public; Owner: gcomesana; Tablespace: 
--

CREATE TABLE hospital (
    idhosp integer NOT NULL,
    name character varying(128) NOT NULL,
    hospcod integer NOT NULL,
    c_date timestamp without time zone DEFAULT now(),
    u_date timestamp without time zone
);


--
-- Name: interview; Type: TABLE; Schema: public; Owner: gcomesana; Tablespace: 
--

CREATE TABLE interview (
    idinterview integer NOT NULL,
    name character varying(128),
    description character varying(128),
    codprj integer,
    codusr integer,
    c_date timestamp without time zone DEFAULT now(),
    u_date timestamp without time zone
);


--
-- Name: intr_instance; Type: TABLE; Schema: public; Owner: gcomesana; Tablespace: 
--

CREATE TABLE intr_instance (
    idinstance integer NOT NULL,
    place character varying(256),
    date_ini timestamp without time zone,
    date_end timestamp without time zone,
    codinterview integer NOT NULL
);


--
-- Name: item; Type: TABLE; Schema: public; Owner: gcomesana; Tablespace: 
--

CREATE TABLE item (
    iditem integer NOT NULL,
    idsection integer,
    ite_iditem integer,
    content character varying(10240),
    item_order integer,
    c_date timestamp without time zone DEFAULT now(),
    u_date timestamp without time zone,
    "repeatable" integer,
    highlight integer DEFAULT 0
);


--
-- Name: pat_gives_answer2ques; Type: TABLE; Schema: public; Owner: gcomesana; Tablespace: 
--

CREATE TABLE pat_gives_answer2ques (
    idp_a_q integer NOT NULL,
    codpat integer,
    codanswer integer,
    codquestion integer,
    answer_number integer,
    answer_order integer,
    answer_grp integer
);


--
-- Name: patient; Type: TABLE; Schema: public; Owner: gcomesana; Tablespace: 
--

CREATE TABLE patient (
    idpat integer NOT NULL,
    name character varying(256),
    codpatient character varying(15) NOT NULL,
    address character varying(512),
    phone character varying(20),
    numhc character varying(32),
    c_date timestamp without time zone DEFAULT now(),
    u_date timestamp without time zone
);


--
-- Name: performance; Type: TABLE; Schema: public; Owner: gcomesana; Tablespace: 
--

CREATE TABLE performance (
    idperformance integer NOT NULL,
    coduser integer,
    codinterview integer,
    codpat integer,
    date_ini timestamp without time zone,
    date_end timestamp without time zone,
    place character varying(256),
    num_order integer,
    last_sec integer DEFAULT 1
);


--
-- Name: project; Type: TABLE; Schema: public; Owner: gcomesana; Tablespace: 
--

CREATE TABLE project (
    idprj integer NOT NULL,
    name character varying(128),
    description character varying(128),
    c_date timestamp without time zone DEFAULT now(),
    u_date timestamp without time zone
);


--
-- Name: question; Type: TABLE; Schema: public; Owner: gcomesana; Tablespace: 
--

CREATE TABLE question (
    idquestion integer NOT NULL,
    "repeatable" integer,
    codquestion character varying(16),
    mandatory integer DEFAULT 0
);


--
-- Name: question_ansitem; Type: TABLE; Schema: public; Owner: gcomesana; Tablespace: 
--

CREATE TABLE question_ansitem (
    id integer NOT NULL,
    codansitem integer NOT NULL,
    codquestion integer NOT NULL,
    answer_order integer,
    pattern character varying(255)
);


--
-- Name: rel_grp_appusr; Type: TABLE; Schema: public; Owner: gcomesana; Tablespace: 
--

CREATE TABLE rel_grp_appusr (
    idgrp_usr integer NOT NULL,
    codgroup integer NOT NULL,
    coduser integer NOT NULL
);


--
-- Name: rel_prj_appusers; Type: TABLE; Schema: public; Owner: gcomesana; Tablespace: 
--

CREATE TABLE rel_prj_appusers (
    idprj_usrs integer NOT NULL,
    codprj integer NOT NULL,
    coduser integer NOT NULL
);


--
-- Name: role; Type: TABLE; Schema: public; Owner: gcomesana; Tablespace: 
--

CREATE TABLE "role" (
    idrole integer NOT NULL,
    name character varying(128),
    description character varying(128),
    c_date timestamp without time zone DEFAULT now(),
    u_date timestamp without time zone
);


--
-- Name: section; Type: TABLE; Schema: public; Owner: gcomesana; Tablespace: 
--

CREATE TABLE section (
    idsection integer NOT NULL,
    name character varying(128),
    description character varying(128),
    section_order integer,
    codinterview integer,
    c_date timestamp without time zone DEFAULT now(),
    u_date timestamp without time zone
);


--
-- Name: text; Type: TABLE; Schema: public; Owner: gcomesana; Tablespace: 
--

CREATE TABLE text (
    idtext integer NOT NULL,
    highlighted integer
);


--
-- Name: user_role; Type: TABLE; Schema: public; Owner: gcomesana; Tablespace: 
--

CREATE TABLE user_role (
    iduser_role integer NOT NULL,
    coduser integer NOT NULL,
    codrole integer NOT NULL,
    username character varying(128),
    rolename character varying(128)
);


--
-- Name: usr_pat_intrinst; Type: TABLE; Schema: public; Owner: gcomesana; Tablespace: 
--

CREATE TABLE usr_pat_intrinst (
    id_upi integer NOT NULL,
    coduser integer NOT NULL,
    codpatient integer NOT NULL,
    codintr_ins integer NOT NULL
);


--
-- Name: answer_idanswer_seq; Type: SEQUENCE; Schema: public; Owner: gcomesana
--

CREATE SEQUENCE answer_idanswer_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: answer_item_idansitem_seq; Type: SEQUENCE; Schema: public; Owner: gcomesana
--

CREATE SEQUENCE answer_item_idansitem_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: appgroup_idgroup_seq; Type: SEQUENCE; Schema: public; Owner: gcomesana
--

CREATE SEQUENCE appgroup_idgroup_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: appuser_iduser_seq; Type: SEQUENCE; Schema: public; Owner: gcomesana
--

CREATE SEQUENCE appuser_iduser_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: enumitem_idenumitem_seq; Type: SEQUENCE; Schema: public; Owner: gcomesana
--

CREATE SEQUENCE enumitem_idenumitem_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: hospital_idhosp_seq; Type: SEQUENCE; Schema: public; Owner: gcomesana
--

CREATE SEQUENCE hospital_idhosp_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: interview_idinterview_seq; Type: SEQUENCE; Schema: public; Owner: gcomesana
--

CREATE SEQUENCE interview_idinterview_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: intr_instance_idinstance_seq; Type: SEQUENCE; Schema: public; Owner: gcomesana
--

CREATE SEQUENCE intr_instance_idinstance_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: item_iditem_seq; Type: SEQUENCE; Schema: public; Owner: gcomesana
--

CREATE SEQUENCE item_iditem_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: pat_gives_answer2ques_idp_a_q_seq; Type: SEQUENCE; Schema: public; Owner: gcomesana
--

CREATE SEQUENCE pat_gives_answer2ques_idp_a_q_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: patient_idpat_seq; Type: SEQUENCE; Schema: public; Owner: gcomesana
--

CREATE SEQUENCE patient_idpat_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: patient_idpatient_seq; Type: SEQUENCE; Schema: public; Owner: gcomesana
--

CREATE SEQUENCE patient_idpatient_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: performance_idperformance_seq; Type: SEQUENCE; Schema: public; Owner: gcomesana
--

CREATE SEQUENCE performance_idperformance_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: project_idprj_seq; Type: SEQUENCE; Schema: public; Owner: gcomesana
--

CREATE SEQUENCE project_idprj_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: project_idproject_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE project_idproject_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: question_ansitem_id_seq; Type: SEQUENCE; Schema: public; Owner: gcomesana
--

CREATE SEQUENCE question_ansitem_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: question_idquestion_seq; Type: SEQUENCE; Schema: public; Owner: gcomesana
--

CREATE SEQUENCE question_idquestion_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: rel_grp_appusr_idgrp_usr_seq; Type: SEQUENCE; Schema: public; Owner: gcomesana
--

CREATE SEQUENCE rel_grp_appusr_idgrp_usr_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: rel_prj_appusers_idprj_usrs_seq; Type: SEQUENCE; Schema: public; Owner: gcomesana
--

CREATE SEQUENCE rel_prj_appusers_idprj_usrs_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: role_idrole_seq; Type: SEQUENCE; Schema: public; Owner: gcomesana
--

CREATE SEQUENCE role_idrole_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: section_idsection_seq; Type: SEQUENCE; Schema: public; Owner: gcomesana
--

CREATE SEQUENCE section_idsection_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: text_idtext_seq; Type: SEQUENCE; Schema: public; Owner: gcomesana
--

CREATE SEQUENCE text_idtext_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: user_role_iduser_role_seq; Type: SEQUENCE; Schema: public; Owner: gcomesana
--

CREATE SEQUENCE user_role_iduser_role_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: usr_pat_intrinst_id_upi_seq; Type: SEQUENCE; Schema: public; Owner: gcomesana
--

CREATE SEQUENCE usr_pat_intrinst_id_upi_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: idanswer; Type: DEFAULT; Schema: public; Owner: gcomesana
--

ALTER TABLE answer ALTER COLUMN idanswer SET DEFAULT nextval('answer_idanswer_seq'::regclass);


--
-- Name: idansitem; Type: DEFAULT; Schema: public; Owner: gcomesana
--

ALTER TABLE answer_item ALTER COLUMN idansitem SET DEFAULT nextval('answer_item_idansitem_seq'::regclass);


--
-- Name: idgroup; Type: DEFAULT; Schema: public; Owner: gcomesana
--

ALTER TABLE appgroup ALTER COLUMN idgroup SET DEFAULT nextval('appgroup_idgroup_seq'::regclass);


--
-- Name: iduser; Type: DEFAULT; Schema: public; Owner: gcomesana
--

ALTER TABLE appuser ALTER COLUMN iduser SET DEFAULT nextval('appuser_iduser_seq'::regclass);


--
-- Name: idenumitem; Type: DEFAULT; Schema: public; Owner: gcomesana
--

ALTER TABLE enumitem ALTER COLUMN idenumitem SET DEFAULT nextval('enumitem_idenumitem_seq'::regclass);


--
-- Name: idhosp; Type: DEFAULT; Schema: public; Owner: gcomesana
--

ALTER TABLE hospital ALTER COLUMN idhosp SET DEFAULT nextval('hospital_idhosp_seq'::regclass);


--
-- Name: idinterview; Type: DEFAULT; Schema: public; Owner: gcomesana
--

ALTER TABLE interview ALTER COLUMN idinterview SET DEFAULT nextval('interview_idinterview_seq'::regclass);


--
-- Name: idinstance; Type: DEFAULT; Schema: public; Owner: gcomesana
--

ALTER TABLE intr_instance ALTER COLUMN idinstance SET DEFAULT nextval('intr_instance_idinstance_seq'::regclass);


--
-- Name: iditem; Type: DEFAULT; Schema: public; Owner: gcomesana
--

ALTER TABLE item ALTER COLUMN iditem SET DEFAULT nextval('item_iditem_seq'::regclass);


--
-- Name: idp_a_q; Type: DEFAULT; Schema: public; Owner: gcomesana
--

ALTER TABLE pat_gives_answer2ques ALTER COLUMN idp_a_q SET DEFAULT nextval('pat_gives_answer2ques_idp_a_q_seq'::regclass);


--
-- Name: idpat; Type: DEFAULT; Schema: public; Owner: gcomesana
--

ALTER TABLE patient ALTER COLUMN idpat SET DEFAULT nextval('patient_idpat_seq'::regclass);


--
-- Name: idperformance; Type: DEFAULT; Schema: public; Owner: gcomesana
--

ALTER TABLE performance ALTER COLUMN idperformance SET DEFAULT nextval('performance_idperformance_seq'::regclass);


--
-- Name: idprj; Type: DEFAULT; Schema: public; Owner: gcomesana
--

ALTER TABLE project ALTER COLUMN idprj SET DEFAULT nextval('project_idprj_seq'::regclass);


--
-- Name: idquestion; Type: DEFAULT; Schema: public; Owner: gcomesana
--

ALTER TABLE question ALTER COLUMN idquestion SET DEFAULT nextval('question_idquestion_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: gcomesana
--

ALTER TABLE question_ansitem ALTER COLUMN id SET DEFAULT nextval('question_ansitem_id_seq'::regclass);


--
-- Name: idgrp_usr; Type: DEFAULT; Schema: public; Owner: gcomesana
--

ALTER TABLE rel_grp_appusr ALTER COLUMN idgrp_usr SET DEFAULT nextval('rel_grp_appusr_idgrp_usr_seq'::regclass);


--
-- Name: idprj_usrs; Type: DEFAULT; Schema: public; Owner: gcomesana
--

ALTER TABLE rel_prj_appusers ALTER COLUMN idprj_usrs SET DEFAULT nextval('rel_prj_appusers_idprj_usrs_seq'::regclass);


--
-- Name: idrole; Type: DEFAULT; Schema: public; Owner: gcomesana
--

ALTER TABLE "role" ALTER COLUMN idrole SET DEFAULT nextval('role_idrole_seq'::regclass);


--
-- Name: idsection; Type: DEFAULT; Schema: public; Owner: gcomesana
--

ALTER TABLE section ALTER COLUMN idsection SET DEFAULT nextval('section_idsection_seq'::regclass);


--
-- Name: idtext; Type: DEFAULT; Schema: public; Owner: gcomesana
--

ALTER TABLE text ALTER COLUMN idtext SET DEFAULT nextval('text_idtext_seq'::regclass);


--
-- Name: iduser_role; Type: DEFAULT; Schema: public; Owner: gcomesana
--

ALTER TABLE user_role ALTER COLUMN iduser_role SET DEFAULT nextval('user_role_iduser_role_seq'::regclass);


--
-- Name: id_upi; Type: DEFAULT; Schema: public; Owner: gcomesana
--

ALTER TABLE usr_pat_intrinst ALTER COLUMN id_upi SET DEFAULT nextval('usr_pat_intrinst_id_upi_seq'::regclass);


--
-- Name: pk_answer; Type: CONSTRAINT; Schema: public; Owner: gcomesana; Tablespace: 
--

ALTER TABLE ONLY answer
    ADD CONSTRAINT pk_answer PRIMARY KEY (idanswer);


--
-- Name: pk_answer_item; Type: CONSTRAINT; Schema: public; Owner: gcomesana; Tablespace: 
--

ALTER TABLE ONLY answer_item
    ADD CONSTRAINT pk_answer_item PRIMARY KEY (idansitem);


--
-- Name: pk_answertype; Type: CONSTRAINT; Schema: public; Owner: gcomesana; Tablespace: 
--

ALTER TABLE ONLY answertype
    ADD CONSTRAINT pk_answertype PRIMARY KEY (idanstype);


--
-- Name: pk_appgroup; Type: CONSTRAINT; Schema: public; Owner: gcomesana; Tablespace: 
--

ALTER TABLE ONLY appgroup
    ADD CONSTRAINT pk_appgroup PRIMARY KEY (idgroup);


--
-- Name: pk_appuser; Type: CONSTRAINT; Schema: public; Owner: gcomesana; Tablespace: 
--

ALTER TABLE ONLY appuser
    ADD CONSTRAINT pk_appuser PRIMARY KEY (iduser);


--
-- Name: pk_enumitem; Type: CONSTRAINT; Schema: public; Owner: gcomesana; Tablespace: 
--

ALTER TABLE ONLY enumitem
    ADD CONSTRAINT pk_enumitem PRIMARY KEY (idenumitem);


--
-- Name: pk_enumtype; Type: CONSTRAINT; Schema: public; Owner: gcomesana; Tablespace: 
--

ALTER TABLE ONLY enumtype
    ADD CONSTRAINT pk_enumtype PRIMARY KEY (idenumtype);


--
-- Name: pk_hospital; Type: CONSTRAINT; Schema: public; Owner: gcomesana; Tablespace: 
--

ALTER TABLE ONLY hospital
    ADD CONSTRAINT pk_hospital PRIMARY KEY (idhosp);


--
-- Name: pk_interview; Type: CONSTRAINT; Schema: public; Owner: gcomesana; Tablespace: 
--

ALTER TABLE ONLY interview
    ADD CONSTRAINT pk_interview PRIMARY KEY (idinterview);


--
-- Name: pk_intr_instance; Type: CONSTRAINT; Schema: public; Owner: gcomesana; Tablespace: 
--

ALTER TABLE ONLY intr_instance
    ADD CONSTRAINT pk_intr_instance PRIMARY KEY (idinstance);


--
-- Name: pk_item; Type: CONSTRAINT; Schema: public; Owner: gcomesana; Tablespace: 
--

ALTER TABLE ONLY item
    ADD CONSTRAINT pk_item PRIMARY KEY (iditem);


--
-- Name: pk_pat_gives_answer2ques; Type: CONSTRAINT; Schema: public; Owner: gcomesana; Tablespace: 
--

ALTER TABLE ONLY pat_gives_answer2ques
    ADD CONSTRAINT pk_pat_gives_answer2ques PRIMARY KEY (idp_a_q);


--
-- Name: pk_patient; Type: CONSTRAINT; Schema: public; Owner: gcomesana; Tablespace: 
--

ALTER TABLE ONLY patient
    ADD CONSTRAINT pk_patient PRIMARY KEY (idpat);


--
-- Name: pk_performance; Type: CONSTRAINT; Schema: public; Owner: gcomesana; Tablespace: 
--

ALTER TABLE ONLY performance
    ADD CONSTRAINT pk_performance PRIMARY KEY (idperformance);


--
-- Name: pk_project; Type: CONSTRAINT; Schema: public; Owner: gcomesana; Tablespace: 
--

ALTER TABLE ONLY project
    ADD CONSTRAINT pk_project PRIMARY KEY (idprj);


--
-- Name: pk_question; Type: CONSTRAINT; Schema: public; Owner: gcomesana; Tablespace: 
--

ALTER TABLE ONLY question
    ADD CONSTRAINT pk_question PRIMARY KEY (idquestion);


--
-- Name: pk_question_ansitem; Type: CONSTRAINT; Schema: public; Owner: gcomesana; Tablespace: 
--

ALTER TABLE ONLY question_ansitem
    ADD CONSTRAINT pk_question_ansitem PRIMARY KEY (id);


--
-- Name: pk_rel_grp_appusr; Type: CONSTRAINT; Schema: public; Owner: gcomesana; Tablespace: 
--

ALTER TABLE ONLY rel_grp_appusr
    ADD CONSTRAINT pk_rel_grp_appusr PRIMARY KEY (idgrp_usr);


--
-- Name: pk_rel_prj_appusers; Type: CONSTRAINT; Schema: public; Owner: gcomesana; Tablespace: 
--

ALTER TABLE ONLY rel_prj_appusers
    ADD CONSTRAINT pk_rel_prj_appusers PRIMARY KEY (idprj_usrs);


--
-- Name: pk_role; Type: CONSTRAINT; Schema: public; Owner: gcomesana; Tablespace: 
--

ALTER TABLE ONLY "role"
    ADD CONSTRAINT pk_role PRIMARY KEY (idrole);


--
-- Name: pk_section; Type: CONSTRAINT; Schema: public; Owner: gcomesana; Tablespace: 
--

ALTER TABLE ONLY section
    ADD CONSTRAINT pk_section PRIMARY KEY (idsection);


--
-- Name: pk_text; Type: CONSTRAINT; Schema: public; Owner: gcomesana; Tablespace: 
--

ALTER TABLE ONLY text
    ADD CONSTRAINT pk_text PRIMARY KEY (idtext);


--
-- Name: pk_user_role; Type: CONSTRAINT; Schema: public; Owner: gcomesana; Tablespace: 
--

ALTER TABLE ONLY user_role
    ADD CONSTRAINT pk_user_role PRIMARY KEY (iduser_role);


--
-- Name: pk_usr_pat_intrinst; Type: CONSTRAINT; Schema: public; Owner: gcomesana; Tablespace: 
--

ALTER TABLE ONLY usr_pat_intrinst
    ADD CONSTRAINT pk_usr_pat_intrinst PRIMARY KEY (id_upi);


--
-- Name: fk143bf46a1c3f28d3; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--
/*
ALTER TABLE ONLY user_role
    ADD CONSTRAINT fk143bf46a1c3f28d3 FOREIGN KEY (codrole) REFERENCES role(idrole);


--
-- Name: fk143bf46a289fe600; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY user_role
    ADD CONSTRAINT fk143bf46a289fe600 FOREIGN KEY (coduser) REFERENCES appuser(iduser);


--
-- Name: fk1dfcd1819fb025d9; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY interview
    ADD CONSTRAINT fk1dfcd1819fb025d9 FOREIGN KEY (codusr) REFERENCES appuser(iduser);


--
-- Name: fk1dfcd181bc927c7a; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY interview
    ADD CONSTRAINT fk1dfcd181bc927c7a FOREIGN KEY (codprj) REFERENCES project(idprj);


--
-- Name: fk27b94df0028e8c; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY text
    ADD CONSTRAINT fk27b94df0028e8c FOREIGN KEY (idtext) REFERENCES item(iditem);


--
-- Name: fk317b136ead1f80; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY item
    ADD CONSTRAINT fk317b136ead1f80 FOREIGN KEY (idsection) REFERENCES section(idsection);


--
-- Name: fk317b13ee6627b7; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY item
    ADD CONSTRAINT fk317b13ee6627b7 FOREIGN KEY (ite_iditem) REFERENCES item(iditem);


--
-- Name: fk33f5054cff274c45; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY appuser
    ADD CONSTRAINT fk33f5054cff274c45 FOREIGN KEY (codhosp) REFERENCES hospital(idhosp);


--
-- Name: fk3e240fd3289fe600; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY rel_grp_appusr
    ADD CONSTRAINT fk3e240fd3289fe600 FOREIGN KEY (coduser) REFERENCES appuser(iduser);


--
-- Name: fk3e240fd3e9d1abd4; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY rel_grp_appusr
    ADD CONSTRAINT fk3e240fd3e9d1abd4 FOREIGN KEY (codgroup) REFERENCES appgroup(idgroup);


--
-- Name: fk6d9a2ea05c3d6ca1; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY question_ansitem
    ADD CONSTRAINT fk6d9a2ea05c3d6ca1 FOREIGN KEY (codansitem) REFERENCES answer_item(idansitem);


--
-- Name: fk6d9a2ea0b9245433; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY question_ansitem
    ADD CONSTRAINT fk6d9a2ea0b9245433 FOREIGN KEY (codquestion) REFERENCES question(idquestion);


--
-- Name: fk756f7ee57bd5537b; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY section
    ADD CONSTRAINT fk756f7ee57bd5537b FOREIGN KEY (codinterview) REFERENCES interview(idinterview);


--
-- Name: fk849ca7944d54c7fd; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY enumitem
    ADD CONSTRAINT fk849ca7944d54c7fd FOREIGN KEY (codenumtype) REFERENCES enumtype(idenumtype);


--
-- Name: fk886d93fbda39f0f6; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY enumtype
    ADD CONSTRAINT fk886d93fbda39f0f6 FOREIGN KEY (idenumtype) REFERENCES answer_item(idansitem);
*/

--
-- Name: fk_answer_item; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY question_ansitem
    ADD CONSTRAINT fk_answer_item FOREIGN KEY (codansitem) REFERENCES answer_item(idansitem) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_answer_rel_answ__answer_i; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY answer
    ADD CONSTRAINT fk_answer_rel_answ__answer_i FOREIGN KEY (codansitem) REFERENCES answer_item(idansitem) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_answerty_isoneof_answer_i; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY answertype
    ADD CONSTRAINT fk_answerty_isoneof_answer_i FOREIGN KEY (idanstype) REFERENCES answer_item(idansitem) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_enumitem_contains_enumtype; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY enumitem
    ADD CONSTRAINT fk_enumitem_contains_enumtype FOREIGN KEY (codenumtype) REFERENCES enumtype(idenumtype) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_enumtype_isoneof2_answer_i; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY enumtype
    ADD CONSTRAINT fk_enumtype_isoneof2_answer_i FOREIGN KEY (idenumtype) REFERENCES answer_item(idansitem) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_hospital_user; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY appuser
    ADD CONSTRAINT fk_hospital_user FOREIGN KEY (codhosp) REFERENCES hospital(idhosp) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: fk_instance_interview; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY intr_instance
    ADD CONSTRAINT fk_instance_interview FOREIGN KEY (codinterview) REFERENCES interview(idinterview) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: fk_interview_belongs_user; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY interview
    ADD CONSTRAINT fk_interview_belongs_user FOREIGN KEY (codusr) REFERENCES appuser(iduser) ON UPDATE SET DEFAULT ON DELETE SET DEFAULT;


--
-- Name: fk_interview_is_formed_project; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY interview
    ADD CONSTRAINT fk_interview_is_formed_project FOREIGN KEY (codprj) REFERENCES project(idprj) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_intr_ins_ternary_rel; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY usr_pat_intrinst
    ADD CONSTRAINT fk_intr_ins_ternary_rel FOREIGN KEY (codintr_ins) REFERENCES intr_instance(idinstance) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_item_contains_item; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY item
    ADD CONSTRAINT fk_item_contains_item FOREIGN KEY (ite_iditem) REFERENCES item(iditem) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_item_is_formed_section; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY item
    ADD CONSTRAINT fk_item_is_formed_section FOREIGN KEY (idsection) REFERENCES section(idsection) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_pat_give_rel_ans_p_answer; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY pat_gives_answer2ques
    ADD CONSTRAINT fk_pat_give_rel_ans_p_answer FOREIGN KEY (codanswer) REFERENCES answer(idanswer) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_pat_give_rel_pat_a_patient; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY pat_gives_answer2ques
    ADD CONSTRAINT fk_pat_give_rel_pat_a_patient FOREIGN KEY (codpat) REFERENCES patient(idpat) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_pat_give_rel_ques__question; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY pat_gives_answer2ques
    ADD CONSTRAINT fk_pat_give_rel_ques__question FOREIGN KEY (codquestion) REFERENCES question(idquestion) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_pat_ternary_rel; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY usr_pat_intrinst
    ADD CONSTRAINT fk_pat_ternary_rel FOREIGN KEY (codpatient) REFERENCES patient(idpat) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_performa_rel_appus_appuser; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY performance
    ADD CONSTRAINT fk_performa_rel_appus_appuser FOREIGN KEY (coduser) REFERENCES appuser(iduser) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_performa_rel_intrv_intervie; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY performance
    ADD CONSTRAINT fk_performa_rel_intrv_intervie FOREIGN KEY (codinterview) REFERENCES interview(idinterview) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_performa_rel_pat_p_patient; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY performance
    ADD CONSTRAINT fk_performa_rel_pat_p_patient FOREIGN KEY (codpat) REFERENCES patient(idpat) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_question; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY question_ansitem
    ADD CONSTRAINT fk_question FOREIGN KEY (codquestion) REFERENCES question(idquestion) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_question_itemisa2_item; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY question
    ADD CONSTRAINT fk_question_itemisa2_item FOREIGN KEY (idquestion) REFERENCES item(iditem) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_rel_grp__rel_grp_a_appgroup; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY rel_grp_appusr
    ADD CONSTRAINT fk_rel_grp__rel_grp_a_appgroup FOREIGN KEY (codgroup) REFERENCES appgroup(idgroup) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_rel_grp__rel_grp_a_appuser; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY rel_grp_appusr
    ADD CONSTRAINT fk_rel_grp__rel_grp_a_appuser FOREIGN KEY (coduser) REFERENCES appuser(iduser) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_rel_prj__rel_prj_a_appuser; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY rel_prj_appusers
    ADD CONSTRAINT fk_rel_prj__rel_prj_a_appuser FOREIGN KEY (coduser) REFERENCES appuser(iduser) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_rel_prj__rel_prj_a_project; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY rel_prj_appusers
    ADD CONSTRAINT fk_rel_prj__rel_prj_a_project FOREIGN KEY (codprj) REFERENCES project(idprj) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_section_is_formed_interview; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY section
    ADD CONSTRAINT fk_section_is_formed_interview FOREIGN KEY (codinterview) REFERENCES interview(idinterview) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_text_itemisa_item; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY text
    ADD CONSTRAINT fk_text_itemisa_item FOREIGN KEY (idtext) REFERENCES item(iditem) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_userrole_role; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY user_role
    ADD CONSTRAINT fk_userrole_role FOREIGN KEY (codrole) REFERENCES role(idrole) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_userrole_user; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY user_role
    ADD CONSTRAINT fk_userrole_user FOREIGN KEY (coduser) REFERENCES appuser(iduser) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_usr_ternary_rel; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY usr_pat_intrinst
    ADD CONSTRAINT fk_usr_ternary_rel FOREIGN KEY (coduser) REFERENCES appuser(iduser) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fka7c31030289fe600; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--
/*
ALTER TABLE ONLY performance
    ADD CONSTRAINT fka7c31030289fe600 FOREIGN KEY (coduser) REFERENCES appuser(iduser);


--
-- Name: fka7c310307bd5537b; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY performance
    ADD CONSTRAINT fka7c310307bd5537b FOREIGN KEY (codinterview) REFERENCES interview(idinterview);


--
-- Name: fka7c310309fd61a61; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY performance
    ADD CONSTRAINT fka7c310309fd61a61 FOREIGN KEY (codpat) REFERENCES patient(idpat);


--
-- Name: fkabca3fbe5c3d6ca1; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY answer
    ADD CONSTRAINT fkabca3fbe5c3d6ca1 FOREIGN KEY (codansitem) REFERENCES answer_item(idansitem);


--
-- Name: fkb00210386a4127c5; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY answertype
    ADD CONSTRAINT fkb00210386a4127c5 FOREIGN KEY (idanstype) REFERENCES answer_item(idansitem);


--
-- Name: fkba823be6e7b3fc5; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY question
    ADD CONSTRAINT fkba823be6e7b3fc5 FOREIGN KEY (idquestion) REFERENCES item(iditem);


--
-- Name: fkd0e56e24289fe600; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY rel_prj_appusers
    ADD CONSTRAINT fkd0e56e24289fe600 FOREIGN KEY (coduser) REFERENCES appuser(iduser);


--
-- Name: fkd0e56e24bc927c7a; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY rel_prj_appusers
    ADD CONSTRAINT fkd0e56e24bc927c7a FOREIGN KEY (codprj) REFERENCES project(idprj);


--
-- Name: fkd6209a2d9fd61a61; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY pat_gives_answer2ques
    ADD CONSTRAINT fkd6209a2d9fd61a61 FOREIGN KEY (codpat) REFERENCES patient(idpat);


--
-- Name: fkd6209a2db9245433; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY pat_gives_answer2ques
    ADD CONSTRAINT fkd6209a2db9245433 FOREIGN KEY (codquestion) REFERENCES question(idquestion);


--
-- Name: fkd6209a2dcefe49a3; Type: FK CONSTRAINT; Schema: public; Owner: gcomesana
--

ALTER TABLE ONLY pat_gives_answer2ques
    ADD CONSTRAINT fkd6209a2dcefe49a3 FOREIGN KEY (codanswer) REFERENCES answer(idanswer);

*/
--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

