-- SQL Manager 2007 for PostgreSQL 4.3.0.1
-- ---------------------------------------
-- Host      : localhost
-- Database  : appform
-- Version   : PostgreSQL 8.2.5 on i386-apple-darwin9.3.0, compiled by GCC i686-apple-darwin9-gcc-4.0.1 (GCC) 4.0.1 (Apple Inc. build 5465)


SET search_path = public, pg_catalog;
DROP TRIGGER IF EXISTS "logAnswerUpdate" ON public.answer;
DROP TRIGGER IF EXISTS "onCreateUser" ON public.appuser;
DROP TRIGGER IF EXISTS "onLogout" ON public.appuser;
DROP TRIGGER IF EXISTS "onInsertLog" ON public.applog;
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
DROP FUNCTION IF EXISTS public."resetPasswd" ();
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
-- Definition for language plpgsql (OID = 119379) : 
--
CREATE TRUSTED PROCEDURAL LANGUAGE plpgsql
   HANDLER "plpgsql_call_handler"
;
SET check_function_bodies = false;
--
-- Definition for function log_appsession_end (OID = 119475) : 
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
-- Definition for function log_tmpl_intrv (OID = 119476) : 
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
-- Definition for function set_log_time (OID = 119477) : 
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
-- Definition for function digest (OID = 123401) : 
--
CREATE FUNCTION public.digest (pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_digest'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function digest (OID = 123402) : 
--
CREATE FUNCTION public.digest (bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_digest'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function hmac (OID = 123403) : 
--
CREATE FUNCTION public.hmac (pg_catalog.text, pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_hmac'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function hmac (OID = 123404) : 
--
CREATE FUNCTION public.hmac (bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_hmac'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function crypt (OID = 123405) : 
--
CREATE FUNCTION public.crypt (pg_catalog.text, pg_catalog.text) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pg_crypt'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function gen_salt (OID = 123406) : 
--
CREATE FUNCTION public.gen_salt (pg_catalog.text) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pg_gen_salt'
    LANGUAGE c STRICT;
--
-- Definition for function gen_salt (OID = 123407) : 
--
CREATE FUNCTION public.gen_salt (pg_catalog.text, integer) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pg_gen_salt_rounds'
    LANGUAGE c STRICT;
--
-- Definition for function encrypt (OID = 123408) : 
--
CREATE FUNCTION public.encrypt (bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_encrypt'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function decrypt (OID = 123409) : 
--
CREATE FUNCTION public.decrypt (bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_decrypt'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function encrypt_iv (OID = 123410) : 
--
CREATE FUNCTION public.encrypt_iv (bytea, bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_encrypt_iv'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function decrypt_iv (OID = 123411) : 
--
CREATE FUNCTION public.decrypt_iv (bytea, bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_decrypt_iv'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function gen_random_bytes (OID = 123412) : 
--
CREATE FUNCTION public.gen_random_bytes (integer) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_random_bytes'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_sym_encrypt (OID = 123413) : 
--
CREATE FUNCTION public.pgp_sym_encrypt (pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_sym_encrypt_text'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_sym_encrypt_bytea (OID = 123414) : 
--
CREATE FUNCTION public.pgp_sym_encrypt_bytea (bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_sym_encrypt_bytea'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_sym_encrypt (OID = 123415) : 
--
CREATE FUNCTION public.pgp_sym_encrypt (pg_catalog.text, pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_sym_encrypt_text'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_sym_encrypt_bytea (OID = 123416) : 
--
CREATE FUNCTION public.pgp_sym_encrypt_bytea (bytea, pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_sym_encrypt_bytea'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_sym_decrypt (OID = 123417) : 
--
CREATE FUNCTION public.pgp_sym_decrypt (bytea, pg_catalog.text) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pgp_sym_decrypt_text'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_sym_decrypt_bytea (OID = 123418) : 
--
CREATE FUNCTION public.pgp_sym_decrypt_bytea (bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_sym_decrypt_bytea'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_sym_decrypt (OID = 123419) : 
--
CREATE FUNCTION public.pgp_sym_decrypt (bytea, pg_catalog.text, pg_catalog.text) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pgp_sym_decrypt_text'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_sym_decrypt_bytea (OID = 123420) : 
--
CREATE FUNCTION public.pgp_sym_decrypt_bytea (bytea, pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_sym_decrypt_bytea'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_pub_encrypt (OID = 123421) : 
--
CREATE FUNCTION public.pgp_pub_encrypt (pg_catalog.text, bytea) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_encrypt_text'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_pub_encrypt_bytea (OID = 123422) : 
--
CREATE FUNCTION public.pgp_pub_encrypt_bytea (bytea, bytea) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_encrypt_bytea'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_pub_encrypt (OID = 123423) : 
--
CREATE FUNCTION public.pgp_pub_encrypt (pg_catalog.text, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_encrypt_text'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_pub_encrypt_bytea (OID = 123424) : 
--
CREATE FUNCTION public.pgp_pub_encrypt_bytea (bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_encrypt_bytea'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_pub_decrypt (OID = 123425) : 
--
CREATE FUNCTION public.pgp_pub_decrypt (bytea, bytea) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pgp_pub_decrypt_text'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_pub_decrypt_bytea (OID = 123426) : 
--
CREATE FUNCTION public.pgp_pub_decrypt_bytea (bytea, bytea) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_decrypt_bytea'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_pub_decrypt (OID = 123427) : 
--
CREATE FUNCTION public.pgp_pub_decrypt (bytea, bytea, pg_catalog.text) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pgp_pub_decrypt_text'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_pub_decrypt_bytea (OID = 123428) : 
--
CREATE FUNCTION public.pgp_pub_decrypt_bytea (bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_decrypt_bytea'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_pub_decrypt (OID = 123429) : 
--
CREATE FUNCTION public.pgp_pub_decrypt (bytea, bytea, pg_catalog.text, pg_catalog.text) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pgp_pub_decrypt_text'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_pub_decrypt_bytea (OID = 123430) : 
--
CREATE FUNCTION public.pgp_pub_decrypt_bytea (bytea, bytea, pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_decrypt_bytea'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_key_id (OID = 123431) : 
--
CREATE FUNCTION public.pgp_key_id (bytea) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pgp_key_id_w'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function armor (OID = 123432) : 
--
CREATE FUNCTION public.armor (bytea) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pg_armor'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function dearmor (OID = 123433) : 
--
CREATE FUNCTION public.dearmor (pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_dearmor'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function log_upd_answer (OID = 123434) : 
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
/*      insert into test (content) values (msglog);      
    else
    	insert into test (content) values ('Nothing was updated');  
*/     
	  end if;
   
  end if; -- if TG_UPDATE
  return null;
  
END;
$body$
    LANGUAGE plpgsql;
--
-- Definition for function resetPasswd (OID = 123435) : 
--
CREATE FUNCTION public."resetPasswd" () RETURNS "trigger"
AS 
$body$
DECLARE
  newpasswd varchar;
  oldpasswd varchar;
  
  user_row appuser%ROWTYPE;
BEGIN  
-- This is to encrypt the password when new user is added
  if (NEW.passwd = NEW.username) then
  	oldpasswd = NEW.passwd;
  	newpasswd = crypt (NEW.passwd, gen_salt('md5'));
  	NEW.passwd = newpasswd;
-- insert into test (content) values ('passwd = username: new password: '||NEW.passwd);
-- this is to encrypt the password when a new password is requested
  ELSEif (NEW.passwd <> OLD.passwd) then
  	newpasswd = crypt (NEW.passwd, gen_salt('md5'));
  	NEW.passwd = newpasswd;
-- insert into test (content) values ('new.passwd <> old.passwd: new password: ' || NEW.passwd);
  end if;
   
  return NEW;
END;
$body$
    LANGUAGE plpgsql;
--
-- Structure for table answer (OID = 119380) : 
--
CREATE TABLE public.answer (
    idanswer integer DEFAULT nextval('answer_idanswer_seq'::regclass) NOT NULL,
    thevalue character varying(512),
    answer_order integer,
    codansitem integer NOT NULL
) WITHOUT OIDS;
--
-- Structure for table answer_item (OID = 119385) : 
--
CREATE TABLE public.answer_item (
    idansitem integer DEFAULT nextval('answer_item_idansitem_seq'::regclass) NOT NULL,
    answer_order integer,
    name character varying(128),
    description character varying(128),
    codintrv integer
) WITHOUT OIDS;
--
-- Structure for table answertype (OID = 119387) : 
--
CREATE TABLE public.answertype (
    idanstype integer NOT NULL,
    pattern character varying(256)
) WITHOUT OIDS;
--
-- Structure for table appgroup (OID = 119389) : 
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
-- Structure for table applog (OID = 119392) : 
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
-- Structure for table appuser (OID = 119397) : 
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
-- Structure for table enumitem (OID = 119405) : 
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
-- Structure for table enumtype (OID = 119410) : 
--
CREATE TABLE public.enumtype (
    idenumtype integer NOT NULL,
    numitems integer
) WITHOUT OIDS;
--
-- Structure for table grouptype (OID = 119412) : 
--
CREATE TABLE public.grouptype (
    idgrouptype integer DEFAULT nextval('grouptype_idgrouptype_seq'::regclass) NOT NULL,
    name character varying(128) NOT NULL,
    description character varying(1024)
) WITHOUT OIDS;
--
-- Structure for table hospital (OID = 119417) : 
--
CREATE TABLE public.hospital (
    idhosp integer DEFAULT nextval('hospital_idhosp_seq'::regclass) NOT NULL,
    name character varying(128) NOT NULL,
    hospcod integer NOT NULL,
    c_date timestamp without time zone DEFAULT now(),
    u_date timestamp without time zone
) WITHOUT OIDS;
--
-- Structure for table interview (OID = 119420) : 
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
-- Structure for table intr_instance (OID = 119423) : 
--
CREATE TABLE public.intr_instance (
    idinstance integer DEFAULT nextval('intr_instance_idinstance_seq'::regclass) NOT NULL,
    place character varying(256),
    date_ini timestamp without time zone,
    date_end timestamp without time zone,
    codinterview integer NOT NULL
) WITHOUT OIDS;
--
-- Structure for table intrv_group (OID = 119425) : 
--
CREATE TABLE public.intrv_group (
    idintrv_group integer DEFAULT nextval('intrv_group_idintrv_group_seq'::regclass) NOT NULL,
    codintrv integer NOT NULL,
    codgroup integer NOT NULL
) WITHOUT OIDS;
--
-- Structure for table item (OID = 119427) : 
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
-- Structure for table pat_gives_answer2ques (OID = 119434) : 
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
-- Structure for table patient (OID = 119436) : 
--
CREATE TABLE public.patient (
    idpat integer DEFAULT nextval('patient_idpat_seq'::regclass) NOT NULL,
    name character varying(256),
    codpatient character varying(15) NOT NULL,
    address character varying(512),
    phone character varying(20),
    numhc character varying(32),
    c_date timestamp without time zone DEFAULT now(),
    u_date timestamp without time zone,
    cod_type_subject character varying(255),
    codhosp character varying(255),
    codprj character varying(255),
    codpat character varying(255)
) WITHOUT OIDS;
--
-- Structure for table perf_history (OID = 119442) : 
--
CREATE TABLE public.perf_history (
    idhistory integer DEFAULT nextval('perf_history_idhistory_seq'::regclass) NOT NULL,
    thetimestamp timestamp without time zone,
    coduser integer NOT NULL,
    codperf integer NOT NULL,
    iduser_role integer
);
--
-- Structure for table performance (OID = 119444) : 
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
-- Structure for table project (OID = 119447) : 
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
-- Structure for table question (OID = 119450) : 
--
CREATE TABLE public.question (
    idquestion integer DEFAULT nextval('question_idquestion_seq'::regclass) NOT NULL,
    repeatable integer,
    codquestion character varying(16),
    mandatory integer DEFAULT 0
) WITHOUT OIDS;
--
-- Structure for table question_ansitem (OID = 119453) : 
--
CREATE TABLE public.question_ansitem (
    id integer DEFAULT nextval('question_ansitem_id_seq'::regclass) NOT NULL,
    codansitem integer NOT NULL,
    codquestion integer NOT NULL,
    answer_order integer,
    pattern character varying(255)
) WITHOUT OIDS;
--
-- Structure for table rel_grp_appusr (OID = 119455) : 
--
CREATE TABLE public.rel_grp_appusr (
    idgrp_usr integer DEFAULT nextval('rel_grp_appusr_idgrp_usr_seq'::regclass) NOT NULL,
    codgroup integer NOT NULL,
    coduser integer NOT NULL,
    active integer DEFAULT 0
) WITHOUT OIDS;
--
-- Structure for table rel_prj_appusers (OID = 119458) : 
--
CREATE TABLE public.rel_prj_appusers (
    idprj_usrs integer DEFAULT nextval('rel_prj_appusers_idprj_usrs_seq'::regclass) NOT NULL,
    codprj integer NOT NULL,
    coduser integer NOT NULL
) WITHOUT OIDS;
--
-- Structure for table role (OID = 119460) : 
--
CREATE TABLE public.role (
    idrole integer DEFAULT nextval('role_idrole_seq'::regclass) NOT NULL,
    name character varying(128),
    description character varying(128),
    c_date timestamp without time zone DEFAULT now(),
    u_date timestamp without time zone
) WITHOUT OIDS;
--
-- Structure for table section (OID = 119463) : 
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
-- Structure for table text (OID = 119466) : 
--
CREATE TABLE public.text (
    idtext integer DEFAULT nextval('text_idtext_seq'::regclass) NOT NULL,
    highlighted integer
) WITHOUT OIDS;
--
-- Structure for table user_role (OID = 119468) : 
--
CREATE TABLE public.user_role (
    iduser_role integer DEFAULT nextval('user_role_iduser_role_seq'::regclass) NOT NULL,
    coduser integer NOT NULL,
    codrole integer NOT NULL,
    username character varying(128),
    rolename character varying(128)
) WITHOUT OIDS;
--
-- Structure for table usr_pat_intrinst (OID = 119470) : 
--
CREATE TABLE public.usr_pat_intrinst (
    id_upi integer DEFAULT nextval('usr_pat_intrinst_id_upi_seq'::regclass) NOT NULL,
    coduser integer NOT NULL,
    codpatient integer NOT NULL,
    codintr_ins integer NOT NULL
) WITHOUT OIDS;
--
-- Definition for view viewlog (OID = 119472) : 
--
CREATE VIEW public.viewlog AS
SELECT a.thetime, a.userid, a.logmsg, a.lastip, a.sessionid AS sessid
FROM applog a
ORDER BY a.thetime DESC;

--
-- Definition for function log_appsession_end (OID = 119475) : 
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
-- Definition for function log_tmpl_intrv (OID = 119476) : 
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
-- Definition for function set_log_time (OID = 119477) : 
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
-- Definition for sequence answer_idanswer_seq (OID = 119478) : 
--
CREATE SEQUENCE public.answer_idanswer_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence answer_item_idansitem_seq (OID = 119480) : 
--
CREATE SEQUENCE public.answer_item_idansitem_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence appgroup_idgroup_seq (OID = 119482) : 
--
CREATE SEQUENCE public.appgroup_idgroup_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence applog_logid_seq (OID = 119484) : 
--
CREATE SEQUENCE public.applog_logid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence appuser_iduser_seq (OID = 119486) : 
--
CREATE SEQUENCE public.appuser_iduser_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence enumitem_idenumitem_seq (OID = 119488) : 
--
CREATE SEQUENCE public.enumitem_idenumitem_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence grouptype_idgrouptype_seq (OID = 119490) : 
--
CREATE SEQUENCE public.grouptype_idgrouptype_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence hospital_idhosp_seq (OID = 119492) : 
--
CREATE SEQUENCE public.hospital_idhosp_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence interview_idinterview_seq (OID = 119494) : 
--
CREATE SEQUENCE public.interview_idinterview_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence intr_instance_idinstance_seq (OID = 119496) : 
--
CREATE SEQUENCE public.intr_instance_idinstance_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence intrv_group_idintrv_group_seq (OID = 119498) : 
--
CREATE SEQUENCE public.intrv_group_idintrv_group_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence item_iditem_seq (OID = 119500) : 
--
CREATE SEQUENCE public.item_iditem_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence pat_gives_answer2ques_idp_a_q_seq (OID = 119502) : 
--
CREATE SEQUENCE public.pat_gives_answer2ques_idp_a_q_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence patient_idpat_seq (OID = 119504) : 
--
CREATE SEQUENCE public.patient_idpat_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence patient_idpatient_seq (OID = 119506) : 
--
CREATE SEQUENCE public.patient_idpatient_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence perf_history_idhistory_seq (OID = 119508) : 
--
CREATE SEQUENCE public.perf_history_idhistory_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence performance_idperformance_seq (OID = 119510) : 
--
CREATE SEQUENCE public.performance_idperformance_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence project_idprj_seq (OID = 119512) : 
--
CREATE SEQUENCE public.project_idprj_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence project_idproject_seq (OID = 119514) : 
--
CREATE SEQUENCE public.project_idproject_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence question_ansitem_id_seq (OID = 119516) : 
--
CREATE SEQUENCE public.question_ansitem_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence question_idquestion_seq (OID = 119518) : 
--
CREATE SEQUENCE public.question_idquestion_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence rel_grp_appusr_idgrp_usr_seq (OID = 119520) : 
--
CREATE SEQUENCE public.rel_grp_appusr_idgrp_usr_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence rel_prj_appusers_idprj_usrs_seq (OID = 119522) : 
--
CREATE SEQUENCE public.rel_prj_appusers_idprj_usrs_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence role_idrole_seq (OID = 119524) : 
--
CREATE SEQUENCE public.role_idrole_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence section_idsection_seq (OID = 119526) : 
--
CREATE SEQUENCE public.section_idsection_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence text_idtext_seq (OID = 119528) : 
--
CREATE SEQUENCE public.text_idtext_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence user_role_iduser_role_seq (OID = 119530) : 
--
CREATE SEQUENCE public.user_role_iduser_role_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for sequence usr_pat_intrinst_id_upi_seq (OID = 119532) : 
--
CREATE SEQUENCE public.usr_pat_intrinst_id_upi_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
--
-- Definition for function digest (OID = 123401) : 
--
CREATE FUNCTION public.digest (pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_digest'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function digest (OID = 123402) : 
--
CREATE FUNCTION public.digest (bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_digest'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function hmac (OID = 123403) : 
--
CREATE FUNCTION public.hmac (pg_catalog.text, pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_hmac'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function hmac (OID = 123404) : 
--
CREATE FUNCTION public.hmac (bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_hmac'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function crypt (OID = 123405) : 
--
CREATE FUNCTION public.crypt (pg_catalog.text, pg_catalog.text) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pg_crypt'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function gen_salt (OID = 123406) : 
--
CREATE FUNCTION public.gen_salt (pg_catalog.text) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pg_gen_salt'
    LANGUAGE c STRICT;
--
-- Definition for function gen_salt (OID = 123407) : 
--
CREATE FUNCTION public.gen_salt (pg_catalog.text, integer) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pg_gen_salt_rounds'
    LANGUAGE c STRICT;
--
-- Definition for function encrypt (OID = 123408) : 
--
CREATE FUNCTION public.encrypt (bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_encrypt'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function decrypt (OID = 123409) : 
--
CREATE FUNCTION public.decrypt (bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_decrypt'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function encrypt_iv (OID = 123410) : 
--
CREATE FUNCTION public.encrypt_iv (bytea, bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_encrypt_iv'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function decrypt_iv (OID = 123411) : 
--
CREATE FUNCTION public.decrypt_iv (bytea, bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_decrypt_iv'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function gen_random_bytes (OID = 123412) : 
--
CREATE FUNCTION public.gen_random_bytes (integer) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_random_bytes'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_sym_encrypt (OID = 123413) : 
--
CREATE FUNCTION public.pgp_sym_encrypt (pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_sym_encrypt_text'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_sym_encrypt_bytea (OID = 123414) : 
--
CREATE FUNCTION public.pgp_sym_encrypt_bytea (bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_sym_encrypt_bytea'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_sym_encrypt (OID = 123415) : 
--
CREATE FUNCTION public.pgp_sym_encrypt (pg_catalog.text, pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_sym_encrypt_text'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_sym_encrypt_bytea (OID = 123416) : 
--
CREATE FUNCTION public.pgp_sym_encrypt_bytea (bytea, pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_sym_encrypt_bytea'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_sym_decrypt (OID = 123417) : 
--
CREATE FUNCTION public.pgp_sym_decrypt (bytea, pg_catalog.text) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pgp_sym_decrypt_text'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_sym_decrypt_bytea (OID = 123418) : 
--
CREATE FUNCTION public.pgp_sym_decrypt_bytea (bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_sym_decrypt_bytea'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_sym_decrypt (OID = 123419) : 
--
CREATE FUNCTION public.pgp_sym_decrypt (bytea, pg_catalog.text, pg_catalog.text) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pgp_sym_decrypt_text'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_sym_decrypt_bytea (OID = 123420) : 
--
CREATE FUNCTION public.pgp_sym_decrypt_bytea (bytea, pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_sym_decrypt_bytea'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_pub_encrypt (OID = 123421) : 
--
CREATE FUNCTION public.pgp_pub_encrypt (pg_catalog.text, bytea) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_encrypt_text'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_pub_encrypt_bytea (OID = 123422) : 
--
CREATE FUNCTION public.pgp_pub_encrypt_bytea (bytea, bytea) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_encrypt_bytea'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_pub_encrypt (OID = 123423) : 
--
CREATE FUNCTION public.pgp_pub_encrypt (pg_catalog.text, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_encrypt_text'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_pub_encrypt_bytea (OID = 123424) : 
--
CREATE FUNCTION public.pgp_pub_encrypt_bytea (bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_encrypt_bytea'
    LANGUAGE c STRICT;
--
-- Definition for function pgp_pub_decrypt (OID = 123425) : 
--
CREATE FUNCTION public.pgp_pub_decrypt (bytea, bytea) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pgp_pub_decrypt_text'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_pub_decrypt_bytea (OID = 123426) : 
--
CREATE FUNCTION public.pgp_pub_decrypt_bytea (bytea, bytea) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_decrypt_bytea'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_pub_decrypt (OID = 123427) : 
--
CREATE FUNCTION public.pgp_pub_decrypt (bytea, bytea, pg_catalog.text) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pgp_pub_decrypt_text'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_pub_decrypt_bytea (OID = 123428) : 
--
CREATE FUNCTION public.pgp_pub_decrypt_bytea (bytea, bytea, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_decrypt_bytea'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_pub_decrypt (OID = 123429) : 
--
CREATE FUNCTION public.pgp_pub_decrypt (bytea, bytea, pg_catalog.text, pg_catalog.text) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pgp_pub_decrypt_text'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_pub_decrypt_bytea (OID = 123430) : 
--
CREATE FUNCTION public.pgp_pub_decrypt_bytea (bytea, bytea, pg_catalog.text, pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pgp_pub_decrypt_bytea'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function pgp_key_id (OID = 123431) : 
--
CREATE FUNCTION public.pgp_key_id (bytea) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pgp_key_id_w'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function armor (OID = 123432) : 
--
CREATE FUNCTION public.armor (bytea) RETURNS pg_catalog.text
AS '$libdir/pgcrypto', 'pg_armor'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function dearmor (OID = 123433) : 
--
CREATE FUNCTION public.dearmor (pg_catalog.text) RETURNS bytea
AS '$libdir/pgcrypto', 'pg_dearmor'
    LANGUAGE c IMMUTABLE STRICT;
--
-- Definition for function log_upd_answer (OID = 123434) : 
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
/*      insert into test (content) values (msglog);      
    else
    	insert into test (content) values ('Nothing was updated');  
*/     
	  end if;
   
  end if; -- if TG_UPDATE
  return null;
  
END;
$body$
    LANGUAGE plpgsql;
--
-- Definition for function resetPasswd (OID = 123435) : 
--
CREATE FUNCTION public."resetPasswd" () RETURNS "trigger"
AS 
$body$
DECLARE
  newpasswd varchar;
  oldpasswd varchar;
  
  user_row appuser%ROWTYPE;
BEGIN  
-- This is to encrypt the password when new user is added
  if (NEW.passwd = NEW.username) then
  	oldpasswd = NEW.passwd;
  	newpasswd = crypt (NEW.passwd, gen_salt('md5'));
  	NEW.passwd = newpasswd;
-- insert into test (content) values ('passwd = username: new password: '||NEW.passwd);
-- this is to encrypt the password when a new password is requested
  ELSEif (NEW.passwd <> OLD.passwd) then
  	newpasswd = crypt (NEW.passwd, gen_salt('md5'));
  	NEW.passwd = newpasswd;
-- insert into test (content) values ('new.passwd <> old.passwd: new password: ' || NEW.passwd);
  end if;
   
  return NEW;
END;
$body$
    LANGUAGE plpgsql;
