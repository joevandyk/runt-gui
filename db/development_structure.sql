--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: event_occurances; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE event_occurances (
    id integer NOT NULL,
    event_id integer,
    name character varying(255),
    start_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    end_at timestamp without time zone
);


--
-- Name: events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events (
    id integer NOT NULL,
    start_at timestamp without time zone,
    end_at timestamp without time zone,
    last_generated_event timestamp without time zone,
    repeat_weekly boolean,
    repeat_daily boolean,
    repeat_monthly boolean,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: schedule_details; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schedule_details (
    id integer NOT NULL,
    schedule_id integer,
    notes text,
    schedule_date timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: schedules; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schedules (
    id integer NOT NULL,
    name character varying(255),
    description text,
    schedule_description character varying(255),
    datetime_from timestamp without time zone,
    datetime_to timestamp without time zone,
    repeats character varying(255),
    all_day boolean,
    daily_repeat_every integer,
    daily_ends timestamp without time zone,
    daily_range character varying(255),
    weekly_repeat_every integer,
    weekly_ends timestamp without time zone,
    weekly_range character varying(255),
    wd0 boolean,
    wd1 boolean,
    wd2 boolean,
    wd3 boolean,
    wd4 boolean,
    wd5 boolean,
    wd6 boolean,
    monthly_repeat_every integer,
    monthly_repeat_by character varying(255),
    monthly_range character varying(255),
    monthly_ends timestamp without time zone,
    yearly_repeat_every integer,
    yearly_range character varying(255),
    yearly_ends timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    runt bytea
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: event_occurances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE event_occurances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: event_occurances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE event_occurances_id_seq OWNED BY event_occurances.id;


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- Name: schedule_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE schedule_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: schedule_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE schedule_details_id_seq OWNED BY schedule_details.id;


--
-- Name: schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE schedules_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE schedules_id_seq OWNED BY schedules.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE event_occurances ALTER COLUMN id SET DEFAULT nextval('event_occurances_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE schedule_details ALTER COLUMN id SET DEFAULT nextval('schedule_details_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE schedules ALTER COLUMN id SET DEFAULT nextval('schedules_id_seq'::regclass);


--
-- Name: event_occurances_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY event_occurances
    ADD CONSTRAINT event_occurances_pkey PRIMARY KEY (id);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: schedule_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY schedule_details
    ADD CONSTRAINT schedule_details_pkey PRIMARY KEY (id);


--
-- Name: schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY schedules
    ADD CONSTRAINT schedules_pkey PRIMARY KEY (id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20090304181501');

INSERT INTO schema_migrations (version) VALUES ('20090317215635');

INSERT INTO schema_migrations (version) VALUES ('20090327030913');

INSERT INTO schema_migrations (version) VALUES ('20090329212437');

INSERT INTO schema_migrations (version) VALUES ('20090329212540');

INSERT INTO schema_migrations (version) VALUES ('20090407225853');