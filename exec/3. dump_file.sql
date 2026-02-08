--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Drop databases (except postgres and template1)
--

DROP DATABASE backuptest;
DROP DATABASE jupddang_dev;
DROP DATABASE template_postgis;




--
-- Drop roles
--

DROP ROLE jupddang;


--
-- Roles
--

CREATE ROLE jupddang;
ALTER ROLE jupddang WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:wrSfFd2yYN8CoyIKEgJ9Ig==$gufEM5jnUItrovHxFVDcjfpofYzMuRmqKT8oVQ19Lsk=:pyfG14xCKtiVwxbDj+ycwT9e4ilBD4C6Fx4ltvWIsO0=';

--
-- User Configurations
--








--
-- Databases
--

--
-- Database "template1" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8 (Debian 15.8-1.pgdg110+1)
-- Dumped by pg_dump version 15.8 (Debian 15.8-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

UPDATE pg_catalog.pg_database SET datistemplate = false WHERE datname = 'template1';
DROP DATABASE template1;
--
-- Name: template1; Type: DATABASE; Schema: -; Owner: jupddang
--

CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C';


ALTER DATABASE template1 OWNER TO jupddang;

\connect template1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE template1; Type: COMMENT; Schema: -; Owner: jupddang
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- Name: template1; Type: DATABASE PROPERTIES; Schema: -; Owner: jupddang
--

ALTER DATABASE template1 IS_TEMPLATE = true;


\connect template1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE template1; Type: ACL; Schema: -; Owner: jupddang
--

REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


--
-- PostgreSQL database dump complete
--

--
-- Database "backuptest" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8 (Debian 15.8-1.pgdg110+1)
-- Dumped by pg_dump version 15.8 (Debian 15.8-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: backuptest; Type: DATABASE; Schema: -; Owner: jupddang
--

CREATE DATABASE backuptest WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C';


ALTER DATABASE backuptest OWNER TO jupddang;

\connect backuptest

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: backuptest; Type: DATABASE PROPERTIES; Schema: -; Owner: jupddang
--

ALTER DATABASE backuptest SET search_path TO '$user', 'public', 'tiger', 'topology';


\connect backuptest

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: jupddang
--

CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO jupddang;

--
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: jupddang
--

CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO jupddang;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: jupddang
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO jupddang;

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: jupddang
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- Name: postgis_tiger_geocoder; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder WITH SCHEMA tiger;


--
-- Name: EXTENSION postgis_tiger_geocoder; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_tiger_geocoder IS 'PostGIS tiger geocoder and reverse geocoder';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.account (
    user_id character varying(50) NOT NULL,
    color character varying(255),
    created_at timestamp(6) without time zone NOT NULL,
    email character varying(255) NOT NULL,
    intro character varying(255) NOT NULL,
    nickname character varying(255) NOT NULL,
    profile_image character varying(255) NOT NULL,
    pw character varying(255) NOT NULL,
    tier character varying(255) NOT NULL,
    total_distance double precision NOT NULL,
    total_score bigint NOT NULL,
    total_time integer NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.account OWNER TO jupddang;

--
-- Name: comment; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.comment (
    comment_id bigint NOT NULL,
    content text,
    created_at timestamp(6) without time zone,
    user_id character varying(50),
    post_id bigint
);


ALTER TABLE public.comment OWNER TO jupddang;

--
-- Name: comment_comment_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.comment_comment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comment_comment_id_seq OWNER TO jupddang;

--
-- Name: comment_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.comment_comment_id_seq OWNED BY public.comment.comment_id;


--
-- Name: fcm_tokens; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.fcm_tokens (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    device_type character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.fcm_tokens OWNER TO jupddang;

--
-- Name: fcm_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.fcm_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fcm_tokens_id_seq OWNER TO jupddang;

--
-- Name: fcm_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.fcm_tokens_id_seq OWNED BY public.fcm_tokens.id;


--
-- Name: follow; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.follow (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    follower_id character varying(50) NOT NULL,
    following_id character varying(50) NOT NULL
);


ALTER TABLE public.follow OWNER TO jupddang;

--
-- Name: follow_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.follow_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.follow_id_seq OWNER TO jupddang;

--
-- Name: follow_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.follow_id_seq OWNED BY public.follow.id;


--
-- Name: grids; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.grids (
    grid_id character varying(255) NOT NULL,
    occupied_at timestamp(6) without time zone NOT NULL,
    party_id bigint,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.grids OWNER TO jupddang;

--
-- Name: party; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.party (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    ended_at timestamp(6) without time zone,
    invite_code character varying(6) NOT NULL,
    leader_id character varying(50) NOT NULL,
    max_members integer NOT NULL,
    name character varying(100),
    started_at timestamp(6) without time zone,
    status character varying(255) NOT NULL,
    total_distance double precision,
    total_score integer,
    total_time integer,
    CONSTRAINT party_status_check CHECK (((status)::text = ANY (ARRAY[('WAITING'::character varying)::text, ('IN_PROGRESS'::character varying)::text, ('COMPLETED'::character varying)::text])))
);


ALTER TABLE public.party OWNER TO jupddang;

--
-- Name: party_activity; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.party_activity (
    id bigint NOT NULL,
    distance double precision,
    ended_at timestamp(6) without time zone,
    party_id bigint NOT NULL,
    started_at timestamp(6) without time zone NOT NULL,
    status character varying(255) NOT NULL,
    trash_count integer,
    user_id character varying(50) NOT NULL,
    plogging_id bigint,
    CONSTRAINT party_activity_status_check CHECK (((status)::text = ANY (ARRAY[('IN_PROGRESS'::character varying)::text, ('COMPLETED'::character varying)::text, ('ABANDONED'::character varying)::text])))
);


ALTER TABLE public.party_activity OWNER TO jupddang;

--
-- Name: party_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.party_activity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.party_activity_id_seq OWNER TO jupddang;

--
-- Name: party_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.party_activity_id_seq OWNED BY public.party_activity.id;


--
-- Name: party_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.party_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.party_id_seq OWNER TO jupddang;

--
-- Name: party_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.party_id_seq OWNED BY public.party.id;


--
-- Name: party_member; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.party_member (
    id bigint NOT NULL,
    joined_at timestamp(6) without time zone NOT NULL,
    user_id character varying(50) NOT NULL,
    party_id bigint NOT NULL
);


ALTER TABLE public.party_member OWNER TO jupddang;

--
-- Name: party_member_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.party_member_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.party_member_id_seq OWNER TO jupddang;

--
-- Name: party_member_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.party_member_id_seq OWNED BY public.party_member.id;


--
-- Name: plogging_record; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.plogging_record (
    plogging_record_id bigint NOT NULL
);


ALTER TABLE public.plogging_record OWNER TO jupddang;

--
-- Name: plogging_record_plogging_record_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.plogging_record_plogging_record_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.plogging_record_plogging_record_id_seq OWNER TO jupddang;

--
-- Name: plogging_record_plogging_record_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.plogging_record_plogging_record_id_seq OWNED BY public.plogging_record.plogging_record_id;


--
-- Name: ploggings; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.ploggings (
    plogging_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    distance double precision,
    score integer NOT NULL,
    times integer,
    user_id character varying(50),
    after_image_url character varying(255),
    before_image_url character varying(255),
    content text,
    map_image_url character varying(255),
    record_name character varying(255),
    status character varying(255) DEFAULT 'USED'::character varying
);


ALTER TABLE public.ploggings OWNER TO jupddang;

--
-- Name: ploggings_plogging_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.ploggings_plogging_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ploggings_plogging_id_seq OWNER TO jupddang;

--
-- Name: ploggings_plogging_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.ploggings_plogging_id_seq OWNED BY public.ploggings.plogging_id;


--
-- Name: post; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.post (
    post_id bigint NOT NULL,
    after_image_url character varying(500),
    before_image_url character varying(500),
    content text,
    created_at timestamp(6) without time zone,
    like_cnt integer,
    map_image_url character varying(500),
    plogging_id bigint,
    updated_at timestamp(6) without time zone,
    user_id character varying(50)
);


ALTER TABLE public.post OWNER TO jupddang;

--
-- Name: post_post_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.post_post_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.post_post_id_seq OWNER TO jupddang;

--
-- Name: post_post_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.post_post_id_seq OWNED BY public.post.post_id;


--
-- Name: raid_boss; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.raid_boss (
    id bigint NOT NULL,
    h3index character varying(255) NOT NULL,
    name character varying(255),
    boss_type integer DEFAULT 0
);


ALTER TABLE public.raid_boss OWNER TO jupddang;

--
-- Name: raid_boss_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.raid_boss_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.raid_boss_id_seq OWNER TO jupddang;

--
-- Name: raid_boss_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.raid_boss_id_seq OWNED BY public.raid_boss.id;


--
-- Name: raid_record; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.raid_record (
    id bigint NOT NULL,
    total_score bigint NOT NULL,
    updated_at timestamp(6) without time zone,
    account_user_id character varying(50) NOT NULL,
    boss_id bigint NOT NULL
);


ALTER TABLE public.raid_record OWNER TO jupddang;

--
-- Name: raid_record_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.raid_record_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.raid_record_id_seq OWNER TO jupddang;

--
-- Name: raid_record_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.raid_record_id_seq OWNED BY public.raid_record.id;


--
-- Name: test_entity; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.test_entity (
    id bigint NOT NULL,
    content character varying(255)
);


ALTER TABLE public.test_entity OWNER TO jupddang;

--
-- Name: test_entity_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.test_entity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.test_entity_id_seq OWNER TO jupddang;

--
-- Name: test_entity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.test_entity_id_seq OWNED BY public.test_entity.id;


--
-- Name: trashcan_verifications; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.trashcan_verifications (
    id bigint NOT NULL,
    verified_at timestamp(6) without time zone NOT NULL,
    trashcan_id bigint NOT NULL,
    user_id character varying(50) NOT NULL
);


ALTER TABLE public.trashcan_verifications OWNER TO jupddang;

--
-- Name: trashcan_verifications_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.trashcan_verifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trashcan_verifications_id_seq OWNER TO jupddang;

--
-- Name: trashcan_verifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.trashcan_verifications_id_seq OWNED BY public.trashcan_verifications.id;


--
-- Name: trashcans; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.trashcans (
    id bigint NOT NULL,
    address character varying(500),
    created_at timestamp(6) without time zone NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    status character varying(20) NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    verification_count integer NOT NULL,
    reported_by character varying(50),
    CONSTRAINT trashcans_status_check CHECK (((status)::text = ANY (ARRAY[('OFFICIAL'::character varying)::text, ('PENDING'::character varying)::text, ('VERIFIED'::character varying)::text])))
);


ALTER TABLE public.trashcans OWNER TO jupddang;

--
-- Name: trashcans_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.trashcans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trashcans_id_seq OWNER TO jupddang;

--
-- Name: trashcans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.trashcans_id_seq OWNED BY public.trashcans.id;


--
-- Name: comment comment_id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.comment ALTER COLUMN comment_id SET DEFAULT nextval('public.comment_comment_id_seq'::regclass);


--
-- Name: fcm_tokens id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.fcm_tokens ALTER COLUMN id SET DEFAULT nextval('public.fcm_tokens_id_seq'::regclass);


--
-- Name: follow id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.follow ALTER COLUMN id SET DEFAULT nextval('public.follow_id_seq'::regclass);


--
-- Name: party id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.party ALTER COLUMN id SET DEFAULT nextval('public.party_id_seq'::regclass);


--
-- Name: party_activity id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.party_activity ALTER COLUMN id SET DEFAULT nextval('public.party_activity_id_seq'::regclass);


--
-- Name: party_member id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.party_member ALTER COLUMN id SET DEFAULT nextval('public.party_member_id_seq'::regclass);


--
-- Name: plogging_record plogging_record_id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.plogging_record ALTER COLUMN plogging_record_id SET DEFAULT nextval('public.plogging_record_plogging_record_id_seq'::regclass);


--
-- Name: ploggings plogging_id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.ploggings ALTER COLUMN plogging_id SET DEFAULT nextval('public.ploggings_plogging_id_seq'::regclass);


--
-- Name: post post_id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.post ALTER COLUMN post_id SET DEFAULT nextval('public.post_post_id_seq'::regclass);


--
-- Name: raid_boss id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.raid_boss ALTER COLUMN id SET DEFAULT nextval('public.raid_boss_id_seq'::regclass);


--
-- Name: raid_record id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.raid_record ALTER COLUMN id SET DEFAULT nextval('public.raid_record_id_seq'::regclass);


--
-- Name: test_entity id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.test_entity ALTER COLUMN id SET DEFAULT nextval('public.test_entity_id_seq'::regclass);


--
-- Name: trashcan_verifications id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.trashcan_verifications ALTER COLUMN id SET DEFAULT nextval('public.trashcan_verifications_id_seq'::regclass);


--
-- Name: trashcans id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.trashcans ALTER COLUMN id SET DEFAULT nextval('public.trashcans_id_seq'::regclass);


--
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.account (user_id, color, created_at, email, intro, nickname, profile_image, pw, tier, total_distance, total_score, total_time, updated_at) FROM stdin;
test2	#111111	2026-01-29 16:43:11.33638	test2@test.com	안녕하세요!	test	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$pynPdZrJ20aQGio54nX0NOAkMNxbasDIMtQDq2tsI7nXSnmnhICnG	Bronze 5	0	0	0	2026-01-29 16:43:11.33638
ssafy1	string	2026-01-30 10:24:23.716314	string	안녕하세요!	string	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$0njihrxEqN0nrXfMy3Jj1O/wMJGfqMLdB57/mFdzJi2sf2.L9WeSi	Bronze 5	0	0	0	2026-01-30 10:24:23.716314
testuser1	#FFFFFF	2026-01-30 12:46:24.565976	testuser1@example.com	안녕하세요!	닉네임_testuser1	https://storage.googleapis.com/jupddang-images/default/default-profile.png	password	Bronze 5	0	0	0	2026-01-30 12:46:24.565976
testuser2	#FFFFFF	2026-01-30 12:46:24.576527	testuser2@example.com	안녕하세요!	닉네임_testuser2	https://storage.googleapis.com/jupddang-images/default/default-profile.png	password	Bronze 5	0	0	0	2026-01-30 12:46:24.576527
testuser3	#FFFFFF	2026-01-30 12:46:24.578911	testuser3@example.com	안녕하세요!	닉네임_testuser3	https://storage.googleapis.com/jupddang-images/default/default-profile.png	password	Bronze 5	0	0	0	2026-01-30 12:46:24.578911
testuser4	#FFFFFF	2026-01-30 12:46:24.581053	testuser4@example.com	안녕하세요!	닉네임_testuser4	https://storage.googleapis.com/jupddang-images/default/default-profile.png	password	Bronze 5	0	0	0	2026-01-30 12:46:24.581053
testuser5	#FFFFFF	2026-01-30 12:46:24.583021	testuser5@example.com	안녕하세요!	닉네임_testuser5	https://storage.googleapis.com/jupddang-images/default/default-profile.png	password	Bronze 5	0	0	0	2026-01-30 12:46:24.583021
ranker3	#FFFF00	2026-02-01 11:35:18.243391	rank3@test.com	다 주워버리겠다	쓰레기사냥	https://storage.googleapis.com/jupddang-images/profile/b477e139-4e16-4d31-89a8-8415f6836024_scaled_36.webp	$2a$10$9t11L9sfrN.LSv4vxj8HUOX727dJXQoHmkUrIXKMFO4H0xgX2cNHC	Silver 4	280	6000	4000	2026-02-08 23:37:24.157199
ranker1	#4DD0E1	2026-02-01 11:35:18.243391	rank1123@test.com	1등 껌이던데ㅎㅋ	랭커1	https://storage.googleapis.com/jupddang-images/profile/ab271aa8-d3a1-4f1b-831d-55cde4063103_scaled_33.webp	$2a$10$2GBQrkO1RZZi3rhoyrE6SuPobk9eyi3RiQYOt8lowIoMwCRNa6u6i	Gold 4	820.5	12200	5008	2026-02-08 01:55:48.793625
ssafy2	FFFFF	2026-01-30 14:54:05.83362	string@gmail.com	안녕하세요!	진우님	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$/4g585WoofLjji35iMM77uPl3.298oMsiwGghcaollFfNvqgB0G82	Bronze 5	0	0	5	2026-01-30 15:00:09.303204
2	2	2026-01-30 17:46:36.447236	2	안녕하세요!	2	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$k6gB2npybGL9Zog7/7qMC./fy3GFuoYZ.ru8TMi6zAWNo2TrFVX9m	Bronze 5	0	0	0	2026-01-30 17:46:36.447236
3	3	2026-01-30 17:46:45.908557	3	안녕하세요!	3	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$uXx3IjlWD1xOJioZ0nQ8jeIh7U.jAQ4l6UBhAhh/7M05gioIUCaoG	Bronze 5	0	0	0	2026-01-30 17:46:45.908557
4	4	2026-01-30 17:46:54.435252	4	안녕하세요!	4	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$4MLNIz33FoV8aJ0HI9ejPOioWEu4Y52nSYrFYcyKtd.u/iY7Den.q	Bronze 5	0	0	0	2026-01-30 17:46:54.435252
5	5	2026-01-30 17:47:11.856173	5	안녕하세요!	5	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$w91gX0QyV6ljAoh0t7azb.QWM2dgsTEXqwV7ieZl0bHmFJkWlRPWa	Bronze 5	0	0	0	2026-01-30 17:47:11.856173
1	1	2026-01-30 17:46:23.20687	1	안녕하세요!	1	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$9t11L9sfrN.LSv4vxj8HUOX727dJXQoHmkUrIXKMFO4H0xgX2cNHC	Bronze 5	0	0	15	2026-01-31 13:01:54.330704
ranker2	#FFA500	2026-02-01 11:35:18.243391	rank2@test.com	안녕하세요	줍땅고수	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$9t11L9sfrN.LSv4vxj8HUOX727dJXQoHmkUrIXKMFO4H0xgX2cNHC	Silver 3	390.2	7500	4500	2026-02-07 17:19:57.071964
signup	#111111	2026-02-01 18:58:55.410286	signup@test	안녕하세요!	whaa	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$PvnaKDww82I24Z76jrZzmeumH1ez/Kt3ZLDB2hY4h3QLuuInidHBS	Bronze 5	0	0	0	2026-02-01 18:58:55.410286
elena	#111111	2026-02-01 19:00:35.380925	elenakim1224@gmail.com	안녕하세요!	nickname	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$H.EMB30gGQpPTLOk0Rh0eeKNMk9z7tDl9s7VCtoKO2RX3oRJP3woO	Bronze 5	0	0	0	2026-02-01 19:00:35.380925
test6	#111111	2026-02-01 19:20:20.959551	lulu@nate.com	안녕하세요!	nick	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$pbWC23UWq7dWD42WncqIxusXGNBpYudW2bsvJJ2WGaiNEKExdbcKu	Bronze 5	0	0	0	2026-02-01 19:20:20.959551
test7	#111111	2026-02-01 19:24:47.881194	test7@gmail.com	안녕하세요!	nick	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$4/PjZo6.1kgAdKDi/vqizOXhGVi6b7dyTJxF2sEZ5yIijLpSsoLy.	Bronze 5	0	0	0	2026-02-01 19:24:47.881194
6	#111111	2026-02-01 19:55:02.666676	6@.com	안녕하세요!	6	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$yHiXqQA6Ky82SHv.zsYXOuLzWJ6w68stjIumZAvv.MAjI7CqhDaUG	Bronze 5	0	0	0	2026-02-01 19:55:02.666676
7	#111111	2026-02-01 20:25:46.588655	7@.com	안녕하세요!	7	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$HEsP0OT3ilHpN3uDHN6OjuRfQ7EztrJcHKim11e8qqUXFy5dx5yBa	Bronze 5	0	0	0	2026-02-01 20:25:46.588655
ssafy	FFFFFF	2026-01-30 06:30:20.774483	ssafy@ssafy.com	안녕하세요!	컨코치님	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$1tiGT3ODiB.NUqjfwMeTZeb2K1fHIDPS5K7AJsljw8uBJxYmGZuVy	Bronze 5	0.001	0	120	2026-02-06 15:13:52.355866
ranker4	#008000	2026-02-01 11:35:18.243391	rank4@test.com	지구가 아파요	환경지킴이	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$9t11L9sfrN.LSv4vxj8HUOX727dJXQoHmkUrIXKMFO4H0xgX2cNHC	Bronze 1	170	4500	3500	2026-02-07 17:19:57.072367
test	#1E88E5	2026-01-29 16:42:36.259738	test@test.com	플로깅 좋아합니다!	hihi	https://storage.googleapis.com/jupddang-images/profile/6f811271-a1ed-4379-8824-11fa63cfaeea_scaled_61.webp	$2a$10$SIGHni3FnCH3FY0E7waMqe3MXaZEzxKMQe8B4wK.HC0/w/.nMVuK6	Bronze 5	0.207	10	633	2026-02-06 16:30:20.508709
user5	0xFF46A140	2026-02-07 20:41:32.586942	user5@naver.com	안녕하세요!	플로깅 초보	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$BlRoXSpEgVmsQmhRhRbOT.ZO2jh/8hdR6wSH.OcNdoU8hRWmulNpW	Bronze 5	0.348	11	493	2026-02-08 21:50:02.486413
kky	0xFF46A140	2026-02-07 23:49:52.566864	kky@test.com	안녕하세요!	kimkang	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$nMiI6fnIm.W1FQmk3TGYEuhVZ9y29amlpW0R00twnpQK7s.FGA0ee	Bronze 5	0	0	0	2026-02-07 23:49:52.566864
user1	0xFF46A140	2026-02-07 20:32:59.379539	user1@naver.com	안녕하세요!	오늘도줍깅	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$GzYO69ZOQmz95uI5mqPJb.LuI/jqciUqOVzIgCkjHkcA5GiVVui.6	Bronze 5	0.291	13	737	2026-02-08 21:54:09.370205
user2	0xFF46A140	2026-02-07 20:35:31.621697	user2@naver.com	안녕하세요!	걷고줍고뛰고	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$9sYIa8jJa46UuVrOfV4Cf.HQgqILqa9x/rP0TnsKebtcp6B6oNTtO	Bronze 5	0.22799999999999998	10	585	2026-02-08 21:59:23.596695
ranker7	#DB5FBD	2026-02-01 11:35:18.243391	rank7@test.com	아침 공기 상쾌	새벽러너	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$9t11L9sfrN.LSv4vxj8HUOX727dJXQoHmkUrIXKMFO4H0xgX2cNHC	Silver 1	790	9500	2000	2026-02-08 00:38:16.605362
ssafy4	0xFF46A140	2026-02-06 10:54:36.064306	ssafy4@naver.com	안녕하세요!	김싸피4	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$OsOk.xt97VBb3e10QJ5arO/gTV/929SX.G5XJ6HsSUCD3tWElM0Z.	Bronze 5	0	0	371	2026-02-06 17:41:14.737127
ranker11	#FFFFFF	2026-02-07 03:41:58.868595	ranker10@test.com	안녕하세요!	안녕하세요!	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$Wl4TSx7KEA9v60H7Y5OsZukNOyQZCVUAW9Ao89onGjfrxlT.973q2	Bronze 5	0	0	0	2026-02-07 03:41:58.868595
ranker8	#FFFFFF	2026-02-01 11:35:18.243391	rank8@test.com	평일은 바빠요	주말러	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$9t11L9sfrN.LSv4vxj8HUOX727dJXQoHmkUrIXKMFO4H0xgX2cNHC	Bronze 4	60	1800	1500	2026-02-07 17:19:57.072968
ranker9	#000000	2026-02-01 11:35:18.243391	rank9@test.com	잘 부탁드려요	뉴비입니다	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$9t11L9sfrN.LSv4vxj8HUOX727dJXQoHmkUrIXKMFO4H0xgX2cNHC	Bronze 4	40	1200	1000	2026-02-07 17:19:57.073152
ranker10	#808080	2026-02-01 11:35:18.243391	rank10@test.com	언젠간 1등	꼴찌탈출	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$9t11L9sfrN.LSv4vxj8HUOX727dJXQoHmkUrIXKMFO4H0xgX2cNHC	Bronze 5	20	600	500	2026-02-07 17:19:57.073305
ranker6	#FFFFFF	2026-02-01 11:35:18.243391	rank6@test.com	플로깅 좋아합니다!	ranker6	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$9t11L9sfrN.LSv4vxj8HUOX727dJXQoHmkUrIXKMFO4H0xgX2cNHC	Bronze 3	90	2900	2500	2026-02-07 17:19:57.073459
멋쟁이토마토	0xFF46A140	2026-02-06 16:47:02.228181	dmdm0601@naver.com	안녕하세요!	멋쟁이토마토	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$bw8WI/no65IlB8LoQxxBCe5PJwzTFJIjWGoF0icvNrVhInQ0ybyLy	Bronze 5	0	0	0	2026-02-06 16:47:02.228181
test_agent_007	#00FF00	2026-02-08 18:37:45.104166	agent007@test.com	안녕하세요!	Agent007	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$k89VE9qoPAVlernrh6sz2OEhIVcwxbYy6U4fo410MI.cXEyAJBItm	Bronze 5	0	0	0	2026-02-08 18:37:45.104166
ranker5	#FFFFFF	2026-02-01 11:35:18.243391	rank5@test.com	플로깅 좋아합니다!	ranker5	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$9t11L9sfrN.LSv4vxj8HUOX727dJXQoHmkUrIXKMFO4H0xgX2cNHC	Silver 1	660	9000	3000	2026-02-07 17:19:57.073782
user3	0xFF46A140	2026-02-07 20:36:51.311462	user3@naver.com	안녕하세요!	주로밤에합니다	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$LE1uqpWTWb.9RHphIqQEn.xgnsFmKqhyNzYHbPEUowAV7W3pXuTTa	Bronze 5	0.194	9	584	2026-02-08 22:05:20.143878
user4	0xFF46A140	2026-02-07 20:37:42.329052	user4@naver.com	안녕하세요!	초록발걸음	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$7mz1d/eL945o5FayriSWp.HGT6d0Pb5L7tZaPejFDkiWVPcJL39uy	Bronze 5	0.685	28	1369	2026-02-08 22:17:05.891024
komae	#00897B	2026-02-06 16:50:16.774592	kem4378@naver.com	안녕하세요!	komae	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$mSqS0dW4SjkxmuhGQdsoSu8SeYK9QQQU91yeVXcT6rfYm4MC/uPVW	Bronze 5	0.645	57	2915	2026-02-08 23:49:54.973151
\.


--
-- Data for Name: comment; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.comment (comment_id, content, created_at, user_id, post_id) FROM stdin;
3	야야	2026-01-30 15:19:56.474329	ssafy	3
5	1의 댓글	2026-01-30 17:51:54.452659	1	9
9	asdf	2026-01-30 22:00:11.253269	1	13
12	fffasasdfasdfasdf	2026-01-30 22:02:32.097354	1	13
15	evevevev	2026-01-30 22:10:22.763727	1	9
16	ggg	2026-01-30 22:13:04.207629	1	9
22	zezebal	2026-01-30 22:25:13.97574	1	13
28	ok?	2026-01-30 22:34:36.932893	1	13
29	oh no..	2026-01-30 22:34:44.995595	1	13
30	whyrano...	2026-01-30 22:35:00.993033	1	13
32	??????	2026-01-30 22:38:00.492888	1	13
34	ohohoh	2026-01-30 22:47:09.93116	1	13
35	ohyeahyeah	2026-01-30 22:47:22.952304	1	13
36	wow	2026-01-30 22:47:30.105221	1	13
37	hi	2026-01-30 22:49:38.280065	1	13
38	bye	2026-01-30 23:21:15.551447	1	13
41	동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리나라 만세 무궁화 삼천리 화려강산 대한사람 대한으로 길이 보전하세	2026-01-30 23:26:21.098875	1	13
42	동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리나라 만세 무궁화 삼천리 화려강산 대한사람 대한으로 길이 보전하세	2026-01-30 23:26:38.700369	1	9
43	대한민국 만세~	2026-01-30 23:42:14.568211	1	13
44	누구세욤	2026-01-30 23:47:19.761845	1	11
45	댓글창 바꿔봤는데 어때욤	2026-01-30 23:48:01.386088	1	11
47	😆😆	2026-01-30 23:49:09.07929	1	11
48	(⁠.⁠ ⁠❛⁠ ⁠ᴗ⁠ ⁠❛⁠.⁠)✧⁠*⁠。	2026-01-30 23:50:01.92474	1	10
49	아 푸쉬 안해서 아직 뭐가 바꼈는지 모르겠구나 우하핫	2026-01-30 23:52:20.974153	1	11
54	오예	2026-02-03 19:45:56.229076	ranker1	61
55	쓰레기줍당	2026-02-03 19:46:11.484024	ranker1	59
56	깔끔해요	2026-02-03 19:46:32.190439	ranker1	58
57	asdf	2026-02-04 09:44:02.299917	ranker3	50
58	fff	2026-02-04 09:44:10.912574	ranker3	61
59	zebal	2026-02-05 02:37:11.417862	ranker9	64
60	gogogo	2026-02-05 02:37:26.562092	ranker9	61
72	ddd	2026-02-06 15:44:44.266785	test	87
73	퓨왕	2026-02-06 16:27:37.406674	ssafy4	93
74	hihi~~	2026-02-07 18:34:11.431345	ranker3	100
76	환경지킴이 ㅎㅇ	2026-02-07 19:50:12.824687	ranker1	51
77	ㅋㅋㅋㅋㅋㅋㅋㅋㅋ최고!!!!!	2026-02-07 21:58:43.511335	ranker1	105
78	hello	2026-02-07 22:20:51.568442	ranker1	61
79	최고!!!!	2026-02-08 00:29:02.959502	ranker1	106
80	우왕굳	2026-02-08 00:40:21.973174	ranker7	106
81	good	2026-02-08 15:36:44.946043	ranker1	108
82	asdf	2026-02-08 22:02:23.220617	ranker1	50
83	good	2026-02-08 22:53:42.645109	user1	116
\.


--
-- Data for Name: fcm_tokens; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.fcm_tokens (id, created_at, device_type, token, updated_at, user_id) FROM stdin;
3	2026-02-08 21:28:27.21783	android	e4a09tRhTZKZUuopxq29fe:APA91bFHgA8IQ0ex3n8e6Jb3MeTD73zbLrJ2LL6F9HCXoNC64vnA1dSKGRC4lOGh8ZC9AverX_ewLXBVXnvI6e9t1M-bVNvWOjxZPmc4ldJQl3U2oZ70Wyw	2026-02-08 21:28:27.21783	ranker1
23	2026-02-08 23:32:19.021004	android	d6t_hLtsTo2sQWv8YJqkot:APA91bGgm7WRfv6tNtYqTWYbS3ixLdpjz6BIsbMGzm9Qw3X9Dh-pc4qZiqDHS3Ro2X6ElkExCXDvw3VO8Nu3_8f5Htpe6yjLKJ7IzxlItHdgM1BRCwiszZg	2026-02-08 23:32:19.021004	komae
24	2026-02-08 23:40:31.185283	android	cHpG644ISJelQ_JHllqW0J:APA91bGIahZGIRGwtOOonam7_X5tAnnI8dzHO3wk0-JCKxOJMU0_xPp9lrHIygHg2we9wIfLWzl97UpONAGWCP_wCfJDa-jUt5oqBkQMYsDAaOfL60-RDlQ	2026-02-08 23:40:31.185283	user1
\.


--
-- Data for Name: follow; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.follow (id, created_at, follower_id, following_id) FROM stdin;
2	2026-01-30 17:40:56.590773	ssafy	ssafy2
6	2026-01-30 23:38:10.87246	2	3
7	2026-01-30 23:38:14.972712	2	4
8	2026-01-30 23:38:26.524871	2	1
28	2026-02-01 16:18:03.006732	1	5
29	2026-02-01 16:18:07.573467	1	3
31	2026-02-03 16:25:30.343733	ranker1	ranker3
32	2026-02-03 16:25:35.150168	ranker1	ranker4
33	2026-02-03 20:00:45.021298	ranker2	ranker1
48	2026-02-04 01:36:11.84667	ranker5	ranker10
50	2026-02-04 09:38:57.716445	ranker3	ranker1
51	2026-02-04 09:42:11.993262	ranker3	ranker2
53	2026-02-04 11:20:37.834618	ranker7	1
54	2026-02-04 15:06:23.073863	ranker7	ranker1
55	2026-02-05 01:51:58.177126	ranker9	ranker10
58	2026-02-06 09:11:29.107959	test	ranker5
59	2026-02-06 13:41:08.600876	test	ranker1
62	2026-02-06 13:49:20.859475	test	ssafy
63	2026-02-06 13:49:35.725821	test	ranker3
65	2026-02-08 18:05:16.497632	ranker1	test
66	2026-02-08 18:05:22.209402	ranker1	ranker7
67	2026-02-08 18:05:24.042221	ranker1	ranker2
\.


--
-- Data for Name: grids; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.grids (grid_id, occupied_at, party_id, user_id) FROM stdin;
\.


--
-- Data for Name: party; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.party (id, created_at, ended_at, invite_code, leader_id, max_members, name, started_at, status, total_distance, total_score, total_time) FROM stdin;
1	2026-01-29 16:43:29.083591	\N	412974	test	6	m	2026-01-29 16:43:45.119578	IN_PROGRESS	\N	\N	\N
2	2026-01-29 16:49:18.327202	\N	675664	test	6	m	\N	WAITING	\N	\N	\N
3	2026-01-29 16:53:43.843688	\N	428228	test	6	m	2026-01-29 16:53:51.836323	IN_PROGRESS	\N	\N	\N
4	2026-01-29 16:57:39.304606	\N	086866	test	6	m	2026-01-29 16:58:06.769854	IN_PROGRESS	\N	\N	\N
5	2026-01-29 17:03:06.613475	\N	121623	test	6	m	2026-01-29 17:03:23.784701	IN_PROGRESS	\N	\N	\N
6	2026-01-29 17:06:52.274186	\N	019965	test	6	n	2026-01-29 17:07:26.119329	IN_PROGRESS	\N	\N	\N
7	2026-01-30 10:14:28.787323	\N	057982	test	6	안녕	2026-01-30 10:14:57.688894	IN_PROGRESS	\N	\N	\N
8	2026-01-30 10:15:26.706158	\N	059161	ssafy	6	파티1	2026-01-30 10:15:35.566085	IN_PROGRESS	\N	\N	\N
9	2026-01-30 10:35:22.067678	\N	817932	ssafy	6	룰루	2026-01-30 10:35:37.987511	IN_PROGRESS	\N	\N	\N
10	2026-01-30 16:54:19.951528	\N	366708	ssafy	6	파티	\N	WAITING	\N	\N	\N
11	2026-02-01 14:46:37.484948	\N	723907	1	6	123	\N	WAITING	\N	\N	\N
12	2026-02-01 14:50:18.835101	\N	801167	1	6	123	\N	WAITING	\N	\N	\N
13	2026-02-01 14:55:20.80224	\N	282202	1	6	222	\N	WAITING	\N	\N	\N
14	2026-02-01 15:13:43.64122	\N	632413	2	6	bb	\N	WAITING	\N	\N	\N
15	2026-02-01 15:14:37.821164	\N	319245	2	6	파티	\N	WAITING	\N	\N	\N
16	2026-02-01 15:16:56.08949	\N	693262	ssafy	6	파티!	2026-02-01 15:17:27.04218	IN_PROGRESS	\N	\N	\N
17	2026-02-03 19:43:10.723546	\N	494029	ranker1	6	싸피	\N	WAITING	\N	\N	\N
18	2026-02-03 21:29:35.579508	\N	328635	ranker1	6	고고	\N	WAITING	\N	\N	\N
19	2026-02-04 19:33:32.851687	\N	711539	test	6	hello	2026-02-04 19:33:36.531544	IN_PROGRESS	\N	\N	\N
20	2026-02-04 19:50:45.550443	\N	889017	test	6	gggg	\N	WAITING	\N	\N	\N
21	2026-02-05 14:35:53.067968	\N	060835	test	6	hi	\N	WAITING	\N	\N	\N
22	2026-02-05 14:37:30.533806	\N	735706	test	6	fff	\N	WAITING	\N	\N	\N
23	2026-02-05 14:42:16.696839	\N	988313	test	6	gg	\N	WAITING	\N	\N	\N
24	2026-02-05 22:21:48.406052	\N	673277	test	6	test	\N	WAITING	\N	\N	\N
25	2026-02-05 22:53:55.191998	\N	600969	test	6	test	\N	WAITING	\N	\N	\N
26	2026-02-05 22:58:20.211127	\N	620967	test	6	test	\N	WAITING	\N	\N	\N
27	2026-02-06 02:05:50.102031	\N	502225	test	6	test	\N	WAITING	\N	\N	\N
28	2026-02-06 02:11:08.275963	\N	658757	test	6	test	\N	WAITING	\N	\N	\N
29	2026-02-06 13:56:53.578261	\N	603999	test	6	test	\N	WAITING	\N	\N	\N
30	2026-02-06 16:27:51.509008	\N	519237	test	6	test	\N	WAITING	\N	\N	\N
31	2026-02-06 17:36:55.016442	\N	572372	komae	6	ㅂㅅ	\N	WAITING	\N	\N	\N
32	2026-02-06 17:40:06.775806	\N	281682	komae	6	eng	\N	WAITING	\N	\N	\N
33	2026-02-07 18:56:21.452537	\N	517932	test	6	test	\N	WAITING	\N	\N	\N
34	2026-02-07 21:35:50.806876	\N	451874	komae	6	ff	\N	WAITING	\N	\N	\N
35	2026-02-07 21:39:37.466021	\N	966412	test	6	dd	\N	WAITING	\N	\N	\N
36	2026-02-07 21:40:14.635162	\N	004957	komae	6	dd	\N	WAITING	\N	\N	\N
37	2026-02-07 21:40:33.578599	\N	895907	komae	6	dx	\N	WAITING	\N	\N	\N
38	2026-02-07 21:52:18.341175	\N	297892	komae	6	d	2026-02-07 21:52:28.730462	IN_PROGRESS	\N	\N	\N
39	2026-02-08 21:34:51.712007	\N	336793	ranker1	6	파티	\N	WAITING	\N	\N	\N
\.


--
-- Data for Name: party_activity; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.party_activity (id, distance, ended_at, party_id, started_at, status, trash_count, user_id, plogging_id) FROM stdin;
1	\N	\N	1	2026-01-29 16:43:45.123582	IN_PROGRESS	\N	test	\N
2	\N	\N	1	2026-01-29 16:43:45.126283	IN_PROGRESS	\N	test2	\N
3	\N	\N	3	2026-01-29 16:53:51.8426	IN_PROGRESS	\N	test	\N
4	\N	\N	3	2026-01-29 16:53:51.847327	IN_PROGRESS	\N	test2	\N
5	\N	\N	4	2026-01-29 16:58:06.771291	IN_PROGRESS	\N	test	\N
6	\N	\N	4	2026-01-29 16:58:06.772439	IN_PROGRESS	\N	test2	\N
7	\N	\N	5	2026-01-29 17:03:23.786224	IN_PROGRESS	\N	test	\N
8	\N	\N	5	2026-01-29 17:03:23.787543	IN_PROGRESS	\N	test2	\N
9	\N	\N	6	2026-01-29 17:07:26.124252	IN_PROGRESS	\N	test	\N
10	\N	\N	6	2026-01-29 17:07:26.127318	IN_PROGRESS	\N	test2	\N
11	\N	\N	7	2026-01-30 10:14:57.692549	IN_PROGRESS	\N	test	\N
12	\N	\N	7	2026-01-30 10:14:57.697567	IN_PROGRESS	\N	ssafy	\N
13	\N	\N	8	2026-01-30 10:15:35.567744	IN_PROGRESS	\N	ssafy	\N
14	\N	\N	8	2026-01-30 10:15:35.569114	IN_PROGRESS	\N	test	\N
15	\N	\N	9	2026-01-30 10:35:37.988943	IN_PROGRESS	\N	ssafy	\N
16	\N	\N	9	2026-01-30 10:35:37.990493	IN_PROGRESS	\N	test	\N
17	\N	\N	16	2026-02-01 15:17:27.045259	IN_PROGRESS	\N	ssafy	\N
18	\N	\N	16	2026-02-01 15:17:27.051018	IN_PROGRESS	\N	2	\N
19	\N	\N	19	2026-02-04 19:33:36.53726	IN_PROGRESS	\N	test	\N
20	\N	\N	38	2026-02-07 21:52:28.732449	IN_PROGRESS	\N	komae	\N
21	\N	\N	38	2026-02-07 21:52:28.741234	IN_PROGRESS	\N	test	\N
\.


--
-- Data for Name: party_member; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.party_member (id, joined_at, user_id, party_id) FROM stdin;
1	2026-01-29 16:43:29.101509	test	1
2	2026-01-29 16:43:41.386197	test2	1
3	2026-01-29 16:49:18.328742	test	2
4	2026-01-29 16:53:43.877711	test	3
5	2026-01-29 16:53:49.554358	test2	3
6	2026-01-29 16:57:39.306364	test	4
7	2026-01-29 16:58:02.696112	test2	4
8	2026-01-29 17:03:06.614941	test	5
9	2026-01-29 17:03:20.63138	test2	5
10	2026-01-29 17:06:52.275843	test	6
11	2026-01-29 17:07:22.498374	test2	6
12	2026-01-30 10:14:28.802386	test	7
13	2026-01-30 10:14:45.3681	ssafy	7
14	2026-01-30 10:15:26.707908	ssafy	8
15	2026-01-30 10:15:31.817918	test	8
16	2026-01-30 10:35:22.069233	ssafy	9
17	2026-01-30 10:35:28.480708	test	9
18	2026-01-30 16:54:19.956361	ssafy	10
19	2026-02-01 14:46:37.49325	1	11
20	2026-02-01 14:50:18.836684	1	12
21	2026-02-01 14:55:20.803741	1	13
22	2026-02-01 15:13:43.643256	2	14
23	2026-02-01 15:14:37.822711	2	15
24	2026-02-01 15:16:56.090936	ssafy	16
25	2026-02-01 15:17:11.029874	2	16
26	2026-02-03 19:43:10.730369	ranker1	17
27	2026-02-03 21:29:35.584286	ranker1	18
28	2026-02-04 19:33:32.899446	test	19
29	2026-02-04 19:50:45.55242	test	20
30	2026-02-05 14:35:53.104321	test	21
31	2026-02-05 14:37:30.535591	test	22
32	2026-02-05 14:38:26.547546	ranker5	22
33	2026-02-05 14:42:16.698516	test	23
34	2026-02-05 14:42:28.793307	ranker5	23
35	2026-02-05 22:21:48.430027	test	24
36	2026-02-05 22:53:55.193982	test	25
37	2026-02-05 22:58:20.212501	test	26
38	2026-02-06 02:05:50.12094	test	27
39	2026-02-06 02:11:08.277662	test	28
40	2026-02-06 13:56:53.632072	test	29
41	2026-02-06 16:27:51.511225	test	30
42	2026-02-06 16:28:57.396533	ranker1	30
43	2026-02-06 17:36:55.019362	komae	31
44	2026-02-06 17:37:09.010805	test	31
45	2026-02-06 17:37:25.527557	ranker8	31
46	2026-02-06 17:40:06.777218	komae	32
47	2026-02-06 17:40:19.772936	test	32
48	2026-02-07 18:56:21.489671	test	33
49	2026-02-07 21:35:50.812985	komae	34
50	2026-02-07 21:35:56.162528	test	34
51	2026-02-07 21:39:37.468205	test	35
52	2026-02-07 21:40:14.636803	komae	36
53	2026-02-07 21:40:33.580128	komae	37
54	2026-02-07 21:40:53.258352	test	37
55	2026-02-07 21:52:18.343012	komae	38
56	2026-02-07 21:52:27.547339	test	38
57	2026-02-08 21:34:51.718734	ranker1	39
\.


--
-- Data for Name: plogging_record; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.plogging_record (plogging_record_id) FROM stdin;
\.


--
-- Data for Name: ploggings; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.ploggings (plogging_id, created_at, distance, score, times, user_id, after_image_url, before_image_url, content, map_image_url, record_name, status) FROM stdin;
1	2026-01-30 13:59:33.100134	0	0	4	ssafy	\N	\N	\N	\N	\N	USED
2	2026-01-30 14:37:07.015901	0	0	3	ssafy	\N	\N	\N	\N	\N	USED
3	2026-01-30 15:00:08.212083	0	0	5	ssafy2	\N	\N	\N	\N	\N	USED
4	2026-01-31 00:17:45.669717	0	0	6	ssafy	\N	\N	\N	\N	\N	USED
5	2026-01-31 00:23:07.864568	0	0	4	ssafy	\N	\N	\N	\N	\N	USED
6	2026-01-31 08:57:42.405297	0	0	11	1	\N	\N	\N	\N	\N	USED
7	2026-01-31 13:01:53.767793	0	0	4	1	\N	\N	\N	\N	\N	USED
8	2026-02-01 15:18:38.357064	0.001	0	34	ssafy	\N	\N	\N	\N	\N	USED
9	2026-02-01 21:37:41.946048	80	800	\N	ranker1	\N	\N	\N	\N	\N	USED
10	2026-02-01 21:40:02.217865	80	800	\N	ranker1	\N	\N	\N	\N	\N	USED
11	2026-02-01 21:40:33.476098	80	800	\N	ranker1	\N	\N	\N	\N	\N	USED
12	2026-02-01 21:40:34.583213	80	800	\N	ranker1	\N	\N	\N	\N	\N	USED
13	2026-02-01 21:41:13.80243	80	800	\N	ranker1	\N	\N	\N	\N	\N	USED
14	2026-02-01 21:45:12.848556	50	500	\N	ranker5	\N	\N	\N	\N	\N	USED
15	2026-02-01 21:45:16.615651	50	500	\N	ranker5	\N	\N	\N	\N	\N	USED
16	2026-02-01 21:45:17.711565	50	500	\N	ranker5	\N	\N	\N	\N	\N	USED
17	2026-02-01 21:45:18.582348	50	500	\N	ranker5	\N	\N	\N	\N	\N	USED
18	2026-02-01 21:46:38.065819	50	500	\N	ranker5	\N	\N	\N	\N	\N	USED
19	2026-02-01 21:46:39.059721	50	500	\N	ranker5	\N	\N	\N	\N	\N	USED
20	2026-02-01 21:47:07.406552	50	500	\N	ranker5	\N	\N	\N	\N	\N	USED
21	2026-02-01 21:47:12.960994	50	500	\N	ranker5	\N	\N	\N	\N	\N	USED
22	2026-02-01 21:47:18.722059	50	500	\N	ranker5	\N	\N	\N	\N	\N	USED
23	2026-02-01 21:47:25.33947	50	500	\N	ranker5	\N	\N	\N	\N	\N	USED
24	2026-02-01 21:47:26.162359	50	500	\N	ranker5	\N	\N	\N	\N	\N	USED
25	2026-02-01 21:47:58.777542	50	500	\N	ranker7	\N	\N	\N	\N	\N	USED
26	2026-02-01 21:48:22.41085	500	5000	\N	ranker7	\N	\N	\N	\N	\N	USED
27	2026-02-01 21:48:34.76122	100	1000	\N	ranker7	\N	\N	\N	\N	\N	USED
28	2026-02-01 21:48:39.886586	100	1000	\N	ranker7	\N	\N	\N	\N	\N	USED
29	2026-02-01 21:50:13.953733	100	1000	\N	ranker2	\N	\N	\N	\N	\N	USED
30	2026-02-01 21:50:22.016704	100	1000	\N	ranker2	\N	\N	\N	\N	\N	USED
31	2026-02-01 21:50:29.850328	100	1000	\N	ranker2	\N	\N	\N	\N	\N	USED
32	2026-02-01 21:50:39.463041	100	1000	\N	ranker3	\N	\N	\N	\N	\N	USED
33	2026-02-01 21:50:41.818014	100	1000	\N	ranker3	\N	\N	\N	\N	\N	USED
34	2026-02-01 21:50:46.018072	100	1000	\N	ranker4	\N	\N	\N	\N	\N	USED
35	2026-02-01 21:50:54.421884	50	500	\N	ranker5	\N	\N	\N	\N	\N	USED
36	2026-02-01 21:51:01.282095	40	400	\N	ranker6	\N	\N	\N	\N	\N	USED
37	2026-02-01 21:51:12.267232	30	300	\N	ranker8	\N	\N	\N	\N	\N	USED
38	2026-02-01 21:51:18.992403	20	200	\N	ranker9	\N	\N	\N	\N	\N	USED
39	2026-02-01 21:51:27.585336	10	100	\N	ranker10	\N	\N	\N	\N	\N	USED
40	2026-02-02 15:13:56.70388	0	0	8	ranker1	\N	\N	\N	\N	\N	USED
41	2026-02-03 15:55:12.429953	80	800	\N	ranker1	\N	\N	\N	\N	\N	USED
42	2026-02-03 15:57:17.060057	80	800	\N	ranker1	\N	\N	\N	\N	\N	USED
43	2026-02-03 16:07:46.209264	80	800	\N	ranker1	\N	\N	\N	\N	\N	USED
44	2026-02-03 16:08:06.953598	80	800	\N	ranker1	\N	\N	\N	\N	\N	USED
45	2026-02-05 17:15:19.276833	0	0	2	test	\N	\N	\N	\N	\N	\N
46	2026-02-05 22:54:33.009001	0	0	26	test	\N	\N	\N	\N	\N	\N
47	2026-02-05 22:58:47.916707	0	0	19	test	\N	\N	\N	\N	\N	\N
48	2026-02-05 22:59:22.700124	0	0	14	test	\N	\N	\N	\N	\N	\N
49	2026-02-06 02:12:40.988047	0	0	3	test	\N	\N	\N	\N	\N	\N
50	2026-02-06 05:56:07.282833	0	0	44	ssafy	\N	\N	\N	\N	good	USED
51	2026-02-06 00:00:00	0	0	22	ssafy	\N	\N	ㅎㅎ	\N	기록1	TEMP
52	2026-02-06 00:00:00	0	0	22	ssafy	https://storage.googleapis.com/jupddang-images/profile/ab271aa8-d3a1-4f1b-831d-55cde4063103_scaled_33.webp	https://storage.googleapis.com/jupddang-images/profile/ab271aa8-d3a1-4f1b-831d-55cde4063103_scaled_33.webp	기록2입니다!	https://storage.googleapis.com/jupddang-images/profile/ab271aa8-d3a1-4f1b-831d-55cde4063103_scaled_33.webp	기록2	TEMP
53	2026-02-06 10:16:20.600459	0	3	193	test	\N	\N	\N	\N	dddd	USED
56	2026-02-06 14:15:17.777914	0	0	23	ssafy4	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/56/91d29b91-ec8a-40f0-ad38-e53ebddae87f_scaled_832e727d-8489-46df-ac98-4159404af77e7538123214131713412.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/56/82e803a3-c448-452a-adef-5c7d8aebae02_scaled_88aa1dbe-a01c-4204-949c-2b9a995ad4e59175336574678727716.webp	좋아요\n\n기록: 좋은 기록 · 2026-02-06 · 0.0km · 23초 · 0점	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/56/46a43dce-2975-48a6-86f9-f53ce160e905_map_1770354887588.webp	좋은 기록	USED
54	2026-02-06 10:55:47.032168	0	0	28	ssafy4	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/54/937ff96b-cf6f-4f15-815d-532c05a44544_scaled_35f51b53-59e4-42e6-8cf9-5acb172dfd538964893074411591407.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/54/8a747127-2351-4cde-b3ab-1e5aa5c03cf5_scaled_a9177956-216d-4177-9936-8b3090ac202b5717899471335387020.webp	좋아요\n\n기록: 기록_1 · 2026-02-06 · 0.0km · 28초 · 0점	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/54/daf5d0ee-5e37-4892-8ef8-3bb76ca9ca00_map_1770342929315.webp	기록_1	USED
55	2026-02-06 14:09:52.321457	0	0	23	ssafy4	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/55/06fe0c2d-2ba6-4bf3-a1b0-2d347c8ba86c_scaled_6d54244e-77d2-4230-b0c3-833f98a9d35f7387772983032342393.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/55/e57425ec-7357-45ab-9fbc-f37637260cfd_scaled_6a1f4b6e-025a-4156-af01-7fdf65af321a2236150741340950598.webp	으어\n\n기록: 임시기록1 · 2026-02-06 · 0.0km · 23초 · 0점	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/55/2738c606-187d-4643-9e7f-c53bdf79d273_map_1770354580528.webp	임시기록1	USED
58	2026-02-06 15:13:43.390816	0	0	25	ssafy	\N	\N	\N	\N	좋아요	USED
57	2026-02-06 14:26:36.354795	0	0	26	ssafy4	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/57/5ede116f-c7b7-4a67-9561-301f3c0d1b4f_scaled_d1e2502b-0dad-4472-99e7-fa46e587b7a78480358841842157018.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/57/3b5aaf9c-3fcc-4300-805b-e2765ef168a0_scaled_d7df6355-1016-4ef3-af90-3c8c055108d8284478518783574263.webp	ㅎㅎ\n\n기록: ㅎㅎ · 2026-02-06 · 0.0km · 26초 · 0점	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/57/9c4021a0-b641-4fa8-bf77-f5ef84da2390_map_1770355588181.webp	ㅎㅎ	USED
59	2026-02-06 15:15:20.205618	0	0	26	ssafy4	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/59/285cce75-0ec5-4ecf-baed-1e794a01b256_scaled_434292e7-04ef-4a55-8e20-ac6858fc073b6575250714612678147.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/59/9e3672b5-bf41-43bf-b108-7d48c4466c84_scaled_f69229ec-10ec-452f-975e-b849add76a823623625567001138980.webp	추워요\n\n기록: 추운 플로깅 · 2026-02-06 · 0.0km · 26초 · 0점	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/59/2111fcf4-724c-4d02-b833-fa1bf671e9d2_map_1770358508801.webp	추운 플로깅	USED
60	2026-02-06 15:35:52.825196	0	0	40	ssafy4	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/60/1d2d9cdb-82ca-45dd-917e-314f1d80aa8b_scaled_1fbb650c-91fc-40e3-aa9d-32f6f273fa7c670894039089225142.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/60/68f58f1d-a47f-409d-8dd6-83f1d8a192cf_scaled_44a35c51-b667-4dec-b3db-cc7fa23443677234391481440015557.webp	배고파!\n\n기록: 기록!! · 2026-02-06 · 0.0km · 40초 · 0점	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/60/fd3eb156-1347-476b-adc4-94b2ee44c3d1_map_1770359731504.webp	기록!!	USED
61	2026-02-06 15:48:22.675231	0.207	6	266	test	\N	\N	\N	\N	동네 한바퀴	USED
62	2026-02-06 15:59:17.927231	0	0	27	ssafy4	\N	\N	\N	\N	비애	USED
71	2026-02-06 17:39:58.83183	0	0	25	ssafy4	\N	\N	\N	\N	일반 플러깅 테스트	USED
63	2026-02-06 16:07:48.355474	0	0	20	ssafy4	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/63/0e1a2537-8324-4cd8-a18a-3cc8ba24ec23_scaled_ff40072d-9baa-4a32-9423-24fe3669bdc54621435283347316107.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/63/8e274702-aaf3-4f5e-a3df-c840f1bd9cfe_scaled_732ee517-cdf6-4439-990a-5cbd03cd7377447536258931619431.webp	임시저장 후 작성된 글 입니다\n\n기록: 비애 테스트 · 2026-02-06 · 0.0km · 20초 · 0점	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/63/41f61405-129f-4319-8aef-9ec6fd1885ec_map_1770361619971.webp	비애 테스트	USED
64	2026-02-06 16:26:42.260717	0	0	45	test	\N	\N	\N	\N	ddd	USED
65	2026-02-06 16:30:18.88401	0	1	65	test	\N	\N	\N	\N	ddd	USED
66	2026-02-06 16:58:04.127123	0	0	30	ssafy4	\N	\N	\N	\N	TMI	USED
67	2026-02-06 17:13:58.365189	0	0	24	ssafy4	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/67/d37cc925-a5c7-4cca-9c25-ad65690b9d59_scaled_983ed9fc-38dd-4db2-8ab2-9aa9078424162073938638127093874.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/67/54f774ea-b7c7-4558-9b00-fb60c731db97_scaled_8c15c1a5-83ce-4db2-9011-bd8d909894978246825230370997618.webp	퇴근 50분 전\n\n기록: 퇴5 · 2026-02-06 · 0.0km · 24초 · 0점	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/67/f1cabd23-213f-46bf-926d-df5907e0e7cd_map_1770365613276.webp	퇴5	USED
68	2026-02-06 17:15:34.749929	0	0	20	ssafy4	\N	\N	\N	\N	일반 종료	USED
72	2026-02-06 17:41:07.534814	0	0	25	ssafy4	\N	\N	\N	\N	일반 플러깅 테스트	USED
69	2026-02-06 17:22:36.081112	0	0	17	ssafy4	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/69/9487a50e-7649-45f9-9c93-b7bfef2f0579_scaled_dbe44f0e-8d07-4bad-8639-3bde5e2f2ee6441366420296652646.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/69/00d7d751-6136-4964-adcb-d568bd8adab7_scaled_9d266ab4-6593-4d41-bd17-945feb2b72ca8871844576386998684.webp	임시 저장 테스트\n\n기록: 임시 저장 테스트 · 2026-02-06 · 0.0km · 17초 · 0점	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/69/8e9742bf-1ee1-4597-ac7b-5ac36f82359f_map_1770366137845.webp	임시 저장 테스트	USED
70	2026-02-06 17:28:19.568197	0	0	17	ssafy4	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/70/8b4290e1-0178-4459-8ba8-1be1df7ed139_scaled_090eb8e1-b7a5-43a0-ad8e-e4e2b97047613747191418305239467.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/70/765e94e8-404c-411f-b897-341aaa152b93_scaled_e0d63166-ea25-4136-b59f-1069de77cc437749888872588175193.webp	임시테스트2\n\n기록: 임시테스트2 · 2026-02-06 · 0.0km · 17초 · 0점	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/70/29d8907d-cf26-4ee5-ac81-10c349049961_map_1770366485706.webp	임시테스트2	USED
73	2026-02-07 21:28:32.938789	0.215	11	550	user1	\N	\N	\N	\N	토욜밤 플로깅	USED
74	2026-02-07 21:35:15.730503	0.183	6	343	user2	\N	\N	\N	\N	오플완	USED
75	2026-02-07 21:42:07.187901	0.012	4	285	user3	\N	\N	\N	\N	2월7일	USED
76	2026-02-07 21:56:45.143533	0.148	13	731	user4	\N	\N	\N	\N	구미 플로깅	USED
77	2026-02-08 00:09:02.242676	0.101	2	91	komae	\N	\N	\N	\N	cold	USED
78	2026-02-08 13:09:56.159466	0.11	3	135	komae	\N	\N	\N	\N	춥다	USED
79	2026-02-08 20:48:07.807387	0	0	13	user1	\N	\N	\N	\N	테스트	USED
80	2026-02-08 21:49:53.341099	0.348	11	493	user5	\N	\N	\N	\N	담꽁	USED
81	2026-02-08 21:54:01.853481	0.076	2	174	user1	\N	\N	\N	\N	짧은 플로깅	USED
82	2026-02-08 21:59:16.376954	0.045	4	242	user2	\N	\N	\N	\N	동네 플로깅	USED
83	2026-02-08 22:05:12.898318	0.182	5	299	user3	\N	\N	\N	\N	집 근처 플로깅	USED
84	2026-02-08 22:16:58.884345	0.537	15	638	user4	\N	\N	\N	\N	춥춥	USED
85	2026-02-08 22:30:58.715103	0.101	9	495	komae	\N	\N	\N	\N	cold	USED
86	2026-02-08 22:44:02.56083	0.106	2	93	komae	\N	\N	\N	\N	..	USED
87	2026-02-08 23:24:28.402675	0.123	18	1073	komae	\N	\N	\N	\N	.	USED
88	2026-02-08 23:49:44.647283	0.104	23	1028	komae	\N	\N	\N	\N	.	USED
\.


--
-- Data for Name: post; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.post (post_id, after_image_url, before_image_url, content, created_at, like_cnt, map_image_url, plogging_id, updated_at, user_id) FROM stdin;
17	https://storage.googleapis.com/jupddang-images/plogging/1/7/d153de05-9e33-4ede-8823-7ec62a942146_1769832114105.jpg	https://storage.googleapis.com/jupddang-images/plogging/1/7/2c9b3212-d154-414f-a90e-a4d685381691_1769832113771.jpg		2026-01-31 13:01:54.32018	1	https://storage.googleapis.com/jupddang-images/plogging/1/7/9a4c3022-f0f8-4306-b1c5-c67c11756f24_1769832114204.png	7	2026-01-31 18:02:38.290389	1
16	https://storage.googleapis.com/jupddang-images/plogging/1/6/b3dc2bd4-04d3-46d0-8874-e335acc46229_1769817463044.jpg	https://storage.googleapis.com/jupddang-images/plogging/1/6/29024398-fbdd-4df9-9940-7a6339741dcb_1769817462409.jpg	1test-화현 진짜 플로깅	2026-01-31 08:57:43.226508	2	https://storage.googleapis.com/jupddang-images/plogging/1/6/147ffead-0445-49eb-b92e-d93a59dbf9f8_1769817463130.png	6	2026-01-31 18:02:40.411266	1
2	https://storage.googleapis.com/jupddang-images/plogging/ssafy/1/9fba66fc-0f4f-460e-b795-73cc896600af_1769749174552.jpg	https://storage.googleapis.com/jupddang-images/plogging/ssafy/1/5cb6afde-9ba0-4bb4-8e21-b8fec489091a_1769749173110.jpg	!!	2026-01-30 13:59:35.113737	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy/1/cec64f06-d826-462a-8cbb-b856ba397d36_1769749175023.png	1	2026-01-30 13:59:35.113737	ssafy
4	https://storage.googleapis.com/jupddang-images/plogging/ssafy2/3/4503ecb6-6c00-4569-908a-4a441006b0e7_1769752808793.jpg	https://storage.googleapis.com/jupddang-images/plogging/ssafy2/3/a7e7130b-add5-4a2f-9762-ca62521f245a_1769752808214.jpg	추워요!!	2026-01-30 15:00:09.29639	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy2/3/023c82f7-3fc4-4515-a7b5-006f2f1a9db9_1769752809205.png	3	2026-01-30 15:00:09.29639	ssafy2
3	https://storage.googleapis.com/jupddang-images/plogging/ssafy/2/69c359f2-8662-4758-a978-31a3b7716174_1769751427455.jpg	https://storage.googleapis.com/jupddang-images/plogging/ssafy/2/0788bcc1-33cd-46f3-904f-c81ab3d30433_1769751427017.jpg	gg!!	2026-01-30 14:37:07.969032	1	https://storage.googleapis.com/jupddang-images/plogging/ssafy/2/f60b009d-bfb1-4ebf-9eed-d1509819fbe8_1769751427865.png	2	2026-01-30 15:46:54.109687	ssafy
1	\N	\N	춥땅\n\n기록: 캠퍼스 러닝 · 2024-10-29 · 2.1km · 24분	2026-01-30 10:21:07.037604	4	\N	\N	2026-01-30 15:52:58.279294	ssafy
5	https://storage.googleapis.com/jupddang-images/sns/d9e43934-0119-44b7-950e-8ce70872a395_1769761434387.jpg	https://storage.googleapis.com/jupddang-images/sns/73bf9fc5-8ff5-45a9-8b6b-70e79f2541f5_1769761434076.jpg	fasdfasdf\n\n기록: 한강 플로깅 · 2024-11-02 · 3.2km · 32분	2026-01-30 17:23:54.462117	0	\N	\N	2026-01-30 17:23:54.462117	ssafy
6	https://storage.googleapis.com/jupddang-images/sns/14b9f3ec-94d3-4dff-8984-f921a31d11a1_1769761558124.jpg	https://storage.googleapis.com/jupddang-images/sns/8c87b317-76d2-4765-820c-eb789aadfd65_1769761557990.jpg	asdfff\n\n기록: 캠퍼스 러닝 · 2024-10-29 · 2.1km · 24분	2026-01-30 17:25:58.204961	0	\N	\N	2026-01-30 17:25:58.204961	ssafy
7	https://storage.googleapis.com/jupddang-images/sns/e6f2ca41-0929-4f29-967a-6a1c994d5ae2_1769761687526.jpg	https://storage.googleapis.com/jupddang-images/sns/1fb3486e-2e0c-414c-89d5-99e3edd2d52e_1769761687397.jpg	fff	2026-01-30 17:28:07.595545	0	\N	\N	2026-01-30 17:28:07.595545	ssafy
8	\N	\N	ㅠㅠ	2026-01-30 17:36:55.495419	0	\N	\N	2026-01-30 17:36:55.495419	ssafy2
12	\N	\N	ㅎㅎ\n\n기록: 한강 플로깅 · 2024-11-02 · 3.2km · 32분	2026-01-30 17:59:43.333839	0	\N	\N	2026-01-30 17:59:43.333839	ssafy
11	\N	\N	1	2026-01-30 17:56:47.725422	1	\N	\N	2026-01-30 23:47:08.129542	2
10	\N	\N	34534534	2026-01-30 17:54:27.91007	1	\N	\N	2026-01-30 23:48:06.837162	2
13	\N	\N	asdf	2026-01-30 20:49:50.858972	2	\N	\N	2026-01-30 23:50:07.797886	1
9	https://storage.googleapis.com/jupddang-images/sns/27d538c8-d49a-4068-964a-5f7b32a5ce98_1769763025173.jpg	https://storage.googleapis.com/jupddang-images/sns/4abdc0bb-c1a9-40df-b541-62327f106ff0_1769763025051.jpg	1의 게시물1\n\n기록: 동네 산책 플로깅 · 2024-10-24 · 1.4km · 18분	2026-01-30 17:50:25.24428	2	\N	\N	2026-01-30 23:50:10.93142	1
14	https://storage.googleapis.com/jupddang-images/plogging/ssafy/4/9b20ca0a-3b07-4fd6-a008-3d0cae465e06_1769786266257.jpg	https://storage.googleapis.com/jupddang-images/plogging/ssafy/4/a4e95061-708e-4cad-bdd1-d9f7276aa3b6_1769786265672.jpg	좋았죠 뭐	2026-01-31 00:17:46.746501	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy/4/cb9747be-8ae9-415c-8bfc-366afb1a4717_1769786266661.png	4	2026-01-31 00:17:46.746501	ssafy
15	https://storage.googleapis.com/jupddang-images/plogging/ssafy/5/ca2973c3-f8dc-40dc-aa3b-55bb912ce9f9_1769786588350.jpg	https://storage.googleapis.com/jupddang-images/plogging/ssafy/5/882bf840-f052-4018-96b6-bdea49e908ef_1769786587865.jpg	테스트임돠	2026-01-31 00:23:08.922099	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy/5/f9279b25-d877-4f99-819b-cc3bbae993f9_1769786588819.png	5	2026-01-31 00:23:08.922099	ssafy
21	\N	\N	whyrano	2026-02-01 01:30:42.460424	0	\N	\N	2026-02-01 01:30:42.460424	1
24	https://storage.googleapis.com/jupddang-images/plogging/ssafy/8/e05850c7-fb2e-41a5-aaf3-74332f830b29_1769926719826.jpg	https://storage.googleapis.com/jupddang-images/plogging/ssafy/8/0aea6f0d-0f4f-44d8-878d-ba265597513d_1769926718365.jpg	ㅎㅎ\n\n기록: ㅎㅎ 쨌 2026-02-01 쨌 0.0km 쨌 0분	2026-02-01 15:18:40.459033	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy/8/33006f64-a824-4289-98a1-bf3fda074c1a_1769926720355.png	8	2026-02-01 15:18:40.459033	ssafy
26	https://storage.googleapis.com/jupddang-images/plogging/ranker1/9/2db052f8-8227-4253-a6bf-5f68b9b242bc_1769949462268.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker1/9/77df6f73-7625-465d-9aed-5d68c68b1d6a_1769949461950.jpg	내가 1등이다!	2026-02-01 21:37:42.406195	0	https://storage.googleapis.com/jupddang-images/plogging/ranker1/9/1b170663-5207-4bc1-9f88-b01421b1a78e_1769949462328.jpg	9	2026-02-01 21:37:42.406195	ranker1
27	https://storage.googleapis.com/jupddang-images/plogging/ranker1/10/740f9423-8657-4429-934f-5d5ce0282148_1769949602346.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker1/10/7e34a259-f1b7-443b-99a9-16684241e512_1769949602219.jpg	내가 1등이다!	2026-02-01 21:40:02.472281	0	https://storage.googleapis.com/jupddang-images/plogging/ranker1/10/d8b12701-a7f2-499a-9116-b0c1ce0afa21_1769949602404.jpg	10	2026-02-01 21:40:02.472281	ranker1
28	https://storage.googleapis.com/jupddang-images/plogging/ranker1/11/1002857e-15c0-48dd-ac98-da9d68455783_1769949633606.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker1/11/73556742-5f0b-4fda-ad8a-c17062628461_1769949633477.jpg	내가 1등이다!	2026-02-01 21:40:33.726479	0	https://storage.googleapis.com/jupddang-images/plogging/ranker1/11/d8efbaa0-a3a3-4a4f-82ea-04f9d5eba7ee_1769949633664.jpg	11	2026-02-01 21:40:33.726479	ranker1
29	https://storage.googleapis.com/jupddang-images/plogging/ranker1/12/6800c193-d7a4-4ac7-b745-ad1e7239057c_1769949634666.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker1/12/c64a60b9-395b-4853-8c53-08dff2b4d3a2_1769949634584.jpg	내가 1등이다!	2026-02-01 21:40:34.793928	0	https://storage.googleapis.com/jupddang-images/plogging/ranker1/12/8a0bc288-fab4-4dc2-a98a-93891423aed7_1769949634727.jpg	12	2026-02-01 21:40:34.793928	ranker1
30	https://storage.googleapis.com/jupddang-images/plogging/ranker1/13/559604ec-04ec-46ab-aed1-3934df4aad71_1769949673932.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker1/13/6b5fcd6c-0250-4953-85a8-cb593ab638ce_1769949673803.jpg	내가 1등이다!	2026-02-01 21:41:14.058938	0	https://storage.googleapis.com/jupddang-images/plogging/ranker1/13/5de34241-6f6e-4ddc-af08-1bc0424f57cd_1769949673985.jpg	13	2026-02-01 21:41:14.058938	ranker1
31	https://storage.googleapis.com/jupddang-images/plogging/ranker5/14/3bb5f689-57d2-4cb0-94aa-24f0dd7f20bd_1769949912988.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker5/14/fcd3d61e-1f8c-4922-b0e3-29e1ebfecbeb_1769949912850.jpg	나는 2등!	2026-02-01 21:45:13.123649	0	https://storage.googleapis.com/jupddang-images/plogging/ranker5/14/5acccb55-42bf-4c05-844d-f1e28d771b4d_1769949913056.jpg	14	2026-02-01 21:45:13.123649	ranker5
32	https://storage.googleapis.com/jupddang-images/plogging/ranker5/15/be037f94-ab67-4b0b-abcd-f4039a73f06f_1769949916702.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker5/15/acf84f7c-39c9-47e7-8f8a-9073a140eda1_1769949916617.jpg	나는 2등!	2026-02-01 21:45:16.823744	0	https://storage.googleapis.com/jupddang-images/plogging/ranker5/15/f5756c6d-b5ba-4a05-83bb-d2aec733faa3_1769949916760.jpg	15	2026-02-01 21:45:16.823744	ranker5
33	https://storage.googleapis.com/jupddang-images/plogging/ranker5/16/dd773359-d39e-48a1-b3e0-579e62c84c3e_1769949917791.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker5/16/094598ce-aef2-46dc-9eb9-c4ab1b117d15_1769949917712.jpg	나는 2등!	2026-02-01 21:45:17.913658	0	https://storage.googleapis.com/jupddang-images/plogging/ranker5/16/74209af5-a8e8-4442-992d-2250338586ad_1769949917849.jpg	16	2026-02-01 21:45:17.913658	ranker5
34	https://storage.googleapis.com/jupddang-images/plogging/ranker5/17/8b2375ab-72a3-44b4-8b9c-59bb88e59e60_1769949918658.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker5/17/1292ac8b-d9ba-4746-a950-847f378f9ed2_1769949918583.jpg	나는 2등!	2026-02-01 21:45:18.776232	0	https://storage.googleapis.com/jupddang-images/plogging/ranker5/17/71f5b722-081f-449c-9001-a7b3afa9aa1c_1769949918712.jpg	17	2026-02-01 21:45:18.776232	ranker5
35	https://storage.googleapis.com/jupddang-images/plogging/ranker5/18/ed1f1e36-780b-45df-b637-171218c46cc9_1769949998194.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker5/18/2853dd63-e054-46fa-8f32-6a0a3ebd1af1_1769949998067.jpg	나는 2등!	2026-02-01 21:46:38.319944	0	https://storage.googleapis.com/jupddang-images/plogging/ranker5/18/eca892fc-8024-437e-a89e-bb8299b61431_1769949998254.jpg	18	2026-02-01 21:46:38.319944	ranker5
36	https://storage.googleapis.com/jupddang-images/plogging/ranker5/19/8609420d-af04-4a52-a878-d947d03e2225_1769949999125.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker5/19/b00feee6-1dc7-4587-88fe-38cb3ec43701_1769949999061.jpg	나는 2등!	2026-02-01 21:46:39.235281	0	https://storage.googleapis.com/jupddang-images/plogging/ranker5/19/63357510-f3b5-4934-8c1b-324cec7f4ffc_1769949999173.jpg	19	2026-02-01 21:46:39.235281	ranker5
37	https://storage.googleapis.com/jupddang-images/plogging/ranker5/20/ab7e7b0d-ac5e-4294-89e1-8bd874428155_1769950027521.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker5/20/1642f5c1-951f-44f0-ab58-15c2f5661615_1769950027407.jpg	나는 2등!	2026-02-01 21:47:07.652281	0	https://storage.googleapis.com/jupddang-images/plogging/ranker5/20/03f51f54-4b58-4d5c-899a-8aef40383d14_1769950027586.jpg	20	2026-02-01 21:47:07.652281	ranker5
38	https://storage.googleapis.com/jupddang-images/plogging/ranker5/21/c225c911-470b-4824-b56e-4fbc4cf332e5_1769950033072.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker5/21/80e923eb-6ed4-4fed-960c-e2072967f657_1769950032962.jpg	나는 2등!	2026-02-01 21:47:13.185065	0	https://storage.googleapis.com/jupddang-images/plogging/ranker5/21/96ec1237-6c4d-4903-8511-535af8b93808_1769950033120.jpg	21	2026-02-01 21:47:13.185065	ranker5
39	https://storage.googleapis.com/jupddang-images/plogging/ranker5/22/52b4d884-a619-4029-a3d0-45194e9aeacf_1769950038837.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker5/22/900e4f66-b689-4885-bb1e-8a1727eb3df5_1769950038723.jpg	나는 2등!	2026-02-01 21:47:18.944774	0	https://storage.googleapis.com/jupddang-images/plogging/ranker5/22/1c1d510c-701e-44d8-956b-2fe64570a959_1769950038885.jpg	22	2026-02-01 21:47:18.944774	ranker5
40	https://storage.googleapis.com/jupddang-images/plogging/ranker5/23/ff421d97-57fb-4396-9995-b46913365b95_1769950045462.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker5/23/60ff0ee6-6601-4946-8c54-03651e51f521_1769950045340.jpg	나는 2등!	2026-02-01 21:47:25.579525	0	https://storage.googleapis.com/jupddang-images/plogging/ranker5/23/f5486752-992d-4754-88ef-59d6a9fac255_1769950045517.jpg	23	2026-02-01 21:47:25.579525	ranker5
41	https://storage.googleapis.com/jupddang-images/plogging/ranker5/24/455182c5-0947-4ef1-9ba3-9a38bd380212_1769950046235.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker5/24/7616116c-6339-44f6-92f1-65f6a1df34fe_1769950046163.jpg	나는 2등!	2026-02-01 21:47:26.348573	0	https://storage.googleapis.com/jupddang-images/plogging/ranker5/24/44c8491d-65c7-455f-9c00-8e467ac0b217_1769950046296.jpg	24	2026-02-01 21:47:26.348573	ranker5
42	https://storage.googleapis.com/jupddang-images/plogging/ranker7/25/ca878194-19ea-459a-b0a8-92a801beab31_1769950078907.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker7/25/6524c1a5-a551-418c-8106-34c6c2e7bca7_1769950078778.jpg	나는 2등!	2026-02-01 21:47:59.029058	0	https://storage.googleapis.com/jupddang-images/plogging/ranker7/25/9ee9493e-b55d-469e-b270-7b4f7fd284e7_1769950078963.jpg	25	2026-02-01 21:47:59.029058	ranker7
43	https://storage.googleapis.com/jupddang-images/plogging/ranker7/26/0ebe860f-34c1-4c7e-a442-eab4453f68f5_1769950102530.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker7/26/537911b9-5047-4bc5-8628-7543f0303c99_1769950102412.jpg	나는 1등!	2026-02-01 21:48:22.650932	0	https://storage.googleapis.com/jupddang-images/plogging/ranker7/26/19271917-0b1b-4ade-95e5-b7b6293c6594_1769950102587.jpg	26	2026-02-01 21:48:22.650932	ranker7
44	https://storage.googleapis.com/jupddang-images/plogging/ranker7/27/a15bacb6-a013-48bd-9c61-55d9344882ba_1769950114877.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker7/27/5aa2d275-75ae-4d37-bd84-d3e6c8ee4dfb_1769950114762.jpg	나는 1등!	2026-02-01 21:48:34.989434	0	https://storage.googleapis.com/jupddang-images/plogging/ranker7/27/b772d729-f654-4fb3-845f-5f67b6eeff0c_1769950114930.jpg	27	2026-02-01 21:48:34.989434	ranker7
45	https://storage.googleapis.com/jupddang-images/plogging/ranker7/28/bcee33f6-c4b4-4714-9267-82525416eb12_1769950119959.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker7/28/9ce4677d-6aaf-4046-86e9-a231686f8d56_1769950119887.jpg	나는 1등!	2026-02-01 21:48:40.078929	0	https://storage.googleapis.com/jupddang-images/plogging/ranker7/28/f93440ff-23ea-4d6e-9fb1-bf8322c73ea2_1769950120012.jpg	28	2026-02-01 21:48:40.078929	ranker7
46	https://storage.googleapis.com/jupddang-images/plogging/ranker2/29/8ab5720d-4a22-44c8-bd94-e269107fb6df_1769950214094.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker2/29/4bd6aad0-fded-4d84-b38f-e2b3503f929b_1769950213954.jpg	나는 1등!	2026-02-01 21:50:14.230557	0	https://storage.googleapis.com/jupddang-images/plogging/ranker2/29/0cde7367-16c0-4ad1-b9bb-ab967b644c3f_1769950214148.jpg	29	2026-02-01 21:50:14.230557	ranker2
47	https://storage.googleapis.com/jupddang-images/plogging/ranker2/30/9a155c3c-3585-41ca-85ef-79585faca78f_1769950222145.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker2/30/e4eee53d-92a3-45b1-9ec2-032ee08b2150_1769950222017.jpg	나는 1등!	2026-02-01 21:50:22.265533	0	https://storage.googleapis.com/jupddang-images/plogging/ranker2/30/1d35ce89-0a1d-438d-95d9-7fb44ec6eb00_1769950222198.jpg	30	2026-02-01 21:50:22.265533	ranker2
48	https://storage.googleapis.com/jupddang-images/plogging/ranker2/31/61da9e97-a5d1-4313-9236-3e3ddf5a47dc_1769950229973.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker2/31/20de58ad-f41d-4be0-9f4c-5dbfa42ec0df_1769950229851.jpg	나는 1등!	2026-02-01 21:50:30.091138	0	https://storage.googleapis.com/jupddang-images/plogging/ranker2/31/4018d5ec-8106-412e-b18e-e28d8392b622_1769950230030.jpg	31	2026-02-01 21:50:30.091138	ranker2
49	https://storage.googleapis.com/jupddang-images/plogging/ranker3/32/f3b5d5f9-d016-4daa-bac2-d63b09d6eb64_1769950239574.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker3/32/e9f11f40-8158-40dd-bd64-61f7e5a4955b_1769950239464.jpg	나는 1등!	2026-02-01 21:50:39.691052	0	https://storage.googleapis.com/jupddang-images/plogging/ranker3/32/81bd431c-cba0-4487-bda6-66afe99d010f_1769950239625.jpg	32	2026-02-01 21:50:39.691052	ranker3
50	https://storage.googleapis.com/jupddang-images/plogging/ranker3/33/6b4e9831-8922-469c-a299-47f0e52bbd18_1769950241884.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker3/33/9e055c03-75b6-4a0e-b9e8-d1487e75f5fb_1769950241819.jpg	나는 1등!	2026-02-01 21:50:41.996366	0	https://storage.googleapis.com/jupddang-images/plogging/ranker3/33/4bbd2b2a-5762-4b5e-a6d3-1fc3ae7b3384_1769950241939.jpg	33	2026-02-01 21:50:41.996366	ranker3
51	https://storage.googleapis.com/jupddang-images/plogging/ranker4/34/63ecd686-c69f-4b78-b2d0-478a01c580b7_1769950246089.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker4/34/d70e0093-69a1-4911-99a5-9a6fef7baa60_1769950246019.jpg	나는 1등!	2026-02-01 21:50:46.204487	0	https://storage.googleapis.com/jupddang-images/plogging/ranker4/34/a8d2b8c1-12a5-42ee-9d64-3ff4f19c3916_1769950246141.jpg	34	2026-02-01 21:50:46.204487	ranker4
52	https://storage.googleapis.com/jupddang-images/plogging/ranker5/35/e6329249-9623-46aa-a4fa-4968f7d1cf9b_1769950254545.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker5/35/9e34eeff-a9aa-4cf7-a9d1-68c01c347fa4_1769950254423.jpg	나는 1등!	2026-02-01 21:50:54.664039	0	https://storage.googleapis.com/jupddang-images/plogging/ranker5/35/1ff8e298-441f-4f88-acfc-0893cb9c600e_1769950254600.jpg	35	2026-02-01 21:50:54.664039	ranker5
53	https://storage.googleapis.com/jupddang-images/plogging/ranker6/36/73140a96-95d6-446f-84c8-57e581b27f62_1769950261399.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker6/36/c3fec8e4-ad2a-4fb7-b1b2-1cb1f8efa73c_1769950261283.jpg	나는 1등!	2026-02-01 21:51:01.523803	0	https://storage.googleapis.com/jupddang-images/plogging/ranker6/36/bb32a032-d36e-4756-91e4-5569b4d6358e_1769950261460.jpg	36	2026-02-01 21:51:01.523803	ranker6
54	https://storage.googleapis.com/jupddang-images/plogging/ranker8/37/39c46248-1bdd-4599-bccc-38748115895f_1769950272400.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker8/37/20c00f99-1919-48c4-b923-faae7c838db8_1769950272268.jpg	나는 1등!	2026-02-01 21:51:12.509451	0	https://storage.googleapis.com/jupddang-images/plogging/ranker8/37/8de6d7a1-2bf1-4e70-af36-1c06984ddeb3_1769950272450.jpg	37	2026-02-01 21:51:12.509451	ranker8
55	https://storage.googleapis.com/jupddang-images/plogging/ranker9/38/7cf1b38b-9cf8-4b14-a869-5f613c1ebab6_1769950279117.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker9/38/2d42b98d-0269-427a-823d-db66da21747b_1769950278993.jpg	나는 1등!	2026-02-01 21:51:19.240843	0	https://storage.googleapis.com/jupddang-images/plogging/ranker9/38/0b12d822-5cfa-4c3c-b093-3f29159031f4_1769950279176.jpg	38	2026-02-01 21:51:19.240843	ranker9
56	https://storage.googleapis.com/jupddang-images/plogging/ranker10/39/a249b8dc-795c-49cf-83c9-0b9343578baa_1769950287700.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker10/39/88063300-0af5-4cf3-a20f-53c77bd749ef_1769950287586.jpg	나는 1등!	2026-02-01 21:51:27.815193	0	https://storage.googleapis.com/jupddang-images/plogging/ranker10/39/c5e67309-0582-435e-8436-b2932b61542e_1769950287757.jpg	39	2026-02-01 21:51:27.815193	ranker10
58	https://storage.googleapis.com/jupddang-images/plogging/ranker1/41/58348883-ba1f-4f44-8aa5-2d36ad5967f8_after1.webp	https://storage.googleapis.com/jupddang-images/plogging/ranker1/41/801ea247-8353-468e-b45b-125d12ea8330_before1.webp	플로깅 찢었따리	2026-02-03 15:55:14.624802	0	https://storage.googleapis.com/jupddang-images/plogging/ranker1/41/a5dbf8c4-c59a-43c9-964e-1c14fa9bd830_EkdEkajrrl.webp	41	2026-02-03 15:55:14.624802	ranker1
59	https://storage.googleapis.com/jupddang-images/plogging/ranker1/42/a8151a30-e32c-4be7-bb4e-e2839fb3852a_쓰레기없는사진3.webp	https://storage.googleapis.com/jupddang-images/plogging/ranker1/42/4d59e41c-1a7b-48eb-b40c-9d2aec479e5f_쓰레기있는사진3.webp	내가 1등이다!	2026-02-03 15:57:17.901006	0	https://storage.googleapis.com/jupddang-images/plogging/ranker1/42/288412c9-070f-41bf-a72d-df43dcb745f8_지도.webp	42	2026-02-03 15:57:17.901006	ranker1
63	\N	\N	fff	2026-02-05 01:56:12.318636	2	\N	\N	2026-02-05 14:29:29.571543	ranker9
65	\N	\N	sdf	2026-02-05 14:44:35.537136	1	\N	\N	2026-02-05 15:19:36.759067	ranker5
62	\N	\N	asdf	2026-02-05 01:55:41.700323	1	\N	\N	2026-02-05 02:57:20.445453	ranker9
64	\N	\N	asdfasdf	2026-02-05 01:56:56.012859	6	\N	\N	2026-02-05 14:29:27.151208	ranker9
66	https://storage.googleapis.com/jupddang-images/plogging/test/45/b1365ca3-b3e3-4933-9fc4-6814add3a98d_32.webp	https://storage.googleapis.com/jupddang-images/plogging/test/45/7f663fff-d52d-4dfa-be84-792ed1b9c4b3_34.webp	111\n\n기록: ddd · 2026-02-05 · 0.0km · 2초 · 0점	2026-02-05 17:15:22.050467	0	https://storage.googleapis.com/jupddang-images/plogging/test/45/6e52bf00-89c1-4756-baf0-1a4613fa612b_map_1770279308048.webp	45	2026-02-05 17:15:22.050467	test
67	https://storage.googleapis.com/jupddang-images/plogging/test/46/f2b6b761-e24b-4b98-87ba-51539f6807ae_after.webp	https://storage.googleapis.com/jupddang-images/plogging/test/46/3be7316c-1cda-4fd3-83b8-eef74ef4842a_before.webp	dd\n\n기록: dd · 2026-02-05 · 0.0km · 26초 · 0점	2026-02-05 22:54:35.13256	0	https://storage.googleapis.com/jupddang-images/plogging/test/46/1a2a3b20-b06e-4ff7-9c95-c2a084109e8e_map.webp	46	2026-02-05 22:54:35.13256	test
71	https://storage.googleapis.com/jupddang-images/plogging/ssafy/50/c0223e9a-bcc6-418e-9330-396f0de623fa_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy/50/08e04daf-a144-4ea1-9579-03e4d2e681e1_before.webp	good\n\n기록: good · 2026-02-06 · 0.0km · 44초 · 0점	2026-02-06 05:56:16.525395	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy/50/a4ef179b-1d5d-4280-9551-cb0befc4a716_map.webp	50	2026-02-06 05:56:16.525395	ssafy
72	\N	\N	굳!\n\n기록: 기록1 · 2026.02.06 · 0.00km · 0m	2026-02-06 07:47:53.800598	0	\N	\N	2026-02-06 07:47:53.800598	ssafy
73	\N	\N	ㅎㅎ\n\n기록: 기록1 · 2026.02.06 · 0.00km · 0m	2026-02-06 09:15:23.219009	0	\N	\N	2026-02-06 09:15:23.219009	ssafy
74	https://storage.googleapis.com/jupddang-images/plogging/ssafy/74/0f90fcad-2204-4807-8122-063ed320e77f_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy/74/fc4cef45-5a90-4a12-9a6d-f4d603cb2ec7_before.webp	기록2입니다!\n\n기록: 기록2 · 2026.02.06 · 0.00km · 0m	2026-02-06 09:55:34.56162	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy/74/9ac26b48-bc27-43cd-8f37-393127f85d6f_map.webp	\N	2026-02-06 09:55:35.574018	ssafy
75	https://storage.googleapis.com/jupddang-images/plogging/test/53/ba9fb530-f62c-4733-8240-3b847547875e_after.webp	https://storage.googleapis.com/jupddang-images/plogging/test/53/e54eaf90-bd35-4d1f-9e3c-c00dbcbcb60e_before.webp	dddd\n\n기록: dddd · 2026-02-06 · 0.0km · 3분 13초 · 3점	2026-02-06 10:16:22.367037	0	https://storage.googleapis.com/jupddang-images/plogging/test/53/93684eb0-a5d0-48ac-b9a5-1320c39c699c_map.webp	53	2026-02-06 10:16:22.367037	test
76	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/76/753213ec-8b5f-4e52-8832-3024d2ff2ff6_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/76/849c2803-d690-40f2-b79e-ca962fc24d64_before.webp	좋아요\n\n기록: 기록_1 · 2026.02.06 · 0.00km · 0m	2026-02-06 10:56:36.65768	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/76/084382db-95aa-470f-b8b9-d3a164924f1d_map.webp	\N	2026-02-06 10:56:39.619666	ssafy4
80	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/80/035346c3-ab72-4250-b041-f170cf8073fa_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/80/f2112f3b-075b-46f5-acde-d1bb851afc9d_before.webp	좋아요	2026-02-06 14:07:40.600516	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/80/36dea237-46d0-4d14-b064-20f4d0412982_map.webp	54	2026-02-06 14:07:44.569141	ssafy4
81	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/81/60599297-52af-48b1-a2f4-2e8efe3c8222_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/81/70635c03-8cec-4e6a-bce7-2eafa55bd7fe_before.webp	으어	2026-02-06 14:10:24.454585	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/81/78793842-3450-44fa-bbd9-7b33754d2e6b_map.webp	55	2026-02-06 14:10:27.801447	ssafy4
84	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/84/84a34111-5455-420e-a2a4-395e64492ac6_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/84/ee5d2513-31e0-46fd-a6cd-2f25f331405f_before.webp	ㅎㅎ	2026-02-06 14:26:58.24639	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/84/5981252f-6b66-4bb7-a767-0e410eb93b90_map.webp	57	2026-02-06 14:27:00.684457	ssafy4
86	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/86/5b98e9dd-fdcf-470d-8e92-37e15b8314f8_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/86/a2937e3f-359f-413d-966d-954ca257e23c_before.webp	추워요	2026-02-06 15:17:40.223787	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/86/46ab6b51-1bec-4179-b0ae-3f106a178785_map.webp	59	2026-02-06 15:17:44.457321	ssafy4
92	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/92/50d70aa7-00a8-4ce4-8e7d-42cab0e8295a_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/92/c7891a86-75fd-4201-ac68-f98cec41cd35_before.webp	임시저장 후 작성된 글 입니다\n\n기록: 비애 테스트 · 2026.02.06 · 0.00km · 0m	2026-02-06 16:08:11.047918	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/92/7d45eeba-a96d-44db-9147-663597cbecff_map.webp	63	2026-02-06 16:08:14.5737	ssafy4
87	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/87/f2be8b8b-27f0-4fbc-b75f-f683d704654b_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/87/c7585266-97eb-45f8-a2da-867c41f35e27_before.webp	배고파!\n\n기록: 기록!! · 2026.02.06 · 0.00km · 0m	2026-02-06 15:39:11.535117	1	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/87/73738ade-e4a0-4e67-8e3b-7a75189eb60f_map.webp	60	2026-02-06 15:45:13.328771	ssafy4
88	https://storage.googleapis.com/jupddang-images/plogging/test/61/0d78b60b-4a40-491a-ad7a-cc2108c0ebba_after.webp	https://storage.googleapis.com/jupddang-images/plogging/test/61/a4628978-ba59-4c14-b139-698d78eba7b6_before.webp	추워요\n\n기록: 동네 한바퀴 · 2026-02-06 · 0.2km · 4분 26초 · 6점	2026-02-06 15:48:29.886442	0	https://storage.googleapis.com/jupddang-images/plogging/test/61/aa843691-7dcb-4b2e-9f52-6ed2c9c22445_map.webp	61	2026-02-06 15:48:29.886442	test
89	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/62/ecc500fb-bac6-41cf-818e-e29d40b8cea4_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/62/af2384c3-a3e7-4609-87e5-619158667dce_before.webp	비포 애프터 테스트\n\n기록: 비애 · 2026-02-06 · 0.0km · 27초 · 0점	2026-02-06 15:59:24.35314	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/62/4eb2e4f7-a958-462c-8709-d5ceecf5b28e_map.webp	62	2026-02-06 15:59:24.35314	ssafy4
93	https://storage.googleapis.com/jupddang-images/plogging/test/64/cd7992c3-066d-4dea-8c69-f68d625e8ac9_after.webp	https://storage.googleapis.com/jupddang-images/plogging/test/64/a14715c3-3f65-4085-928a-079e82af739f_before.webp	ddd\n\n기록: ddd · 2026-02-06 · 0.0km · 45초 · 0점	2026-02-06 16:26:44.90645	0	https://storage.googleapis.com/jupddang-images/plogging/test/64/0d0f55d5-4978-4e04-9565-ddb2b782297a_map.webp	64	2026-02-06 16:26:44.90645	test
94	https://storage.googleapis.com/jupddang-images/plogging/test/65/a54dfd0a-c5e9-4b90-8dfe-c650ee0be865_after.webp	https://storage.googleapis.com/jupddang-images/plogging/test/65/f7731159-1a36-4c64-b73c-13e2fa9331dc_before.webp	ddd\n\n기록: ddd · 2026-02-06 · 0.0km · 1분 5초 · 1점	2026-02-06 16:30:20.49931	0	https://storage.googleapis.com/jupddang-images/plogging/test/65/6441a244-4a7a-435d-88e6-6cc720a7e07c_map.webp	65	2026-02-06 16:30:20.49931	test
95	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/66/d84520b4-a379-4413-be5f-8b9d76e3b676_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/66/f1344162-315f-4397-ad26-1c152dd64968_before.webp	TLI 작성하세요\n\n기록: TMI · 2026-02-06 · 0.0km · 30초 · 0점	2026-02-06 16:58:12.152697	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/66/29b6b907-03bb-48fa-a0e5-82cd80118659_map.webp	66	2026-02-06 16:58:12.152697	ssafy4
97	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/68/176a2577-eadc-4613-aa4a-1013045ca4f1_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/68/54faee0a-5dfa-426c-82d1-3e23cb40407e_before.webp	일반 종료\n\n기록: 일반 종료 · 2026-02-06 · 0.0km · 20초 · 0점	2026-02-06 17:15:41.776891	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/68/1b62fd26-9606-4b26-b382-5c3f89011a1a_map.webp	68	2026-02-06 17:15:41.776891	ssafy4
98	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/98/f11146bd-4ccb-4191-8e91-4e4a33b0caad_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/98/6179bdbb-ccd2-461f-ba87-6b75e5ad23eb_before.webp	임시 저장 테스트\n\n기록: 임시 저장 테스트 · 2026.02.06 · 0.00km · 0m · 0점	2026-02-06 17:27:33.079351	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/98/abb8cbda-85c6-4672-b681-22aa9c799f26_map.webp	69	2026-02-06 17:27:36.844598	ssafy4
99	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/99/b3be475d-19fb-4d69-9f5a-c2a7b0d2a430_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/99/41c69608-cdba-4507-bb6d-f6dda7c3bbda_before.webp	임시테스트2\n\n기록: 임시테스트2 · 2026.02.06 · 0.00km · 0m · 0점	2026-02-06 17:38:51.540527	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/99/c51ddb1c-bb92-4ac0-a881-194b0c17c958_map.webp	70	2026-02-06 17:38:56.084838	ssafy4
100	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/71/c5d0baa0-1cdf-4809-8148-74e2de77b576_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/71/b8824cfb-5dff-4c46-b398-ef4e241e4f68_before.webp	일반 플러깅 테스트\n\n기록: 일반 플러깅 테스트 · 2026-02-06 · 0.0km · 25초 · 0점	2026-02-06 17:40:06.136366	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/71/6787aecf-10db-4d0b-9d78-c3b3152d7c35_map.webp	71	2026-02-06 17:40:06.136366	ssafy4
118	https://storage.googleapis.com/jupddang-images/plogging/komae/88/989f1fa4-9c46-4c8b-9079-69b5a759928d_after.webp	https://storage.googleapis.com/jupddang-images/plogging/komae/88/8efcffda-2081-475d-a6eb-f9c328fb53ac_before.webp	.\n\n기록: . · 2026-02-08 · 0.1km · 17분 8초 · 23점	2026-02-08 23:49:54.535432	0	https://storage.googleapis.com/jupddang-images/plogging/komae/88/436b58ca-3aa6-4f7c-807f-a540ef7ed8fd_map.webp	88	2026-02-08 23:49:54.535432	komae
101	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/72/21c985e0-cb3f-4275-920e-30f760381263_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/72/c1e5ee53-2bed-4edc-b772-25d2d6135534_before.webp	일반 플러깅 테스트\n\n기록: 일반 플러깅 테스트 · 2026-02-06 · 0.0km · 25초 · 0점	2026-02-06 17:41:14.727625	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/72/c501d2bd-f405-4865-9d51-76287d913193_map.webp	72	2026-02-06 17:41:14.727625	ssafy4
102	https://storage.googleapis.com/jupddang-images/plogging/user1/73/1a9cc8db-6992-48e1-a6dd-237e3ae84058_after.webp	https://storage.googleapis.com/jupddang-images/plogging/user1/73/e0e5c8b5-1cef-4ed6-83cf-41ac1543e0d1_before.webp	춥지만 뿌듯합니당 ㅎㅎ\n\n기록: 토욜밤 플로깅 · 2026-02-07 · 0.2km · 9분 10초 · 11점	2026-02-07 21:28:41.089744	0	https://storage.googleapis.com/jupddang-images/plogging/user1/73/b65b18dd-8f5d-4565-9078-df792126eafa_map.webp	73	2026-02-07 21:28:41.089744	user1
103	https://storage.googleapis.com/jupddang-images/plogging/user2/74/21656bd4-f24b-4317-8686-fd9bc5a105f7_after.webp	https://storage.googleapis.com/jupddang-images/plogging/user2/74/339377e8-39fb-4d66-acaa-f1150613f752_before.webp	오플완!\n\n기록: 오플완 · 2026-02-07 · 0.2km · 5분 43초 · 6점	2026-02-07 21:35:22.895885	0	https://storage.googleapis.com/jupddang-images/plogging/user2/74/9842c435-ad91-4a8a-b65b-d76927b134cf_map.webp	74	2026-02-07 21:35:22.895885	user2
104	https://storage.googleapis.com/jupddang-images/plogging/user3/75/29668c12-80e1-4108-8520-326098afc5e5_after.webp	https://storage.googleapis.com/jupddang-images/plogging/user3/75/073cba6f-f4a7-445b-9dfc-a88ec0b13779_before.webp	오늘은 담배꽁초 주웠습니다\n\n기록: 2월7일 · 2026-02-07 · 0.0km · 4분 45초 · 4점	2026-02-07 21:42:14.308159	0	https://storage.googleapis.com/jupddang-images/plogging/user3/75/94e183d7-3fce-4547-9a4f-c0b22e78021f_map.webp	75	2026-02-07 21:42:14.308159	user3
61	https://storage.googleapis.com/jupddang-images/plogging/ranker1/44/39370c1d-345f-47c6-99c1-83bd338b3944_쓰레기없는사진4.webp	https://storage.googleapis.com/jupddang-images/plogging/ranker1/44/0088f187-5ea3-4570-a294-80897781bbc9_쓰레기있는사진4.webp	내가 1등이다!	2026-02-03 16:08:07.484536	2	https://storage.googleapis.com/jupddang-images/plogging/ranker1/44/08bda834-e202-4c23-a41b-6519f45a06f6_지도.webp	44	2026-02-07 21:55:57.005554	ranker1
105	https://storage.googleapis.com/jupddang-images/plogging/user4/76/7cb6fd55-af73-4ac4-bb1e-0c61a6676c96_after.webp	https://storage.googleapis.com/jupddang-images/plogging/user4/76/2f3ec736-53f0-494c-b28b-bf7121e50cf6_before.webp	춥지만.. 마음은 따뜻합니다..\n\n기록: 구미 플로깅 · 2026-02-07 · 0.1km · 12분 11초 · 13점	2026-02-07 21:56:51.629578	1	https://storage.googleapis.com/jupddang-images/plogging/user4/76/543b8673-ba02-4fce-95ad-2b32c21108d0_map.webp	76	2026-02-07 23:55:50.836403	user4
106	https://storage.googleapis.com/jupddang-images/plogging/komae/77/cc0c93a1-002f-4a0f-a7be-67094d0668be_after.webp	https://storage.googleapis.com/jupddang-images/plogging/komae/77/c194b923-fd74-495e-913e-9d3bab229039_before.webp	cold\n\n기록: cold · 2026-02-08 · 0.1km · 1분 31초 · 2점	2026-02-08 00:09:08.983212	1	https://storage.googleapis.com/jupddang-images/plogging/komae/77/e44cacb9-3aaf-418a-907a-1be3dcb4bd93_map.webp	77	2026-02-08 00:29:11.213302	komae
108	https://storage.googleapis.com/jupddang-images/plogging/komae/78/9d81326b-b050-47e2-8719-eaa66b191d51_after.webp	https://storage.googleapis.com/jupddang-images/plogging/komae/78/b8f1feb8-3d9e-4908-abcc-5ed9770c9dc1_before.webp	춥다\n\n기록: 춥다 · 2026-02-08 · 0.1km · 2분 15초 · 3점	2026-02-08 13:10:03.352408	1	https://storage.googleapis.com/jupddang-images/plogging/komae/78/ed211e58-4246-404f-83e4-6172cd5c4d35_map.webp	78	2026-02-08 15:36:21.458789	komae
110	https://storage.googleapis.com/jupddang-images/plogging/user5/80/0f513f85-80b4-4b6d-bf10-209925139ed1_after.webp	https://storage.googleapis.com/jupddang-images/plogging/user5/80/dfe0eae2-5a77-4053-afa8-0857f8ca48d4_before.webp	추워요!! 어제보단 덜\n\n기록: 담꽁 · 2026-02-08 · 0.3km · 8분 13초 · 11점	2026-02-08 21:50:02.099596	0	https://storage.googleapis.com/jupddang-images/plogging/user5/80/7189be62-da58-43b6-8242-3a2614f2865d_map.webp	80	2026-02-08 21:50:02.099596	user5
111	https://storage.googleapis.com/jupddang-images/plogging/user1/81/9060e38a-b9df-4547-9ce5-83e2b5c551b5_after.webp	https://storage.googleapis.com/jupddang-images/plogging/user1/81/e3bf592b-c041-4779-a4a8-986b7836b94b_before.webp	짧플\n\n기록: 짧은 플로깅 · 2026-02-08 · 0.1km · 2분 54초 · 2점	2026-02-08 21:54:09.169847	0	https://storage.googleapis.com/jupddang-images/plogging/user1/81/18562e86-dffc-4171-b5e8-28d7357b8805_map.webp	81	2026-02-08 21:54:09.169847	user1
112	https://storage.googleapis.com/jupddang-images/plogging/user2/82/fbe759d2-2a06-4967-b2ef-f69db7ab591f_after.webp	https://storage.googleapis.com/jupddang-images/plogging/user2/82/3daa6f57-863d-4aac-95a2-523abeaf735e_before.webp	세탁소 앞 청소\n\n기록: 동네 플로깅 · 2026-02-08 · 0.0km · 4분 2초 · 4점	2026-02-08 21:59:23.392614	0	https://storage.googleapis.com/jupddang-images/plogging/user2/82/f47745de-3822-4494-b375-422e5cc9af1a_map.webp	82	2026-02-08 21:59:23.392614	user2
113	https://storage.googleapis.com/jupddang-images/plogging/user3/83/8059423a-c1cd-442c-844a-ef16204cac33_after.webp	https://storage.googleapis.com/jupddang-images/plogging/user3/83/665127fc-6ddb-4ea0-a83c-7f0618f6ff14_before.webp	집 앞 청소 했습니다\n\n기록: 집 근처 플로깅 · 2026-02-08 · 0.2km · 4분 59초 · 5점	2026-02-08 22:05:19.948996	0	https://storage.googleapis.com/jupddang-images/plogging/user3/83/910adbce-3e81-45c7-af3e-807186d48deb_map.webp	83	2026-02-08 22:05:19.948996	user3
114	https://storage.googleapis.com/jupddang-images/plogging/user4/84/ef79d3f7-e062-478e-a930-317a6342d94b_after.webp	https://storage.googleapis.com/jupddang-images/plogging/user4/84/ae8ecfac-47c0-4c0b-b86d-b1a6a2c3395e_before.webp	추우ㅏ요\n\n기록: 춥춥 · 2026-02-08 · 0.5km · 10분 38초 · 15점	2026-02-08 22:17:05.711569	0	https://storage.googleapis.com/jupddang-images/plogging/user4/84/08f8e7d3-3b3d-4025-ac4b-4f4ea5e37634_map.webp	84	2026-02-08 22:17:05.711569	user4
115	https://storage.googleapis.com/jupddang-images/plogging/komae/85/69997e68-6844-4193-9a13-8c6a2acf0c06_after.webp	https://storage.googleapis.com/jupddang-images/plogging/komae/85/d27f73a0-3e26-4018-83ab-125954cee0ff_before.webp	cold\n\n기록: cold · 2026-02-08 · 0.1km · 8분 15초 · 9점	2026-02-08 22:31:08.786791	0	https://storage.googleapis.com/jupddang-images/plogging/komae/85/7f0cd8d0-7744-4067-bb09-df0a6e704f5d_map.webp	85	2026-02-08 22:31:08.786791	komae
116	https://storage.googleapis.com/jupddang-images/plogging/komae/86/7d9d9dd6-33ca-4101-8fd3-2fea2df7ce91_after.webp	https://storage.googleapis.com/jupddang-images/plogging/komae/86/e8d54209-f7b4-4029-9e70-b2cd27a7778a_before.webp	..\n\n기록: .. · 2026-02-08 · 0.1km · 1분 33초 · 2점	2026-02-08 22:44:08.587358	0	https://storage.googleapis.com/jupddang-images/plogging/komae/86/e50228c9-ae49-4099-965e-c3c3b095d79d_map.webp	86	2026-02-08 22:44:08.587358	komae
117	https://storage.googleapis.com/jupddang-images/plogging/komae/87/94d1cc45-a81a-4315-97f6-a345f853db7b_after.webp	https://storage.googleapis.com/jupddang-images/plogging/komae/87/312a569a-6717-4084-a1c8-609bd7a38d11_before.webp	.\n\n기록: . · 2026-02-08 · 0.1km · 17분 53초 · 18점	2026-02-08 23:24:37.850795	0	https://storage.googleapis.com/jupddang-images/plogging/komae/87/f65040df-2102-460f-8d0f-12078f866d64_map.webp	87	2026-02-08 23:24:37.850795	komae
\.


--
-- Data for Name: raid_boss; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.raid_boss (id, h3index, name, boss_type) FROM stdin;
1	8b2b90d2c94ffff	SSAFY_캠퍼스_보스	0
2	8b2b90d2c92ffff	금오산_입구_보스	0
3	8b2b90d2c93ffff	캠퍼스_북쪽_보스	0
4	8b2b90d2c95ffff	캠퍼스_동쪽_보스	0
5	8b2b90d2c96ffff	캠퍼스_남쪽_보스	0
6	8b30e1882cdafff	중심 쓰레기존	0
7	8b30e1882cd8fff	동쪽 먼지구역	2
8	8b30e1882cd2fff	서쪽 쓰레기봉투	1
9	8b30e1882cdcfff	북쪽 썩은 새싹	3
\.


--
-- Data for Name: raid_record; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.raid_record (id, total_score, updated_at, account_user_id, boss_id) FROM stdin;
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: test_entity; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.test_entity (id, content) FROM stdin;
\.


--
-- Data for Name: trashcan_verifications; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.trashcan_verifications (id, verified_at, trashcan_id, user_id) FROM stdin;
1	2026-02-03 13:28:39.266151	3013	test
2	2026-02-06 16:25:03.110857	3014	test
3	2026-02-08 01:33:19.081581	3015	ranker1
\.


--
-- Data for Name: trashcans; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.trashcans (id, address, created_at, latitude, longitude, status, updated_at, verification_count, reported_by) FROM stdin;
1	대구광역시 남구 이천로28길 42-16 대구광역시 남구 대명동 383-4	2026-01-29 23:28:24.744173	35.85385142	128.5998035	OFFICIAL	2026-01-29 23:28:24.744243	0	\N
2	대구광역시 남구 봉덕로11길 13 대구광역시 남구 봉덕동 705-32	2026-01-29 23:28:24.763183	35.84565736	128.5957994	OFFICIAL	2026-01-29 23:28:24.763205	0	\N
3	대구광역시 남구 중앙대로22길 100 대구광역시 남구 봉덕동 702-6	2026-01-29 23:28:24.764265	35.8424186	128.5959476	OFFICIAL	2026-01-29 23:28:24.764285	0	\N
4	대구광역시 남구 대명로30길 14 대구광역시 남구 대명동 916-2	2026-01-29 23:28:24.765259	35.8384918	128.5738239	OFFICIAL	2026-01-29 23:28:24.765281	0	\N
5	대구광역시 남구 큰골길 53 대구광역시 남구 대명동 2680-7	2026-01-29 23:28:24.76628	35.8372536	128.5790379	OFFICIAL	2026-01-29 23:28:24.766299	0	\N
6	대구광역시 남구 대명역6길 48 대구광역시 남구 대명동 1540	2026-01-29 23:28:24.767682	35.83269131	128.5640623	OFFICIAL	2026-01-29 23:28:24.767704	0	\N
7	대구광역시 남구 관문시장4길 53 대구광역시 남구 대명동 1180	2026-01-29 23:28:24.768902	35.83624135	128.560605	OFFICIAL	2026-01-29 23:28:24.768921	0	\N
8	대구광역시 남구 계명7길 18 대구광역시 남구 대명동 2255-1	2026-01-29 23:28:24.77008	35.85275091	128.5778762	OFFICIAL	2026-01-29 23:28:24.7701	0	\N
9	대구광역시 남구 명덕로20길 115 대구광역시 남구 대명동 642-46	2026-01-29 23:28:24.771129	35.85230083	128.5790561	OFFICIAL	2026-01-29 23:28:24.771148	0	\N
10	대구광역시 남구 두류공원로12길 25-48 대구광역시 남구 봉덕동 1067-121	2026-01-29 23:28:24.772126	35.84383615	128.5744916	OFFICIAL	2026-01-29 23:28:24.772148	0	\N
11	대구광역시 남구 두류공원로20길 19 대구광역시 남구 대명동 3043-34	2026-01-29 23:28:24.773111	35.84596976	128.5695016	OFFICIAL	2026-01-29 23:28:24.773129	0	\N
12	대구광역시 남구 봉덕로5길 20 대구광역시 남구 봉덕동 592-9	2026-01-29 23:28:24.774055	35.8461956	128.5933294	OFFICIAL	2026-01-29 23:28:24.774075	0	\N
13	대구광역시 남구 봉덕로6길35-63 대구광역시 남구 봉덕동 990-17	2026-01-29 23:28:24.775052	35.84323063	128.5922385	OFFICIAL	2026-01-29 23:28:24.775086	0	\N
14	대구광역시 남구 자유3길 54 대구광역시 남구 대명동 353-6	2026-01-29 23:28:24.776089	35.83876049	128.5819202	OFFICIAL	2026-01-29 23:28:24.776108	0	\N
15	대구광역시 남구 대명로21길 9 대구광역시 남구 대명동 1624-22	2026-01-29 23:28:24.777381	35.84009483	128.5691654	OFFICIAL	2026-01-29 23:28:24.777403	0	\N
16	대구광역시 남구 두류공원로 38 대구광역시 남구 대명동 1652-1	2026-01-29 23:28:24.778531	35.84171631	128.5735748	OFFICIAL	2026-01-29 23:28:24.778551	0	\N
17	대구광역시 남구 명덕로32길 30 대구광역시 남구 대명동 1827	2026-01-29 23:28:24.779633	35.85528539	128.5862415	OFFICIAL	2026-01-29 23:28:24.779652	0	\N
18	경기도 파주시 교하로425번길 1 경기도 파주시 동패동 302-2	2026-01-29 23:28:24.780662	37.70563342	126.7318432	OFFICIAL	2026-01-29 23:28:24.780681	0	\N
19	경기도 파주시 동패동 1363-4	2026-01-29 23:28:24.781815	37.70512501	126.7319539	OFFICIAL	2026-01-29 23:28:24.781835	0	\N
20	경기도 파주시 목동동 1150	2026-01-29 23:28:24.782849	37.72481244	126.7355358	OFFICIAL	2026-01-29 23:28:24.782871	0	\N
21	경기도 파주시 동패동 1903	2026-01-29 23:28:24.78386	37.71128925	126.737337	OFFICIAL	2026-01-29 23:28:24.783881	0	\N
22	경기도 파주시 동패동 1764	2026-01-29 23:28:24.78494	37.71007189	126.7409982	OFFICIAL	2026-01-29 23:28:24.784958	0	\N
23	경기도 파주시 동패동 1756-1	2026-01-29 23:28:24.785905	37.71036444	126.7403727	OFFICIAL	2026-01-29 23:28:24.785925	0	\N
24	경기도 파주시 동패동 1833	2026-01-29 23:28:24.786871	37.71586004	126.7383055	OFFICIAL	2026-01-29 23:28:24.78689	0	\N
25	경기도 파주시 동패동 1750	2026-01-29 23:28:24.787938	37.71299273	126.7424609	OFFICIAL	2026-01-29 23:28:24.787957	0	\N
26	경기도 파주시 동패동 1750	2026-01-29 23:28:24.788928	37.71299273	126.7424609	OFFICIAL	2026-01-29 23:28:24.788948	0	\N
27	경기도 파주시 목동동 676	2026-01-29 23:28:24.789914	37.72399972	126.7474984	OFFICIAL	2026-01-29 23:28:24.789934	0	\N
28	경기도 파주시 목동동 676	2026-01-29 23:28:24.790903	37.72399972	126.7474984	OFFICIAL	2026-01-29 23:28:24.790922	0	\N
29	경기도 파주시 목동동 1050	2026-01-29 23:28:24.791993	37.72147402	126.7371394	OFFICIAL	2026-01-29 23:28:24.792013	0	\N
30	경기도 파주시 목동동 1008	2026-01-29 23:28:24.793028	37.72524807	126.7372276	OFFICIAL	2026-01-29 23:28:24.793047	0	\N
31	경기도 파주시 야당동 1019-1	2026-01-29 23:28:24.794011	37.71008898	126.7560668	OFFICIAL	2026-01-29 23:28:24.794029	0	\N
32	경기도 파주시 야당동 1020	2026-01-29 23:28:24.795068	37.71103055	126.7502093	OFFICIAL	2026-01-29 23:28:24.795089	0	\N
33	경기도 파주시 야당동 1020	2026-01-29 23:28:24.796128	37.71103055	126.7502093	OFFICIAL	2026-01-29 23:28:24.796149	0	\N
34	경기도 파주시 목동동 870	2026-01-29 23:28:24.797102	37.73192514	126.7358329	OFFICIAL	2026-01-29 23:28:24.797121	0	\N
35	경기도 파주시 야당동 998	2026-01-29 23:28:24.79816	37.7120697	126.7591269	OFFICIAL	2026-01-29 23:28:24.798182	0	\N
36	경기도 파주시 야당동 998	2026-01-29 23:28:24.799096	37.7120697	126.7591269	OFFICIAL	2026-01-29 23:28:24.799118	0	\N
37	경기도 파주시 야당동 990	2026-01-29 23:28:24.800053	37.71326307	126.7539702	OFFICIAL	2026-01-29 23:28:24.800071	0	\N
38	경기도 파주시 목동동 870	2026-01-29 23:28:24.801027	37.73192514	126.7358329	OFFICIAL	2026-01-29 23:28:24.801046	0	\N
39	경기도 파주시 야당동 998	2026-01-29 23:28:24.801972	37.7120697	126.7591269	OFFICIAL	2026-01-29 23:28:24.801991	0	\N
40	경기도 파주시 야당동 998	2026-01-29 23:28:24.802914	37.7120697	126.7591269	OFFICIAL	2026-01-29 23:28:24.802932	0	\N
41	경기도 파주시 야당동 989	2026-01-29 23:28:24.803831	37.71685622	126.7535333	OFFICIAL	2026-01-29 23:28:24.80385	0	\N
42	경기도 파주시 야당동 989	2026-01-29 23:28:24.804827	37.71685622	126.7535333	OFFICIAL	2026-01-29 23:28:24.804848	0	\N
43	경기도 파주시 야당동 1022-5	2026-01-29 23:28:24.80586	37.7091436	126.7464058	OFFICIAL	2026-01-29 23:28:24.805878	0	\N
44	경기도 파주시 동패동 1749	2026-01-29 23:28:24.806916	37.71223811	126.7462207	OFFICIAL	2026-01-29 23:28:24.806936	0	\N
45	경기도 파주시 야당동 980	2026-01-29 23:28:24.807894	37.71225363	126.74645	OFFICIAL	2026-01-29 23:28:24.807913	0	\N
46	경기도 파주시 동패동 1749	2026-01-29 23:28:24.808858	37.71223811	126.7462207	OFFICIAL	2026-01-29 23:28:24.808877	0	\N
47	경기도 파주시 와동동 1405	2026-01-29 23:28:24.809813	37.72189881	126.7491674	OFFICIAL	2026-01-29 23:28:24.809833	0	\N
48	경기도 파주시 와동동 1364	2026-01-29 23:28:24.810861	37.72635513	126.7516634	OFFICIAL	2026-01-29 23:28:24.810881	0	\N
49	경기도 파주시 와동동 1305	2026-01-29 23:28:24.811789	37.73150741	126.7512577	OFFICIAL	2026-01-29 23:28:24.811808	0	\N
50	경기도 파주시 목동동 645	2026-01-29 23:28:24.812656	37.72957855	126.7456089	OFFICIAL	2026-01-29 23:28:24.812675	0	\N
51	경기도 파주시 와동동 1393	2026-01-29 23:28:24.813865	37.72376034	126.7546741	OFFICIAL	2026-01-29 23:28:24.813928	0	\N
52	경기도 파주시 와동동 1421	2026-01-29 23:28:24.814969	37.72417538	126.7658301	OFFICIAL	2026-01-29 23:28:24.814987	0	\N
53	경기도 파주시 와동동 1329	2026-01-29 23:28:24.816047	37.72609443	126.7609012	OFFICIAL	2026-01-29 23:28:24.816067	0	\N
54	경기도 파주시 와동동 1329	2026-01-29 23:28:24.817213	37.72609443	126.7609012	OFFICIAL	2026-01-29 23:28:24.817231	0	\N
55	경기도 파주시 와동동 1342	2026-01-29 23:28:24.818187	37.72986083	126.7560803	OFFICIAL	2026-01-29 23:28:24.818221	0	\N
56	경기도 파주시 와동동 1342	2026-01-29 23:28:24.819165	37.72986083	126.7560803	OFFICIAL	2026-01-29 23:28:24.819197	0	\N
57	경기도 파주시 금바위로 50 경기도 파주시 와동동 1378	2026-01-29 23:28:24.82013	37.72902871	126.7588583	OFFICIAL	2026-01-29 23:28:24.820148	0	\N
58	경기도 파주시 와동동 1376	2026-01-29 23:28:24.821069	37.72713251	126.7584582	OFFICIAL	2026-01-29 23:28:24.821088	0	\N
59	경기도 파주시 와동동 1369-1	2026-01-29 23:28:24.82208	37.72392455	126.7545938	OFFICIAL	2026-01-29 23:28:24.822099	0	\N
60	경기도 파주시 와동동 1370	2026-01-29 23:28:24.823098	37.72502177	126.7561433	OFFICIAL	2026-01-29 23:28:24.823117	0	\N
61	경기도 파주시 동패동 1792	2026-01-29 23:28:24.824222	37.71706943	126.7377643	OFFICIAL	2026-01-29 23:28:24.824242	0	\N
62	경기도 파주시 동패동 1833	2026-01-29 23:28:24.825386	37.71586004	126.7383055	OFFICIAL	2026-01-29 23:28:24.825405	0	\N
63	경기도 파주시 동패동 1792	2026-01-29 23:28:24.82652	37.71706943	126.7377643	OFFICIAL	2026-01-29 23:28:24.826539	0	\N
64	경기도 파주시 와석순환로 415 경기도 파주시 와동동 1358	2026-01-29 23:28:24.828301	37.72402922	126.7513065	OFFICIAL	2026-01-29 23:28:24.828363	0	\N
65	경기도 파주시 와석순환로 415 경기도 파주시 와동동 1358	2026-01-29 23:28:24.830098	37.72402922	126.7513065	OFFICIAL	2026-01-29 23:28:24.830119	0	\N
66	경기도 파주시 와동동 1364	2026-01-29 23:28:24.831093	37.72635513	126.7516634	OFFICIAL	2026-01-29 23:28:24.831111	0	\N
67	경기도 파주시 미래로 564 경기도 파주시 와동동 1344	2026-01-29 23:28:24.83206	37.72766106	126.7531214	OFFICIAL	2026-01-29 23:28:24.832078	0	\N
68	경기도 파주시 미래로 610 경기도 파주시 와동동 1303-1	2026-01-29 23:28:24.833151	37.73165607	126.7514599	OFFICIAL	2026-01-29 23:28:24.833189	0	\N
69	경기도 파주시 가람로 22 경기도 파주시 와동동 1308	2026-01-29 23:28:24.834146	37.73292356	126.7533502	OFFICIAL	2026-01-29 23:28:24.834177	0	\N
70	경기도 파주시 가람로 70 경기도 파주시 와동동 1321	2026-01-29 23:28:24.835091	37.73465466	126.7583889	OFFICIAL	2026-01-29 23:28:24.835138	0	\N
71	경기도 파주시 가람로 59 경기도 파주시 와동동 1553-1	2026-01-29 23:28:24.835986	37.73476235	126.7565601	OFFICIAL	2026-01-29 23:28:24.836022	0	\N
72	경기도 파주시 동패동 2148	2026-01-29 23:28:24.836891	37.71602862	126.7144667	OFFICIAL	2026-01-29 23:28:24.836908	0	\N
73	경기도 파주시 동패동 2154	2026-01-29 23:28:24.837896	37.7135641	126.7078536	OFFICIAL	2026-01-29 23:28:24.837913	0	\N
74	경기도 파주시 동패동 2154	2026-01-29 23:28:24.838856	37.7135641	126.7078536	OFFICIAL	2026-01-29 23:28:24.838875	0	\N
75	경기도 파주시 문발동 541-3	2026-01-29 23:28:24.839725	37.71586589	126.6911528	OFFICIAL	2026-01-29 23:28:24.83974	0	\N
76	경기도 파주시 문발동 541-3	2026-01-29 23:28:24.840677	37.71586589	126.6911528	OFFICIAL	2026-01-29 23:28:24.840694	0	\N
77	경기도 파주시 문발동 541-12	2026-01-29 23:28:24.841578	37.70170543	126.686117	OFFICIAL	2026-01-29 23:28:24.841594	0	\N
78	경기도 파주시 문발동 541-12	2026-01-29 23:28:24.842468	37.70170543	126.686117	OFFICIAL	2026-01-29 23:28:24.842484	0	\N
79	경기도 파주시 문발동 541-2	2026-01-29 23:28:24.84334	37.7138612	126.6873952	OFFICIAL	2026-01-29 23:28:24.843356	0	\N
80	경기도 파주시 문발로 233 경기도 파주시 문발동 502-1	2026-01-29 23:28:24.844252	37.71516574	126.6875146	OFFICIAL	2026-01-29 23:28:24.844268	0	\N
81	경기도 파주시 문발동 541-2	2026-01-29 23:28:24.845285	37.7138612	126.6873952	OFFICIAL	2026-01-29 23:28:24.845301	0	\N
82	경기도 파주시 문발동 541-2	2026-01-29 23:28:24.84615	37.7138612	126.6873952	OFFICIAL	2026-01-29 23:28:24.846166	0	\N
83	경기도 파주시 문발동 541-2	2026-01-29 23:28:24.847021	37.7138612	126.6873952	OFFICIAL	2026-01-29 23:28:24.847037	0	\N
84	경기도 파주시 문발동 541-2	2026-01-29 23:28:24.847914	37.7138612	126.6873952	OFFICIAL	2026-01-29 23:28:24.84793	0	\N
85	경기도 파주시 서패동 305-1	2026-01-29 23:28:24.84893	37.71671563	126.6957951	OFFICIAL	2026-01-29 23:28:24.848947	0	\N
86	경기도 파주시 신촌동 산 55-3	2026-01-29 23:28:24.849934	37.73072362	126.7083059	OFFICIAL	2026-01-29 23:28:24.849951	0	\N
87	경기도 파주시 신촌동 703	2026-01-29 23:28:24.850858	37.73051673	126.7082899	OFFICIAL	2026-01-29 23:28:24.850875	0	\N
88	경기도 파주시 문발동 32-1	2026-01-29 23:28:24.851716	37.72867906	126.7064347	OFFICIAL	2026-01-29 23:28:24.85173	0	\N
89	경기도 파주시 문발동 621	2026-01-29 23:28:24.852586	37.72722975	126.7089423	OFFICIAL	2026-01-29 23:28:24.8526	0	\N
90	경기도 파주시 문발동 621	2026-01-29 23:28:24.853441	37.72722975	126.7089423	OFFICIAL	2026-01-29 23:28:24.853455	0	\N
91	경기도 파주시 문발동 621	2026-01-29 23:28:24.854281	37.72722975	126.7089423	OFFICIAL	2026-01-29 23:28:24.854296	0	\N
92	경기도 파주시 동패동 1745-8	2026-01-29 23:28:24.855148	37.72353613	126.7227707	OFFICIAL	2026-01-29 23:28:24.855163	0	\N
93	경기도 파주시 동패동 1745-2	2026-01-29 23:28:24.856055	37.72181355	126.7173793	OFFICIAL	2026-01-29 23:28:24.856118	0	\N
94	경기도 파주시 동패동 1711-1	2026-01-29 23:28:24.857053	37.71991202	126.7190772	OFFICIAL	2026-01-29 23:28:24.857077	0	\N
95	경기도 파주시 동패동 1745-2	2026-01-29 23:28:24.857949	37.72181355	126.7173793	OFFICIAL	2026-01-29 23:28:24.857963	0	\N
96	경기도 파주시 동패동 1704-1	2026-01-29 23:28:24.858939	37.72213757	126.7175437	OFFICIAL	2026-01-29 23:28:24.858954	0	\N
97	경기도 파주시 동패동 1745-7	2026-01-29 23:28:24.85974	37.72433601	126.7201435	OFFICIAL	2026-01-29 23:28:24.859788	0	\N
98	경기도 파주시 동패동 1745-7	2026-01-29 23:28:24.860852	37.72433601	126.7201435	OFFICIAL	2026-01-29 23:28:24.860868	0	\N
99	경기도 파주시 책향기로 423 경기도 파주시 동패동 1701	2026-01-29 23:28:24.861671	37.72492304	126.7189297	OFFICIAL	2026-01-29 23:28:24.861711	0	\N
100	경기도 파주시 동패동 1745-2	2026-01-29 23:28:24.863064	37.72181355	126.7173793	OFFICIAL	2026-01-29 23:28:24.863111	0	\N
101	경기도 파주시 동패동 1745-2	2026-01-29 23:28:24.864	37.72181355	126.7173793	OFFICIAL	2026-01-29 23:28:24.864014	0	\N
102	경기도 파주시 다율동 1003	2026-01-29 23:28:24.864884	37.73204777	126.7191699	OFFICIAL	2026-01-29 23:28:24.864899	0	\N
103	경기도 파주시 다율동 1003	2026-01-29 23:28:24.865721	37.73204777	126.7191699	OFFICIAL	2026-01-29 23:28:24.865735	0	\N
104	경기도 파주시 다율동 982-1	2026-01-29 23:28:24.866548	37.7331968	126.7196748	OFFICIAL	2026-01-29 23:28:24.866562	0	\N
105	경기도 파주시 교하동 372-1	2026-01-29 23:28:24.867472	37.75200818	126.750513	OFFICIAL	2026-01-29 23:28:24.867486	0	\N
106	경기도 파주시 교하동 372-1	2026-01-29 23:28:24.868311	37.75200818	126.750513	OFFICIAL	2026-01-29 23:28:24.868325	0	\N
107	경기도 파주시 당하동 151-1	2026-01-29 23:28:24.869192	37.746312	126.7518564	OFFICIAL	2026-01-29 23:28:24.869206	0	\N
108	경기도 파주시 천정구로 128 경기도 파주시 당하동 306	2026-01-29 23:28:24.870179	37.74691669	126.7520788	OFFICIAL	2026-01-29 23:28:24.870194	0	\N
109	경기도 파주시 검산동 297-2	2026-01-29 23:28:24.871151	37.77478772	126.7400962	OFFICIAL	2026-01-29 23:28:24.871165	0	\N
110	경기도 파주시 맥금동 1140-1	2026-01-29 23:28:24.871996	37.76975169	126.7366968	OFFICIAL	2026-01-29 23:28:24.872009	0	\N
111	경기도 파주시 맥금동 1078-4	2026-01-29 23:28:24.872959	37.77237264	126.7348273	OFFICIAL	2026-01-29 23:28:24.872972	0	\N
112	경기도 파주시 장터고개길 10 경기도 파주시 맥금동 110-9	2026-01-29 23:28:24.873926	37.77298229	126.7337334	OFFICIAL	2026-01-29 23:28:24.87394	0	\N
113	경기도 파주시 검산동 824	2026-01-29 23:28:24.874831	37.77216198	126.7446852	OFFICIAL	2026-01-29 23:28:24.874845	0	\N
114	경기도 파주시 평화로 352 경기도 파주시 검산동 276-13	2026-01-29 23:28:24.875801	37.7732299	126.7437819	OFFICIAL	2026-01-29 23:28:24.875815	0	\N
115	경기도 파주시 평화로 307 경기도 파주시 검산동 868	2026-01-29 23:28:24.876807	37.77195119	126.7482251	OFFICIAL	2026-01-29 23:28:24.876821	0	\N
116	경기도 파주시 검산동 137-3	2026-01-29 23:28:24.877718	37.77226693	126.7470001	OFFICIAL	2026-01-29 23:28:24.877732	0	\N
117	경기도 파주시 야동동 692	2026-01-29 23:28:24.878638	37.77259232	126.7511982	OFFICIAL	2026-01-29 23:28:24.878653	0	\N
118	경기도 파주시 평화로 278 경기도 파주시 야동동 589-12	2026-01-29 23:28:24.879536	37.77318377	126.7515676	OFFICIAL	2026-01-29 23:28:24.87955	0	\N
119	경기도 파주시 야동동 910	2026-01-29 23:28:24.88046	37.77041489	126.7609747	OFFICIAL	2026-01-29 23:28:24.880475	0	\N
120	경기도 파주시 평화로 190 경기도 파주시 야동동 361	2026-01-29 23:28:24.881311	37.77260399	126.7628873	OFFICIAL	2026-01-29 23:28:24.881326	0	\N
121	경기도 파주시 금촌동 419-1	2026-01-29 23:28:24.882217	37.77098332	126.771488	OFFICIAL	2026-01-29 23:28:24.882231	0	\N
122	경기도 파주시 시청로 244 경기도 파주시 금촌동 423-5	2026-01-29 23:28:24.883131	37.7713412	126.7718827	OFFICIAL	2026-01-29 23:28:24.883145	0	\N
123	경기도 파주시 송화로 13 경기도 파주시 아동동 283	2026-01-29 23:28:24.88398	37.77166848	126.7750484	OFFICIAL	2026-01-29 23:28:24.883994	0	\N
124	경기도 파주시 정담길 90 경기도 파주시 금촌동 11-7	2026-01-29 23:28:24.88478	37.77097862	126.7742951	OFFICIAL	2026-01-29 23:28:24.884796	0	\N
125	경기도 파주시 정담길 40 경기도 파주시 아동동 275-13	2026-01-29 23:28:24.885655	37.76987067	126.7777367	OFFICIAL	2026-01-29 23:28:24.885669	0	\N
126	경기도 파주시 시청로 190 경기도 파주시 아동동 275-6	2026-01-29 23:28:24.886503	37.77069465	126.778001	OFFICIAL	2026-01-29 23:28:24.886516	0	\N
127	경기도 파주시 새꽃로 1 경기도 파주시 금촌동 1023	2026-01-29 23:28:24.887436	37.75023227	126.7681602	OFFICIAL	2026-01-29 23:28:24.88745	0	\N
128	경기도 파주시 쇠재로 123 경기도 파주시 금촌동 1007	2026-01-29 23:28:24.890159	37.75259449	126.7767807	OFFICIAL	2026-01-29 23:28:24.890318	0	\N
129	경기도 파주시 가나무로 130 경기도 파주시 금릉동 428	2026-01-29 23:28:24.892003	37.7538401	126.7798134	OFFICIAL	2026-01-29 23:28:24.892018	0	\N
130	경기도 파주시 쇠재로 133 경기도 파주시 금촌동 1003	2026-01-29 23:28:24.892903	37.75326607	126.7769711	OFFICIAL	2026-01-29 23:28:24.892918	0	\N
131	경기도 파주시 후곡로 50 경기도 파주시 금촌동 992	2026-01-29 23:28:24.893726	37.7532251	126.769121	OFFICIAL	2026-01-29 23:28:24.893741	0	\N
132	경기도 파주시 새꽃로 35 경기도 파주시 금촌동 984	2026-01-29 23:28:24.894683	37.75382255	126.7679869	OFFICIAL	2026-01-29 23:28:24.894698	0	\N
133	경기도 파주시 새꽃로 55 경기도 파주시 금촌동 974	2026-01-29 23:28:24.895468	37.75504144	126.767654	OFFICIAL	2026-01-29 23:28:24.895482	0	\N
134	경기도 파주시 후곡로 80 경기도 파주시 금촌동 997	2026-01-29 23:28:24.896337	37.75043566	126.7729952	OFFICIAL	2026-01-29 23:28:24.896351	0	\N
135	경기도 파주시 후곡로 50 경기도 파주시 금촌동 992	2026-01-29 23:28:24.897149	37.7532251	126.769121	OFFICIAL	2026-01-29 23:28:24.897163	0	\N
136	경기도 파주시 후곡로 2 경기도 파주시 금촌동 958-10	2026-01-29 23:28:24.897997	37.75740458	126.7731555	OFFICIAL	2026-01-29 23:28:24.898011	0	\N
137	경기도 파주시 번영로 15 경기도 파주시 금촌동 959-2	2026-01-29 23:28:24.898891	37.75756997	126.771369	OFFICIAL	2026-01-29 23:28:24.898906	0	\N
138	경기도 파주시 번영로 55 경기도 파주시 금촌동 972	2026-01-29 23:28:24.899705	37.75741591	126.7660484	OFFICIAL	2026-01-29 23:28:24.899719	0	\N
139	경기도 파주시 금촌동 978-13	2026-01-29 23:28:24.900511	37.75240553	126.7654264	OFFICIAL	2026-01-29 23:28:24.900525	0	\N
140	경기도 파주시 금빛로 24-17 경기도 파주시 금촌동 988-4	2026-01-29 23:28:24.901363	37.75198848	126.767633	OFFICIAL	2026-01-29 23:28:24.901399	0	\N
141	경기도 파주시 금빛로 24-28 경기도 파주시 금촌동 989-6	2026-01-29 23:28:24.902206	37.75165485	126.7682735	OFFICIAL	2026-01-29 23:28:24.902225	0	\N
142	경기도 파주시 금빛로 24-22 경기도 파주시 금촌동 989-5	2026-01-29 23:28:24.903013	37.75165206	126.7679103	OFFICIAL	2026-01-29 23:28:24.903027	0	\N
143	경기도 파주시 금빛로 24-17 경기도 파주시 금촌동 988-4	2026-01-29 23:28:24.903835	37.75198848	126.767633	OFFICIAL	2026-01-29 23:28:24.903849	0	\N
144	경기도 파주시 금빛로 24-10 경기도 파주시 금촌동 989-2	2026-01-29 23:28:24.904664	37.75165559	126.7672766	OFFICIAL	2026-01-29 23:28:24.904678	0	\N
145	경기도 파주시 금빛로 24 경기도 파주시 금촌동 988-1	2026-01-29 23:28:24.90555	37.75198853	126.7668832	OFFICIAL	2026-01-29 23:28:24.905566	0	\N
146	경기도 파주시 중앙로 193 경기도 파주시 금릉동 211-11	2026-01-29 23:28:24.906406	37.75449299	126.7819724	OFFICIAL	2026-01-29 23:28:24.90642	0	\N
147	경기도 파주시 중앙로 194 경기도 파주시 금릉동 216-21	2026-01-29 23:28:24.907262	37.75489984	126.7824175	OFFICIAL	2026-01-29 23:28:24.907276	0	\N
148	경기도 파주시 중앙로 160 경기도 파주시 금릉동 186-5	2026-01-29 23:28:24.908119	37.75612433	126.786478	OFFICIAL	2026-01-29 23:28:24.908133	0	\N
149	경기도 파주시 아동동 51-10	2026-01-29 23:28:24.908972	37.75968332	126.7956703	OFFICIAL	2026-01-29 23:28:24.909017	0	\N
150	경기도 파주시 통일로 541 경기도 파주시 아동동 45-7	2026-01-29 23:28:24.909795	37.75840583	126.7957202	OFFICIAL	2026-01-29 23:28:24.909839	0	\N
151	경기도 파주시 후곡로 19 경기도 파주시 금촌동 953-5	2026-01-29 23:28:24.910624	37.75574508	126.7739012	OFFICIAL	2026-01-29 23:28:24.910666	0	\N
152	경기도 파주시 가나무로 101 경기도 파주시 금촌동 123-30	2026-01-29 23:28:24.911493	37.75432256	126.7765047	OFFICIAL	2026-01-29 23:28:24.911505	0	\N
153	경기도 파주시 시청로 21 경기도 파주시 금촌동 765-21	2026-01-29 23:28:24.912429	37.75893833	126.7759047	OFFICIAL	2026-01-29 23:28:24.91244	0	\N
154	경기도 파주시 시청로 2 경기도 파주시 금촌동 948-1	2026-01-29 23:28:24.913395	37.75784489	126.7742406	OFFICIAL	2026-01-29 23:28:24.913406	0	\N
155	경기도 파주시 후곡로 1 경기도 파주시 금촌동 952-1	2026-01-29 23:28:24.915486	37.75740254	126.7740148	OFFICIAL	2026-01-29 23:28:24.915498	0	\N
156	경기도 파주시 번영로 56 경기도 파주시 금촌동 967-3	2026-01-29 23:28:24.916265	37.75791486	126.7669098	OFFICIAL	2026-01-29 23:28:24.916276	0	\N
157	경기도 파주시 번영로 4 경기도 파주시 금촌동 945-11	2026-01-29 23:28:24.917052	37.75789734	126.7726538	OFFICIAL	2026-01-29 23:28:24.917063	0	\N
158	경기도 파주시 평화로 3-1 경기도 파주시 금촌동 945-6	2026-01-29 23:28:24.917877	37.75838584	126.7729811	OFFICIAL	2026-01-29 23:28:24.917888	0	\N
159	경기도 파주시 평화로 6 경기도 파주시 금촌동 946-19	2026-01-29 23:28:24.918592	37.75856794	126.7732647	OFFICIAL	2026-01-29 23:28:24.91861	0	\N
160	경기도 파주시 평화로 2 경기도 파주시 금촌동 946-17	2026-01-29 23:28:24.919448	37.75827499	126.773524	OFFICIAL	2026-01-29 23:28:24.919458	0	\N
161	경기도 파주시 문화로 103 경기도 파주시 금촌동 62-1	2026-01-29 23:28:24.920524	37.76331085	126.7744701	OFFICIAL	2026-01-29 23:28:24.920536	0	\N
162	경기도 파주시 새꽃로 193 경기도 파주시 금촌동 329-251	2026-01-29 23:28:24.921308	37.76608619	126.7750857	OFFICIAL	2026-01-29 23:28:24.921319	0	\N
163	경기도 파주시 새꽃로 193 경기도 파주시 금촌동 329-251	2026-01-29 23:28:24.922142	37.76608619	126.7750857	OFFICIAL	2026-01-29 23:28:24.922153	0	\N
164	경기도 파주시 새꽃로 204 경기도 파주시 금촌동 329-223	2026-01-29 23:28:24.923102	37.76546747	126.7751657	OFFICIAL	2026-01-29 23:28:24.923113	0	\N
165	경기도 파주시 새꽃로 205 경기도 파주시 아동동 351-15	2026-01-29 23:28:24.924001	37.76586674	126.7752438	OFFICIAL	2026-01-29 23:28:24.924012	0	\N
166	경기도 파주시 새꽃로 204 경기도 파주시 금촌동 329-223	2026-01-29 23:28:24.92479	37.76546747	126.7751657	OFFICIAL	2026-01-29 23:28:24.924801	0	\N
167	경기도 파주시 월롱면 능산리 236-1	2026-01-29 23:28:24.925572	37.82603186	126.7715271	OFFICIAL	2026-01-29 23:28:24.925583	0	\N
168	경기도 파주시 월롱면 능산리 256-10	2026-01-29 23:28:24.9264	37.82616767	126.772548	OFFICIAL	2026-01-29 23:28:24.926411	0	\N
169	경기도 파주시 월롱면 능산리 665	2026-01-29 23:28:24.92725	37.83326284	126.7784847	OFFICIAL	2026-01-29 23:28:24.927259	0	\N
170	경기도 파주시 월롱면 휴암로 477 경기도 파주시 월롱면 능산리 658	2026-01-29 23:28:24.928179	37.83430163	126.7775546	OFFICIAL	2026-01-29 23:28:24.92819	0	\N
171	경기도 파주시 월롱면 덕은리 957-4	2026-01-29 23:28:24.929313	37.81520761	126.7618768	OFFICIAL	2026-01-29 23:28:24.929326	0	\N
172	경기도 파주시 월롱면 덕은리 833-2	2026-01-29 23:28:24.930348	37.81559292	126.7619825	OFFICIAL	2026-01-29 23:28:24.93036	0	\N
173	경기도 파주시 월롱면 덕은리 1005	2026-01-29 23:28:24.931154	37.81239617	126.7672721	OFFICIAL	2026-01-29 23:28:24.931165	0	\N
174	경기도 파주시 월롱면 덕은리 938-49	2026-01-29 23:28:24.932026	37.81288656	126.7667669	OFFICIAL	2026-01-29 23:28:24.932037	0	\N
175	경기도 파주시 월롱면 덕은리 1277	2026-01-29 23:28:24.93288	37.81227091	126.7751194	OFFICIAL	2026-01-29 23:28:24.932892	0	\N
176	경기도 파주시 월롱면 덕은리 523-2	2026-01-29 23:28:24.933665	37.81275397	126.7744436	OFFICIAL	2026-01-29 23:28:24.933675	0	\N
177	경기도 파주시 월롱면 엘지로 164 경기도 파주시 월롱면 덕은리 1060	2026-01-29 23:28:24.934503	37.81076895	126.7811147	OFFICIAL	2026-01-29 23:28:24.934514	0	\N
178	경기도 파주시 월롱면 덕은리 463-1	2026-01-29 23:28:24.935273	37.80999514	126.7812599	OFFICIAL	2026-01-29 23:28:24.935283	0	\N
179	경기도 파주시 월롱면 휴암로 4 경기도 파주시 월롱면 위전리 427-13	2026-01-29 23:28:24.936057	37.79594398	126.7912003	OFFICIAL	2026-01-29 23:28:24.936067	0	\N
180	경기도 파주시 월롱면 위전리 425-1	2026-01-29 23:28:24.936851	37.79645096	126.7915788	OFFICIAL	2026-01-29 23:28:24.936861	0	\N
181	경기도 파주시 월롱면 통일로 980 경기도 파주시 월롱면 위전리 168-3	2026-01-29 23:28:24.937668	37.79614315	126.7922047	OFFICIAL	2026-01-29 23:28:24.937711	0	\N
182	경기도 파주시 월롱면 통일로 980 경기도 파주시 월롱면 위전리 168-3	2026-01-29 23:28:24.93853	37.79614315	126.7922047	OFFICIAL	2026-01-29 23:28:24.93856	0	\N
183	경기도 파주시 월롱면 영태리 572-6	2026-01-29 23:28:24.939425	37.77623936	126.7886051	OFFICIAL	2026-01-29 23:28:24.939435	0	\N
184	경기도 파주시 월롱면 영태리 579-12	2026-01-29 23:28:24.940251	37.77774471	126.7887711	OFFICIAL	2026-01-29 23:28:24.940262	0	\N
185	경기도 파주시 월롱면 통일로 824 경기도 파주시 월롱면 영태리 612-17	2026-01-29 23:28:24.941108	37.78268931	126.7885168	OFFICIAL	2026-01-29 23:28:24.941118	0	\N
186	경기도 파주시 월롱면 통일로 824 경기도 파주시 월롱면 영태리 612-17	2026-01-29 23:28:24.941992	37.78268931	126.7885168	OFFICIAL	2026-01-29 23:28:24.942004	0	\N
187	경기도 파주시 월롱면 영태리 513-1	2026-01-29 23:28:24.942854	37.77378606	126.7884552	OFFICIAL	2026-01-29 23:28:24.942864	0	\N
188	경기도 파주시 탄현면 약산로 76 경기도 파주시 탄현면 법흥리 1581-1	2026-01-29 23:28:24.94364	37.77111216	126.7051236	OFFICIAL	2026-01-29 23:28:24.943652	0	\N
189	경기도 파주시 탄현면 법흥리 1664	2026-01-29 23:28:24.944478	37.78574641	126.6997465	OFFICIAL	2026-01-29 23:28:24.944488	0	\N
190	경기도 파주시 탄현면 여치길 81 경기도 파주시 탄현면 법흥리 1566	2026-01-29 23:28:24.945249	37.77045463	126.7025397	OFFICIAL	2026-01-29 23:28:24.945267	0	\N
191	경기도 파주시 탄현면 법흥리 747-9	2026-01-29 23:28:24.946031	37.78890418	126.6936048	OFFICIAL	2026-01-29 23:28:24.946041	0	\N
192	경기도 파주시 탄현면 헤이리마을길 55-61 경기도 파주시 탄현면 법흥리 1652-164	2026-01-29 23:28:24.946827	37.7887567	126.6942883	OFFICIAL	2026-01-29 23:28:24.946854	0	\N
193	경기도 파주시 탄현면 새오리로 542 경기도 파주시 탄현면 금산리 208-2	2026-01-29 23:28:24.947616	37.8120444	126.7080859	OFFICIAL	2026-01-29 23:28:24.947626	0	\N
194	경기도 파주시 광탄면 혜음로 1121-1 경기도 파주시 광탄면 신산리 371-24	2026-01-29 23:28:24.948524	37.78150414	126.8473902	OFFICIAL	2026-01-29 23:28:24.948549	0	\N
195	경기도 파주시 광탄면 혜음로 1121-1 경기도 파주시 광탄면 신산리 371-24	2026-01-29 23:28:24.949527	37.78150414	126.8473902	OFFICIAL	2026-01-29 23:28:24.949537	0	\N
196	경기도 파주시 광탄면 등원로 527 경기도 파주시 광탄면 신산리 366-1	2026-01-29 23:28:24.950414	37.78335959	126.8449088	OFFICIAL	2026-01-29 23:28:24.950423	0	\N
197	경기도 파주시 파평면 금파리 296-9	2026-01-29 23:28:24.951274	37.92169557	126.8392175	OFFICIAL	2026-01-29 23:28:24.951284	0	\N
198	경기도 파주시 파평면 장마루로 263 경기도 파주시 파평면 장파리 370-118	2026-01-29 23:28:24.952091	37.94525328	126.8374999	OFFICIAL	2026-01-29 23:28:24.952101	0	\N
199	경기도 파주시 파평면 장마루로 225 경기도 파주시 파평면 장파리 370-21	2026-01-29 23:28:24.95293	37.94203677	126.8368652	OFFICIAL	2026-01-29 23:28:24.952941	0	\N
200	경기도 파주시 파평면 청송로 415 경기도 파주시 파평면 눌노리 231-13	2026-01-29 23:28:24.953732	37.93067136	126.8589747	OFFICIAL	2026-01-29 23:28:24.953742	0	\N
201	경기도 파주시 파평면 청송로652번길 14 경기도 파주시 파평면 덕천리 126-19	2026-01-29 23:28:24.954521	37.942166	126.8800281	OFFICIAL	2026-01-29 23:28:24.95453	0	\N
202	경기도 파주시 적성면 청송로 701 경기도 파주시 적성면 식현리 284	2026-01-29 23:28:24.955311	37.94557773	126.8855095	OFFICIAL	2026-01-29 23:28:24.95532	0	\N
203	경기도 파주시 적성면 청송로 1003 경기도 파주시 적성면 마지리 48-2	2026-01-29 23:28:24.956132	37.95340587	126.9169532	OFFICIAL	2026-01-29 23:28:24.956141	0	\N
204	경기도 파주시 적성면 마지리 39-49	2026-01-29 23:28:24.956866	37.95686246	126.9160336	OFFICIAL	2026-01-29 23:28:24.956876	0	\N
205	경기도 파주시 법원읍 술이홀로 1722 경기도 파주시 법원읍 웅담리 388-2	2026-01-29 23:28:24.957677	37.91471347	126.8955351	OFFICIAL	2026-01-29 23:28:24.957687	0	\N
206	경기도 파주시 법원읍 금곡리 336-4	2026-01-29 23:28:24.958455	37.88532474	126.8778106	OFFICIAL	2026-01-29 23:28:24.958464	0	\N
207	경기도 파주시 법원읍 가야리 86-3	2026-01-29 23:28:24.959234	37.84968924	126.8633434	OFFICIAL	2026-01-29 23:28:24.959244	0	\N
208	경기도 파주시 법원읍 사임당로 881 경기도 파주시 법원읍 법원리 444-7	2026-01-29 23:28:24.960031	37.84844706	126.8787791	OFFICIAL	2026-01-29 23:28:24.960041	0	\N
209	경기도 파주시 법원읍 사임당로 895 경기도 파주시 법원읍 법원리 447-28	2026-01-29 23:28:24.96078	37.8481883	126.8804482	OFFICIAL	2026-01-29 23:28:24.96079	0	\N
210	경기도 파주시 법원읍 술이홀로 869 경기도 파주시 법원읍 대능리 94-105	2026-01-29 23:28:24.961529	37.84907513	126.8724766	OFFICIAL	2026-01-29 23:28:24.961538	0	\N
211	경기도 파주시 법원읍 사임당로 845 경기도 파주시 법원읍 대능리 87-6	2026-01-29 23:28:24.962347	37.84919233	126.8748211	OFFICIAL	2026-01-29 23:28:24.962356	0	\N
212	경기도 파주시 법원읍 사임당로 846 경기도 파주시 법원읍 대능리 84-1	2026-01-29 23:28:24.963151	37.84864911	126.8745313	OFFICIAL	2026-01-29 23:28:24.96316	0	\N
213	경기도 파주시 조리읍 봉일천리 229-2	2026-01-29 23:28:24.963952	37.74492281	126.8084016	OFFICIAL	2026-01-29 23:28:24.963961	0	\N
214	경기도 파주시 조리읍 봉천로 28 경기도 파주시 조리읍 봉일천리 210-16	2026-01-29 23:28:24.964745	37.74364707	126.8087516	OFFICIAL	2026-01-29 23:28:24.964785	0	\N
215	경기도 파주시 조리읍 두루봉로 27 경기도 파주시 조리읍 봉일천리 237-3	2026-01-29 23:28:24.965506	37.74654276	126.8108062	OFFICIAL	2026-01-29 23:28:24.965515	0	\N
216	경기도 파주시 조리읍 봉일천리 39-5	2026-01-29 23:28:24.966206	37.73815631	126.8207799	OFFICIAL	2026-01-29 23:28:24.966215	0	\N
217	경기도 파주시 조리읍 봉일천리 26-54	2026-01-29 23:28:24.966924	37.73706699	126.8233395	OFFICIAL	2026-01-29 23:28:24.966933	0	\N
218	경기도 파주시 조리읍 장곡리 765-1	2026-01-29 23:28:24.967704	37.72896107	126.8390474	OFFICIAL	2026-01-29 23:28:24.967714	0	\N
219	경기도 파주시 조리읍 명봉산로 68 경기도 파주시 조리읍 장곡리 656-1	2026-01-29 23:28:24.968459	37.73398069	126.842373	OFFICIAL	2026-01-29 23:28:24.968469	0	\N
220	경기도 파주시 조리읍 장곡리 598-236	2026-01-29 23:28:24.969171	37.73761328	126.8450458	OFFICIAL	2026-01-29 23:28:24.96918	0	\N
221	경기도 파주시 조리읍 장곡리 765-1	2026-01-29 23:28:24.969925	37.72896107	126.8390474	OFFICIAL	2026-01-29 23:28:24.969935	0	\N
222	경기도 파주시 조리읍 통일로 43 경기도 파주시 조리읍 장곡리 463-2	2026-01-29 23:28:24.970648	37.73115763	126.8354089	OFFICIAL	2026-01-29 23:28:24.970657	0	\N
223	경기도 파주시 조리읍 통일로 155 경기도 파주시 조리읍 봉일천리 13-15	2026-01-29 23:28:24.971408	37.73635799	126.8247639	OFFICIAL	2026-01-29 23:28:24.971417	0	\N
224	경기도 파주시 조리읍 봉일천리 26-54	2026-01-29 23:28:24.972159	37.73706699	126.8233395	OFFICIAL	2026-01-29 23:28:24.972169	0	\N
225	경기도 파주시 조리읍 봉일천리 125-2	2026-01-29 23:28:24.973026	37.74263952	126.8105131	OFFICIAL	2026-01-29 23:28:24.973065	0	\N
226	경기도 파주시 조리읍 고봉로 1028 경기도 파주시 조리읍 봉일천리 142-23	2026-01-29 23:28:24.973792	37.74273625	126.8078444	OFFICIAL	2026-01-29 23:28:24.973802	0	\N
227	경기도 파주시 조리읍 고봉로 1029 경기도 파주시 조리읍 봉일천리 154-4	2026-01-29 23:28:24.974507	37.74306766	126.8075355	OFFICIAL	2026-01-29 23:28:24.974517	0	\N
228	경기도 파주시 조리읍 봉천로 43 경기도 파주시 조리읍 봉일천리 168-13	2026-01-29 23:28:24.97546	37.74357358	126.8069427	OFFICIAL	2026-01-29 23:28:24.975476	0	\N
229	경기도 파주시 조리읍 봉천로 38-11 경기도 파주시 조리읍 봉일천리 204-11	2026-01-29 23:28:24.976305	37.74392069	126.8069248	OFFICIAL	2026-01-29 23:28:24.976315	0	\N
230	경기도 파주시 조리읍 봉일천리 187-23	2026-01-29 23:28:24.977116	37.74486117	126.8045334	OFFICIAL	2026-01-29 23:28:24.977126	0	\N
231	경기도 파주시 조리읍 대원리 963-5	2026-01-29 23:28:24.9779	37.74009021	126.8064822	OFFICIAL	2026-01-29 23:28:24.97791	0	\N
232	경기도 파주시 조리읍 대원리 227-4	2026-01-29 23:28:24.97865	37.72843972	126.8134568	OFFICIAL	2026-01-29 23:28:24.978659	0	\N
233	경기도 파주시 조리읍 대원로 56 경기도 파주시 조리읍 대원리 218	2026-01-29 23:28:24.979396	37.72808793	126.8155688	OFFICIAL	2026-01-29 23:28:24.979406	0	\N
234	경기도 파주시 조리읍 대원리 198-4	2026-01-29 23:28:24.98014	37.72718203	126.8175882	OFFICIAL	2026-01-29 23:28:24.980149	0	\N
235	경기도 파주시 조리읍 대원로 45 경기도 파주시 조리읍 대원리 272	2026-01-29 23:28:24.981044	37.72708817	126.8171588	OFFICIAL	2026-01-29 23:28:24.981054	0	\N
236	경기도 파주시 조리읍 고봉로 925 경기도 파주시 조리읍 대원리 637-1	2026-01-29 23:28:24.981896	37.73485195	126.802978	OFFICIAL	2026-01-29 23:28:24.981906	0	\N
237	경기도 파주시 조리읍 등원리 275-1	2026-01-29 23:28:24.982622	37.75600139	126.8030243	OFFICIAL	2026-01-29 23:28:24.982632	0	\N
238	경기도 파주시 조리읍 등원리 263-1	2026-01-29 23:28:24.983353	37.75679131	126.8036403	OFFICIAL	2026-01-29 23:28:24.983362	0	\N
239	경기도 파주시 조리읍 등원로 93 경기도 파주시 조리읍 등원리 1-2	2026-01-29 23:28:24.984112	37.76160985	126.8095522	OFFICIAL	2026-01-29 23:28:24.984122	0	\N
240	경기도 파주시 조리읍 등원로 127 경기도 파주시 조리읍 뇌조리 417-2	2026-01-29 23:28:24.984942	37.76399146	126.8120217	OFFICIAL	2026-01-29 23:28:24.984952	0	\N
241	경기도 파주시 조리읍 등원로 199 경기도 파주시 조리읍 뇌조리 457-1	2026-01-29 23:28:24.985722	37.76533187	126.8194822	OFFICIAL	2026-01-29 23:28:24.985732	0	\N
242	경기도 파주시 조리읍 오산리 377-4	2026-01-29 23:28:24.986481	37.76495518	126.8226438	OFFICIAL	2026-01-29 23:28:24.98649	0	\N
243	경기도 파주시 조리읍 오산리 309-7	2026-01-29 23:28:24.987217	37.7688689	126.8254268	OFFICIAL	2026-01-29 23:28:24.987226	0	\N
244	경기도 파주시 조리읍 등원로 273 경기도 파주시 조리읍 오산리 309-1	2026-01-29 23:28:24.988133	37.76890172	126.8251376	OFFICIAL	2026-01-29 23:28:24.988143	0	\N
245	경기도 파주시 조리읍 사근절길 95 경기도 파주시 조리읍 오산리 353	2026-01-29 23:28:24.988894	37.7636475	126.8287113	OFFICIAL	2026-01-29 23:28:24.988904	0	\N
246	경기도 파주시 문산읍 문산로 42 경기도 파주시 문산읍 문산리 10-28	2026-01-29 23:28:24.989628	37.85725458	126.783868	OFFICIAL	2026-01-29 23:28:24.989638	0	\N
247	경기도 파주시 문산읍 당동2로 1 경기도 파주시 문산읍 당동리 888-4	2026-01-29 23:28:24.99042	37.86776721	126.7850443	OFFICIAL	2026-01-29 23:28:24.99043	0	\N
248	경기도 파주시 문산읍 당동리 897	2026-01-29 23:28:24.991327	37.86604827	126.7836137	OFFICIAL	2026-01-29 23:28:24.991337	0	\N
249	경기도 파주시 문산읍 문향로 26 경기도 파주시 문산읍 문산리 17-360	2026-01-29 23:28:24.99215	37.8542204	126.786258	OFFICIAL	2026-01-29 23:28:24.99216	0	\N
250	경기도 파주시 문산읍 문산역로 94 경기도 파주시 문산읍 문산리 17-14	2026-01-29 23:28:24.992921	37.8545887	126.7875954	OFFICIAL	2026-01-29 23:28:24.99293	0	\N
251	경기도 파주시 문산읍 문향로68번길 5 경기도 파주시 문산읍 문산리 9-5	2026-01-29 23:28:24.993721	37.85777951	126.7855624	OFFICIAL	2026-01-29 23:28:24.993731	0	\N
252	경기도 파주시 문산읍 사임당로 113 경기도 파주시 문산읍 선유리 434-3	2026-01-29 23:28:24.994507	37.86523362	126.8041368	OFFICIAL	2026-01-29 23:28:24.994517	0	\N
253	경기도 파주시 문산읍 문향로 75 경기도 파주시 문산읍 문산리 3-5	2026-01-29 23:28:24.995293	37.85858077	126.7854415	OFFICIAL	2026-01-29 23:28:24.995303	0	\N
254	경기도 파주시 문산읍 문산로 43-2 경기도 파주시 문산읍 문산리 8-16	2026-01-29 23:28:24.996123	37.85764869	126.7841803	OFFICIAL	2026-01-29 23:28:24.996133	0	\N
255	경기도 파주시 문산읍 문향로 42 경기도 파주시 문산읍 문산리 13-1	2026-01-29 23:28:24.996922	37.85578022	126.7861632	OFFICIAL	2026-01-29 23:28:24.996933	0	\N
256	경상남도 거창군 신원면 과정리 309-7	2026-01-29 23:28:24.997811	35.57037796	127.9247715	OFFICIAL	2026-01-29 23:28:24.997891	0	\N
257	경상남도 거창군 신원면 과정리 187-13	2026-01-29 23:28:24.99899	35.56772966	127.9255701	OFFICIAL	2026-01-29 23:28:24.999001	0	\N
258	경상남도 거창군 신원면 양지리 307-1	2026-01-29 23:28:24.999839	35.58499648	127.9589552	OFFICIAL	2026-01-29 23:28:24.999866	0	\N
259	경상남도 거창군 고제면 봉계리 548-1	2026-01-29 23:28:25.00059	35.87993465	127.8764909	OFFICIAL	2026-01-29 23:28:25.00061	0	\N
260	경상남도 거창군 위천면 은하리길 2	2026-01-29 23:28:25.001412	35.76092327	127.8336769	OFFICIAL	2026-01-29 23:28:25.001431	0	\N
261	경상남도 거창군 신원면 감악산로 398	2026-01-29 23:28:25.00218	35.60002215	127.9112594	OFFICIAL	2026-01-29 23:28:25.002189	0	\N
262	경상남도 거창군 가조면 가조가야로 1296	2026-01-29 23:28:25.002965	35.7042267	128.0345597	OFFICIAL	2026-01-29 23:28:25.002972	0	\N
263	경상남도 거창군 가조면 의상봉길 65	2026-01-29 23:28:25.003716	35.70908568	128.0191933	OFFICIAL	2026-01-29 23:28:25.003724	0	\N
264	경상남도 거창군 신원면 청용1길 16	2026-01-29 23:28:25.004478	35.57016755	127.9016399	OFFICIAL	2026-01-29 23:28:25.004486	0	\N
265	경상남도 거창군 신원면 오례길 127-5	2026-01-29 23:28:25.005186	35.57025282	127.8912278	OFFICIAL	2026-01-29 23:28:25.005195	0	\N
266	경상남도 거창군 신원면 대현리 345-3	2026-01-29 23:28:25.005906	35.55358357	127.9260712	OFFICIAL	2026-01-29 23:28:25.005914	0	\N
267	경상남도 거창군 신원면 덕산리 1548	2026-01-29 23:28:25.006843	35.60200738	127.9108411	OFFICIAL	2026-01-29 23:28:25.006852	0	\N
268	경상남도 거창군 신원면 구사리 972-1	2026-01-29 23:28:25.007638	35.5765338	127.9496965	OFFICIAL	2026-01-29 23:28:25.007647	0	\N
269	경상남도 거창군 신원면 신차로 3016	2026-01-29 23:28:25.008402	35.56320368	127.9263887	OFFICIAL	2026-01-29 23:28:25.00841	0	\N
270	경상남도 거창군 신원면 과정리 355-1	2026-01-29 23:28:25.009119	35.57185355	127.9212112	OFFICIAL	2026-01-29 23:28:25.009127	0	\N
271	경상남도 거창군 남하면 무릉리 556-1	2026-01-29 23:28:25.009872	35.65121684	127.9538186	OFFICIAL	2026-01-29 23:28:25.00988	0	\N
272	경상남도 거창군 남하면 둔마리 710-2	2026-01-29 23:28:25.01059	35.71480479	127.9656457	OFFICIAL	2026-01-29 23:28:25.010598	0	\N
273	경상남도 거창군 남하면 무릉리 307-2	2026-01-29 23:28:25.011385	35.65782405	127.9581137	OFFICIAL	2026-01-29 23:28:25.011393	0	\N
274	경상남도 거창군 남하면 둔마리 1145-1	2026-01-29 23:28:25.012166	35.70531421	127.951549	OFFICIAL	2026-01-29 23:28:25.012173	0	\N
275	경상남도 거창군 남상면 임불리 602-5	2026-01-29 23:28:25.012912	35.62705364	127.9887798	OFFICIAL	2026-01-29 23:28:25.01292	0	\N
276	경상남도 거창군 남상면 무촌리 1344-38	2026-01-29 23:28:25.013609	35.64092847	127.9068367	OFFICIAL	2026-01-29 23:28:25.013617	0	\N
277	경상남도 거창군 남상면 춘전리 53-4	2026-01-29 23:28:25.014373	35.58675826	127.8560539	OFFICIAL	2026-01-29 23:28:25.014381	0	\N
278	경상남도 거창군 남상면 무촌리 1098	2026-01-29 23:28:25.015148	35.63182684	127.9064172	OFFICIAL	2026-01-29 23:28:25.015156	0	\N
279	경상남도 거창군 남상면 대산리 1270-2	2026-01-29 23:28:25.015882	35.64508894	127.9201178	OFFICIAL	2026-01-29 23:28:25.015889	0	\N
280	경상남도 거창군 남상면 진목1길 20	2026-01-29 23:28:25.016594	35.59493615	127.8702702	OFFICIAL	2026-01-29 23:28:25.016602	0	\N
281	경상남도 거창군 남상면 대산리 412-2	2026-01-29 23:28:25.017378	35.64183675	127.937744	OFFICIAL	2026-01-29 23:28:25.017386	0	\N
282	경상남도 거창군 마리면 영승리 273	2026-01-29 23:28:25.018107	35.70290025	127.8630043	OFFICIAL	2026-01-29 23:28:25.018114	0	\N
283	경상남도 거창군 마리면 대동리 318-1	2026-01-29 23:28:25.018883	35.66954974	127.856815	OFFICIAL	2026-01-29 23:28:25.01889	0	\N
284	경상남도 거창군 위천면 남산리 753-1	2026-01-29 23:28:25.019616	35.73598938	127.8285592	OFFICIAL	2026-01-29 23:28:25.019623	0	\N
285	경상남도 거창군 위천면 남산리 221-1	2026-01-29 23:28:25.020528	35.73864253	127.837724	OFFICIAL	2026-01-29 23:28:25.020536	0	\N
286	경상남도 거창군 위천면 당산리 337-7	2026-01-29 23:28:25.021227	35.74985118	127.8564089	OFFICIAL	2026-01-29 23:28:25.021243	0	\N
287	경상남도 거창군 위천면 모동리 256-2	2026-01-29 23:28:25.02198	35.78380321	127.8639845	OFFICIAL	2026-01-29 23:28:25.021987	0	\N
288	경상남도 거창군 위천면 강천리 160-1	2026-01-29 23:28:25.02274	35.7547564	127.8280998	OFFICIAL	2026-01-29 23:28:25.022778	0	\N
289	경상남도 거창군 북상면 월성리 835-3	2026-01-29 23:28:25.02351	35.75819681	127.7397428	OFFICIAL	2026-01-29 23:28:25.023541	0	\N
290	경상남도 거창군 북상면 월성리 1084-6	2026-01-29 23:28:25.024279	35.76493855	127.7428904	OFFICIAL	2026-01-29 23:28:25.024308	0	\N
291	경상남도 거창군 북상면 병곡리 768-3	2026-01-29 23:28:25.024988	35.810219	127.7748968	OFFICIAL	2026-01-29 23:28:25.025019	0	\N
292	경상남도 거창군 북상면 월성리 1783	2026-01-29 23:28:25.025698	35.77020671	127.7173898	OFFICIAL	2026-01-29 23:28:25.025707	0	\N
293	경상남도 거창군 고제면 봉계리 355-5	2026-01-29 23:28:25.026622	35.87254176	127.8748814	OFFICIAL	2026-01-29 23:28:25.02663	0	\N
294	경상남도 거창군 고제면 봉산리 1427-14	2026-01-29 23:28:25.027304	35.86360664	127.8732422	OFFICIAL	2026-01-29 23:28:25.027312	0	\N
295	경상남도 거창군 고제면 봉계리 678-1	2026-01-29 23:28:25.028171	35.89113997	127.8715298	OFFICIAL	2026-01-29 23:28:25.028179	0	\N
296	경상남도 거창군 고제면 방학길 13-3	2026-01-29 23:28:25.028925	35.83839429	127.8766847	OFFICIAL	2026-01-29 23:28:25.028934	0	\N
297	경상남도 거창군 고제면 농산리 1438-1	2026-01-29 23:28:25.029804	35.81077982	127.8507687	OFFICIAL	2026-01-29 23:28:25.029812	0	\N
298	경상남도 거창군 고제면 개명리 1056	2026-01-29 23:28:25.030512	35.83144897	127.8489465	OFFICIAL	2026-01-29 23:28:25.03052	0	\N
299	경상남도 거창군 고제면 궁항리 1305-2	2026-01-29 23:28:25.031303	35.8260665	127.8734814	OFFICIAL	2026-01-29 23:28:25.031312	0	\N
300	경상남도 거창군 고제면 봉산리 823-2	2026-01-29 23:28:25.032097	35.85212676	127.8774521	OFFICIAL	2026-01-29 23:28:25.032106	0	\N
301	경상남도 거창군 웅양면 노현리 1331	2026-01-29 23:28:25.032868	35.80449367	127.9102938	OFFICIAL	2026-01-29 23:28:25.032876	0	\N
302	경상남도 거창군 웅양면 신촌리 524-1	2026-01-29 23:28:25.033809	35.8763281	127.9108236	OFFICIAL	2026-01-29 23:28:25.033817	0	\N
303	경상남도 거창군 웅양면 산포리 282	2026-01-29 23:28:25.03463	35.81275931	127.9544963	OFFICIAL	2026-01-29 23:28:25.03464	0	\N
304	경상남도 거창군 웅양면 한기리 823-5	2026-01-29 23:28:25.035428	35.88389643	127.9202222	OFFICIAL	2026-01-29 23:28:25.035436	0	\N
305	경상남도 거창군 웅양면 신촌리 1073-2	2026-01-29 23:28:25.036126	35.87128817	127.9064344	OFFICIAL	2026-01-29 23:28:25.036134	0	\N
306	경상남도 거창군 웅양면 신촌리 288-11	2026-01-29 23:28:25.036876	35.86709288	127.9147638	OFFICIAL	2026-01-29 23:28:25.036884	0	\N
307	경상남도 거창군 웅양면 노현리 1096-1	2026-01-29 23:28:25.037591	35.81000858	127.910288	OFFICIAL	2026-01-29 23:28:25.0376	0	\N
308	경상남도 거창군 웅양면 동호리 308-2	2026-01-29 23:28:25.038324	35.79181412	127.9286302	OFFICIAL	2026-01-29 23:28:25.038332	0	\N
309	경상남도 거창군 웅양면 죽림리 921-1	2026-01-29 23:28:25.039081	35.80169382	127.9051093	OFFICIAL	2026-01-29 23:28:25.039089	0	\N
310	경상남도 거창군 웅양면 죽림리 195-5	2026-01-29 23:28:25.039776	35.79525856	127.9127246	OFFICIAL	2026-01-29 23:28:25.039784	0	\N
311	경상남도 거창군 웅양면 한기리 68-8	2026-01-29 23:28:25.040448	35.87344448	127.9283874	OFFICIAL	2026-01-29 23:28:25.040456	0	\N
312	경상남도 거창군 웅양면 한기리 424-7	2026-01-29 23:28:25.041166	35.87433837	127.9261376	OFFICIAL	2026-01-29 23:28:25.041174	0	\N
313	경상남도 거창군 웅양면 한기리 453-17	2026-01-29 23:28:25.041921	35.87240862	127.9219525	OFFICIAL	2026-01-29 23:28:25.041929	0	\N
314	경상남도 거창군 웅양면 한기리 354-7	2026-01-29 23:28:25.042631	35.86904697	127.9258216	OFFICIAL	2026-01-29 23:28:25.042639	0	\N
315	경상남도 거창군 웅양면 동호리 868	2026-01-29 23:28:25.043327	35.79923213	127.9242421	OFFICIAL	2026-01-29 23:28:25.043335	0	\N
316	경상남도 거창군 웅양면 죽림리 686-7	2026-01-29 23:28:25.044009	35.7971002	127.9071784	OFFICIAL	2026-01-29 23:28:25.044017	0	\N
317	경상남도 거창군 웅양면 신촌리 620-5	2026-01-29 23:28:25.044781	35.88168142	127.9131966	OFFICIAL	2026-01-29 23:28:25.044789	0	\N
318	경상남도 거창군 웅양면 산포리 1387-19	2026-01-29 23:28:25.046303	35.82108481	127.9284932	OFFICIAL	2026-01-29 23:28:25.046311	0	\N
319	경상남도 거창군 웅양면 노현리 147-2	2026-01-29 23:28:25.048231	35.80666381	127.9178214	OFFICIAL	2026-01-29 23:28:25.048239	0	\N
320	경상남도 거창군 주상면 도평리 376-9	2026-01-29 23:28:25.04896	35.75554332	127.9157703	OFFICIAL	2026-01-29 23:28:25.048968	0	\N
321	경상남도 거창군 거창읍 김천리 210-31	2026-01-29 23:28:25.049861	35.6757584	127.909394	OFFICIAL	2026-01-29 23:28:25.04987	0	\N
322	경상남도 거창군 거창읍 송정리 839-1	2026-01-29 23:28:25.050539	35.68152227	127.8959979	OFFICIAL	2026-01-29 23:28:25.050547	0	\N
323	경상남도 거창군 거창읍 중앙리 353-3	2026-01-29 23:28:25.051323	35.69011991	127.9100497	OFFICIAL	2026-01-29 23:28:25.051332	0	\N
324	경상남도 거창군 거창읍 중앙리 2-6	2026-01-29 23:28:25.051995	35.69310911	127.9119846	OFFICIAL	2026-01-29 23:28:25.052003	0	\N
325	경상남도 거창군 거창읍 가지리 995-1	2026-01-29 23:28:25.052658	35.70345119	127.897809	OFFICIAL	2026-01-29 23:28:25.05269	0	\N
326	경상남도 거창군 거창읍 양평리 1239-110	2026-01-29 23:28:25.053439	35.68692195	127.9375303	OFFICIAL	2026-01-29 23:28:25.053461	0	\N
327	경상남도 거창군 거창읍 양평리 829	2026-01-29 23:28:25.054227	35.71402531	127.938854	OFFICIAL	2026-01-29 23:28:25.054233	0	\N
328	경상남도 거창군 거창읍 동변리 62-1	2026-01-29 23:28:25.054943	35.7162098	127.9178782	OFFICIAL	2026-01-29 23:28:25.05495	0	\N
329	경상남도 거창군 거창읍 김천리 20-6	2026-01-29 23:28:25.055675	35.68358187	127.9145165	OFFICIAL	2026-01-29 23:28:25.055682	0	\N
330	경상남도 거창군 거창읍 김천리 59-7	2026-01-29 23:28:25.056436	35.68252094	127.9137194	OFFICIAL	2026-01-29 23:28:25.056443	0	\N
331	경상남도 거창군 거창읍 대평리 1054-11	2026-01-29 23:28:25.057176	35.68424168	127.9195439	OFFICIAL	2026-01-29 23:28:25.057183	0	\N
332	경상남도 거창군 거창읍 상림리 243-19	2026-01-29 23:28:25.057878	35.68449465	127.9022872	OFFICIAL	2026-01-29 23:28:25.057885	0	\N
333	경상남도 거창군 주상면 하임실길 112	2026-01-29 23:28:25.058574	35.75051893	127.8951033	OFFICIAL	2026-01-29 23:28:25.058581	0	\N
334	경상남도 거창군 주상면 원성기1길 88	2026-01-29 23:28:25.059266	35.77600321	127.9245279	OFFICIAL	2026-01-29 23:28:25.059273	0	\N
335	경상남도 거창군 주상면 오류동길 44	2026-01-29 23:28:25.060113	35.78585923	127.8890597	OFFICIAL	2026-01-29 23:28:25.06012	0	\N
336	경상남도 거창군 주상면 연교1길 40	2026-01-29 23:28:25.06082	35.76142063	127.8992363	OFFICIAL	2026-01-29 23:28:25.060826	0	\N
337	경상남도 거창군 주상면 상도평길 35-6	2026-01-29 23:28:25.061506	35.75470379	127.9137809	OFFICIAL	2026-01-29 23:28:25.061513	0	\N
338	경상남도 거창군 주상면 도평리 1126	2026-01-29 23:28:25.062191	35.74506998	127.9290736	OFFICIAL	2026-01-29 23:28:25.062198	0	\N
339	경상남도 거창군 주상면 도평3길 15	2026-01-29 23:28:25.062926	35.74982815	127.9129963	OFFICIAL	2026-01-29 23:28:25.062933	0	\N
340	경상남도 거창군 주상면 도평1길 60	2026-01-29 23:28:25.063614	35.74952313	127.9142324	OFFICIAL	2026-01-29 23:28:25.06362	0	\N
341	경상남도 거창군 주상면 도동길 15	2026-01-29 23:28:25.064298	35.79696853	127.876873	OFFICIAL	2026-01-29 23:28:25.064305	0	\N
342	경상남도 거창군 주상면 당대고개길 6	2026-01-29 23:28:25.065185	35.75068571	127.9145895	OFFICIAL	2026-01-29 23:28:25.065192	0	\N
343	경상남도 거창군 주상면 거기1길 23	2026-01-29 23:28:25.066532	35.75659428	127.9410311	OFFICIAL	2026-01-29 23:28:25.066541	0	\N
344	경상남도 거창군 위천면 은하리길 2	2026-01-29 23:28:25.067299	35.76092327	127.8336769	OFFICIAL	2026-01-29 23:28:25.067307	0	\N
345	경상남도 거창군 위천면 원학길 321	2026-01-29 23:28:25.068144	35.74924121	127.8326881	OFFICIAL	2026-01-29 23:28:25.068151	0	\N
346	경상남도 거창군 위천면 원당1길 39	2026-01-29 23:28:25.068923	35.77489552	127.8678822	OFFICIAL	2026-01-29 23:28:25.06893	0	\N
347	경상남도 거창군 위천면 금원산길 471-27	2026-01-29 23:28:25.069644	35.72617571	127.795727	OFFICIAL	2026-01-29 23:28:25.069651	0	\N
348	경상남도 거창군 웅양면 죽림리 산108	2026-01-29 23:28:25.070345	35.79030695	127.9056157	OFFICIAL	2026-01-29 23:28:25.070352	0	\N
349	경상남도 거창군 웅양면 성북1길 259-6	2026-01-29 23:28:25.071045	35.79177533	127.9283434	OFFICIAL	2026-01-29 23:28:25.071085	0	\N
350	경상남도 거창군 웅양면 누룩재길 164	2026-01-29 23:28:25.071811	35.7971002	127.9071784	OFFICIAL	2026-01-29 23:28:25.071818	0	\N
351	경상남도 거창군 신원면 양지1길 8-1	2026-01-29 23:28:25.072466	35.5849552	127.9584444	OFFICIAL	2026-01-29 23:28:25.072489	0	\N
352	경상남도 거창군 신원면 신차로 2924	2026-01-29 23:28:25.073169	35.55574562	127.9248903	OFFICIAL	2026-01-29 23:28:25.073176	0	\N
353	경상남도 거창군 신원면 신머리길 3	2026-01-29 23:28:25.073911	35.53510242	127.8841341	OFFICIAL	2026-01-29 23:28:25.073918	0	\N
354	경상남도 거창군 신원면 상감악길 447-44	2026-01-29 23:28:25.074599	35.58800734	127.930925	OFFICIAL	2026-01-29 23:28:25.074606	0	\N
355	경상남도 거창군 북상면 병곡리 768-4	2026-01-29 23:28:25.075361	35.80911337	127.7756271	OFFICIAL	2026-01-29 23:28:25.075368	0	\N
356	경상남도 거창군 북상면 병곡길 185	2026-01-29 23:28:25.076141	35.79172837	127.7891925	OFFICIAL	2026-01-29 23:28:25.076147	0	\N
357	경상남도 거창군 북상면 덕유월성로1312-96	2026-01-29 23:28:25.076866	35.76120302	127.724	OFFICIAL	2026-01-29 23:28:25.076873	0	\N
358	경상남도 거창군 북상면 덕유월성로 1312-96	2026-01-29 23:28:25.077575	35.76120302	127.724	OFFICIAL	2026-01-29 23:28:25.077582	0	\N
359	경상남도 거창군 마리면 진산길 51-13	2026-01-29 23:28:25.07828	35.6983895	127.856838	OFFICIAL	2026-01-29 23:28:25.078286	0	\N
360	경상남도 거창군 마리면 율리 940-7	2026-01-29 23:28:25.078964	35.73199174	127.8536034	OFFICIAL	2026-01-29 23:28:25.078971	0	\N
361	경상남도 거창군 마리면 빼재로 23	2026-01-29 23:28:25.079639	35.70257339	127.8535867	OFFICIAL	2026-01-29 23:28:25.079645	0	\N
362	경상남도 거창군 마리면 매바우길 26	2026-01-29 23:28:25.080353	35.74449654	127.8580807	OFFICIAL	2026-01-29 23:28:25.08036	0	\N
363	경상남도 거창군 마리면 거안로 851	2026-01-29 23:28:25.081977	35.69943006	127.8564486	OFFICIAL	2026-01-29 23:28:25.081984	0	\N
364	경상남도 거창군 마리면 거안로 1035	2026-01-29 23:28:25.082735	35.68826694	127.8703455	OFFICIAL	2026-01-29 23:28:25.082743	0	\N
365	경상남도 거창군 남하면 지산로 731	2026-01-29 23:28:25.083422	35.66501522	127.9982123	OFFICIAL	2026-01-29 23:28:25.083429	0	\N
366	경상남도 거창군 남하면 양항길 354	2026-01-29 23:28:25.084109	35.68566767	127.9453686	OFFICIAL	2026-01-29 23:28:25.084116	0	\N
367	경상남도 거창군 남하면 양항길 310-11	2026-01-29 23:28:25.084855	35.68359544	127.944922	OFFICIAL	2026-01-29 23:28:25.084862	0	\N
368	경상남도 거창군 남하면 양항리 958	2026-01-29 23:28:25.085725	35.68436863	127.9398827	OFFICIAL	2026-01-29 23:28:25.085732	0	\N
369	경상남도 거창군 남하면 대야길 69-26	2026-01-29 23:28:25.08669	35.63801549	127.9642103	OFFICIAL	2026-01-29 23:28:25.086699	0	\N
370	경상남도 거창군 남상면 홍덕길 41	2026-01-29 23:28:25.087658	35.65442187	127.9334152	OFFICIAL	2026-01-29 23:28:25.087665	0	\N
371	경상남도 거창군 남상면 한산1길 122	2026-01-29 23:28:25.088525	35.64183675	127.937744	OFFICIAL	2026-01-29 23:28:25.088531	0	\N
372	경상남도 거창군 남상면 임불1길 57	2026-01-29 23:28:25.089373	35.61457278	127.9691721	OFFICIAL	2026-01-29 23:28:25.089379	0	\N
373	경상남도 거창군 남상면 일반산업길 160	2026-01-29 23:28:25.090081	35.65622785	127.9270145	OFFICIAL	2026-01-29 23:28:25.090088	0	\N
374	경상남도 거창군 남상면 인평길 36	2026-01-29 23:28:25.090894	35.64298394	127.9105058	OFFICIAL	2026-01-29 23:28:25.090902	0	\N
375	경상남도 거창군 남상면 인평길 21	2026-01-29 23:28:25.092194	35.64501258	127.9105881	OFFICIAL	2026-01-29 23:28:25.0922	0	\N
376	경상남도 거창군 남상면 웃골길 71	2026-01-29 23:28:25.092902	35.65646376	127.9146321	OFFICIAL	2026-01-29 23:28:25.09291	0	\N
377	경상남도 거창군 남상면 동령길 26-10	2026-01-29 23:28:25.093557	35.60688644	127.8770277	OFFICIAL	2026-01-29 23:28:25.093564	0	\N
378	경상남도 거창군 남상면 대산리 1599-1	2026-01-29 23:28:25.094212	35.65507959	127.9352875	OFFICIAL	2026-01-29 23:28:25.094219	0	\N
379	경상남도 거창군 고제면 하개명길 37	2026-01-29 23:28:25.094889	35.82801774	127.857058	OFFICIAL	2026-01-29 23:28:25.094896	0	\N
380	경상남도 거창군 고제면 소사길 52-5	2026-01-29 23:28:25.095541	35.90008506	127.8632116	OFFICIAL	2026-01-29 23:28:25.095547	0	\N
381	경상남도 거창군 고제면 고제로 333	2026-01-29 23:28:25.096207	35.83826388	127.876882	OFFICIAL	2026-01-29 23:28:25.096213	0	\N
382	경상남도 거창군 거창읍 창남5길 3-8	2026-01-29 23:28:25.096969	35.68246429	127.9125741	OFFICIAL	2026-01-29 23:28:25.096976	0	\N
383	경상남도 거창군 거창읍 창남1길 58	2026-01-29 23:28:25.098323	35.68316068	127.9152693	OFFICIAL	2026-01-29 23:28:25.098331	0	\N
384	경상남도 거창군 거창읍 창남1길 44	2026-01-29 23:28:25.099228	35.68226474	127.9146302	OFFICIAL	2026-01-29 23:28:25.099235	0	\N
385	경상남도 거창군 거창읍 창남1길 44	2026-01-29 23:28:25.100175	35.68226474	127.9146302	OFFICIAL	2026-01-29 23:28:25.100181	0	\N
386	경상남도 거창군 거창읍 창남1길 44	2026-01-29 23:28:25.101335	35.68226474	127.9146302	OFFICIAL	2026-01-29 23:28:25.101342	0	\N
387	경상남도 거창군 거창읍 창남1길 44	2026-01-29 23:28:25.102078	35.68226474	127.9146302	OFFICIAL	2026-01-29 23:28:25.102085	0	\N
388	경상남도 거창군 거창읍 창남1길 21	2026-01-29 23:28:25.102737	35.68164038	127.9134168	OFFICIAL	2026-01-29 23:28:25.102744	0	\N
389	경상남도 거창군 거창읍 중앙리 427-4	2026-01-29 23:28:25.103381	35.69121372	127.9098227	OFFICIAL	2026-01-29 23:28:25.103388	0	\N
390	경상남도 거창군 거창읍 중앙로1길 94	2026-01-29 23:28:25.104093	35.69006104	127.9168934	OFFICIAL	2026-01-29 23:28:25.104099	0	\N
391	경상남도 거창군 거창읍 중앙로1길 67	2026-01-29 23:28:25.104819	35.68951115	127.915727	OFFICIAL	2026-01-29 23:28:25.104826	0	\N
392	경상남도 거창군 거창읍 중앙로1길 67	2026-01-29 23:28:25.105464	35.68951115	127.915727	OFFICIAL	2026-01-29 23:28:25.105471	0	\N
393	경상남도 거창군 거창읍 중앙로1길 124	2026-01-29 23:28:25.106121	35.69095781	127.9182729	OFFICIAL	2026-01-29 23:28:25.106128	0	\N
394	경상남도 거창군 거창읍 중앙로 89	2026-01-29 23:28:25.106779	35.68569829	127.9085389	OFFICIAL	2026-01-29 23:28:25.106788	0	\N
395	경상남도 거창군 거창읍 중앙로 198	2026-01-29 23:28:25.107412	35.68861862	127.9198318	OFFICIAL	2026-01-29 23:28:25.107418	0	\N
396	경상남도 거창군 거창읍 중앙로 182	2026-01-29 23:28:25.108078	35.6881817	127.9182268	OFFICIAL	2026-01-29 23:28:25.108085	0	\N
397	경상남도 거창군 거창읍 중산길 62	2026-01-29 23:28:25.108782	35.67152291	127.9088316	OFFICIAL	2026-01-29 23:28:25.108789	0	\N
398	경상남도 거창군 거창읍 죽전길 24-5	2026-01-29 23:28:25.109409	35.69011922	127.908328	OFFICIAL	2026-01-29 23:28:25.109415	0	\N
399	경상남도 거창군 거창읍 죽전7길 13	2026-01-29 23:28:25.110061	35.69310247	127.9134433	OFFICIAL	2026-01-29 23:28:25.110067	0	\N
400	경상남도 거창군 거창읍 죽전4길 79-3	2026-01-29 23:28:25.110708	35.69346601	127.9102459	OFFICIAL	2026-01-29 23:28:25.110714	0	\N
401	경상남도 거창군 거창읍 죽전4길 79-3	2026-01-29 23:28:25.111395	35.69346601	127.9102459	OFFICIAL	2026-01-29 23:28:25.111401	0	\N
402	경상남도 거창군 거창읍 죽전4길 39	2026-01-29 23:28:25.112075	35.69196393	127.9102311	OFFICIAL	2026-01-29 23:28:25.112081	0	\N
403	경상남도 거창군 거창읍 죽전4길 28	2026-01-29 23:28:25.112702	35.69175768	127.9121537	OFFICIAL	2026-01-29 23:28:25.112709	0	\N
404	경상남도 거창군 거창읍 죽전2길 60	2026-01-29 23:28:25.11336	35.69174336	127.909401	OFFICIAL	2026-01-29 23:28:25.113368	0	\N
405	경상남도 거창군 거창읍 죽전2길 57	2026-01-29 23:28:25.114014	35.69134655	127.9094595	OFFICIAL	2026-01-29 23:28:25.11402	0	\N
406	경상남도 거창군 거창읍 죽전2길 43,33-4	2026-01-29 23:28:25.11469	35.69142095	127.9099067	OFFICIAL	2026-01-29 23:28:25.114697	0	\N
3013	구미시	2026-02-03 13:28:31.141184	36.1071743	128.4165079	PENDING	2026-02-03 13:28:31.141239	1	test
407	경상남도 거창군 거창읍 죽전2길 34-3,죽전길 24-5	2026-01-29 23:28:25.115377	35.69115915	127.9102384	OFFICIAL	2026-01-29 23:28:25.115384	0	\N
408	경상남도 거창군 거창읍 죽전2길 33-4	2026-01-29 23:28:25.116124	35.69117361	127.9100188	OFFICIAL	2026-01-29 23:28:25.11613	0	\N
409	경상남도 거창군 거창읍 죽전2길 16	2026-01-29 23:28:25.116894	35.69037659	127.9104314	OFFICIAL	2026-01-29 23:28:25.1169	0	\N
410	경상남도 거창군 거창읍 죽전1길 8	2026-01-29 23:28:25.117516	35.68971563	127.909165	OFFICIAL	2026-01-29 23:28:25.117522	0	\N
411	경상남도 거창군 거창읍 죽전1길 72	2026-01-29 23:28:25.11817	35.69274942	127.9088778	OFFICIAL	2026-01-29 23:28:25.118176	0	\N
412	경상남도 거창군 거창읍 죽동길 138	2026-01-29 23:28:25.11895	35.71868403	127.9020084	OFFICIAL	2026-01-29 23:28:25.118957	0	\N
413	경상남도 거창군 거창읍 주곡로 207	2026-01-29 23:28:25.119626	35.71382296	127.9169681	OFFICIAL	2026-01-29 23:28:25.119632	0	\N
414	경상남도 거창군 거창읍 주곡로 19	2026-01-29 23:28:25.120308	35.69670903	127.9192366	OFFICIAL	2026-01-29 23:28:25.120315	0	\N
415	경상남도 거창군 거창읍 정장길 19	2026-01-29 23:28:25.120967	35.6776769	127.9132959	OFFICIAL	2026-01-29 23:28:25.120973	0	\N
416	경상남도 거창군 거창읍 장팔길 93	2026-01-29 23:28:25.121601	35.67639913	127.9084095	OFFICIAL	2026-01-29 23:28:25.121607	0	\N
417	경상남도 거창군 거창읍 장팔길 93	2026-01-29 23:28:25.122222	35.67639913	127.9084095	OFFICIAL	2026-01-29 23:28:25.122229	0	\N
418	경상남도 거창군 거창읍 장팔길 91	2026-01-29 23:28:25.122923	35.67644016	127.908442	OFFICIAL	2026-01-29 23:28:25.122929	0	\N
419	경상남도 거창군 거창읍 장성골길 99	2026-01-29 23:28:25.123568	35.73686092	127.9307974	OFFICIAL	2026-01-29 23:28:25.123575	0	\N
420	경상남도 거창군 거창읍 의동1길 71-4	2026-01-29 23:28:25.124213	35.71644122	127.9295868	OFFICIAL	2026-01-29 23:28:25.12422	0	\N
421	경상남도 거창군 거창읍 운정3길 70-20	2026-01-29 23:28:25.124886	35.67768183	127.8952051	OFFICIAL	2026-01-29 23:28:25.124892	0	\N
422	경상남도 거창군 거창읍 운정3길 179	2026-01-29 23:28:25.125517	35.6758361	127.890462	OFFICIAL	2026-01-29 23:28:25.125524	0	\N
423	경상남도 거창군 거창읍 외학길 19	2026-01-29 23:28:25.126138	35.74047317	127.927131	OFFICIAL	2026-01-29 23:28:25.126144	0	\N
424	경상남도 거창군 거창읍 양평리 1141	2026-01-29 23:28:25.1268	35.69370448	127.9308049	OFFICIAL	2026-01-29 23:28:25.126806	0	\N
425	경상남도 거창군 거창읍 아림로3길 91	2026-01-29 23:28:25.127427	35.68997504	127.9141115	OFFICIAL	2026-01-29 23:28:25.127434	0	\N
426	경상남도 거창군 거창읍 아림로1길 20	2026-01-29 23:28:25.128086	35.68523733	127.9098241	OFFICIAL	2026-01-29 23:28:25.128093	0	\N
427	경상남도 거창군 거창읍 아림로 23	2026-01-29 23:28:25.128708	35.68517155	127.9105735	OFFICIAL	2026-01-29 23:28:25.128714	0	\N
428	경상남도 거창군 거창읍 심소정길 185	2026-01-29 23:28:25.129387	35.68709799	127.9048324	OFFICIAL	2026-01-29 23:28:25.129393	0	\N
429	경상남도 거창군 거창읍 수남로 2264-22	2026-01-29 23:28:25.130035	35.68114651	127.9135099	OFFICIAL	2026-01-29 23:28:25.130042	0	\N
430	경상남도 거창군 거창읍 수남로 2203-8	2026-01-29 23:28:25.130743	35.67579688	127.9108131	OFFICIAL	2026-01-29 23:28:25.130778	0	\N
431	경상남도 거창군 거창읍 수남로 2159	2026-01-29 23:28:25.131395	35.67177176	127.9107253	OFFICIAL	2026-01-29 23:28:25.131401	0	\N
432	경상남도 거창군 거창읍 송정리 609	2026-01-29 23:28:25.132075	35.67746209	127.901858	OFFICIAL	2026-01-29 23:28:25.132082	0	\N
433	경상남도 거창군 거창읍 송정리 1134-13,14	2026-01-29 23:28:25.132716	35.68131794	127.9085437	OFFICIAL	2026-01-29 23:28:25.132722	0	\N
434	경상남도 거창군 거창읍 송정리 1118-3	2026-01-29 23:28:25.133344	35.68048981	127.9028147	OFFICIAL	2026-01-29 23:28:25.13335	0	\N
435	경상남도 거창군 거창읍 송정리 1114-12	2026-01-29 23:28:25.133991	35.68076043	127.9032866	OFFICIAL	2026-01-29 23:28:25.133998	0	\N
436	경상남도 거창군 거창읍 송정리 1110-8	2026-01-29 23:28:25.134626	35.68159846	127.9048888	OFFICIAL	2026-01-29 23:28:25.134632	0	\N
437	경상남도 거창군 거창읍 송정리 1109-8	2026-01-29 23:28:25.13525	35.68170841	127.9040766	OFFICIAL	2026-01-29 23:28:25.135256	0	\N
438	경상남도 거창군 거창읍 송정9길 77	2026-01-29 23:28:25.135878	35.68135243	127.9105028	OFFICIAL	2026-01-29 23:28:25.135884	0	\N
439	경상남도 거창군 거창읍 송정9길 66	2026-01-29 23:28:25.136512	35.68105101	127.9098857	OFFICIAL	2026-01-29 23:28:25.136519	0	\N
440	경상남도 거창군 거창읍 송정9길 60	2026-01-29 23:28:25.137163	35.68104827	127.9095849	OFFICIAL	2026-01-29 23:28:25.137169	0	\N
441	경상남도 거창군 거창읍 송정9길 53	2026-01-29 23:28:25.137776	35.68132409	127.9092023	OFFICIAL	2026-01-29 23:28:25.137782	0	\N
442	경상남도 거창군 거창읍 송정9길 49	2026-01-29 23:28:25.138397	35.68134262	127.9090343	OFFICIAL	2026-01-29 23:28:25.138403	0	\N
443	경상남도 거창군 거창읍 송정9길 47	2026-01-29 23:28:25.139049	35.68134089	127.9088693	OFFICIAL	2026-01-29 23:28:25.139055	0	\N
444	경상남도 거창군 거창읍 송정9길 43	2026-01-29 23:28:25.139661	35.68134262	127.908711	OFFICIAL	2026-01-29 23:28:25.139667	0	\N
445	경상남도 거창군 거창읍 송정9길 42	2026-01-29 23:28:25.140318	35.68103949	127.9086528	OFFICIAL	2026-01-29 23:28:25.140325	0	\N
446	경상남도 거창군 거창읍 송정9길 40	2026-01-29 23:28:25.140958	35.68103277	127.9085211	OFFICIAL	2026-01-29 23:28:25.140964	0	\N
447	경상남도 거창군 거창읍 송정9길 38	2026-01-29 23:28:25.141731	35.68102482	127.9083562	OFFICIAL	2026-01-29 23:28:25.14174	0	\N
448	경상남도 거창군 거창읍 송정9길 22	2026-01-29 23:28:25.142446	35.68101388	127.9074397	OFFICIAL	2026-01-29 23:28:25.142453	0	\N
449	경상남도 거창군 거창읍 송정8길 86	2026-01-29 23:28:25.143455	35.68104691	127.9094361	OFFICIAL	2026-01-29 23:28:25.143463	0	\N
450	경상남도 거창군 거창읍 송정7길 86	2026-01-29 23:28:25.14421	35.68053337	127.9105393	OFFICIAL	2026-01-29 23:28:25.144217	0	\N
451	경상남도 거창군 거창읍 송정7길 80	2026-01-29 23:28:25.144942	35.68060831	127.9101991	OFFICIAL	2026-01-29 23:28:25.144949	0	\N
452	경상남도 거창군 거창읍 송정7길 74	2026-01-29 23:28:25.145618	35.68059462	127.9098512	OFFICIAL	2026-01-29 23:28:25.145625	0	\N
453	경상남도 거창군 거창읍 송정7길 70	2026-01-29 23:28:25.146313	35.68059285	127.909668	OFFICIAL	2026-01-29 23:28:25.14632	0	\N
454	경상남도 거창군 거창읍 송정7길 67	2026-01-29 23:28:25.147014	35.68085196	127.9096094	OFFICIAL	2026-01-29 23:28:25.147021	0	\N
455	경상남도 거창군 거창읍 송정7길 59	2026-01-29 23:28:25.147663	35.68087241	127.9090735	OFFICIAL	2026-01-29 23:28:25.147669	0	\N
456	경상남도 거창군 거창읍 송정7길 112	2026-01-29 23:28:25.148325	35.68182474	127.9107626	OFFICIAL	2026-01-29 23:28:25.148333	0	\N
457	경상남도 거창군 거창읍 송정6길 19	2026-01-29 23:28:25.148955	35.68119777	127.9038063	OFFICIAL	2026-01-29 23:28:25.148961	0	\N
458	경상남도 거창군 거창읍 송정5길 54	2026-01-29 23:28:25.149657	35.68094801	127.9047917	OFFICIAL	2026-01-29 23:28:25.149664	0	\N
459	경상남도 거창군 거창읍 송정5길 48	2026-01-29 23:28:25.150301	35.68094565	127.9045397	OFFICIAL	2026-01-29 23:28:25.150307	0	\N
460	경상남도 거창군 거창읍 송정5길 40	2026-01-29 23:28:25.150963	35.68092537	127.9040895	OFFICIAL	2026-01-29 23:28:25.15097	0	\N
461	경상남도 거창군 거창읍 송정5길 25	2026-01-29 23:28:25.151576	35.68122383	127.9033354	OFFICIAL	2026-01-29 23:28:25.151582	0	\N
462	경상남도 거창군 거창읍 송정5길 22	2026-01-29 23:28:25.152228	35.68093238	127.9031418	OFFICIAL	2026-01-29 23:28:25.152235	0	\N
463	경상남도 거창군 거창읍 송정5길 13	2026-01-29 23:28:25.152854	35.68117045	127.9026772	OFFICIAL	2026-01-29 23:28:25.15286	0	\N
464	경상남도 거창군 거창읍 송정4길 57	2026-01-29 23:28:25.153454	35.68042338	127.9043022	OFFICIAL	2026-01-29 23:28:25.15346	0	\N
465	경상남도 거창군 거창읍 송정3길 37-10	2026-01-29 23:28:25.15408	35.68191472	127.9032018	OFFICIAL	2026-01-29 23:28:25.154085	0	\N
466	경상남도 거창군 거창읍 송정3길 34	2026-01-29 23:28:25.154678	35.68135206	127.9028079	OFFICIAL	2026-01-29 23:28:25.154684	0	\N
467	경상남도 거창군 거창읍 송정3길 20	2026-01-29 23:28:25.155271	35.68129268	127.9023661	OFFICIAL	2026-01-29 23:28:25.155277	0	\N
468	경상남도 거창군 거창읍 송정1길 95	2026-01-29 23:28:25.155898	35.68070354	127.902099	OFFICIAL	2026-01-29 23:28:25.155904	0	\N
469	경상남도 거창군 거창읍 송정1길 147	2026-01-29 23:28:25.156638	35.68078403	127.9049659	OFFICIAL	2026-01-29 23:28:25.156645	0	\N
470	경상남도 거창군 거창읍 송정1길 146,148	2026-01-29 23:28:25.157345	35.68054782	127.904833	OFFICIAL	2026-01-29 23:28:25.157351	0	\N
471	경상남도 거창군 거창읍 송정1길 134	2026-01-29 23:28:25.157954	35.68054168	127.9042469	OFFICIAL	2026-01-29 23:28:25.15796	0	\N
472	경상남도 거창군 거창읍 송정1길 132	2026-01-29 23:28:25.158533	35.68054182	127.9040721	OFFICIAL	2026-01-29 23:28:25.158539	0	\N
473	경상남도 거창군 거창읍 송정1길 124	2026-01-29 23:28:25.159113	35.68052155	127.9036068	OFFICIAL	2026-01-29 23:28:25.159119	0	\N
474	경상남도 거창군 거창읍 송정1길 121	2026-01-29 23:28:25.159677	35.68076372	127.9034643	OFFICIAL	2026-01-29 23:28:25.159683	0	\N
475	경상남도 거창군 거창읍 송정1길 120	2026-01-29 23:28:25.160323	35.68051602	127.9033957	OFFICIAL	2026-01-29 23:28:25.160329	0	\N
476	경상남도 거창군 거창읍 송정1길 112	2026-01-29 23:28:25.161009	35.68049471	127.9030026	OFFICIAL	2026-01-29 23:28:25.161015	0	\N
477	경상남도 거창군 거창읍 송정10길 51	2026-01-29 23:28:25.161652	35.68181152	127.9090015	OFFICIAL	2026-01-29 23:28:25.161658	0	\N
478	경상남도 거창군 거창읍 송정10길 48,50	2026-01-29 23:28:25.162309	35.68150924	127.9087502	OFFICIAL	2026-01-29 23:28:25.162315	0	\N
479	경상남도 거창군 거창읍 송정10길 47	2026-01-29 23:28:25.162957	35.68183104	127.9088138	OFFICIAL	2026-01-29 23:28:25.162963	0	\N
480	경상남도 거창군 거창읍 송정10길 15	2026-01-29 23:28:25.163558	35.68084163	127.9078908	OFFICIAL	2026-01-29 23:28:25.163564	0	\N
481	경상남도 거창군 거창읍 소만5길 37	2026-01-29 23:28:25.164187	35.69238766	127.9220067	OFFICIAL	2026-01-29 23:28:25.164194	0	\N
482	경상남도 거창군 거창읍 소만4길 22	2026-01-29 23:28:25.164846	35.69307488	127.9236258	OFFICIAL	2026-01-29 23:28:25.164852	0	\N
483	경상남도 거창군 거창읍 소만3길 42	2026-01-29 23:28:25.165443	35.69382728	127.9220679	OFFICIAL	2026-01-29 23:28:25.165449	0	\N
484	경상남도 거창군 거창읍 소만3길 36-19	2026-01-29 23:28:25.16608	35.69309764	127.9218582	OFFICIAL	2026-01-29 23:28:25.166086	0	\N
485	경상남도 거창군 거창읍 소만3길 36-16	2026-01-29 23:28:25.166716	35.69304951	127.921517	OFFICIAL	2026-01-29 23:28:25.166722	0	\N
486	경상남도 거창군 거창읍 소만3길 14-23	2026-01-29 23:28:25.167322	35.69289169	127.9206736	OFFICIAL	2026-01-29 23:28:25.167328	0	\N
487	경상남도 거창군 거창읍 소만3길 14-15	2026-01-29 23:28:25.167957	35.69319233	127.9206583	OFFICIAL	2026-01-29 23:28:25.167963	0	\N
488	경상남도 거창군 거창읍 소만3길 14-15	2026-01-29 23:28:25.168539	35.69319233	127.9206583	OFFICIAL	2026-01-29 23:28:25.168545	0	\N
489	경상남도 거창군 거창읍 소만2길 31	2026-01-29 23:28:25.169149	35.69367373	127.9220776	OFFICIAL	2026-01-29 23:28:25.169155	0	\N
490	경상남도 거창군 거창읍 소만1길 58	2026-01-29 23:28:25.169798	35.69489358	127.9210978	OFFICIAL	2026-01-29 23:28:25.169804	0	\N
491	경상남도 거창군 거창읍 소만1길 28	2026-01-29 23:28:25.170431	35.69348022	127.9212427	OFFICIAL	2026-01-29 23:28:25.170437	0	\N
492	경상남도 거창군 거창읍 소만1길 21	2026-01-29 23:28:25.171084	35.69317204	127.9209194	OFFICIAL	2026-01-29 23:28:25.171091	0	\N
493	경상남도 거창군 거창읍 소만1길 17	2026-01-29 23:28:25.171693	35.69290774	127.9209379	OFFICIAL	2026-01-29 23:28:25.171699	0	\N
494	경상남도 거창군 거창읍 소만1길 16-8	2026-01-29 23:28:25.172342	35.69267152	127.9216098	OFFICIAL	2026-01-29 23:28:25.172348	0	\N
495	경상남도 거창군 거창읍 샛단길 21-14	2026-01-29 23:28:25.17296	35.6833386	127.8935413	OFFICIAL	2026-01-29 23:28:25.172966	0	\N
496	경상남도 거창군 거창읍 상림리 851	2026-01-29 23:28:25.173688	35.68628654	127.9022585	OFFICIAL	2026-01-29 23:28:25.173694	0	\N
497	경상남도 거창군 거창읍 상림리 495	2026-01-29 23:28:25.174448	35.68648926	127.8943328	OFFICIAL	2026-01-29 23:28:25.174454	0	\N
498	경상남도 거창군 거창읍 상림리 31-2	2026-01-29 23:28:25.175222	35.68730526	127.907825	OFFICIAL	2026-01-29 23:28:25.175229	0	\N
499	경상남도 거창군 거창읍 상림리 116-5	2026-01-29 23:28:25.175886	35.68483448	127.9085095	OFFICIAL	2026-01-29 23:28:25.175892	0	\N
500	경상남도 거창군 거창읍 상동8길 15	2026-01-29 23:28:25.176513	35.68725247	127.9058254	OFFICIAL	2026-01-29 23:28:25.17652	0	\N
501	경상남도 거창군 거창읍 상동7길 46	2026-01-29 23:28:25.177118	35.68739662	127.9066347	OFFICIAL	2026-01-29 23:28:25.177124	0	\N
502	경상남도 거창군 거창읍 상동7길 46	2026-01-29 23:28:25.177963	35.68739662	127.9066347	OFFICIAL	2026-01-29 23:28:25.177971	0	\N
503	경상남도 거창군 거창읍 상동7길 46	2026-01-29 23:28:25.178569	35.68739662	127.9066347	OFFICIAL	2026-01-29 23:28:25.178576	0	\N
504	경상남도 거창군 거창읍 상동6길 17	2026-01-29 23:28:25.179163	35.68860743	127.9084048	OFFICIAL	2026-01-29 23:28:25.179169	0	\N
505	경상남도 거창군 거창읍 상동6길 17	2026-01-29 23:28:25.179787	35.68860743	127.9084048	OFFICIAL	2026-01-29 23:28:25.179793	0	\N
506	경상남도 거창군 거창읍 상동1길 45	2026-01-29 23:28:25.180402	35.68684802	127.906684	OFFICIAL	2026-01-29 23:28:25.180409	0	\N
507	경상남도 거창군 거창읍 밤티재로 1288	2026-01-29 23:28:25.181028	35.67061785	127.9324907	OFFICIAL	2026-01-29 23:28:25.181034	0	\N
508	경상남도 거창군 거창읍 모곡2길 22	2026-01-29 23:28:25.181649	35.71515524	127.9170544	OFFICIAL	2026-01-29 23:28:25.181655	0	\N
509	경상남도 거창군 거창읍 모곡2길 22	2026-01-29 23:28:25.182329	35.71515524	127.9170544	OFFICIAL	2026-01-29 23:28:25.182336	0	\N
510	경상남도 거창군 거창읍 동산길 41	2026-01-29 23:28:25.18295	35.69971886	127.9175179	OFFICIAL	2026-01-29 23:28:25.182957	0	\N
511	경상남도 거창군 거창읍 동동6길 9	2026-01-29 23:28:25.183571	35.69050342	127.9206649	OFFICIAL	2026-01-29 23:28:25.183593	0	\N
512	경상남도 거창군 거창읍 동동5길 90	2026-01-29 23:28:25.184926	35.69203978	127.9248256	OFFICIAL	2026-01-29 23:28:25.184934	0	\N
513	경상남도 거창군 거창읍 동동5길 68	2026-01-29 23:28:25.186552	35.69181555	127.9234173	OFFICIAL	2026-01-29 23:28:25.18656	0	\N
514	경상남도 거창군 거창읍 동동1길 31	2026-01-29 23:28:25.187269	35.68883105	127.9213158	OFFICIAL	2026-01-29 23:28:25.187276	0	\N
515	경상남도 거창군 거창읍 대평리 1187	2026-01-29 23:28:25.187886	35.68425419	127.9170294	OFFICIAL	2026-01-29 23:28:25.187893	0	\N
516	경상남도 거창군 거창읍 대평리 1054-5	2026-01-29 23:28:25.188574	35.68473007	127.9201862	OFFICIAL	2026-01-29 23:28:25.188581	0	\N
517	경상남도 거창군 거창읍 대평리 1054-20	2026-01-29 23:28:25.189171	35.68450616	127.9201144	OFFICIAL	2026-01-29 23:28:25.189178	0	\N
518	경상남도 거창군 거창읍 대평리 1053-4	2026-01-29 23:28:25.189731	35.68499321	127.9196285	OFFICIAL	2026-01-29 23:28:25.189738	0	\N
519	경상남도 거창군 거창읍 대평리 1053-1	2026-01-29 23:28:25.190384	35.68482494	127.9197718	OFFICIAL	2026-01-29 23:28:25.190391	0	\N
520	경상남도 거창군 거창읍 대평8길 35	2026-01-29 23:28:25.191002	35.68338589	127.9207542	OFFICIAL	2026-01-29 23:28:25.191009	0	\N
521	경상남도 거창군 거창읍 대평7길 54	2026-01-29 23:28:25.191583	35.68359021	127.9207651	OFFICIAL	2026-01-29 23:28:25.191589	0	\N
522	경상남도 거창군 거창읍 대평7길 50	2026-01-29 23:28:25.192171	35.68358744	127.9203973	OFFICIAL	2026-01-29 23:28:25.192178	0	\N
523	경상남도 거창군 거창읍 대평6길 47	2026-01-29 23:28:25.192774	35.68418481	127.9202284	OFFICIAL	2026-01-29 23:28:25.192779	0	\N
524	경상남도 거창군 거창읍 대평6길 30	2026-01-29 23:28:25.193345	35.68376034	127.9192946	OFFICIAL	2026-01-29 23:28:25.193352	0	\N
525	경상남도 거창군 거창읍 대평5길 38-8	2026-01-29 23:28:25.193948	35.6842755	127.9193876	OFFICIAL	2026-01-29 23:28:25.193954	0	\N
526	경상남도 거창군 거창읍 대평3길 51	2026-01-29 23:28:25.194577	35.68487525	127.9207125	OFFICIAL	2026-01-29 23:28:25.194584	0	\N
527	경상남도 거창군 거창읍 대평3길 51	2026-01-29 23:28:25.195169	35.68487525	127.9207125	OFFICIAL	2026-01-29 23:28:25.195175	0	\N
528	경상남도 거창군 거창읍 대평3길 48	2026-01-29 23:28:25.195835	35.68479756	127.9211947	OFFICIAL	2026-01-29 23:28:25.195842	0	\N
529	경상남도 거창군 거창읍 대평3길 38	2026-01-29 23:28:25.196444	35.68453109	127.9213924	OFFICIAL	2026-01-29 23:28:25.196452	0	\N
530	경상남도 거창군 거창읍 대평2길 13	2026-01-29 23:28:25.197089	35.68295105	127.9199871	OFFICIAL	2026-01-29 23:28:25.197096	0	\N
531	경상남도 거창군 거창읍 대동리 983-3	2026-01-29 23:28:25.197674	35.69334291	127.9209087	OFFICIAL	2026-01-29 23:28:25.197687	0	\N
532	경상남도 거창군 거창읍 강양1길 27	2026-01-29 23:28:25.198298	35.69039867	127.9188171	OFFICIAL	2026-01-29 23:28:25.198304	0	\N
533	경상남도 거창군 거창읍 거열로2길 76-14	2026-01-29 23:28:25.198914	35.6948296	127.9136907	OFFICIAL	2026-01-29 23:28:25.198921	0	\N
534	경상남도 거창군 거창읍 대동리 27-20	2026-01-29 23:28:25.199515	35.68725782	127.9176847	OFFICIAL	2026-01-29 23:28:25.199521	0	\N
535	경상남도 거창군 거창읍 대동리 13-5	2026-01-29 23:28:25.200096	35.69023793	127.9233809	OFFICIAL	2026-01-29 23:28:25.200102	0	\N
536	경상남도 거창군 남상면 홍덕길 15	2026-01-29 23:28:25.200665	35.65542594	127.9337653	OFFICIAL	2026-01-29 23:28:25.20067	0	\N
537	경상남도 거창군 남상면 홍덕길 11	2026-01-29 23:28:25.201288	35.65574527	127.9333913	OFFICIAL	2026-01-29 23:28:25.201292	0	\N
538	경상남도 거창군 남상면 창포원길 21-1	2026-01-29 23:28:25.20191	35.6549216	127.9398302	OFFICIAL	2026-01-29 23:28:25.201916	0	\N
539	경상남도 거창군 남상면 진목1길 20	2026-01-29 23:28:25.202476	35.59493615	127.8702702	OFFICIAL	2026-01-29 23:28:25.202482	0	\N
540	경상남도 거창군 남상면 승강기길 80	2026-01-29 23:28:25.203078	35.65308646	127.9300075	OFFICIAL	2026-01-29 23:28:25.203084	0	\N
541	경상남도 거창군 거창읍 김천리 475-3	2026-01-29 23:28:25.203707	35.68104964	127.9097353	OFFICIAL	2026-01-29 23:28:25.203712	0	\N
542	경상남도 거창군 거창읍 김천리 473-1	2026-01-29 23:28:25.204417	35.68209922	127.9094591	OFFICIAL	2026-01-29 23:28:25.204423	0	\N
543	경상남도 거창군 거창읍 김천2길 46	2026-01-29 23:28:25.205065	35.67694353	127.9089053	OFFICIAL	2026-01-29 23:28:25.205071	0	\N
544	경상남도 거창군 거창읍 국농소2길 10	2026-01-29 23:28:25.205664	35.67346358	127.9362578	OFFICIAL	2026-01-29 23:28:25.20567	0	\N
545	경상남도 거창군 거창읍 구산1길 4	2026-01-29 23:28:25.206257	35.71803162	127.9066859	OFFICIAL	2026-01-29 23:28:25.206262	0	\N
546	경상남도 거창군 거창읍 구례길 166	2026-01-29 23:28:25.20687	35.72252727	127.9274857	OFFICIAL	2026-01-29 23:28:25.206876	0	\N
547	경상남도 거창군 거창읍 공수들8길 11	2026-01-29 23:28:25.207443	35.68548079	127.9008675	OFFICIAL	2026-01-29 23:28:25.207449	0	\N
548	경상남도 거창군 거창읍 공수들6길 17	2026-01-29 23:28:25.208083	35.68690156	127.9034589	OFFICIAL	2026-01-29 23:28:25.208088	0	\N
549	경상남도 거창군 거창읍 공수들1길 16	2026-01-29 23:28:25.208683	35.68529222	127.9006909	OFFICIAL	2026-01-29 23:28:25.208689	0	\N
550	경상남도 거창군 거창읍 거함대로5길 51	2026-01-29 23:28:25.209333	35.68284699	127.9208779	OFFICIAL	2026-01-29 23:28:25.209339	0	\N
551	경상남도 거창군 거창읍 거함대로4길 60	2026-01-29 23:28:25.209941	35.68316487	127.9142794	OFFICIAL	2026-01-29 23:28:25.209947	0	\N
552	경상남도 거창군 거창읍 거함대로4길 24	2026-01-29 23:28:25.210542	35.68308147	127.9166304	OFFICIAL	2026-01-29 23:28:25.210548	0	\N
553	경상남도 거창군 거창읍 거함대로3길 23	2026-01-29 23:28:25.211102	35.67937054	127.9107121	OFFICIAL	2026-01-29 23:28:25.211108	0	\N
554	경상남도 거창군 거창읍 거함대로 4길 64	2026-01-29 23:28:25.21169	35.68322887	127.9138744	OFFICIAL	2026-01-29 23:28:25.211695	0	\N
555	경상남도 거창군 거창읍 거함대로 3372-8	2026-01-29 23:28:25.212279	35.67608301	127.9272966	OFFICIAL	2026-01-29 23:28:25.212285	0	\N
556	경상남도 거창군 거창읍 거함대로 3372-30	2026-01-29 23:28:25.212899	35.67569426	127.924782	OFFICIAL	2026-01-29 23:28:25.212905	0	\N
557	경상남도 거창군 거창읍 거함대로 3372	2026-01-29 23:28:25.213506	35.6758035	127.926212	OFFICIAL	2026-01-29 23:28:25.213512	0	\N
558	경상남도 거창군 거창읍 거함대로 3322	2026-01-29 23:28:25.2141	35.67800721	127.9230338	OFFICIAL	2026-01-29 23:28:25.214105	0	\N
559	경상남도 거창군 거창읍 거함대로 3276-3	2026-01-29 23:28:25.214802	35.68031636	127.9188533	OFFICIAL	2026-01-29 23:28:25.214807	0	\N
560	경상남도 거창군 거창읍 거함대로 3235	2026-01-29 23:28:25.215372	35.68175872	127.9154447	OFFICIAL	2026-01-29 23:28:25.215378	0	\N
561	경상남도 거창군 거창읍 거함대로 3200	2026-01-29 23:28:25.216025	35.6802029	127.9117994	OFFICIAL	2026-01-29 23:28:25.216031	0	\N
562	경상남도 거창군 거창읍 거함대로 3196	2026-01-29 23:28:25.216644	35.68022138	127.9115848	OFFICIAL	2026-01-29 23:28:25.21665	0	\N
563	경상남도 거창군 거창읍 거함대로 3079	2026-01-29 23:28:25.217277	35.6809354	127.8987277	OFFICIAL	2026-01-29 23:28:25.217283	0	\N
564	경상남도 거창군 거창읍 거창대학로 72	2026-01-29 23:28:25.217895	35.67320256	127.9124187	OFFICIAL	2026-01-29 23:28:25.2179	0	\N
565	경상남도 거창군 거창읍 거창대로3길 50	2026-01-29 23:28:25.218472	35.68881756	127.9180453	OFFICIAL	2026-01-29 23:28:25.218477	0	\N
566	경상남도 거창군 거창읍 거창대로 52	2026-01-29 23:28:25.219073	35.68639967	127.9167601	OFFICIAL	2026-01-29 23:28:25.219079	0	\N
567	경상남도 거창군 거창읍 거열산성로 73	2026-01-29 23:28:25.219669	35.69281847	127.8948848	OFFICIAL	2026-01-29 23:28:25.219674	0	\N
568	경상남도 거창군 거창읍 거열로9길 158	2026-01-29 23:28:25.22031	35.68728568	127.890722	OFFICIAL	2026-01-29 23:28:25.220316	0	\N
569	경상남도 거창군 거창읍 거열로7길 94	2026-01-29 23:28:25.220941	35.69221396	127.9008954	OFFICIAL	2026-01-29 23:28:25.220946	0	\N
570	경상남도 거창군 거창읍 거열로7길 57	2026-01-29 23:28:25.221489	35.69108338	127.9003606	OFFICIAL	2026-01-29 23:28:25.221495	0	\N
571	경상남도 거창군 거창읍 거열로6길 11	2026-01-29 23:28:25.222061	35.68919288	127.9036746	OFFICIAL	2026-01-29 23:28:25.222066	0	\N
572	경상남도 거창군 거창읍 거열로5길 8-26	2026-01-29 23:28:25.222617	35.68994682	127.9065094	OFFICIAL	2026-01-29 23:28:25.222623	0	\N
573	경상남도 거창군 거창읍 거열로4길 98	2026-01-29 23:28:25.223203	35.69287394	127.9079562	OFFICIAL	2026-01-29 23:28:25.223209	0	\N
574	경상남도 거창군 거창읍 거열로4길 7-13	2026-01-29 23:28:25.223804	35.6895796	127.9067804	OFFICIAL	2026-01-29 23:28:25.22381	0	\N
575	경상남도 거창군 거창읍 거열로4길 406	2026-01-29 23:28:25.224353	35.7023336	127.8959264	OFFICIAL	2026-01-29 23:28:25.224359	0	\N
576	경상남도 거창군 거창읍 거열로4길 161	2026-01-29 23:28:25.224927	35.69541269	127.9059213	OFFICIAL	2026-01-29 23:28:25.224932	0	\N
577	경상남도 거창군 거창읍 장팔길 77	2026-01-29 23:28:25.225887	35.6770135	127.9086622	OFFICIAL	2026-01-29 23:28:25.225893	0	\N
578	경상남도 거창군 거창읍 거열로4길 160	2026-01-29 23:28:25.226507	35.69545691	127.9065963	OFFICIAL	2026-01-29 23:28:25.226517	0	\N
579	경상남도 거창군 거창읍 거열로4길 144-61	2026-01-29 23:28:25.227118	35.69520126	127.9083853	OFFICIAL	2026-01-29 23:28:25.227124	0	\N
580	경상남도 거창군 거창읍 거열로4길 127	2026-01-29 23:28:25.227712	35.6940635	127.9067636	OFFICIAL	2026-01-29 23:28:25.227718	0	\N
581	경상남도 거창군 거창읍 거열로4길 120	2026-01-29 23:28:25.228331	35.69388856	127.9076975	OFFICIAL	2026-01-29 23:28:25.228336	0	\N
582	경상남도 거창군 거창읍 거열로3길5-6	2026-01-29 23:28:25.229	35.69190463	127.9162419	OFFICIAL	2026-01-29 23:28:25.229006	0	\N
583	경상남도 거창군 거창읍 거열로3길 66-4	2026-01-29 23:28:25.229608	35.69373737	127.9151432	OFFICIAL	2026-01-29 23:28:25.229614	0	\N
584	경상남도 거창군 거창읍 거열로3길 66-3	2026-01-29 23:28:25.230184	35.69371959	127.9148982	OFFICIAL	2026-01-29 23:28:25.23019	0	\N
585	경상남도 거창군 거창읍 거열로3길 26	2026-01-29 23:28:25.230783	35.69264455	127.9163833	OFFICIAL	2026-01-29 23:28:25.230789	0	\N
586	경상남도 거창군 거창읍 거열로3길 16-12	2026-01-29 23:28:25.231361	35.69244028	127.9169698	OFFICIAL	2026-01-29 23:28:25.231366	0	\N
587	경상남도 거창군 거창읍 거열로3길 10	2026-01-29 23:28:25.231942	35.69196826	127.9168207	OFFICIAL	2026-01-29 23:28:25.231947	0	\N
588	경상남도 거창군 거창읍 거열로2길 73	2026-01-29 23:28:25.232534	35.69401818	127.9138524	OFFICIAL	2026-01-29 23:28:25.23254	0	\N
589	경상남도 거창군 거창읍 거열로2길 63	2026-01-29 23:28:25.233111	35.6931808	127.9142603	OFFICIAL	2026-01-29 23:28:25.233117	0	\N
590	경상남도 거창군 거창읍 거열로2길 63	2026-01-29 23:28:25.233656	35.6931808	127.9142603	OFFICIAL	2026-01-29 23:28:25.233662	0	\N
591	경상남도 거창군 거창읍 거열로2길 24	2026-01-29 23:28:25.234291	35.69228661	127.915349	OFFICIAL	2026-01-29 23:28:25.234296	0	\N
592	경상남도 거창군 거창읍 거열로2길 24	2026-01-29 23:28:25.234917	35.69228661	127.915349	OFFICIAL	2026-01-29 23:28:25.234922	0	\N
593	경상남도 거창군 거창읍 거열로2길 24	2026-01-29 23:28:25.235501	35.69228661	127.915349	OFFICIAL	2026-01-29 23:28:25.235506	0	\N
594	경상남도 거창군 거창읍 거열로1길 92	2026-01-29 23:28:25.23609	35.69369226	127.9119192	OFFICIAL	2026-01-29 23:28:25.236095	0	\N
595	경상남도 거창군 거창읍 거열로1길 86	2026-01-29 23:28:25.236662	35.69377129	127.912361	OFFICIAL	2026-01-29 23:28:25.236667	0	\N
596	경상남도 거창군 거창읍 거열로1길 79	2026-01-29 23:28:25.237265	35.69311755	127.9127854	OFFICIAL	2026-01-29 23:28:25.23727	0	\N
597	경상남도 거창군 거창읍 거열로1길 78-7	2026-01-29 23:28:25.237866	35.6937871	127.9126648	OFFICIAL	2026-01-29 23:28:25.237871	0	\N
598	경상남도 거창군 거창읍 거열로1길 78-57	2026-01-29 23:28:25.238419	35.6947845	127.9108405	OFFICIAL	2026-01-29 23:28:25.238424	0	\N
599	경상남도 거창군 거창읍 거열로1길 78-23	2026-01-29 23:28:25.239025	35.69472709	127.9121551	OFFICIAL	2026-01-29 23:28:25.23903	0	\N
600	경상남도 거창군 거창읍 거열로1길 74	2026-01-29 23:28:25.239605	35.69379956	127.9130182	OFFICIAL	2026-01-29 23:28:25.23961	0	\N
601	경상남도 거창군 거창읍 거열로1길 100-26	2026-01-29 23:28:25.240208	35.69454347	127.9115521	OFFICIAL	2026-01-29 23:28:25.240214	0	\N
602	경상남도 거창군 거창읍 거열로1길 100-24	2026-01-29 23:28:25.240822	35.69421007	127.911771	OFFICIAL	2026-01-29 23:28:25.240828	0	\N
603	경상남도 거창군 거창읍 거열로 234-14	2026-01-29 23:28:25.241398	35.69248278	127.918772	OFFICIAL	2026-01-29 23:28:25.241403	0	\N
604	경상남도 거창군 거창읍 거열로 165-1	2026-01-29 23:28:25.242005	35.69015826	127.9117472	OFFICIAL	2026-01-29 23:28:25.242011	0	\N
605	경상남도 거창군 거창읍 거안로 1266-43	2026-01-29 23:28:25.242582	35.68415861	127.8878089	OFFICIAL	2026-01-29 23:28:25.242588	0	\N
606	경상남도 거창군 거창읍 개봉길 58	2026-01-29 23:28:25.243152	35.69343584	127.9145705	OFFICIAL	2026-01-29 23:28:25.243158	0	\N
607	경상남도 거창군 거창읍 개봉길 46	2026-01-29 23:28:25.243717	35.69330986	127.9156836	OFFICIAL	2026-01-29 23:28:25.243722	0	\N
608	경상남도 거창군 거창읍 강양5길 61-3	2026-01-29 23:28:25.244301	35.68944658	127.9184526	OFFICIAL	2026-01-29 23:28:25.244306	0	\N
609	경상남도 거창군 거창읍 강양4길 26	2026-01-29 23:28:25.244901	35.6898523	127.9187858	OFFICIAL	2026-01-29 23:28:25.244907	0	\N
610	경상남도 거창군 거창읍 강양4길 19-6	2026-01-29 23:28:25.245467	35.69032792	127.9185333	OFFICIAL	2026-01-29 23:28:25.245473	0	\N
611	경상남도 거창군 거창읍 강양4길 16	2026-01-29 23:28:25.246039	35.68991512	127.9182785	OFFICIAL	2026-01-29 23:28:25.246044	0	\N
612	경상남도 거창군 거창읍 강양4길 10	2026-01-29 23:28:25.246591	35.68991233	127.9179701	OFFICIAL	2026-01-29 23:28:25.246596	0	\N
613	경상남도 거창군 거창읍 강양2길 36	2026-01-29 23:28:25.247143	35.69173606	127.9186111	OFFICIAL	2026-01-29 23:28:25.247149	0	\N
614	경상남도 거창군 거창읍 강양1길 31	2026-01-29 23:28:25.247727	35.69060972	127.9187602	OFFICIAL	2026-01-29 23:28:25.247732	0	\N
615	경상남도 거창군 거창읍 강양1길 27	2026-01-29 23:28:25.248416	35.69039867	127.9188171	OFFICIAL	2026-01-29 23:28:25.248421	0	\N
616	경상남도 거창군 거창읍 강변로9길 51	2026-01-29 23:28:25.249034	35.68898986	127.9175035	OFFICIAL	2026-01-29 23:28:25.24904	0	\N
617	경상남도 거창군 거창읍 강변로7길 13	2026-01-29 23:28:25.2496	35.68478296	127.9081355	OFFICIAL	2026-01-29 23:28:25.249606	0	\N
618	경상남도 거창군 거창읍 강변로2길 12	2026-01-29 23:28:25.250182	35.68396949	127.9005546	OFFICIAL	2026-01-29 23:28:25.250188	0	\N
619	경상남도 거창군 거창읍 강변로157	2026-01-29 23:28:25.250787	35.685603	127.9142081	OFFICIAL	2026-01-29 23:28:25.250793	0	\N
620	경상남도 거창군 거창읍 강변로 35-1	2026-01-29 23:28:25.251385	35.68365935	127.901015	OFFICIAL	2026-01-29 23:28:25.251391	0	\N
621	경상남도 거창군 거창읍 강변로 279	2026-01-29 23:28:25.252082	35.69045411	127.9257556	OFFICIAL	2026-01-29 23:28:25.252088	0	\N
622	경상남도 거창군 거창읍 강변로 19	2026-01-29 23:28:25.252681	35.68352625	127.8993494	OFFICIAL	2026-01-29 23:28:25.252687	0	\N
623	경상남도 거창군 거창읍 강변로 127	2026-01-29 23:28:25.253267	35.68463392	127.9109002	OFFICIAL	2026-01-29 23:28:25.253273	0	\N
624	경상남도 거창군 거창읍 강변로 127	2026-01-29 23:28:25.253869	35.68463392	127.9109002	OFFICIAL	2026-01-29 23:28:25.253875	0	\N
625	경상남도 거창군 거창읍 강남로3길 34	2026-01-29 23:28:25.254409	35.68197849	127.9086104	OFFICIAL	2026-01-29 23:28:25.254414	0	\N
626	경상남도 거창군 거창읍 강남로2길 33-10	2026-01-29 23:28:25.254971	35.6815093	127.9073277	OFFICIAL	2026-01-29 23:28:25.254976	0	\N
627	경상남도 거창군 거창읍 강남로1길 96	2026-01-29 23:28:25.255624	35.68218367	127.9060204	OFFICIAL	2026-01-29 23:28:25.25564	0	\N
628	경상남도 거창군 거창읍 강남로1길 78-10	2026-01-29 23:28:25.256258	35.68159846	127.9048888	OFFICIAL	2026-01-29 23:28:25.256265	0	\N
629	경상남도 거창군 거창읍 강남로1길 67	2026-01-29 23:28:25.256875	35.68213099	127.9043715	OFFICIAL	2026-01-29 23:28:25.256881	0	\N
630	경상남도 거창군 거창읍 강남로1길 53	2026-01-29 23:28:25.25744	35.68237243	127.9036639	OFFICIAL	2026-01-29 23:28:25.257445	0	\N
631	경상남도 거창군 거창읍 강남로1길 49	2026-01-29 23:28:25.258051	35.68239329	127.9035025	OFFICIAL	2026-01-29 23:28:25.258057	0	\N
632	경상남도 거창군 거창읍 강남로1길 41	2026-01-29 23:28:25.258642	35.68230203	127.9029701	OFFICIAL	2026-01-29 23:28:25.25865	0	\N
633	경상남도 거창군 거창읍 강남로1길 158	2026-01-29 23:28:25.259214	35.68259082	127.9092754	OFFICIAL	2026-01-29 23:28:25.259221	0	\N
634	경상남도 거창군 거창읍 강남로 80	2026-01-29 23:28:25.25983	35.68263539	127.906341	OFFICIAL	2026-01-29 23:28:25.259842	0	\N
635	경상남도 거창군 거창읍 강남로 64	2026-01-29 23:28:25.260366	35.68230705	127.9047019	OFFICIAL	2026-01-29 23:28:25.260372	0	\N
636	경상남도 거창군 거창읍 강남로 254-14	2026-01-29 23:28:25.260941	35.68656767	127.9240321	OFFICIAL	2026-01-29 23:28:25.260947	0	\N
637	경상남도 거창군 거창읍 가지리 799-4	2026-01-29 23:28:25.261477	35.71470488	127.8996589	OFFICIAL	2026-01-29 23:28:25.261483	0	\N
638	경상남도 거창군 거창읍 가지리 210	2026-01-29 23:28:25.262059	35.69546019	127.9071036	OFFICIAL	2026-01-29 23:28:25.262065	0	\N
639	경상남도 거창군 가조면 지산로 1386	2026-01-29 23:28:25.262855	35.70165276	128.0193527	OFFICIAL	2026-01-29 23:28:25.262863	0	\N
640	경상남도 거창군 가조면 의상봉길 149	2026-01-29 23:28:25.263641	35.71221677	128.0214844	OFFICIAL	2026-01-29 23:28:25.263647	0	\N
641	경상남도 거창군 가조면 수월리 산19	2026-01-29 23:28:25.26435	35.73662049	128.0408983	OFFICIAL	2026-01-29 23:28:25.264356	0	\N
642	경상남도 거창군 가조면 마상3길 49	2026-01-29 23:28:25.265055	35.71215841	128.0169467	OFFICIAL	2026-01-29 23:28:25.26507	0	\N
643	경상남도 거창군 가조면 마상3길 33-20	2026-01-29 23:28:25.265666	35.71373734	128.0157437	OFFICIAL	2026-01-29 23:28:25.265671	0	\N
644	경상남도 거창군 가조면 도리1길 27	2026-01-29 23:28:25.266466	35.70487646	128.0464976	OFFICIAL	2026-01-29 23:28:25.266471	0	\N
645	경상남도 거창군 주상면 성기리 1378-25	2026-01-29 23:28:25.267105	35.76616711	127.918779	OFFICIAL	2026-01-29 23:28:25.26711	0	\N
646	경상남도 거창군 북상면 월성리 1084-4	2026-01-29 23:28:25.267694	35.76476964	127.7432473	OFFICIAL	2026-01-29 23:28:25.267699	0	\N
647	경상남도 거창군 거창읍 절부길 24-6	2026-01-29 23:28:25.26835	35.68171104	127.8959543	OFFICIAL	2026-01-29 23:28:25.268355	0	\N
648	경상남도 거창군 거창읍 성산길 36	2026-01-29 23:28:25.268942	35.69308263	127.9029092	OFFICIAL	2026-01-29 23:28:25.268947	0	\N
649	경상남도 거창군 거창읍 거열로7길 102	2026-01-29 23:28:25.269521	35.69233266	127.9007139	OFFICIAL	2026-01-29 23:28:25.269526	0	\N
650	경상남도 거창군 거창읍 거열로4길 111	2026-01-29 23:28:25.270055	35.69367675	127.9066828	OFFICIAL	2026-01-29 23:28:25.27006	0	\N
651	경상남도 거창군 거창읍 거열로2길 34-14	2026-01-29 23:28:25.270642	35.69268522	127.9154682	OFFICIAL	2026-01-29 23:28:25.270647	0	\N
652	경상남도 거창군 거창읍 거열로1길 92	2026-01-29 23:28:25.271285	35.69369226	127.9119192	OFFICIAL	2026-01-29 23:28:25.27129	0	\N
653	경상남도 거창군 거창읍 거열로1길 89	2026-01-29 23:28:25.27191	35.69327879	127.9123448	OFFICIAL	2026-01-29 23:28:25.271915	0	\N
654	경상남도 거창군 거창읍 거열로1길 81	2026-01-29 23:28:25.272455	35.69337995	127.9127202	OFFICIAL	2026-01-29 23:28:25.27246	0	\N
655	경상남도 거창군 거창읍 거열로1길 75	2026-01-29 23:28:25.273038	35.69343653	127.9131739	OFFICIAL	2026-01-29 23:28:25.273043	0	\N
656	경상남도 거창군 거창읍 개화2길 26-3	2026-01-29 23:28:25.273607	35.69941373	127.9052914	OFFICIAL	2026-01-29 23:28:25.273612	0	\N
657	부산광역시 연제구 좌수영로 225 부산광역시 연제구 연산동 2317	2026-01-29 23:28:25.274167	35.183774	129.1137205	OFFICIAL	2026-01-29 23:28:25.274172	0	\N
658	부산광역시 연제구 좌수영로 225 부산광역시 연제구 연산동 2317	2026-01-29 23:28:25.274737	35.183774	129.1137205	OFFICIAL	2026-01-29 23:28:25.274742	0	\N
659	부산광역시 연제구 과정로225번길 46 부산광역시 연제구 연산동 378-11	2026-01-29 23:28:25.275346	35.18621999	129.1004919	OFFICIAL	2026-01-29 23:28:25.27535	0	\N
660	부산광역시 연제구 과정로225번길 46 부산광역시 연제구 연산동 378-11	2026-01-29 23:28:25.275933	35.18621999	129.1004919	OFFICIAL	2026-01-29 23:28:25.275938	0	\N
661	부산광역시 연제구 고분로 12 부산광역시 연제구 연산동 731-2	2026-01-29 23:28:25.276468	35.1856702	129.0835701	OFFICIAL	2026-01-29 23:28:25.276473	0	\N
662	부산광역시 연제구 고분로 12 부산광역시 연제구 연산동 731-2	2026-01-29 23:28:25.277049	35.1856702	129.0835701	OFFICIAL	2026-01-29 23:28:25.277053	0	\N
663	부산광역시 연제구 월드컵대로 54 부산광역시 연제구 연산동 686-4	2026-01-29 23:28:25.277586	35.1793063	129.0848871	OFFICIAL	2026-01-29 23:28:25.277593	0	\N
664	부산광역시 연제구 월드컵대로 54 부산광역시 연제구 연산동 686-4	2026-01-29 23:28:25.278173	35.1793063	129.0848871	OFFICIAL	2026-01-29 23:28:25.278178	0	\N
665	부산광역시 연제구 연수로 96-1 부산광역시 연제구 연산동 844-56	2026-01-29 23:28:25.278793	35.17514394	129.0813938	OFFICIAL	2026-01-29 23:28:25.2788	0	\N
666	부산광역시 연제구 연수로 96-1 부산광역시 연제구 연산동 844-56	2026-01-29 23:28:25.279369	35.17514394	129.0813938	OFFICIAL	2026-01-29 23:28:25.279373	0	\N
667	부산광역시 연제구 연수로 177 부산광역시 연제구 연산동 1867-1	2026-01-29 23:28:25.279933	35.1743178	129.0901318	OFFICIAL	2026-01-29 23:28:25.279937	0	\N
668	부산광역시 연제구 연수로 177 부산광역시 연제구 연산동 1867-1	2026-01-29 23:28:25.28053	35.1743178	129.0901318	OFFICIAL	2026-01-29 23:28:25.280534	0	\N
669	부산광역시 연제구 과정로 139-1 부산광역시 연제구 연산동 479-5	2026-01-29 23:28:25.281099	35.18391929	129.1069265	OFFICIAL	2026-01-29 23:28:25.281104	0	\N
670	부산광역시 연제구 과정로 139-1 부산광역시 연제구 연산동 479-5	2026-01-29 23:28:25.281653	35.18391929	129.1069265	OFFICIAL	2026-01-29 23:28:25.281658	0	\N
671	부산광역시 연제구 과정로 171 부산광역시 연제구 연산동 418-20	2026-01-29 23:28:25.282288	35.18669688	129.1069954	OFFICIAL	2026-01-29 23:28:25.282293	0	\N
672	부산광역시 연제구 과정로 171 부산광역시 연제구 연산동 418-20	2026-01-29 23:28:25.282907	35.18669688	129.1069954	OFFICIAL	2026-01-29 23:28:25.282912	0	\N
673	부산광역시 연제구 과정로 232-1 부산광역시 연제구 연산동 399-11	2026-01-29 23:28:25.283537	35.1878504	129.1018541	OFFICIAL	2026-01-29 23:28:25.283542	0	\N
674	부산광역시 연제구 과정로 232-1 부산광역시 연제구 연산동 399-11	2026-01-29 23:28:25.284132	35.1878504	129.1018541	OFFICIAL	2026-01-29 23:28:25.284136	0	\N
675	부산광역시 연제구 법원로 15 부산광역시 연제구 거제동 1501	2026-01-29 23:28:25.284705	35.19140319	129.0719757	OFFICIAL	2026-01-29 23:28:25.28471	0	\N
676	부산광역시 연제구 법원로 15 부산광역시 연제구 거제동 1501	2026-01-29 23:28:25.285319	35.19140319	129.0719757	OFFICIAL	2026-01-29 23:28:25.285324	0	\N
677	부산광역시 연제구 법원북로 34 부산광역시 연제구 거제동 1481	2026-01-29 23:28:25.285981	35.19242972	129.0711214	OFFICIAL	2026-01-29 23:28:25.285987	0	\N
678	부산광역시 연제구 법원북로 34 부산광역시 연제구 거제동 1481	2026-01-29 23:28:25.286531	35.19242972	129.0711214	OFFICIAL	2026-01-29 23:28:25.286536	0	\N
679	부산광역시 연제구 종합운동장로 28 부산광역시 연제구 거제동 897-24	2026-01-29 23:28:25.287066	35.1930722	129.0647759	OFFICIAL	2026-01-29 23:28:25.287071	0	\N
680	부산광역시 연제구 종합운동장로 28 부산광역시 연제구 거제동 897-24	2026-01-29 23:28:25.287652	35.1930722	129.0647759	OFFICIAL	2026-01-29 23:28:25.287658	0	\N
681	부산광역시 연제구 월드컵대로 242 부산광역시 연제구 거제동 1044-29	2026-01-29 23:28:25.288204	35.1902413	129.070924	OFFICIAL	2026-01-29 23:28:25.288209	0	\N
682	부산광역시 연제구 월드컵대로 242 부산광역시 연제구 거제동 1044-29	2026-01-29 23:28:25.288735	35.1902413	129.070924	OFFICIAL	2026-01-29 23:28:25.28874	0	\N
683	부산광역시 연제구 거제대로 123 부산광역시 연제구 거제동 676-1	2026-01-29 23:28:25.289522	35.18117042	129.0689964	OFFICIAL	2026-01-29 23:28:25.289527	0	\N
684	부산광역시 연제구 거제대로 123 부산광역시 연제구 거제동 676-1	2026-01-29 23:28:25.290099	35.18117042	129.0689964	OFFICIAL	2026-01-29 23:28:25.290104	0	\N
685	부산광역시 연제구 과정로114번길 18-22 부산광역시 연제구 연산동117-30	2026-01-29 23:28:25.290645	35.18057556	129.1081694	OFFICIAL	2026-01-29 23:28:25.29065	0	\N
686	부산광역시 연제구 과정로114번길 18-22 부산광역시 연제구 연산동117-30	2026-01-29 23:28:25.291187	35.18057556	129.1081694	OFFICIAL	2026-01-29 23:28:25.291191	0	\N
687	부산광역시 연제구 과정로 191 부산광역시 연제구 연산동 405-10	2026-01-29 23:28:25.291773	35.18765939	129.1062969	OFFICIAL	2026-01-29 23:28:25.291777	0	\N
688	부산광역시 연제구 과정로 191 부산광역시 연제구 연산동 405-10	2026-01-29 23:28:25.292317	35.18765939	129.1062969	OFFICIAL	2026-01-29 23:28:25.292322	0	\N
689	부산광역시 연제구 과정로 286 부산광역시 연제구 연산동 367-28	2026-01-29 23:28:25.292897	35.1884096	129.0962733	OFFICIAL	2026-01-29 23:28:25.292902	0	\N
690	부산광역시 연제구 과정로 286 부산광역시 연제구 연산동 367-28	2026-01-29 23:28:25.293449	35.1884096	129.0962733	OFFICIAL	2026-01-29 23:28:25.293454	0	\N
691	부산광역시 연제구 반송로 88 부산광역시 연제구 연산동 105-1	2026-01-29 23:28:25.294022	35.19095872	129.0893311	OFFICIAL	2026-01-29 23:28:25.294027	0	\N
692	부산광역시 연제구 반송로 88 부산광역시 연제구 연산동 105-1	2026-01-29 23:28:25.294598	35.19095872	129.0893311	OFFICIAL	2026-01-29 23:28:25.294602	0	\N
693	부산광역시 연제구 반송로 46 부산광역시 연제구 연산동 590-49	2026-01-29 23:28:25.295158	35.1887023	129.0853514	OFFICIAL	2026-01-29 23:28:25.295163	0	\N
694	부산광역시 연제구 반송로 46 부산광역시 연제구 연산동 590-49	2026-01-29 23:28:25.295728	35.1887023	129.0853514	OFFICIAL	2026-01-29 23:28:25.295732	0	\N
695	부산광역시 연제구 반송로 17 부산광역시 연제구 연산동 723-29	2026-01-29 23:28:25.296311	35.18719468	129.0827007	OFFICIAL	2026-01-29 23:28:25.29632	0	\N
696	부산광역시 연제구 반송로 17 부산광역시 연제구 연산동 723-29	2026-01-29 23:28:25.296925	35.18719468	129.0827007	OFFICIAL	2026-01-29 23:28:25.29693	0	\N
697	부산광역시 연제구 연수로 224 부산광역시 연제구 연산동 1800-10	2026-01-29 23:28:25.297474	35.17336052	129.0951632	OFFICIAL	2026-01-29 23:28:25.297479	0	\N
698	부산광역시 연제구 연수로 224 부산광역시 연제구 연산동 1800-10	2026-01-29 23:28:25.298038	35.17336052	129.0951632	OFFICIAL	2026-01-29 23:28:25.298042	0	\N
699	부산광역시 연제구 연수로 109-1 부산광역시 연제구 연산동 822-39	2026-01-29 23:28:25.298611	35.17531	129.0829234	OFFICIAL	2026-01-29 23:28:25.298616	0	\N
700	부산광역시 연제구 연수로 109-1 부산광역시 연제구 연산동 822-39	2026-01-29 23:28:25.299303	35.17531	129.0829234	OFFICIAL	2026-01-29 23:28:25.29931	0	\N
701	부산광역시 연제구 종합운동장로 7 부산광역시 연제구 거제동 1208	2026-01-29 23:28:25.299951	35.19126734	129.0620086	OFFICIAL	2026-01-29 23:28:25.299956	0	\N
702	부산광역시 연제구 종합운동장로 7 부산광역시 연제구 거제동 1208	2026-01-29 23:28:25.300548	35.19126734	129.0620086	OFFICIAL	2026-01-29 23:28:25.300553	0	\N
703	부산광역시 연제구 월드컵대로 115 부산광역시 연제구 연산동 709-2	2026-01-29 23:28:25.301114	35.1845909	129.0821782	OFFICIAL	2026-01-29 23:28:25.301119	0	\N
704	부산광역시 연제구 월드컵대로 115 부산광역시 연제구 연산동 709-2	2026-01-29 23:28:25.301659	35.1845909	129.0821782	OFFICIAL	2026-01-29 23:28:25.301664	0	\N
705	부산광역시 연제구 거제대로 248 부산광역시 연제구 거제동 18-54	2026-01-29 23:28:25.30228	35.1891273	129.0752595	OFFICIAL	2026-01-29 23:28:25.302286	0	\N
706	부산광역시 연제구 거제대로 248 부산광역시 연제구 거제동 18-54	2026-01-29 23:28:25.30286	35.1891273	129.0752595	OFFICIAL	2026-01-29 23:28:25.302865	0	\N
707	부산광역시 연제구 거제대로 160 부산광역시 연제구 거제동 585-35	2026-01-29 23:28:25.303399	35.18249618	129.0704417	OFFICIAL	2026-01-29 23:28:25.303404	0	\N
708	부산광역시 연제구 거제대로 160 부산광역시 연제구 거제동 585-35	2026-01-29 23:28:25.303995	35.18249618	129.0704417	OFFICIAL	2026-01-29 23:28:25.304	0	\N
709	부산광역시 연제구 월드컵대로 149 부산광역시 연제구 연산동 1241-5	2026-01-29 23:28:25.304586	35.18641176	129.0798929	OFFICIAL	2026-01-29 23:28:25.304591	0	\N
710	부산광역시 연제구 월드컵대로 149 부산광역시 연제구 연산동 1241-5	2026-01-29 23:28:25.305143	35.18641176	129.0798929	OFFICIAL	2026-01-29 23:28:25.305147	0	\N
711	부산광역시 연제구 월드컵대로 144 부산광역시 연제구 연산동 1126-12	2026-01-29 23:28:25.305674	35.18667156	129.0806527	OFFICIAL	2026-01-29 23:28:25.305678	0	\N
712	부산광역시 연제구 월드컵대로 144 부산광역시 연제구 연산동 1126-12	2026-01-29 23:28:25.306251	35.18667156	129.0806527	OFFICIAL	2026-01-29 23:28:25.306256	0	\N
713	부산광역시 연제구 월드컵대로 2 부산광역시 연제구 연산동 1916-10	2026-01-29 23:28:25.306839	35.17504688	129.0867222	OFFICIAL	2026-01-29 23:28:25.306844	0	\N
714	부산광역시 연제구 월드컵대로 2 부산광역시 연제구 연산동 1916-10	2026-01-29 23:28:25.307409	35.17504688	129.0867222	OFFICIAL	2026-01-29 23:28:25.307414	0	\N
715	부산광역시 연제구 법원남로9번길 17 부산광역시 연제구 거제동 419-2	2026-01-29 23:28:25.307994	35.18951105	129.0742898	OFFICIAL	2026-01-29 23:28:25.307999	0	\N
716	부산광역시 연제구 법원남로9번길 17 부산광역시 연제구 거제동 419-2	2026-01-29 23:28:25.30852	35.18951105	129.0742898	OFFICIAL	2026-01-29 23:28:25.308525	0	\N
717	부산광역시 연제구 연제로 21 부산광역시 연제구 연산동 862	2026-01-29 23:28:25.309124	35.17684154	129.0770534	OFFICIAL	2026-01-29 23:28:25.309129	0	\N
718	부산광역시 연제구 연수로 184 부산광역시 연제구 연산동 1873-70	2026-01-29 23:28:25.309679	35.17364431	129.0909816	OFFICIAL	2026-01-29 23:28:25.309684	0	\N
719	부산광역시 연제구 연수로 184 부산광역시 연제구 연산동 1873-70	2026-01-29 23:28:25.310273	35.17364431	129.0909816	OFFICIAL	2026-01-29 23:28:25.310278	0	\N
720	부산광역시 연제구 과정로 152 부산광역시 연제구 연산동 478-8	2026-01-29 23:28:25.310868	35.1850904	129.1074467	OFFICIAL	2026-01-29 23:28:25.310873	0	\N
721	부산광역시 연제구 과정로 152 부산광역시 연제구 연산동 478-8	2026-01-29 23:28:25.311436	35.1850904	129.1074467	OFFICIAL	2026-01-29 23:28:25.311441	0	\N
722	부산광역시 연제구 과정로 265 부산광역시 연제구 연산동 380-1	2026-01-29 23:28:25.312039	35.1877514	129.0981464	OFFICIAL	2026-01-29 23:28:25.312044	0	\N
723	부산광역시 연제구 과정로 265 부산광역시 연제구 연산동 380-1	2026-01-29 23:28:25.312602	35.1877514	129.0981464	OFFICIAL	2026-01-29 23:28:25.312607	0	\N
724	부산광역시 연제구 거제대로214번길 6 부산광역시 연제구 거제동 38-45	2026-01-29 23:28:25.313171	35.18679429	129.0743716	OFFICIAL	2026-01-29 23:28:25.313176	0	\N
725	부산광역시 연제구 거제대로214번길 6 부산광역시 연제구 거제동 38-45	2026-01-29 23:28:25.313712	35.18679429	129.0743716	OFFICIAL	2026-01-29 23:28:25.313717	0	\N
726	부산광역시 연제구 법원북로 16 부산광역시 연제구 거제동 1479	2026-01-29 23:28:25.314261	35.19254721	129.0681338	OFFICIAL	2026-01-29 23:28:25.314266	0	\N
727	부산광역시 연제구 법원북로 16 부산광역시 연제구 거제동 1479	2026-01-29 23:28:25.31485	35.19254721	129.0681338	OFFICIAL	2026-01-29 23:28:25.314855	0	\N
728	부산광역시 연제구 아시아드대로 12 부산광역시 연제구 거제동 878-7	2026-01-29 23:28:25.315381	35.18661543	129.0703432	OFFICIAL	2026-01-29 23:28:25.315385	0	\N
729	부산광역시 연제구 아시아드대로 12 부산광역시 연제구 거제동 878-7	2026-01-29 23:28:25.315951	35.18661543	129.0703432	OFFICIAL	2026-01-29 23:28:25.315956	0	\N
730	부산광역시 연제구 과정로 221 부산광역시 연제구 연산동 406-34	2026-01-29 23:28:25.3166	35.18753326	129.1030778	OFFICIAL	2026-01-29 23:28:25.316606	0	\N
731	부산광역시 연제구 과정로 221 부산광역시 연제구 연산동 406-34	2026-01-29 23:28:25.317171	35.18753326	129.1030778	OFFICIAL	2026-01-29 23:28:25.317177	0	\N
732	부산광역시 연제구 과정로 340 부산광역시 연제구 연산동 307-40	2026-01-29 23:28:25.317697	35.1905374	129.0909692	OFFICIAL	2026-01-29 23:28:25.317702	0	\N
733	부산광역시 연제구 과정로 340 부산광역시 연제구 연산동 307-40	2026-01-29 23:28:25.318284	35.1905374	129.0909692	OFFICIAL	2026-01-29 23:28:25.318289	0	\N
734	부산광역시 연제구 고분로 170 부산광역시 연제구 연산동 277-4	2026-01-29 23:28:25.318869	35.18542933	129.1009589	OFFICIAL	2026-01-29 23:28:25.318873	0	\N
735	부산광역시 연제구 고분로 170 부산광역시 연제구 연산동 277-4	2026-01-29 23:28:25.319435	35.18542933	129.1009589	OFFICIAL	2026-01-29 23:28:25.31944	0	\N
736	부산광역시 연제구 반송로 89 부산광역시 연제구 연산동 582-1	2026-01-29 23:28:25.320003	35.19153806	129.0882804	OFFICIAL	2026-01-29 23:28:25.320007	0	\N
737	부산광역시 연제구 반송로 89 부산광역시 연제구 연산동 582-1	2026-01-29 23:28:25.320941	35.19153806	129.0882804	OFFICIAL	2026-01-29 23:28:25.320948	0	\N
738	부산광역시 연제구 반송로 14 부산광역시 연제구 연산동 728-2	2026-01-29 23:28:25.321557	35.18678236	129.0828604	OFFICIAL	2026-01-29 23:28:25.321562	0	\N
739	부산광역시 연제구 반송로 14 부산광역시 연제구 연산동 728-2	2026-01-29 23:28:25.322139	35.18678236	129.0828604	OFFICIAL	2026-01-29 23:28:25.322143	0	\N
740	부산광역시 연제구 연수로 225 부산광역시 연제구 연산동 2121-16	2026-01-29 23:28:25.322696	35.1736676	129.0954932	OFFICIAL	2026-01-29 23:28:25.322701	0	\N
741	부산광역시 연제구 연수로 225 부산광역시 연제구 연산동 2121-16	2026-01-29 23:28:25.323311	35.1736676	129.0954932	OFFICIAL	2026-01-29 23:28:25.323316	0	\N
742	부산광역시 연제구 거제대로 123 부산광역시 연제구 거제동 676-1	2026-01-29 23:28:25.32387	35.18117042	129.0689964	OFFICIAL	2026-01-29 23:28:25.323875	0	\N
743	부산광역시 연제구 거제대로 123 부산광역시 연제구 거제동 676-1	2026-01-29 23:28:25.324397	35.18117042	129.0689964	OFFICIAL	2026-01-29 23:28:25.324402	0	\N
744	서울특별시 중랑구 겸재로253-1 서울특별시 중랑구 망우동 526-32	2026-01-29 23:28:25.32494	37.59052839	127.095694	OFFICIAL	2026-01-29 23:28:25.324945	0	\N
745	서울특별시 중랑구 봉우재로70길 96 서울특별시 중랑구 망우동 530-3	2026-01-29 23:28:25.32552	37.59139552	127.0967468	OFFICIAL	2026-01-29 23:28:25.325524	0	\N
746	서울특별시 중랑구 겸재로 261 서울특별시 중랑구 망우동 526-2	2026-01-29 23:28:25.326082	37.59075471	127.0966074	OFFICIAL	2026-01-29 23:28:25.326089	0	\N
747	서울특별시 중랑구 봉우재로 240 서울특별시 중랑구 망우동 458-3	2026-01-29 23:28:25.326647	37.59530807	127.0993721	OFFICIAL	2026-01-29 23:28:25.326651	0	\N
748	서울특별시 중랑구 봉우재로 234 서울특별시 중랑구 망우동 460-1	2026-01-29 23:28:25.327202	37.59516913	127.0988755	OFFICIAL	2026-01-29 23:28:25.327207	0	\N
749	서울특별시 중랑구 용마산로96길 33 서울특별시 중랑구 망우동 437-18	2026-01-29 23:28:25.327785	37.59005416	127.0992655	OFFICIAL	2026-01-29 23:28:25.327792	0	\N
750	서울특별시 중랑구 용마산로 488 서울특별시 중랑구 망우동 410-8	2026-01-29 23:28:25.32831	37.59448255	127.0998237	OFFICIAL	2026-01-29 23:28:25.328315	0	\N
751	서울특별시 중랑구 용마산로 441 서울특별시 중랑구 망우동 531-4	2026-01-29 23:28:25.328885	37.59084116	127.0973084	OFFICIAL	2026-01-29 23:28:25.328889	0	\N
752	서울특별시 중랑구 상봉로 78 서울특별시 중랑구 망우동 479-77	2026-01-29 23:28:25.329514	37.5928309	127.0935702	OFFICIAL	2026-01-29 23:28:25.329519	0	\N
753	서울특별시 중랑구 상봉로 76 서울특별시 중랑구 망우동 477-56	2026-01-29 23:28:25.330045	37.59260575	127.0935843	OFFICIAL	2026-01-29 23:28:25.33005	0	\N
754	서울특별시 중랑구 상봉로 76 서울특별시 중랑구 망우동 477-56	2026-01-29 23:28:25.330594	37.59260575	127.0935843	OFFICIAL	2026-01-29 23:28:25.330598	0	\N
755	서울특별시 중랑구 용마산로 494 서울특별시 중랑구 망우동 410-1	2026-01-29 23:28:25.331123	37.59497252	127.1002707	OFFICIAL	2026-01-29 23:28:25.331128	0	\N
756	서울특별시 중랑구 용마산로 480 서울특별시 중랑구 망우동 411-3	2026-01-29 23:28:25.331713	37.59374966	127.0994248	OFFICIAL	2026-01-29 23:28:25.331717	0	\N
757	서울특별시 중랑구 용마산로 448 서울특별시 중랑구 망우동 442-21	2026-01-29 23:28:25.332329	37.59115319	127.098052	OFFICIAL	2026-01-29 23:28:25.332335	0	\N
758	서울특별시 중랑구 용마공원로2길 7 서울특별시 중랑구 망우동 409-23	2026-01-29 23:28:25.332909	37.59450582	127.1005141	OFFICIAL	2026-01-29 23:28:25.332914	0	\N
759	서울특별시 중랑구 용마공원로 455	2026-01-29 23:28:25.333472	37.59274083	127.1018376	OFFICIAL	2026-01-29 23:28:25.333477	0	\N
760	서울특별시 중랑구 용마산로99길 9 서울특별시 중랑구 망우동 531-24	2026-01-29 23:28:25.334068	37.59187831	127.0974317	OFFICIAL	2026-01-29 23:28:25.334073	0	\N
761	서울특별시 중랑구 망우로 530-2	2026-01-29 23:28:25.334636	37.59733286	127.0907978	OFFICIAL	2026-01-29 23:28:25.33464	0	\N
762	서울특별시 중랑구 겸재로 263 서울특별시 중랑구 망우동 531-35	2026-01-29 23:28:25.335262	37.59066591	127.0967783	OFFICIAL	2026-01-29 23:28:25.335267	0	\N
763	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.335848	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.335853	0	\N
764	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.33642	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.336424	0	\N
765	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.336973	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.336977	0	\N
766	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.33751	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.337515	0	\N
767	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.338065	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.33807	0	\N
768	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.338983	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.338991	0	\N
769	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.340009	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.340014	0	\N
770	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.34084	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.340846	0	\N
771	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.341429	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.341435	0	\N
772	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.342035	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.342041	0	\N
773	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.342561	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.342566	0	\N
774	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.34309	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.343095	0	\N
775	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.34381	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.343818	0	\N
776	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.344356	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.344361	0	\N
777	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.344934	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.344939	0	\N
778	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.345506	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.345512	0	\N
779	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.346094	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.346099	0	\N
780	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.346883	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.346888	0	\N
781	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.347415	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.34742	0	\N
782	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.347965	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.34797	0	\N
783	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.348667	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.348674	0	\N
784	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.349308	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.349314	0	\N
785	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.349913	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.349918	0	\N
786	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.350497	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.350502	0	\N
787	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.351063	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.351068	0	\N
788	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.351636	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.351641	0	\N
789	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.352197	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.352202	0	\N
790	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.352897	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.352905	0	\N
791	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.353555	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.353561	0	\N
792	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.354164	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.35417	0	\N
793	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.354737	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.354742	0	\N
794	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.355321	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.355326	0	\N
795	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.355892	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.355897	0	\N
796	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.356431	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.356436	0	\N
797	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.356994	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.356999	0	\N
798	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.357563	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.357568	0	\N
799	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.358102	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.358107	0	\N
800	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.358687	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.358691	0	\N
801	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.359277	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.359282	0	\N
802	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.359886	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.359891	0	\N
803	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.360394	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.360399	0	\N
804	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.360911	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.360916	0	\N
805	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.361402	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.361407	0	\N
806	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.362011	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.362016	0	\N
807	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.362564	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.362569	0	\N
808	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.363101	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.363106	0	\N
809	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.363643	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.363648	0	\N
810	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.36423	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.364234	0	\N
811	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.364808	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.364813	0	\N
812	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.365322	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.365327	0	\N
813	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.365878	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.365883	0	\N
814	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.366375	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.36638	0	\N
815	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.36692	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.366925	0	\N
816	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.367453	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.367457	0	\N
817	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.368078	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.368083	0	\N
818	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.368628	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.368633	0	\N
819	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.369128	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.369133	0	\N
820	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.369676	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.369681	0	\N
821	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.37023	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.370235	0	\N
822	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.370844	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.370849	0	\N
823	서울특별시 중랑구 상봉동	2026-01-29 23:28:25.371401	37.59412924	127.0843255	OFFICIAL	2026-01-29 23:28:25.371405	0	\N
824	서울특별시 중랑구 상봉동	2026-01-29 23:28:25.371971	37.59412924	127.0843255	OFFICIAL	2026-01-29 23:28:25.371976	0	\N
825	서울특별시 중랑구 상봉동	2026-01-29 23:28:25.372509	37.59412924	127.0843255	OFFICIAL	2026-01-29 23:28:25.372513	0	\N
826	서울특별시 중랑구 상봉동	2026-01-29 23:28:25.373044	37.59412924	127.0843255	OFFICIAL	2026-01-29 23:28:25.373049	0	\N
827	서울특별시 중랑구 상봉동	2026-01-29 23:28:25.373586	37.59412924	127.0843255	OFFICIAL	2026-01-29 23:28:25.373591	0	\N
828	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.374136	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.374141	0	\N
829	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.374636	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.37464	0	\N
830	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.375193	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.375198	0	\N
831	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.375796	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.375807	0	\N
832	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.376334	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.376338	0	\N
833	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.37691	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.376914	0	\N
834	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.377462	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.377467	0	\N
835	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.378014	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.378019	0	\N
836	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.37855	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.378554	0	\N
837	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.379086	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.37909	0	\N
838	서울특별시 중랑구 겸재로	2026-01-29 23:28:25.379599	37.58822911	127.0868774	OFFICIAL	2026-01-29 23:28:25.379604	0	\N
839	서울특별시 중랑구 상봉로 134 서울특별시 중랑구 망우동 564-5	2026-01-29 23:28:25.380278	37.59806114	127.0932713	OFFICIAL	2026-01-29 23:28:25.380284	0	\N
840	서울특별시 중랑구 상봉로 134 서울특별시 중랑구 망우동 564-5	2026-01-29 23:28:25.380881	37.59806114	127.0932713	OFFICIAL	2026-01-29 23:28:25.380885	0	\N
841	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.381431	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.381436	0	\N
842	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.383083	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.383088	0	\N
843	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.383639	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.383644	0	\N
844	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.384201	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.384206	0	\N
845	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.384741	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.384746	0	\N
846	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.385307	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.385311	0	\N
847	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.385879	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.385883	0	\N
848	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.386417	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.386422	0	\N
849	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.386989	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.386994	0	\N
850	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.387531	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.387535	0	\N
851	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.388078	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.388083	0	\N
852	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.388607	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.388611	0	\N
853	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.389257	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.389263	0	\N
854	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.389859	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.389865	0	\N
855	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.390444	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.390449	0	\N
856	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.391046	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.391051	0	\N
857	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.391672	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.391679	0	\N
858	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.392301	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.392306	0	\N
859	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.392923	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.392929	0	\N
860	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.393479	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.393484	0	\N
861	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.394074	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.394079	0	\N
862	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.394656	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.394661	0	\N
863	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.395268	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.395272	0	\N
864	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.39582	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.395825	0	\N
865	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.398012	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.398019	0	\N
866	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.398612	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.398618	0	\N
867	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.3992	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.399206	0	\N
868	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.399884	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.399889	0	\N
869	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.400417	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.400422	0	\N
870	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.401062	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.401067	0	\N
871	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.401636	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.401641	0	\N
872	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.402194	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.4022	0	\N
873	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.40278	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.402785	0	\N
874	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.4033	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.403305	0	\N
875	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.403874	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.403879	0	\N
876	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.404403	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.404407	0	\N
877	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.404966	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.404971	0	\N
878	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.405487	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.405492	0	\N
879	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.406038	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.406043	0	\N
880	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.406614	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.406619	0	\N
881	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.407169	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.407174	0	\N
882	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.407719	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.407724	0	\N
883	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.408269	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.408274	0	\N
884	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.408845	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.40885	0	\N
885	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.409367	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.409371	0	\N
886	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.410042	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.410047	0	\N
887	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.410609	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.410615	0	\N
888	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.411247	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.411253	0	\N
889	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.411853	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.411858	0	\N
890	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.412373	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.412378	0	\N
891	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.413004	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.413009	0	\N
892	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.413651	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.413656	0	\N
893	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.414217	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.414224	0	\N
894	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.414785	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.41479	0	\N
895	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.415304	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.415309	0	\N
896	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.416006	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.416011	0	\N
897	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.418409	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.418414	0	\N
898	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.419014	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.41902	0	\N
899	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.419553	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.419558	0	\N
900	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.42009	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.420096	0	\N
901	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.420585	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.42059	0	\N
902	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.421108	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.421113	0	\N
903	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.421606	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.421611	0	\N
904	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.422202	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.422207	0	\N
905	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.422708	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.422714	0	\N
906	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.423298	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.423303	0	\N
907	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.423804	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.42381	0	\N
908	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.424305	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.424311	0	\N
909	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.424842	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.424847	0	\N
910	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.42534	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.425345	0	\N
911	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.425903	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.425909	0	\N
912	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.42643	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.426435	0	\N
913	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.426976	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.426981	0	\N
914	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.427543	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.427549	0	\N
915	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.428101	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.428106	0	\N
916	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.428619	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.428624	0	\N
917	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.429163	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.429177	0	\N
918	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.429657	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.429663	0	\N
919	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.430189	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.430195	0	\N
920	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.430712	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.430717	0	\N
921	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.431244	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.431249	0	\N
922	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.431776	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.431781	0	\N
923	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.432265	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.43227	0	\N
924	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.432742	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.432771	0	\N
925	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.433255	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.433261	0	\N
926	서울특별시 중랑구 사가정로49길 56 서울특별시 중랑구 면목동 570	2026-01-29 23:28:25.433729	37.58350833	127.086969	OFFICIAL	2026-01-29 23:28:25.433735	0	\N
927	서울특별시 중랑구 사가정로49길 56 서울특별시 중랑구 면목동 570	2026-01-29 23:28:25.434256	37.58350833	127.086969	OFFICIAL	2026-01-29 23:28:25.434261	0	\N
928	서울특별시 중랑구 면목동 396-1	2026-01-29 23:28:25.434795	37.5909884	127.0755544	OFFICIAL	2026-01-29 23:28:25.4348	0	\N
929	서울특별시 중랑구 겸재로 120-1 서울특별시 중랑구 면목동 150-16	2026-01-29 23:28:25.435276	37.58672569	127.0812344	OFFICIAL	2026-01-29 23:28:25.435281	0	\N
930	부산광역시 사상구 모라로192번길 21 부산광역시 사상구 모라동 75-9	2026-01-29 23:28:25.435866	35.1848992	129.0009312	OFFICIAL	2026-01-29 23:28:25.435871	0	\N
931	부산광역시 사상구 학감대로 242 부산광역시 사상구 감전동138-8	2026-01-29 23:28:25.4364	35.15255072	128.9914561	OFFICIAL	2026-01-29 23:28:25.436405	0	\N
932	서울특별시 성북구 하월곡동22-13	2026-01-29 23:28:25.436962	37.60416814	127.042325	OFFICIAL	2026-01-29 23:28:25.436966	0	\N
933	서울특별시 성북구 동소문로 305-1 서울특별시 성북구 길음동 510-173	2026-01-29 23:28:25.437535	37.607487	127.0283683	OFFICIAL	2026-01-29 23:28:25.437541	0	\N
934	서울특별시 성북구 길음로 74 서울특별시 성북구 길음동 1282	2026-01-29 23:28:25.438153	37.60928966	127.0210339	OFFICIAL	2026-01-29 23:28:25.438158	0	\N
935	서울특별시 성북구 보문로 39길 4 서울특별시 성북구 동소문동3가 82	2026-01-29 23:28:25.438725	37.59143108	127.0132624	OFFICIAL	2026-01-29 23:28:25.43873	0	\N
936	서울특별시 성북구 보문로 192 서울특별시 성북구 삼선동4가 349-1	2026-01-29 23:28:25.43931	37.59086591	127.0146551	OFFICIAL	2026-01-29 23:28:25.439315	0	\N
937	서울특별시 성북구 보문로 190 서울특별시 성북구 삼선동4가 349-1	2026-01-29 23:28:25.439947	37.59086591	127.0146551	OFFICIAL	2026-01-29 23:28:25.439952	0	\N
938	서울특별시 성북구 보문로 78 서울특별시 성북구 보문동4가 77-2	2026-01-29 23:28:25.440524	37.58228095	127.0213065	OFFICIAL	2026-01-29 23:28:25.440529	0	\N
939	충청남도 홍성군 홍성읍 오관리 556-2	2026-01-29 23:28:25.441059	36.59437926	126.6663975	OFFICIAL	2026-01-29 23:28:25.441064	0	\N
940	충청남도 홍성군 홍성읍 오관리 877	2026-01-29 23:28:25.443266	36.60330902	126.6594567	OFFICIAL	2026-01-29 23:28:25.443271	0	\N
941	충청남도 홍성군 홍성읍 내법리430-1	2026-01-29 23:28:25.443855	36.61701642	126.6697058	OFFICIAL	2026-01-29 23:28:25.44386	0	\N
942	충청남도 홍성군 홍성읍 고암리907-3	2026-01-29 23:28:25.444418	36.59868139	126.6715522	OFFICIAL	2026-01-29 23:28:25.444423	0	\N
943	충청남도 홍성군 홍성읍 옥암리899-18	2026-01-29 23:28:25.445047	36.59612806	126.6577392	OFFICIAL	2026-01-29 23:28:25.445053	0	\N
944	충청남도 홍성군 홍성읍 오관리595-2	2026-01-29 23:28:25.445674	36.59814721	126.6587952	OFFICIAL	2026-01-29 23:28:25.445679	0	\N
945	충청남도 홍성군 홍성읍 오관리472-1	2026-01-29 23:28:25.446256	36.59771	126.663	OFFICIAL	2026-01-29 23:28:25.446261	0	\N
946	경기도 군포시 산본천로 111	2026-01-29 23:28:25.446847	37.3646456	126.9342455	OFFICIAL	2026-01-29 23:28:25.446852	0	\N
947	경기도 군포시 용호2로 10 경기도 군포시 당동 976	2026-01-29 23:28:25.447364	37.34225732	126.9382071	OFFICIAL	2026-01-29 23:28:25.447369	0	\N
948	경기도 군포시 군포로 211, (군포시보건소 버스정류소)	2026-01-29 23:28:25.447922	37.33252109	126.9251121	OFFICIAL	2026-01-29 23:28:25.447928	0	\N
949	경기도 군포시 번영로 382, (오금동우체국 앞)	2026-01-29 23:28:25.448514	37.34945226	126.9259671	OFFICIAL	2026-01-29 23:28:25.448519	0	\N
950	경기도 군포시 금산로 91 경기도 군포시 산본동 1256	2026-01-29 23:28:25.449103	37.36808061	126.9366772	OFFICIAL	2026-01-29 23:28:25.449108	0	\N
951	경기도 군포시 산본천로 224-1, (버스정류소)	2026-01-29 23:28:25.449633	37.37161944	126.9421677	OFFICIAL	2026-01-29 23:28:25.449638	0	\N
952	경기도 군포시 번영로 385 경기도 군포시 산본동 1235	2026-01-29 23:28:25.450189	37.35112222	126.9261472	OFFICIAL	2026-01-29 23:28:25.450194	0	\N
953	경기도 군포시 당정역로4번길 20 경기도 군포시 당정동 1027	2026-01-29 23:28:25.450791	37.34291703	126.9504755	OFFICIAL	2026-01-29 23:28:25.450796	0	\N
954	경기도 군포시 용호2로54번길 40 경기도 군포시 당정동 753	2026-01-29 23:28:25.451319	37.34421631	126.9479349	OFFICIAL	2026-01-29 23:28:25.451324	0	\N
955	경기도 군포시 군포로534번길 19, (군포역 1번 출구 앞 택시승강장 부근)	2026-01-29 23:28:25.4519	37.35374466	126.9477314	OFFICIAL	2026-01-29 23:28:25.451905	0	\N
956	경기도 군포시 군포로 524	2026-01-29 23:28:25.452436	37.35281178	126.9458221	OFFICIAL	2026-01-29 23:28:25.452441	0	\N
957	경기도 군포시 고산로 262, (새마을금고 앞)	2026-01-29 23:28:25.453017	37.34676637	126.9436033	OFFICIAL	2026-01-29 23:28:25.453022	0	\N
958	경기도 군포시 산본로 339, (군포시청 건너편 버스정류소)	2026-01-29 23:28:25.453833	37.36060833	126.9325882	OFFICIAL	2026-01-29 23:28:25.453838	0	\N
959	경기도 군포시 산본로 328, (군포우체국 앞)	2026-01-29 23:28:25.454367	37.36019036	126.9340594	OFFICIAL	2026-01-29 23:28:25.454371	0	\N
960	경기도 군포시 산본천로 227-2, (금정역 6번 출구앞 버스정류소) 경기도 군포시 산본동 103-28	2026-01-29 23:28:25.454906	37.37213688	126.9421274	OFFICIAL	2026-01-29 23:28:25.454911	0	\N
961	경기도 군포시 군포로735번길 4 경기도 군포시 금정동 27-6	2026-01-29 23:28:25.455415	37.37076562	126.9436132	OFFICIAL	2026-01-29 23:28:25.45542	0	\N
962	경기도 군포시 번영로 502 경기도 군포시 금정동 894	2026-01-29 23:28:25.455969	37.357707	126.933118	OFFICIAL	2026-01-29 23:28:25.455974	0	\N
963	경기도 군포시 번영로 497 경기도 군포시 산본동 1179	2026-01-29 23:28:25.456491	37.35805724	126.9322603	OFFICIAL	2026-01-29 23:28:25.456496	0	\N
964	경기도 군포시 산본로323번길 16-26(중앙분수대 옆 벤치)	2026-01-29 23:28:25.457029	37.35998048	126.9317825	OFFICIAL	2026-01-29 23:28:25.457034	0	\N
965	경기도 군포시 광정로 60(흡연부스 옆)	2026-01-29 23:28:25.457548	37.35872074	126.9308199	OFFICIAL	2026-01-29 23:28:25.457553	0	\N
966	경상남도 합천군 가야면 야천리 465-5	2026-01-29 23:28:25.458094	35.7627806	128.1394531	OFFICIAL	2026-01-29 23:28:25.458098	0	\N
967	경상남도 합천군 가야면 매화리 304-2	2026-01-29 23:28:25.458656	35.7343862	128.1248001	OFFICIAL	2026-01-29 23:28:25.458661	0	\N
968	서울특별시 구로구 구로동로 13 서울특별시 구로구 가리봉동 121-30	2026-01-29 23:28:25.4592	37.48289633	126.8868871	OFFICIAL	2026-01-29 23:28:25.459205	0	\N
969	서울특별시 성북구 동소문로20길 43 서울특별시 성북구 동선동1가 46-2	2026-01-29 23:28:25.459745	37.59065915	127.0170249	OFFICIAL	2026-01-29 23:28:25.459774	0	\N
970	서울특별시 성북구 보문로34길 88 서울특별시 성북구 동선동2가 154	2026-01-29 23:28:25.460286	37.59125877	127.0201498	OFFICIAL	2026-01-29 23:28:25.460291	0	\N
971	서울특별시 성북구 삼선교로 29 서울특별시 성북구 삼선동2가 105	2026-01-29 23:28:25.46085	37.58824221	127.0092204	OFFICIAL	2026-01-29 23:28:25.460855	0	\N
972	서울특별시 성북구 보문로 151 서울특별시 성북구 삼선동5가 297	2026-01-29 23:28:25.461423	37.58816492	127.0172891	OFFICIAL	2026-01-29 23:28:25.461429	0	\N
973	서울특별시 성북구 보문로 156-1 서울특별시 성북구 삼선동5가 326	2026-01-29 23:28:25.461996	37.58869751	127.0172939	OFFICIAL	2026-01-29 23:28:25.462	0	\N
974	서울특별시 성북구 보문동1가 178-1	2026-01-29 23:28:25.462553	37.58550482	127.0201945	OFFICIAL	2026-01-29 23:28:25.462557	0	\N
975	서울특별시 성북구 보문동1가 109-3	2026-01-29 23:28:25.4631	37.5856381	127.0200081	OFFICIAL	2026-01-29 23:28:25.463105	0	\N
976	서울특별시 성북구 고려대로 73 서울특별시 성북구 안암동5가 126-1	2026-01-29 23:28:25.463655	37.58711097	127.0263572	OFFICIAL	2026-01-29 23:28:25.46366	0	\N
977	서울특별시 성북구 동소문로 310 서울특별시 성북구 하월곡동 88-3	2026-01-29 23:28:25.464194	37.60731274	127.0293121	OFFICIAL	2026-01-29 23:28:25.464199	0	\N
978	대구광역시 북구 칠곡중앙대로136길 90 대구광역시 북구 학정동 515-3	2026-01-29 23:28:25.464729	35.95526718	128.5626769	OFFICIAL	2026-01-29 23:28:25.464734	0	\N
979	대구광역시 북구 학정로 553 (학정동) 대구광역시 북구 학정동 922-3	2026-01-29 23:28:25.465265	35.95406761	128.5654001	OFFICIAL	2026-01-29 23:28:25.46527	0	\N
980	대구광역시 북구 대학로 80 대구광역시 북구 산격동 1370-1	2026-01-29 23:28:25.465836	35.88909749	128.6143223	OFFICIAL	2026-01-29 23:28:25.465841	0	\N
981	대구광역시 북구 옥산로 75 대구광역시 북구 침산동 447-10	2026-01-29 23:28:25.466328	35.88512411	128.5838427	OFFICIAL	2026-01-29 23:28:25.466333	0	\N
982	서울특별시 구로구 구일로8길 31 서울특별시 구로구 구로동 1058	2026-01-29 23:28:25.466881	37.49517251	126.8726762	OFFICIAL	2026-01-29 23:28:25.466886	0	\N
983	서울특별시 성북구 보문로 168 서울특별시 성북구 삼선동5가 411	2026-01-29 23:28:25.467394	37.58946842	127.0168218	OFFICIAL	2026-01-29 23:28:25.467399	0	\N
984	서울특별시 성북구 동소문로 298 서울특별시 성북구 하월곡동 88-485	2026-01-29 23:28:25.46796	37.60650703	127.0282193	OFFICIAL	2026-01-29 23:28:25.467965	0	\N
985	서울특별시 성북구 아리랑로 10 서울특별시 성북구 동선동4가 38	2026-01-29 23:28:25.468571	37.59377027	127.016453	OFFICIAL	2026-01-29 23:28:25.468577	0	\N
986	서울특별시 성북구 길음동 559-1	2026-01-29 23:28:25.469152	37.60544504	127.0222217	OFFICIAL	2026-01-29 23:28:25.469158	0	\N
987	서울특별시 성북구 길음로 33 서울특별시 성북구 길음동 1284	2026-01-29 23:28:25.469706	37.60504925	127.0220094	OFFICIAL	2026-01-29 23:28:25.469711	0	\N
988	서울특별시 성북구 장위동 310-25	2026-01-29 23:28:25.47026	37.61903401	127.0456148	OFFICIAL	2026-01-29 23:28:25.470265	0	\N
989	서울특별시 성북구 서경로 63 서울특별시 성북구 정릉동 192-152	2026-01-29 23:28:25.47086	37.60905769	127.0153655	OFFICIAL	2026-01-29 23:28:25.470864	0	\N
990	서울특별시 성북구 솔샘로 32 서울특별시 성북구 정릉동 704-23	2026-01-29 23:28:25.471365	37.61039477	127.005287	OFFICIAL	2026-01-29 23:28:25.471369	0	\N
991	서울특별시 성북구 한천로 518 서울특별시 성북구 석관동 92-2	2026-01-29 23:28:25.471899	37.60670448	127.0664361	OFFICIAL	2026-01-29 23:28:25.471903	0	\N
992	서울특별시 성북구 한천로 713 서울특별시 성북구 장위동 320	2026-01-29 23:28:25.472392	37.62005567	127.0514349	OFFICIAL	2026-01-29 23:28:25.472396	0	\N
993	서울특별시 성북구 장월로 160 서울특별시 성북구 장위동 322	2026-01-29 23:28:25.47296	37.61800248	127.0533081	OFFICIAL	2026-01-29 23:28:25.472965	0	\N
994	서울특별시 성북구 돌곶이로40길 46 서울특별시 성북구 장위동 323	2026-01-29 23:28:25.473539	37.61866075	127.0489591	OFFICIAL	2026-01-29 23:28:25.473544	0	\N
995	서울특별시 성북구 보국문로22길 8 서울특별시 성북구 정릉동 289-38	2026-01-29 23:28:25.474084	37.61211271	127.0085918	OFFICIAL	2026-01-29 23:28:25.474089	0	\N
996	서울특별시 성북구 종암로24가길 80 서울특별시 성북구 종암동 134	2026-01-29 23:28:25.474662	37.59937311	127.0392269	OFFICIAL	2026-01-29 23:28:25.474667	0	\N
997	서울특별시 성북구 하월곡동 35-1	2026-01-29 23:28:25.475212	37.60142105	127.0411848	OFFICIAL	2026-01-29 23:28:25.475216	0	\N
998	서울특별시 성북구 종암로21가길 36-1 서울특별시 성북구 종암동 65-13	2026-01-29 23:28:25.475849	37.59815179	127.03261	OFFICIAL	2026-01-29 23:28:25.475854	0	\N
999	서울특별시 성북구 정릉동 164-51	2026-01-29 23:28:25.476354	37.6050398	127.0113564	OFFICIAL	2026-01-29 23:28:25.476358	0	\N
1000	서울특별시 성북구 길음로7길 20 서울특별시 성북구 길음동 1286-8	2026-01-29 23:28:25.476908	37.60375093	127.0224636	OFFICIAL	2026-01-29 23:28:25.476912	0	\N
1001	서울특별시 성북구 보문로168 서울특별시 성북구 삼선동5가 411	2026-01-29 23:28:25.521458	37.58946842	127.0168218	OFFICIAL	2026-01-29 23:28:25.521469	0	\N
1002	서울특별시 성북구 장월로29길 9 서울특별시 성북구 장위동 206-3	2026-01-29 23:28:25.522367	37.61769896	127.0498021	OFFICIAL	2026-01-29 23:28:25.522373	0	\N
1003	서울특별시 성북구 정릉로 279 서울특별시 성북구 정릉동 160-1	2026-01-29 23:28:25.523045	37.6038198	127.013291	OFFICIAL	2026-01-29 23:28:25.523051	0	\N
1004	서울특별시 성북구 종암로5길 14 서울특별시 성북구 종암동 22-1	2026-01-29 23:28:25.523593	37.59452119	127.0352972	OFFICIAL	2026-01-29 23:28:25.523598	0	\N
1005	서울특별시 성북구 석관동 375-46	2026-01-29 23:28:25.524179	37.6148489	127.0668471	OFFICIAL	2026-01-29 23:28:25.524184	0	\N
1006	서울특별시 성북구 보국문로 101 서울특별시 성북구 정릉동 295-11	2026-01-29 23:28:25.524777	37.61289493	127.0070579	OFFICIAL	2026-01-29 23:28:25.524783	0	\N
1007	서울특별시 성북구 종암동 90-21	2026-01-29 23:28:25.52536	37.60243467	127.034667	OFFICIAL	2026-01-29 23:28:25.525365	0	\N
1008	서울특별시 성북구 석관동 43-1	2026-01-29 23:28:25.525947	37.60620572	127.0664368	OFFICIAL	2026-01-29 23:28:25.525952	0	\N
1009	서울특별시 성북구 종암동 115-152	2026-01-29 23:28:25.526506	37.60203491	127.0374768	OFFICIAL	2026-01-29 23:28:25.526511	0	\N
1010	서울특별시 성북구 보문로 113 서울특별시 성북구 보문동2가 134	2026-01-29 23:28:25.527081	37.58504462	127.0192999	OFFICIAL	2026-01-29 23:28:25.527086	0	\N
1011	서울특별시 성북구 아리랑로 26-1 서울특별시 성북구 동선동5가 26	2026-01-29 23:28:25.527637	37.59507885	127.016162	OFFICIAL	2026-01-29 23:28:25.527642	0	\N
1012	서울특별시 성북구 하월곡동 1-12	2026-01-29 23:28:25.528201	37.60554551	127.0474239	OFFICIAL	2026-01-29 23:28:25.528206	0	\N
1013	서울특별시 성북구 동소문로23길 73 서울특별시 성북구 동선동5가 141-6	2026-01-29 23:28:25.528784	37.59639551	127.0157506	OFFICIAL	2026-01-29 23:28:25.528789	0	\N
1014	서울특별시 성북구 석관동 375-14	2026-01-29 23:28:25.529334	37.61509454	127.0667187	OFFICIAL	2026-01-29 23:28:25.529339	0	\N
1015	서울특별시 성북구 하월곡동 88-5	2026-01-29 23:28:25.529938	37.60493587	127.0316201	OFFICIAL	2026-01-29 23:28:25.529943	0	\N
1016	서울특별시 성북구 오패산로 22 서울특별시 성북구 하월곡동 62-4	2026-01-29 23:28:25.530496	37.60422016	127.0376844	OFFICIAL	2026-01-29 23:28:25.530501	0	\N
1017	서울특별시 성북구 정릉로 272-8 서울특별시 성북구 정릉동 139-56	2026-01-29 23:28:25.531142	37.60291849	127.0136887	OFFICIAL	2026-01-29 23:28:25.531149	0	\N
1018	서울특별시 성북구 정릉동 967-20	2026-01-29 23:28:25.531925	37.60244138	127.0134197	OFFICIAL	2026-01-29 23:28:25.531932	0	\N
1019	서울특별시 성북구 성북로 14 서울특별시 성북구 성북동1가 50-4	2026-01-29 23:28:25.532556	37.58947034	127.00522	OFFICIAL	2026-01-29 23:28:25.532562	0	\N
1020	서울특별시 성북구 종암로 54 서울특별시 성북구 종암동 10-178	2026-01-29 23:28:25.53314	37.59502982	127.0361993	OFFICIAL	2026-01-29 23:28:25.533145	0	\N
1021	서울특별시 성북구 종암로 103 서울특별시 성북구 종암동 87-6	2026-01-29 23:28:25.533689	37.59933907	127.0340484	OFFICIAL	2026-01-29 23:28:25.533694	0	\N
1022	서울특별시 성북구 정릉로 324 서울특별시 성북구 정릉동 16-170	2026-01-29 23:28:25.534268	37.60212379	127.0191517	OFFICIAL	2026-01-29 23:28:25.534274	0	\N
1023	서울특별시 성북구 화랑로 79 서울특별시 성북구 하월곡동 27-117	2026-01-29 23:28:25.53484	37.60249259	127.0411515	OFFICIAL	2026-01-29 23:28:25.534845	0	\N
1024	서울특별시 성북구 길음동 534-9	2026-01-29 23:28:25.535643	37.60328765	127.0237397	OFFICIAL	2026-01-29 23:28:25.535648	0	\N
1025	서울특별시 성북구 길음동 532-17	2026-01-29 23:28:25.536375	37.60375649	127.0242239	OFFICIAL	2026-01-29 23:28:25.53638	0	\N
1026	서울특별시 성북구 동소문로 295-2 서울특별시 성북구 길음동 515	2026-01-29 23:28:25.537908	37.60675178	127.0278637	OFFICIAL	2026-01-29 23:28:25.537914	0	\N
1027	서울특별시 성북구 동소문로 286 서울특별시 성북구 하월곡동 88-31	2026-01-29 23:28:25.538502	37.60581297	127.0273879	OFFICIAL	2026-01-29 23:28:25.538507	0	\N
1028	서울특별시 성북구 정릉로 367-2 서울특별시 성북구 돈암동 8-165	2026-01-29 23:28:25.539129	37.60227407	127.0240657	OFFICIAL	2026-01-29 23:28:25.539134	0	\N
1029	서울특별시 성북구 오패산로 98-23 서울특별시 성북구 하월곡동 77-976	2026-01-29 23:28:25.539691	37.61176348	127.0359516	OFFICIAL	2026-01-29 23:28:25.539697	0	\N
1030	서울특별시 성북구 정릉동 590-16	2026-01-29 23:28:25.540295	37.60869733	126.9989744	OFFICIAL	2026-01-29 23:28:25.540301	0	\N
1031	서울특별시 성북구 종암로 42-1 서울특별시 성북구 종암동 12-33	2026-01-29 23:28:25.542123	37.59417872	127.0362062	OFFICIAL	2026-01-29 23:28:25.542128	0	\N
1032	서울특별시 성북구 안암로 105 서울특별시 성북구 안암동5가 86-10	2026-01-29 23:28:25.542668	37.58510934	127.0314287	OFFICIAL	2026-01-29 23:28:25.542674	0	\N
1033	서울특별시 성북구 보문로 121 서울특별시 성북구 보문동2가 79	2026-01-29 23:28:25.543234	37.58586857	127.0188005	OFFICIAL	2026-01-29 23:28:25.543239	0	\N
1034	서울특별시 성북구 길음동 607-33	2026-01-29 23:28:25.543819	37.60660606	127.0217163	OFFICIAL	2026-01-29 23:28:25.543825	0	\N
1035	서울특별시 성북구 길음동 875-1	2026-01-29 23:28:25.544347	37.60724571	127.0216337	OFFICIAL	2026-01-29 23:28:25.544352	0	\N
1036	서울특별시 성북구 길음동 875-1	2026-01-29 23:28:25.544897	37.60724571	127.0216337	OFFICIAL	2026-01-29 23:28:25.544902	0	\N
1037	서울특별시 성북구 길음로 74 서울특별시 성북구 길음동 1282	2026-01-29 23:28:25.545435	37.60928966	127.0210339	OFFICIAL	2026-01-29 23:28:25.545441	0	\N
1038	서울특별시 성북구 종암로 129 서울특별시 성북구 종암동 3-1342	2026-01-29 23:28:25.546001	37.60144986	127.0327235	OFFICIAL	2026-01-29 23:28:25.546006	0	\N
1039	서울특별시 성북구 종암로 1 서울특별시 성북구 종암동 29-18	2026-01-29 23:28:25.546548	37.59064969	127.0362127	OFFICIAL	2026-01-29 23:28:25.546554	0	\N
1040	서울특별시 성북구 한천로66길 221-1 서울특별시 성북구 석관동 375-29	2026-01-29 23:28:25.547139	37.61416533	127.0649259	OFFICIAL	2026-01-29 23:28:25.547145	0	\N
1041	서울특별시 성북구 동소문로 312 서울특별시 성북구 하월곡동 89-4	2026-01-29 23:28:25.547657	37.60756223	127.0292087	OFFICIAL	2026-01-29 23:28:25.547663	0	\N
1042	서울특별시 성북구 성북로 68 서울특별시 성북구 성북동 155-16	2026-01-29 23:28:25.548225	37.59352493	127.0014063	OFFICIAL	2026-01-29 23:28:25.548231	0	\N
3014	Gumi Imsu-dong	2026-02-06 16:25:03.009885	36.1081833	128.4139683	PENDING	2026-02-06 16:25:03.00994	1	test
1043	서울특별시 성북구 성북로 52-1 서울특별시 성북구 성북동 170-41	2026-01-29 23:28:25.54886	37.59251384	127.0027939	OFFICIAL	2026-01-29 23:28:25.548865	0	\N
1044	서울특별시 성북구 아리랑로 89 서울특별시 성북구 돈암동 524	2026-01-29 23:28:25.54947	37.60073299	127.0136175	OFFICIAL	2026-01-29 23:28:25.549475	0	\N
1045	서울특별시 성북구 아리랑로 82 서울특별시 성북구 돈암동 538-98	2026-01-29 23:28:25.550032	37.60005917	127.0139243	OFFICIAL	2026-01-29 23:28:25.550037	0	\N
1046	서울특별시 성북구 월계로40길 7 서울특별시 성북구 장위동 316-3	2026-01-29 23:28:25.550612	37.62291794	127.0483972	OFFICIAL	2026-01-29 23:28:25.550617	0	\N
1047	서울특별시 성북구 돌곶이로 197 서울특별시 성북구 장위동 214-79	2026-01-29 23:28:25.551181	37.61762061	127.0477205	OFFICIAL	2026-01-29 23:28:25.551185	0	\N
1048	서울특별시 성북구 장월로 89-1 서울특별시 성북구 장위동 238-198	2026-01-29 23:28:25.5517	37.61386832	127.0487365	OFFICIAL	2026-01-29 23:28:25.551704	0	\N
1049	서울특별시 성북구 고려대로 100 서울특별시 성북구 안암동5가 96	2026-01-29 23:28:25.552435	37.58617158	127.0304208	OFFICIAL	2026-01-29 23:28:25.55244	0	\N
1050	서울특별시 성북구 고려대로27길 4 서울특별시 성북구 안암동5가 99	2026-01-29 23:28:25.553007	37.58652168	127.030237	OFFICIAL	2026-01-29 23:28:25.553012	0	\N
1051	서울특별시 성북구 보문로 124 서울특별시 성북구 보문동1가 120	2026-01-29 23:28:25.553522	37.58612342	127.0192059	OFFICIAL	2026-01-29 23:28:25.553527	0	\N
1052	서울특별시 성북구 보문로 79 서울특별시 성북구 보문동5가 160-1	2026-01-29 23:28:25.554072	37.58238112	127.0206873	OFFICIAL	2026-01-29 23:28:25.554077	0	\N
1053	서울특별시 성북구 보문로 55-1 서울특별시 성북구 보문동7가 31	2026-01-29 23:28:25.554696	37.5804096	127.0217293	OFFICIAL	2026-01-29 23:28:25.554701	0	\N
1054	서울특별시 성북구 종암로 180-1 서울특별시 성북구 하월곡동 90-117	2026-01-29 23:28:25.555332	37.6059607	127.0316371	OFFICIAL	2026-01-29 23:28:25.555338	0	\N
1055	서울특별시 성북구 종암로40길 37 서울특별시 성북구 하월곡동 174	2026-01-29 23:28:25.555892	37.60967849	127.0320225	OFFICIAL	2026-01-29 23:28:25.555898	0	\N
1056	서울특별시 성북구 오패산로3길 17 서울특별시 성북구 하월곡동 219	2026-01-29 23:28:25.556406	37.60459386	127.0345453	OFFICIAL	2026-01-29 23:28:25.556411	0	\N
1057	서울특별시 성북구 종암로 132 서울특별시 성북구 종암동 132	2026-01-29 23:28:25.556897	37.60193718	127.0335324	OFFICIAL	2026-01-29 23:28:25.556901	0	\N
1058	서울특별시 성북구 길음동 1076-2	2026-01-29 23:28:25.557386	37.60455235	127.0251733	OFFICIAL	2026-01-29 23:28:25.557391	0	\N
1059	서울특별시 성북구 월곡로108 서울특별시 성북구 하월곡동 35-5	2026-01-29 23:28:25.557918	37.60156211	127.0415814	OFFICIAL	2026-01-29 23:28:25.557923	0	\N
1060	서울특별시 성북구 화랑로15길 4 서울특별시 성북구 상월곡동 55-56	2026-01-29 23:28:25.558406	37.60572459	127.0463868	OFFICIAL	2026-01-29 23:28:25.558411	0	\N
1061	서울특별시 성북구 상월곡동 35-9	2026-01-29 23:28:25.558891	37.60603113	127.0476799	OFFICIAL	2026-01-29 23:28:25.558896	0	\N
1062	서울특별시 성북구 화랑로 241 서울특별시 성북구 장위동 64-115	2026-01-29 23:28:25.559363	37.61063073	127.0561203	OFFICIAL	2026-01-29 23:28:25.559368	0	\N
1063	서울특별시 성북구 장위동 64-135	2026-01-29 23:28:25.559863	37.61126749	127.0565666	OFFICIAL	2026-01-29 23:28:25.559868	0	\N
1064	서울특별시 성북구 정릉동 747-4	2026-01-29 23:28:25.560387	37.61357821	127.0062651	OFFICIAL	2026-01-29 23:28:25.560391	0	\N
1065	서울특별시 성북구 솔샘로25길 11-11 서울특별시 성북구 정릉동 239-4	2026-01-29 23:28:25.560935	37.61604544	127.008106	OFFICIAL	2026-01-29 23:28:25.56094	0	\N
1066	서울특별시 성북구 정릉동 649-33	2026-01-29 23:28:25.561463	37.60730331	127.0030606	OFFICIAL	2026-01-29 23:28:25.561468	0	\N
1067	서울특별시 성북구 정릉로 119-39 서울특별시 성북구 정릉동 산 1-79	2026-01-29 23:28:25.562028	37.60991195	126.9983548	OFFICIAL	2026-01-29 23:28:25.562032	0	\N
1068	서울특별시 성북구 정릉동 산 1-213	2026-01-29 23:28:25.562517	37.61090527	126.9943438	OFFICIAL	2026-01-29 23:28:25.562521	0	\N
1069	서울특별시 성북구 정릉동 산 1-344	2026-01-29 23:28:25.563139	37.61094706	126.9935823	OFFICIAL	2026-01-29 23:28:25.563146	0	\N
1070	서울특별시 성북구 정릉동 산 1-200	2026-01-29 23:28:25.563721	37.60836364	127.0007169	OFFICIAL	2026-01-29 23:28:25.563727	0	\N
1071	서울특별시 성북구 정릉로 153 서울특별시 성북구 정릉동 653-1	2026-01-29 23:28:25.564316	37.60795544	127.0024021	OFFICIAL	2026-01-29 23:28:25.564322	0	\N
1072	서울특별시 성북구 정릉동 415-18	2026-01-29 23:28:25.56489	37.60528387	127.0113803	OFFICIAL	2026-01-29 23:28:25.564895	0	\N
1073	서울특별시 성북구 정릉로26길 1 서울특별시 성북구 정릉동 966-125	2026-01-29 23:28:25.565401	37.60446495	127.0111291	OFFICIAL	2026-01-29 23:28:25.565406	0	\N
1074	서울특별시 성북구 정릉로 282 서울특별시 성북구 정릉동 966-112	2026-01-29 23:28:25.565962	37.60312751	127.0145106	OFFICIAL	2026-01-29 23:28:25.565967	0	\N
1075	서울특별시 성북구 정릉로31길 30 서울특별시 성북구 정릉동 966-173	2026-01-29 23:28:25.566511	37.60387465	127.0153694	OFFICIAL	2026-01-29 23:28:25.566516	0	\N
1076	서울특별시 성북구 성북동 227-8	2026-01-29 23:28:25.56706	37.59438363	126.991777	OFFICIAL	2026-01-29 23:28:25.567065	0	\N
1077	서울특별시 성북구 동소문로 184-1 서울특별시 성북구 돈암동 19-309	2026-01-29 23:28:25.567563	37.59840562	127.0219621	OFFICIAL	2026-01-29 23:28:25.567568	0	\N
1078	서울특별시 성북구 동소문로 181-1 서울특별시 성북구 돈암동 49-1	2026-01-29 23:28:25.568071	37.59831397	127.0215854	OFFICIAL	2026-01-29 23:28:25.568076	0	\N
1079	서울특별시 성북구 정릉로 372-1 서울특별시 성북구 돈암동 9-2	2026-01-29 23:28:25.56867	37.60188115	127.0244669	OFFICIAL	2026-01-29 23:28:25.568675	0	\N
1080	서울특별시 성북구 아리랑로7-1 서울특별시 성북구 동소문동6가 143-2	2026-01-29 23:28:25.569192	37.5934711	127.0161231	OFFICIAL	2026-01-29 23:28:25.569196	0	\N
1081	서울특별시 성북구 아리랑로8 서울특별시 성북구 동선동4가 26	2026-01-29 23:28:25.569679	37.59360817	127.0166658	OFFICIAL	2026-01-29 23:28:25.569683	0	\N
1082	서울특별시 성북구 동선동1가 101-1	2026-01-29 23:28:25.570258	37.5930516	127.0173347	OFFICIAL	2026-01-29 23:28:25.570263	0	\N
1083	서울특별시 성북구 동선동1가 123-1	2026-01-29 23:28:25.570778	37.59403525	127.0185316	OFFICIAL	2026-01-29 23:28:25.570783	0	\N
1084	서울특별시 성북구 성북로 3 서울특별시 성북구 성북동1가 35-33	2026-01-29 23:28:25.571325	37.58862414	127.0055302	OFFICIAL	2026-01-29 23:28:25.57133	0	\N
1085	서울특별시 성북구 동소문동3가 1-1	2026-01-29 23:28:25.571906	37.58995391	127.009784	OFFICIAL	2026-01-29 23:28:25.571911	0	\N
1086	서울특별시 성북구 동소문로 12-1 서울특별시 성북구 동소문동2가 2-1	2026-01-29 23:28:25.572449	37.58889911	127.0074702	OFFICIAL	2026-01-29 23:28:25.572454	0	\N
1087	서울특별시 성북구 동소문동2가 2-4	2026-01-29 23:28:25.573008	37.58840558	127.0064867	OFFICIAL	2026-01-29 23:28:25.573012	0	\N
1088	부산광역시 금정구 중앙대로 1770부산광역시 금정구 중앙대로 1777	2026-01-29 23:28:25.573682	35.24234	129.093	OFFICIAL	2026-01-29 23:28:25.573688	0	\N
1089	경상북도 영덕군 달산면 팔각산로 1833 경상북도 영덕군 달산면 대지리 463-3	2026-01-29 23:28:25.574235	36.39925547	129.3031206	OFFICIAL	2026-01-29 23:28:25.57424	0	\N
1090	경상북도 영덕군 병곡면 덕천리 54-4	2026-01-29 23:28:25.574821	36.56488276	129.420373	OFFICIAL	2026-01-29 23:28:25.574826	0	\N
1091	경상북도 영덕군 지품면 신안리 183-10	2026-01-29 23:28:25.575319	36.44796596	129.2816463	OFFICIAL	2026-01-29 23:28:25.575324	0	\N
1092	경상북도 영덕군 축산면 상원리 220-3	2026-01-29 23:28:25.575894	36.50740542	129.3988972	OFFICIAL	2026-01-29 23:28:25.575898	0	\N
1093	경상북도 영덕군 남정면 회리 691-7	2026-01-29 23:28:25.576369	36.27395438	129.3510523	OFFICIAL	2026-01-29 23:28:25.576376	0	\N
1094	경상북도 영덕군 남정면 부경리 448-7	2026-01-29 23:28:25.576885	36.26838467	129.3752332	OFFICIAL	2026-01-29 23:28:25.576892	0	\N
1095	경상북도 영덕군 강구면 강산로 152 경상북도 영덕군 강구면 화전리 산 55-2	2026-01-29 23:28:25.577351	36.35817018	129.3658262	OFFICIAL	2026-01-29 23:28:25.577355	0	\N
1096	경상북도 영덕군 영덕읍 창포리 113-3	2026-01-29 23:28:25.577877	36.41760453	129.4306034	OFFICIAL	2026-01-29 23:28:25.577882	0	\N
1097	경상북도 영덕군 창수면 인천리 191-4	2026-01-29 23:28:25.578384	36.63775808	129.2843135	OFFICIAL	2026-01-29 23:28:25.578392	0	\N
1098	경상북도 영덕군 축산면 경정리 301-1	2026-01-29 23:28:25.578883	36.48373338	129.4354461	OFFICIAL	2026-01-29 23:28:25.578888	0	\N
1099	경상북도 영덕군 축산면 경정리 404-3	2026-01-29 23:28:25.579347	36.48367277	129.4325273	OFFICIAL	2026-01-29 23:28:25.579351	0	\N
1100	경상북도 영덕군 축산면 도곡리 615-4	2026-01-29 23:28:25.579844	36.50636254	129.41622	OFFICIAL	2026-01-29 23:28:25.579848	0	\N
1101	경상북도 영덕군 남정면 양성리 176-4	2026-01-29 23:28:25.58033	36.28256739	129.3671429	OFFICIAL	2026-01-29 23:28:25.580335	0	\N
1102	경상북도 영덕군 남정면 회리 705-7	2026-01-29 23:28:25.580898	36.27364649	129.3318908	OFFICIAL	2026-01-29 23:28:25.580902	0	\N
1103	경상북도 영덕군 남정면 회리 40-11	2026-01-29 23:28:25.581447	36.27501753	129.3409078	OFFICIAL	2026-01-29 23:28:25.581452	0	\N
1104	경상북도 영덕군 남정면 원척1길 44-1 경상북도 영덕군 남정면 원척리 121-1	2026-01-29 23:28:25.581952	36.30055384	129.3781363	OFFICIAL	2026-01-29 23:28:25.581957	0	\N
1105	경상북도 영덕군 남정면 부흥리 486	2026-01-29 23:28:25.582438	36.29032174	129.375207	OFFICIAL	2026-01-29 23:28:25.582443	0	\N
1106	경상북도 영덕군 남정면 진불4길 4 경상북도 영덕군 남정면 장사리 306-1	2026-01-29 23:28:25.582944	36.28554099	129.3722543	OFFICIAL	2026-01-29 23:28:25.582949	0	\N
1107	경상북도 영덕군 영해면 괴시리 143-1	2026-01-29 23:28:25.583414	36.54176292	129.4090079	OFFICIAL	2026-01-29 23:28:25.583419	0	\N
1108	경상북도 영덕군 영해면 성내리 499-1	2026-01-29 23:28:25.583886	36.54093383	129.4054211	OFFICIAL	2026-01-29 23:28:25.58389	0	\N
1109	경상북도 영덕군 영해면 대리 390	2026-01-29 23:28:25.58435	36.51819594	129.2991678	OFFICIAL	2026-01-29 23:28:25.584355	0	\N
1110	경상북도 영덕군 영해면 성내리 824-5	2026-01-29 23:28:25.584863	36.53218421	129.4062223	OFFICIAL	2026-01-29 23:28:25.584867	0	\N
1111	경상북도 영덕군 영해면 성내리 687-4	2026-01-29 23:28:25.585394	36.53534308	129.4054433	OFFICIAL	2026-01-29 23:28:25.585398	0	\N
1112	경상북도 영덕군 영해면 벌영리 388-1	2026-01-29 23:28:25.585882	36.53691248	129.4015272	OFFICIAL	2026-01-29 23:28:25.585886	0	\N
1113	경상북도 영덕군 영해면 예주시장4길 10 경상북도 영덕군 영해면 성내리 468-1	2026-01-29 23:28:25.586349	36.5400495	129.4073058	OFFICIAL	2026-01-29 23:28:25.586353	0	\N
1114	경상북도 영덕군 영해면 예주8길 14-7 경상북도 영덕군 영해면 괴시리 128	2026-01-29 23:28:25.586839	36.53906186	129.413478	OFFICIAL	2026-01-29 23:28:25.586843	0	\N
1115	경상북도 영덕군 영해면 원당길 5 경상북도 영덕군 영해면 성내리 386	2026-01-29 23:28:25.587308	36.53779655	129.4104762	OFFICIAL	2026-01-29 23:28:25.587312	0	\N
1116	경상북도 영덕군 영해면 벌영리 410-3	2026-01-29 23:28:25.587773	36.5375435	129.4003768	OFFICIAL	2026-01-29 23:28:25.587777	0	\N
1117	경상북도 영덕군 영해면 원구1길 54 경상북도 영덕군 영해면 원구리 152-18	2026-01-29 23:28:25.588259	36.53949225	129.3786693	OFFICIAL	2026-01-29 23:28:25.588264	0	\N
1118	경상북도 영덕군 강구면 오포리 579-1	2026-01-29 23:28:25.588776	36.35880023	129.3776821	OFFICIAL	2026-01-29 23:28:25.58878	0	\N
1119	경상북도 영덕군 강구면 원직리 534	2026-01-29 23:28:25.589243	36.37632184	129.3683248	OFFICIAL	2026-01-29 23:28:25.589248	0	\N
1120	경상북도 영덕군 강구면 오포리 882	2026-01-29 23:28:25.589709	36.36147561	129.3780011	OFFICIAL	2026-01-29 23:28:25.589714	0	\N
1121	경상북도 영덕군 강구면 소월리 133-1	2026-01-29 23:28:25.5902	36.37777784	129.3742767	OFFICIAL	2026-01-29 23:28:25.590204	0	\N
1122	경상북도 영덕군 강구면 하저리 산 181-1	2026-01-29 23:28:25.590662	36.3880102	129.4066097	OFFICIAL	2026-01-29 23:28:25.590666	0	\N
1123	경상북도 영덕군 강구면 삼사리 147	2026-01-29 23:28:25.591143	36.34892434	129.3849337	OFFICIAL	2026-01-29 23:28:25.591151	0	\N
1124	경상북도 영덕군 강구면 오포리 814-1	2026-01-29 23:28:25.591612	36.35777489	129.3890432	OFFICIAL	2026-01-29 23:28:25.591616	0	\N
1125	경상북도 영덕군 강구면 금진리 806-1	2026-01-29 23:28:25.592067	36.37636469	129.4019142	OFFICIAL	2026-01-29 23:28:25.592072	0	\N
1126	경상북도 영덕군 강구면 오포리 1-9	2026-01-29 23:28:25.592539	36.35648031	129.3849978	OFFICIAL	2026-01-29 23:28:25.592543	0	\N
1127	경상북도 영덕군 강구면 영덕대게로 509 경상북도 영덕군 강구면 하저리 57-2	2026-01-29 23:28:25.592998	36.39050172	129.4085883	OFFICIAL	2026-01-29 23:28:25.593002	0	\N
1128	경상북도 영덕군 강구면 신강구1길 21-1 경상북도 영덕군 강구면 오포리 675	2026-01-29 23:28:25.593478	36.35530805	129.3812564	OFFICIAL	2026-01-29 23:28:25.593482	0	\N
1129	서울특별시 구로구 구일로2길 60 서울특별시 구로구 구로동 1259	2026-01-29 23:28:25.593965	37.48975807	126.8770812	OFFICIAL	2026-01-29 23:28:25.593969	0	\N
1130	경상북도 영덕군 강구면 오포리 616-1	2026-01-29 23:28:25.594428	36.35449737	129.3789892	OFFICIAL	2026-01-29 23:28:25.594432	0	\N
1131	경상북도 영덕군 강구면 오포리 386-4	2026-01-29 23:28:25.594884	36.36303272	129.3755067	OFFICIAL	2026-01-29 23:28:25.594889	0	\N
1132	경상북도 영덕군 영덕읍 화개리 644-13	2026-01-29 23:28:25.595341	36.41740653	129.3660419	OFFICIAL	2026-01-29 23:28:25.595345	0	\N
1133	경상북도 영덕군 영덕읍 화개리 257	2026-01-29 23:28:25.595824	36.42036067	129.3632565	OFFICIAL	2026-01-29 23:28:25.595829	0	\N
1134	경상북도 영덕군 영덕읍 군청길 116 경상북도 영덕군 영덕읍 남석리 310-3	2026-01-29 23:28:25.596283	36.41503388	129.3654012	OFFICIAL	2026-01-29 23:28:25.596287	0	\N
1135	경상북도 영덕군 영덕읍 화개리 86	2026-01-29 23:28:25.596744	36.4151178	129.368141	OFFICIAL	2026-01-29 23:28:25.596771	0	\N
1136	경상북도 영덕군 영덕읍 화천리 524-5	2026-01-29 23:28:25.597226	36.45990512	129.3524221	OFFICIAL	2026-01-29 23:28:25.597231	0	\N
1137	경상북도 영덕군 영덕읍 우곡리 93-1	2026-01-29 23:28:25.597681	36.41563383	129.3792098	OFFICIAL	2026-01-29 23:28:25.597686	0	\N
1138	경상북도 영덕군 영덕읍 영덕대게로 1198 경상북도 영덕군 영덕읍 오보리 146-7	2026-01-29 23:28:25.598167	36.44022908	129.4324078	OFFICIAL	2026-01-29 23:28:25.598171	0	\N
1139	경상북도 영덕군 영덕읍 덕곡리 233	2026-01-29 23:28:25.598686	36.41318837	129.3713592	OFFICIAL	2026-01-29 23:28:25.59869	0	\N
1140	경상북도 영덕군 영덕읍 덕곡리 331-3	2026-01-29 23:28:25.599173	36.40955044	129.3709725	OFFICIAL	2026-01-29 23:28:25.599177	0	\N
1141	경상북도 영덕군 영덕읍 덕곡리 322-11	2026-01-29 23:28:25.599729	36.41385344	129.3732127	OFFICIAL	2026-01-29 23:28:25.599733	0	\N
1142	경상북도 영덕군 영덕읍 남산길 21-3 경상북도 영덕군 영덕읍 남산리 63-5	2026-01-29 23:28:25.600215	36.40132792	129.3706873	OFFICIAL	2026-01-29 23:28:25.600219	0	\N
1143	경상북도 영덕군 영덕읍 우곡리 490-4	2026-01-29 23:28:25.600694	36.40858173	129.3712698	OFFICIAL	2026-01-29 23:28:25.600699	0	\N
1144	경상북도 영덕군 영덕읍 덕곡리 228-7	2026-01-29 23:28:25.60119	36.41328385	129.3731214	OFFICIAL	2026-01-29 23:28:25.601195	0	\N
1145	경상북도 영덕군 영덕읍 우곡리 490-4	2026-01-29 23:28:25.60165	36.40858173	129.3712698	OFFICIAL	2026-01-29 23:28:25.601654	0	\N
1146	경상북도 영덕군 영덕읍 구미1길 14 경상북도 영덕군 영덕읍 구미리 155	2026-01-29 23:28:25.602129	36.43338075	129.3546003	OFFICIAL	2026-01-29 23:28:25.602133	0	\N
1147	경상북도 영덕군 영덕읍 석리 221-3	2026-01-29 23:28:25.602593	36.46573457	129.4351088	OFFICIAL	2026-01-29 23:28:25.602597	0	\N
1148	경상북도 영덕군 영덕읍 창포리 625-1	2026-01-29 23:28:25.603065	36.410966	129.4298665	OFFICIAL	2026-01-29 23:28:25.603069	0	\N
1149	경상북도 영덕군 영덕읍 노물리 568	2026-01-29 23:28:25.603702	36.44641039	129.4321646	OFFICIAL	2026-01-29 23:28:25.603707	0	\N
1150	경상북도 영덕군 영덕읍 남산리 245-1	2026-01-29 23:28:25.604238	36.39209573	129.3693516	OFFICIAL	2026-01-29 23:28:25.604242	0	\N
1151	경상남도 합천군 야로면 묵촌리 654-5	2026-01-29 23:28:25.604696	35.7048422	128.1538951	OFFICIAL	2026-01-29 23:28:25.604701	0	\N
1152	경상남도 합천군 야로면 하빈리 282	2026-01-29 23:28:25.605306	35.7268417	128.1874528	OFFICIAL	2026-01-29 23:28:25.605311	0	\N
1153	경상남도 합천군 야로면 나대리 472-8	2026-01-29 23:28:25.607387	35.7581771	128.1724539	OFFICIAL	2026-01-29 23:28:25.607393	0	\N
1154	경상남도 합천군 야로면 금평리 137	2026-01-29 23:28:25.607967	35.7084214	128.1852657	OFFICIAL	2026-01-29 23:28:25.607972	0	\N
1155	경상남도 합천군 야로면 청계리 376-8	2026-01-29 23:28:25.608484	35.6933264	128.2004456	OFFICIAL	2026-01-29 23:28:25.608489	0	\N
1156	경상남도 합천군 야로면 하빈리 438-10	2026-01-29 23:28:25.609031	35.7087664	128.1776742	OFFICIAL	2026-01-29 23:28:25.609036	0	\N
1157	경상남도 합천군 야로면 하림리 675-1	2026-01-29 23:28:25.609548	35.7454434	128.1505014	OFFICIAL	2026-01-29 23:28:25.609553	0	\N
1158	경상남도 합천군 가야면 사촌리 496-2	2026-01-29 23:28:25.610057	35.7506102	128.1250685	OFFICIAL	2026-01-29 23:28:25.610062	0	\N
1159	경상남도 합천군 가야면 죽전리 429-6	2026-01-29 23:28:25.610591	35.7499737	128.0783512	OFFICIAL	2026-01-29 23:28:25.610596	0	\N
1160	서울특별시 구로구 구일로 62 서울특별시 구로구 구로동 685-219	2026-01-29 23:28:25.611138	37.49177716	126.8743642	OFFICIAL	2026-01-29 23:28:25.611143	0	\N
1161	경상남도 합천군 적중면 황정길 109-1	2026-01-29 23:28:25.611679	35.5357856	128.2852634	OFFICIAL	2026-01-29 23:28:25.611683	0	\N
1162	경상남도 합천군 적중면 부수길 28-2	2026-01-29 23:28:25.612198	35.5441548	128.2871901	OFFICIAL	2026-01-29 23:28:25.612203	0	\N
1163	경상남도 합천군 적중면 양림길 27	2026-01-29 23:28:25.612689	35.5381525	128.2672411	OFFICIAL	2026-01-29 23:28:25.612693	0	\N
1164	경상남도 합천군 청덕면 모리 378	2026-01-29 23:28:25.613216	35.5746318	128.3085041	OFFICIAL	2026-01-29 23:28:25.61322	0	\N
1165	경상남도 합천군 청덕면 가현리 69	2026-01-29 23:28:25.613774	35.5715121	128.3422514	OFFICIAL	2026-01-29 23:28:25.613779	0	\N
1166	경상남도 합천군 덕곡면 본곡리 768	2026-01-29 23:28:25.614269	35.6446497	128.3086293	OFFICIAL	2026-01-29 23:28:25.614274	0	\N
1167	경상남도 합천군 덕곡면 장리 1000-3	2026-01-29 23:28:25.6149	35.6283973	128.3158976	OFFICIAL	2026-01-29 23:28:25.614904	0	\N
1168	경상남도 합천군 덕곡면 병배리 290-3	2026-01-29 23:28:25.615517	35.6246449	128.3400711	OFFICIAL	2026-01-29 23:28:25.615521	0	\N
1169	경상남도 합천군 덕곡면 병배리 72-1	2026-01-29 23:28:25.616043	35.6192479	128.3456449	OFFICIAL	2026-01-29 23:28:25.616047	0	\N
1170	경상남도 합천군 덕곡면 학리 547	2026-01-29 23:28:25.616529	35.6247044	128.3476335	OFFICIAL	2026-01-29 23:28:25.616533	0	\N
1171	경상남도 합천군 덕곡면 학리 302-1	2026-01-29 23:28:25.617025	35.6262151	128.3519898	OFFICIAL	2026-01-29 23:28:25.61703	0	\N
1172	경상남도 합천군 덕곡면 율원리 406	2026-01-29 23:28:25.617544	35.6401608	128.2905254	OFFICIAL	2026-01-29 23:28:25.617548	0	\N
1173	경상남도 합천군 덕곡면 장리 531-2	2026-01-29 23:28:25.61805	35.6246193	128.3265031	OFFICIAL	2026-01-29 23:28:25.618059	0	\N
1174	경상남도 합천군 덕곡면 포두1길 82-7	2026-01-29 23:28:25.618522	35.6315481	128.3468682	OFFICIAL	2026-01-29 23:28:25.618527	0	\N
1175	경상남도 합천군 덕곡면 장리 2길 3	2026-01-29 23:28:25.619054	35.6232635	128.3311783	OFFICIAL	2026-01-29 23:28:25.619058	0	\N
1176	경상남도 합천군 쌍책면 상포리 448	2026-01-29 23:28:25.621875	35.5827021	128.2736784	OFFICIAL	2026-01-29 23:28:25.62188	0	\N
1177	경상남도 합천군 쌍책면 덕봉리 241-2	2026-01-29 23:28:25.622418	35.6029446	128.2785594	OFFICIAL	2026-01-29 23:28:25.622423	0	\N
1178	경상남도 합천군 쌍책면 상포리 248-3	2026-01-29 23:28:25.62292	35.5840863	128.2673384	OFFICIAL	2026-01-29 23:28:25.622925	0	\N
1179	경상남도 합천군 초계면 대평리 430-4	2026-01-29 23:28:25.623396	35.5452444	128.2513609	OFFICIAL	2026-01-29 23:28:25.623401	0	\N
1180	경상남도 합천군 초계면 상대리 445	2026-01-29 23:28:25.623869	35.5310564	128.2514821	OFFICIAL	2026-01-29 23:28:25.623873	0	\N
1181	경상남도 합천군 초계면 신촌리 607-8	2026-01-29 23:28:25.624315	35.5221829	128.2490177	OFFICIAL	2026-01-29 23:28:25.624319	0	\N
1182	경상남도 합천군 초계면 중리 110	2026-01-29 23:28:25.624836	35.5602246	128.2559635	OFFICIAL	2026-01-29 23:28:25.624841	0	\N
1183	경상남도 합천군 율곡면 본천리 424	2026-01-29 23:28:25.625363	35.5567639	128.1926374	OFFICIAL	2026-01-29 23:28:25.625368	0	\N
1184	경상남도 합천군 율곡면 제내2길 21-3	2026-01-29 23:28:25.625869	35.5849868	128.2084181	OFFICIAL	2026-01-29 23:28:25.625874	0	\N
1185	경상남도 합천군 율곡면 임북2길 43-1	2026-01-29 23:28:25.626338	35.5757757	128.1798845	OFFICIAL	2026-01-29 23:28:25.626342	0	\N
1186	경상남도 합천군 율곡면 노양리 581-1	2026-01-29 23:28:25.626818	35.6239604	128.1931849	OFFICIAL	2026-01-29 23:28:25.626823	0	\N
1187	경상남도 합천군 율곡면 영전리 455-1	2026-01-29 23:28:25.627266	35.5724136	128.2180941	OFFICIAL	2026-01-29 23:28:25.627271	0	\N
1188	경상남도 합천군 율곡면 내천리 594-6	2026-01-29 23:28:25.62771	35.6109354	128.2386188	OFFICIAL	2026-01-29 23:28:25.627715	0	\N
1189	경상남도 합천군 율곡면 와리 424-3	2026-01-29 23:28:25.628197	35.6111101	128.1967634	OFFICIAL	2026-01-29 23:28:25.628202	0	\N
1190	경상남도 합천군 야로면 매촌리 300-1	2026-01-29 23:28:25.628641	35.7209982	128.1646808	OFFICIAL	2026-01-29 23:28:25.628645	0	\N
1191	서울특별시 구로구 가마산로 87 서울특별시 구로구 구로동 1281-1	2026-01-29 23:28:25.629156	37.48584845	126.876157	OFFICIAL	2026-01-29 23:28:25.629161	0	\N
1192	경상남도 합천군 대병면 상천길 29-1	2026-01-29 23:28:25.629595	35.5443764	128.0280579	OFFICIAL	2026-01-29 23:28:25.629601	0	\N
1193	경상남도 합천군 대병면 양리 631	2026-01-29 23:28:25.630043	35.5058701	128.0239437	OFFICIAL	2026-01-29 23:28:25.630047	0	\N
1194	경상남도 합천군 가회면 안불길 127	2026-01-29 23:28:25.630483	35.4486652	128.0348103	OFFICIAL	2026-01-29 23:28:25.630489	0	\N
1195	경상남도 합천군 가회면 오도리 1016-3	2026-01-29 23:28:25.630951	35.4515047	128.0343709	OFFICIAL	2026-01-29 23:28:25.630955	0	\N
1196	경상남도 합천군 가회면 장대리 677	2026-01-29 23:28:25.631434	35.4422671	128.0545132	OFFICIAL	2026-01-29 23:28:25.631439	0	\N
1197	경상남도 합천군 삼가면 외톨리 577-2	2026-01-29 23:28:25.631879	35.4136416	128.1045828	OFFICIAL	2026-01-29 23:28:25.631883	0	\N
1198	경상남도 합천군 쌍백면 하신리 809-3	2026-01-29 23:28:25.632316	35.4610897	128.1251036	OFFICIAL	2026-01-29 23:28:25.632321	0	\N
1199	경상남도 합천군 쌍백면 외초리 1060	2026-01-29 23:28:25.632794	35.4127127	128.1687308	OFFICIAL	2026-01-29 23:28:25.632799	0	\N
1200	경상남도 합천군 쌍백면 평구리 887-1	2026-01-29 23:28:25.633266	35.4411999	128.1379711	OFFICIAL	2026-01-29 23:28:25.633271	0	\N
1201	경상남도 합천군 쌍백면 평구리 837-4	2026-01-29 23:28:25.633708	35.4348169	128.1389735	OFFICIAL	2026-01-29 23:28:25.633712	0	\N
1202	경상남도 합천군 쌍백면 죽전리 672-3	2026-01-29 23:28:25.634177	35.4542199	128.1172602	OFFICIAL	2026-01-29 23:28:25.634182	0	\N
1203	경상남도 합천군 쌍백면 백역리 1014	2026-01-29 23:28:25.634629	35.4854131	128.1213942	OFFICIAL	2026-01-29 23:28:25.634634	0	\N
1204	경상남도 합천군 쌍백면 죽전리 111	2026-01-29 23:28:25.635132	35.4446461	128.1272702	OFFICIAL	2026-01-29 23:28:25.635137	0	\N
1205	경상남도 합천군 쌍백면 안계리 955	2026-01-29 23:28:25.635592	35.4354249	128.1831954	OFFICIAL	2026-01-29 23:28:25.635597	0	\N
1206	경상남도 합천군 쌍백면 외초리 554-6	2026-01-29 23:28:25.636033	35.4198881	128.1685916	OFFICIAL	2026-01-29 23:28:25.636037	0	\N
1207	경상남도 합천군 쌍백면 하신리 708-3	2026-01-29 23:28:25.636475	35.4679961	128.1235166	OFFICIAL	2026-01-29 23:28:25.63648	0	\N
1208	경상남도 합천군 쌍백면 삼리 251-5	2026-01-29 23:28:25.636961	35.4671705	128.0999032	OFFICIAL	2026-01-29 23:28:25.636965	0	\N
1209	경상남도 합천군 쌍백면 백역리 971-4	2026-01-29 23:28:25.637939	35.4793357	128.1232915	OFFICIAL	2026-01-29 23:28:25.637944	0	\N
1210	경상남도 합천군 쌍백면 외초리 1065	2026-01-29 23:28:25.638415	35.4111052	128.1708966	OFFICIAL	2026-01-29 23:28:25.63842	0	\N
1211	경상남도 합천군 대양면 백암리 367	2026-01-29 23:28:25.639368	35.4969628	128.2209542	OFFICIAL	2026-01-29 23:28:25.639374	0	\N
1212	경상남도 합천군 대양면 덕정리 706-3	2026-01-29 23:28:25.639893	35.5142588	128.1783471	OFFICIAL	2026-01-29 23:28:25.639898	0	\N
1213	경상남도 합천군 대양면 양산리 588-12	2026-01-29 23:28:25.640475	35.5031786	128.1672774	OFFICIAL	2026-01-29 23:28:25.64048	0	\N
1214	경상남도 합천군 대양면 함지리 173-6	2026-01-29 23:28:25.64121	35.4912131	128.1637477	OFFICIAL	2026-01-29 23:28:25.641215	0	\N
1215	경상남도 합천군 대양면 무곡리 984	2026-01-29 23:28:25.641723	35.5213401	128.1866761	OFFICIAL	2026-01-29 23:28:25.641728	0	\N
1216	경상남도 합천군 대양면 무곡리 1258-1	2026-01-29 23:28:25.642231	35.5178917	128.2010229	OFFICIAL	2026-01-29 23:28:25.642236	0	\N
1217	경상남도 합천군 대양면 안금리 576-2	2026-01-29 23:28:25.642713	35.4959148	128.1848427	OFFICIAL	2026-01-29 23:28:25.642717	0	\N
1218	경상남도 합천군 대양면 백암리 542	2026-01-29 23:28:25.643189	35.4974459	128.2129423	OFFICIAL	2026-01-29 23:28:25.643194	0	\N
1219	경상남도 합천군 대양면 정양리 293	2026-01-29 23:28:25.643637	35.5428363	128.1630034	OFFICIAL	2026-01-29 23:28:25.643641	0	\N
1220	경상남도 합천군 적중면 정토리 206-1	2026-01-29 23:28:25.644091	35.5296748	128.2569581	OFFICIAL	2026-01-29 23:28:25.644096	0	\N
1221	경상남도 합천군 적중면 두방리 45	2026-01-29 23:28:25.644533	35.5372111	128.2996487	OFFICIAL	2026-01-29 23:28:25.644538	0	\N
1222	경상남도 합천군 적중면 명곡2길 40	2026-01-29 23:28:25.644975	35.5288334	128.2707277	OFFICIAL	2026-01-29 23:28:25.64498	0	\N
1223	경상남도 합천군 합천읍 합천리 872-1	2026-01-29 23:28:25.645427	35.5625799	128.1604401	OFFICIAL	2026-01-29 23:28:25.645432	0	\N
1224	경상남도 합천군 합천읍 합천리 348-7	2026-01-29 23:28:25.645867	35.5656722	128.1666461	OFFICIAL	2026-01-29 23:28:25.645872	0	\N
1225	경상남도 합천군 합천읍 합천리 501-2	2026-01-29 23:28:25.646308	35.5681729	128.1570201	OFFICIAL	2026-01-29 23:28:25.646312	0	\N
1226	경상남도 합천군 합천읍 합천리 477-52	2026-01-29 23:28:25.646776	35.5692507	128.1600121	OFFICIAL	2026-01-29 23:28:25.646781	0	\N
1227	경상남도 합천군 합천읍 영창리 17-3	2026-01-29 23:28:25.64722	35.5820572	128.1680922	OFFICIAL	2026-01-29 23:28:25.647225	0	\N
1228	경상남도 합천군 합천읍 내곡리 655-1	2026-01-29 23:28:25.647668	35.6412923	128.1498421	OFFICIAL	2026-01-29 23:28:25.647672	0	\N
1229	경상남도 합천군 합천읍 합천리 360-9	2026-01-29 23:28:25.648112	35.5675636	128.1677421	OFFICIAL	2026-01-29 23:28:25.648118	0	\N
1230	경상남도 합천군 합천읍 인곡리 629	2026-01-29 23:28:25.648551	35.6052621	128.1000635	OFFICIAL	2026-01-29 23:28:25.648555	0	\N
1231	경상남도 합천군 합천읍 합천리 915-20	2026-01-29 23:28:25.648988	35.5612523	128.1555505	OFFICIAL	2026-01-29 23:28:25.648993	0	\N
1232	경상남도 합천군 합천읍 영창리 614-7	2026-01-29 23:28:25.649436	35.5715386	128.1611639	OFFICIAL	2026-01-29 23:28:25.649441	0	\N
1233	경상남도 합천군 합천읍 영창리 917	2026-01-29 23:28:25.649907	35.5738895	128.1555749	OFFICIAL	2026-01-29 23:28:25.649911	0	\N
1234	경상남도 합천군 합천읍 합천리 700-2	2026-01-29 23:28:25.650512	35.5636705	128.1604752	OFFICIAL	2026-01-29 23:28:25.650516	0	\N
1235	경상남도 합천군 합천읍 합천리 856-40	2026-01-29 23:28:25.651031	35.5631059	128.1579921	OFFICIAL	2026-01-29 23:28:25.651035	0	\N
1236	경상남도 합천군 합천읍 합천리 1013	2026-01-29 23:28:25.651502	35.5660291	128.1559569	OFFICIAL	2026-01-29 23:28:25.651507	0	\N
1237	경상남도 합천군 합천읍 대야로 890-10	2026-01-29 23:28:25.651978	35.5676137	128.1640905	OFFICIAL	2026-01-29 23:28:25.651983	0	\N
1238	경상남도 합천군 합천읍 합천리 1365-108	2026-01-29 23:28:25.652436	35.5677503	128.1562691	OFFICIAL	2026-01-29 23:28:25.65244	0	\N
1239	경상남도 합천군 합천읍 신소양1길 4	2026-01-29 23:28:25.65291	35.5788756	128.1679422	OFFICIAL	2026-01-29 23:28:25.652915	0	\N
1240	경상남도 합천군 합천읍 합천리 976-22	2026-01-29 23:28:25.653356	35.5642986	128.1557771	OFFICIAL	2026-01-29 23:28:25.65336	0	\N
1241	경상남도 합천군 합천읍 합천리 978-10	2026-01-29 23:28:25.653828	35.5652272	128.1556906	OFFICIAL	2026-01-29 23:28:25.653833	0	\N
1242	경상남도 합천군 합천읍 합천리 655-8	2026-01-29 23:28:25.654265	35.5678971	128.1611125	OFFICIAL	2026-01-29 23:28:25.654269	0	\N
1243	경상남도 합천군 합천읍 합천리 249-3	2026-01-29 23:28:25.654701	35.5630465	128.1620404	OFFICIAL	2026-01-29 23:28:25.654706	0	\N
1244	경상남도 합천군 합천읍 합천리 539-2	2026-01-29 23:28:25.655222	35.5668751	128.1568962	OFFICIAL	2026-01-29 23:28:25.655227	0	\N
1245	경상남도 합천군 합천읍 중앙로 75	2026-01-29 23:28:25.655714	35.5674951	128.1585081	OFFICIAL	2026-01-29 23:28:25.655719	0	\N
1246	경상남도 합천군 용주면 가호리 633-4	2026-01-29 23:28:25.656207	35.5508604	128.0662891	OFFICIAL	2026-01-29 23:28:25.656211	0	\N
1247	경상남도 합천군 용주면 평산리 378	2026-01-29 23:28:25.65665	35.5255736	128.1175514	OFFICIAL	2026-01-29 23:28:25.656656	0	\N
1248	경상남도 합천군 용주면 우곡리 283-5	2026-01-29 23:28:25.657138	35.5733782	128.0789623	OFFICIAL	2026-01-29 23:28:25.657143	0	\N
1249	경상남도 합천군 용주면 고품리 1183-1	2026-01-29 23:28:25.657592	35.5396552	128.0947657	OFFICIAL	2026-01-29 23:28:25.657597	0	\N
1250	경상남도 합천군 대병면 유전리 1236	2026-01-29 23:28:25.658031	35.5326433	128.0087782	OFFICIAL	2026-01-29 23:28:25.658035	0	\N
1251	경상남도 합천군 대병면 송리 480	2026-01-29 23:28:25.658467	35.5431461	128.0428579	OFFICIAL	2026-01-29 23:28:25.658471	0	\N
1252	경상남도 합천군 대병면 회양리 418-2	2026-01-29 23:28:25.659027	35.5196704	128.0233965	OFFICIAL	2026-01-29 23:28:25.659031	0	\N
1253	서울특별시 성북구 보문로 52 서울특별시 성북구 보문동7가 104	2026-01-29 23:28:25.659492	37.58021816	127.0226114	OFFICIAL	2026-01-29 23:28:25.659497	0	\N
1254	경상남도 합천군 봉산면 계산리 616-3	2026-01-29 23:28:25.659975	35.6005987	128.0655355	OFFICIAL	2026-01-29 23:28:25.65998	0	\N
1255	경상남도 합천군 봉산면 계산리 1252-1	2026-01-29 23:28:25.660543	35.5996091	128.0619478	OFFICIAL	2026-01-29 23:28:25.660547	0	\N
1256	경상남도 합천군 봉산면 계산리 616-3	2026-01-29 23:28:25.660988	35.6005987	128.0655355	OFFICIAL	2026-01-29 23:28:25.660993	0	\N
1257	경상남도 합천군 봉산면 계산리 406	2026-01-29 23:28:25.661424	35.6112793	128.0667032	OFFICIAL	2026-01-29 23:28:25.661429	0	\N
1258	경상남도 합천군 합천읍 서산리 361-4	2026-01-29 23:28:25.661904	35.5917959	128.1282751	OFFICIAL	2026-01-29 23:28:25.661909	0	\N
1259	경상남도 합천군 합천읍 합천리 420-49	2026-01-29 23:28:25.662358	35.5697581	128.1648011	OFFICIAL	2026-01-29 23:28:25.662363	0	\N
1260	경상남도 합천군 합천읍 영창리 535-9	2026-01-29 23:28:25.66283	35.5728792	128.1629981	OFFICIAL	2026-01-29 23:28:25.662835	0	\N
1261	경상남도 합천군 합천읍 합천리 420-49	2026-01-29 23:28:25.663313	35.5697581	128.1648011	OFFICIAL	2026-01-29 23:28:25.663318	0	\N
1262	경상남도 합천군 합천읍 동서로 141-17	2026-01-29 23:28:25.663762	35.5669335	128.1671451	OFFICIAL	2026-01-29 23:28:25.663768	0	\N
1263	경상남도 합천군 합천읍 금양리 355	2026-01-29 23:28:25.664238	35.5921362	128.1733111	OFFICIAL	2026-01-29 23:28:25.664243	0	\N
1264	경상남도 합천군 합천읍 합천리 702-3	2026-01-29 23:28:25.664885	35.5636356	128.1595926	OFFICIAL	2026-01-29 23:28:25.664889	0	\N
1265	경상남도 합천군 합천읍 핫들1로 50	2026-01-29 23:28:25.665452	35.5726233	128.1655681	OFFICIAL	2026-01-29 23:28:25.665457	0	\N
1266	경상남도 합천군 합천읍 합천리 1162-2	2026-01-29 23:28:25.666044	35.5682947	128.1535011	OFFICIAL	2026-01-29 23:28:25.666049	0	\N
1267	경상남도 합천군 합천읍 합천리 817-1	2026-01-29 23:28:25.666534	35.5645114	128.1584802	OFFICIAL	2026-01-29 23:28:25.666539	0	\N
1268	경상남도 합천군 합천읍 합천리 725-1	2026-01-29 23:28:25.666982	35.5665201	128.1595211	OFFICIAL	2026-01-29 23:28:25.666986	0	\N
1269	경상남도 합천군 합천읍 합천리 415-2	2026-01-29 23:28:25.667426	35.5686973	128.1626696	OFFICIAL	2026-01-29 23:28:25.66743	0	\N
1270	경상남도 합천군 합천읍 합천리 417-13	2026-01-29 23:28:25.667905	35.5691759	128.1619976	OFFICIAL	2026-01-29 23:28:25.66791	0	\N
1271	경상남도 합천군 합천읍 합천리 959-7	2026-01-29 23:28:25.668385	35.5619628	128.1567874	OFFICIAL	2026-01-29 23:28:25.66839	0	\N
1272	경상남도 합천군 합천읍 서산리 534-1	2026-01-29 23:28:25.668863	35.5962612	128.1487871	OFFICIAL	2026-01-29 23:28:25.668867	0	\N
1273	경상남도 합천군 합천읍 용계리 424-6	2026-01-29 23:28:25.669342	35.6287813	128.1702545	OFFICIAL	2026-01-29 23:28:25.669346	0	\N
1274	경상남도 합천군 합천읍 합천리 702-3	2026-01-29 23:28:25.669866	35.5636356	128.1595926	OFFICIAL	2026-01-29 23:28:25.66987	0	\N
1275	경상남도 합천군 합천읍 합천리 850-2	2026-01-29 23:28:25.67034	35.5629436	128.1580689	OFFICIAL	2026-01-29 23:28:25.670345	0	\N
1276	경상남도 합천군 합천읍 합천리 1227-6	2026-01-29 23:28:25.670838	35.5681833	128.1559831	OFFICIAL	2026-01-29 23:28:25.670843	0	\N
1277	경상남도 합천군 합천읍 합천리 981-3	2026-01-29 23:28:25.671394	35.5650907	128.1566391	OFFICIAL	2026-01-29 23:28:25.671398	0	\N
1278	경상남도 합천군 합천읍 합천리 952-2	2026-01-29 23:28:25.671892	35.5630457	128.1557746	OFFICIAL	2026-01-29 23:28:25.671897	0	\N
1279	경상남도 합천군 합천읍 합천리 697-4	2026-01-29 23:28:25.672537	35.5646801	128.1604331	OFFICIAL	2026-01-29 23:28:25.672542	0	\N
1280	경상남도 합천군 합천읍 합천리 154-4	2026-01-29 23:28:25.67319	35.5655525	128.1684771	OFFICIAL	2026-01-29 23:28:25.673198	0	\N
1281	경상남도 합천군 합천읍 합천리 418-18	2026-01-29 23:28:25.674113	35.5693359	128.1636307	OFFICIAL	2026-01-29 23:28:25.674118	0	\N
1282	경상남도 합천군 합천읍 용계리 963	2026-01-29 23:28:25.674652	35.6367407	128.1634919	OFFICIAL	2026-01-29 23:28:25.674657	0	\N
1283	경상남도 합천군 합천읍 외곡리 933-3	2026-01-29 23:28:25.675751	35.6279934	128.1379159	OFFICIAL	2026-01-29 23:28:25.675757	0	\N
1284	경상남도 합천군 율곡면 영전리 74-4	2026-01-29 23:28:25.676342	35.5682415	128.2070949	OFFICIAL	2026-01-29 23:28:25.676353	0	\N
1285	경상남도 합천군 율곡면 갑산2길 14-6	2026-01-29 23:28:25.676994	35.5897028	128.2457175	OFFICIAL	2026-01-29 23:28:25.677	0	\N
1286	경상남도 합천군 율곡면 내천리 594-6	2026-01-29 23:28:25.677594	35.6109354	128.2386188	OFFICIAL	2026-01-29 23:28:25.677601	0	\N
1287	경상남도 합천군 야로면 구정리 51-4	2026-01-29 23:28:25.678224	35.7028518	128.1726221	OFFICIAL	2026-01-29 23:28:25.67823	0	\N
1288	경상남도 합천군 야로면 나대길 112	2026-01-29 23:28:25.678821	35.7350301	128.1663016	OFFICIAL	2026-01-29 23:28:25.678826	0	\N
1289	경상남도 합천군 야로면 창동청계길 281	2026-01-29 23:28:25.679303	35.7115511	128.2009554	OFFICIAL	2026-01-29 23:28:25.679308	0	\N
1290	경상남도 합천군 야로면 하림리 109-4	2026-01-29 23:28:25.679807	35.7481862	128.1554822	OFFICIAL	2026-01-29 23:28:25.679812	0	\N
1291	경상남도 합천군 야로면 월광리 69-2	2026-01-29 23:28:25.68028	35.7305354	128.1573051	OFFICIAL	2026-01-29 23:28:25.680285	0	\N
1292	경상남도 합천군 야로면 금평리 114	2026-01-29 23:28:25.680839	35.7080143	128.1862262	OFFICIAL	2026-01-29 23:28:25.680844	0	\N
1293	경상남도 합천군 야로면 정대리 520-3	2026-01-29 23:28:25.681344	35.6965222	128.1677244	OFFICIAL	2026-01-29 23:28:25.68135	0	\N
1294	경상남도 합천군 가야면 구미2길 114-7	2026-01-29 23:28:25.681832	35.7442631	128.1082198	OFFICIAL	2026-01-29 23:28:25.681837	0	\N
1295	경상남도 합천군 가야면 매화산로 659	2026-01-29 23:28:25.682314	35.7749818	128.1258921	OFFICIAL	2026-01-29 23:28:25.682319	0	\N
1296	경상남도 합천군 묘산면 안성리 506-2	2026-01-29 23:28:25.682881	35.6722268	128.1265811	OFFICIAL	2026-01-29 23:28:25.682886	0	\N
1297	경상남도 합천군 묘산면 봉곡리 105	2026-01-29 23:28:25.683381	35.6378352	128.1130008	OFFICIAL	2026-01-29 23:28:25.683386	0	\N
1298	경상남도 합천군 묘산면 묘산로 163	2026-01-29 23:28:25.683868	35.6580171	128.1126426	OFFICIAL	2026-01-29 23:28:25.683873	0	\N
1299	경상남도 합천군 묘산면 화양리 870	2026-01-29 23:28:25.684321	35.6957525	128.1263309	OFFICIAL	2026-01-29 23:28:25.684326	0	\N
1300	경상남도 합천군 묘산면 양지리 671	2026-01-29 23:28:25.684789	35.6431567	128.1187613	OFFICIAL	2026-01-29 23:28:25.684794	0	\N
1301	경상남도 합천군 묘산면 거산리 605-3	2026-01-29 23:28:25.685221	35.6786502	128.1454709	OFFICIAL	2026-01-29 23:28:25.685225	0	\N
1302	경상남도 합천군 묘산면 관기리 280-2	2026-01-29 23:28:25.685644	35.6499951	128.1304884	OFFICIAL	2026-01-29 23:28:25.685649	0	\N
1303	경상남도 합천군 묘산면 화양리 353-3	2026-01-29 23:28:25.686062	35.6814755	128.1341633	OFFICIAL	2026-01-29 23:28:25.686067	0	\N
1304	경상남도 합천군 묘산면 도옥리 156-410	2026-01-29 23:28:25.6865	35.6624522	128.1215622	OFFICIAL	2026-01-29 23:28:25.686505	0	\N
1305	경상남도 합천군 묘산면 거산리 525-2	2026-01-29 23:28:25.686975	35.6804291	128.1502356	OFFICIAL	2026-01-29 23:28:25.68698	0	\N
1306	경상남도 합천군 묘산면 관기리 639-3	2026-01-29 23:28:25.68742	35.6479709	128.1267746	OFFICIAL	2026-01-29 23:28:25.687425	0	\N
1307	경상남도 합천군 묘산면 산제리 462	2026-01-29 23:28:25.68786	35.6613493	128.1057995	OFFICIAL	2026-01-29 23:28:25.687865	0	\N
1308	경상남도 합천군 묘산면 광산리 272	2026-01-29 23:28:25.688379	35.6429674	128.1188273	OFFICIAL	2026-01-29 23:28:25.688384	0	\N
1309	경상남도 합천군 묘산면 팔심리 480-10	2026-01-29 23:28:25.688866	35.6241789	128.0924807	OFFICIAL	2026-01-29 23:28:25.688871	0	\N
1310	경상남도 합천군 봉산면 압곡리 167-4	2026-01-29 23:28:25.689365	35.6384065	128.0570973	OFFICIAL	2026-01-29 23:28:25.68937	0	\N
1311	경상남도 합천군 봉산면 압곡리 582	2026-01-29 23:28:25.689852	35.6475205	128.0544203	OFFICIAL	2026-01-29 23:28:25.689857	0	\N
1312	경상남도 합천군 봉산면 술곡리 516-6	2026-01-29 23:28:25.690298	35.5764954	127.9914718	OFFICIAL	2026-01-29 23:28:25.690304	0	\N
1313	경상남도 합천군 봉산면 계산리 136	2026-01-29 23:28:25.690782	35.5904741	128.0696654	OFFICIAL	2026-01-29 23:28:25.690787	0	\N
1314	서울특별시 노원구 동일로228길 23	2026-01-29 23:28:25.691247	37.66985723	127.0587456	OFFICIAL	2026-01-29 23:28:25.691285	0	\N
1315	서울특별시 성북구 성북동 118-2	2026-01-29 23:28:25.691727	37.59249965	126.9977895	OFFICIAL	2026-01-29 23:28:25.691732	0	\N
1316	경상남도 합천군 적중면 죽고리 342-3	2026-01-29 23:28:25.692214	35.5663139	128.3006726	OFFICIAL	2026-01-29 23:28:25.692243	0	\N
1317	경상남도 합천군 적중면 죽고리 50-1	2026-01-29 23:28:25.692708	35.5638488	128.3059585	OFFICIAL	2026-01-29 23:28:25.692714	0	\N
1318	경상남도 합천군 적중면 황정리 227-6	2026-01-29 23:28:25.693185	35.5356957	128.2851859	OFFICIAL	2026-01-29 23:28:25.69319	0	\N
1319	경상남도 합천군 적중면 정토리 218-5	2026-01-29 23:28:25.693626	35.5299091	128.2569699	OFFICIAL	2026-01-29 23:28:25.693631	0	\N
1320	경상남도 합천군 덕곡면 율지리 86	2026-01-29 23:28:25.694046	35.6145942	128.3588821	OFFICIAL	2026-01-29 23:28:25.69405	0	\N
1321	경상남도 합천군 덕곡면 율지리 314-1	2026-01-29 23:28:25.694486	35.6135357	128.3540977	OFFICIAL	2026-01-29 23:28:25.694491	0	\N
1322	경상남도 합천군 덕곡면 율원리 562	2026-01-29 23:28:25.694955	35.6385662	128.2902215	OFFICIAL	2026-01-29 23:28:25.694959	0	\N
1323	경상남도 합천군 쌍책면 진정리 499	2026-01-29 23:28:25.695391	35.5923448	128.2899111	OFFICIAL	2026-01-29 23:28:25.695396	0	\N
1324	경상남도 합천군 쌍책면 다라리 473-2	2026-01-29 23:28:25.695861	35.5809782	128.2900357	OFFICIAL	2026-01-29 23:28:25.695865	0	\N
1325	경상남도 합천군 쌍책면 성산리 150-10	2026-01-29 23:28:25.696302	35.5777911	128.2847282	OFFICIAL	2026-01-29 23:28:25.696307	0	\N
1326	경상남도 합천군 쌍책면 성산리 58-4	2026-01-29 23:28:25.696743	35.5753277	128.2858117	OFFICIAL	2026-01-29 23:28:25.696776	0	\N
1327	경상남도 합천군 초계면 초계3길 4	2026-01-29 23:28:25.697219	35.5586361	128.2693277	OFFICIAL	2026-01-29 23:28:25.697223	0	\N
1328	경상남도 합천군 초계면 초계2길 12-11	2026-01-29 23:28:25.697675	35.5581462	128.2667008	OFFICIAL	2026-01-29 23:28:25.69768	0	\N
1329	경상남도 합천군 초계면 초계리 250-1	2026-01-29 23:28:25.698152	35.5604521	128.2633991	OFFICIAL	2026-01-29 23:28:25.698156	0	\N
1330	경상남도 합천군 초계면 초계리 25-4	2026-01-29 23:28:25.698595	35.5582596	128.2684109	OFFICIAL	2026-01-29 23:28:25.6986	0	\N
1331	경상남도 합천군 초계면 초계리 47	2026-01-29 23:28:25.699066	35.5601085	128.2679427	OFFICIAL	2026-01-29 23:28:25.69907	0	\N
1332	경상남도 합천군 초계면 중리 380-21	2026-01-29 23:28:25.699508	35.5590822	128.2505437	OFFICIAL	2026-01-29 23:28:25.699514	0	\N
1333	경상남도 합천군 초계면 초계리 117-1	2026-01-29 23:28:25.700022	35.5588574	128.2671112	OFFICIAL	2026-01-29 23:28:25.700027	0	\N
1334	경상남도 합천군 초계면 아막재로 19	2026-01-29 23:28:25.700474	35.5609194	128.2680557	OFFICIAL	2026-01-29 23:28:25.70048	0	\N
1335	경상남도 합천군 초계면 초계리 96-6	2026-01-29 23:28:25.701026	35.5590503	128.2654793	OFFICIAL	2026-01-29 23:28:25.701031	0	\N
1336	경상남도 합천군 초계면 아막재로 38	2026-01-29 23:28:25.70149	35.5623961	128.2687997	OFFICIAL	2026-01-29 23:28:25.701494	0	\N
1337	경상남도 합천군 초계면 초계중앙로 78	2026-01-29 23:28:25.701953	35.5590434	128.2685679	OFFICIAL	2026-01-29 23:28:25.701958	0	\N
1338	경상남도 합천군 초계면 초계중앙로 9	2026-01-29 23:28:25.702399	35.5592669	128.2612332	OFFICIAL	2026-01-29 23:28:25.702404	0	\N
1339	경상남도 합천군 율곡면 영전리 74-4	2026-01-29 23:28:25.702867	35.5682415	128.2070949	OFFICIAL	2026-01-29 23:28:25.702871	0	\N
1340	경상남도 합천군 율곡면 임북공단길 12-9	2026-01-29 23:28:25.703305	35.5792903	128.1803668	OFFICIAL	2026-01-29 23:28:25.703311	0	\N
1341	경상남도 합천군 율곡면 제내리 439	2026-01-29 23:28:25.703852	35.5849868	128.2084181	OFFICIAL	2026-01-29 23:28:25.703857	0	\N
1342	경상남도 합천군 율곡면 문림리 327-4	2026-01-29 23:28:25.704315	35.5690861	128.1924242	OFFICIAL	2026-01-29 23:28:25.704319	0	\N
1343	경상남도 합천군 율곡면 낙민리 655-1	2026-01-29 23:28:25.704776	35.5800264	128.2250218	OFFICIAL	2026-01-29 23:28:25.70478	0	\N
1344	경상남도 합천군 율곡면 영전리 455-1	2026-01-29 23:28:25.705218	35.5724136	128.2180941	OFFICIAL	2026-01-29 23:28:25.705223	0	\N
1345	서울특별시 노원구 동일로 1456	2026-01-29 23:28:25.705663	37.66067691	127.0614956	OFFICIAL	2026-01-29 23:28:25.705667	0	\N
1346	경상남도 합천군 삼가면 양전리 207	2026-01-29 23:28:25.706128	35.4259488	128.1375045	OFFICIAL	2026-01-29 23:28:25.706133	0	\N
1347	경상남도 합천군 삼가면 동리 944	2026-01-29 23:28:25.706567	35.4189365	128.1447273	OFFICIAL	2026-01-29 23:28:25.706571	0	\N
1348	경상남도 합천군 삼가면 금리 12-8	2026-01-29 23:28:25.706989	35.4162979	128.1263777	OFFICIAL	2026-01-29 23:28:25.706995	0	\N
1349	경상남도 합천군 삼가면 학리 608-2	2026-01-29 23:28:25.707468	35.3968695	128.0896664	OFFICIAL	2026-01-29 23:28:25.707473	0	\N
1350	경상남도 합천군 삼가면 동리 135-6	2026-01-29 23:28:25.707928	35.4188643	128.1447822	OFFICIAL	2026-01-29 23:28:25.707933	0	\N
1351	경상남도 합천군 삼가면 하판리 1899	2026-01-29 23:28:25.70837	35.4240651	128.1111267	OFFICIAL	2026-01-29 23:28:25.708375	0	\N
1352	경상남도 합천군 삼가면 양천강변길 130-43	2026-01-29 23:28:25.708829	35.4096606	128.1292081	OFFICIAL	2026-01-29 23:28:25.708834	0	\N
1353	경상남도 합천군 삼가면 삼가중앙길 32-3	2026-01-29 23:28:25.70927	35.4141288	128.1232802	OFFICIAL	2026-01-29 23:28:25.709275	0	\N
1354	경상남도 합천군 쌍백면 평지리 578-5	2026-01-29 23:28:25.709706	35.4402801	128.1732162	OFFICIAL	2026-01-29 23:28:25.70971	0	\N
1355	경상남도 합천군 쌍백면 대곡리 577-1	2026-01-29 23:28:25.710169	35.4687129	128.1893531	OFFICIAL	2026-01-29 23:28:25.710174	0	\N
1356	경상남도 합천군 쌍백면 외초리 123	2026-01-29 23:28:25.710605	35.4110224	128.1720415	OFFICIAL	2026-01-29 23:28:25.71061	0	\N
1357	경상남도 합천군 쌍백면 평구리 1328-13	2026-01-29 23:28:25.711038	35.4394346	128.1444776	OFFICIAL	2026-01-29 23:28:25.711043	0	\N
1358	경상남도 합천군 쌍백면 평구리 570-2	2026-01-29 23:28:25.711472	35.4386421	128.1439035	OFFICIAL	2026-01-29 23:28:25.711477	0	\N
1359	경상남도 합천군 쌍백면 외초리 1062-2	2026-01-29 23:28:25.711934	35.4123892	128.1680035	OFFICIAL	2026-01-29 23:28:25.711939	0	\N
1360	경상남도 합천군 쌍백면 평구리 306-7	2026-01-29 23:28:25.712366	35.4402859	128.1485986	OFFICIAL	2026-01-29 23:28:25.712371	0	\N
1361	경상남도 합천군 쌍백면 평구리 1328-13	2026-01-29 23:28:25.712869	35.4394346	128.1444776	OFFICIAL	2026-01-29 23:28:25.712873	0	\N
1362	경상남도 합천군 대양면 덕정리 959	2026-01-29 23:28:25.713305	35.5134282	128.1730314	OFFICIAL	2026-01-29 23:28:25.71331	0	\N
1363	경상남도 합천군 대양면 안금리 815	2026-01-29 23:28:25.713745	35.4901316	128.1824047	OFFICIAL	2026-01-29 23:28:25.713778	0	\N
1364	경상남도 합천군 대양면 대목리 61	2026-01-29 23:28:25.714213	35.5276044	128.1684969	OFFICIAL	2026-01-29 23:28:25.714218	0	\N
1365	경상남도 합천군 대양면 양산리 568-5	2026-01-29 23:28:25.714655	35.5033944	128.1676416	OFFICIAL	2026-01-29 23:28:25.71466	0	\N
1366	경상남도 합천군 대양면 양산리 757	2026-01-29 23:28:25.715582	35.5038536	128.1743778	OFFICIAL	2026-01-29 23:28:25.715588	0	\N
1367	경상남도 합천군 대양면 양산리 923	2026-01-29 23:28:25.716062	35.5081735	128.1789399	OFFICIAL	2026-01-29 23:28:25.716066	0	\N
1368	경상남도 합천군 대양면 무곡리 695	2026-01-29 23:28:25.716507	35.5224481	128.1928972	OFFICIAL	2026-01-29 23:28:25.716512	0	\N
1369	경상남도 합천군 대양면 무곡리 984	2026-01-29 23:28:25.716972	35.5213401	128.1866761	OFFICIAL	2026-01-29 23:28:25.716977	0	\N
1370	경상남도 합천군 대양면 도리 109	2026-01-29 23:28:25.717434	35.5007996	128.1531852	OFFICIAL	2026-01-29 23:28:25.717439	0	\N
1371	경상남도 합천군 청덕면 성태리 1023-5	2026-01-29 23:28:25.717869	35.5774253	128.3157525	OFFICIAL	2026-01-29 23:28:25.717874	0	\N
1372	경상남도 합천군 청덕면 앙진리 산91-1	2026-01-29 23:28:25.718314	35.5044503	128.3575646	OFFICIAL	2026-01-29 23:28:25.718319	0	\N
1373	경상남도 합천군 청덕면 두곡리 311-6	2026-01-29 23:28:25.718787	35.5540395	128.3173263	OFFICIAL	2026-01-29 23:28:25.718792	0	\N
1374	경상남도 합천군 청덕면 가현리 498-26	2026-01-29 23:28:25.719266	35.5672573	128.3294253	OFFICIAL	2026-01-29 23:28:25.719286	0	\N
1375	경상남도 합천군 청덕면 두곡리 299-9	2026-01-29 23:28:25.719727	35.5539554	128.3184731	OFFICIAL	2026-01-29 23:28:25.719732	0	\N
1376	서울특별시 노원구 노원로16길 15	2026-01-29 23:28:25.720174	37.64344507	127.0733372	OFFICIAL	2026-01-29 23:28:25.720179	0	\N
1377	경상남도 합천군 용주면 방곡리 315	2026-01-29 23:28:25.720618	35.5779505	128.1000185	OFFICIAL	2026-01-29 23:28:25.720622	0	\N
1378	경상남도 합천군 용주면 용지리 460-4	2026-01-29 23:28:25.721127	35.5395229	128.1123334	OFFICIAL	2026-01-29 23:28:25.721131	0	\N
1379	경상남도 합천군 대병면 성리 황계폭포로 129	2026-01-29 23:28:25.721565	35.5210915	128.0588774	OFFICIAL	2026-01-29 23:28:25.72157	0	\N
1380	경상남도 합천군 대병면 하금리 산109-4	2026-01-29 23:28:25.721992	35.5158123	127.9757126	OFFICIAL	2026-01-29 23:28:25.721997	0	\N
1381	경상남도 합천군 대병면 하금리 산111-4	2026-01-29 23:28:25.722433	35.5160187	127.9713026	OFFICIAL	2026-01-29 23:28:25.722438	0	\N
1382	경상남도 합천군 대병면 하금리 323-1	2026-01-29 23:28:25.722889	35.5302549	127.9963506	OFFICIAL	2026-01-29 23:28:25.722894	0	\N
1383	경상남도 합천군 대병면 하금리 307-7	2026-01-29 23:28:25.72338	35.5299032	127.9936491	OFFICIAL	2026-01-29 23:28:25.723386	0	\N
1384	경상남도 합천군 대병면 성리 1182-2	2026-01-29 23:28:25.723948	35.5233761	128.0498047	OFFICIAL	2026-01-29 23:28:25.723952	0	\N
1385	경상남도 합천군 가회면 외사리 609-3	2026-01-29 23:28:25.724396	35.4259144	128.0737963	OFFICIAL	2026-01-29 23:28:25.7244	0	\N
1386	경상남도 합천군 가회면 월계리 504-4	2026-01-29 23:28:25.724863	35.4848477	128.0568122	OFFICIAL	2026-01-29 23:28:25.724868	0	\N
1387	경상남도 합천군 가회면 둔내리 761-3	2026-01-29 23:28:25.72531	35.4713937	128.0120221	OFFICIAL	2026-01-29 23:28:25.725315	0	\N
1388	경상남도 합천군 가회면 함방리 441	2026-01-29 23:28:25.725791	35.4266174	128.0331819	OFFICIAL	2026-01-29 23:28:25.725795	0	\N
1389	경상남도 합천군 가회면 중촌리 572-8	2026-01-29 23:28:25.726227	35.4533932	128.0079544	OFFICIAL	2026-01-29 23:28:25.726232	0	\N
1390	경상남도 합천군 삼가면 모의로 59	2026-01-29 23:28:25.726661	35.3841851	128.1224862	OFFICIAL	2026-01-29 23:28:25.726666	0	\N
1391	경상남도 합천군 삼가면 덕진리 448	2026-01-29 23:28:25.727122	35.4126517	128.0786071	OFFICIAL	2026-01-29 23:28:25.727127	0	\N
1392	경상남도 합천군 삼가면 덕진리 497-1	2026-01-29 23:28:25.727549	35.4108067	128.0875458	OFFICIAL	2026-01-29 23:28:25.727553	0	\N
1393	경상남도 합천군 삼가면 소오리 398-5	2026-01-29 23:28:25.727996	35.4118985	128.1180798	OFFICIAL	2026-01-29 23:28:25.728	0	\N
1394	경상남도 합천군 삼가면 일부리 921-5	2026-01-29 23:28:25.728448	35.4125519	128.1227383	OFFICIAL	2026-01-29 23:28:25.728453	0	\N
1395	경상남도 합천군 삼가면 금리4길 56-10	2026-01-29 23:28:25.728902	35.4156429	128.1234697	OFFICIAL	2026-01-29 23:28:25.728907	0	\N
1396	경상남도 합천군 삼가면 용흥길 20	2026-01-29 23:28:25.729339	35.4079835	128.1210468	OFFICIAL	2026-01-29 23:28:25.729344	0	\N
1397	경상남도 합천군 삼가면 일부리 826-2	2026-01-29 23:28:25.729809	35.4130733	128.1240934	OFFICIAL	2026-01-29 23:28:25.729814	0	\N
1398	경상남도 합천군 삼가면 금리 621	2026-01-29 23:28:25.73024	35.4151874	128.1192628	OFFICIAL	2026-01-29 23:28:25.730245	0	\N
1399	경상남도 합천군 삼가면 금리 63-1	2026-01-29 23:28:25.730666	35.4140043	128.1215623	OFFICIAL	2026-01-29 23:28:25.730671	0	\N
1400	경상남도 합천군 삼가면 두모리 220-1	2026-01-29 23:28:25.73112	35.4144484	128.0991664	OFFICIAL	2026-01-29 23:28:25.731125	0	\N
1401	경상남도 합천군 삼가면 두모리 437	2026-01-29 23:28:25.731545	35.4136579	128.0957741	OFFICIAL	2026-01-29 23:28:25.73155	0	\N
1402	경상남도 합천군 삼가면 소오리 820	2026-01-29 23:28:25.732025	35.4072185	128.1198345	OFFICIAL	2026-01-29 23:28:25.73203	0	\N
1403	경상남도 합천군 삼가면 소오리 산1	2026-01-29 23:28:25.732456	35.4067252	128.1172905	OFFICIAL	2026-01-29 23:28:25.73246	0	\N
1404	경상남도 합천군 삼가면 일부리 920-1	2026-01-29 23:28:25.732909	35.4128501	128.1220891	OFFICIAL	2026-01-29 23:28:25.732913	0	\N
1405	경상남도 합천군 삼가면 외토리 577-2	2026-01-29 23:28:25.733337	35.3834557	128.1021774	OFFICIAL	2026-01-29 23:28:25.733341	0	\N
1406	경상남도 합천군 삼가면 외토리 810	2026-01-29 23:28:25.733826	35.3840725	128.0974782	OFFICIAL	2026-01-29 23:28:25.73383	0	\N
1407	서울특별시 노원구 동일로203가길 29	2026-01-29 23:28:25.734299	37.63987596	127.0642838	OFFICIAL	2026-01-29 23:28:25.734303	0	\N
1408	경상북도 영덕군 영덕읍 강변길 52 경상북도 영덕군 영덕읍 덕곡리 151-3	2026-01-29 23:28:25.73479	36.41146889	129.3709522	OFFICIAL	2026-01-29 23:28:25.734796	0	\N
1409	경상북도 영덕군 영덕읍 덕곡리 197-7	2026-01-29 23:28:25.736338	36.4154975	129.3720899	OFFICIAL	2026-01-29 23:28:25.736344	0	\N
1410	경상북도 영덕군 영덕읍 덕곡리 135-8	2026-01-29 23:28:25.738177	36.41173387	129.3729662	OFFICIAL	2026-01-29 23:28:25.738183	0	\N
1411	경상북도 영덕군 영덕읍 군청길 86 경상북도 영덕군 영덕읍 덕곡리 186	2026-01-29 23:28:25.738897	36.41450621	129.3697335	OFFICIAL	2026-01-29 23:28:25.738902	0	\N
1412	경상북도 영덕군 영덕읍 덕곡리 323-1	2026-01-29 23:28:25.739535	36.415978	129.3726013	OFFICIAL	2026-01-29 23:28:25.73954	0	\N
1413	경상북도 영덕군 영덕읍 남석리 317	2026-01-29 23:28:25.740169	36.40874402	129.3705972	OFFICIAL	2026-01-29 23:28:25.740174	0	\N
1414	경상북도 영덕군 영덕읍 남석리 52-2	2026-01-29 23:28:25.740647	36.40914594	129.3683437	OFFICIAL	2026-01-29 23:28:25.740652	0	\N
1415	경상북도 영덕군 영덕읍 미듬길 8 경상북도 영덕군 영덕읍 화개리 46-2	2026-01-29 23:28:25.741119	36.41772104	129.3724181	OFFICIAL	2026-01-29 23:28:25.741124	0	\N
1416	경상남도 합천군 합천읍 충효로 13	2026-01-29 23:28:25.741677	35.5615893	128.1597651	OFFICIAL	2026-01-29 23:28:25.741683	0	\N
1417	경상남도 합천군 합천읍 동서로 15	2026-01-29 23:28:25.742188	35.5687981	128.1545722	OFFICIAL	2026-01-29 23:28:25.742193	0	\N
1418	경상남도 합천군 합천읍 대야로 883	2026-01-29 23:28:25.742653	35.5672187	128.1629204	OFFICIAL	2026-01-29 23:28:25.742659	0	\N
1419	경상남도 합천군 용주면 성산리 745	2026-01-29 23:28:25.743131	35.5571132	128.1344962	OFFICIAL	2026-01-29 23:28:25.743137	0	\N
1420	경상남도 합천군 용주면 우곡리 577	2026-01-29 23:28:25.743612	35.5683339	128.0734633	OFFICIAL	2026-01-29 23:28:25.743616	0	\N
1421	경상남도 합천군 용주면 고품리 산43-3	2026-01-29 23:28:25.744067	35.5389888	128.0939929	OFFICIAL	2026-01-29 23:28:25.744072	0	\N
1422	경상남도 합천군 용주면 손목리 510	2026-01-29 23:28:25.74448	35.5564812	128.1271709	OFFICIAL	2026-01-29 23:28:25.744485	0	\N
1423	경상남도 합천군 용주면 노리팔산길 68	2026-01-29 23:28:25.744952	35.5235398	128.1232378	OFFICIAL	2026-01-29 23:28:25.744956	0	\N
1424	경상남도 합천군 용주면 죽죽리 330-1	2026-01-29 23:28:25.745404	35.5520975	128.0409655	OFFICIAL	2026-01-29 23:28:25.745408	0	\N
1425	경상남도 합천군 용주면 고품리 산12-43	2026-01-29 23:28:25.745927	35.5560487	128.1085399	OFFICIAL	2026-01-29 23:28:25.745931	0	\N
1426	경상남도 합천군 용주면 성산리 548	2026-01-29 23:28:25.74641	35.5574797	128.1372655	OFFICIAL	2026-01-29 23:28:25.746415	0	\N
1427	경상남도 합천군 용주면 방곡리 539-2	2026-01-29 23:28:25.746926	35.5694277	128.1056564	OFFICIAL	2026-01-29 23:28:25.746931	0	\N
1428	경상남도 합천군 용주면 공암리 164-1	2026-01-29 23:28:25.74735	35.5023756	128.1036726	OFFICIAL	2026-01-29 23:28:25.747355	0	\N
1429	경상남도 합천군 용주면 월평리 809-3	2026-01-29 23:28:25.747785	35.5660551	128.1169817	OFFICIAL	2026-01-29 23:28:25.74779	0	\N
1430	경상남도 합천군 묘산면 화양리 862	2026-01-29 23:28:25.748196	35.6956171	128.1266069	OFFICIAL	2026-01-29 23:28:25.748201	0	\N
1431	경상남도 합천군 묘산면 반포리 124-1	2026-01-29 23:28:25.748605	35.6491805	128.0955574	OFFICIAL	2026-01-29 23:28:25.748611	0	\N
1432	경상남도 합천군 묘산면 산제리 278-4	2026-01-29 23:28:25.749046	35.6576253	128.1074291	OFFICIAL	2026-01-29 23:28:25.749051	0	\N
1433	경상남도 합천군 묘산면 거산리 679-11	2026-01-29 23:28:25.749458	35.6794919	128.1499466	OFFICIAL	2026-01-29 23:28:25.749462	0	\N
1434	경상남도 합천군 묘산면 거산리 405-3	2026-01-29 23:28:25.749884	35.6714026	128.1460101	OFFICIAL	2026-01-29 23:28:25.749888	0	\N
1435	경상남도 합천군 묘산면 화양리 327-3	2026-01-29 23:28:25.750297	35.6821771	128.1355344	OFFICIAL	2026-01-29 23:28:25.750301	0	\N
1436	경상남도 합천군 묘산면 관기리 281-3	2026-01-29 23:28:25.750707	35.6502291	128.1306876	OFFICIAL	2026-01-29 23:28:25.750712	0	\N
1437	경상남도 합천군 묘산면 도옥리 298	2026-01-29 23:28:25.751146	35.6701157	128.1196297	OFFICIAL	2026-01-29 23:28:25.75115	0	\N
1438	경상남도 합천군 묘산면 가산리 754-5	2026-01-29 23:28:25.751552	35.6587512	128.1267696	OFFICIAL	2026-01-29 23:28:25.751557	0	\N
1439	경상남도 합천군 묘산면 안성리 산77-1	2026-01-29 23:28:25.751965	35.6729712	128.1381258	OFFICIAL	2026-01-29 23:28:25.75197	0	\N
1440	경상북도 영덕군 영덕읍 화개리 652	2026-01-29 23:28:25.75236	36.42135788	129.3645717	OFFICIAL	2026-01-29 23:28:25.752364	0	\N
1441	경상북도 영덕군 영덕읍 우곡길 48 경상북도 영덕군 영덕읍 우곡리 322-10	2026-01-29 23:28:25.752797	36.40800827	129.3727756	OFFICIAL	2026-01-29 23:28:25.752802	0	\N
1442	경상북도 영덕군 영덕읍 우곡리 492	2026-01-29 23:28:25.753217	36.41026416	129.37732	OFFICIAL	2026-01-29 23:28:25.753222	0	\N
1443	경상남도 합천군 봉산면 계산리 136	2026-01-29 23:28:25.75517	35.5904741	128.0696654	OFFICIAL	2026-01-29 23:28:25.755174	0	\N
1444	경상남도 합천군 봉산면 양지리 671	2026-01-29 23:28:25.755591	35.5910709	128.0052533	OFFICIAL	2026-01-29 23:28:25.755595	0	\N
1445	경상남도 합천군 봉산면 도곡리 산116-3	2026-01-29 23:28:25.756033	35.6148487	128.0110942	OFFICIAL	2026-01-29 23:28:25.756037	0	\N
1446	경상남도 합천군 합천읍 계림3길 54-4	2026-01-29 23:28:25.756445	35.5962251	128.1487981	OFFICIAL	2026-01-29 23:28:25.756449	0	\N
1447	경상남도 합천군 합천읍 내곡리 706-4	2026-01-29 23:28:25.75685	35.6389046	128.1491421	OFFICIAL	2026-01-29 23:28:25.756855	0	\N
1448	경상남도 합천군 합천읍 서산리 827	2026-01-29 23:28:25.757255	35.5726215	128.1460623	OFFICIAL	2026-01-29 23:28:25.75726	0	\N
1449	경상남도 합천군 합천읍 장계리 산195-1	2026-01-29 23:28:25.757781	35.6088141	128.1192183	OFFICIAL	2026-01-29 23:28:25.757785	0	\N
1450	경상남도 합천군 합천읍 장계리 1010-1	2026-01-29 23:28:25.758194	35.6133158	128.1153064	OFFICIAL	2026-01-29 23:28:25.758199	0	\N
1451	경상남도 합천군 합천읍 장계리 1186	2026-01-29 23:28:25.758642	35.6147604	128.1219757	OFFICIAL	2026-01-29 23:28:25.758647	0	\N
1452	경상남도 합천군 합천읍 외곡2길 19	2026-01-29 23:28:25.759076	35.6279481	128.1380483	OFFICIAL	2026-01-29 23:28:25.759081	0	\N
1453	경상남도 합천군 합천읍 금양리 274-2	2026-01-29 23:28:25.759485	35.5900971	128.1746749	OFFICIAL	2026-01-29 23:28:25.759489	0	\N
1454	경상남도 합천군 합천읍 금양리 857-5	2026-01-29 23:28:25.759975	35.6170804	128.1645779	OFFICIAL	2026-01-29 23:28:25.759979	0	\N
1455	경상남도 합천군 합천읍 서산리 산174	2026-01-29 23:28:25.760386	35.5913775	128.1317947	OFFICIAL	2026-01-29 23:28:25.760391	0	\N
1456	경상남도 합천군 합천읍 인곡리 1192-88	2026-01-29 23:28:25.760825	35.6073207	128.1066003	OFFICIAL	2026-01-29 23:28:25.760829	0	\N
1457	경상남도 합천군 합천읍 용계리 166-4	2026-01-29 23:28:25.761241	35.6204644	128.1616815	OFFICIAL	2026-01-29 23:28:25.761246	0	\N
1458	경상남도 합천군 합천읍 외곡리 405-1	2026-01-29 23:28:25.761647	35.6354958	128.1429857	OFFICIAL	2026-01-29 23:28:25.761651	0	\N
1459	경상남도 합천군 합천읍 내곡리 763-1	2026-01-29 23:28:25.762029	35.6341706	128.1506127	OFFICIAL	2026-01-29 23:28:25.762033	0	\N
1460	경상남도 합천군 합천읍 서산리 603-3	2026-01-29 23:28:25.762437	35.5844815	128.1477501	OFFICIAL	2026-01-29 23:28:25.762442	0	\N
1461	경상남도 합천군 합천읍 인곡리 629	2026-01-29 23:28:25.762864	35.6052621	128.1000635	OFFICIAL	2026-01-29 23:28:25.762868	0	\N
1462	서울특별시 서초구 반포동1-13	2026-01-29 23:28:25.763272	37.50750565	126.9996531	OFFICIAL	2026-01-29 23:28:25.763276	0	\N
1463	서울특별시 서초구 남부순환로 350길4	2026-01-29 23:28:25.763676	37.48433811	127.0351785	OFFICIAL	2026-01-29 23:28:25.76368	0	\N
1464	서울특별시 서초구 효령로 386	2026-01-29 23:28:25.76412	37.48761254	127.0261892	OFFICIAL	2026-01-29 23:28:25.764124	0	\N
1465	서울특별시 서초구 신반포로 194	2026-01-29 23:28:25.764525	37.50643574	127.0068344	OFFICIAL	2026-01-29 23:28:25.76453	0	\N
1466	서울특별시 서초구 신반포로 105	2026-01-29 23:28:25.764941	37.50622031	127.0050517	OFFICIAL	2026-01-29 23:28:25.764945	0	\N
1467	서울특별시 서초구 신반포로 105	2026-01-29 23:28:25.765364	37.50622031	127.0050517	OFFICIAL	2026-01-29 23:28:25.765368	0	\N
1468	서울특별시 서초구 잠원로14길 32	2026-01-29 23:28:25.765801	37.51793353	127.0141425	OFFICIAL	2026-01-29 23:28:25.765806	0	\N
1469	서울특별시 서초구 원지동594-10(청계산로)	2026-01-29 23:28:25.766217	37.44753815	127.0553202	OFFICIAL	2026-01-29 23:28:25.766223	0	\N
1470	서울특별시 서초구 헌릉로13	2026-01-29 23:28:25.766635	37.46512254	127.0447513	OFFICIAL	2026-01-29 23:28:25.76664	0	\N
1471	서울특별시 서초구 매헌로116	2026-01-29 23:28:25.767042	37.46997873	127.0383258	OFFICIAL	2026-01-29 23:28:25.767047	0	\N
1472	서울특별시 서초구 매헌로24	2026-01-29 23:28:25.767446	37.46343917	127.0355257	OFFICIAL	2026-01-29 23:28:25.767451	0	\N
1473	경상남도 합천군 봉산면 오도산휴양로 345	2026-01-29 23:28:25.767869	35.6652511	128.0528971	OFFICIAL	2026-01-29 23:28:25.767874	0	\N
1474	서울특별시 서초구 양재대로2길 90	2026-01-29 23:28:25.768278	37.45760527	127.0175705	OFFICIAL	2026-01-29 23:28:25.768283	0	\N
1475	서울특별시 서초구 양재대로54	2026-01-29 23:28:25.768682	37.45976394	127.0253605	OFFICIAL	2026-01-29 23:28:25.768686	0	\N
1476	서울특별시 서초구 서운로212	2026-01-29 23:28:25.769116	37.50185788	127.0224228	OFFICIAL	2026-01-29 23:28:25.769121	0	\N
1477	서울특별시 서초구 서운로201	2026-01-29 23:28:25.769531	37.50132463	127.0201266	OFFICIAL	2026-01-29 23:28:25.769536	0	\N
1478	서울특별시 서초구 서운로107	2026-01-29 23:28:25.769959	37.49300713	127.0254533	OFFICIAL	2026-01-29 23:28:25.769963	0	\N
1479	서울특별시 서초구 서운로104	2026-01-29 23:28:25.770368	37.4934156	127.0264914	OFFICIAL	2026-01-29 23:28:25.770373	0	\N
1480	서울특별시 서초구 서초동1498-47(서초대로)	2026-01-29 23:28:25.770801	37.4907461	127.004678	OFFICIAL	2026-01-29 23:28:25.770806	0	\N
1481	서울특별시 서초구 고무래로34	2026-01-29 23:28:25.771209	37.50248707	127.0125134	OFFICIAL	2026-01-29 23:28:25.771214	0	\N
1482	서울특별시 서초구 명달로134	2026-01-29 23:28:25.771611	37.48924257	127.0048247	OFFICIAL	2026-01-29 23:28:25.771617	0	\N
1483	서울특별시 서초구 서초중앙로238	2026-01-29 23:28:25.772025	37.50296195	127.012071	OFFICIAL	2026-01-29 23:28:25.77203	0	\N
1484	서울특별시 서초구 방배중앙로 215 서울특별시 서초구 방배동752-7	2026-01-29 23:28:25.772429	37.49829312	126.9848286	OFFICIAL	2026-01-29 23:28:25.772435	0	\N
1485	서울특별시 서초구 방배천로 11 서울특별시 서초구 방배동444-3	2026-01-29 23:28:25.772864	37.47770076	126.9822361	OFFICIAL	2026-01-29 23:28:25.772868	0	\N
1486	서울특별시 서초구 동작대로 24 서울특별시 서초구 방배동443-3	2026-01-29 23:28:25.773281	37.47866249	126.9821522	OFFICIAL	2026-01-29 23:28:25.773285	0	\N
1487	서울특별시 서초구 방배천로 91 서울특별시 서초구 방배동3250	2026-01-29 23:28:25.773687	37.48479284	126.9825989	OFFICIAL	2026-01-29 23:28:25.773692	0	\N
1488	서울특별시 서초구 동작대로 108 서울특별시 서초구 방배동3001-1	2026-01-29 23:28:25.774126	37.4860911	126.9826166	OFFICIAL	2026-01-29 23:28:25.77413	0	\N
1489	서울특별시 서초구 동작대로 130 서울특별시 서초구 방배동1770	2026-01-29 23:28:25.774539	37.48801287	126.9826363	OFFICIAL	2026-01-29 23:28:25.774543	0	\N
1490	서울특별시 서초구 사평대로285	2026-01-29 23:28:25.774966	37.5041589	127.0154342	OFFICIAL	2026-01-29 23:28:25.774972	0	\N
1491	서울특별시 서초구 반포동20-49(사평대로)	2026-01-29 23:28:25.775372	37.50491575	127.0144171	OFFICIAL	2026-01-29 23:28:25.775376	0	\N
1492	서울특별시 서초구 사평대로66	2026-01-29 23:28:25.775803	37.49789692	126.9918371	OFFICIAL	2026-01-29 23:28:25.775807	0	\N
1493	서울특별시 서초구 사평대로142	2026-01-29 23:28:25.776211	37.50037298	127.0010603	OFFICIAL	2026-01-29 23:28:25.776216	0	\N
1494	서울특별시 서초구 사평대로 126 서울특별시 서초구 반포동 93-1	2026-01-29 23:28:25.776618	37.49976696	126.9983523	OFFICIAL	2026-01-29 23:28:25.776622	0	\N
1495	서울특별시 서초구 사평대로98	2026-01-29 23:28:25.777023	37.49865153	126.9954558	OFFICIAL	2026-01-29 23:28:25.777035	0	\N
1496	서울특별시 서초구 사평대로55	2026-01-29 23:28:25.777435	37.49885315	126.9905157	OFFICIAL	2026-01-29 23:28:25.77744	0	\N
1497	서울특별시 서초구 남부순환로2406	2026-01-29 23:28:25.777845	37.4802402	127.0142152	OFFICIAL	2026-01-29 23:28:25.77785	0	\N
1498	서울특별시 서초구 남부순환로2406	2026-01-29 23:28:25.778249	37.4802402	127.0142152	OFFICIAL	2026-01-29 23:28:25.778254	0	\N
1499	서울특별시 서초구 남부순환로2183	2026-01-29 23:28:25.778658	37.47511676	126.9910912	OFFICIAL	2026-01-29 23:28:25.778664	0	\N
1500	서울특별시 서초구 잠원로117	2026-01-29 23:28:25.77906	37.51451892	127.0069957	OFFICIAL	2026-01-29 23:28:25.779064	0	\N
1501	서울특별시 서초구 잠원동160-2(잠원로)	2026-01-29 23:28:25.779462	37.5099491	127.0077759	OFFICIAL	2026-01-29 23:28:25.779468	0	\N
1502	서울특별시 서초구 잠원로69	2026-01-29 23:28:25.779887	37.5102605	127.0069708	OFFICIAL	2026-01-29 23:28:25.779892	0	\N
1503	서울특별시 서초구 신반포로105	2026-01-29 23:28:25.7803	37.50622031	127.0050517	OFFICIAL	2026-01-29 23:28:25.780305	0	\N
1504	서울특별시 서초구 반포대로275	2026-01-29 23:28:25.780708	37.50239027	126.9959653	OFFICIAL	2026-01-29 23:28:25.780713	0	\N
1505	서울특별시 서초구 신반포로200	2026-01-29 23:28:25.781138	37.50622031	127.0050517	OFFICIAL	2026-01-29 23:28:25.781142	0	\N
1506	서울특별시 서초구 신반포로17	2026-01-29 23:28:25.78154	37.50113938	126.9861839	OFFICIAL	2026-01-29 23:28:25.781545	0	\N
1507	서울특별시 서초구 방배로16	2026-01-29 23:28:25.782092	37.47652276	127.0012438	OFFICIAL	2026-01-29 23:28:25.782096	0	\N
1508	서울특별시 서초구 효령로 120	2026-01-29 23:28:25.782503	37.48108275	126.9974214	OFFICIAL	2026-01-29 23:28:25.782508	0	\N
1509	서울특별시 서초구 서초대로 101	2026-01-29 23:28:25.782925	37.48790195	126.993196	OFFICIAL	2026-01-29 23:28:25.78293	0	\N
1510	서울특별시 서초구 방배로 151	2026-01-29 23:28:25.783324	37.48715828	126.9935602	OFFICIAL	2026-01-29 23:28:25.783329	0	\N
1511	서울특별시 서초구 방배로 173	2026-01-29 23:28:25.783728	37.48900761	126.9922424	OFFICIAL	2026-01-29 23:28:25.783733	0	\N
1512	서울특별시 서초구 방배로 268	2026-01-29 23:28:25.784145	37.49668577	126.9884208	OFFICIAL	2026-01-29 23:28:25.78415	0	\N
1513	서울특별시 서초구 효령로 34길 4	2026-01-29 23:28:25.78457	37.48136451	126.9989177	OFFICIAL	2026-01-29 23:28:25.784575	0	\N
1514	서울특별시 서초구 반포대로94	2026-01-29 23:28:25.784985	37.48871122	127.0095838	OFFICIAL	2026-01-29 23:28:25.784989	0	\N
1515	서울특별시 서초구 효령로 120	2026-01-29 23:28:25.785384	37.48108275	126.9974214	OFFICIAL	2026-01-29 23:28:25.785389	0	\N
1516	서울특별시 서초구 반포대로95	2026-01-29 23:28:25.785802	37.48868462	127.0087399	OFFICIAL	2026-01-29 23:28:25.785807	0	\N
1517	서울특별시 서초구 서초동1541-5(반포대로)	2026-01-29 23:28:25.786224	37.49092158	127.0079134	OFFICIAL	2026-01-29 23:28:25.786229	0	\N
1518	서울특별시 서초구 서초대로 240	2026-01-29 23:28:25.786628	37.49157706	127.0083435	OFFICIAL	2026-01-29 23:28:25.786633	0	\N
1519	서울특별시 서초구 반포대로72	2026-01-29 23:28:25.787041	37.48692867	127.0105871	OFFICIAL	2026-01-29 23:28:25.787046	0	\N
1520	서울특별시 서초구 반포대로43	2026-01-29 23:28:25.78745	37.48422977	127.0108415	OFFICIAL	2026-01-29 23:28:25.787455	0	\N
1521	서울특별시 서초구 반포대로38	2026-01-29 23:28:25.787883	37.48389485	127.0119208	OFFICIAL	2026-01-29 23:28:25.787888	0	\N
1522	서울특별시 서초구 효령로341	2026-01-29 23:28:25.788296	37.48663971	127.0213145	OFFICIAL	2026-01-29 23:28:25.788301	0	\N
1523	서울특별시 서초구 효령로418	2026-01-29 23:28:25.788706	37.4886106	127.0295891	OFFICIAL	2026-01-29 23:28:25.78871	0	\N
1524	서울특별시 서초구 효령로336	2026-01-29 23:28:25.789141	37.48602619	127.0209888	OFFICIAL	2026-01-29 23:28:25.789146	0	\N
1525	서울특별시 서초구 강남대로27	2026-01-29 23:28:25.789541	37.46827871	127.0391364	OFFICIAL	2026-01-29 23:28:25.789545	0	\N
1526	서울특별시 서초구 강남대로259	2026-01-29 23:28:25.789967	37.48657325	127.0326334	OFFICIAL	2026-01-29 23:28:25.789972	0	\N
1527	서울특별시 서초구 효령로292	2026-01-29 23:28:25.79038	37.48354661	127.0151109	OFFICIAL	2026-01-29 23:28:25.790384	0	\N
1528	서울특별시 서초구 효령로92	2026-01-29 23:28:25.790812	37.48016182	126.9945968	OFFICIAL	2026-01-29 23:28:25.790816	0	\N
1529	서울특별시 서초구 효령로22	2026-01-29 23:28:25.791215	37.4773868	126.9874824	OFFICIAL	2026-01-29 23:28:25.79122	0	\N
1530	서울특별시 서초구 강남대로45-2	2026-01-29 23:28:25.791654	37.46860382	127.0395902	OFFICIAL	2026-01-29 23:28:25.791658	0	\N
1531	서울특별시 서초구 강남대로48-3	2026-01-29 23:28:25.792037	37.469282	127.0399092	OFFICIAL	2026-01-29 23:28:25.792042	0	\N
1532	서울특별시 서초구 양재동 105-4(강남대로)	2026-01-29 23:28:25.792471	37.47859191	127.0384311	OFFICIAL	2026-01-29 23:28:25.792476	0	\N
1533	서울특별시 서초구 강남대로148	2026-01-29 23:28:25.792949	37.47788797	127.0391803	OFFICIAL	2026-01-29 23:28:25.792953	0	\N
1534	서울특별시 서초구 남부순환로2585	2026-01-29 23:28:25.793372	37.48393473	127.0345442	OFFICIAL	2026-01-29 23:28:25.793377	0	\N
1535	서울특별시 서초구 강남대로213	2026-01-29 23:28:25.793852	37.48276664	127.0349496	OFFICIAL	2026-01-29 23:28:25.793856	0	\N
1536	서울특별시 서초구 남부순환로2585	2026-01-29 23:28:25.794413	37.48393473	127.0345442	OFFICIAL	2026-01-29 23:28:25.794419	0	\N
1537	경상북도 영덕군 영덕읍 우곡리 491-45	2026-01-29 23:28:25.795313	36.40602339	129.3755674	OFFICIAL	2026-01-29 23:28:25.795318	0	\N
1538	경상북도 영덕군 영덕읍 남석리 66-22	2026-01-29 23:28:25.796006	36.40983742	129.3686186	OFFICIAL	2026-01-29 23:28:25.796012	0	\N
1539	경상북도 영덕군 영덕읍 우곡리 490-4	2026-01-29 23:28:25.79649	36.40858173	129.3712698	OFFICIAL	2026-01-29 23:28:25.796496	0	\N
1540	경상북도 영덕군 영덕읍 남석리 205-1	2026-01-29 23:28:25.796933	36.41158555	129.3652492	OFFICIAL	2026-01-29 23:28:25.796938	0	\N
1541	충청남도 홍성군 구항면 구항길240번길 21	2026-01-29 23:28:25.797384	36.5830161	126.6240259	OFFICIAL	2026-01-29 23:28:25.79739	0	\N
1542	충청남도 홍성군 구항면 거북로 440	2026-01-29 23:28:25.797856	36.57052522	126.6092873	OFFICIAL	2026-01-29 23:28:25.797861	0	\N
1543	충청남도 홍성군 구항면  충서로999번길 101-65	2026-01-29 23:28:25.79827	36.56780825	126.6390658	OFFICIAL	2026-01-29 23:28:25.798276	0	\N
1544	경상남도 합천군 용주면 고품부흥1길 10-28	2026-01-29 23:28:25.798704	35.5543751	128.1151668	OFFICIAL	2026-01-29 23:28:25.798708	0	\N
1545	경상남도 합천군 용주면 합천호수로 757	2026-01-29 23:28:25.799188	35.5490189	128.0710082	OFFICIAL	2026-01-29 23:28:25.799193	0	\N
1546	경상남도 합천군 대병면 합천호반로 4	2026-01-29 23:28:25.799725	35.5314136	128.0317584	OFFICIAL	2026-01-29 23:28:25.79973	0	\N
1547	경상남도 합천군 가회면 황매산공원길 263	2026-01-29 23:28:25.80017	35.4851395	127.9842519	OFFICIAL	2026-01-29 23:28:25.800174	0	\N
1548	경상남도 합천군 가회면 황매산공원길 331	2026-01-29 23:28:25.800593	35.4816328	127.9820485	OFFICIAL	2026-01-29 23:28:25.800598	0	\N
1549	경상남도 합천군 가회면 둔내리 산210	2026-01-29 23:28:25.801051	35.4864836	128.0008161	OFFICIAL	2026-01-29 23:28:25.801056	0	\N
1550	경상남도 합천군 대양면 정양리 613	2026-01-29 23:28:25.801447	35.5584161	128.1667081	OFFICIAL	2026-01-29 23:28:25.801452	0	\N
1551	경상남도 합천군 삼가면 합천대로 455	2026-01-29 23:28:25.801856	35.3841527	128.1091347	OFFICIAL	2026-01-29 23:28:25.801861	0	\N
1552	서울특별시 서초구 남부순환로2585	2026-01-29 23:28:25.802286	37.48393473	127.0345442	OFFICIAL	2026-01-29 23:28:25.802293	0	\N
1553	서울특별시 서초구 강남대로299	2026-01-29 23:28:25.802686	37.48975281	127.0309834	OFFICIAL	2026-01-29 23:28:25.802691	0	\N
1554	서울특별시 서초구 강남대로343	2026-01-29 23:28:25.803131	37.49351955	127.0292412	OFFICIAL	2026-01-29 23:28:25.803136	0	\N
1555	서울특별시 서초구 강남대로359	2026-01-29 23:28:25.803526	37.49479896	127.0286098	OFFICIAL	2026-01-29 23:28:25.803531	0	\N
1556	서울특별시 서초구 강남대로365	2026-01-29 23:28:25.803989	37.49532341	127.0283489	OFFICIAL	2026-01-29 23:28:25.803994	0	\N
1557	서울특별시 서초구 강남대로373	2026-01-29 23:28:25.80441	37.49598293	127.0280101	OFFICIAL	2026-01-29 23:28:25.804415	0	\N
1558	서울특별시 서초구 강남대로415	2026-01-29 23:28:25.804824	37.4995604	127.0263398	OFFICIAL	2026-01-29 23:28:25.804828	0	\N
1559	서울특별시 서초구 강남대로423	2026-01-29 23:28:25.805217	37.50030971	127.0258153	OFFICIAL	2026-01-29 23:28:25.805221	0	\N
1560	서울특별시 서초구 강남대로441	2026-01-29 23:28:25.805608	37.50173585	127.0252785	OFFICIAL	2026-01-29 23:28:25.805612	0	\N
1561	서울특별시 서초구 강남대로447	2026-01-29 23:28:25.806031	37.50219197	127.0250968	OFFICIAL	2026-01-29 23:28:25.806046	0	\N
1562	서울특별시 서초구 강남대로477-2	2026-01-29 23:28:25.80643	37.504919	127.0240413	OFFICIAL	2026-01-29 23:28:25.806434	0	\N
1563	서울특별시 서초구 강남대로483	2026-01-29 23:28:25.806857	37.50532543	127.023649	OFFICIAL	2026-01-29 23:28:25.806862	0	\N
1564	서울특별시 서초구 강남대로505	2026-01-29 23:28:25.807272	37.50701446	127.0227028	OFFICIAL	2026-01-29 23:28:25.807276	0	\N
1565	서울특별시 서초구 강남대로567	2026-01-29 23:28:25.807826	37.51239375	127.0200688	OFFICIAL	2026-01-29 23:28:25.80783	0	\N
1566	서울특별시 서초구 강남대로603-2	2026-01-29 23:28:25.808238	37.51555521	127.0194711	OFFICIAL	2026-01-29 23:28:25.808243	0	\N
1567	서울특별시 서초구 강남대로623	2026-01-29 23:28:25.808642	37.51740815	127.0187331	OFFICIAL	2026-01-29 23:28:25.808646	0	\N
1568	서울특별시 구로구 구로동로 153 서울특별시 구로구 구로동 413-88	2026-01-29 23:28:25.809037	37.4923559	126.8834335	OFFICIAL	2026-01-29 23:28:25.809041	0	\N
1569	충청남도 홍성군 구항면 충서로 999번길101-6	2026-01-29 23:28:25.809435	36.56985126	126.6409254	OFFICIAL	2026-01-29 23:28:25.809439	0	\N
1570	충청남도 홍성군 구항면  구항남길 544	2026-01-29 23:28:25.809848	36.56825784	126.5972872	OFFICIAL	2026-01-29 23:28:25.809853	0	\N
1571	충청남도 홍성군 구항면  충서로726번길 142	2026-01-29 23:28:25.810234	36.54262949	126.6486726	OFFICIAL	2026-01-29 23:28:25.810238	0	\N
1572	충청남도 홍성군 구항면  장양리 663-3	2026-01-29 23:28:25.810618	36.58085324	126.5900856	OFFICIAL	2026-01-29 23:28:25.810623	0	\N
1573	충청남도 홍성군 갈산면 수덕사로324번길 64	2026-01-29 23:28:25.811007	36.61835518	126.5929713	OFFICIAL	2026-01-29 23:28:25.811011	0	\N
1574	충청남도 홍성군 갈산면 백야로 314번길 57	2026-01-29 23:28:25.811389	36.58266883	126.5619087	OFFICIAL	2026-01-29 23:28:25.811393	0	\N
1575	충청남도 홍성군 갈산면 백야로 390	2026-01-29 23:28:25.811781	36.58730101	126.5547518	OFFICIAL	2026-01-29 23:28:25.811822	0	\N
1576	충청남도 홍성군 갈산면  오두리182-3	2026-01-29 23:28:25.812225	36.59646882	126.5283742	OFFICIAL	2026-01-29 23:28:25.81223	0	\N
1577	충청남도 홍성군 갈산면  백야로246번길 65	2026-01-29 23:28:25.812612	36.58120146	126.5648484	OFFICIAL	2026-01-29 23:28:25.812617	0	\N
1578	충청남도 홍성군 결성면 형산리 36-6	2026-01-29 23:28:25.813024	36.58522207	126.5757462	OFFICIAL	2026-01-29 23:28:25.813029	0	\N
1579	충청남도 홍성군 결성면 교향리 125-2	2026-01-29 23:28:25.813424	36.54725	126.547	OFFICIAL	2026-01-29 23:28:25.813428	0	\N
1580	충청남도 홍성군 결성면 교항리 1009	2026-01-29 23:28:25.813849	36.57800692	126.5436265	OFFICIAL	2026-01-29 23:28:25.813854	0	\N
1581	충청남도 홍성군 결성면 금곡리 840	2026-01-29 23:28:25.814241	36.52954709	126.5602166	OFFICIAL	2026-01-29 23:28:25.814245	0	\N
1582	충청남도 홍성군 결성면 교항리 339-7	2026-01-29 23:28:25.814628	36.58346125	126.54247	OFFICIAL	2026-01-29 23:28:25.814633	0	\N
1583	충청남도 홍성군 은하면 구성남로310번길 150-4	2026-01-29 23:28:25.815022	36.53446129	126.5682931	OFFICIAL	2026-01-29 23:28:25.815026	0	\N
1584	충청남도 홍성군 은하면 은하로129번길 76	2026-01-29 23:28:25.815444	36.53084196	126.5793994	OFFICIAL	2026-01-29 23:28:25.815448	0	\N
1585	충청남도 홍성군 은하면 은하로406번길 156	2026-01-29 23:28:25.815863	36.55123827	126.6063121	OFFICIAL	2026-01-29 23:28:25.815867	0	\N
1586	충청남도 홍성군 은하면 홍남서로886번길 177	2026-01-29 23:28:25.816235	36.50831371	126.5656438	OFFICIAL	2026-01-29 23:28:25.816239	0	\N
1587	충청남도 홍성군 장곡면 홍남동로 474번길 120-1	2026-01-29 23:28:25.816605	36.49996196	126.6814598	OFFICIAL	2026-01-29 23:28:25.816609	0	\N
1588	충청남도 홍성군 장곡면 장곡동길 660	2026-01-29 23:28:25.817035	36.53757321	126.7390158	OFFICIAL	2026-01-29 23:28:25.81704	0	\N
1589	충청남도 홍성군 장곡면 장곡길534번길 49	2026-01-29 23:28:25.817448	36.48525286	126.6950176	OFFICIAL	2026-01-29 23:28:25.817452	0	\N
1590	충청남도 홍성군 장곡면 지정1길 41-8	2026-01-29 23:28:25.817875	36.53030448	126.7040989	OFFICIAL	2026-01-29 23:28:25.817879	0	\N
1591	충청남도 홍성군 장곡면  홍남동로 713번길 190	2026-01-29 23:28:25.818251	36.50785508	126.7039209	OFFICIAL	2026-01-29 23:28:25.818255	0	\N
1592	충청남도 홍성군 장곡면  홍남동로461	2026-01-29 23:28:25.818681	36.50516139	126.6912807	OFFICIAL	2026-01-29 23:28:25.818685	0	\N
1593	충청남도 홍성군 장곡면  신풍리 60-1	2026-01-29 23:28:25.819104	36.49400989	126.6918792	OFFICIAL	2026-01-29 23:28:25.819108	0	\N
1594	충청남도 홍성군 금마면 금마로436번길 71	2026-01-29 23:28:25.819483	36.60419912	126.7524657	OFFICIAL	2026-01-29 23:28:25.819487	0	\N
1595	충청남도 홍성군 금마면 홍양길 518	2026-01-29 23:28:25.819897	36.60101835	126.72193	OFFICIAL	2026-01-29 23:28:25.819901	0	\N
1596	충청남도 홍성군 금마면 화양리 317-16	2026-01-29 23:28:25.820279	36.61880235	126.7237673	OFFICIAL	2026-01-29 23:28:25.820283	0	\N
1597	충청남도 홍성군 금마면 죽림리 719-29	2026-01-29 23:28:25.820662	36.61701054	126.7125174	OFFICIAL	2026-01-29 23:28:25.820666	0	\N
1598	충청남도 홍성군 금마면 죽림리 82-30	2026-01-29 23:28:25.821056	36.61462345	126.716211	OFFICIAL	2026-01-29 23:28:25.821061	0	\N
1599	충청남도 홍성군 홍동면 광금남로498번길 89	2026-01-29 23:28:25.821432	36.54310735	126.6863898	OFFICIAL	2026-01-29 23:28:25.821436	0	\N
1600	충청남도 홍성군 홍동면 신기리 382-7	2026-01-29 23:28:25.821895	36.58056199	126.7144232	OFFICIAL	2026-01-29 23:28:25.821899	0	\N
1601	충청남도 홍성군 홍북읍 홍북로 450	2026-01-29 23:28:25.822286	36.65016309	126.6919755	OFFICIAL	2026-01-29 23:28:25.822291	0	\N
1602	충청남도 홍성군 홍북읍 금북로 364-41	2026-01-29 23:28:25.822674	36.64845571	126.7232123	OFFICIAL	2026-01-29 23:28:25.822679	0	\N
1603	충청남도 홍성군 홍북읍 홍북읍 갈산리 244-3	2026-01-29 23:28:25.82306	36.64205	126.69	OFFICIAL	2026-01-29 23:28:25.823064	0	\N
1604	충청남도 홍성군 홍북읍 홍북읍 대인리 602-6	2026-01-29 23:28:25.823463	36.64205	126.69	OFFICIAL	2026-01-29 23:28:25.823467	0	\N
1605	충청남도 홍성군 홍북읍 홍북로 502번길 54	2026-01-29 23:28:25.823906	36.65165786	126.7013768	OFFICIAL	2026-01-29 23:28:25.823912	0	\N
1606	충청남도 홍성군 홍북읍 홍북로 453번길 47-19	2026-01-29 23:28:25.824384	36.64955412	126.689622	OFFICIAL	2026-01-29 23:28:25.824391	0	\N
1607	충청남도 홍성군 홍북읍 금북로614번길118	2026-01-29 23:28:25.824837	36.6693017	126.7388282	OFFICIAL	2026-01-29 23:28:25.824842	0	\N
1608	충청남도 홍성군 홍북읍 내용길 270	2026-01-29 23:28:25.825242	36.61808004	126.6926859	OFFICIAL	2026-01-29 23:28:25.825247	0	\N
1609	충청남도 홍성군 홍북읍 홍천문화2길30-14	2026-01-29 23:28:25.825634	36.62628097	126.642329	OFFICIAL	2026-01-29 23:28:25.825672	0	\N
1610	충청남도 홍성군 홍북읍 금북로 366	2026-01-29 23:28:25.826074	36.64962341	126.7218254	OFFICIAL	2026-01-29 23:28:25.826079	0	\N
1611	충청남도 홍성군 홍북읍 이응노로 307	2026-01-29 23:28:25.826527	36.6314193	126.653511	OFFICIAL	2026-01-29 23:28:25.826531	0	\N
1612	충청남도 홍성군 광천읍 상정리 653-3	2026-01-29 23:28:25.826953	36.50954832	126.6121306	OFFICIAL	2026-01-29 23:28:25.826972	0	\N
1613	충청남도 홍성군 광천읍 상정리 580-3	2026-01-29 23:28:25.827428	36.50555151	126.6112	OFFICIAL	2026-01-29 23:28:25.827433	0	\N
1614	충청남도 홍성군 광천읍 소암리 344-4	2026-01-29 23:28:25.827836	36.50026369	126.6368659	OFFICIAL	2026-01-29 23:28:25.827841	0	\N
1615	충청남도 홍성군 광천읍 가정리 502-3	2026-01-29 23:28:25.828319	36.50353205	126.648406	OFFICIAL	2026-01-29 23:28:25.828324	0	\N
1616	충청남도 홍성군 광천읍 홍남로623-18	2026-01-29 23:28:25.828732	36.50512729	126.620022	OFFICIAL	2026-01-29 23:28:25.828737	0	\N
1617	충청남도 홍성군 광천읍 월림1길 20-4	2026-01-29 23:28:25.829166	36.52149433	126.6471813	OFFICIAL	2026-01-29 23:28:25.829171	0	\N
1618	충청남도 홍성군 광천읍 담산길 13	2026-01-29 23:28:25.82956	36.49632354	126.6426721	OFFICIAL	2026-01-29 23:28:25.829565	0	\N
1619	충청남도 홍성군 광천읍 매현1길 2	2026-01-29 23:28:25.829953	36.52226833	126.6336432	OFFICIAL	2026-01-29 23:28:25.829958	0	\N
1620	충청남도 홍성군 광천읍 충서로 206-12	2026-01-29 23:28:25.83034	36.50244773	126.6178831	OFFICIAL	2026-01-29 23:28:25.83035	0	\N
1621	충청남도 홍성군 홍성읍 오관리 875-19	2026-01-29 23:28:25.830738	36.60086047	126.6589627	OFFICIAL	2026-01-29 23:28:25.830742	0	\N
1622	충청남도 홍성군 홍성읍 대교리 16-7	2026-01-29 23:28:25.831152	36.605952	126.6817526	OFFICIAL	2026-01-29 23:28:25.831156	0	\N
1623	충청남도 홍성군 홍성읍 대교리 30-2	2026-01-29 23:28:25.831544	36.60577826	126.6772135	OFFICIAL	2026-01-29 23:28:25.831548	0	\N
1624	충청남도 홍성군 홍성읍 월산리 830-4	2026-01-29 23:28:25.831964	36.60039943	126.6465531	OFFICIAL	2026-01-29 23:28:25.831969	0	\N
1625	충청남도 홍성군 홍성읍 고암리 570-9	2026-01-29 23:28:25.83235	36.59834807	126.6747773	OFFICIAL	2026-01-29 23:28:25.832354	0	\N
1626	충청남도 홍성군 홍성읍 오관리 587-4	2026-01-29 23:28:25.832729	36.59755443	126.6598002	OFFICIAL	2026-01-29 23:28:25.832733	0	\N
1627	충청남도 홍성군 홍성읍 내법리 154-5	2026-01-29 23:28:25.833141	36.61116754	126.6774255	OFFICIAL	2026-01-29 23:28:25.833146	0	\N
1628	충청남도 홍성군 홍성읍 오관리 726-5	2026-01-29 23:28:25.833518	36.60362705	126.65695	OFFICIAL	2026-01-29 23:28:25.833523	0	\N
1629	충청남도 홍성군 홍성읍 내법리 330-2	2026-01-29 23:28:25.833925	36.6165635	126.6737312	OFFICIAL	2026-01-29 23:28:25.83393	0	\N
1630	충청남도 홍성군 홍성읍 월산리 850	2026-01-29 23:28:25.834303	36.6024162	126.6497034	OFFICIAL	2026-01-29 23:28:25.834308	0	\N
1631	충청남도 홍성군 홍성읍 고암리 552-6	2026-01-29 23:28:25.834695	36.59883	126.673	OFFICIAL	2026-01-29 23:28:25.8347	0	\N
1632	서울특별시 구로구 구로동로 238-1 서울특별시 구로구 구로동 497-7	2026-01-29 23:28:25.835185	37.49983443	126.8826164	OFFICIAL	2026-01-29 23:28:25.83519	0	\N
1633	충청남도 홍성군 홍성읍 남장리 507-8	2026-01-29 23:28:25.835598	36.58125753	126.6539618	OFFICIAL	2026-01-29 23:28:25.835603	0	\N
1634	충청남도 홍성군 홍성읍 남장리 108-19	2026-01-29 23:28:25.83624	36.59296259	126.6648363	OFFICIAL	2026-01-29 23:28:25.836244	0	\N
1635	충청남도 홍성군 홍성읍 남장리 422-5	2026-01-29 23:28:25.836631	36.57734382	126.6549732	OFFICIAL	2026-01-29 23:28:25.836639	0	\N
1636	충청남도 홍성군 홍성읍 오관리904	2026-01-29 23:28:25.837125	36.59768418	126.6541879	OFFICIAL	2026-01-29 23:28:25.837129	0	\N
1637	충청남도 홍성군 홍성읍 월산리 901	2026-01-29 23:28:25.837513	36.599025	126.6504631	OFFICIAL	2026-01-29 23:28:25.837517	0	\N
1638	충청남도 홍성군 홍성읍 오관리 411-21	2026-01-29 23:28:25.837919	36.59994116	126.663184	OFFICIAL	2026-01-29 23:28:25.837923	0	\N
1639	충청남도 홍성군 홍성읍 오관리 715-21	2026-01-29 23:28:25.838294	36.60410982	126.6599375	OFFICIAL	2026-01-29 23:28:25.838299	0	\N
1640	충청남도 홍성군 홍성읍 대교리 443-32	2026-01-29 23:28:25.838672	36.60668851	126.663853	OFFICIAL	2026-01-29 23:28:25.838677	0	\N
1641	충청남도 홍성군 홍성읍 내포로 251번길120	2026-01-29 23:28:25.839038	36.58348157	126.6420953	OFFICIAL	2026-01-29 23:28:25.839043	0	\N
1642	서울특별시 구로구 구로중앙로 135-6 서울특별시 구로구 구로동 500-27	2026-01-29 23:28:25.839411	37.49995073	126.8828691	OFFICIAL	2026-01-29 23:28:25.839415	0	\N
1643	서울특별시 마포구 잔다리로 8 서울특별시 마포구 서교동 363-6	2026-01-29 23:28:25.839815	37.55088607	126.9222846	OFFICIAL	2026-01-29 23:28:25.839819	0	\N
1644	서울특별시 마포구 어울마당로 65 서울특별시 마포구 서교동 367-5	2026-01-29 23:28:25.840191	37.5509577	126.921063	OFFICIAL	2026-01-29 23:28:25.840196	0	\N
1645	서울특별시 마포구 어울마당로 65 서울특별시 마포구 서교동 367-5	2026-01-29 23:28:25.840562	37.5509577	126.921063	OFFICIAL	2026-01-29 23:28:25.840567	0	\N
1646	서울특별시 마포구 잔다리로 13 서울특별시 마포구 서교동 407-23	2026-01-29 23:28:25.84096	37.5505701	126.9216259	OFFICIAL	2026-01-29 23:28:25.840964	0	\N
1647	서울특별시 마포구 어울마당로 76 서울특별시 마포구 서교동 364-18	2026-01-29 23:28:25.841337	37.55173887	126.921615	OFFICIAL	2026-01-29 23:28:25.841341	0	\N
1648	서울특별시 마포구 월드컵로 212 서울특별시 마포구 성산동 370	2026-01-29 23:28:25.841821	37.56631284	126.9016157	OFFICIAL	2026-01-29 23:28:25.841827	0	\N
1649	서울특별시 마포구 월드컵로 212 서울특별시 마포구 성산동 370	2026-01-29 23:28:25.842324	37.56631284	126.9016157	OFFICIAL	2026-01-29 23:28:25.842329	0	\N
1650	서울특별시 마포구 고산2길 61 서울특별시 마포구 노고산동 12-187	2026-01-29 23:28:25.842789	37.55397876	126.9408091	OFFICIAL	2026-01-29 23:28:25.842793	0	\N
1651	서울특별시 마포구 월드컵로 77 서울특별시 마포구 망원동 378	2026-01-29 23:28:25.843228	37.55605729	126.9100339	OFFICIAL	2026-01-29 23:28:25.843234	0	\N
1652	서울특별시 마포구 월드컵로 77 서울특별시 마포구 망원동 378	2026-01-29 23:28:25.84364	37.55605729	126.9100339	OFFICIAL	2026-01-29 23:28:25.843644	0	\N
1653	서울특별시 마포구 월드컵로 212 서울특별시 마포구 성산동 370	2026-01-29 23:28:25.844045	37.56631284	126.9016157	OFFICIAL	2026-01-29 23:28:25.84405	0	\N
1654	서울특별시 마포구 월드컵북로 361 서울특별시 마포구 상암동 1653	2026-01-29 23:28:25.844452	37.5771097	126.8914039	OFFICIAL	2026-01-29 23:28:25.844456	0	\N
1655	서울특별시 마포구 매봉산로 80 서울특별시 마포구 상암동 1615	2026-01-29 23:28:25.844849	37.57852975	126.8942848	OFFICIAL	2026-01-29 23:28:25.844853	0	\N
1656	서울특별시 마포구 월드컵로 202 서울특별시 마포구 성산동 591-2	2026-01-29 23:28:25.845268	37.56528704	126.9024641	OFFICIAL	2026-01-29 23:28:25.845273	0	\N
1657	서울특별시 마포구 월드컵로 212 서울특별시 마포구 성산동 370	2026-01-29 23:28:25.845671	37.56631284	126.9016157	OFFICIAL	2026-01-29 23:28:25.845676	0	\N
1658	서울특별시 마포구 성산동 665	2026-01-29 23:28:25.846051	37.56827661	126.8927642	OFFICIAL	2026-01-29 23:28:25.846056	0	\N
1659	서울특별시 마포구 월드컵로 204 서울특별시 마포구 성산동 591-1	2026-01-29 23:28:25.846435	37.56539921	126.9021318	OFFICIAL	2026-01-29 23:28:25.84644	0	\N
1660	서울특별시 마포구 상암동 1622-1	2026-01-29 23:28:25.846852	37.57712976	126.8978247	OFFICIAL	2026-01-29 23:28:25.846857	0	\N
1661	서울특별시 마포구 상암동 1731	2026-01-29 23:28:25.847266	37.57362275	126.8873006	OFFICIAL	2026-01-29 23:28:25.847271	0	\N
1662	서울특별시 마포구 월드컵로 61 서울특별시 마포구 망원동 386-3	2026-01-29 23:28:25.847702	37.55465441	126.9110639	OFFICIAL	2026-01-29 23:28:25.847707	0	\N
1663	서울특별시 마포구 월드컵로 143 서울특별시 마포구 망원동 477-4	2026-01-29 23:28:25.848159	37.56048172	126.905632	OFFICIAL	2026-01-29 23:28:25.848165	0	\N
1664	서울특별시 마포구 월드컵로 143 서울특별시 마포구 망원동 477-4	2026-01-29 23:28:25.848625	37.56048172	126.905632	OFFICIAL	2026-01-29 23:28:25.84863	0	\N
1665	서울특별시 마포구 월드컵로 87 서울특별시 마포구 망원동 377-1	2026-01-29 23:28:25.849169	37.5564743	126.9092406	OFFICIAL	2026-01-29 23:28:25.849174	0	\N
1666	서울특별시 마포구 월드컵로 78 서울특별시 마포구 서교동 441-19	2026-01-29 23:28:25.849608	37.5560151	126.910469	OFFICIAL	2026-01-29 23:28:25.849614	0	\N
1667	서울특별시 마포구 월드컵북로 183-2 서울특별시 마포구 성산동 200-3	2026-01-29 23:28:25.850027	37.56790457	126.9082588	OFFICIAL	2026-01-29 23:28:25.850032	0	\N
1668	서울특별시 마포구 월드컵북로 221 서울특별시 마포구 성산동 466-6	2026-01-29 23:28:25.850433	37.5692779	126.9043255	OFFICIAL	2026-01-29 23:28:25.850437	0	\N
1669	서울특별시 마포구 월드컵북로 233 서울특별시 마포구 성산동 446	2026-01-29 23:28:25.850873	37.56973229	126.9031355	OFFICIAL	2026-01-29 23:28:25.850877	0	\N
1670	서울특별시 마포구 성산동 661	2026-01-29 23:28:25.851263	37.5702693	126.8945243	OFFICIAL	2026-01-29 23:28:25.851268	0	\N
1671	서울특별시 마포구 성산동 661	2026-01-29 23:28:25.851644	37.5702693	126.8945243	OFFICIAL	2026-01-29 23:28:25.851648	0	\N
1672	전라남도 해남군 해남읍 신안길 82 전라남도 해남군 해남읍 신안리 138-1	2026-01-29 23:28:25.852068	34.56218135	126.6162469	OFFICIAL	2026-01-29 23:28:25.852073	0	\N
1673	전라남도 해남군 해남읍 남외리 113-1	2026-01-29 23:28:25.852467	34.56868837	126.5957116	OFFICIAL	2026-01-29 23:28:25.852471	0	\N
1674	전라남도 해남군 해남읍 수성리 63	2026-01-29 23:28:25.852868	34.57354561	126.6004697	OFFICIAL	2026-01-29 23:28:25.852873	0	\N
1675	전라남도 해남군 해남읍 읍학동길 20-3 전라남도 해남군 해남읍 구교리 839-4	2026-01-29 23:28:25.853287	34.58260194	126.5801071	OFFICIAL	2026-01-29 23:28:25.853291	0	\N
1676	전라남도 해남군 해남읍 읍내길 20-6 전라남도 해남군 해남읍 읍내리 50	2026-01-29 23:28:25.853744	34.57030585	126.5989153	OFFICIAL	2026-01-29 23:28:25.853778	0	\N
1677	전라남도 해남군 해남읍 읍관동길 26 전라남도 해남군 해남읍 구교리 526-4	2026-01-29 23:28:25.854177	34.57912999	126.5881281	OFFICIAL	2026-01-29 23:28:25.854182	0	\N
1678	전라남도 해남군 해남읍 안동리 176-2	2026-01-29 23:28:25.854569	34.55250401	126.5832005	OFFICIAL	2026-01-29 23:28:25.854573	0	\N
1679	전라남도 해남군 해남읍 남천길 37 전라남도 해남군 해남읍 남천리 339-3	2026-01-29 23:28:25.85495	34.55973549	126.5680076	OFFICIAL	2026-01-29 23:28:25.854954	0	\N
1680	서울특별시 마포구 잔다리로 6 서울특별시 마포구 서교동 363-5	2026-01-29 23:28:25.85534	37.55090875	126.9225252	OFFICIAL	2026-01-29 23:28:25.855344	0	\N
1681	서울특별시 마포구 잔다리로 13 서울특별시 마포구 서교동 407-23	2026-01-29 23:28:25.855725	37.5505701	126.9216259	OFFICIAL	2026-01-29 23:28:25.855729	0	\N
1682	서울특별시 마포구 어울마당로 65 서울특별시 마포구 서교동 367-5	2026-01-29 23:28:25.856167	37.5509577	126.921063	OFFICIAL	2026-01-29 23:28:25.856171	0	\N
1683	서울특별시 마포구 서강로 127-1 서울특별시 마포구 노고산동 49-66	2026-01-29 23:28:25.856593	37.5539745	126.9347767	OFFICIAL	2026-01-29 23:28:25.856597	0	\N
1684	서울특별시 마포구 서강로 111-1 서울특별시 마포구 창전동 2-3	2026-01-29 23:28:25.856977	37.55319412	126.9332862	OFFICIAL	2026-01-29 23:28:25.856981	0	\N
1685	서울특별시 마포구 마포대로 212-1	2026-01-29 23:28:25.857361	37.55278656	126.9565585	OFFICIAL	2026-01-29 23:28:25.857368	0	\N
1686	서울특별시 마포구 마포대로 109 서울특별시 마포구 공덕동 467	2026-01-29 23:28:25.857734	37.54511882	126.9508863	OFFICIAL	2026-01-29 23:28:25.857739	0	\N
1687	서울특별시 마포구 홍익로 6 서울특별시 마포구 서교동 344-15	2026-01-29 23:28:25.85813	37.55329783	126.9240508	OFFICIAL	2026-01-29 23:28:25.858134	0	\N
1688	서울특별시 마포구 홍익로 5 서울특별시 마포구 서교동 358-19	2026-01-29 23:28:25.858637	37.55311367	126.9237638	OFFICIAL	2026-01-29 23:28:25.858642	0	\N
1689	서울특별시 마포구 홍익로 23 서울특별시 마포구 서교동 356-2	2026-01-29 23:28:25.859101	37.55429262	126.9222415	OFFICIAL	2026-01-29 23:28:25.859105	0	\N
1690	서울특별시 마포구 홍익로 20 서울특별시 마포구 서교동 345-30	2026-01-29 23:28:25.859499	37.55438256	126.9228187	OFFICIAL	2026-01-29 23:28:25.859504	0	\N
1691	서울특별시 마포구 홍익로 19 서울특별시 마포구 서교동 358-1	2026-01-29 23:28:25.859917	37.5540115	126.9226326	OFFICIAL	2026-01-29 23:28:25.859921	0	\N
1692	서울특별시 마포구 홍익로 18 서울특별시 마포구 서교동 345-9	2026-01-29 23:28:25.860303	37.55422005	126.9230101	OFFICIAL	2026-01-29 23:28:25.860307	0	\N
1693	서울특별시 마포구 홍익로 11 서울특별시 마포구 서교동 358-12	2026-01-29 23:28:25.860682	37.55350394	126.9232862	OFFICIAL	2026-01-29 23:28:25.860686	0	\N
1694	서울특별시 마포구 홍익로 10 서울특별시 마포구 서교동 486	2026-01-29 23:28:25.861114	37.55376198	126.9236938	OFFICIAL	2026-01-29 23:28:25.861118	0	\N
1695	서울특별시 마포구 잔다리로 40 서울특별시 마포구 서교동 368-9	2026-01-29 23:28:25.861509	37.55195907	126.9193376	OFFICIAL	2026-01-29 23:28:25.861513	0	\N
1696	서울특별시 마포구 어울마당로 113 서울특별시 마포구 동교동 163-5	2026-01-29 23:28:25.861919	37.55497476	126.9229139	OFFICIAL	2026-01-29 23:28:25.861923	0	\N
1697	서울특별시 마포구 어울마당로 107 서울특별시 마포구 동교동 163-8	2026-01-29 23:28:25.862396	37.55462795	126.9224833	OFFICIAL	2026-01-29 23:28:25.8624	0	\N
1698	서울특별시 마포구 양화로 100-2 서울특별시 마포구 서교동 427	2026-01-29 23:28:25.862816	37.5528524	126.9186684	OFFICIAL	2026-01-29 23:28:25.862821	0	\N
1699	서울특별시 마포구 양화로 100-2 서울특별시 마포구 서교동 427	2026-01-29 23:28:25.863204	37.5528524	126.9186684	OFFICIAL	2026-01-29 23:28:25.863208	0	\N
1700	서울특별시 마포구 상수동 1-3	2026-01-29 23:28:25.86359	37.54765426	126.9272266	OFFICIAL	2026-01-29 23:28:25.863594	0	\N
1701	전라남도 해남군 문내면 용암리 300-5	2026-01-29 23:28:25.863971	34.58853335	126.3580555	OFFICIAL	2026-01-29 23:28:25.863975	0	\N
1702	전라남도 해남군 문내면 용암리 733-6	2026-01-29 23:28:25.864344	34.59781368	126.3469407	OFFICIAL	2026-01-29 23:28:25.864348	0	\N
1703	전라남도 해남군 문내면 무고길 64 전라남도 해남군 문내면 무고리 168-1	2026-01-29 23:28:25.864712	34.63100565	126.314658	OFFICIAL	2026-01-29 23:28:25.864731	0	\N
1704	전라남도 해남군 문내면 동헌길 30 전라남도 해남군 문내면 동외리 1117-1	2026-01-29 23:28:25.865328	34.59175651	126.3097889	OFFICIAL	2026-01-29 23:28:25.865332	0	\N
1705	전라남도 해남군 산이면 덕송길 21 전라남도 해남군 산이면 덕송리 817	2026-01-29 23:28:25.865722	34.68063558	126.430966	OFFICIAL	2026-01-29 23:28:25.865726	0	\N
1706	전라남도 해남군 산이면 진산길 110 전라남도 해남군 산이면 진산리 515-1	2026-01-29 23:28:25.866144	34.64739167	126.4244161	OFFICIAL	2026-01-29 23:28:25.866149	0	\N
1707	전라남도 해남군 산이면 대진리 445-1	2026-01-29 23:28:25.866569	34.67240786	126.4244775	OFFICIAL	2026-01-29 23:28:25.866573	0	\N
1708	전라남도 해남군 황산면 우항길 60 전라남도 해남군 황산면 우항리 317-1	2026-01-29 23:28:25.866936	34.58372633	126.4377013	OFFICIAL	2026-01-29 23:28:25.86694	0	\N
1709	전라남도 해남군 황산면 연호길 19 전라남도 해남군 황산면 연호리 391-1	2026-01-29 23:28:25.867295	34.59986958	126.4839324	OFFICIAL	2026-01-29 23:28:25.867299	0	\N
1710	전라남도 해남군 황산면 남리길 182 전라남도 해남군 황산면 남리리 764-1	2026-01-29 23:28:25.867682	34.57101452	126.4205638	OFFICIAL	2026-01-29 23:28:25.867686	0	\N
1711	전라남도 해남군 황산면 한자리 1123-12	2026-01-29 23:28:25.868069	34.52351394	126.4575274	OFFICIAL	2026-01-29 23:28:25.868073	0	\N
1712	전라남도 해남군 마산면 마산로 410-1 전라남도 해남군 마산면 화내리 637-16	2026-01-29 23:28:25.868434	34.61905151	126.5706787	OFFICIAL	2026-01-29 23:28:25.868438	0	\N
1713	전라남도 해남군 마산면 연구리 363	2026-01-29 23:28:25.86882	34.6426585	126.5454045	OFFICIAL	2026-01-29 23:28:25.868824	0	\N
1714	전라남도 해남군 계곡면 가학길 35 전라남도 해남군 계곡면 가학리 95	2026-01-29 23:28:25.869191	34.65366698	126.5958078	OFFICIAL	2026-01-29 23:28:25.869195	0	\N
1715	전라남도 해남군 계곡면 용지길 86 전라남도 해남군 계곡면 사정리 110-4	2026-01-29 23:28:25.869556	34.64190958	126.6039461	OFFICIAL	2026-01-29 23:28:25.86956	0	\N
1716	전라남도 해남군 옥천면 백호길 45 전라남도 해남군 옥천면 백호리 412-6	2026-01-29 23:28:25.869964	34.54774346	126.6552162	OFFICIAL	2026-01-29 23:28:25.869968	0	\N
1717	전라남도 해남군 옥천면 영신길 5 전라남도 해남군 옥천면 영신리 477-1	2026-01-29 23:28:25.870398	34.58923626	126.6474804	OFFICIAL	2026-01-29 23:28:25.870402	0	\N
1718	전라남도 해남군 북일면 만월길 18-11 전라남도 해남군 북일면 흥촌리 158-3	2026-01-29 23:28:25.870842	34.46446525	126.6721804	OFFICIAL	2026-01-29 23:28:25.870846	0	\N
1719	전라남도 해남군 북일면 삼성길 72 전라남도 해남군 북일면 흥촌리 848-1	2026-01-29 23:28:25.871234	34.46457789	126.6644962	OFFICIAL	2026-01-29 23:28:25.871239	0	\N
1720	전라남도 해남군 북일면 용일길 128 전라남도 해남군 북일면 용일리 749-1	2026-01-29 23:28:25.871616	34.4616847	126.6984058	OFFICIAL	2026-01-29 23:28:25.87162	0	\N
1721	전라남도 해남군 북평면 동해리 620-1	2026-01-29 23:28:25.871996	34.43722587	126.6370071	OFFICIAL	2026-01-29 23:28:25.872	0	\N
1722	전라남도 해남군 송지면 마봉리 1257	2026-01-29 23:28:25.872364	34.36885237	126.5333675	OFFICIAL	2026-01-29 23:28:25.872368	0	\N
1723	전라남도 해남군 송지면 산정리 542-3	2026-01-29 23:28:25.872729	34.36908018	126.5168907	OFFICIAL	2026-01-29 23:28:25.872733	0	\N
1724	전라남도 해남군 송지면 소죽길 65 전라남도 해남군 송지면 소죽리 493-1	2026-01-29 23:28:25.87313	34.36497673	126.527691	OFFICIAL	2026-01-29 23:28:25.873134	0	\N
1725	전라남도 해남군 현산면 고현리 1039-3	2026-01-29 23:28:25.873516	34.4623945	126.5370299	OFFICIAL	2026-01-29 23:28:25.873521	0	\N
1726	전라남도 해남군 현산면 조산리 369-1	2026-01-29 23:28:25.873944	34.4340966	126.6012893	OFFICIAL	2026-01-29 23:28:25.873948	0	\N
1727	전라남도 해남군 현산면 신방리길 36 전라남도 해남군 현산면 초호리 628-3	2026-01-29 23:28:25.874323	34.43507533	126.5404396	OFFICIAL	2026-01-29 23:28:25.874327	0	\N
1728	전라남도 해남군 화산면 송평로 5-12 전라남도 해남군 화산면 방축리 468-6	2026-01-29 23:28:25.874697	34.49021461	126.5149325	OFFICIAL	2026-01-29 23:28:25.874706	0	\N
1729	전라남도 해남군 삼산면 상가리 340-5	2026-01-29 23:28:25.875124	34.52932987	126.6389607	OFFICIAL	2026-01-29 23:28:25.875128	0	\N
1730	전라남도 해남군 삼산면 평활길 24 전라남도 해남군 삼산면 평활리 473-1	2026-01-29 23:28:25.875599	34.51785622	126.6205372	OFFICIAL	2026-01-29 23:28:25.875603	0	\N
1731	전라남도 해남군 삼산면 창리 329	2026-01-29 23:28:25.876006	34.53683521	126.5962593	OFFICIAL	2026-01-29 23:28:25.87601	0	\N
1732	광주광역시 광산구 하산동 193-9	2026-01-29 23:28:25.876453	35.09144873	126.7725212	OFFICIAL	2026-01-29 23:28:25.876457	0	\N
1733	경상남도 남해군 남면 선구리 1049-1	2026-01-29 23:28:25.87688	34.7426034	127.8582505	OFFICIAL	2026-01-29 23:28:25.876884	0	\N
1734	경상남도 남해군 삼동면 봉화리 967-3	2026-01-29 23:28:25.877257	34.80365029	128.0233	OFFICIAL	2026-01-29 23:28:25.877261	0	\N
1735	경상남도 남해군 상주면 양아리 918-7	2026-01-29 23:28:25.877836	34.71669108	127.9580289	OFFICIAL	2026-01-29 23:28:25.877842	0	\N
1736	경상남도 남해군 이동면 무림리 1164-3	2026-01-29 23:28:25.878289	34.80469451	127.9548819	OFFICIAL	2026-01-29 23:28:25.878294	0	\N
1737	경상남도 남해군 이동면 초음리 627	2026-01-29 23:28:25.878693	34.82839136	127.9302861	OFFICIAL	2026-01-29 23:28:25.878698	0	\N
1738	경상남도 남해군 남해읍 평현리 1224-1	2026-01-29 23:28:25.879104	34.81902806	127.8793388	OFFICIAL	2026-01-29 23:28:25.879108	0	\N
1739	경상남도 남해군 고현면 갈화리 1383-11	2026-01-29 23:28:25.879509	34.89513685	127.8368857	OFFICIAL	2026-01-29 23:28:25.879513	0	\N
1740	경상남도 남해군 삼동면 금송리 546	2026-01-29 23:28:25.879923	34.83010104	128.0186724	OFFICIAL	2026-01-29 23:28:25.879927	0	\N
1741	경상남도 남해군 설천면 금음리 1-12	2026-01-29 23:28:25.880494	34.93084144	127.9280628	OFFICIAL	2026-01-29 23:28:25.8805	0	\N
1742	경상남도 남해군 미조면 미조리 632-3	2026-01-29 23:28:25.880953	34.7142421	128.0439621	OFFICIAL	2026-01-29 23:28:25.880958	0	\N
1743	경상남도 남해군 남면 석교리 1034-1	2026-01-29 23:28:25.881367	34.76716924	127.9050423	OFFICIAL	2026-01-29 23:28:25.881371	0	\N
1744	경상남도 남해군 남해읍 평리 661-2	2026-01-29 23:28:25.881787	34.82009964	127.8920287	OFFICIAL	2026-01-29 23:28:25.881791	0	\N
1745	경상남도 남해군 창선면 수산리 525	2026-01-29 23:28:25.882202	34.85486592	128.0123902	OFFICIAL	2026-01-29 23:28:25.882206	0	\N
1746	경상남도 남해군 서면 노구리 1049-7	2026-01-29 23:28:25.882595	34.86052345	127.8201545	OFFICIAL	2026-01-29 23:28:25.8826	0	\N
1747	경상남도 남해군 상주면 양아리 1467-1	2026-01-29 23:28:25.883048	34.73294922	127.9552582	OFFICIAL	2026-01-29 23:28:25.883053	0	\N
1748	경상남도 남해군 이동면 신전리 169-2	2026-01-29 23:28:25.883447	34.77569063	127.9582623	OFFICIAL	2026-01-29 23:28:25.883451	0	\N
1749	경상남도 남해군 창선면 진동리 708-42	2026-01-29 23:28:25.883835	34.85249235	128.053563	OFFICIAL	2026-01-29 23:28:25.883839	0	\N
1750	경상남도 남해군 창선면 가인리 453	2026-01-29 23:28:25.884215	34.85643	127.9664221	OFFICIAL	2026-01-29 23:28:25.884219	0	\N
1751	경상남도 남해군 설천면 문의리 70-9	2026-01-29 23:28:25.884596	34.9309804	127.9194809	OFFICIAL	2026-01-29 23:28:25.8846	0	\N
1752	경상남도 남해군 고현면 도마리 512-1	2026-01-29 23:28:25.884974	34.88194193	127.8876497	OFFICIAL	2026-01-29 23:28:25.884978	0	\N
1753	경상남도 남해군 서면 남상리 1166-32	2026-01-29 23:28:25.885349	34.84701711	127.818773	OFFICIAL	2026-01-29 23:28:25.885364	0	\N
1754	전라남도 해남군 마산면 학의리 1444-11	2026-01-29 23:28:25.885726	34.60088091	126.5296003	OFFICIAL	2026-01-29 23:28:25.88573	0	\N
1755	전라남도 해남군 송지면 송호리 897-5	2026-01-29 23:28:25.886172	34.31706214	126.5178398	OFFICIAL	2026-01-29 23:28:25.886176	0	\N
1756	전라남도 해남군 삼산면 충리길 121 전라남도 해남군 삼산면 충리 362-2	2026-01-29 23:28:25.886539	34.51799709	126.5960984	OFFICIAL	2026-01-29 23:28:25.886543	0	\N
1757	전라남도 해남군 해남읍 길호길 54 전라남도 해남군 해남읍 복평리 334	2026-01-29 23:28:25.886932	34.55947182	126.5463859	OFFICIAL	2026-01-29 23:28:25.886936	0	\N
1758	전라남도 해남군 화원면 화봉리 596-1	2026-01-29 23:28:25.887306	34.65928465	126.2660463	OFFICIAL	2026-01-29 23:28:25.88731	0	\N
1759	전라남도 해남군 화원면 산호리 91	2026-01-29 23:28:25.887693	34.64736613	126.299728	OFFICIAL	2026-01-29 23:28:25.887697	0	\N
1760	전라남도 해남군 화원면 이목길 44-16 전라남도 해남군 화원면 장춘리 624-1	2026-01-29 23:28:25.888084	34.65172354	126.3169355	OFFICIAL	2026-01-29 23:28:25.888088	0	\N
1761	전라남도 해남군 화원면 마산리 152-1	2026-01-29 23:28:25.888552	34.71376879	126.3327554	OFFICIAL	2026-01-29 23:28:25.888558	0	\N
1762	서울특별시 구로구 구로동로 31 서울특별시 구로구 가리봉동 25-51	2026-01-29 23:28:25.889087	37.48444034	126.8859907	OFFICIAL	2026-01-29 23:28:25.889092	0	\N
1763	광주광역시 광산구 유계동 1031-14	2026-01-29 23:28:25.889518	35.091394	126.7729998	OFFICIAL	2026-01-29 23:28:25.889523	0	\N
1764	전라남도 장흥군 장흥읍 칠거리예양로 41-2 전라남도 장흥군 장흥읍 예양리 47-2	2026-01-29 23:28:25.889959	34.67582148	126.9015785	OFFICIAL	2026-01-29 23:28:25.889964	0	\N
1765	전라남도 장흥군 장흥읍 평화리 733-1	2026-01-29 23:28:25.890365	34.67221919	126.9044399	OFFICIAL	2026-01-29 23:28:25.89037	0	\N
1766	전라남도 장흥군 장흥읍 기양길 16 전라남도 장흥군 장흥읍 기양리 109-2	2026-01-29 23:28:25.890788	34.67824363	126.9016945	OFFICIAL	2026-01-29 23:28:25.890793	0	\N
1767	전라남도 장흥군 부산면 부춘리 133-3	2026-01-29 23:28:25.891225	34.70711065	126.9182653	OFFICIAL	2026-01-29 23:28:25.891229	0	\N
1768	전라남도 장흥군 장흥읍 건산리 651-9	2026-01-29 23:28:25.891717	34.68597448	126.9076502	OFFICIAL	2026-01-29 23:28:25.891721	0	\N
1769	전라남도 장흥군 장흥읍 우산리 545-1	2026-01-29 23:28:25.892149	34.67237649	126.9247591	OFFICIAL	2026-01-29 23:28:25.892153	0	\N
1770	전라남도 장흥군 장흥읍 건산리 1-1	2026-01-29 23:28:25.892565	34.68232676	126.9163015	OFFICIAL	2026-01-29 23:28:25.8926	0	\N
1771	전라남도 장흥군 장흥읍 흥성로 74 전라남도 장흥군 장흥읍 건산리 383-5	2026-01-29 23:28:25.893007	34.67713923	126.9113719	OFFICIAL	2026-01-29 23:28:25.893012	0	\N
1772	전라남도 장흥군 장흥읍 건산리 244-2	2026-01-29 23:28:25.893391	34.6766671	126.910908	OFFICIAL	2026-01-29 23:28:25.893395	0	\N
1773	전라남도 장흥군 장흥읍 예양1길 17-1 전라남도 장흥군 장흥읍 예양리 121-6	2026-01-29 23:28:25.893797	34.67384874	126.9018525	OFFICIAL	2026-01-29 23:28:25.893801	0	\N
1774	전라남도 장흥군 장흥읍 읍성로 132 전라남도 장흥군 장흥읍 남동리 28	2026-01-29 23:28:25.894177	34.67866823	126.8991879	OFFICIAL	2026-01-29 23:28:25.894181	0	\N
1775	전라남도 장흥군 장흥읍 장원길 10-24 전라남도 장흥군 장흥읍 동동리 197-2	2026-01-29 23:28:25.894552	34.6802488	126.8985426	OFFICIAL	2026-01-29 23:28:25.894557	0	\N
1776	전라남도 장흥군 장흥읍 기양리 155	2026-01-29 23:28:25.894953	34.68257093	126.9005626	OFFICIAL	2026-01-29 23:28:25.894957	0	\N
1777	전라남도 장흥군 장흥읍 건산리 669-14	2026-01-29 23:28:25.89533	34.68447145	126.9070959	OFFICIAL	2026-01-29 23:28:25.895334	0	\N
1778	전라남도 장흥군 장흥읍 건산리 565-11	2026-01-29 23:28:25.89571	34.68597737	126.9112391	OFFICIAL	2026-01-29 23:28:25.895715	0	\N
1779	전라남도 장흥군 장흥읍 동교로 20 전라남도 장흥군 장흥읍 건산리 702-1	2026-01-29 23:28:25.896141	34.68182377	126.9053472	OFFICIAL	2026-01-29 23:28:25.896155	0	\N
1780	전라남도 장흥군 장흥읍 건산리 448-9	2026-01-29 23:28:25.896531	34.68146878	126.9116445	OFFICIAL	2026-01-29 23:28:25.896535	0	\N
1781	전라남도 장흥군 장흥읍 잣두길 26 전라남도 장흥군 장흥읍 행원리 992-1	2026-01-29 23:28:25.896936	34.69070063	126.8998679	OFFICIAL	2026-01-29 23:28:25.89694	0	\N
1782	전라남도 장흥군 장흥읍 건산리 478-19	2026-01-29 23:28:25.897324	34.67907442	126.9086888	OFFICIAL	2026-01-29 23:28:25.897329	0	\N
1783	전라남도 장흥군 장흥읍 건산리 732-14	2026-01-29 23:28:25.897742	34.67942171	126.9066245	OFFICIAL	2026-01-29 23:28:25.897769	0	\N
1784	경기도 동두천시 중앙로 125 경기도 동두천시 지행동 691-5	2026-01-29 23:28:25.898142	37.89275704	127.0517467	OFFICIAL	2026-01-29 23:28:25.898146	0	\N
1785	경기도 동두천시 평화로 2333 경기도 동두천시 지행동 745-10	2026-01-29 23:28:25.898522	37.89600876	127.0574953	OFFICIAL	2026-01-29 23:28:25.898526	0	\N
1786	경기도 동두천시 중앙로 130 경기도 동두천시 지행동 693-1	2026-01-29 23:28:25.898947	37.89302678	127.0525603	OFFICIAL	2026-01-29 23:28:25.898951	0	\N
1787	경기도 동두천시 평화로 2371 경기도 동두천시 생연동 732-4	2026-01-29 23:28:25.899323	37.89940724	127.057627	OFFICIAL	2026-01-29 23:28:25.899327	0	\N
1788	경기도 동두천시 삼육사로 975 경기도 동두천시 생연동 370-2	2026-01-29 23:28:25.899701	37.89930865	127.0582298	OFFICIAL	2026-01-29 23:28:25.899705	0	\N
1789	경기도 동두천시 평화로 2285 경기도 동두천시 지행동 424-1	2026-01-29 23:28:25.900104	37.89187746	127.0556642	OFFICIAL	2026-01-29 23:28:25.900108	0	\N
1790	경기도 동두천시 평화로 2285 경기도 동두천시 지행동 424-1	2026-01-29 23:28:25.900499	37.89187746	127.0556642	OFFICIAL	2026-01-29 23:28:25.900503	0	\N
1791	경기도 동두천시 지행로 67 경기도 동두천시 지행동 695-4	2026-01-29 23:28:25.9009	37.89270189	127.054744	OFFICIAL	2026-01-29 23:28:25.900904	0	\N
1792	서울특별시 구로구 구로동로 25 서울특별시 구로구 가리봉동 88-18	2026-01-29 23:28:25.901279	37.48387266	126.8863248	OFFICIAL	2026-01-29 23:28:25.901287	0	\N
1793	충청남도 논산시 연산면 연산사계7길 12 충청남도 논산시 연산면 장전리 405-1	2026-01-29 23:28:25.901776	36.2326756	127.1682026	OFFICIAL	2026-01-29 23:28:25.90178	0	\N
1794	충청남도 논산시 부적면 안골길 8 충청남도 논산시 부적면 신교리 114-12	2026-01-29 23:28:25.902173	36.1889054	127.1456836	OFFICIAL	2026-01-29 23:28:25.902177	0	\N
1795	충청남도 논산시 광석면 논산평야로1119번길 83 충청남도 논산시 광석면 사월리 151-9	2026-01-29 23:28:25.902592	36.2543496	127.104291	OFFICIAL	2026-01-29 23:28:25.902596	0	\N
1796	충청남도 논산시 채운면 계백로499번길 62 충청남도 논산시 채운면 장화리 872	2026-01-29 23:28:25.90299	36.1771758	127.0481859	OFFICIAL	2026-01-29 23:28:25.902994	0	\N
1797	충청남도 논산시 연무읍 황화정리 319-2	2026-01-29 23:28:25.90337	36.0899181	127.11443	OFFICIAL	2026-01-29 23:28:25.903374	0	\N
1798	충청남도 논산시 연무읍 황화정리 150	2026-01-29 23:28:25.903772	36.0855444	127.1140792	OFFICIAL	2026-01-29 23:28:25.903777	0	\N
1799	충청남도 논산시 연무읍 죽본3길 3-3 충청남도 논산시 연무읍 죽본리 325-1	2026-01-29 23:28:25.904135	36.1446467	127.1222835	OFFICIAL	2026-01-29 23:28:25.90414	0	\N
1800	충청남도 논산시 연무읍 노루목길 158 충청남도 논산시 연무읍 마전리 643	2026-01-29 23:28:25.904505	36.1073228	127.0833697	OFFICIAL	2026-01-29 23:28:25.904509	0	\N
1801	충청남도 논산시 양촌면 황산벌로 977-19 충청남도 논산시 양촌면 신흥리 199-1	2026-01-29 23:28:25.904954	36.1685261	127.2043933	OFFICIAL	2026-01-29 23:28:25.904959	0	\N
1802	충청남도 논산시 채운면 연은로15번길 44 충청남도 논산시 채운면 심암리 102	2026-01-29 23:28:25.905338	36.1411598	127.0814768	OFFICIAL	2026-01-29 23:28:25.905342	0	\N
1803	충청남도 논산시 부적면 반송길 102-3 충청남도 논산시 부적면 반송리 480-1	2026-01-29 23:28:25.90571	36.2080093	127.142774	OFFICIAL	2026-01-29 23:28:25.905714	0	\N
1804	충청남도 논산시 노성면 장마루로833번길 61 충청남도 논산시 노성면 효죽리 60-2	2026-01-29 23:28:25.906111	36.292083	127.0709522	OFFICIAL	2026-01-29 23:28:25.906115	0	\N
1805	충청남도 논산시 반월동 192-33	2026-01-29 23:28:25.906535	36.2044424	127.0821847	OFFICIAL	2026-01-29 23:28:25.906539	0	\N
1806	충청남도 논산시 반월동 170-3	2026-01-29 23:28:25.90695	36.2038459	127.083148	OFFICIAL	2026-01-29 23:28:25.906954	0	\N
1807	충청남도 논산시 은진면 매죽헌로411번길 36-1 충청남도 논산시 은진면 시묘리 300-2	2026-01-29 23:28:25.907333	36.1453264	127.1352103	OFFICIAL	2026-01-29 23:28:25.907338	0	\N
1808	충청남도 논산시 부적면 금성길 45 충청남도 논산시 부적면 탑정리 270-53	2026-01-29 23:28:25.907715	36.1900389	127.1353313	OFFICIAL	2026-01-29 23:28:25.907719	0	\N
1809	충청남도 논산시 부적면 덕평1길 35 충청남도 논산시 부적면 덕평리 781-3	2026-01-29 23:28:25.90813	36.2228655	127.136984	OFFICIAL	2026-01-29 23:28:25.908135	0	\N
1810	충청남도 논산시 벌곡면 수락로 503 충청남도 논산시 벌곡면 대덕리 370-1	2026-01-29 23:28:25.90851	36.1909104	127.2931046	OFFICIAL	2026-01-29 23:28:25.908514	0	\N
1811	충청남도 논산시 광석면 논산평야로 722-17 충청남도 논산시 광석면 산동리 8-329	2026-01-29 23:28:25.908907	36.2225568	127.0939306	OFFICIAL	2026-01-29 23:28:25.908911	0	\N
1812	충청남도 논산시 양촌면 매죽헌로1461번길 27 충청남도 논산시 양촌면 임화리 342-2	2026-01-29 23:28:25.909277	36.1309929	127.217426	OFFICIAL	2026-01-29 23:28:25.909281	0	\N
1813	충청남도 논산시 양촌면 이메4길 7 충청남도 논산시 양촌면 임화리 115-1	2026-01-29 23:28:25.909644	36.1126822	127.2346906	OFFICIAL	2026-01-29 23:28:25.909648	0	\N
1814	충청남도 논산시 연무읍 신화리 1374-2	2026-01-29 23:28:25.910014	36.1307815	127.0553337	OFFICIAL	2026-01-29 23:28:25.910018	0	\N
1815	충청남도 논산시 은진면 방축길 75 충청남도 논산시 은진면 방축리 58-4	2026-01-29 23:28:25.910383	36.1602569	127.095636	OFFICIAL	2026-01-29 23:28:25.910387	0	\N
1816	충청남도 논산시 부적면 신교1길 11 충청남도 논산시 부적면 신교리 558-20	2026-01-29 23:28:25.910781	36.1919907	127.1322967	OFFICIAL	2026-01-29 23:28:25.910785	0	\N
1817	충청남도 논산시 광석면 천동1길 42 충청남도 논산시 광석면 천동리 150-6	2026-01-29 23:28:25.911243	36.2404464	127.097496	OFFICIAL	2026-01-29 23:28:25.911248	0	\N
1818	충청남도 논산시 양촌면 이메1길 18-8 충청남도 논산시 양촌면 양촌리 210-3	2026-01-29 23:28:25.911628	36.1201519	127.2415056	OFFICIAL	2026-01-29 23:28:25.911632	0	\N
1819	충청남도 논산시 벌곡면 벌곡로313번길 5 충청남도 논산시 벌곡면 조동리 164-6	2026-01-29 23:28:25.912034	36.2227392	127.2939645	OFFICIAL	2026-01-29 23:28:25.912038	0	\N
1820	서울특별시 구로구 개봉로20길 74 서울특별시 구로구 개봉동 407-17	2026-01-29 23:28:25.912418	37.49328895	126.8584193	OFFICIAL	2026-01-29 23:28:25.912423	0	\N
1821	충청남도 논산시 연무읍 연무로404번길 14 충청남도 논산시 연무읍 마산리 432	2026-01-29 23:28:25.912821	36.1184384	127.1186647	OFFICIAL	2026-01-29 23:28:25.912825	0	\N
1822	충청남도 논산시 은진면 탑정로423번길 9-1 충청남도 논산시 은진면 교촌리 38-3	2026-01-29 23:28:25.913257	36.1701156	127.1111624	OFFICIAL	2026-01-29 23:28:25.913262	0	\N
1823	충청남도 논산시 연무읍 왕릉로232번길 10 충청남도 논산시 연무읍 안심리 933-3	2026-01-29 23:28:25.913711	36.1195363	127.0776738	OFFICIAL	2026-01-29 23:28:25.913715	0	\N
1824	충청남도 논산시 연무읍 득안대로84번길 17 충청남도 논산시 연무읍 마전리 251-7	2026-01-29 23:28:25.914145	36.0790349	127.0944449	OFFICIAL	2026-01-29 23:28:25.914148	0	\N
1825	충청남도 논산시 연무읍 황화로278번길 23-19 충청남도 논산시 연무읍 고내리 1096-88	2026-01-29 23:28:25.914591	36.0970559	127.0950603	OFFICIAL	2026-01-29 23:28:25.914596	0	\N
1826	충청남도 논산시 은진면 남산리 597-9	2026-01-29 23:28:25.91503	36.172563	127.0783876	OFFICIAL	2026-01-29 23:28:25.915035	0	\N
1827	충청남도 논산시 채운면 화정리 466	2026-01-29 23:28:25.915432	36.1384303	127.0711198	OFFICIAL	2026-01-29 23:28:25.915436	0	\N
1828	충청남도 논산시 부적면 탑정리 523	2026-01-29 23:28:25.915843	36.1859067	127.1384674	OFFICIAL	2026-01-29 23:28:25.915847	0	\N
1829	충청남도 논산시 광석면 오강길 73 충청남도 논산시 광석면 오강리 265	2026-01-29 23:28:25.916237	36.2583743	127.0718182	OFFICIAL	2026-01-29 23:28:25.916242	0	\N
1830	충청남도 논산시 성동면 원북길 75 충청남도 논산시 성동면 원북리 483-1	2026-01-29 23:28:25.916673	36.2257509	127.0377544	OFFICIAL	2026-01-29 23:28:25.916677	0	\N
1831	충청남도 논산시 성동면 논산평야로436번길 51 충청남도 논산시 성동면 원봉리 444-3	2026-01-29 23:28:25.917065	36.2106661	127.0653414	OFFICIAL	2026-01-29 23:28:25.917069	0	\N
1832	충청남도 논산시 연무읍 소룡리 638-43	2026-01-29 23:28:25.917444	36.1099993	127.1293327	OFFICIAL	2026-01-29 23:28:25.917448	0	\N
1833	충청남도 논산시 지산2길 35-1 충청남도 논산시 지산동 617-1	2026-01-29 23:28:25.91784	36.2026041	127.1157999	OFFICIAL	2026-01-29 23:28:25.917844	0	\N
1834	충청남도 논산시 양촌면 대둔로 359-26 충청남도 논산시 양촌면 산직리 311	2026-01-29 23:28:25.918277	36.1738797	127.2391216	OFFICIAL	2026-01-29 23:28:25.918282	0	\N
1835	충청남도 논산시 부적면 덕평리 805	2026-01-29 23:28:25.918807	36.2263928	127.1387139	OFFICIAL	2026-01-29 23:28:25.91881	0	\N
1836	충청남도 논산시 광석면 천동리 363-2	2026-01-29 23:28:25.919967	36.2397584	127.0934988	OFFICIAL	2026-01-29 23:28:25.919972	0	\N
1837	충청남도 논산시 성동면 병촌2길 13-1 충청남도 논산시 성동면 병촌리 276	2026-01-29 23:28:25.920323	36.195938	127.0134011	OFFICIAL	2026-01-29 23:28:25.920328	0	\N
1838	충청남도 논산시 은진면 매죽헌로37번길 13 충청남도 논산시 은진면 연서리 180-3	2026-01-29 23:28:25.920678	36.16732	127.1072925	OFFICIAL	2026-01-29 23:28:25.920682	0	\N
1839	충청남도 논산시 벌곡면 수락리 40-6	2026-01-29 23:28:25.92106	36.1541058	127.3075706	OFFICIAL	2026-01-29 23:28:25.921064	0	\N
1840	충청남도 논산시 부적면 계백로1459번길 26 충청남도 논산시 부적면 마구평리 2-19	2026-01-29 23:28:25.921404	36.2159587	127.136537	OFFICIAL	2026-01-29 23:28:25.921408	0	\N
1841	충청남도 논산시 관촉로277번길 23-15 충청남도 논산시 취암동 1043-13	2026-01-29 23:28:25.921741	36.2024825	127.0911036	OFFICIAL	2026-01-29 23:28:25.921745	0	\N
2073	서울특별시 마포구 신공덕동 56-74	2026-01-29 23:28:26.045441	37.54302821	126.9527869	OFFICIAL	2026-01-29 23:28:26.045445	0	\N
1842	충청남도 논산시 채운면 계백로339번길 138 충청남도 논산시 채운면 장화리 670	2026-01-29 23:28:25.922107	36.1744971	127.0344232	OFFICIAL	2026-01-29 23:28:25.922111	0	\N
1843	충청남도 논산시 은진면 와야길 49 충청남도 논산시 은진면 와야리 177-3	2026-01-29 23:28:25.922503	36.1811894	127.1156845	OFFICIAL	2026-01-29 23:28:25.922507	0	\N
1844	충청남도 논산시 벌곡면 도산리 125-2	2026-01-29 23:28:25.922887	36.1611621	127.3137327	OFFICIAL	2026-01-29 23:28:25.922892	0	\N
1845	충청남도 논산시 연산면 한전리 496	2026-01-29 23:28:25.923324	36.2122497	127.187414	OFFICIAL	2026-01-29 23:28:25.923329	0	\N
1846	충청남도 논산시 연산면 화악길 92 충청남도 논산시 연산면 화악리 259-4	2026-01-29 23:28:25.923785	36.2503712	127.2211131	OFFICIAL	2026-01-29 23:28:25.92379	0	\N
1847	충청남도 논산시 연무읍 금곡길 47-2 충청남도 논산시 연무읍 금곡리 117-5	2026-01-29 23:28:25.924179	36.113955	127.0939115	OFFICIAL	2026-01-29 23:28:25.924183	0	\N
1848	서울특별시 구로구 개봉로20길 74 서울특별시 구로구 개봉동 407-17	2026-01-29 23:28:25.924564	37.49328895	126.8584193	OFFICIAL	2026-01-29 23:28:25.924568	0	\N
1849	서울특별시 마포구 상암동 1626	2026-01-29 23:28:25.924952	37.5742349	126.8983876	OFFICIAL	2026-01-29 23:28:25.924956	0	\N
1850	서울특별시 마포구 월드컵로 205 서울특별시 마포구 성산동 595	2026-01-29 23:28:25.925333	37.56504756	126.9014996	OFFICIAL	2026-01-29 23:28:25.925337	0	\N
1851	서울특별시 마포구 월드컵로 213 서울특별시 마포구 성산동 595-1	2026-01-29 23:28:25.925705	37.56544396	126.9008029	OFFICIAL	2026-01-29 23:28:25.925709	0	\N
1852	서울특별시 마포구 성산동 665	2026-01-29 23:28:25.92609	37.56827661	126.8927642	OFFICIAL	2026-01-29 23:28:25.926094	0	\N
1853	서울특별시 마포구 성산동 665	2026-01-29 23:28:25.926461	37.56827661	126.8927642	OFFICIAL	2026-01-29 23:28:25.926465	0	\N
1854	서울특별시 마포구 월드컵북로43길 11 서울특별시 마포구 상암동 1630	2026-01-29 23:28:25.926837	37.57466828	126.8957125	OFFICIAL	2026-01-29 23:28:25.926842	0	\N
1855	서울특별시 마포구 월드컵북로 69 서울특별시 마포구 성산동 232-4	2026-01-29 23:28:25.927202	37.55993081	126.9163426	OFFICIAL	2026-01-29 23:28:25.927206	0	\N
1856	서울특별시 마포구 상암동 1707	2026-01-29 23:28:25.927565	37.57887956	126.8919606	OFFICIAL	2026-01-29 23:28:25.927569	0	\N
1857	서울특별시 마포구 월드컵북로 137 서울특별시 마포구 성산동 56-1	2026-01-29 23:28:25.927961	37.56482585	126.9116621	OFFICIAL	2026-01-29 23:28:25.927966	0	\N
1858	서울특별시 마포구 월드컵북로 260 서울특별시 마포구 성산동 446	2026-01-29 23:28:25.92833	37.57306208	126.9010479	OFFICIAL	2026-01-29 23:28:25.928334	0	\N
1859	서울특별시 마포구 월드컵로 158 서울특별시 마포구 성산동 266-1	2026-01-29 23:28:25.928742	37.56196342	126.905207	OFFICIAL	2026-01-29 23:28:25.928768	0	\N
1860	서울특별시 마포구 성산동 99-6	2026-01-29 23:28:25.92916	37.56569253	126.9123257	OFFICIAL	2026-01-29 23:28:25.929164	0	\N
1861	서울특별시 마포구 월드컵로 108 서울특별시 마포구 성산동 252-22	2026-01-29 23:28:25.929525	37.55824513	126.9084431	OFFICIAL	2026-01-29 23:28:25.929529	0	\N
1862	서울특별시 마포구 월드컵로 100 서울특별시 마포구 성산동 649-4	2026-01-29 23:28:25.929914	37.55762081	126.9089982	OFFICIAL	2026-01-29 23:28:25.929918	0	\N
1863	서울특별시 마포구 월드컵로 74 서울특별시 마포구 서교동 475-13	2026-01-29 23:28:25.930276	37.5557822	126.9107286	OFFICIAL	2026-01-29 23:28:25.93028	0	\N
1864	서울특별시 마포구 상암동 1622-1	2026-01-29 23:28:25.930645	37.57712976	126.8978247	OFFICIAL	2026-01-29 23:28:25.930649	0	\N
1865	서울특별시 마포구 성산동 191-33	2026-01-29 23:28:25.931015	37.563845	126.9066719	OFFICIAL	2026-01-29 23:28:25.93102	0	\N
1866	서울특별시 마포구 성산동 280-7	2026-01-29 23:28:25.931375	37.56302533	126.9046698	OFFICIAL	2026-01-29 23:28:25.931379	0	\N
1867	서울특별시 마포구 성산동 280-7	2026-01-29 23:28:25.931739	37.56302533	126.9046698	OFFICIAL	2026-01-29 23:28:25.931743	0	\N
1868	서울특별시 마포구 상암동 1756-4	2026-01-29 23:28:25.932121	37.58440628	126.8834663	OFFICIAL	2026-01-29 23:28:25.932125	0	\N
1869	서울특별시 마포구 상암동 1694-1	2026-01-29 23:28:25.932478	37.58541095	126.8853832	OFFICIAL	2026-01-29 23:28:25.932482	0	\N
1870	서울특별시 마포구 성산동 313-1	2026-01-29 23:28:25.932866	37.56256223	126.9026338	OFFICIAL	2026-01-29 23:28:25.932871	0	\N
1871	서울특별시 마포구 월드컵북로62길 11 서울특별시 마포구 상암동 1582	2026-01-29 23:28:25.933229	37.5836103	126.8844155	OFFICIAL	2026-01-29 23:28:25.933233	0	\N
1872	서울특별시 마포구 성산동 196-2	2026-01-29 23:28:25.933586	37.56412724	126.9063815	OFFICIAL	2026-01-29 23:28:25.93359	0	\N
1873	서울특별시 마포구 상암동 1715	2026-01-29 23:28:25.934048	37.5799712	126.8876108	OFFICIAL	2026-01-29 23:28:25.934052	0	\N
1874	서울특별시 마포구 성산동 196-2	2026-01-29 23:28:25.934419	37.56412724	126.9063815	OFFICIAL	2026-01-29 23:28:25.934423	0	\N
1875	서울특별시 마포구 월드컵로 54 서울특별시 마포구 서교동 444-1	2026-01-29 23:28:25.934804	37.5541167	126.9120342	OFFICIAL	2026-01-29 23:28:25.934808	0	\N
1876	서울특별시 마포구 성암로 201 서울특별시 마포구 상암동 1620	2026-01-29 23:28:25.935171	37.5775885	126.896952	OFFICIAL	2026-01-29 23:28:25.935175	0	\N
1877	서울특별시 마포구 성암로 201 서울특별시 마포구 상암동 1620	2026-01-29 23:28:25.935527	37.5775885	126.896952	OFFICIAL	2026-01-29 23:28:25.935531	0	\N
1878	서울특별시 마포구 상암동 1695	2026-01-29 23:28:25.936841	37.5814607	126.8917094	OFFICIAL	2026-01-29 23:28:25.936847	0	\N
1879	서울특별시 마포구 상암동 1138	2026-01-29 23:28:25.937293	37.57666476	126.89892	OFFICIAL	2026-01-29 23:28:25.937297	0	\N
1880	서울특별시 마포구 월드컵로 지하190	2026-01-29 23:28:25.937781	37.564186	126.903288	OFFICIAL	2026-01-29 23:28:25.937793	0	\N
1881	서울특별시 마포구 성암로 37 서울특별시 마포구 중동 299	2026-01-29 23:28:25.938203	37.5691456	126.9122909	OFFICIAL	2026-01-29 23:28:25.938207	0	\N
1882	서울특별시 마포구 성산동 665	2026-01-29 23:28:25.938575	37.56827661	126.8927642	OFFICIAL	2026-01-29 23:28:25.938579	0	\N
1883	서울특별시 마포구 상암동 37-36	2026-01-29 23:28:25.938975	37.57641429	126.8933237	OFFICIAL	2026-01-29 23:28:25.938978	0	\N
1884	서울특별시 마포구 상암동 487-137	2026-01-29 23:28:25.939338	37.56129274	126.8877722	OFFICIAL	2026-01-29 23:28:25.939342	0	\N
1885	서울특별시 마포구 상암동 487-137	2026-01-29 23:28:25.939701	37.56129274	126.8877722	OFFICIAL	2026-01-29 23:28:25.939705	0	\N
1886	서울특별시 마포구 월드컵북로47길 46 서울특별시 마포구 상암동 1637	2026-01-29 23:28:25.940101	37.57488209	126.8907326	OFFICIAL	2026-01-29 23:28:25.940104	0	\N
1887	서울특별시 마포구 월드컵북로47길 46 서울특별시 마포구 상암동 1637	2026-01-29 23:28:25.94047	37.57488209	126.8907326	OFFICIAL	2026-01-29 23:28:25.940474	0	\N
1888	서울특별시 마포구 성산동 665	2026-01-29 23:28:25.940832	37.56827661	126.8927642	OFFICIAL	2026-01-29 23:28:25.940836	0	\N
1889	서울특별시 마포구 월드컵로 220 서울특별시 마포구 성산동 369-2	2026-01-29 23:28:25.941194	37.5673618	126.9006703	OFFICIAL	2026-01-29 23:28:25.941197	0	\N
1890	서울특별시 마포구 월드컵로 220 서울특별시 마포구 성산동 369-2	2026-01-29 23:28:25.941552	37.5673618	126.9006703	OFFICIAL	2026-01-29 23:28:25.941556	0	\N
1891	서울특별시 마포구 상암동 1715	2026-01-29 23:28:25.941968	37.5799712	126.8876108	OFFICIAL	2026-01-29 23:28:25.941972	0	\N
1892	서울특별시 마포구 월드컵북로 235 서울특별시 마포구 성산동 446	2026-01-29 23:28:25.942327	37.56970041	126.9014174	OFFICIAL	2026-01-29 23:28:25.942331	0	\N
1893	서울특별시 마포구 월드컵북로 381 서울특별시 마포구 상암동 1655	2026-01-29 23:28:25.942685	37.57795288	126.8898876	OFFICIAL	2026-01-29 23:28:25.942689	0	\N
1894	서울특별시 마포구 월드컵북로 381 서울특별시 마포구 상암동 1655	2026-01-29 23:28:25.943062	37.57795288	126.8898876	OFFICIAL	2026-01-29 23:28:25.943066	0	\N
1895	서울특별시 마포구 월드컵북로 381 서울특별시 마포구 상암동 1655	2026-01-29 23:28:25.943445	37.57795288	126.8898876	OFFICIAL	2026-01-29 23:28:25.943449	0	\N
1896	서울특별시 마포구 월드컵로 212 서울특별시 마포구 성산동 370	2026-01-29 23:28:25.943829	37.56631284	126.9016157	OFFICIAL	2026-01-29 23:28:25.943833	0	\N
1897	서울특별시 마포구 월드컵로 212 서울특별시 마포구 성산동 370	2026-01-29 23:28:25.944198	37.56631284	126.9016157	OFFICIAL	2026-01-29 23:28:25.944202	0	\N
1898	서울특별시 마포구 상암산로1길 26 서울특별시 마포구 상암동 1657	2026-01-29 23:28:25.944554	37.57905692	126.8875508	OFFICIAL	2026-01-29 23:28:25.944557	0	\N
1899	서울특별시 마포구 월드컵로 204 서울특별시 마포구 성산동 591-1	2026-01-29 23:28:25.944948	37.56539921	126.9021318	OFFICIAL	2026-01-29 23:28:25.944951	0	\N
1900	서울특별시 마포구 월드컵로 202 서울특별시 마포구 성산동 591-2	2026-01-29 23:28:25.945318	37.56528704	126.9024641	OFFICIAL	2026-01-29 23:28:25.945321	0	\N
1901	서울특별시 마포구 상암산로1길 52 서울특별시 마포구 상암동 1658	2026-01-29 23:28:25.945672	37.58080737	126.8853953	OFFICIAL	2026-01-29 23:28:25.945676	0	\N
1902	서울특별시 마포구 상암산로1길 52 서울특별시 마포구 상암동 1658	2026-01-29 23:28:25.946043	37.58080737	126.8853953	OFFICIAL	2026-01-29 23:28:25.946046	0	\N
1903	서울특별시 마포구 상암동 1715-25	2026-01-29 23:28:25.946415	37.58214488	126.8834433	OFFICIAL	2026-01-29 23:28:25.946418	0	\N
1904	서울특별시 마포구 가양대로 124 서울특별시 마포구 상암동 1669	2026-01-29 23:28:25.946826	37.5807915	126.8784504	OFFICIAL	2026-01-29 23:28:25.94683	0	\N
1905	서울특별시 마포구 상암동 1694-5	2026-01-29 23:28:25.947194	37.58192134	126.8794618	OFFICIAL	2026-01-29 23:28:25.947198	0	\N
1906	서울특별시 마포구 성산동 24-12	2026-01-29 23:28:25.947635	37.56590741	126.9146741	OFFICIAL	2026-01-29 23:28:25.94764	0	\N
1907	서울특별시 마포구 월드컵북로 136 서울특별시 마포구 성산동 51-11	2026-01-29 23:28:25.948071	37.56502512	126.9124737	OFFICIAL	2026-01-29 23:28:25.948076	0	\N
1908	서울특별시 마포구 월드컵북로 120 서울특별시 마포구 성산동 52-12	2026-01-29 23:28:25.948454	37.56394457	126.9133439	OFFICIAL	2026-01-29 23:28:25.948457	0	\N
1909	서울특별시 마포구 월드컵북로 78 서울특별시 마포구 성산동 209-1	2026-01-29 23:28:25.948853	37.56083654	126.916147	OFFICIAL	2026-01-29 23:28:25.948857	0	\N
1910	서울특별시 마포구 월드컵북로54길 12 서울특별시 마포구 상암동 1602	2026-01-29 23:28:25.949225	37.58085428	126.8893321	OFFICIAL	2026-01-29 23:28:25.94923	0	\N
1911	서울특별시 마포구 월드컵북로6길 3 서울특별시 마포구 연남동 571-10	2026-01-29 23:28:25.949594	37.55788989	126.9189437	OFFICIAL	2026-01-29 23:28:25.949598	0	\N
1912	서울특별시 마포구 상암동 1715-6	2026-01-29 23:28:25.949989	37.57923225	126.8894082	OFFICIAL	2026-01-29 23:28:25.949994	0	\N
1913	서울특별시 마포구 월드컵북로 15 서울특별시 마포구 서교동 445-3	2026-01-29 23:28:25.950371	37.55620886	126.9199478	OFFICIAL	2026-01-29 23:28:25.950375	0	\N
1914	서울특별시 마포구 월드컵북로 396 서울특별시 마포구 상암동 1605	2026-01-29 23:28:25.950735	37.57944191	126.8903226	OFFICIAL	2026-01-29 23:28:25.950739	0	\N
1915	서울특별시 마포구 월드컵북로 396 서울특별시 마포구 상암동 1605	2026-01-29 23:28:25.951142	37.57944191	126.8903226	OFFICIAL	2026-01-29 23:28:25.951146	0	\N
1916	서울특별시 마포구 상암동 1757	2026-01-29 23:28:25.951507	37.58633427	126.8815182	OFFICIAL	2026-01-29 23:28:25.951511	0	\N
1917	서울특별시 마포구 상암동 1758	2026-01-29 23:28:25.951887	37.58453485	126.8798665	OFFICIAL	2026-01-29 23:28:25.951891	0	\N
1918	서울특별시 마포구 월드컵로42길 9-1 서울특별시 마포구 상암동 1730	2026-01-29 23:28:25.952253	37.57818563	126.8817095	OFFICIAL	2026-01-29 23:28:25.952257	0	\N
1919	서울특별시 마포구 상암동 478-13	2026-01-29 23:28:25.952619	37.57736261	126.8808259	OFFICIAL	2026-01-29 23:28:25.952622	0	\N
1920	서울특별시 마포구 상암동 478-13	2026-01-29 23:28:25.953007	37.57736261	126.8808259	OFFICIAL	2026-01-29 23:28:25.953011	0	\N
1921	서울특별시 마포구 상암동 1542-4	2026-01-29 23:28:25.953372	37.57852263	126.8795509	OFFICIAL	2026-01-29 23:28:25.953376	0	\N
1922	서울특별시 마포구 상암동 1542-4	2026-01-29 23:28:25.953742	37.57852263	126.8795509	OFFICIAL	2026-01-29 23:28:25.95377	0	\N
1923	서울특별시 마포구 상암동 1731-9	2026-01-29 23:28:25.954132	37.57310152	126.8876032	OFFICIAL	2026-01-29 23:28:25.954136	0	\N
1924	서울특별시 마포구 월드컵로42길 22 서울특별시 마포구 상암동 1761	2026-01-29 23:28:25.954497	37.5795486	126.8831094	OFFICIAL	2026-01-29 23:28:25.954501	0	\N
1925	서울특별시 마포구 성산동 665-1	2026-01-29 23:28:25.954985	37.56911709	126.8912548	OFFICIAL	2026-01-29 23:28:25.95499	0	\N
1926	서울특별시 마포구 성산동 665	2026-01-29 23:28:25.955514	37.56827661	126.8927642	OFFICIAL	2026-01-29 23:28:25.955518	0	\N
1927	서울특별시 마포구 성산동 664	2026-01-29 23:28:25.955961	37.57048737	126.8961489	OFFICIAL	2026-01-29 23:28:25.955965	0	\N
1928	서울특별시 마포구 성산동 664	2026-01-29 23:28:25.956366	37.57048737	126.8961489	OFFICIAL	2026-01-29 23:28:25.956371	0	\N
1929	서울특별시 마포구 월드컵북로 157 서울특별시 마포구 성산동 95-14	2026-01-29 23:28:25.956824	37.5663123	126.9103618	OFFICIAL	2026-01-29 23:28:25.956828	0	\N
1930	서울특별시 마포구 서강로 51 서울특별시 마포구 창전동 256-2	2026-01-29 23:28:25.957243	37.54775312	126.9311541	OFFICIAL	2026-01-29 23:28:25.957247	0	\N
1931	서울특별시 마포구 서강로 55 서울특별시 마포구 창전동 444	2026-01-29 23:28:25.957627	37.54828681	126.9313562	OFFICIAL	2026-01-29 23:28:25.957632	0	\N
1932	서울특별시 마포구 서강로 55 서울특별시 마포구 창전동 444	2026-01-29 23:28:25.958007	37.54828681	126.9313562	OFFICIAL	2026-01-29 23:28:25.958011	0	\N
1933	서울특별시 마포구 창전동 12-34	2026-01-29 23:28:25.958454	37.55112096	126.932607	OFFICIAL	2026-01-29 23:28:25.958458	0	\N
1934	서울특별시 마포구 서강로 97 서울특별시 마포구 창전동 437	2026-01-29 23:28:25.958887	37.55193462	126.9323486	OFFICIAL	2026-01-29 23:28:25.958891	0	\N
1935	서울특별시 구로구 개봉로20길 54 서울특별시 구로구 개봉동 407-14	2026-01-29 23:28:25.959274	37.49343625	126.8573608	OFFICIAL	2026-01-29 23:28:25.959278	0	\N
1936	서울특별시 마포구 창전동 2-126	2026-01-29 23:28:25.959656	37.55276683	126.9330602	OFFICIAL	2026-01-29 23:28:25.95966	0	\N
1937	서울특별시 마포구 신촌로16길 29 서울특별시 마포구 노고산동 57-50	2026-01-29 23:28:25.960113	37.55409824	126.9347633	OFFICIAL	2026-01-29 23:28:25.960118	0	\N
1938	서울특별시 마포구 서강로 137 서울특별시 마포구 노고산동 57-26	2026-01-29 23:28:25.960578	37.55466827	126.9355938	OFFICIAL	2026-01-29 23:28:25.960583	0	\N
1939	서울특별시 마포구 서강로 137 서울특별시 마포구 노고산동 57-26	2026-01-29 23:28:25.960966	37.55466827	126.9355938	OFFICIAL	2026-01-29 23:28:25.96097	0	\N
1940	서울특별시 마포구 서강로 118 서울특별시 마포구 노고산동 112-5	2026-01-29 23:28:25.961343	37.55322915	126.9343748	OFFICIAL	2026-01-29 23:28:25.961348	0	\N
1941	서울특별시 마포구 창전로 60 서울특별시 마포구 구수동 2-3	2026-01-29 23:28:25.961711	37.54779701	126.9328946	OFFICIAL	2026-01-29 23:28:25.961715	0	\N
1942	서울특별시 마포구 창전로 60 서울특별시 마포구 구수동 2-3	2026-01-29 23:28:25.962105	37.54779701	126.9328946	OFFICIAL	2026-01-29 23:28:25.962109	0	\N
1943	서울특별시 마포구 독막로 165 서울특별시 마포구 창전동 242	2026-01-29 23:28:25.962477	37.54773473	126.9320618	OFFICIAL	2026-01-29 23:28:25.962481	0	\N
1944	서울특별시 마포구 창전동 236	2026-01-29 23:28:25.962963	37.54711325	126.931429	OFFICIAL	2026-01-29 23:28:25.962967	0	\N
1945	서울특별시 마포구 신촌로 94 서울특별시 마포구 노고산동 57-1	2026-01-29 23:28:25.96333	37.55499447	126.9359976	OFFICIAL	2026-01-29 23:28:25.963334	0	\N
1946	서울특별시 마포구 신촌로 82 서울특별시 마포구 노고산동 49-46	2026-01-29 23:28:25.963697	37.55561127	126.9348093	OFFICIAL	2026-01-29 23:28:25.963701	0	\N
1947	서울특별시 마포구 신촌로 82 서울특별시 마포구 노고산동 49-46	2026-01-29 23:28:25.964095	37.55561127	126.9348093	OFFICIAL	2026-01-29 23:28:25.964099	0	\N
1948	서울특별시 마포구 신촌로 66 서울특별시 마포구 노고산동 49-31	2026-01-29 23:28:25.964454	37.5560665	126.9331166	OFFICIAL	2026-01-29 23:28:25.964458	0	\N
1949	서울특별시 마포구 와우산로 157 서울특별시 마포구 서교동 327-9	2026-01-29 23:28:25.96484	37.5550833	126.9301095	OFFICIAL	2026-01-29 23:28:25.964844	0	\N
1950	서울특별시 마포구 와우산로 121 서울특별시 마포구 서교동 338-8	2026-01-29 23:28:25.965193	37.55350885	126.926757	OFFICIAL	2026-01-29 23:28:25.965197	0	\N
1951	서울특별시 마포구 와우산로 97 서울특별시 마포구 서교동 344-12	2026-01-29 23:28:25.965566	37.55309395	126.9243535	OFFICIAL	2026-01-29 23:28:25.965569	0	\N
1952	서울특별시 마포구 와우산로 71 서울특별시 마포구 서교동 363-2	2026-01-29 23:28:25.96595	37.55088076	126.9228524	OFFICIAL	2026-01-29 23:28:25.965954	0	\N
1953	서울특별시 마포구 와우산로 56 서울특별시 마포구 상수동 89-1	2026-01-29 23:28:25.966318	37.54944456	126.9233972	OFFICIAL	2026-01-29 23:28:25.966322	0	\N
1954	서울특별시 마포구 와우산로 55 서울특별시 마포구 상수동 90-9	2026-01-29 23:28:25.966676	37.54937991	126.9228941	OFFICIAL	2026-01-29 23:28:25.96668	0	\N
1955	서울특별시 마포구 독막로 5 서울특별시 마포구 합정동 414-3	2026-01-29 23:28:25.967036	37.54901989	126.9143079	OFFICIAL	2026-01-29 23:28:25.96704	0	\N
1956	서울특별시 마포구 독막로 5 서울특별시 마포구 합정동 414-3	2026-01-29 23:28:25.967399	37.54901989	126.9143079	OFFICIAL	2026-01-29 23:28:25.967403	0	\N
1957	서울특별시 마포구 독막로 16 서울특별시 마포구 합정동 364-37	2026-01-29 23:28:25.967785	37.54844301	126.9150957	OFFICIAL	2026-01-29 23:28:25.967789	0	\N
1958	서울특별시 마포구 독막로 36 서울특별시 마포구 합정동 363-2	2026-01-29 23:28:25.968135	37.5479499	126.9173864	OFFICIAL	2026-01-29 23:28:25.968139	0	\N
1959	서울특별시 마포구 독막로 37 서울특별시 마포구 합정동 412-12	2026-01-29 23:28:25.968491	37.54827448	126.9176949	OFFICIAL	2026-01-29 23:28:25.968495	0	\N
1960	서울특별시 마포구 독막로 63 서울특별시 마포구 상수동 317-12	2026-01-29 23:28:25.968863	37.54799414	126.9205318	OFFICIAL	2026-01-29 23:28:25.968867	0	\N
1961	서울특별시 마포구 독막로 74 서울특별시 마포구 상수동 323-3	2026-01-29 23:28:25.96922	37.5476338	126.9215759	OFFICIAL	2026-01-29 23:28:25.969224	0	\N
1962	서울특별시 마포구 독막로 63 서울특별시 마포구 상수동 317-12	2026-01-29 23:28:25.969613	37.54799414	126.9205318	OFFICIAL	2026-01-29 23:28:25.969616	0	\N
1963	서울특별시 구로구 개봉로20길 54 서울특별시 구로구 개봉동 407-14	2026-01-29 23:28:25.969997	37.49343625	126.8573608	OFFICIAL	2026-01-29 23:28:25.970001	0	\N
1964	서울특별시 마포구 독막로 101 서울특별시 마포구 상수동 141-1	2026-01-29 23:28:25.970356	37.54824385	126.924449	OFFICIAL	2026-01-29 23:28:25.97036	0	\N
1965	서울특별시 마포구 상수동 128-1	2026-01-29 23:28:25.970707	37.54758363	126.9262393	OFFICIAL	2026-01-29 23:28:25.970711	0	\N
1966	서울특별시 마포구 양화로 29 서울특별시 마포구 합정동 383-11	2026-01-29 23:28:25.971107	37.54915893	126.9124833	OFFICIAL	2026-01-29 23:28:25.971111	0	\N
1967	서울특별시 마포구 양화로 29 서울특별시 마포구 합정동 383-11	2026-01-29 23:28:25.971475	37.54915893	126.9124833	OFFICIAL	2026-01-29 23:28:25.971479	0	\N
1968	서울특별시 마포구 양화로 33-1 서울특별시 마포구 합정동 383-36	2026-01-29 23:28:25.971834	37.54916598	126.9127609	OFFICIAL	2026-01-29 23:28:25.971838	0	\N
1969	서울특별시 마포구 양화로 33-1 서울특별시 마포구 합정동 383-36	2026-01-29 23:28:25.972193	37.54916598	126.9127609	OFFICIAL	2026-01-29 23:28:25.972197	0	\N
1970	서울특별시 마포구 양화로 57 서울특별시 마포구 서교동 393-12	2026-01-29 23:28:25.972551	37.55048476	126.9147075	OFFICIAL	2026-01-29 23:28:25.972555	0	\N
1971	서울특별시 마포구 양화로 68 서울특별시 마포구 서교동 395-44	2026-01-29 23:28:25.97293	37.55075668	126.9160934	OFFICIAL	2026-01-29 23:28:25.972934	0	\N
1972	서울특별시 마포구 양화로 68 서울특별시 마포구 서교동 395-44	2026-01-29 23:28:25.973297	37.55075668	126.9160934	OFFICIAL	2026-01-29 23:28:25.973301	0	\N
1973	서울특별시 마포구 양화로 99 서울특별시 마포구 서교동 374-10	2026-01-29 23:28:25.973655	37.55306059	126.9182338	OFFICIAL	2026-01-29 23:28:25.973659	0	\N
1974	서울특별시 마포구 양화로 107 서울특별시 마포구 서교동 374-6	2026-01-29 23:28:25.974013	37.55358661	126.9187818	OFFICIAL	2026-01-29 23:28:25.974017	0	\N
1975	서울특별시 마포구 양화로 100-2 서울특별시 마포구 서교동 427	2026-01-29 23:28:25.97438	37.5528524	126.9186684	OFFICIAL	2026-01-29 23:28:25.974384	0	\N
1976	서울특별시 마포구 양화로 119 서울특별시 마포구 서교동 353-7	2026-01-29 23:28:25.974738	37.55436061	126.9197696	OFFICIAL	2026-01-29 23:28:25.974742	0	\N
1977	서울특별시 마포구 양화로 129 서울특별시 마포구 서교동 353-2	2026-01-29 23:28:25.975122	37.55506077	126.9206937	OFFICIAL	2026-01-29 23:28:25.975126	0	\N
1978	서울특별시 마포구 양화로 153 서울특별시 마포구 동교동 159-8	2026-01-29 23:28:25.975475	37.55649437	126.9226319	OFFICIAL	2026-01-29 23:28:25.975479	0	\N
1979	서울특별시 마포구 양화로 162 서울특별시 마포구 동교동 165-5	2026-01-29 23:28:25.975832	37.55642986	126.9238714	OFFICIAL	2026-01-29 23:28:25.975835	0	\N
1980	서울특별시 마포구 동교동 155-55	2026-01-29 23:28:25.976187	37.55637208	126.9231257	OFFICIAL	2026-01-29 23:28:25.976191	0	\N
1981	서울특별시 마포구 양화로 171 서울특별시 마포구 동교동 156-4	2026-01-29 23:28:25.976541	37.55753207	126.9240527	OFFICIAL	2026-01-29 23:28:25.976545	0	\N
1982	서울특별시 마포구 양화로 183 서울특별시 마포구 동교동 155-27	2026-01-29 23:28:25.976956	37.55836755	126.9251484	OFFICIAL	2026-01-29 23:28:25.97696	0	\N
1983	서울특별시 마포구 양화로 183 서울특별시 마포구 동교동 155-27	2026-01-29 23:28:25.977324	37.55836755	126.9251484	OFFICIAL	2026-01-29 23:28:25.977328	0	\N
1984	서울특별시 마포구 연희로 1-1 서울특별시 마포구 동교동 147-5	2026-01-29 23:28:25.97768	37.55901257	126.926145	OFFICIAL	2026-01-29 23:28:25.977684	0	\N
1985	서울특별시 마포구 연희로 43 서울특별시 마포구 연남동 226-36	2026-01-29 23:28:25.978043	37.56261343	126.9275008	OFFICIAL	2026-01-29 23:28:25.978047	0	\N
1986	서울특별시 마포구 연희로 43 서울특별시 마포구 연남동 226-36	2026-01-29 23:28:25.978401	37.56261343	126.9275008	OFFICIAL	2026-01-29 23:28:25.978405	0	\N
1987	서울특별시 마포구 양화로 188 서울특별시 마포구 동교동 190-1	2026-01-29 23:28:25.978788	37.55774581	126.9264983	OFFICIAL	2026-01-29 23:28:25.978792	0	\N
1988	서울특별시 마포구 양화로 188 서울특별시 마포구 동교동 190-1	2026-01-29 23:28:25.979143	37.55774581	126.9264983	OFFICIAL	2026-01-29 23:28:25.979147	0	\N
1989	서울특별시 마포구 동교동 155-55	2026-01-29 23:28:25.979526	37.55637208	126.9231257	OFFICIAL	2026-01-29 23:28:25.97953	0	\N
1990	서울특별시 마포구 동교동 155-55	2026-01-29 23:28:25.979919	37.55637208	126.9231257	OFFICIAL	2026-01-29 23:28:25.979923	0	\N
1991	서울특별시 마포구 양화로18길 3 서울특별시 마포구 동교동 166-13	2026-01-29 23:28:25.980281	37.55703127	126.9245703	OFFICIAL	2026-01-29 23:28:25.980285	0	\N
1992	서울특별시 마포구 양화로18길 3 서울특별시 마포구 동교동 166-13	2026-01-29 23:28:25.980636	37.55703127	126.9245703	OFFICIAL	2026-01-29 23:28:25.98064	0	\N
1993	서울특별시 마포구 양화로 136 서울특별시 마포구 서교동 354-1	2026-01-29 23:28:25.981001	37.55484181	126.9216064	OFFICIAL	2026-01-29 23:28:25.981005	0	\N
1994	서울특별시 마포구 양화로 136 서울특별시 마포구 서교동 354-1	2026-01-29 23:28:25.981362	37.55484181	126.9216064	OFFICIAL	2026-01-29 23:28:25.981365	0	\N
1995	서울특별시 마포구 양화로 136 서울특별시 마포구 서교동 354-1	2026-01-29 23:28:25.981716	37.55484181	126.9216064	OFFICIAL	2026-01-29 23:28:25.98172	0	\N
1996	서울특별시 마포구 양화로 136 서울특별시 마포구 서교동 354-1	2026-01-29 23:28:25.982121	37.55484181	126.9216064	OFFICIAL	2026-01-29 23:28:25.982125	0	\N
1997	서울특별시 마포구 양화로 100-2 서울특별시 마포구 서교동 427	2026-01-29 23:28:25.98249	37.5528524	126.9186684	OFFICIAL	2026-01-29 23:28:25.982494	0	\N
1998	서울특별시 마포구 양화로 100 서울특별시 마포구 서교동 372-1	2026-01-29 23:28:25.982868	37.55270402	126.918684	OFFICIAL	2026-01-29 23:28:25.982872	0	\N
1999	서울특별시 마포구 양화로 68 서울특별시 마포구 서교동 395-44	2026-01-29 23:28:25.983223	37.55075668	126.9160934	OFFICIAL	2026-01-29 23:28:25.983227	0	\N
2000	서울특별시 마포구 양화로 68 서울특별시 마포구 서교동 395-44	2026-01-29 23:28:25.983579	37.55075668	126.9160934	OFFICIAL	2026-01-29 23:28:25.983582	0	\N
2001	서울특별시 마포구 양화로 50 서울특별시 마포구 합정동 414-1	2026-01-29 23:28:26.01602	37.54952216	126.9145058	OFFICIAL	2026-01-29 23:28:26.016027	0	\N
2002	서울특별시 마포구 양화로 50 서울특별시 마포구 합정동 414-1	2026-01-29 23:28:26.016623	37.54952216	126.9145058	OFFICIAL	2026-01-29 23:28:26.016627	0	\N
2003	서울특별시 마포구 양화로 36 서울특별시 마포구 합정동 374-1	2026-01-29 23:28:26.017507	37.54850913	126.9133377	OFFICIAL	2026-01-29 23:28:26.017521	0	\N
2004	서울특별시 마포구 월드컵로5길 11 서울특별시 마포구 합정동 473	2026-01-29 23:28:26.017984	37.55161665	126.911726	OFFICIAL	2026-01-29 23:28:26.017988	0	\N
2005	서울특별시 마포구 월드컵로5길 11 서울특별시 마포구 합정동 473	2026-01-29 23:28:26.018466	37.55161665	126.911726	OFFICIAL	2026-01-29 23:28:26.018471	0	\N
2006	서울특별시 마포구 월드컵로 30 서울특별시 마포구 서교동 383-17	2026-01-29 23:28:26.018918	37.55210603	126.9126397	OFFICIAL	2026-01-29 23:28:26.018923	0	\N
2007	서울특별시 마포구 월드컵로 39 서울특별시 마포구 합정동 427-20	2026-01-29 23:28:26.019308	37.55279206	126.9119181	OFFICIAL	2026-01-29 23:28:26.019313	0	\N
2008	서울특별시 마포구 월드컵로 54 서울특별시 마포구 서교동 444-1	2026-01-29 23:28:26.019708	37.5541167	126.9120342	OFFICIAL	2026-01-29 23:28:26.019712	0	\N
2009	서울특별시 마포구 월드컵로 51 서울특별시 마포구 합정동 427-4	2026-01-29 23:28:26.020101	37.55382052	126.9115313	OFFICIAL	2026-01-29 23:28:26.020105	0	\N
2010	서울특별시 마포구 도화동 293-1	2026-01-29 23:28:26.020506	37.54111288	126.948038	OFFICIAL	2026-01-29 23:28:26.02051	0	\N
2011	서울특별시 마포구 만리재로 88 서울특별시 마포구 공덕동 111-193	2026-01-29 23:28:26.020904	37.54811717	126.9591862	OFFICIAL	2026-01-29 23:28:26.020908	0	\N
2012	서울특별시 마포구 만리재로 83-1 서울특별시 마포구 공덕동 111-209	2026-01-29 23:28:26.021292	37.54815358	126.9587131	OFFICIAL	2026-01-29 23:28:26.021296	0	\N
2013	서울특별시 마포구 대흥동 2-1	2026-01-29 23:28:26.021665	37.55656965	126.9462676	OFFICIAL	2026-01-29 23:28:26.021669	0	\N
2014	서울특별시 마포구 대흥로 194 서울특별시 마포구 대흥동 2-10	2026-01-29 23:28:26.02204	37.55623344	126.946135	OFFICIAL	2026-01-29 23:28:26.022044	0	\N
2015	서울특별시 마포구 대흥로 122 서울특별시 마포구 대흥동 38-22	2026-01-29 23:28:26.022419	37.55040682	126.9442781	OFFICIAL	2026-01-29 23:28:26.022423	0	\N
2016	서울특별시 마포구 마포대로 247 서울특별시 마포구 아현동 267-1	2026-01-29 23:28:26.022812	37.55640071	126.9565	OFFICIAL	2026-01-29 23:28:26.022816	0	\N
2017	서울특별시 마포구 마포대로 247 서울특별시 마포구 아현동 267-1	2026-01-29 23:28:26.023184	37.55640071	126.9565	OFFICIAL	2026-01-29 23:28:26.023189	0	\N
2018	서울특별시 마포구 신촌로 234 서울특별시 마포구 아현동 347-13	2026-01-29 23:28:26.023555	37.5569132	126.9516554	OFFICIAL	2026-01-29 23:28:26.023559	0	\N
2019	서울특별시 마포구 신촌로 210 서울특별시 마포구 아현동 677-1	2026-01-29 23:28:26.023953	37.55671611	126.9489834	OFFICIAL	2026-01-29 23:28:26.023957	0	\N
2020	서울특별시 마포구 신촌로 174 서울특별시 마포구 대흥동 12-23	2026-01-29 23:28:26.024326	37.55648691	126.9449971	OFFICIAL	2026-01-29 23:28:26.02433	0	\N
2021	서울특별시 마포구 신촌로 174 서울특별시 마포구 대흥동 12-23	2026-01-29 23:28:26.024698	37.55648691	126.9449971	OFFICIAL	2026-01-29 23:28:26.024701	0	\N
2022	서울특별시 마포구 신촌로 110 서울특별시 마포구 노고산동 40-56	2026-01-29 23:28:26.025098	37.55515688	126.9381344	OFFICIAL	2026-01-29 23:28:26.025102	0	\N
2023	서울특별시 마포구 창전로 32 서울특별시 마포구 구수동 68-32	2026-01-29 23:28:26.025477	37.54515427	126.9319133	OFFICIAL	2026-01-29 23:28:26.025481	0	\N
2024	서울특별시 마포구 독막로 246 서울특별시 마포구 대흥동 328-55	2026-01-29 23:28:26.026022	37.54638913	126.9408559	OFFICIAL	2026-01-29 23:28:26.026027	0	\N
2025	서울특별시 마포구 독막로 242 서울특별시 마포구 대흥동 325-5	2026-01-29 23:28:26.026519	37.54659734	126.9402909	OFFICIAL	2026-01-29 23:28:26.026524	0	\N
2026	서울특별시 마포구 독막로 192 서울특별시 마포구 신수동 458	2026-01-29 23:28:26.026994	37.54715926	126.9351045	OFFICIAL	2026-01-29 23:28:26.026998	0	\N
2027	서울특별시 마포구 독막로 221 서울특별시 마포구 신수동 178-3	2026-01-29 23:28:26.027382	37.54753983	126.9384571	OFFICIAL	2026-01-29 23:28:26.027385	0	\N
2028	서울특별시 마포구 대흥동 325-84	2026-01-29 23:28:26.02779	37.54604406	126.9402563	OFFICIAL	2026-01-29 23:28:26.027794	0	\N
2029	서울특별시 마포구 백범로 88 서울특별시 마포구 대흥동 276-1	2026-01-29 23:28:26.028164	37.547947	126.9411092	OFFICIAL	2026-01-29 23:28:26.028169	0	\N
2030	서울특별시 마포구 노고산동 31-123	2026-01-29 23:28:26.028531	37.55495552	126.9368606	OFFICIAL	2026-01-29 23:28:26.028535	0	\N
2031	서울특별시 마포구 노고산동 31-123	2026-01-29 23:28:26.02896	37.55495552	126.9368606	OFFICIAL	2026-01-29 23:28:26.028965	0	\N
2032	서울특별시 마포구 백범로 91 서울특별시 마포구 대흥동 120	2026-01-29 23:28:26.029343	37.5482162	126.9418041	OFFICIAL	2026-01-29 23:28:26.029347	0	\N
2033	서울특별시 마포구 백범로 178 서울특별시 마포구 공덕동 461	2026-01-29 23:28:26.029728	37.54388177	126.9500762	OFFICIAL	2026-01-29 23:28:26.029732	0	\N
2034	서울특별시 마포구 공덕동 435-12	2026-01-29 23:28:26.030134	37.54405896	126.9502626	OFFICIAL	2026-01-29 23:28:26.030138	0	\N
2035	서울특별시 마포구 백범로 170 서울특별시 마포구 공덕동 478	2026-01-29 23:28:26.030519	37.54429633	126.9492629	OFFICIAL	2026-01-29 23:28:26.030523	0	\N
2036	서울특별시 마포구 백범로 152 서울특별시 마포구 공덕동 476	2026-01-29 23:28:26.030916	37.54474774	126.9482582	OFFICIAL	2026-01-29 23:28:26.03092	0	\N
2037	서울특별시 마포구 백범로 122 서울특별시 마포구 염리동 155-12	2026-01-29 23:28:26.031294	37.54655467	126.9444362	OFFICIAL	2026-01-29 23:28:26.031298	0	\N
2038	서울특별시 마포구 백범로 112 서울특별시 마포구 대흥동 200-3	2026-01-29 23:28:26.031674	37.54698538	126.9435565	OFFICIAL	2026-01-29 23:28:26.031678	0	\N
2039	서울특별시 마포구 백범로 95 서울특별시 마포구 대흥동 132-1	2026-01-29 23:28:26.032043	37.54795254	126.9423084	OFFICIAL	2026-01-29 23:28:26.032048	0	\N
2040	서울특별시 마포구 공덕동 257-88	2026-01-29 23:28:26.032459	37.54448915	126.950127	OFFICIAL	2026-01-29 23:28:26.032463	0	\N
2041	서울특별시 마포구 마포대로 25 서울특별시 마포구 마포동 33-1	2026-01-29 23:28:26.032839	37.53937876	126.9448336	OFFICIAL	2026-01-29 23:28:26.032843	0	\N
2042	서울특별시 마포구 마포대로 20 서울특별시 마포구 마포동 140	2026-01-29 23:28:26.033212	37.53842521	126.9449856	OFFICIAL	2026-01-29 23:28:26.033216	0	\N
2043	서울특별시 마포구 도화동 293-1	2026-01-29 23:28:26.03359	37.54111288	126.948038	OFFICIAL	2026-01-29 23:28:26.033594	0	\N
2044	서울특별시 마포구 도화동 293-1	2026-01-29 23:28:26.033963	37.54111288	126.948038	OFFICIAL	2026-01-29 23:28:26.033968	0	\N
2045	서울특별시 마포구 마포대로 33 서울특별시 마포구 도화동 160	2026-01-29 23:28:26.034441	37.53958379	126.9459204	OFFICIAL	2026-01-29 23:28:26.034447	0	\N
2046	서울특별시 마포구 마포대로 33 서울특별시 마포구 도화동 160	2026-01-29 23:28:26.034882	37.53958379	126.9459204	OFFICIAL	2026-01-29 23:28:26.034887	0	\N
2047	서울특별시 마포구 마포대로 61-1 서울특별시 마포구 도화동 559	2026-01-29 23:28:26.03527	37.54135699	126.9480097	OFFICIAL	2026-01-29 23:28:26.035274	0	\N
2048	서울특별시 마포구 마포대로 61-1 서울특별시 마포구 도화동 559	2026-01-29 23:28:26.03566	37.54135699	126.9480097	OFFICIAL	2026-01-29 23:28:26.035664	0	\N
2049	서울특별시 마포구 공덕동 237-9	2026-01-29 23:28:26.036025	37.54615674	126.9526245	OFFICIAL	2026-01-29 23:28:26.036029	0	\N
2050	서울특별시 마포구 공덕동 237-9	2026-01-29 23:28:26.036406	37.54615674	126.9526245	OFFICIAL	2026-01-29 23:28:26.03641	0	\N
2051	서울특별시 마포구 마포대로 207-1	2026-01-29 23:28:26.036868	37.552723	126.956048	OFFICIAL	2026-01-29 23:28:26.036872	0	\N
2052	서울특별시 마포구 마포대로 233-1 서울특별시 마포구 아현동 610-1	2026-01-29 23:28:26.037249	37.5548077	126.9571319	OFFICIAL	2026-01-29 23:28:26.037253	0	\N
2053	서울특별시 마포구 아현동 447-9	2026-01-29 23:28:26.037631	37.5508124	126.9552615	OFFICIAL	2026-01-29 23:28:26.037635	0	\N
2054	서울특별시 마포구 아현동 447-9	2026-01-29 23:28:26.037998	37.5508124	126.9552615	OFFICIAL	2026-01-29 23:28:26.038002	0	\N
2055	서울특별시 마포구 아현동 447-15	2026-01-29 23:28:26.038366	37.55041674	126.9552829	OFFICIAL	2026-01-29 23:28:26.03837	0	\N
2056	서울특별시 마포구 아현동 447-15	2026-01-29 23:28:26.038733	37.55041674	126.9552829	OFFICIAL	2026-01-29 23:28:26.038737	0	\N
2057	서울특별시 마포구 마포대로 212-1	2026-01-29 23:28:26.039254	37.55278656	126.9565585	OFFICIAL	2026-01-29 23:28:26.03926	0	\N
2058	서울특별시 마포구 마포대로 212-1	2026-01-29 23:28:26.039699	37.55278656	126.9565585	OFFICIAL	2026-01-29 23:28:26.039704	0	\N
2059	서울특별시 마포구 마포대로 114 서울특별시 마포구 공덕동 255-1	2026-01-29 23:28:26.040131	37.54480763	126.9520282	OFFICIAL	2026-01-29 23:28:26.040136	0	\N
2060	서울특별시 마포구 공덕동 254-29	2026-01-29 23:28:26.040517	37.5454877	126.952345	OFFICIAL	2026-01-29 23:28:26.040521	0	\N
2061	서울특별시 마포구 마포대로 122 서울특별시 마포구 공덕동 254-5	2026-01-29 23:28:26.040918	37.54539944	126.95256	OFFICIAL	2026-01-29 23:28:26.040922	0	\N
2062	서울특별시 마포구 공덕동 237-9	2026-01-29 23:28:26.041303	37.54615674	126.9526245	OFFICIAL	2026-01-29 23:28:26.041307	0	\N
2063	서울특별시 마포구 공덕동 237-9	2026-01-29 23:28:26.041685	37.54615674	126.9526245	OFFICIAL	2026-01-29 23:28:26.041689	0	\N
2064	서울특별시 마포구 공덕동 441-3	2026-01-29 23:28:26.042072	37.54367216	126.9508125	OFFICIAL	2026-01-29 23:28:26.042076	0	\N
2065	서울특별시 마포구 공덕동 255-10	2026-01-29 23:28:26.042466	37.54431932	126.9518728	OFFICIAL	2026-01-29 23:28:26.04247	0	\N
2066	서울특별시 마포구 만리재로 3 서울특별시 마포구 공덕동 255-9	2026-01-29 23:28:26.042875	37.54435757	126.9517759	OFFICIAL	2026-01-29 23:28:26.042879	0	\N
2067	서울특별시 마포구 만리재로 14 서울특별시 마포구 공덕동 456	2026-01-29 23:28:26.043241	37.54399372	126.9528352	OFFICIAL	2026-01-29 23:28:26.043245	0	\N
2068	서울특별시 마포구 만리재로 14 서울특별시 마포구 공덕동 456	2026-01-29 23:28:26.043603	37.54399372	126.9528352	OFFICIAL	2026-01-29 23:28:26.043607	0	\N
2069	서울특별시 마포구 신공덕동 56-87	2026-01-29 23:28:26.043973	37.54297824	126.9527384	OFFICIAL	2026-01-29 23:28:26.043977	0	\N
2070	서울특별시 마포구 백범로 199 서울특별시 마포구 신공덕동 167	2026-01-29 23:28:26.044336	37.54350072	126.9528871	OFFICIAL	2026-01-29 23:28:26.04434	0	\N
2071	서울특별시 마포구 백범로 205 서울특별시 마포구 신공덕동 172	2026-01-29 23:28:26.044696	37.5441056	126.9541301	OFFICIAL	2026-01-29 23:28:26.0447	0	\N
2072	서울특별시 마포구 신공덕동 56-74	2026-01-29 23:28:26.045082	37.54302821	126.9527869	OFFICIAL	2026-01-29 23:28:26.045086	0	\N
2074	충청남도 논산시 성동면 우곤리 1433-6	2026-01-29 23:28:26.045836	36.1938917	127.0024637	OFFICIAL	2026-01-29 23:28:26.04584	0	\N
2075	충청남도 논산시 양촌면 황산벌로933번길 15 충청남도 논산시 양촌면 신흥리 306-4	2026-01-29 23:28:26.046243	36.1650858	127.2047614	OFFICIAL	2026-01-29 23:28:26.046247	0	\N
2076	충청남도 논산시 성동면 성동로 275 충청남도 논산시 성동면 원남리 394-8	2026-01-29 23:28:26.046614	36.2035828	127.0335885	OFFICIAL	2026-01-29 23:28:26.046618	0	\N
2077	충청남도 논산시 연무읍 연무로166번길 12-4 충청남도 논산시 연무읍 안심리 14-115	2026-01-29 23:28:26.047047	36.1305177	127.0971544	OFFICIAL	2026-01-29 23:28:26.047051	0	\N
2078	충청남도 논산시 벌곡면 벌곡로330번길 21 충청남도 논산시 벌곡면 조동리 435-11	2026-01-29 23:28:26.047432	36.2210051	127.2964049	OFFICIAL	2026-01-29 23:28:26.047436	0	\N
2079	전라남도 장흥군 장흥읍 제암산길 29 전라남도 장흥군 장흥읍 축내리 245	2026-01-29 23:28:26.047833	34.68732238	126.9217265	OFFICIAL	2026-01-29 23:28:26.047837	0	\N
2080	전라남도 장흥군 장흥읍 제암산길 60 전라남도 장흥군 장흥읍 상리 73-4	2026-01-29 23:28:26.04821	34.68821053	126.9246883	OFFICIAL	2026-01-29 23:28:26.048214	0	\N
2081	전라남도 장흥군 장흥읍 금성1길 120 전라남도 장흥군 장흥읍 금산리 486-2	2026-01-29 23:28:26.048576	34.69870483	126.9392988	OFFICIAL	2026-01-29 23:28:26.04858	0	\N
2082	전라남도 장흥군 장흥읍 행원2길 7 전라남도 장흥군 장흥읍 행원리 401-1	2026-01-29 23:28:26.048939	34.69591623	126.9083907	OFFICIAL	2026-01-29 23:28:26.048943	0	\N
2083	전라남도 장흥군 장흥읍 신남외3길 4-4 전라남도 장흥군 장흥읍 남외리 259-57	2026-01-29 23:28:26.04932	34.66875477	126.9012099	OFFICIAL	2026-01-29 23:28:26.049324	0	\N
2084	전라남도 장흥군 장흥읍 영전1길 89 전라남도 장흥군 장흥읍 영전리 334-1	2026-01-29 23:28:26.049681	34.66628359	126.878927	OFFICIAL	2026-01-29 23:28:26.049685	0	\N
2085	전라남도 장흥군 장흥읍 송산길 54-4 전라남도 장흥군 장흥읍 덕제리 238	2026-01-29 23:28:26.050137	34.65313399	126.8893262	OFFICIAL	2026-01-29 23:28:26.050141	0	\N
2086	전라남도 장흥군 회진면 회진리 762-13	2026-01-29 23:28:26.050508	34.48062797	126.9382923	OFFICIAL	2026-01-29 23:28:26.050512	0	\N
2087	전라남도 장흥군 부산면 부유로 28 전라남도 장흥군 부산면 유량리 75-8	2026-01-29 23:28:26.050901	34.72280907	126.903085	OFFICIAL	2026-01-29 23:28:26.050906	0	\N
2088	전라남도 장흥군 유치면 원등길 10 전라남도 장흥군 유치면 원등리 43	2026-01-29 23:28:26.051284	34.802681	126.8380485	OFFICIAL	2026-01-29 23:28:26.051288	0	\N
2089	전라남도 장흥군 장평면 선정2길 6 전라남도 장흥군 장평면 선정리 517-2	2026-01-29 23:28:26.05166	34.79001495	126.9647484	OFFICIAL	2026-01-29 23:28:26.051664	0	\N
2090	전라남도 장흥군 장동면 신북1길 35 전라남도 장흥군 장동면 북교리 7-1	2026-01-29 23:28:26.052029	34.74995321	126.9952904	OFFICIAL	2026-01-29 23:28:26.052033	0	\N
2091	전라남도 장흥군 안양면 기산리 산 65-17	2026-01-29 23:28:26.052393	34.67621633	126.9561341	OFFICIAL	2026-01-29 23:28:26.052397	0	\N
2092	전라남도 장흥군 안양면 기산리 803-4	2026-01-29 23:28:26.052791	34.67405536	126.9500929	OFFICIAL	2026-01-29 23:28:26.052795	0	\N
2093	전라남도 장흥군 용산면 인암리 1106-8	2026-01-29 23:28:26.053157	34.61479386	126.915757	OFFICIAL	2026-01-29 23:28:26.053161	0	\N
2094	전라남도 장흥군 대덕읍 도청신월로 130 전라남도 장흥군 대덕읍 도청리 491	2026-01-29 23:28:26.053518	34.49348071	126.8854671	OFFICIAL	2026-01-29 23:28:26.053522	0	\N
2095	전라남도 장흥군 관산읍 옥당리 456-2	2026-01-29 23:28:26.053901	34.56214211	126.9378043	OFFICIAL	2026-01-29 23:28:26.053905	0	\N
2096	전라남도 장흥군 장흥읍 장원길 12 전라남도 장흥군 장흥읍 동동리 187-1	2026-01-29 23:28:26.054262	34.67928179	126.897833	OFFICIAL	2026-01-29 23:28:26.054266	0	\N
2097	전라남도 장흥군 장흥읍 건산리 112-3	2026-01-29 23:28:26.054661	34.67971898	126.913682	OFFICIAL	2026-01-29 23:28:26.054665	0	\N
2098	전라남도 장흥군 장흥읍 마당바위길 34-24 전라남도 장흥군 장흥읍 송암리 270	2026-01-29 23:28:26.055039	34.6601602	126.8723369	OFFICIAL	2026-01-29 23:28:26.055043	0	\N
2099	전라남도 장흥군 장흥읍 대반길 33-3 전라남도 장흥군 장흥읍 덕제리 537-1	2026-01-29 23:28:26.0554	34.6457004	126.8847533	OFFICIAL	2026-01-29 23:28:26.055404	0	\N
2100	전라남도 장흥군 장흥읍 원도관덕길 26 전라남도 장흥군 장흥읍 관덕리 215-1	2026-01-29 23:28:26.055795	34.68870171	126.9182356	OFFICIAL	2026-01-29 23:28:26.055798	0	\N
2101	전라남도 장흥군 장흥읍 장흥로 101 전라남도 장흥군 장흥읍 건산리 568	2026-01-29 23:28:26.056159	34.68643555	126.9118196	OFFICIAL	2026-01-29 23:28:26.056162	0	\N
2102	전라남도 장흥군 장흥읍 장흥대로 3492 전라남도 장흥군 장흥읍 건산리 767	2026-01-29 23:28:26.056524	34.67534692	126.9059676	OFFICIAL	2026-01-29 23:28:26.056528	0	\N
2103	전라남도 장흥군 장흥읍 동교1길 10-5 전라남도 장흥군 장흥읍 건산리 752	2026-01-29 23:28:26.056908	34.6763513	126.9070295	OFFICIAL	2026-01-29 23:28:26.056912	0	\N
2104	전라남도 장흥군 장흥읍 못골길 37-1 전라남도 장흥군 장흥읍 건산리 41-3	2026-01-29 23:28:26.057275	34.68223702	126.9149534	OFFICIAL	2026-01-29 23:28:26.057279	0	\N
2105	전라남도 장흥군 장흥읍 건산리 435-7	2026-01-29 23:28:26.058314	34.68064	126.9129722	OFFICIAL	2026-01-29 23:28:26.058319	0	\N
2106	전라남도 장흥군 장흥읍 건산리 796-7	2026-01-29 23:28:26.058804	34.68289399	126.9061124	OFFICIAL	2026-01-29 23:28:26.058809	0	\N
2107	전라남도 장흥군 대덕읍 축내2길 10 전라남도 장흥군 대덕읍 신월리 250-2	2026-01-29 23:28:26.059218	34.49740693	126.8818718	OFFICIAL	2026-01-29 23:28:26.059222	0	\N
2108	전라남도 장흥군 회진면 회진로 612 전라남도 장흥군 회진면 덕산리 2136-10	2026-01-29 23:28:26.059718	34.47750824	126.9542629	OFFICIAL	2026-01-29 23:28:26.059722	0	\N
2109	전라남도 장흥군 부산면 내안리 938-1	2026-01-29 23:28:26.060155	34.70725949	126.8915428	OFFICIAL	2026-01-29 23:28:26.060159	0	\N
2110	전라남도 장흥군 유치면 대천리 557-1	2026-01-29 23:28:26.060549	34.84268448	126.8763152	OFFICIAL	2026-01-29 23:28:26.060553	0	\N
2111	전라남도 장흥군 장평면 청용2길 38 전라남도 장흥군 장평면 청용리 331-1	2026-01-29 23:28:26.060972	34.80475129	126.9451192	OFFICIAL	2026-01-29 23:28:26.060976	0	\N
2112	전라남도 장흥군 장동면 조양리 433	2026-01-29 23:28:26.061366	34.77096201	126.9894755	OFFICIAL	2026-01-29 23:28:26.061371	0	\N
2113	전라남도 장흥군 안양면 당암리 454-1	2026-01-29 23:28:26.061778	34.66137568	126.9678947	OFFICIAL	2026-01-29 23:28:26.061782	0	\N
2114	전라남도 장흥군 용산면 금곡길 11-9 전라남도 장흥군 용산면 금곡리 242-1	2026-01-29 23:28:26.062154	34.62058335	126.9368671	OFFICIAL	2026-01-29 23:28:26.062158	0	\N
2115	전라남도 장흥군 대덕읍 가학리 333-3	2026-01-29 23:28:26.06257	34.4797291	126.9046982	OFFICIAL	2026-01-29 23:28:26.062574	0	\N
2116	전라남도 장흥군 관산읍 옥당리 1001	2026-01-29 23:28:26.062954	34.56654864	126.9306747	OFFICIAL	2026-01-29 23:28:26.06296	0	\N
2117	전라남도 장흥군 장흥읍 원도리 315	2026-01-29 23:28:26.063331	34.68524555	126.9118631	OFFICIAL	2026-01-29 23:28:26.063337	0	\N
2118	전라남도 장흥군 장흥읍 원도리 308-5	2026-01-29 23:28:26.063792	34.68145292	126.9090171	OFFICIAL	2026-01-29 23:28:26.063796	0	\N
2119	전라남도 장흥군 장흥읍 예양리 산 10-3	2026-01-29 23:28:26.06426	34.67499149	126.9003447	OFFICIAL	2026-01-29 23:28:26.064265	0	\N
2120	전라남도 장흥군 장흥읍 예양리 88	2026-01-29 23:28:26.064643	34.67612813	126.9006662	OFFICIAL	2026-01-29 23:28:26.064647	0	\N
2121	전라남도 장흥군 장흥읍 기양리 53	2026-01-29 23:28:26.065029	34.67983289	126.9022952	OFFICIAL	2026-01-29 23:28:26.065033	0	\N
2122	전라남도 장흥군 회진면 진목리 195-42	2026-01-29 23:28:26.065408	34.44967504	126.9269511	OFFICIAL	2026-01-29 23:28:26.065412	0	\N
2123	전라남도 장흥군 회진면 회진리 1878-4	2026-01-29 23:28:26.065829	34.48924705	126.9337009	OFFICIAL	2026-01-29 23:28:26.065833	0	\N
2124	전라남도 장흥군 부산면 용반리 277-1	2026-01-29 23:28:26.06622	34.74726647	126.9027256	OFFICIAL	2026-01-29 23:28:26.066224	0	\N
2125	전라남도 장흥군 부산면 구룡리 300	2026-01-29 23:28:26.066602	34.71816482	126.8977667	OFFICIAL	2026-01-29 23:28:26.066606	0	\N
2126	전라남도 장흥군 부산면 내안리 653-1	2026-01-29 23:28:26.066988	34.70578793	126.8855547	OFFICIAL	2026-01-29 23:28:26.066992	0	\N
2127	전라남도 장흥군 유치면 장흥대로 5609 전라남도 장흥군 유치면 반월리 518-3	2026-01-29 23:28:26.067369	34.80449376	126.8061786	OFFICIAL	2026-01-29 23:28:26.067373	0	\N
2128	전라남도 장흥군 장평면 우산리 580-1	2026-01-29 23:28:26.067743	34.81359745	126.9220862	OFFICIAL	2026-01-29 23:28:26.067771	0	\N
2129	전라남도 장흥군 장동면 월곡길 285 전라남도 장흥군 장동면 용곡리 산 119-6	2026-01-29 23:28:26.068187	34.71366499	126.9584713	OFFICIAL	2026-01-29 23:28:26.068191	0	\N
2130	전라남도 장흥군 장흥읍 장흥대로 3747 전라남도 장흥군 장흥읍 행원리 1271	2026-01-29 23:28:26.06864	34.6974146	126.9005019	OFFICIAL	2026-01-29 23:28:26.068644	0	\N
2131	전라남도 장흥군 안양면 지천3길 4 전라남도 장흥군 안양면 지천리 407-1	2026-01-29 23:28:26.069072	34.63063395	126.9667607	OFFICIAL	2026-01-29 23:28:26.069076	0	\N
2132	전라남도 장흥군 대덕읍 장흥대로 856 전라남도 장흥군 대덕읍 연지리 246-6	2026-01-29 23:28:26.069469	34.50274697	126.9120029	OFFICIAL	2026-01-29 23:28:26.069474	0	\N
2133	전라남도 장흥군 대덕읍 연평길 29 전라남도 장흥군 대덕읍 연정리 145	2026-01-29 23:28:26.069939	34.50113922	126.8936383	OFFICIAL	2026-01-29 23:28:26.069944	0	\N
2134	전라남도 장흥군 관산읍 지정리 260-9	2026-01-29 23:28:26.070392	34.55572015	126.9580729	OFFICIAL	2026-01-29 23:28:26.070397	0	\N
2135	광주광역시 광산구 동곡로 155	2026-01-29 23:28:26.07081	35.09737371	126.7739134	OFFICIAL	2026-01-29 23:28:26.070814	0	\N
2136	광주광역시 광산구 유계동 237-2	2026-01-29 23:28:26.071193	35.10168773	126.7783326	OFFICIAL	2026-01-29 23:28:26.071197	0	\N
2137	광주광역시 광산구 복룡동 369-34	2026-01-29 23:28:26.071573	35.1073257	126.7786699	OFFICIAL	2026-01-29 23:28:26.071578	0	\N
2138	광주광역시 광산구 복룡동 367-34	2026-01-29 23:28:26.071956	35.11067637	126.7792337	OFFICIAL	2026-01-29 23:28:26.07196	0	\N
2139	광주광역시 광산구 복룡동 743-23	2026-01-29 23:28:26.07233	35.11790709	126.7804368	OFFICIAL	2026-01-29 23:28:26.072334	0	\N
2140	광주광역시 광산구 비아로62번길 12	2026-01-29 23:28:26.072696	35.21987458	126.8194148	OFFICIAL	2026-01-29 23:28:26.0727	0	\N
2141	광주광역시 광산구 산월로 81	2026-01-29 23:28:26.07309	35.21003947	126.8458685	OFFICIAL	2026-01-29 23:28:26.073094	0	\N
2142	광주광역시 광산구 산월동 886-7	2026-01-29 23:28:26.073453	35.20674431	126.8430584	OFFICIAL	2026-01-29 23:28:26.073457	0	\N
2143	광주광역시 광산구 첨단중앙로68번길 99	2026-01-29 23:28:26.073831	35.21248237	126.8487728	OFFICIAL	2026-01-29 23:28:26.073835	0	\N
2144	광주광역시 광산구 월계로 203	2026-01-29 23:28:26.074194	35.2138558	126.8478006	OFFICIAL	2026-01-29 23:28:26.074198	0	\N
2145	광주광역시 광산구 산월로 27-1	2026-01-29 23:28:26.074555	35.2089921	126.8403753	OFFICIAL	2026-01-29 23:28:26.074558	0	\N
2146	광주광역시 광산구 첨단중앙로 102	2026-01-29 23:28:26.07494	35.21429806	126.8433285	OFFICIAL	2026-01-29 23:28:26.074947	0	\N
2147	광주광역시 광산구 첨단내촌로 74	2026-01-29 23:28:26.075307	35.2131716	126.836408	OFFICIAL	2026-01-29 23:28:26.075311	0	\N
2148	광주광역시 광산구 쌍암동 666-11	2026-01-29 23:28:26.075673	35.21986262	126.8442883	OFFICIAL	2026-01-29 23:28:26.075677	0	\N
2149	광주광역시 광산구 임방울대로 673-12	2026-01-29 23:28:26.076027	35.21689594	126.8320336	OFFICIAL	2026-01-29 23:28:26.076031	0	\N
2150	광주광역시 광산구 월계동 758-12	2026-01-29 23:28:26.07639	35.21812509	126.8387557	OFFICIAL	2026-01-29 23:28:26.076394	0	\N
2151	광주광역시 광산구 월계동 758-12	2026-01-29 23:28:26.076776	35.21812509	126.8387557	OFFICIAL	2026-01-29 23:28:26.076779	0	\N
2152	광주광역시 광산구 임방울대로 727-20	2026-01-29 23:28:26.077139	35.21986405	126.8378944	OFFICIAL	2026-01-29 23:28:26.077143	0	\N
2153	부산광역시 사하구 다대로 210 부산광역시 사하구 장림동 1037	2026-01-29 23:28:26.077498	35.08376384	128.975571	OFFICIAL	2026-01-29 23:28:26.077502	0	\N
2154	부산광역시 사하구 장림동 1149	2026-01-29 23:28:26.07788	35.08129723	128.9589704	OFFICIAL	2026-01-29 23:28:26.077884	0	\N
2155	부산광역시 사하구 낙동대로 581 부산광역시 사하구 하단동 1217-2	2026-01-29 23:28:26.078283	35.11547085	128.9613273	OFFICIAL	2026-01-29 23:28:26.078288	0	\N
2156	부산광역시 사하구 낙동남로 1413 부산광역시 사하구 하단동 526-6	2026-01-29 23:28:26.078669	35.10668081	128.9663681	OFFICIAL	2026-01-29 23:28:26.078673	0	\N
2157	부산광역시 사하구 옥천로 125 부산광역시 사하구 감천동 10	2026-01-29 23:28:26.079024	35.09733631	129.0103738	OFFICIAL	2026-01-29 23:28:26.079028	0	\N
2158	부산광역시 사하구 감내2로 137 부산광역시 사하구 감천동 6-994	2026-01-29 23:28:26.079391	35.09816032	129.0086035	OFFICIAL	2026-01-29 23:28:26.079395	0	\N
2159	부산광역시 사하구 옥천로 73 부산광역시 사하구 감천동 16-65	2026-01-29 23:28:26.079779	35.09314392	129.0090047	OFFICIAL	2026-01-29 23:28:26.079783	0	\N
2160	부산광역시 사하구 감내1로 175 부산광역시 사하구 감천동 6-1604	2026-01-29 23:28:26.080146	35.09556525	129.0090025	OFFICIAL	2026-01-29 23:28:26.08015	0	\N
2161	부산광역시 사하구 감천로 47 부산광역시 사하구 감천동 648-11	2026-01-29 23:28:26.080518	35.09097192	128.997881	OFFICIAL	2026-01-29 23:28:26.080523	0	\N
2162	부산광역시 사하구 감천로 174 부산광역시 사하구 감천동 178-2	2026-01-29 23:28:26.080904	35.08410327	129.0087222	OFFICIAL	2026-01-29 23:28:26.080908	0	\N
2163	전라남도 장흥군 용산면 묵촌길 41-12 전라남도 장흥군 용산면 접정리 134-1	2026-01-29 23:28:26.081277	34.60664906	126.9155443	OFFICIAL	2026-01-29 23:28:26.08128	0	\N
2164	전라남도 장흥군 용산면 장전길 10 전라남도 장흥군 용산면 인암리 39-1	2026-01-29 23:28:26.08181	34.6278786	126.9276062	OFFICIAL	2026-01-29 23:28:26.081814	0	\N
2165	광주광역시 광산구 월계동 758-10	2026-01-29 23:28:26.082211	35.21854666	126.8416999	OFFICIAL	2026-01-29 23:28:26.082215	0	\N
2166	광주광역시 광산구 월계동 758-10	2026-01-29 23:28:26.082637	35.21854666	126.8416999	OFFICIAL	2026-01-29 23:28:26.082641	0	\N
2167	광주광역시 광산구 첨단중앙로 150	2026-01-29 23:28:26.083049	35.21855063	126.8423501	OFFICIAL	2026-01-29 23:28:26.083053	0	\N
2168	광주광역시 광산구 임방울대로 779	2026-01-29 23:28:26.083482	35.21822675	126.8436519	OFFICIAL	2026-01-29 23:28:26.083486	0	\N
2169	광주광역시 광산구 첨단중앙로 160	2026-01-29 23:28:26.083878	35.21952708	126.8423636	OFFICIAL	2026-01-29 23:28:26.083882	0	\N
2170	광주광역시 광산구 월계동 757-10	2026-01-29 23:28:26.084248	35.22210098	126.8407189	OFFICIAL	2026-01-29 23:28:26.084252	0	\N
2171	광주광역시 광산구 첨단중앙로182번길 8	2026-01-29 23:28:26.084615	35.22138372	126.8422588	OFFICIAL	2026-01-29 23:28:26.084619	0	\N
2172	광주광역시 광산구 첨단중앙로182번길 8	2026-01-29 23:28:26.085021	35.22138372	126.8422588	OFFICIAL	2026-01-29 23:28:26.085025	0	\N
2173	광주광역시 광산구 임방울대로 261	2026-01-29 23:28:26.08539	35.185028	126.8186595	OFFICIAL	2026-01-29 23:28:26.085394	0	\N
2174	광주광역시 광산구 임방울대로 261	2026-01-29 23:28:26.085789	35.185028	126.8186595	OFFICIAL	2026-01-29 23:28:26.085793	0	\N
2175	광주광역시 광산구 장신로 120	2026-01-29 23:28:26.086164	35.19044338	126.8232656	OFFICIAL	2026-01-29 23:28:26.086169	0	\N
2176	광주광역시 광산구 수완로 63	2026-01-29 23:28:26.086531	35.19093029	126.8284667	OFFICIAL	2026-01-29 23:28:26.086546	0	\N
2177	광주광역시 광산구 장신로 82	2026-01-29 23:28:26.08694	35.19044454	126.8187432	OFFICIAL	2026-01-29 23:28:26.086944	0	\N
2178	광주광역시 광산구 장신로 189	2026-01-29 23:28:26.087308	35.19104995	126.8308757	OFFICIAL	2026-01-29 23:28:26.087312	0	\N
2179	광주광역시 광산구 신가동 981-1	2026-01-29 23:28:26.087679	35.18764438	126.8367679	OFFICIAL	2026-01-29 23:28:26.087683	0	\N
2180	광주광역시 광산구 신창동 1235	2026-01-29 23:28:26.088061	35.19392158	126.8378283	OFFICIAL	2026-01-29 23:28:26.088065	0	\N
2181	광주광역시 광산구 신창동 1260	2026-01-29 23:28:26.088433	35.19412554	126.8374723	OFFICIAL	2026-01-29 23:28:26.088437	0	\N
2182	광주광역시 광산구 신창동 1108-2	2026-01-29 23:28:26.088827	35.1861961	126.8374212	OFFICIAL	2026-01-29 23:28:26.088831	0	\N
2183	광주광역시 광산구 수등로243번길 28-24	2026-01-29 23:28:26.089195	35.18622556	126.8367315	OFFICIAL	2026-01-29 23:28:26.089199	0	\N
2184	광주광역시 광산구 수등로 245	2026-01-29 23:28:26.089569	35.18532509	126.8358506	OFFICIAL	2026-01-29 23:28:26.089572	0	\N
2185	광주광역시 광산구 신창로 44	2026-01-29 23:28:26.089947	35.18915	126.8372627	OFFICIAL	2026-01-29 23:28:26.089951	0	\N
2186	광주광역시 광산구 신창로 44	2026-01-29 23:28:26.090324	35.18915	126.8372627	OFFICIAL	2026-01-29 23:28:26.090328	0	\N
2187	광주광역시 광산구 신창동 1185-3	2026-01-29 23:28:26.090769	35.19236233	126.8433554	OFFICIAL	2026-01-29 23:28:26.090773	0	\N
2188	광주광역시 광산구 목련로 349	2026-01-29 23:28:26.091159	35.18022786	126.8310256	OFFICIAL	2026-01-29 23:28:26.091163	0	\N
2189	광주광역시 광산구 신가동 963-5	2026-01-29 23:28:26.091532	35.18461712	126.8320931	OFFICIAL	2026-01-29 23:28:26.091536	0	\N
2190	광주광역시 광산구 목련로394번길 9-11	2026-01-29 23:28:26.091929	35.18426804	126.832928	OFFICIAL	2026-01-29 23:28:26.091933	0	\N
2191	광주광역시 광산구 운남동 776-2	2026-01-29 23:28:26.092297	35.17871572	126.82743	OFFICIAL	2026-01-29 23:28:26.092302	0	\N
2192	광주광역시 광산구 운남동 771-2	2026-01-29 23:28:26.092673	35.17900721	126.822252	OFFICIAL	2026-01-29 23:28:26.092677	0	\N
2193	광주광역시 광산구 운남동 769-3	2026-01-29 23:28:26.093027	35.17917776	126.8194328	OFFICIAL	2026-01-29 23:28:26.093042	0	\N
2194	광주광역시 광산구 운남동 782-3	2026-01-29 23:28:26.093406	35.17939357	126.8157783	OFFICIAL	2026-01-29 23:28:26.09341	0	\N
2195	광주광역시 광산구 임방울대로 148	2026-01-29 23:28:26.093812	35.1744507	126.8179442	OFFICIAL	2026-01-29 23:28:26.093816	0	\N
2196	광주광역시 광산구 하남대로 125	2026-01-29 23:28:26.094176	35.18031301	126.8071045	OFFICIAL	2026-01-29 23:28:26.094183	0	\N
2197	광주광역시 광산구 산정동 1011	2026-01-29 23:28:26.094536	35.17539587	126.797686	OFFICIAL	2026-01-29 23:28:26.09454	0	\N
2198	광주광역시 광산구 손재로110번길 21	2026-01-29 23:28:26.09492	35.17609338	126.7980729	OFFICIAL	2026-01-29 23:28:26.094924	0	\N
2199	광주광역시 광산구 사암로 303	2026-01-29 23:28:26.095289	35.1714314	126.8090289	OFFICIAL	2026-01-29 23:28:26.095293	0	\N
2200	광주광역시 광산구 사암로 300	2026-01-29 23:28:26.09567	35.17129717	126.8096478	OFFICIAL	2026-01-29 23:28:26.095676	0	\N
2201	광주광역시 광산구 사암로 274	2026-01-29 23:28:26.096027	35.16878612	126.8092135	OFFICIAL	2026-01-29 23:28:26.096031	0	\N
2202	광주광역시 광산구 사암로 266	2026-01-29 23:28:26.096403	35.16797366	126.8091751	OFFICIAL	2026-01-29 23:28:26.096407	0	\N
2203	광주광역시 광산구 사암로 251	2026-01-29 23:28:26.096796	35.16734483	126.8082321	OFFICIAL	2026-01-29 23:28:26.096799	0	\N
2204	광주광역시 광산구 사암로 251	2026-01-29 23:28:26.09716	35.16734483	126.8082321	OFFICIAL	2026-01-29 23:28:26.097164	0	\N
2205	광주광역시 광산구 월곡동 315-26	2026-01-29 23:28:26.097524	35.17273721	126.809394	OFFICIAL	2026-01-29 23:28:26.097527	0	\N
2206	광주광역시 광산구 사암로 343	2026-01-29 23:28:26.097917	35.17513465	126.8083628	OFFICIAL	2026-01-29 23:28:26.097921	0	\N
2207	광주광역시 광산구 사암로 349	2026-01-29 23:28:26.098284	35.1755469	126.8083441	OFFICIAL	2026-01-29 23:28:26.098288	0	\N
2208	광주광역시 광산구 하남대로 146	2026-01-29 23:28:26.098645	35.17977495	126.8095302	OFFICIAL	2026-01-29 23:28:26.098649	0	\N
2209	광주광역시 광산구 월곡중앙로 60-1	2026-01-29 23:28:26.099017	35.17176858	126.8113758	OFFICIAL	2026-01-29 23:28:26.099021	0	\N
2210	광주광역시 광산구 우산로 17	2026-01-29 23:28:26.099394	35.15982377	126.8041467	OFFICIAL	2026-01-29 23:28:26.099398	0	\N
2211	광주광역시 광산구 용아로 251	2026-01-29 23:28:26.099796	35.16588819	126.8012667	OFFICIAL	2026-01-29 23:28:26.0998	0	\N
2212	광주광역시 광산구 월곡산정로 12	2026-01-29 23:28:26.100165	35.16631715	126.8038702	OFFICIAL	2026-01-29 23:28:26.100168	0	\N
2213	광주광역시 광산구 월곡산정로 80	2026-01-29 23:28:26.100542	35.16577515	126.8111785	OFFICIAL	2026-01-29 23:28:26.100546	0	\N
2214	광주광역시 광산구 우산로 89	2026-01-29 23:28:26.100931	35.15661731	126.8099416	OFFICIAL	2026-01-29 23:28:26.100935	0	\N
2215	광주광역시 광산구 금봉로 106	2026-01-29 23:28:26.10131	35.1510226	126.8126175	OFFICIAL	2026-01-29 23:28:26.101314	0	\N
2216	광주광역시 광산구 금봉로 101-1	2026-01-29 23:28:26.101698	35.1521505	126.8098018	OFFICIAL	2026-01-29 23:28:26.101702	0	\N
2217	광주광역시 광산구 신촌동 978-8	2026-01-29 23:28:26.102129	35.1465121	126.8075708	OFFICIAL	2026-01-29 23:28:26.102133	0	\N
2218	광주광역시 광산구 어등대로 661	2026-01-29 23:28:26.102499	35.14493246	126.7905884	OFFICIAL	2026-01-29 23:28:26.102503	0	\N
2219	광주광역시 광산구 어등대로 658	2026-01-29 23:28:26.102896	35.14244615	126.7913219	OFFICIAL	2026-01-29 23:28:26.1029	0	\N
2220	광주광역시 광산구 상무대로 125-99	2026-01-29 23:28:26.103308	35.1313677	126.7872758	OFFICIAL	2026-01-29 23:28:26.103312	0	\N
2221	광주광역시 광산구 송정동 949-77	2026-01-29 23:28:26.103683	35.1344844	126.7893032	OFFICIAL	2026-01-29 23:28:26.103687	0	\N
2222	광주광역시 광산구 상무대로 190	2026-01-29 23:28:26.104055	35.13666213	126.7913266	OFFICIAL	2026-01-29 23:28:26.104058	0	\N
2223	광주광역시 광산구 상무대로 214	2026-01-29 23:28:26.104417	35.138236	126.7923269	OFFICIAL	2026-01-29 23:28:26.104421	0	\N
2224	광주광역시 광산구 상무대로 211	2026-01-29 23:28:26.104856	35.13827647	126.7916942	OFFICIAL	2026-01-29 23:28:26.104859	0	\N
2225	광주광역시 광산구 송정동 887-12	2026-01-29 23:28:26.105235	35.13591945	126.797431	OFFICIAL	2026-01-29 23:28:26.105239	0	\N
2226	광주광역시 광산구 상무대로 268	2026-01-29 23:28:26.105611	35.14153854	126.7956927	OFFICIAL	2026-01-29 23:28:26.105616	0	\N
2227	광주광역시 광산구 상무대로 404	2026-01-29 23:28:26.106004	35.14392764	126.8101871	OFFICIAL	2026-01-29 23:28:26.106008	0	\N
2228	서울특별시 노원구 화랑로 440-2	2026-01-29 23:28:26.106388	37.61768123	127.076266	OFFICIAL	2026-01-29 23:28:26.106392	0	\N
2229	서울특별시 구로구 개봉로19길 43 서울특별시 구로구 개봉동 302-21	2026-01-29 23:28:26.106777	37.49360219	126.8555586	OFFICIAL	2026-01-29 23:28:26.106781	0	\N
2230	서울특별시 구로구 개봉로 71 서울특별시 구로구 개봉동 403-206	2026-01-29 23:28:26.107146	37.49209383	126.8555745	OFFICIAL	2026-01-29 23:28:26.10715	0	\N
2231	서울특별시 구로구 개봉로 63 서울특별시 구로구 개봉동 403-53	2026-01-29 23:28:26.107511	37.49138218	126.8556895	OFFICIAL	2026-01-29 23:28:26.107515	0	\N
2232	서울특별시 구로구 남부순환로 775 서울특별시 구로구 개봉동 492	2026-01-29 23:28:26.107903	37.50156787	126.8471623	OFFICIAL	2026-01-29 23:28:26.107907	0	\N
2233	서울특별시 구로구 경인로 319 서울특별시 구로구 개봉동 156-5	2026-01-29 23:28:26.108272	37.49759938	126.8556011	OFFICIAL	2026-01-29 23:28:26.108276	0	\N
2234	서울특별시 구로구 경인로33길 25 서울특별시 구로구 개봉동 139-61	2026-01-29 23:28:26.108643	37.49905708	126.8517194	OFFICIAL	2026-01-29 23:28:26.108647	0	\N
2235	서울특별시 구로구 고척로 102 서울특별시 구로구 개봉동 66-32	2026-01-29 23:28:26.109016	37.50103924	126.8454965	OFFICIAL	2026-01-29 23:28:26.10902	0	\N
2236	서울특별시 구로구 고척로 85 서울특별시 구로구 개봉동 60-101	2026-01-29 23:28:26.109408	37.50107408	126.8438229	OFFICIAL	2026-01-29 23:28:26.109412	0	\N
2237	서울특별시 구로구 고척로 101 서울특별시 구로구 개봉동 63-35	2026-01-29 23:28:26.109817	37.50127895	126.8452527	OFFICIAL	2026-01-29 23:28:26.109844	0	\N
2238	서울특별시 구로구 경인로 281 서울특별시 구로구 개봉동 139-200	2026-01-29 23:28:26.110231	37.49849715	126.851827	OFFICIAL	2026-01-29 23:28:26.110235	0	\N
2239	서울특별시 구로구 경인로 313 서울특별시 구로구 개봉동 146-24	2026-01-29 23:28:26.110717	37.49749954	126.8551588	OFFICIAL	2026-01-29 23:28:26.110721	0	\N
2240	서울특별시 구로구 남부순환로 775 서울특별시 구로구 개봉동 492	2026-01-29 23:28:26.111134	37.50156787	126.8471623	OFFICIAL	2026-01-29 23:28:26.111138	0	\N
2241	서울특별시 구로구 경인로33길 51 서울특별시 구로구 개봉동 134-8	2026-01-29 23:28:26.111502	37.50024126	126.8511388	OFFICIAL	2026-01-29 23:28:26.111506	0	\N
2242	서울특별시 구로구 개봉로23가길 30 서울특별시 구로구 개봉동 416-146	2026-01-29 23:28:26.111897	37.49506475	126.8580465	OFFICIAL	2026-01-29 23:28:26.111901	0	\N
2243	서울특별시 구로구 디지털로27길 135 서울특별시 구로구 가리봉동 89-99	2026-01-29 23:28:26.112255	37.48484996	126.8865766	OFFICIAL	2026-01-29 23:28:26.112259	0	\N
2244	서울특별시 구로구 디지털로27길 135 서울특별시 구로구 가리봉동 89-99	2026-01-29 23:28:26.112665	37.48484996	126.8865766	OFFICIAL	2026-01-29 23:28:26.112669	0	\N
2245	서울특별시 구로구 디지털로 231 서울특별시 구로구 가리봉동 131-11	2026-01-29 23:28:26.113011	37.48076327	126.891283	OFFICIAL	2026-01-29 23:28:26.113015	0	\N
2246	서울특별시 구로구 디지털로 226 서울특별시 구로구 가리봉동 134-114	2026-01-29 23:28:26.11341	37.48009519	126.8911068	OFFICIAL	2026-01-29 23:28:26.113414	0	\N
2247	서울특별시 구로구 남부순환로105길 134 서울특별시 구로구 가리봉동 121-44	2026-01-29 23:28:26.113806	37.48230207	126.8867218	OFFICIAL	2026-01-29 23:28:26.113809	0	\N
2248	서울특별시 구로구 남부순환로105길 134 서울특별시 구로구 가리봉동 121-44	2026-01-29 23:28:26.114171	37.48230207	126.8867218	OFFICIAL	2026-01-29 23:28:26.114175	0	\N
2249	서울특별시 구로구 남부순환로105길 76 서울특별시 구로구 가리봉동 125-16	2026-01-29 23:28:26.114533	37.48016123	126.8886952	OFFICIAL	2026-01-29 23:28:26.114537	0	\N
2250	서울특별시 구로구 남부순환로 1295 서울특별시 구로구 가리봉동 137-4	2026-01-29 23:28:26.114922	37.47911835	126.8948323	OFFICIAL	2026-01-29 23:28:26.114926	0	\N
2251	서울특별시 구로구 구로동 693-2	2026-01-29 23:28:26.115285	37.48988183	126.875474	OFFICIAL	2026-01-29 23:28:26.115289	0	\N
2252	서울특별시 구로구 구일로4길 57 서울특별시 구로구 구로동 685-213	2026-01-29 23:28:26.115651	37.49304008	126.8757883	OFFICIAL	2026-01-29 23:28:26.115655	0	\N
2253	서울특별시 구로구 구일로4길 46 서울특별시 구로구 구로동 685-70	2026-01-29 23:28:26.116012	37.49326723	126.8778699	OFFICIAL	2026-01-29 23:28:26.116016	0	\N
2254	서울특별시 구로구 고척로 142-1 서울특별시 구로구 고척동 333	2026-01-29 23:28:26.116378	37.50264701	126.8498373	OFFICIAL	2026-01-29 23:28:26.116381	0	\N
2255	서울특별시 구로구 고척로 142-1 서울특별시 구로구 고척동 194-3	2026-01-29 23:28:26.116737	37.50264701	126.8498373	OFFICIAL	2026-01-29 23:28:26.116741	0	\N
2256	서울특별시 구로구 고척로 209-1	2026-01-29 23:28:26.117128	37.5054913	126.856546	OFFICIAL	2026-01-29 23:28:26.117132	0	\N
2257	서울특별시 구로구 고척로 206	2026-01-29 23:28:26.117488	37.50501563	126.8561093	OFFICIAL	2026-01-29 23:28:26.117492	0	\N
2258	서울특별시 구로구 고척로 202	2026-01-29 23:28:26.117904	37.50485847	126.855798	OFFICIAL	2026-01-29 23:28:26.117908	0	\N
2259	서울특별시 구로구 고척로 177	2026-01-29 23:28:26.118263	37.50419607	126.853141	OFFICIAL	2026-01-29 23:28:26.118274	0	\N
2260	서울특별시 구로구 고척로 195	2026-01-29 23:28:26.118635	37.50492878	126.854807	OFFICIAL	2026-01-29 23:28:26.118638	0	\N
2261	서울특별시 구로구 경인로 445	2026-01-29 23:28:26.119095	37.49999579	126.8681697	OFFICIAL	2026-01-29 23:28:26.119098	0	\N
2262	서울특별시 구로구 경인로 433	2026-01-29 23:28:26.11946	37.49969202	126.867056	OFFICIAL	2026-01-29 23:28:26.119464	0	\N
2263	서울특별시 구로구 경인로 403	2026-01-29 23:28:26.119822	37.49795843	126.8643477	OFFICIAL	2026-01-29 23:28:26.119825	0	\N
2264	서울특별시 구로구 경인로 403	2026-01-29 23:28:26.120181	37.49795843	126.8643477	OFFICIAL	2026-01-29 23:28:26.120185	0	\N
2265	서울특별시 구로구 경인로 331	2026-01-29 23:28:26.120547	37.497642	126.8569352	OFFICIAL	2026-01-29 23:28:26.120551	0	\N
2266	서울특별시 구로구 고척로 238 서울특별시 구로구 고척동 333	2026-01-29 23:28:26.12093	37.50617829	126.8594037	OFFICIAL	2026-01-29 23:28:26.120941	0	\N
2267	서울특별시 구로구 중앙로 76	2026-01-29 23:28:26.121298	37.50444791	126.8617685	OFFICIAL	2026-01-29 23:28:26.121302	0	\N
2268	서울특별시 구로구 중앙로 63	2026-01-29 23:28:26.121656	37.50325232	126.8618884	OFFICIAL	2026-01-29 23:28:26.12166	0	\N
2269	서울특별시 구로구 중앙로10길 7	2026-01-29 23:28:26.122024	37.5034895	126.8626141	OFFICIAL	2026-01-29 23:28:26.122028	0	\N
3015	구미시 진평동	2026-02-08 01:33:18.974595	36.10656279724593	128.41801169320516	PENDING	2026-02-08 01:33:18.974631	1	ranker1
2270	서울특별시 구로구 중앙로 37	2026-01-29 23:28:26.122387	37.50116082	126.863006	OFFICIAL	2026-01-29 23:28:26.122391	0	\N
2271	서울특별시 구로구 경서로 47 서울특별시 구로구 고척동 134-33	2026-01-29 23:28:26.122814	37.50149371	126.8585145	OFFICIAL	2026-01-29 23:28:26.122816	0	\N
2272	서울특별시 구로구 개봉로 34 서울특별시 구로구 개봉동 403-154	2026-01-29 23:28:26.123177	37.48860421	126.8564451	OFFICIAL	2026-01-29 23:28:26.123181	0	\N
2273	서울특별시 구로구 개봉로 22 서울특별시 구로구 개봉동 403-171	2026-01-29 23:28:26.12354	37.48750656	126.856558	OFFICIAL	2026-01-29 23:28:26.123544	0	\N
2274	서울특별시 구로구 개봉로 10 서울특별시 구로구 개봉동 403-196	2026-01-29 23:28:26.123932	37.48662187	126.8567122	OFFICIAL	2026-01-29 23:28:26.123936	0	\N
2275	서울특별시 구로구 개봉로 10 서울특별시 구로구 개봉동 403-196	2026-01-29 23:28:26.124291	37.48662187	126.8567122	OFFICIAL	2026-01-29 23:28:26.124294	0	\N
2276	서울특별시 구로구 개봉로1길 40 서울특별시 구로구 개봉동 367-1	2026-01-29 23:28:26.124658	37.48504966	126.8544668	OFFICIAL	2026-01-29 23:28:26.124662	0	\N
2277	서울특별시 구로구 개봉로 4 서울특별시 구로구 개봉동 290-6	2026-01-29 23:28:26.125009	37.48610225	126.8567755	OFFICIAL	2026-01-29 23:28:26.125013	0	\N
2278	서울특별시 구로구 남부순환로95길 30 서울특별시 구로구 개봉동 403-217	2026-01-29 23:28:26.125369	37.49413421	126.8564997	OFFICIAL	2026-01-29 23:28:26.125373	0	\N
2279	서울특별시 구로구 남부순환로95길 16 서울특별시 구로구 개봉동 471	2026-01-29 23:28:26.125728	37.49456794	126.8573079	OFFICIAL	2026-01-29 23:28:26.125732	0	\N
2280	서울특별시 노원구 노해로 449	2026-01-29 23:28:26.12612	37.65405358	127.0579974	OFFICIAL	2026-01-29 23:28:26.126124	0	\N
2281	서울특별시 노원구 노해로75길 14-2	2026-01-29 23:28:26.126466	37.65429614	127.0576013	OFFICIAL	2026-01-29 23:28:26.12647	0	\N
2282	서울특별시 노원구 동일로 1625	2026-01-29 23:28:26.126841	37.67375444	127.0549667	OFFICIAL	2026-01-29 23:28:26.126845	0	\N
2283	서울특별시 노원구 동일로 1629-2	2026-01-29 23:28:26.1272	37.67386054	127.0552343	OFFICIAL	2026-01-29 23:28:26.127204	0	\N
2284	서울특별시 노원구 동일로221길 22	2026-01-29 23:28:26.127562	37.6599719	127.0573759	OFFICIAL	2026-01-29 23:28:26.127566	0	\N
2285	서울특별시 노원구 노원로 532	2026-01-29 23:28:26.127957	37.66461677	127.0598168	OFFICIAL	2026-01-29 23:28:26.12796	0	\N
2286	경상남도 합천군 묘산면 관기리 639-1	2026-01-29 23:28:26.128307	35.6477544	128.1268958	OFFICIAL	2026-01-29 23:28:26.128311	0	\N
2287	경상남도 합천군 묘산면 안성리 506-2	2026-01-29 23:28:26.128656	35.6722268	128.1265811	OFFICIAL	2026-01-29 23:28:26.12866	0	\N
2288	경상남도 합천군 묘산면 광산리 272	2026-01-29 23:28:26.129036	35.6429674	128.1188273	OFFICIAL	2026-01-29 23:28:26.12904	0	\N
2289	경상남도 합천군 묘산면 팔심리 398-2	2026-01-29 23:28:26.129401	35.6284328	128.0932915	OFFICIAL	2026-01-29 23:28:26.129405	0	\N
2290	경상남도 합천군 묘산면 산제리 462-5	2026-01-29 23:28:26.129793	35.6612322	128.1057111	OFFICIAL	2026-01-29 23:28:26.129796	0	\N
2291	경상남도 합천군 묘산면 관기리 1000-16	2026-01-29 23:28:26.130149	35.6492542	128.1234858	OFFICIAL	2026-01-29 23:28:26.130152	0	\N
2292	경상남도 합천군 봉산면 권빈리 산122	2026-01-29 23:28:26.1305	35.6178109	128.0725151	OFFICIAL	2026-01-29 23:28:26.130504	0	\N
2293	경상남도 합천군 봉산면 봉계리 849	2026-01-29 23:28:26.130966	35.6106827	128.0230367	OFFICIAL	2026-01-29 23:28:26.13097	0	\N
2294	대구광역시 달서구 월배로 328	2026-01-29 23:28:26.131348	35.82469667	128.5467008	OFFICIAL	2026-01-29 23:28:26.131352	0	\N
2295	대구광역시 달서구 구마로 253-1	2026-01-29 23:28:26.131722	35.8374365	128.5555388	OFFICIAL	2026-01-29 23:28:26.131726	0	\N
2296	대구광역시 달서구 달구벌대로 1541-1	2026-01-29 23:28:26.132126	35.85032939	128.5354417	OFFICIAL	2026-01-29 23:28:26.13213	0	\N
2297	대구광역시 달서구 월배로 202	2026-01-29 23:28:26.1326	35.81802126	128.5358598	OFFICIAL	2026-01-29 23:28:26.132606	0	\N
2298	대구광역시 달서구 선원로 270	2026-01-29 23:28:26.133014	35.85852491	128.5220493	OFFICIAL	2026-01-29 23:28:26.133019	0	\N
2299	대구광역시 달서구 달구벌대로 1790	2026-01-29 23:28:26.133398	35.85855961	128.5607948	OFFICIAL	2026-01-29 23:28:26.133403	0	\N
2300	대구광역시 달서구 구마로 256	2026-01-29 23:28:26.133802	35.83702973	128.5557906	OFFICIAL	2026-01-29 23:28:26.133806	0	\N
2301	대구광역시 달서구 상인서로85	2026-01-29 23:28:26.134196	35.81791126	128.5402856	OFFICIAL	2026-01-29 23:28:26.1342	0	\N
2302	대구광역시 달서구 달구벌대로 1467	2026-01-29 23:28:26.134575	35.84945213	128.5274033	OFFICIAL	2026-01-29 23:28:26.134579	0	\N
2303	전북특별자치도 남원시 주천면 용담리 257-1	2026-01-29 23:28:26.134946	35.40842925	127.4084162	OFFICIAL	2026-01-29 23:28:26.13495	0	\N
2304	전북특별자치도 남원시 주천면 송치리 1298-1	2026-01-29 23:28:26.135495	35.38903195	127.4073359	OFFICIAL	2026-01-29 23:28:26.135501	0	\N
2305	전북특별자치도 남원시 주천면 배덕리 311-1	2026-01-29 23:28:26.13596	35.36696514	127.4121295	OFFICIAL	2026-01-29 23:28:26.135964	0	\N
2306	전북특별자치도 남원시 주천면 내용궁길 32	2026-01-29 23:28:26.136351	35.37860814	127.4498623	OFFICIAL	2026-01-29 23:28:26.136354	0	\N
2307	전북특별자치도 남원시 주천면 은송리 232-3	2026-01-29 23:28:26.136719	35.39793022	127.45299	OFFICIAL	2026-01-29 23:28:26.136723	0	\N
2308	전북특별자치도 남원시 주천면 은송리 492-4	2026-01-29 23:28:26.137119	35.39716949	127.4442873	OFFICIAL	2026-01-29 23:28:26.137123	0	\N
2309	전북특별자치도 남원시 주천면 송치리 1265	2026-01-29 23:28:26.137486	35.38949235	127.4086972	OFFICIAL	2026-01-29 23:28:26.13749	0	\N
2310	전북특별자치도 남원시 주천면 고기리 861	2026-01-29 23:28:26.137876	35.38721263	127.501021	OFFICIAL	2026-01-29 23:28:26.13788	0	\N
2311	전북특별자치도 남원시 주천면 호경리 105-2	2026-01-29 23:28:26.138241	35.38832363	127.4554983	OFFICIAL	2026-01-29 23:28:26.138245	0	\N
2312	전북특별자치도 남원시 주천면 송치리 1285	2026-01-29 23:28:26.138611	35.38905703	127.4063118	OFFICIAL	2026-01-29 23:28:26.138615	0	\N
2313	전북특별자치도 남원시 주천면 장안리 242-1	2026-01-29 23:28:26.138973	35.3898443	127.4449758	OFFICIAL	2026-01-29 23:28:26.138977	0	\N
2314	전북특별자치도 남원시 운봉읍 장교리 773-3	2026-01-29 23:28:26.139337	35.45067995	127.4967987	OFFICIAL	2026-01-29 23:28:26.13934	0	\N
2315	전북특별자치도 남원시 운봉읍 권포리 547-1	2026-01-29 23:28:26.139712	35.46687842	127.5100065	OFFICIAL	2026-01-29 23:28:26.139716	0	\N
2316	전북특별자치도 남원시 운봉읍 산덕리 443-4	2026-01-29 23:28:26.140107	35.42362309	127.5388	OFFICIAL	2026-01-29 23:28:26.140111	0	\N
2317	전북특별자치도 남원시 운봉읍 행정리 535-19	2026-01-29 23:28:26.140474	35.42163261	127.5231506	OFFICIAL	2026-01-29 23:28:26.140478	0	\N
2318	전북특별자치도 남원시 운봉읍 매요리 1034-1	2026-01-29 23:28:26.140842	35.46869124	127.5402853	OFFICIAL	2026-01-29 23:28:26.140846	0	\N
2319	전북특별자치도 남원시 운봉읍 화수리 1148	2026-01-29 23:28:26.141208	35.44490464	127.5531868	OFFICIAL	2026-01-29 23:28:26.141212	0	\N
2320	전북특별자치도 남원시 송동면 내사촌길 40	2026-01-29 23:28:26.141569	35.35750874	127.3672497	OFFICIAL	2026-01-29 23:28:26.141573	0	\N
2321	전북특별자치도 남원시 송동면 연산리 327-2	2026-01-29 23:28:26.141984	35.3356625	127.3148826	OFFICIAL	2026-01-29 23:28:26.141988	0	\N
2322	전북특별자치도 남원시 송동면 송기리 306	2026-01-29 23:28:26.142349	35.35415642	127.3387237	OFFICIAL	2026-01-29 23:28:26.142353	0	\N
2323	전북특별자치도 남원시 송동면 손동길 11	2026-01-29 23:28:26.142712	35.33826696	127.3195799	OFFICIAL	2026-01-29 23:28:26.142716	0	\N
2324	전북특별자치도 남원시 송동면 장국리 617-1	2026-01-29 23:28:26.143103	35.37632011	127.3619526	OFFICIAL	2026-01-29 23:28:26.143107	0	\N
2325	전북특별자치도 남원시 송동면 송내리 541-5	2026-01-29 23:28:26.143465	35.35847485	127.3538952	OFFICIAL	2026-01-29 23:28:26.143468	0	\N
2326	전북특별자치도 남원시 수지면 유암리 948	2026-01-29 23:28:26.143828	35.32778604	127.378755	OFFICIAL	2026-01-29 23:28:26.143832	0	\N
2327	전북특별자치도 남원시 수지면 산정리 214-2	2026-01-29 23:28:26.144196	35.32340826	127.3602778	OFFICIAL	2026-01-29 23:28:26.1442	0	\N
2328	전북특별자치도 남원시 수지면 산정리 1184	2026-01-29 23:28:26.144559	35.33231879	127.3594598	OFFICIAL	2026-01-29 23:28:26.144563	0	\N
2329	전북특별자치도 남원시 수지면 고평리 1337	2026-01-29 23:28:26.144948	35.35619133	127.4043182	OFFICIAL	2026-01-29 23:28:26.144952	0	\N
2330	전북특별자치도 남원시 수지면 고평리 1369-6	2026-01-29 23:28:26.14531	35.35216936	127.3930701	OFFICIAL	2026-01-29 23:28:26.145314	0	\N
2331	전북특별자치도 남원시 수지면 고평리 634-1	2026-01-29 23:28:26.145671	35.34718789	127.3861675	OFFICIAL	2026-01-29 23:28:26.145675	0	\N
2332	전북특별자치도 남원시 수지면 산정리 741	2026-01-29 23:28:26.146026	35.33430015	127.3583112	OFFICIAL	2026-01-29 23:28:26.146029	0	\N
2333	전북특별자치도 남원시 수지면 남창리 1618	2026-01-29 23:28:26.146424	35.32752079	127.3302731	OFFICIAL	2026-01-29 23:28:26.146428	0	\N
2334	전북특별자치도 남원시 수지면 호곡리 619-4	2026-01-29 23:28:26.146833	35.33897184	127.3733893	OFFICIAL	2026-01-29 23:28:26.146837	0	\N
2335	전북특별자치도 남원시 주천면 주천리 920-179	2026-01-29 23:28:26.147196	35.37939133	127.403917	OFFICIAL	2026-01-29 23:28:26.1472	0	\N
2336	전북특별자치도 남원시 금지면 입암리 378-1	2026-01-29 23:28:26.147554	35.35725419	127.2934866	OFFICIAL	2026-01-29 23:28:26.147558	0	\N
2337	전북특별자치도 남원시 금지면 방촌리 737	2026-01-29 23:28:26.148004	35.34386525	127.2837238	OFFICIAL	2026-01-29 23:28:26.148008	0	\N
2338	전북특별자치도 남원시 금지면 하도리 621-176	2026-01-29 23:28:26.148383	35.3181501	127.3072655	OFFICIAL	2026-01-29 23:28:26.148386	0	\N
2339	전북특별자치도 남원시 금지면 택내리 933-1	2026-01-29 23:28:26.148778	35.33359034	127.286509	OFFICIAL	2026-01-29 23:28:26.148782	0	\N
2340	전북특별자치도 남원시 주생면 지당리 433-2	2026-01-29 23:28:26.149145	35.38636547	127.3293036	OFFICIAL	2026-01-29 23:28:26.149149	0	\N
2341	전북특별자치도 남원시 주생면 도산리 654-10	2026-01-29 23:28:26.149549	35.37371525	127.2815127	OFFICIAL	2026-01-29 23:28:26.149563	0	\N
2342	전북특별자치도 남원시 주생면 정송리 41-9	2026-01-29 23:28:26.14996	35.39953427	127.3325498	OFFICIAL	2026-01-29 23:28:26.149965	0	\N
2343	전북특별자치도 남원시 주생면 영천리 472-1	2026-01-29 23:28:26.15034	35.38149043	127.3134836	OFFICIAL	2026-01-29 23:28:26.150344	0	\N
2344	전북특별자치도 남원시 주생면 낙동리 323-6	2026-01-29 23:28:26.150736	35.3827541	127.3011786	OFFICIAL	2026-01-29 23:28:26.15074	0	\N
2345	전북특별자치도 남원시 주생면 상동리 635-1	2026-01-29 23:28:26.151125	35.39730222	127.3413227	OFFICIAL	2026-01-29 23:28:26.151129	0	\N
2346	전북특별자치도 남원시 주생면 정송리 636	2026-01-29 23:28:26.151486	35.39376666	127.3187051	OFFICIAL	2026-01-29 23:28:26.15149	0	\N
2347	전북특별자치도 남원시 주생면 내동리 717-131	2026-01-29 23:28:26.151922	35.38491711	127.2737878	OFFICIAL	2026-01-29 23:28:26.151926	0	\N
2348	전북특별자치도 남원시 주생면 영천리 241-6	2026-01-29 23:28:26.152285	35.3818873	127.3166595	OFFICIAL	2026-01-29 23:28:26.152289	0	\N
2349	전북특별자치도 남원시 송동면 신평리 924	2026-01-29 23:28:26.152648	35.36030725	127.3262396	OFFICIAL	2026-01-29 23:28:26.152652	0	\N
2350	전북특별자치도 남원시 송동면 연산리 347-1	2026-01-29 23:28:26.153016	35.33595684	127.3177549	OFFICIAL	2026-01-29 23:28:26.153021	0	\N
2351	전북특별자치도 남원시 송동면 두신리 844-150	2026-01-29 23:28:26.15339	35.34436817	127.3082194	OFFICIAL	2026-01-29 23:28:26.153394	0	\N
2352	전북특별자치도 남원시 덕과면 용산리 259-2	2026-01-29 23:28:26.153776	35.54837217	127.3578824	OFFICIAL	2026-01-29 23:28:26.15378	0	\N
2353	전북특별자치도 남원시 사매면 인화리 625	2026-01-29 23:28:26.154175	35.47781273	127.339478	OFFICIAL	2026-01-29 23:28:26.154179	0	\N
2354	전북특별자치도 남원시 대산면 수덕리 650-1	2026-01-29 23:28:26.154539	35.41550249	127.3316834	OFFICIAL	2026-01-29 23:28:26.154544	0	\N
2355	전북특별자치도 남원시 대산면 금성리 235-1	2026-01-29 23:28:26.154932	35.42202668	127.3395583	OFFICIAL	2026-01-29 23:28:26.154936	0	\N
2356	전북특별자치도 남원시 대산면 갈랭이길 36-48	2026-01-29 23:28:26.155285	35.40977233	127.3338005	OFFICIAL	2026-01-29 23:28:26.155288	0	\N
2357	전북특별자치도 남원시 대강면 송대리 173-1	2026-01-29 23:28:26.155667	35.36759785	127.2334992	OFFICIAL	2026-01-29 23:28:26.155671	0	\N
2358	전북특별자치도 남원시 대강면 사석리 1854-107	2026-01-29 23:28:26.156009	35.34197457	127.232421	OFFICIAL	2026-01-29 23:28:26.156013	0	\N
2359	전북특별자치도 남원시 대강면 평촌리 268-2	2026-01-29 23:28:26.156371	35.38779571	127.2417401	OFFICIAL	2026-01-29 23:28:26.156374	0	\N
2360	전북특별자치도 남원시 대강면 신덕리 636-6	2026-01-29 23:28:26.156744	35.3327879	127.2086829	OFFICIAL	2026-01-29 23:28:26.156792	0	\N
2361	전북특별자치도 남원시 대강면 사석리 728	2026-01-29 23:28:26.15717	35.34732509	127.2277385	OFFICIAL	2026-01-29 23:28:26.157174	0	\N
2362	전북특별자치도 남원시 대강면 월탄리 829	2026-01-29 23:28:26.157532	35.34638346	127.201369	OFFICIAL	2026-01-29 23:28:26.157536	0	\N
2363	전북특별자치도 남원시 금지면 황구길 15	2026-01-29 23:28:26.157929	35.33286064	127.2978235	OFFICIAL	2026-01-29 23:28:26.157933	0	\N
2364	전북특별자치도 남원시 금지면 신월리 389-1	2026-01-29 23:28:26.15829	35.32366335	127.2957471	OFFICIAL	2026-01-29 23:28:26.158294	0	\N
2365	전북특별자치도 남원시 금지면 옹정리 253-3	2026-01-29 23:28:26.158644	35.36055228	127.305782	OFFICIAL	2026-01-29 23:28:26.158648	0	\N
2366	전북특별자치도 남원시 금지면 상신리 211-1	2026-01-29 23:28:26.15903	35.33190207	127.3004057	OFFICIAL	2026-01-29 23:28:26.159034	0	\N
2367	전북특별자치도 남원시 금지면 서매리 1016-5	2026-01-29 23:28:26.159519	35.35186735	127.2741939	OFFICIAL	2026-01-29 23:28:26.159523	0	\N
2368	전북특별자치도 남원시 이백면 양가리 663-14	2026-01-29 23:28:26.159932	35.43897869	127.4628585	OFFICIAL	2026-01-29 23:28:26.159936	0	\N
2369	전북특별자치도 남원시 이백면 내동리 210	2026-01-29 23:28:26.160333	35.44656257	127.4436362	OFFICIAL	2026-01-29 23:28:26.160337	0	\N
2370	전북특별자치도 남원시 이백면 과립리 475-6	2026-01-29 23:28:26.160707	35.42585191	127.4590523	OFFICIAL	2026-01-29 23:28:26.160711	0	\N
2371	전북특별자치도 남원시 이백면 남계리 945-2	2026-01-29 23:28:26.161141	35.45428587	127.4393461	OFFICIAL	2026-01-29 23:28:26.161144	0	\N
2372	전북특별자치도 남원시 이백면 효기리 754-1	2026-01-29 23:28:26.161514	35.4220747	127.4581461	OFFICIAL	2026-01-29 23:28:26.161518	0	\N
2373	전북특별자치도 남원시 이백면 서곡리 601-4	2026-01-29 23:28:26.161909	35.42691032	127.4353836	OFFICIAL	2026-01-29 23:28:26.161913	0	\N
2374	전북특별자치도 남원시 이백면 서곡리 302-11	2026-01-29 23:28:26.162274	35.43260013	127.4371944	OFFICIAL	2026-01-29 23:28:26.162278	0	\N
2375	전북특별자치도 남원시 산동면 목동리 395-12	2026-01-29 23:28:26.162633	35.46862422	127.4407123	OFFICIAL	2026-01-29 23:28:26.162636	0	\N
2376	전북특별자치도 남원시 산동면 월석리 208	2026-01-29 23:28:26.162989	35.49671861	127.517817	OFFICIAL	2026-01-29 23:28:26.162993	0	\N
2377	전북특별자치도 남원시 산동면 월석리 397-6	2026-01-29 23:28:26.163349	35.50139781	127.5113297	OFFICIAL	2026-01-29 23:28:26.163354	0	\N
2378	전북특별자치도 남원시 산동면 대기리 156-4	2026-01-29 23:28:26.163712	35.49589819	127.4978278	OFFICIAL	2026-01-29 23:28:26.163715	0	\N
2379	전북특별자치도 남원시 산동면 태평리 536-1	2026-01-29 23:28:26.164102	35.49350189	127.4740356	OFFICIAL	2026-01-29 23:28:26.164106	0	\N
2380	전북특별자치도 남원시 보절면 금다리 359-1	2026-01-29 23:28:26.164458	35.50093726	127.425013	OFFICIAL	2026-01-29 23:28:26.164461	0	\N
2381	전북특별자치도 남원시 보절면 사촌길 15-7	2026-01-29 23:28:26.164841	35.53955647	127.4109201	OFFICIAL	2026-01-29 23:28:26.164844	0	\N
2382	전북특별자치도 남원시 덕과면 신양리 416	2026-01-29 23:28:26.165197	35.50903821	127.3860081	OFFICIAL	2026-01-29 23:28:26.165201	0	\N
2383	전북특별자치도 남원시 덕과면 덕촌리 165	2026-01-29 23:28:26.165553	35.54390953	127.3731704	OFFICIAL	2026-01-29 23:28:26.165557	0	\N
2384	전북특별자치도 남원시 산내면 백일리 519	2026-01-29 23:28:26.165938	35.4237192	127.6384466	OFFICIAL	2026-01-29 23:28:26.165942	0	\N
2385	전북특별자치도 남원시 산내면 대정리 491-1	2026-01-29 23:28:26.166298	35.42497963	127.6256705	OFFICIAL	2026-01-29 23:28:26.166302	0	\N
2386	전북특별자치도 남원시 산내면 입석리 482-5	2026-01-29 23:28:26.166654	35.41173965	127.6203803	OFFICIAL	2026-01-29 23:28:26.166658	0	\N
2387	전북특별자치도 남원시 산내면 중황리 624	2026-01-29 23:28:26.167011	35.42660069	127.6458936	OFFICIAL	2026-01-29 23:28:26.167015	0	\N
2388	전북특별자치도 남원시 산내면 부운리 235	2026-01-29 23:28:26.167453	35.37637191	127.5802182	OFFICIAL	2026-01-29 23:28:26.167457	0	\N
2389	전북특별자치도 남원시 산내면 부운리 244	2026-01-29 23:28:26.167835	35.3729065	127.5791921	OFFICIAL	2026-01-29 23:28:26.167838	0	\N
2390	전북특별자치도 남원시 산내면 입석리 205-6	2026-01-29 23:28:26.1682	35.41698763	127.629545	OFFICIAL	2026-01-29 23:28:26.168204	0	\N
2391	전북특별자치도 남원시 산내면 백일리 502-1	2026-01-29 23:28:26.16857	35.41718688	127.6389487	OFFICIAL	2026-01-29 23:28:26.168574	0	\N
2392	전북특별자치도 남원시 아영면 구상리 233-2	2026-01-29 23:28:26.168951	35.52942322	127.5905751	OFFICIAL	2026-01-29 23:28:26.168955	0	\N
2393	전북특별자치도 남원시 아영면 일대리 235-1	2026-01-29 23:28:26.169326	35.52732897	127.6019318	OFFICIAL	2026-01-29 23:28:26.16933	0	\N
2394	전북특별자치도 남원시 아영면 아곡리 703	2026-01-29 23:28:26.169696	35.48034216	127.5735216	OFFICIAL	2026-01-29 23:28:26.1697	0	\N
2395	전북특별자치도 남원시 아영면 월산리 551-2	2026-01-29 23:28:26.170085	35.51572048	127.5970278	OFFICIAL	2026-01-29 23:28:26.170089	0	\N
2396	전북특별자치도 남원시 아영면 아백로 380	2026-01-29 23:28:26.170459	35.50864276	127.6128933	OFFICIAL	2026-01-29 23:28:26.170462	0	\N
2397	전북특별자치도 남원시 아영면 의지리 76	2026-01-29 23:28:26.170822	35.52793434	127.6204677	OFFICIAL	2026-01-29 23:28:26.170826	0	\N
2398	전북특별자치도 남원시 인월면 자래리 223-3	2026-01-29 23:28:26.171204	35.48321338	127.6181834	OFFICIAL	2026-01-29 23:28:26.171208	0	\N
2399	전북특별자치도 남원시 인월면 서무리 828-1	2026-01-29 23:28:26.171578	35.46518553	127.5956106	OFFICIAL	2026-01-29 23:28:26.171581	0	\N
2400	전북특별자치도 남원시 고죽동 527-5	2026-01-29 23:28:26.171948	35.44840228	127.398552	OFFICIAL	2026-01-29 23:28:26.171952	0	\N
2401	전북특별자치도 남원시 장승길 12-3	2026-01-29 23:28:26.172339	35.41858193	127.3749332	OFFICIAL	2026-01-29 23:28:26.172342	0	\N
2402	전북특별자치도 남원시 산곡동 산 12-16	2026-01-29 23:28:26.172699	35.42616903	127.3674963	OFFICIAL	2026-01-29 23:28:26.172703	0	\N
2403	전북특별자치도 남원시 칠승리길 84	2026-01-29 23:28:26.173087	35.40857624	127.362778	OFFICIAL	2026-01-29 23:28:26.173091	0	\N
2404	전북특별자치도 남원시 노암동 597-32	2026-01-29 23:28:26.173448	35.39522147	127.3738802	OFFICIAL	2026-01-29 23:28:26.173452	0	\N
2405	전북특별자치도 남원시 신촌동 216-1	2026-01-29 23:28:26.173835	35.40851143	127.3994753	OFFICIAL	2026-01-29 23:28:26.173838	0	\N
2406	전북특별자치도 남원시 노암동 225-18	2026-01-29 23:28:26.174197	35.39371821	127.3778183	OFFICIAL	2026-01-29 23:28:26.174201	0	\N
2407	전북특별자치도 남원시 동충동 396-1	2026-01-29 23:28:26.174564	35.41172025	127.378025	OFFICIAL	2026-01-29 23:28:26.174567	0	\N
2408	대전광역시 유성구 관평동 1286	2026-01-29 23:28:26.17502	36.424048	127.388777	OFFICIAL	2026-01-29 23:28:26.175024	0	\N
2409	대전광역시 유성구 관평동 1293	2026-01-29 23:28:26.175406	36.426653	127.385358	OFFICIAL	2026-01-29 23:28:26.17541	0	\N
2410	대전광역시 유성구 테크노2로 319 (탑립동) 대전광역시 유성구 탑립동 930	2026-01-29 23:28:26.175813	36.413548	127.411603	OFFICIAL	2026-01-29 23:28:26.175816	0	\N
2411	대전광역시 유성구 탑립동 946	2026-01-29 23:28:26.176187	36.416345	127.406623	OFFICIAL	2026-01-29 23:28:26.176191	0	\N
2412	대전광역시 유성구 테크노2로 153 (용산동) 대전광역시 유성구 용산동 521	2026-01-29 23:28:26.176556	36.425833	127.402124	OFFICIAL	2026-01-29 23:28:26.176559	0	\N
2413	대전광역시 유성구 테크노2로 106 (관평동) 대전광역시 유성구 관평동 691	2026-01-29 23:28:26.176957	36.428446	127.398053	OFFICIAL	2026-01-29 23:28:26.176961	0	\N
2414	대전광역시 유성구 관평동 1287 대전광역시 유성구 관평동 1287	2026-01-29 23:28:26.177324	36.430313	127.395657	OFFICIAL	2026-01-29 23:28:26.177327	0	\N
2415	대전광역시 유성구 관평동 1286	2026-01-29 23:28:26.177734	36.424076	127.388517	OFFICIAL	2026-01-29 23:28:26.177738	0	\N
2416	대전광역시 유성구 관평2로 43 대전광역시 유성구 관평동 1281	2026-01-29 23:28:26.178129	36.421456	127.388674	OFFICIAL	2026-01-29 23:28:26.178133	0	\N
2417	대전광역시 유성구 관평동 673	2026-01-29 23:28:26.178487	36.421214	127.388539	OFFICIAL	2026-01-29 23:28:26.178491	0	\N
2418	대전광역시 유성구 용산2로 33 (용산동) 대전광역시 유성구 관평동 683	2026-01-29 23:28:26.178904	36.418774	127.387836	OFFICIAL	2026-01-29 23:28:26.178908	0	\N
2419	대전광역시 유성구 관평동 673	2026-01-29 23:28:26.179352	36.420325	127.392259	OFFICIAL	2026-01-29 23:28:26.179357	0	\N
2420	대전광역시 유성구 관평동 1286	2026-01-29 23:28:26.179808	36.428107	127.391129	OFFICIAL	2026-01-29 23:28:26.179812	0	\N
2421	대전광역시 유성구 전민동 905	2026-01-29 23:28:26.180247	36.399553	127.399516	OFFICIAL	2026-01-29 23:28:26.180251	0	\N
2422	대전광역시 유성구 전민동 394-16	2026-01-29 23:28:26.180631	36.399534	127.403753	OFFICIAL	2026-01-29 23:28:26.180635	0	\N
2423	대전광역시 유성구 원촌동 51	2026-01-29 23:28:26.181053	36.376771	127.402904	OFFICIAL	2026-01-29 23:28:26.181057	0	\N
2424	대전광역시 유성구 원촌동 135-2	2026-01-29 23:28:26.181437	36.384832	127.405441	OFFICIAL	2026-01-29 23:28:26.18144	0	\N
2425	대전광역시 유성구 원촌동 48-1	2026-01-29 23:28:26.181832	36.377292	127.404749	OFFICIAL	2026-01-29 23:28:26.181835	0	\N
2426	대전광역시 유성구 전민동 394-16	2026-01-29 23:28:26.182194	36.399769	127.403827	OFFICIAL	2026-01-29 23:28:26.182198	0	\N
2427	대전광역시 유성구 전민동 523-4	2026-01-29 23:28:26.182564	36.399754	127.400561	OFFICIAL	2026-01-29 23:28:26.182578	0	\N
2428	대전광역시 유성구 전민동 464-3	2026-01-29 23:28:26.182951	36.400584	127.405049	OFFICIAL	2026-01-29 23:28:26.182955	0	\N
2429	대전광역시 유성구 전민동 464-7	2026-01-29 23:28:26.183323	36.396638	127.405031	OFFICIAL	2026-01-29 23:28:26.183327	0	\N
2430	대전광역시 유성구 전민동 396-6	2026-01-29 23:28:26.183694	36.398072	127.404832	OFFICIAL	2026-01-29 23:28:26.183698	0	\N
2431	대전광역시 유성구 문지동 103-3	2026-01-29 23:28:26.184096	36.396067	127.404767	OFFICIAL	2026-01-29 23:28:26.1841	0	\N
2432	대전광역시 유성구 원촌동 90	2026-01-29 23:28:26.184466	36.381851	127.406515	OFFICIAL	2026-01-29 23:28:26.18447	0	\N
2433	대전광역시 유성구 원촌동 90	2026-01-29 23:28:26.184861	36.381202	127.406279	OFFICIAL	2026-01-29 23:28:26.184865	0	\N
2434	대전광역시 유성구 전민동 462-11	2026-01-29 23:28:26.185245	36.403781	127.404784	OFFICIAL	2026-01-29 23:28:26.185249	0	\N
2435	대전광역시 유성구 화암동 25-13	2026-01-29 23:28:26.185608	36.410545	127.377634	OFFICIAL	2026-01-29 23:28:26.185612	0	\N
2436	대전광역시 유성구 방현동 349	2026-01-29 23:28:26.185971	36.407123	127.373723	OFFICIAL	2026-01-29 23:28:26.185975	0	\N
2437	대전광역시 유성구 하기동 18-52	2026-01-29 23:28:26.186347	36.389247	127.347006	OFFICIAL	2026-01-29 23:28:26.186351	0	\N
2438	전북특별자치도 남원시 산내면 중황리 758	2026-01-29 23:28:26.18671	35.42264154	127.6424419	OFFICIAL	2026-01-29 23:28:26.186714	0	\N
2439	대전광역시 유성구 신성동 산 19-3	2026-01-29 23:28:26.187109	36.384703	127.349005	OFFICIAL	2026-01-29 23:28:26.187113	0	\N
2440	대전광역시 유성구 대덕대로 480 (도룡동) 대전광역시 유성구 도룡동 3-1	2026-01-29 23:28:26.187572	36.377388	127.379189	OFFICIAL	2026-01-29 23:28:26.187576	0	\N
2441	대전광역시 유성구 가정동 9-1	2026-01-29 23:28:26.187949	36.377443	127.378832	OFFICIAL	2026-01-29 23:28:26.187952	0	\N
2442	대전광역시 유성구 구성동 464	2026-01-29 23:28:26.18831	36.365131	127.362894	OFFICIAL	2026-01-29 23:28:26.188314	0	\N
2443	대전광역시 유성구 화암동 120-3	2026-01-29 23:28:26.188708	36.412353	127.378033	OFFICIAL	2026-01-29 23:28:26.188711	0	\N
2444	대전광역시 유성구 화암동 25-13	2026-01-29 23:28:26.189102	36.412861	127.378402	OFFICIAL	2026-01-29 23:28:26.189106	0	\N
2445	대전광역시 유성구 대덕대로 523 (가정동) 대전광역시 유성구 가정동 2	2026-01-29 23:28:26.189467	36.382278	127.378439	OFFICIAL	2026-01-29 23:28:26.189471	0	\N
2446	대전광역시 유성구 도룡동 436	2026-01-29 23:28:26.189831	36.381981	127.378745	OFFICIAL	2026-01-29 23:28:26.189834	0	\N
2447	대전광역시 유성구 도룡동 409	2026-01-29 23:28:26.190194	36.386499	127.378522	OFFICIAL	2026-01-29 23:28:26.190198	0	\N
2448	대전광역시 유성구 화암동 61-4	2026-01-29 23:28:26.190563	36.399736	127.374311	OFFICIAL	2026-01-29 23:28:26.190566	0	\N
2449	대전광역시 유성구 대덕대로 634 (도룡동) 대전광역시 유성구 도룡동 401	2026-01-29 23:28:26.190951	36.388541	127.379573	OFFICIAL	2026-01-29 23:28:26.190955	0	\N
2450	대전광역시 유성구 도룡동 409	2026-01-29 23:28:26.191322	36.386675	127.378811	OFFICIAL	2026-01-29 23:28:26.191326	0	\N
2451	대전광역시 유성구 도룡동 582	2026-01-29 23:28:26.191686	36.374098	127.388722	OFFICIAL	2026-01-29 23:28:26.19169	0	\N
2452	대전광역시 유성구 대덕대로 480 (도룡동) 대전광역시 유성구 도룡동 3-1	2026-01-29 23:28:26.192071	36.374334	127.387221	OFFICIAL	2026-01-29 23:28:26.192075	0	\N
2453	대전광역시 유성구 신성동 458	2026-01-29 23:28:26.192434	36.384451	127.354471	OFFICIAL	2026-01-29 23:28:26.192437	0	\N
2454	대전광역시 유성구 장동 산 19-3	2026-01-29 23:28:26.192824	36.390008	127.362306	OFFICIAL	2026-01-29 23:28:26.192828	0	\N
2455	대전광역시 유성구 가정동 산 1-2	2026-01-29 23:28:26.193195	36.384194	127.367184	OFFICIAL	2026-01-29 23:28:26.193198	0	\N
2456	대전광역시 유성구 신성동 420-8	2026-01-29 23:28:26.193555	36.384142	127.347149	OFFICIAL	2026-01-29 23:28:26.193559	0	\N
2457	대전광역시 유성구 신성동 108-2	2026-01-29 23:28:26.193944	36.385441	127.352951	OFFICIAL	2026-01-29 23:28:26.193948	0	\N
2458	대전광역시 유성구 도룡동 404	2026-01-29 23:28:26.194312	36.385864	127.377352	OFFICIAL	2026-01-29 23:28:26.194315	0	\N
2459	대전광역시 유성구 북유성대로 300 (반석동) 대전광역시 유성구 반석동 61	2026-01-29 23:28:26.194672	36.391386	127.315419	OFFICIAL	2026-01-29 23:28:26.194676	0	\N
2460	대전광역시 유성구 지족동 1005	2026-01-29 23:28:26.195008	36.386484	127.318452	OFFICIAL	2026-01-29 23:28:26.195011	0	\N
2461	대전광역시 유성구 지족동 946	2026-01-29 23:28:26.195372	36.382329	127.319466	OFFICIAL	2026-01-29 23:28:26.195376	0	\N
2462	대전광역시 유성구 북유성대로 지하303 (반석동) 대전광역시 유성구 반석동 685	2026-01-29 23:28:26.195736	36.391441	127.315481	OFFICIAL	2026-01-29 23:28:26.19574	0	\N
2463	대전광역시 유성구 한밭대로 지하155 (노은동) 대전광역시 유성구 노은동 612	2026-01-29 23:28:26.196129	36.367091	127.321462	OFFICIAL	2026-01-29 23:28:26.196132	0	\N
2464	대전광역시 유성구 한밭대로 지하155 (노은동) 대전광역시 유성구 노은동 612	2026-01-29 23:28:26.196489	36.366467	127.321791	OFFICIAL	2026-01-29 23:28:26.196492	0	\N
2465	대전광역시 유성구 장대로 43 (장대동) 대전광역시 유성구 장대동 280-18	2026-01-29 23:28:26.196874	36.358777	127.336215	OFFICIAL	2026-01-29 23:28:26.196878	0	\N
2466	전북특별자치도 남원시 산내면 덕동리 21-4	2026-01-29 23:28:26.19739	35.36897226	127.5702746	OFFICIAL	2026-01-29 23:28:26.197394	0	\N
2467	대전광역시 유성구 죽동 119-4	2026-01-29 23:28:26.197806	36.366422	127.338706	OFFICIAL	2026-01-29 23:28:26.19781	0	\N
2468	대전광역시 유성구 장대동 309-1	2026-01-29 23:28:26.198181	36.365406	127.335747	OFFICIAL	2026-01-29 23:28:26.198185	0	\N
2469	대전광역시 유성구 장대동 321	2026-01-29 23:28:26.198554	36.365147	127.335141	OFFICIAL	2026-01-29 23:28:26.198558	0	\N
2470	대전광역시 유성구 대학로 99 (궁동) 대전광역시 유성구 궁동 220	2026-01-29 23:28:26.198945	36.370175	127.340484	OFFICIAL	2026-01-29 23:28:26.198949	0	\N
2471	대전광역시 유성구 대학로 99 (궁동) 대전광역시 유성구 궁동 220	2026-01-29 23:28:26.199326	36.369342	127.340159	OFFICIAL	2026-01-29 23:28:26.19933	0	\N
2472	대전광역시 유성구 궁동 29-4	2026-01-29 23:28:26.199687	36.360836	127.349455	OFFICIAL	2026-01-29 23:28:26.199691	0	\N
2473	대전광역시 유성구 어은동 311	2026-01-29 23:28:26.20013	36.361408	127.356052	OFFICIAL	2026-01-29 23:28:26.200134	0	\N
2474	대전광역시 유성구 대학로 99 (궁동) 대전광역시 유성구 궁동 351	2026-01-29 23:28:26.201168	36.362615	127.343686	OFFICIAL	2026-01-29 23:28:26.201172	0	\N
2475	대전광역시 유성구 궁동 450-1	2026-01-29 23:28:26.201567	36.362202	127.343492	OFFICIAL	2026-01-29 23:28:26.201572	0	\N
2476	대전광역시 유성구 어은동 59-23	2026-01-29 23:28:26.201977	36.361586	127.357143	OFFICIAL	2026-01-29 23:28:26.201981	0	\N
2477	대전광역시 유성구 어은동 311	2026-01-29 23:28:26.202372	36.362647	127.358587	OFFICIAL	2026-01-29 23:28:26.202375	0	\N
2478	대전광역시 유성구 대학로 291 (구성동) 대전광역시 유성구 구성동 23	2026-01-29 23:28:26.202734	36.370458	127.368716	OFFICIAL	2026-01-29 23:28:26.202738	0	\N
2479	대전광역시 유성구 구성동 286-3	2026-01-29 23:28:26.20312	36.365865	127.325091	OFFICIAL	2026-01-29 23:28:26.203124	0	\N
2480	대전광역시 유성구 계룡로 지하97 (봉명동) 대전광역시 유성구 봉명동 551-18	2026-01-29 23:28:26.203477	36.354617	127.342115	OFFICIAL	2026-01-29 23:28:26.203481	0	\N
2481	대전광역시 유성구 구암동 641	2026-01-29 23:28:26.203864	36.350826	127.335589	OFFICIAL	2026-01-29 23:28:26.203868	0	\N
2482	대전광역시 유성구 월드컵대로275번길 48 (구암동) 대전광역시 유성구 구암동 618-1	2026-01-29 23:28:26.204227	36.351791	127.331734	OFFICIAL	2026-01-29 23:28:26.204231	0	\N
2483	대전광역시 유성구 유성대로654번길 66 (구암동) 대전광역시 유성구 구암동 617-3	2026-01-29 23:28:26.20462	36.351321	127.332634	OFFICIAL	2026-01-29 23:28:26.204624	0	\N
2484	대전광역시 유성구 덕명동 150-6	2026-01-29 23:28:26.204987	36.351561	127.297815	OFFICIAL	2026-01-29 23:28:26.20499	0	\N
2485	대전광역시 유성구 구암동 424-3	2026-01-29 23:28:26.205429	36.359542	127.320103	OFFICIAL	2026-01-29 23:28:26.205433	0	\N
2486	대전광역시 유성구 현충원로 지하455 (구암동) 대전광역시 유성구 구암동 527-193	2026-01-29 23:28:26.205828	36.359269	127.321804	OFFICIAL	2026-01-29 23:28:26.205832	0	\N
2487	대전광역시 유성구 구암동 642	2026-01-29 23:28:26.20619	36.351321	127.332705	OFFICIAL	2026-01-29 23:28:26.206194	0	\N
2488	대전광역시 유성구 구암동 95-11	2026-01-29 23:28:26.206558	36.356021	127.330929	OFFICIAL	2026-01-29 23:28:26.206562	0	\N
2489	대전광역시 유성구 구암동 94-3	2026-01-29 23:28:26.206943	36.355791	127.331172	OFFICIAL	2026-01-29 23:28:26.206946	0	\N
2490	대전광역시 유성구 봉명동 4-1	2026-01-29 23:28:26.207297	36.359355	127.355045	OFFICIAL	2026-01-29 23:28:26.2073	0	\N
2491	대전광역시 유성구 덕명동 569	2026-01-29 23:28:26.20766	36.358351	127.303621	OFFICIAL	2026-01-29 23:28:26.207665	0	\N
2492	대전광역시 유성구 덕명동 569	2026-01-29 23:28:26.208008	36.358268	127.304035	OFFICIAL	2026-01-29 23:28:26.208012	0	\N
2493	대전광역시 유성구 봉명동 1026-4	2026-01-29 23:28:26.208353	36.352312	127.341205	OFFICIAL	2026-01-29 23:28:26.208357	0	\N
2494	전북특별자치도 남원시 산내면 중황리 513-2	2026-01-29 23:28:26.208695	35.42593424	127.6483493	OFFICIAL	2026-01-29 23:28:26.208698	0	\N
2495	대전광역시 유성구 봉명동 608	2026-01-29 23:28:26.209089	36.358256	127.343483	OFFICIAL	2026-01-29 23:28:26.209093	0	\N
2496	대전광역시 유성구 봉명동 1058	2026-01-29 23:28:26.209444	36.353257	127.341083	OFFICIAL	2026-01-29 23:28:26.209448	0	\N
2497	대전광역시 유성구 계룡로 지하97 (봉명동) 대전광역시 유성구 봉명동 552-11	2026-01-29 23:28:26.209861	36.354748	127.341562	OFFICIAL	2026-01-29 23:28:26.209865	0	\N
2498	대전광역시 유성구 계룡로 지하97 (봉명동) 대전광역시 유성구 봉명동 551-18	2026-01-29 23:28:26.210286	36.354743	127.342102	OFFICIAL	2026-01-29 23:28:26.21029	0	\N
2499	대전광역시 유성구 봉명동 1058	2026-01-29 23:28:26.210658	36.351961	127.346802	OFFICIAL	2026-01-29 23:28:26.210662	0	\N
2500	대전광역시 유성구 봉명동 1058	2026-01-29 23:28:26.211022	36.352695	127.345744	OFFICIAL	2026-01-29 23:28:26.211025	0	\N
2501	대전광역시 유성구 봉명동 468-21	2026-01-29 23:28:26.211422	36.354642	127.338031	OFFICIAL	2026-01-29 23:28:26.211425	0	\N
2502	대전광역시 유성구 봉명동 1062	2026-01-29 23:28:26.211827	36.348696	127.341772	OFFICIAL	2026-01-29 23:28:26.21183	0	\N
2503	대전광역시 유성구 상대동 498	2026-01-29 23:28:26.212188	36.341489	127.338104	OFFICIAL	2026-01-29 23:28:26.212192	0	\N
2504	대전광역시 유성구 원신흥동 609	2026-01-29 23:28:26.212579	36.332453	127.339349	OFFICIAL	2026-01-29 23:28:26.212583	0	\N
2505	대전광역시 유성구 원신흥동 534-1	2026-01-29 23:28:26.212973	36.338155	127.341123	OFFICIAL	2026-01-29 23:28:26.212978	0	\N
2506	대전광역시 유성구 원신흥동 588	2026-01-29 23:28:26.213349	36.338384	127.338961	OFFICIAL	2026-01-29 23:28:26.213353	0	\N
2507	대전광역시 유성구 원신흥동 602-1	2026-01-29 23:28:26.213706	36.333902	127.338023	OFFICIAL	2026-01-29 23:28:26.21371	0	\N
2508	대전광역시 유성구 원신흥동 602-1	2026-01-29 23:28:26.214088	36.334351	127.338281	OFFICIAL	2026-01-29 23:28:26.214092	0	\N
2509	대전광역시 유성구 원신흥동 528-1	2026-01-29 23:28:26.214461	36.332393	127.313102	OFFICIAL	2026-01-29 23:28:26.214465	0	\N
2510	대전광역시 유성구 봉명동 1062	2026-01-29 23:28:26.214826	36.348297	127.342096	OFFICIAL	2026-01-29 23:28:26.214829	0	\N
2511	대전광역시 유성구 상대동 498	2026-01-29 23:28:26.215189	36.347221	127.340085	OFFICIAL	2026-01-29 23:28:26.215193	0	\N
2512	대전광역시 유성구 진잠로42번길 35 (원내동) 대전광역시 유성구 원내동 351	2026-01-29 23:28:26.215546	36.295726	127.321283	OFFICIAL	2026-01-29 23:28:26.21555	0	\N
2513	대전광역시 유성구 원내동 711	2026-01-29 23:28:26.215949	36.295851	127.319563	OFFICIAL	2026-01-29 23:28:26.215953	0	\N
2514	대전광역시 유성구 원내동 416-6	2026-01-29 23:28:26.216297	36.293648	127.319419	OFFICIAL	2026-01-29 23:28:26.216301	0	\N
2515	대전광역시 유성구 교촌동 651	2026-01-29 23:28:26.216647	36.303999	127.319446	OFFICIAL	2026-01-29 23:28:26.216651	0	\N
2516	대전광역시 유성구 원내동 711	2026-01-29 23:28:26.217003	36.299769	127.322048	OFFICIAL	2026-01-29 23:28:26.217006	0	\N
2517	대전광역시 유성구 교촌동 652	2026-01-29 23:28:26.217349	36.306831	127.319335	OFFICIAL	2026-01-29 23:28:26.217352	0	\N
2518	대전광역시 유성구 대정동 318	2026-01-29 23:28:26.217813	36.315573	127.319812	OFFICIAL	2026-01-29 23:28:26.217817	0	\N
2519	대전광역시 유성구 대정동 318	2026-01-29 23:28:26.218183	36.315474	127.320086	OFFICIAL	2026-01-29 23:28:26.218187	0	\N
2520	대전광역시 유성구 대정동 246-2	2026-01-29 23:28:26.218564	36.311666	127.318471	OFFICIAL	2026-01-29 23:28:26.218568	0	\N
2521	대전광역시 유성구 대정동 274	2026-01-29 23:28:26.218951	36.311975	127.318404	OFFICIAL	2026-01-29 23:28:26.218955	0	\N
2522	대구광역시 북구 옥산로 112 대구광역시 북구 고성동3가 7-2	2026-01-29 23:28:26.219317	35.88331609	128.587807	OFFICIAL	2026-01-29 23:28:26.219321	0	\N
2523	경상남도 합천군 초계면 관평리 661-22	2026-01-29 23:28:26.219678	35.5432002	128.2589864	OFFICIAL	2026-01-29 23:28:26.219682	0	\N
2524	경상남도 합천군 초계면 신촌리 172-2	2026-01-29 23:28:26.220063	35.5227028	128.2504306	OFFICIAL	2026-01-29 23:28:26.220067	0	\N
2525	경상남도 합천군 초계면 상대리 280	2026-01-29 23:28:26.220474	35.5300361	128.2436278	OFFICIAL	2026-01-29 23:28:26.220478	0	\N
2526	경상남도 합천군 초계면 중리 417	2026-01-29 23:28:26.220851	35.5564699	128.2540764	OFFICIAL	2026-01-29 23:28:26.220855	0	\N
2527	경상남도 합천군 초계면 유하리 270-1	2026-01-29 23:28:26.221216	35.5410166	128.2471571	OFFICIAL	2026-01-29 23:28:26.22122	0	\N
2528	경상남도 합천군 초계면 초계리 500	2026-01-29 23:28:26.221571	35.5565074	128.2618088	OFFICIAL	2026-01-29 23:28:26.221575	0	\N
2529	경상남도 합천군 율곡면 갑산리 564-15	2026-01-29 23:28:26.221946	35.5900712	128.2591814	OFFICIAL	2026-01-29 23:28:26.22195	0	\N
2530	경상남도 합천군 율곡면 낙민리 1358	2026-01-29 23:28:26.222307	35.5852319	128.2225868	OFFICIAL	2026-01-29 23:28:26.222311	0	\N
2531	경상남도 합천군 율곡면 본천리 1053-1	2026-01-29 23:28:26.22266	35.5399102	128.1969753	OFFICIAL	2026-01-29 23:28:26.222664	0	\N
2532	경상남도 합천군 율곡면 노양리 789	2026-01-29 23:28:26.223007	35.6378249	128.1865161	OFFICIAL	2026-01-29 23:28:26.223011	0	\N
2533	경상남도 합천군 율곡면 와리 176-2	2026-01-29 23:28:26.223473	35.6215095	128.1982571	OFFICIAL	2026-01-29 23:28:26.223477	0	\N
2534	경상남도 합천군 율곡면 본천리 424	2026-01-29 23:28:26.223878	35.5567639	128.1926374	OFFICIAL	2026-01-29 23:28:26.223882	0	\N
2535	경상남도 합천군 율곡면 율진리 1168	2026-01-29 23:28:26.224253	35.6076124	128.1856511	OFFICIAL	2026-01-29 23:28:26.224256	0	\N
2536	경상남도 합천군 율곡면 기리 316-1	2026-01-29 23:28:26.224619	35.6219446	128.2274796	OFFICIAL	2026-01-29 23:28:26.224622	0	\N
2537	경상남도 합천군 율곡면 노양리 548-2	2026-01-29 23:28:26.224984	35.6219777	128.1929814	OFFICIAL	2026-01-29 23:28:26.224988	0	\N
2538	경상남도 합천군 율곡면 본천리 306	2026-01-29 23:28:26.225349	35.5577549	128.1985633	OFFICIAL	2026-01-29 23:28:26.225353	0	\N
2539	경상남도 합천군 율곡면 영전리 74-4	2026-01-29 23:28:26.225708	35.5682415	128.2070949	OFFICIAL	2026-01-29 23:28:26.225712	0	\N
2540	경상남도 합천군 율곡면 갑산2길 14-6	2026-01-29 23:28:26.226083	35.5897028	128.2457175	OFFICIAL	2026-01-29 23:28:26.226087	0	\N
2541	경상남도 합천군 율곡면 내천리 434	2026-01-29 23:28:26.226437	35.6133436	128.2377981	OFFICIAL	2026-01-29 23:28:26.22644	0	\N
2542	경상남도 합천군 율곡면 항곡리 243-2	2026-01-29 23:28:26.226807	35.5973827	128.2124011	OFFICIAL	2026-01-29 23:28:26.226811	0	\N
2543	경상남도 합천군 율곡면 갑산리 697	2026-01-29 23:28:26.227186	35.5944949	128.2559181	OFFICIAL	2026-01-29 23:28:26.22719	0	\N
2544	경상남도 합천군 율곡면 항곡리 557-3	2026-01-29 23:28:26.227553	35.6079027	128.2118769	OFFICIAL	2026-01-29 23:28:26.227557	0	\N
2545	경상남도 합천군 율곡면 율진리 521	2026-01-29 23:28:26.227943	35.5927753	128.1860252	OFFICIAL	2026-01-29 23:28:26.227947	0	\N
2546	경상남도 합천군 율곡면 제내리 24-5	2026-01-29 23:28:26.228306	35.5888012	128.2177413	OFFICIAL	2026-01-29 23:28:26.22831	0	\N
2547	경상남도 합천군 야로면 매촌리 635-1	2026-01-29 23:28:26.228664	35.7148879	128.1640272	OFFICIAL	2026-01-29 23:28:26.228668	0	\N
2548	경상남도 합천군 야로면 월광리 33-3	2026-01-29 23:28:26.229086	35.7277153	128.1563931	OFFICIAL	2026-01-29 23:28:26.229091	0	\N
2549	경상남도 합천군 야로면 묵촌리 2-3	2026-01-29 23:28:26.229492	35.7050381	128.1557962	OFFICIAL	2026-01-29 23:28:26.229496	0	\N
2550	경상남도 합천군 야로면 정대리 986	2026-01-29 23:28:26.229951	35.6942784	128.1672777	OFFICIAL	2026-01-29 23:28:26.229955	0	\N
2551	경상남도 합천군 야로면 금평리 557-2	2026-01-29 23:28:26.23035	35.7029705	128.1777497	OFFICIAL	2026-01-29 23:28:26.230354	0	\N
2552	경상남도 합천군 야로면 묵촌리 산80-11	2026-01-29 23:28:26.230833	35.6920406	128.1485558	OFFICIAL	2026-01-29 23:28:26.230841	0	\N
2553	경상남도 합천군 가야면 치인리 산25-1	2026-01-29 23:28:26.231271	35.7835206	128.0458515	OFFICIAL	2026-01-29 23:28:26.231276	0	\N
2554	경상남도 합천군 가야면 이천리 554	2026-01-29 23:28:26.231675	35.7243123	128.1302226	OFFICIAL	2026-01-29 23:28:26.231679	0	\N
2555	경상남도 합천군 가야면 치인리 797	2026-01-29 23:28:26.232054	35.7878906	128.0497701	OFFICIAL	2026-01-29 23:28:26.232058	0	\N
2556	서울특별시 노원구 화랑로 510	2026-01-29 23:28:26.232513	37.61989439	127.0837446	OFFICIAL	2026-01-29 23:28:26.232517	0	\N
2557	서울특별시 노원구 공릉로46길 18	2026-01-29 23:28:26.232927	37.627173	127.0799936	OFFICIAL	2026-01-29 23:28:26.232931	0	\N
2558	서울특별시 노원구 노원로16길 15	2026-01-29 23:28:26.233307	37.64344507	127.0733372	OFFICIAL	2026-01-29 23:28:26.233311	0	\N
2559	서울특별시 노원구 공릉로 232	2026-01-29 23:28:26.233801	37.63307893	127.0767947	OFFICIAL	2026-01-29 23:28:26.233805	0	\N
2560	서울특별시 노원구 중계로 169	2026-01-29 23:28:26.234298	37.65026232	127.0807682	OFFICIAL	2026-01-29 23:28:26.234303	0	\N
2561	서울특별시 노원구 동일로 1690-2	2026-01-29 23:28:26.234816	37.67928212	127.0555505	OFFICIAL	2026-01-29 23:28:26.234821	0	\N
2562	서울특별시 노원구 동일로 1690-2	2026-01-29 23:28:26.235212	37.67928212	127.0555505	OFFICIAL	2026-01-29 23:28:26.235216	0	\N
2563	서울특별시 노원구 마들로 86	2026-01-29 23:28:26.235713	37.62358892	127.0687828	OFFICIAL	2026-01-29 23:28:26.235719	0	\N
2564	서울특별시 노원구 마들로 86	2026-01-29 23:28:26.236166	37.62358892	127.0687828	OFFICIAL	2026-01-29 23:28:26.23617	0	\N
2565	서울특별시 노원구 상계로 118	2026-01-29 23:28:26.236565	37.65748313	127.0678641	OFFICIAL	2026-01-29 23:28:26.236569	0	\N
2566	서울특별시 노원구 상계로 182	2026-01-29 23:28:26.236954	37.66090389	127.0735754	OFFICIAL	2026-01-29 23:28:26.236958	0	\N
2567	서울특별시 노원구 한글비석로 434	2026-01-29 23:28:26.237695	37.66298077	127.0693673	OFFICIAL	2026-01-29 23:28:26.237699	0	\N
2568	서울특별시 노원구 한글비석로41가길 24	2026-01-29 23:28:26.238105	37.66219777	127.0686777	OFFICIAL	2026-01-29 23:28:26.238108	0	\N
2569	서울특별시 노원구 초안산로 12	2026-01-29 23:28:26.238554	37.63034387	127.0544999	OFFICIAL	2026-01-29 23:28:26.238558	0	\N
2570	서울특별시 노원구 월계로 334	2026-01-29 23:28:26.238971	37.62901731	127.0576125	OFFICIAL	2026-01-29 23:28:26.238975	0	\N
2571	서울특별시 노원구 동일로242길 11	2026-01-29 23:28:26.239343	37.67584698	127.0562724	OFFICIAL	2026-01-29 23:28:26.239347	0	\N
2572	서울특별시 노원구 노원로 510	2026-01-29 23:28:26.239717	37.66093573	127.0625889	OFFICIAL	2026-01-29 23:28:26.239721	0	\N
2573	서울특별시 노원구 동일로221길 22	2026-01-29 23:28:26.240107	37.6599719	127.0573759	OFFICIAL	2026-01-29 23:28:26.240111	0	\N
2574	서울특별시 노원구 동일로 1461	2026-01-29 23:28:26.240469	37.65913138	127.0582807	OFFICIAL	2026-01-29 23:28:26.240473	0	\N
2575	서울특별시 노원구 노원로16길 15	2026-01-29 23:28:26.240894	37.64344507	127.0733372	OFFICIAL	2026-01-29 23:28:26.240903	0	\N
2576	서울특별시 노원구 화랑로 653	2026-01-29 23:28:26.241353	37.62961285	127.0950867	OFFICIAL	2026-01-29 23:28:26.241359	0	\N
2577	서울특별시 노원구 노원로 58	2026-01-29 23:28:26.241727	37.62692051	127.0883803	OFFICIAL	2026-01-29 23:28:26.241731	0	\N
2578	서울특별시 노원구 노원로 75	2026-01-29 23:28:26.242283	37.62881715	127.082693	OFFICIAL	2026-01-29 23:28:26.242288	0	\N
2579	서울특별시 노원구 한글비석로 276	2026-01-29 23:28:26.242684	37.65189706	127.0777654	OFFICIAL	2026-01-29 23:28:26.242688	0	\N
2580	서울특별시 노원구 한글비석로 250	2026-01-29 23:28:26.243136	37.65002891	127.077012	OFFICIAL	2026-01-29 23:28:26.243141	0	\N
2581	서울특별시 노원구 한글비석로 383	2026-01-29 23:28:26.243519	37.65911197	127.073075	OFFICIAL	2026-01-29 23:28:26.243523	0	\N
2582	서울특별시 노원구 한글비석로 384	2026-01-29 23:28:26.24392	37.6598085	127.07324	OFFICIAL	2026-01-29 23:28:26.243924	0	\N
2583	서울특별시 노원구 한글비석로 245	2026-01-29 23:28:26.244291	37.6492608	127.0763611	OFFICIAL	2026-01-29 23:28:26.244295	0	\N
2584	서울특별시 노원구 한글비석로 269	2026-01-29 23:28:26.244661	37.65171822	127.0767882	OFFICIAL	2026-01-29 23:28:26.244665	0	\N
2585	서울특별시 노원구 월계로 55길 16	2026-01-29 23:28:26.245051	37.63266533	127.0608256	OFFICIAL	2026-01-29 23:28:26.245055	0	\N
2586	서울특별시 노원구 석계로15길 25	2026-01-29 23:28:26.245418	37.62206287	127.0613425	OFFICIAL	2026-01-29 23:28:26.245421	0	\N
2587	서울특별시 노원구 석계로 98-2	2026-01-29 23:28:26.245806	37.62303356	127.0617635	OFFICIAL	2026-01-29 23:28:26.24581	0	\N
2588	서울특별시 노원구 광운로 20	2026-01-29 23:28:26.246171	37.61932035	127.0583381	OFFICIAL	2026-01-29 23:28:26.246175	0	\N
2589	서울특별시 노원구 노원로 564	2026-01-29 23:28:26.246562	37.66165211	127.0561247	OFFICIAL	2026-01-29 23:28:26.246566	0	\N
2590	서울특별시 노원구 덕릉로 460	2026-01-29 23:28:26.24697	37.64438255	127.059922	OFFICIAL	2026-01-29 23:28:26.246974	0	\N
2591	서울특별시 노원구 노해로 456	2026-01-29 23:28:26.247342	37.65358729	127.0587983	OFFICIAL	2026-01-29 23:28:26.247346	0	\N
2592	서울특별시 노원구 한글비석로 463	2026-01-29 23:28:26.247848	37.66421635	127.0664373	OFFICIAL	2026-01-29 23:28:26.247852	0	\N
2593	서울특별시 노원구 상계로 312-1	2026-01-29 23:28:26.248256	37.67041582	127.0800568	OFFICIAL	2026-01-29 23:28:26.248271	0	\N
2594	서울특별시 노원구 상계동 111-484	2026-01-29 23:28:26.248663	37.64100553	127.0721484	OFFICIAL	2026-01-29 23:28:26.248666	0	\N
2595	서울특별시 노원구 동일로 1668	2026-01-29 23:28:26.249027	37.67713768	127.0555972	OFFICIAL	2026-01-29 23:28:26.249031	0	\N
2596	서울특별시 노원구 동일로 1669	2026-01-29 23:28:26.249503	37.67745849	127.054894	OFFICIAL	2026-01-29 23:28:26.249508	0	\N
2597	서울특별시 노원구 동일로 1426-3	2026-01-29 23:28:26.24997	37.65595916	127.0603291	OFFICIAL	2026-01-29 23:28:26.249975	0	\N
2598	서울특별시 노원구 동일로 1449	2026-01-29 23:28:26.250373	37.65748572	127.0588513	OFFICIAL	2026-01-29 23:28:26.250377	0	\N
2599	서울특별시 노원구 화랑로 457	2026-01-29 23:28:26.250774	37.61875199	127.0778767	OFFICIAL	2026-01-29 23:28:26.250778	0	\N
2600	서울특별시 노원구 동일로 1038	2026-01-29 23:28:26.251192	37.62279121	127.07424	OFFICIAL	2026-01-29 23:28:26.251196	0	\N
2601	서울특별시 노원구 동일로 1082	2026-01-29 23:28:26.251583	37.64100553	127.0721484	OFFICIAL	2026-01-29 23:28:26.251587	0	\N
2602	서울특별시 노원구 동일로 1101	2026-01-29 23:28:26.251954	37.62825426	127.0710099	OFFICIAL	2026-01-29 23:28:26.251958	0	\N
2603	서울특별시 노원구 동일로 1104	2026-01-29 23:28:26.252327	37.62849889	127.0718707	OFFICIAL	2026-01-29 23:28:26.25233	0	\N
2604	서울특별시 노원구 한글비석로 57	2026-01-29 23:28:26.252697	37.63662358	127.0689153	OFFICIAL	2026-01-29 23:28:26.2527	0	\N
2605	서울특별시 노원구 섬밭로 210-2	2026-01-29 23:28:26.253189	37.63488722	127.0662096	OFFICIAL	2026-01-29 23:28:26.253193	0	\N
2606	서울특별시 노원구 공릉로59길 28	2026-01-29 23:28:26.253561	37.6342349	127.0696715	OFFICIAL	2026-01-29 23:28:26.253565	0	\N
2607	서울특별시 노원구 섬밭로 232	2026-01-29 23:28:26.253947	37.63661517	127.0656682	OFFICIAL	2026-01-29 23:28:26.253951	0	\N
2608	서울특별시 노원구 동일로 1231-2	2026-01-29 23:28:26.254315	37.63914793	127.0666156	OFFICIAL	2026-01-29 23:28:26.254319	0	\N
2609	서울특별시 노원구 동일로 1231-2	2026-01-29 23:28:26.25469	37.63914793	127.0666156	OFFICIAL	2026-01-29 23:28:26.254693	0	\N
2610	서울특별시 노원구 동일로 1231-2	2026-01-29 23:28:26.25507	37.63914793	127.0666156	OFFICIAL	2026-01-29 23:28:26.255074	0	\N
2611	서울특별시 노원구 동일로 1231-2	2026-01-29 23:28:26.255431	37.63914793	127.0666156	OFFICIAL	2026-01-29 23:28:26.255434	0	\N
2612	서울특별시 노원구 덕릉로 483	2026-01-29 23:28:26.255814	37.64560941	127.0627148	OFFICIAL	2026-01-29 23:28:26.255818	0	\N
2613	서울특별시 노원구 월계로 378	2026-01-29 23:28:26.256175	37.63145003	127.0615911	OFFICIAL	2026-01-29 23:28:26.256179	0	\N
2614	서울특별시 노원구 초안산로1길 15	2026-01-29 23:28:26.256533	37.62729655	127.053318	OFFICIAL	2026-01-29 23:28:26.256537	0	\N
2615	서울특별시 노원구 초안산로1길 15	2026-01-29 23:28:26.256929	37.62729655	127.053318	OFFICIAL	2026-01-29 23:28:26.256933	0	\N
2616	서울특별시 노원구 노원로 564	2026-01-29 23:28:26.257293	37.66165211	127.0561247	OFFICIAL	2026-01-29 23:28:26.257297	0	\N
2617	서울특별시 노원구 동일로227길 26	2026-01-29 23:28:26.257657	37.67019074	127.0546889	OFFICIAL	2026-01-29 23:28:26.257661	0	\N
2618	서울특별시 노원구 동일로 1368	2026-01-29 23:28:26.258014	37.65074309	127.0619264	OFFICIAL	2026-01-29 23:28:26.258018	0	\N
2619	서울특별시 노원구 동일로 1355	2026-01-29 23:28:26.25838	37.64970076	127.0613593	OFFICIAL	2026-01-29 23:28:26.258384	0	\N
2620	서울특별시 노원구 동일로 1328-1	2026-01-29 23:28:26.25874	37.64741034	127.0636403	OFFICIAL	2026-01-29 23:28:26.258744	0	\N
2621	서울특별시 노원구 섬밭로 196	2026-01-29 23:28:26.259173	37.63399762	127.0672779	OFFICIAL	2026-01-29 23:28:26.259177	0	\N
2622	경상남도 합천군 대병면 하금리 704	2026-01-29 23:28:26.259569	35.5316067	127.9914876	OFFICIAL	2026-01-29 23:28:26.259573	0	\N
2623	경상남도 합천군 대병면 성리 127	2026-01-29 23:28:26.25995	35.5296404	128.0688629	OFFICIAL	2026-01-29 23:28:26.259954	0	\N
2624	경상남도 합천군 대병면 성리 1188-2	2026-01-29 23:28:26.260312	35.5232584	128.0511719	OFFICIAL	2026-01-29 23:28:26.260316	0	\N
2625	경상남도 합천군 가회면 덕촌리 1063	2026-01-29 23:28:26.26069	35.4309836	128.0164104	OFFICIAL	2026-01-29 23:28:26.260694	0	\N
2626	경상남도 합천군 가회면 외사리 45-2	2026-01-29 23:28:26.261102	35.4373834	128.0827283	OFFICIAL	2026-01-29 23:28:26.261106	0	\N
2627	경상남도 합천군 가회면 장대리 138	2026-01-29 23:28:26.26149	35.4600174	128.0684069	OFFICIAL	2026-01-29 23:28:26.261493	0	\N
2628	경상남도 합천군 가회면 중촌리 산131	2026-01-29 23:28:26.261939	35.4427931	128.0031728	OFFICIAL	2026-01-29 23:28:26.261966	0	\N
2629	경상남도 합천군 가회면 둔내리 159-3	2026-01-29 23:28:26.262655	35.4840656	128.0234744	OFFICIAL	2026-01-29 23:28:26.262661	0	\N
2630	경상남도 합천군 가회면 오도리 77-13	2026-01-29 23:28:26.263175	35.4467922	128.0270656	OFFICIAL	2026-01-29 23:28:26.263179	0	\N
2631	경상남도 합천군 가회면 함방리 339	2026-01-29 23:28:26.263549	35.4279514	128.0335679	OFFICIAL	2026-01-29 23:28:26.263553	0	\N
2632	경상남도 합천군 가회면 외사리 609-3	2026-01-29 23:28:26.263946	35.4259144	128.0737963	OFFICIAL	2026-01-29 23:28:26.26395	0	\N
2633	경상남도 합천군 가회면 월계리 504-4	2026-01-29 23:28:26.264309	35.4848477	128.0568122	OFFICIAL	2026-01-29 23:28:26.264313	0	\N
2634	경상남도 합천군 가회면 둔내리 761-3	2026-01-29 23:28:26.264661	35.4713937	128.0120221	OFFICIAL	2026-01-29 23:28:26.264664	0	\N
2635	경상남도 합천군 삼가면 문송리 496-6	2026-01-29 23:28:26.265074	35.4254745	128.0968232	OFFICIAL	2026-01-29 23:28:26.265078	0	\N
2636	경상남도 합천군 삼가면 덕진리 167	2026-01-29 23:28:26.265436	35.4108511	128.0886139	OFFICIAL	2026-01-29 23:28:26.265439	0	\N
2637	경상남도 합천군 삼가면 외토리 610-20	2026-01-29 23:28:26.265824	35.3864566	128.1031168	OFFICIAL	2026-01-29 23:28:26.265828	0	\N
2638	경상남도 합천군 삼가면 소오리 176-3	2026-01-29 23:28:26.266194	35.4067591	128.1194705	OFFICIAL	2026-01-29 23:28:26.266197	0	\N
2639	경상남도 합천군 삼가면 소오리 517-2	2026-01-29 23:28:26.266561	35.4099565	128.1128249	OFFICIAL	2026-01-29 23:28:26.266565	0	\N
2640	경상남도 합천군 삼가면 동리 269	2026-01-29 23:28:26.266946	35.4182886	128.1437571	OFFICIAL	2026-01-29 23:28:26.26695	0	\N
2641	경상남도 합천군 삼가면 동리 575-1	2026-01-29 23:28:26.267306	35.4164918	128.1535761	OFFICIAL	2026-01-29 23:28:26.26731	0	\N
2642	경상남도 합천군 삼가면 용흥리 889-1	2026-01-29 23:28:26.267689	35.3960838	128.1308377	OFFICIAL	2026-01-29 23:28:26.267693	0	\N
2643	경상남도 합천군 쌍백면 안계2길 2	2026-01-29 23:28:26.268054	35.4359947	128.1819191	OFFICIAL	2026-01-29 23:28:26.268058	0	\N
2644	경상남도 합천군 쌍백면 외초리 394	2026-01-29 23:28:26.268539	35.4193878	128.1653311	OFFICIAL	2026-01-29 23:28:26.268556	0	\N
2645	경상남도 합천군 쌍백면 삼리 251-1	2026-01-29 23:28:26.269002	35.4676312	128.0986697	OFFICIAL	2026-01-29 23:28:26.269006	0	\N
2646	경상남도 합천군 쌍백면 평구리 887-1	2026-01-29 23:28:26.269377	35.4411999	128.1379711	OFFICIAL	2026-01-29 23:28:26.26938	0	\N
2647	경상남도 합천군 쌍백면 평구리 312	2026-01-29 23:28:26.269737	35.4402935	128.1497441	OFFICIAL	2026-01-29 23:28:26.269741	0	\N
2648	경상남도 합천군 쌍백면 평구리 629-1	2026-01-29 23:28:26.270125	35.4356237	128.1427967	OFFICIAL	2026-01-29 23:28:26.270129	0	\N
2649	경상남도 합천군 쌍백면 대곡리 577-1	2026-01-29 23:28:26.270521	35.4687129	128.1893531	OFFICIAL	2026-01-29 23:28:26.270524	0	\N
2650	경상남도 합천군 쌍백면 외초리 123	2026-01-29 23:28:26.270934	35.4110224	128.1720415	OFFICIAL	2026-01-29 23:28:26.270938	0	\N
2651	경상남도 합천군 쌍백면 죽전리 736-3	2026-01-29 23:28:26.271284	35.4585131	128.1146334	OFFICIAL	2026-01-29 23:28:26.271288	0	\N
2652	경상남도 합천군 쌍백면 대현리 515-1	2026-01-29 23:28:26.271632	35.4459721	128.1941906	OFFICIAL	2026-01-29 23:28:26.271636	0	\N
2653	경상남도 합천군 쌍백면 육리 1291-1	2026-01-29 23:28:26.271996	35.4539401	128.1640247	OFFICIAL	2026-01-29 23:28:26.272	0	\N
2654	경상남도 합천군 쌍백면 하신리 972	2026-01-29 23:28:26.272377	35.4545748	128.1395142	OFFICIAL	2026-01-29 23:28:26.272381	0	\N
2655	대구광역시 북구 옥산로 70 대구광역시 북구 고성동3가 46	2026-01-29 23:28:26.272768	35.88443602	128.5826788	OFFICIAL	2026-01-29 23:28:26.272772	0	\N
2656	경상남도 합천군 가야면 야천리 717	2026-01-29 23:28:26.273126	35.7694726	128.1359809	OFFICIAL	2026-01-29 23:28:26.27313	0	\N
2657	경상남도 합천군 가야면 대전리 727-1	2026-01-29 23:28:26.27348	35.7408249	128.0785634	OFFICIAL	2026-01-29 23:28:26.273484	0	\N
2658	경상남도 합천군 가야면 매화리 716-5	2026-01-29 23:28:26.273851	35.7413236	128.1188295	OFFICIAL	2026-01-29 23:28:26.27388	0	\N
2659	경상남도 합천군 가야면 성기리 660-7	2026-01-29 23:28:26.274233	35.7213735	128.1027065	OFFICIAL	2026-01-29 23:28:26.274237	0	\N
2660	경상남도 합천군 가야면 사촌리 50-5	2026-01-29 23:28:26.274578	35.7542329	128.1341083	OFFICIAL	2026-01-29 23:28:26.274582	0	\N
2661	경상남도 합천군 가야면 구원리 242-5	2026-01-29 23:28:26.274969	35.7822292	128.1253061	OFFICIAL	2026-01-29 23:28:26.274973	0	\N
2662	경상남도 합천군 가야면 매안리 566-8	2026-01-29 23:28:26.27532	35.7308371	128.1034151	OFFICIAL	2026-01-29 23:28:26.275323	0	\N
2663	경상남도 합천군 가야면 매안리 432	2026-01-29 23:28:26.275673	35.7306414	128.1105892	OFFICIAL	2026-01-29 23:28:26.275677	0	\N
2664	경상남도 합천군 묘산면 도옥리 156-2	2026-01-29 23:28:26.276016	35.6627489	128.1222695	OFFICIAL	2026-01-29 23:28:26.276019	0	\N
2665	경상남도 합천군 묘산면 안성리 204-4	2026-01-29 23:28:26.276364	35.6741823	128.1352668	OFFICIAL	2026-01-29 23:28:26.276368	0	\N
2666	경상남도 합천군 봉산면 상현리 396	2026-01-29 23:28:26.276713	35.6408308	128.0342641	OFFICIAL	2026-01-29 23:28:26.276716	0	\N
2667	경상남도 합천군 봉산면 권빈리 958-8	2026-01-29 23:28:26.277088	35.6343195	128.0645361	OFFICIAL	2026-01-29 23:28:26.27709	0	\N
2668	경상남도 합천군 봉산면 권빈리 347-2	2026-01-29 23:28:26.277442	35.6195243	128.0712361	OFFICIAL	2026-01-29 23:28:26.277446	0	\N
2669	경상남도 합천군 봉산면 압곡리 721	2026-01-29 23:28:26.277813	35.6385721	128.0496663	OFFICIAL	2026-01-29 23:28:26.277816	0	\N
2670	경상남도 합천군 봉산면 권빈리 1515-2	2026-01-29 23:28:26.278159	35.6354552	128.0646475	OFFICIAL	2026-01-29 23:28:26.278162	0	\N
2671	경상남도 합천군 봉산면 양지리 511	2026-01-29 23:28:26.278507	35.5945863	128.0046024	OFFICIAL	2026-01-29 23:28:26.27851	0	\N
2672	경상남도 합천군 봉산면 봉계리 849	2026-01-29 23:28:26.278873	35.6106827	128.0230367	OFFICIAL	2026-01-29 23:28:26.278876	0	\N
2673	경상남도 합천군 봉산면 노곡리 908	2026-01-29 23:28:26.279214	35.5891959	127.9932802	OFFICIAL	2026-01-29 23:28:26.279218	0	\N
2674	경상남도 합천군 합천읍 인곡리 64-8	2026-01-29 23:28:26.279571	35.6071311	128.1070746	OFFICIAL	2026-01-29 23:28:26.279575	0	\N
2675	경상남도 합천군 용주면 성산리 산84	2026-01-29 23:28:26.279933	35.5514718	128.1413032	OFFICIAL	2026-01-29 23:28:26.279937	0	\N
2676	경상남도 합천군 용주면 고품리 179	2026-01-29 23:28:26.280281	35.5551054	128.1148921	OFFICIAL	2026-01-29 23:28:26.280285	0	\N
2677	경상남도 합천군 용주면 가호리 394	2026-01-29 23:28:26.280628	35.5503536	128.0698733	OFFICIAL	2026-01-29 23:28:26.280631	0	\N
2678	경상남도 합천군 용주면 황계폭포로 1061-12	2026-01-29 23:28:26.28098	35.5344976	128.1172005	OFFICIAL	2026-01-29 23:28:26.280984	0	\N
2679	경상남도 합천군 용주면 월평리 693-3	2026-01-29 23:28:26.281339	35.5659011	128.1179081	OFFICIAL	2026-01-29 23:28:26.281343	0	\N
2680	경상남도 합천군 용주면 공암리 171	2026-01-29 23:28:26.281686	35.5058099	128.1037211	OFFICIAL	2026-01-29 23:28:26.28169	0	\N
2681	경상남도 합천군 용주면 방곡리 826-1	2026-01-29 23:28:26.282044	35.5731171	128.1025169	OFFICIAL	2026-01-29 23:28:26.282047	0	\N
2682	경상남도 합천군 대병면 상천리 515-2	2026-01-29 23:28:26.28239	35.5440701	128.0272526	OFFICIAL	2026-01-29 23:28:26.282394	0	\N
2683	경상남도 합천군 대병면 회양리 337-1	2026-01-29 23:28:26.28279	35.5189139	128.0200666	OFFICIAL	2026-01-29 23:28:26.282794	0	\N
2684	경상남도 합천군 대병면 유전리 920-2	2026-01-29 23:28:26.28314	35.5396647	127.9874063	OFFICIAL	2026-01-29 23:28:26.283144	0	\N
2685	경상남도 합천군 대병면 성리 480	2026-01-29 23:28:26.283488	35.5448103	128.0514062	OFFICIAL	2026-01-29 23:28:26.283491	0	\N
2686	경상남도 합천군 대병면 장단리 1214	2026-01-29 23:28:26.283843	35.5092501	128.0531473	OFFICIAL	2026-01-29 23:28:26.283847	0	\N
2687	대구광역시 북구 고성로 191 대구광역시 북구 고성동3가 2	2026-01-29 23:28:26.284197	35.88301935	128.5861543	OFFICIAL	2026-01-29 23:28:26.284202	0	\N
2688	경상남도 합천군 청덕면 초곡길 151-1	2026-01-29 23:28:26.284596	35.5160212	128.3398438	OFFICIAL	2026-01-29 23:28:26.2846	0	\N
2689	경상남도 합천군 청덕면 운봉리 191-1	2026-01-29 23:28:26.284961	35.6111565	128.3080481	OFFICIAL	2026-01-29 23:28:26.284965	0	\N
2690	경상남도 합천군 청덕면 운봉리 913	2026-01-29 23:28:26.285312	35.6150238	128.3007334	OFFICIAL	2026-01-29 23:28:26.285316	0	\N
2691	경상남도 합천군 청덕면 소례리 1075-5	2026-01-29 23:28:26.285659	35.5982595	128.3345075	OFFICIAL	2026-01-29 23:28:26.285663	0	\N
2692	경상남도 합천군 청덕면 가현리 948-4	2026-01-29 23:28:26.286002	35.5609424	128.3213688	OFFICIAL	2026-01-29 23:28:26.286007	0	\N
2693	경상남도 합천군 청덕면 삼학리 600	2026-01-29 23:28:26.28636	35.5887465	128.3389812	OFFICIAL	2026-01-29 23:28:26.286364	0	\N
2694	경상남도 합천군 청덕면 적포리 591	2026-01-29 23:28:26.28671	35.5664288	128.3515075	OFFICIAL	2026-01-29 23:28:26.286714	0	\N
2695	경상남도 합천군 청덕면 대부리 584-2	2026-01-29 23:28:26.287078	35.5477091	128.3414775	OFFICIAL	2026-01-29 23:28:26.287081	0	\N
2696	경상남도 합천군 청덕면 두곡리 515-7	2026-01-29 23:28:26.287424	35.5564801	128.3147328	OFFICIAL	2026-01-29 23:28:26.287427	0	\N
2697	경상남도 합천군 청덕면 초곡리 833-3	2026-01-29 23:28:26.287794	35.5131481	128.3358188	OFFICIAL	2026-01-29 23:28:26.287798	0	\N
2698	경상남도 합천군 청덕면 앙진리 42-8	2026-01-29 23:28:26.288143	35.5059079	128.3703914	OFFICIAL	2026-01-29 23:28:26.288146	0	\N
2699	경상남도 합천군 덕곡면 포두리 13-25	2026-01-29 23:28:26.288489	35.6403539	128.3532222	OFFICIAL	2026-01-29 23:28:26.288493	0	\N
2700	경상남도 합천군 덕곡면 율원리 562	2026-01-29 23:28:26.288858	35.6385662	128.2902215	OFFICIAL	2026-01-29 23:28:26.288862	0	\N
2701	경상남도 합천군 덕곡면 율지리 314-1	2026-01-29 23:28:26.289214	35.6135357	128.3540977	OFFICIAL	2026-01-29 23:28:26.289218	0	\N
2702	경상남도 합천군 쌍책면 오서리 14-6	2026-01-29 23:28:26.289562	35.5754616	128.2747241	OFFICIAL	2026-01-29 23:28:26.289566	0	\N
2703	경상남도 합천군 쌍책면 하신리 278-3	2026-01-29 23:28:26.289927	35.6236036	128.2499611	OFFICIAL	2026-01-29 23:28:26.28993	0	\N
2704	경상남도 합천군 쌍책면 덕봉리 575	2026-01-29 23:28:26.290292	35.5998065	128.2791555	OFFICIAL	2026-01-29 23:28:26.290296	0	\N
2705	경상남도 합천군 쌍책면 다라리 826-25	2026-01-29 23:28:26.290646	35.5873511	128.2862296	OFFICIAL	2026-01-29 23:28:26.29065	0	\N
2706	경상남도 합천군 쌍책면 사양리 407-2	2026-01-29 23:28:26.290995	35.6251061	128.2721116	OFFICIAL	2026-01-29 23:28:26.290999	0	\N
2707	경상남도 합천군 쌍책면 하신리 294-2	2026-01-29 23:28:26.291348	35.6283401	128.2522059	OFFICIAL	2026-01-29 23:28:26.291351	0	\N
2708	경상남도 합천군 쌍책면 다라리 536-1	2026-01-29 23:28:26.291699	35.5808822	128.2924628	OFFICIAL	2026-01-29 23:28:26.291706	0	\N
2709	경상남도 합천군 쌍책면 상신리 산241-1	2026-01-29 23:28:26.29207	35.6361694	128.2623223	OFFICIAL	2026-01-29 23:28:26.292073	0	\N
2710	경상남도 합천군 쌍책면 성산리 252	2026-01-29 23:28:26.292429	35.5797672	128.2876149	OFFICIAL	2026-01-29 23:28:26.292433	0	\N
2711	경상남도 합천군 쌍책면 상포리 448	2026-01-29 23:28:26.2928	35.5827021	128.2736784	OFFICIAL	2026-01-29 23:28:26.292803	0	\N
2712	경상남도 합천군 쌍책면 상신리 526	2026-01-29 23:28:26.293161	35.6367168	128.2507747	OFFICIAL	2026-01-29 23:28:26.293165	0	\N
2713	경상남도 합천군 쌍책면 건태리 1043	2026-01-29 23:28:26.293514	35.6011368	128.2648126	OFFICIAL	2026-01-29 23:28:26.293517	0	\N
2714	경상남도 합천군 쌍책면 오서리 723	2026-01-29 23:28:26.293902	35.5711881	128.2752279	OFFICIAL	2026-01-29 23:28:26.293906	0	\N
2715	경상남도 합천군 쌍책면 상포리 411-5	2026-01-29 23:28:26.294275	35.5840098	128.2693464	OFFICIAL	2026-01-29 23:28:26.294279	0	\N
2716	경상남도 합천군 쌍책면 건태리 산69-5	2026-01-29 23:28:26.294633	35.6061554	128.2488582	OFFICIAL	2026-01-29 23:28:26.294637	0	\N
2717	경상남도 합천군 초계면 대평리 161-1	2026-01-29 23:28:26.294988	35.5468275	128.2529431	OFFICIAL	2026-01-29 23:28:26.294992	0	\N
2718	경상남도 합천군 초계면 중리 380-21	2026-01-29 23:28:26.295346	35.5590822	128.2505437	OFFICIAL	2026-01-29 23:28:26.29535	0	\N
2719	경상남도 합천군 초계면 원당리 416-1	2026-01-29 23:28:26.295701	35.5381834	128.2396493	OFFICIAL	2026-01-29 23:28:26.295704	0	\N
2720	경상남도 합천군 초계면 택리 598-4	2026-01-29 23:28:26.296098	35.5474392	128.2403055	OFFICIAL	2026-01-29 23:28:26.296102	0	\N
2721	대구광역시 북구 원대로 118 대구광역시 북구 침산동 402-1	2026-01-29 23:28:26.296458	35.88788184	128.5834556	OFFICIAL	2026-01-29 23:28:26.296462	0	\N
2722	경상남도 합천군 쌍백면 안계리 908-3	2026-01-29 23:28:26.296834	35.4422616	128.1863612	OFFICIAL	2026-01-29 23:28:26.296837	0	\N
2723	경상남도 합천군 쌍백면 외초리 1062-2	2026-01-29 23:28:26.297188	35.4123892	128.1680035	OFFICIAL	2026-01-29 23:28:26.297192	0	\N
2724	경상남도 합천군 쌍백면 육리 1248	2026-01-29 23:28:26.297535	35.4649726	128.1831963	OFFICIAL	2026-01-29 23:28:26.297539	0	\N
2725	경상남도 합천군 쌍백면 평지리 446	2026-01-29 23:28:26.297907	35.4391394	128.1703941	OFFICIAL	2026-01-29 23:28:26.297911	0	\N
2726	경상남도 합천군 대양면 도리 337-10	2026-01-29 23:28:26.29826	35.5011227	128.1542771	OFFICIAL	2026-01-29 23:28:26.298264	0	\N
2727	경상남도 합천군 대양면 대목리 558	2026-01-29 23:28:26.298608	35.5215585	128.1667752	OFFICIAL	2026-01-29 23:28:26.298612	0	\N
2728	경상남도 합천군 대양면 무곡리 389	2026-01-29 23:28:26.298949	35.5251456	128.1969172	OFFICIAL	2026-01-29 23:28:26.298952	0	\N
2729	경상남도 합천군 대양면 양산리 923-7	2026-01-29 23:28:26.299316	35.5085524	128.1787203	OFFICIAL	2026-01-29 23:28:26.29932	0	\N
2730	경상남도 합천군 대양면 무곡리 984	2026-01-29 23:28:26.299671	35.5213401	128.1866761	OFFICIAL	2026-01-29 23:28:26.299674	0	\N
2731	경상남도 합천군 대양면 백암리 367	2026-01-29 23:28:26.300999	35.4969628	128.2209542	OFFICIAL	2026-01-29 23:28:26.301003	0	\N
2732	경상남도 합천군 대양면 안금리 576-2	2026-01-29 23:28:26.301402	35.4959148	128.1848427	OFFICIAL	2026-01-29 23:28:26.301405	0	\N
2733	경상남도 합천군 대양면 오산리 307	2026-01-29 23:28:26.30178	35.4992874	128.2310794	OFFICIAL	2026-01-29 23:28:26.301784	0	\N
2734	경상남도 합천군 대양면 덕정리 925-18	2026-01-29 23:28:26.302138	35.5154903	128.1744911	OFFICIAL	2026-01-29 23:28:26.302142	0	\N
2735	경상남도 합천군 적중면 정토리 206-1	2026-01-29 23:28:26.302493	35.5296748	128.2569581	OFFICIAL	2026-01-29 23:28:26.302496	0	\N
2736	경상남도 합천군 적중면 옥두리 612-3	2026-01-29 23:28:26.302859	35.5502596	128.2899471	OFFICIAL	2026-01-29 23:28:26.302863	0	\N
2737	경상남도 합천군 적중면 황정리 290	2026-01-29 23:28:26.303206	35.5391096	128.2861684	OFFICIAL	2026-01-29 23:28:26.30321	0	\N
2738	경상남도 합천군 적중면 황정리 493	2026-01-29 23:28:26.303557	35.5369988	128.2830071	OFFICIAL	2026-01-29 23:28:26.303561	0	\N
2739	경상남도 합천군 적중면 죽고리 287-2	2026-01-29 23:28:26.303926	35.5705284	128.3022329	OFFICIAL	2026-01-29 23:28:26.30393	0	\N
2740	경상남도 합천군 적중면 두방리 357	2026-01-29 23:28:26.304288	35.5385442	128.2926178	OFFICIAL	2026-01-29 23:28:26.304292	0	\N
2741	경상남도 합천군 적중면 누하리 554-1	2026-01-29 23:28:26.304689	35.5297239	128.2675219	OFFICIAL	2026-01-29 23:28:26.304693	0	\N
2742	경상남도 합천군 적중면 양림리 887-14	2026-01-29 23:28:26.305049	35.5345637	128.2637114	OFFICIAL	2026-01-29 23:28:26.305053	0	\N
2743	경상남도 합천군 적중면 누하리 26-1	2026-01-29 23:28:26.305389	35.5313153	128.2733605	OFFICIAL	2026-01-29 23:28:26.305393	0	\N
2744	경상남도 합천군 청덕면 삼학리 45-1	2026-01-29 23:28:26.305786	35.5782241	128.3558179	OFFICIAL	2026-01-29 23:28:26.30579	0	\N
2745	경상남도 합천군 청덕면 미곡리 산56-2	2026-01-29 23:28:26.306138	35.5754567	128.3305622	OFFICIAL	2026-01-29 23:28:26.306141	0	\N
2746	경상남도 합천군 청덕면 대부리 1525	2026-01-29 23:28:26.306486	35.5353218	128.3422741	OFFICIAL	2026-01-29 23:28:26.306489	0	\N
2747	경상남도 합천군 청덕면 소례리 870-2	2026-01-29 23:28:26.306838	35.6046309	128.3148771	OFFICIAL	2026-01-29 23:28:26.306842	0	\N
2748	경상남도 합천군 청덕면 적포리 757-1	2026-01-29 23:28:26.307194	35.5564858	128.3486955	OFFICIAL	2026-01-29 23:28:26.307197	0	\N
2749	경상남도 합천군 청덕면 성태리 1023-5	2026-01-29 23:28:26.307541	35.5774253	128.3157525	OFFICIAL	2026-01-29 23:28:26.307545	0	\N
2750	경상남도 합천군 청덕면 앙진리 1111-4	2026-01-29 23:28:26.307911	35.5198603	128.3587906	OFFICIAL	2026-01-29 23:28:26.307914	0	\N
2751	경상남도 합천군 청덕면 가현리 498-30	2026-01-29 23:28:26.308257	35.5672396	128.3293149	OFFICIAL	2026-01-29 23:28:26.30826	0	\N
2752	경상남도 합천군 청덕면 두곡리 311-6	2026-01-29 23:28:26.308608	35.5540395	128.3173263	OFFICIAL	2026-01-29 23:28:26.308611	0	\N
2753	서울특별시 노원구 화랑로 815	2026-01-29 23:28:26.308956	37.64335737	127.1088503	OFFICIAL	2026-01-29 23:28:26.308959	0	\N
2754	서울특별시 노원구 화랑로 815	2026-01-29 23:28:26.30931	37.64335737	127.1088503	OFFICIAL	2026-01-29 23:28:26.309313	0	\N
2755	서울특별시 노원구 화랑로 768	2026-01-29 23:28:26.30966	37.63600845	127.1068283	OFFICIAL	2026-01-29 23:28:26.309664	0	\N
2756	서울특별시 노원구 화랑로 653	2026-01-29 23:28:26.310059	37.62961285	127.0950867	OFFICIAL	2026-01-29 23:28:26.310063	0	\N
2757	서울특별시 노원구 화랑로 682	2026-01-29 23:28:26.31041	37.62973006	127.0979586	OFFICIAL	2026-01-29 23:28:26.310414	0	\N
2758	서울특별시 노원구 화랑로 682	2026-01-29 23:28:26.310776	37.62973006	127.0979586	OFFICIAL	2026-01-29 23:28:26.310779	0	\N
2759	서울특별시 노원구 화랑로 653	2026-01-29 23:28:26.311113	37.62961285	127.0950867	OFFICIAL	2026-01-29 23:28:26.311117	0	\N
2760	서울특별시 노원구 화랑로 621	2026-01-29 23:28:26.31146	37.62878266	127.0889915	OFFICIAL	2026-01-29 23:28:26.311464	0	\N
2761	서울특별시 노원구 화랑로 621	2026-01-29 23:28:26.311833	37.62878266	127.0889915	OFFICIAL	2026-01-29 23:28:26.311836	0	\N
2762	서울특별시 노원구 화랑로 556	2026-01-29 23:28:26.312196	37.62128774	127.0877533	OFFICIAL	2026-01-29 23:28:26.3122	0	\N
2763	서울특별시 노원구 화랑로51길 17	2026-01-29 23:28:26.312544	37.62307787	127.0893658	OFFICIAL	2026-01-29 23:28:26.312547	0	\N
2764	서울특별시 노원구 섬밭로 17	2026-01-29 23:28:26.312919	37.61843007	127.0723471	OFFICIAL	2026-01-29 23:28:26.312924	0	\N
2765	서울특별시 노원구 동일로183길 34	2026-01-29 23:28:26.31335	37.62328229	127.0713893	OFFICIAL	2026-01-29 23:28:26.313354	0	\N
2766	서울특별시 노원구 동일로191가길 37	2026-01-29 23:28:26.313711	37.62672338	127.0707244	OFFICIAL	2026-01-29 23:28:26.313714	0	\N
2767	서울특별시 노원구 동일로197길 24	2026-01-29 23:28:26.314114	37.62879899	127.0698009	OFFICIAL	2026-01-29 23:28:26.314118	0	\N
2768	서울특별시 노원구 동일로191가길 59	2026-01-29 23:28:26.314476	37.62766279	127.0696059	OFFICIAL	2026-01-29 23:28:26.314479	0	\N
2769	서울특별시 노원구 공릉로 130	2026-01-29 23:28:26.314823	37.62162319	127.0793373	OFFICIAL	2026-01-29 23:28:26.314827	0	\N
2770	서울특별시 노원구 공릉로 232	2026-01-29 23:28:26.315169	37.63307893	127.0767947	OFFICIAL	2026-01-29 23:28:26.315172	0	\N
2771	서울특별시 노원구 노원로1가길 10	2026-01-29 23:28:26.315514	37.62365045	127.0859584	OFFICIAL	2026-01-29 23:28:26.315517	0	\N
2772	서울특별시 노원구 노원로 240	2026-01-29 23:28:26.315887	37.63937196	127.0745259	OFFICIAL	2026-01-29 23:28:26.315891	0	\N
2773	서울특별시 노원구 마들로 111	2026-01-29 23:28:26.316232	37.62383436	127.0647781	OFFICIAL	2026-01-29 23:28:26.316235	0	\N
2774	서울특별시 노원구 마들로 127	2026-01-29 23:28:26.316571	37.62678626	127.0652715	OFFICIAL	2026-01-29 23:28:26.316574	0	\N
2775	서울특별시 노원구 광운로 21	2026-01-29 23:28:26.316943	37.61982653	127.0575899	OFFICIAL	2026-01-29 23:28:26.316947	0	\N
2776	서울특별시 노원구 월계로49길 5	2026-01-29 23:28:26.317291	37.62931332	127.0562219	OFFICIAL	2026-01-29 23:28:26.317294	0	\N
2777	서울특별시 노원구 섬밭로 201	2026-01-29 23:28:26.317635	37.63328542	127.0655211	OFFICIAL	2026-01-29 23:28:26.317639	0	\N
2778	서울특별시 노원구 한글비석로 98	2026-01-29 23:28:26.317983	37.6375355	127.0727752	OFFICIAL	2026-01-29 23:28:26.317987	0	\N
2779	서울특별시 노원구 공릉로62길 41	2026-01-29 23:28:26.318331	37.63747448	127.071637	OFFICIAL	2026-01-29 23:28:26.318335	0	\N
2780	서울특별시 노원구 공릉로58길 176	2026-01-29 23:28:26.318674	37.63769871	127.0769631	OFFICIAL	2026-01-29 23:28:26.318678	0	\N
2781	서울특별시 노원구 한글비석로 151	2026-01-29 23:28:26.319028	37.64133774	127.0756469	OFFICIAL	2026-01-29 23:28:26.319032	0	\N
2782	서울특별시 노원구 노원로16길 15	2026-01-29 23:28:26.319393	37.64344507	127.0733372	OFFICIAL	2026-01-29 23:28:26.319397	0	\N
2783	서울특별시 노원구 노원로18길 41	2026-01-29 23:28:26.319743	37.64451236	127.0729257	OFFICIAL	2026-01-29 23:28:26.319767	0	\N
2784	서울특별시 노원구 한글비석로1길 81-11	2026-01-29 23:28:26.320119	37.64100553	127.0690818	OFFICIAL	2026-01-29 23:28:26.320123	0	\N
2785	서울특별시 노원구 동일로 1238	2026-01-29 23:28:26.320471	37.64066045	127.0668656	OFFICIAL	2026-01-29 23:28:26.320475	0	\N
2786	서울특별시 노원구 중계로 120	2026-01-29 23:28:26.320833	37.64633482	127.0817898	OFFICIAL	2026-01-29 23:28:26.320837	0	\N
2787	서울특별시 노원구 중계로12길 24	2026-01-29 23:28:26.321187	37.6468185	127.0818703	OFFICIAL	2026-01-29 23:28:26.32119	0	\N
2788	서울특별시 노원구 노원로22길 1	2026-01-29 23:28:26.321542	37.64815756	127.0706995	OFFICIAL	2026-01-29 23:28:26.321546	0	\N
2789	서울특별시 노원구 노원로 330	2026-01-29 23:28:26.321934	37.64679053	127.0709409	OFFICIAL	2026-01-29 23:28:26.321938	0	\N
2790	서울특별시 노원구 중계로 167	2026-01-29 23:28:26.322292	37.65005409	127.0807307	OFFICIAL	2026-01-29 23:28:26.322296	0	\N
2791	서울특별시 노원구 중계로 230	2026-01-29 23:28:26.322638	37.65101324	127.0750479	OFFICIAL	2026-01-29 23:28:26.322642	0	\N
2792	서울특별시 노원구 공릉로 431	2026-01-29 23:28:26.322977	37.64503406	127.0661389	OFFICIAL	2026-01-29 23:28:26.322997	0	\N
2793	서울특별시 노원구 노원로15길 51-10	2026-01-29 23:28:26.323395	37.63973051	127.0700338	OFFICIAL	2026-01-29 23:28:26.323399	0	\N
2794	서울특별시 노원구 노원로 331	2026-01-29 23:28:26.323773	37.64617746	127.06966	OFFICIAL	2026-01-29 23:28:26.323777	0	\N
2795	서울특별시 노원구 덕릉로 541	2026-01-29 23:28:26.324117	37.64872348	127.0669678	OFFICIAL	2026-01-29 23:28:26.324121	0	\N
2796	서울특별시 노원구 덕릉로76길 18	2026-01-29 23:28:26.324461	37.65431092	127.0749142	OFFICIAL	2026-01-29 23:28:26.324464	0	\N
2797	서울특별시 노원구 중계로 230	2026-01-29 23:28:26.324902	37.65101324	127.0750479	OFFICIAL	2026-01-29 23:28:26.324917	0	\N
2798	서울특별시 노원구 덕릉로 872	2026-01-29 23:28:26.325257	37.67350344	127.0843883	OFFICIAL	2026-01-29 23:28:26.325261	0	\N
2799	서울특별시 노원구 덕릉로 753	2026-01-29 23:28:26.325621	37.66507422	127.0775817	OFFICIAL	2026-01-29 23:28:26.325623	0	\N
2800	서울특별시 노원구 덕릉로 753	2026-01-29 23:28:26.325977	37.66507422	127.0775817	OFFICIAL	2026-01-29 23:28:26.325982	0	\N
2801	서울특별시 노원구 공릉로 351	2026-01-29 23:28:26.326341	37.63815992	127.0680314	OFFICIAL	2026-01-29 23:28:26.326344	0	\N
2802	서울특별시 노원구 동일로204가길 12	2026-01-29 23:28:26.326683	37.63985808	127.068668	OFFICIAL	2026-01-29 23:28:26.326687	0	\N
2803	서울특별시 노원구 섬밭로 265	2026-01-29 23:28:26.327019	37.63828612	127.0627122	OFFICIAL	2026-01-29 23:28:26.327033	0	\N
2804	서울특별시 노원구 동일로216길 92	2026-01-29 23:28:26.327375	37.65052082	127.0673497	OFFICIAL	2026-01-29 23:28:26.327379	0	\N
2805	서울특별시 노원구 노원로 428	2026-01-29 23:28:26.327732	37.65452808	127.0683534	OFFICIAL	2026-01-29 23:28:26.327736	0	\N
2806	서울특별시 노원구 노해로 508	2026-01-29 23:28:26.328101	37.65470356	127.066191	OFFICIAL	2026-01-29 23:28:26.328105	0	\N
2807	서울특별시 노원구 노해로 502	2026-01-29 23:28:26.328449	37.65445005	127.0636923	OFFICIAL	2026-01-29 23:28:26.328453	0	\N
2808	서울특별시 노원구 노원로38길 76	2026-01-29 23:28:26.32882	37.66385315	127.061985	OFFICIAL	2026-01-29 23:28:26.328823	0	\N
2809	서울특별시 노원구 노원로 532	2026-01-29 23:28:26.329205	37.66461677	127.0598168	OFFICIAL	2026-01-29 23:28:26.329209	0	\N
2810	서울특별시 노원구 동일로215길 23	2026-01-29 23:28:26.329556	37.6504211	127.0590691	OFFICIAL	2026-01-29 23:28:26.329559	0	\N
2811	서울특별시 노원구 동일로215길 81	2026-01-29 23:28:26.329934	37.65022613	127.0568651	OFFICIAL	2026-01-29 23:28:26.329937	0	\N
2812	서울특별시 노원구 동일로 1729	2026-01-29 23:28:26.33029	37.68314469	127.0548083	OFFICIAL	2026-01-29 23:28:26.330294	0	\N
2813	서울특별시 노원구 동일로250길 17	2026-01-29 23:28:26.330634	37.68246227	127.0567709	OFFICIAL	2026-01-29 23:28:26.330637	0	\N
2814	서울특별시 노원구 동일로 1324-2	2026-01-29 23:28:26.330977	37.64700938	127.0633425	OFFICIAL	2026-01-29 23:28:26.330981	0	\N
2815	서울특별시 노원구 노해로 437	2026-01-29 23:28:26.33132	37.65451904	127.0562972	OFFICIAL	2026-01-29 23:28:26.331323	0	\N
2816	서울특별시 노원구 동일로 1378-2	2026-01-29 23:28:26.331719	37.65173576	127.0614564	OFFICIAL	2026-01-29 23:28:26.331764	0	\N
2817	광주광역시 광산구 용봉동 333-24	2026-01-29 23:28:26.332153	35.0808451	126.7664497	OFFICIAL	2026-01-29 23:28:26.332157	0	\N
2818	광주광역시 광산구 용봉동 330-3	2026-01-29 23:28:26.332498	35.08102262	126.7661274	OFFICIAL	2026-01-29 23:28:26.332502	0	\N
2819	광주광역시 광산구 본덕동 506-2	2026-01-29 23:28:26.33288	35.08595053	126.7716261	OFFICIAL	2026-01-29 23:28:26.332884	0	\N
2820	광주광역시 광산구 복룡동 645-9	2026-01-29 23:28:26.333238	35.11782001	126.7807996	OFFICIAL	2026-01-29 23:28:26.333241	0	\N
2821	광주광역시 광산구 동곡로 324	2026-01-29 23:28:26.333583	35.11093722	126.7799549	OFFICIAL	2026-01-29 23:28:26.333586	0	\N
2822	광주광역시 광산구 동곡로 282	2026-01-29 23:28:26.333936	35.10742955	126.7794041	OFFICIAL	2026-01-29 23:28:26.33394	0	\N
2823	광주광역시 광산구 유계동 237-18	2026-01-29 23:28:26.334286	35.10165397	126.7780947	OFFICIAL	2026-01-29 23:28:26.33429	0	\N
2824	광주광역시 광산구 동곡로 170	2026-01-29 23:28:26.33463	35.09782047	126.7756845	OFFICIAL	2026-01-29 23:28:26.334634	0	\N
2825	서울특별시 노원구 동일로 1081	2026-01-29 23:28:26.334976	37.62637728	127.0722704	OFFICIAL	2026-01-29 23:28:26.33498	0	\N
2826	서울특별시 노원구 동일로 1041	2026-01-29 23:28:26.335327	37.62310296	127.0735029	OFFICIAL	2026-01-29 23:28:26.335331	0	\N
2827	서울특별시 노원구 동일로173길 12	2026-01-29 23:28:26.335673	37.61861443	127.0746314	OFFICIAL	2026-01-29 23:28:26.335677	0	\N
2828	서울특별시 노원구 동일로 996	2026-01-29 23:28:26.336007	37.61919557	127.0754877	OFFICIAL	2026-01-29 23:28:26.33601	0	\N
2829	서울특별시 노원구 동일로 192길 20	2026-01-29 23:28:26.336379	37.62590104	127.0742578	OFFICIAL	2026-01-29 23:28:26.336382	0	\N
2830	서울특별시 노원구 화랑로 421	2026-01-29 23:28:26.33673	37.61752173	127.0743315	OFFICIAL	2026-01-29 23:28:26.336734	0	\N
2831	서울특별시 구로구 서해안로 2311 서울특별시 구로구 오류동 85-12	2026-01-29 23:28:26.337089	37.49255807	126.8413421	OFFICIAL	2026-01-29 23:28:26.337092	0	\N
2832	서울특별시 구로구 개봉동 199-4	2026-01-29 23:28:26.337425	37.49380798	126.8597648	OFFICIAL	2026-01-29 23:28:26.337429	0	\N
2833	서울특별시 구로구 디지털로32나길 35 서울특별시 구로구 구로동 1124-44	2026-01-29 23:28:26.337996	37.48471269	126.900872	OFFICIAL	2026-01-29 23:28:26.337999	0	\N
2834	서울특별시 구로구 신도림동 350-2	2026-01-29 23:28:26.338352	37.50862717	126.8876382	OFFICIAL	2026-01-29 23:28:26.338367	0	\N
2835	서울특별시 구로구 경인로 673-1	2026-01-29 23:28:26.338734	37.50984687	126.889001	OFFICIAL	2026-01-29 23:28:26.338737	0	\N
2836	서울특별시 구로구 시흥대로 563 서울특별시 구로구 구로동 1125-5	2026-01-29 23:28:26.339107	37.48339166	126.9014243	OFFICIAL	2026-01-29 23:28:26.339111	0	\N
2837	서울특별시 구로구 항동 9-1	2026-01-29 23:28:26.339462	37.48196844	126.8236695	OFFICIAL	2026-01-29 23:28:26.339466	0	\N
2838	서울특별시 구로구 천왕동 14-41	2026-01-29 23:28:26.339833	37.48682194	126.838774	OFFICIAL	2026-01-29 23:28:26.339837	0	\N
2839	서울특별시 구로구 오류로 20 서울특별시 구로구 천왕동 280-12	2026-01-29 23:28:26.340262	37.48639966	126.839547	OFFICIAL	2026-01-29 23:28:26.340267	0	\N
2840	서울특별시 구로구 경인로 159 서울특별시 구로구 오류동 81-30	2026-01-29 23:28:26.340782	37.49426611	126.8391462	OFFICIAL	2026-01-29 23:28:26.340786	0	\N
2841	서울특별시 구로구 경인로22길 48-1 서울특별시 구로구 오류동 56-49	2026-01-29 23:28:26.341178	37.4961806	126.846457	OFFICIAL	2026-01-29 23:28:26.341182	0	\N
2842	서울특별시 구로구 오류로 104 서울특별시 구로구 오류동 76-2	2026-01-29 23:28:26.341556	37.49394797	126.8405467	OFFICIAL	2026-01-29 23:28:26.341559	0	\N
2843	서울특별시 구로구 경인로 176-4 서울특별시 구로구 오류동 6-303	2026-01-29 23:28:26.341952	37.49446439	126.840732	OFFICIAL	2026-01-29 23:28:26.341956	0	\N
2844	서울특별시 구로구 경인로 248-14 서울특별시 구로구 오류동 336	2026-01-29 23:28:26.342327	37.49755995	126.8478786	OFFICIAL	2026-01-29 23:28:26.342331	0	\N
2845	서울특별시 구로구 새말로 18-53 서울특별시 구로구 구로동 572-22	2026-01-29 23:28:26.342686	37.50116412	126.88349	OFFICIAL	2026-01-29 23:28:26.34269	0	\N
2846	서울특별시 구로구 새말로4길 27 서울특별시 구로구 구로동 572-29	2026-01-29 23:28:26.343055	37.50112484	126.883602	OFFICIAL	2026-01-29 23:28:26.343058	0	\N
2847	서울특별시 구로구 경인로47길 50 서울특별시 구로구 고척동 52-242	2026-01-29 23:28:26.343407	37.5013741	126.8655701	OFFICIAL	2026-01-29 23:28:26.34341	0	\N
2848	서울특별시 구로구 경인로47길 49 서울특별시 구로구 고척동 53-2	2026-01-29 23:28:26.343781	37.50116963	126.865405	OFFICIAL	2026-01-29 23:28:26.343785	0	\N
2849	서울특별시 구로구 연동로 240 서울특별시 구로구 항동 9-1	2026-01-29 23:28:26.344196	37.48196844	126.8236695	OFFICIAL	2026-01-29 23:28:26.344199	0	\N
2850	서울특별시 구로구 항동 100-14	2026-01-29 23:28:26.34455	37.48130537	126.8216787	OFFICIAL	2026-01-29 23:28:26.344553	0	\N
2851	서울특별시 구로구 항동 169-1	2026-01-29 23:28:26.344928	37.478369	126.823641	OFFICIAL	2026-01-29 23:28:26.344932	0	\N
2852	서울특별시 구로구 항동 204-2	2026-01-29 23:28:26.345271	37.4769908	126.8195	OFFICIAL	2026-01-29 23:28:26.345275	0	\N
2853	서울특별시 구로구 항동 88-2	2026-01-29 23:28:26.345611	37.48135478	126.824877	OFFICIAL	2026-01-29 23:28:26.345615	0	\N
2854	서울특별시 구로구 항동 82-7	2026-01-29 23:28:26.345962	37.48177404	126.8246193	OFFICIAL	2026-01-29 23:28:26.345965	0	\N
2855	서울특별시 구로구 항동 113-5	2026-01-29 23:28:26.346315	37.47982718	126.822111	OFFICIAL	2026-01-29 23:28:26.346319	0	\N
2856	서울특별시 구로구 항동 115-2	2026-01-29 23:28:26.346663	37.48020766	126.822536	OFFICIAL	2026-01-29 23:28:26.346666	0	\N
2857	서울특별시 구로구 오류동 169-3	2026-01-29 23:28:26.347152	37.48822079	126.839713	OFFICIAL	2026-01-29 23:28:26.347156	0	\N
2858	서울특별시 구로구 오류동 332-36	2026-01-29 23:28:26.347526	37.4934436	126.842968	OFFICIAL	2026-01-29 23:28:26.347529	0	\N
2859	서울특별시 구로구 오류로 86 서울특별시 구로구 오류동 134-1	2026-01-29 23:28:26.347976	37.49246153	126.8409746	OFFICIAL	2026-01-29 23:28:26.347979	0	\N
2860	서울특별시 구로구 오류로 86 서울특별시 구로구 오류동 134-1	2026-01-29 23:28:26.348358	37.49246153	126.8409746	OFFICIAL	2026-01-29 23:28:26.348368	0	\N
2861	서울특별시 구로구 오류로 66 서울특별시 구로구 오류동 156-28	2026-01-29 23:28:26.348824	37.49048756	126.8408736	OFFICIAL	2026-01-29 23:28:26.348827	0	\N
2862	서울특별시 구로구 천왕동 11-17	2026-01-29 23:28:26.349197	37.48360686	126.841003	OFFICIAL	2026-01-29 23:28:26.3492	0	\N
2863	서울특별시 구로구 천왕동 12-39	2026-01-29 23:28:26.349548	37.48371087	126.841287	OFFICIAL	2026-01-29 23:28:26.349551	0	\N
2864	서울특별시 구로구 천왕동 282-10	2026-01-29 23:28:26.349922	37.48532517	126.8377231	OFFICIAL	2026-01-29 23:28:26.349924	0	\N
2865	서울특별시 구로구 경인로 196 서울특별시 구로구 오류동 48-1	2026-01-29 23:28:26.350276	37.49538169	126.8429307	OFFICIAL	2026-01-29 23:28:26.350279	0	\N
2866	서울특별시 구로구 경인로 196 서울특별시 구로구 오류동 48-1	2026-01-29 23:28:26.350619	37.49538169	126.8429307	OFFICIAL	2026-01-29 23:28:26.350622	0	\N
2867	서울특별시 구로구 경인로 176-4 서울특별시 구로구 오류동 6-303	2026-01-29 23:28:26.350967	37.49446439	126.8407215	OFFICIAL	2026-01-29 23:28:26.35097	0	\N
2868	서울특별시 구로구 경인로 176-4 서울특별시 구로구 오류동 6-303	2026-01-29 23:28:26.351303	37.49446439	126.8407215	OFFICIAL	2026-01-29 23:28:26.351306	0	\N
2869	서울특별시 구로구 경인로 161 서울특별시 구로구 오류동 81-91	2026-01-29 23:28:26.35173	37.49439186	126.8394568	OFFICIAL	2026-01-29 23:28:26.351733	0	\N
2870	서울특별시 구로구 경인로 161 서울특별시 구로구 오류동 81-91	2026-01-29 23:28:26.352121	37.49439186	126.8394568	OFFICIAL	2026-01-29 23:28:26.352123	0	\N
2871	서울특별시 구로구 고척로 6-1 서울특별시 구로구 오류동 9-190	2026-01-29 23:28:26.352476	37.49542213	126.840901	OFFICIAL	2026-01-29 23:28:26.352478	0	\N
2872	서울특별시 구로구 고척로 52	2026-01-29 23:28:26.352827	37.49856841	126.8404707	OFFICIAL	2026-01-29 23:28:26.352829	0	\N
2873	서울특별시 구로구 경인로 217	2026-01-29 23:28:26.353182	37.49672189	126.8449439	OFFICIAL	2026-01-29 23:28:26.353185	0	\N
2874	서울특별시 구로구 경인로27길 7	2026-01-29 23:28:26.353525	37.49707073	126.8450908	OFFICIAL	2026-01-29 23:28:26.353527	0	\N
2875	서울특별시 구로구 우마길 23	2026-01-29 23:28:26.353886	37.48090307	126.888878	OFFICIAL	2026-01-29 23:28:26.353889	0	\N
2876	서울특별시 구로구 구로동로 12	2026-01-29 23:28:26.354234	37.48284325	126.887327	OFFICIAL	2026-01-29 23:28:26.354236	0	\N
2877	서울특별시 구로구 우마길 19	2026-01-29 23:28:26.354582	37.48124676	126.8885862	OFFICIAL	2026-01-29 23:28:26.354585	0	\N
2878	서울특별시 구로구 우마길 23	2026-01-29 23:28:26.354941	37.48090307	126.888878	OFFICIAL	2026-01-29 23:28:26.354943	0	\N
2879	서울특별시 구로구 우마길 10-2	2026-01-29 23:28:26.35529	37.48185313	126.887875	OFFICIAL	2026-01-29 23:28:26.355293	0	\N
2880	서울특별시 구로구 경인로 661	2026-01-29 23:28:26.355634	37.50904922	126.8869873	OFFICIAL	2026-01-29 23:28:26.355637	0	\N
2881	서울특별시 구로구 신도림동 413-2	2026-01-29 23:28:26.355987	37.5056427	126.8834977	OFFICIAL	2026-01-29 23:28:26.35599	0	\N
2882	서울특별시 구로구 신도림동 413-2	2026-01-29 23:28:26.356328	37.5056427	126.8834977	OFFICIAL	2026-01-29 23:28:26.35633	0	\N
2883	서울특별시 구로구 신도림동 413-2	2026-01-29 23:28:26.356667	37.5056427	126.8834977	OFFICIAL	2026-01-29 23:28:26.356669	0	\N
2884	서울특별시 구로구 신도림동 350-2	2026-01-29 23:28:26.357011	37.50862717	126.8876382	OFFICIAL	2026-01-29 23:28:26.357013	0	\N
2885	서울특별시 구로구 신도림동 350-2	2026-01-29 23:28:26.357349	37.50862717	126.8876382	OFFICIAL	2026-01-29 23:28:26.357352	0	\N
2886	서울특별시 구로구 신도림동 350-2	2026-01-29 23:28:26.357688	37.50862717	126.8876382	OFFICIAL	2026-01-29 23:28:26.35769	0	\N
2887	서울특별시 구로구 신도림동 350-2	2026-01-29 23:28:26.35803	37.50862717	126.8876382	OFFICIAL	2026-01-29 23:28:26.358033	0	\N
2888	서울특별시 구로구 경인로 서울특별시 구로구 신도림동 432-30	2026-01-29 23:28:26.358378	37.50623763	126.8853921	OFFICIAL	2026-01-29 23:28:26.35838	0	\N
2889	서울특별시 구로구 신도림로 11 서울특별시 구로구 신도림동 691	2026-01-29 23:28:26.358718	37.50727521	126.878181	OFFICIAL	2026-01-29 23:28:26.358721	0	\N
2890	서울특별시 구로구 신도림로 11 서울특별시 구로구 신도림동 691	2026-01-29 23:28:26.35915	37.50727521	126.878181	OFFICIAL	2026-01-29 23:28:26.359153	0	\N
2891	서울특별시 구로구 신도림로19길 7 서울특별시 구로구 신도림동 649	2026-01-29 23:28:26.359497	37.51120297	126.8844703	OFFICIAL	2026-01-29 23:28:26.3595	0	\N
2892	서울특별시 구로구 신도림로 40 서울특별시 구로구 신도림동 390-68	2026-01-29 23:28:26.359868	37.50777999	126.8805952	OFFICIAL	2026-01-29 23:28:26.359871	0	\N
2893	서울특별시 구로구 신도림동 329-2	2026-01-29 23:28:26.36021	37.51198142	126.8881747	OFFICIAL	2026-01-29 23:28:26.360212	0	\N
2894	서울특별시 구로구 신도림로 67 서울특별시 구로구 신도림동 306-13	2026-01-29 23:28:26.360554	37.50992411	126.8820265	OFFICIAL	2026-01-29 23:28:26.360556	0	\N
2895	서울특별시 구로구 신도림로 78 서울특별시 구로구 신도림동 645	2026-01-29 23:28:26.36093	37.50938921	126.8847002	OFFICIAL	2026-01-29 23:28:26.360932	0	\N
2896	서울특별시 구로구 신도림로 2 서울특별시 구로구 신도림동 400-3	2026-01-29 23:28:26.361261	37.50559462	126.8772754	OFFICIAL	2026-01-29 23:28:26.361263	0	\N
2897	서울특별시 노원구 노원로 31-2	2026-01-29 23:28:26.361613	37.62444854	127.0862158	OFFICIAL	2026-01-29 23:28:26.361615	0	\N
2898	서울특별시 구로구 신도림로 2 서울특별시 구로구 신도림동 400-3	2026-01-29 23:28:26.36197	37.50559462	126.8772754	OFFICIAL	2026-01-29 23:28:26.361972	0	\N
2899	서울특별시 구로구 신도림로 16 서울특별시 구로구 신도림동 642	2026-01-29 23:28:26.36237	37.50512282	126.882191	OFFICIAL	2026-01-29 23:28:26.362373	0	\N
2900	서울특별시 구로구 신도림로 16 서울특별시 구로구 신도림동 642	2026-01-29 23:28:26.362712	37.50512282	126.882191	OFFICIAL	2026-01-29 23:28:26.362715	0	\N
2901	서울특별시 구로구 경인로3길 77 서울특별시 구로구 온수동 52	2026-01-29 23:28:26.363083	37.49173696	126.823542	OFFICIAL	2026-01-29 23:28:26.363085	0	\N
2902	서울특별시 구로구 경인로3길 77 서울특별시 구로구 온수동 52	2026-01-29 23:28:26.36345	37.49173696	126.823542	OFFICIAL	2026-01-29 23:28:26.363452	0	\N
2903	서울특별시 구로구 부일로9길 133 서울특별시 구로구 온수동 141	2026-01-29 23:28:26.363822	37.49690229	126.8221862	OFFICIAL	2026-01-29 23:28:26.363824	0	\N
2904	서울특별시 구로구 부일로 861 서울특별시 구로구 온수동 18-12	2026-01-29 23:28:26.364165	37.49265356	126.822945	OFFICIAL	2026-01-29 23:28:26.364168	0	\N
2905	서울특별시 구로구 부일로 869 서울특별시 구로구 온수동 11-1	2026-01-29 23:28:26.364505	37.49294292	126.823634	OFFICIAL	2026-01-29 23:28:26.364508	0	\N
2906	서울특별시 구로구 부일로 868-1 서울특별시 구로구 온수동 119-4	2026-01-29 23:28:26.36487	37.49254526	126.8235425	OFFICIAL	2026-01-29 23:28:26.364873	0	\N
2907	서울특별시 구로구 부일로 917 서울특별시 구로구 궁동 230	2026-01-29 23:28:26.365218	37.49490231	126.8263536	OFFICIAL	2026-01-29 23:28:26.36522	0	\N
2908	서울특별시 구로구 부일로 957 서울특별시 구로구 궁동 202-6	2026-01-29 23:28:26.36559	37.49340026	126.8336922	OFFICIAL	2026-01-29 23:28:26.365592	0	\N
2909	서울특별시 구로구 부일로 957 서울특별시 구로구 궁동 202-6	2026-01-29 23:28:26.365958	37.49340026	126.8336922	OFFICIAL	2026-01-29 23:28:26.36596	0	\N
2910	서울특별시 구로구 부일로15길 4 서울특별시 구로구 궁동 189-25	2026-01-29 23:28:26.366306	37.49351635	126.834427	OFFICIAL	2026-01-29 23:28:26.366308	0	\N
2911	서울특별시 구로구 궁동 199-26	2026-01-29 23:28:26.366648	37.493509	126.835896	OFFICIAL	2026-01-29 23:28:26.36665	0	\N
2912	서울특별시 구로구 오리로 1286 서울특별시 구로구 궁동 170-11	2026-01-29 23:28:26.367002	37.49627786	126.8299962	OFFICIAL	2026-01-29 23:28:26.367005	0	\N
2913	서울특별시 구로구 오리로 1293 서울특별시 구로구 궁동 283-5	2026-01-29 23:28:26.367358	37.49688156	126.8292071	OFFICIAL	2026-01-29 23:28:26.36736	0	\N
2914	서울특별시 구로구 오리로 1307 서울특별시 구로구 궁동 278-4	2026-01-29 23:28:26.367719	37.49809846	126.8289553	OFFICIAL	2026-01-29 23:28:26.367722	0	\N
2915	서울특별시 구로구 오리로15길 32 서울특별시 구로구 궁동 213-42	2026-01-29 23:28:26.36808	37.4938915	126.8314768	OFFICIAL	2026-01-29 23:28:26.368082	0	\N
2916	서울특별시 구로구 오리로15길 32 서울특별시 구로구 궁동 213-42	2026-01-29 23:28:26.368417	37.4938915	126.8314768	OFFICIAL	2026-01-29 23:28:26.36842	0	\N
2917	서울특별시 구로구 공원로 27 서울특별시 구로구 구로동 107-9	2026-01-29 23:28:26.368809	37.49939719	126.8910091	OFFICIAL	2026-01-29 23:28:26.368811	0	\N
2918	서울특별시 구로구 구로동 3-64	2026-01-29 23:28:26.369279	37.50726447	126.89282	OFFICIAL	2026-01-29 23:28:26.369281	0	\N
2919	서울특별시 구로구 구로중앙로 108 서울특별시 구로구 구로동 514-2	2026-01-29 23:28:26.369709	37.49850642	126.8863775	OFFICIAL	2026-01-29 23:28:26.369712	0	\N
2920	서울특별시 구로구 구로중앙로28길 66 서울특별시 구로구 구로동 109-4	2026-01-29 23:28:26.370097	37.500164	126.8893378	OFFICIAL	2026-01-29 23:28:26.3701	0	\N
2921	서울특별시 구로구 구로중앙로28길 65 서울특별시 구로구 구로동 111-16	2026-01-29 23:28:26.370462	37.50047025	126.8889323	OFFICIAL	2026-01-29 23:28:26.370464	0	\N
2922	서울특별시 구로구 경인로 572 서울특별시 구로구 구로동 603-9	2026-01-29 23:28:26.37091	37.50330627	126.8810839	OFFICIAL	2026-01-29 23:28:26.370913	0	\N
2923	서울특별시 구로구 새말로 111 서울특별시 구로구 구로동 1-4	2026-01-29 23:28:26.371349	37.50786379	126.8922179	OFFICIAL	2026-01-29 23:28:26.371353	0	\N
2924	서울특별시 구로구 새말로 111 서울특별시 구로구 구로동 1-4	2026-01-29 23:28:26.371823	37.50786379	126.8922179	OFFICIAL	2026-01-29 23:28:26.371826	0	\N
2925	서울특별시 구로구 새말로 111 서울특별시 구로구 구로동 1-4	2026-01-29 23:28:26.37221	37.50786379	126.8922179	OFFICIAL	2026-01-29 23:28:26.372212	0	\N
2926	서울특별시 노원구 공릉동 90-2	2026-01-29 23:28:26.372586	37.62095614	127.0848955	OFFICIAL	2026-01-29 23:28:26.372588	0	\N
2927	서울특별시 구로구 새말로 117-6 서울특별시 구로구 구로동 3-55	2026-01-29 23:28:26.37295	37.5074418	126.8922686	OFFICIAL	2026-01-29 23:28:26.372953	0	\N
2928	서울특별시 구로구 새말로 111 서울특별시 구로구 구로동 1-4	2026-01-29 23:28:26.373308	37.50786379	126.8922179	OFFICIAL	2026-01-29 23:28:26.373311	0	\N
2929	서울특별시 구로구 공원로 54 서울특별시 구로구 구로동 45-9	2026-01-29 23:28:26.373658	37.50259229	126.8901814	OFFICIAL	2026-01-29 23:28:26.373661	0	\N
2930	서울특별시 구로구 공원로6길 서울특별시 구로구 구로동 47	2026-01-29 23:28:26.374006	37.50135772	126.8920128	OFFICIAL	2026-01-29 23:28:26.374008	0	\N
2931	서울특별시 구로구 공원로 51 서울특별시 구로구 구로동 110-2	2026-01-29 23:28:26.374358	37.50131998	126.8893996	OFFICIAL	2026-01-29 23:28:26.37436	0	\N
2932	서울특별시 구로구 공원로 27 서울특별시 구로구 구로동 107-9	2026-01-29 23:28:26.374704	37.49939719	126.8910091	OFFICIAL	2026-01-29 23:28:26.374706	0	\N
2933	서울특별시 구로구 가마산로27길 45 서울특별시 구로구 구로동 105-1	2026-01-29 23:28:26.375077	37.49884008	126.8903092	OFFICIAL	2026-01-29 23:28:26.37508	0	\N
2934	서울특별시 구로구 새말로 81 서울특별시 구로구 구로동 8-14	2026-01-29 23:28:26.37542	37.50514257	126.8889085	OFFICIAL	2026-01-29 23:28:26.375423	0	\N
2935	서울특별시 구로구 가마산로 283 서울특별시 구로구 구로동 104-9	2026-01-29 23:28:26.375787	37.49690482	126.8913849	OFFICIAL	2026-01-29 23:28:26.375789	0	\N
2936	서울특별시 구로구 가마산로 283 서울특별시 구로구 구로동 104-9	2026-01-29 23:28:26.37614	37.49690482	126.8913849	OFFICIAL	2026-01-29 23:28:26.376142	0	\N
2937	서울특별시 구로구 구로중앙로 152 서울특별시 구로구 구로동 573	2026-01-29 23:28:26.376482	37.50116014	126.882773	OFFICIAL	2026-01-29 23:28:26.376484	0	\N
2938	서울특별시 구로구 구로중앙로 152 서울특별시 구로구 구로동 573	2026-01-29 23:28:26.376822	37.50116014	126.882773	OFFICIAL	2026-01-29 23:28:26.376825	0	\N
2939	서울특별시 구로구 구로중앙로 68 서울특별시 구로구 구로동 100-8	2026-01-29 23:28:26.377172	37.49586031	126.8888073	OFFICIAL	2026-01-29 23:28:26.377175	0	\N
2940	서울특별시 구로구 구로중앙로 68 서울특별시 구로구 구로동 100-8	2026-01-29 23:28:26.377514	37.49586031	126.8888073	OFFICIAL	2026-01-29 23:28:26.377516	0	\N
2941	서울특별시 구로구 새말로 94 서울특별시 구로구 구로동 25	2026-01-29 23:28:26.377869	37.50547022	126.8904984	OFFICIAL	2026-01-29 23:28:26.377871	0	\N
2942	서울특별시 구로구 구로중앙로28길 66 서울특별시 구로구 구로동 109-4	2026-01-29 23:28:26.378206	37.50010311	126.8893378	OFFICIAL	2026-01-29 23:28:26.378208	0	\N
2943	서울특별시 구로구 구로중앙로28길 66 서울특별시 구로구 구로동 109-4	2026-01-29 23:28:26.378633	37.50010311	126.8893378	OFFICIAL	2026-01-29 23:28:26.378636	0	\N
2944	서울특별시 구로구 구로동로 126-2 서울특별시 구로구 구로동 732-1	2026-01-29 23:28:26.378979	37.48993123	126.8845698	OFFICIAL	2026-01-29 23:28:26.378993	0	\N
2945	서울특별시 구로구 구로동로 124 서울특별시 구로구 구로동 732-3	2026-01-29 23:28:26.379387	37.48963242	126.8845363	OFFICIAL	2026-01-29 23:28:26.37939	0	\N
2946	서울특별시 구로구 구로동로 108 서울특별시 구로구 구로동 737-1	2026-01-29 23:28:26.379829	37.48825257	126.8848511	OFFICIAL	2026-01-29 23:28:26.379832	0	\N
2947	서울특별시 구로구 구로동로 96-1 서울특별시 구로구 구로동 738-65	2026-01-29 23:28:26.380193	37.48731314	126.8851802	OFFICIAL	2026-01-29 23:28:26.380196	0	\N
2948	서울특별시 구로구 구로동로 84 서울특별시 구로구 구로동 807-15	2026-01-29 23:28:26.380546	37.48628409	126.885635	OFFICIAL	2026-01-29 23:28:26.380549	0	\N
2949	서울특별시 구로구 도림로 5 서울특별시 구로구 구로동 805-4	2026-01-29 23:28:26.380918	37.48522857	126.8862995	OFFICIAL	2026-01-29 23:28:26.380921	0	\N
2950	서울특별시 구로구 구로동로 70 서울특별시 구로구 구로동 805-22	2026-01-29 23:28:26.381272	37.48515115	126.8861846	OFFICIAL	2026-01-29 23:28:26.381275	0	\N
2951	서울특별시 구로구 도림로 57 서울특별시 구로구 구로동 766-207	2026-01-29 23:28:26.381612	37.48891958	126.8901495	OFFICIAL	2026-01-29 23:28:26.381614	0	\N
2952	서울특별시 구로구 디지털로31길 109 서울특별시 구로구 구로동 777-39	2026-01-29 23:28:26.381954	37.48734704	126.89033	OFFICIAL	2026-01-29 23:28:26.381957	0	\N
2953	서울특별시 구로구 디지털로33길 11 서울특별시 구로구 구로동 256-1	2026-01-29 23:28:26.382297	37.48570578	126.8955127	OFFICIAL	2026-01-29 23:28:26.3823	0	\N
2954	서울특별시 구로구 디지털로31길 61 서울특별시 구로구 구로동 197-12	2026-01-29 23:28:26.382638	37.48591087	126.891542	OFFICIAL	2026-01-29 23:28:26.382641	0	\N
2955	서울특별시 노원구 동일로 1456	2026-01-29 23:28:26.382985	37.66067691	127.0614956	OFFICIAL	2026-01-29 23:28:26.382987	0	\N
2956	서울특별시 구로구 디지털로27가길 17 서울특별시 구로구 구로동 197-30	2026-01-29 23:28:26.383325	37.48438754	126.8923345	OFFICIAL	2026-01-29 23:28:26.383327	0	\N
2957	서울특별시 구로구 시흥대로 563 서울특별시 구로구 구로동 1125-5	2026-01-29 23:28:26.383855	37.48339166	126.9014243	OFFICIAL	2026-01-29 23:28:26.383859	0	\N
2958	서울특별시 구로구 시흥대로 563 서울특별시 구로구 구로동 1125-5	2026-01-29 23:28:26.384306	37.48339166	126.9014243	OFFICIAL	2026-01-29 23:28:26.384309	0	\N
2959	서울특별시 구로구 시흥대로 563 서울특별시 구로구 구로동 1125-9	2026-01-29 23:28:26.384736	37.48339166	126.9014243	OFFICIAL	2026-01-29 23:28:26.384739	0	\N
2960	서울특별시 구로구 시흥대로 563 서울특별시 구로구 구로동 1125-9	2026-01-29 23:28:26.385158	37.48339166	126.9014243	OFFICIAL	2026-01-29 23:28:26.38516	0	\N
2961	서울특별시 구로구 디지털로32나길 51 서울특별시 구로구 구로동 1124-49	2026-01-29 23:28:26.385558	37.48490133	126.9003821	OFFICIAL	2026-01-29 23:28:26.38556	0	\N
2962	서울특별시 구로구 디지털로32나길 38 서울특별시 구로구 구로동 1124-42	2026-01-29 23:28:26.385955	37.48454459	126.9011985	OFFICIAL	2026-01-29 23:28:26.385957	0	\N
2963	서울특별시 구로구 디지털로32길 79 서울특별시 구로구 구로동 824	2026-01-29 23:28:26.38632	37.48353325	126.899752	OFFICIAL	2026-01-29 23:28:26.386322	0	\N
2964	서울특별시 구로구 디지털로32길 79 서울특별시 구로구 구로동 824	2026-01-29 23:28:26.386686	37.48353325	126.899752	OFFICIAL	2026-01-29 23:28:26.386688	0	\N
2965	서울특별시 구로구 디지털로32길 55 서울특별시 구로구 구로동 817	2026-01-29 23:28:26.387058	37.48398669	126.8983387	OFFICIAL	2026-01-29 23:28:26.38706	0	\N
2966	서울특별시 구로구 디지털로31길 120 서울특별시 구로구 구로동 1280	2026-01-29 23:28:26.387418	37.48847002	126.890773	OFFICIAL	2026-01-29 23:28:26.38742	0	\N
2967	서울특별시 구로구 디지털로26길 5 서울특별시 구로구 구로동 235-2	2026-01-29 23:28:26.387797	37.48161059	126.8934793	OFFICIAL	2026-01-29 23:28:26.387799	0	\N
2968	서울특별시 구로구 디지털로 319 서울특별시 구로구 구로동 1256	2026-01-29 23:28:26.388152	37.49003775	126.8954329	OFFICIAL	2026-01-29 23:28:26.388154	0	\N
2969	서울특별시 구로구 디지털로 292 서울특별시 구로구 구로동 188-11	2026-01-29 23:28:26.388502	37.48469365	126.8958922	OFFICIAL	2026-01-29 23:28:26.388504	0	\N
2970	서울특별시 구로구 디지털로 273 서울특별시 구로구 구로동 212-30	2026-01-29 23:28:26.38888	37.48395432	126.8941033	OFFICIAL	2026-01-29 23:28:26.388882	0	\N
2971	서울특별시 구로구 도림로 6 서울특별시 구로구 구로동 801-51	2026-01-29 23:28:26.389339	37.4851606	126.8867371	OFFICIAL	2026-01-29 23:28:26.389342	0	\N
2972	서울특별시 구로구 도림로 6 서울특별시 구로구 구로동 801-51	2026-01-29 23:28:26.389704	37.4851606	126.8867371	OFFICIAL	2026-01-29 23:28:26.389706	0	\N
2973	서울특별시 구로구 구로동로 203 서울특별시 구로구 구로동 481-7	2026-01-29 23:28:26.390077	37.49671859	126.8822699	OFFICIAL	2026-01-29 23:28:26.390079	0	\N
2974	서울특별시 구로구 구로동로 210 서울특별시 구로구 구로동 487-28	2026-01-29 23:28:26.390428	37.49721417	126.8826589	OFFICIAL	2026-01-29 23:28:26.390431	0	\N
2975	서울특별시 구로구 구로동로 170 서울특별시 구로구 구로동 416-7	2026-01-29 23:28:26.390799	37.49376116	126.883394	OFFICIAL	2026-01-29 23:28:26.390801	0	\N
2976	서울특별시 구로구 가마산로 205 서울특별시 구로구 구로동 426-69	2026-01-29 23:28:26.391142	37.49346137	126.884108	OFFICIAL	2026-01-29 23:28:26.391145	0	\N
2977	서울특별시 구로구 구로동로 219 서울특별시 구로구 구로동 486-55	2026-01-29 23:28:26.391482	37.49813373	126.8822071	OFFICIAL	2026-01-29 23:28:26.391484	0	\N
2978	서울특별시 구로구 구로동로 153 서울특별시 구로구 구로동 413-88	2026-01-29 23:28:26.391835	37.4923559	126.8834335	OFFICIAL	2026-01-29 23:28:26.391837	0	\N
2979	서울특별시 구로구 가마산로 245 서울특별시 구로구 구로동 436-1	2026-01-29 23:28:26.392186	37.49551123	126.8882891	OFFICIAL	2026-01-29 23:28:26.392188	0	\N
2980	서울특별시 구로구 구로동로 216 서울특별시 구로구 구로동 486-11	2026-01-29 23:28:26.39256	37.49784789	126.8827014	OFFICIAL	2026-01-29 23:28:26.392563	0	\N
2981	서울특별시 구로구 구로동로 173 서울특별시 구로구 구로동 415-3	2026-01-29 23:28:26.392938	37.49392402	126.8829027	OFFICIAL	2026-01-29 23:28:26.392941	0	\N
2982	서울특별시 구로구 가마산로 242 서울특별시 구로구 구로동 83	2026-01-29 23:28:26.393295	37.49436222	126.8876711	OFFICIAL	2026-01-29 23:28:26.393298	0	\N
2983	서울특별시 구로구 가마산로 218 서울특별시 구로구 구로동 80-24	2026-01-29 23:28:26.393684	37.49321551	126.8851411	OFFICIAL	2026-01-29 23:28:26.393686	0	\N
2984	서울특별시 노원구 동일로 1456	2026-01-29 23:28:26.394062	37.66067691	127.0614956	OFFICIAL	2026-01-29 23:28:26.394065	0	\N
2985	서울특별시 구로구 가마산로 242 서울특별시 구로구 구로동 83	2026-01-29 23:28:26.394418	37.49436222	126.8876711	OFFICIAL	2026-01-29 23:28:26.39442	0	\N
2986	서울특별시 구로구 구로동 635-4	2026-01-29 23:28:26.394836	37.49985843	126.8749308	OFFICIAL	2026-01-29 23:28:26.394838	0	\N
2987	서울특별시 구로구 구로동 635-4	2026-01-29 23:28:26.395201	37.49985843	126.8749308	OFFICIAL	2026-01-29 23:28:26.395204	0	\N
2988	서울특별시 구로구 구로동 635-4	2026-01-29 23:28:26.395556	37.49985843	126.8749308	OFFICIAL	2026-01-29 23:28:26.395559	0	\N
2989	서울특별시 구로구 구로동 635-4	2026-01-29 23:28:26.395936	37.49985843	126.8749308	OFFICIAL	2026-01-29 23:28:26.395939	0	\N
2990	서울특별시 구로구 가마산로 203 서울특별시 구로구 구로동 426-6	2026-01-29 23:28:26.396288	37.49340254	126.8837472	OFFICIAL	2026-01-29 23:28:26.396291	0	\N
2991	서울특별시 구로구 구로동로 107 서울특별시 구로구 구로동 721-14	2026-01-29 23:28:26.396651	37.48813556	126.8845201	OFFICIAL	2026-01-29 23:28:26.396654	0	\N
2992	서울특별시 구로구 구로동로 125-1 서울특별시 구로구 구로동 726-3	2026-01-29 23:28:26.397018	37.48982287	126.8840474	OFFICIAL	2026-01-29 23:28:26.397021	0	\N
2993	서울특별시 구로구 벚꽃로 484 서울특별시 구로구 구로동 476-134	2026-01-29 23:28:26.397375	37.49733165	126.8801354	OFFICIAL	2026-01-29 23:28:26.397377	0	\N
2994	서울특별시 구로구 가마산로9길 4-4 서울특별시 구로구 구로동 402-7	2026-01-29 23:28:26.397781	37.49154041	126.8816385	OFFICIAL	2026-01-29 23:28:26.397783	0	\N
2995	서울특별시 구로구 가마산로 222 서울특별시 구로구 구로동 80-4	2026-01-29 23:28:26.398145	37.49349581	126.8857884	OFFICIAL	2026-01-29 23:28:26.398147	0	\N
2996	서울특별시 구로구 가마산로 180-2 서울특별시 구로구 구로동 704-38	2026-01-29 23:28:26.398501	37.49168151	126.8822748	OFFICIAL	2026-01-29 23:28:26.398503	0	\N
2997	서울특별시 구로구 구로동로 174 서울특별시 구로구 구로동 416-1	2026-01-29 23:28:26.398868	37.49404864	126.8833646	OFFICIAL	2026-01-29 23:28:26.398871	0	\N
2998	서울특별시 구로구 구로동 490	2026-01-29 23:28:26.399209	37.498129	126.883412	OFFICIAL	2026-01-29 23:28:26.399211	0	\N
2999	서울특별시 구로구 구로동로 203 서울특별시 구로구 구로동 481-7	2026-01-29 23:28:26.399554	37.49671859	126.8822699	OFFICIAL	2026-01-29 23:28:26.399556	0	\N
3000	서울특별시 구로구 구로동로 179 서울특별시 구로구 구로동 461-7	2026-01-29 23:28:26.399955	37.49445292	126.8825421	OFFICIAL	2026-01-29 23:28:26.399958	0	\N
3001	서울특별시 구로구 경인로 518 서울특별시 구로구 구로동 636-1	2026-01-29 23:28:26.401367	37.50023921	126.8769102	OFFICIAL	2026-01-29 23:28:26.401371	0	\N
3002	서울특별시 구로구 경인로 557 서울특별시 구로구 구로동 606-4	2026-01-29 23:28:26.401872	37.50310865	126.8790091	OFFICIAL	2026-01-29 23:28:26.401875	0	\N
3003	서울특별시 구로구 경인로 565 서울특별시 구로구 구로동 604-19	2026-01-29 23:28:26.402317	37.50363988	126.8797139	OFFICIAL	2026-01-29 23:28:26.402319	0	\N
3004	서울특별시 구로구 구로동로 159 서울특별시 구로구 구로동 413-80	2026-01-29 23:28:26.40273	37.49273634	126.8832036	OFFICIAL	2026-01-29 23:28:26.402732	0	\N
3005	서울특별시 구로구 가마산로 206 서울특별시 구로구 구로동 426-92	2026-01-29 23:28:26.403131	37.49295531	126.8840437	OFFICIAL	2026-01-29 23:28:26.403134	0	\N
3006	서울특별시 구로구 구로동로 135 서울특별시 구로구 구로동 754-9	2026-01-29 23:28:26.40351	37.4906411	126.8837098	OFFICIAL	2026-01-29 23:28:26.403512	0	\N
3007	서울특별시 구로구 가마산로 250 서울특별시 구로구 구로동 83-4	2026-01-29 23:28:26.403903	37.49481403	126.8886765	OFFICIAL	2026-01-29 23:28:26.403905	0	\N
3008	서울특별시 구로구 가마산로 235 서울특별시 구로구 구로동 436-1	2026-01-29 23:28:26.404263	37.49453206	126.887015	OFFICIAL	2026-01-29 23:28:26.404266	0	\N
3009	서울특별시 구로구 가마산로 245 서울특별시 구로구 구로동 435	2026-01-29 23:28:26.404629	37.49551123	126.8882891	OFFICIAL	2026-01-29 23:28:26.404632	0	\N
3010	서울특별시 구로구 가마산로 245 서울특별시 구로구 구로동 435	2026-01-29 23:28:26.404987	37.49551123	126.8882891	OFFICIAL	2026-01-29 23:28:26.404989	0	\N
3011	서울특별시 구로구 구로동로 141 서울특별시 구로구 구로동 704-57	2026-01-29 23:28:26.405345	37.4913197	126.883399	OFFICIAL	2026-01-29 23:28:26.405347	0	\N
3012	서울특별시 구로구 구로중앙로 135-6 서울특별시 구로구 구로동 500-27	2026-01-29 23:28:26.405696	37.49995073	126.8828691	OFFICIAL	2026-01-29 23:28:26.405698	0	\N
\.


--
-- Data for Name: geocode_settings; Type: TABLE DATA; Schema: tiger; Owner: jupddang
--

COPY tiger.geocode_settings (name, setting, unit, category, short_desc) FROM stdin;
\.


--
-- Data for Name: pagc_gaz; Type: TABLE DATA; Schema: tiger; Owner: jupddang
--

COPY tiger.pagc_gaz (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_lex; Type: TABLE DATA; Schema: tiger; Owner: jupddang
--

COPY tiger.pagc_lex (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_rules; Type: TABLE DATA; Schema: tiger; Owner: jupddang
--

COPY tiger.pagc_rules (id, rule, is_custom) FROM stdin;
\.


--
-- Data for Name: topology; Type: TABLE DATA; Schema: topology; Owner: jupddang
--

COPY topology.topology (id, name, srid, "precision", hasz) FROM stdin;
\.


--
-- Data for Name: layer; Type: TABLE DATA; Schema: topology; Owner: jupddang
--

COPY topology.layer (topology_id, layer_id, schema_name, table_name, feature_column, feature_type, level, child_id) FROM stdin;
\.


--
-- Name: comment_comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.comment_comment_id_seq', 83, true);


--
-- Name: fcm_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.fcm_tokens_id_seq', 24, true);


--
-- Name: follow_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.follow_id_seq', 67, true);


--
-- Name: party_activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.party_activity_id_seq', 21, true);


--
-- Name: party_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.party_id_seq', 39, true);


--
-- Name: party_member_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.party_member_id_seq', 57, true);


--
-- Name: plogging_record_plogging_record_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.plogging_record_plogging_record_id_seq', 1, false);


--
-- Name: ploggings_plogging_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.ploggings_plogging_id_seq', 88, true);


--
-- Name: post_post_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.post_post_id_seq', 118, true);


--
-- Name: raid_boss_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.raid_boss_id_seq', 9, true);


--
-- Name: raid_record_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.raid_record_id_seq', 1, false);


--
-- Name: test_entity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.test_entity_id_seq', 1, false);


--
-- Name: trashcan_verifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.trashcan_verifications_id_seq', 3, true);


--
-- Name: trashcans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.trashcans_id_seq', 3015, true);


--
-- Name: topology_id_seq; Type: SEQUENCE SET; Schema: topology; Owner: jupddang
--

SELECT pg_catalog.setval('topology.topology_id_seq', 1, false);


--
-- Name: account account_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (user_id);


--
-- Name: comment comment_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_pkey PRIMARY KEY (comment_id);


--
-- Name: fcm_tokens fcm_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.fcm_tokens
    ADD CONSTRAINT fcm_tokens_pkey PRIMARY KEY (id);


--
-- Name: follow follow_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.follow
    ADD CONSTRAINT follow_pkey PRIMARY KEY (id);


--
-- Name: grids grids_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.grids
    ADD CONSTRAINT grids_pkey PRIMARY KEY (grid_id);


--
-- Name: party_activity party_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.party_activity
    ADD CONSTRAINT party_activity_pkey PRIMARY KEY (id);


--
-- Name: party_member party_member_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.party_member
    ADD CONSTRAINT party_member_pkey PRIMARY KEY (id);


--
-- Name: party party_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.party
    ADD CONSTRAINT party_pkey PRIMARY KEY (id);


--
-- Name: plogging_record plogging_record_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.plogging_record
    ADD CONSTRAINT plogging_record_pkey PRIMARY KEY (plogging_record_id);


--
-- Name: ploggings ploggings_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.ploggings
    ADD CONSTRAINT ploggings_pkey PRIMARY KEY (plogging_id);


--
-- Name: post post_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.post
    ADD CONSTRAINT post_pkey PRIMARY KEY (post_id);


--
-- Name: raid_boss raid_boss_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.raid_boss
    ADD CONSTRAINT raid_boss_pkey PRIMARY KEY (id);


--
-- Name: raid_record raid_record_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.raid_record
    ADD CONSTRAINT raid_record_pkey PRIMARY KEY (id);


--
-- Name: test_entity test_entity_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.test_entity
    ADD CONSTRAINT test_entity_pkey PRIMARY KEY (id);


--
-- Name: trashcan_verifications trashcan_verifications_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.trashcan_verifications
    ADD CONSTRAINT trashcan_verifications_pkey PRIMARY KEY (id);


--
-- Name: trashcans trashcans_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.trashcans
    ADD CONSTRAINT trashcans_pkey PRIMARY KEY (id);


--
-- Name: party_member uk9tdmmjuhq00j0cdvg8minjqa; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.party_member
    ADD CONSTRAINT uk9tdmmjuhq00j0cdvg8minjqa UNIQUE (party_id, user_id);


--
-- Name: raid_boss uk_d22bpw9rvi9dganwp8aarek4g; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.raid_boss
    ADD CONSTRAINT uk_d22bpw9rvi9dganwp8aarek4g UNIQUE (h3index);


--
-- Name: account uk_q0uja26qgu1atulenwup9rxyr; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT uk_q0uja26qgu1atulenwup9rxyr UNIQUE (email);


--
-- Name: party uk_q5m63raep7xcquqxh5dp0qibu; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.party
    ADD CONSTRAINT uk_q5m63raep7xcquqxh5dp0qibu UNIQUE (invite_code);


--
-- Name: fcm_tokens uk_qopjyk0c1cho2ep0abxd9hi5q; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.fcm_tokens
    ADD CONSTRAINT uk_qopjyk0c1cho2ep0abxd9hi5q UNIQUE (token);


--
-- Name: raid_record uk_raid_record_boss_account; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.raid_record
    ADD CONSTRAINT uk_raid_record_boss_account UNIQUE (boss_id, account_user_id);


--
-- Name: trashcan_verifications uk_trashcan_user; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.trashcan_verifications
    ADD CONSTRAINT uk_trashcan_user UNIQUE (trashcan_id, user_id);


--
-- Name: idx_latitude_longitude; Type: INDEX; Schema: public; Owner: jupddang
--

CREATE INDEX idx_latitude_longitude ON public.trashcans USING btree (latitude, longitude);


--
-- Name: idx_raid_ranking; Type: INDEX; Schema: public; Owner: jupddang
--

CREATE INDEX idx_raid_ranking ON public.raid_record USING btree (boss_id, total_score DESC, updated_at);


--
-- Name: idx_status; Type: INDEX; Schema: public; Owner: jupddang
--

CREATE INDEX idx_status ON public.trashcans USING btree (status);


--
-- Name: follow fk3p4y9ghyxbcl8n2egyxjx1k5e; Type: FK CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.follow
    ADD CONSTRAINT fk3p4y9ghyxbcl8n2egyxjx1k5e FOREIGN KEY (following_id) REFERENCES public.account(user_id);


--
-- Name: ploggings fk3sdl8kvtfbwqibdm2y51bycx4; Type: FK CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.ploggings
    ADD CONSTRAINT fk3sdl8kvtfbwqibdm2y51bycx4 FOREIGN KEY (user_id) REFERENCES public.account(user_id);


--
-- Name: post fk4f62kobdc0890vctu2jq5tcvq; Type: FK CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.post
    ADD CONSTRAINT fk4f62kobdc0890vctu2jq5tcvq FOREIGN KEY (user_id) REFERENCES public.account(user_id);


--
-- Name: trashcan_verifications fkcdyy7twpvrhnxx71mk7392asp; Type: FK CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.trashcan_verifications
    ADD CONSTRAINT fkcdyy7twpvrhnxx71mk7392asp FOREIGN KEY (user_id) REFERENCES public.account(user_id);


--
-- Name: trashcan_verifications fkcnyr6g39byi8gdh3dpcynaw7k; Type: FK CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.trashcan_verifications
    ADD CONSTRAINT fkcnyr6g39byi8gdh3dpcynaw7k FOREIGN KEY (trashcan_id) REFERENCES public.trashcans(id);


--
-- Name: party_member fkctrpcp93h130dwe6j1jlhf960; Type: FK CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.party_member
    ADD CONSTRAINT fkctrpcp93h130dwe6j1jlhf960 FOREIGN KEY (party_id) REFERENCES public.party(id);


--
-- Name: raid_record fkepptotytcciu9ip3c2swtqmfr; Type: FK CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.raid_record
    ADD CONSTRAINT fkepptotytcciu9ip3c2swtqmfr FOREIGN KEY (boss_id) REFERENCES public.raid_boss(id);


--
-- Name: party_activity fkke7lvro2nvqtduc27ihw8e2jx; Type: FK CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.party_activity
    ADD CONSTRAINT fkke7lvro2nvqtduc27ihw8e2jx FOREIGN KEY (plogging_id) REFERENCES public.ploggings(plogging_id);


--
-- Name: raid_record fkmwi3hkdp7btd08ao7siy7rfnt; Type: FK CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.raid_record
    ADD CONSTRAINT fkmwi3hkdp7btd08ao7siy7rfnt FOREIGN KEY (account_user_id) REFERENCES public.account(user_id);


--
-- Name: comment fkn84216vj612qs1eg5goe6n2lj; Type: FK CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT fkn84216vj612qs1eg5goe6n2lj FOREIGN KEY (user_id) REFERENCES public.account(user_id);


--
-- Name: follow fkr2kqnskllhun8dgwitqljvdyh; Type: FK CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.follow
    ADD CONSTRAINT fkr2kqnskllhun8dgwitqljvdyh FOREIGN KEY (follower_id) REFERENCES public.account(user_id);


--
-- Name: comment fks1slvnkuemjsq2kj4h3vhx7i1; Type: FK CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT fks1slvnkuemjsq2kj4h3vhx7i1 FOREIGN KEY (post_id) REFERENCES public.post(post_id);


--
-- Name: trashcans fktpgel6y6xhf1gr2jl2dq97e0g; Type: FK CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.trashcans
    ADD CONSTRAINT fktpgel6y6xhf1gr2jl2dq97e0g FOREIGN KEY (reported_by) REFERENCES public.account(user_id);


--
-- PostgreSQL database dump complete
--

--
-- Database "jupddang_dev" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8 (Debian 15.8-1.pgdg110+1)
-- Dumped by pg_dump version 15.8 (Debian 15.8-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: jupddang_dev; Type: DATABASE; Schema: -; Owner: jupddang
--

CREATE DATABASE jupddang_dev WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C';


ALTER DATABASE jupddang_dev OWNER TO jupddang;

\connect jupddang_dev

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: jupddang_dev; Type: DATABASE PROPERTIES; Schema: -; Owner: jupddang
--

ALTER DATABASE jupddang_dev SET search_path TO '$user', 'public', 'topology', 'tiger';


\connect jupddang_dev

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: jupddang
--

CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO jupddang;

--
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: jupddang
--

CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO jupddang;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: jupddang
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO jupddang;

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: jupddang
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- Name: postgis_tiger_geocoder; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder WITH SCHEMA tiger;


--
-- Name: EXTENSION postgis_tiger_geocoder; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_tiger_geocoder IS 'PostGIS tiger geocoder and reverse geocoder';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.account (
    user_id character varying(50) NOT NULL,
    color character varying(255),
    created_at timestamp(6) without time zone NOT NULL,
    email character varying(255) NOT NULL,
    intro character varying(255) NOT NULL,
    nickname character varying(255) NOT NULL,
    profile_image character varying(255) NOT NULL,
    pw character varying(255) NOT NULL,
    tier character varying(255) NOT NULL,
    total_distance double precision NOT NULL,
    total_score bigint NOT NULL,
    total_time integer NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.account OWNER TO jupddang;

--
-- Name: comment; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.comment (
    comment_id bigint NOT NULL,
    content text,
    created_at timestamp(6) without time zone,
    user_id character varying(50),
    post_id bigint
);


ALTER TABLE public.comment OWNER TO jupddang;

--
-- Name: comment_comment_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.comment_comment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comment_comment_id_seq OWNER TO jupddang;

--
-- Name: comment_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.comment_comment_id_seq OWNED BY public.comment.comment_id;


--
-- Name: fcm_tokens; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.fcm_tokens (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    device_type character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.fcm_tokens OWNER TO jupddang;

--
-- Name: fcm_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.fcm_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fcm_tokens_id_seq OWNER TO jupddang;

--
-- Name: fcm_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.fcm_tokens_id_seq OWNED BY public.fcm_tokens.id;


--
-- Name: follow; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.follow (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    follower_id character varying(50) NOT NULL,
    following_id character varying(50) NOT NULL
);


ALTER TABLE public.follow OWNER TO jupddang;

--
-- Name: follow_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.follow_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.follow_id_seq OWNER TO jupddang;

--
-- Name: follow_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.follow_id_seq OWNED BY public.follow.id;


--
-- Name: grids; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.grids (
    grid_id character varying(255) NOT NULL,
    occupied_at timestamp(6) without time zone NOT NULL,
    party_id bigint,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.grids OWNER TO jupddang;

--
-- Name: party; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.party (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    ended_at timestamp(6) without time zone,
    invite_code character varying(6) NOT NULL,
    leader_id character varying(50) NOT NULL,
    max_members integer NOT NULL,
    name character varying(100),
    started_at timestamp(6) without time zone,
    status character varying(255) NOT NULL,
    total_distance double precision,
    total_score integer,
    total_time integer,
    CONSTRAINT party_status_check CHECK (((status)::text = ANY ((ARRAY['WAITING'::character varying, 'IN_PROGRESS'::character varying, 'COMPLETED'::character varying])::text[])))
);


ALTER TABLE public.party OWNER TO jupddang;

--
-- Name: party_activity; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.party_activity (
    id bigint NOT NULL,
    distance double precision,
    ended_at timestamp(6) without time zone,
    party_id bigint NOT NULL,
    started_at timestamp(6) without time zone NOT NULL,
    status character varying(255) NOT NULL,
    trash_count integer,
    user_id character varying(50) NOT NULL,
    plogging_id bigint,
    CONSTRAINT party_activity_status_check CHECK (((status)::text = ANY ((ARRAY['IN_PROGRESS'::character varying, 'COMPLETED'::character varying, 'ABANDONED'::character varying])::text[])))
);


ALTER TABLE public.party_activity OWNER TO jupddang;

--
-- Name: party_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.party_activity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.party_activity_id_seq OWNER TO jupddang;

--
-- Name: party_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.party_activity_id_seq OWNED BY public.party_activity.id;


--
-- Name: party_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.party_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.party_id_seq OWNER TO jupddang;

--
-- Name: party_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.party_id_seq OWNED BY public.party.id;


--
-- Name: party_member; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.party_member (
    id bigint NOT NULL,
    joined_at timestamp(6) without time zone NOT NULL,
    user_id character varying(50) NOT NULL,
    party_id bigint NOT NULL
);


ALTER TABLE public.party_member OWNER TO jupddang;

--
-- Name: party_member_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.party_member_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.party_member_id_seq OWNER TO jupddang;

--
-- Name: party_member_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.party_member_id_seq OWNED BY public.party_member.id;


--
-- Name: plogging_record; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.plogging_record (
    plogging_record_id bigint NOT NULL
);


ALTER TABLE public.plogging_record OWNER TO jupddang;

--
-- Name: plogging_record_plogging_record_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.plogging_record_plogging_record_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.plogging_record_plogging_record_id_seq OWNER TO jupddang;

--
-- Name: plogging_record_plogging_record_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.plogging_record_plogging_record_id_seq OWNED BY public.plogging_record.plogging_record_id;


--
-- Name: ploggings; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.ploggings (
    plogging_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    distance double precision,
    score integer NOT NULL,
    times integer,
    user_id character varying(50),
    after_image_url character varying(255),
    before_image_url character varying(255),
    content text,
    map_image_url character varying(255),
    record_name character varying(255),
    status character varying(255) DEFAULT 'USED'::character varying
);


ALTER TABLE public.ploggings OWNER TO jupddang;

--
-- Name: ploggings_plogging_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.ploggings_plogging_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ploggings_plogging_id_seq OWNER TO jupddang;

--
-- Name: ploggings_plogging_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.ploggings_plogging_id_seq OWNED BY public.ploggings.plogging_id;


--
-- Name: post; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.post (
    post_id bigint NOT NULL,
    after_image_url character varying(500),
    before_image_url character varying(500),
    content text,
    created_at timestamp(6) without time zone,
    like_cnt integer,
    map_image_url character varying(500),
    plogging_id bigint,
    updated_at timestamp(6) without time zone,
    user_id character varying(50)
);


ALTER TABLE public.post OWNER TO jupddang;

--
-- Name: post_post_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.post_post_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.post_post_id_seq OWNER TO jupddang;

--
-- Name: post_post_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.post_post_id_seq OWNED BY public.post.post_id;


--
-- Name: raid_boss; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.raid_boss (
    id bigint NOT NULL,
    h3index character varying(255) NOT NULL,
    name character varying(255),
    boss_type integer DEFAULT 0
);


ALTER TABLE public.raid_boss OWNER TO jupddang;

--
-- Name: raid_boss_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.raid_boss_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.raid_boss_id_seq OWNER TO jupddang;

--
-- Name: raid_boss_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.raid_boss_id_seq OWNED BY public.raid_boss.id;


--
-- Name: raid_record; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.raid_record (
    id bigint NOT NULL,
    total_score bigint NOT NULL,
    updated_at timestamp(6) without time zone,
    account_user_id character varying(50) NOT NULL,
    boss_id bigint NOT NULL
);


ALTER TABLE public.raid_record OWNER TO jupddang;

--
-- Name: raid_record_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.raid_record_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.raid_record_id_seq OWNER TO jupddang;

--
-- Name: raid_record_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.raid_record_id_seq OWNED BY public.raid_record.id;


--
-- Name: test_entity; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.test_entity (
    id bigint NOT NULL,
    content character varying(255)
);


ALTER TABLE public.test_entity OWNER TO jupddang;

--
-- Name: test_entity_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.test_entity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.test_entity_id_seq OWNER TO jupddang;

--
-- Name: test_entity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.test_entity_id_seq OWNED BY public.test_entity.id;


--
-- Name: trashcan_verifications; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.trashcan_verifications (
    id bigint NOT NULL,
    verified_at timestamp(6) without time zone NOT NULL,
    trashcan_id bigint NOT NULL,
    user_id character varying(50) NOT NULL
);


ALTER TABLE public.trashcan_verifications OWNER TO jupddang;

--
-- Name: trashcan_verifications_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.trashcan_verifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trashcan_verifications_id_seq OWNER TO jupddang;

--
-- Name: trashcan_verifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.trashcan_verifications_id_seq OWNED BY public.trashcan_verifications.id;


--
-- Name: trashcans; Type: TABLE; Schema: public; Owner: jupddang
--

CREATE TABLE public.trashcans (
    id bigint NOT NULL,
    address character varying(500),
    created_at timestamp(6) without time zone NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    status character varying(20) NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    verification_count integer NOT NULL,
    reported_by character varying(50),
    CONSTRAINT trashcans_status_check CHECK (((status)::text = ANY ((ARRAY['OFFICIAL'::character varying, 'PENDING'::character varying, 'VERIFIED'::character varying])::text[])))
);


ALTER TABLE public.trashcans OWNER TO jupddang;

--
-- Name: trashcans_id_seq; Type: SEQUENCE; Schema: public; Owner: jupddang
--

CREATE SEQUENCE public.trashcans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trashcans_id_seq OWNER TO jupddang;

--
-- Name: trashcans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jupddang
--

ALTER SEQUENCE public.trashcans_id_seq OWNED BY public.trashcans.id;


--
-- Name: comment comment_id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.comment ALTER COLUMN comment_id SET DEFAULT nextval('public.comment_comment_id_seq'::regclass);


--
-- Name: fcm_tokens id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.fcm_tokens ALTER COLUMN id SET DEFAULT nextval('public.fcm_tokens_id_seq'::regclass);


--
-- Name: follow id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.follow ALTER COLUMN id SET DEFAULT nextval('public.follow_id_seq'::regclass);


--
-- Name: party id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.party ALTER COLUMN id SET DEFAULT nextval('public.party_id_seq'::regclass);


--
-- Name: party_activity id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.party_activity ALTER COLUMN id SET DEFAULT nextval('public.party_activity_id_seq'::regclass);


--
-- Name: party_member id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.party_member ALTER COLUMN id SET DEFAULT nextval('public.party_member_id_seq'::regclass);


--
-- Name: plogging_record plogging_record_id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.plogging_record ALTER COLUMN plogging_record_id SET DEFAULT nextval('public.plogging_record_plogging_record_id_seq'::regclass);


--
-- Name: ploggings plogging_id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.ploggings ALTER COLUMN plogging_id SET DEFAULT nextval('public.ploggings_plogging_id_seq'::regclass);


--
-- Name: post post_id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.post ALTER COLUMN post_id SET DEFAULT nextval('public.post_post_id_seq'::regclass);


--
-- Name: raid_boss id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.raid_boss ALTER COLUMN id SET DEFAULT nextval('public.raid_boss_id_seq'::regclass);


--
-- Name: raid_record id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.raid_record ALTER COLUMN id SET DEFAULT nextval('public.raid_record_id_seq'::regclass);


--
-- Name: test_entity id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.test_entity ALTER COLUMN id SET DEFAULT nextval('public.test_entity_id_seq'::regclass);


--
-- Name: trashcan_verifications id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.trashcan_verifications ALTER COLUMN id SET DEFAULT nextval('public.trashcan_verifications_id_seq'::regclass);


--
-- Name: trashcans id; Type: DEFAULT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.trashcans ALTER COLUMN id SET DEFAULT nextval('public.trashcans_id_seq'::regclass);


--
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.account (user_id, color, created_at, email, intro, nickname, profile_image, pw, tier, total_distance, total_score, total_time, updated_at) FROM stdin;
test2	#111111	2026-01-29 16:43:11.33638	test2@test.com	안녕하세요!	test	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$pynPdZrJ20aQGio54nX0NOAkMNxbasDIMtQDq2tsI7nXSnmnhICnG	Bronze 5	0	0	0	2026-01-29 16:43:11.33638
ssafy1	string	2026-01-30 10:24:23.716314	string	안녕하세요!	string	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$0njihrxEqN0nrXfMy3Jj1O/wMJGfqMLdB57/mFdzJi2sf2.L9WeSi	Bronze 5	0	0	0	2026-01-30 10:24:23.716314
testuser1	#FFFFFF	2026-01-30 12:46:24.565976	testuser1@example.com	안녕하세요!	닉네임_testuser1	https://storage.googleapis.com/jupddang-images/default/default-profile.png	password	Bronze 5	0	0	0	2026-01-30 12:46:24.565976
testuser2	#FFFFFF	2026-01-30 12:46:24.576527	testuser2@example.com	안녕하세요!	닉네임_testuser2	https://storage.googleapis.com/jupddang-images/default/default-profile.png	password	Bronze 5	0	0	0	2026-01-30 12:46:24.576527
testuser3	#FFFFFF	2026-01-30 12:46:24.578911	testuser3@example.com	안녕하세요!	닉네임_testuser3	https://storage.googleapis.com/jupddang-images/default/default-profile.png	password	Bronze 5	0	0	0	2026-01-30 12:46:24.578911
testuser4	#FFFFFF	2026-01-30 12:46:24.581053	testuser4@example.com	안녕하세요!	닉네임_testuser4	https://storage.googleapis.com/jupddang-images/default/default-profile.png	password	Bronze 5	0	0	0	2026-01-30 12:46:24.581053
testuser5	#FFFFFF	2026-01-30 12:46:24.583021	testuser5@example.com	안녕하세요!	닉네임_testuser5	https://storage.googleapis.com/jupddang-images/default/default-profile.png	password	Bronze 5	0	0	0	2026-01-30 12:46:24.583021
ranker3	#FFFF00	2026-02-01 11:35:18.243391	rank3@test.com	다 주워버리겠다	쓰레기사냥	https://storage.googleapis.com/jupddang-images/profile/b477e139-4e16-4d31-89a8-8415f6836024_scaled_36.webp	$2a$10$9t11L9sfrN.LSv4vxj8HUOX727dJXQoHmkUrIXKMFO4H0xgX2cNHC	Silver 4	280	6000	4000	2026-02-08 23:37:24.157199
ranker1	#4DD0E1	2026-02-01 11:35:18.243391	rank1123@test.com	1등 껌이던데ㅎㅋ	랭커1	https://storage.googleapis.com/jupddang-images/profile/ab271aa8-d3a1-4f1b-831d-55cde4063103_scaled_33.webp	$2a$10$2GBQrkO1RZZi3rhoyrE6SuPobk9eyi3RiQYOt8lowIoMwCRNa6u6i	Gold 4	820.5	12200	5008	2026-02-08 01:55:48.793625
ssafy2	FFFFF	2026-01-30 14:54:05.83362	string@gmail.com	안녕하세요!	진우님	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$/4g585WoofLjji35iMM77uPl3.298oMsiwGghcaollFfNvqgB0G82	Bronze 5	0	0	5	2026-01-30 15:00:09.303204
2	2	2026-01-30 17:46:36.447236	2	안녕하세요!	2	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$k6gB2npybGL9Zog7/7qMC./fy3GFuoYZ.ru8TMi6zAWNo2TrFVX9m	Bronze 5	0	0	0	2026-01-30 17:46:36.447236
3	3	2026-01-30 17:46:45.908557	3	안녕하세요!	3	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$uXx3IjlWD1xOJioZ0nQ8jeIh7U.jAQ4l6UBhAhh/7M05gioIUCaoG	Bronze 5	0	0	0	2026-01-30 17:46:45.908557
4	4	2026-01-30 17:46:54.435252	4	안녕하세요!	4	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$4MLNIz33FoV8aJ0HI9ejPOioWEu4Y52nSYrFYcyKtd.u/iY7Den.q	Bronze 5	0	0	0	2026-01-30 17:46:54.435252
5	5	2026-01-30 17:47:11.856173	5	안녕하세요!	5	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$w91gX0QyV6ljAoh0t7azb.QWM2dgsTEXqwV7ieZl0bHmFJkWlRPWa	Bronze 5	0	0	0	2026-01-30 17:47:11.856173
1	1	2026-01-30 17:46:23.20687	1	안녕하세요!	1	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$9t11L9sfrN.LSv4vxj8HUOX727dJXQoHmkUrIXKMFO4H0xgX2cNHC	Bronze 5	0	0	15	2026-01-31 13:01:54.330704
ranker2	#FFA500	2026-02-01 11:35:18.243391	rank2@test.com	안녕하세요	줍땅고수	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$9t11L9sfrN.LSv4vxj8HUOX727dJXQoHmkUrIXKMFO4H0xgX2cNHC	Silver 3	390.2	7500	4500	2026-02-07 17:19:57.071964
signup	#111111	2026-02-01 18:58:55.410286	signup@test	안녕하세요!	whaa	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$PvnaKDww82I24Z76jrZzmeumH1ez/Kt3ZLDB2hY4h3QLuuInidHBS	Bronze 5	0	0	0	2026-02-01 18:58:55.410286
elena	#111111	2026-02-01 19:00:35.380925	elenakim1224@gmail.com	안녕하세요!	nickname	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$H.EMB30gGQpPTLOk0Rh0eeKNMk9z7tDl9s7VCtoKO2RX3oRJP3woO	Bronze 5	0	0	0	2026-02-01 19:00:35.380925
test6	#111111	2026-02-01 19:20:20.959551	lulu@nate.com	안녕하세요!	nick	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$pbWC23UWq7dWD42WncqIxusXGNBpYudW2bsvJJ2WGaiNEKExdbcKu	Bronze 5	0	0	0	2026-02-01 19:20:20.959551
test7	#111111	2026-02-01 19:24:47.881194	test7@gmail.com	안녕하세요!	nick	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$4/PjZo6.1kgAdKDi/vqizOXhGVi6b7dyTJxF2sEZ5yIijLpSsoLy.	Bronze 5	0	0	0	2026-02-01 19:24:47.881194
6	#111111	2026-02-01 19:55:02.666676	6@.com	안녕하세요!	6	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$yHiXqQA6Ky82SHv.zsYXOuLzWJ6w68stjIumZAvv.MAjI7CqhDaUG	Bronze 5	0	0	0	2026-02-01 19:55:02.666676
7	#111111	2026-02-01 20:25:46.588655	7@.com	안녕하세요!	7	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$HEsP0OT3ilHpN3uDHN6OjuRfQ7EztrJcHKim11e8qqUXFy5dx5yBa	Bronze 5	0	0	0	2026-02-01 20:25:46.588655
ssafy	FFFFFF	2026-01-30 06:30:20.774483	ssafy@ssafy.com	안녕하세요!	컨코치님	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$1tiGT3ODiB.NUqjfwMeTZeb2K1fHIDPS5K7AJsljw8uBJxYmGZuVy	Bronze 5	0.001	0	120	2026-02-06 15:13:52.355866
ranker4	#008000	2026-02-01 11:35:18.243391	rank4@test.com	지구가 아파요	환경지킴이	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$9t11L9sfrN.LSv4vxj8HUOX727dJXQoHmkUrIXKMFO4H0xgX2cNHC	Bronze 1	170	4500	3500	2026-02-07 17:19:57.072367
test	#1E88E5	2026-01-29 16:42:36.259738	test@test.com	플로깅 좋아합니다!	hihi	https://storage.googleapis.com/jupddang-images/profile/6f811271-a1ed-4379-8824-11fa63cfaeea_scaled_61.webp	$2a$10$SIGHni3FnCH3FY0E7waMqe3MXaZEzxKMQe8B4wK.HC0/w/.nMVuK6	Bronze 5	0.207	10	633	2026-02-06 16:30:20.508709
user5	0xFF46A140	2026-02-07 20:41:32.586942	user5@naver.com	안녕하세요!	플로깅 초보	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$BlRoXSpEgVmsQmhRhRbOT.ZO2jh/8hdR6wSH.OcNdoU8hRWmulNpW	Bronze 5	0.348	11	493	2026-02-08 21:50:02.486413
komae	#00897B	2026-02-06 16:50:16.774592	kem4378@naver.com	안녕하세요!	komae	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$mSqS0dW4SjkxmuhGQdsoSu8SeYK9QQQU91yeVXcT6rfYm4MC/uPVW	Bronze 5	0.756	70	3376	2026-02-09 00:06:46.048005
kky	0xFF46A140	2026-02-07 23:49:52.566864	kky@test.com	안녕하세요!	kimkang	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$nMiI6fnIm.W1FQmk3TGYEuhVZ9y29amlpW0R00twnpQK7s.FGA0ee	Bronze 5	0	0	0	2026-02-07 23:49:52.566864
user1	0xFF46A140	2026-02-07 20:32:59.379539	user1@naver.com	안녕하세요!	오늘도줍깅	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$GzYO69ZOQmz95uI5mqPJb.LuI/jqciUqOVzIgCkjHkcA5GiVVui.6	Bronze 5	0.291	13	737	2026-02-08 21:54:09.370205
user2	0xFF46A140	2026-02-07 20:35:31.621697	user2@naver.com	안녕하세요!	걷고줍고뛰고	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$9sYIa8jJa46UuVrOfV4Cf.HQgqILqa9x/rP0TnsKebtcp6B6oNTtO	Bronze 5	0.22799999999999998	10	585	2026-02-08 21:59:23.596695
ranker7	#DB5FBD	2026-02-01 11:35:18.243391	rank7@test.com	아침 공기 상쾌	새벽러너	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$9t11L9sfrN.LSv4vxj8HUOX727dJXQoHmkUrIXKMFO4H0xgX2cNHC	Silver 1	790	9500	2000	2026-02-08 00:38:16.605362
ssafy4	0xFF46A140	2026-02-06 10:54:36.064306	ssafy4@naver.com	안녕하세요!	김싸피4	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$OsOk.xt97VBb3e10QJ5arO/gTV/929SX.G5XJ6HsSUCD3tWElM0Z.	Bronze 5	0	0	371	2026-02-06 17:41:14.737127
ranker11	#FFFFFF	2026-02-07 03:41:58.868595	ranker10@test.com	안녕하세요!	안녕하세요!	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$Wl4TSx7KEA9v60H7Y5OsZukNOyQZCVUAW9Ao89onGjfrxlT.973q2	Bronze 5	0	0	0	2026-02-07 03:41:58.868595
ranker8	#FFFFFF	2026-02-01 11:35:18.243391	rank8@test.com	평일은 바빠요	주말러	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$9t11L9sfrN.LSv4vxj8HUOX727dJXQoHmkUrIXKMFO4H0xgX2cNHC	Bronze 4	60	1800	1500	2026-02-07 17:19:57.072968
ranker9	#000000	2026-02-01 11:35:18.243391	rank9@test.com	잘 부탁드려요	뉴비입니다	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$9t11L9sfrN.LSv4vxj8HUOX727dJXQoHmkUrIXKMFO4H0xgX2cNHC	Bronze 4	40	1200	1000	2026-02-07 17:19:57.073152
ranker10	#808080	2026-02-01 11:35:18.243391	rank10@test.com	언젠간 1등	꼴찌탈출	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$9t11L9sfrN.LSv4vxj8HUOX727dJXQoHmkUrIXKMFO4H0xgX2cNHC	Bronze 5	20	600	500	2026-02-07 17:19:57.073305
ranker6	#FFFFFF	2026-02-01 11:35:18.243391	rank6@test.com	플로깅 좋아합니다!	ranker6	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$9t11L9sfrN.LSv4vxj8HUOX727dJXQoHmkUrIXKMFO4H0xgX2cNHC	Bronze 3	90	2900	2500	2026-02-07 17:19:57.073459
멋쟁이토마토	0xFF46A140	2026-02-06 16:47:02.228181	dmdm0601@naver.com	안녕하세요!	멋쟁이토마토	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$bw8WI/no65IlB8LoQxxBCe5PJwzTFJIjWGoF0icvNrVhInQ0ybyLy	Bronze 5	0	0	0	2026-02-06 16:47:02.228181
test_agent_007	#00FF00	2026-02-08 18:37:45.104166	agent007@test.com	안녕하세요!	Agent007	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$k89VE9qoPAVlernrh6sz2OEhIVcwxbYy6U4fo410MI.cXEyAJBItm	Bronze 5	0	0	0	2026-02-08 18:37:45.104166
ranker5	#FFFFFF	2026-02-01 11:35:18.243391	rank5@test.com	플로깅 좋아합니다!	ranker5	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$9t11L9sfrN.LSv4vxj8HUOX727dJXQoHmkUrIXKMFO4H0xgX2cNHC	Silver 1	660	9000	3000	2026-02-07 17:19:57.073782
user3	0xFF46A140	2026-02-07 20:36:51.311462	user3@naver.com	안녕하세요!	주로밤에합니다	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$LE1uqpWTWb.9RHphIqQEn.xgnsFmKqhyNzYHbPEUowAV7W3pXuTTa	Bronze 5	0.194	9	584	2026-02-08 22:05:20.143878
user4	0xFF46A140	2026-02-07 20:37:42.329052	user4@naver.com	안녕하세요!	초록발걸음	https://storage.googleapis.com/jupddang-images/default/default-profile.png	$2a$10$7mz1d/eL945o5FayriSWp.HGT6d0Pb5L7tZaPejFDkiWVPcJL39uy	Bronze 5	0.685	28	1369	2026-02-08 22:17:05.891024
\.


--
-- Data for Name: comment; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.comment (comment_id, content, created_at, user_id, post_id) FROM stdin;
3	야야	2026-01-30 15:19:56.474329	ssafy	3
5	1의 댓글	2026-01-30 17:51:54.452659	1	9
9	asdf	2026-01-30 22:00:11.253269	1	13
12	fffasasdfasdfasdf	2026-01-30 22:02:32.097354	1	13
15	evevevev	2026-01-30 22:10:22.763727	1	9
16	ggg	2026-01-30 22:13:04.207629	1	9
22	zezebal	2026-01-30 22:25:13.97574	1	13
28	ok?	2026-01-30 22:34:36.932893	1	13
29	oh no..	2026-01-30 22:34:44.995595	1	13
30	whyrano...	2026-01-30 22:35:00.993033	1	13
32	??????	2026-01-30 22:38:00.492888	1	13
34	ohohoh	2026-01-30 22:47:09.93116	1	13
35	ohyeahyeah	2026-01-30 22:47:22.952304	1	13
36	wow	2026-01-30 22:47:30.105221	1	13
37	hi	2026-01-30 22:49:38.280065	1	13
38	bye	2026-01-30 23:21:15.551447	1	13
41	동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리나라 만세 무궁화 삼천리 화려강산 대한사람 대한으로 길이 보전하세	2026-01-30 23:26:21.098875	1	13
42	동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리나라 만세 무궁화 삼천리 화려강산 대한사람 대한으로 길이 보전하세	2026-01-30 23:26:38.700369	1	9
43	대한민국 만세~	2026-01-30 23:42:14.568211	1	13
44	누구세욤	2026-01-30 23:47:19.761845	1	11
45	댓글창 바꿔봤는데 어때욤	2026-01-30 23:48:01.386088	1	11
47	😆😆	2026-01-30 23:49:09.07929	1	11
48	(⁠.⁠ ⁠❛⁠ ⁠ᴗ⁠ ⁠❛⁠.⁠)✧⁠*⁠。	2026-01-30 23:50:01.92474	1	10
49	아 푸쉬 안해서 아직 뭐가 바꼈는지 모르겠구나 우하핫	2026-01-30 23:52:20.974153	1	11
54	오예	2026-02-03 19:45:56.229076	ranker1	61
55	쓰레기줍당	2026-02-03 19:46:11.484024	ranker1	59
56	깔끔해요	2026-02-03 19:46:32.190439	ranker1	58
57	asdf	2026-02-04 09:44:02.299917	ranker3	50
58	fff	2026-02-04 09:44:10.912574	ranker3	61
59	zebal	2026-02-05 02:37:11.417862	ranker9	64
60	gogogo	2026-02-05 02:37:26.562092	ranker9	61
72	ddd	2026-02-06 15:44:44.266785	test	87
73	퓨왕	2026-02-06 16:27:37.406674	ssafy4	93
74	hihi~~	2026-02-07 18:34:11.431345	ranker3	100
76	환경지킴이 ㅎㅇ	2026-02-07 19:50:12.824687	ranker1	51
77	ㅋㅋㅋㅋㅋㅋㅋㅋㅋ최고!!!!!	2026-02-07 21:58:43.511335	ranker1	105
78	hello	2026-02-07 22:20:51.568442	ranker1	61
79	최고!!!!	2026-02-08 00:29:02.959502	ranker1	106
80	우왕굳	2026-02-08 00:40:21.973174	ranker7	106
81	good	2026-02-08 15:36:44.946043	ranker1	108
82	asdf	2026-02-08 22:02:23.220617	ranker1	50
83	good	2026-02-08 22:53:42.645109	user1	116
\.


--
-- Data for Name: fcm_tokens; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.fcm_tokens (id, created_at, device_type, token, updated_at, user_id) FROM stdin;
30	2026-02-09 00:17:50.273031	android	cHpG644ISJelQ_JHllqW0J:APA91bGIahZGIRGwtOOonam7_X5tAnnI8dzHO3wk0-JCKxOJMU0_xPp9lrHIygHg2we9wIfLWzl97UpONAGWCP_wCfJDa-jUt5oqBkQMYsDAaOfL60-RDlQ	2026-02-09 00:17:50.273031	user1
34	2026-02-09 00:25:51.900931	android	e4a09tRhTZKZUuopxq29fe:APA91bFHgA8IQ0ex3n8e6Jb3MeTD73zbLrJ2LL6F9HCXoNC64vnA1dSKGRC4lOGh8ZC9AverX_ewLXBVXnvI6e9t1M-bVNvWOjxZPmc4ldJQl3U2oZ70Wyw	2026-02-09 00:25:51.900931	ranker1
39	2026-02-09 00:31:38.90526	android	d6t_hLtsTo2sQWv8YJqkot:APA91bGgm7WRfv6tNtYqTWYbS3ixLdpjz6BIsbMGzm9Qw3X9Dh-pc4qZiqDHS3Ro2X6ElkExCXDvw3VO8Nu3_8f5Htpe6yjLKJ7IzxlItHdgM1BRCwiszZg	2026-02-09 00:31:38.90526	test
\.


--
-- Data for Name: follow; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.follow (id, created_at, follower_id, following_id) FROM stdin;
2	2026-01-30 17:40:56.590773	ssafy	ssafy2
6	2026-01-30 23:38:10.87246	2	3
7	2026-01-30 23:38:14.972712	2	4
8	2026-01-30 23:38:26.524871	2	1
28	2026-02-01 16:18:03.006732	1	5
29	2026-02-01 16:18:07.573467	1	3
31	2026-02-03 16:25:30.343733	ranker1	ranker3
32	2026-02-03 16:25:35.150168	ranker1	ranker4
33	2026-02-03 20:00:45.021298	ranker2	ranker1
48	2026-02-04 01:36:11.84667	ranker5	ranker10
50	2026-02-04 09:38:57.716445	ranker3	ranker1
51	2026-02-04 09:42:11.993262	ranker3	ranker2
53	2026-02-04 11:20:37.834618	ranker7	1
54	2026-02-04 15:06:23.073863	ranker7	ranker1
55	2026-02-05 01:51:58.177126	ranker9	ranker10
58	2026-02-06 09:11:29.107959	test	ranker5
59	2026-02-06 13:41:08.600876	test	ranker1
62	2026-02-06 13:49:20.859475	test	ssafy
63	2026-02-06 13:49:35.725821	test	ranker3
65	2026-02-08 18:05:16.497632	ranker1	test
66	2026-02-08 18:05:22.209402	ranker1	ranker7
67	2026-02-08 18:05:24.042221	ranker1	ranker2
\.


--
-- Data for Name: grids; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.grids (grid_id, occupied_at, party_id, user_id) FROM stdin;
8930c1925dbffff	2026-02-09 00:06:33.184119	\N	komae
\.


--
-- Data for Name: party; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.party (id, created_at, ended_at, invite_code, leader_id, max_members, name, started_at, status, total_distance, total_score, total_time) FROM stdin;
1	2026-01-29 16:43:29.083591	\N	412974	test	6	m	2026-01-29 16:43:45.119578	IN_PROGRESS	\N	\N	\N
2	2026-01-29 16:49:18.327202	\N	675664	test	6	m	\N	WAITING	\N	\N	\N
3	2026-01-29 16:53:43.843688	\N	428228	test	6	m	2026-01-29 16:53:51.836323	IN_PROGRESS	\N	\N	\N
4	2026-01-29 16:57:39.304606	\N	086866	test	6	m	2026-01-29 16:58:06.769854	IN_PROGRESS	\N	\N	\N
5	2026-01-29 17:03:06.613475	\N	121623	test	6	m	2026-01-29 17:03:23.784701	IN_PROGRESS	\N	\N	\N
6	2026-01-29 17:06:52.274186	\N	019965	test	6	n	2026-01-29 17:07:26.119329	IN_PROGRESS	\N	\N	\N
7	2026-01-30 10:14:28.787323	\N	057982	test	6	안녕	2026-01-30 10:14:57.688894	IN_PROGRESS	\N	\N	\N
8	2026-01-30 10:15:26.706158	\N	059161	ssafy	6	파티1	2026-01-30 10:15:35.566085	IN_PROGRESS	\N	\N	\N
9	2026-01-30 10:35:22.067678	\N	817932	ssafy	6	룰루	2026-01-30 10:35:37.987511	IN_PROGRESS	\N	\N	\N
10	2026-01-30 16:54:19.951528	\N	366708	ssafy	6	파티	\N	WAITING	\N	\N	\N
11	2026-02-01 14:46:37.484948	\N	723907	1	6	123	\N	WAITING	\N	\N	\N
12	2026-02-01 14:50:18.835101	\N	801167	1	6	123	\N	WAITING	\N	\N	\N
13	2026-02-01 14:55:20.80224	\N	282202	1	6	222	\N	WAITING	\N	\N	\N
14	2026-02-01 15:13:43.64122	\N	632413	2	6	bb	\N	WAITING	\N	\N	\N
15	2026-02-01 15:14:37.821164	\N	319245	2	6	파티	\N	WAITING	\N	\N	\N
16	2026-02-01 15:16:56.08949	\N	693262	ssafy	6	파티!	2026-02-01 15:17:27.04218	IN_PROGRESS	\N	\N	\N
17	2026-02-03 19:43:10.723546	\N	494029	ranker1	6	싸피	\N	WAITING	\N	\N	\N
18	2026-02-03 21:29:35.579508	\N	328635	ranker1	6	고고	\N	WAITING	\N	\N	\N
19	2026-02-04 19:33:32.851687	\N	711539	test	6	hello	2026-02-04 19:33:36.531544	IN_PROGRESS	\N	\N	\N
20	2026-02-04 19:50:45.550443	\N	889017	test	6	gggg	\N	WAITING	\N	\N	\N
21	2026-02-05 14:35:53.067968	\N	060835	test	6	hi	\N	WAITING	\N	\N	\N
22	2026-02-05 14:37:30.533806	\N	735706	test	6	fff	\N	WAITING	\N	\N	\N
23	2026-02-05 14:42:16.696839	\N	988313	test	6	gg	\N	WAITING	\N	\N	\N
24	2026-02-05 22:21:48.406052	\N	673277	test	6	test	\N	WAITING	\N	\N	\N
25	2026-02-05 22:53:55.191998	\N	600969	test	6	test	\N	WAITING	\N	\N	\N
26	2026-02-05 22:58:20.211127	\N	620967	test	6	test	\N	WAITING	\N	\N	\N
27	2026-02-06 02:05:50.102031	\N	502225	test	6	test	\N	WAITING	\N	\N	\N
28	2026-02-06 02:11:08.275963	\N	658757	test	6	test	\N	WAITING	\N	\N	\N
29	2026-02-06 13:56:53.578261	\N	603999	test	6	test	\N	WAITING	\N	\N	\N
30	2026-02-06 16:27:51.509008	\N	519237	test	6	test	\N	WAITING	\N	\N	\N
31	2026-02-06 17:36:55.016442	\N	572372	komae	6	ㅂㅅ	\N	WAITING	\N	\N	\N
32	2026-02-06 17:40:06.775806	\N	281682	komae	6	eng	\N	WAITING	\N	\N	\N
33	2026-02-07 18:56:21.452537	\N	517932	test	6	test	\N	WAITING	\N	\N	\N
34	2026-02-07 21:35:50.806876	\N	451874	komae	6	ff	\N	WAITING	\N	\N	\N
35	2026-02-07 21:39:37.466021	\N	966412	test	6	dd	\N	WAITING	\N	\N	\N
36	2026-02-07 21:40:14.635162	\N	004957	komae	6	dd	\N	WAITING	\N	\N	\N
37	2026-02-07 21:40:33.578599	\N	895907	komae	6	dx	\N	WAITING	\N	\N	\N
38	2026-02-07 21:52:18.341175	\N	297892	komae	6	d	2026-02-07 21:52:28.730462	IN_PROGRESS	\N	\N	\N
39	2026-02-08 21:34:51.712007	\N	336793	ranker1	6	파티	\N	WAITING	\N	\N	\N
\.


--
-- Data for Name: party_activity; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.party_activity (id, distance, ended_at, party_id, started_at, status, trash_count, user_id, plogging_id) FROM stdin;
1	\N	\N	1	2026-01-29 16:43:45.123582	IN_PROGRESS	\N	test	\N
2	\N	\N	1	2026-01-29 16:43:45.126283	IN_PROGRESS	\N	test2	\N
3	\N	\N	3	2026-01-29 16:53:51.8426	IN_PROGRESS	\N	test	\N
4	\N	\N	3	2026-01-29 16:53:51.847327	IN_PROGRESS	\N	test2	\N
5	\N	\N	4	2026-01-29 16:58:06.771291	IN_PROGRESS	\N	test	\N
6	\N	\N	4	2026-01-29 16:58:06.772439	IN_PROGRESS	\N	test2	\N
7	\N	\N	5	2026-01-29 17:03:23.786224	IN_PROGRESS	\N	test	\N
8	\N	\N	5	2026-01-29 17:03:23.787543	IN_PROGRESS	\N	test2	\N
9	\N	\N	6	2026-01-29 17:07:26.124252	IN_PROGRESS	\N	test	\N
10	\N	\N	6	2026-01-29 17:07:26.127318	IN_PROGRESS	\N	test2	\N
11	\N	\N	7	2026-01-30 10:14:57.692549	IN_PROGRESS	\N	test	\N
12	\N	\N	7	2026-01-30 10:14:57.697567	IN_PROGRESS	\N	ssafy	\N
13	\N	\N	8	2026-01-30 10:15:35.567744	IN_PROGRESS	\N	ssafy	\N
14	\N	\N	8	2026-01-30 10:15:35.569114	IN_PROGRESS	\N	test	\N
15	\N	\N	9	2026-01-30 10:35:37.988943	IN_PROGRESS	\N	ssafy	\N
16	\N	\N	9	2026-01-30 10:35:37.990493	IN_PROGRESS	\N	test	\N
17	\N	\N	16	2026-02-01 15:17:27.045259	IN_PROGRESS	\N	ssafy	\N
18	\N	\N	16	2026-02-01 15:17:27.051018	IN_PROGRESS	\N	2	\N
19	\N	\N	19	2026-02-04 19:33:36.53726	IN_PROGRESS	\N	test	\N
20	\N	\N	38	2026-02-07 21:52:28.732449	IN_PROGRESS	\N	komae	\N
21	\N	\N	38	2026-02-07 21:52:28.741234	IN_PROGRESS	\N	test	\N
\.


--
-- Data for Name: party_member; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.party_member (id, joined_at, user_id, party_id) FROM stdin;
1	2026-01-29 16:43:29.101509	test	1
2	2026-01-29 16:43:41.386197	test2	1
3	2026-01-29 16:49:18.328742	test	2
4	2026-01-29 16:53:43.877711	test	3
5	2026-01-29 16:53:49.554358	test2	3
6	2026-01-29 16:57:39.306364	test	4
7	2026-01-29 16:58:02.696112	test2	4
8	2026-01-29 17:03:06.614941	test	5
9	2026-01-29 17:03:20.63138	test2	5
10	2026-01-29 17:06:52.275843	test	6
11	2026-01-29 17:07:22.498374	test2	6
12	2026-01-30 10:14:28.802386	test	7
13	2026-01-30 10:14:45.3681	ssafy	7
14	2026-01-30 10:15:26.707908	ssafy	8
15	2026-01-30 10:15:31.817918	test	8
16	2026-01-30 10:35:22.069233	ssafy	9
17	2026-01-30 10:35:28.480708	test	9
18	2026-01-30 16:54:19.956361	ssafy	10
19	2026-02-01 14:46:37.49325	1	11
20	2026-02-01 14:50:18.836684	1	12
21	2026-02-01 14:55:20.803741	1	13
22	2026-02-01 15:13:43.643256	2	14
23	2026-02-01 15:14:37.822711	2	15
24	2026-02-01 15:16:56.090936	ssafy	16
25	2026-02-01 15:17:11.029874	2	16
26	2026-02-03 19:43:10.730369	ranker1	17
27	2026-02-03 21:29:35.584286	ranker1	18
28	2026-02-04 19:33:32.899446	test	19
29	2026-02-04 19:50:45.55242	test	20
30	2026-02-05 14:35:53.104321	test	21
31	2026-02-05 14:37:30.535591	test	22
32	2026-02-05 14:38:26.547546	ranker5	22
33	2026-02-05 14:42:16.698516	test	23
34	2026-02-05 14:42:28.793307	ranker5	23
35	2026-02-05 22:21:48.430027	test	24
36	2026-02-05 22:53:55.193982	test	25
37	2026-02-05 22:58:20.212501	test	26
38	2026-02-06 02:05:50.12094	test	27
39	2026-02-06 02:11:08.277662	test	28
40	2026-02-06 13:56:53.632072	test	29
41	2026-02-06 16:27:51.511225	test	30
42	2026-02-06 16:28:57.396533	ranker1	30
43	2026-02-06 17:36:55.019362	komae	31
44	2026-02-06 17:37:09.010805	test	31
45	2026-02-06 17:37:25.527557	ranker8	31
46	2026-02-06 17:40:06.777218	komae	32
47	2026-02-06 17:40:19.772936	test	32
48	2026-02-07 18:56:21.489671	test	33
49	2026-02-07 21:35:50.812985	komae	34
50	2026-02-07 21:35:56.162528	test	34
51	2026-02-07 21:39:37.468205	test	35
52	2026-02-07 21:40:14.636803	komae	36
53	2026-02-07 21:40:33.580128	komae	37
54	2026-02-07 21:40:53.258352	test	37
55	2026-02-07 21:52:18.343012	komae	38
56	2026-02-07 21:52:27.547339	test	38
57	2026-02-08 21:34:51.718734	ranker1	39
\.


--
-- Data for Name: plogging_record; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.plogging_record (plogging_record_id) FROM stdin;
\.


--
-- Data for Name: ploggings; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.ploggings (plogging_id, created_at, distance, score, times, user_id, after_image_url, before_image_url, content, map_image_url, record_name, status) FROM stdin;
1	2026-01-30 13:59:33.100134	0	0	4	ssafy	\N	\N	\N	\N	\N	USED
2	2026-01-30 14:37:07.015901	0	0	3	ssafy	\N	\N	\N	\N	\N	USED
3	2026-01-30 15:00:08.212083	0	0	5	ssafy2	\N	\N	\N	\N	\N	USED
4	2026-01-31 00:17:45.669717	0	0	6	ssafy	\N	\N	\N	\N	\N	USED
5	2026-01-31 00:23:07.864568	0	0	4	ssafy	\N	\N	\N	\N	\N	USED
6	2026-01-31 08:57:42.405297	0	0	11	1	\N	\N	\N	\N	\N	USED
7	2026-01-31 13:01:53.767793	0	0	4	1	\N	\N	\N	\N	\N	USED
8	2026-02-01 15:18:38.357064	0.001	0	34	ssafy	\N	\N	\N	\N	\N	USED
9	2026-02-01 21:37:41.946048	80	800	\N	ranker1	\N	\N	\N	\N	\N	USED
10	2026-02-01 21:40:02.217865	80	800	\N	ranker1	\N	\N	\N	\N	\N	USED
11	2026-02-01 21:40:33.476098	80	800	\N	ranker1	\N	\N	\N	\N	\N	USED
12	2026-02-01 21:40:34.583213	80	800	\N	ranker1	\N	\N	\N	\N	\N	USED
13	2026-02-01 21:41:13.80243	80	800	\N	ranker1	\N	\N	\N	\N	\N	USED
14	2026-02-01 21:45:12.848556	50	500	\N	ranker5	\N	\N	\N	\N	\N	USED
15	2026-02-01 21:45:16.615651	50	500	\N	ranker5	\N	\N	\N	\N	\N	USED
16	2026-02-01 21:45:17.711565	50	500	\N	ranker5	\N	\N	\N	\N	\N	USED
17	2026-02-01 21:45:18.582348	50	500	\N	ranker5	\N	\N	\N	\N	\N	USED
18	2026-02-01 21:46:38.065819	50	500	\N	ranker5	\N	\N	\N	\N	\N	USED
19	2026-02-01 21:46:39.059721	50	500	\N	ranker5	\N	\N	\N	\N	\N	USED
20	2026-02-01 21:47:07.406552	50	500	\N	ranker5	\N	\N	\N	\N	\N	USED
21	2026-02-01 21:47:12.960994	50	500	\N	ranker5	\N	\N	\N	\N	\N	USED
22	2026-02-01 21:47:18.722059	50	500	\N	ranker5	\N	\N	\N	\N	\N	USED
23	2026-02-01 21:47:25.33947	50	500	\N	ranker5	\N	\N	\N	\N	\N	USED
24	2026-02-01 21:47:26.162359	50	500	\N	ranker5	\N	\N	\N	\N	\N	USED
25	2026-02-01 21:47:58.777542	50	500	\N	ranker7	\N	\N	\N	\N	\N	USED
26	2026-02-01 21:48:22.41085	500	5000	\N	ranker7	\N	\N	\N	\N	\N	USED
27	2026-02-01 21:48:34.76122	100	1000	\N	ranker7	\N	\N	\N	\N	\N	USED
28	2026-02-01 21:48:39.886586	100	1000	\N	ranker7	\N	\N	\N	\N	\N	USED
29	2026-02-01 21:50:13.953733	100	1000	\N	ranker2	\N	\N	\N	\N	\N	USED
30	2026-02-01 21:50:22.016704	100	1000	\N	ranker2	\N	\N	\N	\N	\N	USED
31	2026-02-01 21:50:29.850328	100	1000	\N	ranker2	\N	\N	\N	\N	\N	USED
32	2026-02-01 21:50:39.463041	100	1000	\N	ranker3	\N	\N	\N	\N	\N	USED
33	2026-02-01 21:50:41.818014	100	1000	\N	ranker3	\N	\N	\N	\N	\N	USED
34	2026-02-01 21:50:46.018072	100	1000	\N	ranker4	\N	\N	\N	\N	\N	USED
35	2026-02-01 21:50:54.421884	50	500	\N	ranker5	\N	\N	\N	\N	\N	USED
36	2026-02-01 21:51:01.282095	40	400	\N	ranker6	\N	\N	\N	\N	\N	USED
37	2026-02-01 21:51:12.267232	30	300	\N	ranker8	\N	\N	\N	\N	\N	USED
38	2026-02-01 21:51:18.992403	20	200	\N	ranker9	\N	\N	\N	\N	\N	USED
39	2026-02-01 21:51:27.585336	10	100	\N	ranker10	\N	\N	\N	\N	\N	USED
40	2026-02-02 15:13:56.70388	0	0	8	ranker1	\N	\N	\N	\N	\N	USED
41	2026-02-03 15:55:12.429953	80	800	\N	ranker1	\N	\N	\N	\N	\N	USED
42	2026-02-03 15:57:17.060057	80	800	\N	ranker1	\N	\N	\N	\N	\N	USED
43	2026-02-03 16:07:46.209264	80	800	\N	ranker1	\N	\N	\N	\N	\N	USED
44	2026-02-03 16:08:06.953598	80	800	\N	ranker1	\N	\N	\N	\N	\N	USED
45	2026-02-05 17:15:19.276833	0	0	2	test	\N	\N	\N	\N	\N	\N
46	2026-02-05 22:54:33.009001	0	0	26	test	\N	\N	\N	\N	\N	\N
47	2026-02-05 22:58:47.916707	0	0	19	test	\N	\N	\N	\N	\N	\N
48	2026-02-05 22:59:22.700124	0	0	14	test	\N	\N	\N	\N	\N	\N
49	2026-02-06 02:12:40.988047	0	0	3	test	\N	\N	\N	\N	\N	\N
50	2026-02-06 05:56:07.282833	0	0	44	ssafy	\N	\N	\N	\N	good	USED
51	2026-02-06 00:00:00	0	0	22	ssafy	\N	\N	ㅎㅎ	\N	기록1	TEMP
52	2026-02-06 00:00:00	0	0	22	ssafy	https://storage.googleapis.com/jupddang-images/profile/ab271aa8-d3a1-4f1b-831d-55cde4063103_scaled_33.webp	https://storage.googleapis.com/jupddang-images/profile/ab271aa8-d3a1-4f1b-831d-55cde4063103_scaled_33.webp	기록2입니다!	https://storage.googleapis.com/jupddang-images/profile/ab271aa8-d3a1-4f1b-831d-55cde4063103_scaled_33.webp	기록2	TEMP
53	2026-02-06 10:16:20.600459	0	3	193	test	\N	\N	\N	\N	dddd	USED
56	2026-02-06 14:15:17.777914	0	0	23	ssafy4	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/56/91d29b91-ec8a-40f0-ad38-e53ebddae87f_scaled_832e727d-8489-46df-ac98-4159404af77e7538123214131713412.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/56/82e803a3-c448-452a-adef-5c7d8aebae02_scaled_88aa1dbe-a01c-4204-949c-2b9a995ad4e59175336574678727716.webp	좋아요\n\n기록: 좋은 기록 · 2026-02-06 · 0.0km · 23초 · 0점	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/56/46a43dce-2975-48a6-86f9-f53ce160e905_map_1770354887588.webp	좋은 기록	USED
54	2026-02-06 10:55:47.032168	0	0	28	ssafy4	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/54/937ff96b-cf6f-4f15-815d-532c05a44544_scaled_35f51b53-59e4-42e6-8cf9-5acb172dfd538964893074411591407.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/54/8a747127-2351-4cde-b3ab-1e5aa5c03cf5_scaled_a9177956-216d-4177-9936-8b3090ac202b5717899471335387020.webp	좋아요\n\n기록: 기록_1 · 2026-02-06 · 0.0km · 28초 · 0점	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/54/daf5d0ee-5e37-4892-8ef8-3bb76ca9ca00_map_1770342929315.webp	기록_1	USED
55	2026-02-06 14:09:52.321457	0	0	23	ssafy4	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/55/06fe0c2d-2ba6-4bf3-a1b0-2d347c8ba86c_scaled_6d54244e-77d2-4230-b0c3-833f98a9d35f7387772983032342393.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/55/e57425ec-7357-45ab-9fbc-f37637260cfd_scaled_6a1f4b6e-025a-4156-af01-7fdf65af321a2236150741340950598.webp	으어\n\n기록: 임시기록1 · 2026-02-06 · 0.0km · 23초 · 0점	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/55/2738c606-187d-4643-9e7f-c53bdf79d273_map_1770354580528.webp	임시기록1	USED
58	2026-02-06 15:13:43.390816	0	0	25	ssafy	\N	\N	\N	\N	좋아요	USED
57	2026-02-06 14:26:36.354795	0	0	26	ssafy4	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/57/5ede116f-c7b7-4a67-9561-301f3c0d1b4f_scaled_d1e2502b-0dad-4472-99e7-fa46e587b7a78480358841842157018.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/57/3b5aaf9c-3fcc-4300-805b-e2765ef168a0_scaled_d7df6355-1016-4ef3-af90-3c8c055108d8284478518783574263.webp	ㅎㅎ\n\n기록: ㅎㅎ · 2026-02-06 · 0.0km · 26초 · 0점	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/57/9c4021a0-b641-4fa8-bf77-f5ef84da2390_map_1770355588181.webp	ㅎㅎ	USED
59	2026-02-06 15:15:20.205618	0	0	26	ssafy4	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/59/285cce75-0ec5-4ecf-baed-1e794a01b256_scaled_434292e7-04ef-4a55-8e20-ac6858fc073b6575250714612678147.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/59/9e3672b5-bf41-43bf-b108-7d48c4466c84_scaled_f69229ec-10ec-452f-975e-b849add76a823623625567001138980.webp	추워요\n\n기록: 추운 플로깅 · 2026-02-06 · 0.0km · 26초 · 0점	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/59/2111fcf4-724c-4d02-b833-fa1bf671e9d2_map_1770358508801.webp	추운 플로깅	USED
60	2026-02-06 15:35:52.825196	0	0	40	ssafy4	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/60/1d2d9cdb-82ca-45dd-917e-314f1d80aa8b_scaled_1fbb650c-91fc-40e3-aa9d-32f6f273fa7c670894039089225142.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/60/68f58f1d-a47f-409d-8dd6-83f1d8a192cf_scaled_44a35c51-b667-4dec-b3db-cc7fa23443677234391481440015557.webp	배고파!\n\n기록: 기록!! · 2026-02-06 · 0.0km · 40초 · 0점	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/60/fd3eb156-1347-476b-adc4-94b2ee44c3d1_map_1770359731504.webp	기록!!	USED
61	2026-02-06 15:48:22.675231	0.207	6	266	test	\N	\N	\N	\N	동네 한바퀴	USED
62	2026-02-06 15:59:17.927231	0	0	27	ssafy4	\N	\N	\N	\N	비애	USED
71	2026-02-06 17:39:58.83183	0	0	25	ssafy4	\N	\N	\N	\N	일반 플러깅 테스트	USED
63	2026-02-06 16:07:48.355474	0	0	20	ssafy4	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/63/0e1a2537-8324-4cd8-a18a-3cc8ba24ec23_scaled_ff40072d-9baa-4a32-9423-24fe3669bdc54621435283347316107.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/63/8e274702-aaf3-4f5e-a3df-c840f1bd9cfe_scaled_732ee517-cdf6-4439-990a-5cbd03cd7377447536258931619431.webp	임시저장 후 작성된 글 입니다\n\n기록: 비애 테스트 · 2026-02-06 · 0.0km · 20초 · 0점	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/63/41f61405-129f-4319-8aef-9ec6fd1885ec_map_1770361619971.webp	비애 테스트	USED
64	2026-02-06 16:26:42.260717	0	0	45	test	\N	\N	\N	\N	ddd	USED
65	2026-02-06 16:30:18.88401	0	1	65	test	\N	\N	\N	\N	ddd	USED
66	2026-02-06 16:58:04.127123	0	0	30	ssafy4	\N	\N	\N	\N	TMI	USED
67	2026-02-06 17:13:58.365189	0	0	24	ssafy4	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/67/d37cc925-a5c7-4cca-9c25-ad65690b9d59_scaled_983ed9fc-38dd-4db2-8ab2-9aa9078424162073938638127093874.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/67/54f774ea-b7c7-4558-9b00-fb60c731db97_scaled_8c15c1a5-83ce-4db2-9011-bd8d909894978246825230370997618.webp	퇴근 50분 전\n\n기록: 퇴5 · 2026-02-06 · 0.0km · 24초 · 0점	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/67/f1cabd23-213f-46bf-926d-df5907e0e7cd_map_1770365613276.webp	퇴5	USED
68	2026-02-06 17:15:34.749929	0	0	20	ssafy4	\N	\N	\N	\N	일반 종료	USED
72	2026-02-06 17:41:07.534814	0	0	25	ssafy4	\N	\N	\N	\N	일반 플러깅 테스트	USED
69	2026-02-06 17:22:36.081112	0	0	17	ssafy4	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/69/9487a50e-7649-45f9-9c93-b7bfef2f0579_scaled_dbe44f0e-8d07-4bad-8639-3bde5e2f2ee6441366420296652646.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/69/00d7d751-6136-4964-adcb-d568bd8adab7_scaled_9d266ab4-6593-4d41-bd17-945feb2b72ca8871844576386998684.webp	임시 저장 테스트\n\n기록: 임시 저장 테스트 · 2026-02-06 · 0.0km · 17초 · 0점	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/69/8e9742bf-1ee1-4597-ac7b-5ac36f82359f_map_1770366137845.webp	임시 저장 테스트	USED
70	2026-02-06 17:28:19.568197	0	0	17	ssafy4	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/70/8b4290e1-0178-4459-8ba8-1be1df7ed139_scaled_090eb8e1-b7a5-43a0-ad8e-e4e2b97047613747191418305239467.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/70/765e94e8-404c-411f-b897-341aaa152b93_scaled_e0d63166-ea25-4136-b59f-1069de77cc437749888872588175193.webp	임시테스트2\n\n기록: 임시테스트2 · 2026-02-06 · 0.0km · 17초 · 0점	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/70/29d8907d-cf26-4ee5-ac81-10c349049961_map_1770366485706.webp	임시테스트2	USED
73	2026-02-07 21:28:32.938789	0.215	11	550	user1	\N	\N	\N	\N	토욜밤 플로깅	USED
74	2026-02-07 21:35:15.730503	0.183	6	343	user2	\N	\N	\N	\N	오플완	USED
75	2026-02-07 21:42:07.187901	0.012	4	285	user3	\N	\N	\N	\N	2월7일	USED
76	2026-02-07 21:56:45.143533	0.148	13	731	user4	\N	\N	\N	\N	구미 플로깅	USED
77	2026-02-08 00:09:02.242676	0.101	2	91	komae	\N	\N	\N	\N	cold	USED
78	2026-02-08 13:09:56.159466	0.11	3	135	komae	\N	\N	\N	\N	춥다	USED
79	2026-02-08 20:48:07.807387	0	0	13	user1	\N	\N	\N	\N	테스트	USED
80	2026-02-08 21:49:53.341099	0.348	11	493	user5	\N	\N	\N	\N	담꽁	USED
81	2026-02-08 21:54:01.853481	0.076	2	174	user1	\N	\N	\N	\N	짧은 플로깅	USED
82	2026-02-08 21:59:16.376954	0.045	4	242	user2	\N	\N	\N	\N	동네 플로깅	USED
83	2026-02-08 22:05:12.898318	0.182	5	299	user3	\N	\N	\N	\N	집 근처 플로깅	USED
84	2026-02-08 22:16:58.884345	0.537	15	638	user4	\N	\N	\N	\N	춥춥	USED
85	2026-02-08 22:30:58.715103	0.101	9	495	komae	\N	\N	\N	\N	cold	USED
86	2026-02-08 22:44:02.56083	0.106	2	93	komae	\N	\N	\N	\N	..	USED
87	2026-02-08 23:24:28.402675	0.123	18	1073	komae	\N	\N	\N	\N	.	USED
88	2026-02-08 23:49:44.647283	0.104	23	1028	komae	\N	\N	\N	\N	.	USED
89	2026-02-09 00:06:33.188957	0.111	13	461	komae	\N	\N	\N	\N	..	USED
\.


--
-- Data for Name: post; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.post (post_id, after_image_url, before_image_url, content, created_at, like_cnt, map_image_url, plogging_id, updated_at, user_id) FROM stdin;
17	https://storage.googleapis.com/jupddang-images/plogging/1/7/d153de05-9e33-4ede-8823-7ec62a942146_1769832114105.jpg	https://storage.googleapis.com/jupddang-images/plogging/1/7/2c9b3212-d154-414f-a90e-a4d685381691_1769832113771.jpg		2026-01-31 13:01:54.32018	1	https://storage.googleapis.com/jupddang-images/plogging/1/7/9a4c3022-f0f8-4306-b1c5-c67c11756f24_1769832114204.png	7	2026-01-31 18:02:38.290389	1
16	https://storage.googleapis.com/jupddang-images/plogging/1/6/b3dc2bd4-04d3-46d0-8874-e335acc46229_1769817463044.jpg	https://storage.googleapis.com/jupddang-images/plogging/1/6/29024398-fbdd-4df9-9940-7a6339741dcb_1769817462409.jpg	1test-화현 진짜 플로깅	2026-01-31 08:57:43.226508	2	https://storage.googleapis.com/jupddang-images/plogging/1/6/147ffead-0445-49eb-b92e-d93a59dbf9f8_1769817463130.png	6	2026-01-31 18:02:40.411266	1
2	https://storage.googleapis.com/jupddang-images/plogging/ssafy/1/9fba66fc-0f4f-460e-b795-73cc896600af_1769749174552.jpg	https://storage.googleapis.com/jupddang-images/plogging/ssafy/1/5cb6afde-9ba0-4bb4-8e21-b8fec489091a_1769749173110.jpg	!!	2026-01-30 13:59:35.113737	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy/1/cec64f06-d826-462a-8cbb-b856ba397d36_1769749175023.png	1	2026-01-30 13:59:35.113737	ssafy
4	https://storage.googleapis.com/jupddang-images/plogging/ssafy2/3/4503ecb6-6c00-4569-908a-4a441006b0e7_1769752808793.jpg	https://storage.googleapis.com/jupddang-images/plogging/ssafy2/3/a7e7130b-add5-4a2f-9762-ca62521f245a_1769752808214.jpg	추워요!!	2026-01-30 15:00:09.29639	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy2/3/023c82f7-3fc4-4515-a7b5-006f2f1a9db9_1769752809205.png	3	2026-01-30 15:00:09.29639	ssafy2
3	https://storage.googleapis.com/jupddang-images/plogging/ssafy/2/69c359f2-8662-4758-a978-31a3b7716174_1769751427455.jpg	https://storage.googleapis.com/jupddang-images/plogging/ssafy/2/0788bcc1-33cd-46f3-904f-c81ab3d30433_1769751427017.jpg	gg!!	2026-01-30 14:37:07.969032	1	https://storage.googleapis.com/jupddang-images/plogging/ssafy/2/f60b009d-bfb1-4ebf-9eed-d1509819fbe8_1769751427865.png	2	2026-01-30 15:46:54.109687	ssafy
1	\N	\N	춥땅\n\n기록: 캠퍼스 러닝 · 2024-10-29 · 2.1km · 24분	2026-01-30 10:21:07.037604	4	\N	\N	2026-01-30 15:52:58.279294	ssafy
5	https://storage.googleapis.com/jupddang-images/sns/d9e43934-0119-44b7-950e-8ce70872a395_1769761434387.jpg	https://storage.googleapis.com/jupddang-images/sns/73bf9fc5-8ff5-45a9-8b6b-70e79f2541f5_1769761434076.jpg	fasdfasdf\n\n기록: 한강 플로깅 · 2024-11-02 · 3.2km · 32분	2026-01-30 17:23:54.462117	0	\N	\N	2026-01-30 17:23:54.462117	ssafy
6	https://storage.googleapis.com/jupddang-images/sns/14b9f3ec-94d3-4dff-8984-f921a31d11a1_1769761558124.jpg	https://storage.googleapis.com/jupddang-images/sns/8c87b317-76d2-4765-820c-eb789aadfd65_1769761557990.jpg	asdfff\n\n기록: 캠퍼스 러닝 · 2024-10-29 · 2.1km · 24분	2026-01-30 17:25:58.204961	0	\N	\N	2026-01-30 17:25:58.204961	ssafy
7	https://storage.googleapis.com/jupddang-images/sns/e6f2ca41-0929-4f29-967a-6a1c994d5ae2_1769761687526.jpg	https://storage.googleapis.com/jupddang-images/sns/1fb3486e-2e0c-414c-89d5-99e3edd2d52e_1769761687397.jpg	fff	2026-01-30 17:28:07.595545	0	\N	\N	2026-01-30 17:28:07.595545	ssafy
8	\N	\N	ㅠㅠ	2026-01-30 17:36:55.495419	0	\N	\N	2026-01-30 17:36:55.495419	ssafy2
12	\N	\N	ㅎㅎ\n\n기록: 한강 플로깅 · 2024-11-02 · 3.2km · 32분	2026-01-30 17:59:43.333839	0	\N	\N	2026-01-30 17:59:43.333839	ssafy
11	\N	\N	1	2026-01-30 17:56:47.725422	1	\N	\N	2026-01-30 23:47:08.129542	2
10	\N	\N	34534534	2026-01-30 17:54:27.91007	1	\N	\N	2026-01-30 23:48:06.837162	2
13	\N	\N	asdf	2026-01-30 20:49:50.858972	2	\N	\N	2026-01-30 23:50:07.797886	1
9	https://storage.googleapis.com/jupddang-images/sns/27d538c8-d49a-4068-964a-5f7b32a5ce98_1769763025173.jpg	https://storage.googleapis.com/jupddang-images/sns/4abdc0bb-c1a9-40df-b541-62327f106ff0_1769763025051.jpg	1의 게시물1\n\n기록: 동네 산책 플로깅 · 2024-10-24 · 1.4km · 18분	2026-01-30 17:50:25.24428	2	\N	\N	2026-01-30 23:50:10.93142	1
14	https://storage.googleapis.com/jupddang-images/plogging/ssafy/4/9b20ca0a-3b07-4fd6-a008-3d0cae465e06_1769786266257.jpg	https://storage.googleapis.com/jupddang-images/plogging/ssafy/4/a4e95061-708e-4cad-bdd1-d9f7276aa3b6_1769786265672.jpg	좋았죠 뭐	2026-01-31 00:17:46.746501	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy/4/cb9747be-8ae9-415c-8bfc-366afb1a4717_1769786266661.png	4	2026-01-31 00:17:46.746501	ssafy
15	https://storage.googleapis.com/jupddang-images/plogging/ssafy/5/ca2973c3-f8dc-40dc-aa3b-55bb912ce9f9_1769786588350.jpg	https://storage.googleapis.com/jupddang-images/plogging/ssafy/5/882bf840-f052-4018-96b6-bdea49e908ef_1769786587865.jpg	테스트임돠	2026-01-31 00:23:08.922099	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy/5/f9279b25-d877-4f99-819b-cc3bbae993f9_1769786588819.png	5	2026-01-31 00:23:08.922099	ssafy
21	\N	\N	whyrano	2026-02-01 01:30:42.460424	0	\N	\N	2026-02-01 01:30:42.460424	1
24	https://storage.googleapis.com/jupddang-images/plogging/ssafy/8/e05850c7-fb2e-41a5-aaf3-74332f830b29_1769926719826.jpg	https://storage.googleapis.com/jupddang-images/plogging/ssafy/8/0aea6f0d-0f4f-44d8-878d-ba265597513d_1769926718365.jpg	ㅎㅎ\n\n기록: ㅎㅎ 쨌 2026-02-01 쨌 0.0km 쨌 0분	2026-02-01 15:18:40.459033	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy/8/33006f64-a824-4289-98a1-bf3fda074c1a_1769926720355.png	8	2026-02-01 15:18:40.459033	ssafy
26	https://storage.googleapis.com/jupddang-images/plogging/ranker1/9/2db052f8-8227-4253-a6bf-5f68b9b242bc_1769949462268.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker1/9/77df6f73-7625-465d-9aed-5d68c68b1d6a_1769949461950.jpg	내가 1등이다!	2026-02-01 21:37:42.406195	0	https://storage.googleapis.com/jupddang-images/plogging/ranker1/9/1b170663-5207-4bc1-9f88-b01421b1a78e_1769949462328.jpg	9	2026-02-01 21:37:42.406195	ranker1
27	https://storage.googleapis.com/jupddang-images/plogging/ranker1/10/740f9423-8657-4429-934f-5d5ce0282148_1769949602346.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker1/10/7e34a259-f1b7-443b-99a9-16684241e512_1769949602219.jpg	내가 1등이다!	2026-02-01 21:40:02.472281	0	https://storage.googleapis.com/jupddang-images/plogging/ranker1/10/d8b12701-a7f2-499a-9116-b0c1ce0afa21_1769949602404.jpg	10	2026-02-01 21:40:02.472281	ranker1
28	https://storage.googleapis.com/jupddang-images/plogging/ranker1/11/1002857e-15c0-48dd-ac98-da9d68455783_1769949633606.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker1/11/73556742-5f0b-4fda-ad8a-c17062628461_1769949633477.jpg	내가 1등이다!	2026-02-01 21:40:33.726479	0	https://storage.googleapis.com/jupddang-images/plogging/ranker1/11/d8efbaa0-a3a3-4a4f-82ea-04f9d5eba7ee_1769949633664.jpg	11	2026-02-01 21:40:33.726479	ranker1
29	https://storage.googleapis.com/jupddang-images/plogging/ranker1/12/6800c193-d7a4-4ac7-b745-ad1e7239057c_1769949634666.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker1/12/c64a60b9-395b-4853-8c53-08dff2b4d3a2_1769949634584.jpg	내가 1등이다!	2026-02-01 21:40:34.793928	0	https://storage.googleapis.com/jupddang-images/plogging/ranker1/12/8a0bc288-fab4-4dc2-a98a-93891423aed7_1769949634727.jpg	12	2026-02-01 21:40:34.793928	ranker1
30	https://storage.googleapis.com/jupddang-images/plogging/ranker1/13/559604ec-04ec-46ab-aed1-3934df4aad71_1769949673932.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker1/13/6b5fcd6c-0250-4953-85a8-cb593ab638ce_1769949673803.jpg	내가 1등이다!	2026-02-01 21:41:14.058938	0	https://storage.googleapis.com/jupddang-images/plogging/ranker1/13/5de34241-6f6e-4ddc-af08-1bc0424f57cd_1769949673985.jpg	13	2026-02-01 21:41:14.058938	ranker1
31	https://storage.googleapis.com/jupddang-images/plogging/ranker5/14/3bb5f689-57d2-4cb0-94aa-24f0dd7f20bd_1769949912988.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker5/14/fcd3d61e-1f8c-4922-b0e3-29e1ebfecbeb_1769949912850.jpg	나는 2등!	2026-02-01 21:45:13.123649	0	https://storage.googleapis.com/jupddang-images/plogging/ranker5/14/5acccb55-42bf-4c05-844d-f1e28d771b4d_1769949913056.jpg	14	2026-02-01 21:45:13.123649	ranker5
32	https://storage.googleapis.com/jupddang-images/plogging/ranker5/15/be037f94-ab67-4b0b-abcd-f4039a73f06f_1769949916702.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker5/15/acf84f7c-39c9-47e7-8f8a-9073a140eda1_1769949916617.jpg	나는 2등!	2026-02-01 21:45:16.823744	0	https://storage.googleapis.com/jupddang-images/plogging/ranker5/15/f5756c6d-b5ba-4a05-83bb-d2aec733faa3_1769949916760.jpg	15	2026-02-01 21:45:16.823744	ranker5
33	https://storage.googleapis.com/jupddang-images/plogging/ranker5/16/dd773359-d39e-48a1-b3e0-579e62c84c3e_1769949917791.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker5/16/094598ce-aef2-46dc-9eb9-c4ab1b117d15_1769949917712.jpg	나는 2등!	2026-02-01 21:45:17.913658	0	https://storage.googleapis.com/jupddang-images/plogging/ranker5/16/74209af5-a8e8-4442-992d-2250338586ad_1769949917849.jpg	16	2026-02-01 21:45:17.913658	ranker5
34	https://storage.googleapis.com/jupddang-images/plogging/ranker5/17/8b2375ab-72a3-44b4-8b9c-59bb88e59e60_1769949918658.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker5/17/1292ac8b-d9ba-4746-a950-847f378f9ed2_1769949918583.jpg	나는 2등!	2026-02-01 21:45:18.776232	0	https://storage.googleapis.com/jupddang-images/plogging/ranker5/17/71f5b722-081f-449c-9001-a7b3afa9aa1c_1769949918712.jpg	17	2026-02-01 21:45:18.776232	ranker5
35	https://storage.googleapis.com/jupddang-images/plogging/ranker5/18/ed1f1e36-780b-45df-b637-171218c46cc9_1769949998194.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker5/18/2853dd63-e054-46fa-8f32-6a0a3ebd1af1_1769949998067.jpg	나는 2등!	2026-02-01 21:46:38.319944	0	https://storage.googleapis.com/jupddang-images/plogging/ranker5/18/eca892fc-8024-437e-a89e-bb8299b61431_1769949998254.jpg	18	2026-02-01 21:46:38.319944	ranker5
36	https://storage.googleapis.com/jupddang-images/plogging/ranker5/19/8609420d-af04-4a52-a878-d947d03e2225_1769949999125.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker5/19/b00feee6-1dc7-4587-88fe-38cb3ec43701_1769949999061.jpg	나는 2등!	2026-02-01 21:46:39.235281	0	https://storage.googleapis.com/jupddang-images/plogging/ranker5/19/63357510-f3b5-4934-8c1b-324cec7f4ffc_1769949999173.jpg	19	2026-02-01 21:46:39.235281	ranker5
37	https://storage.googleapis.com/jupddang-images/plogging/ranker5/20/ab7e7b0d-ac5e-4294-89e1-8bd874428155_1769950027521.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker5/20/1642f5c1-951f-44f0-ab58-15c2f5661615_1769950027407.jpg	나는 2등!	2026-02-01 21:47:07.652281	0	https://storage.googleapis.com/jupddang-images/plogging/ranker5/20/03f51f54-4b58-4d5c-899a-8aef40383d14_1769950027586.jpg	20	2026-02-01 21:47:07.652281	ranker5
38	https://storage.googleapis.com/jupddang-images/plogging/ranker5/21/c225c911-470b-4824-b56e-4fbc4cf332e5_1769950033072.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker5/21/80e923eb-6ed4-4fed-960c-e2072967f657_1769950032962.jpg	나는 2등!	2026-02-01 21:47:13.185065	0	https://storage.googleapis.com/jupddang-images/plogging/ranker5/21/96ec1237-6c4d-4903-8511-535af8b93808_1769950033120.jpg	21	2026-02-01 21:47:13.185065	ranker5
39	https://storage.googleapis.com/jupddang-images/plogging/ranker5/22/52b4d884-a619-4029-a3d0-45194e9aeacf_1769950038837.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker5/22/900e4f66-b689-4885-bb1e-8a1727eb3df5_1769950038723.jpg	나는 2등!	2026-02-01 21:47:18.944774	0	https://storage.googleapis.com/jupddang-images/plogging/ranker5/22/1c1d510c-701e-44d8-956b-2fe64570a959_1769950038885.jpg	22	2026-02-01 21:47:18.944774	ranker5
40	https://storage.googleapis.com/jupddang-images/plogging/ranker5/23/ff421d97-57fb-4396-9995-b46913365b95_1769950045462.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker5/23/60ff0ee6-6601-4946-8c54-03651e51f521_1769950045340.jpg	나는 2등!	2026-02-01 21:47:25.579525	0	https://storage.googleapis.com/jupddang-images/plogging/ranker5/23/f5486752-992d-4754-88ef-59d6a9fac255_1769950045517.jpg	23	2026-02-01 21:47:25.579525	ranker5
41	https://storage.googleapis.com/jupddang-images/plogging/ranker5/24/455182c5-0947-4ef1-9ba3-9a38bd380212_1769950046235.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker5/24/7616116c-6339-44f6-92f1-65f6a1df34fe_1769950046163.jpg	나는 2등!	2026-02-01 21:47:26.348573	0	https://storage.googleapis.com/jupddang-images/plogging/ranker5/24/44c8491d-65c7-455f-9c00-8e467ac0b217_1769950046296.jpg	24	2026-02-01 21:47:26.348573	ranker5
42	https://storage.googleapis.com/jupddang-images/plogging/ranker7/25/ca878194-19ea-459a-b0a8-92a801beab31_1769950078907.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker7/25/6524c1a5-a551-418c-8106-34c6c2e7bca7_1769950078778.jpg	나는 2등!	2026-02-01 21:47:59.029058	0	https://storage.googleapis.com/jupddang-images/plogging/ranker7/25/9ee9493e-b55d-469e-b270-7b4f7fd284e7_1769950078963.jpg	25	2026-02-01 21:47:59.029058	ranker7
43	https://storage.googleapis.com/jupddang-images/plogging/ranker7/26/0ebe860f-34c1-4c7e-a442-eab4453f68f5_1769950102530.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker7/26/537911b9-5047-4bc5-8628-7543f0303c99_1769950102412.jpg	나는 1등!	2026-02-01 21:48:22.650932	0	https://storage.googleapis.com/jupddang-images/plogging/ranker7/26/19271917-0b1b-4ade-95e5-b7b6293c6594_1769950102587.jpg	26	2026-02-01 21:48:22.650932	ranker7
44	https://storage.googleapis.com/jupddang-images/plogging/ranker7/27/a15bacb6-a013-48bd-9c61-55d9344882ba_1769950114877.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker7/27/5aa2d275-75ae-4d37-bd84-d3e6c8ee4dfb_1769950114762.jpg	나는 1등!	2026-02-01 21:48:34.989434	0	https://storage.googleapis.com/jupddang-images/plogging/ranker7/27/b772d729-f654-4fb3-845f-5f67b6eeff0c_1769950114930.jpg	27	2026-02-01 21:48:34.989434	ranker7
45	https://storage.googleapis.com/jupddang-images/plogging/ranker7/28/bcee33f6-c4b4-4714-9267-82525416eb12_1769950119959.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker7/28/9ce4677d-6aaf-4046-86e9-a231686f8d56_1769950119887.jpg	나는 1등!	2026-02-01 21:48:40.078929	0	https://storage.googleapis.com/jupddang-images/plogging/ranker7/28/f93440ff-23ea-4d6e-9fb1-bf8322c73ea2_1769950120012.jpg	28	2026-02-01 21:48:40.078929	ranker7
46	https://storage.googleapis.com/jupddang-images/plogging/ranker2/29/8ab5720d-4a22-44c8-bd94-e269107fb6df_1769950214094.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker2/29/4bd6aad0-fded-4d84-b38f-e2b3503f929b_1769950213954.jpg	나는 1등!	2026-02-01 21:50:14.230557	0	https://storage.googleapis.com/jupddang-images/plogging/ranker2/29/0cde7367-16c0-4ad1-b9bb-ab967b644c3f_1769950214148.jpg	29	2026-02-01 21:50:14.230557	ranker2
47	https://storage.googleapis.com/jupddang-images/plogging/ranker2/30/9a155c3c-3585-41ca-85ef-79585faca78f_1769950222145.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker2/30/e4eee53d-92a3-45b1-9ec2-032ee08b2150_1769950222017.jpg	나는 1등!	2026-02-01 21:50:22.265533	0	https://storage.googleapis.com/jupddang-images/plogging/ranker2/30/1d35ce89-0a1d-438d-95d9-7fb44ec6eb00_1769950222198.jpg	30	2026-02-01 21:50:22.265533	ranker2
48	https://storage.googleapis.com/jupddang-images/plogging/ranker2/31/61da9e97-a5d1-4313-9236-3e3ddf5a47dc_1769950229973.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker2/31/20de58ad-f41d-4be0-9f4c-5dbfa42ec0df_1769950229851.jpg	나는 1등!	2026-02-01 21:50:30.091138	0	https://storage.googleapis.com/jupddang-images/plogging/ranker2/31/4018d5ec-8106-412e-b18e-e28d8392b622_1769950230030.jpg	31	2026-02-01 21:50:30.091138	ranker2
49	https://storage.googleapis.com/jupddang-images/plogging/ranker3/32/f3b5d5f9-d016-4daa-bac2-d63b09d6eb64_1769950239574.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker3/32/e9f11f40-8158-40dd-bd64-61f7e5a4955b_1769950239464.jpg	나는 1등!	2026-02-01 21:50:39.691052	0	https://storage.googleapis.com/jupddang-images/plogging/ranker3/32/81bd431c-cba0-4487-bda6-66afe99d010f_1769950239625.jpg	32	2026-02-01 21:50:39.691052	ranker3
50	https://storage.googleapis.com/jupddang-images/plogging/ranker3/33/6b4e9831-8922-469c-a299-47f0e52bbd18_1769950241884.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker3/33/9e055c03-75b6-4a0e-b9e8-d1487e75f5fb_1769950241819.jpg	나는 1등!	2026-02-01 21:50:41.996366	0	https://storage.googleapis.com/jupddang-images/plogging/ranker3/33/4bbd2b2a-5762-4b5e-a6d3-1fc3ae7b3384_1769950241939.jpg	33	2026-02-01 21:50:41.996366	ranker3
51	https://storage.googleapis.com/jupddang-images/plogging/ranker4/34/63ecd686-c69f-4b78-b2d0-478a01c580b7_1769950246089.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker4/34/d70e0093-69a1-4911-99a5-9a6fef7baa60_1769950246019.jpg	나는 1등!	2026-02-01 21:50:46.204487	0	https://storage.googleapis.com/jupddang-images/plogging/ranker4/34/a8d2b8c1-12a5-42ee-9d64-3ff4f19c3916_1769950246141.jpg	34	2026-02-01 21:50:46.204487	ranker4
52	https://storage.googleapis.com/jupddang-images/plogging/ranker5/35/e6329249-9623-46aa-a4fa-4968f7d1cf9b_1769950254545.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker5/35/9e34eeff-a9aa-4cf7-a9d1-68c01c347fa4_1769950254423.jpg	나는 1등!	2026-02-01 21:50:54.664039	0	https://storage.googleapis.com/jupddang-images/plogging/ranker5/35/1ff8e298-441f-4f88-acfc-0893cb9c600e_1769950254600.jpg	35	2026-02-01 21:50:54.664039	ranker5
53	https://storage.googleapis.com/jupddang-images/plogging/ranker6/36/73140a96-95d6-446f-84c8-57e581b27f62_1769950261399.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker6/36/c3fec8e4-ad2a-4fb7-b1b2-1cb1f8efa73c_1769950261283.jpg	나는 1등!	2026-02-01 21:51:01.523803	0	https://storage.googleapis.com/jupddang-images/plogging/ranker6/36/bb32a032-d36e-4756-91e4-5569b4d6358e_1769950261460.jpg	36	2026-02-01 21:51:01.523803	ranker6
54	https://storage.googleapis.com/jupddang-images/plogging/ranker8/37/39c46248-1bdd-4599-bccc-38748115895f_1769950272400.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker8/37/20c00f99-1919-48c4-b923-faae7c838db8_1769950272268.jpg	나는 1등!	2026-02-01 21:51:12.509451	0	https://storage.googleapis.com/jupddang-images/plogging/ranker8/37/8de6d7a1-2bf1-4e70-af36-1c06984ddeb3_1769950272450.jpg	37	2026-02-01 21:51:12.509451	ranker8
55	https://storage.googleapis.com/jupddang-images/plogging/ranker9/38/7cf1b38b-9cf8-4b14-a869-5f613c1ebab6_1769950279117.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker9/38/2d42b98d-0269-427a-823d-db66da21747b_1769950278993.jpg	나는 1등!	2026-02-01 21:51:19.240843	0	https://storage.googleapis.com/jupddang-images/plogging/ranker9/38/0b12d822-5cfa-4c3c-b093-3f29159031f4_1769950279176.jpg	38	2026-02-01 21:51:19.240843	ranker9
56	https://storage.googleapis.com/jupddang-images/plogging/ranker10/39/a249b8dc-795c-49cf-83c9-0b9343578baa_1769950287700.jpg	https://storage.googleapis.com/jupddang-images/plogging/ranker10/39/88063300-0af5-4cf3-a20f-53c77bd749ef_1769950287586.jpg	나는 1등!	2026-02-01 21:51:27.815193	0	https://storage.googleapis.com/jupddang-images/plogging/ranker10/39/c5e67309-0582-435e-8436-b2932b61542e_1769950287757.jpg	39	2026-02-01 21:51:27.815193	ranker10
58	https://storage.googleapis.com/jupddang-images/plogging/ranker1/41/58348883-ba1f-4f44-8aa5-2d36ad5967f8_after1.webp	https://storage.googleapis.com/jupddang-images/plogging/ranker1/41/801ea247-8353-468e-b45b-125d12ea8330_before1.webp	플로깅 찢었따리	2026-02-03 15:55:14.624802	0	https://storage.googleapis.com/jupddang-images/plogging/ranker1/41/a5dbf8c4-c59a-43c9-964e-1c14fa9bd830_EkdEkajrrl.webp	41	2026-02-03 15:55:14.624802	ranker1
59	https://storage.googleapis.com/jupddang-images/plogging/ranker1/42/a8151a30-e32c-4be7-bb4e-e2839fb3852a_쓰레기없는사진3.webp	https://storage.googleapis.com/jupddang-images/plogging/ranker1/42/4d59e41c-1a7b-48eb-b40c-9d2aec479e5f_쓰레기있는사진3.webp	내가 1등이다!	2026-02-03 15:57:17.901006	0	https://storage.googleapis.com/jupddang-images/plogging/ranker1/42/288412c9-070f-41bf-a72d-df43dcb745f8_지도.webp	42	2026-02-03 15:57:17.901006	ranker1
63	\N	\N	fff	2026-02-05 01:56:12.318636	2	\N	\N	2026-02-05 14:29:29.571543	ranker9
65	\N	\N	sdf	2026-02-05 14:44:35.537136	1	\N	\N	2026-02-05 15:19:36.759067	ranker5
62	\N	\N	asdf	2026-02-05 01:55:41.700323	1	\N	\N	2026-02-05 02:57:20.445453	ranker9
64	\N	\N	asdfasdf	2026-02-05 01:56:56.012859	6	\N	\N	2026-02-05 14:29:27.151208	ranker9
66	https://storage.googleapis.com/jupddang-images/plogging/test/45/b1365ca3-b3e3-4933-9fc4-6814add3a98d_32.webp	https://storage.googleapis.com/jupddang-images/plogging/test/45/7f663fff-d52d-4dfa-be84-792ed1b9c4b3_34.webp	111\n\n기록: ddd · 2026-02-05 · 0.0km · 2초 · 0점	2026-02-05 17:15:22.050467	0	https://storage.googleapis.com/jupddang-images/plogging/test/45/6e52bf00-89c1-4756-baf0-1a4613fa612b_map_1770279308048.webp	45	2026-02-05 17:15:22.050467	test
67	https://storage.googleapis.com/jupddang-images/plogging/test/46/f2b6b761-e24b-4b98-87ba-51539f6807ae_after.webp	https://storage.googleapis.com/jupddang-images/plogging/test/46/3be7316c-1cda-4fd3-83b8-eef74ef4842a_before.webp	dd\n\n기록: dd · 2026-02-05 · 0.0km · 26초 · 0점	2026-02-05 22:54:35.13256	0	https://storage.googleapis.com/jupddang-images/plogging/test/46/1a2a3b20-b06e-4ff7-9c95-c2a084109e8e_map.webp	46	2026-02-05 22:54:35.13256	test
71	https://storage.googleapis.com/jupddang-images/plogging/ssafy/50/c0223e9a-bcc6-418e-9330-396f0de623fa_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy/50/08e04daf-a144-4ea1-9579-03e4d2e681e1_before.webp	good\n\n기록: good · 2026-02-06 · 0.0km · 44초 · 0점	2026-02-06 05:56:16.525395	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy/50/a4ef179b-1d5d-4280-9551-cb0befc4a716_map.webp	50	2026-02-06 05:56:16.525395	ssafy
72	\N	\N	굳!\n\n기록: 기록1 · 2026.02.06 · 0.00km · 0m	2026-02-06 07:47:53.800598	0	\N	\N	2026-02-06 07:47:53.800598	ssafy
73	\N	\N	ㅎㅎ\n\n기록: 기록1 · 2026.02.06 · 0.00km · 0m	2026-02-06 09:15:23.219009	0	\N	\N	2026-02-06 09:15:23.219009	ssafy
74	https://storage.googleapis.com/jupddang-images/plogging/ssafy/74/0f90fcad-2204-4807-8122-063ed320e77f_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy/74/fc4cef45-5a90-4a12-9a6d-f4d603cb2ec7_before.webp	기록2입니다!\n\n기록: 기록2 · 2026.02.06 · 0.00km · 0m	2026-02-06 09:55:34.56162	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy/74/9ac26b48-bc27-43cd-8f37-393127f85d6f_map.webp	\N	2026-02-06 09:55:35.574018	ssafy
75	https://storage.googleapis.com/jupddang-images/plogging/test/53/ba9fb530-f62c-4733-8240-3b847547875e_after.webp	https://storage.googleapis.com/jupddang-images/plogging/test/53/e54eaf90-bd35-4d1f-9e3c-c00dbcbcb60e_before.webp	dddd\n\n기록: dddd · 2026-02-06 · 0.0km · 3분 13초 · 3점	2026-02-06 10:16:22.367037	0	https://storage.googleapis.com/jupddang-images/plogging/test/53/93684eb0-a5d0-48ac-b9a5-1320c39c699c_map.webp	53	2026-02-06 10:16:22.367037	test
76	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/76/753213ec-8b5f-4e52-8832-3024d2ff2ff6_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/76/849c2803-d690-40f2-b79e-ca962fc24d64_before.webp	좋아요\n\n기록: 기록_1 · 2026.02.06 · 0.00km · 0m	2026-02-06 10:56:36.65768	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/76/084382db-95aa-470f-b8b9-d3a164924f1d_map.webp	\N	2026-02-06 10:56:39.619666	ssafy4
80	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/80/035346c3-ab72-4250-b041-f170cf8073fa_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/80/f2112f3b-075b-46f5-acde-d1bb851afc9d_before.webp	좋아요	2026-02-06 14:07:40.600516	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/80/36dea237-46d0-4d14-b064-20f4d0412982_map.webp	54	2026-02-06 14:07:44.569141	ssafy4
81	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/81/60599297-52af-48b1-a2f4-2e8efe3c8222_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/81/70635c03-8cec-4e6a-bce7-2eafa55bd7fe_before.webp	으어	2026-02-06 14:10:24.454585	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/81/78793842-3450-44fa-bbd9-7b33754d2e6b_map.webp	55	2026-02-06 14:10:27.801447	ssafy4
84	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/84/84a34111-5455-420e-a2a4-395e64492ac6_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/84/ee5d2513-31e0-46fd-a6cd-2f25f331405f_before.webp	ㅎㅎ	2026-02-06 14:26:58.24639	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/84/5981252f-6b66-4bb7-a767-0e410eb93b90_map.webp	57	2026-02-06 14:27:00.684457	ssafy4
86	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/86/5b98e9dd-fdcf-470d-8e92-37e15b8314f8_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/86/a2937e3f-359f-413d-966d-954ca257e23c_before.webp	추워요	2026-02-06 15:17:40.223787	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/86/46ab6b51-1bec-4179-b0ae-3f106a178785_map.webp	59	2026-02-06 15:17:44.457321	ssafy4
92	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/92/50d70aa7-00a8-4ce4-8e7d-42cab0e8295a_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/92/c7891a86-75fd-4201-ac68-f98cec41cd35_before.webp	임시저장 후 작성된 글 입니다\n\n기록: 비애 테스트 · 2026.02.06 · 0.00km · 0m	2026-02-06 16:08:11.047918	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/92/7d45eeba-a96d-44db-9147-663597cbecff_map.webp	63	2026-02-06 16:08:14.5737	ssafy4
87	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/87/f2be8b8b-27f0-4fbc-b75f-f683d704654b_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/87/c7585266-97eb-45f8-a2da-867c41f35e27_before.webp	배고파!\n\n기록: 기록!! · 2026.02.06 · 0.00km · 0m	2026-02-06 15:39:11.535117	1	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/87/73738ade-e4a0-4e67-8e3b-7a75189eb60f_map.webp	60	2026-02-06 15:45:13.328771	ssafy4
88	https://storage.googleapis.com/jupddang-images/plogging/test/61/0d78b60b-4a40-491a-ad7a-cc2108c0ebba_after.webp	https://storage.googleapis.com/jupddang-images/plogging/test/61/a4628978-ba59-4c14-b139-698d78eba7b6_before.webp	추워요\n\n기록: 동네 한바퀴 · 2026-02-06 · 0.2km · 4분 26초 · 6점	2026-02-06 15:48:29.886442	0	https://storage.googleapis.com/jupddang-images/plogging/test/61/aa843691-7dcb-4b2e-9f52-6ed2c9c22445_map.webp	61	2026-02-06 15:48:29.886442	test
89	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/62/ecc500fb-bac6-41cf-818e-e29d40b8cea4_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/62/af2384c3-a3e7-4609-87e5-619158667dce_before.webp	비포 애프터 테스트\n\n기록: 비애 · 2026-02-06 · 0.0km · 27초 · 0점	2026-02-06 15:59:24.35314	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/62/4eb2e4f7-a958-462c-8709-d5ceecf5b28e_map.webp	62	2026-02-06 15:59:24.35314	ssafy4
93	https://storage.googleapis.com/jupddang-images/plogging/test/64/cd7992c3-066d-4dea-8c69-f68d625e8ac9_after.webp	https://storage.googleapis.com/jupddang-images/plogging/test/64/a14715c3-3f65-4085-928a-079e82af739f_before.webp	ddd\n\n기록: ddd · 2026-02-06 · 0.0km · 45초 · 0점	2026-02-06 16:26:44.90645	0	https://storage.googleapis.com/jupddang-images/plogging/test/64/0d0f55d5-4978-4e04-9565-ddb2b782297a_map.webp	64	2026-02-06 16:26:44.90645	test
94	https://storage.googleapis.com/jupddang-images/plogging/test/65/a54dfd0a-c5e9-4b90-8dfe-c650ee0be865_after.webp	https://storage.googleapis.com/jupddang-images/plogging/test/65/f7731159-1a36-4c64-b73c-13e2fa9331dc_before.webp	ddd\n\n기록: ddd · 2026-02-06 · 0.0km · 1분 5초 · 1점	2026-02-06 16:30:20.49931	0	https://storage.googleapis.com/jupddang-images/plogging/test/65/6441a244-4a7a-435d-88e6-6cc720a7e07c_map.webp	65	2026-02-06 16:30:20.49931	test
95	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/66/d84520b4-a379-4413-be5f-8b9d76e3b676_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/66/f1344162-315f-4397-ad26-1c152dd64968_before.webp	TLI 작성하세요\n\n기록: TMI · 2026-02-06 · 0.0km · 30초 · 0점	2026-02-06 16:58:12.152697	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/66/29b6b907-03bb-48fa-a0e5-82cd80118659_map.webp	66	2026-02-06 16:58:12.152697	ssafy4
97	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/68/176a2577-eadc-4613-aa4a-1013045ca4f1_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/68/54faee0a-5dfa-426c-82d1-3e23cb40407e_before.webp	일반 종료\n\n기록: 일반 종료 · 2026-02-06 · 0.0km · 20초 · 0점	2026-02-06 17:15:41.776891	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/68/1b62fd26-9606-4b26-b382-5c3f89011a1a_map.webp	68	2026-02-06 17:15:41.776891	ssafy4
98	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/98/f11146bd-4ccb-4191-8e91-4e4a33b0caad_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/98/6179bdbb-ccd2-461f-ba87-6b75e5ad23eb_before.webp	임시 저장 테스트\n\n기록: 임시 저장 테스트 · 2026.02.06 · 0.00km · 0m · 0점	2026-02-06 17:27:33.079351	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/98/abb8cbda-85c6-4672-b681-22aa9c799f26_map.webp	69	2026-02-06 17:27:36.844598	ssafy4
99	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/99/b3be475d-19fb-4d69-9f5a-c2a7b0d2a430_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/99/41c69608-cdba-4507-bb6d-f6dda7c3bbda_before.webp	임시테스트2\n\n기록: 임시테스트2 · 2026.02.06 · 0.00km · 0m · 0점	2026-02-06 17:38:51.540527	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/99/c51ddb1c-bb92-4ac0-a881-194b0c17c958_map.webp	70	2026-02-06 17:38:56.084838	ssafy4
100	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/71/c5d0baa0-1cdf-4809-8148-74e2de77b576_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/71/b8824cfb-5dff-4c46-b398-ef4e241e4f68_before.webp	일반 플러깅 테스트\n\n기록: 일반 플러깅 테스트 · 2026-02-06 · 0.0km · 25초 · 0점	2026-02-06 17:40:06.136366	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/71/6787aecf-10db-4d0b-9d78-c3b3152d7c35_map.webp	71	2026-02-06 17:40:06.136366	ssafy4
101	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/72/21c985e0-cb3f-4275-920e-30f760381263_after.webp	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/72/c1e5ee53-2bed-4edc-b772-25d2d6135534_before.webp	일반 플러깅 테스트\n\n기록: 일반 플러깅 테스트 · 2026-02-06 · 0.0km · 25초 · 0점	2026-02-06 17:41:14.727625	0	https://storage.googleapis.com/jupddang-images/plogging/ssafy4/72/c501d2bd-f405-4865-9d51-76287d913193_map.webp	72	2026-02-06 17:41:14.727625	ssafy4
102	https://storage.googleapis.com/jupddang-images/plogging/user1/73/1a9cc8db-6992-48e1-a6dd-237e3ae84058_after.webp	https://storage.googleapis.com/jupddang-images/plogging/user1/73/e0e5c8b5-1cef-4ed6-83cf-41ac1543e0d1_before.webp	춥지만 뿌듯합니당 ㅎㅎ\n\n기록: 토욜밤 플로깅 · 2026-02-07 · 0.2km · 9분 10초 · 11점	2026-02-07 21:28:41.089744	0	https://storage.googleapis.com/jupddang-images/plogging/user1/73/b65b18dd-8f5d-4565-9078-df792126eafa_map.webp	73	2026-02-07 21:28:41.089744	user1
103	https://storage.googleapis.com/jupddang-images/plogging/user2/74/21656bd4-f24b-4317-8686-fd9bc5a105f7_after.webp	https://storage.googleapis.com/jupddang-images/plogging/user2/74/339377e8-39fb-4d66-acaa-f1150613f752_before.webp	오플완!\n\n기록: 오플완 · 2026-02-07 · 0.2km · 5분 43초 · 6점	2026-02-07 21:35:22.895885	0	https://storage.googleapis.com/jupddang-images/plogging/user2/74/9842c435-ad91-4a8a-b65b-d76927b134cf_map.webp	74	2026-02-07 21:35:22.895885	user2
104	https://storage.googleapis.com/jupddang-images/plogging/user3/75/29668c12-80e1-4108-8520-326098afc5e5_after.webp	https://storage.googleapis.com/jupddang-images/plogging/user3/75/073cba6f-f4a7-445b-9dfc-a88ec0b13779_before.webp	오늘은 담배꽁초 주웠습니다\n\n기록: 2월7일 · 2026-02-07 · 0.0km · 4분 45초 · 4점	2026-02-07 21:42:14.308159	0	https://storage.googleapis.com/jupddang-images/plogging/user3/75/94e183d7-3fce-4547-9a4f-c0b22e78021f_map.webp	75	2026-02-07 21:42:14.308159	user3
61	https://storage.googleapis.com/jupddang-images/plogging/ranker1/44/39370c1d-345f-47c6-99c1-83bd338b3944_쓰레기없는사진4.webp	https://storage.googleapis.com/jupddang-images/plogging/ranker1/44/0088f187-5ea3-4570-a294-80897781bbc9_쓰레기있는사진4.webp	내가 1등이다!	2026-02-03 16:08:07.484536	2	https://storage.googleapis.com/jupddang-images/plogging/ranker1/44/08bda834-e202-4c23-a41b-6519f45a06f6_지도.webp	44	2026-02-07 21:55:57.005554	ranker1
105	https://storage.googleapis.com/jupddang-images/plogging/user4/76/7cb6fd55-af73-4ac4-bb1e-0c61a6676c96_after.webp	https://storage.googleapis.com/jupddang-images/plogging/user4/76/2f3ec736-53f0-494c-b28b-bf7121e50cf6_before.webp	춥지만.. 마음은 따뜻합니다..\n\n기록: 구미 플로깅 · 2026-02-07 · 0.1km · 12분 11초 · 13점	2026-02-07 21:56:51.629578	1	https://storage.googleapis.com/jupddang-images/plogging/user4/76/543b8673-ba02-4fce-95ad-2b32c21108d0_map.webp	76	2026-02-07 23:55:50.836403	user4
106	https://storage.googleapis.com/jupddang-images/plogging/komae/77/cc0c93a1-002f-4a0f-a7be-67094d0668be_after.webp	https://storage.googleapis.com/jupddang-images/plogging/komae/77/c194b923-fd74-495e-913e-9d3bab229039_before.webp	cold\n\n기록: cold · 2026-02-08 · 0.1km · 1분 31초 · 2점	2026-02-08 00:09:08.983212	1	https://storage.googleapis.com/jupddang-images/plogging/komae/77/e44cacb9-3aaf-418a-907a-1be3dcb4bd93_map.webp	77	2026-02-08 00:29:11.213302	komae
108	https://storage.googleapis.com/jupddang-images/plogging/komae/78/9d81326b-b050-47e2-8719-eaa66b191d51_after.webp	https://storage.googleapis.com/jupddang-images/plogging/komae/78/b8f1feb8-3d9e-4908-abcc-5ed9770c9dc1_before.webp	춥다\n\n기록: 춥다 · 2026-02-08 · 0.1km · 2분 15초 · 3점	2026-02-08 13:10:03.352408	1	https://storage.googleapis.com/jupddang-images/plogging/komae/78/ed211e58-4246-404f-83e4-6172cd5c4d35_map.webp	78	2026-02-08 15:36:21.458789	komae
110	https://storage.googleapis.com/jupddang-images/plogging/user5/80/0f513f85-80b4-4b6d-bf10-209925139ed1_after.webp	https://storage.googleapis.com/jupddang-images/plogging/user5/80/dfe0eae2-5a77-4053-afa8-0857f8ca48d4_before.webp	추워요!! 어제보단 덜\n\n기록: 담꽁 · 2026-02-08 · 0.3km · 8분 13초 · 11점	2026-02-08 21:50:02.099596	0	https://storage.googleapis.com/jupddang-images/plogging/user5/80/7189be62-da58-43b6-8242-3a2614f2865d_map.webp	80	2026-02-08 21:50:02.099596	user5
111	https://storage.googleapis.com/jupddang-images/plogging/user1/81/9060e38a-b9df-4547-9ce5-83e2b5c551b5_after.webp	https://storage.googleapis.com/jupddang-images/plogging/user1/81/e3bf592b-c041-4779-a4a8-986b7836b94b_before.webp	짧플\n\n기록: 짧은 플로깅 · 2026-02-08 · 0.1km · 2분 54초 · 2점	2026-02-08 21:54:09.169847	0	https://storage.googleapis.com/jupddang-images/plogging/user1/81/18562e86-dffc-4171-b5e8-28d7357b8805_map.webp	81	2026-02-08 21:54:09.169847	user1
112	https://storage.googleapis.com/jupddang-images/plogging/user2/82/fbe759d2-2a06-4967-b2ef-f69db7ab591f_after.webp	https://storage.googleapis.com/jupddang-images/plogging/user2/82/3daa6f57-863d-4aac-95a2-523abeaf735e_before.webp	세탁소 앞 청소\n\n기록: 동네 플로깅 · 2026-02-08 · 0.0km · 4분 2초 · 4점	2026-02-08 21:59:23.392614	0	https://storage.googleapis.com/jupddang-images/plogging/user2/82/f47745de-3822-4494-b375-422e5cc9af1a_map.webp	82	2026-02-08 21:59:23.392614	user2
113	https://storage.googleapis.com/jupddang-images/plogging/user3/83/8059423a-c1cd-442c-844a-ef16204cac33_after.webp	https://storage.googleapis.com/jupddang-images/plogging/user3/83/665127fc-6ddb-4ea0-a83c-7f0618f6ff14_before.webp	집 앞 청소 했습니다\n\n기록: 집 근처 플로깅 · 2026-02-08 · 0.2km · 4분 59초 · 5점	2026-02-08 22:05:19.948996	0	https://storage.googleapis.com/jupddang-images/plogging/user3/83/910adbce-3e81-45c7-af3e-807186d48deb_map.webp	83	2026-02-08 22:05:19.948996	user3
114	https://storage.googleapis.com/jupddang-images/plogging/user4/84/ef79d3f7-e062-478e-a930-317a6342d94b_after.webp	https://storage.googleapis.com/jupddang-images/plogging/user4/84/ae8ecfac-47c0-4c0b-b86d-b1a6a2c3395e_before.webp	추우ㅏ요\n\n기록: 춥춥 · 2026-02-08 · 0.5km · 10분 38초 · 15점	2026-02-08 22:17:05.711569	0	https://storage.googleapis.com/jupddang-images/plogging/user4/84/08f8e7d3-3b3d-4025-ac4b-4f4ea5e37634_map.webp	84	2026-02-08 22:17:05.711569	user4
115	https://storage.googleapis.com/jupddang-images/plogging/komae/85/69997e68-6844-4193-9a13-8c6a2acf0c06_after.webp	https://storage.googleapis.com/jupddang-images/plogging/komae/85/d27f73a0-3e26-4018-83ab-125954cee0ff_before.webp	cold\n\n기록: cold · 2026-02-08 · 0.1km · 8분 15초 · 9점	2026-02-08 22:31:08.786791	0	https://storage.googleapis.com/jupddang-images/plogging/komae/85/7f0cd8d0-7744-4067-bb09-df0a6e704f5d_map.webp	85	2026-02-08 22:31:08.786791	komae
116	https://storage.googleapis.com/jupddang-images/plogging/komae/86/7d9d9dd6-33ca-4101-8fd3-2fea2df7ce91_after.webp	https://storage.googleapis.com/jupddang-images/plogging/komae/86/e8d54209-f7b4-4029-9e70-b2cd27a7778a_before.webp	..\n\n기록: .. · 2026-02-08 · 0.1km · 1분 33초 · 2점	2026-02-08 22:44:08.587358	0	https://storage.googleapis.com/jupddang-images/plogging/komae/86/e50228c9-ae49-4099-965e-c3c3b095d79d_map.webp	86	2026-02-08 22:44:08.587358	komae
117	https://storage.googleapis.com/jupddang-images/plogging/komae/87/94d1cc45-a81a-4315-97f6-a345f853db7b_after.webp	https://storage.googleapis.com/jupddang-images/plogging/komae/87/312a569a-6717-4084-a1c8-609bd7a38d11_before.webp	.\n\n기록: . · 2026-02-08 · 0.1km · 17분 53초 · 18점	2026-02-08 23:24:37.850795	0	https://storage.googleapis.com/jupddang-images/plogging/komae/87/f65040df-2102-460f-8d0f-12078f866d64_map.webp	87	2026-02-08 23:24:37.850795	komae
118	https://storage.googleapis.com/jupddang-images/plogging/komae/88/989f1fa4-9c46-4c8b-9079-69b5a759928d_after.webp	https://storage.googleapis.com/jupddang-images/plogging/komae/88/8efcffda-2081-475d-a6eb-f9c328fb53ac_before.webp	.\n\n기록: . · 2026-02-08 · 0.1km · 17분 8초 · 23점	2026-02-08 23:49:54.535432	0	https://storage.googleapis.com/jupddang-images/plogging/komae/88/436b58ca-3aa6-4f7c-807f-a540ef7ed8fd_map.webp	88	2026-02-08 23:49:54.535432	komae
119	https://storage.googleapis.com/jupddang-images/plogging/komae/89/67622d11-3a23-4133-8488-79bf8747057c_after.webp	https://storage.googleapis.com/jupddang-images/plogging/komae/89/cfc094f6-a9ed-416a-9699-9c086c610e48_before.webp	..\n\n기록: .. · 2026-02-09 · 0.1km · 7분 41초 · 13점	2026-02-09 00:06:45.577885	0	https://storage.googleapis.com/jupddang-images/plogging/komae/89/c07eafc5-f3d1-484c-a148-d944f0d3cd8f_map.webp	89	2026-02-09 00:06:45.577885	komae
\.


--
-- Data for Name: raid_boss; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.raid_boss (id, h3index, name, boss_type) FROM stdin;
1	8b2b90d2c94ffff	SSAFY_캠퍼스_보스	0
2	8b2b90d2c92ffff	금오산_입구_보스	0
3	8b2b90d2c93ffff	캠퍼스_북쪽_보스	0
4	8b2b90d2c95ffff	캠퍼스_동쪽_보스	0
5	8b2b90d2c96ffff	캠퍼스_남쪽_보스	0
6	8b30e1882cdafff	중심 쓰레기존	0
7	8b30e1882cd8fff	동쪽 먼지구역	2
8	8b30e1882cd2fff	서쪽 쓰레기봉투	1
9	8b30e1882cdcfff	북쪽 썩은 새싹	3
\.


--
-- Data for Name: raid_record; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.raid_record (id, total_score, updated_at, account_user_id, boss_id) FROM stdin;
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: test_entity; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.test_entity (id, content) FROM stdin;
\.


--
-- Data for Name: trashcan_verifications; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.trashcan_verifications (id, verified_at, trashcan_id, user_id) FROM stdin;
1	2026-02-03 13:28:39.266151	3013	test
2	2026-02-06 16:25:03.110857	3014	test
3	2026-02-08 01:33:19.081581	3015	ranker1
\.


--
-- Data for Name: trashcans; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.trashcans (id, address, created_at, latitude, longitude, status, updated_at, verification_count, reported_by) FROM stdin;
1	대구광역시 남구 이천로28길 42-16 대구광역시 남구 대명동 383-4	2026-01-29 23:28:24.744173	35.85385142	128.5998035	OFFICIAL	2026-01-29 23:28:24.744243	0	\N
2	대구광역시 남구 봉덕로11길 13 대구광역시 남구 봉덕동 705-32	2026-01-29 23:28:24.763183	35.84565736	128.5957994	OFFICIAL	2026-01-29 23:28:24.763205	0	\N
3	대구광역시 남구 중앙대로22길 100 대구광역시 남구 봉덕동 702-6	2026-01-29 23:28:24.764265	35.8424186	128.5959476	OFFICIAL	2026-01-29 23:28:24.764285	0	\N
4	대구광역시 남구 대명로30길 14 대구광역시 남구 대명동 916-2	2026-01-29 23:28:24.765259	35.8384918	128.5738239	OFFICIAL	2026-01-29 23:28:24.765281	0	\N
5	대구광역시 남구 큰골길 53 대구광역시 남구 대명동 2680-7	2026-01-29 23:28:24.76628	35.8372536	128.5790379	OFFICIAL	2026-01-29 23:28:24.766299	0	\N
6	대구광역시 남구 대명역6길 48 대구광역시 남구 대명동 1540	2026-01-29 23:28:24.767682	35.83269131	128.5640623	OFFICIAL	2026-01-29 23:28:24.767704	0	\N
7	대구광역시 남구 관문시장4길 53 대구광역시 남구 대명동 1180	2026-01-29 23:28:24.768902	35.83624135	128.560605	OFFICIAL	2026-01-29 23:28:24.768921	0	\N
8	대구광역시 남구 계명7길 18 대구광역시 남구 대명동 2255-1	2026-01-29 23:28:24.77008	35.85275091	128.5778762	OFFICIAL	2026-01-29 23:28:24.7701	0	\N
9	대구광역시 남구 명덕로20길 115 대구광역시 남구 대명동 642-46	2026-01-29 23:28:24.771129	35.85230083	128.5790561	OFFICIAL	2026-01-29 23:28:24.771148	0	\N
10	대구광역시 남구 두류공원로12길 25-48 대구광역시 남구 봉덕동 1067-121	2026-01-29 23:28:24.772126	35.84383615	128.5744916	OFFICIAL	2026-01-29 23:28:24.772148	0	\N
11	대구광역시 남구 두류공원로20길 19 대구광역시 남구 대명동 3043-34	2026-01-29 23:28:24.773111	35.84596976	128.5695016	OFFICIAL	2026-01-29 23:28:24.773129	0	\N
12	대구광역시 남구 봉덕로5길 20 대구광역시 남구 봉덕동 592-9	2026-01-29 23:28:24.774055	35.8461956	128.5933294	OFFICIAL	2026-01-29 23:28:24.774075	0	\N
13	대구광역시 남구 봉덕로6길35-63 대구광역시 남구 봉덕동 990-17	2026-01-29 23:28:24.775052	35.84323063	128.5922385	OFFICIAL	2026-01-29 23:28:24.775086	0	\N
14	대구광역시 남구 자유3길 54 대구광역시 남구 대명동 353-6	2026-01-29 23:28:24.776089	35.83876049	128.5819202	OFFICIAL	2026-01-29 23:28:24.776108	0	\N
15	대구광역시 남구 대명로21길 9 대구광역시 남구 대명동 1624-22	2026-01-29 23:28:24.777381	35.84009483	128.5691654	OFFICIAL	2026-01-29 23:28:24.777403	0	\N
16	대구광역시 남구 두류공원로 38 대구광역시 남구 대명동 1652-1	2026-01-29 23:28:24.778531	35.84171631	128.5735748	OFFICIAL	2026-01-29 23:28:24.778551	0	\N
17	대구광역시 남구 명덕로32길 30 대구광역시 남구 대명동 1827	2026-01-29 23:28:24.779633	35.85528539	128.5862415	OFFICIAL	2026-01-29 23:28:24.779652	0	\N
18	경기도 파주시 교하로425번길 1 경기도 파주시 동패동 302-2	2026-01-29 23:28:24.780662	37.70563342	126.7318432	OFFICIAL	2026-01-29 23:28:24.780681	0	\N
19	경기도 파주시 동패동 1363-4	2026-01-29 23:28:24.781815	37.70512501	126.7319539	OFFICIAL	2026-01-29 23:28:24.781835	0	\N
20	경기도 파주시 목동동 1150	2026-01-29 23:28:24.782849	37.72481244	126.7355358	OFFICIAL	2026-01-29 23:28:24.782871	0	\N
21	경기도 파주시 동패동 1903	2026-01-29 23:28:24.78386	37.71128925	126.737337	OFFICIAL	2026-01-29 23:28:24.783881	0	\N
22	경기도 파주시 동패동 1764	2026-01-29 23:28:24.78494	37.71007189	126.7409982	OFFICIAL	2026-01-29 23:28:24.784958	0	\N
23	경기도 파주시 동패동 1756-1	2026-01-29 23:28:24.785905	37.71036444	126.7403727	OFFICIAL	2026-01-29 23:28:24.785925	0	\N
24	경기도 파주시 동패동 1833	2026-01-29 23:28:24.786871	37.71586004	126.7383055	OFFICIAL	2026-01-29 23:28:24.78689	0	\N
25	경기도 파주시 동패동 1750	2026-01-29 23:28:24.787938	37.71299273	126.7424609	OFFICIAL	2026-01-29 23:28:24.787957	0	\N
26	경기도 파주시 동패동 1750	2026-01-29 23:28:24.788928	37.71299273	126.7424609	OFFICIAL	2026-01-29 23:28:24.788948	0	\N
27	경기도 파주시 목동동 676	2026-01-29 23:28:24.789914	37.72399972	126.7474984	OFFICIAL	2026-01-29 23:28:24.789934	0	\N
28	경기도 파주시 목동동 676	2026-01-29 23:28:24.790903	37.72399972	126.7474984	OFFICIAL	2026-01-29 23:28:24.790922	0	\N
29	경기도 파주시 목동동 1050	2026-01-29 23:28:24.791993	37.72147402	126.7371394	OFFICIAL	2026-01-29 23:28:24.792013	0	\N
30	경기도 파주시 목동동 1008	2026-01-29 23:28:24.793028	37.72524807	126.7372276	OFFICIAL	2026-01-29 23:28:24.793047	0	\N
31	경기도 파주시 야당동 1019-1	2026-01-29 23:28:24.794011	37.71008898	126.7560668	OFFICIAL	2026-01-29 23:28:24.794029	0	\N
32	경기도 파주시 야당동 1020	2026-01-29 23:28:24.795068	37.71103055	126.7502093	OFFICIAL	2026-01-29 23:28:24.795089	0	\N
33	경기도 파주시 야당동 1020	2026-01-29 23:28:24.796128	37.71103055	126.7502093	OFFICIAL	2026-01-29 23:28:24.796149	0	\N
34	경기도 파주시 목동동 870	2026-01-29 23:28:24.797102	37.73192514	126.7358329	OFFICIAL	2026-01-29 23:28:24.797121	0	\N
35	경기도 파주시 야당동 998	2026-01-29 23:28:24.79816	37.7120697	126.7591269	OFFICIAL	2026-01-29 23:28:24.798182	0	\N
36	경기도 파주시 야당동 998	2026-01-29 23:28:24.799096	37.7120697	126.7591269	OFFICIAL	2026-01-29 23:28:24.799118	0	\N
37	경기도 파주시 야당동 990	2026-01-29 23:28:24.800053	37.71326307	126.7539702	OFFICIAL	2026-01-29 23:28:24.800071	0	\N
38	경기도 파주시 목동동 870	2026-01-29 23:28:24.801027	37.73192514	126.7358329	OFFICIAL	2026-01-29 23:28:24.801046	0	\N
39	경기도 파주시 야당동 998	2026-01-29 23:28:24.801972	37.7120697	126.7591269	OFFICIAL	2026-01-29 23:28:24.801991	0	\N
40	경기도 파주시 야당동 998	2026-01-29 23:28:24.802914	37.7120697	126.7591269	OFFICIAL	2026-01-29 23:28:24.802932	0	\N
41	경기도 파주시 야당동 989	2026-01-29 23:28:24.803831	37.71685622	126.7535333	OFFICIAL	2026-01-29 23:28:24.80385	0	\N
42	경기도 파주시 야당동 989	2026-01-29 23:28:24.804827	37.71685622	126.7535333	OFFICIAL	2026-01-29 23:28:24.804848	0	\N
43	경기도 파주시 야당동 1022-5	2026-01-29 23:28:24.80586	37.7091436	126.7464058	OFFICIAL	2026-01-29 23:28:24.805878	0	\N
44	경기도 파주시 동패동 1749	2026-01-29 23:28:24.806916	37.71223811	126.7462207	OFFICIAL	2026-01-29 23:28:24.806936	0	\N
45	경기도 파주시 야당동 980	2026-01-29 23:28:24.807894	37.71225363	126.74645	OFFICIAL	2026-01-29 23:28:24.807913	0	\N
46	경기도 파주시 동패동 1749	2026-01-29 23:28:24.808858	37.71223811	126.7462207	OFFICIAL	2026-01-29 23:28:24.808877	0	\N
47	경기도 파주시 와동동 1405	2026-01-29 23:28:24.809813	37.72189881	126.7491674	OFFICIAL	2026-01-29 23:28:24.809833	0	\N
48	경기도 파주시 와동동 1364	2026-01-29 23:28:24.810861	37.72635513	126.7516634	OFFICIAL	2026-01-29 23:28:24.810881	0	\N
49	경기도 파주시 와동동 1305	2026-01-29 23:28:24.811789	37.73150741	126.7512577	OFFICIAL	2026-01-29 23:28:24.811808	0	\N
50	경기도 파주시 목동동 645	2026-01-29 23:28:24.812656	37.72957855	126.7456089	OFFICIAL	2026-01-29 23:28:24.812675	0	\N
51	경기도 파주시 와동동 1393	2026-01-29 23:28:24.813865	37.72376034	126.7546741	OFFICIAL	2026-01-29 23:28:24.813928	0	\N
52	경기도 파주시 와동동 1421	2026-01-29 23:28:24.814969	37.72417538	126.7658301	OFFICIAL	2026-01-29 23:28:24.814987	0	\N
53	경기도 파주시 와동동 1329	2026-01-29 23:28:24.816047	37.72609443	126.7609012	OFFICIAL	2026-01-29 23:28:24.816067	0	\N
54	경기도 파주시 와동동 1329	2026-01-29 23:28:24.817213	37.72609443	126.7609012	OFFICIAL	2026-01-29 23:28:24.817231	0	\N
55	경기도 파주시 와동동 1342	2026-01-29 23:28:24.818187	37.72986083	126.7560803	OFFICIAL	2026-01-29 23:28:24.818221	0	\N
56	경기도 파주시 와동동 1342	2026-01-29 23:28:24.819165	37.72986083	126.7560803	OFFICIAL	2026-01-29 23:28:24.819197	0	\N
57	경기도 파주시 금바위로 50 경기도 파주시 와동동 1378	2026-01-29 23:28:24.82013	37.72902871	126.7588583	OFFICIAL	2026-01-29 23:28:24.820148	0	\N
58	경기도 파주시 와동동 1376	2026-01-29 23:28:24.821069	37.72713251	126.7584582	OFFICIAL	2026-01-29 23:28:24.821088	0	\N
59	경기도 파주시 와동동 1369-1	2026-01-29 23:28:24.82208	37.72392455	126.7545938	OFFICIAL	2026-01-29 23:28:24.822099	0	\N
60	경기도 파주시 와동동 1370	2026-01-29 23:28:24.823098	37.72502177	126.7561433	OFFICIAL	2026-01-29 23:28:24.823117	0	\N
61	경기도 파주시 동패동 1792	2026-01-29 23:28:24.824222	37.71706943	126.7377643	OFFICIAL	2026-01-29 23:28:24.824242	0	\N
62	경기도 파주시 동패동 1833	2026-01-29 23:28:24.825386	37.71586004	126.7383055	OFFICIAL	2026-01-29 23:28:24.825405	0	\N
63	경기도 파주시 동패동 1792	2026-01-29 23:28:24.82652	37.71706943	126.7377643	OFFICIAL	2026-01-29 23:28:24.826539	0	\N
64	경기도 파주시 와석순환로 415 경기도 파주시 와동동 1358	2026-01-29 23:28:24.828301	37.72402922	126.7513065	OFFICIAL	2026-01-29 23:28:24.828363	0	\N
65	경기도 파주시 와석순환로 415 경기도 파주시 와동동 1358	2026-01-29 23:28:24.830098	37.72402922	126.7513065	OFFICIAL	2026-01-29 23:28:24.830119	0	\N
66	경기도 파주시 와동동 1364	2026-01-29 23:28:24.831093	37.72635513	126.7516634	OFFICIAL	2026-01-29 23:28:24.831111	0	\N
67	경기도 파주시 미래로 564 경기도 파주시 와동동 1344	2026-01-29 23:28:24.83206	37.72766106	126.7531214	OFFICIAL	2026-01-29 23:28:24.832078	0	\N
68	경기도 파주시 미래로 610 경기도 파주시 와동동 1303-1	2026-01-29 23:28:24.833151	37.73165607	126.7514599	OFFICIAL	2026-01-29 23:28:24.833189	0	\N
69	경기도 파주시 가람로 22 경기도 파주시 와동동 1308	2026-01-29 23:28:24.834146	37.73292356	126.7533502	OFFICIAL	2026-01-29 23:28:24.834177	0	\N
70	경기도 파주시 가람로 70 경기도 파주시 와동동 1321	2026-01-29 23:28:24.835091	37.73465466	126.7583889	OFFICIAL	2026-01-29 23:28:24.835138	0	\N
71	경기도 파주시 가람로 59 경기도 파주시 와동동 1553-1	2026-01-29 23:28:24.835986	37.73476235	126.7565601	OFFICIAL	2026-01-29 23:28:24.836022	0	\N
72	경기도 파주시 동패동 2148	2026-01-29 23:28:24.836891	37.71602862	126.7144667	OFFICIAL	2026-01-29 23:28:24.836908	0	\N
73	경기도 파주시 동패동 2154	2026-01-29 23:28:24.837896	37.7135641	126.7078536	OFFICIAL	2026-01-29 23:28:24.837913	0	\N
74	경기도 파주시 동패동 2154	2026-01-29 23:28:24.838856	37.7135641	126.7078536	OFFICIAL	2026-01-29 23:28:24.838875	0	\N
75	경기도 파주시 문발동 541-3	2026-01-29 23:28:24.839725	37.71586589	126.6911528	OFFICIAL	2026-01-29 23:28:24.83974	0	\N
76	경기도 파주시 문발동 541-3	2026-01-29 23:28:24.840677	37.71586589	126.6911528	OFFICIAL	2026-01-29 23:28:24.840694	0	\N
77	경기도 파주시 문발동 541-12	2026-01-29 23:28:24.841578	37.70170543	126.686117	OFFICIAL	2026-01-29 23:28:24.841594	0	\N
78	경기도 파주시 문발동 541-12	2026-01-29 23:28:24.842468	37.70170543	126.686117	OFFICIAL	2026-01-29 23:28:24.842484	0	\N
79	경기도 파주시 문발동 541-2	2026-01-29 23:28:24.84334	37.7138612	126.6873952	OFFICIAL	2026-01-29 23:28:24.843356	0	\N
80	경기도 파주시 문발로 233 경기도 파주시 문발동 502-1	2026-01-29 23:28:24.844252	37.71516574	126.6875146	OFFICIAL	2026-01-29 23:28:24.844268	0	\N
81	경기도 파주시 문발동 541-2	2026-01-29 23:28:24.845285	37.7138612	126.6873952	OFFICIAL	2026-01-29 23:28:24.845301	0	\N
82	경기도 파주시 문발동 541-2	2026-01-29 23:28:24.84615	37.7138612	126.6873952	OFFICIAL	2026-01-29 23:28:24.846166	0	\N
83	경기도 파주시 문발동 541-2	2026-01-29 23:28:24.847021	37.7138612	126.6873952	OFFICIAL	2026-01-29 23:28:24.847037	0	\N
84	경기도 파주시 문발동 541-2	2026-01-29 23:28:24.847914	37.7138612	126.6873952	OFFICIAL	2026-01-29 23:28:24.84793	0	\N
85	경기도 파주시 서패동 305-1	2026-01-29 23:28:24.84893	37.71671563	126.6957951	OFFICIAL	2026-01-29 23:28:24.848947	0	\N
86	경기도 파주시 신촌동 산 55-3	2026-01-29 23:28:24.849934	37.73072362	126.7083059	OFFICIAL	2026-01-29 23:28:24.849951	0	\N
87	경기도 파주시 신촌동 703	2026-01-29 23:28:24.850858	37.73051673	126.7082899	OFFICIAL	2026-01-29 23:28:24.850875	0	\N
88	경기도 파주시 문발동 32-1	2026-01-29 23:28:24.851716	37.72867906	126.7064347	OFFICIAL	2026-01-29 23:28:24.85173	0	\N
89	경기도 파주시 문발동 621	2026-01-29 23:28:24.852586	37.72722975	126.7089423	OFFICIAL	2026-01-29 23:28:24.8526	0	\N
90	경기도 파주시 문발동 621	2026-01-29 23:28:24.853441	37.72722975	126.7089423	OFFICIAL	2026-01-29 23:28:24.853455	0	\N
91	경기도 파주시 문발동 621	2026-01-29 23:28:24.854281	37.72722975	126.7089423	OFFICIAL	2026-01-29 23:28:24.854296	0	\N
92	경기도 파주시 동패동 1745-8	2026-01-29 23:28:24.855148	37.72353613	126.7227707	OFFICIAL	2026-01-29 23:28:24.855163	0	\N
93	경기도 파주시 동패동 1745-2	2026-01-29 23:28:24.856055	37.72181355	126.7173793	OFFICIAL	2026-01-29 23:28:24.856118	0	\N
94	경기도 파주시 동패동 1711-1	2026-01-29 23:28:24.857053	37.71991202	126.7190772	OFFICIAL	2026-01-29 23:28:24.857077	0	\N
95	경기도 파주시 동패동 1745-2	2026-01-29 23:28:24.857949	37.72181355	126.7173793	OFFICIAL	2026-01-29 23:28:24.857963	0	\N
96	경기도 파주시 동패동 1704-1	2026-01-29 23:28:24.858939	37.72213757	126.7175437	OFFICIAL	2026-01-29 23:28:24.858954	0	\N
97	경기도 파주시 동패동 1745-7	2026-01-29 23:28:24.85974	37.72433601	126.7201435	OFFICIAL	2026-01-29 23:28:24.859788	0	\N
98	경기도 파주시 동패동 1745-7	2026-01-29 23:28:24.860852	37.72433601	126.7201435	OFFICIAL	2026-01-29 23:28:24.860868	0	\N
99	경기도 파주시 책향기로 423 경기도 파주시 동패동 1701	2026-01-29 23:28:24.861671	37.72492304	126.7189297	OFFICIAL	2026-01-29 23:28:24.861711	0	\N
100	경기도 파주시 동패동 1745-2	2026-01-29 23:28:24.863064	37.72181355	126.7173793	OFFICIAL	2026-01-29 23:28:24.863111	0	\N
101	경기도 파주시 동패동 1745-2	2026-01-29 23:28:24.864	37.72181355	126.7173793	OFFICIAL	2026-01-29 23:28:24.864014	0	\N
102	경기도 파주시 다율동 1003	2026-01-29 23:28:24.864884	37.73204777	126.7191699	OFFICIAL	2026-01-29 23:28:24.864899	0	\N
103	경기도 파주시 다율동 1003	2026-01-29 23:28:24.865721	37.73204777	126.7191699	OFFICIAL	2026-01-29 23:28:24.865735	0	\N
104	경기도 파주시 다율동 982-1	2026-01-29 23:28:24.866548	37.7331968	126.7196748	OFFICIAL	2026-01-29 23:28:24.866562	0	\N
105	경기도 파주시 교하동 372-1	2026-01-29 23:28:24.867472	37.75200818	126.750513	OFFICIAL	2026-01-29 23:28:24.867486	0	\N
106	경기도 파주시 교하동 372-1	2026-01-29 23:28:24.868311	37.75200818	126.750513	OFFICIAL	2026-01-29 23:28:24.868325	0	\N
107	경기도 파주시 당하동 151-1	2026-01-29 23:28:24.869192	37.746312	126.7518564	OFFICIAL	2026-01-29 23:28:24.869206	0	\N
108	경기도 파주시 천정구로 128 경기도 파주시 당하동 306	2026-01-29 23:28:24.870179	37.74691669	126.7520788	OFFICIAL	2026-01-29 23:28:24.870194	0	\N
109	경기도 파주시 검산동 297-2	2026-01-29 23:28:24.871151	37.77478772	126.7400962	OFFICIAL	2026-01-29 23:28:24.871165	0	\N
110	경기도 파주시 맥금동 1140-1	2026-01-29 23:28:24.871996	37.76975169	126.7366968	OFFICIAL	2026-01-29 23:28:24.872009	0	\N
111	경기도 파주시 맥금동 1078-4	2026-01-29 23:28:24.872959	37.77237264	126.7348273	OFFICIAL	2026-01-29 23:28:24.872972	0	\N
112	경기도 파주시 장터고개길 10 경기도 파주시 맥금동 110-9	2026-01-29 23:28:24.873926	37.77298229	126.7337334	OFFICIAL	2026-01-29 23:28:24.87394	0	\N
113	경기도 파주시 검산동 824	2026-01-29 23:28:24.874831	37.77216198	126.7446852	OFFICIAL	2026-01-29 23:28:24.874845	0	\N
114	경기도 파주시 평화로 352 경기도 파주시 검산동 276-13	2026-01-29 23:28:24.875801	37.7732299	126.7437819	OFFICIAL	2026-01-29 23:28:24.875815	0	\N
115	경기도 파주시 평화로 307 경기도 파주시 검산동 868	2026-01-29 23:28:24.876807	37.77195119	126.7482251	OFFICIAL	2026-01-29 23:28:24.876821	0	\N
116	경기도 파주시 검산동 137-3	2026-01-29 23:28:24.877718	37.77226693	126.7470001	OFFICIAL	2026-01-29 23:28:24.877732	0	\N
117	경기도 파주시 야동동 692	2026-01-29 23:28:24.878638	37.77259232	126.7511982	OFFICIAL	2026-01-29 23:28:24.878653	0	\N
118	경기도 파주시 평화로 278 경기도 파주시 야동동 589-12	2026-01-29 23:28:24.879536	37.77318377	126.7515676	OFFICIAL	2026-01-29 23:28:24.87955	0	\N
119	경기도 파주시 야동동 910	2026-01-29 23:28:24.88046	37.77041489	126.7609747	OFFICIAL	2026-01-29 23:28:24.880475	0	\N
120	경기도 파주시 평화로 190 경기도 파주시 야동동 361	2026-01-29 23:28:24.881311	37.77260399	126.7628873	OFFICIAL	2026-01-29 23:28:24.881326	0	\N
121	경기도 파주시 금촌동 419-1	2026-01-29 23:28:24.882217	37.77098332	126.771488	OFFICIAL	2026-01-29 23:28:24.882231	0	\N
122	경기도 파주시 시청로 244 경기도 파주시 금촌동 423-5	2026-01-29 23:28:24.883131	37.7713412	126.7718827	OFFICIAL	2026-01-29 23:28:24.883145	0	\N
123	경기도 파주시 송화로 13 경기도 파주시 아동동 283	2026-01-29 23:28:24.88398	37.77166848	126.7750484	OFFICIAL	2026-01-29 23:28:24.883994	0	\N
124	경기도 파주시 정담길 90 경기도 파주시 금촌동 11-7	2026-01-29 23:28:24.88478	37.77097862	126.7742951	OFFICIAL	2026-01-29 23:28:24.884796	0	\N
125	경기도 파주시 정담길 40 경기도 파주시 아동동 275-13	2026-01-29 23:28:24.885655	37.76987067	126.7777367	OFFICIAL	2026-01-29 23:28:24.885669	0	\N
126	경기도 파주시 시청로 190 경기도 파주시 아동동 275-6	2026-01-29 23:28:24.886503	37.77069465	126.778001	OFFICIAL	2026-01-29 23:28:24.886516	0	\N
127	경기도 파주시 새꽃로 1 경기도 파주시 금촌동 1023	2026-01-29 23:28:24.887436	37.75023227	126.7681602	OFFICIAL	2026-01-29 23:28:24.88745	0	\N
128	경기도 파주시 쇠재로 123 경기도 파주시 금촌동 1007	2026-01-29 23:28:24.890159	37.75259449	126.7767807	OFFICIAL	2026-01-29 23:28:24.890318	0	\N
129	경기도 파주시 가나무로 130 경기도 파주시 금릉동 428	2026-01-29 23:28:24.892003	37.7538401	126.7798134	OFFICIAL	2026-01-29 23:28:24.892018	0	\N
130	경기도 파주시 쇠재로 133 경기도 파주시 금촌동 1003	2026-01-29 23:28:24.892903	37.75326607	126.7769711	OFFICIAL	2026-01-29 23:28:24.892918	0	\N
131	경기도 파주시 후곡로 50 경기도 파주시 금촌동 992	2026-01-29 23:28:24.893726	37.7532251	126.769121	OFFICIAL	2026-01-29 23:28:24.893741	0	\N
132	경기도 파주시 새꽃로 35 경기도 파주시 금촌동 984	2026-01-29 23:28:24.894683	37.75382255	126.7679869	OFFICIAL	2026-01-29 23:28:24.894698	0	\N
133	경기도 파주시 새꽃로 55 경기도 파주시 금촌동 974	2026-01-29 23:28:24.895468	37.75504144	126.767654	OFFICIAL	2026-01-29 23:28:24.895482	0	\N
134	경기도 파주시 후곡로 80 경기도 파주시 금촌동 997	2026-01-29 23:28:24.896337	37.75043566	126.7729952	OFFICIAL	2026-01-29 23:28:24.896351	0	\N
135	경기도 파주시 후곡로 50 경기도 파주시 금촌동 992	2026-01-29 23:28:24.897149	37.7532251	126.769121	OFFICIAL	2026-01-29 23:28:24.897163	0	\N
136	경기도 파주시 후곡로 2 경기도 파주시 금촌동 958-10	2026-01-29 23:28:24.897997	37.75740458	126.7731555	OFFICIAL	2026-01-29 23:28:24.898011	0	\N
137	경기도 파주시 번영로 15 경기도 파주시 금촌동 959-2	2026-01-29 23:28:24.898891	37.75756997	126.771369	OFFICIAL	2026-01-29 23:28:24.898906	0	\N
138	경기도 파주시 번영로 55 경기도 파주시 금촌동 972	2026-01-29 23:28:24.899705	37.75741591	126.7660484	OFFICIAL	2026-01-29 23:28:24.899719	0	\N
139	경기도 파주시 금촌동 978-13	2026-01-29 23:28:24.900511	37.75240553	126.7654264	OFFICIAL	2026-01-29 23:28:24.900525	0	\N
140	경기도 파주시 금빛로 24-17 경기도 파주시 금촌동 988-4	2026-01-29 23:28:24.901363	37.75198848	126.767633	OFFICIAL	2026-01-29 23:28:24.901399	0	\N
141	경기도 파주시 금빛로 24-28 경기도 파주시 금촌동 989-6	2026-01-29 23:28:24.902206	37.75165485	126.7682735	OFFICIAL	2026-01-29 23:28:24.902225	0	\N
142	경기도 파주시 금빛로 24-22 경기도 파주시 금촌동 989-5	2026-01-29 23:28:24.903013	37.75165206	126.7679103	OFFICIAL	2026-01-29 23:28:24.903027	0	\N
143	경기도 파주시 금빛로 24-17 경기도 파주시 금촌동 988-4	2026-01-29 23:28:24.903835	37.75198848	126.767633	OFFICIAL	2026-01-29 23:28:24.903849	0	\N
144	경기도 파주시 금빛로 24-10 경기도 파주시 금촌동 989-2	2026-01-29 23:28:24.904664	37.75165559	126.7672766	OFFICIAL	2026-01-29 23:28:24.904678	0	\N
145	경기도 파주시 금빛로 24 경기도 파주시 금촌동 988-1	2026-01-29 23:28:24.90555	37.75198853	126.7668832	OFFICIAL	2026-01-29 23:28:24.905566	0	\N
146	경기도 파주시 중앙로 193 경기도 파주시 금릉동 211-11	2026-01-29 23:28:24.906406	37.75449299	126.7819724	OFFICIAL	2026-01-29 23:28:24.90642	0	\N
147	경기도 파주시 중앙로 194 경기도 파주시 금릉동 216-21	2026-01-29 23:28:24.907262	37.75489984	126.7824175	OFFICIAL	2026-01-29 23:28:24.907276	0	\N
148	경기도 파주시 중앙로 160 경기도 파주시 금릉동 186-5	2026-01-29 23:28:24.908119	37.75612433	126.786478	OFFICIAL	2026-01-29 23:28:24.908133	0	\N
149	경기도 파주시 아동동 51-10	2026-01-29 23:28:24.908972	37.75968332	126.7956703	OFFICIAL	2026-01-29 23:28:24.909017	0	\N
150	경기도 파주시 통일로 541 경기도 파주시 아동동 45-7	2026-01-29 23:28:24.909795	37.75840583	126.7957202	OFFICIAL	2026-01-29 23:28:24.909839	0	\N
151	경기도 파주시 후곡로 19 경기도 파주시 금촌동 953-5	2026-01-29 23:28:24.910624	37.75574508	126.7739012	OFFICIAL	2026-01-29 23:28:24.910666	0	\N
152	경기도 파주시 가나무로 101 경기도 파주시 금촌동 123-30	2026-01-29 23:28:24.911493	37.75432256	126.7765047	OFFICIAL	2026-01-29 23:28:24.911505	0	\N
153	경기도 파주시 시청로 21 경기도 파주시 금촌동 765-21	2026-01-29 23:28:24.912429	37.75893833	126.7759047	OFFICIAL	2026-01-29 23:28:24.91244	0	\N
154	경기도 파주시 시청로 2 경기도 파주시 금촌동 948-1	2026-01-29 23:28:24.913395	37.75784489	126.7742406	OFFICIAL	2026-01-29 23:28:24.913406	0	\N
155	경기도 파주시 후곡로 1 경기도 파주시 금촌동 952-1	2026-01-29 23:28:24.915486	37.75740254	126.7740148	OFFICIAL	2026-01-29 23:28:24.915498	0	\N
156	경기도 파주시 번영로 56 경기도 파주시 금촌동 967-3	2026-01-29 23:28:24.916265	37.75791486	126.7669098	OFFICIAL	2026-01-29 23:28:24.916276	0	\N
157	경기도 파주시 번영로 4 경기도 파주시 금촌동 945-11	2026-01-29 23:28:24.917052	37.75789734	126.7726538	OFFICIAL	2026-01-29 23:28:24.917063	0	\N
158	경기도 파주시 평화로 3-1 경기도 파주시 금촌동 945-6	2026-01-29 23:28:24.917877	37.75838584	126.7729811	OFFICIAL	2026-01-29 23:28:24.917888	0	\N
159	경기도 파주시 평화로 6 경기도 파주시 금촌동 946-19	2026-01-29 23:28:24.918592	37.75856794	126.7732647	OFFICIAL	2026-01-29 23:28:24.91861	0	\N
160	경기도 파주시 평화로 2 경기도 파주시 금촌동 946-17	2026-01-29 23:28:24.919448	37.75827499	126.773524	OFFICIAL	2026-01-29 23:28:24.919458	0	\N
161	경기도 파주시 문화로 103 경기도 파주시 금촌동 62-1	2026-01-29 23:28:24.920524	37.76331085	126.7744701	OFFICIAL	2026-01-29 23:28:24.920536	0	\N
162	경기도 파주시 새꽃로 193 경기도 파주시 금촌동 329-251	2026-01-29 23:28:24.921308	37.76608619	126.7750857	OFFICIAL	2026-01-29 23:28:24.921319	0	\N
163	경기도 파주시 새꽃로 193 경기도 파주시 금촌동 329-251	2026-01-29 23:28:24.922142	37.76608619	126.7750857	OFFICIAL	2026-01-29 23:28:24.922153	0	\N
164	경기도 파주시 새꽃로 204 경기도 파주시 금촌동 329-223	2026-01-29 23:28:24.923102	37.76546747	126.7751657	OFFICIAL	2026-01-29 23:28:24.923113	0	\N
165	경기도 파주시 새꽃로 205 경기도 파주시 아동동 351-15	2026-01-29 23:28:24.924001	37.76586674	126.7752438	OFFICIAL	2026-01-29 23:28:24.924012	0	\N
166	경기도 파주시 새꽃로 204 경기도 파주시 금촌동 329-223	2026-01-29 23:28:24.92479	37.76546747	126.7751657	OFFICIAL	2026-01-29 23:28:24.924801	0	\N
167	경기도 파주시 월롱면 능산리 236-1	2026-01-29 23:28:24.925572	37.82603186	126.7715271	OFFICIAL	2026-01-29 23:28:24.925583	0	\N
168	경기도 파주시 월롱면 능산리 256-10	2026-01-29 23:28:24.9264	37.82616767	126.772548	OFFICIAL	2026-01-29 23:28:24.926411	0	\N
169	경기도 파주시 월롱면 능산리 665	2026-01-29 23:28:24.92725	37.83326284	126.7784847	OFFICIAL	2026-01-29 23:28:24.927259	0	\N
170	경기도 파주시 월롱면 휴암로 477 경기도 파주시 월롱면 능산리 658	2026-01-29 23:28:24.928179	37.83430163	126.7775546	OFFICIAL	2026-01-29 23:28:24.92819	0	\N
171	경기도 파주시 월롱면 덕은리 957-4	2026-01-29 23:28:24.929313	37.81520761	126.7618768	OFFICIAL	2026-01-29 23:28:24.929326	0	\N
172	경기도 파주시 월롱면 덕은리 833-2	2026-01-29 23:28:24.930348	37.81559292	126.7619825	OFFICIAL	2026-01-29 23:28:24.93036	0	\N
173	경기도 파주시 월롱면 덕은리 1005	2026-01-29 23:28:24.931154	37.81239617	126.7672721	OFFICIAL	2026-01-29 23:28:24.931165	0	\N
174	경기도 파주시 월롱면 덕은리 938-49	2026-01-29 23:28:24.932026	37.81288656	126.7667669	OFFICIAL	2026-01-29 23:28:24.932037	0	\N
175	경기도 파주시 월롱면 덕은리 1277	2026-01-29 23:28:24.93288	37.81227091	126.7751194	OFFICIAL	2026-01-29 23:28:24.932892	0	\N
176	경기도 파주시 월롱면 덕은리 523-2	2026-01-29 23:28:24.933665	37.81275397	126.7744436	OFFICIAL	2026-01-29 23:28:24.933675	0	\N
177	경기도 파주시 월롱면 엘지로 164 경기도 파주시 월롱면 덕은리 1060	2026-01-29 23:28:24.934503	37.81076895	126.7811147	OFFICIAL	2026-01-29 23:28:24.934514	0	\N
178	경기도 파주시 월롱면 덕은리 463-1	2026-01-29 23:28:24.935273	37.80999514	126.7812599	OFFICIAL	2026-01-29 23:28:24.935283	0	\N
179	경기도 파주시 월롱면 휴암로 4 경기도 파주시 월롱면 위전리 427-13	2026-01-29 23:28:24.936057	37.79594398	126.7912003	OFFICIAL	2026-01-29 23:28:24.936067	0	\N
180	경기도 파주시 월롱면 위전리 425-1	2026-01-29 23:28:24.936851	37.79645096	126.7915788	OFFICIAL	2026-01-29 23:28:24.936861	0	\N
181	경기도 파주시 월롱면 통일로 980 경기도 파주시 월롱면 위전리 168-3	2026-01-29 23:28:24.937668	37.79614315	126.7922047	OFFICIAL	2026-01-29 23:28:24.937711	0	\N
182	경기도 파주시 월롱면 통일로 980 경기도 파주시 월롱면 위전리 168-3	2026-01-29 23:28:24.93853	37.79614315	126.7922047	OFFICIAL	2026-01-29 23:28:24.93856	0	\N
183	경기도 파주시 월롱면 영태리 572-6	2026-01-29 23:28:24.939425	37.77623936	126.7886051	OFFICIAL	2026-01-29 23:28:24.939435	0	\N
184	경기도 파주시 월롱면 영태리 579-12	2026-01-29 23:28:24.940251	37.77774471	126.7887711	OFFICIAL	2026-01-29 23:28:24.940262	0	\N
185	경기도 파주시 월롱면 통일로 824 경기도 파주시 월롱면 영태리 612-17	2026-01-29 23:28:24.941108	37.78268931	126.7885168	OFFICIAL	2026-01-29 23:28:24.941118	0	\N
186	경기도 파주시 월롱면 통일로 824 경기도 파주시 월롱면 영태리 612-17	2026-01-29 23:28:24.941992	37.78268931	126.7885168	OFFICIAL	2026-01-29 23:28:24.942004	0	\N
187	경기도 파주시 월롱면 영태리 513-1	2026-01-29 23:28:24.942854	37.77378606	126.7884552	OFFICIAL	2026-01-29 23:28:24.942864	0	\N
188	경기도 파주시 탄현면 약산로 76 경기도 파주시 탄현면 법흥리 1581-1	2026-01-29 23:28:24.94364	37.77111216	126.7051236	OFFICIAL	2026-01-29 23:28:24.943652	0	\N
189	경기도 파주시 탄현면 법흥리 1664	2026-01-29 23:28:24.944478	37.78574641	126.6997465	OFFICIAL	2026-01-29 23:28:24.944488	0	\N
190	경기도 파주시 탄현면 여치길 81 경기도 파주시 탄현면 법흥리 1566	2026-01-29 23:28:24.945249	37.77045463	126.7025397	OFFICIAL	2026-01-29 23:28:24.945267	0	\N
191	경기도 파주시 탄현면 법흥리 747-9	2026-01-29 23:28:24.946031	37.78890418	126.6936048	OFFICIAL	2026-01-29 23:28:24.946041	0	\N
192	경기도 파주시 탄현면 헤이리마을길 55-61 경기도 파주시 탄현면 법흥리 1652-164	2026-01-29 23:28:24.946827	37.7887567	126.6942883	OFFICIAL	2026-01-29 23:28:24.946854	0	\N
193	경기도 파주시 탄현면 새오리로 542 경기도 파주시 탄현면 금산리 208-2	2026-01-29 23:28:24.947616	37.8120444	126.7080859	OFFICIAL	2026-01-29 23:28:24.947626	0	\N
194	경기도 파주시 광탄면 혜음로 1121-1 경기도 파주시 광탄면 신산리 371-24	2026-01-29 23:28:24.948524	37.78150414	126.8473902	OFFICIAL	2026-01-29 23:28:24.948549	0	\N
195	경기도 파주시 광탄면 혜음로 1121-1 경기도 파주시 광탄면 신산리 371-24	2026-01-29 23:28:24.949527	37.78150414	126.8473902	OFFICIAL	2026-01-29 23:28:24.949537	0	\N
196	경기도 파주시 광탄면 등원로 527 경기도 파주시 광탄면 신산리 366-1	2026-01-29 23:28:24.950414	37.78335959	126.8449088	OFFICIAL	2026-01-29 23:28:24.950423	0	\N
197	경기도 파주시 파평면 금파리 296-9	2026-01-29 23:28:24.951274	37.92169557	126.8392175	OFFICIAL	2026-01-29 23:28:24.951284	0	\N
198	경기도 파주시 파평면 장마루로 263 경기도 파주시 파평면 장파리 370-118	2026-01-29 23:28:24.952091	37.94525328	126.8374999	OFFICIAL	2026-01-29 23:28:24.952101	0	\N
199	경기도 파주시 파평면 장마루로 225 경기도 파주시 파평면 장파리 370-21	2026-01-29 23:28:24.95293	37.94203677	126.8368652	OFFICIAL	2026-01-29 23:28:24.952941	0	\N
200	경기도 파주시 파평면 청송로 415 경기도 파주시 파평면 눌노리 231-13	2026-01-29 23:28:24.953732	37.93067136	126.8589747	OFFICIAL	2026-01-29 23:28:24.953742	0	\N
201	경기도 파주시 파평면 청송로652번길 14 경기도 파주시 파평면 덕천리 126-19	2026-01-29 23:28:24.954521	37.942166	126.8800281	OFFICIAL	2026-01-29 23:28:24.95453	0	\N
202	경기도 파주시 적성면 청송로 701 경기도 파주시 적성면 식현리 284	2026-01-29 23:28:24.955311	37.94557773	126.8855095	OFFICIAL	2026-01-29 23:28:24.95532	0	\N
203	경기도 파주시 적성면 청송로 1003 경기도 파주시 적성면 마지리 48-2	2026-01-29 23:28:24.956132	37.95340587	126.9169532	OFFICIAL	2026-01-29 23:28:24.956141	0	\N
204	경기도 파주시 적성면 마지리 39-49	2026-01-29 23:28:24.956866	37.95686246	126.9160336	OFFICIAL	2026-01-29 23:28:24.956876	0	\N
205	경기도 파주시 법원읍 술이홀로 1722 경기도 파주시 법원읍 웅담리 388-2	2026-01-29 23:28:24.957677	37.91471347	126.8955351	OFFICIAL	2026-01-29 23:28:24.957687	0	\N
206	경기도 파주시 법원읍 금곡리 336-4	2026-01-29 23:28:24.958455	37.88532474	126.8778106	OFFICIAL	2026-01-29 23:28:24.958464	0	\N
207	경기도 파주시 법원읍 가야리 86-3	2026-01-29 23:28:24.959234	37.84968924	126.8633434	OFFICIAL	2026-01-29 23:28:24.959244	0	\N
208	경기도 파주시 법원읍 사임당로 881 경기도 파주시 법원읍 법원리 444-7	2026-01-29 23:28:24.960031	37.84844706	126.8787791	OFFICIAL	2026-01-29 23:28:24.960041	0	\N
209	경기도 파주시 법원읍 사임당로 895 경기도 파주시 법원읍 법원리 447-28	2026-01-29 23:28:24.96078	37.8481883	126.8804482	OFFICIAL	2026-01-29 23:28:24.96079	0	\N
210	경기도 파주시 법원읍 술이홀로 869 경기도 파주시 법원읍 대능리 94-105	2026-01-29 23:28:24.961529	37.84907513	126.8724766	OFFICIAL	2026-01-29 23:28:24.961538	0	\N
211	경기도 파주시 법원읍 사임당로 845 경기도 파주시 법원읍 대능리 87-6	2026-01-29 23:28:24.962347	37.84919233	126.8748211	OFFICIAL	2026-01-29 23:28:24.962356	0	\N
212	경기도 파주시 법원읍 사임당로 846 경기도 파주시 법원읍 대능리 84-1	2026-01-29 23:28:24.963151	37.84864911	126.8745313	OFFICIAL	2026-01-29 23:28:24.96316	0	\N
213	경기도 파주시 조리읍 봉일천리 229-2	2026-01-29 23:28:24.963952	37.74492281	126.8084016	OFFICIAL	2026-01-29 23:28:24.963961	0	\N
214	경기도 파주시 조리읍 봉천로 28 경기도 파주시 조리읍 봉일천리 210-16	2026-01-29 23:28:24.964745	37.74364707	126.8087516	OFFICIAL	2026-01-29 23:28:24.964785	0	\N
215	경기도 파주시 조리읍 두루봉로 27 경기도 파주시 조리읍 봉일천리 237-3	2026-01-29 23:28:24.965506	37.74654276	126.8108062	OFFICIAL	2026-01-29 23:28:24.965515	0	\N
216	경기도 파주시 조리읍 봉일천리 39-5	2026-01-29 23:28:24.966206	37.73815631	126.8207799	OFFICIAL	2026-01-29 23:28:24.966215	0	\N
217	경기도 파주시 조리읍 봉일천리 26-54	2026-01-29 23:28:24.966924	37.73706699	126.8233395	OFFICIAL	2026-01-29 23:28:24.966933	0	\N
218	경기도 파주시 조리읍 장곡리 765-1	2026-01-29 23:28:24.967704	37.72896107	126.8390474	OFFICIAL	2026-01-29 23:28:24.967714	0	\N
219	경기도 파주시 조리읍 명봉산로 68 경기도 파주시 조리읍 장곡리 656-1	2026-01-29 23:28:24.968459	37.73398069	126.842373	OFFICIAL	2026-01-29 23:28:24.968469	0	\N
220	경기도 파주시 조리읍 장곡리 598-236	2026-01-29 23:28:24.969171	37.73761328	126.8450458	OFFICIAL	2026-01-29 23:28:24.96918	0	\N
221	경기도 파주시 조리읍 장곡리 765-1	2026-01-29 23:28:24.969925	37.72896107	126.8390474	OFFICIAL	2026-01-29 23:28:24.969935	0	\N
222	경기도 파주시 조리읍 통일로 43 경기도 파주시 조리읍 장곡리 463-2	2026-01-29 23:28:24.970648	37.73115763	126.8354089	OFFICIAL	2026-01-29 23:28:24.970657	0	\N
223	경기도 파주시 조리읍 통일로 155 경기도 파주시 조리읍 봉일천리 13-15	2026-01-29 23:28:24.971408	37.73635799	126.8247639	OFFICIAL	2026-01-29 23:28:24.971417	0	\N
224	경기도 파주시 조리읍 봉일천리 26-54	2026-01-29 23:28:24.972159	37.73706699	126.8233395	OFFICIAL	2026-01-29 23:28:24.972169	0	\N
225	경기도 파주시 조리읍 봉일천리 125-2	2026-01-29 23:28:24.973026	37.74263952	126.8105131	OFFICIAL	2026-01-29 23:28:24.973065	0	\N
226	경기도 파주시 조리읍 고봉로 1028 경기도 파주시 조리읍 봉일천리 142-23	2026-01-29 23:28:24.973792	37.74273625	126.8078444	OFFICIAL	2026-01-29 23:28:24.973802	0	\N
227	경기도 파주시 조리읍 고봉로 1029 경기도 파주시 조리읍 봉일천리 154-4	2026-01-29 23:28:24.974507	37.74306766	126.8075355	OFFICIAL	2026-01-29 23:28:24.974517	0	\N
228	경기도 파주시 조리읍 봉천로 43 경기도 파주시 조리읍 봉일천리 168-13	2026-01-29 23:28:24.97546	37.74357358	126.8069427	OFFICIAL	2026-01-29 23:28:24.975476	0	\N
229	경기도 파주시 조리읍 봉천로 38-11 경기도 파주시 조리읍 봉일천리 204-11	2026-01-29 23:28:24.976305	37.74392069	126.8069248	OFFICIAL	2026-01-29 23:28:24.976315	0	\N
230	경기도 파주시 조리읍 봉일천리 187-23	2026-01-29 23:28:24.977116	37.74486117	126.8045334	OFFICIAL	2026-01-29 23:28:24.977126	0	\N
231	경기도 파주시 조리읍 대원리 963-5	2026-01-29 23:28:24.9779	37.74009021	126.8064822	OFFICIAL	2026-01-29 23:28:24.97791	0	\N
232	경기도 파주시 조리읍 대원리 227-4	2026-01-29 23:28:24.97865	37.72843972	126.8134568	OFFICIAL	2026-01-29 23:28:24.978659	0	\N
233	경기도 파주시 조리읍 대원로 56 경기도 파주시 조리읍 대원리 218	2026-01-29 23:28:24.979396	37.72808793	126.8155688	OFFICIAL	2026-01-29 23:28:24.979406	0	\N
234	경기도 파주시 조리읍 대원리 198-4	2026-01-29 23:28:24.98014	37.72718203	126.8175882	OFFICIAL	2026-01-29 23:28:24.980149	0	\N
235	경기도 파주시 조리읍 대원로 45 경기도 파주시 조리읍 대원리 272	2026-01-29 23:28:24.981044	37.72708817	126.8171588	OFFICIAL	2026-01-29 23:28:24.981054	0	\N
236	경기도 파주시 조리읍 고봉로 925 경기도 파주시 조리읍 대원리 637-1	2026-01-29 23:28:24.981896	37.73485195	126.802978	OFFICIAL	2026-01-29 23:28:24.981906	0	\N
237	경기도 파주시 조리읍 등원리 275-1	2026-01-29 23:28:24.982622	37.75600139	126.8030243	OFFICIAL	2026-01-29 23:28:24.982632	0	\N
238	경기도 파주시 조리읍 등원리 263-1	2026-01-29 23:28:24.983353	37.75679131	126.8036403	OFFICIAL	2026-01-29 23:28:24.983362	0	\N
239	경기도 파주시 조리읍 등원로 93 경기도 파주시 조리읍 등원리 1-2	2026-01-29 23:28:24.984112	37.76160985	126.8095522	OFFICIAL	2026-01-29 23:28:24.984122	0	\N
240	경기도 파주시 조리읍 등원로 127 경기도 파주시 조리읍 뇌조리 417-2	2026-01-29 23:28:24.984942	37.76399146	126.8120217	OFFICIAL	2026-01-29 23:28:24.984952	0	\N
241	경기도 파주시 조리읍 등원로 199 경기도 파주시 조리읍 뇌조리 457-1	2026-01-29 23:28:24.985722	37.76533187	126.8194822	OFFICIAL	2026-01-29 23:28:24.985732	0	\N
242	경기도 파주시 조리읍 오산리 377-4	2026-01-29 23:28:24.986481	37.76495518	126.8226438	OFFICIAL	2026-01-29 23:28:24.98649	0	\N
243	경기도 파주시 조리읍 오산리 309-7	2026-01-29 23:28:24.987217	37.7688689	126.8254268	OFFICIAL	2026-01-29 23:28:24.987226	0	\N
244	경기도 파주시 조리읍 등원로 273 경기도 파주시 조리읍 오산리 309-1	2026-01-29 23:28:24.988133	37.76890172	126.8251376	OFFICIAL	2026-01-29 23:28:24.988143	0	\N
245	경기도 파주시 조리읍 사근절길 95 경기도 파주시 조리읍 오산리 353	2026-01-29 23:28:24.988894	37.7636475	126.8287113	OFFICIAL	2026-01-29 23:28:24.988904	0	\N
246	경기도 파주시 문산읍 문산로 42 경기도 파주시 문산읍 문산리 10-28	2026-01-29 23:28:24.989628	37.85725458	126.783868	OFFICIAL	2026-01-29 23:28:24.989638	0	\N
247	경기도 파주시 문산읍 당동2로 1 경기도 파주시 문산읍 당동리 888-4	2026-01-29 23:28:24.99042	37.86776721	126.7850443	OFFICIAL	2026-01-29 23:28:24.99043	0	\N
248	경기도 파주시 문산읍 당동리 897	2026-01-29 23:28:24.991327	37.86604827	126.7836137	OFFICIAL	2026-01-29 23:28:24.991337	0	\N
249	경기도 파주시 문산읍 문향로 26 경기도 파주시 문산읍 문산리 17-360	2026-01-29 23:28:24.99215	37.8542204	126.786258	OFFICIAL	2026-01-29 23:28:24.99216	0	\N
250	경기도 파주시 문산읍 문산역로 94 경기도 파주시 문산읍 문산리 17-14	2026-01-29 23:28:24.992921	37.8545887	126.7875954	OFFICIAL	2026-01-29 23:28:24.99293	0	\N
251	경기도 파주시 문산읍 문향로68번길 5 경기도 파주시 문산읍 문산리 9-5	2026-01-29 23:28:24.993721	37.85777951	126.7855624	OFFICIAL	2026-01-29 23:28:24.993731	0	\N
252	경기도 파주시 문산읍 사임당로 113 경기도 파주시 문산읍 선유리 434-3	2026-01-29 23:28:24.994507	37.86523362	126.8041368	OFFICIAL	2026-01-29 23:28:24.994517	0	\N
253	경기도 파주시 문산읍 문향로 75 경기도 파주시 문산읍 문산리 3-5	2026-01-29 23:28:24.995293	37.85858077	126.7854415	OFFICIAL	2026-01-29 23:28:24.995303	0	\N
254	경기도 파주시 문산읍 문산로 43-2 경기도 파주시 문산읍 문산리 8-16	2026-01-29 23:28:24.996123	37.85764869	126.7841803	OFFICIAL	2026-01-29 23:28:24.996133	0	\N
255	경기도 파주시 문산읍 문향로 42 경기도 파주시 문산읍 문산리 13-1	2026-01-29 23:28:24.996922	37.85578022	126.7861632	OFFICIAL	2026-01-29 23:28:24.996933	0	\N
256	경상남도 거창군 신원면 과정리 309-7	2026-01-29 23:28:24.997811	35.57037796	127.9247715	OFFICIAL	2026-01-29 23:28:24.997891	0	\N
257	경상남도 거창군 신원면 과정리 187-13	2026-01-29 23:28:24.99899	35.56772966	127.9255701	OFFICIAL	2026-01-29 23:28:24.999001	0	\N
258	경상남도 거창군 신원면 양지리 307-1	2026-01-29 23:28:24.999839	35.58499648	127.9589552	OFFICIAL	2026-01-29 23:28:24.999866	0	\N
259	경상남도 거창군 고제면 봉계리 548-1	2026-01-29 23:28:25.00059	35.87993465	127.8764909	OFFICIAL	2026-01-29 23:28:25.00061	0	\N
260	경상남도 거창군 위천면 은하리길 2	2026-01-29 23:28:25.001412	35.76092327	127.8336769	OFFICIAL	2026-01-29 23:28:25.001431	0	\N
261	경상남도 거창군 신원면 감악산로 398	2026-01-29 23:28:25.00218	35.60002215	127.9112594	OFFICIAL	2026-01-29 23:28:25.002189	0	\N
262	경상남도 거창군 가조면 가조가야로 1296	2026-01-29 23:28:25.002965	35.7042267	128.0345597	OFFICIAL	2026-01-29 23:28:25.002972	0	\N
263	경상남도 거창군 가조면 의상봉길 65	2026-01-29 23:28:25.003716	35.70908568	128.0191933	OFFICIAL	2026-01-29 23:28:25.003724	0	\N
264	경상남도 거창군 신원면 청용1길 16	2026-01-29 23:28:25.004478	35.57016755	127.9016399	OFFICIAL	2026-01-29 23:28:25.004486	0	\N
265	경상남도 거창군 신원면 오례길 127-5	2026-01-29 23:28:25.005186	35.57025282	127.8912278	OFFICIAL	2026-01-29 23:28:25.005195	0	\N
266	경상남도 거창군 신원면 대현리 345-3	2026-01-29 23:28:25.005906	35.55358357	127.9260712	OFFICIAL	2026-01-29 23:28:25.005914	0	\N
267	경상남도 거창군 신원면 덕산리 1548	2026-01-29 23:28:25.006843	35.60200738	127.9108411	OFFICIAL	2026-01-29 23:28:25.006852	0	\N
268	경상남도 거창군 신원면 구사리 972-1	2026-01-29 23:28:25.007638	35.5765338	127.9496965	OFFICIAL	2026-01-29 23:28:25.007647	0	\N
269	경상남도 거창군 신원면 신차로 3016	2026-01-29 23:28:25.008402	35.56320368	127.9263887	OFFICIAL	2026-01-29 23:28:25.00841	0	\N
270	경상남도 거창군 신원면 과정리 355-1	2026-01-29 23:28:25.009119	35.57185355	127.9212112	OFFICIAL	2026-01-29 23:28:25.009127	0	\N
271	경상남도 거창군 남하면 무릉리 556-1	2026-01-29 23:28:25.009872	35.65121684	127.9538186	OFFICIAL	2026-01-29 23:28:25.00988	0	\N
272	경상남도 거창군 남하면 둔마리 710-2	2026-01-29 23:28:25.01059	35.71480479	127.9656457	OFFICIAL	2026-01-29 23:28:25.010598	0	\N
273	경상남도 거창군 남하면 무릉리 307-2	2026-01-29 23:28:25.011385	35.65782405	127.9581137	OFFICIAL	2026-01-29 23:28:25.011393	0	\N
274	경상남도 거창군 남하면 둔마리 1145-1	2026-01-29 23:28:25.012166	35.70531421	127.951549	OFFICIAL	2026-01-29 23:28:25.012173	0	\N
275	경상남도 거창군 남상면 임불리 602-5	2026-01-29 23:28:25.012912	35.62705364	127.9887798	OFFICIAL	2026-01-29 23:28:25.01292	0	\N
276	경상남도 거창군 남상면 무촌리 1344-38	2026-01-29 23:28:25.013609	35.64092847	127.9068367	OFFICIAL	2026-01-29 23:28:25.013617	0	\N
277	경상남도 거창군 남상면 춘전리 53-4	2026-01-29 23:28:25.014373	35.58675826	127.8560539	OFFICIAL	2026-01-29 23:28:25.014381	0	\N
278	경상남도 거창군 남상면 무촌리 1098	2026-01-29 23:28:25.015148	35.63182684	127.9064172	OFFICIAL	2026-01-29 23:28:25.015156	0	\N
279	경상남도 거창군 남상면 대산리 1270-2	2026-01-29 23:28:25.015882	35.64508894	127.9201178	OFFICIAL	2026-01-29 23:28:25.015889	0	\N
280	경상남도 거창군 남상면 진목1길 20	2026-01-29 23:28:25.016594	35.59493615	127.8702702	OFFICIAL	2026-01-29 23:28:25.016602	0	\N
281	경상남도 거창군 남상면 대산리 412-2	2026-01-29 23:28:25.017378	35.64183675	127.937744	OFFICIAL	2026-01-29 23:28:25.017386	0	\N
282	경상남도 거창군 마리면 영승리 273	2026-01-29 23:28:25.018107	35.70290025	127.8630043	OFFICIAL	2026-01-29 23:28:25.018114	0	\N
283	경상남도 거창군 마리면 대동리 318-1	2026-01-29 23:28:25.018883	35.66954974	127.856815	OFFICIAL	2026-01-29 23:28:25.01889	0	\N
284	경상남도 거창군 위천면 남산리 753-1	2026-01-29 23:28:25.019616	35.73598938	127.8285592	OFFICIAL	2026-01-29 23:28:25.019623	0	\N
285	경상남도 거창군 위천면 남산리 221-1	2026-01-29 23:28:25.020528	35.73864253	127.837724	OFFICIAL	2026-01-29 23:28:25.020536	0	\N
286	경상남도 거창군 위천면 당산리 337-7	2026-01-29 23:28:25.021227	35.74985118	127.8564089	OFFICIAL	2026-01-29 23:28:25.021243	0	\N
287	경상남도 거창군 위천면 모동리 256-2	2026-01-29 23:28:25.02198	35.78380321	127.8639845	OFFICIAL	2026-01-29 23:28:25.021987	0	\N
288	경상남도 거창군 위천면 강천리 160-1	2026-01-29 23:28:25.02274	35.7547564	127.8280998	OFFICIAL	2026-01-29 23:28:25.022778	0	\N
289	경상남도 거창군 북상면 월성리 835-3	2026-01-29 23:28:25.02351	35.75819681	127.7397428	OFFICIAL	2026-01-29 23:28:25.023541	0	\N
290	경상남도 거창군 북상면 월성리 1084-6	2026-01-29 23:28:25.024279	35.76493855	127.7428904	OFFICIAL	2026-01-29 23:28:25.024308	0	\N
291	경상남도 거창군 북상면 병곡리 768-3	2026-01-29 23:28:25.024988	35.810219	127.7748968	OFFICIAL	2026-01-29 23:28:25.025019	0	\N
292	경상남도 거창군 북상면 월성리 1783	2026-01-29 23:28:25.025698	35.77020671	127.7173898	OFFICIAL	2026-01-29 23:28:25.025707	0	\N
293	경상남도 거창군 고제면 봉계리 355-5	2026-01-29 23:28:25.026622	35.87254176	127.8748814	OFFICIAL	2026-01-29 23:28:25.02663	0	\N
294	경상남도 거창군 고제면 봉산리 1427-14	2026-01-29 23:28:25.027304	35.86360664	127.8732422	OFFICIAL	2026-01-29 23:28:25.027312	0	\N
295	경상남도 거창군 고제면 봉계리 678-1	2026-01-29 23:28:25.028171	35.89113997	127.8715298	OFFICIAL	2026-01-29 23:28:25.028179	0	\N
296	경상남도 거창군 고제면 방학길 13-3	2026-01-29 23:28:25.028925	35.83839429	127.8766847	OFFICIAL	2026-01-29 23:28:25.028934	0	\N
297	경상남도 거창군 고제면 농산리 1438-1	2026-01-29 23:28:25.029804	35.81077982	127.8507687	OFFICIAL	2026-01-29 23:28:25.029812	0	\N
298	경상남도 거창군 고제면 개명리 1056	2026-01-29 23:28:25.030512	35.83144897	127.8489465	OFFICIAL	2026-01-29 23:28:25.03052	0	\N
299	경상남도 거창군 고제면 궁항리 1305-2	2026-01-29 23:28:25.031303	35.8260665	127.8734814	OFFICIAL	2026-01-29 23:28:25.031312	0	\N
300	경상남도 거창군 고제면 봉산리 823-2	2026-01-29 23:28:25.032097	35.85212676	127.8774521	OFFICIAL	2026-01-29 23:28:25.032106	0	\N
301	경상남도 거창군 웅양면 노현리 1331	2026-01-29 23:28:25.032868	35.80449367	127.9102938	OFFICIAL	2026-01-29 23:28:25.032876	0	\N
302	경상남도 거창군 웅양면 신촌리 524-1	2026-01-29 23:28:25.033809	35.8763281	127.9108236	OFFICIAL	2026-01-29 23:28:25.033817	0	\N
303	경상남도 거창군 웅양면 산포리 282	2026-01-29 23:28:25.03463	35.81275931	127.9544963	OFFICIAL	2026-01-29 23:28:25.03464	0	\N
304	경상남도 거창군 웅양면 한기리 823-5	2026-01-29 23:28:25.035428	35.88389643	127.9202222	OFFICIAL	2026-01-29 23:28:25.035436	0	\N
305	경상남도 거창군 웅양면 신촌리 1073-2	2026-01-29 23:28:25.036126	35.87128817	127.9064344	OFFICIAL	2026-01-29 23:28:25.036134	0	\N
306	경상남도 거창군 웅양면 신촌리 288-11	2026-01-29 23:28:25.036876	35.86709288	127.9147638	OFFICIAL	2026-01-29 23:28:25.036884	0	\N
307	경상남도 거창군 웅양면 노현리 1096-1	2026-01-29 23:28:25.037591	35.81000858	127.910288	OFFICIAL	2026-01-29 23:28:25.0376	0	\N
308	경상남도 거창군 웅양면 동호리 308-2	2026-01-29 23:28:25.038324	35.79181412	127.9286302	OFFICIAL	2026-01-29 23:28:25.038332	0	\N
309	경상남도 거창군 웅양면 죽림리 921-1	2026-01-29 23:28:25.039081	35.80169382	127.9051093	OFFICIAL	2026-01-29 23:28:25.039089	0	\N
310	경상남도 거창군 웅양면 죽림리 195-5	2026-01-29 23:28:25.039776	35.79525856	127.9127246	OFFICIAL	2026-01-29 23:28:25.039784	0	\N
311	경상남도 거창군 웅양면 한기리 68-8	2026-01-29 23:28:25.040448	35.87344448	127.9283874	OFFICIAL	2026-01-29 23:28:25.040456	0	\N
312	경상남도 거창군 웅양면 한기리 424-7	2026-01-29 23:28:25.041166	35.87433837	127.9261376	OFFICIAL	2026-01-29 23:28:25.041174	0	\N
313	경상남도 거창군 웅양면 한기리 453-17	2026-01-29 23:28:25.041921	35.87240862	127.9219525	OFFICIAL	2026-01-29 23:28:25.041929	0	\N
314	경상남도 거창군 웅양면 한기리 354-7	2026-01-29 23:28:25.042631	35.86904697	127.9258216	OFFICIAL	2026-01-29 23:28:25.042639	0	\N
315	경상남도 거창군 웅양면 동호리 868	2026-01-29 23:28:25.043327	35.79923213	127.9242421	OFFICIAL	2026-01-29 23:28:25.043335	0	\N
316	경상남도 거창군 웅양면 죽림리 686-7	2026-01-29 23:28:25.044009	35.7971002	127.9071784	OFFICIAL	2026-01-29 23:28:25.044017	0	\N
317	경상남도 거창군 웅양면 신촌리 620-5	2026-01-29 23:28:25.044781	35.88168142	127.9131966	OFFICIAL	2026-01-29 23:28:25.044789	0	\N
318	경상남도 거창군 웅양면 산포리 1387-19	2026-01-29 23:28:25.046303	35.82108481	127.9284932	OFFICIAL	2026-01-29 23:28:25.046311	0	\N
319	경상남도 거창군 웅양면 노현리 147-2	2026-01-29 23:28:25.048231	35.80666381	127.9178214	OFFICIAL	2026-01-29 23:28:25.048239	0	\N
320	경상남도 거창군 주상면 도평리 376-9	2026-01-29 23:28:25.04896	35.75554332	127.9157703	OFFICIAL	2026-01-29 23:28:25.048968	0	\N
321	경상남도 거창군 거창읍 김천리 210-31	2026-01-29 23:28:25.049861	35.6757584	127.909394	OFFICIAL	2026-01-29 23:28:25.04987	0	\N
322	경상남도 거창군 거창읍 송정리 839-1	2026-01-29 23:28:25.050539	35.68152227	127.8959979	OFFICIAL	2026-01-29 23:28:25.050547	0	\N
323	경상남도 거창군 거창읍 중앙리 353-3	2026-01-29 23:28:25.051323	35.69011991	127.9100497	OFFICIAL	2026-01-29 23:28:25.051332	0	\N
324	경상남도 거창군 거창읍 중앙리 2-6	2026-01-29 23:28:25.051995	35.69310911	127.9119846	OFFICIAL	2026-01-29 23:28:25.052003	0	\N
325	경상남도 거창군 거창읍 가지리 995-1	2026-01-29 23:28:25.052658	35.70345119	127.897809	OFFICIAL	2026-01-29 23:28:25.05269	0	\N
326	경상남도 거창군 거창읍 양평리 1239-110	2026-01-29 23:28:25.053439	35.68692195	127.9375303	OFFICIAL	2026-01-29 23:28:25.053461	0	\N
327	경상남도 거창군 거창읍 양평리 829	2026-01-29 23:28:25.054227	35.71402531	127.938854	OFFICIAL	2026-01-29 23:28:25.054233	0	\N
328	경상남도 거창군 거창읍 동변리 62-1	2026-01-29 23:28:25.054943	35.7162098	127.9178782	OFFICIAL	2026-01-29 23:28:25.05495	0	\N
329	경상남도 거창군 거창읍 김천리 20-6	2026-01-29 23:28:25.055675	35.68358187	127.9145165	OFFICIAL	2026-01-29 23:28:25.055682	0	\N
330	경상남도 거창군 거창읍 김천리 59-7	2026-01-29 23:28:25.056436	35.68252094	127.9137194	OFFICIAL	2026-01-29 23:28:25.056443	0	\N
331	경상남도 거창군 거창읍 대평리 1054-11	2026-01-29 23:28:25.057176	35.68424168	127.9195439	OFFICIAL	2026-01-29 23:28:25.057183	0	\N
332	경상남도 거창군 거창읍 상림리 243-19	2026-01-29 23:28:25.057878	35.68449465	127.9022872	OFFICIAL	2026-01-29 23:28:25.057885	0	\N
333	경상남도 거창군 주상면 하임실길 112	2026-01-29 23:28:25.058574	35.75051893	127.8951033	OFFICIAL	2026-01-29 23:28:25.058581	0	\N
334	경상남도 거창군 주상면 원성기1길 88	2026-01-29 23:28:25.059266	35.77600321	127.9245279	OFFICIAL	2026-01-29 23:28:25.059273	0	\N
335	경상남도 거창군 주상면 오류동길 44	2026-01-29 23:28:25.060113	35.78585923	127.8890597	OFFICIAL	2026-01-29 23:28:25.06012	0	\N
336	경상남도 거창군 주상면 연교1길 40	2026-01-29 23:28:25.06082	35.76142063	127.8992363	OFFICIAL	2026-01-29 23:28:25.060826	0	\N
337	경상남도 거창군 주상면 상도평길 35-6	2026-01-29 23:28:25.061506	35.75470379	127.9137809	OFFICIAL	2026-01-29 23:28:25.061513	0	\N
338	경상남도 거창군 주상면 도평리 1126	2026-01-29 23:28:25.062191	35.74506998	127.9290736	OFFICIAL	2026-01-29 23:28:25.062198	0	\N
339	경상남도 거창군 주상면 도평3길 15	2026-01-29 23:28:25.062926	35.74982815	127.9129963	OFFICIAL	2026-01-29 23:28:25.062933	0	\N
340	경상남도 거창군 주상면 도평1길 60	2026-01-29 23:28:25.063614	35.74952313	127.9142324	OFFICIAL	2026-01-29 23:28:25.06362	0	\N
341	경상남도 거창군 주상면 도동길 15	2026-01-29 23:28:25.064298	35.79696853	127.876873	OFFICIAL	2026-01-29 23:28:25.064305	0	\N
342	경상남도 거창군 주상면 당대고개길 6	2026-01-29 23:28:25.065185	35.75068571	127.9145895	OFFICIAL	2026-01-29 23:28:25.065192	0	\N
343	경상남도 거창군 주상면 거기1길 23	2026-01-29 23:28:25.066532	35.75659428	127.9410311	OFFICIAL	2026-01-29 23:28:25.066541	0	\N
344	경상남도 거창군 위천면 은하리길 2	2026-01-29 23:28:25.067299	35.76092327	127.8336769	OFFICIAL	2026-01-29 23:28:25.067307	0	\N
345	경상남도 거창군 위천면 원학길 321	2026-01-29 23:28:25.068144	35.74924121	127.8326881	OFFICIAL	2026-01-29 23:28:25.068151	0	\N
346	경상남도 거창군 위천면 원당1길 39	2026-01-29 23:28:25.068923	35.77489552	127.8678822	OFFICIAL	2026-01-29 23:28:25.06893	0	\N
347	경상남도 거창군 위천면 금원산길 471-27	2026-01-29 23:28:25.069644	35.72617571	127.795727	OFFICIAL	2026-01-29 23:28:25.069651	0	\N
348	경상남도 거창군 웅양면 죽림리 산108	2026-01-29 23:28:25.070345	35.79030695	127.9056157	OFFICIAL	2026-01-29 23:28:25.070352	0	\N
349	경상남도 거창군 웅양면 성북1길 259-6	2026-01-29 23:28:25.071045	35.79177533	127.9283434	OFFICIAL	2026-01-29 23:28:25.071085	0	\N
350	경상남도 거창군 웅양면 누룩재길 164	2026-01-29 23:28:25.071811	35.7971002	127.9071784	OFFICIAL	2026-01-29 23:28:25.071818	0	\N
351	경상남도 거창군 신원면 양지1길 8-1	2026-01-29 23:28:25.072466	35.5849552	127.9584444	OFFICIAL	2026-01-29 23:28:25.072489	0	\N
352	경상남도 거창군 신원면 신차로 2924	2026-01-29 23:28:25.073169	35.55574562	127.9248903	OFFICIAL	2026-01-29 23:28:25.073176	0	\N
353	경상남도 거창군 신원면 신머리길 3	2026-01-29 23:28:25.073911	35.53510242	127.8841341	OFFICIAL	2026-01-29 23:28:25.073918	0	\N
354	경상남도 거창군 신원면 상감악길 447-44	2026-01-29 23:28:25.074599	35.58800734	127.930925	OFFICIAL	2026-01-29 23:28:25.074606	0	\N
355	경상남도 거창군 북상면 병곡리 768-4	2026-01-29 23:28:25.075361	35.80911337	127.7756271	OFFICIAL	2026-01-29 23:28:25.075368	0	\N
356	경상남도 거창군 북상면 병곡길 185	2026-01-29 23:28:25.076141	35.79172837	127.7891925	OFFICIAL	2026-01-29 23:28:25.076147	0	\N
357	경상남도 거창군 북상면 덕유월성로1312-96	2026-01-29 23:28:25.076866	35.76120302	127.724	OFFICIAL	2026-01-29 23:28:25.076873	0	\N
358	경상남도 거창군 북상면 덕유월성로 1312-96	2026-01-29 23:28:25.077575	35.76120302	127.724	OFFICIAL	2026-01-29 23:28:25.077582	0	\N
359	경상남도 거창군 마리면 진산길 51-13	2026-01-29 23:28:25.07828	35.6983895	127.856838	OFFICIAL	2026-01-29 23:28:25.078286	0	\N
360	경상남도 거창군 마리면 율리 940-7	2026-01-29 23:28:25.078964	35.73199174	127.8536034	OFFICIAL	2026-01-29 23:28:25.078971	0	\N
361	경상남도 거창군 마리면 빼재로 23	2026-01-29 23:28:25.079639	35.70257339	127.8535867	OFFICIAL	2026-01-29 23:28:25.079645	0	\N
362	경상남도 거창군 마리면 매바우길 26	2026-01-29 23:28:25.080353	35.74449654	127.8580807	OFFICIAL	2026-01-29 23:28:25.08036	0	\N
363	경상남도 거창군 마리면 거안로 851	2026-01-29 23:28:25.081977	35.69943006	127.8564486	OFFICIAL	2026-01-29 23:28:25.081984	0	\N
364	경상남도 거창군 마리면 거안로 1035	2026-01-29 23:28:25.082735	35.68826694	127.8703455	OFFICIAL	2026-01-29 23:28:25.082743	0	\N
365	경상남도 거창군 남하면 지산로 731	2026-01-29 23:28:25.083422	35.66501522	127.9982123	OFFICIAL	2026-01-29 23:28:25.083429	0	\N
366	경상남도 거창군 남하면 양항길 354	2026-01-29 23:28:25.084109	35.68566767	127.9453686	OFFICIAL	2026-01-29 23:28:25.084116	0	\N
367	경상남도 거창군 남하면 양항길 310-11	2026-01-29 23:28:25.084855	35.68359544	127.944922	OFFICIAL	2026-01-29 23:28:25.084862	0	\N
368	경상남도 거창군 남하면 양항리 958	2026-01-29 23:28:25.085725	35.68436863	127.9398827	OFFICIAL	2026-01-29 23:28:25.085732	0	\N
369	경상남도 거창군 남하면 대야길 69-26	2026-01-29 23:28:25.08669	35.63801549	127.9642103	OFFICIAL	2026-01-29 23:28:25.086699	0	\N
370	경상남도 거창군 남상면 홍덕길 41	2026-01-29 23:28:25.087658	35.65442187	127.9334152	OFFICIAL	2026-01-29 23:28:25.087665	0	\N
371	경상남도 거창군 남상면 한산1길 122	2026-01-29 23:28:25.088525	35.64183675	127.937744	OFFICIAL	2026-01-29 23:28:25.088531	0	\N
372	경상남도 거창군 남상면 임불1길 57	2026-01-29 23:28:25.089373	35.61457278	127.9691721	OFFICIAL	2026-01-29 23:28:25.089379	0	\N
373	경상남도 거창군 남상면 일반산업길 160	2026-01-29 23:28:25.090081	35.65622785	127.9270145	OFFICIAL	2026-01-29 23:28:25.090088	0	\N
374	경상남도 거창군 남상면 인평길 36	2026-01-29 23:28:25.090894	35.64298394	127.9105058	OFFICIAL	2026-01-29 23:28:25.090902	0	\N
375	경상남도 거창군 남상면 인평길 21	2026-01-29 23:28:25.092194	35.64501258	127.9105881	OFFICIAL	2026-01-29 23:28:25.0922	0	\N
376	경상남도 거창군 남상면 웃골길 71	2026-01-29 23:28:25.092902	35.65646376	127.9146321	OFFICIAL	2026-01-29 23:28:25.09291	0	\N
377	경상남도 거창군 남상면 동령길 26-10	2026-01-29 23:28:25.093557	35.60688644	127.8770277	OFFICIAL	2026-01-29 23:28:25.093564	0	\N
378	경상남도 거창군 남상면 대산리 1599-1	2026-01-29 23:28:25.094212	35.65507959	127.9352875	OFFICIAL	2026-01-29 23:28:25.094219	0	\N
379	경상남도 거창군 고제면 하개명길 37	2026-01-29 23:28:25.094889	35.82801774	127.857058	OFFICIAL	2026-01-29 23:28:25.094896	0	\N
380	경상남도 거창군 고제면 소사길 52-5	2026-01-29 23:28:25.095541	35.90008506	127.8632116	OFFICIAL	2026-01-29 23:28:25.095547	0	\N
381	경상남도 거창군 고제면 고제로 333	2026-01-29 23:28:25.096207	35.83826388	127.876882	OFFICIAL	2026-01-29 23:28:25.096213	0	\N
382	경상남도 거창군 거창읍 창남5길 3-8	2026-01-29 23:28:25.096969	35.68246429	127.9125741	OFFICIAL	2026-01-29 23:28:25.096976	0	\N
383	경상남도 거창군 거창읍 창남1길 58	2026-01-29 23:28:25.098323	35.68316068	127.9152693	OFFICIAL	2026-01-29 23:28:25.098331	0	\N
384	경상남도 거창군 거창읍 창남1길 44	2026-01-29 23:28:25.099228	35.68226474	127.9146302	OFFICIAL	2026-01-29 23:28:25.099235	0	\N
385	경상남도 거창군 거창읍 창남1길 44	2026-01-29 23:28:25.100175	35.68226474	127.9146302	OFFICIAL	2026-01-29 23:28:25.100181	0	\N
386	경상남도 거창군 거창읍 창남1길 44	2026-01-29 23:28:25.101335	35.68226474	127.9146302	OFFICIAL	2026-01-29 23:28:25.101342	0	\N
387	경상남도 거창군 거창읍 창남1길 44	2026-01-29 23:28:25.102078	35.68226474	127.9146302	OFFICIAL	2026-01-29 23:28:25.102085	0	\N
388	경상남도 거창군 거창읍 창남1길 21	2026-01-29 23:28:25.102737	35.68164038	127.9134168	OFFICIAL	2026-01-29 23:28:25.102744	0	\N
389	경상남도 거창군 거창읍 중앙리 427-4	2026-01-29 23:28:25.103381	35.69121372	127.9098227	OFFICIAL	2026-01-29 23:28:25.103388	0	\N
390	경상남도 거창군 거창읍 중앙로1길 94	2026-01-29 23:28:25.104093	35.69006104	127.9168934	OFFICIAL	2026-01-29 23:28:25.104099	0	\N
391	경상남도 거창군 거창읍 중앙로1길 67	2026-01-29 23:28:25.104819	35.68951115	127.915727	OFFICIAL	2026-01-29 23:28:25.104826	0	\N
392	경상남도 거창군 거창읍 중앙로1길 67	2026-01-29 23:28:25.105464	35.68951115	127.915727	OFFICIAL	2026-01-29 23:28:25.105471	0	\N
393	경상남도 거창군 거창읍 중앙로1길 124	2026-01-29 23:28:25.106121	35.69095781	127.9182729	OFFICIAL	2026-01-29 23:28:25.106128	0	\N
394	경상남도 거창군 거창읍 중앙로 89	2026-01-29 23:28:25.106779	35.68569829	127.9085389	OFFICIAL	2026-01-29 23:28:25.106788	0	\N
395	경상남도 거창군 거창읍 중앙로 198	2026-01-29 23:28:25.107412	35.68861862	127.9198318	OFFICIAL	2026-01-29 23:28:25.107418	0	\N
396	경상남도 거창군 거창읍 중앙로 182	2026-01-29 23:28:25.108078	35.6881817	127.9182268	OFFICIAL	2026-01-29 23:28:25.108085	0	\N
397	경상남도 거창군 거창읍 중산길 62	2026-01-29 23:28:25.108782	35.67152291	127.9088316	OFFICIAL	2026-01-29 23:28:25.108789	0	\N
398	경상남도 거창군 거창읍 죽전길 24-5	2026-01-29 23:28:25.109409	35.69011922	127.908328	OFFICIAL	2026-01-29 23:28:25.109415	0	\N
399	경상남도 거창군 거창읍 죽전7길 13	2026-01-29 23:28:25.110061	35.69310247	127.9134433	OFFICIAL	2026-01-29 23:28:25.110067	0	\N
400	경상남도 거창군 거창읍 죽전4길 79-3	2026-01-29 23:28:25.110708	35.69346601	127.9102459	OFFICIAL	2026-01-29 23:28:25.110714	0	\N
401	경상남도 거창군 거창읍 죽전4길 79-3	2026-01-29 23:28:25.111395	35.69346601	127.9102459	OFFICIAL	2026-01-29 23:28:25.111401	0	\N
402	경상남도 거창군 거창읍 죽전4길 39	2026-01-29 23:28:25.112075	35.69196393	127.9102311	OFFICIAL	2026-01-29 23:28:25.112081	0	\N
403	경상남도 거창군 거창읍 죽전4길 28	2026-01-29 23:28:25.112702	35.69175768	127.9121537	OFFICIAL	2026-01-29 23:28:25.112709	0	\N
404	경상남도 거창군 거창읍 죽전2길 60	2026-01-29 23:28:25.11336	35.69174336	127.909401	OFFICIAL	2026-01-29 23:28:25.113368	0	\N
405	경상남도 거창군 거창읍 죽전2길 57	2026-01-29 23:28:25.114014	35.69134655	127.9094595	OFFICIAL	2026-01-29 23:28:25.11402	0	\N
406	경상남도 거창군 거창읍 죽전2길 43,33-4	2026-01-29 23:28:25.11469	35.69142095	127.9099067	OFFICIAL	2026-01-29 23:28:25.114697	0	\N
3013	구미시	2026-02-03 13:28:31.141184	36.1071743	128.4165079	PENDING	2026-02-03 13:28:31.141239	1	test
407	경상남도 거창군 거창읍 죽전2길 34-3,죽전길 24-5	2026-01-29 23:28:25.115377	35.69115915	127.9102384	OFFICIAL	2026-01-29 23:28:25.115384	0	\N
408	경상남도 거창군 거창읍 죽전2길 33-4	2026-01-29 23:28:25.116124	35.69117361	127.9100188	OFFICIAL	2026-01-29 23:28:25.11613	0	\N
409	경상남도 거창군 거창읍 죽전2길 16	2026-01-29 23:28:25.116894	35.69037659	127.9104314	OFFICIAL	2026-01-29 23:28:25.1169	0	\N
410	경상남도 거창군 거창읍 죽전1길 8	2026-01-29 23:28:25.117516	35.68971563	127.909165	OFFICIAL	2026-01-29 23:28:25.117522	0	\N
411	경상남도 거창군 거창읍 죽전1길 72	2026-01-29 23:28:25.11817	35.69274942	127.9088778	OFFICIAL	2026-01-29 23:28:25.118176	0	\N
412	경상남도 거창군 거창읍 죽동길 138	2026-01-29 23:28:25.11895	35.71868403	127.9020084	OFFICIAL	2026-01-29 23:28:25.118957	0	\N
413	경상남도 거창군 거창읍 주곡로 207	2026-01-29 23:28:25.119626	35.71382296	127.9169681	OFFICIAL	2026-01-29 23:28:25.119632	0	\N
414	경상남도 거창군 거창읍 주곡로 19	2026-01-29 23:28:25.120308	35.69670903	127.9192366	OFFICIAL	2026-01-29 23:28:25.120315	0	\N
415	경상남도 거창군 거창읍 정장길 19	2026-01-29 23:28:25.120967	35.6776769	127.9132959	OFFICIAL	2026-01-29 23:28:25.120973	0	\N
416	경상남도 거창군 거창읍 장팔길 93	2026-01-29 23:28:25.121601	35.67639913	127.9084095	OFFICIAL	2026-01-29 23:28:25.121607	0	\N
417	경상남도 거창군 거창읍 장팔길 93	2026-01-29 23:28:25.122222	35.67639913	127.9084095	OFFICIAL	2026-01-29 23:28:25.122229	0	\N
418	경상남도 거창군 거창읍 장팔길 91	2026-01-29 23:28:25.122923	35.67644016	127.908442	OFFICIAL	2026-01-29 23:28:25.122929	0	\N
419	경상남도 거창군 거창읍 장성골길 99	2026-01-29 23:28:25.123568	35.73686092	127.9307974	OFFICIAL	2026-01-29 23:28:25.123575	0	\N
420	경상남도 거창군 거창읍 의동1길 71-4	2026-01-29 23:28:25.124213	35.71644122	127.9295868	OFFICIAL	2026-01-29 23:28:25.12422	0	\N
421	경상남도 거창군 거창읍 운정3길 70-20	2026-01-29 23:28:25.124886	35.67768183	127.8952051	OFFICIAL	2026-01-29 23:28:25.124892	0	\N
422	경상남도 거창군 거창읍 운정3길 179	2026-01-29 23:28:25.125517	35.6758361	127.890462	OFFICIAL	2026-01-29 23:28:25.125524	0	\N
423	경상남도 거창군 거창읍 외학길 19	2026-01-29 23:28:25.126138	35.74047317	127.927131	OFFICIAL	2026-01-29 23:28:25.126144	0	\N
424	경상남도 거창군 거창읍 양평리 1141	2026-01-29 23:28:25.1268	35.69370448	127.9308049	OFFICIAL	2026-01-29 23:28:25.126806	0	\N
425	경상남도 거창군 거창읍 아림로3길 91	2026-01-29 23:28:25.127427	35.68997504	127.9141115	OFFICIAL	2026-01-29 23:28:25.127434	0	\N
426	경상남도 거창군 거창읍 아림로1길 20	2026-01-29 23:28:25.128086	35.68523733	127.9098241	OFFICIAL	2026-01-29 23:28:25.128093	0	\N
427	경상남도 거창군 거창읍 아림로 23	2026-01-29 23:28:25.128708	35.68517155	127.9105735	OFFICIAL	2026-01-29 23:28:25.128714	0	\N
428	경상남도 거창군 거창읍 심소정길 185	2026-01-29 23:28:25.129387	35.68709799	127.9048324	OFFICIAL	2026-01-29 23:28:25.129393	0	\N
429	경상남도 거창군 거창읍 수남로 2264-22	2026-01-29 23:28:25.130035	35.68114651	127.9135099	OFFICIAL	2026-01-29 23:28:25.130042	0	\N
430	경상남도 거창군 거창읍 수남로 2203-8	2026-01-29 23:28:25.130743	35.67579688	127.9108131	OFFICIAL	2026-01-29 23:28:25.130778	0	\N
431	경상남도 거창군 거창읍 수남로 2159	2026-01-29 23:28:25.131395	35.67177176	127.9107253	OFFICIAL	2026-01-29 23:28:25.131401	0	\N
432	경상남도 거창군 거창읍 송정리 609	2026-01-29 23:28:25.132075	35.67746209	127.901858	OFFICIAL	2026-01-29 23:28:25.132082	0	\N
433	경상남도 거창군 거창읍 송정리 1134-13,14	2026-01-29 23:28:25.132716	35.68131794	127.9085437	OFFICIAL	2026-01-29 23:28:25.132722	0	\N
434	경상남도 거창군 거창읍 송정리 1118-3	2026-01-29 23:28:25.133344	35.68048981	127.9028147	OFFICIAL	2026-01-29 23:28:25.13335	0	\N
435	경상남도 거창군 거창읍 송정리 1114-12	2026-01-29 23:28:25.133991	35.68076043	127.9032866	OFFICIAL	2026-01-29 23:28:25.133998	0	\N
436	경상남도 거창군 거창읍 송정리 1110-8	2026-01-29 23:28:25.134626	35.68159846	127.9048888	OFFICIAL	2026-01-29 23:28:25.134632	0	\N
437	경상남도 거창군 거창읍 송정리 1109-8	2026-01-29 23:28:25.13525	35.68170841	127.9040766	OFFICIAL	2026-01-29 23:28:25.135256	0	\N
438	경상남도 거창군 거창읍 송정9길 77	2026-01-29 23:28:25.135878	35.68135243	127.9105028	OFFICIAL	2026-01-29 23:28:25.135884	0	\N
439	경상남도 거창군 거창읍 송정9길 66	2026-01-29 23:28:25.136512	35.68105101	127.9098857	OFFICIAL	2026-01-29 23:28:25.136519	0	\N
440	경상남도 거창군 거창읍 송정9길 60	2026-01-29 23:28:25.137163	35.68104827	127.9095849	OFFICIAL	2026-01-29 23:28:25.137169	0	\N
441	경상남도 거창군 거창읍 송정9길 53	2026-01-29 23:28:25.137776	35.68132409	127.9092023	OFFICIAL	2026-01-29 23:28:25.137782	0	\N
442	경상남도 거창군 거창읍 송정9길 49	2026-01-29 23:28:25.138397	35.68134262	127.9090343	OFFICIAL	2026-01-29 23:28:25.138403	0	\N
443	경상남도 거창군 거창읍 송정9길 47	2026-01-29 23:28:25.139049	35.68134089	127.9088693	OFFICIAL	2026-01-29 23:28:25.139055	0	\N
444	경상남도 거창군 거창읍 송정9길 43	2026-01-29 23:28:25.139661	35.68134262	127.908711	OFFICIAL	2026-01-29 23:28:25.139667	0	\N
445	경상남도 거창군 거창읍 송정9길 42	2026-01-29 23:28:25.140318	35.68103949	127.9086528	OFFICIAL	2026-01-29 23:28:25.140325	0	\N
446	경상남도 거창군 거창읍 송정9길 40	2026-01-29 23:28:25.140958	35.68103277	127.9085211	OFFICIAL	2026-01-29 23:28:25.140964	0	\N
447	경상남도 거창군 거창읍 송정9길 38	2026-01-29 23:28:25.141731	35.68102482	127.9083562	OFFICIAL	2026-01-29 23:28:25.14174	0	\N
448	경상남도 거창군 거창읍 송정9길 22	2026-01-29 23:28:25.142446	35.68101388	127.9074397	OFFICIAL	2026-01-29 23:28:25.142453	0	\N
449	경상남도 거창군 거창읍 송정8길 86	2026-01-29 23:28:25.143455	35.68104691	127.9094361	OFFICIAL	2026-01-29 23:28:25.143463	0	\N
450	경상남도 거창군 거창읍 송정7길 86	2026-01-29 23:28:25.14421	35.68053337	127.9105393	OFFICIAL	2026-01-29 23:28:25.144217	0	\N
451	경상남도 거창군 거창읍 송정7길 80	2026-01-29 23:28:25.144942	35.68060831	127.9101991	OFFICIAL	2026-01-29 23:28:25.144949	0	\N
452	경상남도 거창군 거창읍 송정7길 74	2026-01-29 23:28:25.145618	35.68059462	127.9098512	OFFICIAL	2026-01-29 23:28:25.145625	0	\N
453	경상남도 거창군 거창읍 송정7길 70	2026-01-29 23:28:25.146313	35.68059285	127.909668	OFFICIAL	2026-01-29 23:28:25.14632	0	\N
454	경상남도 거창군 거창읍 송정7길 67	2026-01-29 23:28:25.147014	35.68085196	127.9096094	OFFICIAL	2026-01-29 23:28:25.147021	0	\N
455	경상남도 거창군 거창읍 송정7길 59	2026-01-29 23:28:25.147663	35.68087241	127.9090735	OFFICIAL	2026-01-29 23:28:25.147669	0	\N
456	경상남도 거창군 거창읍 송정7길 112	2026-01-29 23:28:25.148325	35.68182474	127.9107626	OFFICIAL	2026-01-29 23:28:25.148333	0	\N
457	경상남도 거창군 거창읍 송정6길 19	2026-01-29 23:28:25.148955	35.68119777	127.9038063	OFFICIAL	2026-01-29 23:28:25.148961	0	\N
458	경상남도 거창군 거창읍 송정5길 54	2026-01-29 23:28:25.149657	35.68094801	127.9047917	OFFICIAL	2026-01-29 23:28:25.149664	0	\N
459	경상남도 거창군 거창읍 송정5길 48	2026-01-29 23:28:25.150301	35.68094565	127.9045397	OFFICIAL	2026-01-29 23:28:25.150307	0	\N
460	경상남도 거창군 거창읍 송정5길 40	2026-01-29 23:28:25.150963	35.68092537	127.9040895	OFFICIAL	2026-01-29 23:28:25.15097	0	\N
461	경상남도 거창군 거창읍 송정5길 25	2026-01-29 23:28:25.151576	35.68122383	127.9033354	OFFICIAL	2026-01-29 23:28:25.151582	0	\N
462	경상남도 거창군 거창읍 송정5길 22	2026-01-29 23:28:25.152228	35.68093238	127.9031418	OFFICIAL	2026-01-29 23:28:25.152235	0	\N
463	경상남도 거창군 거창읍 송정5길 13	2026-01-29 23:28:25.152854	35.68117045	127.9026772	OFFICIAL	2026-01-29 23:28:25.15286	0	\N
464	경상남도 거창군 거창읍 송정4길 57	2026-01-29 23:28:25.153454	35.68042338	127.9043022	OFFICIAL	2026-01-29 23:28:25.15346	0	\N
465	경상남도 거창군 거창읍 송정3길 37-10	2026-01-29 23:28:25.15408	35.68191472	127.9032018	OFFICIAL	2026-01-29 23:28:25.154085	0	\N
466	경상남도 거창군 거창읍 송정3길 34	2026-01-29 23:28:25.154678	35.68135206	127.9028079	OFFICIAL	2026-01-29 23:28:25.154684	0	\N
467	경상남도 거창군 거창읍 송정3길 20	2026-01-29 23:28:25.155271	35.68129268	127.9023661	OFFICIAL	2026-01-29 23:28:25.155277	0	\N
468	경상남도 거창군 거창읍 송정1길 95	2026-01-29 23:28:25.155898	35.68070354	127.902099	OFFICIAL	2026-01-29 23:28:25.155904	0	\N
469	경상남도 거창군 거창읍 송정1길 147	2026-01-29 23:28:25.156638	35.68078403	127.9049659	OFFICIAL	2026-01-29 23:28:25.156645	0	\N
470	경상남도 거창군 거창읍 송정1길 146,148	2026-01-29 23:28:25.157345	35.68054782	127.904833	OFFICIAL	2026-01-29 23:28:25.157351	0	\N
471	경상남도 거창군 거창읍 송정1길 134	2026-01-29 23:28:25.157954	35.68054168	127.9042469	OFFICIAL	2026-01-29 23:28:25.15796	0	\N
472	경상남도 거창군 거창읍 송정1길 132	2026-01-29 23:28:25.158533	35.68054182	127.9040721	OFFICIAL	2026-01-29 23:28:25.158539	0	\N
473	경상남도 거창군 거창읍 송정1길 124	2026-01-29 23:28:25.159113	35.68052155	127.9036068	OFFICIAL	2026-01-29 23:28:25.159119	0	\N
474	경상남도 거창군 거창읍 송정1길 121	2026-01-29 23:28:25.159677	35.68076372	127.9034643	OFFICIAL	2026-01-29 23:28:25.159683	0	\N
475	경상남도 거창군 거창읍 송정1길 120	2026-01-29 23:28:25.160323	35.68051602	127.9033957	OFFICIAL	2026-01-29 23:28:25.160329	0	\N
476	경상남도 거창군 거창읍 송정1길 112	2026-01-29 23:28:25.161009	35.68049471	127.9030026	OFFICIAL	2026-01-29 23:28:25.161015	0	\N
477	경상남도 거창군 거창읍 송정10길 51	2026-01-29 23:28:25.161652	35.68181152	127.9090015	OFFICIAL	2026-01-29 23:28:25.161658	0	\N
478	경상남도 거창군 거창읍 송정10길 48,50	2026-01-29 23:28:25.162309	35.68150924	127.9087502	OFFICIAL	2026-01-29 23:28:25.162315	0	\N
479	경상남도 거창군 거창읍 송정10길 47	2026-01-29 23:28:25.162957	35.68183104	127.9088138	OFFICIAL	2026-01-29 23:28:25.162963	0	\N
480	경상남도 거창군 거창읍 송정10길 15	2026-01-29 23:28:25.163558	35.68084163	127.9078908	OFFICIAL	2026-01-29 23:28:25.163564	0	\N
481	경상남도 거창군 거창읍 소만5길 37	2026-01-29 23:28:25.164187	35.69238766	127.9220067	OFFICIAL	2026-01-29 23:28:25.164194	0	\N
482	경상남도 거창군 거창읍 소만4길 22	2026-01-29 23:28:25.164846	35.69307488	127.9236258	OFFICIAL	2026-01-29 23:28:25.164852	0	\N
483	경상남도 거창군 거창읍 소만3길 42	2026-01-29 23:28:25.165443	35.69382728	127.9220679	OFFICIAL	2026-01-29 23:28:25.165449	0	\N
484	경상남도 거창군 거창읍 소만3길 36-19	2026-01-29 23:28:25.16608	35.69309764	127.9218582	OFFICIAL	2026-01-29 23:28:25.166086	0	\N
485	경상남도 거창군 거창읍 소만3길 36-16	2026-01-29 23:28:25.166716	35.69304951	127.921517	OFFICIAL	2026-01-29 23:28:25.166722	0	\N
486	경상남도 거창군 거창읍 소만3길 14-23	2026-01-29 23:28:25.167322	35.69289169	127.9206736	OFFICIAL	2026-01-29 23:28:25.167328	0	\N
487	경상남도 거창군 거창읍 소만3길 14-15	2026-01-29 23:28:25.167957	35.69319233	127.9206583	OFFICIAL	2026-01-29 23:28:25.167963	0	\N
488	경상남도 거창군 거창읍 소만3길 14-15	2026-01-29 23:28:25.168539	35.69319233	127.9206583	OFFICIAL	2026-01-29 23:28:25.168545	0	\N
489	경상남도 거창군 거창읍 소만2길 31	2026-01-29 23:28:25.169149	35.69367373	127.9220776	OFFICIAL	2026-01-29 23:28:25.169155	0	\N
490	경상남도 거창군 거창읍 소만1길 58	2026-01-29 23:28:25.169798	35.69489358	127.9210978	OFFICIAL	2026-01-29 23:28:25.169804	0	\N
491	경상남도 거창군 거창읍 소만1길 28	2026-01-29 23:28:25.170431	35.69348022	127.9212427	OFFICIAL	2026-01-29 23:28:25.170437	0	\N
492	경상남도 거창군 거창읍 소만1길 21	2026-01-29 23:28:25.171084	35.69317204	127.9209194	OFFICIAL	2026-01-29 23:28:25.171091	0	\N
493	경상남도 거창군 거창읍 소만1길 17	2026-01-29 23:28:25.171693	35.69290774	127.9209379	OFFICIAL	2026-01-29 23:28:25.171699	0	\N
494	경상남도 거창군 거창읍 소만1길 16-8	2026-01-29 23:28:25.172342	35.69267152	127.9216098	OFFICIAL	2026-01-29 23:28:25.172348	0	\N
495	경상남도 거창군 거창읍 샛단길 21-14	2026-01-29 23:28:25.17296	35.6833386	127.8935413	OFFICIAL	2026-01-29 23:28:25.172966	0	\N
496	경상남도 거창군 거창읍 상림리 851	2026-01-29 23:28:25.173688	35.68628654	127.9022585	OFFICIAL	2026-01-29 23:28:25.173694	0	\N
497	경상남도 거창군 거창읍 상림리 495	2026-01-29 23:28:25.174448	35.68648926	127.8943328	OFFICIAL	2026-01-29 23:28:25.174454	0	\N
498	경상남도 거창군 거창읍 상림리 31-2	2026-01-29 23:28:25.175222	35.68730526	127.907825	OFFICIAL	2026-01-29 23:28:25.175229	0	\N
499	경상남도 거창군 거창읍 상림리 116-5	2026-01-29 23:28:25.175886	35.68483448	127.9085095	OFFICIAL	2026-01-29 23:28:25.175892	0	\N
500	경상남도 거창군 거창읍 상동8길 15	2026-01-29 23:28:25.176513	35.68725247	127.9058254	OFFICIAL	2026-01-29 23:28:25.17652	0	\N
501	경상남도 거창군 거창읍 상동7길 46	2026-01-29 23:28:25.177118	35.68739662	127.9066347	OFFICIAL	2026-01-29 23:28:25.177124	0	\N
502	경상남도 거창군 거창읍 상동7길 46	2026-01-29 23:28:25.177963	35.68739662	127.9066347	OFFICIAL	2026-01-29 23:28:25.177971	0	\N
503	경상남도 거창군 거창읍 상동7길 46	2026-01-29 23:28:25.178569	35.68739662	127.9066347	OFFICIAL	2026-01-29 23:28:25.178576	0	\N
504	경상남도 거창군 거창읍 상동6길 17	2026-01-29 23:28:25.179163	35.68860743	127.9084048	OFFICIAL	2026-01-29 23:28:25.179169	0	\N
505	경상남도 거창군 거창읍 상동6길 17	2026-01-29 23:28:25.179787	35.68860743	127.9084048	OFFICIAL	2026-01-29 23:28:25.179793	0	\N
506	경상남도 거창군 거창읍 상동1길 45	2026-01-29 23:28:25.180402	35.68684802	127.906684	OFFICIAL	2026-01-29 23:28:25.180409	0	\N
507	경상남도 거창군 거창읍 밤티재로 1288	2026-01-29 23:28:25.181028	35.67061785	127.9324907	OFFICIAL	2026-01-29 23:28:25.181034	0	\N
508	경상남도 거창군 거창읍 모곡2길 22	2026-01-29 23:28:25.181649	35.71515524	127.9170544	OFFICIAL	2026-01-29 23:28:25.181655	0	\N
509	경상남도 거창군 거창읍 모곡2길 22	2026-01-29 23:28:25.182329	35.71515524	127.9170544	OFFICIAL	2026-01-29 23:28:25.182336	0	\N
510	경상남도 거창군 거창읍 동산길 41	2026-01-29 23:28:25.18295	35.69971886	127.9175179	OFFICIAL	2026-01-29 23:28:25.182957	0	\N
511	경상남도 거창군 거창읍 동동6길 9	2026-01-29 23:28:25.183571	35.69050342	127.9206649	OFFICIAL	2026-01-29 23:28:25.183593	0	\N
512	경상남도 거창군 거창읍 동동5길 90	2026-01-29 23:28:25.184926	35.69203978	127.9248256	OFFICIAL	2026-01-29 23:28:25.184934	0	\N
513	경상남도 거창군 거창읍 동동5길 68	2026-01-29 23:28:25.186552	35.69181555	127.9234173	OFFICIAL	2026-01-29 23:28:25.18656	0	\N
514	경상남도 거창군 거창읍 동동1길 31	2026-01-29 23:28:25.187269	35.68883105	127.9213158	OFFICIAL	2026-01-29 23:28:25.187276	0	\N
515	경상남도 거창군 거창읍 대평리 1187	2026-01-29 23:28:25.187886	35.68425419	127.9170294	OFFICIAL	2026-01-29 23:28:25.187893	0	\N
516	경상남도 거창군 거창읍 대평리 1054-5	2026-01-29 23:28:25.188574	35.68473007	127.9201862	OFFICIAL	2026-01-29 23:28:25.188581	0	\N
517	경상남도 거창군 거창읍 대평리 1054-20	2026-01-29 23:28:25.189171	35.68450616	127.9201144	OFFICIAL	2026-01-29 23:28:25.189178	0	\N
518	경상남도 거창군 거창읍 대평리 1053-4	2026-01-29 23:28:25.189731	35.68499321	127.9196285	OFFICIAL	2026-01-29 23:28:25.189738	0	\N
519	경상남도 거창군 거창읍 대평리 1053-1	2026-01-29 23:28:25.190384	35.68482494	127.9197718	OFFICIAL	2026-01-29 23:28:25.190391	0	\N
520	경상남도 거창군 거창읍 대평8길 35	2026-01-29 23:28:25.191002	35.68338589	127.9207542	OFFICIAL	2026-01-29 23:28:25.191009	0	\N
521	경상남도 거창군 거창읍 대평7길 54	2026-01-29 23:28:25.191583	35.68359021	127.9207651	OFFICIAL	2026-01-29 23:28:25.191589	0	\N
522	경상남도 거창군 거창읍 대평7길 50	2026-01-29 23:28:25.192171	35.68358744	127.9203973	OFFICIAL	2026-01-29 23:28:25.192178	0	\N
523	경상남도 거창군 거창읍 대평6길 47	2026-01-29 23:28:25.192774	35.68418481	127.9202284	OFFICIAL	2026-01-29 23:28:25.192779	0	\N
524	경상남도 거창군 거창읍 대평6길 30	2026-01-29 23:28:25.193345	35.68376034	127.9192946	OFFICIAL	2026-01-29 23:28:25.193352	0	\N
525	경상남도 거창군 거창읍 대평5길 38-8	2026-01-29 23:28:25.193948	35.6842755	127.9193876	OFFICIAL	2026-01-29 23:28:25.193954	0	\N
526	경상남도 거창군 거창읍 대평3길 51	2026-01-29 23:28:25.194577	35.68487525	127.9207125	OFFICIAL	2026-01-29 23:28:25.194584	0	\N
527	경상남도 거창군 거창읍 대평3길 51	2026-01-29 23:28:25.195169	35.68487525	127.9207125	OFFICIAL	2026-01-29 23:28:25.195175	0	\N
528	경상남도 거창군 거창읍 대평3길 48	2026-01-29 23:28:25.195835	35.68479756	127.9211947	OFFICIAL	2026-01-29 23:28:25.195842	0	\N
529	경상남도 거창군 거창읍 대평3길 38	2026-01-29 23:28:25.196444	35.68453109	127.9213924	OFFICIAL	2026-01-29 23:28:25.196452	0	\N
530	경상남도 거창군 거창읍 대평2길 13	2026-01-29 23:28:25.197089	35.68295105	127.9199871	OFFICIAL	2026-01-29 23:28:25.197096	0	\N
531	경상남도 거창군 거창읍 대동리 983-3	2026-01-29 23:28:25.197674	35.69334291	127.9209087	OFFICIAL	2026-01-29 23:28:25.197687	0	\N
532	경상남도 거창군 거창읍 강양1길 27	2026-01-29 23:28:25.198298	35.69039867	127.9188171	OFFICIAL	2026-01-29 23:28:25.198304	0	\N
533	경상남도 거창군 거창읍 거열로2길 76-14	2026-01-29 23:28:25.198914	35.6948296	127.9136907	OFFICIAL	2026-01-29 23:28:25.198921	0	\N
534	경상남도 거창군 거창읍 대동리 27-20	2026-01-29 23:28:25.199515	35.68725782	127.9176847	OFFICIAL	2026-01-29 23:28:25.199521	0	\N
535	경상남도 거창군 거창읍 대동리 13-5	2026-01-29 23:28:25.200096	35.69023793	127.9233809	OFFICIAL	2026-01-29 23:28:25.200102	0	\N
536	경상남도 거창군 남상면 홍덕길 15	2026-01-29 23:28:25.200665	35.65542594	127.9337653	OFFICIAL	2026-01-29 23:28:25.20067	0	\N
537	경상남도 거창군 남상면 홍덕길 11	2026-01-29 23:28:25.201288	35.65574527	127.9333913	OFFICIAL	2026-01-29 23:28:25.201292	0	\N
538	경상남도 거창군 남상면 창포원길 21-1	2026-01-29 23:28:25.20191	35.6549216	127.9398302	OFFICIAL	2026-01-29 23:28:25.201916	0	\N
539	경상남도 거창군 남상면 진목1길 20	2026-01-29 23:28:25.202476	35.59493615	127.8702702	OFFICIAL	2026-01-29 23:28:25.202482	0	\N
540	경상남도 거창군 남상면 승강기길 80	2026-01-29 23:28:25.203078	35.65308646	127.9300075	OFFICIAL	2026-01-29 23:28:25.203084	0	\N
541	경상남도 거창군 거창읍 김천리 475-3	2026-01-29 23:28:25.203707	35.68104964	127.9097353	OFFICIAL	2026-01-29 23:28:25.203712	0	\N
542	경상남도 거창군 거창읍 김천리 473-1	2026-01-29 23:28:25.204417	35.68209922	127.9094591	OFFICIAL	2026-01-29 23:28:25.204423	0	\N
543	경상남도 거창군 거창읍 김천2길 46	2026-01-29 23:28:25.205065	35.67694353	127.9089053	OFFICIAL	2026-01-29 23:28:25.205071	0	\N
544	경상남도 거창군 거창읍 국농소2길 10	2026-01-29 23:28:25.205664	35.67346358	127.9362578	OFFICIAL	2026-01-29 23:28:25.20567	0	\N
545	경상남도 거창군 거창읍 구산1길 4	2026-01-29 23:28:25.206257	35.71803162	127.9066859	OFFICIAL	2026-01-29 23:28:25.206262	0	\N
546	경상남도 거창군 거창읍 구례길 166	2026-01-29 23:28:25.20687	35.72252727	127.9274857	OFFICIAL	2026-01-29 23:28:25.206876	0	\N
547	경상남도 거창군 거창읍 공수들8길 11	2026-01-29 23:28:25.207443	35.68548079	127.9008675	OFFICIAL	2026-01-29 23:28:25.207449	0	\N
548	경상남도 거창군 거창읍 공수들6길 17	2026-01-29 23:28:25.208083	35.68690156	127.9034589	OFFICIAL	2026-01-29 23:28:25.208088	0	\N
549	경상남도 거창군 거창읍 공수들1길 16	2026-01-29 23:28:25.208683	35.68529222	127.9006909	OFFICIAL	2026-01-29 23:28:25.208689	0	\N
550	경상남도 거창군 거창읍 거함대로5길 51	2026-01-29 23:28:25.209333	35.68284699	127.9208779	OFFICIAL	2026-01-29 23:28:25.209339	0	\N
551	경상남도 거창군 거창읍 거함대로4길 60	2026-01-29 23:28:25.209941	35.68316487	127.9142794	OFFICIAL	2026-01-29 23:28:25.209947	0	\N
552	경상남도 거창군 거창읍 거함대로4길 24	2026-01-29 23:28:25.210542	35.68308147	127.9166304	OFFICIAL	2026-01-29 23:28:25.210548	0	\N
553	경상남도 거창군 거창읍 거함대로3길 23	2026-01-29 23:28:25.211102	35.67937054	127.9107121	OFFICIAL	2026-01-29 23:28:25.211108	0	\N
554	경상남도 거창군 거창읍 거함대로 4길 64	2026-01-29 23:28:25.21169	35.68322887	127.9138744	OFFICIAL	2026-01-29 23:28:25.211695	0	\N
555	경상남도 거창군 거창읍 거함대로 3372-8	2026-01-29 23:28:25.212279	35.67608301	127.9272966	OFFICIAL	2026-01-29 23:28:25.212285	0	\N
556	경상남도 거창군 거창읍 거함대로 3372-30	2026-01-29 23:28:25.212899	35.67569426	127.924782	OFFICIAL	2026-01-29 23:28:25.212905	0	\N
557	경상남도 거창군 거창읍 거함대로 3372	2026-01-29 23:28:25.213506	35.6758035	127.926212	OFFICIAL	2026-01-29 23:28:25.213512	0	\N
558	경상남도 거창군 거창읍 거함대로 3322	2026-01-29 23:28:25.2141	35.67800721	127.9230338	OFFICIAL	2026-01-29 23:28:25.214105	0	\N
559	경상남도 거창군 거창읍 거함대로 3276-3	2026-01-29 23:28:25.214802	35.68031636	127.9188533	OFFICIAL	2026-01-29 23:28:25.214807	0	\N
560	경상남도 거창군 거창읍 거함대로 3235	2026-01-29 23:28:25.215372	35.68175872	127.9154447	OFFICIAL	2026-01-29 23:28:25.215378	0	\N
561	경상남도 거창군 거창읍 거함대로 3200	2026-01-29 23:28:25.216025	35.6802029	127.9117994	OFFICIAL	2026-01-29 23:28:25.216031	0	\N
562	경상남도 거창군 거창읍 거함대로 3196	2026-01-29 23:28:25.216644	35.68022138	127.9115848	OFFICIAL	2026-01-29 23:28:25.21665	0	\N
563	경상남도 거창군 거창읍 거함대로 3079	2026-01-29 23:28:25.217277	35.6809354	127.8987277	OFFICIAL	2026-01-29 23:28:25.217283	0	\N
564	경상남도 거창군 거창읍 거창대학로 72	2026-01-29 23:28:25.217895	35.67320256	127.9124187	OFFICIAL	2026-01-29 23:28:25.2179	0	\N
565	경상남도 거창군 거창읍 거창대로3길 50	2026-01-29 23:28:25.218472	35.68881756	127.9180453	OFFICIAL	2026-01-29 23:28:25.218477	0	\N
566	경상남도 거창군 거창읍 거창대로 52	2026-01-29 23:28:25.219073	35.68639967	127.9167601	OFFICIAL	2026-01-29 23:28:25.219079	0	\N
567	경상남도 거창군 거창읍 거열산성로 73	2026-01-29 23:28:25.219669	35.69281847	127.8948848	OFFICIAL	2026-01-29 23:28:25.219674	0	\N
568	경상남도 거창군 거창읍 거열로9길 158	2026-01-29 23:28:25.22031	35.68728568	127.890722	OFFICIAL	2026-01-29 23:28:25.220316	0	\N
569	경상남도 거창군 거창읍 거열로7길 94	2026-01-29 23:28:25.220941	35.69221396	127.9008954	OFFICIAL	2026-01-29 23:28:25.220946	0	\N
570	경상남도 거창군 거창읍 거열로7길 57	2026-01-29 23:28:25.221489	35.69108338	127.9003606	OFFICIAL	2026-01-29 23:28:25.221495	0	\N
571	경상남도 거창군 거창읍 거열로6길 11	2026-01-29 23:28:25.222061	35.68919288	127.9036746	OFFICIAL	2026-01-29 23:28:25.222066	0	\N
572	경상남도 거창군 거창읍 거열로5길 8-26	2026-01-29 23:28:25.222617	35.68994682	127.9065094	OFFICIAL	2026-01-29 23:28:25.222623	0	\N
573	경상남도 거창군 거창읍 거열로4길 98	2026-01-29 23:28:25.223203	35.69287394	127.9079562	OFFICIAL	2026-01-29 23:28:25.223209	0	\N
574	경상남도 거창군 거창읍 거열로4길 7-13	2026-01-29 23:28:25.223804	35.6895796	127.9067804	OFFICIAL	2026-01-29 23:28:25.22381	0	\N
575	경상남도 거창군 거창읍 거열로4길 406	2026-01-29 23:28:25.224353	35.7023336	127.8959264	OFFICIAL	2026-01-29 23:28:25.224359	0	\N
576	경상남도 거창군 거창읍 거열로4길 161	2026-01-29 23:28:25.224927	35.69541269	127.9059213	OFFICIAL	2026-01-29 23:28:25.224932	0	\N
577	경상남도 거창군 거창읍 장팔길 77	2026-01-29 23:28:25.225887	35.6770135	127.9086622	OFFICIAL	2026-01-29 23:28:25.225893	0	\N
578	경상남도 거창군 거창읍 거열로4길 160	2026-01-29 23:28:25.226507	35.69545691	127.9065963	OFFICIAL	2026-01-29 23:28:25.226517	0	\N
579	경상남도 거창군 거창읍 거열로4길 144-61	2026-01-29 23:28:25.227118	35.69520126	127.9083853	OFFICIAL	2026-01-29 23:28:25.227124	0	\N
580	경상남도 거창군 거창읍 거열로4길 127	2026-01-29 23:28:25.227712	35.6940635	127.9067636	OFFICIAL	2026-01-29 23:28:25.227718	0	\N
581	경상남도 거창군 거창읍 거열로4길 120	2026-01-29 23:28:25.228331	35.69388856	127.9076975	OFFICIAL	2026-01-29 23:28:25.228336	0	\N
582	경상남도 거창군 거창읍 거열로3길5-6	2026-01-29 23:28:25.229	35.69190463	127.9162419	OFFICIAL	2026-01-29 23:28:25.229006	0	\N
583	경상남도 거창군 거창읍 거열로3길 66-4	2026-01-29 23:28:25.229608	35.69373737	127.9151432	OFFICIAL	2026-01-29 23:28:25.229614	0	\N
584	경상남도 거창군 거창읍 거열로3길 66-3	2026-01-29 23:28:25.230184	35.69371959	127.9148982	OFFICIAL	2026-01-29 23:28:25.23019	0	\N
585	경상남도 거창군 거창읍 거열로3길 26	2026-01-29 23:28:25.230783	35.69264455	127.9163833	OFFICIAL	2026-01-29 23:28:25.230789	0	\N
586	경상남도 거창군 거창읍 거열로3길 16-12	2026-01-29 23:28:25.231361	35.69244028	127.9169698	OFFICIAL	2026-01-29 23:28:25.231366	0	\N
587	경상남도 거창군 거창읍 거열로3길 10	2026-01-29 23:28:25.231942	35.69196826	127.9168207	OFFICIAL	2026-01-29 23:28:25.231947	0	\N
588	경상남도 거창군 거창읍 거열로2길 73	2026-01-29 23:28:25.232534	35.69401818	127.9138524	OFFICIAL	2026-01-29 23:28:25.23254	0	\N
589	경상남도 거창군 거창읍 거열로2길 63	2026-01-29 23:28:25.233111	35.6931808	127.9142603	OFFICIAL	2026-01-29 23:28:25.233117	0	\N
590	경상남도 거창군 거창읍 거열로2길 63	2026-01-29 23:28:25.233656	35.6931808	127.9142603	OFFICIAL	2026-01-29 23:28:25.233662	0	\N
591	경상남도 거창군 거창읍 거열로2길 24	2026-01-29 23:28:25.234291	35.69228661	127.915349	OFFICIAL	2026-01-29 23:28:25.234296	0	\N
592	경상남도 거창군 거창읍 거열로2길 24	2026-01-29 23:28:25.234917	35.69228661	127.915349	OFFICIAL	2026-01-29 23:28:25.234922	0	\N
593	경상남도 거창군 거창읍 거열로2길 24	2026-01-29 23:28:25.235501	35.69228661	127.915349	OFFICIAL	2026-01-29 23:28:25.235506	0	\N
594	경상남도 거창군 거창읍 거열로1길 92	2026-01-29 23:28:25.23609	35.69369226	127.9119192	OFFICIAL	2026-01-29 23:28:25.236095	0	\N
595	경상남도 거창군 거창읍 거열로1길 86	2026-01-29 23:28:25.236662	35.69377129	127.912361	OFFICIAL	2026-01-29 23:28:25.236667	0	\N
596	경상남도 거창군 거창읍 거열로1길 79	2026-01-29 23:28:25.237265	35.69311755	127.9127854	OFFICIAL	2026-01-29 23:28:25.23727	0	\N
597	경상남도 거창군 거창읍 거열로1길 78-7	2026-01-29 23:28:25.237866	35.6937871	127.9126648	OFFICIAL	2026-01-29 23:28:25.237871	0	\N
598	경상남도 거창군 거창읍 거열로1길 78-57	2026-01-29 23:28:25.238419	35.6947845	127.9108405	OFFICIAL	2026-01-29 23:28:25.238424	0	\N
599	경상남도 거창군 거창읍 거열로1길 78-23	2026-01-29 23:28:25.239025	35.69472709	127.9121551	OFFICIAL	2026-01-29 23:28:25.23903	0	\N
600	경상남도 거창군 거창읍 거열로1길 74	2026-01-29 23:28:25.239605	35.69379956	127.9130182	OFFICIAL	2026-01-29 23:28:25.23961	0	\N
601	경상남도 거창군 거창읍 거열로1길 100-26	2026-01-29 23:28:25.240208	35.69454347	127.9115521	OFFICIAL	2026-01-29 23:28:25.240214	0	\N
602	경상남도 거창군 거창읍 거열로1길 100-24	2026-01-29 23:28:25.240822	35.69421007	127.911771	OFFICIAL	2026-01-29 23:28:25.240828	0	\N
603	경상남도 거창군 거창읍 거열로 234-14	2026-01-29 23:28:25.241398	35.69248278	127.918772	OFFICIAL	2026-01-29 23:28:25.241403	0	\N
604	경상남도 거창군 거창읍 거열로 165-1	2026-01-29 23:28:25.242005	35.69015826	127.9117472	OFFICIAL	2026-01-29 23:28:25.242011	0	\N
605	경상남도 거창군 거창읍 거안로 1266-43	2026-01-29 23:28:25.242582	35.68415861	127.8878089	OFFICIAL	2026-01-29 23:28:25.242588	0	\N
606	경상남도 거창군 거창읍 개봉길 58	2026-01-29 23:28:25.243152	35.69343584	127.9145705	OFFICIAL	2026-01-29 23:28:25.243158	0	\N
607	경상남도 거창군 거창읍 개봉길 46	2026-01-29 23:28:25.243717	35.69330986	127.9156836	OFFICIAL	2026-01-29 23:28:25.243722	0	\N
608	경상남도 거창군 거창읍 강양5길 61-3	2026-01-29 23:28:25.244301	35.68944658	127.9184526	OFFICIAL	2026-01-29 23:28:25.244306	0	\N
609	경상남도 거창군 거창읍 강양4길 26	2026-01-29 23:28:25.244901	35.6898523	127.9187858	OFFICIAL	2026-01-29 23:28:25.244907	0	\N
610	경상남도 거창군 거창읍 강양4길 19-6	2026-01-29 23:28:25.245467	35.69032792	127.9185333	OFFICIAL	2026-01-29 23:28:25.245473	0	\N
611	경상남도 거창군 거창읍 강양4길 16	2026-01-29 23:28:25.246039	35.68991512	127.9182785	OFFICIAL	2026-01-29 23:28:25.246044	0	\N
612	경상남도 거창군 거창읍 강양4길 10	2026-01-29 23:28:25.246591	35.68991233	127.9179701	OFFICIAL	2026-01-29 23:28:25.246596	0	\N
613	경상남도 거창군 거창읍 강양2길 36	2026-01-29 23:28:25.247143	35.69173606	127.9186111	OFFICIAL	2026-01-29 23:28:25.247149	0	\N
614	경상남도 거창군 거창읍 강양1길 31	2026-01-29 23:28:25.247727	35.69060972	127.9187602	OFFICIAL	2026-01-29 23:28:25.247732	0	\N
615	경상남도 거창군 거창읍 강양1길 27	2026-01-29 23:28:25.248416	35.69039867	127.9188171	OFFICIAL	2026-01-29 23:28:25.248421	0	\N
616	경상남도 거창군 거창읍 강변로9길 51	2026-01-29 23:28:25.249034	35.68898986	127.9175035	OFFICIAL	2026-01-29 23:28:25.24904	0	\N
617	경상남도 거창군 거창읍 강변로7길 13	2026-01-29 23:28:25.2496	35.68478296	127.9081355	OFFICIAL	2026-01-29 23:28:25.249606	0	\N
618	경상남도 거창군 거창읍 강변로2길 12	2026-01-29 23:28:25.250182	35.68396949	127.9005546	OFFICIAL	2026-01-29 23:28:25.250188	0	\N
619	경상남도 거창군 거창읍 강변로157	2026-01-29 23:28:25.250787	35.685603	127.9142081	OFFICIAL	2026-01-29 23:28:25.250793	0	\N
620	경상남도 거창군 거창읍 강변로 35-1	2026-01-29 23:28:25.251385	35.68365935	127.901015	OFFICIAL	2026-01-29 23:28:25.251391	0	\N
621	경상남도 거창군 거창읍 강변로 279	2026-01-29 23:28:25.252082	35.69045411	127.9257556	OFFICIAL	2026-01-29 23:28:25.252088	0	\N
622	경상남도 거창군 거창읍 강변로 19	2026-01-29 23:28:25.252681	35.68352625	127.8993494	OFFICIAL	2026-01-29 23:28:25.252687	0	\N
623	경상남도 거창군 거창읍 강변로 127	2026-01-29 23:28:25.253267	35.68463392	127.9109002	OFFICIAL	2026-01-29 23:28:25.253273	0	\N
624	경상남도 거창군 거창읍 강변로 127	2026-01-29 23:28:25.253869	35.68463392	127.9109002	OFFICIAL	2026-01-29 23:28:25.253875	0	\N
625	경상남도 거창군 거창읍 강남로3길 34	2026-01-29 23:28:25.254409	35.68197849	127.9086104	OFFICIAL	2026-01-29 23:28:25.254414	0	\N
626	경상남도 거창군 거창읍 강남로2길 33-10	2026-01-29 23:28:25.254971	35.6815093	127.9073277	OFFICIAL	2026-01-29 23:28:25.254976	0	\N
627	경상남도 거창군 거창읍 강남로1길 96	2026-01-29 23:28:25.255624	35.68218367	127.9060204	OFFICIAL	2026-01-29 23:28:25.25564	0	\N
628	경상남도 거창군 거창읍 강남로1길 78-10	2026-01-29 23:28:25.256258	35.68159846	127.9048888	OFFICIAL	2026-01-29 23:28:25.256265	0	\N
629	경상남도 거창군 거창읍 강남로1길 67	2026-01-29 23:28:25.256875	35.68213099	127.9043715	OFFICIAL	2026-01-29 23:28:25.256881	0	\N
630	경상남도 거창군 거창읍 강남로1길 53	2026-01-29 23:28:25.25744	35.68237243	127.9036639	OFFICIAL	2026-01-29 23:28:25.257445	0	\N
631	경상남도 거창군 거창읍 강남로1길 49	2026-01-29 23:28:25.258051	35.68239329	127.9035025	OFFICIAL	2026-01-29 23:28:25.258057	0	\N
632	경상남도 거창군 거창읍 강남로1길 41	2026-01-29 23:28:25.258642	35.68230203	127.9029701	OFFICIAL	2026-01-29 23:28:25.25865	0	\N
633	경상남도 거창군 거창읍 강남로1길 158	2026-01-29 23:28:25.259214	35.68259082	127.9092754	OFFICIAL	2026-01-29 23:28:25.259221	0	\N
634	경상남도 거창군 거창읍 강남로 80	2026-01-29 23:28:25.25983	35.68263539	127.906341	OFFICIAL	2026-01-29 23:28:25.259842	0	\N
635	경상남도 거창군 거창읍 강남로 64	2026-01-29 23:28:25.260366	35.68230705	127.9047019	OFFICIAL	2026-01-29 23:28:25.260372	0	\N
636	경상남도 거창군 거창읍 강남로 254-14	2026-01-29 23:28:25.260941	35.68656767	127.9240321	OFFICIAL	2026-01-29 23:28:25.260947	0	\N
637	경상남도 거창군 거창읍 가지리 799-4	2026-01-29 23:28:25.261477	35.71470488	127.8996589	OFFICIAL	2026-01-29 23:28:25.261483	0	\N
638	경상남도 거창군 거창읍 가지리 210	2026-01-29 23:28:25.262059	35.69546019	127.9071036	OFFICIAL	2026-01-29 23:28:25.262065	0	\N
639	경상남도 거창군 가조면 지산로 1386	2026-01-29 23:28:25.262855	35.70165276	128.0193527	OFFICIAL	2026-01-29 23:28:25.262863	0	\N
640	경상남도 거창군 가조면 의상봉길 149	2026-01-29 23:28:25.263641	35.71221677	128.0214844	OFFICIAL	2026-01-29 23:28:25.263647	0	\N
641	경상남도 거창군 가조면 수월리 산19	2026-01-29 23:28:25.26435	35.73662049	128.0408983	OFFICIAL	2026-01-29 23:28:25.264356	0	\N
642	경상남도 거창군 가조면 마상3길 49	2026-01-29 23:28:25.265055	35.71215841	128.0169467	OFFICIAL	2026-01-29 23:28:25.26507	0	\N
643	경상남도 거창군 가조면 마상3길 33-20	2026-01-29 23:28:25.265666	35.71373734	128.0157437	OFFICIAL	2026-01-29 23:28:25.265671	0	\N
644	경상남도 거창군 가조면 도리1길 27	2026-01-29 23:28:25.266466	35.70487646	128.0464976	OFFICIAL	2026-01-29 23:28:25.266471	0	\N
645	경상남도 거창군 주상면 성기리 1378-25	2026-01-29 23:28:25.267105	35.76616711	127.918779	OFFICIAL	2026-01-29 23:28:25.26711	0	\N
646	경상남도 거창군 북상면 월성리 1084-4	2026-01-29 23:28:25.267694	35.76476964	127.7432473	OFFICIAL	2026-01-29 23:28:25.267699	0	\N
647	경상남도 거창군 거창읍 절부길 24-6	2026-01-29 23:28:25.26835	35.68171104	127.8959543	OFFICIAL	2026-01-29 23:28:25.268355	0	\N
648	경상남도 거창군 거창읍 성산길 36	2026-01-29 23:28:25.268942	35.69308263	127.9029092	OFFICIAL	2026-01-29 23:28:25.268947	0	\N
649	경상남도 거창군 거창읍 거열로7길 102	2026-01-29 23:28:25.269521	35.69233266	127.9007139	OFFICIAL	2026-01-29 23:28:25.269526	0	\N
650	경상남도 거창군 거창읍 거열로4길 111	2026-01-29 23:28:25.270055	35.69367675	127.9066828	OFFICIAL	2026-01-29 23:28:25.27006	0	\N
651	경상남도 거창군 거창읍 거열로2길 34-14	2026-01-29 23:28:25.270642	35.69268522	127.9154682	OFFICIAL	2026-01-29 23:28:25.270647	0	\N
652	경상남도 거창군 거창읍 거열로1길 92	2026-01-29 23:28:25.271285	35.69369226	127.9119192	OFFICIAL	2026-01-29 23:28:25.27129	0	\N
653	경상남도 거창군 거창읍 거열로1길 89	2026-01-29 23:28:25.27191	35.69327879	127.9123448	OFFICIAL	2026-01-29 23:28:25.271915	0	\N
654	경상남도 거창군 거창읍 거열로1길 81	2026-01-29 23:28:25.272455	35.69337995	127.9127202	OFFICIAL	2026-01-29 23:28:25.27246	0	\N
655	경상남도 거창군 거창읍 거열로1길 75	2026-01-29 23:28:25.273038	35.69343653	127.9131739	OFFICIAL	2026-01-29 23:28:25.273043	0	\N
656	경상남도 거창군 거창읍 개화2길 26-3	2026-01-29 23:28:25.273607	35.69941373	127.9052914	OFFICIAL	2026-01-29 23:28:25.273612	0	\N
657	부산광역시 연제구 좌수영로 225 부산광역시 연제구 연산동 2317	2026-01-29 23:28:25.274167	35.183774	129.1137205	OFFICIAL	2026-01-29 23:28:25.274172	0	\N
658	부산광역시 연제구 좌수영로 225 부산광역시 연제구 연산동 2317	2026-01-29 23:28:25.274737	35.183774	129.1137205	OFFICIAL	2026-01-29 23:28:25.274742	0	\N
659	부산광역시 연제구 과정로225번길 46 부산광역시 연제구 연산동 378-11	2026-01-29 23:28:25.275346	35.18621999	129.1004919	OFFICIAL	2026-01-29 23:28:25.27535	0	\N
660	부산광역시 연제구 과정로225번길 46 부산광역시 연제구 연산동 378-11	2026-01-29 23:28:25.275933	35.18621999	129.1004919	OFFICIAL	2026-01-29 23:28:25.275938	0	\N
661	부산광역시 연제구 고분로 12 부산광역시 연제구 연산동 731-2	2026-01-29 23:28:25.276468	35.1856702	129.0835701	OFFICIAL	2026-01-29 23:28:25.276473	0	\N
662	부산광역시 연제구 고분로 12 부산광역시 연제구 연산동 731-2	2026-01-29 23:28:25.277049	35.1856702	129.0835701	OFFICIAL	2026-01-29 23:28:25.277053	0	\N
663	부산광역시 연제구 월드컵대로 54 부산광역시 연제구 연산동 686-4	2026-01-29 23:28:25.277586	35.1793063	129.0848871	OFFICIAL	2026-01-29 23:28:25.277593	0	\N
664	부산광역시 연제구 월드컵대로 54 부산광역시 연제구 연산동 686-4	2026-01-29 23:28:25.278173	35.1793063	129.0848871	OFFICIAL	2026-01-29 23:28:25.278178	0	\N
665	부산광역시 연제구 연수로 96-1 부산광역시 연제구 연산동 844-56	2026-01-29 23:28:25.278793	35.17514394	129.0813938	OFFICIAL	2026-01-29 23:28:25.2788	0	\N
666	부산광역시 연제구 연수로 96-1 부산광역시 연제구 연산동 844-56	2026-01-29 23:28:25.279369	35.17514394	129.0813938	OFFICIAL	2026-01-29 23:28:25.279373	0	\N
667	부산광역시 연제구 연수로 177 부산광역시 연제구 연산동 1867-1	2026-01-29 23:28:25.279933	35.1743178	129.0901318	OFFICIAL	2026-01-29 23:28:25.279937	0	\N
668	부산광역시 연제구 연수로 177 부산광역시 연제구 연산동 1867-1	2026-01-29 23:28:25.28053	35.1743178	129.0901318	OFFICIAL	2026-01-29 23:28:25.280534	0	\N
669	부산광역시 연제구 과정로 139-1 부산광역시 연제구 연산동 479-5	2026-01-29 23:28:25.281099	35.18391929	129.1069265	OFFICIAL	2026-01-29 23:28:25.281104	0	\N
670	부산광역시 연제구 과정로 139-1 부산광역시 연제구 연산동 479-5	2026-01-29 23:28:25.281653	35.18391929	129.1069265	OFFICIAL	2026-01-29 23:28:25.281658	0	\N
671	부산광역시 연제구 과정로 171 부산광역시 연제구 연산동 418-20	2026-01-29 23:28:25.282288	35.18669688	129.1069954	OFFICIAL	2026-01-29 23:28:25.282293	0	\N
672	부산광역시 연제구 과정로 171 부산광역시 연제구 연산동 418-20	2026-01-29 23:28:25.282907	35.18669688	129.1069954	OFFICIAL	2026-01-29 23:28:25.282912	0	\N
673	부산광역시 연제구 과정로 232-1 부산광역시 연제구 연산동 399-11	2026-01-29 23:28:25.283537	35.1878504	129.1018541	OFFICIAL	2026-01-29 23:28:25.283542	0	\N
674	부산광역시 연제구 과정로 232-1 부산광역시 연제구 연산동 399-11	2026-01-29 23:28:25.284132	35.1878504	129.1018541	OFFICIAL	2026-01-29 23:28:25.284136	0	\N
675	부산광역시 연제구 법원로 15 부산광역시 연제구 거제동 1501	2026-01-29 23:28:25.284705	35.19140319	129.0719757	OFFICIAL	2026-01-29 23:28:25.28471	0	\N
676	부산광역시 연제구 법원로 15 부산광역시 연제구 거제동 1501	2026-01-29 23:28:25.285319	35.19140319	129.0719757	OFFICIAL	2026-01-29 23:28:25.285324	0	\N
677	부산광역시 연제구 법원북로 34 부산광역시 연제구 거제동 1481	2026-01-29 23:28:25.285981	35.19242972	129.0711214	OFFICIAL	2026-01-29 23:28:25.285987	0	\N
678	부산광역시 연제구 법원북로 34 부산광역시 연제구 거제동 1481	2026-01-29 23:28:25.286531	35.19242972	129.0711214	OFFICIAL	2026-01-29 23:28:25.286536	0	\N
679	부산광역시 연제구 종합운동장로 28 부산광역시 연제구 거제동 897-24	2026-01-29 23:28:25.287066	35.1930722	129.0647759	OFFICIAL	2026-01-29 23:28:25.287071	0	\N
680	부산광역시 연제구 종합운동장로 28 부산광역시 연제구 거제동 897-24	2026-01-29 23:28:25.287652	35.1930722	129.0647759	OFFICIAL	2026-01-29 23:28:25.287658	0	\N
681	부산광역시 연제구 월드컵대로 242 부산광역시 연제구 거제동 1044-29	2026-01-29 23:28:25.288204	35.1902413	129.070924	OFFICIAL	2026-01-29 23:28:25.288209	0	\N
682	부산광역시 연제구 월드컵대로 242 부산광역시 연제구 거제동 1044-29	2026-01-29 23:28:25.288735	35.1902413	129.070924	OFFICIAL	2026-01-29 23:28:25.28874	0	\N
683	부산광역시 연제구 거제대로 123 부산광역시 연제구 거제동 676-1	2026-01-29 23:28:25.289522	35.18117042	129.0689964	OFFICIAL	2026-01-29 23:28:25.289527	0	\N
684	부산광역시 연제구 거제대로 123 부산광역시 연제구 거제동 676-1	2026-01-29 23:28:25.290099	35.18117042	129.0689964	OFFICIAL	2026-01-29 23:28:25.290104	0	\N
685	부산광역시 연제구 과정로114번길 18-22 부산광역시 연제구 연산동117-30	2026-01-29 23:28:25.290645	35.18057556	129.1081694	OFFICIAL	2026-01-29 23:28:25.29065	0	\N
686	부산광역시 연제구 과정로114번길 18-22 부산광역시 연제구 연산동117-30	2026-01-29 23:28:25.291187	35.18057556	129.1081694	OFFICIAL	2026-01-29 23:28:25.291191	0	\N
687	부산광역시 연제구 과정로 191 부산광역시 연제구 연산동 405-10	2026-01-29 23:28:25.291773	35.18765939	129.1062969	OFFICIAL	2026-01-29 23:28:25.291777	0	\N
688	부산광역시 연제구 과정로 191 부산광역시 연제구 연산동 405-10	2026-01-29 23:28:25.292317	35.18765939	129.1062969	OFFICIAL	2026-01-29 23:28:25.292322	0	\N
689	부산광역시 연제구 과정로 286 부산광역시 연제구 연산동 367-28	2026-01-29 23:28:25.292897	35.1884096	129.0962733	OFFICIAL	2026-01-29 23:28:25.292902	0	\N
690	부산광역시 연제구 과정로 286 부산광역시 연제구 연산동 367-28	2026-01-29 23:28:25.293449	35.1884096	129.0962733	OFFICIAL	2026-01-29 23:28:25.293454	0	\N
691	부산광역시 연제구 반송로 88 부산광역시 연제구 연산동 105-1	2026-01-29 23:28:25.294022	35.19095872	129.0893311	OFFICIAL	2026-01-29 23:28:25.294027	0	\N
692	부산광역시 연제구 반송로 88 부산광역시 연제구 연산동 105-1	2026-01-29 23:28:25.294598	35.19095872	129.0893311	OFFICIAL	2026-01-29 23:28:25.294602	0	\N
693	부산광역시 연제구 반송로 46 부산광역시 연제구 연산동 590-49	2026-01-29 23:28:25.295158	35.1887023	129.0853514	OFFICIAL	2026-01-29 23:28:25.295163	0	\N
694	부산광역시 연제구 반송로 46 부산광역시 연제구 연산동 590-49	2026-01-29 23:28:25.295728	35.1887023	129.0853514	OFFICIAL	2026-01-29 23:28:25.295732	0	\N
695	부산광역시 연제구 반송로 17 부산광역시 연제구 연산동 723-29	2026-01-29 23:28:25.296311	35.18719468	129.0827007	OFFICIAL	2026-01-29 23:28:25.29632	0	\N
696	부산광역시 연제구 반송로 17 부산광역시 연제구 연산동 723-29	2026-01-29 23:28:25.296925	35.18719468	129.0827007	OFFICIAL	2026-01-29 23:28:25.29693	0	\N
697	부산광역시 연제구 연수로 224 부산광역시 연제구 연산동 1800-10	2026-01-29 23:28:25.297474	35.17336052	129.0951632	OFFICIAL	2026-01-29 23:28:25.297479	0	\N
698	부산광역시 연제구 연수로 224 부산광역시 연제구 연산동 1800-10	2026-01-29 23:28:25.298038	35.17336052	129.0951632	OFFICIAL	2026-01-29 23:28:25.298042	0	\N
699	부산광역시 연제구 연수로 109-1 부산광역시 연제구 연산동 822-39	2026-01-29 23:28:25.298611	35.17531	129.0829234	OFFICIAL	2026-01-29 23:28:25.298616	0	\N
700	부산광역시 연제구 연수로 109-1 부산광역시 연제구 연산동 822-39	2026-01-29 23:28:25.299303	35.17531	129.0829234	OFFICIAL	2026-01-29 23:28:25.29931	0	\N
701	부산광역시 연제구 종합운동장로 7 부산광역시 연제구 거제동 1208	2026-01-29 23:28:25.299951	35.19126734	129.0620086	OFFICIAL	2026-01-29 23:28:25.299956	0	\N
702	부산광역시 연제구 종합운동장로 7 부산광역시 연제구 거제동 1208	2026-01-29 23:28:25.300548	35.19126734	129.0620086	OFFICIAL	2026-01-29 23:28:25.300553	0	\N
703	부산광역시 연제구 월드컵대로 115 부산광역시 연제구 연산동 709-2	2026-01-29 23:28:25.301114	35.1845909	129.0821782	OFFICIAL	2026-01-29 23:28:25.301119	0	\N
704	부산광역시 연제구 월드컵대로 115 부산광역시 연제구 연산동 709-2	2026-01-29 23:28:25.301659	35.1845909	129.0821782	OFFICIAL	2026-01-29 23:28:25.301664	0	\N
705	부산광역시 연제구 거제대로 248 부산광역시 연제구 거제동 18-54	2026-01-29 23:28:25.30228	35.1891273	129.0752595	OFFICIAL	2026-01-29 23:28:25.302286	0	\N
706	부산광역시 연제구 거제대로 248 부산광역시 연제구 거제동 18-54	2026-01-29 23:28:25.30286	35.1891273	129.0752595	OFFICIAL	2026-01-29 23:28:25.302865	0	\N
707	부산광역시 연제구 거제대로 160 부산광역시 연제구 거제동 585-35	2026-01-29 23:28:25.303399	35.18249618	129.0704417	OFFICIAL	2026-01-29 23:28:25.303404	0	\N
708	부산광역시 연제구 거제대로 160 부산광역시 연제구 거제동 585-35	2026-01-29 23:28:25.303995	35.18249618	129.0704417	OFFICIAL	2026-01-29 23:28:25.304	0	\N
709	부산광역시 연제구 월드컵대로 149 부산광역시 연제구 연산동 1241-5	2026-01-29 23:28:25.304586	35.18641176	129.0798929	OFFICIAL	2026-01-29 23:28:25.304591	0	\N
710	부산광역시 연제구 월드컵대로 149 부산광역시 연제구 연산동 1241-5	2026-01-29 23:28:25.305143	35.18641176	129.0798929	OFFICIAL	2026-01-29 23:28:25.305147	0	\N
711	부산광역시 연제구 월드컵대로 144 부산광역시 연제구 연산동 1126-12	2026-01-29 23:28:25.305674	35.18667156	129.0806527	OFFICIAL	2026-01-29 23:28:25.305678	0	\N
712	부산광역시 연제구 월드컵대로 144 부산광역시 연제구 연산동 1126-12	2026-01-29 23:28:25.306251	35.18667156	129.0806527	OFFICIAL	2026-01-29 23:28:25.306256	0	\N
713	부산광역시 연제구 월드컵대로 2 부산광역시 연제구 연산동 1916-10	2026-01-29 23:28:25.306839	35.17504688	129.0867222	OFFICIAL	2026-01-29 23:28:25.306844	0	\N
714	부산광역시 연제구 월드컵대로 2 부산광역시 연제구 연산동 1916-10	2026-01-29 23:28:25.307409	35.17504688	129.0867222	OFFICIAL	2026-01-29 23:28:25.307414	0	\N
715	부산광역시 연제구 법원남로9번길 17 부산광역시 연제구 거제동 419-2	2026-01-29 23:28:25.307994	35.18951105	129.0742898	OFFICIAL	2026-01-29 23:28:25.307999	0	\N
716	부산광역시 연제구 법원남로9번길 17 부산광역시 연제구 거제동 419-2	2026-01-29 23:28:25.30852	35.18951105	129.0742898	OFFICIAL	2026-01-29 23:28:25.308525	0	\N
717	부산광역시 연제구 연제로 21 부산광역시 연제구 연산동 862	2026-01-29 23:28:25.309124	35.17684154	129.0770534	OFFICIAL	2026-01-29 23:28:25.309129	0	\N
718	부산광역시 연제구 연수로 184 부산광역시 연제구 연산동 1873-70	2026-01-29 23:28:25.309679	35.17364431	129.0909816	OFFICIAL	2026-01-29 23:28:25.309684	0	\N
719	부산광역시 연제구 연수로 184 부산광역시 연제구 연산동 1873-70	2026-01-29 23:28:25.310273	35.17364431	129.0909816	OFFICIAL	2026-01-29 23:28:25.310278	0	\N
720	부산광역시 연제구 과정로 152 부산광역시 연제구 연산동 478-8	2026-01-29 23:28:25.310868	35.1850904	129.1074467	OFFICIAL	2026-01-29 23:28:25.310873	0	\N
721	부산광역시 연제구 과정로 152 부산광역시 연제구 연산동 478-8	2026-01-29 23:28:25.311436	35.1850904	129.1074467	OFFICIAL	2026-01-29 23:28:25.311441	0	\N
722	부산광역시 연제구 과정로 265 부산광역시 연제구 연산동 380-1	2026-01-29 23:28:25.312039	35.1877514	129.0981464	OFFICIAL	2026-01-29 23:28:25.312044	0	\N
723	부산광역시 연제구 과정로 265 부산광역시 연제구 연산동 380-1	2026-01-29 23:28:25.312602	35.1877514	129.0981464	OFFICIAL	2026-01-29 23:28:25.312607	0	\N
724	부산광역시 연제구 거제대로214번길 6 부산광역시 연제구 거제동 38-45	2026-01-29 23:28:25.313171	35.18679429	129.0743716	OFFICIAL	2026-01-29 23:28:25.313176	0	\N
725	부산광역시 연제구 거제대로214번길 6 부산광역시 연제구 거제동 38-45	2026-01-29 23:28:25.313712	35.18679429	129.0743716	OFFICIAL	2026-01-29 23:28:25.313717	0	\N
726	부산광역시 연제구 법원북로 16 부산광역시 연제구 거제동 1479	2026-01-29 23:28:25.314261	35.19254721	129.0681338	OFFICIAL	2026-01-29 23:28:25.314266	0	\N
727	부산광역시 연제구 법원북로 16 부산광역시 연제구 거제동 1479	2026-01-29 23:28:25.31485	35.19254721	129.0681338	OFFICIAL	2026-01-29 23:28:25.314855	0	\N
728	부산광역시 연제구 아시아드대로 12 부산광역시 연제구 거제동 878-7	2026-01-29 23:28:25.315381	35.18661543	129.0703432	OFFICIAL	2026-01-29 23:28:25.315385	0	\N
729	부산광역시 연제구 아시아드대로 12 부산광역시 연제구 거제동 878-7	2026-01-29 23:28:25.315951	35.18661543	129.0703432	OFFICIAL	2026-01-29 23:28:25.315956	0	\N
730	부산광역시 연제구 과정로 221 부산광역시 연제구 연산동 406-34	2026-01-29 23:28:25.3166	35.18753326	129.1030778	OFFICIAL	2026-01-29 23:28:25.316606	0	\N
731	부산광역시 연제구 과정로 221 부산광역시 연제구 연산동 406-34	2026-01-29 23:28:25.317171	35.18753326	129.1030778	OFFICIAL	2026-01-29 23:28:25.317177	0	\N
732	부산광역시 연제구 과정로 340 부산광역시 연제구 연산동 307-40	2026-01-29 23:28:25.317697	35.1905374	129.0909692	OFFICIAL	2026-01-29 23:28:25.317702	0	\N
733	부산광역시 연제구 과정로 340 부산광역시 연제구 연산동 307-40	2026-01-29 23:28:25.318284	35.1905374	129.0909692	OFFICIAL	2026-01-29 23:28:25.318289	0	\N
734	부산광역시 연제구 고분로 170 부산광역시 연제구 연산동 277-4	2026-01-29 23:28:25.318869	35.18542933	129.1009589	OFFICIAL	2026-01-29 23:28:25.318873	0	\N
735	부산광역시 연제구 고분로 170 부산광역시 연제구 연산동 277-4	2026-01-29 23:28:25.319435	35.18542933	129.1009589	OFFICIAL	2026-01-29 23:28:25.31944	0	\N
736	부산광역시 연제구 반송로 89 부산광역시 연제구 연산동 582-1	2026-01-29 23:28:25.320003	35.19153806	129.0882804	OFFICIAL	2026-01-29 23:28:25.320007	0	\N
737	부산광역시 연제구 반송로 89 부산광역시 연제구 연산동 582-1	2026-01-29 23:28:25.320941	35.19153806	129.0882804	OFFICIAL	2026-01-29 23:28:25.320948	0	\N
738	부산광역시 연제구 반송로 14 부산광역시 연제구 연산동 728-2	2026-01-29 23:28:25.321557	35.18678236	129.0828604	OFFICIAL	2026-01-29 23:28:25.321562	0	\N
739	부산광역시 연제구 반송로 14 부산광역시 연제구 연산동 728-2	2026-01-29 23:28:25.322139	35.18678236	129.0828604	OFFICIAL	2026-01-29 23:28:25.322143	0	\N
740	부산광역시 연제구 연수로 225 부산광역시 연제구 연산동 2121-16	2026-01-29 23:28:25.322696	35.1736676	129.0954932	OFFICIAL	2026-01-29 23:28:25.322701	0	\N
741	부산광역시 연제구 연수로 225 부산광역시 연제구 연산동 2121-16	2026-01-29 23:28:25.323311	35.1736676	129.0954932	OFFICIAL	2026-01-29 23:28:25.323316	0	\N
742	부산광역시 연제구 거제대로 123 부산광역시 연제구 거제동 676-1	2026-01-29 23:28:25.32387	35.18117042	129.0689964	OFFICIAL	2026-01-29 23:28:25.323875	0	\N
743	부산광역시 연제구 거제대로 123 부산광역시 연제구 거제동 676-1	2026-01-29 23:28:25.324397	35.18117042	129.0689964	OFFICIAL	2026-01-29 23:28:25.324402	0	\N
744	서울특별시 중랑구 겸재로253-1 서울특별시 중랑구 망우동 526-32	2026-01-29 23:28:25.32494	37.59052839	127.095694	OFFICIAL	2026-01-29 23:28:25.324945	0	\N
745	서울특별시 중랑구 봉우재로70길 96 서울특별시 중랑구 망우동 530-3	2026-01-29 23:28:25.32552	37.59139552	127.0967468	OFFICIAL	2026-01-29 23:28:25.325524	0	\N
746	서울특별시 중랑구 겸재로 261 서울특별시 중랑구 망우동 526-2	2026-01-29 23:28:25.326082	37.59075471	127.0966074	OFFICIAL	2026-01-29 23:28:25.326089	0	\N
747	서울특별시 중랑구 봉우재로 240 서울특별시 중랑구 망우동 458-3	2026-01-29 23:28:25.326647	37.59530807	127.0993721	OFFICIAL	2026-01-29 23:28:25.326651	0	\N
748	서울특별시 중랑구 봉우재로 234 서울특별시 중랑구 망우동 460-1	2026-01-29 23:28:25.327202	37.59516913	127.0988755	OFFICIAL	2026-01-29 23:28:25.327207	0	\N
749	서울특별시 중랑구 용마산로96길 33 서울특별시 중랑구 망우동 437-18	2026-01-29 23:28:25.327785	37.59005416	127.0992655	OFFICIAL	2026-01-29 23:28:25.327792	0	\N
750	서울특별시 중랑구 용마산로 488 서울특별시 중랑구 망우동 410-8	2026-01-29 23:28:25.32831	37.59448255	127.0998237	OFFICIAL	2026-01-29 23:28:25.328315	0	\N
751	서울특별시 중랑구 용마산로 441 서울특별시 중랑구 망우동 531-4	2026-01-29 23:28:25.328885	37.59084116	127.0973084	OFFICIAL	2026-01-29 23:28:25.328889	0	\N
752	서울특별시 중랑구 상봉로 78 서울특별시 중랑구 망우동 479-77	2026-01-29 23:28:25.329514	37.5928309	127.0935702	OFFICIAL	2026-01-29 23:28:25.329519	0	\N
753	서울특별시 중랑구 상봉로 76 서울특별시 중랑구 망우동 477-56	2026-01-29 23:28:25.330045	37.59260575	127.0935843	OFFICIAL	2026-01-29 23:28:25.33005	0	\N
754	서울특별시 중랑구 상봉로 76 서울특별시 중랑구 망우동 477-56	2026-01-29 23:28:25.330594	37.59260575	127.0935843	OFFICIAL	2026-01-29 23:28:25.330598	0	\N
755	서울특별시 중랑구 용마산로 494 서울특별시 중랑구 망우동 410-1	2026-01-29 23:28:25.331123	37.59497252	127.1002707	OFFICIAL	2026-01-29 23:28:25.331128	0	\N
756	서울특별시 중랑구 용마산로 480 서울특별시 중랑구 망우동 411-3	2026-01-29 23:28:25.331713	37.59374966	127.0994248	OFFICIAL	2026-01-29 23:28:25.331717	0	\N
757	서울특별시 중랑구 용마산로 448 서울특별시 중랑구 망우동 442-21	2026-01-29 23:28:25.332329	37.59115319	127.098052	OFFICIAL	2026-01-29 23:28:25.332335	0	\N
758	서울특별시 중랑구 용마공원로2길 7 서울특별시 중랑구 망우동 409-23	2026-01-29 23:28:25.332909	37.59450582	127.1005141	OFFICIAL	2026-01-29 23:28:25.332914	0	\N
759	서울특별시 중랑구 용마공원로 455	2026-01-29 23:28:25.333472	37.59274083	127.1018376	OFFICIAL	2026-01-29 23:28:25.333477	0	\N
760	서울특별시 중랑구 용마산로99길 9 서울특별시 중랑구 망우동 531-24	2026-01-29 23:28:25.334068	37.59187831	127.0974317	OFFICIAL	2026-01-29 23:28:25.334073	0	\N
761	서울특별시 중랑구 망우로 530-2	2026-01-29 23:28:25.334636	37.59733286	127.0907978	OFFICIAL	2026-01-29 23:28:25.33464	0	\N
762	서울특별시 중랑구 겸재로 263 서울특별시 중랑구 망우동 531-35	2026-01-29 23:28:25.335262	37.59066591	127.0967783	OFFICIAL	2026-01-29 23:28:25.335267	0	\N
763	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.335848	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.335853	0	\N
764	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.33642	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.336424	0	\N
765	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.336973	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.336977	0	\N
766	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.33751	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.337515	0	\N
767	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.338065	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.33807	0	\N
768	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.338983	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.338991	0	\N
769	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.340009	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.340014	0	\N
770	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.34084	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.340846	0	\N
771	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.341429	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.341435	0	\N
772	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.342035	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.342041	0	\N
773	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.342561	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.342566	0	\N
774	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.34309	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.343095	0	\N
775	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.34381	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.343818	0	\N
776	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.344356	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.344361	0	\N
777	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.344934	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.344939	0	\N
778	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.345506	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.345512	0	\N
779	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.346094	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.346099	0	\N
780	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.346883	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.346888	0	\N
781	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.347415	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.34742	0	\N
782	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.347965	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.34797	0	\N
783	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.348667	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.348674	0	\N
784	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.349308	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.349314	0	\N
785	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.349913	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.349918	0	\N
786	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.350497	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.350502	0	\N
787	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.351063	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.351068	0	\N
788	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.351636	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.351641	0	\N
789	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.352197	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.352202	0	\N
790	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.352897	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.352905	0	\N
791	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.353555	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.353561	0	\N
792	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.354164	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.35417	0	\N
793	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.354737	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.354742	0	\N
794	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.355321	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.355326	0	\N
795	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.355892	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.355897	0	\N
796	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.356431	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.356436	0	\N
797	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.356994	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.356999	0	\N
798	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.357563	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.357568	0	\N
799	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.358102	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.358107	0	\N
800	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.358687	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.358691	0	\N
801	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.359277	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.359282	0	\N
802	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.359886	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.359891	0	\N
803	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.360394	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.360399	0	\N
804	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.360911	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.360916	0	\N
805	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.361402	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.361407	0	\N
806	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.362011	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.362016	0	\N
807	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.362564	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.362569	0	\N
808	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.363101	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.363106	0	\N
809	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.363643	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.363648	0	\N
810	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.36423	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.364234	0	\N
811	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.364808	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.364813	0	\N
812	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.365322	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.365327	0	\N
813	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.365878	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.365883	0	\N
814	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.366375	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.36638	0	\N
815	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.36692	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.366925	0	\N
816	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.367453	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.367457	0	\N
817	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.368078	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.368083	0	\N
818	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.368628	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.368633	0	\N
819	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.369128	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.369133	0	\N
820	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.369676	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.369681	0	\N
821	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.37023	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.370235	0	\N
822	서울특별시 중랑구 동일로163길	2026-01-29 23:28:25.370844	37.6118209	127.0756028	OFFICIAL	2026-01-29 23:28:25.370849	0	\N
823	서울특별시 중랑구 상봉동	2026-01-29 23:28:25.371401	37.59412924	127.0843255	OFFICIAL	2026-01-29 23:28:25.371405	0	\N
824	서울특별시 중랑구 상봉동	2026-01-29 23:28:25.371971	37.59412924	127.0843255	OFFICIAL	2026-01-29 23:28:25.371976	0	\N
825	서울특별시 중랑구 상봉동	2026-01-29 23:28:25.372509	37.59412924	127.0843255	OFFICIAL	2026-01-29 23:28:25.372513	0	\N
826	서울특별시 중랑구 상봉동	2026-01-29 23:28:25.373044	37.59412924	127.0843255	OFFICIAL	2026-01-29 23:28:25.373049	0	\N
827	서울특별시 중랑구 상봉동	2026-01-29 23:28:25.373586	37.59412924	127.0843255	OFFICIAL	2026-01-29 23:28:25.373591	0	\N
828	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.374136	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.374141	0	\N
829	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.374636	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.37464	0	\N
830	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.375193	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.375198	0	\N
831	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.375796	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.375807	0	\N
832	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.376334	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.376338	0	\N
833	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.37691	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.376914	0	\N
834	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.377462	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.377467	0	\N
835	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.378014	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.378019	0	\N
836	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.37855	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.378554	0	\N
837	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.379086	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.37909	0	\N
838	서울특별시 중랑구 겸재로	2026-01-29 23:28:25.379599	37.58822911	127.0868774	OFFICIAL	2026-01-29 23:28:25.379604	0	\N
839	서울특별시 중랑구 상봉로 134 서울특별시 중랑구 망우동 564-5	2026-01-29 23:28:25.380278	37.59806114	127.0932713	OFFICIAL	2026-01-29 23:28:25.380284	0	\N
840	서울특별시 중랑구 상봉로 134 서울특별시 중랑구 망우동 564-5	2026-01-29 23:28:25.380881	37.59806114	127.0932713	OFFICIAL	2026-01-29 23:28:25.380885	0	\N
841	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.381431	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.381436	0	\N
842	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.383083	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.383088	0	\N
843	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.383639	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.383644	0	\N
844	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.384201	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.384206	0	\N
845	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.384741	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.384746	0	\N
846	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.385307	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.385311	0	\N
847	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.385879	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.385883	0	\N
848	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.386417	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.386422	0	\N
849	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.386989	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.386994	0	\N
850	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.387531	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.387535	0	\N
851	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.388078	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.388083	0	\N
852	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.388607	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.388611	0	\N
853	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.389257	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.389263	0	\N
854	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.389859	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.389865	0	\N
855	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.390444	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.390449	0	\N
856	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.391046	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.391051	0	\N
857	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.391672	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.391679	0	\N
858	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.392301	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.392306	0	\N
859	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.392923	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.392929	0	\N
860	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.393479	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.393484	0	\N
861	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.394074	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.394079	0	\N
862	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.394656	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.394661	0	\N
863	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.395268	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.395272	0	\N
864	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.39582	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.395825	0	\N
865	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.398012	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.398019	0	\N
866	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.398612	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.398618	0	\N
867	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.3992	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.399206	0	\N
868	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.399884	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.399889	0	\N
869	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.400417	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.400422	0	\N
870	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.401062	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.401067	0	\N
871	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.401636	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.401641	0	\N
872	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.402194	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.4022	0	\N
873	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.40278	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.402785	0	\N
874	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.4033	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.403305	0	\N
875	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.403874	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.403879	0	\N
876	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.404403	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.404407	0	\N
877	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.404966	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.404971	0	\N
878	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.405487	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.405492	0	\N
879	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.406038	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.406043	0	\N
880	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.406614	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.406619	0	\N
881	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.407169	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.407174	0	\N
882	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.407719	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.407724	0	\N
883	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.408269	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.408274	0	\N
884	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.408845	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.40885	0	\N
885	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.409367	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.409371	0	\N
886	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.410042	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.410047	0	\N
887	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.410609	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.410615	0	\N
888	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.411247	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.411253	0	\N
889	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.411853	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.411858	0	\N
890	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.412373	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.412378	0	\N
891	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.413004	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.413009	0	\N
892	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.413651	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.413656	0	\N
893	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.414217	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.414224	0	\N
894	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.414785	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.41479	0	\N
895	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.415304	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.415309	0	\N
896	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.416006	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.416011	0	\N
897	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.418409	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.418414	0	\N
898	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.419014	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.41902	0	\N
899	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.419553	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.419558	0	\N
900	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.42009	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.420096	0	\N
901	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.420585	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.42059	0	\N
902	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.421108	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.421113	0	\N
903	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.421606	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.421611	0	\N
904	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.422202	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.422207	0	\N
905	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.422708	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.422714	0	\N
906	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.423298	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.423303	0	\N
907	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.423804	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.42381	0	\N
908	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.424305	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.424311	0	\N
909	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.424842	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.424847	0	\N
910	서울특별시 중랑구 봉우재로33길, 봉우재로43길, 망우로50길	2026-01-29 23:28:25.42534	37.59463947	127.0885545	OFFICIAL	2026-01-29 23:28:25.425345	0	\N
911	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.425903	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.425909	0	\N
912	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.42643	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.426435	0	\N
913	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.426976	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.426981	0	\N
914	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.427543	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.427549	0	\N
915	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.428101	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.428106	0	\N
916	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.428619	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.428624	0	\N
917	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.429163	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.429177	0	\N
918	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.429657	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.429663	0	\N
919	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.430189	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.430195	0	\N
920	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.430712	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.430717	0	\N
921	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.431244	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.431249	0	\N
922	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.431776	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.431781	0	\N
923	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.432265	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.43227	0	\N
924	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.432742	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.432771	0	\N
925	서울특별시 중랑구 사가정로51길	2026-01-29 23:28:25.433255	37.58234425	127.0879116	OFFICIAL	2026-01-29 23:28:25.433261	0	\N
926	서울특별시 중랑구 사가정로49길 56 서울특별시 중랑구 면목동 570	2026-01-29 23:28:25.433729	37.58350833	127.086969	OFFICIAL	2026-01-29 23:28:25.433735	0	\N
927	서울특별시 중랑구 사가정로49길 56 서울특별시 중랑구 면목동 570	2026-01-29 23:28:25.434256	37.58350833	127.086969	OFFICIAL	2026-01-29 23:28:25.434261	0	\N
928	서울특별시 중랑구 면목동 396-1	2026-01-29 23:28:25.434795	37.5909884	127.0755544	OFFICIAL	2026-01-29 23:28:25.4348	0	\N
929	서울특별시 중랑구 겸재로 120-1 서울특별시 중랑구 면목동 150-16	2026-01-29 23:28:25.435276	37.58672569	127.0812344	OFFICIAL	2026-01-29 23:28:25.435281	0	\N
930	부산광역시 사상구 모라로192번길 21 부산광역시 사상구 모라동 75-9	2026-01-29 23:28:25.435866	35.1848992	129.0009312	OFFICIAL	2026-01-29 23:28:25.435871	0	\N
931	부산광역시 사상구 학감대로 242 부산광역시 사상구 감전동138-8	2026-01-29 23:28:25.4364	35.15255072	128.9914561	OFFICIAL	2026-01-29 23:28:25.436405	0	\N
932	서울특별시 성북구 하월곡동22-13	2026-01-29 23:28:25.436962	37.60416814	127.042325	OFFICIAL	2026-01-29 23:28:25.436966	0	\N
933	서울특별시 성북구 동소문로 305-1 서울특별시 성북구 길음동 510-173	2026-01-29 23:28:25.437535	37.607487	127.0283683	OFFICIAL	2026-01-29 23:28:25.437541	0	\N
934	서울특별시 성북구 길음로 74 서울특별시 성북구 길음동 1282	2026-01-29 23:28:25.438153	37.60928966	127.0210339	OFFICIAL	2026-01-29 23:28:25.438158	0	\N
935	서울특별시 성북구 보문로 39길 4 서울특별시 성북구 동소문동3가 82	2026-01-29 23:28:25.438725	37.59143108	127.0132624	OFFICIAL	2026-01-29 23:28:25.43873	0	\N
936	서울특별시 성북구 보문로 192 서울특별시 성북구 삼선동4가 349-1	2026-01-29 23:28:25.43931	37.59086591	127.0146551	OFFICIAL	2026-01-29 23:28:25.439315	0	\N
937	서울특별시 성북구 보문로 190 서울특별시 성북구 삼선동4가 349-1	2026-01-29 23:28:25.439947	37.59086591	127.0146551	OFFICIAL	2026-01-29 23:28:25.439952	0	\N
938	서울특별시 성북구 보문로 78 서울특별시 성북구 보문동4가 77-2	2026-01-29 23:28:25.440524	37.58228095	127.0213065	OFFICIAL	2026-01-29 23:28:25.440529	0	\N
939	충청남도 홍성군 홍성읍 오관리 556-2	2026-01-29 23:28:25.441059	36.59437926	126.6663975	OFFICIAL	2026-01-29 23:28:25.441064	0	\N
940	충청남도 홍성군 홍성읍 오관리 877	2026-01-29 23:28:25.443266	36.60330902	126.6594567	OFFICIAL	2026-01-29 23:28:25.443271	0	\N
941	충청남도 홍성군 홍성읍 내법리430-1	2026-01-29 23:28:25.443855	36.61701642	126.6697058	OFFICIAL	2026-01-29 23:28:25.44386	0	\N
942	충청남도 홍성군 홍성읍 고암리907-3	2026-01-29 23:28:25.444418	36.59868139	126.6715522	OFFICIAL	2026-01-29 23:28:25.444423	0	\N
943	충청남도 홍성군 홍성읍 옥암리899-18	2026-01-29 23:28:25.445047	36.59612806	126.6577392	OFFICIAL	2026-01-29 23:28:25.445053	0	\N
944	충청남도 홍성군 홍성읍 오관리595-2	2026-01-29 23:28:25.445674	36.59814721	126.6587952	OFFICIAL	2026-01-29 23:28:25.445679	0	\N
945	충청남도 홍성군 홍성읍 오관리472-1	2026-01-29 23:28:25.446256	36.59771	126.663	OFFICIAL	2026-01-29 23:28:25.446261	0	\N
946	경기도 군포시 산본천로 111	2026-01-29 23:28:25.446847	37.3646456	126.9342455	OFFICIAL	2026-01-29 23:28:25.446852	0	\N
947	경기도 군포시 용호2로 10 경기도 군포시 당동 976	2026-01-29 23:28:25.447364	37.34225732	126.9382071	OFFICIAL	2026-01-29 23:28:25.447369	0	\N
948	경기도 군포시 군포로 211, (군포시보건소 버스정류소)	2026-01-29 23:28:25.447922	37.33252109	126.9251121	OFFICIAL	2026-01-29 23:28:25.447928	0	\N
949	경기도 군포시 번영로 382, (오금동우체국 앞)	2026-01-29 23:28:25.448514	37.34945226	126.9259671	OFFICIAL	2026-01-29 23:28:25.448519	0	\N
950	경기도 군포시 금산로 91 경기도 군포시 산본동 1256	2026-01-29 23:28:25.449103	37.36808061	126.9366772	OFFICIAL	2026-01-29 23:28:25.449108	0	\N
951	경기도 군포시 산본천로 224-1, (버스정류소)	2026-01-29 23:28:25.449633	37.37161944	126.9421677	OFFICIAL	2026-01-29 23:28:25.449638	0	\N
952	경기도 군포시 번영로 385 경기도 군포시 산본동 1235	2026-01-29 23:28:25.450189	37.35112222	126.9261472	OFFICIAL	2026-01-29 23:28:25.450194	0	\N
953	경기도 군포시 당정역로4번길 20 경기도 군포시 당정동 1027	2026-01-29 23:28:25.450791	37.34291703	126.9504755	OFFICIAL	2026-01-29 23:28:25.450796	0	\N
954	경기도 군포시 용호2로54번길 40 경기도 군포시 당정동 753	2026-01-29 23:28:25.451319	37.34421631	126.9479349	OFFICIAL	2026-01-29 23:28:25.451324	0	\N
955	경기도 군포시 군포로534번길 19, (군포역 1번 출구 앞 택시승강장 부근)	2026-01-29 23:28:25.4519	37.35374466	126.9477314	OFFICIAL	2026-01-29 23:28:25.451905	0	\N
956	경기도 군포시 군포로 524	2026-01-29 23:28:25.452436	37.35281178	126.9458221	OFFICIAL	2026-01-29 23:28:25.452441	0	\N
957	경기도 군포시 고산로 262, (새마을금고 앞)	2026-01-29 23:28:25.453017	37.34676637	126.9436033	OFFICIAL	2026-01-29 23:28:25.453022	0	\N
958	경기도 군포시 산본로 339, (군포시청 건너편 버스정류소)	2026-01-29 23:28:25.453833	37.36060833	126.9325882	OFFICIAL	2026-01-29 23:28:25.453838	0	\N
959	경기도 군포시 산본로 328, (군포우체국 앞)	2026-01-29 23:28:25.454367	37.36019036	126.9340594	OFFICIAL	2026-01-29 23:28:25.454371	0	\N
960	경기도 군포시 산본천로 227-2, (금정역 6번 출구앞 버스정류소) 경기도 군포시 산본동 103-28	2026-01-29 23:28:25.454906	37.37213688	126.9421274	OFFICIAL	2026-01-29 23:28:25.454911	0	\N
961	경기도 군포시 군포로735번길 4 경기도 군포시 금정동 27-6	2026-01-29 23:28:25.455415	37.37076562	126.9436132	OFFICIAL	2026-01-29 23:28:25.45542	0	\N
962	경기도 군포시 번영로 502 경기도 군포시 금정동 894	2026-01-29 23:28:25.455969	37.357707	126.933118	OFFICIAL	2026-01-29 23:28:25.455974	0	\N
963	경기도 군포시 번영로 497 경기도 군포시 산본동 1179	2026-01-29 23:28:25.456491	37.35805724	126.9322603	OFFICIAL	2026-01-29 23:28:25.456496	0	\N
964	경기도 군포시 산본로323번길 16-26(중앙분수대 옆 벤치)	2026-01-29 23:28:25.457029	37.35998048	126.9317825	OFFICIAL	2026-01-29 23:28:25.457034	0	\N
965	경기도 군포시 광정로 60(흡연부스 옆)	2026-01-29 23:28:25.457548	37.35872074	126.9308199	OFFICIAL	2026-01-29 23:28:25.457553	0	\N
966	경상남도 합천군 가야면 야천리 465-5	2026-01-29 23:28:25.458094	35.7627806	128.1394531	OFFICIAL	2026-01-29 23:28:25.458098	0	\N
967	경상남도 합천군 가야면 매화리 304-2	2026-01-29 23:28:25.458656	35.7343862	128.1248001	OFFICIAL	2026-01-29 23:28:25.458661	0	\N
968	서울특별시 구로구 구로동로 13 서울특별시 구로구 가리봉동 121-30	2026-01-29 23:28:25.4592	37.48289633	126.8868871	OFFICIAL	2026-01-29 23:28:25.459205	0	\N
969	서울특별시 성북구 동소문로20길 43 서울특별시 성북구 동선동1가 46-2	2026-01-29 23:28:25.459745	37.59065915	127.0170249	OFFICIAL	2026-01-29 23:28:25.459774	0	\N
970	서울특별시 성북구 보문로34길 88 서울특별시 성북구 동선동2가 154	2026-01-29 23:28:25.460286	37.59125877	127.0201498	OFFICIAL	2026-01-29 23:28:25.460291	0	\N
971	서울특별시 성북구 삼선교로 29 서울특별시 성북구 삼선동2가 105	2026-01-29 23:28:25.46085	37.58824221	127.0092204	OFFICIAL	2026-01-29 23:28:25.460855	0	\N
972	서울특별시 성북구 보문로 151 서울특별시 성북구 삼선동5가 297	2026-01-29 23:28:25.461423	37.58816492	127.0172891	OFFICIAL	2026-01-29 23:28:25.461429	0	\N
973	서울특별시 성북구 보문로 156-1 서울특별시 성북구 삼선동5가 326	2026-01-29 23:28:25.461996	37.58869751	127.0172939	OFFICIAL	2026-01-29 23:28:25.462	0	\N
974	서울특별시 성북구 보문동1가 178-1	2026-01-29 23:28:25.462553	37.58550482	127.0201945	OFFICIAL	2026-01-29 23:28:25.462557	0	\N
975	서울특별시 성북구 보문동1가 109-3	2026-01-29 23:28:25.4631	37.5856381	127.0200081	OFFICIAL	2026-01-29 23:28:25.463105	0	\N
976	서울특별시 성북구 고려대로 73 서울특별시 성북구 안암동5가 126-1	2026-01-29 23:28:25.463655	37.58711097	127.0263572	OFFICIAL	2026-01-29 23:28:25.46366	0	\N
977	서울특별시 성북구 동소문로 310 서울특별시 성북구 하월곡동 88-3	2026-01-29 23:28:25.464194	37.60731274	127.0293121	OFFICIAL	2026-01-29 23:28:25.464199	0	\N
978	대구광역시 북구 칠곡중앙대로136길 90 대구광역시 북구 학정동 515-3	2026-01-29 23:28:25.464729	35.95526718	128.5626769	OFFICIAL	2026-01-29 23:28:25.464734	0	\N
979	대구광역시 북구 학정로 553 (학정동) 대구광역시 북구 학정동 922-3	2026-01-29 23:28:25.465265	35.95406761	128.5654001	OFFICIAL	2026-01-29 23:28:25.46527	0	\N
980	대구광역시 북구 대학로 80 대구광역시 북구 산격동 1370-1	2026-01-29 23:28:25.465836	35.88909749	128.6143223	OFFICIAL	2026-01-29 23:28:25.465841	0	\N
981	대구광역시 북구 옥산로 75 대구광역시 북구 침산동 447-10	2026-01-29 23:28:25.466328	35.88512411	128.5838427	OFFICIAL	2026-01-29 23:28:25.466333	0	\N
982	서울특별시 구로구 구일로8길 31 서울특별시 구로구 구로동 1058	2026-01-29 23:28:25.466881	37.49517251	126.8726762	OFFICIAL	2026-01-29 23:28:25.466886	0	\N
983	서울특별시 성북구 보문로 168 서울특별시 성북구 삼선동5가 411	2026-01-29 23:28:25.467394	37.58946842	127.0168218	OFFICIAL	2026-01-29 23:28:25.467399	0	\N
984	서울특별시 성북구 동소문로 298 서울특별시 성북구 하월곡동 88-485	2026-01-29 23:28:25.46796	37.60650703	127.0282193	OFFICIAL	2026-01-29 23:28:25.467965	0	\N
985	서울특별시 성북구 아리랑로 10 서울특별시 성북구 동선동4가 38	2026-01-29 23:28:25.468571	37.59377027	127.016453	OFFICIAL	2026-01-29 23:28:25.468577	0	\N
986	서울특별시 성북구 길음동 559-1	2026-01-29 23:28:25.469152	37.60544504	127.0222217	OFFICIAL	2026-01-29 23:28:25.469158	0	\N
987	서울특별시 성북구 길음로 33 서울특별시 성북구 길음동 1284	2026-01-29 23:28:25.469706	37.60504925	127.0220094	OFFICIAL	2026-01-29 23:28:25.469711	0	\N
988	서울특별시 성북구 장위동 310-25	2026-01-29 23:28:25.47026	37.61903401	127.0456148	OFFICIAL	2026-01-29 23:28:25.470265	0	\N
989	서울특별시 성북구 서경로 63 서울특별시 성북구 정릉동 192-152	2026-01-29 23:28:25.47086	37.60905769	127.0153655	OFFICIAL	2026-01-29 23:28:25.470864	0	\N
990	서울특별시 성북구 솔샘로 32 서울특별시 성북구 정릉동 704-23	2026-01-29 23:28:25.471365	37.61039477	127.005287	OFFICIAL	2026-01-29 23:28:25.471369	0	\N
991	서울특별시 성북구 한천로 518 서울특별시 성북구 석관동 92-2	2026-01-29 23:28:25.471899	37.60670448	127.0664361	OFFICIAL	2026-01-29 23:28:25.471903	0	\N
992	서울특별시 성북구 한천로 713 서울특별시 성북구 장위동 320	2026-01-29 23:28:25.472392	37.62005567	127.0514349	OFFICIAL	2026-01-29 23:28:25.472396	0	\N
993	서울특별시 성북구 장월로 160 서울특별시 성북구 장위동 322	2026-01-29 23:28:25.47296	37.61800248	127.0533081	OFFICIAL	2026-01-29 23:28:25.472965	0	\N
994	서울특별시 성북구 돌곶이로40길 46 서울특별시 성북구 장위동 323	2026-01-29 23:28:25.473539	37.61866075	127.0489591	OFFICIAL	2026-01-29 23:28:25.473544	0	\N
995	서울특별시 성북구 보국문로22길 8 서울특별시 성북구 정릉동 289-38	2026-01-29 23:28:25.474084	37.61211271	127.0085918	OFFICIAL	2026-01-29 23:28:25.474089	0	\N
996	서울특별시 성북구 종암로24가길 80 서울특별시 성북구 종암동 134	2026-01-29 23:28:25.474662	37.59937311	127.0392269	OFFICIAL	2026-01-29 23:28:25.474667	0	\N
997	서울특별시 성북구 하월곡동 35-1	2026-01-29 23:28:25.475212	37.60142105	127.0411848	OFFICIAL	2026-01-29 23:28:25.475216	0	\N
998	서울특별시 성북구 종암로21가길 36-1 서울특별시 성북구 종암동 65-13	2026-01-29 23:28:25.475849	37.59815179	127.03261	OFFICIAL	2026-01-29 23:28:25.475854	0	\N
999	서울특별시 성북구 정릉동 164-51	2026-01-29 23:28:25.476354	37.6050398	127.0113564	OFFICIAL	2026-01-29 23:28:25.476358	0	\N
1000	서울특별시 성북구 길음로7길 20 서울특별시 성북구 길음동 1286-8	2026-01-29 23:28:25.476908	37.60375093	127.0224636	OFFICIAL	2026-01-29 23:28:25.476912	0	\N
1001	서울특별시 성북구 보문로168 서울특별시 성북구 삼선동5가 411	2026-01-29 23:28:25.521458	37.58946842	127.0168218	OFFICIAL	2026-01-29 23:28:25.521469	0	\N
1002	서울특별시 성북구 장월로29길 9 서울특별시 성북구 장위동 206-3	2026-01-29 23:28:25.522367	37.61769896	127.0498021	OFFICIAL	2026-01-29 23:28:25.522373	0	\N
1003	서울특별시 성북구 정릉로 279 서울특별시 성북구 정릉동 160-1	2026-01-29 23:28:25.523045	37.6038198	127.013291	OFFICIAL	2026-01-29 23:28:25.523051	0	\N
1004	서울특별시 성북구 종암로5길 14 서울특별시 성북구 종암동 22-1	2026-01-29 23:28:25.523593	37.59452119	127.0352972	OFFICIAL	2026-01-29 23:28:25.523598	0	\N
1005	서울특별시 성북구 석관동 375-46	2026-01-29 23:28:25.524179	37.6148489	127.0668471	OFFICIAL	2026-01-29 23:28:25.524184	0	\N
1006	서울특별시 성북구 보국문로 101 서울특별시 성북구 정릉동 295-11	2026-01-29 23:28:25.524777	37.61289493	127.0070579	OFFICIAL	2026-01-29 23:28:25.524783	0	\N
1007	서울특별시 성북구 종암동 90-21	2026-01-29 23:28:25.52536	37.60243467	127.034667	OFFICIAL	2026-01-29 23:28:25.525365	0	\N
1008	서울특별시 성북구 석관동 43-1	2026-01-29 23:28:25.525947	37.60620572	127.0664368	OFFICIAL	2026-01-29 23:28:25.525952	0	\N
1009	서울특별시 성북구 종암동 115-152	2026-01-29 23:28:25.526506	37.60203491	127.0374768	OFFICIAL	2026-01-29 23:28:25.526511	0	\N
1010	서울특별시 성북구 보문로 113 서울특별시 성북구 보문동2가 134	2026-01-29 23:28:25.527081	37.58504462	127.0192999	OFFICIAL	2026-01-29 23:28:25.527086	0	\N
1011	서울특별시 성북구 아리랑로 26-1 서울특별시 성북구 동선동5가 26	2026-01-29 23:28:25.527637	37.59507885	127.016162	OFFICIAL	2026-01-29 23:28:25.527642	0	\N
1012	서울특별시 성북구 하월곡동 1-12	2026-01-29 23:28:25.528201	37.60554551	127.0474239	OFFICIAL	2026-01-29 23:28:25.528206	0	\N
1013	서울특별시 성북구 동소문로23길 73 서울특별시 성북구 동선동5가 141-6	2026-01-29 23:28:25.528784	37.59639551	127.0157506	OFFICIAL	2026-01-29 23:28:25.528789	0	\N
1014	서울특별시 성북구 석관동 375-14	2026-01-29 23:28:25.529334	37.61509454	127.0667187	OFFICIAL	2026-01-29 23:28:25.529339	0	\N
1015	서울특별시 성북구 하월곡동 88-5	2026-01-29 23:28:25.529938	37.60493587	127.0316201	OFFICIAL	2026-01-29 23:28:25.529943	0	\N
1016	서울특별시 성북구 오패산로 22 서울특별시 성북구 하월곡동 62-4	2026-01-29 23:28:25.530496	37.60422016	127.0376844	OFFICIAL	2026-01-29 23:28:25.530501	0	\N
1017	서울특별시 성북구 정릉로 272-8 서울특별시 성북구 정릉동 139-56	2026-01-29 23:28:25.531142	37.60291849	127.0136887	OFFICIAL	2026-01-29 23:28:25.531149	0	\N
1018	서울특별시 성북구 정릉동 967-20	2026-01-29 23:28:25.531925	37.60244138	127.0134197	OFFICIAL	2026-01-29 23:28:25.531932	0	\N
1019	서울특별시 성북구 성북로 14 서울특별시 성북구 성북동1가 50-4	2026-01-29 23:28:25.532556	37.58947034	127.00522	OFFICIAL	2026-01-29 23:28:25.532562	0	\N
1020	서울특별시 성북구 종암로 54 서울특별시 성북구 종암동 10-178	2026-01-29 23:28:25.53314	37.59502982	127.0361993	OFFICIAL	2026-01-29 23:28:25.533145	0	\N
1021	서울특별시 성북구 종암로 103 서울특별시 성북구 종암동 87-6	2026-01-29 23:28:25.533689	37.59933907	127.0340484	OFFICIAL	2026-01-29 23:28:25.533694	0	\N
1022	서울특별시 성북구 정릉로 324 서울특별시 성북구 정릉동 16-170	2026-01-29 23:28:25.534268	37.60212379	127.0191517	OFFICIAL	2026-01-29 23:28:25.534274	0	\N
1023	서울특별시 성북구 화랑로 79 서울특별시 성북구 하월곡동 27-117	2026-01-29 23:28:25.53484	37.60249259	127.0411515	OFFICIAL	2026-01-29 23:28:25.534845	0	\N
1024	서울특별시 성북구 길음동 534-9	2026-01-29 23:28:25.535643	37.60328765	127.0237397	OFFICIAL	2026-01-29 23:28:25.535648	0	\N
1025	서울특별시 성북구 길음동 532-17	2026-01-29 23:28:25.536375	37.60375649	127.0242239	OFFICIAL	2026-01-29 23:28:25.53638	0	\N
1026	서울특별시 성북구 동소문로 295-2 서울특별시 성북구 길음동 515	2026-01-29 23:28:25.537908	37.60675178	127.0278637	OFFICIAL	2026-01-29 23:28:25.537914	0	\N
1027	서울특별시 성북구 동소문로 286 서울특별시 성북구 하월곡동 88-31	2026-01-29 23:28:25.538502	37.60581297	127.0273879	OFFICIAL	2026-01-29 23:28:25.538507	0	\N
1028	서울특별시 성북구 정릉로 367-2 서울특별시 성북구 돈암동 8-165	2026-01-29 23:28:25.539129	37.60227407	127.0240657	OFFICIAL	2026-01-29 23:28:25.539134	0	\N
1029	서울특별시 성북구 오패산로 98-23 서울특별시 성북구 하월곡동 77-976	2026-01-29 23:28:25.539691	37.61176348	127.0359516	OFFICIAL	2026-01-29 23:28:25.539697	0	\N
1030	서울특별시 성북구 정릉동 590-16	2026-01-29 23:28:25.540295	37.60869733	126.9989744	OFFICIAL	2026-01-29 23:28:25.540301	0	\N
1031	서울특별시 성북구 종암로 42-1 서울특별시 성북구 종암동 12-33	2026-01-29 23:28:25.542123	37.59417872	127.0362062	OFFICIAL	2026-01-29 23:28:25.542128	0	\N
1032	서울특별시 성북구 안암로 105 서울특별시 성북구 안암동5가 86-10	2026-01-29 23:28:25.542668	37.58510934	127.0314287	OFFICIAL	2026-01-29 23:28:25.542674	0	\N
1033	서울특별시 성북구 보문로 121 서울특별시 성북구 보문동2가 79	2026-01-29 23:28:25.543234	37.58586857	127.0188005	OFFICIAL	2026-01-29 23:28:25.543239	0	\N
1034	서울특별시 성북구 길음동 607-33	2026-01-29 23:28:25.543819	37.60660606	127.0217163	OFFICIAL	2026-01-29 23:28:25.543825	0	\N
1035	서울특별시 성북구 길음동 875-1	2026-01-29 23:28:25.544347	37.60724571	127.0216337	OFFICIAL	2026-01-29 23:28:25.544352	0	\N
1036	서울특별시 성북구 길음동 875-1	2026-01-29 23:28:25.544897	37.60724571	127.0216337	OFFICIAL	2026-01-29 23:28:25.544902	0	\N
1037	서울특별시 성북구 길음로 74 서울특별시 성북구 길음동 1282	2026-01-29 23:28:25.545435	37.60928966	127.0210339	OFFICIAL	2026-01-29 23:28:25.545441	0	\N
1038	서울특별시 성북구 종암로 129 서울특별시 성북구 종암동 3-1342	2026-01-29 23:28:25.546001	37.60144986	127.0327235	OFFICIAL	2026-01-29 23:28:25.546006	0	\N
1039	서울특별시 성북구 종암로 1 서울특별시 성북구 종암동 29-18	2026-01-29 23:28:25.546548	37.59064969	127.0362127	OFFICIAL	2026-01-29 23:28:25.546554	0	\N
1040	서울특별시 성북구 한천로66길 221-1 서울특별시 성북구 석관동 375-29	2026-01-29 23:28:25.547139	37.61416533	127.0649259	OFFICIAL	2026-01-29 23:28:25.547145	0	\N
1041	서울특별시 성북구 동소문로 312 서울특별시 성북구 하월곡동 89-4	2026-01-29 23:28:25.547657	37.60756223	127.0292087	OFFICIAL	2026-01-29 23:28:25.547663	0	\N
1042	서울특별시 성북구 성북로 68 서울특별시 성북구 성북동 155-16	2026-01-29 23:28:25.548225	37.59352493	127.0014063	OFFICIAL	2026-01-29 23:28:25.548231	0	\N
3014	Gumi Imsu-dong	2026-02-06 16:25:03.009885	36.1081833	128.4139683	PENDING	2026-02-06 16:25:03.00994	1	test
1043	서울특별시 성북구 성북로 52-1 서울특별시 성북구 성북동 170-41	2026-01-29 23:28:25.54886	37.59251384	127.0027939	OFFICIAL	2026-01-29 23:28:25.548865	0	\N
1044	서울특별시 성북구 아리랑로 89 서울특별시 성북구 돈암동 524	2026-01-29 23:28:25.54947	37.60073299	127.0136175	OFFICIAL	2026-01-29 23:28:25.549475	0	\N
1045	서울특별시 성북구 아리랑로 82 서울특별시 성북구 돈암동 538-98	2026-01-29 23:28:25.550032	37.60005917	127.0139243	OFFICIAL	2026-01-29 23:28:25.550037	0	\N
1046	서울특별시 성북구 월계로40길 7 서울특별시 성북구 장위동 316-3	2026-01-29 23:28:25.550612	37.62291794	127.0483972	OFFICIAL	2026-01-29 23:28:25.550617	0	\N
1047	서울특별시 성북구 돌곶이로 197 서울특별시 성북구 장위동 214-79	2026-01-29 23:28:25.551181	37.61762061	127.0477205	OFFICIAL	2026-01-29 23:28:25.551185	0	\N
1048	서울특별시 성북구 장월로 89-1 서울특별시 성북구 장위동 238-198	2026-01-29 23:28:25.5517	37.61386832	127.0487365	OFFICIAL	2026-01-29 23:28:25.551704	0	\N
1049	서울특별시 성북구 고려대로 100 서울특별시 성북구 안암동5가 96	2026-01-29 23:28:25.552435	37.58617158	127.0304208	OFFICIAL	2026-01-29 23:28:25.55244	0	\N
1050	서울특별시 성북구 고려대로27길 4 서울특별시 성북구 안암동5가 99	2026-01-29 23:28:25.553007	37.58652168	127.030237	OFFICIAL	2026-01-29 23:28:25.553012	0	\N
1051	서울특별시 성북구 보문로 124 서울특별시 성북구 보문동1가 120	2026-01-29 23:28:25.553522	37.58612342	127.0192059	OFFICIAL	2026-01-29 23:28:25.553527	0	\N
1052	서울특별시 성북구 보문로 79 서울특별시 성북구 보문동5가 160-1	2026-01-29 23:28:25.554072	37.58238112	127.0206873	OFFICIAL	2026-01-29 23:28:25.554077	0	\N
1053	서울특별시 성북구 보문로 55-1 서울특별시 성북구 보문동7가 31	2026-01-29 23:28:25.554696	37.5804096	127.0217293	OFFICIAL	2026-01-29 23:28:25.554701	0	\N
1054	서울특별시 성북구 종암로 180-1 서울특별시 성북구 하월곡동 90-117	2026-01-29 23:28:25.555332	37.6059607	127.0316371	OFFICIAL	2026-01-29 23:28:25.555338	0	\N
1055	서울특별시 성북구 종암로40길 37 서울특별시 성북구 하월곡동 174	2026-01-29 23:28:25.555892	37.60967849	127.0320225	OFFICIAL	2026-01-29 23:28:25.555898	0	\N
1056	서울특별시 성북구 오패산로3길 17 서울특별시 성북구 하월곡동 219	2026-01-29 23:28:25.556406	37.60459386	127.0345453	OFFICIAL	2026-01-29 23:28:25.556411	0	\N
1057	서울특별시 성북구 종암로 132 서울특별시 성북구 종암동 132	2026-01-29 23:28:25.556897	37.60193718	127.0335324	OFFICIAL	2026-01-29 23:28:25.556901	0	\N
1058	서울특별시 성북구 길음동 1076-2	2026-01-29 23:28:25.557386	37.60455235	127.0251733	OFFICIAL	2026-01-29 23:28:25.557391	0	\N
1059	서울특별시 성북구 월곡로108 서울특별시 성북구 하월곡동 35-5	2026-01-29 23:28:25.557918	37.60156211	127.0415814	OFFICIAL	2026-01-29 23:28:25.557923	0	\N
1060	서울특별시 성북구 화랑로15길 4 서울특별시 성북구 상월곡동 55-56	2026-01-29 23:28:25.558406	37.60572459	127.0463868	OFFICIAL	2026-01-29 23:28:25.558411	0	\N
1061	서울특별시 성북구 상월곡동 35-9	2026-01-29 23:28:25.558891	37.60603113	127.0476799	OFFICIAL	2026-01-29 23:28:25.558896	0	\N
1062	서울특별시 성북구 화랑로 241 서울특별시 성북구 장위동 64-115	2026-01-29 23:28:25.559363	37.61063073	127.0561203	OFFICIAL	2026-01-29 23:28:25.559368	0	\N
1063	서울특별시 성북구 장위동 64-135	2026-01-29 23:28:25.559863	37.61126749	127.0565666	OFFICIAL	2026-01-29 23:28:25.559868	0	\N
1064	서울특별시 성북구 정릉동 747-4	2026-01-29 23:28:25.560387	37.61357821	127.0062651	OFFICIAL	2026-01-29 23:28:25.560391	0	\N
1065	서울특별시 성북구 솔샘로25길 11-11 서울특별시 성북구 정릉동 239-4	2026-01-29 23:28:25.560935	37.61604544	127.008106	OFFICIAL	2026-01-29 23:28:25.56094	0	\N
1066	서울특별시 성북구 정릉동 649-33	2026-01-29 23:28:25.561463	37.60730331	127.0030606	OFFICIAL	2026-01-29 23:28:25.561468	0	\N
1067	서울특별시 성북구 정릉로 119-39 서울특별시 성북구 정릉동 산 1-79	2026-01-29 23:28:25.562028	37.60991195	126.9983548	OFFICIAL	2026-01-29 23:28:25.562032	0	\N
1068	서울특별시 성북구 정릉동 산 1-213	2026-01-29 23:28:25.562517	37.61090527	126.9943438	OFFICIAL	2026-01-29 23:28:25.562521	0	\N
1069	서울특별시 성북구 정릉동 산 1-344	2026-01-29 23:28:25.563139	37.61094706	126.9935823	OFFICIAL	2026-01-29 23:28:25.563146	0	\N
1070	서울특별시 성북구 정릉동 산 1-200	2026-01-29 23:28:25.563721	37.60836364	127.0007169	OFFICIAL	2026-01-29 23:28:25.563727	0	\N
1071	서울특별시 성북구 정릉로 153 서울특별시 성북구 정릉동 653-1	2026-01-29 23:28:25.564316	37.60795544	127.0024021	OFFICIAL	2026-01-29 23:28:25.564322	0	\N
1072	서울특별시 성북구 정릉동 415-18	2026-01-29 23:28:25.56489	37.60528387	127.0113803	OFFICIAL	2026-01-29 23:28:25.564895	0	\N
1073	서울특별시 성북구 정릉로26길 1 서울특별시 성북구 정릉동 966-125	2026-01-29 23:28:25.565401	37.60446495	127.0111291	OFFICIAL	2026-01-29 23:28:25.565406	0	\N
1074	서울특별시 성북구 정릉로 282 서울특별시 성북구 정릉동 966-112	2026-01-29 23:28:25.565962	37.60312751	127.0145106	OFFICIAL	2026-01-29 23:28:25.565967	0	\N
1075	서울특별시 성북구 정릉로31길 30 서울특별시 성북구 정릉동 966-173	2026-01-29 23:28:25.566511	37.60387465	127.0153694	OFFICIAL	2026-01-29 23:28:25.566516	0	\N
1076	서울특별시 성북구 성북동 227-8	2026-01-29 23:28:25.56706	37.59438363	126.991777	OFFICIAL	2026-01-29 23:28:25.567065	0	\N
1077	서울특별시 성북구 동소문로 184-1 서울특별시 성북구 돈암동 19-309	2026-01-29 23:28:25.567563	37.59840562	127.0219621	OFFICIAL	2026-01-29 23:28:25.567568	0	\N
1078	서울특별시 성북구 동소문로 181-1 서울특별시 성북구 돈암동 49-1	2026-01-29 23:28:25.568071	37.59831397	127.0215854	OFFICIAL	2026-01-29 23:28:25.568076	0	\N
1079	서울특별시 성북구 정릉로 372-1 서울특별시 성북구 돈암동 9-2	2026-01-29 23:28:25.56867	37.60188115	127.0244669	OFFICIAL	2026-01-29 23:28:25.568675	0	\N
1080	서울특별시 성북구 아리랑로7-1 서울특별시 성북구 동소문동6가 143-2	2026-01-29 23:28:25.569192	37.5934711	127.0161231	OFFICIAL	2026-01-29 23:28:25.569196	0	\N
1081	서울특별시 성북구 아리랑로8 서울특별시 성북구 동선동4가 26	2026-01-29 23:28:25.569679	37.59360817	127.0166658	OFFICIAL	2026-01-29 23:28:25.569683	0	\N
1082	서울특별시 성북구 동선동1가 101-1	2026-01-29 23:28:25.570258	37.5930516	127.0173347	OFFICIAL	2026-01-29 23:28:25.570263	0	\N
1083	서울특별시 성북구 동선동1가 123-1	2026-01-29 23:28:25.570778	37.59403525	127.0185316	OFFICIAL	2026-01-29 23:28:25.570783	0	\N
1084	서울특별시 성북구 성북로 3 서울특별시 성북구 성북동1가 35-33	2026-01-29 23:28:25.571325	37.58862414	127.0055302	OFFICIAL	2026-01-29 23:28:25.57133	0	\N
1085	서울특별시 성북구 동소문동3가 1-1	2026-01-29 23:28:25.571906	37.58995391	127.009784	OFFICIAL	2026-01-29 23:28:25.571911	0	\N
1086	서울특별시 성북구 동소문로 12-1 서울특별시 성북구 동소문동2가 2-1	2026-01-29 23:28:25.572449	37.58889911	127.0074702	OFFICIAL	2026-01-29 23:28:25.572454	0	\N
1087	서울특별시 성북구 동소문동2가 2-4	2026-01-29 23:28:25.573008	37.58840558	127.0064867	OFFICIAL	2026-01-29 23:28:25.573012	0	\N
1088	부산광역시 금정구 중앙대로 1770부산광역시 금정구 중앙대로 1777	2026-01-29 23:28:25.573682	35.24234	129.093	OFFICIAL	2026-01-29 23:28:25.573688	0	\N
1089	경상북도 영덕군 달산면 팔각산로 1833 경상북도 영덕군 달산면 대지리 463-3	2026-01-29 23:28:25.574235	36.39925547	129.3031206	OFFICIAL	2026-01-29 23:28:25.57424	0	\N
1090	경상북도 영덕군 병곡면 덕천리 54-4	2026-01-29 23:28:25.574821	36.56488276	129.420373	OFFICIAL	2026-01-29 23:28:25.574826	0	\N
1091	경상북도 영덕군 지품면 신안리 183-10	2026-01-29 23:28:25.575319	36.44796596	129.2816463	OFFICIAL	2026-01-29 23:28:25.575324	0	\N
1092	경상북도 영덕군 축산면 상원리 220-3	2026-01-29 23:28:25.575894	36.50740542	129.3988972	OFFICIAL	2026-01-29 23:28:25.575898	0	\N
1093	경상북도 영덕군 남정면 회리 691-7	2026-01-29 23:28:25.576369	36.27395438	129.3510523	OFFICIAL	2026-01-29 23:28:25.576376	0	\N
1094	경상북도 영덕군 남정면 부경리 448-7	2026-01-29 23:28:25.576885	36.26838467	129.3752332	OFFICIAL	2026-01-29 23:28:25.576892	0	\N
1095	경상북도 영덕군 강구면 강산로 152 경상북도 영덕군 강구면 화전리 산 55-2	2026-01-29 23:28:25.577351	36.35817018	129.3658262	OFFICIAL	2026-01-29 23:28:25.577355	0	\N
1096	경상북도 영덕군 영덕읍 창포리 113-3	2026-01-29 23:28:25.577877	36.41760453	129.4306034	OFFICIAL	2026-01-29 23:28:25.577882	0	\N
1097	경상북도 영덕군 창수면 인천리 191-4	2026-01-29 23:28:25.578384	36.63775808	129.2843135	OFFICIAL	2026-01-29 23:28:25.578392	0	\N
1098	경상북도 영덕군 축산면 경정리 301-1	2026-01-29 23:28:25.578883	36.48373338	129.4354461	OFFICIAL	2026-01-29 23:28:25.578888	0	\N
1099	경상북도 영덕군 축산면 경정리 404-3	2026-01-29 23:28:25.579347	36.48367277	129.4325273	OFFICIAL	2026-01-29 23:28:25.579351	0	\N
1100	경상북도 영덕군 축산면 도곡리 615-4	2026-01-29 23:28:25.579844	36.50636254	129.41622	OFFICIAL	2026-01-29 23:28:25.579848	0	\N
1101	경상북도 영덕군 남정면 양성리 176-4	2026-01-29 23:28:25.58033	36.28256739	129.3671429	OFFICIAL	2026-01-29 23:28:25.580335	0	\N
1102	경상북도 영덕군 남정면 회리 705-7	2026-01-29 23:28:25.580898	36.27364649	129.3318908	OFFICIAL	2026-01-29 23:28:25.580902	0	\N
1103	경상북도 영덕군 남정면 회리 40-11	2026-01-29 23:28:25.581447	36.27501753	129.3409078	OFFICIAL	2026-01-29 23:28:25.581452	0	\N
1104	경상북도 영덕군 남정면 원척1길 44-1 경상북도 영덕군 남정면 원척리 121-1	2026-01-29 23:28:25.581952	36.30055384	129.3781363	OFFICIAL	2026-01-29 23:28:25.581957	0	\N
1105	경상북도 영덕군 남정면 부흥리 486	2026-01-29 23:28:25.582438	36.29032174	129.375207	OFFICIAL	2026-01-29 23:28:25.582443	0	\N
1106	경상북도 영덕군 남정면 진불4길 4 경상북도 영덕군 남정면 장사리 306-1	2026-01-29 23:28:25.582944	36.28554099	129.3722543	OFFICIAL	2026-01-29 23:28:25.582949	0	\N
1107	경상북도 영덕군 영해면 괴시리 143-1	2026-01-29 23:28:25.583414	36.54176292	129.4090079	OFFICIAL	2026-01-29 23:28:25.583419	0	\N
1108	경상북도 영덕군 영해면 성내리 499-1	2026-01-29 23:28:25.583886	36.54093383	129.4054211	OFFICIAL	2026-01-29 23:28:25.58389	0	\N
1109	경상북도 영덕군 영해면 대리 390	2026-01-29 23:28:25.58435	36.51819594	129.2991678	OFFICIAL	2026-01-29 23:28:25.584355	0	\N
1110	경상북도 영덕군 영해면 성내리 824-5	2026-01-29 23:28:25.584863	36.53218421	129.4062223	OFFICIAL	2026-01-29 23:28:25.584867	0	\N
1111	경상북도 영덕군 영해면 성내리 687-4	2026-01-29 23:28:25.585394	36.53534308	129.4054433	OFFICIAL	2026-01-29 23:28:25.585398	0	\N
1112	경상북도 영덕군 영해면 벌영리 388-1	2026-01-29 23:28:25.585882	36.53691248	129.4015272	OFFICIAL	2026-01-29 23:28:25.585886	0	\N
1113	경상북도 영덕군 영해면 예주시장4길 10 경상북도 영덕군 영해면 성내리 468-1	2026-01-29 23:28:25.586349	36.5400495	129.4073058	OFFICIAL	2026-01-29 23:28:25.586353	0	\N
1114	경상북도 영덕군 영해면 예주8길 14-7 경상북도 영덕군 영해면 괴시리 128	2026-01-29 23:28:25.586839	36.53906186	129.413478	OFFICIAL	2026-01-29 23:28:25.586843	0	\N
1115	경상북도 영덕군 영해면 원당길 5 경상북도 영덕군 영해면 성내리 386	2026-01-29 23:28:25.587308	36.53779655	129.4104762	OFFICIAL	2026-01-29 23:28:25.587312	0	\N
1116	경상북도 영덕군 영해면 벌영리 410-3	2026-01-29 23:28:25.587773	36.5375435	129.4003768	OFFICIAL	2026-01-29 23:28:25.587777	0	\N
1117	경상북도 영덕군 영해면 원구1길 54 경상북도 영덕군 영해면 원구리 152-18	2026-01-29 23:28:25.588259	36.53949225	129.3786693	OFFICIAL	2026-01-29 23:28:25.588264	0	\N
1118	경상북도 영덕군 강구면 오포리 579-1	2026-01-29 23:28:25.588776	36.35880023	129.3776821	OFFICIAL	2026-01-29 23:28:25.58878	0	\N
1119	경상북도 영덕군 강구면 원직리 534	2026-01-29 23:28:25.589243	36.37632184	129.3683248	OFFICIAL	2026-01-29 23:28:25.589248	0	\N
1120	경상북도 영덕군 강구면 오포리 882	2026-01-29 23:28:25.589709	36.36147561	129.3780011	OFFICIAL	2026-01-29 23:28:25.589714	0	\N
1121	경상북도 영덕군 강구면 소월리 133-1	2026-01-29 23:28:25.5902	36.37777784	129.3742767	OFFICIAL	2026-01-29 23:28:25.590204	0	\N
1122	경상북도 영덕군 강구면 하저리 산 181-1	2026-01-29 23:28:25.590662	36.3880102	129.4066097	OFFICIAL	2026-01-29 23:28:25.590666	0	\N
1123	경상북도 영덕군 강구면 삼사리 147	2026-01-29 23:28:25.591143	36.34892434	129.3849337	OFFICIAL	2026-01-29 23:28:25.591151	0	\N
1124	경상북도 영덕군 강구면 오포리 814-1	2026-01-29 23:28:25.591612	36.35777489	129.3890432	OFFICIAL	2026-01-29 23:28:25.591616	0	\N
1125	경상북도 영덕군 강구면 금진리 806-1	2026-01-29 23:28:25.592067	36.37636469	129.4019142	OFFICIAL	2026-01-29 23:28:25.592072	0	\N
1126	경상북도 영덕군 강구면 오포리 1-9	2026-01-29 23:28:25.592539	36.35648031	129.3849978	OFFICIAL	2026-01-29 23:28:25.592543	0	\N
1127	경상북도 영덕군 강구면 영덕대게로 509 경상북도 영덕군 강구면 하저리 57-2	2026-01-29 23:28:25.592998	36.39050172	129.4085883	OFFICIAL	2026-01-29 23:28:25.593002	0	\N
1128	경상북도 영덕군 강구면 신강구1길 21-1 경상북도 영덕군 강구면 오포리 675	2026-01-29 23:28:25.593478	36.35530805	129.3812564	OFFICIAL	2026-01-29 23:28:25.593482	0	\N
1129	서울특별시 구로구 구일로2길 60 서울특별시 구로구 구로동 1259	2026-01-29 23:28:25.593965	37.48975807	126.8770812	OFFICIAL	2026-01-29 23:28:25.593969	0	\N
1130	경상북도 영덕군 강구면 오포리 616-1	2026-01-29 23:28:25.594428	36.35449737	129.3789892	OFFICIAL	2026-01-29 23:28:25.594432	0	\N
1131	경상북도 영덕군 강구면 오포리 386-4	2026-01-29 23:28:25.594884	36.36303272	129.3755067	OFFICIAL	2026-01-29 23:28:25.594889	0	\N
1132	경상북도 영덕군 영덕읍 화개리 644-13	2026-01-29 23:28:25.595341	36.41740653	129.3660419	OFFICIAL	2026-01-29 23:28:25.595345	0	\N
1133	경상북도 영덕군 영덕읍 화개리 257	2026-01-29 23:28:25.595824	36.42036067	129.3632565	OFFICIAL	2026-01-29 23:28:25.595829	0	\N
1134	경상북도 영덕군 영덕읍 군청길 116 경상북도 영덕군 영덕읍 남석리 310-3	2026-01-29 23:28:25.596283	36.41503388	129.3654012	OFFICIAL	2026-01-29 23:28:25.596287	0	\N
1135	경상북도 영덕군 영덕읍 화개리 86	2026-01-29 23:28:25.596744	36.4151178	129.368141	OFFICIAL	2026-01-29 23:28:25.596771	0	\N
1136	경상북도 영덕군 영덕읍 화천리 524-5	2026-01-29 23:28:25.597226	36.45990512	129.3524221	OFFICIAL	2026-01-29 23:28:25.597231	0	\N
1137	경상북도 영덕군 영덕읍 우곡리 93-1	2026-01-29 23:28:25.597681	36.41563383	129.3792098	OFFICIAL	2026-01-29 23:28:25.597686	0	\N
1138	경상북도 영덕군 영덕읍 영덕대게로 1198 경상북도 영덕군 영덕읍 오보리 146-7	2026-01-29 23:28:25.598167	36.44022908	129.4324078	OFFICIAL	2026-01-29 23:28:25.598171	0	\N
1139	경상북도 영덕군 영덕읍 덕곡리 233	2026-01-29 23:28:25.598686	36.41318837	129.3713592	OFFICIAL	2026-01-29 23:28:25.59869	0	\N
1140	경상북도 영덕군 영덕읍 덕곡리 331-3	2026-01-29 23:28:25.599173	36.40955044	129.3709725	OFFICIAL	2026-01-29 23:28:25.599177	0	\N
1141	경상북도 영덕군 영덕읍 덕곡리 322-11	2026-01-29 23:28:25.599729	36.41385344	129.3732127	OFFICIAL	2026-01-29 23:28:25.599733	0	\N
1142	경상북도 영덕군 영덕읍 남산길 21-3 경상북도 영덕군 영덕읍 남산리 63-5	2026-01-29 23:28:25.600215	36.40132792	129.3706873	OFFICIAL	2026-01-29 23:28:25.600219	0	\N
1143	경상북도 영덕군 영덕읍 우곡리 490-4	2026-01-29 23:28:25.600694	36.40858173	129.3712698	OFFICIAL	2026-01-29 23:28:25.600699	0	\N
1144	경상북도 영덕군 영덕읍 덕곡리 228-7	2026-01-29 23:28:25.60119	36.41328385	129.3731214	OFFICIAL	2026-01-29 23:28:25.601195	0	\N
1145	경상북도 영덕군 영덕읍 우곡리 490-4	2026-01-29 23:28:25.60165	36.40858173	129.3712698	OFFICIAL	2026-01-29 23:28:25.601654	0	\N
1146	경상북도 영덕군 영덕읍 구미1길 14 경상북도 영덕군 영덕읍 구미리 155	2026-01-29 23:28:25.602129	36.43338075	129.3546003	OFFICIAL	2026-01-29 23:28:25.602133	0	\N
1147	경상북도 영덕군 영덕읍 석리 221-3	2026-01-29 23:28:25.602593	36.46573457	129.4351088	OFFICIAL	2026-01-29 23:28:25.602597	0	\N
1148	경상북도 영덕군 영덕읍 창포리 625-1	2026-01-29 23:28:25.603065	36.410966	129.4298665	OFFICIAL	2026-01-29 23:28:25.603069	0	\N
1149	경상북도 영덕군 영덕읍 노물리 568	2026-01-29 23:28:25.603702	36.44641039	129.4321646	OFFICIAL	2026-01-29 23:28:25.603707	0	\N
1150	경상북도 영덕군 영덕읍 남산리 245-1	2026-01-29 23:28:25.604238	36.39209573	129.3693516	OFFICIAL	2026-01-29 23:28:25.604242	0	\N
1151	경상남도 합천군 야로면 묵촌리 654-5	2026-01-29 23:28:25.604696	35.7048422	128.1538951	OFFICIAL	2026-01-29 23:28:25.604701	0	\N
1152	경상남도 합천군 야로면 하빈리 282	2026-01-29 23:28:25.605306	35.7268417	128.1874528	OFFICIAL	2026-01-29 23:28:25.605311	0	\N
1153	경상남도 합천군 야로면 나대리 472-8	2026-01-29 23:28:25.607387	35.7581771	128.1724539	OFFICIAL	2026-01-29 23:28:25.607393	0	\N
1154	경상남도 합천군 야로면 금평리 137	2026-01-29 23:28:25.607967	35.7084214	128.1852657	OFFICIAL	2026-01-29 23:28:25.607972	0	\N
1155	경상남도 합천군 야로면 청계리 376-8	2026-01-29 23:28:25.608484	35.6933264	128.2004456	OFFICIAL	2026-01-29 23:28:25.608489	0	\N
1156	경상남도 합천군 야로면 하빈리 438-10	2026-01-29 23:28:25.609031	35.7087664	128.1776742	OFFICIAL	2026-01-29 23:28:25.609036	0	\N
1157	경상남도 합천군 야로면 하림리 675-1	2026-01-29 23:28:25.609548	35.7454434	128.1505014	OFFICIAL	2026-01-29 23:28:25.609553	0	\N
1158	경상남도 합천군 가야면 사촌리 496-2	2026-01-29 23:28:25.610057	35.7506102	128.1250685	OFFICIAL	2026-01-29 23:28:25.610062	0	\N
1159	경상남도 합천군 가야면 죽전리 429-6	2026-01-29 23:28:25.610591	35.7499737	128.0783512	OFFICIAL	2026-01-29 23:28:25.610596	0	\N
1160	서울특별시 구로구 구일로 62 서울특별시 구로구 구로동 685-219	2026-01-29 23:28:25.611138	37.49177716	126.8743642	OFFICIAL	2026-01-29 23:28:25.611143	0	\N
1161	경상남도 합천군 적중면 황정길 109-1	2026-01-29 23:28:25.611679	35.5357856	128.2852634	OFFICIAL	2026-01-29 23:28:25.611683	0	\N
1162	경상남도 합천군 적중면 부수길 28-2	2026-01-29 23:28:25.612198	35.5441548	128.2871901	OFFICIAL	2026-01-29 23:28:25.612203	0	\N
1163	경상남도 합천군 적중면 양림길 27	2026-01-29 23:28:25.612689	35.5381525	128.2672411	OFFICIAL	2026-01-29 23:28:25.612693	0	\N
1164	경상남도 합천군 청덕면 모리 378	2026-01-29 23:28:25.613216	35.5746318	128.3085041	OFFICIAL	2026-01-29 23:28:25.61322	0	\N
1165	경상남도 합천군 청덕면 가현리 69	2026-01-29 23:28:25.613774	35.5715121	128.3422514	OFFICIAL	2026-01-29 23:28:25.613779	0	\N
1166	경상남도 합천군 덕곡면 본곡리 768	2026-01-29 23:28:25.614269	35.6446497	128.3086293	OFFICIAL	2026-01-29 23:28:25.614274	0	\N
1167	경상남도 합천군 덕곡면 장리 1000-3	2026-01-29 23:28:25.6149	35.6283973	128.3158976	OFFICIAL	2026-01-29 23:28:25.614904	0	\N
1168	경상남도 합천군 덕곡면 병배리 290-3	2026-01-29 23:28:25.615517	35.6246449	128.3400711	OFFICIAL	2026-01-29 23:28:25.615521	0	\N
1169	경상남도 합천군 덕곡면 병배리 72-1	2026-01-29 23:28:25.616043	35.6192479	128.3456449	OFFICIAL	2026-01-29 23:28:25.616047	0	\N
1170	경상남도 합천군 덕곡면 학리 547	2026-01-29 23:28:25.616529	35.6247044	128.3476335	OFFICIAL	2026-01-29 23:28:25.616533	0	\N
1171	경상남도 합천군 덕곡면 학리 302-1	2026-01-29 23:28:25.617025	35.6262151	128.3519898	OFFICIAL	2026-01-29 23:28:25.61703	0	\N
1172	경상남도 합천군 덕곡면 율원리 406	2026-01-29 23:28:25.617544	35.6401608	128.2905254	OFFICIAL	2026-01-29 23:28:25.617548	0	\N
1173	경상남도 합천군 덕곡면 장리 531-2	2026-01-29 23:28:25.61805	35.6246193	128.3265031	OFFICIAL	2026-01-29 23:28:25.618059	0	\N
1174	경상남도 합천군 덕곡면 포두1길 82-7	2026-01-29 23:28:25.618522	35.6315481	128.3468682	OFFICIAL	2026-01-29 23:28:25.618527	0	\N
1175	경상남도 합천군 덕곡면 장리 2길 3	2026-01-29 23:28:25.619054	35.6232635	128.3311783	OFFICIAL	2026-01-29 23:28:25.619058	0	\N
1176	경상남도 합천군 쌍책면 상포리 448	2026-01-29 23:28:25.621875	35.5827021	128.2736784	OFFICIAL	2026-01-29 23:28:25.62188	0	\N
1177	경상남도 합천군 쌍책면 덕봉리 241-2	2026-01-29 23:28:25.622418	35.6029446	128.2785594	OFFICIAL	2026-01-29 23:28:25.622423	0	\N
1178	경상남도 합천군 쌍책면 상포리 248-3	2026-01-29 23:28:25.62292	35.5840863	128.2673384	OFFICIAL	2026-01-29 23:28:25.622925	0	\N
1179	경상남도 합천군 초계면 대평리 430-4	2026-01-29 23:28:25.623396	35.5452444	128.2513609	OFFICIAL	2026-01-29 23:28:25.623401	0	\N
1180	경상남도 합천군 초계면 상대리 445	2026-01-29 23:28:25.623869	35.5310564	128.2514821	OFFICIAL	2026-01-29 23:28:25.623873	0	\N
1181	경상남도 합천군 초계면 신촌리 607-8	2026-01-29 23:28:25.624315	35.5221829	128.2490177	OFFICIAL	2026-01-29 23:28:25.624319	0	\N
1182	경상남도 합천군 초계면 중리 110	2026-01-29 23:28:25.624836	35.5602246	128.2559635	OFFICIAL	2026-01-29 23:28:25.624841	0	\N
1183	경상남도 합천군 율곡면 본천리 424	2026-01-29 23:28:25.625363	35.5567639	128.1926374	OFFICIAL	2026-01-29 23:28:25.625368	0	\N
1184	경상남도 합천군 율곡면 제내2길 21-3	2026-01-29 23:28:25.625869	35.5849868	128.2084181	OFFICIAL	2026-01-29 23:28:25.625874	0	\N
1185	경상남도 합천군 율곡면 임북2길 43-1	2026-01-29 23:28:25.626338	35.5757757	128.1798845	OFFICIAL	2026-01-29 23:28:25.626342	0	\N
1186	경상남도 합천군 율곡면 노양리 581-1	2026-01-29 23:28:25.626818	35.6239604	128.1931849	OFFICIAL	2026-01-29 23:28:25.626823	0	\N
1187	경상남도 합천군 율곡면 영전리 455-1	2026-01-29 23:28:25.627266	35.5724136	128.2180941	OFFICIAL	2026-01-29 23:28:25.627271	0	\N
1188	경상남도 합천군 율곡면 내천리 594-6	2026-01-29 23:28:25.62771	35.6109354	128.2386188	OFFICIAL	2026-01-29 23:28:25.627715	0	\N
1189	경상남도 합천군 율곡면 와리 424-3	2026-01-29 23:28:25.628197	35.6111101	128.1967634	OFFICIAL	2026-01-29 23:28:25.628202	0	\N
1190	경상남도 합천군 야로면 매촌리 300-1	2026-01-29 23:28:25.628641	35.7209982	128.1646808	OFFICIAL	2026-01-29 23:28:25.628645	0	\N
1191	서울특별시 구로구 가마산로 87 서울특별시 구로구 구로동 1281-1	2026-01-29 23:28:25.629156	37.48584845	126.876157	OFFICIAL	2026-01-29 23:28:25.629161	0	\N
1192	경상남도 합천군 대병면 상천길 29-1	2026-01-29 23:28:25.629595	35.5443764	128.0280579	OFFICIAL	2026-01-29 23:28:25.629601	0	\N
1193	경상남도 합천군 대병면 양리 631	2026-01-29 23:28:25.630043	35.5058701	128.0239437	OFFICIAL	2026-01-29 23:28:25.630047	0	\N
1194	경상남도 합천군 가회면 안불길 127	2026-01-29 23:28:25.630483	35.4486652	128.0348103	OFFICIAL	2026-01-29 23:28:25.630489	0	\N
1195	경상남도 합천군 가회면 오도리 1016-3	2026-01-29 23:28:25.630951	35.4515047	128.0343709	OFFICIAL	2026-01-29 23:28:25.630955	0	\N
1196	경상남도 합천군 가회면 장대리 677	2026-01-29 23:28:25.631434	35.4422671	128.0545132	OFFICIAL	2026-01-29 23:28:25.631439	0	\N
1197	경상남도 합천군 삼가면 외톨리 577-2	2026-01-29 23:28:25.631879	35.4136416	128.1045828	OFFICIAL	2026-01-29 23:28:25.631883	0	\N
1198	경상남도 합천군 쌍백면 하신리 809-3	2026-01-29 23:28:25.632316	35.4610897	128.1251036	OFFICIAL	2026-01-29 23:28:25.632321	0	\N
1199	경상남도 합천군 쌍백면 외초리 1060	2026-01-29 23:28:25.632794	35.4127127	128.1687308	OFFICIAL	2026-01-29 23:28:25.632799	0	\N
1200	경상남도 합천군 쌍백면 평구리 887-1	2026-01-29 23:28:25.633266	35.4411999	128.1379711	OFFICIAL	2026-01-29 23:28:25.633271	0	\N
1201	경상남도 합천군 쌍백면 평구리 837-4	2026-01-29 23:28:25.633708	35.4348169	128.1389735	OFFICIAL	2026-01-29 23:28:25.633712	0	\N
1202	경상남도 합천군 쌍백면 죽전리 672-3	2026-01-29 23:28:25.634177	35.4542199	128.1172602	OFFICIAL	2026-01-29 23:28:25.634182	0	\N
1203	경상남도 합천군 쌍백면 백역리 1014	2026-01-29 23:28:25.634629	35.4854131	128.1213942	OFFICIAL	2026-01-29 23:28:25.634634	0	\N
1204	경상남도 합천군 쌍백면 죽전리 111	2026-01-29 23:28:25.635132	35.4446461	128.1272702	OFFICIAL	2026-01-29 23:28:25.635137	0	\N
1205	경상남도 합천군 쌍백면 안계리 955	2026-01-29 23:28:25.635592	35.4354249	128.1831954	OFFICIAL	2026-01-29 23:28:25.635597	0	\N
1206	경상남도 합천군 쌍백면 외초리 554-6	2026-01-29 23:28:25.636033	35.4198881	128.1685916	OFFICIAL	2026-01-29 23:28:25.636037	0	\N
1207	경상남도 합천군 쌍백면 하신리 708-3	2026-01-29 23:28:25.636475	35.4679961	128.1235166	OFFICIAL	2026-01-29 23:28:25.63648	0	\N
1208	경상남도 합천군 쌍백면 삼리 251-5	2026-01-29 23:28:25.636961	35.4671705	128.0999032	OFFICIAL	2026-01-29 23:28:25.636965	0	\N
1209	경상남도 합천군 쌍백면 백역리 971-4	2026-01-29 23:28:25.637939	35.4793357	128.1232915	OFFICIAL	2026-01-29 23:28:25.637944	0	\N
1210	경상남도 합천군 쌍백면 외초리 1065	2026-01-29 23:28:25.638415	35.4111052	128.1708966	OFFICIAL	2026-01-29 23:28:25.63842	0	\N
1211	경상남도 합천군 대양면 백암리 367	2026-01-29 23:28:25.639368	35.4969628	128.2209542	OFFICIAL	2026-01-29 23:28:25.639374	0	\N
1212	경상남도 합천군 대양면 덕정리 706-3	2026-01-29 23:28:25.639893	35.5142588	128.1783471	OFFICIAL	2026-01-29 23:28:25.639898	0	\N
1213	경상남도 합천군 대양면 양산리 588-12	2026-01-29 23:28:25.640475	35.5031786	128.1672774	OFFICIAL	2026-01-29 23:28:25.64048	0	\N
1214	경상남도 합천군 대양면 함지리 173-6	2026-01-29 23:28:25.64121	35.4912131	128.1637477	OFFICIAL	2026-01-29 23:28:25.641215	0	\N
1215	경상남도 합천군 대양면 무곡리 984	2026-01-29 23:28:25.641723	35.5213401	128.1866761	OFFICIAL	2026-01-29 23:28:25.641728	0	\N
1216	경상남도 합천군 대양면 무곡리 1258-1	2026-01-29 23:28:25.642231	35.5178917	128.2010229	OFFICIAL	2026-01-29 23:28:25.642236	0	\N
1217	경상남도 합천군 대양면 안금리 576-2	2026-01-29 23:28:25.642713	35.4959148	128.1848427	OFFICIAL	2026-01-29 23:28:25.642717	0	\N
1218	경상남도 합천군 대양면 백암리 542	2026-01-29 23:28:25.643189	35.4974459	128.2129423	OFFICIAL	2026-01-29 23:28:25.643194	0	\N
1219	경상남도 합천군 대양면 정양리 293	2026-01-29 23:28:25.643637	35.5428363	128.1630034	OFFICIAL	2026-01-29 23:28:25.643641	0	\N
1220	경상남도 합천군 적중면 정토리 206-1	2026-01-29 23:28:25.644091	35.5296748	128.2569581	OFFICIAL	2026-01-29 23:28:25.644096	0	\N
1221	경상남도 합천군 적중면 두방리 45	2026-01-29 23:28:25.644533	35.5372111	128.2996487	OFFICIAL	2026-01-29 23:28:25.644538	0	\N
1222	경상남도 합천군 적중면 명곡2길 40	2026-01-29 23:28:25.644975	35.5288334	128.2707277	OFFICIAL	2026-01-29 23:28:25.64498	0	\N
1223	경상남도 합천군 합천읍 합천리 872-1	2026-01-29 23:28:25.645427	35.5625799	128.1604401	OFFICIAL	2026-01-29 23:28:25.645432	0	\N
1224	경상남도 합천군 합천읍 합천리 348-7	2026-01-29 23:28:25.645867	35.5656722	128.1666461	OFFICIAL	2026-01-29 23:28:25.645872	0	\N
1225	경상남도 합천군 합천읍 합천리 501-2	2026-01-29 23:28:25.646308	35.5681729	128.1570201	OFFICIAL	2026-01-29 23:28:25.646312	0	\N
1226	경상남도 합천군 합천읍 합천리 477-52	2026-01-29 23:28:25.646776	35.5692507	128.1600121	OFFICIAL	2026-01-29 23:28:25.646781	0	\N
1227	경상남도 합천군 합천읍 영창리 17-3	2026-01-29 23:28:25.64722	35.5820572	128.1680922	OFFICIAL	2026-01-29 23:28:25.647225	0	\N
1228	경상남도 합천군 합천읍 내곡리 655-1	2026-01-29 23:28:25.647668	35.6412923	128.1498421	OFFICIAL	2026-01-29 23:28:25.647672	0	\N
1229	경상남도 합천군 합천읍 합천리 360-9	2026-01-29 23:28:25.648112	35.5675636	128.1677421	OFFICIAL	2026-01-29 23:28:25.648118	0	\N
1230	경상남도 합천군 합천읍 인곡리 629	2026-01-29 23:28:25.648551	35.6052621	128.1000635	OFFICIAL	2026-01-29 23:28:25.648555	0	\N
1231	경상남도 합천군 합천읍 합천리 915-20	2026-01-29 23:28:25.648988	35.5612523	128.1555505	OFFICIAL	2026-01-29 23:28:25.648993	0	\N
1232	경상남도 합천군 합천읍 영창리 614-7	2026-01-29 23:28:25.649436	35.5715386	128.1611639	OFFICIAL	2026-01-29 23:28:25.649441	0	\N
1233	경상남도 합천군 합천읍 영창리 917	2026-01-29 23:28:25.649907	35.5738895	128.1555749	OFFICIAL	2026-01-29 23:28:25.649911	0	\N
1234	경상남도 합천군 합천읍 합천리 700-2	2026-01-29 23:28:25.650512	35.5636705	128.1604752	OFFICIAL	2026-01-29 23:28:25.650516	0	\N
1235	경상남도 합천군 합천읍 합천리 856-40	2026-01-29 23:28:25.651031	35.5631059	128.1579921	OFFICIAL	2026-01-29 23:28:25.651035	0	\N
1236	경상남도 합천군 합천읍 합천리 1013	2026-01-29 23:28:25.651502	35.5660291	128.1559569	OFFICIAL	2026-01-29 23:28:25.651507	0	\N
1237	경상남도 합천군 합천읍 대야로 890-10	2026-01-29 23:28:25.651978	35.5676137	128.1640905	OFFICIAL	2026-01-29 23:28:25.651983	0	\N
1238	경상남도 합천군 합천읍 합천리 1365-108	2026-01-29 23:28:25.652436	35.5677503	128.1562691	OFFICIAL	2026-01-29 23:28:25.65244	0	\N
1239	경상남도 합천군 합천읍 신소양1길 4	2026-01-29 23:28:25.65291	35.5788756	128.1679422	OFFICIAL	2026-01-29 23:28:25.652915	0	\N
1240	경상남도 합천군 합천읍 합천리 976-22	2026-01-29 23:28:25.653356	35.5642986	128.1557771	OFFICIAL	2026-01-29 23:28:25.65336	0	\N
1241	경상남도 합천군 합천읍 합천리 978-10	2026-01-29 23:28:25.653828	35.5652272	128.1556906	OFFICIAL	2026-01-29 23:28:25.653833	0	\N
1242	경상남도 합천군 합천읍 합천리 655-8	2026-01-29 23:28:25.654265	35.5678971	128.1611125	OFFICIAL	2026-01-29 23:28:25.654269	0	\N
1243	경상남도 합천군 합천읍 합천리 249-3	2026-01-29 23:28:25.654701	35.5630465	128.1620404	OFFICIAL	2026-01-29 23:28:25.654706	0	\N
1244	경상남도 합천군 합천읍 합천리 539-2	2026-01-29 23:28:25.655222	35.5668751	128.1568962	OFFICIAL	2026-01-29 23:28:25.655227	0	\N
1245	경상남도 합천군 합천읍 중앙로 75	2026-01-29 23:28:25.655714	35.5674951	128.1585081	OFFICIAL	2026-01-29 23:28:25.655719	0	\N
1246	경상남도 합천군 용주면 가호리 633-4	2026-01-29 23:28:25.656207	35.5508604	128.0662891	OFFICIAL	2026-01-29 23:28:25.656211	0	\N
1247	경상남도 합천군 용주면 평산리 378	2026-01-29 23:28:25.65665	35.5255736	128.1175514	OFFICIAL	2026-01-29 23:28:25.656656	0	\N
1248	경상남도 합천군 용주면 우곡리 283-5	2026-01-29 23:28:25.657138	35.5733782	128.0789623	OFFICIAL	2026-01-29 23:28:25.657143	0	\N
1249	경상남도 합천군 용주면 고품리 1183-1	2026-01-29 23:28:25.657592	35.5396552	128.0947657	OFFICIAL	2026-01-29 23:28:25.657597	0	\N
1250	경상남도 합천군 대병면 유전리 1236	2026-01-29 23:28:25.658031	35.5326433	128.0087782	OFFICIAL	2026-01-29 23:28:25.658035	0	\N
1251	경상남도 합천군 대병면 송리 480	2026-01-29 23:28:25.658467	35.5431461	128.0428579	OFFICIAL	2026-01-29 23:28:25.658471	0	\N
1252	경상남도 합천군 대병면 회양리 418-2	2026-01-29 23:28:25.659027	35.5196704	128.0233965	OFFICIAL	2026-01-29 23:28:25.659031	0	\N
1253	서울특별시 성북구 보문로 52 서울특별시 성북구 보문동7가 104	2026-01-29 23:28:25.659492	37.58021816	127.0226114	OFFICIAL	2026-01-29 23:28:25.659497	0	\N
1254	경상남도 합천군 봉산면 계산리 616-3	2026-01-29 23:28:25.659975	35.6005987	128.0655355	OFFICIAL	2026-01-29 23:28:25.65998	0	\N
1255	경상남도 합천군 봉산면 계산리 1252-1	2026-01-29 23:28:25.660543	35.5996091	128.0619478	OFFICIAL	2026-01-29 23:28:25.660547	0	\N
1256	경상남도 합천군 봉산면 계산리 616-3	2026-01-29 23:28:25.660988	35.6005987	128.0655355	OFFICIAL	2026-01-29 23:28:25.660993	0	\N
1257	경상남도 합천군 봉산면 계산리 406	2026-01-29 23:28:25.661424	35.6112793	128.0667032	OFFICIAL	2026-01-29 23:28:25.661429	0	\N
1258	경상남도 합천군 합천읍 서산리 361-4	2026-01-29 23:28:25.661904	35.5917959	128.1282751	OFFICIAL	2026-01-29 23:28:25.661909	0	\N
1259	경상남도 합천군 합천읍 합천리 420-49	2026-01-29 23:28:25.662358	35.5697581	128.1648011	OFFICIAL	2026-01-29 23:28:25.662363	0	\N
1260	경상남도 합천군 합천읍 영창리 535-9	2026-01-29 23:28:25.66283	35.5728792	128.1629981	OFFICIAL	2026-01-29 23:28:25.662835	0	\N
1261	경상남도 합천군 합천읍 합천리 420-49	2026-01-29 23:28:25.663313	35.5697581	128.1648011	OFFICIAL	2026-01-29 23:28:25.663318	0	\N
1262	경상남도 합천군 합천읍 동서로 141-17	2026-01-29 23:28:25.663762	35.5669335	128.1671451	OFFICIAL	2026-01-29 23:28:25.663768	0	\N
1263	경상남도 합천군 합천읍 금양리 355	2026-01-29 23:28:25.664238	35.5921362	128.1733111	OFFICIAL	2026-01-29 23:28:25.664243	0	\N
1264	경상남도 합천군 합천읍 합천리 702-3	2026-01-29 23:28:25.664885	35.5636356	128.1595926	OFFICIAL	2026-01-29 23:28:25.664889	0	\N
1265	경상남도 합천군 합천읍 핫들1로 50	2026-01-29 23:28:25.665452	35.5726233	128.1655681	OFFICIAL	2026-01-29 23:28:25.665457	0	\N
1266	경상남도 합천군 합천읍 합천리 1162-2	2026-01-29 23:28:25.666044	35.5682947	128.1535011	OFFICIAL	2026-01-29 23:28:25.666049	0	\N
1267	경상남도 합천군 합천읍 합천리 817-1	2026-01-29 23:28:25.666534	35.5645114	128.1584802	OFFICIAL	2026-01-29 23:28:25.666539	0	\N
1268	경상남도 합천군 합천읍 합천리 725-1	2026-01-29 23:28:25.666982	35.5665201	128.1595211	OFFICIAL	2026-01-29 23:28:25.666986	0	\N
1269	경상남도 합천군 합천읍 합천리 415-2	2026-01-29 23:28:25.667426	35.5686973	128.1626696	OFFICIAL	2026-01-29 23:28:25.66743	0	\N
1270	경상남도 합천군 합천읍 합천리 417-13	2026-01-29 23:28:25.667905	35.5691759	128.1619976	OFFICIAL	2026-01-29 23:28:25.66791	0	\N
1271	경상남도 합천군 합천읍 합천리 959-7	2026-01-29 23:28:25.668385	35.5619628	128.1567874	OFFICIAL	2026-01-29 23:28:25.66839	0	\N
1272	경상남도 합천군 합천읍 서산리 534-1	2026-01-29 23:28:25.668863	35.5962612	128.1487871	OFFICIAL	2026-01-29 23:28:25.668867	0	\N
1273	경상남도 합천군 합천읍 용계리 424-6	2026-01-29 23:28:25.669342	35.6287813	128.1702545	OFFICIAL	2026-01-29 23:28:25.669346	0	\N
1274	경상남도 합천군 합천읍 합천리 702-3	2026-01-29 23:28:25.669866	35.5636356	128.1595926	OFFICIAL	2026-01-29 23:28:25.66987	0	\N
1275	경상남도 합천군 합천읍 합천리 850-2	2026-01-29 23:28:25.67034	35.5629436	128.1580689	OFFICIAL	2026-01-29 23:28:25.670345	0	\N
1276	경상남도 합천군 합천읍 합천리 1227-6	2026-01-29 23:28:25.670838	35.5681833	128.1559831	OFFICIAL	2026-01-29 23:28:25.670843	0	\N
1277	경상남도 합천군 합천읍 합천리 981-3	2026-01-29 23:28:25.671394	35.5650907	128.1566391	OFFICIAL	2026-01-29 23:28:25.671398	0	\N
1278	경상남도 합천군 합천읍 합천리 952-2	2026-01-29 23:28:25.671892	35.5630457	128.1557746	OFFICIAL	2026-01-29 23:28:25.671897	0	\N
1279	경상남도 합천군 합천읍 합천리 697-4	2026-01-29 23:28:25.672537	35.5646801	128.1604331	OFFICIAL	2026-01-29 23:28:25.672542	0	\N
1280	경상남도 합천군 합천읍 합천리 154-4	2026-01-29 23:28:25.67319	35.5655525	128.1684771	OFFICIAL	2026-01-29 23:28:25.673198	0	\N
1281	경상남도 합천군 합천읍 합천리 418-18	2026-01-29 23:28:25.674113	35.5693359	128.1636307	OFFICIAL	2026-01-29 23:28:25.674118	0	\N
1282	경상남도 합천군 합천읍 용계리 963	2026-01-29 23:28:25.674652	35.6367407	128.1634919	OFFICIAL	2026-01-29 23:28:25.674657	0	\N
1283	경상남도 합천군 합천읍 외곡리 933-3	2026-01-29 23:28:25.675751	35.6279934	128.1379159	OFFICIAL	2026-01-29 23:28:25.675757	0	\N
1284	경상남도 합천군 율곡면 영전리 74-4	2026-01-29 23:28:25.676342	35.5682415	128.2070949	OFFICIAL	2026-01-29 23:28:25.676353	0	\N
1285	경상남도 합천군 율곡면 갑산2길 14-6	2026-01-29 23:28:25.676994	35.5897028	128.2457175	OFFICIAL	2026-01-29 23:28:25.677	0	\N
1286	경상남도 합천군 율곡면 내천리 594-6	2026-01-29 23:28:25.677594	35.6109354	128.2386188	OFFICIAL	2026-01-29 23:28:25.677601	0	\N
1287	경상남도 합천군 야로면 구정리 51-4	2026-01-29 23:28:25.678224	35.7028518	128.1726221	OFFICIAL	2026-01-29 23:28:25.67823	0	\N
1288	경상남도 합천군 야로면 나대길 112	2026-01-29 23:28:25.678821	35.7350301	128.1663016	OFFICIAL	2026-01-29 23:28:25.678826	0	\N
1289	경상남도 합천군 야로면 창동청계길 281	2026-01-29 23:28:25.679303	35.7115511	128.2009554	OFFICIAL	2026-01-29 23:28:25.679308	0	\N
1290	경상남도 합천군 야로면 하림리 109-4	2026-01-29 23:28:25.679807	35.7481862	128.1554822	OFFICIAL	2026-01-29 23:28:25.679812	0	\N
1291	경상남도 합천군 야로면 월광리 69-2	2026-01-29 23:28:25.68028	35.7305354	128.1573051	OFFICIAL	2026-01-29 23:28:25.680285	0	\N
1292	경상남도 합천군 야로면 금평리 114	2026-01-29 23:28:25.680839	35.7080143	128.1862262	OFFICIAL	2026-01-29 23:28:25.680844	0	\N
1293	경상남도 합천군 야로면 정대리 520-3	2026-01-29 23:28:25.681344	35.6965222	128.1677244	OFFICIAL	2026-01-29 23:28:25.68135	0	\N
1294	경상남도 합천군 가야면 구미2길 114-7	2026-01-29 23:28:25.681832	35.7442631	128.1082198	OFFICIAL	2026-01-29 23:28:25.681837	0	\N
1295	경상남도 합천군 가야면 매화산로 659	2026-01-29 23:28:25.682314	35.7749818	128.1258921	OFFICIAL	2026-01-29 23:28:25.682319	0	\N
1296	경상남도 합천군 묘산면 안성리 506-2	2026-01-29 23:28:25.682881	35.6722268	128.1265811	OFFICIAL	2026-01-29 23:28:25.682886	0	\N
1297	경상남도 합천군 묘산면 봉곡리 105	2026-01-29 23:28:25.683381	35.6378352	128.1130008	OFFICIAL	2026-01-29 23:28:25.683386	0	\N
1298	경상남도 합천군 묘산면 묘산로 163	2026-01-29 23:28:25.683868	35.6580171	128.1126426	OFFICIAL	2026-01-29 23:28:25.683873	0	\N
1299	경상남도 합천군 묘산면 화양리 870	2026-01-29 23:28:25.684321	35.6957525	128.1263309	OFFICIAL	2026-01-29 23:28:25.684326	0	\N
1300	경상남도 합천군 묘산면 양지리 671	2026-01-29 23:28:25.684789	35.6431567	128.1187613	OFFICIAL	2026-01-29 23:28:25.684794	0	\N
1301	경상남도 합천군 묘산면 거산리 605-3	2026-01-29 23:28:25.685221	35.6786502	128.1454709	OFFICIAL	2026-01-29 23:28:25.685225	0	\N
1302	경상남도 합천군 묘산면 관기리 280-2	2026-01-29 23:28:25.685644	35.6499951	128.1304884	OFFICIAL	2026-01-29 23:28:25.685649	0	\N
1303	경상남도 합천군 묘산면 화양리 353-3	2026-01-29 23:28:25.686062	35.6814755	128.1341633	OFFICIAL	2026-01-29 23:28:25.686067	0	\N
1304	경상남도 합천군 묘산면 도옥리 156-410	2026-01-29 23:28:25.6865	35.6624522	128.1215622	OFFICIAL	2026-01-29 23:28:25.686505	0	\N
1305	경상남도 합천군 묘산면 거산리 525-2	2026-01-29 23:28:25.686975	35.6804291	128.1502356	OFFICIAL	2026-01-29 23:28:25.68698	0	\N
1306	경상남도 합천군 묘산면 관기리 639-3	2026-01-29 23:28:25.68742	35.6479709	128.1267746	OFFICIAL	2026-01-29 23:28:25.687425	0	\N
1307	경상남도 합천군 묘산면 산제리 462	2026-01-29 23:28:25.68786	35.6613493	128.1057995	OFFICIAL	2026-01-29 23:28:25.687865	0	\N
1308	경상남도 합천군 묘산면 광산리 272	2026-01-29 23:28:25.688379	35.6429674	128.1188273	OFFICIAL	2026-01-29 23:28:25.688384	0	\N
1309	경상남도 합천군 묘산면 팔심리 480-10	2026-01-29 23:28:25.688866	35.6241789	128.0924807	OFFICIAL	2026-01-29 23:28:25.688871	0	\N
1310	경상남도 합천군 봉산면 압곡리 167-4	2026-01-29 23:28:25.689365	35.6384065	128.0570973	OFFICIAL	2026-01-29 23:28:25.68937	0	\N
1311	경상남도 합천군 봉산면 압곡리 582	2026-01-29 23:28:25.689852	35.6475205	128.0544203	OFFICIAL	2026-01-29 23:28:25.689857	0	\N
1312	경상남도 합천군 봉산면 술곡리 516-6	2026-01-29 23:28:25.690298	35.5764954	127.9914718	OFFICIAL	2026-01-29 23:28:25.690304	0	\N
1313	경상남도 합천군 봉산면 계산리 136	2026-01-29 23:28:25.690782	35.5904741	128.0696654	OFFICIAL	2026-01-29 23:28:25.690787	0	\N
1314	서울특별시 노원구 동일로228길 23	2026-01-29 23:28:25.691247	37.66985723	127.0587456	OFFICIAL	2026-01-29 23:28:25.691285	0	\N
1315	서울특별시 성북구 성북동 118-2	2026-01-29 23:28:25.691727	37.59249965	126.9977895	OFFICIAL	2026-01-29 23:28:25.691732	0	\N
1316	경상남도 합천군 적중면 죽고리 342-3	2026-01-29 23:28:25.692214	35.5663139	128.3006726	OFFICIAL	2026-01-29 23:28:25.692243	0	\N
1317	경상남도 합천군 적중면 죽고리 50-1	2026-01-29 23:28:25.692708	35.5638488	128.3059585	OFFICIAL	2026-01-29 23:28:25.692714	0	\N
1318	경상남도 합천군 적중면 황정리 227-6	2026-01-29 23:28:25.693185	35.5356957	128.2851859	OFFICIAL	2026-01-29 23:28:25.69319	0	\N
1319	경상남도 합천군 적중면 정토리 218-5	2026-01-29 23:28:25.693626	35.5299091	128.2569699	OFFICIAL	2026-01-29 23:28:25.693631	0	\N
1320	경상남도 합천군 덕곡면 율지리 86	2026-01-29 23:28:25.694046	35.6145942	128.3588821	OFFICIAL	2026-01-29 23:28:25.69405	0	\N
1321	경상남도 합천군 덕곡면 율지리 314-1	2026-01-29 23:28:25.694486	35.6135357	128.3540977	OFFICIAL	2026-01-29 23:28:25.694491	0	\N
1322	경상남도 합천군 덕곡면 율원리 562	2026-01-29 23:28:25.694955	35.6385662	128.2902215	OFFICIAL	2026-01-29 23:28:25.694959	0	\N
1323	경상남도 합천군 쌍책면 진정리 499	2026-01-29 23:28:25.695391	35.5923448	128.2899111	OFFICIAL	2026-01-29 23:28:25.695396	0	\N
1324	경상남도 합천군 쌍책면 다라리 473-2	2026-01-29 23:28:25.695861	35.5809782	128.2900357	OFFICIAL	2026-01-29 23:28:25.695865	0	\N
1325	경상남도 합천군 쌍책면 성산리 150-10	2026-01-29 23:28:25.696302	35.5777911	128.2847282	OFFICIAL	2026-01-29 23:28:25.696307	0	\N
1326	경상남도 합천군 쌍책면 성산리 58-4	2026-01-29 23:28:25.696743	35.5753277	128.2858117	OFFICIAL	2026-01-29 23:28:25.696776	0	\N
1327	경상남도 합천군 초계면 초계3길 4	2026-01-29 23:28:25.697219	35.5586361	128.2693277	OFFICIAL	2026-01-29 23:28:25.697223	0	\N
1328	경상남도 합천군 초계면 초계2길 12-11	2026-01-29 23:28:25.697675	35.5581462	128.2667008	OFFICIAL	2026-01-29 23:28:25.69768	0	\N
1329	경상남도 합천군 초계면 초계리 250-1	2026-01-29 23:28:25.698152	35.5604521	128.2633991	OFFICIAL	2026-01-29 23:28:25.698156	0	\N
1330	경상남도 합천군 초계면 초계리 25-4	2026-01-29 23:28:25.698595	35.5582596	128.2684109	OFFICIAL	2026-01-29 23:28:25.6986	0	\N
1331	경상남도 합천군 초계면 초계리 47	2026-01-29 23:28:25.699066	35.5601085	128.2679427	OFFICIAL	2026-01-29 23:28:25.69907	0	\N
1332	경상남도 합천군 초계면 중리 380-21	2026-01-29 23:28:25.699508	35.5590822	128.2505437	OFFICIAL	2026-01-29 23:28:25.699514	0	\N
1333	경상남도 합천군 초계면 초계리 117-1	2026-01-29 23:28:25.700022	35.5588574	128.2671112	OFFICIAL	2026-01-29 23:28:25.700027	0	\N
1334	경상남도 합천군 초계면 아막재로 19	2026-01-29 23:28:25.700474	35.5609194	128.2680557	OFFICIAL	2026-01-29 23:28:25.70048	0	\N
1335	경상남도 합천군 초계면 초계리 96-6	2026-01-29 23:28:25.701026	35.5590503	128.2654793	OFFICIAL	2026-01-29 23:28:25.701031	0	\N
1336	경상남도 합천군 초계면 아막재로 38	2026-01-29 23:28:25.70149	35.5623961	128.2687997	OFFICIAL	2026-01-29 23:28:25.701494	0	\N
1337	경상남도 합천군 초계면 초계중앙로 78	2026-01-29 23:28:25.701953	35.5590434	128.2685679	OFFICIAL	2026-01-29 23:28:25.701958	0	\N
1338	경상남도 합천군 초계면 초계중앙로 9	2026-01-29 23:28:25.702399	35.5592669	128.2612332	OFFICIAL	2026-01-29 23:28:25.702404	0	\N
1339	경상남도 합천군 율곡면 영전리 74-4	2026-01-29 23:28:25.702867	35.5682415	128.2070949	OFFICIAL	2026-01-29 23:28:25.702871	0	\N
1340	경상남도 합천군 율곡면 임북공단길 12-9	2026-01-29 23:28:25.703305	35.5792903	128.1803668	OFFICIAL	2026-01-29 23:28:25.703311	0	\N
1341	경상남도 합천군 율곡면 제내리 439	2026-01-29 23:28:25.703852	35.5849868	128.2084181	OFFICIAL	2026-01-29 23:28:25.703857	0	\N
1342	경상남도 합천군 율곡면 문림리 327-4	2026-01-29 23:28:25.704315	35.5690861	128.1924242	OFFICIAL	2026-01-29 23:28:25.704319	0	\N
1343	경상남도 합천군 율곡면 낙민리 655-1	2026-01-29 23:28:25.704776	35.5800264	128.2250218	OFFICIAL	2026-01-29 23:28:25.70478	0	\N
1344	경상남도 합천군 율곡면 영전리 455-1	2026-01-29 23:28:25.705218	35.5724136	128.2180941	OFFICIAL	2026-01-29 23:28:25.705223	0	\N
1345	서울특별시 노원구 동일로 1456	2026-01-29 23:28:25.705663	37.66067691	127.0614956	OFFICIAL	2026-01-29 23:28:25.705667	0	\N
1346	경상남도 합천군 삼가면 양전리 207	2026-01-29 23:28:25.706128	35.4259488	128.1375045	OFFICIAL	2026-01-29 23:28:25.706133	0	\N
1347	경상남도 합천군 삼가면 동리 944	2026-01-29 23:28:25.706567	35.4189365	128.1447273	OFFICIAL	2026-01-29 23:28:25.706571	0	\N
1348	경상남도 합천군 삼가면 금리 12-8	2026-01-29 23:28:25.706989	35.4162979	128.1263777	OFFICIAL	2026-01-29 23:28:25.706995	0	\N
1349	경상남도 합천군 삼가면 학리 608-2	2026-01-29 23:28:25.707468	35.3968695	128.0896664	OFFICIAL	2026-01-29 23:28:25.707473	0	\N
1350	경상남도 합천군 삼가면 동리 135-6	2026-01-29 23:28:25.707928	35.4188643	128.1447822	OFFICIAL	2026-01-29 23:28:25.707933	0	\N
1351	경상남도 합천군 삼가면 하판리 1899	2026-01-29 23:28:25.70837	35.4240651	128.1111267	OFFICIAL	2026-01-29 23:28:25.708375	0	\N
1352	경상남도 합천군 삼가면 양천강변길 130-43	2026-01-29 23:28:25.708829	35.4096606	128.1292081	OFFICIAL	2026-01-29 23:28:25.708834	0	\N
1353	경상남도 합천군 삼가면 삼가중앙길 32-3	2026-01-29 23:28:25.70927	35.4141288	128.1232802	OFFICIAL	2026-01-29 23:28:25.709275	0	\N
1354	경상남도 합천군 쌍백면 평지리 578-5	2026-01-29 23:28:25.709706	35.4402801	128.1732162	OFFICIAL	2026-01-29 23:28:25.70971	0	\N
1355	경상남도 합천군 쌍백면 대곡리 577-1	2026-01-29 23:28:25.710169	35.4687129	128.1893531	OFFICIAL	2026-01-29 23:28:25.710174	0	\N
1356	경상남도 합천군 쌍백면 외초리 123	2026-01-29 23:28:25.710605	35.4110224	128.1720415	OFFICIAL	2026-01-29 23:28:25.71061	0	\N
1357	경상남도 합천군 쌍백면 평구리 1328-13	2026-01-29 23:28:25.711038	35.4394346	128.1444776	OFFICIAL	2026-01-29 23:28:25.711043	0	\N
1358	경상남도 합천군 쌍백면 평구리 570-2	2026-01-29 23:28:25.711472	35.4386421	128.1439035	OFFICIAL	2026-01-29 23:28:25.711477	0	\N
1359	경상남도 합천군 쌍백면 외초리 1062-2	2026-01-29 23:28:25.711934	35.4123892	128.1680035	OFFICIAL	2026-01-29 23:28:25.711939	0	\N
1360	경상남도 합천군 쌍백면 평구리 306-7	2026-01-29 23:28:25.712366	35.4402859	128.1485986	OFFICIAL	2026-01-29 23:28:25.712371	0	\N
1361	경상남도 합천군 쌍백면 평구리 1328-13	2026-01-29 23:28:25.712869	35.4394346	128.1444776	OFFICIAL	2026-01-29 23:28:25.712873	0	\N
1362	경상남도 합천군 대양면 덕정리 959	2026-01-29 23:28:25.713305	35.5134282	128.1730314	OFFICIAL	2026-01-29 23:28:25.71331	0	\N
1363	경상남도 합천군 대양면 안금리 815	2026-01-29 23:28:25.713745	35.4901316	128.1824047	OFFICIAL	2026-01-29 23:28:25.713778	0	\N
1364	경상남도 합천군 대양면 대목리 61	2026-01-29 23:28:25.714213	35.5276044	128.1684969	OFFICIAL	2026-01-29 23:28:25.714218	0	\N
1365	경상남도 합천군 대양면 양산리 568-5	2026-01-29 23:28:25.714655	35.5033944	128.1676416	OFFICIAL	2026-01-29 23:28:25.71466	0	\N
1366	경상남도 합천군 대양면 양산리 757	2026-01-29 23:28:25.715582	35.5038536	128.1743778	OFFICIAL	2026-01-29 23:28:25.715588	0	\N
1367	경상남도 합천군 대양면 양산리 923	2026-01-29 23:28:25.716062	35.5081735	128.1789399	OFFICIAL	2026-01-29 23:28:25.716066	0	\N
1368	경상남도 합천군 대양면 무곡리 695	2026-01-29 23:28:25.716507	35.5224481	128.1928972	OFFICIAL	2026-01-29 23:28:25.716512	0	\N
1369	경상남도 합천군 대양면 무곡리 984	2026-01-29 23:28:25.716972	35.5213401	128.1866761	OFFICIAL	2026-01-29 23:28:25.716977	0	\N
1370	경상남도 합천군 대양면 도리 109	2026-01-29 23:28:25.717434	35.5007996	128.1531852	OFFICIAL	2026-01-29 23:28:25.717439	0	\N
1371	경상남도 합천군 청덕면 성태리 1023-5	2026-01-29 23:28:25.717869	35.5774253	128.3157525	OFFICIAL	2026-01-29 23:28:25.717874	0	\N
1372	경상남도 합천군 청덕면 앙진리 산91-1	2026-01-29 23:28:25.718314	35.5044503	128.3575646	OFFICIAL	2026-01-29 23:28:25.718319	0	\N
1373	경상남도 합천군 청덕면 두곡리 311-6	2026-01-29 23:28:25.718787	35.5540395	128.3173263	OFFICIAL	2026-01-29 23:28:25.718792	0	\N
1374	경상남도 합천군 청덕면 가현리 498-26	2026-01-29 23:28:25.719266	35.5672573	128.3294253	OFFICIAL	2026-01-29 23:28:25.719286	0	\N
1375	경상남도 합천군 청덕면 두곡리 299-9	2026-01-29 23:28:25.719727	35.5539554	128.3184731	OFFICIAL	2026-01-29 23:28:25.719732	0	\N
1376	서울특별시 노원구 노원로16길 15	2026-01-29 23:28:25.720174	37.64344507	127.0733372	OFFICIAL	2026-01-29 23:28:25.720179	0	\N
1377	경상남도 합천군 용주면 방곡리 315	2026-01-29 23:28:25.720618	35.5779505	128.1000185	OFFICIAL	2026-01-29 23:28:25.720622	0	\N
1378	경상남도 합천군 용주면 용지리 460-4	2026-01-29 23:28:25.721127	35.5395229	128.1123334	OFFICIAL	2026-01-29 23:28:25.721131	0	\N
1379	경상남도 합천군 대병면 성리 황계폭포로 129	2026-01-29 23:28:25.721565	35.5210915	128.0588774	OFFICIAL	2026-01-29 23:28:25.72157	0	\N
1380	경상남도 합천군 대병면 하금리 산109-4	2026-01-29 23:28:25.721992	35.5158123	127.9757126	OFFICIAL	2026-01-29 23:28:25.721997	0	\N
1381	경상남도 합천군 대병면 하금리 산111-4	2026-01-29 23:28:25.722433	35.5160187	127.9713026	OFFICIAL	2026-01-29 23:28:25.722438	0	\N
1382	경상남도 합천군 대병면 하금리 323-1	2026-01-29 23:28:25.722889	35.5302549	127.9963506	OFFICIAL	2026-01-29 23:28:25.722894	0	\N
1383	경상남도 합천군 대병면 하금리 307-7	2026-01-29 23:28:25.72338	35.5299032	127.9936491	OFFICIAL	2026-01-29 23:28:25.723386	0	\N
1384	경상남도 합천군 대병면 성리 1182-2	2026-01-29 23:28:25.723948	35.5233761	128.0498047	OFFICIAL	2026-01-29 23:28:25.723952	0	\N
1385	경상남도 합천군 가회면 외사리 609-3	2026-01-29 23:28:25.724396	35.4259144	128.0737963	OFFICIAL	2026-01-29 23:28:25.7244	0	\N
1386	경상남도 합천군 가회면 월계리 504-4	2026-01-29 23:28:25.724863	35.4848477	128.0568122	OFFICIAL	2026-01-29 23:28:25.724868	0	\N
1387	경상남도 합천군 가회면 둔내리 761-3	2026-01-29 23:28:25.72531	35.4713937	128.0120221	OFFICIAL	2026-01-29 23:28:25.725315	0	\N
1388	경상남도 합천군 가회면 함방리 441	2026-01-29 23:28:25.725791	35.4266174	128.0331819	OFFICIAL	2026-01-29 23:28:25.725795	0	\N
1389	경상남도 합천군 가회면 중촌리 572-8	2026-01-29 23:28:25.726227	35.4533932	128.0079544	OFFICIAL	2026-01-29 23:28:25.726232	0	\N
1390	경상남도 합천군 삼가면 모의로 59	2026-01-29 23:28:25.726661	35.3841851	128.1224862	OFFICIAL	2026-01-29 23:28:25.726666	0	\N
1391	경상남도 합천군 삼가면 덕진리 448	2026-01-29 23:28:25.727122	35.4126517	128.0786071	OFFICIAL	2026-01-29 23:28:25.727127	0	\N
1392	경상남도 합천군 삼가면 덕진리 497-1	2026-01-29 23:28:25.727549	35.4108067	128.0875458	OFFICIAL	2026-01-29 23:28:25.727553	0	\N
1393	경상남도 합천군 삼가면 소오리 398-5	2026-01-29 23:28:25.727996	35.4118985	128.1180798	OFFICIAL	2026-01-29 23:28:25.728	0	\N
1394	경상남도 합천군 삼가면 일부리 921-5	2026-01-29 23:28:25.728448	35.4125519	128.1227383	OFFICIAL	2026-01-29 23:28:25.728453	0	\N
1395	경상남도 합천군 삼가면 금리4길 56-10	2026-01-29 23:28:25.728902	35.4156429	128.1234697	OFFICIAL	2026-01-29 23:28:25.728907	0	\N
1396	경상남도 합천군 삼가면 용흥길 20	2026-01-29 23:28:25.729339	35.4079835	128.1210468	OFFICIAL	2026-01-29 23:28:25.729344	0	\N
1397	경상남도 합천군 삼가면 일부리 826-2	2026-01-29 23:28:25.729809	35.4130733	128.1240934	OFFICIAL	2026-01-29 23:28:25.729814	0	\N
1398	경상남도 합천군 삼가면 금리 621	2026-01-29 23:28:25.73024	35.4151874	128.1192628	OFFICIAL	2026-01-29 23:28:25.730245	0	\N
1399	경상남도 합천군 삼가면 금리 63-1	2026-01-29 23:28:25.730666	35.4140043	128.1215623	OFFICIAL	2026-01-29 23:28:25.730671	0	\N
1400	경상남도 합천군 삼가면 두모리 220-1	2026-01-29 23:28:25.73112	35.4144484	128.0991664	OFFICIAL	2026-01-29 23:28:25.731125	0	\N
1401	경상남도 합천군 삼가면 두모리 437	2026-01-29 23:28:25.731545	35.4136579	128.0957741	OFFICIAL	2026-01-29 23:28:25.73155	0	\N
1402	경상남도 합천군 삼가면 소오리 820	2026-01-29 23:28:25.732025	35.4072185	128.1198345	OFFICIAL	2026-01-29 23:28:25.73203	0	\N
1403	경상남도 합천군 삼가면 소오리 산1	2026-01-29 23:28:25.732456	35.4067252	128.1172905	OFFICIAL	2026-01-29 23:28:25.73246	0	\N
1404	경상남도 합천군 삼가면 일부리 920-1	2026-01-29 23:28:25.732909	35.4128501	128.1220891	OFFICIAL	2026-01-29 23:28:25.732913	0	\N
1405	경상남도 합천군 삼가면 외토리 577-2	2026-01-29 23:28:25.733337	35.3834557	128.1021774	OFFICIAL	2026-01-29 23:28:25.733341	0	\N
1406	경상남도 합천군 삼가면 외토리 810	2026-01-29 23:28:25.733826	35.3840725	128.0974782	OFFICIAL	2026-01-29 23:28:25.73383	0	\N
1407	서울특별시 노원구 동일로203가길 29	2026-01-29 23:28:25.734299	37.63987596	127.0642838	OFFICIAL	2026-01-29 23:28:25.734303	0	\N
1408	경상북도 영덕군 영덕읍 강변길 52 경상북도 영덕군 영덕읍 덕곡리 151-3	2026-01-29 23:28:25.73479	36.41146889	129.3709522	OFFICIAL	2026-01-29 23:28:25.734796	0	\N
1409	경상북도 영덕군 영덕읍 덕곡리 197-7	2026-01-29 23:28:25.736338	36.4154975	129.3720899	OFFICIAL	2026-01-29 23:28:25.736344	0	\N
1410	경상북도 영덕군 영덕읍 덕곡리 135-8	2026-01-29 23:28:25.738177	36.41173387	129.3729662	OFFICIAL	2026-01-29 23:28:25.738183	0	\N
1411	경상북도 영덕군 영덕읍 군청길 86 경상북도 영덕군 영덕읍 덕곡리 186	2026-01-29 23:28:25.738897	36.41450621	129.3697335	OFFICIAL	2026-01-29 23:28:25.738902	0	\N
1412	경상북도 영덕군 영덕읍 덕곡리 323-1	2026-01-29 23:28:25.739535	36.415978	129.3726013	OFFICIAL	2026-01-29 23:28:25.73954	0	\N
1413	경상북도 영덕군 영덕읍 남석리 317	2026-01-29 23:28:25.740169	36.40874402	129.3705972	OFFICIAL	2026-01-29 23:28:25.740174	0	\N
1414	경상북도 영덕군 영덕읍 남석리 52-2	2026-01-29 23:28:25.740647	36.40914594	129.3683437	OFFICIAL	2026-01-29 23:28:25.740652	0	\N
1415	경상북도 영덕군 영덕읍 미듬길 8 경상북도 영덕군 영덕읍 화개리 46-2	2026-01-29 23:28:25.741119	36.41772104	129.3724181	OFFICIAL	2026-01-29 23:28:25.741124	0	\N
1416	경상남도 합천군 합천읍 충효로 13	2026-01-29 23:28:25.741677	35.5615893	128.1597651	OFFICIAL	2026-01-29 23:28:25.741683	0	\N
1417	경상남도 합천군 합천읍 동서로 15	2026-01-29 23:28:25.742188	35.5687981	128.1545722	OFFICIAL	2026-01-29 23:28:25.742193	0	\N
1418	경상남도 합천군 합천읍 대야로 883	2026-01-29 23:28:25.742653	35.5672187	128.1629204	OFFICIAL	2026-01-29 23:28:25.742659	0	\N
1419	경상남도 합천군 용주면 성산리 745	2026-01-29 23:28:25.743131	35.5571132	128.1344962	OFFICIAL	2026-01-29 23:28:25.743137	0	\N
1420	경상남도 합천군 용주면 우곡리 577	2026-01-29 23:28:25.743612	35.5683339	128.0734633	OFFICIAL	2026-01-29 23:28:25.743616	0	\N
1421	경상남도 합천군 용주면 고품리 산43-3	2026-01-29 23:28:25.744067	35.5389888	128.0939929	OFFICIAL	2026-01-29 23:28:25.744072	0	\N
1422	경상남도 합천군 용주면 손목리 510	2026-01-29 23:28:25.74448	35.5564812	128.1271709	OFFICIAL	2026-01-29 23:28:25.744485	0	\N
1423	경상남도 합천군 용주면 노리팔산길 68	2026-01-29 23:28:25.744952	35.5235398	128.1232378	OFFICIAL	2026-01-29 23:28:25.744956	0	\N
1424	경상남도 합천군 용주면 죽죽리 330-1	2026-01-29 23:28:25.745404	35.5520975	128.0409655	OFFICIAL	2026-01-29 23:28:25.745408	0	\N
1425	경상남도 합천군 용주면 고품리 산12-43	2026-01-29 23:28:25.745927	35.5560487	128.1085399	OFFICIAL	2026-01-29 23:28:25.745931	0	\N
1426	경상남도 합천군 용주면 성산리 548	2026-01-29 23:28:25.74641	35.5574797	128.1372655	OFFICIAL	2026-01-29 23:28:25.746415	0	\N
1427	경상남도 합천군 용주면 방곡리 539-2	2026-01-29 23:28:25.746926	35.5694277	128.1056564	OFFICIAL	2026-01-29 23:28:25.746931	0	\N
1428	경상남도 합천군 용주면 공암리 164-1	2026-01-29 23:28:25.74735	35.5023756	128.1036726	OFFICIAL	2026-01-29 23:28:25.747355	0	\N
1429	경상남도 합천군 용주면 월평리 809-3	2026-01-29 23:28:25.747785	35.5660551	128.1169817	OFFICIAL	2026-01-29 23:28:25.74779	0	\N
1430	경상남도 합천군 묘산면 화양리 862	2026-01-29 23:28:25.748196	35.6956171	128.1266069	OFFICIAL	2026-01-29 23:28:25.748201	0	\N
1431	경상남도 합천군 묘산면 반포리 124-1	2026-01-29 23:28:25.748605	35.6491805	128.0955574	OFFICIAL	2026-01-29 23:28:25.748611	0	\N
1432	경상남도 합천군 묘산면 산제리 278-4	2026-01-29 23:28:25.749046	35.6576253	128.1074291	OFFICIAL	2026-01-29 23:28:25.749051	0	\N
1433	경상남도 합천군 묘산면 거산리 679-11	2026-01-29 23:28:25.749458	35.6794919	128.1499466	OFFICIAL	2026-01-29 23:28:25.749462	0	\N
1434	경상남도 합천군 묘산면 거산리 405-3	2026-01-29 23:28:25.749884	35.6714026	128.1460101	OFFICIAL	2026-01-29 23:28:25.749888	0	\N
1435	경상남도 합천군 묘산면 화양리 327-3	2026-01-29 23:28:25.750297	35.6821771	128.1355344	OFFICIAL	2026-01-29 23:28:25.750301	0	\N
1436	경상남도 합천군 묘산면 관기리 281-3	2026-01-29 23:28:25.750707	35.6502291	128.1306876	OFFICIAL	2026-01-29 23:28:25.750712	0	\N
1437	경상남도 합천군 묘산면 도옥리 298	2026-01-29 23:28:25.751146	35.6701157	128.1196297	OFFICIAL	2026-01-29 23:28:25.75115	0	\N
1438	경상남도 합천군 묘산면 가산리 754-5	2026-01-29 23:28:25.751552	35.6587512	128.1267696	OFFICIAL	2026-01-29 23:28:25.751557	0	\N
1439	경상남도 합천군 묘산면 안성리 산77-1	2026-01-29 23:28:25.751965	35.6729712	128.1381258	OFFICIAL	2026-01-29 23:28:25.75197	0	\N
1440	경상북도 영덕군 영덕읍 화개리 652	2026-01-29 23:28:25.75236	36.42135788	129.3645717	OFFICIAL	2026-01-29 23:28:25.752364	0	\N
1441	경상북도 영덕군 영덕읍 우곡길 48 경상북도 영덕군 영덕읍 우곡리 322-10	2026-01-29 23:28:25.752797	36.40800827	129.3727756	OFFICIAL	2026-01-29 23:28:25.752802	0	\N
1442	경상북도 영덕군 영덕읍 우곡리 492	2026-01-29 23:28:25.753217	36.41026416	129.37732	OFFICIAL	2026-01-29 23:28:25.753222	0	\N
1443	경상남도 합천군 봉산면 계산리 136	2026-01-29 23:28:25.75517	35.5904741	128.0696654	OFFICIAL	2026-01-29 23:28:25.755174	0	\N
1444	경상남도 합천군 봉산면 양지리 671	2026-01-29 23:28:25.755591	35.5910709	128.0052533	OFFICIAL	2026-01-29 23:28:25.755595	0	\N
1445	경상남도 합천군 봉산면 도곡리 산116-3	2026-01-29 23:28:25.756033	35.6148487	128.0110942	OFFICIAL	2026-01-29 23:28:25.756037	0	\N
1446	경상남도 합천군 합천읍 계림3길 54-4	2026-01-29 23:28:25.756445	35.5962251	128.1487981	OFFICIAL	2026-01-29 23:28:25.756449	0	\N
1447	경상남도 합천군 합천읍 내곡리 706-4	2026-01-29 23:28:25.75685	35.6389046	128.1491421	OFFICIAL	2026-01-29 23:28:25.756855	0	\N
1448	경상남도 합천군 합천읍 서산리 827	2026-01-29 23:28:25.757255	35.5726215	128.1460623	OFFICIAL	2026-01-29 23:28:25.75726	0	\N
1449	경상남도 합천군 합천읍 장계리 산195-1	2026-01-29 23:28:25.757781	35.6088141	128.1192183	OFFICIAL	2026-01-29 23:28:25.757785	0	\N
1450	경상남도 합천군 합천읍 장계리 1010-1	2026-01-29 23:28:25.758194	35.6133158	128.1153064	OFFICIAL	2026-01-29 23:28:25.758199	0	\N
1451	경상남도 합천군 합천읍 장계리 1186	2026-01-29 23:28:25.758642	35.6147604	128.1219757	OFFICIAL	2026-01-29 23:28:25.758647	0	\N
1452	경상남도 합천군 합천읍 외곡2길 19	2026-01-29 23:28:25.759076	35.6279481	128.1380483	OFFICIAL	2026-01-29 23:28:25.759081	0	\N
1453	경상남도 합천군 합천읍 금양리 274-2	2026-01-29 23:28:25.759485	35.5900971	128.1746749	OFFICIAL	2026-01-29 23:28:25.759489	0	\N
1454	경상남도 합천군 합천읍 금양리 857-5	2026-01-29 23:28:25.759975	35.6170804	128.1645779	OFFICIAL	2026-01-29 23:28:25.759979	0	\N
1455	경상남도 합천군 합천읍 서산리 산174	2026-01-29 23:28:25.760386	35.5913775	128.1317947	OFFICIAL	2026-01-29 23:28:25.760391	0	\N
1456	경상남도 합천군 합천읍 인곡리 1192-88	2026-01-29 23:28:25.760825	35.6073207	128.1066003	OFFICIAL	2026-01-29 23:28:25.760829	0	\N
1457	경상남도 합천군 합천읍 용계리 166-4	2026-01-29 23:28:25.761241	35.6204644	128.1616815	OFFICIAL	2026-01-29 23:28:25.761246	0	\N
1458	경상남도 합천군 합천읍 외곡리 405-1	2026-01-29 23:28:25.761647	35.6354958	128.1429857	OFFICIAL	2026-01-29 23:28:25.761651	0	\N
1459	경상남도 합천군 합천읍 내곡리 763-1	2026-01-29 23:28:25.762029	35.6341706	128.1506127	OFFICIAL	2026-01-29 23:28:25.762033	0	\N
1460	경상남도 합천군 합천읍 서산리 603-3	2026-01-29 23:28:25.762437	35.5844815	128.1477501	OFFICIAL	2026-01-29 23:28:25.762442	0	\N
1461	경상남도 합천군 합천읍 인곡리 629	2026-01-29 23:28:25.762864	35.6052621	128.1000635	OFFICIAL	2026-01-29 23:28:25.762868	0	\N
1462	서울특별시 서초구 반포동1-13	2026-01-29 23:28:25.763272	37.50750565	126.9996531	OFFICIAL	2026-01-29 23:28:25.763276	0	\N
1463	서울특별시 서초구 남부순환로 350길4	2026-01-29 23:28:25.763676	37.48433811	127.0351785	OFFICIAL	2026-01-29 23:28:25.76368	0	\N
1464	서울특별시 서초구 효령로 386	2026-01-29 23:28:25.76412	37.48761254	127.0261892	OFFICIAL	2026-01-29 23:28:25.764124	0	\N
1465	서울특별시 서초구 신반포로 194	2026-01-29 23:28:25.764525	37.50643574	127.0068344	OFFICIAL	2026-01-29 23:28:25.76453	0	\N
1466	서울특별시 서초구 신반포로 105	2026-01-29 23:28:25.764941	37.50622031	127.0050517	OFFICIAL	2026-01-29 23:28:25.764945	0	\N
1467	서울특별시 서초구 신반포로 105	2026-01-29 23:28:25.765364	37.50622031	127.0050517	OFFICIAL	2026-01-29 23:28:25.765368	0	\N
1468	서울특별시 서초구 잠원로14길 32	2026-01-29 23:28:25.765801	37.51793353	127.0141425	OFFICIAL	2026-01-29 23:28:25.765806	0	\N
1469	서울특별시 서초구 원지동594-10(청계산로)	2026-01-29 23:28:25.766217	37.44753815	127.0553202	OFFICIAL	2026-01-29 23:28:25.766223	0	\N
1470	서울특별시 서초구 헌릉로13	2026-01-29 23:28:25.766635	37.46512254	127.0447513	OFFICIAL	2026-01-29 23:28:25.76664	0	\N
1471	서울특별시 서초구 매헌로116	2026-01-29 23:28:25.767042	37.46997873	127.0383258	OFFICIAL	2026-01-29 23:28:25.767047	0	\N
1472	서울특별시 서초구 매헌로24	2026-01-29 23:28:25.767446	37.46343917	127.0355257	OFFICIAL	2026-01-29 23:28:25.767451	0	\N
1473	경상남도 합천군 봉산면 오도산휴양로 345	2026-01-29 23:28:25.767869	35.6652511	128.0528971	OFFICIAL	2026-01-29 23:28:25.767874	0	\N
1474	서울특별시 서초구 양재대로2길 90	2026-01-29 23:28:25.768278	37.45760527	127.0175705	OFFICIAL	2026-01-29 23:28:25.768283	0	\N
1475	서울특별시 서초구 양재대로54	2026-01-29 23:28:25.768682	37.45976394	127.0253605	OFFICIAL	2026-01-29 23:28:25.768686	0	\N
1476	서울특별시 서초구 서운로212	2026-01-29 23:28:25.769116	37.50185788	127.0224228	OFFICIAL	2026-01-29 23:28:25.769121	0	\N
1477	서울특별시 서초구 서운로201	2026-01-29 23:28:25.769531	37.50132463	127.0201266	OFFICIAL	2026-01-29 23:28:25.769536	0	\N
1478	서울특별시 서초구 서운로107	2026-01-29 23:28:25.769959	37.49300713	127.0254533	OFFICIAL	2026-01-29 23:28:25.769963	0	\N
1479	서울특별시 서초구 서운로104	2026-01-29 23:28:25.770368	37.4934156	127.0264914	OFFICIAL	2026-01-29 23:28:25.770373	0	\N
1480	서울특별시 서초구 서초동1498-47(서초대로)	2026-01-29 23:28:25.770801	37.4907461	127.004678	OFFICIAL	2026-01-29 23:28:25.770806	0	\N
1481	서울특별시 서초구 고무래로34	2026-01-29 23:28:25.771209	37.50248707	127.0125134	OFFICIAL	2026-01-29 23:28:25.771214	0	\N
1482	서울특별시 서초구 명달로134	2026-01-29 23:28:25.771611	37.48924257	127.0048247	OFFICIAL	2026-01-29 23:28:25.771617	0	\N
1483	서울특별시 서초구 서초중앙로238	2026-01-29 23:28:25.772025	37.50296195	127.012071	OFFICIAL	2026-01-29 23:28:25.77203	0	\N
1484	서울특별시 서초구 방배중앙로 215 서울특별시 서초구 방배동752-7	2026-01-29 23:28:25.772429	37.49829312	126.9848286	OFFICIAL	2026-01-29 23:28:25.772435	0	\N
1485	서울특별시 서초구 방배천로 11 서울특별시 서초구 방배동444-3	2026-01-29 23:28:25.772864	37.47770076	126.9822361	OFFICIAL	2026-01-29 23:28:25.772868	0	\N
1486	서울특별시 서초구 동작대로 24 서울특별시 서초구 방배동443-3	2026-01-29 23:28:25.773281	37.47866249	126.9821522	OFFICIAL	2026-01-29 23:28:25.773285	0	\N
1487	서울특별시 서초구 방배천로 91 서울특별시 서초구 방배동3250	2026-01-29 23:28:25.773687	37.48479284	126.9825989	OFFICIAL	2026-01-29 23:28:25.773692	0	\N
1488	서울특별시 서초구 동작대로 108 서울특별시 서초구 방배동3001-1	2026-01-29 23:28:25.774126	37.4860911	126.9826166	OFFICIAL	2026-01-29 23:28:25.77413	0	\N
1489	서울특별시 서초구 동작대로 130 서울특별시 서초구 방배동1770	2026-01-29 23:28:25.774539	37.48801287	126.9826363	OFFICIAL	2026-01-29 23:28:25.774543	0	\N
1490	서울특별시 서초구 사평대로285	2026-01-29 23:28:25.774966	37.5041589	127.0154342	OFFICIAL	2026-01-29 23:28:25.774972	0	\N
1491	서울특별시 서초구 반포동20-49(사평대로)	2026-01-29 23:28:25.775372	37.50491575	127.0144171	OFFICIAL	2026-01-29 23:28:25.775376	0	\N
1492	서울특별시 서초구 사평대로66	2026-01-29 23:28:25.775803	37.49789692	126.9918371	OFFICIAL	2026-01-29 23:28:25.775807	0	\N
1493	서울특별시 서초구 사평대로142	2026-01-29 23:28:25.776211	37.50037298	127.0010603	OFFICIAL	2026-01-29 23:28:25.776216	0	\N
1494	서울특별시 서초구 사평대로 126 서울특별시 서초구 반포동 93-1	2026-01-29 23:28:25.776618	37.49976696	126.9983523	OFFICIAL	2026-01-29 23:28:25.776622	0	\N
1495	서울특별시 서초구 사평대로98	2026-01-29 23:28:25.777023	37.49865153	126.9954558	OFFICIAL	2026-01-29 23:28:25.777035	0	\N
1496	서울특별시 서초구 사평대로55	2026-01-29 23:28:25.777435	37.49885315	126.9905157	OFFICIAL	2026-01-29 23:28:25.77744	0	\N
1497	서울특별시 서초구 남부순환로2406	2026-01-29 23:28:25.777845	37.4802402	127.0142152	OFFICIAL	2026-01-29 23:28:25.77785	0	\N
1498	서울특별시 서초구 남부순환로2406	2026-01-29 23:28:25.778249	37.4802402	127.0142152	OFFICIAL	2026-01-29 23:28:25.778254	0	\N
1499	서울특별시 서초구 남부순환로2183	2026-01-29 23:28:25.778658	37.47511676	126.9910912	OFFICIAL	2026-01-29 23:28:25.778664	0	\N
1500	서울특별시 서초구 잠원로117	2026-01-29 23:28:25.77906	37.51451892	127.0069957	OFFICIAL	2026-01-29 23:28:25.779064	0	\N
1501	서울특별시 서초구 잠원동160-2(잠원로)	2026-01-29 23:28:25.779462	37.5099491	127.0077759	OFFICIAL	2026-01-29 23:28:25.779468	0	\N
1502	서울특별시 서초구 잠원로69	2026-01-29 23:28:25.779887	37.5102605	127.0069708	OFFICIAL	2026-01-29 23:28:25.779892	0	\N
1503	서울특별시 서초구 신반포로105	2026-01-29 23:28:25.7803	37.50622031	127.0050517	OFFICIAL	2026-01-29 23:28:25.780305	0	\N
1504	서울특별시 서초구 반포대로275	2026-01-29 23:28:25.780708	37.50239027	126.9959653	OFFICIAL	2026-01-29 23:28:25.780713	0	\N
1505	서울특별시 서초구 신반포로200	2026-01-29 23:28:25.781138	37.50622031	127.0050517	OFFICIAL	2026-01-29 23:28:25.781142	0	\N
1506	서울특별시 서초구 신반포로17	2026-01-29 23:28:25.78154	37.50113938	126.9861839	OFFICIAL	2026-01-29 23:28:25.781545	0	\N
1507	서울특별시 서초구 방배로16	2026-01-29 23:28:25.782092	37.47652276	127.0012438	OFFICIAL	2026-01-29 23:28:25.782096	0	\N
1508	서울특별시 서초구 효령로 120	2026-01-29 23:28:25.782503	37.48108275	126.9974214	OFFICIAL	2026-01-29 23:28:25.782508	0	\N
1509	서울특별시 서초구 서초대로 101	2026-01-29 23:28:25.782925	37.48790195	126.993196	OFFICIAL	2026-01-29 23:28:25.78293	0	\N
1510	서울특별시 서초구 방배로 151	2026-01-29 23:28:25.783324	37.48715828	126.9935602	OFFICIAL	2026-01-29 23:28:25.783329	0	\N
1511	서울특별시 서초구 방배로 173	2026-01-29 23:28:25.783728	37.48900761	126.9922424	OFFICIAL	2026-01-29 23:28:25.783733	0	\N
1512	서울특별시 서초구 방배로 268	2026-01-29 23:28:25.784145	37.49668577	126.9884208	OFFICIAL	2026-01-29 23:28:25.78415	0	\N
1513	서울특별시 서초구 효령로 34길 4	2026-01-29 23:28:25.78457	37.48136451	126.9989177	OFFICIAL	2026-01-29 23:28:25.784575	0	\N
1514	서울특별시 서초구 반포대로94	2026-01-29 23:28:25.784985	37.48871122	127.0095838	OFFICIAL	2026-01-29 23:28:25.784989	0	\N
1515	서울특별시 서초구 효령로 120	2026-01-29 23:28:25.785384	37.48108275	126.9974214	OFFICIAL	2026-01-29 23:28:25.785389	0	\N
1516	서울특별시 서초구 반포대로95	2026-01-29 23:28:25.785802	37.48868462	127.0087399	OFFICIAL	2026-01-29 23:28:25.785807	0	\N
1517	서울특별시 서초구 서초동1541-5(반포대로)	2026-01-29 23:28:25.786224	37.49092158	127.0079134	OFFICIAL	2026-01-29 23:28:25.786229	0	\N
1518	서울특별시 서초구 서초대로 240	2026-01-29 23:28:25.786628	37.49157706	127.0083435	OFFICIAL	2026-01-29 23:28:25.786633	0	\N
1519	서울특별시 서초구 반포대로72	2026-01-29 23:28:25.787041	37.48692867	127.0105871	OFFICIAL	2026-01-29 23:28:25.787046	0	\N
1520	서울특별시 서초구 반포대로43	2026-01-29 23:28:25.78745	37.48422977	127.0108415	OFFICIAL	2026-01-29 23:28:25.787455	0	\N
1521	서울특별시 서초구 반포대로38	2026-01-29 23:28:25.787883	37.48389485	127.0119208	OFFICIAL	2026-01-29 23:28:25.787888	0	\N
1522	서울특별시 서초구 효령로341	2026-01-29 23:28:25.788296	37.48663971	127.0213145	OFFICIAL	2026-01-29 23:28:25.788301	0	\N
1523	서울특별시 서초구 효령로418	2026-01-29 23:28:25.788706	37.4886106	127.0295891	OFFICIAL	2026-01-29 23:28:25.78871	0	\N
1524	서울특별시 서초구 효령로336	2026-01-29 23:28:25.789141	37.48602619	127.0209888	OFFICIAL	2026-01-29 23:28:25.789146	0	\N
1525	서울특별시 서초구 강남대로27	2026-01-29 23:28:25.789541	37.46827871	127.0391364	OFFICIAL	2026-01-29 23:28:25.789545	0	\N
1526	서울특별시 서초구 강남대로259	2026-01-29 23:28:25.789967	37.48657325	127.0326334	OFFICIAL	2026-01-29 23:28:25.789972	0	\N
1527	서울특별시 서초구 효령로292	2026-01-29 23:28:25.79038	37.48354661	127.0151109	OFFICIAL	2026-01-29 23:28:25.790384	0	\N
1528	서울특별시 서초구 효령로92	2026-01-29 23:28:25.790812	37.48016182	126.9945968	OFFICIAL	2026-01-29 23:28:25.790816	0	\N
1529	서울특별시 서초구 효령로22	2026-01-29 23:28:25.791215	37.4773868	126.9874824	OFFICIAL	2026-01-29 23:28:25.79122	0	\N
1530	서울특별시 서초구 강남대로45-2	2026-01-29 23:28:25.791654	37.46860382	127.0395902	OFFICIAL	2026-01-29 23:28:25.791658	0	\N
1531	서울특별시 서초구 강남대로48-3	2026-01-29 23:28:25.792037	37.469282	127.0399092	OFFICIAL	2026-01-29 23:28:25.792042	0	\N
1532	서울특별시 서초구 양재동 105-4(강남대로)	2026-01-29 23:28:25.792471	37.47859191	127.0384311	OFFICIAL	2026-01-29 23:28:25.792476	0	\N
1533	서울특별시 서초구 강남대로148	2026-01-29 23:28:25.792949	37.47788797	127.0391803	OFFICIAL	2026-01-29 23:28:25.792953	0	\N
1534	서울특별시 서초구 남부순환로2585	2026-01-29 23:28:25.793372	37.48393473	127.0345442	OFFICIAL	2026-01-29 23:28:25.793377	0	\N
1535	서울특별시 서초구 강남대로213	2026-01-29 23:28:25.793852	37.48276664	127.0349496	OFFICIAL	2026-01-29 23:28:25.793856	0	\N
1536	서울특별시 서초구 남부순환로2585	2026-01-29 23:28:25.794413	37.48393473	127.0345442	OFFICIAL	2026-01-29 23:28:25.794419	0	\N
1537	경상북도 영덕군 영덕읍 우곡리 491-45	2026-01-29 23:28:25.795313	36.40602339	129.3755674	OFFICIAL	2026-01-29 23:28:25.795318	0	\N
1538	경상북도 영덕군 영덕읍 남석리 66-22	2026-01-29 23:28:25.796006	36.40983742	129.3686186	OFFICIAL	2026-01-29 23:28:25.796012	0	\N
1539	경상북도 영덕군 영덕읍 우곡리 490-4	2026-01-29 23:28:25.79649	36.40858173	129.3712698	OFFICIAL	2026-01-29 23:28:25.796496	0	\N
1540	경상북도 영덕군 영덕읍 남석리 205-1	2026-01-29 23:28:25.796933	36.41158555	129.3652492	OFFICIAL	2026-01-29 23:28:25.796938	0	\N
1541	충청남도 홍성군 구항면 구항길240번길 21	2026-01-29 23:28:25.797384	36.5830161	126.6240259	OFFICIAL	2026-01-29 23:28:25.79739	0	\N
1542	충청남도 홍성군 구항면 거북로 440	2026-01-29 23:28:25.797856	36.57052522	126.6092873	OFFICIAL	2026-01-29 23:28:25.797861	0	\N
1543	충청남도 홍성군 구항면  충서로999번길 101-65	2026-01-29 23:28:25.79827	36.56780825	126.6390658	OFFICIAL	2026-01-29 23:28:25.798276	0	\N
1544	경상남도 합천군 용주면 고품부흥1길 10-28	2026-01-29 23:28:25.798704	35.5543751	128.1151668	OFFICIAL	2026-01-29 23:28:25.798708	0	\N
1545	경상남도 합천군 용주면 합천호수로 757	2026-01-29 23:28:25.799188	35.5490189	128.0710082	OFFICIAL	2026-01-29 23:28:25.799193	0	\N
1546	경상남도 합천군 대병면 합천호반로 4	2026-01-29 23:28:25.799725	35.5314136	128.0317584	OFFICIAL	2026-01-29 23:28:25.79973	0	\N
1547	경상남도 합천군 가회면 황매산공원길 263	2026-01-29 23:28:25.80017	35.4851395	127.9842519	OFFICIAL	2026-01-29 23:28:25.800174	0	\N
1548	경상남도 합천군 가회면 황매산공원길 331	2026-01-29 23:28:25.800593	35.4816328	127.9820485	OFFICIAL	2026-01-29 23:28:25.800598	0	\N
1549	경상남도 합천군 가회면 둔내리 산210	2026-01-29 23:28:25.801051	35.4864836	128.0008161	OFFICIAL	2026-01-29 23:28:25.801056	0	\N
1550	경상남도 합천군 대양면 정양리 613	2026-01-29 23:28:25.801447	35.5584161	128.1667081	OFFICIAL	2026-01-29 23:28:25.801452	0	\N
1551	경상남도 합천군 삼가면 합천대로 455	2026-01-29 23:28:25.801856	35.3841527	128.1091347	OFFICIAL	2026-01-29 23:28:25.801861	0	\N
1552	서울특별시 서초구 남부순환로2585	2026-01-29 23:28:25.802286	37.48393473	127.0345442	OFFICIAL	2026-01-29 23:28:25.802293	0	\N
1553	서울특별시 서초구 강남대로299	2026-01-29 23:28:25.802686	37.48975281	127.0309834	OFFICIAL	2026-01-29 23:28:25.802691	0	\N
1554	서울특별시 서초구 강남대로343	2026-01-29 23:28:25.803131	37.49351955	127.0292412	OFFICIAL	2026-01-29 23:28:25.803136	0	\N
1555	서울특별시 서초구 강남대로359	2026-01-29 23:28:25.803526	37.49479896	127.0286098	OFFICIAL	2026-01-29 23:28:25.803531	0	\N
1556	서울특별시 서초구 강남대로365	2026-01-29 23:28:25.803989	37.49532341	127.0283489	OFFICIAL	2026-01-29 23:28:25.803994	0	\N
1557	서울특별시 서초구 강남대로373	2026-01-29 23:28:25.80441	37.49598293	127.0280101	OFFICIAL	2026-01-29 23:28:25.804415	0	\N
1558	서울특별시 서초구 강남대로415	2026-01-29 23:28:25.804824	37.4995604	127.0263398	OFFICIAL	2026-01-29 23:28:25.804828	0	\N
1559	서울특별시 서초구 강남대로423	2026-01-29 23:28:25.805217	37.50030971	127.0258153	OFFICIAL	2026-01-29 23:28:25.805221	0	\N
1560	서울특별시 서초구 강남대로441	2026-01-29 23:28:25.805608	37.50173585	127.0252785	OFFICIAL	2026-01-29 23:28:25.805612	0	\N
1561	서울특별시 서초구 강남대로447	2026-01-29 23:28:25.806031	37.50219197	127.0250968	OFFICIAL	2026-01-29 23:28:25.806046	0	\N
1562	서울특별시 서초구 강남대로477-2	2026-01-29 23:28:25.80643	37.504919	127.0240413	OFFICIAL	2026-01-29 23:28:25.806434	0	\N
1563	서울특별시 서초구 강남대로483	2026-01-29 23:28:25.806857	37.50532543	127.023649	OFFICIAL	2026-01-29 23:28:25.806862	0	\N
1564	서울특별시 서초구 강남대로505	2026-01-29 23:28:25.807272	37.50701446	127.0227028	OFFICIAL	2026-01-29 23:28:25.807276	0	\N
1565	서울특별시 서초구 강남대로567	2026-01-29 23:28:25.807826	37.51239375	127.0200688	OFFICIAL	2026-01-29 23:28:25.80783	0	\N
1566	서울특별시 서초구 강남대로603-2	2026-01-29 23:28:25.808238	37.51555521	127.0194711	OFFICIAL	2026-01-29 23:28:25.808243	0	\N
1567	서울특별시 서초구 강남대로623	2026-01-29 23:28:25.808642	37.51740815	127.0187331	OFFICIAL	2026-01-29 23:28:25.808646	0	\N
1568	서울특별시 구로구 구로동로 153 서울특별시 구로구 구로동 413-88	2026-01-29 23:28:25.809037	37.4923559	126.8834335	OFFICIAL	2026-01-29 23:28:25.809041	0	\N
1569	충청남도 홍성군 구항면 충서로 999번길101-6	2026-01-29 23:28:25.809435	36.56985126	126.6409254	OFFICIAL	2026-01-29 23:28:25.809439	0	\N
1570	충청남도 홍성군 구항면  구항남길 544	2026-01-29 23:28:25.809848	36.56825784	126.5972872	OFFICIAL	2026-01-29 23:28:25.809853	0	\N
1571	충청남도 홍성군 구항면  충서로726번길 142	2026-01-29 23:28:25.810234	36.54262949	126.6486726	OFFICIAL	2026-01-29 23:28:25.810238	0	\N
1572	충청남도 홍성군 구항면  장양리 663-3	2026-01-29 23:28:25.810618	36.58085324	126.5900856	OFFICIAL	2026-01-29 23:28:25.810623	0	\N
1573	충청남도 홍성군 갈산면 수덕사로324번길 64	2026-01-29 23:28:25.811007	36.61835518	126.5929713	OFFICIAL	2026-01-29 23:28:25.811011	0	\N
1574	충청남도 홍성군 갈산면 백야로 314번길 57	2026-01-29 23:28:25.811389	36.58266883	126.5619087	OFFICIAL	2026-01-29 23:28:25.811393	0	\N
1575	충청남도 홍성군 갈산면 백야로 390	2026-01-29 23:28:25.811781	36.58730101	126.5547518	OFFICIAL	2026-01-29 23:28:25.811822	0	\N
1576	충청남도 홍성군 갈산면  오두리182-3	2026-01-29 23:28:25.812225	36.59646882	126.5283742	OFFICIAL	2026-01-29 23:28:25.81223	0	\N
1577	충청남도 홍성군 갈산면  백야로246번길 65	2026-01-29 23:28:25.812612	36.58120146	126.5648484	OFFICIAL	2026-01-29 23:28:25.812617	0	\N
1578	충청남도 홍성군 결성면 형산리 36-6	2026-01-29 23:28:25.813024	36.58522207	126.5757462	OFFICIAL	2026-01-29 23:28:25.813029	0	\N
1579	충청남도 홍성군 결성면 교향리 125-2	2026-01-29 23:28:25.813424	36.54725	126.547	OFFICIAL	2026-01-29 23:28:25.813428	0	\N
1580	충청남도 홍성군 결성면 교항리 1009	2026-01-29 23:28:25.813849	36.57800692	126.5436265	OFFICIAL	2026-01-29 23:28:25.813854	0	\N
1581	충청남도 홍성군 결성면 금곡리 840	2026-01-29 23:28:25.814241	36.52954709	126.5602166	OFFICIAL	2026-01-29 23:28:25.814245	0	\N
1582	충청남도 홍성군 결성면 교항리 339-7	2026-01-29 23:28:25.814628	36.58346125	126.54247	OFFICIAL	2026-01-29 23:28:25.814633	0	\N
1583	충청남도 홍성군 은하면 구성남로310번길 150-4	2026-01-29 23:28:25.815022	36.53446129	126.5682931	OFFICIAL	2026-01-29 23:28:25.815026	0	\N
1584	충청남도 홍성군 은하면 은하로129번길 76	2026-01-29 23:28:25.815444	36.53084196	126.5793994	OFFICIAL	2026-01-29 23:28:25.815448	0	\N
1585	충청남도 홍성군 은하면 은하로406번길 156	2026-01-29 23:28:25.815863	36.55123827	126.6063121	OFFICIAL	2026-01-29 23:28:25.815867	0	\N
1586	충청남도 홍성군 은하면 홍남서로886번길 177	2026-01-29 23:28:25.816235	36.50831371	126.5656438	OFFICIAL	2026-01-29 23:28:25.816239	0	\N
1587	충청남도 홍성군 장곡면 홍남동로 474번길 120-1	2026-01-29 23:28:25.816605	36.49996196	126.6814598	OFFICIAL	2026-01-29 23:28:25.816609	0	\N
1588	충청남도 홍성군 장곡면 장곡동길 660	2026-01-29 23:28:25.817035	36.53757321	126.7390158	OFFICIAL	2026-01-29 23:28:25.81704	0	\N
1589	충청남도 홍성군 장곡면 장곡길534번길 49	2026-01-29 23:28:25.817448	36.48525286	126.6950176	OFFICIAL	2026-01-29 23:28:25.817452	0	\N
1590	충청남도 홍성군 장곡면 지정1길 41-8	2026-01-29 23:28:25.817875	36.53030448	126.7040989	OFFICIAL	2026-01-29 23:28:25.817879	0	\N
1591	충청남도 홍성군 장곡면  홍남동로 713번길 190	2026-01-29 23:28:25.818251	36.50785508	126.7039209	OFFICIAL	2026-01-29 23:28:25.818255	0	\N
1592	충청남도 홍성군 장곡면  홍남동로461	2026-01-29 23:28:25.818681	36.50516139	126.6912807	OFFICIAL	2026-01-29 23:28:25.818685	0	\N
1593	충청남도 홍성군 장곡면  신풍리 60-1	2026-01-29 23:28:25.819104	36.49400989	126.6918792	OFFICIAL	2026-01-29 23:28:25.819108	0	\N
1594	충청남도 홍성군 금마면 금마로436번길 71	2026-01-29 23:28:25.819483	36.60419912	126.7524657	OFFICIAL	2026-01-29 23:28:25.819487	0	\N
1595	충청남도 홍성군 금마면 홍양길 518	2026-01-29 23:28:25.819897	36.60101835	126.72193	OFFICIAL	2026-01-29 23:28:25.819901	0	\N
1596	충청남도 홍성군 금마면 화양리 317-16	2026-01-29 23:28:25.820279	36.61880235	126.7237673	OFFICIAL	2026-01-29 23:28:25.820283	0	\N
1597	충청남도 홍성군 금마면 죽림리 719-29	2026-01-29 23:28:25.820662	36.61701054	126.7125174	OFFICIAL	2026-01-29 23:28:25.820666	0	\N
1598	충청남도 홍성군 금마면 죽림리 82-30	2026-01-29 23:28:25.821056	36.61462345	126.716211	OFFICIAL	2026-01-29 23:28:25.821061	0	\N
1599	충청남도 홍성군 홍동면 광금남로498번길 89	2026-01-29 23:28:25.821432	36.54310735	126.6863898	OFFICIAL	2026-01-29 23:28:25.821436	0	\N
1600	충청남도 홍성군 홍동면 신기리 382-7	2026-01-29 23:28:25.821895	36.58056199	126.7144232	OFFICIAL	2026-01-29 23:28:25.821899	0	\N
1601	충청남도 홍성군 홍북읍 홍북로 450	2026-01-29 23:28:25.822286	36.65016309	126.6919755	OFFICIAL	2026-01-29 23:28:25.822291	0	\N
1602	충청남도 홍성군 홍북읍 금북로 364-41	2026-01-29 23:28:25.822674	36.64845571	126.7232123	OFFICIAL	2026-01-29 23:28:25.822679	0	\N
1603	충청남도 홍성군 홍북읍 홍북읍 갈산리 244-3	2026-01-29 23:28:25.82306	36.64205	126.69	OFFICIAL	2026-01-29 23:28:25.823064	0	\N
1604	충청남도 홍성군 홍북읍 홍북읍 대인리 602-6	2026-01-29 23:28:25.823463	36.64205	126.69	OFFICIAL	2026-01-29 23:28:25.823467	0	\N
1605	충청남도 홍성군 홍북읍 홍북로 502번길 54	2026-01-29 23:28:25.823906	36.65165786	126.7013768	OFFICIAL	2026-01-29 23:28:25.823912	0	\N
1606	충청남도 홍성군 홍북읍 홍북로 453번길 47-19	2026-01-29 23:28:25.824384	36.64955412	126.689622	OFFICIAL	2026-01-29 23:28:25.824391	0	\N
1607	충청남도 홍성군 홍북읍 금북로614번길118	2026-01-29 23:28:25.824837	36.6693017	126.7388282	OFFICIAL	2026-01-29 23:28:25.824842	0	\N
1608	충청남도 홍성군 홍북읍 내용길 270	2026-01-29 23:28:25.825242	36.61808004	126.6926859	OFFICIAL	2026-01-29 23:28:25.825247	0	\N
1609	충청남도 홍성군 홍북읍 홍천문화2길30-14	2026-01-29 23:28:25.825634	36.62628097	126.642329	OFFICIAL	2026-01-29 23:28:25.825672	0	\N
1610	충청남도 홍성군 홍북읍 금북로 366	2026-01-29 23:28:25.826074	36.64962341	126.7218254	OFFICIAL	2026-01-29 23:28:25.826079	0	\N
1611	충청남도 홍성군 홍북읍 이응노로 307	2026-01-29 23:28:25.826527	36.6314193	126.653511	OFFICIAL	2026-01-29 23:28:25.826531	0	\N
1612	충청남도 홍성군 광천읍 상정리 653-3	2026-01-29 23:28:25.826953	36.50954832	126.6121306	OFFICIAL	2026-01-29 23:28:25.826972	0	\N
1613	충청남도 홍성군 광천읍 상정리 580-3	2026-01-29 23:28:25.827428	36.50555151	126.6112	OFFICIAL	2026-01-29 23:28:25.827433	0	\N
1614	충청남도 홍성군 광천읍 소암리 344-4	2026-01-29 23:28:25.827836	36.50026369	126.6368659	OFFICIAL	2026-01-29 23:28:25.827841	0	\N
1615	충청남도 홍성군 광천읍 가정리 502-3	2026-01-29 23:28:25.828319	36.50353205	126.648406	OFFICIAL	2026-01-29 23:28:25.828324	0	\N
1616	충청남도 홍성군 광천읍 홍남로623-18	2026-01-29 23:28:25.828732	36.50512729	126.620022	OFFICIAL	2026-01-29 23:28:25.828737	0	\N
1617	충청남도 홍성군 광천읍 월림1길 20-4	2026-01-29 23:28:25.829166	36.52149433	126.6471813	OFFICIAL	2026-01-29 23:28:25.829171	0	\N
1618	충청남도 홍성군 광천읍 담산길 13	2026-01-29 23:28:25.82956	36.49632354	126.6426721	OFFICIAL	2026-01-29 23:28:25.829565	0	\N
1619	충청남도 홍성군 광천읍 매현1길 2	2026-01-29 23:28:25.829953	36.52226833	126.6336432	OFFICIAL	2026-01-29 23:28:25.829958	0	\N
1620	충청남도 홍성군 광천읍 충서로 206-12	2026-01-29 23:28:25.83034	36.50244773	126.6178831	OFFICIAL	2026-01-29 23:28:25.83035	0	\N
1621	충청남도 홍성군 홍성읍 오관리 875-19	2026-01-29 23:28:25.830738	36.60086047	126.6589627	OFFICIAL	2026-01-29 23:28:25.830742	0	\N
1622	충청남도 홍성군 홍성읍 대교리 16-7	2026-01-29 23:28:25.831152	36.605952	126.6817526	OFFICIAL	2026-01-29 23:28:25.831156	0	\N
1623	충청남도 홍성군 홍성읍 대교리 30-2	2026-01-29 23:28:25.831544	36.60577826	126.6772135	OFFICIAL	2026-01-29 23:28:25.831548	0	\N
1624	충청남도 홍성군 홍성읍 월산리 830-4	2026-01-29 23:28:25.831964	36.60039943	126.6465531	OFFICIAL	2026-01-29 23:28:25.831969	0	\N
1625	충청남도 홍성군 홍성읍 고암리 570-9	2026-01-29 23:28:25.83235	36.59834807	126.6747773	OFFICIAL	2026-01-29 23:28:25.832354	0	\N
1626	충청남도 홍성군 홍성읍 오관리 587-4	2026-01-29 23:28:25.832729	36.59755443	126.6598002	OFFICIAL	2026-01-29 23:28:25.832733	0	\N
1627	충청남도 홍성군 홍성읍 내법리 154-5	2026-01-29 23:28:25.833141	36.61116754	126.6774255	OFFICIAL	2026-01-29 23:28:25.833146	0	\N
1628	충청남도 홍성군 홍성읍 오관리 726-5	2026-01-29 23:28:25.833518	36.60362705	126.65695	OFFICIAL	2026-01-29 23:28:25.833523	0	\N
1629	충청남도 홍성군 홍성읍 내법리 330-2	2026-01-29 23:28:25.833925	36.6165635	126.6737312	OFFICIAL	2026-01-29 23:28:25.83393	0	\N
1630	충청남도 홍성군 홍성읍 월산리 850	2026-01-29 23:28:25.834303	36.6024162	126.6497034	OFFICIAL	2026-01-29 23:28:25.834308	0	\N
1631	충청남도 홍성군 홍성읍 고암리 552-6	2026-01-29 23:28:25.834695	36.59883	126.673	OFFICIAL	2026-01-29 23:28:25.8347	0	\N
1632	서울특별시 구로구 구로동로 238-1 서울특별시 구로구 구로동 497-7	2026-01-29 23:28:25.835185	37.49983443	126.8826164	OFFICIAL	2026-01-29 23:28:25.83519	0	\N
1633	충청남도 홍성군 홍성읍 남장리 507-8	2026-01-29 23:28:25.835598	36.58125753	126.6539618	OFFICIAL	2026-01-29 23:28:25.835603	0	\N
1634	충청남도 홍성군 홍성읍 남장리 108-19	2026-01-29 23:28:25.83624	36.59296259	126.6648363	OFFICIAL	2026-01-29 23:28:25.836244	0	\N
1635	충청남도 홍성군 홍성읍 남장리 422-5	2026-01-29 23:28:25.836631	36.57734382	126.6549732	OFFICIAL	2026-01-29 23:28:25.836639	0	\N
1636	충청남도 홍성군 홍성읍 오관리904	2026-01-29 23:28:25.837125	36.59768418	126.6541879	OFFICIAL	2026-01-29 23:28:25.837129	0	\N
1637	충청남도 홍성군 홍성읍 월산리 901	2026-01-29 23:28:25.837513	36.599025	126.6504631	OFFICIAL	2026-01-29 23:28:25.837517	0	\N
1638	충청남도 홍성군 홍성읍 오관리 411-21	2026-01-29 23:28:25.837919	36.59994116	126.663184	OFFICIAL	2026-01-29 23:28:25.837923	0	\N
1639	충청남도 홍성군 홍성읍 오관리 715-21	2026-01-29 23:28:25.838294	36.60410982	126.6599375	OFFICIAL	2026-01-29 23:28:25.838299	0	\N
1640	충청남도 홍성군 홍성읍 대교리 443-32	2026-01-29 23:28:25.838672	36.60668851	126.663853	OFFICIAL	2026-01-29 23:28:25.838677	0	\N
1641	충청남도 홍성군 홍성읍 내포로 251번길120	2026-01-29 23:28:25.839038	36.58348157	126.6420953	OFFICIAL	2026-01-29 23:28:25.839043	0	\N
1642	서울특별시 구로구 구로중앙로 135-6 서울특별시 구로구 구로동 500-27	2026-01-29 23:28:25.839411	37.49995073	126.8828691	OFFICIAL	2026-01-29 23:28:25.839415	0	\N
1643	서울특별시 마포구 잔다리로 8 서울특별시 마포구 서교동 363-6	2026-01-29 23:28:25.839815	37.55088607	126.9222846	OFFICIAL	2026-01-29 23:28:25.839819	0	\N
1644	서울특별시 마포구 어울마당로 65 서울특별시 마포구 서교동 367-5	2026-01-29 23:28:25.840191	37.5509577	126.921063	OFFICIAL	2026-01-29 23:28:25.840196	0	\N
1645	서울특별시 마포구 어울마당로 65 서울특별시 마포구 서교동 367-5	2026-01-29 23:28:25.840562	37.5509577	126.921063	OFFICIAL	2026-01-29 23:28:25.840567	0	\N
1646	서울특별시 마포구 잔다리로 13 서울특별시 마포구 서교동 407-23	2026-01-29 23:28:25.84096	37.5505701	126.9216259	OFFICIAL	2026-01-29 23:28:25.840964	0	\N
1647	서울특별시 마포구 어울마당로 76 서울특별시 마포구 서교동 364-18	2026-01-29 23:28:25.841337	37.55173887	126.921615	OFFICIAL	2026-01-29 23:28:25.841341	0	\N
1648	서울특별시 마포구 월드컵로 212 서울특별시 마포구 성산동 370	2026-01-29 23:28:25.841821	37.56631284	126.9016157	OFFICIAL	2026-01-29 23:28:25.841827	0	\N
1649	서울특별시 마포구 월드컵로 212 서울특별시 마포구 성산동 370	2026-01-29 23:28:25.842324	37.56631284	126.9016157	OFFICIAL	2026-01-29 23:28:25.842329	0	\N
1650	서울특별시 마포구 고산2길 61 서울특별시 마포구 노고산동 12-187	2026-01-29 23:28:25.842789	37.55397876	126.9408091	OFFICIAL	2026-01-29 23:28:25.842793	0	\N
1651	서울특별시 마포구 월드컵로 77 서울특별시 마포구 망원동 378	2026-01-29 23:28:25.843228	37.55605729	126.9100339	OFFICIAL	2026-01-29 23:28:25.843234	0	\N
1652	서울특별시 마포구 월드컵로 77 서울특별시 마포구 망원동 378	2026-01-29 23:28:25.84364	37.55605729	126.9100339	OFFICIAL	2026-01-29 23:28:25.843644	0	\N
1653	서울특별시 마포구 월드컵로 212 서울특별시 마포구 성산동 370	2026-01-29 23:28:25.844045	37.56631284	126.9016157	OFFICIAL	2026-01-29 23:28:25.84405	0	\N
1654	서울특별시 마포구 월드컵북로 361 서울특별시 마포구 상암동 1653	2026-01-29 23:28:25.844452	37.5771097	126.8914039	OFFICIAL	2026-01-29 23:28:25.844456	0	\N
1655	서울특별시 마포구 매봉산로 80 서울특별시 마포구 상암동 1615	2026-01-29 23:28:25.844849	37.57852975	126.8942848	OFFICIAL	2026-01-29 23:28:25.844853	0	\N
1656	서울특별시 마포구 월드컵로 202 서울특별시 마포구 성산동 591-2	2026-01-29 23:28:25.845268	37.56528704	126.9024641	OFFICIAL	2026-01-29 23:28:25.845273	0	\N
1657	서울특별시 마포구 월드컵로 212 서울특별시 마포구 성산동 370	2026-01-29 23:28:25.845671	37.56631284	126.9016157	OFFICIAL	2026-01-29 23:28:25.845676	0	\N
1658	서울특별시 마포구 성산동 665	2026-01-29 23:28:25.846051	37.56827661	126.8927642	OFFICIAL	2026-01-29 23:28:25.846056	0	\N
1659	서울특별시 마포구 월드컵로 204 서울특별시 마포구 성산동 591-1	2026-01-29 23:28:25.846435	37.56539921	126.9021318	OFFICIAL	2026-01-29 23:28:25.84644	0	\N
1660	서울특별시 마포구 상암동 1622-1	2026-01-29 23:28:25.846852	37.57712976	126.8978247	OFFICIAL	2026-01-29 23:28:25.846857	0	\N
1661	서울특별시 마포구 상암동 1731	2026-01-29 23:28:25.847266	37.57362275	126.8873006	OFFICIAL	2026-01-29 23:28:25.847271	0	\N
1662	서울특별시 마포구 월드컵로 61 서울특별시 마포구 망원동 386-3	2026-01-29 23:28:25.847702	37.55465441	126.9110639	OFFICIAL	2026-01-29 23:28:25.847707	0	\N
1663	서울특별시 마포구 월드컵로 143 서울특별시 마포구 망원동 477-4	2026-01-29 23:28:25.848159	37.56048172	126.905632	OFFICIAL	2026-01-29 23:28:25.848165	0	\N
1664	서울특별시 마포구 월드컵로 143 서울특별시 마포구 망원동 477-4	2026-01-29 23:28:25.848625	37.56048172	126.905632	OFFICIAL	2026-01-29 23:28:25.84863	0	\N
1665	서울특별시 마포구 월드컵로 87 서울특별시 마포구 망원동 377-1	2026-01-29 23:28:25.849169	37.5564743	126.9092406	OFFICIAL	2026-01-29 23:28:25.849174	0	\N
1666	서울특별시 마포구 월드컵로 78 서울특별시 마포구 서교동 441-19	2026-01-29 23:28:25.849608	37.5560151	126.910469	OFFICIAL	2026-01-29 23:28:25.849614	0	\N
1667	서울특별시 마포구 월드컵북로 183-2 서울특별시 마포구 성산동 200-3	2026-01-29 23:28:25.850027	37.56790457	126.9082588	OFFICIAL	2026-01-29 23:28:25.850032	0	\N
1668	서울특별시 마포구 월드컵북로 221 서울특별시 마포구 성산동 466-6	2026-01-29 23:28:25.850433	37.5692779	126.9043255	OFFICIAL	2026-01-29 23:28:25.850437	0	\N
1669	서울특별시 마포구 월드컵북로 233 서울특별시 마포구 성산동 446	2026-01-29 23:28:25.850873	37.56973229	126.9031355	OFFICIAL	2026-01-29 23:28:25.850877	0	\N
1670	서울특별시 마포구 성산동 661	2026-01-29 23:28:25.851263	37.5702693	126.8945243	OFFICIAL	2026-01-29 23:28:25.851268	0	\N
1671	서울특별시 마포구 성산동 661	2026-01-29 23:28:25.851644	37.5702693	126.8945243	OFFICIAL	2026-01-29 23:28:25.851648	0	\N
1672	전라남도 해남군 해남읍 신안길 82 전라남도 해남군 해남읍 신안리 138-1	2026-01-29 23:28:25.852068	34.56218135	126.6162469	OFFICIAL	2026-01-29 23:28:25.852073	0	\N
1673	전라남도 해남군 해남읍 남외리 113-1	2026-01-29 23:28:25.852467	34.56868837	126.5957116	OFFICIAL	2026-01-29 23:28:25.852471	0	\N
1674	전라남도 해남군 해남읍 수성리 63	2026-01-29 23:28:25.852868	34.57354561	126.6004697	OFFICIAL	2026-01-29 23:28:25.852873	0	\N
1675	전라남도 해남군 해남읍 읍학동길 20-3 전라남도 해남군 해남읍 구교리 839-4	2026-01-29 23:28:25.853287	34.58260194	126.5801071	OFFICIAL	2026-01-29 23:28:25.853291	0	\N
1676	전라남도 해남군 해남읍 읍내길 20-6 전라남도 해남군 해남읍 읍내리 50	2026-01-29 23:28:25.853744	34.57030585	126.5989153	OFFICIAL	2026-01-29 23:28:25.853778	0	\N
1677	전라남도 해남군 해남읍 읍관동길 26 전라남도 해남군 해남읍 구교리 526-4	2026-01-29 23:28:25.854177	34.57912999	126.5881281	OFFICIAL	2026-01-29 23:28:25.854182	0	\N
1678	전라남도 해남군 해남읍 안동리 176-2	2026-01-29 23:28:25.854569	34.55250401	126.5832005	OFFICIAL	2026-01-29 23:28:25.854573	0	\N
1679	전라남도 해남군 해남읍 남천길 37 전라남도 해남군 해남읍 남천리 339-3	2026-01-29 23:28:25.85495	34.55973549	126.5680076	OFFICIAL	2026-01-29 23:28:25.854954	0	\N
1680	서울특별시 마포구 잔다리로 6 서울특별시 마포구 서교동 363-5	2026-01-29 23:28:25.85534	37.55090875	126.9225252	OFFICIAL	2026-01-29 23:28:25.855344	0	\N
1681	서울특별시 마포구 잔다리로 13 서울특별시 마포구 서교동 407-23	2026-01-29 23:28:25.855725	37.5505701	126.9216259	OFFICIAL	2026-01-29 23:28:25.855729	0	\N
1682	서울특별시 마포구 어울마당로 65 서울특별시 마포구 서교동 367-5	2026-01-29 23:28:25.856167	37.5509577	126.921063	OFFICIAL	2026-01-29 23:28:25.856171	0	\N
1683	서울특별시 마포구 서강로 127-1 서울특별시 마포구 노고산동 49-66	2026-01-29 23:28:25.856593	37.5539745	126.9347767	OFFICIAL	2026-01-29 23:28:25.856597	0	\N
1684	서울특별시 마포구 서강로 111-1 서울특별시 마포구 창전동 2-3	2026-01-29 23:28:25.856977	37.55319412	126.9332862	OFFICIAL	2026-01-29 23:28:25.856981	0	\N
1685	서울특별시 마포구 마포대로 212-1	2026-01-29 23:28:25.857361	37.55278656	126.9565585	OFFICIAL	2026-01-29 23:28:25.857368	0	\N
1686	서울특별시 마포구 마포대로 109 서울특별시 마포구 공덕동 467	2026-01-29 23:28:25.857734	37.54511882	126.9508863	OFFICIAL	2026-01-29 23:28:25.857739	0	\N
1687	서울특별시 마포구 홍익로 6 서울특별시 마포구 서교동 344-15	2026-01-29 23:28:25.85813	37.55329783	126.9240508	OFFICIAL	2026-01-29 23:28:25.858134	0	\N
1688	서울특별시 마포구 홍익로 5 서울특별시 마포구 서교동 358-19	2026-01-29 23:28:25.858637	37.55311367	126.9237638	OFFICIAL	2026-01-29 23:28:25.858642	0	\N
1689	서울특별시 마포구 홍익로 23 서울특별시 마포구 서교동 356-2	2026-01-29 23:28:25.859101	37.55429262	126.9222415	OFFICIAL	2026-01-29 23:28:25.859105	0	\N
1690	서울특별시 마포구 홍익로 20 서울특별시 마포구 서교동 345-30	2026-01-29 23:28:25.859499	37.55438256	126.9228187	OFFICIAL	2026-01-29 23:28:25.859504	0	\N
1691	서울특별시 마포구 홍익로 19 서울특별시 마포구 서교동 358-1	2026-01-29 23:28:25.859917	37.5540115	126.9226326	OFFICIAL	2026-01-29 23:28:25.859921	0	\N
1692	서울특별시 마포구 홍익로 18 서울특별시 마포구 서교동 345-9	2026-01-29 23:28:25.860303	37.55422005	126.9230101	OFFICIAL	2026-01-29 23:28:25.860307	0	\N
1693	서울특별시 마포구 홍익로 11 서울특별시 마포구 서교동 358-12	2026-01-29 23:28:25.860682	37.55350394	126.9232862	OFFICIAL	2026-01-29 23:28:25.860686	0	\N
1694	서울특별시 마포구 홍익로 10 서울특별시 마포구 서교동 486	2026-01-29 23:28:25.861114	37.55376198	126.9236938	OFFICIAL	2026-01-29 23:28:25.861118	0	\N
1695	서울특별시 마포구 잔다리로 40 서울특별시 마포구 서교동 368-9	2026-01-29 23:28:25.861509	37.55195907	126.9193376	OFFICIAL	2026-01-29 23:28:25.861513	0	\N
1696	서울특별시 마포구 어울마당로 113 서울특별시 마포구 동교동 163-5	2026-01-29 23:28:25.861919	37.55497476	126.9229139	OFFICIAL	2026-01-29 23:28:25.861923	0	\N
1697	서울특별시 마포구 어울마당로 107 서울특별시 마포구 동교동 163-8	2026-01-29 23:28:25.862396	37.55462795	126.9224833	OFFICIAL	2026-01-29 23:28:25.8624	0	\N
1698	서울특별시 마포구 양화로 100-2 서울특별시 마포구 서교동 427	2026-01-29 23:28:25.862816	37.5528524	126.9186684	OFFICIAL	2026-01-29 23:28:25.862821	0	\N
1699	서울특별시 마포구 양화로 100-2 서울특별시 마포구 서교동 427	2026-01-29 23:28:25.863204	37.5528524	126.9186684	OFFICIAL	2026-01-29 23:28:25.863208	0	\N
1700	서울특별시 마포구 상수동 1-3	2026-01-29 23:28:25.86359	37.54765426	126.9272266	OFFICIAL	2026-01-29 23:28:25.863594	0	\N
1701	전라남도 해남군 문내면 용암리 300-5	2026-01-29 23:28:25.863971	34.58853335	126.3580555	OFFICIAL	2026-01-29 23:28:25.863975	0	\N
1702	전라남도 해남군 문내면 용암리 733-6	2026-01-29 23:28:25.864344	34.59781368	126.3469407	OFFICIAL	2026-01-29 23:28:25.864348	0	\N
1703	전라남도 해남군 문내면 무고길 64 전라남도 해남군 문내면 무고리 168-1	2026-01-29 23:28:25.864712	34.63100565	126.314658	OFFICIAL	2026-01-29 23:28:25.864731	0	\N
1704	전라남도 해남군 문내면 동헌길 30 전라남도 해남군 문내면 동외리 1117-1	2026-01-29 23:28:25.865328	34.59175651	126.3097889	OFFICIAL	2026-01-29 23:28:25.865332	0	\N
1705	전라남도 해남군 산이면 덕송길 21 전라남도 해남군 산이면 덕송리 817	2026-01-29 23:28:25.865722	34.68063558	126.430966	OFFICIAL	2026-01-29 23:28:25.865726	0	\N
1706	전라남도 해남군 산이면 진산길 110 전라남도 해남군 산이면 진산리 515-1	2026-01-29 23:28:25.866144	34.64739167	126.4244161	OFFICIAL	2026-01-29 23:28:25.866149	0	\N
1707	전라남도 해남군 산이면 대진리 445-1	2026-01-29 23:28:25.866569	34.67240786	126.4244775	OFFICIAL	2026-01-29 23:28:25.866573	0	\N
1708	전라남도 해남군 황산면 우항길 60 전라남도 해남군 황산면 우항리 317-1	2026-01-29 23:28:25.866936	34.58372633	126.4377013	OFFICIAL	2026-01-29 23:28:25.86694	0	\N
1709	전라남도 해남군 황산면 연호길 19 전라남도 해남군 황산면 연호리 391-1	2026-01-29 23:28:25.867295	34.59986958	126.4839324	OFFICIAL	2026-01-29 23:28:25.867299	0	\N
1710	전라남도 해남군 황산면 남리길 182 전라남도 해남군 황산면 남리리 764-1	2026-01-29 23:28:25.867682	34.57101452	126.4205638	OFFICIAL	2026-01-29 23:28:25.867686	0	\N
1711	전라남도 해남군 황산면 한자리 1123-12	2026-01-29 23:28:25.868069	34.52351394	126.4575274	OFFICIAL	2026-01-29 23:28:25.868073	0	\N
1712	전라남도 해남군 마산면 마산로 410-1 전라남도 해남군 마산면 화내리 637-16	2026-01-29 23:28:25.868434	34.61905151	126.5706787	OFFICIAL	2026-01-29 23:28:25.868438	0	\N
1713	전라남도 해남군 마산면 연구리 363	2026-01-29 23:28:25.86882	34.6426585	126.5454045	OFFICIAL	2026-01-29 23:28:25.868824	0	\N
1714	전라남도 해남군 계곡면 가학길 35 전라남도 해남군 계곡면 가학리 95	2026-01-29 23:28:25.869191	34.65366698	126.5958078	OFFICIAL	2026-01-29 23:28:25.869195	0	\N
1715	전라남도 해남군 계곡면 용지길 86 전라남도 해남군 계곡면 사정리 110-4	2026-01-29 23:28:25.869556	34.64190958	126.6039461	OFFICIAL	2026-01-29 23:28:25.86956	0	\N
1716	전라남도 해남군 옥천면 백호길 45 전라남도 해남군 옥천면 백호리 412-6	2026-01-29 23:28:25.869964	34.54774346	126.6552162	OFFICIAL	2026-01-29 23:28:25.869968	0	\N
1717	전라남도 해남군 옥천면 영신길 5 전라남도 해남군 옥천면 영신리 477-1	2026-01-29 23:28:25.870398	34.58923626	126.6474804	OFFICIAL	2026-01-29 23:28:25.870402	0	\N
1718	전라남도 해남군 북일면 만월길 18-11 전라남도 해남군 북일면 흥촌리 158-3	2026-01-29 23:28:25.870842	34.46446525	126.6721804	OFFICIAL	2026-01-29 23:28:25.870846	0	\N
1719	전라남도 해남군 북일면 삼성길 72 전라남도 해남군 북일면 흥촌리 848-1	2026-01-29 23:28:25.871234	34.46457789	126.6644962	OFFICIAL	2026-01-29 23:28:25.871239	0	\N
1720	전라남도 해남군 북일면 용일길 128 전라남도 해남군 북일면 용일리 749-1	2026-01-29 23:28:25.871616	34.4616847	126.6984058	OFFICIAL	2026-01-29 23:28:25.87162	0	\N
1721	전라남도 해남군 북평면 동해리 620-1	2026-01-29 23:28:25.871996	34.43722587	126.6370071	OFFICIAL	2026-01-29 23:28:25.872	0	\N
1722	전라남도 해남군 송지면 마봉리 1257	2026-01-29 23:28:25.872364	34.36885237	126.5333675	OFFICIAL	2026-01-29 23:28:25.872368	0	\N
1723	전라남도 해남군 송지면 산정리 542-3	2026-01-29 23:28:25.872729	34.36908018	126.5168907	OFFICIAL	2026-01-29 23:28:25.872733	0	\N
1724	전라남도 해남군 송지면 소죽길 65 전라남도 해남군 송지면 소죽리 493-1	2026-01-29 23:28:25.87313	34.36497673	126.527691	OFFICIAL	2026-01-29 23:28:25.873134	0	\N
1725	전라남도 해남군 현산면 고현리 1039-3	2026-01-29 23:28:25.873516	34.4623945	126.5370299	OFFICIAL	2026-01-29 23:28:25.873521	0	\N
1726	전라남도 해남군 현산면 조산리 369-1	2026-01-29 23:28:25.873944	34.4340966	126.6012893	OFFICIAL	2026-01-29 23:28:25.873948	0	\N
1727	전라남도 해남군 현산면 신방리길 36 전라남도 해남군 현산면 초호리 628-3	2026-01-29 23:28:25.874323	34.43507533	126.5404396	OFFICIAL	2026-01-29 23:28:25.874327	0	\N
1728	전라남도 해남군 화산면 송평로 5-12 전라남도 해남군 화산면 방축리 468-6	2026-01-29 23:28:25.874697	34.49021461	126.5149325	OFFICIAL	2026-01-29 23:28:25.874706	0	\N
1729	전라남도 해남군 삼산면 상가리 340-5	2026-01-29 23:28:25.875124	34.52932987	126.6389607	OFFICIAL	2026-01-29 23:28:25.875128	0	\N
1730	전라남도 해남군 삼산면 평활길 24 전라남도 해남군 삼산면 평활리 473-1	2026-01-29 23:28:25.875599	34.51785622	126.6205372	OFFICIAL	2026-01-29 23:28:25.875603	0	\N
1731	전라남도 해남군 삼산면 창리 329	2026-01-29 23:28:25.876006	34.53683521	126.5962593	OFFICIAL	2026-01-29 23:28:25.87601	0	\N
1732	광주광역시 광산구 하산동 193-9	2026-01-29 23:28:25.876453	35.09144873	126.7725212	OFFICIAL	2026-01-29 23:28:25.876457	0	\N
1733	경상남도 남해군 남면 선구리 1049-1	2026-01-29 23:28:25.87688	34.7426034	127.8582505	OFFICIAL	2026-01-29 23:28:25.876884	0	\N
1734	경상남도 남해군 삼동면 봉화리 967-3	2026-01-29 23:28:25.877257	34.80365029	128.0233	OFFICIAL	2026-01-29 23:28:25.877261	0	\N
1735	경상남도 남해군 상주면 양아리 918-7	2026-01-29 23:28:25.877836	34.71669108	127.9580289	OFFICIAL	2026-01-29 23:28:25.877842	0	\N
1736	경상남도 남해군 이동면 무림리 1164-3	2026-01-29 23:28:25.878289	34.80469451	127.9548819	OFFICIAL	2026-01-29 23:28:25.878294	0	\N
1737	경상남도 남해군 이동면 초음리 627	2026-01-29 23:28:25.878693	34.82839136	127.9302861	OFFICIAL	2026-01-29 23:28:25.878698	0	\N
1738	경상남도 남해군 남해읍 평현리 1224-1	2026-01-29 23:28:25.879104	34.81902806	127.8793388	OFFICIAL	2026-01-29 23:28:25.879108	0	\N
1739	경상남도 남해군 고현면 갈화리 1383-11	2026-01-29 23:28:25.879509	34.89513685	127.8368857	OFFICIAL	2026-01-29 23:28:25.879513	0	\N
1740	경상남도 남해군 삼동면 금송리 546	2026-01-29 23:28:25.879923	34.83010104	128.0186724	OFFICIAL	2026-01-29 23:28:25.879927	0	\N
1741	경상남도 남해군 설천면 금음리 1-12	2026-01-29 23:28:25.880494	34.93084144	127.9280628	OFFICIAL	2026-01-29 23:28:25.8805	0	\N
1742	경상남도 남해군 미조면 미조리 632-3	2026-01-29 23:28:25.880953	34.7142421	128.0439621	OFFICIAL	2026-01-29 23:28:25.880958	0	\N
1743	경상남도 남해군 남면 석교리 1034-1	2026-01-29 23:28:25.881367	34.76716924	127.9050423	OFFICIAL	2026-01-29 23:28:25.881371	0	\N
1744	경상남도 남해군 남해읍 평리 661-2	2026-01-29 23:28:25.881787	34.82009964	127.8920287	OFFICIAL	2026-01-29 23:28:25.881791	0	\N
1745	경상남도 남해군 창선면 수산리 525	2026-01-29 23:28:25.882202	34.85486592	128.0123902	OFFICIAL	2026-01-29 23:28:25.882206	0	\N
1746	경상남도 남해군 서면 노구리 1049-7	2026-01-29 23:28:25.882595	34.86052345	127.8201545	OFFICIAL	2026-01-29 23:28:25.8826	0	\N
1747	경상남도 남해군 상주면 양아리 1467-1	2026-01-29 23:28:25.883048	34.73294922	127.9552582	OFFICIAL	2026-01-29 23:28:25.883053	0	\N
1748	경상남도 남해군 이동면 신전리 169-2	2026-01-29 23:28:25.883447	34.77569063	127.9582623	OFFICIAL	2026-01-29 23:28:25.883451	0	\N
1749	경상남도 남해군 창선면 진동리 708-42	2026-01-29 23:28:25.883835	34.85249235	128.053563	OFFICIAL	2026-01-29 23:28:25.883839	0	\N
1750	경상남도 남해군 창선면 가인리 453	2026-01-29 23:28:25.884215	34.85643	127.9664221	OFFICIAL	2026-01-29 23:28:25.884219	0	\N
1751	경상남도 남해군 설천면 문의리 70-9	2026-01-29 23:28:25.884596	34.9309804	127.9194809	OFFICIAL	2026-01-29 23:28:25.8846	0	\N
1752	경상남도 남해군 고현면 도마리 512-1	2026-01-29 23:28:25.884974	34.88194193	127.8876497	OFFICIAL	2026-01-29 23:28:25.884978	0	\N
1753	경상남도 남해군 서면 남상리 1166-32	2026-01-29 23:28:25.885349	34.84701711	127.818773	OFFICIAL	2026-01-29 23:28:25.885364	0	\N
1754	전라남도 해남군 마산면 학의리 1444-11	2026-01-29 23:28:25.885726	34.60088091	126.5296003	OFFICIAL	2026-01-29 23:28:25.88573	0	\N
1755	전라남도 해남군 송지면 송호리 897-5	2026-01-29 23:28:25.886172	34.31706214	126.5178398	OFFICIAL	2026-01-29 23:28:25.886176	0	\N
1756	전라남도 해남군 삼산면 충리길 121 전라남도 해남군 삼산면 충리 362-2	2026-01-29 23:28:25.886539	34.51799709	126.5960984	OFFICIAL	2026-01-29 23:28:25.886543	0	\N
1757	전라남도 해남군 해남읍 길호길 54 전라남도 해남군 해남읍 복평리 334	2026-01-29 23:28:25.886932	34.55947182	126.5463859	OFFICIAL	2026-01-29 23:28:25.886936	0	\N
1758	전라남도 해남군 화원면 화봉리 596-1	2026-01-29 23:28:25.887306	34.65928465	126.2660463	OFFICIAL	2026-01-29 23:28:25.88731	0	\N
1759	전라남도 해남군 화원면 산호리 91	2026-01-29 23:28:25.887693	34.64736613	126.299728	OFFICIAL	2026-01-29 23:28:25.887697	0	\N
1760	전라남도 해남군 화원면 이목길 44-16 전라남도 해남군 화원면 장춘리 624-1	2026-01-29 23:28:25.888084	34.65172354	126.3169355	OFFICIAL	2026-01-29 23:28:25.888088	0	\N
1761	전라남도 해남군 화원면 마산리 152-1	2026-01-29 23:28:25.888552	34.71376879	126.3327554	OFFICIAL	2026-01-29 23:28:25.888558	0	\N
1762	서울특별시 구로구 구로동로 31 서울특별시 구로구 가리봉동 25-51	2026-01-29 23:28:25.889087	37.48444034	126.8859907	OFFICIAL	2026-01-29 23:28:25.889092	0	\N
1763	광주광역시 광산구 유계동 1031-14	2026-01-29 23:28:25.889518	35.091394	126.7729998	OFFICIAL	2026-01-29 23:28:25.889523	0	\N
1764	전라남도 장흥군 장흥읍 칠거리예양로 41-2 전라남도 장흥군 장흥읍 예양리 47-2	2026-01-29 23:28:25.889959	34.67582148	126.9015785	OFFICIAL	2026-01-29 23:28:25.889964	0	\N
1765	전라남도 장흥군 장흥읍 평화리 733-1	2026-01-29 23:28:25.890365	34.67221919	126.9044399	OFFICIAL	2026-01-29 23:28:25.89037	0	\N
1766	전라남도 장흥군 장흥읍 기양길 16 전라남도 장흥군 장흥읍 기양리 109-2	2026-01-29 23:28:25.890788	34.67824363	126.9016945	OFFICIAL	2026-01-29 23:28:25.890793	0	\N
1767	전라남도 장흥군 부산면 부춘리 133-3	2026-01-29 23:28:25.891225	34.70711065	126.9182653	OFFICIAL	2026-01-29 23:28:25.891229	0	\N
1768	전라남도 장흥군 장흥읍 건산리 651-9	2026-01-29 23:28:25.891717	34.68597448	126.9076502	OFFICIAL	2026-01-29 23:28:25.891721	0	\N
1769	전라남도 장흥군 장흥읍 우산리 545-1	2026-01-29 23:28:25.892149	34.67237649	126.9247591	OFFICIAL	2026-01-29 23:28:25.892153	0	\N
1770	전라남도 장흥군 장흥읍 건산리 1-1	2026-01-29 23:28:25.892565	34.68232676	126.9163015	OFFICIAL	2026-01-29 23:28:25.8926	0	\N
1771	전라남도 장흥군 장흥읍 흥성로 74 전라남도 장흥군 장흥읍 건산리 383-5	2026-01-29 23:28:25.893007	34.67713923	126.9113719	OFFICIAL	2026-01-29 23:28:25.893012	0	\N
1772	전라남도 장흥군 장흥읍 건산리 244-2	2026-01-29 23:28:25.893391	34.6766671	126.910908	OFFICIAL	2026-01-29 23:28:25.893395	0	\N
1773	전라남도 장흥군 장흥읍 예양1길 17-1 전라남도 장흥군 장흥읍 예양리 121-6	2026-01-29 23:28:25.893797	34.67384874	126.9018525	OFFICIAL	2026-01-29 23:28:25.893801	0	\N
1774	전라남도 장흥군 장흥읍 읍성로 132 전라남도 장흥군 장흥읍 남동리 28	2026-01-29 23:28:25.894177	34.67866823	126.8991879	OFFICIAL	2026-01-29 23:28:25.894181	0	\N
1775	전라남도 장흥군 장흥읍 장원길 10-24 전라남도 장흥군 장흥읍 동동리 197-2	2026-01-29 23:28:25.894552	34.6802488	126.8985426	OFFICIAL	2026-01-29 23:28:25.894557	0	\N
1776	전라남도 장흥군 장흥읍 기양리 155	2026-01-29 23:28:25.894953	34.68257093	126.9005626	OFFICIAL	2026-01-29 23:28:25.894957	0	\N
1777	전라남도 장흥군 장흥읍 건산리 669-14	2026-01-29 23:28:25.89533	34.68447145	126.9070959	OFFICIAL	2026-01-29 23:28:25.895334	0	\N
1778	전라남도 장흥군 장흥읍 건산리 565-11	2026-01-29 23:28:25.89571	34.68597737	126.9112391	OFFICIAL	2026-01-29 23:28:25.895715	0	\N
1779	전라남도 장흥군 장흥읍 동교로 20 전라남도 장흥군 장흥읍 건산리 702-1	2026-01-29 23:28:25.896141	34.68182377	126.9053472	OFFICIAL	2026-01-29 23:28:25.896155	0	\N
1780	전라남도 장흥군 장흥읍 건산리 448-9	2026-01-29 23:28:25.896531	34.68146878	126.9116445	OFFICIAL	2026-01-29 23:28:25.896535	0	\N
1781	전라남도 장흥군 장흥읍 잣두길 26 전라남도 장흥군 장흥읍 행원리 992-1	2026-01-29 23:28:25.896936	34.69070063	126.8998679	OFFICIAL	2026-01-29 23:28:25.89694	0	\N
1782	전라남도 장흥군 장흥읍 건산리 478-19	2026-01-29 23:28:25.897324	34.67907442	126.9086888	OFFICIAL	2026-01-29 23:28:25.897329	0	\N
1783	전라남도 장흥군 장흥읍 건산리 732-14	2026-01-29 23:28:25.897742	34.67942171	126.9066245	OFFICIAL	2026-01-29 23:28:25.897769	0	\N
1784	경기도 동두천시 중앙로 125 경기도 동두천시 지행동 691-5	2026-01-29 23:28:25.898142	37.89275704	127.0517467	OFFICIAL	2026-01-29 23:28:25.898146	0	\N
1785	경기도 동두천시 평화로 2333 경기도 동두천시 지행동 745-10	2026-01-29 23:28:25.898522	37.89600876	127.0574953	OFFICIAL	2026-01-29 23:28:25.898526	0	\N
1786	경기도 동두천시 중앙로 130 경기도 동두천시 지행동 693-1	2026-01-29 23:28:25.898947	37.89302678	127.0525603	OFFICIAL	2026-01-29 23:28:25.898951	0	\N
1787	경기도 동두천시 평화로 2371 경기도 동두천시 생연동 732-4	2026-01-29 23:28:25.899323	37.89940724	127.057627	OFFICIAL	2026-01-29 23:28:25.899327	0	\N
1788	경기도 동두천시 삼육사로 975 경기도 동두천시 생연동 370-2	2026-01-29 23:28:25.899701	37.89930865	127.0582298	OFFICIAL	2026-01-29 23:28:25.899705	0	\N
1789	경기도 동두천시 평화로 2285 경기도 동두천시 지행동 424-1	2026-01-29 23:28:25.900104	37.89187746	127.0556642	OFFICIAL	2026-01-29 23:28:25.900108	0	\N
1790	경기도 동두천시 평화로 2285 경기도 동두천시 지행동 424-1	2026-01-29 23:28:25.900499	37.89187746	127.0556642	OFFICIAL	2026-01-29 23:28:25.900503	0	\N
1791	경기도 동두천시 지행로 67 경기도 동두천시 지행동 695-4	2026-01-29 23:28:25.9009	37.89270189	127.054744	OFFICIAL	2026-01-29 23:28:25.900904	0	\N
1792	서울특별시 구로구 구로동로 25 서울특별시 구로구 가리봉동 88-18	2026-01-29 23:28:25.901279	37.48387266	126.8863248	OFFICIAL	2026-01-29 23:28:25.901287	0	\N
1793	충청남도 논산시 연산면 연산사계7길 12 충청남도 논산시 연산면 장전리 405-1	2026-01-29 23:28:25.901776	36.2326756	127.1682026	OFFICIAL	2026-01-29 23:28:25.90178	0	\N
1794	충청남도 논산시 부적면 안골길 8 충청남도 논산시 부적면 신교리 114-12	2026-01-29 23:28:25.902173	36.1889054	127.1456836	OFFICIAL	2026-01-29 23:28:25.902177	0	\N
1795	충청남도 논산시 광석면 논산평야로1119번길 83 충청남도 논산시 광석면 사월리 151-9	2026-01-29 23:28:25.902592	36.2543496	127.104291	OFFICIAL	2026-01-29 23:28:25.902596	0	\N
1796	충청남도 논산시 채운면 계백로499번길 62 충청남도 논산시 채운면 장화리 872	2026-01-29 23:28:25.90299	36.1771758	127.0481859	OFFICIAL	2026-01-29 23:28:25.902994	0	\N
1797	충청남도 논산시 연무읍 황화정리 319-2	2026-01-29 23:28:25.90337	36.0899181	127.11443	OFFICIAL	2026-01-29 23:28:25.903374	0	\N
1798	충청남도 논산시 연무읍 황화정리 150	2026-01-29 23:28:25.903772	36.0855444	127.1140792	OFFICIAL	2026-01-29 23:28:25.903777	0	\N
1799	충청남도 논산시 연무읍 죽본3길 3-3 충청남도 논산시 연무읍 죽본리 325-1	2026-01-29 23:28:25.904135	36.1446467	127.1222835	OFFICIAL	2026-01-29 23:28:25.90414	0	\N
1800	충청남도 논산시 연무읍 노루목길 158 충청남도 논산시 연무읍 마전리 643	2026-01-29 23:28:25.904505	36.1073228	127.0833697	OFFICIAL	2026-01-29 23:28:25.904509	0	\N
1801	충청남도 논산시 양촌면 황산벌로 977-19 충청남도 논산시 양촌면 신흥리 199-1	2026-01-29 23:28:25.904954	36.1685261	127.2043933	OFFICIAL	2026-01-29 23:28:25.904959	0	\N
1802	충청남도 논산시 채운면 연은로15번길 44 충청남도 논산시 채운면 심암리 102	2026-01-29 23:28:25.905338	36.1411598	127.0814768	OFFICIAL	2026-01-29 23:28:25.905342	0	\N
1803	충청남도 논산시 부적면 반송길 102-3 충청남도 논산시 부적면 반송리 480-1	2026-01-29 23:28:25.90571	36.2080093	127.142774	OFFICIAL	2026-01-29 23:28:25.905714	0	\N
1804	충청남도 논산시 노성면 장마루로833번길 61 충청남도 논산시 노성면 효죽리 60-2	2026-01-29 23:28:25.906111	36.292083	127.0709522	OFFICIAL	2026-01-29 23:28:25.906115	0	\N
1805	충청남도 논산시 반월동 192-33	2026-01-29 23:28:25.906535	36.2044424	127.0821847	OFFICIAL	2026-01-29 23:28:25.906539	0	\N
1806	충청남도 논산시 반월동 170-3	2026-01-29 23:28:25.90695	36.2038459	127.083148	OFFICIAL	2026-01-29 23:28:25.906954	0	\N
1807	충청남도 논산시 은진면 매죽헌로411번길 36-1 충청남도 논산시 은진면 시묘리 300-2	2026-01-29 23:28:25.907333	36.1453264	127.1352103	OFFICIAL	2026-01-29 23:28:25.907338	0	\N
1808	충청남도 논산시 부적면 금성길 45 충청남도 논산시 부적면 탑정리 270-53	2026-01-29 23:28:25.907715	36.1900389	127.1353313	OFFICIAL	2026-01-29 23:28:25.907719	0	\N
1809	충청남도 논산시 부적면 덕평1길 35 충청남도 논산시 부적면 덕평리 781-3	2026-01-29 23:28:25.90813	36.2228655	127.136984	OFFICIAL	2026-01-29 23:28:25.908135	0	\N
1810	충청남도 논산시 벌곡면 수락로 503 충청남도 논산시 벌곡면 대덕리 370-1	2026-01-29 23:28:25.90851	36.1909104	127.2931046	OFFICIAL	2026-01-29 23:28:25.908514	0	\N
1811	충청남도 논산시 광석면 논산평야로 722-17 충청남도 논산시 광석면 산동리 8-329	2026-01-29 23:28:25.908907	36.2225568	127.0939306	OFFICIAL	2026-01-29 23:28:25.908911	0	\N
1812	충청남도 논산시 양촌면 매죽헌로1461번길 27 충청남도 논산시 양촌면 임화리 342-2	2026-01-29 23:28:25.909277	36.1309929	127.217426	OFFICIAL	2026-01-29 23:28:25.909281	0	\N
1813	충청남도 논산시 양촌면 이메4길 7 충청남도 논산시 양촌면 임화리 115-1	2026-01-29 23:28:25.909644	36.1126822	127.2346906	OFFICIAL	2026-01-29 23:28:25.909648	0	\N
1814	충청남도 논산시 연무읍 신화리 1374-2	2026-01-29 23:28:25.910014	36.1307815	127.0553337	OFFICIAL	2026-01-29 23:28:25.910018	0	\N
1815	충청남도 논산시 은진면 방축길 75 충청남도 논산시 은진면 방축리 58-4	2026-01-29 23:28:25.910383	36.1602569	127.095636	OFFICIAL	2026-01-29 23:28:25.910387	0	\N
1816	충청남도 논산시 부적면 신교1길 11 충청남도 논산시 부적면 신교리 558-20	2026-01-29 23:28:25.910781	36.1919907	127.1322967	OFFICIAL	2026-01-29 23:28:25.910785	0	\N
1817	충청남도 논산시 광석면 천동1길 42 충청남도 논산시 광석면 천동리 150-6	2026-01-29 23:28:25.911243	36.2404464	127.097496	OFFICIAL	2026-01-29 23:28:25.911248	0	\N
1818	충청남도 논산시 양촌면 이메1길 18-8 충청남도 논산시 양촌면 양촌리 210-3	2026-01-29 23:28:25.911628	36.1201519	127.2415056	OFFICIAL	2026-01-29 23:28:25.911632	0	\N
1819	충청남도 논산시 벌곡면 벌곡로313번길 5 충청남도 논산시 벌곡면 조동리 164-6	2026-01-29 23:28:25.912034	36.2227392	127.2939645	OFFICIAL	2026-01-29 23:28:25.912038	0	\N
1820	서울특별시 구로구 개봉로20길 74 서울특별시 구로구 개봉동 407-17	2026-01-29 23:28:25.912418	37.49328895	126.8584193	OFFICIAL	2026-01-29 23:28:25.912423	0	\N
1821	충청남도 논산시 연무읍 연무로404번길 14 충청남도 논산시 연무읍 마산리 432	2026-01-29 23:28:25.912821	36.1184384	127.1186647	OFFICIAL	2026-01-29 23:28:25.912825	0	\N
1822	충청남도 논산시 은진면 탑정로423번길 9-1 충청남도 논산시 은진면 교촌리 38-3	2026-01-29 23:28:25.913257	36.1701156	127.1111624	OFFICIAL	2026-01-29 23:28:25.913262	0	\N
1823	충청남도 논산시 연무읍 왕릉로232번길 10 충청남도 논산시 연무읍 안심리 933-3	2026-01-29 23:28:25.913711	36.1195363	127.0776738	OFFICIAL	2026-01-29 23:28:25.913715	0	\N
1824	충청남도 논산시 연무읍 득안대로84번길 17 충청남도 논산시 연무읍 마전리 251-7	2026-01-29 23:28:25.914145	36.0790349	127.0944449	OFFICIAL	2026-01-29 23:28:25.914148	0	\N
1825	충청남도 논산시 연무읍 황화로278번길 23-19 충청남도 논산시 연무읍 고내리 1096-88	2026-01-29 23:28:25.914591	36.0970559	127.0950603	OFFICIAL	2026-01-29 23:28:25.914596	0	\N
1826	충청남도 논산시 은진면 남산리 597-9	2026-01-29 23:28:25.91503	36.172563	127.0783876	OFFICIAL	2026-01-29 23:28:25.915035	0	\N
1827	충청남도 논산시 채운면 화정리 466	2026-01-29 23:28:25.915432	36.1384303	127.0711198	OFFICIAL	2026-01-29 23:28:25.915436	0	\N
1828	충청남도 논산시 부적면 탑정리 523	2026-01-29 23:28:25.915843	36.1859067	127.1384674	OFFICIAL	2026-01-29 23:28:25.915847	0	\N
1829	충청남도 논산시 광석면 오강길 73 충청남도 논산시 광석면 오강리 265	2026-01-29 23:28:25.916237	36.2583743	127.0718182	OFFICIAL	2026-01-29 23:28:25.916242	0	\N
1830	충청남도 논산시 성동면 원북길 75 충청남도 논산시 성동면 원북리 483-1	2026-01-29 23:28:25.916673	36.2257509	127.0377544	OFFICIAL	2026-01-29 23:28:25.916677	0	\N
1831	충청남도 논산시 성동면 논산평야로436번길 51 충청남도 논산시 성동면 원봉리 444-3	2026-01-29 23:28:25.917065	36.2106661	127.0653414	OFFICIAL	2026-01-29 23:28:25.917069	0	\N
1832	충청남도 논산시 연무읍 소룡리 638-43	2026-01-29 23:28:25.917444	36.1099993	127.1293327	OFFICIAL	2026-01-29 23:28:25.917448	0	\N
1833	충청남도 논산시 지산2길 35-1 충청남도 논산시 지산동 617-1	2026-01-29 23:28:25.91784	36.2026041	127.1157999	OFFICIAL	2026-01-29 23:28:25.917844	0	\N
1834	충청남도 논산시 양촌면 대둔로 359-26 충청남도 논산시 양촌면 산직리 311	2026-01-29 23:28:25.918277	36.1738797	127.2391216	OFFICIAL	2026-01-29 23:28:25.918282	0	\N
1835	충청남도 논산시 부적면 덕평리 805	2026-01-29 23:28:25.918807	36.2263928	127.1387139	OFFICIAL	2026-01-29 23:28:25.91881	0	\N
1836	충청남도 논산시 광석면 천동리 363-2	2026-01-29 23:28:25.919967	36.2397584	127.0934988	OFFICIAL	2026-01-29 23:28:25.919972	0	\N
1837	충청남도 논산시 성동면 병촌2길 13-1 충청남도 논산시 성동면 병촌리 276	2026-01-29 23:28:25.920323	36.195938	127.0134011	OFFICIAL	2026-01-29 23:28:25.920328	0	\N
1838	충청남도 논산시 은진면 매죽헌로37번길 13 충청남도 논산시 은진면 연서리 180-3	2026-01-29 23:28:25.920678	36.16732	127.1072925	OFFICIAL	2026-01-29 23:28:25.920682	0	\N
1839	충청남도 논산시 벌곡면 수락리 40-6	2026-01-29 23:28:25.92106	36.1541058	127.3075706	OFFICIAL	2026-01-29 23:28:25.921064	0	\N
1840	충청남도 논산시 부적면 계백로1459번길 26 충청남도 논산시 부적면 마구평리 2-19	2026-01-29 23:28:25.921404	36.2159587	127.136537	OFFICIAL	2026-01-29 23:28:25.921408	0	\N
1841	충청남도 논산시 관촉로277번길 23-15 충청남도 논산시 취암동 1043-13	2026-01-29 23:28:25.921741	36.2024825	127.0911036	OFFICIAL	2026-01-29 23:28:25.921745	0	\N
2073	서울특별시 마포구 신공덕동 56-74	2026-01-29 23:28:26.045441	37.54302821	126.9527869	OFFICIAL	2026-01-29 23:28:26.045445	0	\N
1842	충청남도 논산시 채운면 계백로339번길 138 충청남도 논산시 채운면 장화리 670	2026-01-29 23:28:25.922107	36.1744971	127.0344232	OFFICIAL	2026-01-29 23:28:25.922111	0	\N
1843	충청남도 논산시 은진면 와야길 49 충청남도 논산시 은진면 와야리 177-3	2026-01-29 23:28:25.922503	36.1811894	127.1156845	OFFICIAL	2026-01-29 23:28:25.922507	0	\N
1844	충청남도 논산시 벌곡면 도산리 125-2	2026-01-29 23:28:25.922887	36.1611621	127.3137327	OFFICIAL	2026-01-29 23:28:25.922892	0	\N
1845	충청남도 논산시 연산면 한전리 496	2026-01-29 23:28:25.923324	36.2122497	127.187414	OFFICIAL	2026-01-29 23:28:25.923329	0	\N
1846	충청남도 논산시 연산면 화악길 92 충청남도 논산시 연산면 화악리 259-4	2026-01-29 23:28:25.923785	36.2503712	127.2211131	OFFICIAL	2026-01-29 23:28:25.92379	0	\N
1847	충청남도 논산시 연무읍 금곡길 47-2 충청남도 논산시 연무읍 금곡리 117-5	2026-01-29 23:28:25.924179	36.113955	127.0939115	OFFICIAL	2026-01-29 23:28:25.924183	0	\N
1848	서울특별시 구로구 개봉로20길 74 서울특별시 구로구 개봉동 407-17	2026-01-29 23:28:25.924564	37.49328895	126.8584193	OFFICIAL	2026-01-29 23:28:25.924568	0	\N
1849	서울특별시 마포구 상암동 1626	2026-01-29 23:28:25.924952	37.5742349	126.8983876	OFFICIAL	2026-01-29 23:28:25.924956	0	\N
1850	서울특별시 마포구 월드컵로 205 서울특별시 마포구 성산동 595	2026-01-29 23:28:25.925333	37.56504756	126.9014996	OFFICIAL	2026-01-29 23:28:25.925337	0	\N
1851	서울특별시 마포구 월드컵로 213 서울특별시 마포구 성산동 595-1	2026-01-29 23:28:25.925705	37.56544396	126.9008029	OFFICIAL	2026-01-29 23:28:25.925709	0	\N
1852	서울특별시 마포구 성산동 665	2026-01-29 23:28:25.92609	37.56827661	126.8927642	OFFICIAL	2026-01-29 23:28:25.926094	0	\N
1853	서울특별시 마포구 성산동 665	2026-01-29 23:28:25.926461	37.56827661	126.8927642	OFFICIAL	2026-01-29 23:28:25.926465	0	\N
1854	서울특별시 마포구 월드컵북로43길 11 서울특별시 마포구 상암동 1630	2026-01-29 23:28:25.926837	37.57466828	126.8957125	OFFICIAL	2026-01-29 23:28:25.926842	0	\N
1855	서울특별시 마포구 월드컵북로 69 서울특별시 마포구 성산동 232-4	2026-01-29 23:28:25.927202	37.55993081	126.9163426	OFFICIAL	2026-01-29 23:28:25.927206	0	\N
1856	서울특별시 마포구 상암동 1707	2026-01-29 23:28:25.927565	37.57887956	126.8919606	OFFICIAL	2026-01-29 23:28:25.927569	0	\N
1857	서울특별시 마포구 월드컵북로 137 서울특별시 마포구 성산동 56-1	2026-01-29 23:28:25.927961	37.56482585	126.9116621	OFFICIAL	2026-01-29 23:28:25.927966	0	\N
1858	서울특별시 마포구 월드컵북로 260 서울특별시 마포구 성산동 446	2026-01-29 23:28:25.92833	37.57306208	126.9010479	OFFICIAL	2026-01-29 23:28:25.928334	0	\N
1859	서울특별시 마포구 월드컵로 158 서울특별시 마포구 성산동 266-1	2026-01-29 23:28:25.928742	37.56196342	126.905207	OFFICIAL	2026-01-29 23:28:25.928768	0	\N
1860	서울특별시 마포구 성산동 99-6	2026-01-29 23:28:25.92916	37.56569253	126.9123257	OFFICIAL	2026-01-29 23:28:25.929164	0	\N
1861	서울특별시 마포구 월드컵로 108 서울특별시 마포구 성산동 252-22	2026-01-29 23:28:25.929525	37.55824513	126.9084431	OFFICIAL	2026-01-29 23:28:25.929529	0	\N
1862	서울특별시 마포구 월드컵로 100 서울특별시 마포구 성산동 649-4	2026-01-29 23:28:25.929914	37.55762081	126.9089982	OFFICIAL	2026-01-29 23:28:25.929918	0	\N
1863	서울특별시 마포구 월드컵로 74 서울특별시 마포구 서교동 475-13	2026-01-29 23:28:25.930276	37.5557822	126.9107286	OFFICIAL	2026-01-29 23:28:25.93028	0	\N
1864	서울특별시 마포구 상암동 1622-1	2026-01-29 23:28:25.930645	37.57712976	126.8978247	OFFICIAL	2026-01-29 23:28:25.930649	0	\N
1865	서울특별시 마포구 성산동 191-33	2026-01-29 23:28:25.931015	37.563845	126.9066719	OFFICIAL	2026-01-29 23:28:25.93102	0	\N
1866	서울특별시 마포구 성산동 280-7	2026-01-29 23:28:25.931375	37.56302533	126.9046698	OFFICIAL	2026-01-29 23:28:25.931379	0	\N
1867	서울특별시 마포구 성산동 280-7	2026-01-29 23:28:25.931739	37.56302533	126.9046698	OFFICIAL	2026-01-29 23:28:25.931743	0	\N
1868	서울특별시 마포구 상암동 1756-4	2026-01-29 23:28:25.932121	37.58440628	126.8834663	OFFICIAL	2026-01-29 23:28:25.932125	0	\N
1869	서울특별시 마포구 상암동 1694-1	2026-01-29 23:28:25.932478	37.58541095	126.8853832	OFFICIAL	2026-01-29 23:28:25.932482	0	\N
1870	서울특별시 마포구 성산동 313-1	2026-01-29 23:28:25.932866	37.56256223	126.9026338	OFFICIAL	2026-01-29 23:28:25.932871	0	\N
1871	서울특별시 마포구 월드컵북로62길 11 서울특별시 마포구 상암동 1582	2026-01-29 23:28:25.933229	37.5836103	126.8844155	OFFICIAL	2026-01-29 23:28:25.933233	0	\N
1872	서울특별시 마포구 성산동 196-2	2026-01-29 23:28:25.933586	37.56412724	126.9063815	OFFICIAL	2026-01-29 23:28:25.93359	0	\N
1873	서울특별시 마포구 상암동 1715	2026-01-29 23:28:25.934048	37.5799712	126.8876108	OFFICIAL	2026-01-29 23:28:25.934052	0	\N
1874	서울특별시 마포구 성산동 196-2	2026-01-29 23:28:25.934419	37.56412724	126.9063815	OFFICIAL	2026-01-29 23:28:25.934423	0	\N
1875	서울특별시 마포구 월드컵로 54 서울특별시 마포구 서교동 444-1	2026-01-29 23:28:25.934804	37.5541167	126.9120342	OFFICIAL	2026-01-29 23:28:25.934808	0	\N
1876	서울특별시 마포구 성암로 201 서울특별시 마포구 상암동 1620	2026-01-29 23:28:25.935171	37.5775885	126.896952	OFFICIAL	2026-01-29 23:28:25.935175	0	\N
1877	서울특별시 마포구 성암로 201 서울특별시 마포구 상암동 1620	2026-01-29 23:28:25.935527	37.5775885	126.896952	OFFICIAL	2026-01-29 23:28:25.935531	0	\N
1878	서울특별시 마포구 상암동 1695	2026-01-29 23:28:25.936841	37.5814607	126.8917094	OFFICIAL	2026-01-29 23:28:25.936847	0	\N
1879	서울특별시 마포구 상암동 1138	2026-01-29 23:28:25.937293	37.57666476	126.89892	OFFICIAL	2026-01-29 23:28:25.937297	0	\N
1880	서울특별시 마포구 월드컵로 지하190	2026-01-29 23:28:25.937781	37.564186	126.903288	OFFICIAL	2026-01-29 23:28:25.937793	0	\N
1881	서울특별시 마포구 성암로 37 서울특별시 마포구 중동 299	2026-01-29 23:28:25.938203	37.5691456	126.9122909	OFFICIAL	2026-01-29 23:28:25.938207	0	\N
1882	서울특별시 마포구 성산동 665	2026-01-29 23:28:25.938575	37.56827661	126.8927642	OFFICIAL	2026-01-29 23:28:25.938579	0	\N
1883	서울특별시 마포구 상암동 37-36	2026-01-29 23:28:25.938975	37.57641429	126.8933237	OFFICIAL	2026-01-29 23:28:25.938978	0	\N
1884	서울특별시 마포구 상암동 487-137	2026-01-29 23:28:25.939338	37.56129274	126.8877722	OFFICIAL	2026-01-29 23:28:25.939342	0	\N
1885	서울특별시 마포구 상암동 487-137	2026-01-29 23:28:25.939701	37.56129274	126.8877722	OFFICIAL	2026-01-29 23:28:25.939705	0	\N
1886	서울특별시 마포구 월드컵북로47길 46 서울특별시 마포구 상암동 1637	2026-01-29 23:28:25.940101	37.57488209	126.8907326	OFFICIAL	2026-01-29 23:28:25.940104	0	\N
1887	서울특별시 마포구 월드컵북로47길 46 서울특별시 마포구 상암동 1637	2026-01-29 23:28:25.94047	37.57488209	126.8907326	OFFICIAL	2026-01-29 23:28:25.940474	0	\N
1888	서울특별시 마포구 성산동 665	2026-01-29 23:28:25.940832	37.56827661	126.8927642	OFFICIAL	2026-01-29 23:28:25.940836	0	\N
1889	서울특별시 마포구 월드컵로 220 서울특별시 마포구 성산동 369-2	2026-01-29 23:28:25.941194	37.5673618	126.9006703	OFFICIAL	2026-01-29 23:28:25.941197	0	\N
1890	서울특별시 마포구 월드컵로 220 서울특별시 마포구 성산동 369-2	2026-01-29 23:28:25.941552	37.5673618	126.9006703	OFFICIAL	2026-01-29 23:28:25.941556	0	\N
1891	서울특별시 마포구 상암동 1715	2026-01-29 23:28:25.941968	37.5799712	126.8876108	OFFICIAL	2026-01-29 23:28:25.941972	0	\N
1892	서울특별시 마포구 월드컵북로 235 서울특별시 마포구 성산동 446	2026-01-29 23:28:25.942327	37.56970041	126.9014174	OFFICIAL	2026-01-29 23:28:25.942331	0	\N
1893	서울특별시 마포구 월드컵북로 381 서울특별시 마포구 상암동 1655	2026-01-29 23:28:25.942685	37.57795288	126.8898876	OFFICIAL	2026-01-29 23:28:25.942689	0	\N
1894	서울특별시 마포구 월드컵북로 381 서울특별시 마포구 상암동 1655	2026-01-29 23:28:25.943062	37.57795288	126.8898876	OFFICIAL	2026-01-29 23:28:25.943066	0	\N
1895	서울특별시 마포구 월드컵북로 381 서울특별시 마포구 상암동 1655	2026-01-29 23:28:25.943445	37.57795288	126.8898876	OFFICIAL	2026-01-29 23:28:25.943449	0	\N
1896	서울특별시 마포구 월드컵로 212 서울특별시 마포구 성산동 370	2026-01-29 23:28:25.943829	37.56631284	126.9016157	OFFICIAL	2026-01-29 23:28:25.943833	0	\N
1897	서울특별시 마포구 월드컵로 212 서울특별시 마포구 성산동 370	2026-01-29 23:28:25.944198	37.56631284	126.9016157	OFFICIAL	2026-01-29 23:28:25.944202	0	\N
1898	서울특별시 마포구 상암산로1길 26 서울특별시 마포구 상암동 1657	2026-01-29 23:28:25.944554	37.57905692	126.8875508	OFFICIAL	2026-01-29 23:28:25.944557	0	\N
1899	서울특별시 마포구 월드컵로 204 서울특별시 마포구 성산동 591-1	2026-01-29 23:28:25.944948	37.56539921	126.9021318	OFFICIAL	2026-01-29 23:28:25.944951	0	\N
1900	서울특별시 마포구 월드컵로 202 서울특별시 마포구 성산동 591-2	2026-01-29 23:28:25.945318	37.56528704	126.9024641	OFFICIAL	2026-01-29 23:28:25.945321	0	\N
1901	서울특별시 마포구 상암산로1길 52 서울특별시 마포구 상암동 1658	2026-01-29 23:28:25.945672	37.58080737	126.8853953	OFFICIAL	2026-01-29 23:28:25.945676	0	\N
1902	서울특별시 마포구 상암산로1길 52 서울특별시 마포구 상암동 1658	2026-01-29 23:28:25.946043	37.58080737	126.8853953	OFFICIAL	2026-01-29 23:28:25.946046	0	\N
1903	서울특별시 마포구 상암동 1715-25	2026-01-29 23:28:25.946415	37.58214488	126.8834433	OFFICIAL	2026-01-29 23:28:25.946418	0	\N
1904	서울특별시 마포구 가양대로 124 서울특별시 마포구 상암동 1669	2026-01-29 23:28:25.946826	37.5807915	126.8784504	OFFICIAL	2026-01-29 23:28:25.94683	0	\N
1905	서울특별시 마포구 상암동 1694-5	2026-01-29 23:28:25.947194	37.58192134	126.8794618	OFFICIAL	2026-01-29 23:28:25.947198	0	\N
1906	서울특별시 마포구 성산동 24-12	2026-01-29 23:28:25.947635	37.56590741	126.9146741	OFFICIAL	2026-01-29 23:28:25.94764	0	\N
1907	서울특별시 마포구 월드컵북로 136 서울특별시 마포구 성산동 51-11	2026-01-29 23:28:25.948071	37.56502512	126.9124737	OFFICIAL	2026-01-29 23:28:25.948076	0	\N
1908	서울특별시 마포구 월드컵북로 120 서울특별시 마포구 성산동 52-12	2026-01-29 23:28:25.948454	37.56394457	126.9133439	OFFICIAL	2026-01-29 23:28:25.948457	0	\N
1909	서울특별시 마포구 월드컵북로 78 서울특별시 마포구 성산동 209-1	2026-01-29 23:28:25.948853	37.56083654	126.916147	OFFICIAL	2026-01-29 23:28:25.948857	0	\N
1910	서울특별시 마포구 월드컵북로54길 12 서울특별시 마포구 상암동 1602	2026-01-29 23:28:25.949225	37.58085428	126.8893321	OFFICIAL	2026-01-29 23:28:25.94923	0	\N
1911	서울특별시 마포구 월드컵북로6길 3 서울특별시 마포구 연남동 571-10	2026-01-29 23:28:25.949594	37.55788989	126.9189437	OFFICIAL	2026-01-29 23:28:25.949598	0	\N
1912	서울특별시 마포구 상암동 1715-6	2026-01-29 23:28:25.949989	37.57923225	126.8894082	OFFICIAL	2026-01-29 23:28:25.949994	0	\N
1913	서울특별시 마포구 월드컵북로 15 서울특별시 마포구 서교동 445-3	2026-01-29 23:28:25.950371	37.55620886	126.9199478	OFFICIAL	2026-01-29 23:28:25.950375	0	\N
1914	서울특별시 마포구 월드컵북로 396 서울특별시 마포구 상암동 1605	2026-01-29 23:28:25.950735	37.57944191	126.8903226	OFFICIAL	2026-01-29 23:28:25.950739	0	\N
1915	서울특별시 마포구 월드컵북로 396 서울특별시 마포구 상암동 1605	2026-01-29 23:28:25.951142	37.57944191	126.8903226	OFFICIAL	2026-01-29 23:28:25.951146	0	\N
1916	서울특별시 마포구 상암동 1757	2026-01-29 23:28:25.951507	37.58633427	126.8815182	OFFICIAL	2026-01-29 23:28:25.951511	0	\N
1917	서울특별시 마포구 상암동 1758	2026-01-29 23:28:25.951887	37.58453485	126.8798665	OFFICIAL	2026-01-29 23:28:25.951891	0	\N
1918	서울특별시 마포구 월드컵로42길 9-1 서울특별시 마포구 상암동 1730	2026-01-29 23:28:25.952253	37.57818563	126.8817095	OFFICIAL	2026-01-29 23:28:25.952257	0	\N
1919	서울특별시 마포구 상암동 478-13	2026-01-29 23:28:25.952619	37.57736261	126.8808259	OFFICIAL	2026-01-29 23:28:25.952622	0	\N
1920	서울특별시 마포구 상암동 478-13	2026-01-29 23:28:25.953007	37.57736261	126.8808259	OFFICIAL	2026-01-29 23:28:25.953011	0	\N
1921	서울특별시 마포구 상암동 1542-4	2026-01-29 23:28:25.953372	37.57852263	126.8795509	OFFICIAL	2026-01-29 23:28:25.953376	0	\N
1922	서울특별시 마포구 상암동 1542-4	2026-01-29 23:28:25.953742	37.57852263	126.8795509	OFFICIAL	2026-01-29 23:28:25.95377	0	\N
1923	서울특별시 마포구 상암동 1731-9	2026-01-29 23:28:25.954132	37.57310152	126.8876032	OFFICIAL	2026-01-29 23:28:25.954136	0	\N
1924	서울특별시 마포구 월드컵로42길 22 서울특별시 마포구 상암동 1761	2026-01-29 23:28:25.954497	37.5795486	126.8831094	OFFICIAL	2026-01-29 23:28:25.954501	0	\N
1925	서울특별시 마포구 성산동 665-1	2026-01-29 23:28:25.954985	37.56911709	126.8912548	OFFICIAL	2026-01-29 23:28:25.95499	0	\N
1926	서울특별시 마포구 성산동 665	2026-01-29 23:28:25.955514	37.56827661	126.8927642	OFFICIAL	2026-01-29 23:28:25.955518	0	\N
1927	서울특별시 마포구 성산동 664	2026-01-29 23:28:25.955961	37.57048737	126.8961489	OFFICIAL	2026-01-29 23:28:25.955965	0	\N
1928	서울특별시 마포구 성산동 664	2026-01-29 23:28:25.956366	37.57048737	126.8961489	OFFICIAL	2026-01-29 23:28:25.956371	0	\N
1929	서울특별시 마포구 월드컵북로 157 서울특별시 마포구 성산동 95-14	2026-01-29 23:28:25.956824	37.5663123	126.9103618	OFFICIAL	2026-01-29 23:28:25.956828	0	\N
1930	서울특별시 마포구 서강로 51 서울특별시 마포구 창전동 256-2	2026-01-29 23:28:25.957243	37.54775312	126.9311541	OFFICIAL	2026-01-29 23:28:25.957247	0	\N
1931	서울특별시 마포구 서강로 55 서울특별시 마포구 창전동 444	2026-01-29 23:28:25.957627	37.54828681	126.9313562	OFFICIAL	2026-01-29 23:28:25.957632	0	\N
1932	서울특별시 마포구 서강로 55 서울특별시 마포구 창전동 444	2026-01-29 23:28:25.958007	37.54828681	126.9313562	OFFICIAL	2026-01-29 23:28:25.958011	0	\N
1933	서울특별시 마포구 창전동 12-34	2026-01-29 23:28:25.958454	37.55112096	126.932607	OFFICIAL	2026-01-29 23:28:25.958458	0	\N
1934	서울특별시 마포구 서강로 97 서울특별시 마포구 창전동 437	2026-01-29 23:28:25.958887	37.55193462	126.9323486	OFFICIAL	2026-01-29 23:28:25.958891	0	\N
1935	서울특별시 구로구 개봉로20길 54 서울특별시 구로구 개봉동 407-14	2026-01-29 23:28:25.959274	37.49343625	126.8573608	OFFICIAL	2026-01-29 23:28:25.959278	0	\N
1936	서울특별시 마포구 창전동 2-126	2026-01-29 23:28:25.959656	37.55276683	126.9330602	OFFICIAL	2026-01-29 23:28:25.95966	0	\N
1937	서울특별시 마포구 신촌로16길 29 서울특별시 마포구 노고산동 57-50	2026-01-29 23:28:25.960113	37.55409824	126.9347633	OFFICIAL	2026-01-29 23:28:25.960118	0	\N
1938	서울특별시 마포구 서강로 137 서울특별시 마포구 노고산동 57-26	2026-01-29 23:28:25.960578	37.55466827	126.9355938	OFFICIAL	2026-01-29 23:28:25.960583	0	\N
1939	서울특별시 마포구 서강로 137 서울특별시 마포구 노고산동 57-26	2026-01-29 23:28:25.960966	37.55466827	126.9355938	OFFICIAL	2026-01-29 23:28:25.96097	0	\N
1940	서울특별시 마포구 서강로 118 서울특별시 마포구 노고산동 112-5	2026-01-29 23:28:25.961343	37.55322915	126.9343748	OFFICIAL	2026-01-29 23:28:25.961348	0	\N
1941	서울특별시 마포구 창전로 60 서울특별시 마포구 구수동 2-3	2026-01-29 23:28:25.961711	37.54779701	126.9328946	OFFICIAL	2026-01-29 23:28:25.961715	0	\N
1942	서울특별시 마포구 창전로 60 서울특별시 마포구 구수동 2-3	2026-01-29 23:28:25.962105	37.54779701	126.9328946	OFFICIAL	2026-01-29 23:28:25.962109	0	\N
1943	서울특별시 마포구 독막로 165 서울특별시 마포구 창전동 242	2026-01-29 23:28:25.962477	37.54773473	126.9320618	OFFICIAL	2026-01-29 23:28:25.962481	0	\N
1944	서울특별시 마포구 창전동 236	2026-01-29 23:28:25.962963	37.54711325	126.931429	OFFICIAL	2026-01-29 23:28:25.962967	0	\N
1945	서울특별시 마포구 신촌로 94 서울특별시 마포구 노고산동 57-1	2026-01-29 23:28:25.96333	37.55499447	126.9359976	OFFICIAL	2026-01-29 23:28:25.963334	0	\N
1946	서울특별시 마포구 신촌로 82 서울특별시 마포구 노고산동 49-46	2026-01-29 23:28:25.963697	37.55561127	126.9348093	OFFICIAL	2026-01-29 23:28:25.963701	0	\N
1947	서울특별시 마포구 신촌로 82 서울특별시 마포구 노고산동 49-46	2026-01-29 23:28:25.964095	37.55561127	126.9348093	OFFICIAL	2026-01-29 23:28:25.964099	0	\N
1948	서울특별시 마포구 신촌로 66 서울특별시 마포구 노고산동 49-31	2026-01-29 23:28:25.964454	37.5560665	126.9331166	OFFICIAL	2026-01-29 23:28:25.964458	0	\N
1949	서울특별시 마포구 와우산로 157 서울특별시 마포구 서교동 327-9	2026-01-29 23:28:25.96484	37.5550833	126.9301095	OFFICIAL	2026-01-29 23:28:25.964844	0	\N
1950	서울특별시 마포구 와우산로 121 서울특별시 마포구 서교동 338-8	2026-01-29 23:28:25.965193	37.55350885	126.926757	OFFICIAL	2026-01-29 23:28:25.965197	0	\N
1951	서울특별시 마포구 와우산로 97 서울특별시 마포구 서교동 344-12	2026-01-29 23:28:25.965566	37.55309395	126.9243535	OFFICIAL	2026-01-29 23:28:25.965569	0	\N
1952	서울특별시 마포구 와우산로 71 서울특별시 마포구 서교동 363-2	2026-01-29 23:28:25.96595	37.55088076	126.9228524	OFFICIAL	2026-01-29 23:28:25.965954	0	\N
1953	서울특별시 마포구 와우산로 56 서울특별시 마포구 상수동 89-1	2026-01-29 23:28:25.966318	37.54944456	126.9233972	OFFICIAL	2026-01-29 23:28:25.966322	0	\N
1954	서울특별시 마포구 와우산로 55 서울특별시 마포구 상수동 90-9	2026-01-29 23:28:25.966676	37.54937991	126.9228941	OFFICIAL	2026-01-29 23:28:25.96668	0	\N
1955	서울특별시 마포구 독막로 5 서울특별시 마포구 합정동 414-3	2026-01-29 23:28:25.967036	37.54901989	126.9143079	OFFICIAL	2026-01-29 23:28:25.96704	0	\N
1956	서울특별시 마포구 독막로 5 서울특별시 마포구 합정동 414-3	2026-01-29 23:28:25.967399	37.54901989	126.9143079	OFFICIAL	2026-01-29 23:28:25.967403	0	\N
1957	서울특별시 마포구 독막로 16 서울특별시 마포구 합정동 364-37	2026-01-29 23:28:25.967785	37.54844301	126.9150957	OFFICIAL	2026-01-29 23:28:25.967789	0	\N
1958	서울특별시 마포구 독막로 36 서울특별시 마포구 합정동 363-2	2026-01-29 23:28:25.968135	37.5479499	126.9173864	OFFICIAL	2026-01-29 23:28:25.968139	0	\N
1959	서울특별시 마포구 독막로 37 서울특별시 마포구 합정동 412-12	2026-01-29 23:28:25.968491	37.54827448	126.9176949	OFFICIAL	2026-01-29 23:28:25.968495	0	\N
1960	서울특별시 마포구 독막로 63 서울특별시 마포구 상수동 317-12	2026-01-29 23:28:25.968863	37.54799414	126.9205318	OFFICIAL	2026-01-29 23:28:25.968867	0	\N
1961	서울특별시 마포구 독막로 74 서울특별시 마포구 상수동 323-3	2026-01-29 23:28:25.96922	37.5476338	126.9215759	OFFICIAL	2026-01-29 23:28:25.969224	0	\N
1962	서울특별시 마포구 독막로 63 서울특별시 마포구 상수동 317-12	2026-01-29 23:28:25.969613	37.54799414	126.9205318	OFFICIAL	2026-01-29 23:28:25.969616	0	\N
1963	서울특별시 구로구 개봉로20길 54 서울특별시 구로구 개봉동 407-14	2026-01-29 23:28:25.969997	37.49343625	126.8573608	OFFICIAL	2026-01-29 23:28:25.970001	0	\N
1964	서울특별시 마포구 독막로 101 서울특별시 마포구 상수동 141-1	2026-01-29 23:28:25.970356	37.54824385	126.924449	OFFICIAL	2026-01-29 23:28:25.97036	0	\N
1965	서울특별시 마포구 상수동 128-1	2026-01-29 23:28:25.970707	37.54758363	126.9262393	OFFICIAL	2026-01-29 23:28:25.970711	0	\N
1966	서울특별시 마포구 양화로 29 서울특별시 마포구 합정동 383-11	2026-01-29 23:28:25.971107	37.54915893	126.9124833	OFFICIAL	2026-01-29 23:28:25.971111	0	\N
1967	서울특별시 마포구 양화로 29 서울특별시 마포구 합정동 383-11	2026-01-29 23:28:25.971475	37.54915893	126.9124833	OFFICIAL	2026-01-29 23:28:25.971479	0	\N
1968	서울특별시 마포구 양화로 33-1 서울특별시 마포구 합정동 383-36	2026-01-29 23:28:25.971834	37.54916598	126.9127609	OFFICIAL	2026-01-29 23:28:25.971838	0	\N
1969	서울특별시 마포구 양화로 33-1 서울특별시 마포구 합정동 383-36	2026-01-29 23:28:25.972193	37.54916598	126.9127609	OFFICIAL	2026-01-29 23:28:25.972197	0	\N
1970	서울특별시 마포구 양화로 57 서울특별시 마포구 서교동 393-12	2026-01-29 23:28:25.972551	37.55048476	126.9147075	OFFICIAL	2026-01-29 23:28:25.972555	0	\N
1971	서울특별시 마포구 양화로 68 서울특별시 마포구 서교동 395-44	2026-01-29 23:28:25.97293	37.55075668	126.9160934	OFFICIAL	2026-01-29 23:28:25.972934	0	\N
1972	서울특별시 마포구 양화로 68 서울특별시 마포구 서교동 395-44	2026-01-29 23:28:25.973297	37.55075668	126.9160934	OFFICIAL	2026-01-29 23:28:25.973301	0	\N
1973	서울특별시 마포구 양화로 99 서울특별시 마포구 서교동 374-10	2026-01-29 23:28:25.973655	37.55306059	126.9182338	OFFICIAL	2026-01-29 23:28:25.973659	0	\N
1974	서울특별시 마포구 양화로 107 서울특별시 마포구 서교동 374-6	2026-01-29 23:28:25.974013	37.55358661	126.9187818	OFFICIAL	2026-01-29 23:28:25.974017	0	\N
1975	서울특별시 마포구 양화로 100-2 서울특별시 마포구 서교동 427	2026-01-29 23:28:25.97438	37.5528524	126.9186684	OFFICIAL	2026-01-29 23:28:25.974384	0	\N
1976	서울특별시 마포구 양화로 119 서울특별시 마포구 서교동 353-7	2026-01-29 23:28:25.974738	37.55436061	126.9197696	OFFICIAL	2026-01-29 23:28:25.974742	0	\N
1977	서울특별시 마포구 양화로 129 서울특별시 마포구 서교동 353-2	2026-01-29 23:28:25.975122	37.55506077	126.9206937	OFFICIAL	2026-01-29 23:28:25.975126	0	\N
1978	서울특별시 마포구 양화로 153 서울특별시 마포구 동교동 159-8	2026-01-29 23:28:25.975475	37.55649437	126.9226319	OFFICIAL	2026-01-29 23:28:25.975479	0	\N
1979	서울특별시 마포구 양화로 162 서울특별시 마포구 동교동 165-5	2026-01-29 23:28:25.975832	37.55642986	126.9238714	OFFICIAL	2026-01-29 23:28:25.975835	0	\N
1980	서울특별시 마포구 동교동 155-55	2026-01-29 23:28:25.976187	37.55637208	126.9231257	OFFICIAL	2026-01-29 23:28:25.976191	0	\N
1981	서울특별시 마포구 양화로 171 서울특별시 마포구 동교동 156-4	2026-01-29 23:28:25.976541	37.55753207	126.9240527	OFFICIAL	2026-01-29 23:28:25.976545	0	\N
1982	서울특별시 마포구 양화로 183 서울특별시 마포구 동교동 155-27	2026-01-29 23:28:25.976956	37.55836755	126.9251484	OFFICIAL	2026-01-29 23:28:25.97696	0	\N
1983	서울특별시 마포구 양화로 183 서울특별시 마포구 동교동 155-27	2026-01-29 23:28:25.977324	37.55836755	126.9251484	OFFICIAL	2026-01-29 23:28:25.977328	0	\N
1984	서울특별시 마포구 연희로 1-1 서울특별시 마포구 동교동 147-5	2026-01-29 23:28:25.97768	37.55901257	126.926145	OFFICIAL	2026-01-29 23:28:25.977684	0	\N
1985	서울특별시 마포구 연희로 43 서울특별시 마포구 연남동 226-36	2026-01-29 23:28:25.978043	37.56261343	126.9275008	OFFICIAL	2026-01-29 23:28:25.978047	0	\N
1986	서울특별시 마포구 연희로 43 서울특별시 마포구 연남동 226-36	2026-01-29 23:28:25.978401	37.56261343	126.9275008	OFFICIAL	2026-01-29 23:28:25.978405	0	\N
1987	서울특별시 마포구 양화로 188 서울특별시 마포구 동교동 190-1	2026-01-29 23:28:25.978788	37.55774581	126.9264983	OFFICIAL	2026-01-29 23:28:25.978792	0	\N
1988	서울특별시 마포구 양화로 188 서울특별시 마포구 동교동 190-1	2026-01-29 23:28:25.979143	37.55774581	126.9264983	OFFICIAL	2026-01-29 23:28:25.979147	0	\N
1989	서울특별시 마포구 동교동 155-55	2026-01-29 23:28:25.979526	37.55637208	126.9231257	OFFICIAL	2026-01-29 23:28:25.97953	0	\N
1990	서울특별시 마포구 동교동 155-55	2026-01-29 23:28:25.979919	37.55637208	126.9231257	OFFICIAL	2026-01-29 23:28:25.979923	0	\N
1991	서울특별시 마포구 양화로18길 3 서울특별시 마포구 동교동 166-13	2026-01-29 23:28:25.980281	37.55703127	126.9245703	OFFICIAL	2026-01-29 23:28:25.980285	0	\N
1992	서울특별시 마포구 양화로18길 3 서울특별시 마포구 동교동 166-13	2026-01-29 23:28:25.980636	37.55703127	126.9245703	OFFICIAL	2026-01-29 23:28:25.98064	0	\N
1993	서울특별시 마포구 양화로 136 서울특별시 마포구 서교동 354-1	2026-01-29 23:28:25.981001	37.55484181	126.9216064	OFFICIAL	2026-01-29 23:28:25.981005	0	\N
1994	서울특별시 마포구 양화로 136 서울특별시 마포구 서교동 354-1	2026-01-29 23:28:25.981362	37.55484181	126.9216064	OFFICIAL	2026-01-29 23:28:25.981365	0	\N
1995	서울특별시 마포구 양화로 136 서울특별시 마포구 서교동 354-1	2026-01-29 23:28:25.981716	37.55484181	126.9216064	OFFICIAL	2026-01-29 23:28:25.98172	0	\N
1996	서울특별시 마포구 양화로 136 서울특별시 마포구 서교동 354-1	2026-01-29 23:28:25.982121	37.55484181	126.9216064	OFFICIAL	2026-01-29 23:28:25.982125	0	\N
1997	서울특별시 마포구 양화로 100-2 서울특별시 마포구 서교동 427	2026-01-29 23:28:25.98249	37.5528524	126.9186684	OFFICIAL	2026-01-29 23:28:25.982494	0	\N
1998	서울특별시 마포구 양화로 100 서울특별시 마포구 서교동 372-1	2026-01-29 23:28:25.982868	37.55270402	126.918684	OFFICIAL	2026-01-29 23:28:25.982872	0	\N
1999	서울특별시 마포구 양화로 68 서울특별시 마포구 서교동 395-44	2026-01-29 23:28:25.983223	37.55075668	126.9160934	OFFICIAL	2026-01-29 23:28:25.983227	0	\N
2000	서울특별시 마포구 양화로 68 서울특별시 마포구 서교동 395-44	2026-01-29 23:28:25.983579	37.55075668	126.9160934	OFFICIAL	2026-01-29 23:28:25.983582	0	\N
2001	서울특별시 마포구 양화로 50 서울특별시 마포구 합정동 414-1	2026-01-29 23:28:26.01602	37.54952216	126.9145058	OFFICIAL	2026-01-29 23:28:26.016027	0	\N
2002	서울특별시 마포구 양화로 50 서울특별시 마포구 합정동 414-1	2026-01-29 23:28:26.016623	37.54952216	126.9145058	OFFICIAL	2026-01-29 23:28:26.016627	0	\N
2003	서울특별시 마포구 양화로 36 서울특별시 마포구 합정동 374-1	2026-01-29 23:28:26.017507	37.54850913	126.9133377	OFFICIAL	2026-01-29 23:28:26.017521	0	\N
2004	서울특별시 마포구 월드컵로5길 11 서울특별시 마포구 합정동 473	2026-01-29 23:28:26.017984	37.55161665	126.911726	OFFICIAL	2026-01-29 23:28:26.017988	0	\N
2005	서울특별시 마포구 월드컵로5길 11 서울특별시 마포구 합정동 473	2026-01-29 23:28:26.018466	37.55161665	126.911726	OFFICIAL	2026-01-29 23:28:26.018471	0	\N
2006	서울특별시 마포구 월드컵로 30 서울특별시 마포구 서교동 383-17	2026-01-29 23:28:26.018918	37.55210603	126.9126397	OFFICIAL	2026-01-29 23:28:26.018923	0	\N
2007	서울특별시 마포구 월드컵로 39 서울특별시 마포구 합정동 427-20	2026-01-29 23:28:26.019308	37.55279206	126.9119181	OFFICIAL	2026-01-29 23:28:26.019313	0	\N
2008	서울특별시 마포구 월드컵로 54 서울특별시 마포구 서교동 444-1	2026-01-29 23:28:26.019708	37.5541167	126.9120342	OFFICIAL	2026-01-29 23:28:26.019712	0	\N
2009	서울특별시 마포구 월드컵로 51 서울특별시 마포구 합정동 427-4	2026-01-29 23:28:26.020101	37.55382052	126.9115313	OFFICIAL	2026-01-29 23:28:26.020105	0	\N
2010	서울특별시 마포구 도화동 293-1	2026-01-29 23:28:26.020506	37.54111288	126.948038	OFFICIAL	2026-01-29 23:28:26.02051	0	\N
2011	서울특별시 마포구 만리재로 88 서울특별시 마포구 공덕동 111-193	2026-01-29 23:28:26.020904	37.54811717	126.9591862	OFFICIAL	2026-01-29 23:28:26.020908	0	\N
2012	서울특별시 마포구 만리재로 83-1 서울특별시 마포구 공덕동 111-209	2026-01-29 23:28:26.021292	37.54815358	126.9587131	OFFICIAL	2026-01-29 23:28:26.021296	0	\N
2013	서울특별시 마포구 대흥동 2-1	2026-01-29 23:28:26.021665	37.55656965	126.9462676	OFFICIAL	2026-01-29 23:28:26.021669	0	\N
2014	서울특별시 마포구 대흥로 194 서울특별시 마포구 대흥동 2-10	2026-01-29 23:28:26.02204	37.55623344	126.946135	OFFICIAL	2026-01-29 23:28:26.022044	0	\N
2015	서울특별시 마포구 대흥로 122 서울특별시 마포구 대흥동 38-22	2026-01-29 23:28:26.022419	37.55040682	126.9442781	OFFICIAL	2026-01-29 23:28:26.022423	0	\N
2016	서울특별시 마포구 마포대로 247 서울특별시 마포구 아현동 267-1	2026-01-29 23:28:26.022812	37.55640071	126.9565	OFFICIAL	2026-01-29 23:28:26.022816	0	\N
2017	서울특별시 마포구 마포대로 247 서울특별시 마포구 아현동 267-1	2026-01-29 23:28:26.023184	37.55640071	126.9565	OFFICIAL	2026-01-29 23:28:26.023189	0	\N
2018	서울특별시 마포구 신촌로 234 서울특별시 마포구 아현동 347-13	2026-01-29 23:28:26.023555	37.5569132	126.9516554	OFFICIAL	2026-01-29 23:28:26.023559	0	\N
2019	서울특별시 마포구 신촌로 210 서울특별시 마포구 아현동 677-1	2026-01-29 23:28:26.023953	37.55671611	126.9489834	OFFICIAL	2026-01-29 23:28:26.023957	0	\N
2020	서울특별시 마포구 신촌로 174 서울특별시 마포구 대흥동 12-23	2026-01-29 23:28:26.024326	37.55648691	126.9449971	OFFICIAL	2026-01-29 23:28:26.02433	0	\N
2021	서울특별시 마포구 신촌로 174 서울특별시 마포구 대흥동 12-23	2026-01-29 23:28:26.024698	37.55648691	126.9449971	OFFICIAL	2026-01-29 23:28:26.024701	0	\N
2022	서울특별시 마포구 신촌로 110 서울특별시 마포구 노고산동 40-56	2026-01-29 23:28:26.025098	37.55515688	126.9381344	OFFICIAL	2026-01-29 23:28:26.025102	0	\N
2023	서울특별시 마포구 창전로 32 서울특별시 마포구 구수동 68-32	2026-01-29 23:28:26.025477	37.54515427	126.9319133	OFFICIAL	2026-01-29 23:28:26.025481	0	\N
2024	서울특별시 마포구 독막로 246 서울특별시 마포구 대흥동 328-55	2026-01-29 23:28:26.026022	37.54638913	126.9408559	OFFICIAL	2026-01-29 23:28:26.026027	0	\N
2025	서울특별시 마포구 독막로 242 서울특별시 마포구 대흥동 325-5	2026-01-29 23:28:26.026519	37.54659734	126.9402909	OFFICIAL	2026-01-29 23:28:26.026524	0	\N
2026	서울특별시 마포구 독막로 192 서울특별시 마포구 신수동 458	2026-01-29 23:28:26.026994	37.54715926	126.9351045	OFFICIAL	2026-01-29 23:28:26.026998	0	\N
2027	서울특별시 마포구 독막로 221 서울특별시 마포구 신수동 178-3	2026-01-29 23:28:26.027382	37.54753983	126.9384571	OFFICIAL	2026-01-29 23:28:26.027385	0	\N
2028	서울특별시 마포구 대흥동 325-84	2026-01-29 23:28:26.02779	37.54604406	126.9402563	OFFICIAL	2026-01-29 23:28:26.027794	0	\N
2029	서울특별시 마포구 백범로 88 서울특별시 마포구 대흥동 276-1	2026-01-29 23:28:26.028164	37.547947	126.9411092	OFFICIAL	2026-01-29 23:28:26.028169	0	\N
2030	서울특별시 마포구 노고산동 31-123	2026-01-29 23:28:26.028531	37.55495552	126.9368606	OFFICIAL	2026-01-29 23:28:26.028535	0	\N
2031	서울특별시 마포구 노고산동 31-123	2026-01-29 23:28:26.02896	37.55495552	126.9368606	OFFICIAL	2026-01-29 23:28:26.028965	0	\N
2032	서울특별시 마포구 백범로 91 서울특별시 마포구 대흥동 120	2026-01-29 23:28:26.029343	37.5482162	126.9418041	OFFICIAL	2026-01-29 23:28:26.029347	0	\N
2033	서울특별시 마포구 백범로 178 서울특별시 마포구 공덕동 461	2026-01-29 23:28:26.029728	37.54388177	126.9500762	OFFICIAL	2026-01-29 23:28:26.029732	0	\N
2034	서울특별시 마포구 공덕동 435-12	2026-01-29 23:28:26.030134	37.54405896	126.9502626	OFFICIAL	2026-01-29 23:28:26.030138	0	\N
2035	서울특별시 마포구 백범로 170 서울특별시 마포구 공덕동 478	2026-01-29 23:28:26.030519	37.54429633	126.9492629	OFFICIAL	2026-01-29 23:28:26.030523	0	\N
2036	서울특별시 마포구 백범로 152 서울특별시 마포구 공덕동 476	2026-01-29 23:28:26.030916	37.54474774	126.9482582	OFFICIAL	2026-01-29 23:28:26.03092	0	\N
2037	서울특별시 마포구 백범로 122 서울특별시 마포구 염리동 155-12	2026-01-29 23:28:26.031294	37.54655467	126.9444362	OFFICIAL	2026-01-29 23:28:26.031298	0	\N
2038	서울특별시 마포구 백범로 112 서울특별시 마포구 대흥동 200-3	2026-01-29 23:28:26.031674	37.54698538	126.9435565	OFFICIAL	2026-01-29 23:28:26.031678	0	\N
2039	서울특별시 마포구 백범로 95 서울특별시 마포구 대흥동 132-1	2026-01-29 23:28:26.032043	37.54795254	126.9423084	OFFICIAL	2026-01-29 23:28:26.032048	0	\N
2040	서울특별시 마포구 공덕동 257-88	2026-01-29 23:28:26.032459	37.54448915	126.950127	OFFICIAL	2026-01-29 23:28:26.032463	0	\N
2041	서울특별시 마포구 마포대로 25 서울특별시 마포구 마포동 33-1	2026-01-29 23:28:26.032839	37.53937876	126.9448336	OFFICIAL	2026-01-29 23:28:26.032843	0	\N
2042	서울특별시 마포구 마포대로 20 서울특별시 마포구 마포동 140	2026-01-29 23:28:26.033212	37.53842521	126.9449856	OFFICIAL	2026-01-29 23:28:26.033216	0	\N
2043	서울특별시 마포구 도화동 293-1	2026-01-29 23:28:26.03359	37.54111288	126.948038	OFFICIAL	2026-01-29 23:28:26.033594	0	\N
2044	서울특별시 마포구 도화동 293-1	2026-01-29 23:28:26.033963	37.54111288	126.948038	OFFICIAL	2026-01-29 23:28:26.033968	0	\N
2045	서울특별시 마포구 마포대로 33 서울특별시 마포구 도화동 160	2026-01-29 23:28:26.034441	37.53958379	126.9459204	OFFICIAL	2026-01-29 23:28:26.034447	0	\N
2046	서울특별시 마포구 마포대로 33 서울특별시 마포구 도화동 160	2026-01-29 23:28:26.034882	37.53958379	126.9459204	OFFICIAL	2026-01-29 23:28:26.034887	0	\N
2047	서울특별시 마포구 마포대로 61-1 서울특별시 마포구 도화동 559	2026-01-29 23:28:26.03527	37.54135699	126.9480097	OFFICIAL	2026-01-29 23:28:26.035274	0	\N
2048	서울특별시 마포구 마포대로 61-1 서울특별시 마포구 도화동 559	2026-01-29 23:28:26.03566	37.54135699	126.9480097	OFFICIAL	2026-01-29 23:28:26.035664	0	\N
2049	서울특별시 마포구 공덕동 237-9	2026-01-29 23:28:26.036025	37.54615674	126.9526245	OFFICIAL	2026-01-29 23:28:26.036029	0	\N
2050	서울특별시 마포구 공덕동 237-9	2026-01-29 23:28:26.036406	37.54615674	126.9526245	OFFICIAL	2026-01-29 23:28:26.03641	0	\N
2051	서울특별시 마포구 마포대로 207-1	2026-01-29 23:28:26.036868	37.552723	126.956048	OFFICIAL	2026-01-29 23:28:26.036872	0	\N
2052	서울특별시 마포구 마포대로 233-1 서울특별시 마포구 아현동 610-1	2026-01-29 23:28:26.037249	37.5548077	126.9571319	OFFICIAL	2026-01-29 23:28:26.037253	0	\N
2053	서울특별시 마포구 아현동 447-9	2026-01-29 23:28:26.037631	37.5508124	126.9552615	OFFICIAL	2026-01-29 23:28:26.037635	0	\N
2054	서울특별시 마포구 아현동 447-9	2026-01-29 23:28:26.037998	37.5508124	126.9552615	OFFICIAL	2026-01-29 23:28:26.038002	0	\N
2055	서울특별시 마포구 아현동 447-15	2026-01-29 23:28:26.038366	37.55041674	126.9552829	OFFICIAL	2026-01-29 23:28:26.03837	0	\N
2056	서울특별시 마포구 아현동 447-15	2026-01-29 23:28:26.038733	37.55041674	126.9552829	OFFICIAL	2026-01-29 23:28:26.038737	0	\N
2057	서울특별시 마포구 마포대로 212-1	2026-01-29 23:28:26.039254	37.55278656	126.9565585	OFFICIAL	2026-01-29 23:28:26.03926	0	\N
2058	서울특별시 마포구 마포대로 212-1	2026-01-29 23:28:26.039699	37.55278656	126.9565585	OFFICIAL	2026-01-29 23:28:26.039704	0	\N
2059	서울특별시 마포구 마포대로 114 서울특별시 마포구 공덕동 255-1	2026-01-29 23:28:26.040131	37.54480763	126.9520282	OFFICIAL	2026-01-29 23:28:26.040136	0	\N
2060	서울특별시 마포구 공덕동 254-29	2026-01-29 23:28:26.040517	37.5454877	126.952345	OFFICIAL	2026-01-29 23:28:26.040521	0	\N
2061	서울특별시 마포구 마포대로 122 서울특별시 마포구 공덕동 254-5	2026-01-29 23:28:26.040918	37.54539944	126.95256	OFFICIAL	2026-01-29 23:28:26.040922	0	\N
2062	서울특별시 마포구 공덕동 237-9	2026-01-29 23:28:26.041303	37.54615674	126.9526245	OFFICIAL	2026-01-29 23:28:26.041307	0	\N
2063	서울특별시 마포구 공덕동 237-9	2026-01-29 23:28:26.041685	37.54615674	126.9526245	OFFICIAL	2026-01-29 23:28:26.041689	0	\N
2064	서울특별시 마포구 공덕동 441-3	2026-01-29 23:28:26.042072	37.54367216	126.9508125	OFFICIAL	2026-01-29 23:28:26.042076	0	\N
2065	서울특별시 마포구 공덕동 255-10	2026-01-29 23:28:26.042466	37.54431932	126.9518728	OFFICIAL	2026-01-29 23:28:26.04247	0	\N
2066	서울특별시 마포구 만리재로 3 서울특별시 마포구 공덕동 255-9	2026-01-29 23:28:26.042875	37.54435757	126.9517759	OFFICIAL	2026-01-29 23:28:26.042879	0	\N
2067	서울특별시 마포구 만리재로 14 서울특별시 마포구 공덕동 456	2026-01-29 23:28:26.043241	37.54399372	126.9528352	OFFICIAL	2026-01-29 23:28:26.043245	0	\N
2068	서울특별시 마포구 만리재로 14 서울특별시 마포구 공덕동 456	2026-01-29 23:28:26.043603	37.54399372	126.9528352	OFFICIAL	2026-01-29 23:28:26.043607	0	\N
2069	서울특별시 마포구 신공덕동 56-87	2026-01-29 23:28:26.043973	37.54297824	126.9527384	OFFICIAL	2026-01-29 23:28:26.043977	0	\N
2070	서울특별시 마포구 백범로 199 서울특별시 마포구 신공덕동 167	2026-01-29 23:28:26.044336	37.54350072	126.9528871	OFFICIAL	2026-01-29 23:28:26.04434	0	\N
2071	서울특별시 마포구 백범로 205 서울특별시 마포구 신공덕동 172	2026-01-29 23:28:26.044696	37.5441056	126.9541301	OFFICIAL	2026-01-29 23:28:26.0447	0	\N
2072	서울특별시 마포구 신공덕동 56-74	2026-01-29 23:28:26.045082	37.54302821	126.9527869	OFFICIAL	2026-01-29 23:28:26.045086	0	\N
2074	충청남도 논산시 성동면 우곤리 1433-6	2026-01-29 23:28:26.045836	36.1938917	127.0024637	OFFICIAL	2026-01-29 23:28:26.04584	0	\N
2075	충청남도 논산시 양촌면 황산벌로933번길 15 충청남도 논산시 양촌면 신흥리 306-4	2026-01-29 23:28:26.046243	36.1650858	127.2047614	OFFICIAL	2026-01-29 23:28:26.046247	0	\N
2076	충청남도 논산시 성동면 성동로 275 충청남도 논산시 성동면 원남리 394-8	2026-01-29 23:28:26.046614	36.2035828	127.0335885	OFFICIAL	2026-01-29 23:28:26.046618	0	\N
2077	충청남도 논산시 연무읍 연무로166번길 12-4 충청남도 논산시 연무읍 안심리 14-115	2026-01-29 23:28:26.047047	36.1305177	127.0971544	OFFICIAL	2026-01-29 23:28:26.047051	0	\N
2078	충청남도 논산시 벌곡면 벌곡로330번길 21 충청남도 논산시 벌곡면 조동리 435-11	2026-01-29 23:28:26.047432	36.2210051	127.2964049	OFFICIAL	2026-01-29 23:28:26.047436	0	\N
2079	전라남도 장흥군 장흥읍 제암산길 29 전라남도 장흥군 장흥읍 축내리 245	2026-01-29 23:28:26.047833	34.68732238	126.9217265	OFFICIAL	2026-01-29 23:28:26.047837	0	\N
2080	전라남도 장흥군 장흥읍 제암산길 60 전라남도 장흥군 장흥읍 상리 73-4	2026-01-29 23:28:26.04821	34.68821053	126.9246883	OFFICIAL	2026-01-29 23:28:26.048214	0	\N
2081	전라남도 장흥군 장흥읍 금성1길 120 전라남도 장흥군 장흥읍 금산리 486-2	2026-01-29 23:28:26.048576	34.69870483	126.9392988	OFFICIAL	2026-01-29 23:28:26.04858	0	\N
2082	전라남도 장흥군 장흥읍 행원2길 7 전라남도 장흥군 장흥읍 행원리 401-1	2026-01-29 23:28:26.048939	34.69591623	126.9083907	OFFICIAL	2026-01-29 23:28:26.048943	0	\N
2083	전라남도 장흥군 장흥읍 신남외3길 4-4 전라남도 장흥군 장흥읍 남외리 259-57	2026-01-29 23:28:26.04932	34.66875477	126.9012099	OFFICIAL	2026-01-29 23:28:26.049324	0	\N
2084	전라남도 장흥군 장흥읍 영전1길 89 전라남도 장흥군 장흥읍 영전리 334-1	2026-01-29 23:28:26.049681	34.66628359	126.878927	OFFICIAL	2026-01-29 23:28:26.049685	0	\N
2085	전라남도 장흥군 장흥읍 송산길 54-4 전라남도 장흥군 장흥읍 덕제리 238	2026-01-29 23:28:26.050137	34.65313399	126.8893262	OFFICIAL	2026-01-29 23:28:26.050141	0	\N
2086	전라남도 장흥군 회진면 회진리 762-13	2026-01-29 23:28:26.050508	34.48062797	126.9382923	OFFICIAL	2026-01-29 23:28:26.050512	0	\N
2087	전라남도 장흥군 부산면 부유로 28 전라남도 장흥군 부산면 유량리 75-8	2026-01-29 23:28:26.050901	34.72280907	126.903085	OFFICIAL	2026-01-29 23:28:26.050906	0	\N
2088	전라남도 장흥군 유치면 원등길 10 전라남도 장흥군 유치면 원등리 43	2026-01-29 23:28:26.051284	34.802681	126.8380485	OFFICIAL	2026-01-29 23:28:26.051288	0	\N
2089	전라남도 장흥군 장평면 선정2길 6 전라남도 장흥군 장평면 선정리 517-2	2026-01-29 23:28:26.05166	34.79001495	126.9647484	OFFICIAL	2026-01-29 23:28:26.051664	0	\N
2090	전라남도 장흥군 장동면 신북1길 35 전라남도 장흥군 장동면 북교리 7-1	2026-01-29 23:28:26.052029	34.74995321	126.9952904	OFFICIAL	2026-01-29 23:28:26.052033	0	\N
2091	전라남도 장흥군 안양면 기산리 산 65-17	2026-01-29 23:28:26.052393	34.67621633	126.9561341	OFFICIAL	2026-01-29 23:28:26.052397	0	\N
2092	전라남도 장흥군 안양면 기산리 803-4	2026-01-29 23:28:26.052791	34.67405536	126.9500929	OFFICIAL	2026-01-29 23:28:26.052795	0	\N
2093	전라남도 장흥군 용산면 인암리 1106-8	2026-01-29 23:28:26.053157	34.61479386	126.915757	OFFICIAL	2026-01-29 23:28:26.053161	0	\N
2094	전라남도 장흥군 대덕읍 도청신월로 130 전라남도 장흥군 대덕읍 도청리 491	2026-01-29 23:28:26.053518	34.49348071	126.8854671	OFFICIAL	2026-01-29 23:28:26.053522	0	\N
2095	전라남도 장흥군 관산읍 옥당리 456-2	2026-01-29 23:28:26.053901	34.56214211	126.9378043	OFFICIAL	2026-01-29 23:28:26.053905	0	\N
2096	전라남도 장흥군 장흥읍 장원길 12 전라남도 장흥군 장흥읍 동동리 187-1	2026-01-29 23:28:26.054262	34.67928179	126.897833	OFFICIAL	2026-01-29 23:28:26.054266	0	\N
2097	전라남도 장흥군 장흥읍 건산리 112-3	2026-01-29 23:28:26.054661	34.67971898	126.913682	OFFICIAL	2026-01-29 23:28:26.054665	0	\N
2098	전라남도 장흥군 장흥읍 마당바위길 34-24 전라남도 장흥군 장흥읍 송암리 270	2026-01-29 23:28:26.055039	34.6601602	126.8723369	OFFICIAL	2026-01-29 23:28:26.055043	0	\N
2099	전라남도 장흥군 장흥읍 대반길 33-3 전라남도 장흥군 장흥읍 덕제리 537-1	2026-01-29 23:28:26.0554	34.6457004	126.8847533	OFFICIAL	2026-01-29 23:28:26.055404	0	\N
2100	전라남도 장흥군 장흥읍 원도관덕길 26 전라남도 장흥군 장흥읍 관덕리 215-1	2026-01-29 23:28:26.055795	34.68870171	126.9182356	OFFICIAL	2026-01-29 23:28:26.055798	0	\N
2101	전라남도 장흥군 장흥읍 장흥로 101 전라남도 장흥군 장흥읍 건산리 568	2026-01-29 23:28:26.056159	34.68643555	126.9118196	OFFICIAL	2026-01-29 23:28:26.056162	0	\N
2102	전라남도 장흥군 장흥읍 장흥대로 3492 전라남도 장흥군 장흥읍 건산리 767	2026-01-29 23:28:26.056524	34.67534692	126.9059676	OFFICIAL	2026-01-29 23:28:26.056528	0	\N
2103	전라남도 장흥군 장흥읍 동교1길 10-5 전라남도 장흥군 장흥읍 건산리 752	2026-01-29 23:28:26.056908	34.6763513	126.9070295	OFFICIAL	2026-01-29 23:28:26.056912	0	\N
2104	전라남도 장흥군 장흥읍 못골길 37-1 전라남도 장흥군 장흥읍 건산리 41-3	2026-01-29 23:28:26.057275	34.68223702	126.9149534	OFFICIAL	2026-01-29 23:28:26.057279	0	\N
2105	전라남도 장흥군 장흥읍 건산리 435-7	2026-01-29 23:28:26.058314	34.68064	126.9129722	OFFICIAL	2026-01-29 23:28:26.058319	0	\N
2106	전라남도 장흥군 장흥읍 건산리 796-7	2026-01-29 23:28:26.058804	34.68289399	126.9061124	OFFICIAL	2026-01-29 23:28:26.058809	0	\N
2107	전라남도 장흥군 대덕읍 축내2길 10 전라남도 장흥군 대덕읍 신월리 250-2	2026-01-29 23:28:26.059218	34.49740693	126.8818718	OFFICIAL	2026-01-29 23:28:26.059222	0	\N
2108	전라남도 장흥군 회진면 회진로 612 전라남도 장흥군 회진면 덕산리 2136-10	2026-01-29 23:28:26.059718	34.47750824	126.9542629	OFFICIAL	2026-01-29 23:28:26.059722	0	\N
2109	전라남도 장흥군 부산면 내안리 938-1	2026-01-29 23:28:26.060155	34.70725949	126.8915428	OFFICIAL	2026-01-29 23:28:26.060159	0	\N
2110	전라남도 장흥군 유치면 대천리 557-1	2026-01-29 23:28:26.060549	34.84268448	126.8763152	OFFICIAL	2026-01-29 23:28:26.060553	0	\N
2111	전라남도 장흥군 장평면 청용2길 38 전라남도 장흥군 장평면 청용리 331-1	2026-01-29 23:28:26.060972	34.80475129	126.9451192	OFFICIAL	2026-01-29 23:28:26.060976	0	\N
2112	전라남도 장흥군 장동면 조양리 433	2026-01-29 23:28:26.061366	34.77096201	126.9894755	OFFICIAL	2026-01-29 23:28:26.061371	0	\N
2113	전라남도 장흥군 안양면 당암리 454-1	2026-01-29 23:28:26.061778	34.66137568	126.9678947	OFFICIAL	2026-01-29 23:28:26.061782	0	\N
2114	전라남도 장흥군 용산면 금곡길 11-9 전라남도 장흥군 용산면 금곡리 242-1	2026-01-29 23:28:26.062154	34.62058335	126.9368671	OFFICIAL	2026-01-29 23:28:26.062158	0	\N
2115	전라남도 장흥군 대덕읍 가학리 333-3	2026-01-29 23:28:26.06257	34.4797291	126.9046982	OFFICIAL	2026-01-29 23:28:26.062574	0	\N
2116	전라남도 장흥군 관산읍 옥당리 1001	2026-01-29 23:28:26.062954	34.56654864	126.9306747	OFFICIAL	2026-01-29 23:28:26.06296	0	\N
2117	전라남도 장흥군 장흥읍 원도리 315	2026-01-29 23:28:26.063331	34.68524555	126.9118631	OFFICIAL	2026-01-29 23:28:26.063337	0	\N
2118	전라남도 장흥군 장흥읍 원도리 308-5	2026-01-29 23:28:26.063792	34.68145292	126.9090171	OFFICIAL	2026-01-29 23:28:26.063796	0	\N
2119	전라남도 장흥군 장흥읍 예양리 산 10-3	2026-01-29 23:28:26.06426	34.67499149	126.9003447	OFFICIAL	2026-01-29 23:28:26.064265	0	\N
2120	전라남도 장흥군 장흥읍 예양리 88	2026-01-29 23:28:26.064643	34.67612813	126.9006662	OFFICIAL	2026-01-29 23:28:26.064647	0	\N
2121	전라남도 장흥군 장흥읍 기양리 53	2026-01-29 23:28:26.065029	34.67983289	126.9022952	OFFICIAL	2026-01-29 23:28:26.065033	0	\N
2122	전라남도 장흥군 회진면 진목리 195-42	2026-01-29 23:28:26.065408	34.44967504	126.9269511	OFFICIAL	2026-01-29 23:28:26.065412	0	\N
2123	전라남도 장흥군 회진면 회진리 1878-4	2026-01-29 23:28:26.065829	34.48924705	126.9337009	OFFICIAL	2026-01-29 23:28:26.065833	0	\N
2124	전라남도 장흥군 부산면 용반리 277-1	2026-01-29 23:28:26.06622	34.74726647	126.9027256	OFFICIAL	2026-01-29 23:28:26.066224	0	\N
2125	전라남도 장흥군 부산면 구룡리 300	2026-01-29 23:28:26.066602	34.71816482	126.8977667	OFFICIAL	2026-01-29 23:28:26.066606	0	\N
2126	전라남도 장흥군 부산면 내안리 653-1	2026-01-29 23:28:26.066988	34.70578793	126.8855547	OFFICIAL	2026-01-29 23:28:26.066992	0	\N
2127	전라남도 장흥군 유치면 장흥대로 5609 전라남도 장흥군 유치면 반월리 518-3	2026-01-29 23:28:26.067369	34.80449376	126.8061786	OFFICIAL	2026-01-29 23:28:26.067373	0	\N
2128	전라남도 장흥군 장평면 우산리 580-1	2026-01-29 23:28:26.067743	34.81359745	126.9220862	OFFICIAL	2026-01-29 23:28:26.067771	0	\N
2129	전라남도 장흥군 장동면 월곡길 285 전라남도 장흥군 장동면 용곡리 산 119-6	2026-01-29 23:28:26.068187	34.71366499	126.9584713	OFFICIAL	2026-01-29 23:28:26.068191	0	\N
2130	전라남도 장흥군 장흥읍 장흥대로 3747 전라남도 장흥군 장흥읍 행원리 1271	2026-01-29 23:28:26.06864	34.6974146	126.9005019	OFFICIAL	2026-01-29 23:28:26.068644	0	\N
2131	전라남도 장흥군 안양면 지천3길 4 전라남도 장흥군 안양면 지천리 407-1	2026-01-29 23:28:26.069072	34.63063395	126.9667607	OFFICIAL	2026-01-29 23:28:26.069076	0	\N
2132	전라남도 장흥군 대덕읍 장흥대로 856 전라남도 장흥군 대덕읍 연지리 246-6	2026-01-29 23:28:26.069469	34.50274697	126.9120029	OFFICIAL	2026-01-29 23:28:26.069474	0	\N
2133	전라남도 장흥군 대덕읍 연평길 29 전라남도 장흥군 대덕읍 연정리 145	2026-01-29 23:28:26.069939	34.50113922	126.8936383	OFFICIAL	2026-01-29 23:28:26.069944	0	\N
2134	전라남도 장흥군 관산읍 지정리 260-9	2026-01-29 23:28:26.070392	34.55572015	126.9580729	OFFICIAL	2026-01-29 23:28:26.070397	0	\N
2135	광주광역시 광산구 동곡로 155	2026-01-29 23:28:26.07081	35.09737371	126.7739134	OFFICIAL	2026-01-29 23:28:26.070814	0	\N
2136	광주광역시 광산구 유계동 237-2	2026-01-29 23:28:26.071193	35.10168773	126.7783326	OFFICIAL	2026-01-29 23:28:26.071197	0	\N
2137	광주광역시 광산구 복룡동 369-34	2026-01-29 23:28:26.071573	35.1073257	126.7786699	OFFICIAL	2026-01-29 23:28:26.071578	0	\N
2138	광주광역시 광산구 복룡동 367-34	2026-01-29 23:28:26.071956	35.11067637	126.7792337	OFFICIAL	2026-01-29 23:28:26.07196	0	\N
2139	광주광역시 광산구 복룡동 743-23	2026-01-29 23:28:26.07233	35.11790709	126.7804368	OFFICIAL	2026-01-29 23:28:26.072334	0	\N
2140	광주광역시 광산구 비아로62번길 12	2026-01-29 23:28:26.072696	35.21987458	126.8194148	OFFICIAL	2026-01-29 23:28:26.0727	0	\N
2141	광주광역시 광산구 산월로 81	2026-01-29 23:28:26.07309	35.21003947	126.8458685	OFFICIAL	2026-01-29 23:28:26.073094	0	\N
2142	광주광역시 광산구 산월동 886-7	2026-01-29 23:28:26.073453	35.20674431	126.8430584	OFFICIAL	2026-01-29 23:28:26.073457	0	\N
2143	광주광역시 광산구 첨단중앙로68번길 99	2026-01-29 23:28:26.073831	35.21248237	126.8487728	OFFICIAL	2026-01-29 23:28:26.073835	0	\N
2144	광주광역시 광산구 월계로 203	2026-01-29 23:28:26.074194	35.2138558	126.8478006	OFFICIAL	2026-01-29 23:28:26.074198	0	\N
2145	광주광역시 광산구 산월로 27-1	2026-01-29 23:28:26.074555	35.2089921	126.8403753	OFFICIAL	2026-01-29 23:28:26.074558	0	\N
2146	광주광역시 광산구 첨단중앙로 102	2026-01-29 23:28:26.07494	35.21429806	126.8433285	OFFICIAL	2026-01-29 23:28:26.074947	0	\N
2147	광주광역시 광산구 첨단내촌로 74	2026-01-29 23:28:26.075307	35.2131716	126.836408	OFFICIAL	2026-01-29 23:28:26.075311	0	\N
2148	광주광역시 광산구 쌍암동 666-11	2026-01-29 23:28:26.075673	35.21986262	126.8442883	OFFICIAL	2026-01-29 23:28:26.075677	0	\N
2149	광주광역시 광산구 임방울대로 673-12	2026-01-29 23:28:26.076027	35.21689594	126.8320336	OFFICIAL	2026-01-29 23:28:26.076031	0	\N
2150	광주광역시 광산구 월계동 758-12	2026-01-29 23:28:26.07639	35.21812509	126.8387557	OFFICIAL	2026-01-29 23:28:26.076394	0	\N
2151	광주광역시 광산구 월계동 758-12	2026-01-29 23:28:26.076776	35.21812509	126.8387557	OFFICIAL	2026-01-29 23:28:26.076779	0	\N
2152	광주광역시 광산구 임방울대로 727-20	2026-01-29 23:28:26.077139	35.21986405	126.8378944	OFFICIAL	2026-01-29 23:28:26.077143	0	\N
2153	부산광역시 사하구 다대로 210 부산광역시 사하구 장림동 1037	2026-01-29 23:28:26.077498	35.08376384	128.975571	OFFICIAL	2026-01-29 23:28:26.077502	0	\N
2154	부산광역시 사하구 장림동 1149	2026-01-29 23:28:26.07788	35.08129723	128.9589704	OFFICIAL	2026-01-29 23:28:26.077884	0	\N
2155	부산광역시 사하구 낙동대로 581 부산광역시 사하구 하단동 1217-2	2026-01-29 23:28:26.078283	35.11547085	128.9613273	OFFICIAL	2026-01-29 23:28:26.078288	0	\N
2156	부산광역시 사하구 낙동남로 1413 부산광역시 사하구 하단동 526-6	2026-01-29 23:28:26.078669	35.10668081	128.9663681	OFFICIAL	2026-01-29 23:28:26.078673	0	\N
2157	부산광역시 사하구 옥천로 125 부산광역시 사하구 감천동 10	2026-01-29 23:28:26.079024	35.09733631	129.0103738	OFFICIAL	2026-01-29 23:28:26.079028	0	\N
2158	부산광역시 사하구 감내2로 137 부산광역시 사하구 감천동 6-994	2026-01-29 23:28:26.079391	35.09816032	129.0086035	OFFICIAL	2026-01-29 23:28:26.079395	0	\N
2159	부산광역시 사하구 옥천로 73 부산광역시 사하구 감천동 16-65	2026-01-29 23:28:26.079779	35.09314392	129.0090047	OFFICIAL	2026-01-29 23:28:26.079783	0	\N
2160	부산광역시 사하구 감내1로 175 부산광역시 사하구 감천동 6-1604	2026-01-29 23:28:26.080146	35.09556525	129.0090025	OFFICIAL	2026-01-29 23:28:26.08015	0	\N
2161	부산광역시 사하구 감천로 47 부산광역시 사하구 감천동 648-11	2026-01-29 23:28:26.080518	35.09097192	128.997881	OFFICIAL	2026-01-29 23:28:26.080523	0	\N
2162	부산광역시 사하구 감천로 174 부산광역시 사하구 감천동 178-2	2026-01-29 23:28:26.080904	35.08410327	129.0087222	OFFICIAL	2026-01-29 23:28:26.080908	0	\N
2163	전라남도 장흥군 용산면 묵촌길 41-12 전라남도 장흥군 용산면 접정리 134-1	2026-01-29 23:28:26.081277	34.60664906	126.9155443	OFFICIAL	2026-01-29 23:28:26.08128	0	\N
2164	전라남도 장흥군 용산면 장전길 10 전라남도 장흥군 용산면 인암리 39-1	2026-01-29 23:28:26.08181	34.6278786	126.9276062	OFFICIAL	2026-01-29 23:28:26.081814	0	\N
2165	광주광역시 광산구 월계동 758-10	2026-01-29 23:28:26.082211	35.21854666	126.8416999	OFFICIAL	2026-01-29 23:28:26.082215	0	\N
2166	광주광역시 광산구 월계동 758-10	2026-01-29 23:28:26.082637	35.21854666	126.8416999	OFFICIAL	2026-01-29 23:28:26.082641	0	\N
2167	광주광역시 광산구 첨단중앙로 150	2026-01-29 23:28:26.083049	35.21855063	126.8423501	OFFICIAL	2026-01-29 23:28:26.083053	0	\N
2168	광주광역시 광산구 임방울대로 779	2026-01-29 23:28:26.083482	35.21822675	126.8436519	OFFICIAL	2026-01-29 23:28:26.083486	0	\N
2169	광주광역시 광산구 첨단중앙로 160	2026-01-29 23:28:26.083878	35.21952708	126.8423636	OFFICIAL	2026-01-29 23:28:26.083882	0	\N
2170	광주광역시 광산구 월계동 757-10	2026-01-29 23:28:26.084248	35.22210098	126.8407189	OFFICIAL	2026-01-29 23:28:26.084252	0	\N
2171	광주광역시 광산구 첨단중앙로182번길 8	2026-01-29 23:28:26.084615	35.22138372	126.8422588	OFFICIAL	2026-01-29 23:28:26.084619	0	\N
2172	광주광역시 광산구 첨단중앙로182번길 8	2026-01-29 23:28:26.085021	35.22138372	126.8422588	OFFICIAL	2026-01-29 23:28:26.085025	0	\N
2173	광주광역시 광산구 임방울대로 261	2026-01-29 23:28:26.08539	35.185028	126.8186595	OFFICIAL	2026-01-29 23:28:26.085394	0	\N
2174	광주광역시 광산구 임방울대로 261	2026-01-29 23:28:26.085789	35.185028	126.8186595	OFFICIAL	2026-01-29 23:28:26.085793	0	\N
2175	광주광역시 광산구 장신로 120	2026-01-29 23:28:26.086164	35.19044338	126.8232656	OFFICIAL	2026-01-29 23:28:26.086169	0	\N
2176	광주광역시 광산구 수완로 63	2026-01-29 23:28:26.086531	35.19093029	126.8284667	OFFICIAL	2026-01-29 23:28:26.086546	0	\N
2177	광주광역시 광산구 장신로 82	2026-01-29 23:28:26.08694	35.19044454	126.8187432	OFFICIAL	2026-01-29 23:28:26.086944	0	\N
2178	광주광역시 광산구 장신로 189	2026-01-29 23:28:26.087308	35.19104995	126.8308757	OFFICIAL	2026-01-29 23:28:26.087312	0	\N
2179	광주광역시 광산구 신가동 981-1	2026-01-29 23:28:26.087679	35.18764438	126.8367679	OFFICIAL	2026-01-29 23:28:26.087683	0	\N
2180	광주광역시 광산구 신창동 1235	2026-01-29 23:28:26.088061	35.19392158	126.8378283	OFFICIAL	2026-01-29 23:28:26.088065	0	\N
2181	광주광역시 광산구 신창동 1260	2026-01-29 23:28:26.088433	35.19412554	126.8374723	OFFICIAL	2026-01-29 23:28:26.088437	0	\N
2182	광주광역시 광산구 신창동 1108-2	2026-01-29 23:28:26.088827	35.1861961	126.8374212	OFFICIAL	2026-01-29 23:28:26.088831	0	\N
2183	광주광역시 광산구 수등로243번길 28-24	2026-01-29 23:28:26.089195	35.18622556	126.8367315	OFFICIAL	2026-01-29 23:28:26.089199	0	\N
2184	광주광역시 광산구 수등로 245	2026-01-29 23:28:26.089569	35.18532509	126.8358506	OFFICIAL	2026-01-29 23:28:26.089572	0	\N
2185	광주광역시 광산구 신창로 44	2026-01-29 23:28:26.089947	35.18915	126.8372627	OFFICIAL	2026-01-29 23:28:26.089951	0	\N
2186	광주광역시 광산구 신창로 44	2026-01-29 23:28:26.090324	35.18915	126.8372627	OFFICIAL	2026-01-29 23:28:26.090328	0	\N
2187	광주광역시 광산구 신창동 1185-3	2026-01-29 23:28:26.090769	35.19236233	126.8433554	OFFICIAL	2026-01-29 23:28:26.090773	0	\N
2188	광주광역시 광산구 목련로 349	2026-01-29 23:28:26.091159	35.18022786	126.8310256	OFFICIAL	2026-01-29 23:28:26.091163	0	\N
2189	광주광역시 광산구 신가동 963-5	2026-01-29 23:28:26.091532	35.18461712	126.8320931	OFFICIAL	2026-01-29 23:28:26.091536	0	\N
2190	광주광역시 광산구 목련로394번길 9-11	2026-01-29 23:28:26.091929	35.18426804	126.832928	OFFICIAL	2026-01-29 23:28:26.091933	0	\N
2191	광주광역시 광산구 운남동 776-2	2026-01-29 23:28:26.092297	35.17871572	126.82743	OFFICIAL	2026-01-29 23:28:26.092302	0	\N
2192	광주광역시 광산구 운남동 771-2	2026-01-29 23:28:26.092673	35.17900721	126.822252	OFFICIAL	2026-01-29 23:28:26.092677	0	\N
2193	광주광역시 광산구 운남동 769-3	2026-01-29 23:28:26.093027	35.17917776	126.8194328	OFFICIAL	2026-01-29 23:28:26.093042	0	\N
2194	광주광역시 광산구 운남동 782-3	2026-01-29 23:28:26.093406	35.17939357	126.8157783	OFFICIAL	2026-01-29 23:28:26.09341	0	\N
2195	광주광역시 광산구 임방울대로 148	2026-01-29 23:28:26.093812	35.1744507	126.8179442	OFFICIAL	2026-01-29 23:28:26.093816	0	\N
2196	광주광역시 광산구 하남대로 125	2026-01-29 23:28:26.094176	35.18031301	126.8071045	OFFICIAL	2026-01-29 23:28:26.094183	0	\N
2197	광주광역시 광산구 산정동 1011	2026-01-29 23:28:26.094536	35.17539587	126.797686	OFFICIAL	2026-01-29 23:28:26.09454	0	\N
2198	광주광역시 광산구 손재로110번길 21	2026-01-29 23:28:26.09492	35.17609338	126.7980729	OFFICIAL	2026-01-29 23:28:26.094924	0	\N
2199	광주광역시 광산구 사암로 303	2026-01-29 23:28:26.095289	35.1714314	126.8090289	OFFICIAL	2026-01-29 23:28:26.095293	0	\N
2200	광주광역시 광산구 사암로 300	2026-01-29 23:28:26.09567	35.17129717	126.8096478	OFFICIAL	2026-01-29 23:28:26.095676	0	\N
2201	광주광역시 광산구 사암로 274	2026-01-29 23:28:26.096027	35.16878612	126.8092135	OFFICIAL	2026-01-29 23:28:26.096031	0	\N
2202	광주광역시 광산구 사암로 266	2026-01-29 23:28:26.096403	35.16797366	126.8091751	OFFICIAL	2026-01-29 23:28:26.096407	0	\N
2203	광주광역시 광산구 사암로 251	2026-01-29 23:28:26.096796	35.16734483	126.8082321	OFFICIAL	2026-01-29 23:28:26.096799	0	\N
2204	광주광역시 광산구 사암로 251	2026-01-29 23:28:26.09716	35.16734483	126.8082321	OFFICIAL	2026-01-29 23:28:26.097164	0	\N
2205	광주광역시 광산구 월곡동 315-26	2026-01-29 23:28:26.097524	35.17273721	126.809394	OFFICIAL	2026-01-29 23:28:26.097527	0	\N
2206	광주광역시 광산구 사암로 343	2026-01-29 23:28:26.097917	35.17513465	126.8083628	OFFICIAL	2026-01-29 23:28:26.097921	0	\N
2207	광주광역시 광산구 사암로 349	2026-01-29 23:28:26.098284	35.1755469	126.8083441	OFFICIAL	2026-01-29 23:28:26.098288	0	\N
2208	광주광역시 광산구 하남대로 146	2026-01-29 23:28:26.098645	35.17977495	126.8095302	OFFICIAL	2026-01-29 23:28:26.098649	0	\N
2209	광주광역시 광산구 월곡중앙로 60-1	2026-01-29 23:28:26.099017	35.17176858	126.8113758	OFFICIAL	2026-01-29 23:28:26.099021	0	\N
2210	광주광역시 광산구 우산로 17	2026-01-29 23:28:26.099394	35.15982377	126.8041467	OFFICIAL	2026-01-29 23:28:26.099398	0	\N
2211	광주광역시 광산구 용아로 251	2026-01-29 23:28:26.099796	35.16588819	126.8012667	OFFICIAL	2026-01-29 23:28:26.0998	0	\N
2212	광주광역시 광산구 월곡산정로 12	2026-01-29 23:28:26.100165	35.16631715	126.8038702	OFFICIAL	2026-01-29 23:28:26.100168	0	\N
2213	광주광역시 광산구 월곡산정로 80	2026-01-29 23:28:26.100542	35.16577515	126.8111785	OFFICIAL	2026-01-29 23:28:26.100546	0	\N
2214	광주광역시 광산구 우산로 89	2026-01-29 23:28:26.100931	35.15661731	126.8099416	OFFICIAL	2026-01-29 23:28:26.100935	0	\N
2215	광주광역시 광산구 금봉로 106	2026-01-29 23:28:26.10131	35.1510226	126.8126175	OFFICIAL	2026-01-29 23:28:26.101314	0	\N
2216	광주광역시 광산구 금봉로 101-1	2026-01-29 23:28:26.101698	35.1521505	126.8098018	OFFICIAL	2026-01-29 23:28:26.101702	0	\N
2217	광주광역시 광산구 신촌동 978-8	2026-01-29 23:28:26.102129	35.1465121	126.8075708	OFFICIAL	2026-01-29 23:28:26.102133	0	\N
2218	광주광역시 광산구 어등대로 661	2026-01-29 23:28:26.102499	35.14493246	126.7905884	OFFICIAL	2026-01-29 23:28:26.102503	0	\N
2219	광주광역시 광산구 어등대로 658	2026-01-29 23:28:26.102896	35.14244615	126.7913219	OFFICIAL	2026-01-29 23:28:26.1029	0	\N
2220	광주광역시 광산구 상무대로 125-99	2026-01-29 23:28:26.103308	35.1313677	126.7872758	OFFICIAL	2026-01-29 23:28:26.103312	0	\N
2221	광주광역시 광산구 송정동 949-77	2026-01-29 23:28:26.103683	35.1344844	126.7893032	OFFICIAL	2026-01-29 23:28:26.103687	0	\N
2222	광주광역시 광산구 상무대로 190	2026-01-29 23:28:26.104055	35.13666213	126.7913266	OFFICIAL	2026-01-29 23:28:26.104058	0	\N
2223	광주광역시 광산구 상무대로 214	2026-01-29 23:28:26.104417	35.138236	126.7923269	OFFICIAL	2026-01-29 23:28:26.104421	0	\N
2224	광주광역시 광산구 상무대로 211	2026-01-29 23:28:26.104856	35.13827647	126.7916942	OFFICIAL	2026-01-29 23:28:26.104859	0	\N
2225	광주광역시 광산구 송정동 887-12	2026-01-29 23:28:26.105235	35.13591945	126.797431	OFFICIAL	2026-01-29 23:28:26.105239	0	\N
2226	광주광역시 광산구 상무대로 268	2026-01-29 23:28:26.105611	35.14153854	126.7956927	OFFICIAL	2026-01-29 23:28:26.105616	0	\N
2227	광주광역시 광산구 상무대로 404	2026-01-29 23:28:26.106004	35.14392764	126.8101871	OFFICIAL	2026-01-29 23:28:26.106008	0	\N
2228	서울특별시 노원구 화랑로 440-2	2026-01-29 23:28:26.106388	37.61768123	127.076266	OFFICIAL	2026-01-29 23:28:26.106392	0	\N
2229	서울특별시 구로구 개봉로19길 43 서울특별시 구로구 개봉동 302-21	2026-01-29 23:28:26.106777	37.49360219	126.8555586	OFFICIAL	2026-01-29 23:28:26.106781	0	\N
2230	서울특별시 구로구 개봉로 71 서울특별시 구로구 개봉동 403-206	2026-01-29 23:28:26.107146	37.49209383	126.8555745	OFFICIAL	2026-01-29 23:28:26.10715	0	\N
2231	서울특별시 구로구 개봉로 63 서울특별시 구로구 개봉동 403-53	2026-01-29 23:28:26.107511	37.49138218	126.8556895	OFFICIAL	2026-01-29 23:28:26.107515	0	\N
2232	서울특별시 구로구 남부순환로 775 서울특별시 구로구 개봉동 492	2026-01-29 23:28:26.107903	37.50156787	126.8471623	OFFICIAL	2026-01-29 23:28:26.107907	0	\N
2233	서울특별시 구로구 경인로 319 서울특별시 구로구 개봉동 156-5	2026-01-29 23:28:26.108272	37.49759938	126.8556011	OFFICIAL	2026-01-29 23:28:26.108276	0	\N
2234	서울특별시 구로구 경인로33길 25 서울특별시 구로구 개봉동 139-61	2026-01-29 23:28:26.108643	37.49905708	126.8517194	OFFICIAL	2026-01-29 23:28:26.108647	0	\N
2235	서울특별시 구로구 고척로 102 서울특별시 구로구 개봉동 66-32	2026-01-29 23:28:26.109016	37.50103924	126.8454965	OFFICIAL	2026-01-29 23:28:26.10902	0	\N
2236	서울특별시 구로구 고척로 85 서울특별시 구로구 개봉동 60-101	2026-01-29 23:28:26.109408	37.50107408	126.8438229	OFFICIAL	2026-01-29 23:28:26.109412	0	\N
2237	서울특별시 구로구 고척로 101 서울특별시 구로구 개봉동 63-35	2026-01-29 23:28:26.109817	37.50127895	126.8452527	OFFICIAL	2026-01-29 23:28:26.109844	0	\N
2238	서울특별시 구로구 경인로 281 서울특별시 구로구 개봉동 139-200	2026-01-29 23:28:26.110231	37.49849715	126.851827	OFFICIAL	2026-01-29 23:28:26.110235	0	\N
2239	서울특별시 구로구 경인로 313 서울특별시 구로구 개봉동 146-24	2026-01-29 23:28:26.110717	37.49749954	126.8551588	OFFICIAL	2026-01-29 23:28:26.110721	0	\N
2240	서울특별시 구로구 남부순환로 775 서울특별시 구로구 개봉동 492	2026-01-29 23:28:26.111134	37.50156787	126.8471623	OFFICIAL	2026-01-29 23:28:26.111138	0	\N
2241	서울특별시 구로구 경인로33길 51 서울특별시 구로구 개봉동 134-8	2026-01-29 23:28:26.111502	37.50024126	126.8511388	OFFICIAL	2026-01-29 23:28:26.111506	0	\N
2242	서울특별시 구로구 개봉로23가길 30 서울특별시 구로구 개봉동 416-146	2026-01-29 23:28:26.111897	37.49506475	126.8580465	OFFICIAL	2026-01-29 23:28:26.111901	0	\N
2243	서울특별시 구로구 디지털로27길 135 서울특별시 구로구 가리봉동 89-99	2026-01-29 23:28:26.112255	37.48484996	126.8865766	OFFICIAL	2026-01-29 23:28:26.112259	0	\N
2244	서울특별시 구로구 디지털로27길 135 서울특별시 구로구 가리봉동 89-99	2026-01-29 23:28:26.112665	37.48484996	126.8865766	OFFICIAL	2026-01-29 23:28:26.112669	0	\N
2245	서울특별시 구로구 디지털로 231 서울특별시 구로구 가리봉동 131-11	2026-01-29 23:28:26.113011	37.48076327	126.891283	OFFICIAL	2026-01-29 23:28:26.113015	0	\N
2246	서울특별시 구로구 디지털로 226 서울특별시 구로구 가리봉동 134-114	2026-01-29 23:28:26.11341	37.48009519	126.8911068	OFFICIAL	2026-01-29 23:28:26.113414	0	\N
2247	서울특별시 구로구 남부순환로105길 134 서울특별시 구로구 가리봉동 121-44	2026-01-29 23:28:26.113806	37.48230207	126.8867218	OFFICIAL	2026-01-29 23:28:26.113809	0	\N
2248	서울특별시 구로구 남부순환로105길 134 서울특별시 구로구 가리봉동 121-44	2026-01-29 23:28:26.114171	37.48230207	126.8867218	OFFICIAL	2026-01-29 23:28:26.114175	0	\N
2249	서울특별시 구로구 남부순환로105길 76 서울특별시 구로구 가리봉동 125-16	2026-01-29 23:28:26.114533	37.48016123	126.8886952	OFFICIAL	2026-01-29 23:28:26.114537	0	\N
2250	서울특별시 구로구 남부순환로 1295 서울특별시 구로구 가리봉동 137-4	2026-01-29 23:28:26.114922	37.47911835	126.8948323	OFFICIAL	2026-01-29 23:28:26.114926	0	\N
2251	서울특별시 구로구 구로동 693-2	2026-01-29 23:28:26.115285	37.48988183	126.875474	OFFICIAL	2026-01-29 23:28:26.115289	0	\N
2252	서울특별시 구로구 구일로4길 57 서울특별시 구로구 구로동 685-213	2026-01-29 23:28:26.115651	37.49304008	126.8757883	OFFICIAL	2026-01-29 23:28:26.115655	0	\N
2253	서울특별시 구로구 구일로4길 46 서울특별시 구로구 구로동 685-70	2026-01-29 23:28:26.116012	37.49326723	126.8778699	OFFICIAL	2026-01-29 23:28:26.116016	0	\N
2254	서울특별시 구로구 고척로 142-1 서울특별시 구로구 고척동 333	2026-01-29 23:28:26.116378	37.50264701	126.8498373	OFFICIAL	2026-01-29 23:28:26.116381	0	\N
2255	서울특별시 구로구 고척로 142-1 서울특별시 구로구 고척동 194-3	2026-01-29 23:28:26.116737	37.50264701	126.8498373	OFFICIAL	2026-01-29 23:28:26.116741	0	\N
2256	서울특별시 구로구 고척로 209-1	2026-01-29 23:28:26.117128	37.5054913	126.856546	OFFICIAL	2026-01-29 23:28:26.117132	0	\N
2257	서울특별시 구로구 고척로 206	2026-01-29 23:28:26.117488	37.50501563	126.8561093	OFFICIAL	2026-01-29 23:28:26.117492	0	\N
2258	서울특별시 구로구 고척로 202	2026-01-29 23:28:26.117904	37.50485847	126.855798	OFFICIAL	2026-01-29 23:28:26.117908	0	\N
2259	서울특별시 구로구 고척로 177	2026-01-29 23:28:26.118263	37.50419607	126.853141	OFFICIAL	2026-01-29 23:28:26.118274	0	\N
2260	서울특별시 구로구 고척로 195	2026-01-29 23:28:26.118635	37.50492878	126.854807	OFFICIAL	2026-01-29 23:28:26.118638	0	\N
2261	서울특별시 구로구 경인로 445	2026-01-29 23:28:26.119095	37.49999579	126.8681697	OFFICIAL	2026-01-29 23:28:26.119098	0	\N
2262	서울특별시 구로구 경인로 433	2026-01-29 23:28:26.11946	37.49969202	126.867056	OFFICIAL	2026-01-29 23:28:26.119464	0	\N
2263	서울특별시 구로구 경인로 403	2026-01-29 23:28:26.119822	37.49795843	126.8643477	OFFICIAL	2026-01-29 23:28:26.119825	0	\N
2264	서울특별시 구로구 경인로 403	2026-01-29 23:28:26.120181	37.49795843	126.8643477	OFFICIAL	2026-01-29 23:28:26.120185	0	\N
2265	서울특별시 구로구 경인로 331	2026-01-29 23:28:26.120547	37.497642	126.8569352	OFFICIAL	2026-01-29 23:28:26.120551	0	\N
2266	서울특별시 구로구 고척로 238 서울특별시 구로구 고척동 333	2026-01-29 23:28:26.12093	37.50617829	126.8594037	OFFICIAL	2026-01-29 23:28:26.120941	0	\N
2267	서울특별시 구로구 중앙로 76	2026-01-29 23:28:26.121298	37.50444791	126.8617685	OFFICIAL	2026-01-29 23:28:26.121302	0	\N
2268	서울특별시 구로구 중앙로 63	2026-01-29 23:28:26.121656	37.50325232	126.8618884	OFFICIAL	2026-01-29 23:28:26.12166	0	\N
2269	서울특별시 구로구 중앙로10길 7	2026-01-29 23:28:26.122024	37.5034895	126.8626141	OFFICIAL	2026-01-29 23:28:26.122028	0	\N
3015	구미시 진평동	2026-02-08 01:33:18.974595	36.10656279724593	128.41801169320516	PENDING	2026-02-08 01:33:18.974631	1	ranker1
2270	서울특별시 구로구 중앙로 37	2026-01-29 23:28:26.122387	37.50116082	126.863006	OFFICIAL	2026-01-29 23:28:26.122391	0	\N
2271	서울특별시 구로구 경서로 47 서울특별시 구로구 고척동 134-33	2026-01-29 23:28:26.122814	37.50149371	126.8585145	OFFICIAL	2026-01-29 23:28:26.122816	0	\N
2272	서울특별시 구로구 개봉로 34 서울특별시 구로구 개봉동 403-154	2026-01-29 23:28:26.123177	37.48860421	126.8564451	OFFICIAL	2026-01-29 23:28:26.123181	0	\N
2273	서울특별시 구로구 개봉로 22 서울특별시 구로구 개봉동 403-171	2026-01-29 23:28:26.12354	37.48750656	126.856558	OFFICIAL	2026-01-29 23:28:26.123544	0	\N
2274	서울특별시 구로구 개봉로 10 서울특별시 구로구 개봉동 403-196	2026-01-29 23:28:26.123932	37.48662187	126.8567122	OFFICIAL	2026-01-29 23:28:26.123936	0	\N
2275	서울특별시 구로구 개봉로 10 서울특별시 구로구 개봉동 403-196	2026-01-29 23:28:26.124291	37.48662187	126.8567122	OFFICIAL	2026-01-29 23:28:26.124294	0	\N
2276	서울특별시 구로구 개봉로1길 40 서울특별시 구로구 개봉동 367-1	2026-01-29 23:28:26.124658	37.48504966	126.8544668	OFFICIAL	2026-01-29 23:28:26.124662	0	\N
2277	서울특별시 구로구 개봉로 4 서울특별시 구로구 개봉동 290-6	2026-01-29 23:28:26.125009	37.48610225	126.8567755	OFFICIAL	2026-01-29 23:28:26.125013	0	\N
2278	서울특별시 구로구 남부순환로95길 30 서울특별시 구로구 개봉동 403-217	2026-01-29 23:28:26.125369	37.49413421	126.8564997	OFFICIAL	2026-01-29 23:28:26.125373	0	\N
2279	서울특별시 구로구 남부순환로95길 16 서울특별시 구로구 개봉동 471	2026-01-29 23:28:26.125728	37.49456794	126.8573079	OFFICIAL	2026-01-29 23:28:26.125732	0	\N
2280	서울특별시 노원구 노해로 449	2026-01-29 23:28:26.12612	37.65405358	127.0579974	OFFICIAL	2026-01-29 23:28:26.126124	0	\N
2281	서울특별시 노원구 노해로75길 14-2	2026-01-29 23:28:26.126466	37.65429614	127.0576013	OFFICIAL	2026-01-29 23:28:26.12647	0	\N
2282	서울특별시 노원구 동일로 1625	2026-01-29 23:28:26.126841	37.67375444	127.0549667	OFFICIAL	2026-01-29 23:28:26.126845	0	\N
2283	서울특별시 노원구 동일로 1629-2	2026-01-29 23:28:26.1272	37.67386054	127.0552343	OFFICIAL	2026-01-29 23:28:26.127204	0	\N
2284	서울특별시 노원구 동일로221길 22	2026-01-29 23:28:26.127562	37.6599719	127.0573759	OFFICIAL	2026-01-29 23:28:26.127566	0	\N
2285	서울특별시 노원구 노원로 532	2026-01-29 23:28:26.127957	37.66461677	127.0598168	OFFICIAL	2026-01-29 23:28:26.12796	0	\N
2286	경상남도 합천군 묘산면 관기리 639-1	2026-01-29 23:28:26.128307	35.6477544	128.1268958	OFFICIAL	2026-01-29 23:28:26.128311	0	\N
2287	경상남도 합천군 묘산면 안성리 506-2	2026-01-29 23:28:26.128656	35.6722268	128.1265811	OFFICIAL	2026-01-29 23:28:26.12866	0	\N
2288	경상남도 합천군 묘산면 광산리 272	2026-01-29 23:28:26.129036	35.6429674	128.1188273	OFFICIAL	2026-01-29 23:28:26.12904	0	\N
2289	경상남도 합천군 묘산면 팔심리 398-2	2026-01-29 23:28:26.129401	35.6284328	128.0932915	OFFICIAL	2026-01-29 23:28:26.129405	0	\N
2290	경상남도 합천군 묘산면 산제리 462-5	2026-01-29 23:28:26.129793	35.6612322	128.1057111	OFFICIAL	2026-01-29 23:28:26.129796	0	\N
2291	경상남도 합천군 묘산면 관기리 1000-16	2026-01-29 23:28:26.130149	35.6492542	128.1234858	OFFICIAL	2026-01-29 23:28:26.130152	0	\N
2292	경상남도 합천군 봉산면 권빈리 산122	2026-01-29 23:28:26.1305	35.6178109	128.0725151	OFFICIAL	2026-01-29 23:28:26.130504	0	\N
2293	경상남도 합천군 봉산면 봉계리 849	2026-01-29 23:28:26.130966	35.6106827	128.0230367	OFFICIAL	2026-01-29 23:28:26.13097	0	\N
2294	대구광역시 달서구 월배로 328	2026-01-29 23:28:26.131348	35.82469667	128.5467008	OFFICIAL	2026-01-29 23:28:26.131352	0	\N
2295	대구광역시 달서구 구마로 253-1	2026-01-29 23:28:26.131722	35.8374365	128.5555388	OFFICIAL	2026-01-29 23:28:26.131726	0	\N
2296	대구광역시 달서구 달구벌대로 1541-1	2026-01-29 23:28:26.132126	35.85032939	128.5354417	OFFICIAL	2026-01-29 23:28:26.13213	0	\N
2297	대구광역시 달서구 월배로 202	2026-01-29 23:28:26.1326	35.81802126	128.5358598	OFFICIAL	2026-01-29 23:28:26.132606	0	\N
2298	대구광역시 달서구 선원로 270	2026-01-29 23:28:26.133014	35.85852491	128.5220493	OFFICIAL	2026-01-29 23:28:26.133019	0	\N
2299	대구광역시 달서구 달구벌대로 1790	2026-01-29 23:28:26.133398	35.85855961	128.5607948	OFFICIAL	2026-01-29 23:28:26.133403	0	\N
2300	대구광역시 달서구 구마로 256	2026-01-29 23:28:26.133802	35.83702973	128.5557906	OFFICIAL	2026-01-29 23:28:26.133806	0	\N
2301	대구광역시 달서구 상인서로85	2026-01-29 23:28:26.134196	35.81791126	128.5402856	OFFICIAL	2026-01-29 23:28:26.1342	0	\N
2302	대구광역시 달서구 달구벌대로 1467	2026-01-29 23:28:26.134575	35.84945213	128.5274033	OFFICIAL	2026-01-29 23:28:26.134579	0	\N
2303	전북특별자치도 남원시 주천면 용담리 257-1	2026-01-29 23:28:26.134946	35.40842925	127.4084162	OFFICIAL	2026-01-29 23:28:26.13495	0	\N
2304	전북특별자치도 남원시 주천면 송치리 1298-1	2026-01-29 23:28:26.135495	35.38903195	127.4073359	OFFICIAL	2026-01-29 23:28:26.135501	0	\N
2305	전북특별자치도 남원시 주천면 배덕리 311-1	2026-01-29 23:28:26.13596	35.36696514	127.4121295	OFFICIAL	2026-01-29 23:28:26.135964	0	\N
2306	전북특별자치도 남원시 주천면 내용궁길 32	2026-01-29 23:28:26.136351	35.37860814	127.4498623	OFFICIAL	2026-01-29 23:28:26.136354	0	\N
2307	전북특별자치도 남원시 주천면 은송리 232-3	2026-01-29 23:28:26.136719	35.39793022	127.45299	OFFICIAL	2026-01-29 23:28:26.136723	0	\N
2308	전북특별자치도 남원시 주천면 은송리 492-4	2026-01-29 23:28:26.137119	35.39716949	127.4442873	OFFICIAL	2026-01-29 23:28:26.137123	0	\N
2309	전북특별자치도 남원시 주천면 송치리 1265	2026-01-29 23:28:26.137486	35.38949235	127.4086972	OFFICIAL	2026-01-29 23:28:26.13749	0	\N
2310	전북특별자치도 남원시 주천면 고기리 861	2026-01-29 23:28:26.137876	35.38721263	127.501021	OFFICIAL	2026-01-29 23:28:26.13788	0	\N
2311	전북특별자치도 남원시 주천면 호경리 105-2	2026-01-29 23:28:26.138241	35.38832363	127.4554983	OFFICIAL	2026-01-29 23:28:26.138245	0	\N
2312	전북특별자치도 남원시 주천면 송치리 1285	2026-01-29 23:28:26.138611	35.38905703	127.4063118	OFFICIAL	2026-01-29 23:28:26.138615	0	\N
2313	전북특별자치도 남원시 주천면 장안리 242-1	2026-01-29 23:28:26.138973	35.3898443	127.4449758	OFFICIAL	2026-01-29 23:28:26.138977	0	\N
2314	전북특별자치도 남원시 운봉읍 장교리 773-3	2026-01-29 23:28:26.139337	35.45067995	127.4967987	OFFICIAL	2026-01-29 23:28:26.13934	0	\N
2315	전북특별자치도 남원시 운봉읍 권포리 547-1	2026-01-29 23:28:26.139712	35.46687842	127.5100065	OFFICIAL	2026-01-29 23:28:26.139716	0	\N
2316	전북특별자치도 남원시 운봉읍 산덕리 443-4	2026-01-29 23:28:26.140107	35.42362309	127.5388	OFFICIAL	2026-01-29 23:28:26.140111	0	\N
2317	전북특별자치도 남원시 운봉읍 행정리 535-19	2026-01-29 23:28:26.140474	35.42163261	127.5231506	OFFICIAL	2026-01-29 23:28:26.140478	0	\N
2318	전북특별자치도 남원시 운봉읍 매요리 1034-1	2026-01-29 23:28:26.140842	35.46869124	127.5402853	OFFICIAL	2026-01-29 23:28:26.140846	0	\N
2319	전북특별자치도 남원시 운봉읍 화수리 1148	2026-01-29 23:28:26.141208	35.44490464	127.5531868	OFFICIAL	2026-01-29 23:28:26.141212	0	\N
2320	전북특별자치도 남원시 송동면 내사촌길 40	2026-01-29 23:28:26.141569	35.35750874	127.3672497	OFFICIAL	2026-01-29 23:28:26.141573	0	\N
2321	전북특별자치도 남원시 송동면 연산리 327-2	2026-01-29 23:28:26.141984	35.3356625	127.3148826	OFFICIAL	2026-01-29 23:28:26.141988	0	\N
2322	전북특별자치도 남원시 송동면 송기리 306	2026-01-29 23:28:26.142349	35.35415642	127.3387237	OFFICIAL	2026-01-29 23:28:26.142353	0	\N
2323	전북특별자치도 남원시 송동면 손동길 11	2026-01-29 23:28:26.142712	35.33826696	127.3195799	OFFICIAL	2026-01-29 23:28:26.142716	0	\N
2324	전북특별자치도 남원시 송동면 장국리 617-1	2026-01-29 23:28:26.143103	35.37632011	127.3619526	OFFICIAL	2026-01-29 23:28:26.143107	0	\N
2325	전북특별자치도 남원시 송동면 송내리 541-5	2026-01-29 23:28:26.143465	35.35847485	127.3538952	OFFICIAL	2026-01-29 23:28:26.143468	0	\N
2326	전북특별자치도 남원시 수지면 유암리 948	2026-01-29 23:28:26.143828	35.32778604	127.378755	OFFICIAL	2026-01-29 23:28:26.143832	0	\N
2327	전북특별자치도 남원시 수지면 산정리 214-2	2026-01-29 23:28:26.144196	35.32340826	127.3602778	OFFICIAL	2026-01-29 23:28:26.1442	0	\N
2328	전북특별자치도 남원시 수지면 산정리 1184	2026-01-29 23:28:26.144559	35.33231879	127.3594598	OFFICIAL	2026-01-29 23:28:26.144563	0	\N
2329	전북특별자치도 남원시 수지면 고평리 1337	2026-01-29 23:28:26.144948	35.35619133	127.4043182	OFFICIAL	2026-01-29 23:28:26.144952	0	\N
2330	전북특별자치도 남원시 수지면 고평리 1369-6	2026-01-29 23:28:26.14531	35.35216936	127.3930701	OFFICIAL	2026-01-29 23:28:26.145314	0	\N
2331	전북특별자치도 남원시 수지면 고평리 634-1	2026-01-29 23:28:26.145671	35.34718789	127.3861675	OFFICIAL	2026-01-29 23:28:26.145675	0	\N
2332	전북특별자치도 남원시 수지면 산정리 741	2026-01-29 23:28:26.146026	35.33430015	127.3583112	OFFICIAL	2026-01-29 23:28:26.146029	0	\N
2333	전북특별자치도 남원시 수지면 남창리 1618	2026-01-29 23:28:26.146424	35.32752079	127.3302731	OFFICIAL	2026-01-29 23:28:26.146428	0	\N
2334	전북특별자치도 남원시 수지면 호곡리 619-4	2026-01-29 23:28:26.146833	35.33897184	127.3733893	OFFICIAL	2026-01-29 23:28:26.146837	0	\N
2335	전북특별자치도 남원시 주천면 주천리 920-179	2026-01-29 23:28:26.147196	35.37939133	127.403917	OFFICIAL	2026-01-29 23:28:26.1472	0	\N
2336	전북특별자치도 남원시 금지면 입암리 378-1	2026-01-29 23:28:26.147554	35.35725419	127.2934866	OFFICIAL	2026-01-29 23:28:26.147558	0	\N
2337	전북특별자치도 남원시 금지면 방촌리 737	2026-01-29 23:28:26.148004	35.34386525	127.2837238	OFFICIAL	2026-01-29 23:28:26.148008	0	\N
2338	전북특별자치도 남원시 금지면 하도리 621-176	2026-01-29 23:28:26.148383	35.3181501	127.3072655	OFFICIAL	2026-01-29 23:28:26.148386	0	\N
2339	전북특별자치도 남원시 금지면 택내리 933-1	2026-01-29 23:28:26.148778	35.33359034	127.286509	OFFICIAL	2026-01-29 23:28:26.148782	0	\N
2340	전북특별자치도 남원시 주생면 지당리 433-2	2026-01-29 23:28:26.149145	35.38636547	127.3293036	OFFICIAL	2026-01-29 23:28:26.149149	0	\N
2341	전북특별자치도 남원시 주생면 도산리 654-10	2026-01-29 23:28:26.149549	35.37371525	127.2815127	OFFICIAL	2026-01-29 23:28:26.149563	0	\N
2342	전북특별자치도 남원시 주생면 정송리 41-9	2026-01-29 23:28:26.14996	35.39953427	127.3325498	OFFICIAL	2026-01-29 23:28:26.149965	0	\N
2343	전북특별자치도 남원시 주생면 영천리 472-1	2026-01-29 23:28:26.15034	35.38149043	127.3134836	OFFICIAL	2026-01-29 23:28:26.150344	0	\N
2344	전북특별자치도 남원시 주생면 낙동리 323-6	2026-01-29 23:28:26.150736	35.3827541	127.3011786	OFFICIAL	2026-01-29 23:28:26.15074	0	\N
2345	전북특별자치도 남원시 주생면 상동리 635-1	2026-01-29 23:28:26.151125	35.39730222	127.3413227	OFFICIAL	2026-01-29 23:28:26.151129	0	\N
2346	전북특별자치도 남원시 주생면 정송리 636	2026-01-29 23:28:26.151486	35.39376666	127.3187051	OFFICIAL	2026-01-29 23:28:26.15149	0	\N
2347	전북특별자치도 남원시 주생면 내동리 717-131	2026-01-29 23:28:26.151922	35.38491711	127.2737878	OFFICIAL	2026-01-29 23:28:26.151926	0	\N
2348	전북특별자치도 남원시 주생면 영천리 241-6	2026-01-29 23:28:26.152285	35.3818873	127.3166595	OFFICIAL	2026-01-29 23:28:26.152289	0	\N
2349	전북특별자치도 남원시 송동면 신평리 924	2026-01-29 23:28:26.152648	35.36030725	127.3262396	OFFICIAL	2026-01-29 23:28:26.152652	0	\N
2350	전북특별자치도 남원시 송동면 연산리 347-1	2026-01-29 23:28:26.153016	35.33595684	127.3177549	OFFICIAL	2026-01-29 23:28:26.153021	0	\N
2351	전북특별자치도 남원시 송동면 두신리 844-150	2026-01-29 23:28:26.15339	35.34436817	127.3082194	OFFICIAL	2026-01-29 23:28:26.153394	0	\N
2352	전북특별자치도 남원시 덕과면 용산리 259-2	2026-01-29 23:28:26.153776	35.54837217	127.3578824	OFFICIAL	2026-01-29 23:28:26.15378	0	\N
2353	전북특별자치도 남원시 사매면 인화리 625	2026-01-29 23:28:26.154175	35.47781273	127.339478	OFFICIAL	2026-01-29 23:28:26.154179	0	\N
2354	전북특별자치도 남원시 대산면 수덕리 650-1	2026-01-29 23:28:26.154539	35.41550249	127.3316834	OFFICIAL	2026-01-29 23:28:26.154544	0	\N
2355	전북특별자치도 남원시 대산면 금성리 235-1	2026-01-29 23:28:26.154932	35.42202668	127.3395583	OFFICIAL	2026-01-29 23:28:26.154936	0	\N
2356	전북특별자치도 남원시 대산면 갈랭이길 36-48	2026-01-29 23:28:26.155285	35.40977233	127.3338005	OFFICIAL	2026-01-29 23:28:26.155288	0	\N
2357	전북특별자치도 남원시 대강면 송대리 173-1	2026-01-29 23:28:26.155667	35.36759785	127.2334992	OFFICIAL	2026-01-29 23:28:26.155671	0	\N
2358	전북특별자치도 남원시 대강면 사석리 1854-107	2026-01-29 23:28:26.156009	35.34197457	127.232421	OFFICIAL	2026-01-29 23:28:26.156013	0	\N
2359	전북특별자치도 남원시 대강면 평촌리 268-2	2026-01-29 23:28:26.156371	35.38779571	127.2417401	OFFICIAL	2026-01-29 23:28:26.156374	0	\N
2360	전북특별자치도 남원시 대강면 신덕리 636-6	2026-01-29 23:28:26.156744	35.3327879	127.2086829	OFFICIAL	2026-01-29 23:28:26.156792	0	\N
2361	전북특별자치도 남원시 대강면 사석리 728	2026-01-29 23:28:26.15717	35.34732509	127.2277385	OFFICIAL	2026-01-29 23:28:26.157174	0	\N
2362	전북특별자치도 남원시 대강면 월탄리 829	2026-01-29 23:28:26.157532	35.34638346	127.201369	OFFICIAL	2026-01-29 23:28:26.157536	0	\N
2363	전북특별자치도 남원시 금지면 황구길 15	2026-01-29 23:28:26.157929	35.33286064	127.2978235	OFFICIAL	2026-01-29 23:28:26.157933	0	\N
2364	전북특별자치도 남원시 금지면 신월리 389-1	2026-01-29 23:28:26.15829	35.32366335	127.2957471	OFFICIAL	2026-01-29 23:28:26.158294	0	\N
2365	전북특별자치도 남원시 금지면 옹정리 253-3	2026-01-29 23:28:26.158644	35.36055228	127.305782	OFFICIAL	2026-01-29 23:28:26.158648	0	\N
2366	전북특별자치도 남원시 금지면 상신리 211-1	2026-01-29 23:28:26.15903	35.33190207	127.3004057	OFFICIAL	2026-01-29 23:28:26.159034	0	\N
2367	전북특별자치도 남원시 금지면 서매리 1016-5	2026-01-29 23:28:26.159519	35.35186735	127.2741939	OFFICIAL	2026-01-29 23:28:26.159523	0	\N
2368	전북특별자치도 남원시 이백면 양가리 663-14	2026-01-29 23:28:26.159932	35.43897869	127.4628585	OFFICIAL	2026-01-29 23:28:26.159936	0	\N
2369	전북특별자치도 남원시 이백면 내동리 210	2026-01-29 23:28:26.160333	35.44656257	127.4436362	OFFICIAL	2026-01-29 23:28:26.160337	0	\N
2370	전북특별자치도 남원시 이백면 과립리 475-6	2026-01-29 23:28:26.160707	35.42585191	127.4590523	OFFICIAL	2026-01-29 23:28:26.160711	0	\N
2371	전북특별자치도 남원시 이백면 남계리 945-2	2026-01-29 23:28:26.161141	35.45428587	127.4393461	OFFICIAL	2026-01-29 23:28:26.161144	0	\N
2372	전북특별자치도 남원시 이백면 효기리 754-1	2026-01-29 23:28:26.161514	35.4220747	127.4581461	OFFICIAL	2026-01-29 23:28:26.161518	0	\N
2373	전북특별자치도 남원시 이백면 서곡리 601-4	2026-01-29 23:28:26.161909	35.42691032	127.4353836	OFFICIAL	2026-01-29 23:28:26.161913	0	\N
2374	전북특별자치도 남원시 이백면 서곡리 302-11	2026-01-29 23:28:26.162274	35.43260013	127.4371944	OFFICIAL	2026-01-29 23:28:26.162278	0	\N
2375	전북특별자치도 남원시 산동면 목동리 395-12	2026-01-29 23:28:26.162633	35.46862422	127.4407123	OFFICIAL	2026-01-29 23:28:26.162636	0	\N
2376	전북특별자치도 남원시 산동면 월석리 208	2026-01-29 23:28:26.162989	35.49671861	127.517817	OFFICIAL	2026-01-29 23:28:26.162993	0	\N
2377	전북특별자치도 남원시 산동면 월석리 397-6	2026-01-29 23:28:26.163349	35.50139781	127.5113297	OFFICIAL	2026-01-29 23:28:26.163354	0	\N
2378	전북특별자치도 남원시 산동면 대기리 156-4	2026-01-29 23:28:26.163712	35.49589819	127.4978278	OFFICIAL	2026-01-29 23:28:26.163715	0	\N
2379	전북특별자치도 남원시 산동면 태평리 536-1	2026-01-29 23:28:26.164102	35.49350189	127.4740356	OFFICIAL	2026-01-29 23:28:26.164106	0	\N
2380	전북특별자치도 남원시 보절면 금다리 359-1	2026-01-29 23:28:26.164458	35.50093726	127.425013	OFFICIAL	2026-01-29 23:28:26.164461	0	\N
2381	전북특별자치도 남원시 보절면 사촌길 15-7	2026-01-29 23:28:26.164841	35.53955647	127.4109201	OFFICIAL	2026-01-29 23:28:26.164844	0	\N
2382	전북특별자치도 남원시 덕과면 신양리 416	2026-01-29 23:28:26.165197	35.50903821	127.3860081	OFFICIAL	2026-01-29 23:28:26.165201	0	\N
2383	전북특별자치도 남원시 덕과면 덕촌리 165	2026-01-29 23:28:26.165553	35.54390953	127.3731704	OFFICIAL	2026-01-29 23:28:26.165557	0	\N
2384	전북특별자치도 남원시 산내면 백일리 519	2026-01-29 23:28:26.165938	35.4237192	127.6384466	OFFICIAL	2026-01-29 23:28:26.165942	0	\N
2385	전북특별자치도 남원시 산내면 대정리 491-1	2026-01-29 23:28:26.166298	35.42497963	127.6256705	OFFICIAL	2026-01-29 23:28:26.166302	0	\N
2386	전북특별자치도 남원시 산내면 입석리 482-5	2026-01-29 23:28:26.166654	35.41173965	127.6203803	OFFICIAL	2026-01-29 23:28:26.166658	0	\N
2387	전북특별자치도 남원시 산내면 중황리 624	2026-01-29 23:28:26.167011	35.42660069	127.6458936	OFFICIAL	2026-01-29 23:28:26.167015	0	\N
2388	전북특별자치도 남원시 산내면 부운리 235	2026-01-29 23:28:26.167453	35.37637191	127.5802182	OFFICIAL	2026-01-29 23:28:26.167457	0	\N
2389	전북특별자치도 남원시 산내면 부운리 244	2026-01-29 23:28:26.167835	35.3729065	127.5791921	OFFICIAL	2026-01-29 23:28:26.167838	0	\N
2390	전북특별자치도 남원시 산내면 입석리 205-6	2026-01-29 23:28:26.1682	35.41698763	127.629545	OFFICIAL	2026-01-29 23:28:26.168204	0	\N
2391	전북특별자치도 남원시 산내면 백일리 502-1	2026-01-29 23:28:26.16857	35.41718688	127.6389487	OFFICIAL	2026-01-29 23:28:26.168574	0	\N
2392	전북특별자치도 남원시 아영면 구상리 233-2	2026-01-29 23:28:26.168951	35.52942322	127.5905751	OFFICIAL	2026-01-29 23:28:26.168955	0	\N
2393	전북특별자치도 남원시 아영면 일대리 235-1	2026-01-29 23:28:26.169326	35.52732897	127.6019318	OFFICIAL	2026-01-29 23:28:26.16933	0	\N
2394	전북특별자치도 남원시 아영면 아곡리 703	2026-01-29 23:28:26.169696	35.48034216	127.5735216	OFFICIAL	2026-01-29 23:28:26.1697	0	\N
2395	전북특별자치도 남원시 아영면 월산리 551-2	2026-01-29 23:28:26.170085	35.51572048	127.5970278	OFFICIAL	2026-01-29 23:28:26.170089	0	\N
2396	전북특별자치도 남원시 아영면 아백로 380	2026-01-29 23:28:26.170459	35.50864276	127.6128933	OFFICIAL	2026-01-29 23:28:26.170462	0	\N
2397	전북특별자치도 남원시 아영면 의지리 76	2026-01-29 23:28:26.170822	35.52793434	127.6204677	OFFICIAL	2026-01-29 23:28:26.170826	0	\N
2398	전북특별자치도 남원시 인월면 자래리 223-3	2026-01-29 23:28:26.171204	35.48321338	127.6181834	OFFICIAL	2026-01-29 23:28:26.171208	0	\N
2399	전북특별자치도 남원시 인월면 서무리 828-1	2026-01-29 23:28:26.171578	35.46518553	127.5956106	OFFICIAL	2026-01-29 23:28:26.171581	0	\N
2400	전북특별자치도 남원시 고죽동 527-5	2026-01-29 23:28:26.171948	35.44840228	127.398552	OFFICIAL	2026-01-29 23:28:26.171952	0	\N
2401	전북특별자치도 남원시 장승길 12-3	2026-01-29 23:28:26.172339	35.41858193	127.3749332	OFFICIAL	2026-01-29 23:28:26.172342	0	\N
2402	전북특별자치도 남원시 산곡동 산 12-16	2026-01-29 23:28:26.172699	35.42616903	127.3674963	OFFICIAL	2026-01-29 23:28:26.172703	0	\N
2403	전북특별자치도 남원시 칠승리길 84	2026-01-29 23:28:26.173087	35.40857624	127.362778	OFFICIAL	2026-01-29 23:28:26.173091	0	\N
2404	전북특별자치도 남원시 노암동 597-32	2026-01-29 23:28:26.173448	35.39522147	127.3738802	OFFICIAL	2026-01-29 23:28:26.173452	0	\N
2405	전북특별자치도 남원시 신촌동 216-1	2026-01-29 23:28:26.173835	35.40851143	127.3994753	OFFICIAL	2026-01-29 23:28:26.173838	0	\N
2406	전북특별자치도 남원시 노암동 225-18	2026-01-29 23:28:26.174197	35.39371821	127.3778183	OFFICIAL	2026-01-29 23:28:26.174201	0	\N
2407	전북특별자치도 남원시 동충동 396-1	2026-01-29 23:28:26.174564	35.41172025	127.378025	OFFICIAL	2026-01-29 23:28:26.174567	0	\N
2408	대전광역시 유성구 관평동 1286	2026-01-29 23:28:26.17502	36.424048	127.388777	OFFICIAL	2026-01-29 23:28:26.175024	0	\N
2409	대전광역시 유성구 관평동 1293	2026-01-29 23:28:26.175406	36.426653	127.385358	OFFICIAL	2026-01-29 23:28:26.17541	0	\N
2410	대전광역시 유성구 테크노2로 319 (탑립동) 대전광역시 유성구 탑립동 930	2026-01-29 23:28:26.175813	36.413548	127.411603	OFFICIAL	2026-01-29 23:28:26.175816	0	\N
2411	대전광역시 유성구 탑립동 946	2026-01-29 23:28:26.176187	36.416345	127.406623	OFFICIAL	2026-01-29 23:28:26.176191	0	\N
2412	대전광역시 유성구 테크노2로 153 (용산동) 대전광역시 유성구 용산동 521	2026-01-29 23:28:26.176556	36.425833	127.402124	OFFICIAL	2026-01-29 23:28:26.176559	0	\N
2413	대전광역시 유성구 테크노2로 106 (관평동) 대전광역시 유성구 관평동 691	2026-01-29 23:28:26.176957	36.428446	127.398053	OFFICIAL	2026-01-29 23:28:26.176961	0	\N
2414	대전광역시 유성구 관평동 1287 대전광역시 유성구 관평동 1287	2026-01-29 23:28:26.177324	36.430313	127.395657	OFFICIAL	2026-01-29 23:28:26.177327	0	\N
2415	대전광역시 유성구 관평동 1286	2026-01-29 23:28:26.177734	36.424076	127.388517	OFFICIAL	2026-01-29 23:28:26.177738	0	\N
2416	대전광역시 유성구 관평2로 43 대전광역시 유성구 관평동 1281	2026-01-29 23:28:26.178129	36.421456	127.388674	OFFICIAL	2026-01-29 23:28:26.178133	0	\N
2417	대전광역시 유성구 관평동 673	2026-01-29 23:28:26.178487	36.421214	127.388539	OFFICIAL	2026-01-29 23:28:26.178491	0	\N
2418	대전광역시 유성구 용산2로 33 (용산동) 대전광역시 유성구 관평동 683	2026-01-29 23:28:26.178904	36.418774	127.387836	OFFICIAL	2026-01-29 23:28:26.178908	0	\N
2419	대전광역시 유성구 관평동 673	2026-01-29 23:28:26.179352	36.420325	127.392259	OFFICIAL	2026-01-29 23:28:26.179357	0	\N
2420	대전광역시 유성구 관평동 1286	2026-01-29 23:28:26.179808	36.428107	127.391129	OFFICIAL	2026-01-29 23:28:26.179812	0	\N
2421	대전광역시 유성구 전민동 905	2026-01-29 23:28:26.180247	36.399553	127.399516	OFFICIAL	2026-01-29 23:28:26.180251	0	\N
2422	대전광역시 유성구 전민동 394-16	2026-01-29 23:28:26.180631	36.399534	127.403753	OFFICIAL	2026-01-29 23:28:26.180635	0	\N
2423	대전광역시 유성구 원촌동 51	2026-01-29 23:28:26.181053	36.376771	127.402904	OFFICIAL	2026-01-29 23:28:26.181057	0	\N
2424	대전광역시 유성구 원촌동 135-2	2026-01-29 23:28:26.181437	36.384832	127.405441	OFFICIAL	2026-01-29 23:28:26.18144	0	\N
2425	대전광역시 유성구 원촌동 48-1	2026-01-29 23:28:26.181832	36.377292	127.404749	OFFICIAL	2026-01-29 23:28:26.181835	0	\N
2426	대전광역시 유성구 전민동 394-16	2026-01-29 23:28:26.182194	36.399769	127.403827	OFFICIAL	2026-01-29 23:28:26.182198	0	\N
2427	대전광역시 유성구 전민동 523-4	2026-01-29 23:28:26.182564	36.399754	127.400561	OFFICIAL	2026-01-29 23:28:26.182578	0	\N
2428	대전광역시 유성구 전민동 464-3	2026-01-29 23:28:26.182951	36.400584	127.405049	OFFICIAL	2026-01-29 23:28:26.182955	0	\N
2429	대전광역시 유성구 전민동 464-7	2026-01-29 23:28:26.183323	36.396638	127.405031	OFFICIAL	2026-01-29 23:28:26.183327	0	\N
2430	대전광역시 유성구 전민동 396-6	2026-01-29 23:28:26.183694	36.398072	127.404832	OFFICIAL	2026-01-29 23:28:26.183698	0	\N
2431	대전광역시 유성구 문지동 103-3	2026-01-29 23:28:26.184096	36.396067	127.404767	OFFICIAL	2026-01-29 23:28:26.1841	0	\N
2432	대전광역시 유성구 원촌동 90	2026-01-29 23:28:26.184466	36.381851	127.406515	OFFICIAL	2026-01-29 23:28:26.18447	0	\N
2433	대전광역시 유성구 원촌동 90	2026-01-29 23:28:26.184861	36.381202	127.406279	OFFICIAL	2026-01-29 23:28:26.184865	0	\N
2434	대전광역시 유성구 전민동 462-11	2026-01-29 23:28:26.185245	36.403781	127.404784	OFFICIAL	2026-01-29 23:28:26.185249	0	\N
2435	대전광역시 유성구 화암동 25-13	2026-01-29 23:28:26.185608	36.410545	127.377634	OFFICIAL	2026-01-29 23:28:26.185612	0	\N
2436	대전광역시 유성구 방현동 349	2026-01-29 23:28:26.185971	36.407123	127.373723	OFFICIAL	2026-01-29 23:28:26.185975	0	\N
2437	대전광역시 유성구 하기동 18-52	2026-01-29 23:28:26.186347	36.389247	127.347006	OFFICIAL	2026-01-29 23:28:26.186351	0	\N
2438	전북특별자치도 남원시 산내면 중황리 758	2026-01-29 23:28:26.18671	35.42264154	127.6424419	OFFICIAL	2026-01-29 23:28:26.186714	0	\N
2439	대전광역시 유성구 신성동 산 19-3	2026-01-29 23:28:26.187109	36.384703	127.349005	OFFICIAL	2026-01-29 23:28:26.187113	0	\N
2440	대전광역시 유성구 대덕대로 480 (도룡동) 대전광역시 유성구 도룡동 3-1	2026-01-29 23:28:26.187572	36.377388	127.379189	OFFICIAL	2026-01-29 23:28:26.187576	0	\N
2441	대전광역시 유성구 가정동 9-1	2026-01-29 23:28:26.187949	36.377443	127.378832	OFFICIAL	2026-01-29 23:28:26.187952	0	\N
2442	대전광역시 유성구 구성동 464	2026-01-29 23:28:26.18831	36.365131	127.362894	OFFICIAL	2026-01-29 23:28:26.188314	0	\N
2443	대전광역시 유성구 화암동 120-3	2026-01-29 23:28:26.188708	36.412353	127.378033	OFFICIAL	2026-01-29 23:28:26.188711	0	\N
2444	대전광역시 유성구 화암동 25-13	2026-01-29 23:28:26.189102	36.412861	127.378402	OFFICIAL	2026-01-29 23:28:26.189106	0	\N
2445	대전광역시 유성구 대덕대로 523 (가정동) 대전광역시 유성구 가정동 2	2026-01-29 23:28:26.189467	36.382278	127.378439	OFFICIAL	2026-01-29 23:28:26.189471	0	\N
2446	대전광역시 유성구 도룡동 436	2026-01-29 23:28:26.189831	36.381981	127.378745	OFFICIAL	2026-01-29 23:28:26.189834	0	\N
2447	대전광역시 유성구 도룡동 409	2026-01-29 23:28:26.190194	36.386499	127.378522	OFFICIAL	2026-01-29 23:28:26.190198	0	\N
2448	대전광역시 유성구 화암동 61-4	2026-01-29 23:28:26.190563	36.399736	127.374311	OFFICIAL	2026-01-29 23:28:26.190566	0	\N
2449	대전광역시 유성구 대덕대로 634 (도룡동) 대전광역시 유성구 도룡동 401	2026-01-29 23:28:26.190951	36.388541	127.379573	OFFICIAL	2026-01-29 23:28:26.190955	0	\N
2450	대전광역시 유성구 도룡동 409	2026-01-29 23:28:26.191322	36.386675	127.378811	OFFICIAL	2026-01-29 23:28:26.191326	0	\N
2451	대전광역시 유성구 도룡동 582	2026-01-29 23:28:26.191686	36.374098	127.388722	OFFICIAL	2026-01-29 23:28:26.19169	0	\N
2452	대전광역시 유성구 대덕대로 480 (도룡동) 대전광역시 유성구 도룡동 3-1	2026-01-29 23:28:26.192071	36.374334	127.387221	OFFICIAL	2026-01-29 23:28:26.192075	0	\N
2453	대전광역시 유성구 신성동 458	2026-01-29 23:28:26.192434	36.384451	127.354471	OFFICIAL	2026-01-29 23:28:26.192437	0	\N
2454	대전광역시 유성구 장동 산 19-3	2026-01-29 23:28:26.192824	36.390008	127.362306	OFFICIAL	2026-01-29 23:28:26.192828	0	\N
2455	대전광역시 유성구 가정동 산 1-2	2026-01-29 23:28:26.193195	36.384194	127.367184	OFFICIAL	2026-01-29 23:28:26.193198	0	\N
2456	대전광역시 유성구 신성동 420-8	2026-01-29 23:28:26.193555	36.384142	127.347149	OFFICIAL	2026-01-29 23:28:26.193559	0	\N
2457	대전광역시 유성구 신성동 108-2	2026-01-29 23:28:26.193944	36.385441	127.352951	OFFICIAL	2026-01-29 23:28:26.193948	0	\N
2458	대전광역시 유성구 도룡동 404	2026-01-29 23:28:26.194312	36.385864	127.377352	OFFICIAL	2026-01-29 23:28:26.194315	0	\N
2459	대전광역시 유성구 북유성대로 300 (반석동) 대전광역시 유성구 반석동 61	2026-01-29 23:28:26.194672	36.391386	127.315419	OFFICIAL	2026-01-29 23:28:26.194676	0	\N
2460	대전광역시 유성구 지족동 1005	2026-01-29 23:28:26.195008	36.386484	127.318452	OFFICIAL	2026-01-29 23:28:26.195011	0	\N
2461	대전광역시 유성구 지족동 946	2026-01-29 23:28:26.195372	36.382329	127.319466	OFFICIAL	2026-01-29 23:28:26.195376	0	\N
2462	대전광역시 유성구 북유성대로 지하303 (반석동) 대전광역시 유성구 반석동 685	2026-01-29 23:28:26.195736	36.391441	127.315481	OFFICIAL	2026-01-29 23:28:26.19574	0	\N
2463	대전광역시 유성구 한밭대로 지하155 (노은동) 대전광역시 유성구 노은동 612	2026-01-29 23:28:26.196129	36.367091	127.321462	OFFICIAL	2026-01-29 23:28:26.196132	0	\N
2464	대전광역시 유성구 한밭대로 지하155 (노은동) 대전광역시 유성구 노은동 612	2026-01-29 23:28:26.196489	36.366467	127.321791	OFFICIAL	2026-01-29 23:28:26.196492	0	\N
2465	대전광역시 유성구 장대로 43 (장대동) 대전광역시 유성구 장대동 280-18	2026-01-29 23:28:26.196874	36.358777	127.336215	OFFICIAL	2026-01-29 23:28:26.196878	0	\N
2466	전북특별자치도 남원시 산내면 덕동리 21-4	2026-01-29 23:28:26.19739	35.36897226	127.5702746	OFFICIAL	2026-01-29 23:28:26.197394	0	\N
2467	대전광역시 유성구 죽동 119-4	2026-01-29 23:28:26.197806	36.366422	127.338706	OFFICIAL	2026-01-29 23:28:26.19781	0	\N
2468	대전광역시 유성구 장대동 309-1	2026-01-29 23:28:26.198181	36.365406	127.335747	OFFICIAL	2026-01-29 23:28:26.198185	0	\N
2469	대전광역시 유성구 장대동 321	2026-01-29 23:28:26.198554	36.365147	127.335141	OFFICIAL	2026-01-29 23:28:26.198558	0	\N
2470	대전광역시 유성구 대학로 99 (궁동) 대전광역시 유성구 궁동 220	2026-01-29 23:28:26.198945	36.370175	127.340484	OFFICIAL	2026-01-29 23:28:26.198949	0	\N
2471	대전광역시 유성구 대학로 99 (궁동) 대전광역시 유성구 궁동 220	2026-01-29 23:28:26.199326	36.369342	127.340159	OFFICIAL	2026-01-29 23:28:26.19933	0	\N
2472	대전광역시 유성구 궁동 29-4	2026-01-29 23:28:26.199687	36.360836	127.349455	OFFICIAL	2026-01-29 23:28:26.199691	0	\N
2473	대전광역시 유성구 어은동 311	2026-01-29 23:28:26.20013	36.361408	127.356052	OFFICIAL	2026-01-29 23:28:26.200134	0	\N
2474	대전광역시 유성구 대학로 99 (궁동) 대전광역시 유성구 궁동 351	2026-01-29 23:28:26.201168	36.362615	127.343686	OFFICIAL	2026-01-29 23:28:26.201172	0	\N
2475	대전광역시 유성구 궁동 450-1	2026-01-29 23:28:26.201567	36.362202	127.343492	OFFICIAL	2026-01-29 23:28:26.201572	0	\N
2476	대전광역시 유성구 어은동 59-23	2026-01-29 23:28:26.201977	36.361586	127.357143	OFFICIAL	2026-01-29 23:28:26.201981	0	\N
2477	대전광역시 유성구 어은동 311	2026-01-29 23:28:26.202372	36.362647	127.358587	OFFICIAL	2026-01-29 23:28:26.202375	0	\N
2478	대전광역시 유성구 대학로 291 (구성동) 대전광역시 유성구 구성동 23	2026-01-29 23:28:26.202734	36.370458	127.368716	OFFICIAL	2026-01-29 23:28:26.202738	0	\N
2479	대전광역시 유성구 구성동 286-3	2026-01-29 23:28:26.20312	36.365865	127.325091	OFFICIAL	2026-01-29 23:28:26.203124	0	\N
2480	대전광역시 유성구 계룡로 지하97 (봉명동) 대전광역시 유성구 봉명동 551-18	2026-01-29 23:28:26.203477	36.354617	127.342115	OFFICIAL	2026-01-29 23:28:26.203481	0	\N
2481	대전광역시 유성구 구암동 641	2026-01-29 23:28:26.203864	36.350826	127.335589	OFFICIAL	2026-01-29 23:28:26.203868	0	\N
2482	대전광역시 유성구 월드컵대로275번길 48 (구암동) 대전광역시 유성구 구암동 618-1	2026-01-29 23:28:26.204227	36.351791	127.331734	OFFICIAL	2026-01-29 23:28:26.204231	0	\N
2483	대전광역시 유성구 유성대로654번길 66 (구암동) 대전광역시 유성구 구암동 617-3	2026-01-29 23:28:26.20462	36.351321	127.332634	OFFICIAL	2026-01-29 23:28:26.204624	0	\N
2484	대전광역시 유성구 덕명동 150-6	2026-01-29 23:28:26.204987	36.351561	127.297815	OFFICIAL	2026-01-29 23:28:26.20499	0	\N
2485	대전광역시 유성구 구암동 424-3	2026-01-29 23:28:26.205429	36.359542	127.320103	OFFICIAL	2026-01-29 23:28:26.205433	0	\N
2486	대전광역시 유성구 현충원로 지하455 (구암동) 대전광역시 유성구 구암동 527-193	2026-01-29 23:28:26.205828	36.359269	127.321804	OFFICIAL	2026-01-29 23:28:26.205832	0	\N
2487	대전광역시 유성구 구암동 642	2026-01-29 23:28:26.20619	36.351321	127.332705	OFFICIAL	2026-01-29 23:28:26.206194	0	\N
2488	대전광역시 유성구 구암동 95-11	2026-01-29 23:28:26.206558	36.356021	127.330929	OFFICIAL	2026-01-29 23:28:26.206562	0	\N
2489	대전광역시 유성구 구암동 94-3	2026-01-29 23:28:26.206943	36.355791	127.331172	OFFICIAL	2026-01-29 23:28:26.206946	0	\N
2490	대전광역시 유성구 봉명동 4-1	2026-01-29 23:28:26.207297	36.359355	127.355045	OFFICIAL	2026-01-29 23:28:26.2073	0	\N
2491	대전광역시 유성구 덕명동 569	2026-01-29 23:28:26.20766	36.358351	127.303621	OFFICIAL	2026-01-29 23:28:26.207665	0	\N
2492	대전광역시 유성구 덕명동 569	2026-01-29 23:28:26.208008	36.358268	127.304035	OFFICIAL	2026-01-29 23:28:26.208012	0	\N
2493	대전광역시 유성구 봉명동 1026-4	2026-01-29 23:28:26.208353	36.352312	127.341205	OFFICIAL	2026-01-29 23:28:26.208357	0	\N
2494	전북특별자치도 남원시 산내면 중황리 513-2	2026-01-29 23:28:26.208695	35.42593424	127.6483493	OFFICIAL	2026-01-29 23:28:26.208698	0	\N
2495	대전광역시 유성구 봉명동 608	2026-01-29 23:28:26.209089	36.358256	127.343483	OFFICIAL	2026-01-29 23:28:26.209093	0	\N
2496	대전광역시 유성구 봉명동 1058	2026-01-29 23:28:26.209444	36.353257	127.341083	OFFICIAL	2026-01-29 23:28:26.209448	0	\N
2497	대전광역시 유성구 계룡로 지하97 (봉명동) 대전광역시 유성구 봉명동 552-11	2026-01-29 23:28:26.209861	36.354748	127.341562	OFFICIAL	2026-01-29 23:28:26.209865	0	\N
2498	대전광역시 유성구 계룡로 지하97 (봉명동) 대전광역시 유성구 봉명동 551-18	2026-01-29 23:28:26.210286	36.354743	127.342102	OFFICIAL	2026-01-29 23:28:26.21029	0	\N
2499	대전광역시 유성구 봉명동 1058	2026-01-29 23:28:26.210658	36.351961	127.346802	OFFICIAL	2026-01-29 23:28:26.210662	0	\N
2500	대전광역시 유성구 봉명동 1058	2026-01-29 23:28:26.211022	36.352695	127.345744	OFFICIAL	2026-01-29 23:28:26.211025	0	\N
2501	대전광역시 유성구 봉명동 468-21	2026-01-29 23:28:26.211422	36.354642	127.338031	OFFICIAL	2026-01-29 23:28:26.211425	0	\N
2502	대전광역시 유성구 봉명동 1062	2026-01-29 23:28:26.211827	36.348696	127.341772	OFFICIAL	2026-01-29 23:28:26.21183	0	\N
2503	대전광역시 유성구 상대동 498	2026-01-29 23:28:26.212188	36.341489	127.338104	OFFICIAL	2026-01-29 23:28:26.212192	0	\N
2504	대전광역시 유성구 원신흥동 609	2026-01-29 23:28:26.212579	36.332453	127.339349	OFFICIAL	2026-01-29 23:28:26.212583	0	\N
2505	대전광역시 유성구 원신흥동 534-1	2026-01-29 23:28:26.212973	36.338155	127.341123	OFFICIAL	2026-01-29 23:28:26.212978	0	\N
2506	대전광역시 유성구 원신흥동 588	2026-01-29 23:28:26.213349	36.338384	127.338961	OFFICIAL	2026-01-29 23:28:26.213353	0	\N
2507	대전광역시 유성구 원신흥동 602-1	2026-01-29 23:28:26.213706	36.333902	127.338023	OFFICIAL	2026-01-29 23:28:26.21371	0	\N
2508	대전광역시 유성구 원신흥동 602-1	2026-01-29 23:28:26.214088	36.334351	127.338281	OFFICIAL	2026-01-29 23:28:26.214092	0	\N
2509	대전광역시 유성구 원신흥동 528-1	2026-01-29 23:28:26.214461	36.332393	127.313102	OFFICIAL	2026-01-29 23:28:26.214465	0	\N
2510	대전광역시 유성구 봉명동 1062	2026-01-29 23:28:26.214826	36.348297	127.342096	OFFICIAL	2026-01-29 23:28:26.214829	0	\N
2511	대전광역시 유성구 상대동 498	2026-01-29 23:28:26.215189	36.347221	127.340085	OFFICIAL	2026-01-29 23:28:26.215193	0	\N
2512	대전광역시 유성구 진잠로42번길 35 (원내동) 대전광역시 유성구 원내동 351	2026-01-29 23:28:26.215546	36.295726	127.321283	OFFICIAL	2026-01-29 23:28:26.21555	0	\N
2513	대전광역시 유성구 원내동 711	2026-01-29 23:28:26.215949	36.295851	127.319563	OFFICIAL	2026-01-29 23:28:26.215953	0	\N
2514	대전광역시 유성구 원내동 416-6	2026-01-29 23:28:26.216297	36.293648	127.319419	OFFICIAL	2026-01-29 23:28:26.216301	0	\N
2515	대전광역시 유성구 교촌동 651	2026-01-29 23:28:26.216647	36.303999	127.319446	OFFICIAL	2026-01-29 23:28:26.216651	0	\N
2516	대전광역시 유성구 원내동 711	2026-01-29 23:28:26.217003	36.299769	127.322048	OFFICIAL	2026-01-29 23:28:26.217006	0	\N
2517	대전광역시 유성구 교촌동 652	2026-01-29 23:28:26.217349	36.306831	127.319335	OFFICIAL	2026-01-29 23:28:26.217352	0	\N
2518	대전광역시 유성구 대정동 318	2026-01-29 23:28:26.217813	36.315573	127.319812	OFFICIAL	2026-01-29 23:28:26.217817	0	\N
2519	대전광역시 유성구 대정동 318	2026-01-29 23:28:26.218183	36.315474	127.320086	OFFICIAL	2026-01-29 23:28:26.218187	0	\N
2520	대전광역시 유성구 대정동 246-2	2026-01-29 23:28:26.218564	36.311666	127.318471	OFFICIAL	2026-01-29 23:28:26.218568	0	\N
2521	대전광역시 유성구 대정동 274	2026-01-29 23:28:26.218951	36.311975	127.318404	OFFICIAL	2026-01-29 23:28:26.218955	0	\N
2522	대구광역시 북구 옥산로 112 대구광역시 북구 고성동3가 7-2	2026-01-29 23:28:26.219317	35.88331609	128.587807	OFFICIAL	2026-01-29 23:28:26.219321	0	\N
2523	경상남도 합천군 초계면 관평리 661-22	2026-01-29 23:28:26.219678	35.5432002	128.2589864	OFFICIAL	2026-01-29 23:28:26.219682	0	\N
2524	경상남도 합천군 초계면 신촌리 172-2	2026-01-29 23:28:26.220063	35.5227028	128.2504306	OFFICIAL	2026-01-29 23:28:26.220067	0	\N
2525	경상남도 합천군 초계면 상대리 280	2026-01-29 23:28:26.220474	35.5300361	128.2436278	OFFICIAL	2026-01-29 23:28:26.220478	0	\N
2526	경상남도 합천군 초계면 중리 417	2026-01-29 23:28:26.220851	35.5564699	128.2540764	OFFICIAL	2026-01-29 23:28:26.220855	0	\N
2527	경상남도 합천군 초계면 유하리 270-1	2026-01-29 23:28:26.221216	35.5410166	128.2471571	OFFICIAL	2026-01-29 23:28:26.22122	0	\N
2528	경상남도 합천군 초계면 초계리 500	2026-01-29 23:28:26.221571	35.5565074	128.2618088	OFFICIAL	2026-01-29 23:28:26.221575	0	\N
2529	경상남도 합천군 율곡면 갑산리 564-15	2026-01-29 23:28:26.221946	35.5900712	128.2591814	OFFICIAL	2026-01-29 23:28:26.22195	0	\N
2530	경상남도 합천군 율곡면 낙민리 1358	2026-01-29 23:28:26.222307	35.5852319	128.2225868	OFFICIAL	2026-01-29 23:28:26.222311	0	\N
2531	경상남도 합천군 율곡면 본천리 1053-1	2026-01-29 23:28:26.22266	35.5399102	128.1969753	OFFICIAL	2026-01-29 23:28:26.222664	0	\N
2532	경상남도 합천군 율곡면 노양리 789	2026-01-29 23:28:26.223007	35.6378249	128.1865161	OFFICIAL	2026-01-29 23:28:26.223011	0	\N
2533	경상남도 합천군 율곡면 와리 176-2	2026-01-29 23:28:26.223473	35.6215095	128.1982571	OFFICIAL	2026-01-29 23:28:26.223477	0	\N
2534	경상남도 합천군 율곡면 본천리 424	2026-01-29 23:28:26.223878	35.5567639	128.1926374	OFFICIAL	2026-01-29 23:28:26.223882	0	\N
2535	경상남도 합천군 율곡면 율진리 1168	2026-01-29 23:28:26.224253	35.6076124	128.1856511	OFFICIAL	2026-01-29 23:28:26.224256	0	\N
2536	경상남도 합천군 율곡면 기리 316-1	2026-01-29 23:28:26.224619	35.6219446	128.2274796	OFFICIAL	2026-01-29 23:28:26.224622	0	\N
2537	경상남도 합천군 율곡면 노양리 548-2	2026-01-29 23:28:26.224984	35.6219777	128.1929814	OFFICIAL	2026-01-29 23:28:26.224988	0	\N
2538	경상남도 합천군 율곡면 본천리 306	2026-01-29 23:28:26.225349	35.5577549	128.1985633	OFFICIAL	2026-01-29 23:28:26.225353	0	\N
2539	경상남도 합천군 율곡면 영전리 74-4	2026-01-29 23:28:26.225708	35.5682415	128.2070949	OFFICIAL	2026-01-29 23:28:26.225712	0	\N
2540	경상남도 합천군 율곡면 갑산2길 14-6	2026-01-29 23:28:26.226083	35.5897028	128.2457175	OFFICIAL	2026-01-29 23:28:26.226087	0	\N
2541	경상남도 합천군 율곡면 내천리 434	2026-01-29 23:28:26.226437	35.6133436	128.2377981	OFFICIAL	2026-01-29 23:28:26.22644	0	\N
2542	경상남도 합천군 율곡면 항곡리 243-2	2026-01-29 23:28:26.226807	35.5973827	128.2124011	OFFICIAL	2026-01-29 23:28:26.226811	0	\N
2543	경상남도 합천군 율곡면 갑산리 697	2026-01-29 23:28:26.227186	35.5944949	128.2559181	OFFICIAL	2026-01-29 23:28:26.22719	0	\N
2544	경상남도 합천군 율곡면 항곡리 557-3	2026-01-29 23:28:26.227553	35.6079027	128.2118769	OFFICIAL	2026-01-29 23:28:26.227557	0	\N
2545	경상남도 합천군 율곡면 율진리 521	2026-01-29 23:28:26.227943	35.5927753	128.1860252	OFFICIAL	2026-01-29 23:28:26.227947	0	\N
2546	경상남도 합천군 율곡면 제내리 24-5	2026-01-29 23:28:26.228306	35.5888012	128.2177413	OFFICIAL	2026-01-29 23:28:26.22831	0	\N
2547	경상남도 합천군 야로면 매촌리 635-1	2026-01-29 23:28:26.228664	35.7148879	128.1640272	OFFICIAL	2026-01-29 23:28:26.228668	0	\N
2548	경상남도 합천군 야로면 월광리 33-3	2026-01-29 23:28:26.229086	35.7277153	128.1563931	OFFICIAL	2026-01-29 23:28:26.229091	0	\N
2549	경상남도 합천군 야로면 묵촌리 2-3	2026-01-29 23:28:26.229492	35.7050381	128.1557962	OFFICIAL	2026-01-29 23:28:26.229496	0	\N
2550	경상남도 합천군 야로면 정대리 986	2026-01-29 23:28:26.229951	35.6942784	128.1672777	OFFICIAL	2026-01-29 23:28:26.229955	0	\N
2551	경상남도 합천군 야로면 금평리 557-2	2026-01-29 23:28:26.23035	35.7029705	128.1777497	OFFICIAL	2026-01-29 23:28:26.230354	0	\N
2552	경상남도 합천군 야로면 묵촌리 산80-11	2026-01-29 23:28:26.230833	35.6920406	128.1485558	OFFICIAL	2026-01-29 23:28:26.230841	0	\N
2553	경상남도 합천군 가야면 치인리 산25-1	2026-01-29 23:28:26.231271	35.7835206	128.0458515	OFFICIAL	2026-01-29 23:28:26.231276	0	\N
2554	경상남도 합천군 가야면 이천리 554	2026-01-29 23:28:26.231675	35.7243123	128.1302226	OFFICIAL	2026-01-29 23:28:26.231679	0	\N
2555	경상남도 합천군 가야면 치인리 797	2026-01-29 23:28:26.232054	35.7878906	128.0497701	OFFICIAL	2026-01-29 23:28:26.232058	0	\N
2556	서울특별시 노원구 화랑로 510	2026-01-29 23:28:26.232513	37.61989439	127.0837446	OFFICIAL	2026-01-29 23:28:26.232517	0	\N
2557	서울특별시 노원구 공릉로46길 18	2026-01-29 23:28:26.232927	37.627173	127.0799936	OFFICIAL	2026-01-29 23:28:26.232931	0	\N
2558	서울특별시 노원구 노원로16길 15	2026-01-29 23:28:26.233307	37.64344507	127.0733372	OFFICIAL	2026-01-29 23:28:26.233311	0	\N
2559	서울특별시 노원구 공릉로 232	2026-01-29 23:28:26.233801	37.63307893	127.0767947	OFFICIAL	2026-01-29 23:28:26.233805	0	\N
2560	서울특별시 노원구 중계로 169	2026-01-29 23:28:26.234298	37.65026232	127.0807682	OFFICIAL	2026-01-29 23:28:26.234303	0	\N
2561	서울특별시 노원구 동일로 1690-2	2026-01-29 23:28:26.234816	37.67928212	127.0555505	OFFICIAL	2026-01-29 23:28:26.234821	0	\N
2562	서울특별시 노원구 동일로 1690-2	2026-01-29 23:28:26.235212	37.67928212	127.0555505	OFFICIAL	2026-01-29 23:28:26.235216	0	\N
2563	서울특별시 노원구 마들로 86	2026-01-29 23:28:26.235713	37.62358892	127.0687828	OFFICIAL	2026-01-29 23:28:26.235719	0	\N
2564	서울특별시 노원구 마들로 86	2026-01-29 23:28:26.236166	37.62358892	127.0687828	OFFICIAL	2026-01-29 23:28:26.23617	0	\N
2565	서울특별시 노원구 상계로 118	2026-01-29 23:28:26.236565	37.65748313	127.0678641	OFFICIAL	2026-01-29 23:28:26.236569	0	\N
2566	서울특별시 노원구 상계로 182	2026-01-29 23:28:26.236954	37.66090389	127.0735754	OFFICIAL	2026-01-29 23:28:26.236958	0	\N
2567	서울특별시 노원구 한글비석로 434	2026-01-29 23:28:26.237695	37.66298077	127.0693673	OFFICIAL	2026-01-29 23:28:26.237699	0	\N
2568	서울특별시 노원구 한글비석로41가길 24	2026-01-29 23:28:26.238105	37.66219777	127.0686777	OFFICIAL	2026-01-29 23:28:26.238108	0	\N
2569	서울특별시 노원구 초안산로 12	2026-01-29 23:28:26.238554	37.63034387	127.0544999	OFFICIAL	2026-01-29 23:28:26.238558	0	\N
2570	서울특별시 노원구 월계로 334	2026-01-29 23:28:26.238971	37.62901731	127.0576125	OFFICIAL	2026-01-29 23:28:26.238975	0	\N
2571	서울특별시 노원구 동일로242길 11	2026-01-29 23:28:26.239343	37.67584698	127.0562724	OFFICIAL	2026-01-29 23:28:26.239347	0	\N
2572	서울특별시 노원구 노원로 510	2026-01-29 23:28:26.239717	37.66093573	127.0625889	OFFICIAL	2026-01-29 23:28:26.239721	0	\N
2573	서울특별시 노원구 동일로221길 22	2026-01-29 23:28:26.240107	37.6599719	127.0573759	OFFICIAL	2026-01-29 23:28:26.240111	0	\N
2574	서울특별시 노원구 동일로 1461	2026-01-29 23:28:26.240469	37.65913138	127.0582807	OFFICIAL	2026-01-29 23:28:26.240473	0	\N
2575	서울특별시 노원구 노원로16길 15	2026-01-29 23:28:26.240894	37.64344507	127.0733372	OFFICIAL	2026-01-29 23:28:26.240903	0	\N
2576	서울특별시 노원구 화랑로 653	2026-01-29 23:28:26.241353	37.62961285	127.0950867	OFFICIAL	2026-01-29 23:28:26.241359	0	\N
2577	서울특별시 노원구 노원로 58	2026-01-29 23:28:26.241727	37.62692051	127.0883803	OFFICIAL	2026-01-29 23:28:26.241731	0	\N
2578	서울특별시 노원구 노원로 75	2026-01-29 23:28:26.242283	37.62881715	127.082693	OFFICIAL	2026-01-29 23:28:26.242288	0	\N
2579	서울특별시 노원구 한글비석로 276	2026-01-29 23:28:26.242684	37.65189706	127.0777654	OFFICIAL	2026-01-29 23:28:26.242688	0	\N
2580	서울특별시 노원구 한글비석로 250	2026-01-29 23:28:26.243136	37.65002891	127.077012	OFFICIAL	2026-01-29 23:28:26.243141	0	\N
2581	서울특별시 노원구 한글비석로 383	2026-01-29 23:28:26.243519	37.65911197	127.073075	OFFICIAL	2026-01-29 23:28:26.243523	0	\N
2582	서울특별시 노원구 한글비석로 384	2026-01-29 23:28:26.24392	37.6598085	127.07324	OFFICIAL	2026-01-29 23:28:26.243924	0	\N
2583	서울특별시 노원구 한글비석로 245	2026-01-29 23:28:26.244291	37.6492608	127.0763611	OFFICIAL	2026-01-29 23:28:26.244295	0	\N
2584	서울특별시 노원구 한글비석로 269	2026-01-29 23:28:26.244661	37.65171822	127.0767882	OFFICIAL	2026-01-29 23:28:26.244665	0	\N
2585	서울특별시 노원구 월계로 55길 16	2026-01-29 23:28:26.245051	37.63266533	127.0608256	OFFICIAL	2026-01-29 23:28:26.245055	0	\N
2586	서울특별시 노원구 석계로15길 25	2026-01-29 23:28:26.245418	37.62206287	127.0613425	OFFICIAL	2026-01-29 23:28:26.245421	0	\N
2587	서울특별시 노원구 석계로 98-2	2026-01-29 23:28:26.245806	37.62303356	127.0617635	OFFICIAL	2026-01-29 23:28:26.24581	0	\N
2588	서울특별시 노원구 광운로 20	2026-01-29 23:28:26.246171	37.61932035	127.0583381	OFFICIAL	2026-01-29 23:28:26.246175	0	\N
2589	서울특별시 노원구 노원로 564	2026-01-29 23:28:26.246562	37.66165211	127.0561247	OFFICIAL	2026-01-29 23:28:26.246566	0	\N
2590	서울특별시 노원구 덕릉로 460	2026-01-29 23:28:26.24697	37.64438255	127.059922	OFFICIAL	2026-01-29 23:28:26.246974	0	\N
2591	서울특별시 노원구 노해로 456	2026-01-29 23:28:26.247342	37.65358729	127.0587983	OFFICIAL	2026-01-29 23:28:26.247346	0	\N
2592	서울특별시 노원구 한글비석로 463	2026-01-29 23:28:26.247848	37.66421635	127.0664373	OFFICIAL	2026-01-29 23:28:26.247852	0	\N
2593	서울특별시 노원구 상계로 312-1	2026-01-29 23:28:26.248256	37.67041582	127.0800568	OFFICIAL	2026-01-29 23:28:26.248271	0	\N
2594	서울특별시 노원구 상계동 111-484	2026-01-29 23:28:26.248663	37.64100553	127.0721484	OFFICIAL	2026-01-29 23:28:26.248666	0	\N
2595	서울특별시 노원구 동일로 1668	2026-01-29 23:28:26.249027	37.67713768	127.0555972	OFFICIAL	2026-01-29 23:28:26.249031	0	\N
2596	서울특별시 노원구 동일로 1669	2026-01-29 23:28:26.249503	37.67745849	127.054894	OFFICIAL	2026-01-29 23:28:26.249508	0	\N
2597	서울특별시 노원구 동일로 1426-3	2026-01-29 23:28:26.24997	37.65595916	127.0603291	OFFICIAL	2026-01-29 23:28:26.249975	0	\N
2598	서울특별시 노원구 동일로 1449	2026-01-29 23:28:26.250373	37.65748572	127.0588513	OFFICIAL	2026-01-29 23:28:26.250377	0	\N
2599	서울특별시 노원구 화랑로 457	2026-01-29 23:28:26.250774	37.61875199	127.0778767	OFFICIAL	2026-01-29 23:28:26.250778	0	\N
2600	서울특별시 노원구 동일로 1038	2026-01-29 23:28:26.251192	37.62279121	127.07424	OFFICIAL	2026-01-29 23:28:26.251196	0	\N
2601	서울특별시 노원구 동일로 1082	2026-01-29 23:28:26.251583	37.64100553	127.0721484	OFFICIAL	2026-01-29 23:28:26.251587	0	\N
2602	서울특별시 노원구 동일로 1101	2026-01-29 23:28:26.251954	37.62825426	127.0710099	OFFICIAL	2026-01-29 23:28:26.251958	0	\N
2603	서울특별시 노원구 동일로 1104	2026-01-29 23:28:26.252327	37.62849889	127.0718707	OFFICIAL	2026-01-29 23:28:26.25233	0	\N
2604	서울특별시 노원구 한글비석로 57	2026-01-29 23:28:26.252697	37.63662358	127.0689153	OFFICIAL	2026-01-29 23:28:26.2527	0	\N
2605	서울특별시 노원구 섬밭로 210-2	2026-01-29 23:28:26.253189	37.63488722	127.0662096	OFFICIAL	2026-01-29 23:28:26.253193	0	\N
2606	서울특별시 노원구 공릉로59길 28	2026-01-29 23:28:26.253561	37.6342349	127.0696715	OFFICIAL	2026-01-29 23:28:26.253565	0	\N
2607	서울특별시 노원구 섬밭로 232	2026-01-29 23:28:26.253947	37.63661517	127.0656682	OFFICIAL	2026-01-29 23:28:26.253951	0	\N
2608	서울특별시 노원구 동일로 1231-2	2026-01-29 23:28:26.254315	37.63914793	127.0666156	OFFICIAL	2026-01-29 23:28:26.254319	0	\N
2609	서울특별시 노원구 동일로 1231-2	2026-01-29 23:28:26.25469	37.63914793	127.0666156	OFFICIAL	2026-01-29 23:28:26.254693	0	\N
2610	서울특별시 노원구 동일로 1231-2	2026-01-29 23:28:26.25507	37.63914793	127.0666156	OFFICIAL	2026-01-29 23:28:26.255074	0	\N
2611	서울특별시 노원구 동일로 1231-2	2026-01-29 23:28:26.255431	37.63914793	127.0666156	OFFICIAL	2026-01-29 23:28:26.255434	0	\N
2612	서울특별시 노원구 덕릉로 483	2026-01-29 23:28:26.255814	37.64560941	127.0627148	OFFICIAL	2026-01-29 23:28:26.255818	0	\N
2613	서울특별시 노원구 월계로 378	2026-01-29 23:28:26.256175	37.63145003	127.0615911	OFFICIAL	2026-01-29 23:28:26.256179	0	\N
2614	서울특별시 노원구 초안산로1길 15	2026-01-29 23:28:26.256533	37.62729655	127.053318	OFFICIAL	2026-01-29 23:28:26.256537	0	\N
2615	서울특별시 노원구 초안산로1길 15	2026-01-29 23:28:26.256929	37.62729655	127.053318	OFFICIAL	2026-01-29 23:28:26.256933	0	\N
2616	서울특별시 노원구 노원로 564	2026-01-29 23:28:26.257293	37.66165211	127.0561247	OFFICIAL	2026-01-29 23:28:26.257297	0	\N
2617	서울특별시 노원구 동일로227길 26	2026-01-29 23:28:26.257657	37.67019074	127.0546889	OFFICIAL	2026-01-29 23:28:26.257661	0	\N
2618	서울특별시 노원구 동일로 1368	2026-01-29 23:28:26.258014	37.65074309	127.0619264	OFFICIAL	2026-01-29 23:28:26.258018	0	\N
2619	서울특별시 노원구 동일로 1355	2026-01-29 23:28:26.25838	37.64970076	127.0613593	OFFICIAL	2026-01-29 23:28:26.258384	0	\N
2620	서울특별시 노원구 동일로 1328-1	2026-01-29 23:28:26.25874	37.64741034	127.0636403	OFFICIAL	2026-01-29 23:28:26.258744	0	\N
2621	서울특별시 노원구 섬밭로 196	2026-01-29 23:28:26.259173	37.63399762	127.0672779	OFFICIAL	2026-01-29 23:28:26.259177	0	\N
2622	경상남도 합천군 대병면 하금리 704	2026-01-29 23:28:26.259569	35.5316067	127.9914876	OFFICIAL	2026-01-29 23:28:26.259573	0	\N
2623	경상남도 합천군 대병면 성리 127	2026-01-29 23:28:26.25995	35.5296404	128.0688629	OFFICIAL	2026-01-29 23:28:26.259954	0	\N
2624	경상남도 합천군 대병면 성리 1188-2	2026-01-29 23:28:26.260312	35.5232584	128.0511719	OFFICIAL	2026-01-29 23:28:26.260316	0	\N
2625	경상남도 합천군 가회면 덕촌리 1063	2026-01-29 23:28:26.26069	35.4309836	128.0164104	OFFICIAL	2026-01-29 23:28:26.260694	0	\N
2626	경상남도 합천군 가회면 외사리 45-2	2026-01-29 23:28:26.261102	35.4373834	128.0827283	OFFICIAL	2026-01-29 23:28:26.261106	0	\N
2627	경상남도 합천군 가회면 장대리 138	2026-01-29 23:28:26.26149	35.4600174	128.0684069	OFFICIAL	2026-01-29 23:28:26.261493	0	\N
2628	경상남도 합천군 가회면 중촌리 산131	2026-01-29 23:28:26.261939	35.4427931	128.0031728	OFFICIAL	2026-01-29 23:28:26.261966	0	\N
2629	경상남도 합천군 가회면 둔내리 159-3	2026-01-29 23:28:26.262655	35.4840656	128.0234744	OFFICIAL	2026-01-29 23:28:26.262661	0	\N
2630	경상남도 합천군 가회면 오도리 77-13	2026-01-29 23:28:26.263175	35.4467922	128.0270656	OFFICIAL	2026-01-29 23:28:26.263179	0	\N
2631	경상남도 합천군 가회면 함방리 339	2026-01-29 23:28:26.263549	35.4279514	128.0335679	OFFICIAL	2026-01-29 23:28:26.263553	0	\N
2632	경상남도 합천군 가회면 외사리 609-3	2026-01-29 23:28:26.263946	35.4259144	128.0737963	OFFICIAL	2026-01-29 23:28:26.26395	0	\N
2633	경상남도 합천군 가회면 월계리 504-4	2026-01-29 23:28:26.264309	35.4848477	128.0568122	OFFICIAL	2026-01-29 23:28:26.264313	0	\N
2634	경상남도 합천군 가회면 둔내리 761-3	2026-01-29 23:28:26.264661	35.4713937	128.0120221	OFFICIAL	2026-01-29 23:28:26.264664	0	\N
2635	경상남도 합천군 삼가면 문송리 496-6	2026-01-29 23:28:26.265074	35.4254745	128.0968232	OFFICIAL	2026-01-29 23:28:26.265078	0	\N
2636	경상남도 합천군 삼가면 덕진리 167	2026-01-29 23:28:26.265436	35.4108511	128.0886139	OFFICIAL	2026-01-29 23:28:26.265439	0	\N
2637	경상남도 합천군 삼가면 외토리 610-20	2026-01-29 23:28:26.265824	35.3864566	128.1031168	OFFICIAL	2026-01-29 23:28:26.265828	0	\N
2638	경상남도 합천군 삼가면 소오리 176-3	2026-01-29 23:28:26.266194	35.4067591	128.1194705	OFFICIAL	2026-01-29 23:28:26.266197	0	\N
2639	경상남도 합천군 삼가면 소오리 517-2	2026-01-29 23:28:26.266561	35.4099565	128.1128249	OFFICIAL	2026-01-29 23:28:26.266565	0	\N
2640	경상남도 합천군 삼가면 동리 269	2026-01-29 23:28:26.266946	35.4182886	128.1437571	OFFICIAL	2026-01-29 23:28:26.26695	0	\N
2641	경상남도 합천군 삼가면 동리 575-1	2026-01-29 23:28:26.267306	35.4164918	128.1535761	OFFICIAL	2026-01-29 23:28:26.26731	0	\N
2642	경상남도 합천군 삼가면 용흥리 889-1	2026-01-29 23:28:26.267689	35.3960838	128.1308377	OFFICIAL	2026-01-29 23:28:26.267693	0	\N
2643	경상남도 합천군 쌍백면 안계2길 2	2026-01-29 23:28:26.268054	35.4359947	128.1819191	OFFICIAL	2026-01-29 23:28:26.268058	0	\N
2644	경상남도 합천군 쌍백면 외초리 394	2026-01-29 23:28:26.268539	35.4193878	128.1653311	OFFICIAL	2026-01-29 23:28:26.268556	0	\N
2645	경상남도 합천군 쌍백면 삼리 251-1	2026-01-29 23:28:26.269002	35.4676312	128.0986697	OFFICIAL	2026-01-29 23:28:26.269006	0	\N
2646	경상남도 합천군 쌍백면 평구리 887-1	2026-01-29 23:28:26.269377	35.4411999	128.1379711	OFFICIAL	2026-01-29 23:28:26.26938	0	\N
2647	경상남도 합천군 쌍백면 평구리 312	2026-01-29 23:28:26.269737	35.4402935	128.1497441	OFFICIAL	2026-01-29 23:28:26.269741	0	\N
2648	경상남도 합천군 쌍백면 평구리 629-1	2026-01-29 23:28:26.270125	35.4356237	128.1427967	OFFICIAL	2026-01-29 23:28:26.270129	0	\N
2649	경상남도 합천군 쌍백면 대곡리 577-1	2026-01-29 23:28:26.270521	35.4687129	128.1893531	OFFICIAL	2026-01-29 23:28:26.270524	0	\N
2650	경상남도 합천군 쌍백면 외초리 123	2026-01-29 23:28:26.270934	35.4110224	128.1720415	OFFICIAL	2026-01-29 23:28:26.270938	0	\N
2651	경상남도 합천군 쌍백면 죽전리 736-3	2026-01-29 23:28:26.271284	35.4585131	128.1146334	OFFICIAL	2026-01-29 23:28:26.271288	0	\N
2652	경상남도 합천군 쌍백면 대현리 515-1	2026-01-29 23:28:26.271632	35.4459721	128.1941906	OFFICIAL	2026-01-29 23:28:26.271636	0	\N
2653	경상남도 합천군 쌍백면 육리 1291-1	2026-01-29 23:28:26.271996	35.4539401	128.1640247	OFFICIAL	2026-01-29 23:28:26.272	0	\N
2654	경상남도 합천군 쌍백면 하신리 972	2026-01-29 23:28:26.272377	35.4545748	128.1395142	OFFICIAL	2026-01-29 23:28:26.272381	0	\N
2655	대구광역시 북구 옥산로 70 대구광역시 북구 고성동3가 46	2026-01-29 23:28:26.272768	35.88443602	128.5826788	OFFICIAL	2026-01-29 23:28:26.272772	0	\N
2656	경상남도 합천군 가야면 야천리 717	2026-01-29 23:28:26.273126	35.7694726	128.1359809	OFFICIAL	2026-01-29 23:28:26.27313	0	\N
2657	경상남도 합천군 가야면 대전리 727-1	2026-01-29 23:28:26.27348	35.7408249	128.0785634	OFFICIAL	2026-01-29 23:28:26.273484	0	\N
2658	경상남도 합천군 가야면 매화리 716-5	2026-01-29 23:28:26.273851	35.7413236	128.1188295	OFFICIAL	2026-01-29 23:28:26.27388	0	\N
2659	경상남도 합천군 가야면 성기리 660-7	2026-01-29 23:28:26.274233	35.7213735	128.1027065	OFFICIAL	2026-01-29 23:28:26.274237	0	\N
2660	경상남도 합천군 가야면 사촌리 50-5	2026-01-29 23:28:26.274578	35.7542329	128.1341083	OFFICIAL	2026-01-29 23:28:26.274582	0	\N
2661	경상남도 합천군 가야면 구원리 242-5	2026-01-29 23:28:26.274969	35.7822292	128.1253061	OFFICIAL	2026-01-29 23:28:26.274973	0	\N
2662	경상남도 합천군 가야면 매안리 566-8	2026-01-29 23:28:26.27532	35.7308371	128.1034151	OFFICIAL	2026-01-29 23:28:26.275323	0	\N
2663	경상남도 합천군 가야면 매안리 432	2026-01-29 23:28:26.275673	35.7306414	128.1105892	OFFICIAL	2026-01-29 23:28:26.275677	0	\N
2664	경상남도 합천군 묘산면 도옥리 156-2	2026-01-29 23:28:26.276016	35.6627489	128.1222695	OFFICIAL	2026-01-29 23:28:26.276019	0	\N
2665	경상남도 합천군 묘산면 안성리 204-4	2026-01-29 23:28:26.276364	35.6741823	128.1352668	OFFICIAL	2026-01-29 23:28:26.276368	0	\N
2666	경상남도 합천군 봉산면 상현리 396	2026-01-29 23:28:26.276713	35.6408308	128.0342641	OFFICIAL	2026-01-29 23:28:26.276716	0	\N
2667	경상남도 합천군 봉산면 권빈리 958-8	2026-01-29 23:28:26.277088	35.6343195	128.0645361	OFFICIAL	2026-01-29 23:28:26.27709	0	\N
2668	경상남도 합천군 봉산면 권빈리 347-2	2026-01-29 23:28:26.277442	35.6195243	128.0712361	OFFICIAL	2026-01-29 23:28:26.277446	0	\N
2669	경상남도 합천군 봉산면 압곡리 721	2026-01-29 23:28:26.277813	35.6385721	128.0496663	OFFICIAL	2026-01-29 23:28:26.277816	0	\N
2670	경상남도 합천군 봉산면 권빈리 1515-2	2026-01-29 23:28:26.278159	35.6354552	128.0646475	OFFICIAL	2026-01-29 23:28:26.278162	0	\N
2671	경상남도 합천군 봉산면 양지리 511	2026-01-29 23:28:26.278507	35.5945863	128.0046024	OFFICIAL	2026-01-29 23:28:26.27851	0	\N
2672	경상남도 합천군 봉산면 봉계리 849	2026-01-29 23:28:26.278873	35.6106827	128.0230367	OFFICIAL	2026-01-29 23:28:26.278876	0	\N
2673	경상남도 합천군 봉산면 노곡리 908	2026-01-29 23:28:26.279214	35.5891959	127.9932802	OFFICIAL	2026-01-29 23:28:26.279218	0	\N
2674	경상남도 합천군 합천읍 인곡리 64-8	2026-01-29 23:28:26.279571	35.6071311	128.1070746	OFFICIAL	2026-01-29 23:28:26.279575	0	\N
2675	경상남도 합천군 용주면 성산리 산84	2026-01-29 23:28:26.279933	35.5514718	128.1413032	OFFICIAL	2026-01-29 23:28:26.279937	0	\N
2676	경상남도 합천군 용주면 고품리 179	2026-01-29 23:28:26.280281	35.5551054	128.1148921	OFFICIAL	2026-01-29 23:28:26.280285	0	\N
2677	경상남도 합천군 용주면 가호리 394	2026-01-29 23:28:26.280628	35.5503536	128.0698733	OFFICIAL	2026-01-29 23:28:26.280631	0	\N
2678	경상남도 합천군 용주면 황계폭포로 1061-12	2026-01-29 23:28:26.28098	35.5344976	128.1172005	OFFICIAL	2026-01-29 23:28:26.280984	0	\N
2679	경상남도 합천군 용주면 월평리 693-3	2026-01-29 23:28:26.281339	35.5659011	128.1179081	OFFICIAL	2026-01-29 23:28:26.281343	0	\N
2680	경상남도 합천군 용주면 공암리 171	2026-01-29 23:28:26.281686	35.5058099	128.1037211	OFFICIAL	2026-01-29 23:28:26.28169	0	\N
2681	경상남도 합천군 용주면 방곡리 826-1	2026-01-29 23:28:26.282044	35.5731171	128.1025169	OFFICIAL	2026-01-29 23:28:26.282047	0	\N
2682	경상남도 합천군 대병면 상천리 515-2	2026-01-29 23:28:26.28239	35.5440701	128.0272526	OFFICIAL	2026-01-29 23:28:26.282394	0	\N
2683	경상남도 합천군 대병면 회양리 337-1	2026-01-29 23:28:26.28279	35.5189139	128.0200666	OFFICIAL	2026-01-29 23:28:26.282794	0	\N
2684	경상남도 합천군 대병면 유전리 920-2	2026-01-29 23:28:26.28314	35.5396647	127.9874063	OFFICIAL	2026-01-29 23:28:26.283144	0	\N
2685	경상남도 합천군 대병면 성리 480	2026-01-29 23:28:26.283488	35.5448103	128.0514062	OFFICIAL	2026-01-29 23:28:26.283491	0	\N
2686	경상남도 합천군 대병면 장단리 1214	2026-01-29 23:28:26.283843	35.5092501	128.0531473	OFFICIAL	2026-01-29 23:28:26.283847	0	\N
2687	대구광역시 북구 고성로 191 대구광역시 북구 고성동3가 2	2026-01-29 23:28:26.284197	35.88301935	128.5861543	OFFICIAL	2026-01-29 23:28:26.284202	0	\N
2688	경상남도 합천군 청덕면 초곡길 151-1	2026-01-29 23:28:26.284596	35.5160212	128.3398438	OFFICIAL	2026-01-29 23:28:26.2846	0	\N
2689	경상남도 합천군 청덕면 운봉리 191-1	2026-01-29 23:28:26.284961	35.6111565	128.3080481	OFFICIAL	2026-01-29 23:28:26.284965	0	\N
2690	경상남도 합천군 청덕면 운봉리 913	2026-01-29 23:28:26.285312	35.6150238	128.3007334	OFFICIAL	2026-01-29 23:28:26.285316	0	\N
2691	경상남도 합천군 청덕면 소례리 1075-5	2026-01-29 23:28:26.285659	35.5982595	128.3345075	OFFICIAL	2026-01-29 23:28:26.285663	0	\N
2692	경상남도 합천군 청덕면 가현리 948-4	2026-01-29 23:28:26.286002	35.5609424	128.3213688	OFFICIAL	2026-01-29 23:28:26.286007	0	\N
2693	경상남도 합천군 청덕면 삼학리 600	2026-01-29 23:28:26.28636	35.5887465	128.3389812	OFFICIAL	2026-01-29 23:28:26.286364	0	\N
2694	경상남도 합천군 청덕면 적포리 591	2026-01-29 23:28:26.28671	35.5664288	128.3515075	OFFICIAL	2026-01-29 23:28:26.286714	0	\N
2695	경상남도 합천군 청덕면 대부리 584-2	2026-01-29 23:28:26.287078	35.5477091	128.3414775	OFFICIAL	2026-01-29 23:28:26.287081	0	\N
2696	경상남도 합천군 청덕면 두곡리 515-7	2026-01-29 23:28:26.287424	35.5564801	128.3147328	OFFICIAL	2026-01-29 23:28:26.287427	0	\N
2697	경상남도 합천군 청덕면 초곡리 833-3	2026-01-29 23:28:26.287794	35.5131481	128.3358188	OFFICIAL	2026-01-29 23:28:26.287798	0	\N
2698	경상남도 합천군 청덕면 앙진리 42-8	2026-01-29 23:28:26.288143	35.5059079	128.3703914	OFFICIAL	2026-01-29 23:28:26.288146	0	\N
2699	경상남도 합천군 덕곡면 포두리 13-25	2026-01-29 23:28:26.288489	35.6403539	128.3532222	OFFICIAL	2026-01-29 23:28:26.288493	0	\N
2700	경상남도 합천군 덕곡면 율원리 562	2026-01-29 23:28:26.288858	35.6385662	128.2902215	OFFICIAL	2026-01-29 23:28:26.288862	0	\N
2701	경상남도 합천군 덕곡면 율지리 314-1	2026-01-29 23:28:26.289214	35.6135357	128.3540977	OFFICIAL	2026-01-29 23:28:26.289218	0	\N
2702	경상남도 합천군 쌍책면 오서리 14-6	2026-01-29 23:28:26.289562	35.5754616	128.2747241	OFFICIAL	2026-01-29 23:28:26.289566	0	\N
2703	경상남도 합천군 쌍책면 하신리 278-3	2026-01-29 23:28:26.289927	35.6236036	128.2499611	OFFICIAL	2026-01-29 23:28:26.28993	0	\N
2704	경상남도 합천군 쌍책면 덕봉리 575	2026-01-29 23:28:26.290292	35.5998065	128.2791555	OFFICIAL	2026-01-29 23:28:26.290296	0	\N
2705	경상남도 합천군 쌍책면 다라리 826-25	2026-01-29 23:28:26.290646	35.5873511	128.2862296	OFFICIAL	2026-01-29 23:28:26.29065	0	\N
2706	경상남도 합천군 쌍책면 사양리 407-2	2026-01-29 23:28:26.290995	35.6251061	128.2721116	OFFICIAL	2026-01-29 23:28:26.290999	0	\N
2707	경상남도 합천군 쌍책면 하신리 294-2	2026-01-29 23:28:26.291348	35.6283401	128.2522059	OFFICIAL	2026-01-29 23:28:26.291351	0	\N
2708	경상남도 합천군 쌍책면 다라리 536-1	2026-01-29 23:28:26.291699	35.5808822	128.2924628	OFFICIAL	2026-01-29 23:28:26.291706	0	\N
2709	경상남도 합천군 쌍책면 상신리 산241-1	2026-01-29 23:28:26.29207	35.6361694	128.2623223	OFFICIAL	2026-01-29 23:28:26.292073	0	\N
2710	경상남도 합천군 쌍책면 성산리 252	2026-01-29 23:28:26.292429	35.5797672	128.2876149	OFFICIAL	2026-01-29 23:28:26.292433	0	\N
2711	경상남도 합천군 쌍책면 상포리 448	2026-01-29 23:28:26.2928	35.5827021	128.2736784	OFFICIAL	2026-01-29 23:28:26.292803	0	\N
2712	경상남도 합천군 쌍책면 상신리 526	2026-01-29 23:28:26.293161	35.6367168	128.2507747	OFFICIAL	2026-01-29 23:28:26.293165	0	\N
2713	경상남도 합천군 쌍책면 건태리 1043	2026-01-29 23:28:26.293514	35.6011368	128.2648126	OFFICIAL	2026-01-29 23:28:26.293517	0	\N
2714	경상남도 합천군 쌍책면 오서리 723	2026-01-29 23:28:26.293902	35.5711881	128.2752279	OFFICIAL	2026-01-29 23:28:26.293906	0	\N
2715	경상남도 합천군 쌍책면 상포리 411-5	2026-01-29 23:28:26.294275	35.5840098	128.2693464	OFFICIAL	2026-01-29 23:28:26.294279	0	\N
2716	경상남도 합천군 쌍책면 건태리 산69-5	2026-01-29 23:28:26.294633	35.6061554	128.2488582	OFFICIAL	2026-01-29 23:28:26.294637	0	\N
2717	경상남도 합천군 초계면 대평리 161-1	2026-01-29 23:28:26.294988	35.5468275	128.2529431	OFFICIAL	2026-01-29 23:28:26.294992	0	\N
2718	경상남도 합천군 초계면 중리 380-21	2026-01-29 23:28:26.295346	35.5590822	128.2505437	OFFICIAL	2026-01-29 23:28:26.29535	0	\N
2719	경상남도 합천군 초계면 원당리 416-1	2026-01-29 23:28:26.295701	35.5381834	128.2396493	OFFICIAL	2026-01-29 23:28:26.295704	0	\N
2720	경상남도 합천군 초계면 택리 598-4	2026-01-29 23:28:26.296098	35.5474392	128.2403055	OFFICIAL	2026-01-29 23:28:26.296102	0	\N
2721	대구광역시 북구 원대로 118 대구광역시 북구 침산동 402-1	2026-01-29 23:28:26.296458	35.88788184	128.5834556	OFFICIAL	2026-01-29 23:28:26.296462	0	\N
2722	경상남도 합천군 쌍백면 안계리 908-3	2026-01-29 23:28:26.296834	35.4422616	128.1863612	OFFICIAL	2026-01-29 23:28:26.296837	0	\N
2723	경상남도 합천군 쌍백면 외초리 1062-2	2026-01-29 23:28:26.297188	35.4123892	128.1680035	OFFICIAL	2026-01-29 23:28:26.297192	0	\N
2724	경상남도 합천군 쌍백면 육리 1248	2026-01-29 23:28:26.297535	35.4649726	128.1831963	OFFICIAL	2026-01-29 23:28:26.297539	0	\N
2725	경상남도 합천군 쌍백면 평지리 446	2026-01-29 23:28:26.297907	35.4391394	128.1703941	OFFICIAL	2026-01-29 23:28:26.297911	0	\N
2726	경상남도 합천군 대양면 도리 337-10	2026-01-29 23:28:26.29826	35.5011227	128.1542771	OFFICIAL	2026-01-29 23:28:26.298264	0	\N
2727	경상남도 합천군 대양면 대목리 558	2026-01-29 23:28:26.298608	35.5215585	128.1667752	OFFICIAL	2026-01-29 23:28:26.298612	0	\N
2728	경상남도 합천군 대양면 무곡리 389	2026-01-29 23:28:26.298949	35.5251456	128.1969172	OFFICIAL	2026-01-29 23:28:26.298952	0	\N
2729	경상남도 합천군 대양면 양산리 923-7	2026-01-29 23:28:26.299316	35.5085524	128.1787203	OFFICIAL	2026-01-29 23:28:26.29932	0	\N
2730	경상남도 합천군 대양면 무곡리 984	2026-01-29 23:28:26.299671	35.5213401	128.1866761	OFFICIAL	2026-01-29 23:28:26.299674	0	\N
2731	경상남도 합천군 대양면 백암리 367	2026-01-29 23:28:26.300999	35.4969628	128.2209542	OFFICIAL	2026-01-29 23:28:26.301003	0	\N
2732	경상남도 합천군 대양면 안금리 576-2	2026-01-29 23:28:26.301402	35.4959148	128.1848427	OFFICIAL	2026-01-29 23:28:26.301405	0	\N
2733	경상남도 합천군 대양면 오산리 307	2026-01-29 23:28:26.30178	35.4992874	128.2310794	OFFICIAL	2026-01-29 23:28:26.301784	0	\N
2734	경상남도 합천군 대양면 덕정리 925-18	2026-01-29 23:28:26.302138	35.5154903	128.1744911	OFFICIAL	2026-01-29 23:28:26.302142	0	\N
2735	경상남도 합천군 적중면 정토리 206-1	2026-01-29 23:28:26.302493	35.5296748	128.2569581	OFFICIAL	2026-01-29 23:28:26.302496	0	\N
2736	경상남도 합천군 적중면 옥두리 612-3	2026-01-29 23:28:26.302859	35.5502596	128.2899471	OFFICIAL	2026-01-29 23:28:26.302863	0	\N
2737	경상남도 합천군 적중면 황정리 290	2026-01-29 23:28:26.303206	35.5391096	128.2861684	OFFICIAL	2026-01-29 23:28:26.30321	0	\N
2738	경상남도 합천군 적중면 황정리 493	2026-01-29 23:28:26.303557	35.5369988	128.2830071	OFFICIAL	2026-01-29 23:28:26.303561	0	\N
2739	경상남도 합천군 적중면 죽고리 287-2	2026-01-29 23:28:26.303926	35.5705284	128.3022329	OFFICIAL	2026-01-29 23:28:26.30393	0	\N
2740	경상남도 합천군 적중면 두방리 357	2026-01-29 23:28:26.304288	35.5385442	128.2926178	OFFICIAL	2026-01-29 23:28:26.304292	0	\N
2741	경상남도 합천군 적중면 누하리 554-1	2026-01-29 23:28:26.304689	35.5297239	128.2675219	OFFICIAL	2026-01-29 23:28:26.304693	0	\N
2742	경상남도 합천군 적중면 양림리 887-14	2026-01-29 23:28:26.305049	35.5345637	128.2637114	OFFICIAL	2026-01-29 23:28:26.305053	0	\N
2743	경상남도 합천군 적중면 누하리 26-1	2026-01-29 23:28:26.305389	35.5313153	128.2733605	OFFICIAL	2026-01-29 23:28:26.305393	0	\N
2744	경상남도 합천군 청덕면 삼학리 45-1	2026-01-29 23:28:26.305786	35.5782241	128.3558179	OFFICIAL	2026-01-29 23:28:26.30579	0	\N
2745	경상남도 합천군 청덕면 미곡리 산56-2	2026-01-29 23:28:26.306138	35.5754567	128.3305622	OFFICIAL	2026-01-29 23:28:26.306141	0	\N
2746	경상남도 합천군 청덕면 대부리 1525	2026-01-29 23:28:26.306486	35.5353218	128.3422741	OFFICIAL	2026-01-29 23:28:26.306489	0	\N
2747	경상남도 합천군 청덕면 소례리 870-2	2026-01-29 23:28:26.306838	35.6046309	128.3148771	OFFICIAL	2026-01-29 23:28:26.306842	0	\N
2748	경상남도 합천군 청덕면 적포리 757-1	2026-01-29 23:28:26.307194	35.5564858	128.3486955	OFFICIAL	2026-01-29 23:28:26.307197	0	\N
2749	경상남도 합천군 청덕면 성태리 1023-5	2026-01-29 23:28:26.307541	35.5774253	128.3157525	OFFICIAL	2026-01-29 23:28:26.307545	0	\N
2750	경상남도 합천군 청덕면 앙진리 1111-4	2026-01-29 23:28:26.307911	35.5198603	128.3587906	OFFICIAL	2026-01-29 23:28:26.307914	0	\N
2751	경상남도 합천군 청덕면 가현리 498-30	2026-01-29 23:28:26.308257	35.5672396	128.3293149	OFFICIAL	2026-01-29 23:28:26.30826	0	\N
2752	경상남도 합천군 청덕면 두곡리 311-6	2026-01-29 23:28:26.308608	35.5540395	128.3173263	OFFICIAL	2026-01-29 23:28:26.308611	0	\N
2753	서울특별시 노원구 화랑로 815	2026-01-29 23:28:26.308956	37.64335737	127.1088503	OFFICIAL	2026-01-29 23:28:26.308959	0	\N
2754	서울특별시 노원구 화랑로 815	2026-01-29 23:28:26.30931	37.64335737	127.1088503	OFFICIAL	2026-01-29 23:28:26.309313	0	\N
2755	서울특별시 노원구 화랑로 768	2026-01-29 23:28:26.30966	37.63600845	127.1068283	OFFICIAL	2026-01-29 23:28:26.309664	0	\N
2756	서울특별시 노원구 화랑로 653	2026-01-29 23:28:26.310059	37.62961285	127.0950867	OFFICIAL	2026-01-29 23:28:26.310063	0	\N
2757	서울특별시 노원구 화랑로 682	2026-01-29 23:28:26.31041	37.62973006	127.0979586	OFFICIAL	2026-01-29 23:28:26.310414	0	\N
2758	서울특별시 노원구 화랑로 682	2026-01-29 23:28:26.310776	37.62973006	127.0979586	OFFICIAL	2026-01-29 23:28:26.310779	0	\N
2759	서울특별시 노원구 화랑로 653	2026-01-29 23:28:26.311113	37.62961285	127.0950867	OFFICIAL	2026-01-29 23:28:26.311117	0	\N
2760	서울특별시 노원구 화랑로 621	2026-01-29 23:28:26.31146	37.62878266	127.0889915	OFFICIAL	2026-01-29 23:28:26.311464	0	\N
2761	서울특별시 노원구 화랑로 621	2026-01-29 23:28:26.311833	37.62878266	127.0889915	OFFICIAL	2026-01-29 23:28:26.311836	0	\N
2762	서울특별시 노원구 화랑로 556	2026-01-29 23:28:26.312196	37.62128774	127.0877533	OFFICIAL	2026-01-29 23:28:26.3122	0	\N
2763	서울특별시 노원구 화랑로51길 17	2026-01-29 23:28:26.312544	37.62307787	127.0893658	OFFICIAL	2026-01-29 23:28:26.312547	0	\N
2764	서울특별시 노원구 섬밭로 17	2026-01-29 23:28:26.312919	37.61843007	127.0723471	OFFICIAL	2026-01-29 23:28:26.312924	0	\N
2765	서울특별시 노원구 동일로183길 34	2026-01-29 23:28:26.31335	37.62328229	127.0713893	OFFICIAL	2026-01-29 23:28:26.313354	0	\N
2766	서울특별시 노원구 동일로191가길 37	2026-01-29 23:28:26.313711	37.62672338	127.0707244	OFFICIAL	2026-01-29 23:28:26.313714	0	\N
2767	서울특별시 노원구 동일로197길 24	2026-01-29 23:28:26.314114	37.62879899	127.0698009	OFFICIAL	2026-01-29 23:28:26.314118	0	\N
2768	서울특별시 노원구 동일로191가길 59	2026-01-29 23:28:26.314476	37.62766279	127.0696059	OFFICIAL	2026-01-29 23:28:26.314479	0	\N
2769	서울특별시 노원구 공릉로 130	2026-01-29 23:28:26.314823	37.62162319	127.0793373	OFFICIAL	2026-01-29 23:28:26.314827	0	\N
2770	서울특별시 노원구 공릉로 232	2026-01-29 23:28:26.315169	37.63307893	127.0767947	OFFICIAL	2026-01-29 23:28:26.315172	0	\N
2771	서울특별시 노원구 노원로1가길 10	2026-01-29 23:28:26.315514	37.62365045	127.0859584	OFFICIAL	2026-01-29 23:28:26.315517	0	\N
2772	서울특별시 노원구 노원로 240	2026-01-29 23:28:26.315887	37.63937196	127.0745259	OFFICIAL	2026-01-29 23:28:26.315891	0	\N
2773	서울특별시 노원구 마들로 111	2026-01-29 23:28:26.316232	37.62383436	127.0647781	OFFICIAL	2026-01-29 23:28:26.316235	0	\N
2774	서울특별시 노원구 마들로 127	2026-01-29 23:28:26.316571	37.62678626	127.0652715	OFFICIAL	2026-01-29 23:28:26.316574	0	\N
2775	서울특별시 노원구 광운로 21	2026-01-29 23:28:26.316943	37.61982653	127.0575899	OFFICIAL	2026-01-29 23:28:26.316947	0	\N
2776	서울특별시 노원구 월계로49길 5	2026-01-29 23:28:26.317291	37.62931332	127.0562219	OFFICIAL	2026-01-29 23:28:26.317294	0	\N
2777	서울특별시 노원구 섬밭로 201	2026-01-29 23:28:26.317635	37.63328542	127.0655211	OFFICIAL	2026-01-29 23:28:26.317639	0	\N
2778	서울특별시 노원구 한글비석로 98	2026-01-29 23:28:26.317983	37.6375355	127.0727752	OFFICIAL	2026-01-29 23:28:26.317987	0	\N
2779	서울특별시 노원구 공릉로62길 41	2026-01-29 23:28:26.318331	37.63747448	127.071637	OFFICIAL	2026-01-29 23:28:26.318335	0	\N
2780	서울특별시 노원구 공릉로58길 176	2026-01-29 23:28:26.318674	37.63769871	127.0769631	OFFICIAL	2026-01-29 23:28:26.318678	0	\N
2781	서울특별시 노원구 한글비석로 151	2026-01-29 23:28:26.319028	37.64133774	127.0756469	OFFICIAL	2026-01-29 23:28:26.319032	0	\N
2782	서울특별시 노원구 노원로16길 15	2026-01-29 23:28:26.319393	37.64344507	127.0733372	OFFICIAL	2026-01-29 23:28:26.319397	0	\N
2783	서울특별시 노원구 노원로18길 41	2026-01-29 23:28:26.319743	37.64451236	127.0729257	OFFICIAL	2026-01-29 23:28:26.319767	0	\N
2784	서울특별시 노원구 한글비석로1길 81-11	2026-01-29 23:28:26.320119	37.64100553	127.0690818	OFFICIAL	2026-01-29 23:28:26.320123	0	\N
2785	서울특별시 노원구 동일로 1238	2026-01-29 23:28:26.320471	37.64066045	127.0668656	OFFICIAL	2026-01-29 23:28:26.320475	0	\N
2786	서울특별시 노원구 중계로 120	2026-01-29 23:28:26.320833	37.64633482	127.0817898	OFFICIAL	2026-01-29 23:28:26.320837	0	\N
2787	서울특별시 노원구 중계로12길 24	2026-01-29 23:28:26.321187	37.6468185	127.0818703	OFFICIAL	2026-01-29 23:28:26.32119	0	\N
2788	서울특별시 노원구 노원로22길 1	2026-01-29 23:28:26.321542	37.64815756	127.0706995	OFFICIAL	2026-01-29 23:28:26.321546	0	\N
2789	서울특별시 노원구 노원로 330	2026-01-29 23:28:26.321934	37.64679053	127.0709409	OFFICIAL	2026-01-29 23:28:26.321938	0	\N
2790	서울특별시 노원구 중계로 167	2026-01-29 23:28:26.322292	37.65005409	127.0807307	OFFICIAL	2026-01-29 23:28:26.322296	0	\N
2791	서울특별시 노원구 중계로 230	2026-01-29 23:28:26.322638	37.65101324	127.0750479	OFFICIAL	2026-01-29 23:28:26.322642	0	\N
2792	서울특별시 노원구 공릉로 431	2026-01-29 23:28:26.322977	37.64503406	127.0661389	OFFICIAL	2026-01-29 23:28:26.322997	0	\N
2793	서울특별시 노원구 노원로15길 51-10	2026-01-29 23:28:26.323395	37.63973051	127.0700338	OFFICIAL	2026-01-29 23:28:26.323399	0	\N
2794	서울특별시 노원구 노원로 331	2026-01-29 23:28:26.323773	37.64617746	127.06966	OFFICIAL	2026-01-29 23:28:26.323777	0	\N
2795	서울특별시 노원구 덕릉로 541	2026-01-29 23:28:26.324117	37.64872348	127.0669678	OFFICIAL	2026-01-29 23:28:26.324121	0	\N
2796	서울특별시 노원구 덕릉로76길 18	2026-01-29 23:28:26.324461	37.65431092	127.0749142	OFFICIAL	2026-01-29 23:28:26.324464	0	\N
2797	서울특별시 노원구 중계로 230	2026-01-29 23:28:26.324902	37.65101324	127.0750479	OFFICIAL	2026-01-29 23:28:26.324917	0	\N
2798	서울특별시 노원구 덕릉로 872	2026-01-29 23:28:26.325257	37.67350344	127.0843883	OFFICIAL	2026-01-29 23:28:26.325261	0	\N
2799	서울특별시 노원구 덕릉로 753	2026-01-29 23:28:26.325621	37.66507422	127.0775817	OFFICIAL	2026-01-29 23:28:26.325623	0	\N
2800	서울특별시 노원구 덕릉로 753	2026-01-29 23:28:26.325977	37.66507422	127.0775817	OFFICIAL	2026-01-29 23:28:26.325982	0	\N
2801	서울특별시 노원구 공릉로 351	2026-01-29 23:28:26.326341	37.63815992	127.0680314	OFFICIAL	2026-01-29 23:28:26.326344	0	\N
2802	서울특별시 노원구 동일로204가길 12	2026-01-29 23:28:26.326683	37.63985808	127.068668	OFFICIAL	2026-01-29 23:28:26.326687	0	\N
2803	서울특별시 노원구 섬밭로 265	2026-01-29 23:28:26.327019	37.63828612	127.0627122	OFFICIAL	2026-01-29 23:28:26.327033	0	\N
2804	서울특별시 노원구 동일로216길 92	2026-01-29 23:28:26.327375	37.65052082	127.0673497	OFFICIAL	2026-01-29 23:28:26.327379	0	\N
2805	서울특별시 노원구 노원로 428	2026-01-29 23:28:26.327732	37.65452808	127.0683534	OFFICIAL	2026-01-29 23:28:26.327736	0	\N
2806	서울특별시 노원구 노해로 508	2026-01-29 23:28:26.328101	37.65470356	127.066191	OFFICIAL	2026-01-29 23:28:26.328105	0	\N
2807	서울특별시 노원구 노해로 502	2026-01-29 23:28:26.328449	37.65445005	127.0636923	OFFICIAL	2026-01-29 23:28:26.328453	0	\N
2808	서울특별시 노원구 노원로38길 76	2026-01-29 23:28:26.32882	37.66385315	127.061985	OFFICIAL	2026-01-29 23:28:26.328823	0	\N
2809	서울특별시 노원구 노원로 532	2026-01-29 23:28:26.329205	37.66461677	127.0598168	OFFICIAL	2026-01-29 23:28:26.329209	0	\N
2810	서울특별시 노원구 동일로215길 23	2026-01-29 23:28:26.329556	37.6504211	127.0590691	OFFICIAL	2026-01-29 23:28:26.329559	0	\N
2811	서울특별시 노원구 동일로215길 81	2026-01-29 23:28:26.329934	37.65022613	127.0568651	OFFICIAL	2026-01-29 23:28:26.329937	0	\N
2812	서울특별시 노원구 동일로 1729	2026-01-29 23:28:26.33029	37.68314469	127.0548083	OFFICIAL	2026-01-29 23:28:26.330294	0	\N
2813	서울특별시 노원구 동일로250길 17	2026-01-29 23:28:26.330634	37.68246227	127.0567709	OFFICIAL	2026-01-29 23:28:26.330637	0	\N
2814	서울특별시 노원구 동일로 1324-2	2026-01-29 23:28:26.330977	37.64700938	127.0633425	OFFICIAL	2026-01-29 23:28:26.330981	0	\N
2815	서울특별시 노원구 노해로 437	2026-01-29 23:28:26.33132	37.65451904	127.0562972	OFFICIAL	2026-01-29 23:28:26.331323	0	\N
2816	서울특별시 노원구 동일로 1378-2	2026-01-29 23:28:26.331719	37.65173576	127.0614564	OFFICIAL	2026-01-29 23:28:26.331764	0	\N
2817	광주광역시 광산구 용봉동 333-24	2026-01-29 23:28:26.332153	35.0808451	126.7664497	OFFICIAL	2026-01-29 23:28:26.332157	0	\N
2818	광주광역시 광산구 용봉동 330-3	2026-01-29 23:28:26.332498	35.08102262	126.7661274	OFFICIAL	2026-01-29 23:28:26.332502	0	\N
2819	광주광역시 광산구 본덕동 506-2	2026-01-29 23:28:26.33288	35.08595053	126.7716261	OFFICIAL	2026-01-29 23:28:26.332884	0	\N
2820	광주광역시 광산구 복룡동 645-9	2026-01-29 23:28:26.333238	35.11782001	126.7807996	OFFICIAL	2026-01-29 23:28:26.333241	0	\N
2821	광주광역시 광산구 동곡로 324	2026-01-29 23:28:26.333583	35.11093722	126.7799549	OFFICIAL	2026-01-29 23:28:26.333586	0	\N
2822	광주광역시 광산구 동곡로 282	2026-01-29 23:28:26.333936	35.10742955	126.7794041	OFFICIAL	2026-01-29 23:28:26.33394	0	\N
2823	광주광역시 광산구 유계동 237-18	2026-01-29 23:28:26.334286	35.10165397	126.7780947	OFFICIAL	2026-01-29 23:28:26.33429	0	\N
2824	광주광역시 광산구 동곡로 170	2026-01-29 23:28:26.33463	35.09782047	126.7756845	OFFICIAL	2026-01-29 23:28:26.334634	0	\N
2825	서울특별시 노원구 동일로 1081	2026-01-29 23:28:26.334976	37.62637728	127.0722704	OFFICIAL	2026-01-29 23:28:26.33498	0	\N
2826	서울특별시 노원구 동일로 1041	2026-01-29 23:28:26.335327	37.62310296	127.0735029	OFFICIAL	2026-01-29 23:28:26.335331	0	\N
2827	서울특별시 노원구 동일로173길 12	2026-01-29 23:28:26.335673	37.61861443	127.0746314	OFFICIAL	2026-01-29 23:28:26.335677	0	\N
2828	서울특별시 노원구 동일로 996	2026-01-29 23:28:26.336007	37.61919557	127.0754877	OFFICIAL	2026-01-29 23:28:26.33601	0	\N
2829	서울특별시 노원구 동일로 192길 20	2026-01-29 23:28:26.336379	37.62590104	127.0742578	OFFICIAL	2026-01-29 23:28:26.336382	0	\N
2830	서울특별시 노원구 화랑로 421	2026-01-29 23:28:26.33673	37.61752173	127.0743315	OFFICIAL	2026-01-29 23:28:26.336734	0	\N
2831	서울특별시 구로구 서해안로 2311 서울특별시 구로구 오류동 85-12	2026-01-29 23:28:26.337089	37.49255807	126.8413421	OFFICIAL	2026-01-29 23:28:26.337092	0	\N
2832	서울특별시 구로구 개봉동 199-4	2026-01-29 23:28:26.337425	37.49380798	126.8597648	OFFICIAL	2026-01-29 23:28:26.337429	0	\N
2833	서울특별시 구로구 디지털로32나길 35 서울특별시 구로구 구로동 1124-44	2026-01-29 23:28:26.337996	37.48471269	126.900872	OFFICIAL	2026-01-29 23:28:26.337999	0	\N
2834	서울특별시 구로구 신도림동 350-2	2026-01-29 23:28:26.338352	37.50862717	126.8876382	OFFICIAL	2026-01-29 23:28:26.338367	0	\N
2835	서울특별시 구로구 경인로 673-1	2026-01-29 23:28:26.338734	37.50984687	126.889001	OFFICIAL	2026-01-29 23:28:26.338737	0	\N
2836	서울특별시 구로구 시흥대로 563 서울특별시 구로구 구로동 1125-5	2026-01-29 23:28:26.339107	37.48339166	126.9014243	OFFICIAL	2026-01-29 23:28:26.339111	0	\N
2837	서울특별시 구로구 항동 9-1	2026-01-29 23:28:26.339462	37.48196844	126.8236695	OFFICIAL	2026-01-29 23:28:26.339466	0	\N
2838	서울특별시 구로구 천왕동 14-41	2026-01-29 23:28:26.339833	37.48682194	126.838774	OFFICIAL	2026-01-29 23:28:26.339837	0	\N
2839	서울특별시 구로구 오류로 20 서울특별시 구로구 천왕동 280-12	2026-01-29 23:28:26.340262	37.48639966	126.839547	OFFICIAL	2026-01-29 23:28:26.340267	0	\N
2840	서울특별시 구로구 경인로 159 서울특별시 구로구 오류동 81-30	2026-01-29 23:28:26.340782	37.49426611	126.8391462	OFFICIAL	2026-01-29 23:28:26.340786	0	\N
2841	서울특별시 구로구 경인로22길 48-1 서울특별시 구로구 오류동 56-49	2026-01-29 23:28:26.341178	37.4961806	126.846457	OFFICIAL	2026-01-29 23:28:26.341182	0	\N
2842	서울특별시 구로구 오류로 104 서울특별시 구로구 오류동 76-2	2026-01-29 23:28:26.341556	37.49394797	126.8405467	OFFICIAL	2026-01-29 23:28:26.341559	0	\N
2843	서울특별시 구로구 경인로 176-4 서울특별시 구로구 오류동 6-303	2026-01-29 23:28:26.341952	37.49446439	126.840732	OFFICIAL	2026-01-29 23:28:26.341956	0	\N
2844	서울특별시 구로구 경인로 248-14 서울특별시 구로구 오류동 336	2026-01-29 23:28:26.342327	37.49755995	126.8478786	OFFICIAL	2026-01-29 23:28:26.342331	0	\N
2845	서울특별시 구로구 새말로 18-53 서울특별시 구로구 구로동 572-22	2026-01-29 23:28:26.342686	37.50116412	126.88349	OFFICIAL	2026-01-29 23:28:26.34269	0	\N
2846	서울특별시 구로구 새말로4길 27 서울특별시 구로구 구로동 572-29	2026-01-29 23:28:26.343055	37.50112484	126.883602	OFFICIAL	2026-01-29 23:28:26.343058	0	\N
2847	서울특별시 구로구 경인로47길 50 서울특별시 구로구 고척동 52-242	2026-01-29 23:28:26.343407	37.5013741	126.8655701	OFFICIAL	2026-01-29 23:28:26.34341	0	\N
2848	서울특별시 구로구 경인로47길 49 서울특별시 구로구 고척동 53-2	2026-01-29 23:28:26.343781	37.50116963	126.865405	OFFICIAL	2026-01-29 23:28:26.343785	0	\N
2849	서울특별시 구로구 연동로 240 서울특별시 구로구 항동 9-1	2026-01-29 23:28:26.344196	37.48196844	126.8236695	OFFICIAL	2026-01-29 23:28:26.344199	0	\N
2850	서울특별시 구로구 항동 100-14	2026-01-29 23:28:26.34455	37.48130537	126.8216787	OFFICIAL	2026-01-29 23:28:26.344553	0	\N
2851	서울특별시 구로구 항동 169-1	2026-01-29 23:28:26.344928	37.478369	126.823641	OFFICIAL	2026-01-29 23:28:26.344932	0	\N
2852	서울특별시 구로구 항동 204-2	2026-01-29 23:28:26.345271	37.4769908	126.8195	OFFICIAL	2026-01-29 23:28:26.345275	0	\N
2853	서울특별시 구로구 항동 88-2	2026-01-29 23:28:26.345611	37.48135478	126.824877	OFFICIAL	2026-01-29 23:28:26.345615	0	\N
2854	서울특별시 구로구 항동 82-7	2026-01-29 23:28:26.345962	37.48177404	126.8246193	OFFICIAL	2026-01-29 23:28:26.345965	0	\N
2855	서울특별시 구로구 항동 113-5	2026-01-29 23:28:26.346315	37.47982718	126.822111	OFFICIAL	2026-01-29 23:28:26.346319	0	\N
2856	서울특별시 구로구 항동 115-2	2026-01-29 23:28:26.346663	37.48020766	126.822536	OFFICIAL	2026-01-29 23:28:26.346666	0	\N
2857	서울특별시 구로구 오류동 169-3	2026-01-29 23:28:26.347152	37.48822079	126.839713	OFFICIAL	2026-01-29 23:28:26.347156	0	\N
2858	서울특별시 구로구 오류동 332-36	2026-01-29 23:28:26.347526	37.4934436	126.842968	OFFICIAL	2026-01-29 23:28:26.347529	0	\N
2859	서울특별시 구로구 오류로 86 서울특별시 구로구 오류동 134-1	2026-01-29 23:28:26.347976	37.49246153	126.8409746	OFFICIAL	2026-01-29 23:28:26.347979	0	\N
2860	서울특별시 구로구 오류로 86 서울특별시 구로구 오류동 134-1	2026-01-29 23:28:26.348358	37.49246153	126.8409746	OFFICIAL	2026-01-29 23:28:26.348368	0	\N
2861	서울특별시 구로구 오류로 66 서울특별시 구로구 오류동 156-28	2026-01-29 23:28:26.348824	37.49048756	126.8408736	OFFICIAL	2026-01-29 23:28:26.348827	0	\N
2862	서울특별시 구로구 천왕동 11-17	2026-01-29 23:28:26.349197	37.48360686	126.841003	OFFICIAL	2026-01-29 23:28:26.3492	0	\N
2863	서울특별시 구로구 천왕동 12-39	2026-01-29 23:28:26.349548	37.48371087	126.841287	OFFICIAL	2026-01-29 23:28:26.349551	0	\N
2864	서울특별시 구로구 천왕동 282-10	2026-01-29 23:28:26.349922	37.48532517	126.8377231	OFFICIAL	2026-01-29 23:28:26.349924	0	\N
2865	서울특별시 구로구 경인로 196 서울특별시 구로구 오류동 48-1	2026-01-29 23:28:26.350276	37.49538169	126.8429307	OFFICIAL	2026-01-29 23:28:26.350279	0	\N
2866	서울특별시 구로구 경인로 196 서울특별시 구로구 오류동 48-1	2026-01-29 23:28:26.350619	37.49538169	126.8429307	OFFICIAL	2026-01-29 23:28:26.350622	0	\N
2867	서울특별시 구로구 경인로 176-4 서울특별시 구로구 오류동 6-303	2026-01-29 23:28:26.350967	37.49446439	126.8407215	OFFICIAL	2026-01-29 23:28:26.35097	0	\N
2868	서울특별시 구로구 경인로 176-4 서울특별시 구로구 오류동 6-303	2026-01-29 23:28:26.351303	37.49446439	126.8407215	OFFICIAL	2026-01-29 23:28:26.351306	0	\N
2869	서울특별시 구로구 경인로 161 서울특별시 구로구 오류동 81-91	2026-01-29 23:28:26.35173	37.49439186	126.8394568	OFFICIAL	2026-01-29 23:28:26.351733	0	\N
2870	서울특별시 구로구 경인로 161 서울특별시 구로구 오류동 81-91	2026-01-29 23:28:26.352121	37.49439186	126.8394568	OFFICIAL	2026-01-29 23:28:26.352123	0	\N
2871	서울특별시 구로구 고척로 6-1 서울특별시 구로구 오류동 9-190	2026-01-29 23:28:26.352476	37.49542213	126.840901	OFFICIAL	2026-01-29 23:28:26.352478	0	\N
2872	서울특별시 구로구 고척로 52	2026-01-29 23:28:26.352827	37.49856841	126.8404707	OFFICIAL	2026-01-29 23:28:26.352829	0	\N
2873	서울특별시 구로구 경인로 217	2026-01-29 23:28:26.353182	37.49672189	126.8449439	OFFICIAL	2026-01-29 23:28:26.353185	0	\N
2874	서울특별시 구로구 경인로27길 7	2026-01-29 23:28:26.353525	37.49707073	126.8450908	OFFICIAL	2026-01-29 23:28:26.353527	0	\N
2875	서울특별시 구로구 우마길 23	2026-01-29 23:28:26.353886	37.48090307	126.888878	OFFICIAL	2026-01-29 23:28:26.353889	0	\N
2876	서울특별시 구로구 구로동로 12	2026-01-29 23:28:26.354234	37.48284325	126.887327	OFFICIAL	2026-01-29 23:28:26.354236	0	\N
2877	서울특별시 구로구 우마길 19	2026-01-29 23:28:26.354582	37.48124676	126.8885862	OFFICIAL	2026-01-29 23:28:26.354585	0	\N
2878	서울특별시 구로구 우마길 23	2026-01-29 23:28:26.354941	37.48090307	126.888878	OFFICIAL	2026-01-29 23:28:26.354943	0	\N
2879	서울특별시 구로구 우마길 10-2	2026-01-29 23:28:26.35529	37.48185313	126.887875	OFFICIAL	2026-01-29 23:28:26.355293	0	\N
2880	서울특별시 구로구 경인로 661	2026-01-29 23:28:26.355634	37.50904922	126.8869873	OFFICIAL	2026-01-29 23:28:26.355637	0	\N
2881	서울특별시 구로구 신도림동 413-2	2026-01-29 23:28:26.355987	37.5056427	126.8834977	OFFICIAL	2026-01-29 23:28:26.35599	0	\N
2882	서울특별시 구로구 신도림동 413-2	2026-01-29 23:28:26.356328	37.5056427	126.8834977	OFFICIAL	2026-01-29 23:28:26.35633	0	\N
2883	서울특별시 구로구 신도림동 413-2	2026-01-29 23:28:26.356667	37.5056427	126.8834977	OFFICIAL	2026-01-29 23:28:26.356669	0	\N
2884	서울특별시 구로구 신도림동 350-2	2026-01-29 23:28:26.357011	37.50862717	126.8876382	OFFICIAL	2026-01-29 23:28:26.357013	0	\N
2885	서울특별시 구로구 신도림동 350-2	2026-01-29 23:28:26.357349	37.50862717	126.8876382	OFFICIAL	2026-01-29 23:28:26.357352	0	\N
2886	서울특별시 구로구 신도림동 350-2	2026-01-29 23:28:26.357688	37.50862717	126.8876382	OFFICIAL	2026-01-29 23:28:26.35769	0	\N
2887	서울특별시 구로구 신도림동 350-2	2026-01-29 23:28:26.35803	37.50862717	126.8876382	OFFICIAL	2026-01-29 23:28:26.358033	0	\N
2888	서울특별시 구로구 경인로 서울특별시 구로구 신도림동 432-30	2026-01-29 23:28:26.358378	37.50623763	126.8853921	OFFICIAL	2026-01-29 23:28:26.35838	0	\N
2889	서울특별시 구로구 신도림로 11 서울특별시 구로구 신도림동 691	2026-01-29 23:28:26.358718	37.50727521	126.878181	OFFICIAL	2026-01-29 23:28:26.358721	0	\N
2890	서울특별시 구로구 신도림로 11 서울특별시 구로구 신도림동 691	2026-01-29 23:28:26.35915	37.50727521	126.878181	OFFICIAL	2026-01-29 23:28:26.359153	0	\N
2891	서울특별시 구로구 신도림로19길 7 서울특별시 구로구 신도림동 649	2026-01-29 23:28:26.359497	37.51120297	126.8844703	OFFICIAL	2026-01-29 23:28:26.3595	0	\N
2892	서울특별시 구로구 신도림로 40 서울특별시 구로구 신도림동 390-68	2026-01-29 23:28:26.359868	37.50777999	126.8805952	OFFICIAL	2026-01-29 23:28:26.359871	0	\N
2893	서울특별시 구로구 신도림동 329-2	2026-01-29 23:28:26.36021	37.51198142	126.8881747	OFFICIAL	2026-01-29 23:28:26.360212	0	\N
2894	서울특별시 구로구 신도림로 67 서울특별시 구로구 신도림동 306-13	2026-01-29 23:28:26.360554	37.50992411	126.8820265	OFFICIAL	2026-01-29 23:28:26.360556	0	\N
2895	서울특별시 구로구 신도림로 78 서울특별시 구로구 신도림동 645	2026-01-29 23:28:26.36093	37.50938921	126.8847002	OFFICIAL	2026-01-29 23:28:26.360932	0	\N
2896	서울특별시 구로구 신도림로 2 서울특별시 구로구 신도림동 400-3	2026-01-29 23:28:26.361261	37.50559462	126.8772754	OFFICIAL	2026-01-29 23:28:26.361263	0	\N
2897	서울특별시 노원구 노원로 31-2	2026-01-29 23:28:26.361613	37.62444854	127.0862158	OFFICIAL	2026-01-29 23:28:26.361615	0	\N
2898	서울특별시 구로구 신도림로 2 서울특별시 구로구 신도림동 400-3	2026-01-29 23:28:26.36197	37.50559462	126.8772754	OFFICIAL	2026-01-29 23:28:26.361972	0	\N
2899	서울특별시 구로구 신도림로 16 서울특별시 구로구 신도림동 642	2026-01-29 23:28:26.36237	37.50512282	126.882191	OFFICIAL	2026-01-29 23:28:26.362373	0	\N
2900	서울특별시 구로구 신도림로 16 서울특별시 구로구 신도림동 642	2026-01-29 23:28:26.362712	37.50512282	126.882191	OFFICIAL	2026-01-29 23:28:26.362715	0	\N
2901	서울특별시 구로구 경인로3길 77 서울특별시 구로구 온수동 52	2026-01-29 23:28:26.363083	37.49173696	126.823542	OFFICIAL	2026-01-29 23:28:26.363085	0	\N
2902	서울특별시 구로구 경인로3길 77 서울특별시 구로구 온수동 52	2026-01-29 23:28:26.36345	37.49173696	126.823542	OFFICIAL	2026-01-29 23:28:26.363452	0	\N
2903	서울특별시 구로구 부일로9길 133 서울특별시 구로구 온수동 141	2026-01-29 23:28:26.363822	37.49690229	126.8221862	OFFICIAL	2026-01-29 23:28:26.363824	0	\N
2904	서울특별시 구로구 부일로 861 서울특별시 구로구 온수동 18-12	2026-01-29 23:28:26.364165	37.49265356	126.822945	OFFICIAL	2026-01-29 23:28:26.364168	0	\N
2905	서울특별시 구로구 부일로 869 서울특별시 구로구 온수동 11-1	2026-01-29 23:28:26.364505	37.49294292	126.823634	OFFICIAL	2026-01-29 23:28:26.364508	0	\N
2906	서울특별시 구로구 부일로 868-1 서울특별시 구로구 온수동 119-4	2026-01-29 23:28:26.36487	37.49254526	126.8235425	OFFICIAL	2026-01-29 23:28:26.364873	0	\N
2907	서울특별시 구로구 부일로 917 서울특별시 구로구 궁동 230	2026-01-29 23:28:26.365218	37.49490231	126.8263536	OFFICIAL	2026-01-29 23:28:26.36522	0	\N
2908	서울특별시 구로구 부일로 957 서울특별시 구로구 궁동 202-6	2026-01-29 23:28:26.36559	37.49340026	126.8336922	OFFICIAL	2026-01-29 23:28:26.365592	0	\N
2909	서울특별시 구로구 부일로 957 서울특별시 구로구 궁동 202-6	2026-01-29 23:28:26.365958	37.49340026	126.8336922	OFFICIAL	2026-01-29 23:28:26.36596	0	\N
2910	서울특별시 구로구 부일로15길 4 서울특별시 구로구 궁동 189-25	2026-01-29 23:28:26.366306	37.49351635	126.834427	OFFICIAL	2026-01-29 23:28:26.366308	0	\N
2911	서울특별시 구로구 궁동 199-26	2026-01-29 23:28:26.366648	37.493509	126.835896	OFFICIAL	2026-01-29 23:28:26.36665	0	\N
2912	서울특별시 구로구 오리로 1286 서울특별시 구로구 궁동 170-11	2026-01-29 23:28:26.367002	37.49627786	126.8299962	OFFICIAL	2026-01-29 23:28:26.367005	0	\N
2913	서울특별시 구로구 오리로 1293 서울특별시 구로구 궁동 283-5	2026-01-29 23:28:26.367358	37.49688156	126.8292071	OFFICIAL	2026-01-29 23:28:26.36736	0	\N
2914	서울특별시 구로구 오리로 1307 서울특별시 구로구 궁동 278-4	2026-01-29 23:28:26.367719	37.49809846	126.8289553	OFFICIAL	2026-01-29 23:28:26.367722	0	\N
2915	서울특별시 구로구 오리로15길 32 서울특별시 구로구 궁동 213-42	2026-01-29 23:28:26.36808	37.4938915	126.8314768	OFFICIAL	2026-01-29 23:28:26.368082	0	\N
2916	서울특별시 구로구 오리로15길 32 서울특별시 구로구 궁동 213-42	2026-01-29 23:28:26.368417	37.4938915	126.8314768	OFFICIAL	2026-01-29 23:28:26.36842	0	\N
2917	서울특별시 구로구 공원로 27 서울특별시 구로구 구로동 107-9	2026-01-29 23:28:26.368809	37.49939719	126.8910091	OFFICIAL	2026-01-29 23:28:26.368811	0	\N
2918	서울특별시 구로구 구로동 3-64	2026-01-29 23:28:26.369279	37.50726447	126.89282	OFFICIAL	2026-01-29 23:28:26.369281	0	\N
2919	서울특별시 구로구 구로중앙로 108 서울특별시 구로구 구로동 514-2	2026-01-29 23:28:26.369709	37.49850642	126.8863775	OFFICIAL	2026-01-29 23:28:26.369712	0	\N
2920	서울특별시 구로구 구로중앙로28길 66 서울특별시 구로구 구로동 109-4	2026-01-29 23:28:26.370097	37.500164	126.8893378	OFFICIAL	2026-01-29 23:28:26.3701	0	\N
2921	서울특별시 구로구 구로중앙로28길 65 서울특별시 구로구 구로동 111-16	2026-01-29 23:28:26.370462	37.50047025	126.8889323	OFFICIAL	2026-01-29 23:28:26.370464	0	\N
2922	서울특별시 구로구 경인로 572 서울특별시 구로구 구로동 603-9	2026-01-29 23:28:26.37091	37.50330627	126.8810839	OFFICIAL	2026-01-29 23:28:26.370913	0	\N
2923	서울특별시 구로구 새말로 111 서울특별시 구로구 구로동 1-4	2026-01-29 23:28:26.371349	37.50786379	126.8922179	OFFICIAL	2026-01-29 23:28:26.371353	0	\N
2924	서울특별시 구로구 새말로 111 서울특별시 구로구 구로동 1-4	2026-01-29 23:28:26.371823	37.50786379	126.8922179	OFFICIAL	2026-01-29 23:28:26.371826	0	\N
2925	서울특별시 구로구 새말로 111 서울특별시 구로구 구로동 1-4	2026-01-29 23:28:26.37221	37.50786379	126.8922179	OFFICIAL	2026-01-29 23:28:26.372212	0	\N
2926	서울특별시 노원구 공릉동 90-2	2026-01-29 23:28:26.372586	37.62095614	127.0848955	OFFICIAL	2026-01-29 23:28:26.372588	0	\N
2927	서울특별시 구로구 새말로 117-6 서울특별시 구로구 구로동 3-55	2026-01-29 23:28:26.37295	37.5074418	126.8922686	OFFICIAL	2026-01-29 23:28:26.372953	0	\N
2928	서울특별시 구로구 새말로 111 서울특별시 구로구 구로동 1-4	2026-01-29 23:28:26.373308	37.50786379	126.8922179	OFFICIAL	2026-01-29 23:28:26.373311	0	\N
2929	서울특별시 구로구 공원로 54 서울특별시 구로구 구로동 45-9	2026-01-29 23:28:26.373658	37.50259229	126.8901814	OFFICIAL	2026-01-29 23:28:26.373661	0	\N
2930	서울특별시 구로구 공원로6길 서울특별시 구로구 구로동 47	2026-01-29 23:28:26.374006	37.50135772	126.8920128	OFFICIAL	2026-01-29 23:28:26.374008	0	\N
2931	서울특별시 구로구 공원로 51 서울특별시 구로구 구로동 110-2	2026-01-29 23:28:26.374358	37.50131998	126.8893996	OFFICIAL	2026-01-29 23:28:26.37436	0	\N
2932	서울특별시 구로구 공원로 27 서울특별시 구로구 구로동 107-9	2026-01-29 23:28:26.374704	37.49939719	126.8910091	OFFICIAL	2026-01-29 23:28:26.374706	0	\N
2933	서울특별시 구로구 가마산로27길 45 서울특별시 구로구 구로동 105-1	2026-01-29 23:28:26.375077	37.49884008	126.8903092	OFFICIAL	2026-01-29 23:28:26.37508	0	\N
2934	서울특별시 구로구 새말로 81 서울특별시 구로구 구로동 8-14	2026-01-29 23:28:26.37542	37.50514257	126.8889085	OFFICIAL	2026-01-29 23:28:26.375423	0	\N
2935	서울특별시 구로구 가마산로 283 서울특별시 구로구 구로동 104-9	2026-01-29 23:28:26.375787	37.49690482	126.8913849	OFFICIAL	2026-01-29 23:28:26.375789	0	\N
2936	서울특별시 구로구 가마산로 283 서울특별시 구로구 구로동 104-9	2026-01-29 23:28:26.37614	37.49690482	126.8913849	OFFICIAL	2026-01-29 23:28:26.376142	0	\N
2937	서울특별시 구로구 구로중앙로 152 서울특별시 구로구 구로동 573	2026-01-29 23:28:26.376482	37.50116014	126.882773	OFFICIAL	2026-01-29 23:28:26.376484	0	\N
2938	서울특별시 구로구 구로중앙로 152 서울특별시 구로구 구로동 573	2026-01-29 23:28:26.376822	37.50116014	126.882773	OFFICIAL	2026-01-29 23:28:26.376825	0	\N
2939	서울특별시 구로구 구로중앙로 68 서울특별시 구로구 구로동 100-8	2026-01-29 23:28:26.377172	37.49586031	126.8888073	OFFICIAL	2026-01-29 23:28:26.377175	0	\N
2940	서울특별시 구로구 구로중앙로 68 서울특별시 구로구 구로동 100-8	2026-01-29 23:28:26.377514	37.49586031	126.8888073	OFFICIAL	2026-01-29 23:28:26.377516	0	\N
2941	서울특별시 구로구 새말로 94 서울특별시 구로구 구로동 25	2026-01-29 23:28:26.377869	37.50547022	126.8904984	OFFICIAL	2026-01-29 23:28:26.377871	0	\N
2942	서울특별시 구로구 구로중앙로28길 66 서울특별시 구로구 구로동 109-4	2026-01-29 23:28:26.378206	37.50010311	126.8893378	OFFICIAL	2026-01-29 23:28:26.378208	0	\N
2943	서울특별시 구로구 구로중앙로28길 66 서울특별시 구로구 구로동 109-4	2026-01-29 23:28:26.378633	37.50010311	126.8893378	OFFICIAL	2026-01-29 23:28:26.378636	0	\N
2944	서울특별시 구로구 구로동로 126-2 서울특별시 구로구 구로동 732-1	2026-01-29 23:28:26.378979	37.48993123	126.8845698	OFFICIAL	2026-01-29 23:28:26.378993	0	\N
2945	서울특별시 구로구 구로동로 124 서울특별시 구로구 구로동 732-3	2026-01-29 23:28:26.379387	37.48963242	126.8845363	OFFICIAL	2026-01-29 23:28:26.37939	0	\N
2946	서울특별시 구로구 구로동로 108 서울특별시 구로구 구로동 737-1	2026-01-29 23:28:26.379829	37.48825257	126.8848511	OFFICIAL	2026-01-29 23:28:26.379832	0	\N
2947	서울특별시 구로구 구로동로 96-1 서울특별시 구로구 구로동 738-65	2026-01-29 23:28:26.380193	37.48731314	126.8851802	OFFICIAL	2026-01-29 23:28:26.380196	0	\N
2948	서울특별시 구로구 구로동로 84 서울특별시 구로구 구로동 807-15	2026-01-29 23:28:26.380546	37.48628409	126.885635	OFFICIAL	2026-01-29 23:28:26.380549	0	\N
2949	서울특별시 구로구 도림로 5 서울특별시 구로구 구로동 805-4	2026-01-29 23:28:26.380918	37.48522857	126.8862995	OFFICIAL	2026-01-29 23:28:26.380921	0	\N
2950	서울특별시 구로구 구로동로 70 서울특별시 구로구 구로동 805-22	2026-01-29 23:28:26.381272	37.48515115	126.8861846	OFFICIAL	2026-01-29 23:28:26.381275	0	\N
2951	서울특별시 구로구 도림로 57 서울특별시 구로구 구로동 766-207	2026-01-29 23:28:26.381612	37.48891958	126.8901495	OFFICIAL	2026-01-29 23:28:26.381614	0	\N
2952	서울특별시 구로구 디지털로31길 109 서울특별시 구로구 구로동 777-39	2026-01-29 23:28:26.381954	37.48734704	126.89033	OFFICIAL	2026-01-29 23:28:26.381957	0	\N
2953	서울특별시 구로구 디지털로33길 11 서울특별시 구로구 구로동 256-1	2026-01-29 23:28:26.382297	37.48570578	126.8955127	OFFICIAL	2026-01-29 23:28:26.3823	0	\N
2954	서울특별시 구로구 디지털로31길 61 서울특별시 구로구 구로동 197-12	2026-01-29 23:28:26.382638	37.48591087	126.891542	OFFICIAL	2026-01-29 23:28:26.382641	0	\N
2955	서울특별시 노원구 동일로 1456	2026-01-29 23:28:26.382985	37.66067691	127.0614956	OFFICIAL	2026-01-29 23:28:26.382987	0	\N
2956	서울특별시 구로구 디지털로27가길 17 서울특별시 구로구 구로동 197-30	2026-01-29 23:28:26.383325	37.48438754	126.8923345	OFFICIAL	2026-01-29 23:28:26.383327	0	\N
2957	서울특별시 구로구 시흥대로 563 서울특별시 구로구 구로동 1125-5	2026-01-29 23:28:26.383855	37.48339166	126.9014243	OFFICIAL	2026-01-29 23:28:26.383859	0	\N
2958	서울특별시 구로구 시흥대로 563 서울특별시 구로구 구로동 1125-5	2026-01-29 23:28:26.384306	37.48339166	126.9014243	OFFICIAL	2026-01-29 23:28:26.384309	0	\N
2959	서울특별시 구로구 시흥대로 563 서울특별시 구로구 구로동 1125-9	2026-01-29 23:28:26.384736	37.48339166	126.9014243	OFFICIAL	2026-01-29 23:28:26.384739	0	\N
2960	서울특별시 구로구 시흥대로 563 서울특별시 구로구 구로동 1125-9	2026-01-29 23:28:26.385158	37.48339166	126.9014243	OFFICIAL	2026-01-29 23:28:26.38516	0	\N
2961	서울특별시 구로구 디지털로32나길 51 서울특별시 구로구 구로동 1124-49	2026-01-29 23:28:26.385558	37.48490133	126.9003821	OFFICIAL	2026-01-29 23:28:26.38556	0	\N
2962	서울특별시 구로구 디지털로32나길 38 서울특별시 구로구 구로동 1124-42	2026-01-29 23:28:26.385955	37.48454459	126.9011985	OFFICIAL	2026-01-29 23:28:26.385957	0	\N
2963	서울특별시 구로구 디지털로32길 79 서울특별시 구로구 구로동 824	2026-01-29 23:28:26.38632	37.48353325	126.899752	OFFICIAL	2026-01-29 23:28:26.386322	0	\N
2964	서울특별시 구로구 디지털로32길 79 서울특별시 구로구 구로동 824	2026-01-29 23:28:26.386686	37.48353325	126.899752	OFFICIAL	2026-01-29 23:28:26.386688	0	\N
2965	서울특별시 구로구 디지털로32길 55 서울특별시 구로구 구로동 817	2026-01-29 23:28:26.387058	37.48398669	126.8983387	OFFICIAL	2026-01-29 23:28:26.38706	0	\N
2966	서울특별시 구로구 디지털로31길 120 서울특별시 구로구 구로동 1280	2026-01-29 23:28:26.387418	37.48847002	126.890773	OFFICIAL	2026-01-29 23:28:26.38742	0	\N
2967	서울특별시 구로구 디지털로26길 5 서울특별시 구로구 구로동 235-2	2026-01-29 23:28:26.387797	37.48161059	126.8934793	OFFICIAL	2026-01-29 23:28:26.387799	0	\N
2968	서울특별시 구로구 디지털로 319 서울특별시 구로구 구로동 1256	2026-01-29 23:28:26.388152	37.49003775	126.8954329	OFFICIAL	2026-01-29 23:28:26.388154	0	\N
2969	서울특별시 구로구 디지털로 292 서울특별시 구로구 구로동 188-11	2026-01-29 23:28:26.388502	37.48469365	126.8958922	OFFICIAL	2026-01-29 23:28:26.388504	0	\N
2970	서울특별시 구로구 디지털로 273 서울특별시 구로구 구로동 212-30	2026-01-29 23:28:26.38888	37.48395432	126.8941033	OFFICIAL	2026-01-29 23:28:26.388882	0	\N
2971	서울특별시 구로구 도림로 6 서울특별시 구로구 구로동 801-51	2026-01-29 23:28:26.389339	37.4851606	126.8867371	OFFICIAL	2026-01-29 23:28:26.389342	0	\N
2972	서울특별시 구로구 도림로 6 서울특별시 구로구 구로동 801-51	2026-01-29 23:28:26.389704	37.4851606	126.8867371	OFFICIAL	2026-01-29 23:28:26.389706	0	\N
2973	서울특별시 구로구 구로동로 203 서울특별시 구로구 구로동 481-7	2026-01-29 23:28:26.390077	37.49671859	126.8822699	OFFICIAL	2026-01-29 23:28:26.390079	0	\N
2974	서울특별시 구로구 구로동로 210 서울특별시 구로구 구로동 487-28	2026-01-29 23:28:26.390428	37.49721417	126.8826589	OFFICIAL	2026-01-29 23:28:26.390431	0	\N
2975	서울특별시 구로구 구로동로 170 서울특별시 구로구 구로동 416-7	2026-01-29 23:28:26.390799	37.49376116	126.883394	OFFICIAL	2026-01-29 23:28:26.390801	0	\N
2976	서울특별시 구로구 가마산로 205 서울특별시 구로구 구로동 426-69	2026-01-29 23:28:26.391142	37.49346137	126.884108	OFFICIAL	2026-01-29 23:28:26.391145	0	\N
2977	서울특별시 구로구 구로동로 219 서울특별시 구로구 구로동 486-55	2026-01-29 23:28:26.391482	37.49813373	126.8822071	OFFICIAL	2026-01-29 23:28:26.391484	0	\N
2978	서울특별시 구로구 구로동로 153 서울특별시 구로구 구로동 413-88	2026-01-29 23:28:26.391835	37.4923559	126.8834335	OFFICIAL	2026-01-29 23:28:26.391837	0	\N
2979	서울특별시 구로구 가마산로 245 서울특별시 구로구 구로동 436-1	2026-01-29 23:28:26.392186	37.49551123	126.8882891	OFFICIAL	2026-01-29 23:28:26.392188	0	\N
2980	서울특별시 구로구 구로동로 216 서울특별시 구로구 구로동 486-11	2026-01-29 23:28:26.39256	37.49784789	126.8827014	OFFICIAL	2026-01-29 23:28:26.392563	0	\N
2981	서울특별시 구로구 구로동로 173 서울특별시 구로구 구로동 415-3	2026-01-29 23:28:26.392938	37.49392402	126.8829027	OFFICIAL	2026-01-29 23:28:26.392941	0	\N
2982	서울특별시 구로구 가마산로 242 서울특별시 구로구 구로동 83	2026-01-29 23:28:26.393295	37.49436222	126.8876711	OFFICIAL	2026-01-29 23:28:26.393298	0	\N
2983	서울특별시 구로구 가마산로 218 서울특별시 구로구 구로동 80-24	2026-01-29 23:28:26.393684	37.49321551	126.8851411	OFFICIAL	2026-01-29 23:28:26.393686	0	\N
2984	서울특별시 노원구 동일로 1456	2026-01-29 23:28:26.394062	37.66067691	127.0614956	OFFICIAL	2026-01-29 23:28:26.394065	0	\N
2985	서울특별시 구로구 가마산로 242 서울특별시 구로구 구로동 83	2026-01-29 23:28:26.394418	37.49436222	126.8876711	OFFICIAL	2026-01-29 23:28:26.39442	0	\N
2986	서울특별시 구로구 구로동 635-4	2026-01-29 23:28:26.394836	37.49985843	126.8749308	OFFICIAL	2026-01-29 23:28:26.394838	0	\N
2987	서울특별시 구로구 구로동 635-4	2026-01-29 23:28:26.395201	37.49985843	126.8749308	OFFICIAL	2026-01-29 23:28:26.395204	0	\N
2988	서울특별시 구로구 구로동 635-4	2026-01-29 23:28:26.395556	37.49985843	126.8749308	OFFICIAL	2026-01-29 23:28:26.395559	0	\N
2989	서울특별시 구로구 구로동 635-4	2026-01-29 23:28:26.395936	37.49985843	126.8749308	OFFICIAL	2026-01-29 23:28:26.395939	0	\N
2990	서울특별시 구로구 가마산로 203 서울특별시 구로구 구로동 426-6	2026-01-29 23:28:26.396288	37.49340254	126.8837472	OFFICIAL	2026-01-29 23:28:26.396291	0	\N
2991	서울특별시 구로구 구로동로 107 서울특별시 구로구 구로동 721-14	2026-01-29 23:28:26.396651	37.48813556	126.8845201	OFFICIAL	2026-01-29 23:28:26.396654	0	\N
2992	서울특별시 구로구 구로동로 125-1 서울특별시 구로구 구로동 726-3	2026-01-29 23:28:26.397018	37.48982287	126.8840474	OFFICIAL	2026-01-29 23:28:26.397021	0	\N
2993	서울특별시 구로구 벚꽃로 484 서울특별시 구로구 구로동 476-134	2026-01-29 23:28:26.397375	37.49733165	126.8801354	OFFICIAL	2026-01-29 23:28:26.397377	0	\N
2994	서울특별시 구로구 가마산로9길 4-4 서울특별시 구로구 구로동 402-7	2026-01-29 23:28:26.397781	37.49154041	126.8816385	OFFICIAL	2026-01-29 23:28:26.397783	0	\N
2995	서울특별시 구로구 가마산로 222 서울특별시 구로구 구로동 80-4	2026-01-29 23:28:26.398145	37.49349581	126.8857884	OFFICIAL	2026-01-29 23:28:26.398147	0	\N
2996	서울특별시 구로구 가마산로 180-2 서울특별시 구로구 구로동 704-38	2026-01-29 23:28:26.398501	37.49168151	126.8822748	OFFICIAL	2026-01-29 23:28:26.398503	0	\N
2997	서울특별시 구로구 구로동로 174 서울특별시 구로구 구로동 416-1	2026-01-29 23:28:26.398868	37.49404864	126.8833646	OFFICIAL	2026-01-29 23:28:26.398871	0	\N
2998	서울특별시 구로구 구로동 490	2026-01-29 23:28:26.399209	37.498129	126.883412	OFFICIAL	2026-01-29 23:28:26.399211	0	\N
2999	서울특별시 구로구 구로동로 203 서울특별시 구로구 구로동 481-7	2026-01-29 23:28:26.399554	37.49671859	126.8822699	OFFICIAL	2026-01-29 23:28:26.399556	0	\N
3000	서울특별시 구로구 구로동로 179 서울특별시 구로구 구로동 461-7	2026-01-29 23:28:26.399955	37.49445292	126.8825421	OFFICIAL	2026-01-29 23:28:26.399958	0	\N
3001	서울특별시 구로구 경인로 518 서울특별시 구로구 구로동 636-1	2026-01-29 23:28:26.401367	37.50023921	126.8769102	OFFICIAL	2026-01-29 23:28:26.401371	0	\N
3002	서울특별시 구로구 경인로 557 서울특별시 구로구 구로동 606-4	2026-01-29 23:28:26.401872	37.50310865	126.8790091	OFFICIAL	2026-01-29 23:28:26.401875	0	\N
3003	서울특별시 구로구 경인로 565 서울특별시 구로구 구로동 604-19	2026-01-29 23:28:26.402317	37.50363988	126.8797139	OFFICIAL	2026-01-29 23:28:26.402319	0	\N
3004	서울특별시 구로구 구로동로 159 서울특별시 구로구 구로동 413-80	2026-01-29 23:28:26.40273	37.49273634	126.8832036	OFFICIAL	2026-01-29 23:28:26.402732	0	\N
3005	서울특별시 구로구 가마산로 206 서울특별시 구로구 구로동 426-92	2026-01-29 23:28:26.403131	37.49295531	126.8840437	OFFICIAL	2026-01-29 23:28:26.403134	0	\N
3006	서울특별시 구로구 구로동로 135 서울특별시 구로구 구로동 754-9	2026-01-29 23:28:26.40351	37.4906411	126.8837098	OFFICIAL	2026-01-29 23:28:26.403512	0	\N
3007	서울특별시 구로구 가마산로 250 서울특별시 구로구 구로동 83-4	2026-01-29 23:28:26.403903	37.49481403	126.8886765	OFFICIAL	2026-01-29 23:28:26.403905	0	\N
3008	서울특별시 구로구 가마산로 235 서울특별시 구로구 구로동 436-1	2026-01-29 23:28:26.404263	37.49453206	126.887015	OFFICIAL	2026-01-29 23:28:26.404266	0	\N
3009	서울특별시 구로구 가마산로 245 서울특별시 구로구 구로동 435	2026-01-29 23:28:26.404629	37.49551123	126.8882891	OFFICIAL	2026-01-29 23:28:26.404632	0	\N
3010	서울특별시 구로구 가마산로 245 서울특별시 구로구 구로동 435	2026-01-29 23:28:26.404987	37.49551123	126.8882891	OFFICIAL	2026-01-29 23:28:26.404989	0	\N
3011	서울특별시 구로구 구로동로 141 서울특별시 구로구 구로동 704-57	2026-01-29 23:28:26.405345	37.4913197	126.883399	OFFICIAL	2026-01-29 23:28:26.405347	0	\N
3012	서울특별시 구로구 구로중앙로 135-6 서울특별시 구로구 구로동 500-27	2026-01-29 23:28:26.405696	37.49995073	126.8828691	OFFICIAL	2026-01-29 23:28:26.405698	0	\N
\.


--
-- Data for Name: geocode_settings; Type: TABLE DATA; Schema: tiger; Owner: jupddang
--

COPY tiger.geocode_settings (name, setting, unit, category, short_desc) FROM stdin;
\.


--
-- Data for Name: pagc_gaz; Type: TABLE DATA; Schema: tiger; Owner: jupddang
--

COPY tiger.pagc_gaz (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_lex; Type: TABLE DATA; Schema: tiger; Owner: jupddang
--

COPY tiger.pagc_lex (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_rules; Type: TABLE DATA; Schema: tiger; Owner: jupddang
--

COPY tiger.pagc_rules (id, rule, is_custom) FROM stdin;
\.


--
-- Data for Name: topology; Type: TABLE DATA; Schema: topology; Owner: jupddang
--

COPY topology.topology (id, name, srid, "precision", hasz) FROM stdin;
\.


--
-- Data for Name: layer; Type: TABLE DATA; Schema: topology; Owner: jupddang
--

COPY topology.layer (topology_id, layer_id, schema_name, table_name, feature_column, feature_type, level, child_id) FROM stdin;
\.


--
-- Name: comment_comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.comment_comment_id_seq', 83, true);


--
-- Name: fcm_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.fcm_tokens_id_seq', 39, true);


--
-- Name: follow_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.follow_id_seq', 67, true);


--
-- Name: party_activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.party_activity_id_seq', 21, true);


--
-- Name: party_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.party_id_seq', 39, true);


--
-- Name: party_member_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.party_member_id_seq', 57, true);


--
-- Name: plogging_record_plogging_record_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.plogging_record_plogging_record_id_seq', 1, false);


--
-- Name: ploggings_plogging_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.ploggings_plogging_id_seq', 89, true);


--
-- Name: post_post_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.post_post_id_seq', 119, true);


--
-- Name: raid_boss_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.raid_boss_id_seq', 9, true);


--
-- Name: raid_record_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.raid_record_id_seq', 1, false);


--
-- Name: test_entity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.test_entity_id_seq', 1, false);


--
-- Name: trashcan_verifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.trashcan_verifications_id_seq', 3, true);


--
-- Name: trashcans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jupddang
--

SELECT pg_catalog.setval('public.trashcans_id_seq', 3015, true);


--
-- Name: topology_id_seq; Type: SEQUENCE SET; Schema: topology; Owner: jupddang
--

SELECT pg_catalog.setval('topology.topology_id_seq', 1, false);


--
-- Name: account account_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (user_id);


--
-- Name: comment comment_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_pkey PRIMARY KEY (comment_id);


--
-- Name: fcm_tokens fcm_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.fcm_tokens
    ADD CONSTRAINT fcm_tokens_pkey PRIMARY KEY (id);


--
-- Name: follow follow_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.follow
    ADD CONSTRAINT follow_pkey PRIMARY KEY (id);


--
-- Name: grids grids_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.grids
    ADD CONSTRAINT grids_pkey PRIMARY KEY (grid_id);


--
-- Name: party_activity party_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.party_activity
    ADD CONSTRAINT party_activity_pkey PRIMARY KEY (id);


--
-- Name: party_member party_member_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.party_member
    ADD CONSTRAINT party_member_pkey PRIMARY KEY (id);


--
-- Name: party party_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.party
    ADD CONSTRAINT party_pkey PRIMARY KEY (id);


--
-- Name: plogging_record plogging_record_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.plogging_record
    ADD CONSTRAINT plogging_record_pkey PRIMARY KEY (plogging_record_id);


--
-- Name: ploggings ploggings_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.ploggings
    ADD CONSTRAINT ploggings_pkey PRIMARY KEY (plogging_id);


--
-- Name: post post_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.post
    ADD CONSTRAINT post_pkey PRIMARY KEY (post_id);


--
-- Name: raid_boss raid_boss_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.raid_boss
    ADD CONSTRAINT raid_boss_pkey PRIMARY KEY (id);


--
-- Name: raid_record raid_record_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.raid_record
    ADD CONSTRAINT raid_record_pkey PRIMARY KEY (id);


--
-- Name: test_entity test_entity_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.test_entity
    ADD CONSTRAINT test_entity_pkey PRIMARY KEY (id);


--
-- Name: trashcan_verifications trashcan_verifications_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.trashcan_verifications
    ADD CONSTRAINT trashcan_verifications_pkey PRIMARY KEY (id);


--
-- Name: trashcans trashcans_pkey; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.trashcans
    ADD CONSTRAINT trashcans_pkey PRIMARY KEY (id);


--
-- Name: party_member uk9tdmmjuhq00j0cdvg8minjqa; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.party_member
    ADD CONSTRAINT uk9tdmmjuhq00j0cdvg8minjqa UNIQUE (party_id, user_id);


--
-- Name: raid_boss uk_d22bpw9rvi9dganwp8aarek4g; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.raid_boss
    ADD CONSTRAINT uk_d22bpw9rvi9dganwp8aarek4g UNIQUE (h3index);


--
-- Name: account uk_q0uja26qgu1atulenwup9rxyr; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT uk_q0uja26qgu1atulenwup9rxyr UNIQUE (email);


--
-- Name: party uk_q5m63raep7xcquqxh5dp0qibu; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.party
    ADD CONSTRAINT uk_q5m63raep7xcquqxh5dp0qibu UNIQUE (invite_code);


--
-- Name: fcm_tokens uk_qopjyk0c1cho2ep0abxd9hi5q; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.fcm_tokens
    ADD CONSTRAINT uk_qopjyk0c1cho2ep0abxd9hi5q UNIQUE (token);


--
-- Name: raid_record uk_raid_record_boss_account; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.raid_record
    ADD CONSTRAINT uk_raid_record_boss_account UNIQUE (boss_id, account_user_id);


--
-- Name: trashcan_verifications uk_trashcan_user; Type: CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.trashcan_verifications
    ADD CONSTRAINT uk_trashcan_user UNIQUE (trashcan_id, user_id);


--
-- Name: idx_latitude_longitude; Type: INDEX; Schema: public; Owner: jupddang
--

CREATE INDEX idx_latitude_longitude ON public.trashcans USING btree (latitude, longitude);


--
-- Name: idx_raid_ranking; Type: INDEX; Schema: public; Owner: jupddang
--

CREATE INDEX idx_raid_ranking ON public.raid_record USING btree (boss_id, total_score DESC, updated_at);


--
-- Name: idx_status; Type: INDEX; Schema: public; Owner: jupddang
--

CREATE INDEX idx_status ON public.trashcans USING btree (status);


--
-- Name: follow fk3p4y9ghyxbcl8n2egyxjx1k5e; Type: FK CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.follow
    ADD CONSTRAINT fk3p4y9ghyxbcl8n2egyxjx1k5e FOREIGN KEY (following_id) REFERENCES public.account(user_id);


--
-- Name: ploggings fk3sdl8kvtfbwqibdm2y51bycx4; Type: FK CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.ploggings
    ADD CONSTRAINT fk3sdl8kvtfbwqibdm2y51bycx4 FOREIGN KEY (user_id) REFERENCES public.account(user_id);


--
-- Name: post fk4f62kobdc0890vctu2jq5tcvq; Type: FK CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.post
    ADD CONSTRAINT fk4f62kobdc0890vctu2jq5tcvq FOREIGN KEY (user_id) REFERENCES public.account(user_id);


--
-- Name: trashcan_verifications fkcdyy7twpvrhnxx71mk7392asp; Type: FK CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.trashcan_verifications
    ADD CONSTRAINT fkcdyy7twpvrhnxx71mk7392asp FOREIGN KEY (user_id) REFERENCES public.account(user_id);


--
-- Name: trashcan_verifications fkcnyr6g39byi8gdh3dpcynaw7k; Type: FK CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.trashcan_verifications
    ADD CONSTRAINT fkcnyr6g39byi8gdh3dpcynaw7k FOREIGN KEY (trashcan_id) REFERENCES public.trashcans(id);


--
-- Name: party_member fkctrpcp93h130dwe6j1jlhf960; Type: FK CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.party_member
    ADD CONSTRAINT fkctrpcp93h130dwe6j1jlhf960 FOREIGN KEY (party_id) REFERENCES public.party(id);


--
-- Name: raid_record fkepptotytcciu9ip3c2swtqmfr; Type: FK CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.raid_record
    ADD CONSTRAINT fkepptotytcciu9ip3c2swtqmfr FOREIGN KEY (boss_id) REFERENCES public.raid_boss(id);


--
-- Name: party_activity fkke7lvro2nvqtduc27ihw8e2jx; Type: FK CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.party_activity
    ADD CONSTRAINT fkke7lvro2nvqtduc27ihw8e2jx FOREIGN KEY (plogging_id) REFERENCES public.ploggings(plogging_id);


--
-- Name: raid_record fkmwi3hkdp7btd08ao7siy7rfnt; Type: FK CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.raid_record
    ADD CONSTRAINT fkmwi3hkdp7btd08ao7siy7rfnt FOREIGN KEY (account_user_id) REFERENCES public.account(user_id);


--
-- Name: comment fkn84216vj612qs1eg5goe6n2lj; Type: FK CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT fkn84216vj612qs1eg5goe6n2lj FOREIGN KEY (user_id) REFERENCES public.account(user_id);


--
-- Name: follow fkr2kqnskllhun8dgwitqljvdyh; Type: FK CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.follow
    ADD CONSTRAINT fkr2kqnskllhun8dgwitqljvdyh FOREIGN KEY (follower_id) REFERENCES public.account(user_id);


--
-- Name: comment fks1slvnkuemjsq2kj4h3vhx7i1; Type: FK CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT fks1slvnkuemjsq2kj4h3vhx7i1 FOREIGN KEY (post_id) REFERENCES public.post(post_id);


--
-- Name: trashcans fktpgel6y6xhf1gr2jl2dq97e0g; Type: FK CONSTRAINT; Schema: public; Owner: jupddang
--

ALTER TABLE ONLY public.trashcans
    ADD CONSTRAINT fktpgel6y6xhf1gr2jl2dq97e0g FOREIGN KEY (reported_by) REFERENCES public.account(user_id);


--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8 (Debian 15.8-1.pgdg110+1)
-- Dumped by pg_dump version 15.8 (Debian 15.8-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE postgres;
--
-- Name: postgres; Type: DATABASE; Schema: -; Owner: jupddang
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C';


ALTER DATABASE postgres OWNER TO jupddang;

\connect postgres

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: jupddang
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- PostgreSQL database dump complete
--

--
-- Database "template_postgis" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8 (Debian 15.8-1.pgdg110+1)
-- Dumped by pg_dump version 15.8 (Debian 15.8-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: template_postgis; Type: DATABASE; Schema: -; Owner: jupddang
--

CREATE DATABASE template_postgis WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C';


ALTER DATABASE template_postgis OWNER TO jupddang;

\connect template_postgis

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: template_postgis; Type: DATABASE PROPERTIES; Schema: -; Owner: jupddang
--

ALTER DATABASE template_postgis IS_TEMPLATE = true;
ALTER DATABASE template_postgis SET search_path TO '$user', 'public', 'topology', 'tiger';


\connect template_postgis

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: jupddang
--

CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO jupddang;

--
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: jupddang
--

CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO jupddang;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: jupddang
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO jupddang;

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: jupddang
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- Name: postgis_tiger_geocoder; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder WITH SCHEMA tiger;


--
-- Name: EXTENSION postgis_tiger_geocoder; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_tiger_geocoder IS 'PostGIS tiger geocoder and reverse geocoder';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: jupddang
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: geocode_settings; Type: TABLE DATA; Schema: tiger; Owner: jupddang
--

COPY tiger.geocode_settings (name, setting, unit, category, short_desc) FROM stdin;
\.


--
-- Data for Name: pagc_gaz; Type: TABLE DATA; Schema: tiger; Owner: jupddang
--

COPY tiger.pagc_gaz (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_lex; Type: TABLE DATA; Schema: tiger; Owner: jupddang
--

COPY tiger.pagc_lex (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_rules; Type: TABLE DATA; Schema: tiger; Owner: jupddang
--

COPY tiger.pagc_rules (id, rule, is_custom) FROM stdin;
\.


--
-- Data for Name: topology; Type: TABLE DATA; Schema: topology; Owner: jupddang
--

COPY topology.topology (id, name, srid, "precision", hasz) FROM stdin;
\.


--
-- Data for Name: layer; Type: TABLE DATA; Schema: topology; Owner: jupddang
--

COPY topology.layer (topology_id, layer_id, schema_name, table_name, feature_column, feature_type, level, child_id) FROM stdin;
\.


--
-- Name: topology_id_seq; Type: SEQUENCE SET; Schema: topology; Owner: jupddang
--

SELECT pg_catalog.setval('topology.topology_id_seq', 1, false);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

