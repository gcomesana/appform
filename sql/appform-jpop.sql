-- SQL Manager 2007 for PostgreSQL 4.3.0.1
-- ---------------------------------------
-- Host      : localhost
-- Database  : appform
-- Version   : PostgreSQL 8.2.5 on i386-apple-darwin9.3.0, compiled by GCC i686-apple-darwin9-gcc-4.0.1 (GCC) 4.0.1 (Apple Inc. build 5465)


SET search_path = public, pg_catalog;
DROP TRIGGER IF EXISTS "logAnswerUpdate" ON public.answer;
DROP TRIGGER IF EXISTS "onLogout" ON public.appuser;
DROP TRIGGER IF EXISTS "onInsertLog" ON public.applog;
ALTER TABLE ONLY public.test DROP CONSTRAINT test_pkey;
ALTER TABLE ONLY public.perf_history DROP CONSTRAINT fkbbbb053e289fe600;
ALTER TABLE ONLY public.perf_history DROP CONSTRAINT fkbbbb053ed2a39b42;
ALTER TABLE ONLY public.perf_history DROP CONSTRAINT user_history_fk;
ALTER TABLE ONLY public.perf_history DROP CONSTRAINT perf_history_fk;
ALTER TABLE ONLY public.answer_item DROP CONSTRAINT fked6a1af434d3ec6d;
ALTER TABLE ONLY public.pat_gives_answer2ques DROP CONSTRAINT fkd6209a2dcefe49a3;
ALTER TABLE ONLY public.pat_gives_answer2ques DROP CONSTRAINT fkd6209a2db9245433;
ALTER TABLE ONLY public.pat_gives_answer2ques DROP CONSTRAINT fkd6209a2d9fd61a61;
ALTER TABLE ONLY public.rel_prj_appusers DROP CONSTRAINT fkd0e56e24bc927c7a;
ALTER TABLE ONLY public.rel_prj_appusers DROP CONSTRAINT fkd0e56e24289fe600;
ALTER TABLE ONLY public.appuser DROP CONSTRAINT fkd0bc6d6cff274c45;
ALTER TABLE ONLY public.question DROP CONSTRAINT fkba823be6e7b3fc5;
ALTER TABLE ONLY public.answertype DROP CONSTRAINT fkb00210386a4127c5;
ALTER TABLE ONLY public.answer DROP CONSTRAINT fkabca3fbe5c3d6ca1;
ALTER TABLE ONLY public.performance DROP CONSTRAINT fka7c31030e9d1abd4;
ALTER TABLE ONLY public.performance DROP CONSTRAINT fka7c310309fd61a61;
ALTER TABLE ONLY public.performance DROP CONSTRAINT fka7c310307bd5537b;
ALTER TABLE ONLY public.performance DROP CONSTRAINT fka7c31030289fe600;
ALTER TABLE ONLY public.usr_pat_intrinst DROP CONSTRAINT fk_usr_ternary_rel;
ALTER TABLE ONLY public.user_role DROP CONSTRAINT fk_userrole_user;
ALTER TABLE ONLY public.user_role DROP CONSTRAINT fk_userrole_role;
ALTER TABLE ONLY public.text DROP CONSTRAINT fk_text_itemisa_item;
ALTER TABLE ONLY public.section DROP CONSTRAINT fk_section_is_formed_interview;
ALTER TABLE ONLY public.rel_prj_appusers DROP CONSTRAINT fk_rel_prj__rel_prj_a_project;
ALTER TABLE ONLY public.rel_prj_appusers DROP CONSTRAINT fk_rel_prj__rel_prj_a_appuser;
ALTER TABLE ONLY public.rel_grp_appusr DROP CONSTRAINT fk_rel_grp__rel_grp_a_appuser;
ALTER TABLE ONLY public.rel_grp_appusr DROP CONSTRAINT fk_rel_grp__rel_grp_a_appgroup;
ALTER TABLE ONLY public.question DROP CONSTRAINT fk_question_itemisa2_item;
ALTER TABLE ONLY public.question_ansitem DROP CONSTRAINT fk_question;
ALTER TABLE ONLY public.performance DROP CONSTRAINT fk_performa_rel_pat_p_patient;
ALTER TABLE ONLY public.performance DROP CONSTRAINT fk_performa_rel_intrv_intervie;
ALTER TABLE ONLY public.performance DROP CONSTRAINT fk_performa_rel_group;
ALTER TABLE ONLY public.performance DROP CONSTRAINT fk_performa_rel_appus_appuser;
ALTER TABLE ONLY public.usr_pat_intrinst DROP CONSTRAINT fk_pat_ternary_rel;
ALTER TABLE ONLY public.pat_gives_answer2ques DROP CONSTRAINT fk_pat_give_rel_ques__question;
ALTER TABLE ONLY public.pat_gives_answer2ques DROP CONSTRAINT fk_pat_give_rel_pat_a_patient;
ALTER TABLE ONLY public.pat_gives_answer2ques DROP CONSTRAINT fk_pat_give_rel_ans_p_answer;
ALTER TABLE ONLY public.appgroup DROP CONSTRAINT fk_parent_group;
ALTER TABLE ONLY public.item DROP CONSTRAINT fk_item_is_formed_section;
ALTER TABLE ONLY public.item DROP CONSTRAINT fk_item_contains_item;
ALTER TABLE ONLY public.intrv_group DROP CONSTRAINT fk_intrvgroup_intrv;
ALTER TABLE ONLY public.intrv_group DROP CONSTRAINT fk_intrvgroup_group;
ALTER TABLE ONLY public.usr_pat_intrinst DROP CONSTRAINT fk_intr_ins_ternary_rel;
ALTER TABLE ONLY public.interview DROP CONSTRAINT fk_interview_is_formed_project;
ALTER TABLE ONLY public.interview DROP CONSTRAINT fk_interview_belongs_user;
ALTER TABLE ONLY public.intr_instance DROP CONSTRAINT fk_instance_interview;
ALTER TABLE ONLY public.appuser DROP CONSTRAINT fk_hospital_user;
ALTER TABLE ONLY public.appgroup DROP CONSTRAINT fk_grouptype;
ALTER TABLE ONLY public.enumtype DROP CONSTRAINT fk_enumtype_isoneof2_answer_i;
ALTER TABLE ONLY public.enumitem DROP CONSTRAINT fk_enumitem_contains_enumtype;
ALTER TABLE ONLY public.interview DROP CONSTRAINT fk_cloned_from;
ALTER TABLE ONLY public.answertype DROP CONSTRAINT fk_answerty_isoneof_answer_i;
ALTER TABLE ONLY public.answer DROP CONSTRAINT fk_answer_rel_answ__answer_i;
ALTER TABLE ONLY public.question_ansitem DROP CONSTRAINT fk_answer_item;
ALTER TABLE ONLY public.answer_item DROP CONSTRAINT fk_ansitem_intrv;
ALTER TABLE ONLY public.enumtype DROP CONSTRAINT fk886d93fbda39f0f6;
ALTER TABLE ONLY public.intrv_group DROP CONSTRAINT fk84c0ddb3e9d1abd4;
ALTER TABLE ONLY public.intrv_group DROP CONSTRAINT fk84c0ddb334d3ec6d;
ALTER TABLE ONLY public.enumitem DROP CONSTRAINT fk849ca7944d54c7fd;
ALTER TABLE ONLY public.section DROP CONSTRAINT fk756f7ee57bd5537b;
ALTER TABLE ONLY public.question_ansitem DROP CONSTRAINT fk6d9a2ea0b9245433;
ALTER TABLE ONLY public.question_ansitem DROP CONSTRAINT fk6d9a2ea05c3d6ca1;
ALTER TABLE ONLY public.appgroup DROP CONSTRAINT fk460ba8fefa6441bc;
ALTER TABLE ONLY public.appgroup DROP CONSTRAINT fk460ba8fee20f1477;
ALTER TABLE ONLY public.rel_grp_appusr DROP CONSTRAINT fk3e240fd3e9d1abd4;
ALTER TABLE ONLY public.rel_grp_appusr DROP CONSTRAINT fk3e240fd3289fe600;
ALTER TABLE ONLY public.appuser DROP CONSTRAINT fk33f5054cff274c45;
ALTER TABLE ONLY public.item DROP CONSTRAINT fk317b13ee6627b7;
ALTER TABLE ONLY public.item DROP CONSTRAINT fk317b136ead1f80;
ALTER TABLE ONLY public.text DROP CONSTRAINT fk27b94df0028e8c;
ALTER TABLE ONLY public.interview DROP CONSTRAINT fk1dfcd181bc927c7a;
ALTER TABLE ONLY public.interview DROP CONSTRAINT fk1dfcd1819fb025d9;
ALTER TABLE ONLY public.interview DROP CONSTRAINT fk1dfcd18132dc448d;
ALTER TABLE ONLY public.user_role DROP CONSTRAINT fk143bf46a289fe600;
ALTER TABLE ONLY public.user_role DROP CONSTRAINT fk143bf46a1c3f28d3;
ALTER TABLE ONLY public.usr_pat_intrinst DROP CONSTRAINT pk_usr_pat_intrinst;
ALTER TABLE ONLY public.user_role DROP CONSTRAINT pk_user_role;
ALTER TABLE ONLY public.text DROP CONSTRAINT pk_text;
ALTER TABLE ONLY public.section DROP CONSTRAINT pk_section;
ALTER TABLE ONLY public.role DROP CONSTRAINT pk_role;
ALTER TABLE ONLY public.rel_prj_appusers DROP CONSTRAINT pk_rel_prj_appusers;
ALTER TABLE ONLY public.rel_grp_appusr DROP CONSTRAINT pk_rel_grp_appusr;
ALTER TABLE ONLY public.question_ansitem DROP CONSTRAINT pk_question_ansitem;
ALTER TABLE ONLY public.question DROP CONSTRAINT pk_question;
ALTER TABLE ONLY public.project DROP CONSTRAINT pk_project;
ALTER TABLE ONLY public.performance DROP CONSTRAINT pk_performance;
ALTER TABLE ONLY public.patient DROP CONSTRAINT pk_patient;
ALTER TABLE ONLY public.pat_gives_answer2ques DROP CONSTRAINT pk_pat_gives_answer2ques;
ALTER TABLE ONLY public.item DROP CONSTRAINT pk_item;
ALTER TABLE ONLY public.intrv_group DROP CONSTRAINT pk_intrv_group;
ALTER TABLE ONLY public.intr_instance DROP CONSTRAINT pk_intr_instance;
ALTER TABLE ONLY public.interview DROP CONSTRAINT pk_interview;
ALTER TABLE ONLY public.hospital DROP CONSTRAINT pk_hospital;
ALTER TABLE ONLY public.grouptype DROP CONSTRAINT pk_grouptype;
ALTER TABLE ONLY public.enumtype DROP CONSTRAINT pk_enumtype;
ALTER TABLE ONLY public.enumitem DROP CONSTRAINT pk_enumitem;
ALTER TABLE ONLY public.appuser DROP CONSTRAINT pk_appuser;
ALTER TABLE ONLY public.appgroup DROP CONSTRAINT pk_appgroup;
ALTER TABLE ONLY public.answertype DROP CONSTRAINT pk_answertype;
ALTER TABLE ONLY public.answer_item DROP CONSTRAINT pk_answer_item;
ALTER TABLE ONLY public.answer DROP CONSTRAINT pk_answer;
ALTER TABLE ONLY public.perf_history DROP CONSTRAINT perf_history_pkey;
ALTER TABLE ONLY public.applog DROP CONSTRAINT applog_pkey;
DROP TABLE IF EXISTS public.mydata;
DROP TABLE IF EXISTS public.test;
DROP SEQUENCE IF EXISTS public.test_idtest_seq;
DROP FUNCTION IF EXISTS public.log_upd_answer ();
DROP FUNCTION IF EXISTS public.dearmor (pg_catalog.text);
DROP FUNCTION IF EXISTS public.armor (bytea);
DROP FUNCTION IF EXISTS public.pgp_key_id (bytea);
DROP FUNCTION IF EXISTS public.pgp_pub_decrypt_bytea (bytea, bytea, pg_catalog.text, pg_catalog.text);
DROP FUNCTION IF EXISTS public.pgp_pub_decrypt (bytea, bytea, pg_catalog.text, pg_catalog.text);
DROP FUNCTION IF EXISTS public.pgp_pub_decrypt_bytea (bytea, bytea, pg_catalog.text);
DROP FUNCTION IF EXISTS public.pgp_pub_decrypt (bytea, bytea, pg_catalog.text);
DROP FUNCTION IF EXISTS public.pgp_pub_decrypt_bytea (bytea, bytea);
DROP FUNCTION IF EXISTS public.pgp_pub_decrypt (bytea, bytea);
DROP FUNCTION IF EXISTS public.pgp_pub_encrypt_bytea (bytea, bytea, pg_catalog.text);
DROP FUNCTION IF EXISTS public.pgp_pub_encrypt (pg_catalog.text, bytea, pg_catalog.text);
DROP FUNCTION IF EXISTS public.pgp_pub_encrypt_bytea (bytea, bytea);
DROP FUNCTION IF EXISTS public.pgp_pub_encrypt (pg_catalog.text, bytea);
DROP FUNCTION IF EXISTS public.pgp_sym_decrypt_bytea (bytea, pg_catalog.text, pg_catalog.text);
DROP FUNCTION IF EXISTS public.pgp_sym_decrypt (bytea, pg_catalog.text, pg_catalog.text);
DROP FUNCTION IF EXISTS public.pgp_sym_decrypt_bytea (bytea, pg_catalog.text);
DROP FUNCTION IF EXISTS public.pgp_sym_decrypt (bytea, pg_catalog.text);
DROP FUNCTION IF EXISTS public.pgp_sym_encrypt_bytea (bytea, pg_catalog.text, pg_catalog.text);
DROP FUNCTION IF EXISTS public.pgp_sym_encrypt (pg_catalog.text, pg_catalog.text, pg_catalog.text);
DROP FUNCTION IF EXISTS public.pgp_sym_encrypt_bytea (bytea, pg_catalog.text);
DROP FUNCTION IF EXISTS public.pgp_sym_encrypt (pg_catalog.text, pg_catalog.text);
DROP FUNCTION IF EXISTS public.gen_random_bytes (integer);
DROP FUNCTION IF EXISTS public.decrypt_iv (bytea, bytea, bytea, pg_catalog.text);
DROP FUNCTION IF EXISTS public.encrypt_iv (bytea, bytea, bytea, pg_catalog.text);
DROP FUNCTION IF EXISTS public.decrypt (bytea, bytea, pg_catalog.text);
DROP FUNCTION IF EXISTS public.encrypt (bytea, bytea, pg_catalog.text);
DROP FUNCTION IF EXISTS public.gen_salt (pg_catalog.text, integer);
DROP FUNCTION IF EXISTS public.gen_salt (pg_catalog.text);
DROP FUNCTION IF EXISTS public.crypt (pg_catalog.text, pg_catalog.text);
DROP FUNCTION IF EXISTS public.hmac (bytea, bytea, pg_catalog.text);
DROP FUNCTION IF EXISTS public.hmac (pg_catalog.text, pg_catalog.text, pg_catalog.text);
DROP FUNCTION IF EXISTS public.digest (bytea, pg_catalog.text);
DROP FUNCTION IF EXISTS public.digest (pg_catalog.text, pg_catalog.text);
DROP SEQUENCE IF EXISTS public.usr_pat_intrinst_id_upi_seq;
DROP SEQUENCE IF EXISTS public.user_role_iduser_role_seq;
DROP SEQUENCE IF EXISTS public.text_idtext_seq;
DROP SEQUENCE IF EXISTS public.section_idsection_seq;
DROP SEQUENCE IF EXISTS public.role_idrole_seq;
DROP SEQUENCE IF EXISTS public.rel_prj_appusers_idprj_usrs_seq;
DROP SEQUENCE IF EXISTS public.rel_grp_appusr_idgrp_usr_seq;
DROP SEQUENCE IF EXISTS public.question_idquestion_seq;
DROP SEQUENCE IF EXISTS public.question_ansitem_id_seq;
DROP SEQUENCE IF EXISTS public.project_idproject_seq;
DROP SEQUENCE IF EXISTS public.project_idprj_seq;
DROP SEQUENCE IF EXISTS public.performance_idperformance_seq;
DROP SEQUENCE IF EXISTS public.perf_history_idhistory_seq;
DROP SEQUENCE IF EXISTS public.patient_idpatient_seq;
DROP SEQUENCE IF EXISTS public.patient_idpat_seq;
DROP SEQUENCE IF EXISTS public.pat_gives_answer2ques_idp_a_q_seq;
DROP SEQUENCE IF EXISTS public.item_iditem_seq;
DROP SEQUENCE IF EXISTS public.intrv_group_idintrv_group_seq;
DROP SEQUENCE IF EXISTS public.intr_instance_idinstance_seq;
DROP SEQUENCE IF EXISTS public.interview_idinterview_seq;
DROP SEQUENCE IF EXISTS public.hospital_idhosp_seq;
DROP SEQUENCE IF EXISTS public.grouptype_idgrouptype_seq;
DROP SEQUENCE IF EXISTS public.enumitem_idenumitem_seq;
DROP SEQUENCE IF EXISTS public.appuser_iduser_seq;
DROP SEQUENCE IF EXISTS public.applog_logid_seq;
DROP SEQUENCE IF EXISTS public.appgroup_idgroup_seq;
DROP SEQUENCE IF EXISTS public.answer_item_idansitem_seq;
DROP SEQUENCE IF EXISTS public.answer_idanswer_seq;
DROP FUNCTION IF EXISTS public.set_log_time ();
DROP FUNCTION IF EXISTS public.log_tmpl_intrv ();
DROP FUNCTION IF EXISTS public.log_appsession_end ();
DROP VIEW IF EXISTS public.viewlog;
DROP TABLE IF EXISTS public.usr_pat_intrinst;
DROP TABLE IF EXISTS public.user_role;
DROP TABLE IF EXISTS public.text;
DROP TABLE IF EXISTS public.section;
DROP TABLE IF EXISTS public.role;
DROP TABLE IF EXISTS public.rel_prj_appusers;
DROP TABLE IF EXISTS public.rel_grp_appusr;
DROP TABLE IF EXISTS public.question_ansitem;
DROP TABLE IF EXISTS public.question;
DROP TABLE IF EXISTS public.project;
DROP TABLE IF EXISTS public.performance;
DROP TABLE IF EXISTS public.perf_history;
DROP TABLE IF EXISTS public.patient;
DROP TABLE IF EXISTS public.pat_gives_answer2ques;
DROP TABLE IF EXISTS public.item;
DROP TABLE IF EXISTS public.intrv_group;
DROP TABLE IF EXISTS public.intr_instance;
DROP TABLE IF EXISTS public.interview;
DROP TABLE IF EXISTS public.hospital;
DROP TABLE IF EXISTS public.grouptype;
DROP TABLE IF EXISTS public.enumtype;
DROP TABLE IF EXISTS public.enumitem;
DROP TABLE IF EXISTS public.appuser;
DROP TABLE IF EXISTS public.applog;
DROP TABLE IF EXISTS public.appgroup;
DROP TABLE IF EXISTS public.answertype;
DROP TABLE IF EXISTS public.answer_item;
DROP TABLE IF EXISTS public.answer;
DROP PROCEDURAL LANGUAGE IF EXISTS plpgsql;
--
-- Definition for language plpgsql (OID = 97663) : 
--
CREATE TRUSTED PROCEDURAL LANGUAGE plpgsql
   HANDLER "plpgsql_call_handler"
;
SET check_function_bodies = false;
--
-- Definition for function log_appsession_end (OID = 97759) : 
--
CREATE FUNCTION public.log_appsession_end () RETURNS "trigger"
AS 
$body$
/*
  OLD and NEW are the row updated on appuser table
*/
DECLARE
  last_log applog%ROWTYPE;
  msglog varchar;
  mytime timestamp;
  strtime varchar;
BEGIN
	if (TG_OP = 'UPDATE') THEN
		select into last_log * from applog 
    where userid=NEW.iduser and sessionid <> ''
    order by thetime desc;
  
  	IF FOUND THEN
    	IF (NEW.loggedin = 0 and OLD.loggedin = 1) THEN
        mytime = now ();
        strtime = to_char (mytime, 'DD Mon YYYY HH24:MI:SS');
      	msglog = 'User \''||NEW.username||'\' logged out sucessfully at '||strtime;

      	insert into applog (userid, sessionid, logmsg, thetime, lastip)
        values (last_log.userid, last_log.sessionid, msglog, now(), last_log.lastip);
			end if;
		END IF;
    
  END IF;
 	return null;

END;
$body$
    LANGUAGE plpgsql;
--
-- Definition for function log_tmpl_intrv (OID = 97760) : 
--
CREATE FUNCTION public.log_tmpl_intrv () RETURNS "trigger"
AS 
$body$
DECLARE
  username varchar;
  applog_row applog%ROWTYPE;
  msglog varchar;
  intrvname varchar;
  myintrvid integer;
  
BEGIN

	if (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
		select into username a.username from appuser a where a.iduser = NEW.codusr;
    
    select into applog_row a.* from applog a
    where a.userid = NEW.codusr order by a.thetime;
    myintrvid = NEW.idinterview;
    
  else   	select into username a.username from appuser a where a.iduser = OLD.codusr;
    
    select into applog_row a.* from applog a
    where a.userid = OLD.codusr order by a.thetime desc;
    myintrvid = OLD.idinterview;
  end if;
  
  if (TG_OP = 'INSERT') THEN
  	msglog = 'New interview was CREATED by user \''||username||'\'';
    msglog = msglog || ' during session '||applog_row.sessionid;
    msglog = msglog || ' with name \'' || NEW.name || '\'';
    msglog = msglog || ' for project with id '|| NEW.codprj;
    
  elseif (TG_OP = 'UPDATE') THEN
  	DECLARE
    	str_idintrv varchar;
      str_codprj varchar;
    BEGIN
    	str_idintrv = NEW.idinterview::VARCHAR;
      str_codprj = NEW.codprj::VARCHAR;
  		msglog = 'Interview with id ' || cast(NEW.idinterview as varchar);
    	msglog = msglog || ' with name \'' || NEW.name || '\'';
    	msglog = msglog || ' was UPDATED by user \''|| username ||'\'';
    	msglog = msglog || ' during session '||applog_row.sessionid;
    	msglog = msglog || ' for project with id '|| str_codprj;
    END;
    
  ELSE   	msglog = 'Interview with id '||OLD.idinterview;
    msglog = msglog || ' with name \'' || OLD.name || '\'';
    msglog = msglog || ' was DELETED by user \''||username||'\'';
    msglog = msglog || ' during session '||applog_row.sessionid;
    msglog = msglog || ' for project with id '|| OLD.codprj;
  end if;
/*
  msglog = msglog || ' *** ' || applog_row.userid::varchar || ', ';
  msglog = msglog || applog_row.sessionid ||', '|| to_char (now(), 'HH24:MI:SS') ||', '
        ||myintrvid::varchar;
  insert into rubbish (data) values (msglog);
  */
  insert into applog (userid, sessionid, thetime, patientid, intrvid, logmsg)
  values (applog_row.userid::varchar, applog_row.sessionid, now (), null, 
  				myintrvid::varchar, msg);
  return null;
  
END;
$body$
    LANGUAGE plpgsql;
--
-- Definition for function set_log_time (OID = 97761) : 
--
CREATE FUNCTION public.set_log_time () RETURNS "trigger"
AS 
$body$
DECLARE
  mytime timestamp;
BEGIN
  mytime = now ();
  NEW.thetime = mytime;
  
  return NEW;
END;
$body$
    LANGUAGE plpgsql;
--
-- Definition for function digest (OID = 101751) : 
--
CREATE FUNCTION public.digest (pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_digest'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function digest (OID = 101752) : 
--
CREATE FUNCTION public.digest (bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_digest'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function hmac (OID = 101753) : 
--
CREATE FUNCTION public.hmac (pg_catalog.text, pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_hmac'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function hmac (OID = 101754) : 
--
CREATE FUNCTION public.hmac (bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_hmac'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function crypt (OID = 101755) : 
--
CREATE FUNCTION public.crypt (pg_catalog.text, pg_catalog.text) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pg_crypt'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function gen_salt (OID = 101756) : 
--
CREATE FUNCTION public.gen_salt (pg_catalog.text) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pg_gen_salt'
    LANGUAGE c STRICT;
--
-- Definition for function gen_salt (OID = 101757) : 
--
CREATE FUNCTION public.gen_salt (pg_catalog.text, integer) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pg_gen_salt_rounds'
    LANGUAGE c STRICT;
--
-- Definition for function encrypt (OID = 101758) : 
--
CREATE FUNCTION public.encrypt (bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_encrypt'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function decrypt (OID = 101759) : 
--
CREATE FUNCTION public.decrypt (bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_decrypt'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function encrypt_iv (OID = 101760) : 
--
CREATE FUNCTION public.encrypt_iv (bytea, bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_encrypt_iv'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function decrypt_iv (OID = 101761) : 
--
CREATE FUNCTION public.decrypt_iv (bytea, bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_decrypt_iv'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function gen_random_bytes (OID = 101762) : 
--
CREATE FUNCTION public.gen_random_bytes (integer) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_random_bytes'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_sym_encrypt (OID = 101763) : 
--
CREATE FUNCTION public.pgp_sym_encrypt (pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_sym_encrypt_text'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_sym_encrypt_bytea (OID = 101764) : 
--
CREATE FUNCTION public.pgp_sym_encrypt_bytea (bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_sym_encrypt_bytea'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_sym_encrypt (OID = 101765) : 
--
CREATE FUNCTION public.pgp_sym_encrypt (pg_catalog.text, pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_sym_encrypt_text'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_sym_encrypt_bytea (OID = 101766) : 
--
CREATE FUNCTION public.pgp_sym_encrypt_bytea (bytea, pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_sym_encrypt_bytea'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_sym_decrypt (OID = 101767) : 
--
CREATE FUNCTION public.pgp_sym_decrypt (bytea, pg_catalog.text) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pgp_sym_decrypt_text'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_sym_decrypt_bytea (OID = 101768) : 
--
CREATE FUNCTION public.pgp_sym_decrypt_bytea (bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_sym_decrypt_bytea'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_sym_decrypt (OID = 101769) : 
--
CREATE FUNCTION public.pgp_sym_decrypt (bytea, pg_catalog.text, pg_catalog.text) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pgp_sym_decrypt_text'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_sym_decrypt_bytea (OID = 101770) : 
--
CREATE FUNCTION public.pgp_sym_decrypt_bytea (bytea, pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_sym_decrypt_bytea'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_pub_encrypt (OID = 101771) : 
--
CREATE FUNCTION public.pgp_pub_encrypt (pg_catalog.text, bytea) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_encrypt_text'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_pub_encrypt_bytea (OID = 101772) : 
--
CREATE FUNCTION public.pgp_pub_encrypt_bytea (bytea, bytea) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_encrypt_bytea'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_pub_encrypt (OID = 101773) : 
--
CREATE FUNCTION public.pgp_pub_encrypt (pg_catalog.text, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_encrypt_text'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_pub_encrypt_bytea (OID = 101774) : 
--
CREATE FUNCTION public.pgp_pub_encrypt_bytea (bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_encrypt_bytea'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_pub_decrypt (OID = 101775) : 
--
CREATE FUNCTION public.pgp_pub_decrypt (bytea, bytea) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pgp_pub_decrypt_text'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_pub_decrypt_bytea (OID = 101776) : 
--
CREATE FUNCTION public.pgp_pub_decrypt_bytea (bytea, bytea) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_decrypt_bytea'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_pub_decrypt (OID = 101777) : 
--
CREATE FUNCTION public.pgp_pub_decrypt (bytea, bytea, pg_catalog.text) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pgp_pub_decrypt_text'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_pub_decrypt_bytea (OID = 101778) : 
--
CREATE FUNCTION public.pgp_pub_decrypt_bytea (bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_decrypt_bytea'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_pub_decrypt (OID = 101779) : 
--
CREATE FUNCTION public.pgp_pub_decrypt (bytea, bytea, pg_catalog.text, pg_catalog.text) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pgp_pub_decrypt_text'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_pub_decrypt_bytea (OID = 101780) : 
--
CREATE FUNCTION public.pgp_pub_decrypt_bytea (bytea, bytea, pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_decrypt_bytea'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_key_id (OID = 101781) : 
--
CREATE FUNCTION public.pgp_key_id (bytea) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pgp_key_id_w'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function armor (OID = 101782) : 
--
CREATE FUNCTION public.armor (bytea) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pg_armor'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function dearmor (OID = 101783) : 
--
CREATE FUNCTION public.dearmor (pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_dearmor'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function log_upd_answer (OID = 101898) : 
--
CREATE FUNCTION public.log_upd_answer () RETURNS "trigger"
AS 
$body$
DECLARE
  applog_row applog%ROWTYPE;
  msglog varchar;
  intrvname varchar;
  myintrvid integer;
  
  mydata RECORD;
  rowcount integer;
  
BEGIN
  if (TG_OP = 'UPDATE') THEN
  	select q.idquestion as idq, q.codquestion as codq, t.name as intrname, 
           p.idpat as idpat, p.codpatient as codpat, pf.idperformance as idperf,
           u.username as thename, u.iduser as usrid
    into mydata
		from question q, pat_gives_answer2ques pg, answer a, item i, 
		 		section s, interview t, patient p, performance pf, appuser u,
        perf_history ph
		where pg.codanswer = a.idanswer
    	and a.idanswer = OLD.idanswer
  		and pg.codquestion = q.idquestion
  		and q.idquestion = i.iditem
  		and i.idsection = s.idsection
  		and s.codinterview = t.idinterview
  		and pg.codpat = p.idpat
      and pf.codpat = p.idpat
      and pf.codinterview = t.idinterview -- this check is neccessary as, one idpat corresponds with several performids
--  		and pf.coduser = u.iduser
      and ph.coduser = u.iduser
      and ph.codperf = pf.idperformance;

		get diagnostics rowcount = ROW_COUNT;
    if (rowcount = 1) then
    	select into applog_row a.* 
      from applog a
    	where a.userid = mydata.usrid 
      order by a.thetime desc;
--   insert into test (content) values ('sessionid: '||applog_row.sessionid);
   
    	msglog = 'Value for question '|| mydata.codq || ' from interview ';
      msglog = msglog || mydata.intrname || ' updated: OLD='|| OLD.thevalue;
      msglog = msglog || ' -> NEW=' || NEW.thevalue || ' for patient with code: ';
      msglog = msglog || mydata.codpat || ' by user ''' || mydata.thename || '''';
      
      if (applog_row.sessionid is not NULL) then
      	msglog = msglog || ' and sessionid is: '||applog_row.sessionid;
        insert into applog (userid, sessionid, thetime, patientid, intrvid, logmsg, lastip)
      	values (mydata.usrid, applog_row.sessionid, now(), mydata.idpat, 
      					mydata.idperf, msglog, applog_row.lastip);
      ELSE
      	insert into applog (userid, sessionid, thetime, patientid, intrvid, logmsg, lastip)
      	values (mydata.usrid, '-1', now(), mydata.idpat, 
      					mydata.idperf, msglog, applog_row.lastip);
      end if;
      
      insert into test (content) values (msglog);
      
    else
    	insert into test (content) values ('Nothing was updated');  
     
	  end if;
   
  end if; -- if TG_UPDATE
  return null;
  
END;
$body$
    LANGUAGE plpgsql;
--
-- Structure for table answer (OID = 97664) : 
--
CREATE TABLE public.answer (
    idanswer integer DEFAULT nextval('answer_idanswer_seq'::regclass) NOT NULL,
    thevalue character varying(512),
    answer_order integer,
    codansitem integer NOT NULL
) WITHOUT OIDS;
--
-- Structure for table answer_item (OID = 97669) : 
--
CREATE TABLE public.answer_item (
    idansitem integer DEFAULT nextval('answer_item_idansitem_seq'::regclass) NOT NULL,
    answer_order integer,
    name character varying(128),
    description character varying(128),
    codintrv integer
) WITHOUT OIDS;
--
-- Structure for table answertype (OID = 97671) : 
--
CREATE TABLE public.answertype (
    idanstype integer NOT NULL,
    pattern character varying(256)
) WITHOUT OIDS;
--
-- Structure for table appgroup (OID = 97673) : 
--
CREATE TABLE public.appgroup (
    idgroup integer DEFAULT nextval('appgroup_idgroup_seq'::regclass) NOT NULL,
    name character varying(128),
    codgroup character varying(128),
    tmpl_holder integer DEFAULT 0,
    parent integer,
    codgroup_type integer
) WITHOUT OIDS;
--
-- Structure for table applog (OID = 97676) : 
--
CREATE TABLE public.applog (
    logid integer DEFAULT nextval('applog_logid_seq'::regclass) NOT NULL,
    userid integer NOT NULL,
    sessionid character varying(256) NOT NULL,
    thetime timestamp without time zone,
    patientid integer,
    intrvid integer,
    logmsg character varying(1024),
    lastip character varying(128)
);
--
-- Structure for table appuser (OID = 97681) : 
--
CREATE TABLE public.appuser (
    iduser integer DEFAULT nextval('appuser_iduser_seq'::regclass) NOT NULL,
    username character varying(128) NOT NULL,
    passwd character varying(128) NOT NULL,
    c_date timestamp without time zone DEFAULT now(),
    u_date timestamp without time zone,
    codhosp integer,
    country character varying(16),
    firstname character varying(255),
    lastname character varying(255),
    removed integer DEFAULT 0,
    loggedin integer DEFAULT 0,
    loggedfrom character varying(128),
    login_attempts integer,
    email character varying(1024)
) WITHOUT OIDS;
--
-- Structure for table enumitem (OID = 97689) : 
--
CREATE TABLE public.enumitem (
    idenumitem integer DEFAULT nextval('enumitem_idenumitem_seq'::regclass) NOT NULL,
    codenumtype integer NOT NULL,
    name character varying(1024),
    description character varying(128),
    thevalue character varying(128),
    listorder integer
) WITHOUT OIDS;
--
-- Structure for table enumtype (OID = 97694) : 
--
CREATE TABLE public.enumtype (
    idenumtype integer NOT NULL,
    numitems integer
) WITHOUT OIDS;
--
-- Structure for table grouptype (OID = 97696) : 
--
CREATE TABLE public.grouptype (
    idgrouptype integer DEFAULT nextval('grouptype_idgrouptype_seq'::regclass) NOT NULL,
    name character varying(128) NOT NULL,
    description character varying(1024)
) WITHOUT OIDS;
--
-- Structure for table hospital (OID = 97701) : 
--
CREATE TABLE public.hospital (
    idhosp integer DEFAULT nextval('hospital_idhosp_seq'::regclass) NOT NULL,
    name character varying(128) NOT NULL,
    hospcod integer NOT NULL,
    c_date timestamp without time zone DEFAULT now(),
    u_date timestamp without time zone
) WITHOUT OIDS;
--
-- Structure for table interview (OID = 97704) : 
--
CREATE TABLE public.interview (
    idinterview integer DEFAULT nextval('interview_idinterview_seq'::regclass) NOT NULL,
    name character varying(128),
    description character varying(128),
    codprj integer,
    codusr integer,
    c_date timestamp without time zone DEFAULT now(),
    u_date timestamp without time zone,
    source integer
) WITHOUT OIDS;
--
-- Structure for table intr_instance (OID = 97707) : 
--
CREATE TABLE public.intr_instance (
    idinstance integer DEFAULT nextval('intr_instance_idinstance_seq'::regclass) NOT NULL,
    place character varying(256),
    date_ini timestamp without time zone,
    date_end timestamp without time zone,
    codinterview integer NOT NULL
) WITHOUT OIDS;
--
-- Structure for table intrv_group (OID = 97709) : 
--
CREATE TABLE public.intrv_group (
    idintrv_group integer DEFAULT nextval('intrv_group_idintrv_group_seq'::regclass) NOT NULL,
    codintrv integer NOT NULL,
    codgroup integer NOT NULL
) WITHOUT OIDS;
--
-- Structure for table item (OID = 97711) : 
--
CREATE TABLE public.item (
    iditem integer DEFAULT nextval('item_iditem_seq'::regclass) NOT NULL,
    idsection integer,
    ite_iditem integer,
    content character varying(10240),
    item_order integer,
    c_date timestamp without time zone DEFAULT now(),
    u_date timestamp without time zone,
    repeatable integer,
    highlight integer DEFAULT 0
) WITHOUT OIDS;
--
-- Structure for table pat_gives_answer2ques (OID = 97718) : 
--
CREATE TABLE public.pat_gives_answer2ques (
    idp_a_q integer DEFAULT nextval('pat_gives_answer2ques_idp_a_q_seq'::regclass) NOT NULL,
    codpat integer,
    codanswer integer,
    codquestion integer,
    answer_number integer,
    answer_order integer,
    answer_grp integer
) WITHOUT OIDS;
--
-- Structure for table patient (OID = 97720) : 
--
CREATE TABLE public.patient (
    idpat integer DEFAULT nextval('patient_idpat_seq'::regclass) NOT NULL,
    name character varying(256),
    codpatient character varying(15) NOT NULL,
    address character varying(512),
    phone character varying(20),
    numhc character varying(32),
    c_date timestamp without time zone DEFAULT now(),
    u_date timestamp without time zone
) WITHOUT OIDS;
--
-- Structure for table perf_history (OID = 97726) : 
--
CREATE TABLE public.perf_history (
    idhistory integer DEFAULT nextval('perf_history_idhistory_seq'::regclass) NOT NULL,
    thetimestamp timestamp without time zone,
    coduser integer NOT NULL,
    codperf integer NOT NULL,
    iduser_role integer
);
--
-- Structure for table performance (OID = 97728) : 
--
CREATE TABLE public.performance (
    idperformance integer DEFAULT nextval('performance_idperformance_seq'::regclass) NOT NULL,
    coduser integer,
    codinterview integer,
    codpat integer,
    date_ini timestamp without time zone,
    date_end timestamp without time zone,
    place character varying(256),
    num_order integer,
    last_sec integer DEFAULT 1,
    codgroup integer
) WITHOUT OIDS;
--
-- Structure for table project (OID = 97731) : 
--
CREATE TABLE public.project (
    idprj integer DEFAULT nextval('project_idprj_seq'::regclass) NOT NULL,
    name character varying(128),
    description character varying(128),
    c_date timestamp without time zone DEFAULT now(),
    u_date timestamp without time zone,
    project_code character varying(255)
) WITHOUT OIDS;
--
-- Structure for table question (OID = 97734) : 
--
CREATE TABLE public.question (
    idquestion integer DEFAULT nextval('question_idquestion_seq'::regclass) NOT NULL,
    repeatable integer,
    codquestion character varying(16),
    mandatory integer DEFAULT 0
) WITHOUT OIDS;
--
-- Structure for table question_ansitem (OID = 97737) : 
--
CREATE TABLE public.question_ansitem (
    id integer DEFAULT nextval('question_ansitem_id_seq'::regclass) NOT NULL,
    codansitem integer NOT NULL,
    codquestion integer NOT NULL,
    answer_order integer,
    pattern character varying(255)
) WITHOUT OIDS;
--
-- Structure for table rel_grp_appusr (OID = 97739) : 
--
CREATE TABLE public.rel_grp_appusr (
    idgrp_usr integer DEFAULT nextval('rel_grp_appusr_idgrp_usr_seq'::regclass) NOT NULL,
    codgroup integer NOT NULL,
    coduser integer NOT NULL,
    active integer DEFAULT 0
) WITHOUT OIDS;
--
-- Structure for table rel_prj_appusers (OID = 97742) : 
--
CREATE TABLE public.rel_prj_appusers (
    idprj_usrs integer DEFAULT nextval('rel_prj_appusers_idprj_usrs_seq'::regclass) NOT NULL,
    codprj integer NOT NULL,
    coduser integer NOT NULL
) WITHOUT OIDS;
--
-- Structure for table role (OID = 97744) : 
--
CREATE TABLE public.role (
    idrole integer DEFAULT nextval('role_idrole_seq'::regclass) NOT NULL,
    name character varying(128),
    description character varying(128),
    c_date timestamp without time zone DEFAULT now(),
    u_date timestamp without time zone
) WITHOUT OIDS;
--
-- Structure for table section (OID = 97747) : 
--
CREATE TABLE public.section (
    idsection integer DEFAULT nextval('section_idsection_seq'::regclass) NOT NULL,
    name character varying(128),
    description character varying(128),
    section_order integer,
    codinterview integer,
    c_date timestamp without time zone DEFAULT now(),
    u_date timestamp without time zone
) WITHOUT OIDS;
--
-- Structure for table text (OID = 97750) : 
--
CREATE TABLE public.text (
    idtext integer DEFAULT nextval('text_idtext_seq'::regclass) NOT NULL,
    highlighted integer
) WITHOUT OIDS;
--
-- Structure for table user_role (OID = 97752) : 
--
CREATE TABLE public.user_role (
    iduser_role integer DEFAULT nextval('user_role_iduser_role_seq'::regclass) NOT NULL,
    coduser integer NOT NULL,
    codrole integer NOT NULL,
    username character varying(128),
    rolename character varying(128)
) WITHOUT OIDS;
--
-- Structure for table usr_pat_intrinst (OID = 97754) : 
--
CREATE TABLE public.usr_pat_intrinst (
    id_upi integer DEFAULT nextval('usr_pat_intrinst_id_upi_seq'::regclass) NOT NULL,
    coduser integer NOT NULL,
    codpatient integer NOT NULL,
    codintr_ins integer NOT NULL
) WITHOUT OIDS;
--
-- Definition for view viewlog (OID = 97756) : 
--
CREATE VIEW public.viewlog AS
SELECT a.thetime, a.userid, a.logmsg, a.lastip, a.sessionid AS sessid
FROM applog a
ORDER BY a.thetime DESC;

--
-- Definition for function log_appsession_end (OID = 97759) : 
--
CREATE FUNCTION public.log_appsession_end () RETURNS "trigger"
AS 
$body$
/*
  OLD and NEW are the row updated on appuser table
*/
DECLARE
  last_log applog%ROWTYPE;
  msglog varchar;
  mytime timestamp;
  strtime varchar;
BEGIN
	if (TG_OP = 'UPDATE') THEN
		select into last_log * from applog 
    where userid=NEW.iduser and sessionid <> ''
    order by thetime desc;
  
  	IF FOUND THEN
    	IF (NEW.loggedin = 0 and OLD.loggedin = 1) THEN
        mytime = now ();
        strtime = to_char (mytime, 'DD Mon YYYY HH24:MI:SS');
      	msglog = 'User \''||NEW.username||'\' logged out sucessfully at '||strtime;

      	insert into applog (userid, sessionid, logmsg, thetime, lastip)
        values (last_log.userid, last_log.sessionid, msglog, now(), last_log.lastip);
			end if;
		END IF;
    
  END IF;
 	return null;

END;
$body$
    LANGUAGE plpgsql;
--
-- Definition for function log_tmpl_intrv (OID = 97760) : 
--
CREATE FUNCTION public.log_tmpl_intrv () RETURNS "trigger"
AS 
$body$
DECLARE
  username varchar;
  applog_row applog%ROWTYPE;
  msglog varchar;
  intrvname varchar;
  myintrvid integer;
  
BEGIN

	if (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
		select into username a.username from appuser a where a.iduser = NEW.codusr;
    
    select into applog_row a.* from applog a
    where a.userid = NEW.codusr order by a.thetime;
    myintrvid = NEW.idinterview;
    
  else   	select into username a.username from appuser a where a.iduser = OLD.codusr;
    
    select into applog_row a.* from applog a
    where a.userid = OLD.codusr order by a.thetime desc;
    myintrvid = OLD.idinterview;
  end if;
  
  if (TG_OP = 'INSERT') THEN
  	msglog = 'New interview was CREATED by user \''||username||'\'';
    msglog = msglog || ' during session '||applog_row.sessionid;
    msglog = msglog || ' with name \'' || NEW.name || '\'';
    msglog = msglog || ' for project with id '|| NEW.codprj;
    
  elseif (TG_OP = 'UPDATE') THEN
  	DECLARE
    	str_idintrv varchar;
      str_codprj varchar;
    BEGIN
    	str_idintrv = NEW.idinterview::VARCHAR;
      str_codprj = NEW.codprj::VARCHAR;
  		msglog = 'Interview with id ' || cast(NEW.idinterview as varchar);
    	msglog = msglog || ' with name \'' || NEW.name || '\'';
    	msglog = msglog || ' was UPDATED by user \''|| username ||'\'';
    	msglog = msglog || ' during session '||applog_row.sessionid;
    	msglog = msglog || ' for project with id '|| str_codprj;
    END;
    
  ELSE   	msglog = 'Interview with id '||OLD.idinterview;
    msglog = msglog || ' with name \'' || OLD.name || '\'';
    msglog = msglog || ' was DELETED by user \''||username||'\'';
    msglog = msglog || ' during session '||applog_row.sessionid;
    msglog = msglog || ' for project with id '|| OLD.codprj;
  end if;
/*
  msglog = msglog || ' *** ' || applog_row.userid::varchar || ', ';
  msglog = msglog || applog_row.sessionid ||', '|| to_char (now(), 'HH24:MI:SS') ||', '
        ||myintrvid::varchar;
  insert into rubbish (data) values (msglog);
  */
  insert into applog (userid, sessionid, thetime, patientid, intrvid, logmsg)
  values (applog_row.userid::varchar, applog_row.sessionid, now (), null, 
  				myintrvid::varchar, msg);
  return null;
  
END;
$body$
    LANGUAGE plpgsql;
--
-- Definition for function set_log_time (OID = 97761) : 
--
CREATE FUNCTION public.set_log_time () RETURNS "trigger"
AS 
$body$
DECLARE
  mytime timestamp;
BEGIN
  mytime = now ();
  NEW.thetime = mytime;
  
  return NEW;
END;
$body$
    LANGUAGE plpgsql;
--
-- Definition for sequence answer_idanswer_seq (OID = 97762) : 
--
CREATE SEQUENCE public.answer_idanswer_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence answer_item_idansitem_seq (OID = 97764) : 
--
CREATE SEQUENCE public.answer_item_idansitem_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence appgroup_idgroup_seq (OID = 97766) : 
--
CREATE SEQUENCE public.appgroup_idgroup_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence applog_logid_seq (OID = 97768) : 
--
CREATE SEQUENCE public.applog_logid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence appuser_iduser_seq (OID = 97770) : 
--
CREATE SEQUENCE public.appuser_iduser_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence enumitem_idenumitem_seq (OID = 97772) : 
--
CREATE SEQUENCE public.enumitem_idenumitem_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence grouptype_idgrouptype_seq (OID = 97774) : 
--
CREATE SEQUENCE public.grouptype_idgrouptype_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence hospital_idhosp_seq (OID = 97776) : 
--
CREATE SEQUENCE public.hospital_idhosp_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence interview_idinterview_seq (OID = 97778) : 
--
CREATE SEQUENCE public.interview_idinterview_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence intr_instance_idinstance_seq (OID = 97780) : 
--
CREATE SEQUENCE public.intr_instance_idinstance_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence intrv_group_idintrv_group_seq (OID = 97782) : 
--
CREATE SEQUENCE public.intrv_group_idintrv_group_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence item_iditem_seq (OID = 97784) : 
--
CREATE SEQUENCE public.item_iditem_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence pat_gives_answer2ques_idp_a_q_seq (OID = 97786) : 
--
CREATE SEQUENCE public.pat_gives_answer2ques_idp_a_q_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence patient_idpat_seq (OID = 97788) : 
--
CREATE SEQUENCE public.patient_idpat_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence patient_idpatient_seq (OID = 97790) : 
--
CREATE SEQUENCE public.patient_idpatient_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence perf_history_idhistory_seq (OID = 97792) : 
--
CREATE SEQUENCE public.perf_history_idhistory_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence performance_idperformance_seq (OID = 97794) : 
--
CREATE SEQUENCE public.performance_idperformance_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence project_idprj_seq (OID = 97796) : 
--
CREATE SEQUENCE public.project_idprj_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence project_idproject_seq (OID = 97798) : 
--
CREATE SEQUENCE public.project_idproject_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence question_ansitem_id_seq (OID = 97800) : 
--
CREATE SEQUENCE public.question_ansitem_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence question_idquestion_seq (OID = 97802) : 
--
CREATE SEQUENCE public.question_idquestion_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence rel_grp_appusr_idgrp_usr_seq (OID = 97804) : 
--
CREATE SEQUENCE public.rel_grp_appusr_idgrp_usr_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence rel_prj_appusers_idprj_usrs_seq (OID = 97806) : 
--
CREATE SEQUENCE public.rel_prj_appusers_idprj_usrs_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence role_idrole_seq (OID = 97808) : 
--
CREATE SEQUENCE public.role_idrole_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence section_idsection_seq (OID = 97810) : 
--
CREATE SEQUENCE public.section_idsection_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence text_idtext_seq (OID = 97812) : 
--
CREATE SEQUENCE public.text_idtext_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence user_role_iduser_role_seq (OID = 97814) : 
--
CREATE SEQUENCE public.user_role_iduser_role_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence usr_pat_intrinst_id_upi_seq (OID = 97816) : 
--
CREATE SEQUENCE public.usr_pat_intrinst_id_upi_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for function digest (OID = 101751) : 
--
CREATE FUNCTION public.digest (pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_digest'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function digest (OID = 101752) : 
--
CREATE FUNCTION public.digest (bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_digest'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function hmac (OID = 101753) : 
--
CREATE FUNCTION public.hmac (pg_catalog.text, pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_hmac'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function hmac (OID = 101754) : 
--
CREATE FUNCTION public.hmac (bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_hmac'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function crypt (OID = 101755) : 
--
CREATE FUNCTION public.crypt (pg_catalog.text, pg_catalog.text) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pg_crypt'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function gen_salt (OID = 101756) : 
--
CREATE FUNCTION public.gen_salt (pg_catalog.text) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pg_gen_salt'
    LANGUAGE c STRICT;
--
-- Definition for function gen_salt (OID = 101757) : 
--
CREATE FUNCTION public.gen_salt (pg_catalog.text, integer) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pg_gen_salt_rounds'
    LANGUAGE c STRICT;
--
-- Definition for function encrypt (OID = 101758) : 
--
CREATE FUNCTION public.encrypt (bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_encrypt'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function decrypt (OID = 101759) : 
--
CREATE FUNCTION public.decrypt (bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_decrypt'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function encrypt_iv (OID = 101760) : 
--
CREATE FUNCTION public.encrypt_iv (bytea, bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_encrypt_iv'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function decrypt_iv (OID = 101761) : 
--
CREATE FUNCTION public.decrypt_iv (bytea, bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_decrypt_iv'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function gen_random_bytes (OID = 101762) : 
--
CREATE FUNCTION public.gen_random_bytes (integer) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_random_bytes'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_sym_encrypt (OID = 101763) : 
--
CREATE FUNCTION public.pgp_sym_encrypt (pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_sym_encrypt_text'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_sym_encrypt_bytea (OID = 101764) : 
--
CREATE FUNCTION public.pgp_sym_encrypt_bytea (bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_sym_encrypt_bytea'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_sym_encrypt (OID = 101765) : 
--
CREATE FUNCTION public.pgp_sym_encrypt (pg_catalog.text, pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_sym_encrypt_text'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_sym_encrypt_bytea (OID = 101766) : 
--
CREATE FUNCTION public.pgp_sym_encrypt_bytea (bytea, pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_sym_encrypt_bytea'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_sym_decrypt (OID = 101767) : 
--
CREATE FUNCTION public.pgp_sym_decrypt (bytea, pg_catalog.text) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pgp_sym_decrypt_text'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_sym_decrypt_bytea (OID = 101768) : 
--
CREATE FUNCTION public.pgp_sym_decrypt_bytea (bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_sym_decrypt_bytea'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_sym_decrypt (OID = 101769) : 
--
CREATE FUNCTION public.pgp_sym_decrypt (bytea, pg_catalog.text, pg_catalog.text) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pgp_sym_decrypt_text'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_sym_decrypt_bytea (OID = 101770) : 
--
CREATE FUNCTION public.pgp_sym_decrypt_bytea (bytea, pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_sym_decrypt_bytea'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_pub_encrypt (OID = 101771) : 
--
CREATE FUNCTION public.pgp_pub_encrypt (pg_catalog.text, bytea) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_encrypt_text'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_pub_encrypt_bytea (OID = 101772) : 
--
CREATE FUNCTION public.pgp_pub_encrypt_bytea (bytea, bytea) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_encrypt_bytea'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_pub_encrypt (OID = 101773) : 
--
CREATE FUNCTION public.pgp_pub_encrypt (pg_catalog.text, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_encrypt_text'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_pub_encrypt_bytea (OID = 101774) : 
--
CREATE FUNCTION public.pgp_pub_encrypt_bytea (bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_encrypt_bytea'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_pub_decrypt (OID = 101775) : 
--
CREATE FUNCTION public.pgp_pub_decrypt (bytea, bytea) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pgp_pub_decrypt_text'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_pub_decrypt_bytea (OID = 101776) : 
--
CREATE FUNCTION public.pgp_pub_decrypt_bytea (bytea, bytea) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_decrypt_bytea'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_pub_decrypt (OID = 101777) : 
--
CREATE FUNCTION public.pgp_pub_decrypt (bytea, bytea, pg_catalog.text) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pgp_pub_decrypt_text'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_pub_decrypt_bytea (OID = 101778) : 
--
CREATE FUNCTION public.pgp_pub_decrypt_bytea (bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_decrypt_bytea'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_pub_decrypt (OID = 101779) : 
--
CREATE FUNCTION public.pgp_pub_decrypt (bytea, bytea, pg_catalog.text, pg_catalog.text) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pgp_pub_decrypt_text'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_pub_decrypt_bytea (OID = 101780) : 
--
CREATE FUNCTION public.pgp_pub_decrypt_bytea (bytea, bytea, pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_decrypt_bytea'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_key_id (OID = 101781) : 
--
CREATE FUNCTION public.pgp_key_id (bytea) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pgp_key_id_w'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function armor (OID = 101782) : 
--
CREATE FUNCTION public.armor (bytea) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pg_armor'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function dearmor (OID = 101783) : 
--
CREATE FUNCTION public.dearmor (pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_dearmor'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function log_upd_answer (OID = 101898) : 
--
CREATE FUNCTION public.log_upd_answer () RETURNS "trigger"
AS 
$body$
DECLARE
  applog_row applog%ROWTYPE;
  msglog varchar;
  intrvname varchar;
  myintrvid integer;
  
  mydata RECORD;
  rowcount integer;
  
BEGIN
  if (TG_OP = 'UPDATE') THEN
  	select q.idquestion as idq, q.codquestion as codq, t.name as intrname, 
           p.idpat as idpat, p.codpatient as codpat, pf.idperformance as idperf,
           u.username as thename, u.iduser as usrid
    into mydata
		from question q, pat_gives_answer2ques pg, answer a, item i, 
		 		section s, interview t, patient p, performance pf, appuser u,
        perf_history ph
		where pg.codanswer = a.idanswer
    	and a.idanswer = OLD.idanswer
  		and pg.codquestion = q.idquestion
  		and q.idquestion = i.iditem
  		and i.idsection = s.idsection
  		and s.codinterview = t.idinterview
  		and pg.codpat = p.idpat
      and pf.codpat = p.idpat
      and pf.codinterview = t.idinterview -- this check is neccessary as, one idpat corresponds with several performids
--  		and pf.coduser = u.iduser
      and ph.coduser = u.iduser
      and ph.codperf = pf.idperformance;

		get diagnostics rowcount = ROW_COUNT;
    if (rowcount = 1) then
    	select into applog_row a.* 
      from applog a
    	where a.userid = mydata.usrid 
      order by a.thetime desc;
--   insert into test (content) values ('sessionid: '||applog_row.sessionid);
   
    	msglog = 'Value for question '|| mydata.codq || ' from interview ';
      msglog = msglog || mydata.intrname || ' updated: OLD='|| OLD.thevalue;
      msglog = msglog || ' -> NEW=' || NEW.thevalue || ' for patient with code: ';
      msglog = msglog || mydata.codpat || ' by user ''' || mydata.thename || '''';
      
      if (applog_row.sessionid is not NULL) then
      	msglog = msglog || ' and sessionid is: '||applog_row.sessionid;
        insert into applog (userid, sessionid, thetime, patientid, intrvid, logmsg, lastip)
      	values (mydata.usrid, applog_row.sessionid, now(), mydata.idpat, 
      					mydata.idperf, msglog, applog_row.lastip);
      ELSE
      	insert into applog (userid, sessionid, thetime, patientid, intrvid, logmsg, lastip)
      	values (mydata.usrid, '-1', now(), mydata.idpat, 
      					mydata.idperf, msglog, applog_row.lastip);
      end if;
      
      insert into test (content) values (msglog);
      
    else
    	insert into test (content) values ('Nothing was updated');  
     
	  end if;
   
  end if; -- if TG_UPDATE
  return null;
  
END;
$body$
    LANGUAGE plpgsql;
--
-- Definition for sequence test_idtest_seq (OID = 101900) : 
--
CREATE SEQUENCE public.test_idtest_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Structure for table test (OID = 101902) : 
--
CREATE TABLE public.test (
    idtest integer DEFAULT nextval('test_idtest_seq'::regclass) NOT NULL,
    content character varying(4096)
);
--
-- Structure for table mydata (OID = 110122) : 
--
CREATE TABLE public.mydata (
    idq integer,
    codq character varying(16),
    intrname character varying(128),
    idpat integer,
    codpat character varying(15),
    idperf integer,
    thename character varying(128),
    usrid integer
) WITHOUT OIDS;
--
-- Definition for index applog_pkey (OID = 101261) : 
--
ALTER TABLE ONLY applog
    ADD CONSTRAINT applog_pkey PRIMARY KEY (logid);
--
-- Definition for index perf_history_pkey (OID = 101263) : 
--
ALTER TABLE ONLY perf_history
    ADD CONSTRAINT perf_history_pkey PRIMARY KEY (idhistory);
--
-- Definition for index pk_answer (OID = 101265) : 
--
ALTER TABLE ONLY answer
    ADD CONSTRAINT pk_answer PRIMARY KEY (idanswer);
--
-- Definition for index pk_answer_item (OID = 101267) : 
--
ALTER TABLE ONLY answer_item
    ADD CONSTRAINT pk_answer_item PRIMARY KEY (idansitem);
--
-- Definition for index pk_answertype (OID = 101269) : 
--
ALTER TABLE ONLY answertype
    ADD CONSTRAINT pk_answertype PRIMARY KEY (idanstype);
--
-- Definition for index pk_appgroup (OID = 101271) : 
--
ALTER TABLE ONLY appgroup
    ADD CONSTRAINT pk_appgroup PRIMARY KEY (idgroup);
--
-- Definition for index pk_appuser (OID = 101273) : 
--
ALTER TABLE ONLY appuser
    ADD CONSTRAINT pk_appuser PRIMARY KEY (iduser);
--
-- Definition for index pk_enumitem (OID = 101275) : 
--
ALTER TABLE ONLY enumitem
    ADD CONSTRAINT pk_enumitem PRIMARY KEY (idenumitem);
--
-- Definition for index pk_enumtype (OID = 101277) : 
--
ALTER TABLE ONLY enumtype
    ADD CONSTRAINT pk_enumtype PRIMARY KEY (idenumtype);
--
-- Definition for index pk_grouptype (OID = 101279) : 
--
ALTER TABLE ONLY grouptype
    ADD CONSTRAINT pk_grouptype PRIMARY KEY (idgrouptype);
--
-- Definition for index pk_hospital (OID = 101281) : 
--
ALTER TABLE ONLY hospital
    ADD CONSTRAINT pk_hospital PRIMARY KEY (idhosp);
--
-- Definition for index pk_interview (OID = 101283) : 
--
ALTER TABLE ONLY interview
    ADD CONSTRAINT pk_interview PRIMARY KEY (idinterview);
--
-- Definition for index pk_intr_instance (OID = 101285) : 
--
ALTER TABLE ONLY intr_instance
    ADD CONSTRAINT pk_intr_instance PRIMARY KEY (idinstance);
--
-- Definition for index pk_intrv_group (OID = 101287) : 
--
ALTER TABLE ONLY intrv_group
    ADD CONSTRAINT pk_intrv_group PRIMARY KEY (idintrv_group);
--
-- Definition for index pk_item (OID = 101289) : 
--
ALTER TABLE ONLY item
    ADD CONSTRAINT pk_item PRIMARY KEY (iditem);
--
-- Definition for index pk_pat_gives_answer2ques (OID = 101291) : 
--
ALTER TABLE ONLY pat_gives_answer2ques
    ADD CONSTRAINT pk_pat_gives_answer2ques PRIMARY KEY (idp_a_q);
--
-- Definition for index pk_patient (OID = 101293) : 
--
ALTER TABLE ONLY patient
    ADD CONSTRAINT pk_patient PRIMARY KEY (idpat);
--
-- Definition for index pk_performance (OID = 101295) : 
--
ALTER TABLE ONLY performance
    ADD CONSTRAINT pk_performance PRIMARY KEY (idperformance);
--
-- Definition for index pk_project (OID = 101297) : 
--
ALTER TABLE ONLY project
    ADD CONSTRAINT pk_project PRIMARY KEY (idprj);
--
-- Definition for index pk_question (OID = 101299) : 
--
ALTER TABLE ONLY question
    ADD CONSTRAINT pk_question PRIMARY KEY (idquestion);
--
-- Definition for index pk_question_ansitem (OID = 101301) : 
--
ALTER TABLE ONLY question_ansitem
    ADD CONSTRAINT pk_question_ansitem PRIMARY KEY (id);
--
-- Definition for index pk_rel_grp_appusr (OID = 101303) : 
--
ALTER TABLE ONLY rel_grp_appusr
    ADD CONSTRAINT pk_rel_grp_appusr PRIMARY KEY (idgrp_usr);
--
-- Definition for index pk_rel_prj_appusers (OID = 101305) : 
--
ALTER TABLE ONLY rel_prj_appusers
    ADD CONSTRAINT pk_rel_prj_appusers PRIMARY KEY (idprj_usrs);
--
-- Definition for index pk_role (OID = 101307) : 
--
ALTER TABLE ONLY role
    ADD CONSTRAINT pk_role PRIMARY KEY (idrole);
--
-- Definition for index pk_section (OID = 101309) : 
--
ALTER TABLE ONLY section
    ADD CONSTRAINT pk_section PRIMARY KEY (idsection);
--
-- Definition for index pk_text (OID = 101311) : 
--
ALTER TABLE ONLY text
    ADD CONSTRAINT pk_text PRIMARY KEY (idtext);
--
-- Definition for index pk_user_role (OID = 101313) : 
--
ALTER TABLE ONLY user_role
    ADD CONSTRAINT pk_user_role PRIMARY KEY (iduser_role);
--
-- Definition for index pk_usr_pat_intrinst (OID = 101315) : 
--
ALTER TABLE ONLY usr_pat_intrinst
    ADD CONSTRAINT pk_usr_pat_intrinst PRIMARY KEY (id_upi);
--
-- Definition for index fk143bf46a1c3f28d3 (OID = 101320) : 
--
ALTER TABLE ONLY user_role
    ADD CONSTRAINT fk143bf46a1c3f28d3 FOREIGN KEY (codrole) REFERENCES "role"(idrole) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk143bf46a289fe600 (OID = 101325) : 
--
ALTER TABLE ONLY user_role
    ADD CONSTRAINT fk143bf46a289fe600 FOREIGN KEY (coduser) REFERENCES appuser(iduser) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk1dfcd18132dc448d (OID = 101330) : 
--
ALTER TABLE ONLY interview
    ADD CONSTRAINT fk1dfcd18132dc448d FOREIGN KEY (source) REFERENCES interview(idinterview);
--
-- Definition for index fk1dfcd1819fb025d9 (OID = 101335) : 
--
ALTER TABLE ONLY interview
    ADD CONSTRAINT fk1dfcd1819fb025d9 FOREIGN KEY (codusr) REFERENCES appuser(iduser);
--
-- Definition for index fk1dfcd181bc927c7a (OID = 101340) : 
--
ALTER TABLE ONLY interview
    ADD CONSTRAINT fk1dfcd181bc927c7a FOREIGN KEY (codprj) REFERENCES project(idprj);
--
-- Definition for index fk27b94df0028e8c (OID = 101345) : 
--
ALTER TABLE ONLY text
    ADD CONSTRAINT fk27b94df0028e8c FOREIGN KEY (idtext) REFERENCES item(iditem);
--
-- Definition for index fk317b136ead1f80 (OID = 101350) : 
--
ALTER TABLE ONLY item
    ADD CONSTRAINT fk317b136ead1f80 FOREIGN KEY (idsection) REFERENCES section(idsection);
--
-- Definition for index fk317b13ee6627b7 (OID = 101355) : 
--
ALTER TABLE ONLY item
    ADD CONSTRAINT fk317b13ee6627b7 FOREIGN KEY (ite_iditem) REFERENCES item(iditem);
--
-- Definition for index fk33f5054cff274c45 (OID = 101360) : 
--
ALTER TABLE ONLY appuser
    ADD CONSTRAINT fk33f5054cff274c45 FOREIGN KEY (codhosp) REFERENCES hospital(idhosp);
--
-- Definition for index fk3e240fd3289fe600 (OID = 101365) : 
--
ALTER TABLE ONLY rel_grp_appusr
    ADD CONSTRAINT fk3e240fd3289fe600 FOREIGN KEY (coduser) REFERENCES appuser(iduser);
--
-- Definition for index fk3e240fd3e9d1abd4 (OID = 101370) : 
--
ALTER TABLE ONLY rel_grp_appusr
    ADD CONSTRAINT fk3e240fd3e9d1abd4 FOREIGN KEY (codgroup) REFERENCES appgroup(idgroup);
--
-- Definition for index fk460ba8fee20f1477 (OID = 101375) : 
--
ALTER TABLE ONLY appgroup
    ADD CONSTRAINT fk460ba8fee20f1477 FOREIGN KEY (parent) REFERENCES appgroup(idgroup);
--
-- Definition for index fk460ba8fefa6441bc (OID = 101380) : 
--
ALTER TABLE ONLY appgroup
    ADD CONSTRAINT fk460ba8fefa6441bc FOREIGN KEY (codgroup_type) REFERENCES grouptype(idgrouptype);
--
-- Definition for index fk6d9a2ea05c3d6ca1 (OID = 101385) : 
--
ALTER TABLE ONLY question_ansitem
    ADD CONSTRAINT fk6d9a2ea05c3d6ca1 FOREIGN KEY (codansitem) REFERENCES answer_item(idansitem);
--
-- Definition for index fk6d9a2ea0b9245433 (OID = 101390) : 
--
ALTER TABLE ONLY question_ansitem
    ADD CONSTRAINT fk6d9a2ea0b9245433 FOREIGN KEY (codquestion) REFERENCES question(idquestion);
--
-- Definition for index fk756f7ee57bd5537b (OID = 101395) : 
--
ALTER TABLE ONLY section
    ADD CONSTRAINT fk756f7ee57bd5537b FOREIGN KEY (codinterview) REFERENCES interview(idinterview);
--
-- Definition for index fk849ca7944d54c7fd (OID = 101400) : 
--
ALTER TABLE ONLY enumitem
    ADD CONSTRAINT fk849ca7944d54c7fd FOREIGN KEY (codenumtype) REFERENCES enumtype(idenumtype);
--
-- Definition for index fk84c0ddb334d3ec6d (OID = 101405) : 
--
ALTER TABLE ONLY intrv_group
    ADD CONSTRAINT fk84c0ddb334d3ec6d FOREIGN KEY (codintrv) REFERENCES interview(idinterview);
--
-- Definition for index fk84c0ddb3e9d1abd4 (OID = 101410) : 
--
ALTER TABLE ONLY intrv_group
    ADD CONSTRAINT fk84c0ddb3e9d1abd4 FOREIGN KEY (codgroup) REFERENCES appgroup(idgroup);
--
-- Definition for index fk886d93fbda39f0f6 (OID = 101415) : 
--
ALTER TABLE ONLY enumtype
    ADD CONSTRAINT fk886d93fbda39f0f6 FOREIGN KEY (idenumtype) REFERENCES answer_item(idansitem);
--
-- Definition for index fk_ansitem_intrv (OID = 101420) : 
--
ALTER TABLE ONLY answer_item
    ADD CONSTRAINT fk_ansitem_intrv FOREIGN KEY (codintrv) REFERENCES interview(idinterview) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_answer_item (OID = 101425) : 
--
ALTER TABLE ONLY question_ansitem
    ADD CONSTRAINT fk_answer_item FOREIGN KEY (codansitem) REFERENCES answer_item(idansitem) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_answer_rel_answ__answer_i (OID = 101430) : 
--
ALTER TABLE ONLY answer
    ADD CONSTRAINT fk_answer_rel_answ__answer_i FOREIGN KEY (codansitem) REFERENCES answer_item(idansitem) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_answerty_isoneof_answer_i (OID = 101435) : 
--
ALTER TABLE ONLY answertype
    ADD CONSTRAINT fk_answerty_isoneof_answer_i FOREIGN KEY (idanstype) REFERENCES answer_item(idansitem) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_cloned_from (OID = 101440) : 
--
ALTER TABLE ONLY interview
    ADD CONSTRAINT fk_cloned_from FOREIGN KEY (source) REFERENCES interview(idinterview) ON UPDATE CASCADE ON DELETE SET DEFAULT;
--
-- Definition for index fk_enumitem_contains_enumtype (OID = 101445) : 
--
ALTER TABLE ONLY enumitem
    ADD CONSTRAINT fk_enumitem_contains_enumtype FOREIGN KEY (codenumtype) REFERENCES enumtype(idenumtype) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_enumtype_isoneof2_answer_i (OID = 101450) : 
--
ALTER TABLE ONLY enumtype
    ADD CONSTRAINT fk_enumtype_isoneof2_answer_i FOREIGN KEY (idenumtype) REFERENCES answer_item(idansitem) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_grouptype (OID = 101455) : 
--
ALTER TABLE ONLY appgroup
    ADD CONSTRAINT fk_grouptype FOREIGN KEY (codgroup_type) REFERENCES grouptype(idgrouptype) ON UPDATE CASCADE ON DELETE SET DEFAULT;
--
-- Definition for index fk_hospital_user (OID = 101460) : 
--
ALTER TABLE ONLY appuser
    ADD CONSTRAINT fk_hospital_user FOREIGN KEY (codhosp) REFERENCES hospital(idhosp) ON UPDATE RESTRICT ON DELETE RESTRICT;
--
-- Definition for index fk_instance_interview (OID = 101465) : 
--
ALTER TABLE ONLY intr_instance
    ADD CONSTRAINT fk_instance_interview FOREIGN KEY (codinterview) REFERENCES interview(idinterview) ON UPDATE RESTRICT ON DELETE RESTRICT;
--
-- Definition for index fk_interview_belongs_user (OID = 101470) : 
--
ALTER TABLE ONLY interview
    ADD CONSTRAINT fk_interview_belongs_user FOREIGN KEY (codusr) REFERENCES appuser(iduser) ON UPDATE SET DEFAULT ON DELETE SET DEFAULT;
--
-- Definition for index fk_interview_is_formed_project (OID = 101475) : 
--
ALTER TABLE ONLY interview
    ADD CONSTRAINT fk_interview_is_formed_project FOREIGN KEY (codprj) REFERENCES project(idprj) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_intr_ins_ternary_rel (OID = 101480) : 
--
ALTER TABLE ONLY usr_pat_intrinst
    ADD CONSTRAINT fk_intr_ins_ternary_rel FOREIGN KEY (codintr_ins) REFERENCES intr_instance(idinstance) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_intrvgroup_group (OID = 101485) : 
--
ALTER TABLE ONLY intrv_group
    ADD CONSTRAINT fk_intrvgroup_group FOREIGN KEY (codgroup) REFERENCES appgroup(idgroup) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_intrvgroup_intrv (OID = 101490) : 
--
ALTER TABLE ONLY intrv_group
    ADD CONSTRAINT fk_intrvgroup_intrv FOREIGN KEY (codintrv) REFERENCES interview(idinterview) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_item_contains_item (OID = 101495) : 
--
ALTER TABLE ONLY item
    ADD CONSTRAINT fk_item_contains_item FOREIGN KEY (ite_iditem) REFERENCES item(iditem) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_item_is_formed_section (OID = 101500) : 
--
ALTER TABLE ONLY item
    ADD CONSTRAINT fk_item_is_formed_section FOREIGN KEY (idsection) REFERENCES section(idsection) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_parent_group (OID = 101505) : 
--
ALTER TABLE ONLY appgroup
    ADD CONSTRAINT fk_parent_group FOREIGN KEY (parent) REFERENCES appgroup(idgroup) ON UPDATE CASCADE ON DELETE SET DEFAULT;
--
-- Definition for index fk_pat_give_rel_ans_p_answer (OID = 101510) : 
--
ALTER TABLE ONLY pat_gives_answer2ques
    ADD CONSTRAINT fk_pat_give_rel_ans_p_answer FOREIGN KEY (codanswer) REFERENCES answer(idanswer) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_pat_give_rel_pat_a_patient (OID = 101515) : 
--
ALTER TABLE ONLY pat_gives_answer2ques
    ADD CONSTRAINT fk_pat_give_rel_pat_a_patient FOREIGN KEY (codpat) REFERENCES patient(idpat) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_pat_give_rel_ques__question (OID = 101520) : 
--
ALTER TABLE ONLY pat_gives_answer2ques
    ADD CONSTRAINT fk_pat_give_rel_ques__question FOREIGN KEY (codquestion) REFERENCES question(idquestion) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_pat_ternary_rel (OID = 101525) : 
--
ALTER TABLE ONLY usr_pat_intrinst
    ADD CONSTRAINT fk_pat_ternary_rel FOREIGN KEY (codpatient) REFERENCES patient(idpat) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_performa_rel_appus_appuser (OID = 101530) : 
--
ALTER TABLE ONLY performance
    ADD CONSTRAINT fk_performa_rel_appus_appuser FOREIGN KEY (coduser) REFERENCES appuser(iduser) ON UPDATE CASCADE ON DELETE SET NULL;
--
-- Definition for index fk_performa_rel_group (OID = 101535) : 
--
ALTER TABLE ONLY performance
    ADD CONSTRAINT fk_performa_rel_group FOREIGN KEY (codgroup) REFERENCES appgroup(idgroup) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_performa_rel_intrv_intervie (OID = 101540) : 
--
ALTER TABLE ONLY performance
    ADD CONSTRAINT fk_performa_rel_intrv_intervie FOREIGN KEY (codinterview) REFERENCES interview(idinterview) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_performa_rel_pat_p_patient (OID = 101545) : 
--
ALTER TABLE ONLY performance
    ADD CONSTRAINT fk_performa_rel_pat_p_patient FOREIGN KEY (codpat) REFERENCES patient(idpat) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_question (OID = 101550) : 
--
ALTER TABLE ONLY question_ansitem
    ADD CONSTRAINT fk_question FOREIGN KEY (codquestion) REFERENCES question(idquestion) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_question_itemisa2_item (OID = 101555) : 
--
ALTER TABLE ONLY question
    ADD CONSTRAINT fk_question_itemisa2_item FOREIGN KEY (idquestion) REFERENCES item(iditem) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_rel_grp__rel_grp_a_appgroup (OID = 101560) : 
--
ALTER TABLE ONLY rel_grp_appusr
    ADD CONSTRAINT fk_rel_grp__rel_grp_a_appgroup FOREIGN KEY (codgroup) REFERENCES appgroup(idgroup) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_rel_grp__rel_grp_a_appuser (OID = 101565) : 
--
ALTER TABLE ONLY rel_grp_appusr
    ADD CONSTRAINT fk_rel_grp__rel_grp_a_appuser FOREIGN KEY (coduser) REFERENCES appuser(iduser) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_rel_prj__rel_prj_a_appuser (OID = 101570) : 
--
ALTER TABLE ONLY rel_prj_appusers
    ADD CONSTRAINT fk_rel_prj__rel_prj_a_appuser FOREIGN KEY (coduser) REFERENCES appuser(iduser) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_rel_prj__rel_prj_a_project (OID = 101575) : 
--
ALTER TABLE ONLY rel_prj_appusers
    ADD CONSTRAINT fk_rel_prj__rel_prj_a_project FOREIGN KEY (codprj) REFERENCES project(idprj) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_section_is_formed_interview (OID = 101580) : 
--
ALTER TABLE ONLY section
    ADD CONSTRAINT fk_section_is_formed_interview FOREIGN KEY (codinterview) REFERENCES interview(idinterview) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_text_itemisa_item (OID = 101585) : 
--
ALTER TABLE ONLY text
    ADD CONSTRAINT fk_text_itemisa_item FOREIGN KEY (idtext) REFERENCES item(iditem) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_userrole_role (OID = 101590) : 
--
ALTER TABLE ONLY user_role
    ADD CONSTRAINT fk_userrole_role FOREIGN KEY (codrole) REFERENCES "role"(idrole) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_userrole_user (OID = 101595) : 
--
ALTER TABLE ONLY user_role
    ADD CONSTRAINT fk_userrole_user FOREIGN KEY (coduser) REFERENCES appuser(iduser) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fk_usr_ternary_rel (OID = 101600) : 
--
ALTER TABLE ONLY usr_pat_intrinst
    ADD CONSTRAINT fk_usr_ternary_rel FOREIGN KEY (coduser) REFERENCES appuser(iduser) ON UPDATE CASCADE ON DELETE CASCADE;
--
-- Definition for index fka7c31030289fe600 (OID = 101605) : 
--
ALTER TABLE ONLY performance
    ADD CONSTRAINT fka7c31030289fe600 FOREIGN KEY (coduser) REFERENCES appuser(iduser);
--
-- Definition for index fka7c310307bd5537b (OID = 101610) : 
--
ALTER TABLE ONLY performance
    ADD CONSTRAINT fka7c310307bd5537b FOREIGN KEY (codinterview) REFERENCES interview(idinterview);
--
-- Definition for index fka7c310309fd61a61 (OID = 101615) : 
--
ALTER TABLE ONLY performance
    ADD CONSTRAINT fka7c310309fd61a61 FOREIGN KEY (codpat) REFERENCES patient(idpat);
--
-- Definition for index fka7c31030e9d1abd4 (OID = 101620) : 
--
ALTER TABLE ONLY performance
    ADD CONSTRAINT fka7c31030e9d1abd4 FOREIGN KEY (codgroup) REFERENCES appgroup(idgroup);
--
-- Definition for index fkabca3fbe5c3d6ca1 (OID = 101625) : 
--
ALTER TABLE ONLY answer
    ADD CONSTRAINT fkabca3fbe5c3d6ca1 FOREIGN KEY (codansitem) REFERENCES answer_item(idansitem);
--
-- Definition for index fkb00210386a4127c5 (OID = 101630) : 
--
ALTER TABLE ONLY answertype
    ADD CONSTRAINT fkb00210386a4127c5 FOREIGN KEY (idanstype) REFERENCES answer_item(idansitem);
--
-- Definition for index fkba823be6e7b3fc5 (OID = 101635) : 
--
ALTER TABLE ONLY question
    ADD CONSTRAINT fkba823be6e7b3fc5 FOREIGN KEY (idquestion) REFERENCES item(iditem);
--
-- Definition for index fkd0bc6d6cff274c45 (OID = 101640) : 
--
ALTER TABLE ONLY appuser
    ADD CONSTRAINT fkd0bc6d6cff274c45 FOREIGN KEY (codhosp) REFERENCES hospital(idhosp);
--
-- Definition for index fkd0e56e24289fe600 (OID = 101645) : 
--
ALTER TABLE ONLY rel_prj_appusers
    ADD CONSTRAINT fkd0e56e24289fe600 FOREIGN KEY (coduser) REFERENCES appuser(iduser);
--
-- Definition for index fkd0e56e24bc927c7a (OID = 101650) : 
--
ALTER TABLE ONLY rel_prj_appusers
    ADD CONSTRAINT fkd0e56e24bc927c7a FOREIGN KEY (codprj) REFERENCES project(idprj);
--
-- Definition for index fkd6209a2d9fd61a61 (OID = 101655) : 
--
ALTER TABLE ONLY pat_gives_answer2ques
    ADD CONSTRAINT fkd6209a2d9fd61a61 FOREIGN KEY (codpat) REFERENCES patient(idpat);
--
-- Definition for index fkd6209a2db9245433 (OID = 101660) : 
--
ALTER TABLE ONLY pat_gives_answer2ques
    ADD CONSTRAINT fkd6209a2db9245433 FOREIGN KEY (codquestion) REFERENCES question(idquestion);
--
-- Definition for index fkd6209a2dcefe49a3 (OID = 101665) : 
--
ALTER TABLE ONLY pat_gives_answer2ques
    ADD CONSTRAINT fkd6209a2dcefe49a3 FOREIGN KEY (codanswer) REFERENCES answer(idanswer);
--
-- Definition for index fked6a1af434d3ec6d (OID = 101670) : 
--
ALTER TABLE ONLY answer_item
    ADD CONSTRAINT fked6a1af434d3ec6d FOREIGN KEY (codintrv) REFERENCES interview(idinterview);
--
-- Definition for index perf_history_fk (OID = 101675) : 
--
ALTER TABLE ONLY perf_history
    ADD CONSTRAINT perf_history_fk FOREIGN KEY (codperf) REFERENCES performance(idperformance) ON UPDATE CASCADE;
--
-- Definition for index user_history_fk (OID = 101680) : 
--
ALTER TABLE ONLY perf_history
    ADD CONSTRAINT user_history_fk FOREIGN KEY (coduser) REFERENCES appuser(iduser) ON UPDATE CASCADE;
--
-- Definition for index fkbbbb053ed2a39b42 (OID = 101685) : 
--
ALTER TABLE ONLY perf_history
    ADD CONSTRAINT fkbbbb053ed2a39b42 FOREIGN KEY (codperf) REFERENCES performance(idperformance);
--
-- Definition for index fkbbbb053e289fe600 (OID = 101690) : 
--
ALTER TABLE ONLY perf_history
    ADD CONSTRAINT fkbbbb053e289fe600 FOREIGN KEY (coduser) REFERENCES appuser(iduser);
--
-- Definition for index test_pkey (OID = 101908) : 
--
ALTER TABLE ONLY test
    ADD CONSTRAINT test_pkey PRIMARY KEY (idtest);
--
-- Definition for trigger onInsertLog (OID = 101318) : 
--
CREATE TRIGGER "onInsertLog"
    BEFORE INSERT ON applog
    FOR EACH ROW
    EXECUTE PROCEDURE set_log_time ();
--
-- Definition for trigger onLogout (OID = 101319) : 
--
CREATE TRIGGER "onLogout"
    AFTER UPDATE ON appuser
    FOR EACH ROW
    EXECUTE PROCEDURE log_appsession_end ();
--
-- Definition for trigger logAnswerUpdate (OID = 110080) : 
--
CREATE TRIGGER "logAnswerUpdate"
    AFTER UPDATE ON answer
    FOR EACH ROW
    EXECUTE PROCEDURE log_upd_answer ();
--
-- Definition for rule deleteRow (OID = 101317) : 
--
CREATE RULE "deleteRow" AS ON DELETE TO viewlog DO INSTEAD DELETE FROM applog WHERE (((applog.thetime = old.thetime) AND (applog.userid = old.userid)) AND ((applog.logmsg)::pg_catalog.text = (old.logmsg)::pg_catalog.text));
--
-- Comments
--
COMMENT ON SCHEMA public IS 'Standard public schema';
COMMENT ON TABLE public.answer IS 'This table represent the value(s) answered for a question (pay attention that one question can have several answers for a single patient)';
COMMENT ON COLUMN public.answer.thevalue IS 'The value which will held the answer';
COMMENT ON COLUMN public.answer.answer_order IS 'This is the order of the answer when the question has several answer items (f.ex. when the question ask a frequency, amount/time units)';
COMMENT ON TABLE public.answer_item IS 'This one represents each response for a question, considering that any question can be more than one item as response (for ex, month and years, or amount and a dimensional unit as time, weight...). It includes answer types (answertype table) and enum types (enumtype table, types which are actually enumerated types)';
COMMENT ON COLUMN public.answer_item.answer_order IS 'Not used';
COMMENT ON COLUMN public.answer_item.name IS 'This is the name of the answer item (ex, decimal)';
COMMENT ON COLUMN public.answer_item.codintrv IS 'The interview which the answer item belongs to. This is to be able to encapsulate a whole interview template and to be able to use the same answer item with different interviews by cloning them';
COMMENT ON TABLE public.answertype IS 'Represents normal answer types, as label, number...';
COMMENT ON COLUMN public.answertype.idanstype IS 'This is a type which represents a ''simple'' type like numbers or labels';
COMMENT ON COLUMN public.answertype.pattern IS 'Not used. Intended to define a fixed pattern for labels';
COMMENT ON TABLE public.appgroup IS 'A group of users. All users in a group will have access to the same data, but not all of them will have the same rights (which will be given by the role concept/table)';
COMMENT ON TABLE public.applog IS 'This table hold log messages from all over the application';
COMMENT ON COLUMN public.applog.userid IS 'This is the id of the user in the appuser table. Useful to query';
COMMENT ON COLUMN public.applog.sessionid IS 'This is the application session id';
COMMENT ON COLUMN public.applog.lastip IS 'This is the last ip got from the ip packet as returned by ServletRequest.getRemoteAddr() method';
COMMENT ON TABLE public.appuser IS 'This entity represents the individuals which are going to use the application.';
COMMENT ON COLUMN public.appuser.codhosp IS 'Not used. The table rel_grp_appusr supplies this information and replaces this one.';
COMMENT ON COLUMN public.appuser.country IS 'Not used. Intended to set the country for the user. Replaced by the relationship rel_grp_appusr';
COMMENT ON COLUMN public.appuser.removed IS 'This field says if the user was removed (actually disabled) from the database. This means it can not access to the app';
COMMENT ON COLUMN public.appuser.loggedin IS 'Indicates in the database when one user is using the application or not';
COMMENT ON COLUMN public.appuser.loggedfrom IS 'This field represents the IP address where the user is online from. If the user is not online, will be null';
COMMENT ON COLUMN public.appuser.login_attempts IS 'This is a counter to track how many login attemps the user tries and to disable the user if so';
COMMENT ON COLUMN public.appuser.email IS 'The email of the user. Necessary to contact with him/her, mostly in the case of password loose';
COMMENT ON TABLE public.enumitem IS 'The items belonging to a single enumeration type';
COMMENT ON COLUMN public.enumitem.name IS 'The name of this item in the enum type';
COMMENT ON COLUMN public.enumitem.thevalue IS 'The value which will be held by this enum item';
COMMENT ON COLUMN public.enumitem.listorder IS 'The order of this enumeration item in the enumeration type';
COMMENT ON TABLE public.enumtype IS 'The type enumeration is intended as a container of a set of discrete values (enumitem)';
COMMENT ON COLUMN public.enumtype.numitems IS 'Intended to provide the number of enum items for this enumeration type';
COMMENT ON TABLE public.grouptype IS 'This is a relation to define the group type, which can be, in this case, a country as a main group and a hospital or lab as the secondary group. Higher hierarchies can be set';
COMMENT ON TABLE public.hospital IS 'Not used. This was replace by a combination of appgroup and grouptype elements';
COMMENT ON TABLE public.interview IS 'This table holds the interview templates, which means the questionnaires, opposite to performance interviews, which are intended as the interviews to the study subjects.';
COMMENT ON COLUMN public.interview.codprj IS 'FK. The id of the project which this interview belongs to';
COMMENT ON COLUMN public.interview.codusr IS 'FK. This is the user which created this interview.';
COMMENT ON COLUMN public.interview.c_date IS 'Creation date. Not used so far.';
COMMENT ON COLUMN public.interview.u_date IS 'Update date. Not used so far.';
COMMENT ON COLUMN public.interview.source IS 'FK. Parent-child relationship to set if an interview is cloned from another. This has to be done as the clone interviews don''t have the same properties as the source (parent) interview';
COMMENT ON TABLE public.intrv_group IS 'Relation between an interview and a group. This is to define which main group (country in this case, it should be a company or something more generic) the interview belongs to';
COMMENT ON COLUMN public.intrv_group.codintrv IS 'The id of the interview';
COMMENT ON COLUMN public.intrv_group.codgroup IS 'The id of the group which the interview will belong to';
COMMENT ON TABLE public.item IS 'Superclass entity which serves as an entity to represent both texts, questions and text/question grouping (item grouping)';
COMMENT ON COLUMN public.item.idsection IS 'FK. The section id which this item will be inside of';
COMMENT ON COLUMN public.item.ite_iditem IS 'The parent item for this item in the case of this item belongs to a group of items';
COMMENT ON COLUMN public.item.content IS 'The text for this item, either text item or question';
COMMENT ON COLUMN public.item.item_order IS 'The order of the item into the section';
COMMENT ON COLUMN public.item.c_date IS 'Creation date. Not used so far.';
COMMENT ON COLUMN public.item.u_date IS 'Update date. Not used so far.';
COMMENT ON COLUMN public.item.repeatable IS 'Indicates whether or not this item (and its subitems) are repeatable in the interview to the subject (ex. for names of the siblings is necessary this functionality as you dont know how many siblings a subject has)';
COMMENT ON COLUMN public.item.highlight IS 'A number for indicating if this item has to be highlighted (this means to use bold, italic or underline)';
COMMENT ON TABLE public.pat_gives_answer2ques IS 'Several patients gives several answers for the questions. This is the ternary relationship to connect the patients and answers and questions.
The two attributes are:
- answer_number, for questions with several answers (repeatitivity)
- answer_order, for questions with multiple values for the answer, for ex, frequencies';
COMMENT ON COLUMN public.pat_gives_answer2ques.codpat IS 'FK. The patient id.';
COMMENT ON COLUMN public.pat_gives_answer2ques.codanswer IS 'The answer id for this question and this patient';
COMMENT ON COLUMN public.pat_gives_answer2ques.codquestion IS 'The question id.';
COMMENT ON COLUMN public.pat_gives_answer2ques.answer_number IS 'The number of answer in the case of the question is a repeatable question with a undefined number of answers.';
COMMENT ON COLUMN public.pat_gives_answer2ques.answer_order IS 'The answer order in the case this question has several answer items (ex, in the case you have to provide a frequency, which is a number / time unit)';
COMMENT ON COLUMN public.pat_gives_answer2ques.answer_grp IS 'Not used. This is in the case there is several group of question nested each other.';
COMMENT ON TABLE public.patient IS 'The subject who is gonna be interviewed. 
The fields here are not commented as it is possible this information is moved to another database';
COMMENT ON COLUMN public.patient.codpatient IS 'This will be the subject identifier to use all along the study and for the tracking interviews';
COMMENT ON COLUMN public.perf_history.coduser IS 'FK for the current user';
COMMENT ON COLUMN public.perf_history.codperf IS 'FK for current performance';
COMMENT ON TABLE public.performance IS 'This is the instance of a interview. 
The database stores application form (interview) models, but these models have to be realized (performed) by making the interview to someone (a patient). So, the realization (performance) of the interview is done by an interviewer for some application form model (chosen from the interview repository or database) to some patient chosen from some target patient/people database.';
COMMENT ON COLUMN public.performance.coduser IS 'The user which has done the interview.';
COMMENT ON COLUMN public.performance.codinterview IS 'The interview id which was performed by the user to the subject (patient)';
COMMENT ON COLUMN public.performance.codpat IS 'The subject id (patient id) for the interview which has done by the interviewer (user)';
COMMENT ON COLUMN public.performance.date_ini IS 'The starting date of the performance. Mostly not used so far.';
COMMENT ON COLUMN public.performance.date_end IS 'The finish date of the performance. Mostly not used so far.';
COMMENT ON COLUMN public.performance.num_order IS 'Not used.';
COMMENT ON COLUMN public.performance.last_sec IS 'This is the last section which was last performed. As the interview performance can be resumed, this field is useful to resume from the last point.';
COMMENT ON COLUMN public.performance.codgroup IS 'The group id this performance will belong to';
COMMENT ON TABLE public.project IS 'A project is compound by interviews and has several users associated with it';
COMMENT ON TABLE public.question IS 'This represents the question in a section in a interview';
COMMENT ON COLUMN public.question.codquestion IS 'This is a particular question code for every question in order to discriminate questions when the gross data has to be processed';
COMMENT ON COLUMN public.question.mandatory IS 'Not used so far. All questions are mandatory. Further functionality can make use of this field.';
COMMENT ON TABLE public.question_ansitem IS 'One question can expect more than one item as response, even although only one would be the normal situation. Opposite, an answer-item can be present as an answer-item for several questions';
COMMENT ON COLUMN public.question_ansitem.codansitem IS 'The id of the answer item for this question';
COMMENT ON COLUMN public.question_ansitem.codquestion IS 'The question id which the answer item is related to';
COMMENT ON COLUMN public.question_ansitem.answer_order IS 'The answer order for this answer item for the question. Answer items has to be ordered to know which answer item is being used in every case';
COMMENT ON COLUMN public.question_ansitem.pattern IS 'Not used.';
COMMENT ON TABLE public.rel_grp_appusr IS 'Typical membership relation between users and groups';
COMMENT ON COLUMN public.rel_grp_appusr.codgroup IS 'The group id for this relationship';
COMMENT ON COLUMN public.rel_grp_appusr.coduser IS 'The user id for this relationship';
COMMENT ON COLUMN public.rel_grp_appusr.active IS 'This field indicates when a group is CURRENTLY active for the current session for the owner user. 1 means active';
COMMENT ON TABLE public.rel_prj_appusers IS 'Similar to groups and users, this is a relation between the projects and the users which can work on this project.';
COMMENT ON TABLE public.role IS 'The roles will be assigned to the application users. As usual, the roles will allow different capabilities (edit interviews, just viewing interviews,...)
This table can be expanded in the case of implementing a theoretical RBAC (Role-Based Access Control) model.';
COMMENT ON TABLE public.section IS 'A piece which a interview is splitted in to contain several related questions. This is the normal way to compose an interview template.';
COMMENT ON COLUMN public.section.section_order IS 'The order of the section in the interview';
COMMENT ON COLUMN public.section.codinterview IS 'The interview where this section is contained in. This is, the parent interview';
COMMENT ON COLUMN public.section.c_date IS 'Creation date. Not used so far.';
COMMENT ON COLUMN public.section.u_date IS 'Update date. Not used so far.';
COMMENT ON TABLE public.text IS 'This is just an item text. The content of this element is the field ''content'' of the item table';
COMMENT ON COLUMN public.text.highlighted IS 'Not used. Instead, the highlight field in the item table.';
COMMENT ON TABLE public.user_role IS 'Relationship to set the roles for a application user.';
COMMENT ON COLUMN public.user_role.coduser IS 'The id of the application user';
COMMENT ON COLUMN public.user_role.codrole IS 'The id of the application role';
COMMENT ON COLUMN public.user_role.username IS 'This is necessary to implement JDBCRealm in Tomcat. It is redundant, as the username field is in the appuser table';
COMMENT ON COLUMN public.user_role.rolename IS 'This is necessary to implement JDBCRealm in Tomcat. It is redundant, as the rolename field is in the role table';
COMMENT ON VIEW public.viewlog IS 'This view shows the last entries in the applog table, this means, the last logged entries';
COMMENT ON FUNCTION public.log_appsession_end () IS 'This function gets the previous row in the applog table for the same session id and inserts a row logging the user logged out. This function is used by the onLogout trigger';
COMMENT ON FUNCTION public.set_log_time () IS 'This is a trigger function to insert the correct time value in the ''thetime'' field in the applog table to avoid:
- nulls from hibernate
- time mismatching between the application server machine and the db machine

The function returns null to skip the current operation on the row using a row-level trigger';
COMMENT ON TRIGGER "onInsertLog" ON applog IS 'This trigger is used in order to get the correct time to insert into the applog table';
COMMENT ON TRIGGER "onLogout" ON appuser IS 'This trigger logs to the applog table the users'' logout in the application. The logging for the login is done in the jsp/index.jsp page';
COMMENT ON TABLE public.test IS 'Table to test things';
