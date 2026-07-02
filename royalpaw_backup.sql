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
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO postgres;

--
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO postgres;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO postgres;

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: postgres
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
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


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
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: banners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.banners (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying,
    image_url text NOT NULL,
    link character varying,
    sort_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    target text DEFAULT 'all'::text
);


ALTER TABLE public.banners OWNER TO postgres;

--
-- Name: bookings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bookings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    owner_id uuid,
    caretaker_id uuid,
    pet_id uuid,
    service_type character varying,
    status character varying DEFAULT 'pending'::character varying,
    scheduled_start timestamp with time zone,
    scheduled_end timestamp with time zone,
    amount_minor integer,
    currency character(3) DEFAULT 'AZN'::bpchar,
    created_at timestamp with time zone DEFAULT now(),
    live_lat double precision,
    live_lng double precision,
    live_updated_at timestamp with time zone,
    tracking_active boolean DEFAULT false
);


ALTER TABLE public.bookings OWNER TO postgres;

--
-- Name: conversations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.conversations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    owner_id uuid,
    caretaker_id uuid,
    last_message_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.conversations OWNER TO postgres;

--
-- Name: hotel_addons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hotel_addons (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    price_minor integer NOT NULL,
    currency character(3) DEFAULT 'AZN'::bpchar,
    icon character varying DEFAULT 'plus'::character varying,
    sort_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.hotel_addons OWNER TO postgres;

--
-- Name: hotel_rooms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hotel_rooms (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    description text,
    price_minor integer NOT NULL,
    currency character(3) DEFAULT 'AZN'::bpchar,
    photo_url text,
    sort_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.hotel_rooms OWNER TO postgres;

--
-- Name: membership_plans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.membership_plans (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    description text,
    price_minor integer NOT NULL,
    currency character(3) DEFAULT 'AZN'::bpchar,
    period character varying DEFAULT 'month'::character varying,
    features text,
    is_popular boolean DEFAULT false,
    sort_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.membership_plans OWNER TO postgres;

--
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    conversation_id uuid,
    sender_id uuid,
    body text,
    created_at timestamp with time zone DEFAULT now(),
    read_at timestamp with time zone,
    type character varying DEFAULT 'text'::character varying,
    audio_url text,
    audio_duration integer,
    product_name text,
    product_photo text,
    product_price integer,
    product_qty integer,
    sale_id uuid,
    sale_status text,
    edited boolean DEFAULT false
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- Name: monitoring_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.monitoring_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    booking_id uuid,
    note text,
    photo_url text,
    lat double precision,
    lng double precision,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.monitoring_logs OWNER TO postgres;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    title character varying NOT NULL,
    body text,
    icon character varying DEFAULT 'bell'::character varying,
    is_read boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    link text
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: otp_codes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.otp_codes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email character varying NOT NULL,
    code character varying NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    used boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.otp_codes OWNER TO postgres;

--
-- Name: payment_card; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_card (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    card_number character varying,
    holder_name character varying,
    expiry character varying,
    bank_name character varying,
    iban character varying,
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.payment_card OWNER TO postgres;

--
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    booking_id uuid,
    amount_minor integer NOT NULL,
    currency character(3) DEFAULT 'AZN'::bpchar,
    status character varying DEFAULT 'requires_payment'::character varying,
    held_at timestamp with time zone,
    released_at timestamp with time zone,
    refunded_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- Name: pets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pets (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    owner_id uuid,
    name character varying NOT NULL,
    species character varying NOT NULL,
    breed character varying,
    age_months integer,
    weight_kg numeric,
    notes text,
    photo_url text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.pets OWNER TO postgres;

--
-- Name: product_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    seller_id uuid,
    event_type text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.product_events OWNER TO postgres;

--
-- Name: product_images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_images (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    image_url text NOT NULL,
    sort_order integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.product_images OWNER TO postgres;

--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    description text,
    brand character varying,
    price_minor integer NOT NULL,
    currency character(3) DEFAULT 'AZN'::bpchar,
    photo_url text,
    category character varying DEFAULT 'food'::character varying,
    rating numeric(2,1) DEFAULT 5.0,
    stock integer DEFAULT 0,
    sort_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    seller_id uuid
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reviews (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    booking_id uuid,
    caretaker_id uuid,
    owner_id uuid,
    rating integer NOT NULL,
    comment text,
    pet_photo_url text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.reviews OWNER TO postgres;

--
-- Name: sales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    seller_id uuid NOT NULL,
    buyer_id uuid NOT NULL,
    conversation_id uuid,
    product_name text NOT NULL,
    product_photo text,
    amount_minor integer NOT NULL,
    qty integer DEFAULT 1,
    commission_minor integer DEFAULT 0,
    status text DEFAULT 'pending'::text,
    created_at timestamp with time zone DEFAULT now(),
    confirmed_at timestamp with time zone,
    buyer_confirmed text DEFAULT 'pending'::text,
    seller_confirmed text DEFAULT 'pending'::text,
    dispute boolean DEFAULT false
);


ALTER TABLE public.sales OWNER TO postgres;

--
-- Name: services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.services (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    description text,
    price_minor integer NOT NULL,
    currency character(3) DEFAULT 'AZN'::bpchar,
    icon character varying DEFAULT 'pawPrint'::character varying,
    category character varying DEFAULT 'general'::character varying,
    sort_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    image_url text
);


ALTER TABLE public.services OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    role character varying DEFAULT 'owner'::character varying NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    patronymic character varying,
    email character varying,
    phone character varying,
    id_card_serial character varying,
    address text,
    avatar_url text,
    is_phone_verified boolean DEFAULT false,
    kyc_status character varying DEFAULT 'pending'::character varying,
    is_active boolean DEFAULT true,
    password_hash character varying(255),
    points integer DEFAULT 0,
    membership_tier character varying DEFAULT 'free'::character varying,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    services text,
    last_seen timestamp with time zone,
    commission_debt integer DEFAULT 0,
    is_suspended boolean DEFAULT false,
    oldest_debt_at timestamp with time zone,
    payment_pending boolean DEFAULT false,
    total_earnings integer DEFAULT 0,
    refusal_count integer DEFAULT 0,
    payment_receipt text
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Data for Name: banners; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.banners (id, title, image_url, link, sort_order, is_active, created_at, target) FROM stdin;
27c8daec-272f-46e4-9b9b-b7cb1d9001e7		/uploads/1782417353001-388462965.png	\N	0	t	2026-06-25 19:55:54.423699+00	all
007d35ba-93c2-4c0b-b753-b3f0fc69eb6e		/uploads/1782417359558-359115877.png	\N	1	t	2026-06-25 19:56:05.92397+00	all
\.


--
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookings (id, owner_id, caretaker_id, pet_id, service_type, status, scheduled_start, scheduled_end, amount_minor, currency, created_at, live_lat, live_lng, live_updated_at, tracking_active) FROM stdin;
8369c541-9acd-407f-90a5-001406446b3a	3e6bd262-af1c-4c5b-9866-29a99cfe6a3d	3e6bd262-af1c-4c5b-9866-29a99cfe6a3d	d41e9f03-f9a4-4429-ad4f-6535364ae889	walking	completed	2026-06-19 11:34:40.099+00	\N	1500	AZN	2026-06-18 11:34:47.587327+00	\N	\N	\N	f
8e482bea-2413-437a-bf9a-90de80071203	c85303cb-a3c5-4067-a504-bbadfd14f7cc	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	560f117c-d247-471a-a1cd-a980c7523b1c	Müvəqqəti sahiblənmə	completed	2026-06-25 13:11:47.691+00	\N	5000	AZN	2026-06-24 13:11:53.024842+00	\N	\N	\N	f
8d081e4a-1817-4d31-b0d4-a999843165b5	c85303cb-a3c5-4067-a504-bbadfd14f7cc	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	12781d72-7435-4a38-b42b-8183d676bd65	Tük baxımı	completed	2026-06-28 13:11:54.247+00	\N	2500	AZN	2026-06-27 13:11:57.40402+00	\N	\N	\N	f
2de11d09-16dd-4bc0-aef3-68e6700402c3	c85303cb-a3c5-4067-a504-bbadfd14f7cc	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	560f117c-d247-471a-a1cd-a980c7523b1c	Tük baxımı	completed	2026-06-17 20:00:00+00	\N	2500	AZN	2026-06-18 15:48:22.310151+00	\N	\N	\N	f
1a8c3616-9052-45e8-9c5c-2a6f63e3f0e6	c85303cb-a3c5-4067-a504-bbadfd14f7cc	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	560f117c-d247-471a-a1cd-a980c7523b1c	Tük baxımı	completed	2026-06-19 15:47:58.288+00	\N	2500	AZN	2026-06-18 15:48:03.375439+00	\N	\N	\N	f
13196883-339d-4421-a3c3-a325c4b841c1	c85303cb-a3c5-4067-a504-bbadfd14f7cc	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	560f117c-d247-471a-a1cd-a980c7523b1c	Dırnaq kəsimi	completed	2026-06-26 20:00:00+00	\N	1000	AZN	2026-06-25 19:59:26.063842+00	\N	\N	\N	f
242bff8b-754b-4964-ad37-31091036c39b	c85303cb-a3c5-4067-a504-bbadfd14f7cc	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	560f117c-d247-471a-a1cd-a980c7523b1c	Tük baxımı	completed	2026-06-19 16:04:20.732+00	\N	2500	AZN	2026-06-18 16:04:22.223697+00	\N	\N	\N	f
faf11da0-ba00-4a3d-85e3-67142c3fb248	c85303cb-a3c5-4067-a504-bbadfd14f7cc	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	560f117c-d247-471a-a1cd-a980c7523b1c	Tük baxımı	cancelled	2026-06-24 07:40:51.311+00	\N	2500	AZN	2026-06-23 07:40:54.976311+00	\N	\N	\N	f
b747bd3f-96e8-4cdb-85f3-1c44a8f760a9	c85303cb-a3c5-4067-a504-bbadfd14f7cc	3e6bd262-af1c-4c5b-9866-29a99cfe6a3d	560f117c-d247-471a-a1cd-a980c7523b1c	Tük baxımı	cancelled	2026-06-24 07:41:52.371+00	\N	2500	AZN	2026-06-23 07:41:53.81411+00	\N	\N	\N	f
fe761176-d44a-4ebc-a70d-f30762af3932	c85303cb-a3c5-4067-a504-bbadfd14f7cc	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	560f117c-d247-471a-a1cd-a980c7523b1c	Tük baxımı	cancelled	2026-06-24 07:47:16.286+00	\N	2500	AZN	2026-06-23 07:47:18.110866+00	\N	\N	\N	f
97c21f0c-dc19-479f-a0fd-c6615c8c2b42	c85303cb-a3c5-4067-a504-bbadfd14f7cc	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	560f117c-d247-471a-a1cd-a980c7523b1c	Müvəqqəti sahiblənmə	cancelled	2026-06-24 07:47:47.084+00	\N	5000	AZN	2026-06-23 07:47:51.078254+00	\N	\N	\N	f
3a9caa37-f136-4147-b153-78c562f18a6e	27140ea0-6aea-43ae-a522-21da2dac88be	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	63b814cb-23d0-4b75-ae1a-1fbedb749948	Tük baxımı	completed	2026-06-25 12:05:41.582+00	\N	2500	AZN	2026-06-24 12:05:43.614576+00	\N	\N	\N	f
bb2afbae-245f-40c7-87f3-8f1d1a60ace8	c85303cb-a3c5-4067-a504-bbadfd14f7cc	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	560f117c-d247-471a-a1cd-a980c7523b1c	Spa & Masaj	completed	2026-06-25 07:01:44.339+00	\N	3500	AZN	2026-06-24 07:01:48.388778+00	\N	\N	\N	f
962a4c7e-7ad4-4ff5-9324-88f31fd2e034	c85303cb-a3c5-4067-a504-bbadfd14f7cc	bb05fe95-90a3-46f7-b303-a72a4a30a3b7	560f117c-d247-471a-a1cd-a980c7523b1c	Tük baxımı	completed	2026-06-25 07:01:21.854+00	\N	2500	AZN	2026-06-24 07:01:23.662826+00	\N	\N	\N	f
894c7a16-41ec-403c-bb45-39dbf7dbc277	c85303cb-a3c5-4067-a504-bbadfd14f7cc	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	560f117c-d247-471a-a1cd-a980c7523b1c	Gəzdirmə	completed	2026-06-27 21:15:00.409+00	\N	1500	AZN	2026-06-26 21:15:05.719464+00	40.327401196071456	49.824584194260666	2026-06-26 21:40:41.439+00	t
f67b4bd9-cc35-431e-9eb3-106a62950a99	27140ea0-6aea-43ae-a522-21da2dac88be	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	63b814cb-23d0-4b75-ae1a-1fbedb749948	Tük baxımı	completed	2026-06-25 12:06:49.966+00	\N	2500	AZN	2026-06-24 12:06:51.729418+00	\N	\N	\N	f
f8531f43-49ed-4634-8ad1-01dd794704f8	c85303cb-a3c5-4067-a504-bbadfd14f7cc	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	560f117c-d247-471a-a1cd-a980c7523b1c	Tük baxımı	completed	2026-06-27 12:03:27.908+00	\N	2500	AZN	2026-06-26 12:03:28.952185+00	\N	\N	\N	f
9ebc5400-4a56-4805-a722-354497047807	c85303cb-a3c5-4067-a504-bbadfd14f7cc	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	560f117c-d247-471a-a1cd-a980c7523b1c	Tük baxımı	completed	2026-06-25 12:34:21.533+00	\N	2500	AZN	2026-06-24 12:34:23.595075+00	\N	\N	\N	f
eb373001-fd08-40ab-99cb-ddc283cc93e0	c85303cb-a3c5-4067-a504-bbadfd14f7cc	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	988f025c-c4ac-4e2f-b8e3-8a4073bf394d	Müvəqqəti sahiblənmə	completed	2026-06-25 12:41:11.639+00	\N	5000	AZN	2026-06-24 12:41:17.230214+00	\N	\N	\N	f
0c739b96-363a-4eac-848e-6bb583ed4680	c85303cb-a3c5-4067-a504-bbadfd14f7cc	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	12781d72-7435-4a38-b42b-8183d676bd65	Gəzdirmə	completed	2026-06-27 16:09:02.369+00	\N	1500	AZN	2026-06-26 16:09:10.108777+00	\N	\N	\N	f
1faf3e14-f688-43dc-8cee-91b6dbef85ab	c85303cb-a3c5-4067-a504-bbadfd14f7cc	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	560f117c-d247-471a-a1cd-a980c7523b1c	Tük baxımı	completed	2026-06-25 12:54:09.388+00	\N	2500	AZN	2026-06-24 12:54:10.464449+00	\N	\N	\N	f
ff7dbf32-d372-4e5b-af8c-fe371a371f8e	c85303cb-a3c5-4067-a504-bbadfd14f7cc	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	12781d72-7435-4a38-b42b-8183d676bd65	Tük baxımı	completed	2026-06-27 16:54:47.041+00	\N	2500	AZN	2026-06-26 16:54:53.158645+00	\N	\N	\N	f
e4913c6e-892d-480c-b8e6-1bc9b7c94c20	c85303cb-a3c5-4067-a504-bbadfd14f7cc	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	560f117c-d247-471a-a1cd-a980c7523b1c	Tük baxımı	completed	2026-06-27 16:47:37.5+00	\N	2500	AZN	2026-06-26 16:47:40.396695+00	\N	\N	\N	f
20f66c5a-28d4-4f03-90e7-0b1eef627b97	c85303cb-a3c5-4067-a504-bbadfd14f7cc	3e6bd262-af1c-4c5b-9866-29a99cfe6a3d	560f117c-d247-471a-a1cd-a980c7523b1c	walking	cancelled	2026-06-19 11:35:09.373+00	\N	1500	AZN	2026-06-18 11:35:10.533587+00	40.4093	49.8671	2026-06-26 21:06:08.213+00	t
8d3ff42d-2b78-4a9f-af91-5d27cba004be	c85303cb-a3c5-4067-a504-bbadfd14f7cc	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	560f117c-d247-471a-a1cd-a980c7523b1c	Tük baxımı	completed	2026-06-27 22:07:18.233+00	\N	2500	AZN	2026-06-26 22:07:19.489618+00	40.32746757783591	49.824615046256795	2026-06-27 12:04:07.224+00	t
b64fc5ea-9610-4147-8a26-0b34b91a5e50	c85303cb-a3c5-4067-a504-bbadfd14f7cc	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	988f025c-c4ac-4e2f-b8e3-8a4073bf394d	Tük baxımı	completed	2026-06-28 12:58:16.827+00	\N	2500	AZN	2026-06-27 12:58:22.207549+00	\N	\N	\N	f
317923e7-f03f-4306-b461-514a0820d53f	c85303cb-a3c5-4067-a504-bbadfd14f7cc	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	12781d72-7435-4a38-b42b-8183d676bd65	Tük baxımı	completed	2026-06-28 13:04:42.48+00	\N	2500	AZN	2026-06-27 13:04:46.12651+00	\N	\N	\N	f
\.


--
-- Data for Name: conversations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.conversations (id, owner_id, caretaker_id, last_message_at, created_at) FROM stdin;
102ec7c4-2b53-4c72-8d1a-245dfd3cb0c3	3e6bd262-af1c-4c5b-9866-29a99cfe6a3d	3e6bd262-af1c-4c5b-9866-29a99cfe6a3d	2026-06-18 11:18:28.105+00	2026-06-18 11:18:24.006484+00
17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	2026-06-26 11:43:32.242+00	2026-06-18 12:05:47.931633+00
684f2e94-d22f-4fa7-854f-ff8414d90593	27140ea0-6aea-43ae-a522-21da2dac88be	fb1c3204-d8e1-46b2-b3b5-2a24fca12f0b	2026-06-24 08:40:59.447508+00	2026-06-24 08:40:59.447508+00
20df9a84-14dc-43ea-a422-294585b73253	27140ea0-6aea-43ae-a522-21da2dac88be	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	2026-06-24 12:06:45.962676+00	2026-06-24 12:06:45.962676+00
312fc216-f4c3-43b5-8dd6-776b518e0399	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	2026-06-27 13:24:45.782+00	2026-06-25 10:20:18.785913+00
0035837c-29d0-41ab-85a3-23d4975b0167	48073758-4052-49a1-a25f-41a35e8f0a7e	bb05fe95-90a3-46f7-b303-a72a4a30a3b7	2026-06-25 18:53:55.066+00	2026-06-25 18:53:53.314162+00
\.


--
-- Data for Name: hotel_addons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hotel_addons (id, name, price_minor, currency, icon, sort_order, is_active, created_at) FROM stdin;
17f14be8-1e2c-4974-b85c-8c5027586979	Canlı kamera	1000	AZN	video	1	t	2026-06-17 13:20:28.573849+00
3fa881fc-d5b9-4ebc-89e7-d1c65e963436	Əlavə oyun vaxtı	1500	AZN	gamepad2	2	t	2026-06-17 13:20:28.573849+00
11a0b1fb-9757-46b6-a3b9-f7d97d3dd904	Premium yemək	2000	AZN	utensilsCrossed	3	t	2026-06-17 13:20:28.573849+00
\.


--
-- Data for Name: hotel_rooms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hotel_rooms (id, name, description, price_minor, currency, photo_url, sort_order, is_active, created_at) FROM stdin;
3eee447d-76e2-4852-8f6a-59b2f896139e	Standard	Rahat və təhlükəsiz gündəlik qulluq	4000	AZN	\N	1	t	2026-06-17 13:20:28.571877+00
b1ea866a-7da9-45e2-99f6-43902802338d	Premium	Geniş otaq, kamera və premium yemək	7000	AZN	\N	2	t	2026-06-17 13:20:28.571877+00
52dfda09-43c6-42e1-b361-f3f3f4459e60	VIP Suite	Canlı kamera, geniş oyun sahəsi, lüks otaq	12000	AZN	\N	3	t	2026-06-17 13:20:28.571877+00
\.


--
-- Data for Name: membership_plans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.membership_plans (id, name, description, price_minor, currency, period, features, is_popular, sort_order, is_active, created_at) FROM stdin;
771315cd-0fe7-4236-b375-4b4d6195ca4a	Basic	Başlanğıc plan	0	AZN	month	Əsas xidmətlər;Standart dəstək	f	1	t	2026-06-17 13:20:28.575413+00
f4957bb3-53fc-408c-aaba-e3234d67cd05	Premium	Ən populyar plan	1500	AZN	month	10% endirim;Prioritet dəstək;Pulsuz çatdırılma	t	2	t	2026-06-17 13:20:28.575413+00
f990a22b-06c7-4f66-8e54-fa3b98b1ea8e	Royal	Premium üzvlük	3000	AZN	month	20% endirim;VIP dəstək;Pulsuz otel 1 gecə	f	3	t	2026-06-17 13:20:28.575413+00
\.


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.messages (id, conversation_id, sender_id, body, created_at, read_at, type, audio_url, audio_duration, product_name, product_photo, product_price, product_qty, sale_id, sale_status, edited) FROM stdin;
be1b7e09-2bf5-47e8-a533-71ffc10bea3e	102ec7c4-2b53-4c72-8d1a-245dfd3cb0c3	3e6bd262-af1c-4c5b-9866-29a99cfe6a3d	xcxc	2026-06-18 11:18:26.258837+00	\N	text	\N	\N	\N	\N	\N	\N	\N	\N	f
fa74efc9-d712-444b-ad56-8cdefdc2e36a	102ec7c4-2b53-4c72-8d1a-245dfd3cb0c3	3e6bd262-af1c-4c5b-9866-29a99cfe6a3d	xcxcx	2026-06-18 11:18:28.100682+00	\N	text	\N	\N	\N	\N	\N	\N	\N	\N	f
465d9236-5163-4192-911e-846e55c2884e	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	salam	2026-06-18 16:25:08.709422+00	2026-06-18 16:25:28.322+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
ef53768b-d98c-4cea-9ccb-e16b85663025	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	necesen	2026-06-18 16:25:13.638259+00	2026-06-18 16:25:28.322+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
8660946d-4b8e-4579-93c1-693c55c9dceb	17f4f070-185c-4511-a93e-3a89cabad729	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	yaxsitayam sen	2026-06-18 16:25:33.996454+00	2026-06-18 16:25:48.18+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
21b27709-744f-478c-8536-94f543dbb031	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	ssdsd	2026-06-19 11:59:54.980233+00	2026-06-19 12:00:10.018+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
15939b60-588c-4b1d-a9bc-729447d747e5	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	asasas	2026-06-19 12:09:55.940221+00	2026-06-19 12:10:31.169+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
eec769d3-8603-4800-a850-dfc6ea3d62b3	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	sdsdsd	2026-06-19 12:09:58.470684+00	2026-06-19 12:10:31.169+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
f7f2db0b-cf79-49e0-a108-22a3c3019b2c	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	Salam	2026-06-23 07:48:06.318838+00	2026-06-25 10:38:09.068+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
5f595304-ddb6-47af-bc5f-efdb03aebc1f	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	🛒 Sifariş:\n• sdsds x1 — 3 AZN\nÜmumi: 3 AZN	2026-06-23 09:01:21.438109+00	2026-06-25 10:38:09.068+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
ebc326e7-1984-4a98-8a9f-6a79858eb83e	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	🛒 Sifariş:\n• sdsds x4 — 12 AZN\nÜmumi: 12 AZN	2026-06-23 09:02:09.289197+00	2026-06-25 10:38:09.068+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
d694e249-1797-4891-858a-2c2e0ed653f8	17f4f070-185c-4511-a93e-3a89cabad729	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	dfdfdfdf	2026-06-25 10:38:12.171667+00	2026-06-25 10:38:31.954+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
b326b5a1-9d88-4b72-80a5-52429e9612b0	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	sadsdad	2026-06-25 10:38:34.390725+00	2026-06-25 11:12:58.728+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
c01a8beb-a6ab-4848-8e1f-2a1a5a739b52	17f4f070-185c-4511-a93e-3a89cabad729	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	dsfdfdfsdf	2026-06-25 11:13:00.680304+00	2026-06-25 11:13:40.549+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
88a74592-18a7-4b37-bcba-d14439d3c649	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	fdsfsdfsdfsdfsdf	2026-06-25 11:13:42.974532+00	2026-06-25 11:15:45.454+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
178caf87-4580-423d-8d96-4a58dc7cfcc7	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	sdfsdfsdf	2026-06-25 11:13:45.10814+00	2026-06-25 11:15:45.454+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
f7ff49a5-6887-4c2c-9e11-56a2137163be	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	sdfsfsdf	2026-06-25 11:13:46.406911+00	2026-06-25 11:15:45.454+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
203c3a72-da6d-4df8-b43c-1849b965e232	17f4f070-185c-4511-a93e-3a89cabad729	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	DSFSDFSF	2026-06-25 11:15:47.365996+00	2026-06-25 11:34:54.899+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
a16353f3-6846-4cd5-991b-219c3aa61c3d	17f4f070-185c-4511-a93e-3a89cabad729	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	SDFSFSDF	2026-06-25 11:15:48.776843+00	2026-06-25 11:34:54.899+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
c34869ac-076f-4b4c-a698-67698714e730	17f4f070-185c-4511-a93e-3a89cabad729	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	sdsdsdsd	2026-06-25 11:34:35.907027+00	2026-06-25 11:34:54.899+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
f3abea41-a234-4d6c-a4d3-1eb89139f76a	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	🛒 Sifariş:\n• sdsds x1 — 3 AZN\nÜmumi: 3 AZN	2026-06-25 18:00:58.698118+00	2026-06-25 18:04:13.26+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
df2cbd70-e80a-4e83-96c4-1ee68f25bcc4	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	\N	2026-06-25 18:02:05.980973+00	2026-06-25 18:04:13.26+00	audio	/uploads/1782410525962-134505233.webm	3	\N	\N	\N	\N	\N	\N	f
e6da3d97-9156-4242-8dd3-f4299dcebf7f	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	\N	2026-06-25 18:02:26.386154+00	2026-06-25 18:04:13.26+00	audio	/uploads/1782410546338-502259535.webm	13	\N	\N	\N	\N	\N	\N	f
a083097b-373f-4609-89a8-2f50d37cc110	0035837c-29d0-41ab-85a3-23d4975b0167	bb05fe95-90a3-46f7-b303-a72a4a30a3b7	Test link mesaji	2026-06-25 18:53:55.052345+00	\N	text	\N	\N	\N	\N	\N	\N	\N	\N	f
c744b458-c95b-418c-a702-bdb2d1660a93	17f4f070-185c-4511-a93e-3a89cabad729	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	salam	2026-06-25 18:58:17.734258+00	2026-06-25 18:58:38.273+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
6e4142d6-bc6c-45fa-b90b-e29a4ccddd58	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	necesen?	2026-06-25 18:58:42.693965+00	2026-06-25 18:59:08.105+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
b34be1dd-6dba-4240-b348-d03048d12f44	312fc216-f4c3-43b5-8dd6-776b518e0399	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	🛒 Yeni sifariş! Bu məhsulları almaq istəyirəm:	2026-06-25 19:18:14.762984+00	\N	text	\N	\N	\N	\N	\N	\N	\N	\N	f
43915f9a-63fc-4c7e-a98d-9ac9a9af555b	312fc216-f4c3-43b5-8dd6-776b518e0399	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	\N	2026-06-25 19:18:14.8068+00	\N	product	\N	\N	sdsds	/uploads/1782205260582-603746885.jpg	300	1	\N	\N	f
c03f72b6-740e-4a2f-b51d-9508a75cfa96	312fc216-f4c3-43b5-8dd6-776b518e0399	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	💰 Ümumi: 3 AZN\nRazılaşmaq üçün yazın 👇	2026-06-25 19:18:14.836887+00	\N	text	\N	\N	\N	\N	\N	\N	\N	\N	f
8e5b1921-3039-4a2e-a809-6f71f159d7b2	312fc216-f4c3-43b5-8dd6-776b518e0399	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	🛒 Yeni sifariş! Bu məhsulları almaq istəyirəm:	2026-06-25 19:19:44.749642+00	\N	text	\N	\N	\N	\N	\N	\N	\N	\N	f
0a554d3e-7947-4be3-ade9-516f2b414401	312fc216-f4c3-43b5-8dd6-776b518e0399	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	\N	2026-06-25 19:19:44.79189+00	\N	product	\N	\N	sdsds	/uploads/1782205260582-603746885.jpg	300	1	\N	\N	f
a5810064-17b5-47a0-adc0-a04bba485ef4	312fc216-f4c3-43b5-8dd6-776b518e0399	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	💰 Ümumi: 3 AZN\nRazılaşmaq üçün yazın 👇	2026-06-25 19:19:44.832656+00	\N	text	\N	\N	\N	\N	\N	\N	\N	\N	f
8a02f9b6-c94c-45f8-8460-1fb5f1920462	312fc216-f4c3-43b5-8dd6-776b518e0399	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	salam	2026-06-25 19:19:50.227067+00	\N	text	\N	\N	\N	\N	\N	\N	\N	\N	f
1285c7d8-5271-4077-bd1c-4c5cd0ad5dcf	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	🛒 Yeni sifariş! Bu məhsulları almaq istəyirəm:	2026-06-25 19:20:25.844936+00	2026-06-25 19:33:35.307+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
78924f73-ff85-435a-930e-d38af8d377d9	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	\N	2026-06-25 19:20:25.883825+00	2026-06-25 19:33:35.307+00	product	\N	\N	sdsds	/uploads/1782205260582-603746885.jpg	300	1	\N	\N	f
314869af-2e7a-4406-bbbf-ef6450be37b7	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	💰 Ümumi: 3 AZN\nRazılaşmaq üçün yazın 👇	2026-06-25 19:20:25.922499+00	2026-06-25 19:33:35.307+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
f38d44b0-8695-4da9-aa0c-8b35b1e9a3d3	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	🛒 Yeni sifariş! Bu məhsulları almaq istəyirəm:	2026-06-25 19:25:55.621716+00	2026-06-25 19:33:35.307+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
89c66801-6404-407e-8b1c-0a155016afee	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	\N	2026-06-25 19:25:55.673667+00	2026-06-25 19:33:35.307+00	product	\N	\N	sdsds	/uploads/1782205260582-603746885.jpg	300	1	\N	\N	f
66191e8c-d246-48db-b455-00db504ab6c5	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	💰 Ümumi: 3 AZN\nRazılaşmaq üçün yazın 👇	2026-06-25 19:25:55.710472+00	2026-06-25 19:33:35.307+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
9b326c51-12a1-46b3-bd71-f9dab60b7235	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	\N	2026-06-25 19:26:45.106318+00	2026-06-25 19:33:35.307+00	product	\N	\N	sdsds	/uploads/1782205260582-603746885.jpg	300	2	\N	\N	f
76f6627b-0fb0-4c27-b302-5562f3309105	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	💰 Ümumi: 6 AZN\nRazılaşmaq üçün yazın 👇	2026-06-25 19:26:45.139628+00	2026-06-25 19:33:35.307+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
1168e6e2-589e-49e4-a073-eb819c33a0bf	312fc216-f4c3-43b5-8dd6-776b518e0399	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	🛒 Yeni sifariş! Bu məhsulları almaq istəyirəm:	2026-06-25 20:41:20.495017+00	\N	text	\N	\N	\N	\N	\N	\N	\N	\N	f
6bd0f8fe-0fe2-4a03-a4fd-07835739d5ca	312fc216-f4c3-43b5-8dd6-776b518e0399	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	\N	2026-06-25 20:41:20.595493+00	\N	product	\N	\N	it yemeyi	\N	2500	1	a3cf81e9-9b11-445a-b5a1-a5ec6bdfc926	pending	f
3d780aa8-2f27-4a94-983b-aa47dd57d0b4	312fc216-f4c3-43b5-8dd6-776b518e0399	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	💰 Ümumi: 25 AZN\nRazılaşmaq üçün yazın 👇	2026-06-25 20:41:20.647411+00	\N	text	\N	\N	\N	\N	\N	\N	\N	\N	f
7728e71a-ea68-4a0f-ae86-d6bd74085836	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	\N	2026-06-25 20:42:18.854991+00	2026-06-25 20:42:50.371+00	product	\N	\N	it yemeyi	\N	2500	1	922afcdf-e3f2-4daa-8fe6-183581e7da9d	pending	f
84c69b24-7762-453b-a3e9-fa20373fe746	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	💰 Ümumi: 25 AZN\nRazılaşmaq üçün yazın 👇	2026-06-25 20:42:18.895512+00	2026-06-25 20:42:50.371+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
d784db90-eb08-4f00-b14a-5c79ef1ace0c	17f4f070-185c-4511-a93e-3a89cabad729	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	cads	2026-06-25 20:42:59.266384+00	2026-06-25 20:53:21.849+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
a64744f3-4630-4455-91d5-c8861d769b56	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	🛒 Yeni sifariş! Bu məhsulları almaq istəyirəm:	2026-06-25 21:01:10.532591+00	2026-06-25 21:01:51.369+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
624e99ba-502c-4cf4-8a2c-6e0f5577f2b9	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	\N	2026-06-25 21:01:10.626429+00	2026-06-25 21:01:51.369+00	product	\N	\N	it yemeyi	\N	2500	1	f7615948-01b6-474b-9b27-9a24502bc456	pending	f
9b28ca14-33ce-4068-9b6e-d47ec55d9a16	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	💰 Ümumi: 25 AZN\nRazılaşmaq üçün yazın 👇	2026-06-25 21:01:10.665235+00	2026-06-25 21:01:51.369+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
a0a81a8a-d5ac-4eb0-adb4-9097cf4fa307	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	🛒 Yeni sifariş! Bu məhsulları almaq istəyirəm:	2026-06-26 11:23:49.092118+00	2026-06-26 11:44:03.488+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
78ff2db4-9491-47fc-b70c-fbd452c81ffa	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	\N	2026-06-26 11:23:49.313907+00	2026-06-26 11:44:03.488+00	product	\N	\N	it yemeyi	\N	2500	1	289201b8-b392-417b-a2ab-942bcfd740e3	pending	f
c968a39d-2eb2-4ed6-94f8-777336329c35	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	💰 Ümumi: 25 AZN\nRazılaşmaq üçün yazın 👇	2026-06-26 11:23:49.44492+00	2026-06-26 11:44:03.488+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
343a100e-1a47-4f39-989f-2943562559f6	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	🛒 Yeni sifariş! Bu məhsulları almaq istəyirəm:	2026-06-26 11:43:31.744413+00	2026-06-26 11:44:03.488+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
4cca8f04-379e-4208-961b-e0038df11eec	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	\N	2026-06-26 11:43:32.085001+00	2026-06-26 11:44:03.488+00	product	\N	\N	it yemeyi	\N	2500	1	8b58c940-2a3f-43b8-a5e3-ab1731ac6ebe	pending	f
04a86331-1a9f-4425-a7a5-66e623bcf1dd	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	💰 Ümumi: 25 AZN\nRazılaşmaq üçün yazın 👇	2026-06-26 11:43:32.22661+00	2026-06-26 11:44:03.488+00	text	\N	\N	\N	\N	\N	\N	\N	\N	f
09d5f900-a8fd-4bcd-bbc6-d2d5bb5914b0	312fc216-f4c3-43b5-8dd6-776b518e0399	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	🛒 Yeni sifariş! Bu məhsulları almaq istəyirəm:	2026-06-26 15:55:22.474517+00	\N	text	\N	\N	\N	\N	\N	\N	\N	\N	f
d5a8e28e-edc3-41d8-b3bd-da66b8e5c788	312fc216-f4c3-43b5-8dd6-776b518e0399	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	\N	2026-06-26 15:55:22.603111+00	\N	product	\N	\N	it yemeyi	\N	2500	2	7efaa95d-156e-4ad9-beb3-59b822db1930	pending	f
8a8954e8-9110-4b9a-a818-d7848bb18581	312fc216-f4c3-43b5-8dd6-776b518e0399	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	redakt? test	2026-06-26 15:55:22.651321+00	\N	text	\N	\N	\N	\N	\N	\N	\N	\N	t
0844829f-e747-4f3d-a280-3e78c4885c18	17f4f070-185c-4511-a93e-3a89cabad729	c85303cb-a3c5-4067-a504-bbadfd14f7cc	🛒 Yeni sifariş! Bu məhsulları almaq istəyirə	2026-06-25 20:42:18.778046+00	2026-06-25 20:42:50.371+00	text	\N	\N	\N	\N	\N	\N	\N	\N	t
773e6c73-adca-43cf-a5b4-8a2b65b75ac9	312fc216-f4c3-43b5-8dd6-776b518e0399	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	🛒 Yeni sifariş! Bu məhsulları almaq istəyirəm:	2026-06-27 13:24:45.657091+00	\N	text	\N	\N	\N	\N	\N	\N	\N	\N	f
e6ab5918-202b-4248-9daf-d2e35ae8dc6c	312fc216-f4c3-43b5-8dd6-776b518e0399	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	\N	2026-06-27 13:24:45.743367+00	\N	product	\N	\N	Savic Picnic 1 İt və pişik üçün plastik yem qabı, 300 ml (Göy)	/uploads/1782563115354-972661770.jpg	300	1	2c2492f1-7248-48ce-b0d7-b0a6a248ea9c	pending	f
a0c65bec-1f92-452d-918d-17a8a653093e	312fc216-f4c3-43b5-8dd6-776b518e0399	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	💰 Ümumi: 3 AZN\nRazılaşmaq üçün yazın 👇	2026-06-27 13:24:45.778797+00	\N	text	\N	\N	\N	\N	\N	\N	\N	\N	f
\.


--
-- Data for Name: monitoring_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.monitoring_logs (id, booking_id, note, photo_url, lat, lng, created_at) FROM stdin;
526f41d7-73ee-4ccd-bd0d-b23be386c527	1a8c3616-9052-45e8-9c5c-2a6f63e3f0e6	\N	/uploads/1781797733421-837610086.jpg	40.4093	49.8671	2026-06-18 15:48:53.483154+00
19419662-7e32-4ddd-86e4-be04308ea0b5	242bff8b-754b-4964-ad37-31091036c39b	sdsdsdsd	/uploads/1781798687489-40834170.jpg	40.4093	49.8671	2026-06-18 16:04:47.595038+00
9dc925ed-20ec-4f4c-a14d-849bc273848a	242bff8b-754b-4964-ad37-31091036c39b	sdsdsd	/uploads/1781799063001-977146331.jpg	40.4093	49.8671	2026-06-18 16:11:03.071669+00
83dc8f41-2ed7-463c-a620-87f199032c5b	0c739b96-363a-4eac-848e-6bb583ed4680	\N	/uploads/1782490237010-208066042.png	40.4093	49.8671	2026-06-26 16:10:37.104158+00
376a7f76-7e60-4166-bda5-c4c318d75efe	8d3ff42d-2b78-4a9f-af91-5d27cba004be	gezintideyik	/uploads/1782561836548-656710888.png	40.4093	49.8671	2026-06-27 12:03:56.605036+00
52d065c6-ceb6-4e79-a7cb-95731d4d5431	8d3ff42d-2b78-4a9f-af91-5d27cba004be	\N	/uploads/1782561850972-4844046.png	40.4093	49.8671	2026-06-27 12:04:11.040318+00
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, user_id, title, body, icon, is_read, created_at, link) FROM stdin;
74c7a051-e9f5-4765-97af-98f43fa04ddb	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	🎤 Səsli mesaj	messageCircle	t	2026-06-25 18:02:26.443528+00	\N
4debf615-1ef3-489f-a5a7-54394784301b	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	🎤 Səsli mesaj	messageCircle	t	2026-06-25 18:02:05.994394+00	\N
9ece5fc1-b523-4629-a669-ad43905ddca0	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	🛒 Sifariş:\n• sdsds x1 — 3 AZN\nÜmumi: 3 AZN	messageCircle	t	2026-06-25 18:00:58.728084+00	\N
3d5c9e90-51a0-4ca8-bdf3-a1963a50fdd5	48073758-4052-49a1-a25f-41a35e8f0a7e	Yeni mesaj	Test link mesaji	messageCircle	f	2026-06-25 18:53:55.086953+00	chat:0035837c-29d0-41ab-85a3-23d4975b0167
d29f412a-c5d0-4b79-ab54-8aad68552819	c85303cb-a3c5-4067-a504-bbadfd14f7cc	Yeni mesaj	salam	messageCircle	t	2026-06-25 18:58:17.746891+00	chat:17f4f070-185c-4511-a93e-3a89cabad729
a2dfd50c-0894-470e-8f51-78fc00e424e6	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	necesen?	messageCircle	t	2026-06-25 18:58:42.707292+00	chat:17f4f070-185c-4511-a93e-3a89cabad729
b6a03598-f48e-4dc1-a6a9-641a2a57f135	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj		messageCircle	t	2026-06-25 19:26:45.113749+00	chat:17f4f070-185c-4511-a93e-3a89cabad729
f6635660-1115-4548-a34d-c7f983f48634	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	🛒 Yeni sifariş! Bu məhsulları almaq istəyirəm:	messageCircle	t	2026-06-25 19:26:45.084949+00	chat:17f4f070-185c-4511-a93e-3a89cabad729
e63f04d3-c9da-4ead-b92e-72836d97888e	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	💰 Ümumi: 3 AZN\nRazılaşmaq üçün yazın 👇	messageCircle	t	2026-06-25 19:25:55.718359+00	chat:17f4f070-185c-4511-a93e-3a89cabad729
feb3f81e-a599-434d-b8f8-34eb845975a6	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj		messageCircle	t	2026-06-25 19:25:55.682603+00	chat:17f4f070-185c-4511-a93e-3a89cabad729
f747b84e-467d-444e-bbf8-f890e5e38ae2	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	🛒 Yeni sifariş! Bu məhsulları almaq istəyirəm:	messageCircle	t	2026-06-25 19:25:55.639123+00	chat:17f4f070-185c-4511-a93e-3a89cabad729
502b6ef7-4908-4d81-95a6-6133ea924947	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	💰 Ümumi: 3 AZN\nRazılaşmaq üçün yazın 👇	messageCircle	t	2026-06-25 19:20:25.930931+00	chat:17f4f070-185c-4511-a93e-3a89cabad729
03f58112-23a3-4a93-b00f-62e4309ae0c0	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj		messageCircle	t	2026-06-25 19:20:25.892689+00	chat:17f4f070-185c-4511-a93e-3a89cabad729
c5e10073-432a-4b32-81ab-a3f887550607	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	salam	messageCircle	t	2026-06-25 19:19:50.237377+00	chat:312fc216-f4c3-43b5-8dd6-776b518e0399
776ca080-b1a2-48ab-b624-e21ebb787902	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	💰 Ümumi: 3 AZN\nRazılaşmaq üçün yazın 👇	messageCircle	t	2026-06-25 19:19:44.841266+00	chat:312fc216-f4c3-43b5-8dd6-776b518e0399
5862d926-f4b6-4fad-a269-2255d560f67f	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj		messageCircle	t	2026-06-25 19:19:44.80126+00	chat:312fc216-f4c3-43b5-8dd6-776b518e0399
c77c213a-66c1-4363-a0db-16655ca16a64	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	🛒 Yeni sifariş! Bu məhsulları almaq istəyirəm:	messageCircle	t	2026-06-25 19:19:44.760106+00	chat:312fc216-f4c3-43b5-8dd6-776b518e0399
da44a3c5-c770-425e-ba2a-0257dedd0788	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	💰 Ümumi: 3 AZN\nRazılaşmaq üçün yazın 👇	messageCircle	t	2026-06-25 19:18:14.846004+00	chat:312fc216-f4c3-43b5-8dd6-776b518e0399
5c51c703-5f56-415d-822d-c5383d506542	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj		messageCircle	t	2026-06-25 19:18:14.815358+00	chat:312fc216-f4c3-43b5-8dd6-776b518e0399
07a00308-9135-48b6-a254-b2920f25747f	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	🛒 Yeni sifariş! Bu məhsulları almaq istəyirəm:	messageCircle	t	2026-06-25 19:18:14.778026+00	chat:312fc216-f4c3-43b5-8dd6-776b518e0399
f34a152e-f869-400b-9bc1-c00347eb10d0	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	💰 Ümumi: 6 AZN\nRazılaşmaq üçün yazın 👇	messageCircle	t	2026-06-25 19:26:45.148678+00	chat:17f4f070-185c-4511-a93e-3a89cabad729
497a57a7-6411-4065-8a5e-93d015547f0f	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	🛒 Yeni sifariş! Bu məhsulları almaq istəyirəm:	messageCircle	t	2026-06-25 19:20:25.854375+00	chat:17f4f070-185c-4511-a93e-3a89cabad729
2a59a12d-eabc-4ff2-ac75-72e8fcba6660	c85303cb-a3c5-4067-a504-bbadfd14f7cc	Yeni mesaj	cads	messageCircle	t	2026-06-25 20:42:59.27729+00	chat:17f4f070-185c-4511-a93e-3a89cabad729
913595f3-8e92-4bdc-b097-1adf37f2c650	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj		messageCircle	t	2026-06-26 15:55:22.615047+00	chat:312fc216-f4c3-43b5-8dd6-776b518e0399
b642bd82-c136-4477-b255-2b50f106cd17	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	🛒 Yeni sifariş! Bu məhsulları almaq istəyirəm:	messageCircle	t	2026-06-26 15:55:22.499577+00	chat:312fc216-f4c3-43b5-8dd6-776b518e0399
26495cd7-a384-431f-bd7f-0a4a34bdf7ef	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	💰 Ümumi: 25 AZN\nRazılaşmaq üçün yazın 👇	messageCircle	t	2026-06-26 11:43:32.263443+00	chat:17f4f070-185c-4511-a93e-3a89cabad729
85dffc6b-158c-4b31-8554-d3a881ff4968	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj		messageCircle	t	2026-06-26 11:43:32.118151+00	chat:17f4f070-185c-4511-a93e-3a89cabad729
abcb9916-8d7a-48a2-8f0f-07c74e75473f	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	🛒 Yeni sifariş! Bu məhsulları almaq istəyirəm:	messageCircle	t	2026-06-26 11:43:31.807926+00	chat:17f4f070-185c-4511-a93e-3a89cabad729
bb3db426-41ad-4364-a170-9246fa528248	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	💰 Ümumi: 25 AZN\nRazılaşmaq üçün yazın 👇	messageCircle	t	2026-06-26 11:23:49.477039+00	chat:17f4f070-185c-4511-a93e-3a89cabad729
a12d75b1-fb87-4d1c-b4b4-6f7b9f895551	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj		messageCircle	t	2026-06-26 11:23:49.347524+00	chat:17f4f070-185c-4511-a93e-3a89cabad729
c9f4d316-7546-47e9-9282-0ac6e451c0f3	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	🛒 Yeni sifariş! Bu məhsulları almaq istəyirəm:	messageCircle	t	2026-06-26 11:23:49.132071+00	chat:17f4f070-185c-4511-a93e-3a89cabad729
6413ccea-9782-42f9-bcc2-4a234724304a	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	💰 Ümumi: 25 AZN\nRazılaşmaq üçün yazın 👇	messageCircle	t	2026-06-25 21:01:10.673628+00	chat:17f4f070-185c-4511-a93e-3a89cabad729
77e61c63-0ecb-4cca-80b2-1def980038ec	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj		messageCircle	t	2026-06-25 21:01:10.635624+00	chat:17f4f070-185c-4511-a93e-3a89cabad729
88976643-fd8e-4c6f-a21d-287526559900	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	🛒 Yeni sifariş! Bu məhsulları almaq istəyirəm:	messageCircle	t	2026-06-25 21:01:10.546658+00	chat:17f4f070-185c-4511-a93e-3a89cabad729
6ef69521-e7ba-41b3-94d3-9f6d8b3f1033	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	💰 Ümumi: 25 AZN\nRazılaşmaq üçün yazın 👇	messageCircle	t	2026-06-25 20:42:18.904353+00	chat:17f4f070-185c-4511-a93e-3a89cabad729
566f45a0-8d98-4cb8-b428-1f7083733ca0	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj		messageCircle	t	2026-06-25 20:42:18.864227+00	chat:17f4f070-185c-4511-a93e-3a89cabad729
7625a003-0054-4d59-b850-25203dde96fb	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	🛒 Yeni sifariş! Bu məhsulları almaq istəyirəm:	messageCircle	t	2026-06-25 20:42:18.788776+00	chat:17f4f070-185c-4511-a93e-3a89cabad729
ec952e0f-70ec-48fe-92fb-1e30b36a6678	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	💰 Ümumi: 25 AZN\nRazılaşmaq üçün yazın 👇	messageCircle	t	2026-06-25 20:41:20.65837+00	chat:312fc216-f4c3-43b5-8dd6-776b518e0399
a81f6fb8-676c-41e7-aace-24db59de0f78	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj		messageCircle	t	2026-06-25 20:41:20.606096+00	chat:312fc216-f4c3-43b5-8dd6-776b518e0399
8df9cb11-6304-480d-9f32-050a6f3e66ac	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	🛒 Yeni sifariş! Bu məhsulları almaq istəyirəm:	messageCircle	t	2026-06-25 20:41:20.509108+00	chat:312fc216-f4c3-43b5-8dd6-776b518e0399
90ea1bdf-f36b-4e57-a877-98994eaa034b	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	💰 Ümumi: 50 AZN\nRazılaşmaq üçün yazın 👇	messageCircle	t	2026-06-26 15:55:22.663997+00	chat:312fc216-f4c3-43b5-8dd6-776b518e0399
65480e58-6b71-49d7-9d5e-445c1530cb9d	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni sifariş 🎉	Yeni xidmət sifarişi aldınız. Sifarişlərim bölməsinə baxın.	clipboardList	t	2026-06-26 16:47:40.413795+00	bookings
f4af6311-a127-40db-88b5-e277c9eae0f1	c85303cb-a3c5-4067-a504-bbadfd14f7cc	Yeni nəzarət qeydi	Sevimliniz haqqında yeni yenilik əlavə olundu. Baxmaq üçün toxunun.	eye	t	2026-06-26 16:10:37.113945+00	\N
a33d2a16-498c-46ef-b5d2-97dcaa5ca35a	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni sifariş 🎉	Yeni xidmət sifarişi aldınız. Sifarişlərim bölməsinə baxın.	clipboardList	t	2026-06-26 16:54:53.176338+00	bookings
893e98a1-c543-4ff2-b448-00c379bd6e77	fb1c3204-d8e1-46b2-b3b5-2a24fca12f0b	Yeni mesaj	dsfsfsf	messageCircle	f	2026-06-26 22:31:15.61096+00	chat:14660c7a-3a7e-4157-a9e6-47a7cdbd5220
784f2220-a7ba-4a90-b7eb-b8261aa0d8a1	c85303cb-a3c5-4067-a504-bbadfd14f7cc	Yeni nəzarət qeydi	Sevimliniz haqqında yeni yenilik əlavə olundu. Baxmaq üçün toxunun.	eye	t	2026-06-27 12:04:11.046449+00	\N
41680f68-cbea-40f2-8312-d51208f0401b	c85303cb-a3c5-4067-a504-bbadfd14f7cc	Yeni nəzarət qeydi	Sevimliniz haqqında yeni yenilik əlavə olundu. Baxmaq üçün toxunun.	eye	t	2026-06-27 12:03:56.612133+00	\N
ff10cd83-a1c7-4577-8f85-38c8067ce731	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni sifariş 🎉	Yeni xidmət sifarişi aldınız. Sifarişlərim bölməsinə baxın.	clipboardList	t	2026-06-26 22:07:19.496659+00	bookings
bd4f7722-9981-4c4c-bb8a-940988e6faf5	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni sifariş 🎉	Yeni xidmət sifarişi aldınız. Sifarişlərim bölməsinə baxın.	clipboardList	t	2026-06-26 21:15:05.732682+00	bookings
c35aef99-5e8b-4f6f-bd90-f5ef8be8e25f	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	💰 Ümumi: 3 AZN\nRazılaşmaq üçün yazın 👇	messageCircle	t	2026-06-27 13:24:45.787535+00	chat:312fc216-f4c3-43b5-8dd6-776b518e0399
1fd39046-14e2-4dc4-80a7-f5a831ff8a76	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj		messageCircle	t	2026-06-27 13:24:45.751972+00	chat:312fc216-f4c3-43b5-8dd6-776b518e0399
c59db03c-f71a-439c-b923-5046d580091b	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni mesaj	🛒 Yeni sifariş! Bu məhsulları almaq istəyirəm:	messageCircle	t	2026-06-27 13:24:45.675735+00	chat:312fc216-f4c3-43b5-8dd6-776b518e0399
05ef83a7-e1f2-428b-907b-80e4c5b510a7	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni sifariş 🎉	Yeni xidmət sifarişi aldınız. Sifarişlərim bölməsinə baxın.	clipboardList	t	2026-06-27 13:11:57.414559+00	bookings
eab7a572-87af-4e40-8502-a0a01798977e	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni sifariş 🎉	Yeni xidmət sifarişi aldınız. Sifarişlərim bölməsinə baxın.	clipboardList	t	2026-06-27 13:04:46.13289+00	bookings
99749589-b8a4-441f-bb71-49555df6e596	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	Yeni sifariş 🎉	Yeni xidmət sifarişi aldınız. Sifarişlərim bölməsinə baxın.	clipboardList	t	2026-06-27 12:58:22.213512+00	bookings
\.


--
-- Data for Name: otp_codes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.otp_codes (id, email, code, expires_at, used, created_at) FROM stdin;
7e3085fa-244d-4335-9b9e-e779061b1b16	SENIN_EMAIL@gmail.com	195903	2026-06-23 06:42:26.138+00	f	2026-06-23 06:32:26.143192+00
8977eb24-b8c4-4e79-96bb-45c4dad082e1	cavadmusayev055@gmail.com	220845	2026-06-23 06:43:28.597+00	f	2026-06-23 06:33:28.608173+00
00e6a7cd-27be-4dfb-8b61-ba3188b958a6	cavadmusayev055@gmail.com	207836	2026-06-23 06:48:31.611+00	f	2026-06-23 06:38:31.620971+00
e315c85f-8027-4b7a-9c21-a6df630cbc9b	cavadmusayev055@gmail.com	216080	2026-06-23 06:49:31.758+00	f	2026-06-23 06:39:31.774778+00
41d298f8-df61-496b-a934-25a88457dba5	cavadmusayev055@gmail.com	219279	2026-06-23 06:54:43.053+00	t	2026-06-23 06:44:43.064006+00
11c1f491-e7f0-4e75-8b97-a1a10bf1b102	cavadmusayev055@gmail.com	651731	2026-06-24 14:01:25.597+00	t	2026-06-24 13:51:25.612062+00
\.


--
-- Data for Name: payment_card; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_card (id, card_number, holder_name, expiry, bank_name, iban, updated_at) FROM stdin;
57629038-194d-4415-80e1-2801bdca9301	4169 7388 2533 7441	Cavad Musayev	12/28	Kapital Bank	AZ00NABZ00000000000000000000	2026-06-24 12:50:23.011046+00
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (id, booking_id, amount_minor, currency, status, held_at, released_at, refunded_at, created_at) FROM stdin;
dfcde0d8-7945-4316-a3e3-995c01554df7	20f66c5a-28d4-4f03-90e7-0b1eef627b97	1500	AZN	held_in_escrow	2026-06-18 12:06:01.106+00	\N	\N	2026-06-18 12:06:01.079444+00
59a50c99-8aaf-41dd-ba1c-a83acd6cf405	1a8c3616-9052-45e8-9c5c-2a6f63e3f0e6	2500	AZN	held_in_escrow	2026-06-18 15:49:25.789+00	\N	\N	2026-06-18 15:49:25.763373+00
49f1c0cc-e01c-414c-9e1d-9d7984138b4e	2de11d09-16dd-4bc0-aef3-68e6700402c3	2500	AZN	held_in_escrow	2026-06-18 15:49:26.847+00	\N	\N	2026-06-18 15:49:26.819845+00
df79c73e-abf6-4f6c-9291-cba1fece720e	242bff8b-754b-4964-ad37-31091036c39b	2500	AZN	held_in_escrow	2026-06-23 05:59:27.399+00	\N	\N	2026-06-23 05:59:27.372909+00
\.


--
-- Data for Name: pets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pets (id, owner_id, name, species, breed, age_months, weight_kg, notes, photo_url, created_at) FROM stdin;
d41e9f03-f9a4-4429-ad4f-6535364ae889	3e6bd262-af1c-4c5b-9866-29a99cfe6a3d	saas	cat	sss	22	\N	\N	\N	2026-06-18 11:11:07.957832+00
63b814cb-23d0-4b75-ae1a-1fbedb749948	27140ea0-6aea-43ae-a522-21da2dac88be	ccc	dog	cxc	22	\N	\N	\N	2026-06-24 12:05:35.749037+00
988f025c-c4ac-4e2f-b8e3-8a4073bf394d	c85303cb-a3c5-4067-a504-bbadfd14f7cc	Boob	dog	Oggusto	3	2	\N	/uploads/1782564638758-548406928.jpg	2026-06-18 12:06:36.418404+00
12781d72-7435-4a38-b42b-8183d676bd65	c85303cb-a3c5-4067-a504-bbadfd14f7cc	Cesi	dog	Afcarka	2	\N	\N	/uploads/1782564657253-416406748.webp	2026-06-26 16:04:30.521183+00
560f117c-d247-471a-a1cd-a980c7523b1c	c85303cb-a3c5-4067-a504-bbadfd14f7cc	Keşa	bird	Avstraliya Papuqayi	2	0.4	\N	/uploads/1782564709935-287969075.jfif	2026-06-18 10:29:35.193049+00
\.


--
-- Data for Name: product_events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_events (id, product_id, seller_id, event_type, created_at) FROM stdin;
8eb4dfc3-e375-4ae5-a26e-880611b81b7a	96642342-73cd-4344-b103-10b099c32b75	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	view	2026-06-26 17:15:27.253638+00
d35188a4-7b42-4564-8990-c7fc64a13faa	96642342-73cd-4344-b103-10b099c32b75	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	view	2026-06-26 21:44:21.182247+00
4f370718-121f-40e4-8ca5-f5dd6996d5e8	96642342-73cd-4344-b103-10b099c32b75	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	view	2026-06-26 22:10:11.196399+00
1deea10c-1ec5-4146-802b-51f618e44db0	78908d5b-d148-4bab-a414-ad472eeab45e	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	view	2026-06-27 12:22:34.614966+00
2619daf1-8439-4c20-b9b8-56d2add0ae98	def0df1e-cbd9-44fe-ab25-c91a278206f8	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	view	2026-06-27 13:24:36.531164+00
18112d24-fc8a-4fdd-8bdd-c417afbefce6	78908d5b-d148-4bab-a414-ad472eeab45e	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	view	2026-06-27 13:35:39.037589+00
3753548b-474b-432d-b698-3c8fc628af09	00a0df1e-aabd-4265-916b-5a9a25361f18	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	view	2026-06-27 13:35:42.117393+00
83c28333-ada4-4660-9779-af3c54875693	4f899662-ed72-4fdf-815d-9d0a762a1de5	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	view	2026-06-27 13:35:44.087964+00
880f3dbd-fb5a-427f-9c47-c32cd9a9588d	86320b70-23ff-4989-b060-cce156e61965	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	view	2026-06-27 13:35:47.529725+00
23c78566-60e6-486a-8be6-36cf82c7b78e	c420c0e0-3b0c-4942-87a8-de83feb5f008	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	view	2026-06-28 20:21:12.299018+00
\.


--
-- Data for Name: product_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_images (id, product_id, image_url, sort_order, created_at) FROM stdin;
5f69b1a8-fe2e-4893-82b2-fbae4a204e82	96642342-73cd-4344-b103-10b099c32b75	/uploads/1782491709895-897897252.png	0	2026-06-26 16:35:09.933846+00
110e37cc-d53f-4776-a5a3-bb62656cd133	96642342-73cd-4344-b103-10b099c32b75	/uploads/1782491709961-379422340.png	1	2026-06-26 16:35:09.996539+00
7006ec9a-9da7-4143-a37d-12e92409ca0f	78908d5b-d148-4bab-a414-ad472eeab45e	/uploads/1782562949982-571286835.jpg	0	2026-06-27 12:22:30.016191+00
aa2c0d9d-6870-4095-96f8-d3ce46f7e01d	86320b70-23ff-4989-b060-cce156e61965	/uploads/1782563097556-58625909.jpg	0	2026-06-27 12:24:57.595178+00
5bb9e6ea-954b-4664-b64c-d3a4a9e3c3d5	86320b70-23ff-4989-b060-cce156e61965	/uploads/1782563097627-731963135.jpg	1	2026-06-27 12:24:57.662329+00
c6987e4b-5dc5-4d45-8595-07173fe01ca7	d81b47ec-b91e-4961-9ae7-48d6864c5696	/uploads/1782563285198-963820505.jpg	0	2026-06-27 12:28:05.220737+00
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, name, description, brand, price_minor, currency, photo_url, category, rating, stock, sort_order, is_active, created_at, seller_id) FROM stdin;
78908d5b-d148-4bab-a414-ad472eeab45e	Royal Canin Mini Adult Kiçik cins yetkin it üçün quru yem, 10 aydan (kq)Royal Canin Mini Adult Kiçik cins yetkin it üçün quru yem, 10 aydan (kq)	Royal Canin Mini Adult Kiçik cins yetkin it üçün quru yem, 10 aydan (kq)	\N	1590	AZN	/uploads/1782562949846-528729770.png	food	5.0	1	0	t	2026-06-27 12:22:29.941732+00	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7
c420c0e0-3b0c-4942-87a8-de83feb5f008	Royal Canin Babydog Milk Bala it üçün quru süd, 100 q	Royal Canin Babydog Milk Bala it üçün quru süd, 100 q	\N	500	AZN	/uploads/1782562986467-370587623.jpg	food	5.0	1	0	t	2026-06-27 12:23:06.55189+00	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7
00a0df1e-aabd-4265-916b-5a9a25361f18	Royal Canin Maxi Adult Böyük cins yetkin it üçün quru yem, 15 aydan (kq)	Royal Canin Maxi Adult Böyük cins yetkin it üçün quru yem, 15 aydan (kq)	\N	1390	AZN	/uploads/1782563013335-400965293.png	food	5.0	1	0	t	2026-06-27 12:23:33.435943+00	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7
4f899662-ed72-4fdf-815d-9d0a762a1de5	Royal Canin Maxi Adult Böyük cins yetkin it üçün quru yem, 15 aydan (kq)	Royal Canin Maxi Adult Böyük cins yetkin it üçün quru yem, 15 aydan (kq)	\N	9000	AZN	/uploads/1782563057377-715190716.jpg	accessory	5.0	1	0	t	2026-06-27 12:24:17.408871+00	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7
86320b70-23ff-4989-b060-cce156e61965	Beeztees Parinca Pişik və it üçün xalta, qara (20 mm/35-40 sm)	Beeztees Parinca Pişik və it üçün xalta, qara (20 mm/35-40 sm)	\N	1300	AZN	/uploads/1782563097434-483937820.jpg	accessory	5.0	1	0	t	2026-06-27 12:24:57.522662+00	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7
def0df1e-cbd9-44fe-ab25-c91a278206f8	Savic Picnic 1 İt və pişik üçün plastik yem qabı, 300 ml (Göy)	Savic Picnic 1 İt və pişik üçün plastik yem qabı, 300 ml (Göy)	\N	300	AZN	/uploads/1782563115354-972661770.jpg	accessory	5.0	1	0	t	2026-06-27 12:25:15.432355+00	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7
1f6d7227-0d84-4a14-96c3-d4f6836e7140	Beeztees Karlie Furmaster furminator (trimmer-daraq) itlər və pişiklər üçün, 100 mm	Beeztees Karlie Furmaster furminator (trimmer-daraq) itlər və pişiklər üçün, 100 mm	\N	3500	AZN	/uploads/1782563243407-213306362.jpg	accessory	5.0	1	0	t	2026-06-27 12:27:23.469757+00	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7
d81b47ec-b91e-4961-9ae7-48d6864c5696	Flexi New Classic XS İt üçün tənzimlənən lentli xalta qayışı, qırmızı (XS 12 kq, 3 m)	Flexi New Classic XS İt üçün tənzimlənən lentli xalta qayışı, qırmızı (XS 12 kq, 3 m)	\N	26100	AZN	/uploads/1782563285130-646794369.jpg	accessory	5.0	1	0	t	2026-06-27 12:28:05.180717+00	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reviews (id, booking_id, caretaker_id, owner_id, rating, comment, pet_photo_url, created_at) FROM stdin;
7e8277ff-932e-4183-a373-2e60f4d81251	2de11d09-16dd-4bc0-aef3-68e6700402c3	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	c85303cb-a3c5-4067-a504-bbadfd14f7cc	10	\N	\N	2026-06-18 15:49:20.326748+00
fb327158-3753-43a8-8f9b-3237dfd6bd53	1a8c3616-9052-45e8-9c5c-2a6f63e3f0e6	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	c85303cb-a3c5-4067-a504-bbadfd14f7cc	9	\N	\N	2026-06-18 15:49:23.55256+00
fa2a6087-2576-4534-bc7a-d8f0fde5765b	242bff8b-754b-4964-ad37-31091036c39b	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	c85303cb-a3c5-4067-a504-bbadfd14f7cc	9	Helal	\N	2026-06-18 16:11:37.21886+00
355a97c6-5224-44c7-8731-547ab5d7a440	8e482bea-2413-437a-bf9a-90de80071203	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	c85303cb-a3c5-4067-a504-bbadfd14f7cc	10	\N	\N	2026-06-24 13:13:51.372028+00
521636fb-f423-4ccb-a956-7c96f5e5f67f	1faf3e14-f688-43dc-8cee-91b6dbef85ab	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	c85303cb-a3c5-4067-a504-bbadfd14f7cc	2	\N	\N	2026-06-24 13:13:56.349851+00
ee11b9b9-6098-423e-802c-c5badcc68705	8d3ff42d-2b78-4a9f-af91-5d27cba004be	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	c85303cb-a3c5-4067-a504-bbadfd14f7cc	10	Əla idi çox təşəkkür edirəm	\N	2026-06-27 12:57:22.643388+00
11ba4758-bd58-421b-b580-576708715fe3	b64fc5ea-9610-4147-8a26-0b34b91a5e50	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	c85303cb-a3c5-4067-a504-bbadfd14f7cc	10	Möhtəşəm	\N	2026-06-27 12:59:14.150816+00
8bb0e733-955f-4d06-81d6-e4a1669fc603	317923e7-f03f-4306-b461-514a0820d53f	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	c85303cb-a3c5-4067-a504-bbadfd14f7cc	10	Əla möhtəşəmm	\N	2026-06-27 13:05:40.720673+00
6d66edf2-00df-4023-811c-90713f9ebfb2	8d081e4a-1817-4d31-b0d4-a999843165b5	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	c85303cb-a3c5-4067-a504-bbadfd14f7cc	10	Çox yaxşı	\N	2026-06-27 13:12:35.864133+00
\.


--
-- Data for Name: sales; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales (id, seller_id, buyer_id, conversation_id, product_name, product_photo, amount_minor, qty, commission_minor, status, created_at, confirmed_at, buyer_confirmed, seller_confirmed, dispute) FROM stdin;
a3cf81e9-9b11-445a-b5a1-a5ec6bdfc926	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	312fc216-f4c3-43b5-8dd6-776b518e0399	it yemeyi	\N	2500	1	125	pending	2026-06-25 20:41:20.55402+00	\N	pending	pending	f
922afcdf-e3f2-4daa-8fe6-183581e7da9d	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	c85303cb-a3c5-4067-a504-bbadfd14f7cc	17f4f070-185c-4511-a93e-3a89cabad729	it yemeyi	\N	2500	1	125	confirmed	2026-06-25 20:42:18.817692+00	2026-06-25 20:53:26.058+00	pending	pending	f
f7615948-01b6-474b-9b27-9a24502bc456	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	c85303cb-a3c5-4067-a504-bbadfd14f7cc	17f4f070-185c-4511-a93e-3a89cabad729	it yemeyi	\N	2500	1	125	confirmed	2026-06-25 21:01:10.588182+00	2026-06-25 21:01:20.9+00	pending	pending	f
289201b8-b392-417b-a2ab-942bcfd740e3	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	c85303cb-a3c5-4067-a504-bbadfd14f7cc	17f4f070-185c-4511-a93e-3a89cabad729	it yemeyi	\N	2500	1	125	pending	2026-06-26 11:23:49.212653+00	\N	pending	no	f
7efaa95d-156e-4ad9-beb3-59b822db1930	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	312fc216-f4c3-43b5-8dd6-776b518e0399	it yemeyi	\N	5000	2	250	pending	2026-06-26 15:55:22.548577+00	\N	yes	pending	f
8b58c940-2a3f-43b8-a5e3-ab1731ac6ebe	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	c85303cb-a3c5-4067-a504-bbadfd14f7cc	17f4f070-185c-4511-a93e-3a89cabad729	it yemeyi	\N	2500	1	125	confirmed	2026-06-26 11:43:31.991188+00	2026-06-26 16:05:47.298+00	yes	yes	f
2c2492f1-7248-48ce-b0d7-b0a6a248ea9c	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	312fc216-f4c3-43b5-8dd6-776b518e0399	Savic Picnic 1 İt və pişik üçün plastik yem qabı, 300 ml (Göy)	/uploads/1782563115354-972661770.jpg	300	1	15	pending	2026-06-27 13:24:45.710022+00	\N	pending	pending	f
\.


--
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.services (id, name, description, price_minor, currency, icon, category, sort_order, is_active, created_at, image_url) FROM stdin;
e60cf6a3-00e9-43d4-9dd7-31d3faf1b24e	Tük baxımı	Peşəkar tük kəsimi və daraqlama	2500	AZN	scissors	general	1	t	2026-06-17 13:20:28.568075+00	/uploads/1782385375070-258559338.png
d18638ee-6ba8-46a6-9612-c680b3b0440d	Yuyunma	Şampun, qurutma və ətirləmə	2000	AZN	droplets	general	2	t	2026-06-17 13:20:28.568075+00	/uploads/1782385383246-712416620.png
43806cf2-de6f-4583-a99e-7401eac00839	Spa & Masaj	Rahatladıcı spa və masaj	3500	AZN	sparkles	general	3	t	2026-06-17 13:20:28.568075+00	/uploads/1782385389164-831541434.png
fc34dce3-ee3a-4a0b-b207-ea174b2dbe3b	Dırnaq kəsimi	Dırnaq kəsimi və baxımı	1000	AZN	scissors	general	4	t	2026-06-17 13:20:28.568075+00	/uploads/1782385394173-785561403.png
bf22890d-acb2-49c5-b7f9-34f1ae7b3b5d	Baytar yoxlaması	Ümumi sağlamlıq yoxlaması	4000	AZN	stethoscope	general	5	t	2026-06-17 13:20:28.568075+00	/uploads/1782385399374-57326445.png
3ab85157-5f3c-4bb5-a793-9a3dcbcdff9c	Gəzdirmə	Heyvanınızı gəzdirmə xidməti	1500	AZN	heart	general	6	t	2026-06-18 15:14:55.100237+00	/uploads/1782385404820-603722258.png
7b4c63e7-cdc1-4207-8b26-fc032cf709f2	Müvəqqəti sahiblənmə	Səfər zamanı heyvana baxım	5000	AZN	heart	general	7	t	2026-06-18 15:14:55.100237+00	/uploads/1782385409656-752249280.png
540f3cb0-aa4b-4605-a0a1-d2a54630a3e4	Evdə baxım	Evinizdə heyvana qulluq	3000	AZN	heart	general	8	t	2026-06-18 15:14:55.100237+00	/uploads/1782385414618-769075706.png
546b6d78-a4ee-4457-917e-166d07fa4389	Yemləmə	Vaxtlı-vaxtında yemləmə xidməti	1000	AZN	heart	general	9	t	2026-06-18 15:14:55.100237+00	/uploads/1782385419290-188520217.png
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, role, first_name, last_name, patronymic, email, phone, id_card_serial, address, avatar_url, is_phone_verified, kyc_status, is_active, password_hash, points, membership_tier, created_at, updated_at, services, last_seen, commission_debt, is_suspended, oldest_debt_at, payment_pending, total_earnings, refusal_count, payment_receipt) FROM stdin;
c9f4f08b-5076-44bf-a801-dc23d0c2f05c	admin	Admin	Royal	\N	admin@royalpaw.az	+994500000099	\N	\N	\N	f	approved	t	$2b$10$q.TdGfG7akAj6jY6IB3ki.M1JQZmOupQp7XnT7JPBVY6PutqS5CTe	0	free	2026-06-18 10:05:53.72921+00	2026-06-18 10:05:53.72921+00	\N	\N	0	f	\N	f	0	0	\N
c85303cb-a3c5-4067-a504-bbadfd14f7cc	owner	Cavad	Musayev	\N	cavadmusayev@gmail.com	+994503741153	\N	baki	/uploads/1782511585107-835925576.png	f	pending	t	$2b$10$GGiF9dx7J62MScSU7huVEOEpJEbOQ.rgXyxe9upcyXz/T51Hyk5SO	0	free	2026-06-18 10:28:21.311129+00	2026-06-30 14:24:34.169677+00	\N	2026-06-30 14:24:34.153+00	0	f	\N	f	0	0	\N
27140ea0-6aea-43ae-a522-21da2dac88be	owner	cavad	Musayev	\N	cavadmusayev055@gmail.com	+994503741159	\N	\N	\N	f	pending	t	$2b$10$qNyOXeJjtwcstxIpcVuYxOTlGx3yNknmurwXnIDnymBSfumOjk.Na	0	free	2026-06-23 06:45:01.914729+00	2026-06-24 13:52:49.562353+00	\N	2026-06-24 13:52:49.56+00	0	f	\N	f	0	0	\N
3e9ddd93-9923-4a45-91ac-02f0a7d1f1ab	caretaker	R?sad	?liyev	\N	\N	+994552222222	\N	\N	\N	f	pending	f	$2b$10$Ucq8i8mFz1.xpbdnnf4Z/OIc/JH6mrktrq7R2PrUNnCoMIjdVZooC	0	free	2026-06-18 15:58:29.148526+00	2026-06-23 07:10:12.816131+00	walking,vet	\N	0	f	\N	f	0	0	\N
5cd708a0-53d8-4f2e-a8ff-9c9b55f46edb	caretaker	G�nel	H�seynova	\N	\N	+994553333333	\N	\N	\N	f	pending	f	$2b$10$CCF/QliVsT0ho4ZdcPfkH.sC0Z7UQ/KQVC3knARX64aGT3sKwg3W.	0	free	2026-06-18 15:58:29.685015+00	2026-06-23 07:10:15.558429+00	spa,grooming,walking	\N	0	f	\N	f	0	0	\N
fb1c3204-d8e1-46b2-b3b5-2a24fca12f0b	caretaker	Test	test	\N	\N	+994503741157	\N	\N	\N	f	pending	f	$2b$10$uKYckOSShDgCHJP6k872I.BWZA92Fn4Rf4ypkyMMZCD/RkyI2mYRe	0	free	2026-06-18 15:57:32.693527+00	2026-06-27 12:28:57.200555+00	walking,vet	\N	0	f	\N	f	0	0	\N
3e6bd262-af1c-4c5b-9866-29a99cfe6a3d	caretaker	Nicat	Musayev	\N	\N	+994503741154	\N	\N	\N	f	pending	f	$2b$10$LZcwK.KGkm7cJBW5jpMXn.lZB4KCojzgXvP2/ermPGEGZdsTVYgtu	0	free	2026-06-18 10:30:56.999893+00	2026-06-27 12:29:00.648118+00	\N	\N	0	f	\N	f	0	0	\N
4651e8b5-0712-4686-8faf-1c04f66b2696	caretaker	Aysel	M?mm?dova	\N	\N	+994551111111	\N	\N	\N	f	pending	f	$2b$10$.QIeiJiT4IqfcDLOzTEb3ed34PdZiuDqwLljFuM/N7kBaIs0Q1meO	0	free	2026-06-18 15:58:28.558304+00	2026-06-23 07:10:39.926003+00	grooming,bathing	\N	0	f	\N	f	0	0	\N
bb05fe95-90a3-46f7-b303-a72a4a30a3b7	caretaker	cavadq	qulluqcu	\N	\N	+994503741155	\N	\N	\N	f	pending	f	$2b$10$9wM7vaV8e3a3wc3qcEJ8tuphse2lyHI8BtgWJbl5n3VjeoOFncGAa	0	free	2026-06-17 13:40:26.213633+00	2026-06-27 12:29:06.327911+00	walking,grooming,bathing	\N	0	f	\N	f	0	0	\N
48073758-4052-49a1-a25f-41a35e8f0a7e	owner	Cavad	Musayev	\N	\N	+994551234567	\N	Baki, N?simi	\N	f	pending	t	$2b$10$xUq.hWo7fihmGGf2mO55d.uvAu2rUXTXzk.Bq46bgCIrty0U6W6kC	0	free	2026-06-17 13:40:19.243433+00	2026-06-24 07:48:40.443086+00	\N	2026-06-24 07:48:40.432+00	0	f	\N	f	0	0	\N
806ba3e8-6d5c-452c-ad2b-b00b24d86ad7	caretaker	cavad test qulluqcu	Musayev	\N	\N	+994503741156	\N	\N	/uploads/1782387918591-466492545.jfif	f	pending	t	$2b$10$Q4HJXn1rmnd72ZNvCkGp..Gg56CCa28wrnk128FtDAXD42w.iBIzK	0	free	2026-06-18 11:59:28.346149+00	2026-06-30 15:23:08.914597+00	walking,grooming,bathing,spa	2026-06-30 15:23:08.906+00	750	f	2026-06-27 12:58:42.977+00	f	28000	1	\N
\.


--
-- Data for Name: geocode_settings; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.geocode_settings (name, setting, unit, category, short_desc) FROM stdin;
\.


--
-- Data for Name: pagc_gaz; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_gaz (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_lex; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_lex (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_rules; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_rules (id, rule, is_custom) FROM stdin;
\.


--
-- Data for Name: topology; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY topology.topology (id, name, srid, "precision", hasz) FROM stdin;
\.


--
-- Data for Name: layer; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY topology.layer (topology_id, layer_id, schema_name, table_name, feature_column, feature_type, level, child_id) FROM stdin;
\.


--
-- Name: topology_id_seq; Type: SEQUENCE SET; Schema: topology; Owner: postgres
--

SELECT pg_catalog.setval('topology.topology_id_seq', 1, false);


--
-- Name: banners banners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banners
    ADD CONSTRAINT banners_pkey PRIMARY KEY (id);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- Name: conversations conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_pkey PRIMARY KEY (id);


--
-- Name: hotel_addons hotel_addons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_addons
    ADD CONSTRAINT hotel_addons_pkey PRIMARY KEY (id);


--
-- Name: hotel_rooms hotel_rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_rooms
    ADD CONSTRAINT hotel_rooms_pkey PRIMARY KEY (id);


--
-- Name: membership_plans membership_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membership_plans
    ADD CONSTRAINT membership_plans_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: monitoring_logs monitoring_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monitoring_logs
    ADD CONSTRAINT monitoring_logs_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: otp_codes otp_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_codes
    ADD CONSTRAINT otp_codes_pkey PRIMARY KEY (id);


--
-- Name: payment_card payment_card_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_card
    ADD CONSTRAINT payment_card_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: pets pets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pets
    ADD CONSTRAINT pets_pkey PRIMARY KEY (id);


--
-- Name: product_events product_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_events
    ADD CONSTRAINT product_events_pkey PRIMARY KEY (id);


--
-- Name: product_images product_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT product_images_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- Name: sales sales_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_pkey PRIMARY KEY (id);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_product_events_product; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_events_product ON public.product_events USING btree (product_id);


--
-- Name: idx_product_events_seller; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_events_seller ON public.product_events USING btree (seller_id);


--
-- Name: idx_product_images_product; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_images_product ON public.product_images USING btree (product_id);


--
-- Name: bookings bookings_caretaker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_caretaker_id_fkey FOREIGN KEY (caretaker_id) REFERENCES public.users(id);


--
-- Name: bookings bookings_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id);


--
-- Name: bookings bookings_pet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pet_id_fkey FOREIGN KEY (pet_id) REFERENCES public.pets(id);


--
-- Name: conversations conversations_caretaker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_caretaker_id_fkey FOREIGN KEY (caretaker_id) REFERENCES public.users(id);


--
-- Name: conversations conversations_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id);


--
-- Name: messages messages_conversation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversations(id) ON DELETE CASCADE;


--
-- Name: messages messages_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(id);


--
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: payments payments_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON DELETE CASCADE;


--
-- Name: pets pets_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pets
    ADD CONSTRAINT pets_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: reviews reviews_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON DELETE SET NULL;


--
-- Name: reviews reviews_caretaker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_caretaker_id_fkey FOREIGN KEY (caretaker_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: reviews reviews_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

