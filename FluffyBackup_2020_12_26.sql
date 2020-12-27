--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.18
-- Dumped by pg_dump version 12.3

-- Started on 2020-12-27 20:46:37

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

SET default_tablespace = '';

--
-- TOC entry 186 (class 1259 OID 32780)
-- Name: pets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pets (
    pet_id integer NOT NULL,
    specie integer DEFAULT 0,
    nickname character varying(100),
    birthday date,
    price money,
    notes character varying(500),
    photo bytea,
    color character varying(100),
    sex integer DEFAULT 0,
    breed character varying(100)
);


ALTER TABLE public.pets OWNER TO postgres;

--
-- TOC entry 2286 (class 0 OID 0)
-- Dependencies: 186
-- Name: TABLE pets; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.pets IS 'Таблица животных';


--
-- TOC entry 206 (class 1259 OID 41011)
-- Name: sexes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sexes (
    sex_id integer NOT NULL,
    sex_name character varying(100) NOT NULL
);


ALTER TABLE public.sexes OWNER TO postgres;

--
-- TOC entry 2287 (class 0 OID 0)
-- Dependencies: 206
-- Name: TABLE sexes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sexes IS 'Таблица полов для Зоомагазина';


--
-- TOC entry 194 (class 1259 OID 32821)
-- Name: species; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.species (
    specie_id integer NOT NULL,
    specie_name character varying(100) NOT NULL
);


ALTER TABLE public.species OWNER TO postgres;

--
-- TOC entry 2288 (class 0 OID 0)
-- Dependencies: 194
-- Name: TABLE species; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.species IS 'Виды животных';


--
-- TOC entry 196 (class 1259 OID 40971)
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions (
    transaction_id integer NOT NULL,
    date_time timestamp(0) without time zone NOT NULL,
    customer_id integer DEFAULT 0 NOT NULL,
    pet_id integer DEFAULT 0 NOT NULL,
    amount money NOT NULL
);


ALTER TABLE public.transactions OWNER TO postgres;

--
-- TOC entry 2289 (class 0 OID 0)
-- Dependencies: 196
-- Name: TABLE transactions; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.transactions IS 'Покупки (таблица взаимодействия с клиентами)';


--
-- TOC entry 207 (class 1259 OID 41026)
-- Name: available_pets_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.available_pets_view AS
 SELECT pets.pet_id AS "ИД",
    pets.nickname AS "Кличка",
    species.specie_name AS "Вид",
    pets.specie AS "ИД Вида",
    pets.breed AS "Порода",
    pets.color AS "Цвет",
    pets.birthday AS "День рождения",
    pets.price AS "Цена",
    sexes.sex_name AS "Пол"
   FROM ((public.pets
     LEFT JOIN public.species ON ((species.specie_id = pets.specie)))
     LEFT JOIN public.sexes ON ((sexes.sex_id = pets.sex)))
  WHERE ((pets.pet_id > 0) AND (NOT (pets.pet_id IN ( SELECT transactions.pet_id
           FROM public.transactions))));


ALTER TABLE public.available_pets_view OWNER TO postgres;

--
-- TOC entry 2290 (class 0 OID 0)
-- Dependencies: 207
-- Name: VIEW available_pets_view; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.available_pets_view IS 'показывает всех доступных животных в продаже';


--
-- TOC entry 188 (class 1259 OID 32791)
-- Name: cages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cages (
    cage_id integer NOT NULL,
    number character varying(50),
    place character varying(100),
    dimentions character varying(50),
    has_drinker boolean,
    has_feader boolean,
    prefered_specie integer
);


ALTER TABLE public.cages OWNER TO postgres;

--
-- TOC entry 2291 (class 0 OID 0)
-- Dependencies: 188
-- Name: TABLE cages; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.cages IS 'Клетки (и прочие помещения для питомцев)';


--
-- TOC entry 210 (class 1259 OID 57357)
-- Name: cage_name_plus; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.cage_name_plus AS
 SELECT cages.cage_id,
    (((((cages.number)::text || ' ('::text) || (cages.place)::text) || ') - '::text) || (species.specie_name)::text) AS name_plus
   FROM (public.cages
     LEFT JOIN public.species ON ((species.specie_id = cages.prefered_specie)))
  ORDER BY (((((cages.number)::text || ' '::text) || (cages.place)::text) || '-'::text) || (species.specie_name)::text);


ALTER TABLE public.cage_name_plus OWNER TO postgres;

--
-- TOC entry 2292 (class 0 OID 0)
-- Dependencies: 210
-- Name: VIEW cage_name_plus; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.cage_name_plus IS 'Расширенное наименование клетки';


--
-- TOC entry 187 (class 1259 OID 32789)
-- Name: cages_cage_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cages_cage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cages_cage_id_seq OWNER TO postgres;

--
-- TOC entry 2293 (class 0 OID 0)
-- Dependencies: 187
-- Name: cages_cage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cages_cage_id_seq OWNED BY public.cages.cage_id;


--
-- TOC entry 200 (class 1259 OID 40987)
-- Name: placements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.placements (
    placement_id integer NOT NULL,
    date_time timestamp(0) without time zone NOT NULL,
    pet_id integer NOT NULL,
    cage_id integer NOT NULL,
    is_a_start boolean NOT NULL,
    comments character varying(200)
);


ALTER TABLE public.placements OWNER TO postgres;

--
-- TOC entry 2294 (class 0 OID 0)
-- Dependencies: 200
-- Name: TABLE placements; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.placements IS 'Таблица размещения животных';


--
-- TOC entry 211 (class 1259 OID 81947)
-- Name: cages_empty_occupied; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.cages_empty_occupied AS
 SELECT DISTINCT ON (cage_actions.cage_id) cage_actions.cage_id,
    cage_actions.date_time,
    cage_actions.is_a_start
   FROM ( SELECT placements.cage_id,
            placements.date_time,
            placements.is_a_start
           FROM public.placements
        UNION
         SELECT cages.cage_id,
            '2000-01-01 00:00:00'::timestamp without time zone AS date_time,
            false AS is_a_start
           FROM public.cages
          WHERE (cages.cage_id > 0)
          GROUP BY cages.cage_id) cage_actions
  ORDER BY cage_actions.cage_id, cage_actions.date_time DESC;


ALTER TABLE public.cages_empty_occupied OWNER TO postgres;

--
-- TOC entry 2295 (class 0 OID 0)
-- Dependencies: 211
-- Name: VIEW cages_empty_occupied; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.cages_empty_occupied IS 'Сводная таблица по занятым / свободным клеткам';


--
-- TOC entry 190 (class 1259 OID 32799)
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customer_id integer NOT NULL,
    name character varying(100) NOT NULL,
    surname character varying(100) NOT NULL,
    patronymic character varying(100),
    sex integer DEFAULT 0,
    birthday date,
    card_id bigint,
    photo bytea
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- TOC entry 2296 (class 0 OID 0)
-- Dependencies: 190
-- Name: TABLE customers; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.customers IS 'Покупатели зоомагазина';


--
-- TOC entry 209 (class 1259 OID 57353)
-- Name: customer_name_plus; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.customer_name_plus AS
 SELECT customers.customer_id,
    (((((customers.surname)::text || ' '::text) || (customers.name)::text) || ' '::text) || (customers.patronymic)::text) AS name_plus
   FROM public.customers
  ORDER BY (((((customers.surname)::text || ' '::text) || (customers.name)::text) || ' '::text) || (customers.patronymic)::text);


ALTER TABLE public.customer_name_plus OWNER TO postgres;

--
-- TOC entry 2297 (class 0 OID 0)
-- Dependencies: 209
-- Name: VIEW customer_name_plus; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.customer_name_plus IS 'Расширенное имя клиента';


--
-- TOC entry 189 (class 1259 OID 32797)
-- Name: customers_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_customer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customers_customer_id_seq OWNER TO postgres;

--
-- TOC entry 2298 (class 0 OID 0)
-- Dependencies: 189
-- Name: customers_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_customer_id_seq OWNED BY public.customers.customer_id;


--
-- TOC entry 198 (class 1259 OID 40979)
-- Name: feedings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feedings (
    feeding_id integer NOT NULL,
    pet_id integer DEFAULT 0 NOT NULL,
    food_id integer DEFAULT 0 NOT NULL,
    date_time timestamp(0) without time zone NOT NULL,
    weight real
);


ALTER TABLE public.feedings OWNER TO postgres;

--
-- TOC entry 2299 (class 0 OID 0)
-- Dependencies: 198
-- Name: TABLE feedings; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.feedings IS 'Таблица кормлений животных';


--
-- TOC entry 197 (class 1259 OID 40977)
-- Name: feedinds_feeding_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.feedinds_feeding_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.feedinds_feeding_id_seq OWNER TO postgres;

--
-- TOC entry 2300 (class 0 OID 0)
-- Dependencies: 197
-- Name: feedinds_feeding_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.feedinds_feeding_id_seq OWNED BY public.feedings.feeding_id;


--
-- TOC entry 204 (class 1259 OID 41003)
-- Name: foods; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.foods (
    food_id integer NOT NULL,
    name character varying(100) NOT NULL,
    producer character varying(100)
);


ALTER TABLE public.foods OWNER TO postgres;

--
-- TOC entry 2301 (class 0 OID 0)
-- Dependencies: 204
-- Name: TABLE foods; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.foods IS 'Таблица кормов';


--
-- TOC entry 203 (class 1259 OID 41001)
-- Name: foods_food_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.foods_food_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.foods_food_id_seq OWNER TO postgres;

--
-- TOC entry 2302 (class 0 OID 0)
-- Dependencies: 203
-- Name: foods_food_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.foods_food_id_seq OWNED BY public.foods.food_id;


--
-- TOC entry 208 (class 1259 OID 49161)
-- Name: pet_name_plus; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.pet_name_plus AS
 SELECT pets.pet_id,
    (((((species.specie_name)::text || ' '::text) || (pets.breed)::text) || ' - '::text) || (pets.nickname)::text) AS nick_plus
   FROM (public.pets
     LEFT JOIN public.species ON ((species.specie_id = pets.specie)))
  ORDER BY pets.pet_id;


ALTER TABLE public.pet_name_plus OWNER TO postgres;

--
-- TOC entry 2303 (class 0 OID 0)
-- Dependencies: 208
-- Name: VIEW pet_name_plus; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.pet_name_plus IS 'Расширенные имена животных по идентификатору';


--
-- TOC entry 185 (class 1259 OID 32778)
-- Name: pets_pet_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pets_pet_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pets_pet_id_seq OWNER TO postgres;

--
-- TOC entry 2304 (class 0 OID 0)
-- Dependencies: 185
-- Name: pets_pet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pets_pet_id_seq OWNED BY public.pets.pet_id;


--
-- TOC entry 199 (class 1259 OID 40985)
-- Name: placements_placement_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.placements_placement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.placements_placement_id_seq OWNER TO postgres;

--
-- TOC entry 2305 (class 0 OID 0)
-- Dependencies: 199
-- Name: placements_placement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.placements_placement_id_seq OWNED BY public.placements.placement_id;


--
-- TOC entry 192 (class 1259 OID 32810)
-- Name: providers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.providers (
    provider_id integer NOT NULL,
    company_name character varying(100) NOT NULL,
    contact_person character varying(200),
    contact_email character varying(100),
    contact_phone character varying(50),
    adress character varying(200),
    requisites character varying(200)
);


ALTER TABLE public.providers OWNER TO postgres;

--
-- TOC entry 2306 (class 0 OID 0)
-- Dependencies: 192
-- Name: TABLE providers; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.providers IS 'Поставщики зоомагазина';


--
-- TOC entry 191 (class 1259 OID 32808)
-- Name: providers_provider_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.providers_provider_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.providers_provider_id_seq OWNER TO postgres;

--
-- TOC entry 2307 (class 0 OID 0)
-- Dependencies: 191
-- Name: providers_provider_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.providers_provider_id_seq OWNED BY public.providers.provider_id;


--
-- TOC entry 205 (class 1259 OID 41009)
-- Name: sexes_sex_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sexes_sex_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sexes_sex_id_seq OWNER TO postgres;

--
-- TOC entry 2308 (class 0 OID 0)
-- Dependencies: 205
-- Name: sexes_sex_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sexes_sex_id_seq OWNED BY public.sexes.sex_id;


--
-- TOC entry 193 (class 1259 OID 32819)
-- Name: species_specie_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.species_specie_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.species_specie_id_seq OWNER TO postgres;

--
-- TOC entry 2309 (class 0 OID 0)
-- Dependencies: 193
-- Name: species_specie_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.species_specie_id_seq OWNED BY public.species.specie_id;


--
-- TOC entry 202 (class 1259 OID 40995)
-- Name: supplies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supplies (
    supply_id integer NOT NULL,
    date_time timestamp(0) without time zone NOT NULL,
    provider_id integer DEFAULT 0 NOT NULL,
    pet_id integer DEFAULT 0 NOT NULL,
    price money,
    comments character varying(100)
);


ALTER TABLE public.supplies OWNER TO postgres;

--
-- TOC entry 2310 (class 0 OID 0)
-- Dependencies: 202
-- Name: TABLE supplies; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.supplies IS 'Таблица поставок животных';


--
-- TOC entry 201 (class 1259 OID 40993)
-- Name: supplies_supply_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.supplies_supply_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.supplies_supply_id_seq OWNER TO postgres;

--
-- TOC entry 2311 (class 0 OID 0)
-- Dependencies: 201
-- Name: supplies_supply_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.supplies_supply_id_seq OWNED BY public.supplies.supply_id;


--
-- TOC entry 195 (class 1259 OID 40969)
-- Name: transactions_transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transactions_transaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transactions_transaction_id_seq OWNER TO postgres;

--
-- TOC entry 2312 (class 0 OID 0)
-- Dependencies: 195
-- Name: transactions_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transactions_transaction_id_seq OWNED BY public.transactions.transaction_id;


--
-- TOC entry 2087 (class 2604 OID 32794)
-- Name: cages cage_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cages ALTER COLUMN cage_id SET DEFAULT nextval('public.cages_cage_id_seq'::regclass);


--
-- TOC entry 2088 (class 2604 OID 32802)
-- Name: customers customer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN customer_id SET DEFAULT nextval('public.customers_customer_id_seq'::regclass);


--
-- TOC entry 2095 (class 2604 OID 40982)
-- Name: feedings feeding_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedings ALTER COLUMN feeding_id SET DEFAULT nextval('public.feedinds_feeding_id_seq'::regclass);


--
-- TOC entry 2102 (class 2604 OID 41006)
-- Name: foods food_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foods ALTER COLUMN food_id SET DEFAULT nextval('public.foods_food_id_seq'::regclass);


--
-- TOC entry 2084 (class 2604 OID 32783)
-- Name: pets pet_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pets ALTER COLUMN pet_id SET DEFAULT nextval('public.pets_pet_id_seq'::regclass);


--
-- TOC entry 2098 (class 2604 OID 40990)
-- Name: placements placement_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.placements ALTER COLUMN placement_id SET DEFAULT nextval('public.placements_placement_id_seq'::regclass);


--
-- TOC entry 2090 (class 2604 OID 32813)
-- Name: providers provider_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.providers ALTER COLUMN provider_id SET DEFAULT nextval('public.providers_provider_id_seq'::regclass);


--
-- TOC entry 2103 (class 2604 OID 41014)
-- Name: sexes sex_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sexes ALTER COLUMN sex_id SET DEFAULT nextval('public.sexes_sex_id_seq'::regclass);


--
-- TOC entry 2091 (class 2604 OID 32824)
-- Name: species specie_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.species ALTER COLUMN specie_id SET DEFAULT nextval('public.species_specie_id_seq'::regclass);


--
-- TOC entry 2099 (class 2604 OID 40998)
-- Name: supplies supply_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplies ALTER COLUMN supply_id SET DEFAULT nextval('public.supplies_supply_id_seq'::regclass);


--
-- TOC entry 2092 (class 2604 OID 40974)
-- Name: transactions transaction_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions ALTER COLUMN transaction_id SET DEFAULT nextval('public.transactions_transaction_id_seq'::regclass);


--
-- TOC entry 2262 (class 0 OID 32791)
-- Dependencies: 188
-- Data for Name: cages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cages (cage_id, number, place, dimentions, has_drinker, has_feader, prefered_specie) FROM stdin;
1	1А	Напротив окна	20х40х60	t	t	1
2	13	У входа	120х100х150	f	t	4
3	14	У входа	100х80х120	t	t	3
0	- Не задано	 	 	f	\N	0
4	33	Возле арки	40х30х190	t	t	13
5	12Х	Посередине	40х50х60	t	\N	2
6	9	Слева от окна	120х200х200	\N	t	4
7	7П	Гапротив окна	60х100х50	t	\N	7
8	1К	В углу	100х100х200	t	t	10
\.


--
-- TOC entry 2264 (class 0 OID 32799)
-- Dependencies: 190
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (customer_id, name, surname, patronymic, sex, birthday, card_id, photo) FROM stdin;
7	Анна	Попкова	Васильевна	2	1978-01-09	\N	\\xffd8ffe000104a46494600010101000000000000ffdb004300090607131312151312131516151716171818181816171818181f1a1a18181b171d1a181d28201b1a251d161821312225292b2e2e2e171f3338332d37282d2e2bffdb0043010a0a0a0e0d0e1b10101b2d2520252d2d2d2d2d2d2f2d2d2d2d2b2d2d2d2d2d2d2d2d2d2d2d2d2f2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2dffc0001108010100c403012200021101031101ffc4001c0000010501010100000000000000000000000304050607020108ffc4003e100001030203050604040504020301000001000211032104123105415161810613227191a10732b1c142d1e1f01423526272338292f1a2b243b3c208ffc400190100030101010000000000000000000000000203010405ffc40028110002020202010304020300000000000000010211032112314104325113226171a1f01442b1ffda000c03010002110311003f00dc5084200108420010842001084cf69ed3a741b99e4c9b35a04b9c7801fb086e8078a2f1bda2c2d22454acd04799e961aaa57697b66e2d733bc6d06ef0097543e64406f905996d2da93f2bdeee760a2f2fc1558be4dc2bf6f702dffe573bca9d4fa9680a2f15f13b0c0c53a755c77c80c1f73ecb0d3b61d3127ac27787c4547dc440fc44c0f658e72196346cf88f89b876d2cdddbf3ff41200f3cdc3a4f2555abf13dd51c66a160fe9a4c24f52483efd152283b0b20d7ace3fe2d303aebf6572d8f80c1d400d07b6a72cd7f4de9653b5b66a857810776ea9130714f6bbfb9a47ac38a97d9fdadaf6753c40aade4e0ef677e9e69ae2f66b2729665ff6b63ff55115bb3e01cd4dac9e2cf03baee3e4a7fa637ed1a3ecdedc83feab2dbcb26479b4fd8f456bc0e3a9d66e7a4f0f6f11bb911a83c8ac3f0f8b7537455b11bc8ca7d77f5f6562c2567b0f7d8676478f986ad70e0e6ef1ee374278e66b4c59624f68d590a1fb39b79b8a61b64aadf9d93a7f703bda78a985d29a6ad106ab4c10842d3010842001084200108420010842001084200e2bd50c69738c0024ac83b57da673eab8b0804db31366b7fa1bf73bcab4fc4ddb669b1b41861cfb9f2ddf73e8b16da98a9f2f73ccae5cb3b7c4e8c50a5638c50a4ff9aa7a5fa6a990d96d3a127d5bef751d49e4981fbeaac5b3302f7101b24fa008ba1eac8f7ec8bd848ff29fcd2d8cd9f562180c700b46d8bd980003535e0ac34f66d302cd095ccac71180e236654d4b4f3b25308c7d2f15c1dc343fbd56eb8ad914c8f947a285da7d98a2e04c0ba6fa9f267d1de88dd83b44d6a596a12e611a9f999ce778137091c736ad07103c4d9d0fefebfaaef63eccee2a103e577fd291c78914c3b47134c9f2883eea76ac5945a19d1acdaad87349e2d3f30e60e8e1d7aaeb06c75020b0e6a6776b1e5cb96e509431e58f2c7ee25ae1c20c18e62247453d86aa4183a6f3affbba6f5924626488aaea6f6e2289820dc6ebee3c8febc5691b371adad4db51ba3869bc1de0f915995071698d5ae394f22ac9d89c616547d03a1f137cc6a3a8fa2a619d3a13246d59734210bace60421080042108004210800421080042136da757251a8ee0c711e8616374816cc5bb6f8fef71351f36d0794c0f66aa0e31e5d263cbf556ddb14e5c41ebea6deea12b87ee868dcd81f55c3176ecee7ad11782b1cc75dc3cd6add8ed9d14db51c3c46fe4b2ad98c2fab045f369cd6d9b25914dade0026c8e86c4ac95a413ba60266c627348248b2ed0a56684c31546c9eb9d64cf12eb2d933224262a880e07811f54cf6df8693237d47479e89fe28dc79a82ed1e20e5a4de0e7bbee3ea54d3d99963d15fedae1e1ef7347cf95e3a8fd027bb1f145f4da66e194ddeac693f75df69999a9533fda07a4fe6a2bb2f549c41a7bb2521ff0080047a8f756bb39da2db4df9a1bfd5e19e6002dfa81d0a79b3f1d9311de0d5ae048e44091ee546e18cb9bc8d277af84fff0060f45e6d42696273b749ca7d7f553e80d918f04022e0891d574a17b278cef28013396c3c8dc7dc74534bbe32e4ace392a74084213180842100084210008421000a33b47572e1ea1e395bff002701f7526a07b6248a0de1de373795e3de12cfdac687b9195ed5c1f8f5006f27701aaaa6376a53cf95821bbc9d4c6a4fee15d36fd5a6d665ab395de12f6eeb03267a2a06d1d8169a551b51a6f7043b958c8ea095c78d7c9d73247b0f84ef6b66dc0c95af60cb5a2e40547f86db37252738dc9744f97ea54ae28893de102fa936f743db2d0d44b68c4b0e8e6faae9b890a818dc2d223336b007aa57643aa34805e5c0e86647aac768a45a65e8d5052188aa344c9cf21b2abf89dac41252390ea04c62e156b6e192c2787d437f55e53ed03cbb296000ef94df68d790d1c1a7d8fe89449bd9dedbff0041878388f60ab5d9aaa7f8b73a4c47a5f729fda2f9a0d1fdc7e8a0b6453c8ea8f3fb81f9b87a2a590ad16dd91566ac717b5bd03c7d9a12db4de1d55cd3a39e7d40cc3efe8986c177f3a9f479f433ef3e8bbaf573398ee35411d014215975ec1e24b5e699fc5ff63f7cd5ed657d9dad96a03b9ae1e968fa85a982ba703d3473e65bb3d4210ae44108420010842001084200147ede68387a81da16c759107d6148287ed61230e7fc9b3e52967ed6347dc8c3bb57892585a23e7779eefb08543639f9ac4804e9bbd15f3b6149809d64c9125a1b7befe17555d9780356a0cb0624d8ce91f9ae6c6e91d52ecd7fb09878c2b39c9f72baed2766bbe21d9f2c6e1227aeee89f766a964c3b1a750002a768869b1014d7674d68cbf1dd986e60412d16902087408b9b989bee52db136296996b8e5d6381579ab82a62f95be89ab80dd016ce4fc990825b431dade1a12a8d4cd432e0c0e33001bf58fccabcf691dfca8517b36888b48f230a7abd95db45476a6d1af4086be966cd1f28169de61b61d537c46264b071047d08f5575c5ecb2e11f37523f30a0b68f675c0668d0c81249f529b253e8928493646e21f349bfe4e29845a07e2735bd2731fa27b89b360d883f9a8ea9572df918f336fa02a69ec1ad133b3f1119dfc1ae83e7207e7d53ba0d9ee87f75fd3f550d833fcb683a989f69f752bb3eacbdbfe47e87f209e24a44deca3fcc7b7947b123ea3d16af8674b1a78b41f658c6cac4935aa91c6dd2df65b4619b0c68e0d03d97460ed9cf9ba42884217490042108004210800421080051bda2a79b0f507207d08524b9ab4c38169b82083e46cb24ad51a9d3b30aed8603bd6d8789bbb431c47ef728eec86ccc85f205c10358bc19ff00c7d95d3b6bb3aa61c888735df29e3c8f03fa2a053c7551543858033c00f3e6b8b6b4ced5bda34fd8f57f96275123ae89e1c565503d9faf9a99bcde678e613f5946d3c516db79d14e4e8ebc7b43ec56d57b8e566a9f608801b98de2ea2b64e108bbb528da3b34871aad99de24c1e8b15f63bae87bb721d604289c162c53a818edfa74559da98aaceb071691cbf35de0df51cf0ea864810165d9b4687deb6242638fac0850d87c7c7849bae9f8a95b766f1f2406dda50646875fdfa2afd66e60470b8e923ffd2b5ed7334dca918cc77741ce807411fbf35aa3bd109f4d92f84a9f29e4d1effbf44e762d53949dedcdea1b9bee544ecbc532a8f072394ea37f5ba99a0cca5c373afebafdd1b8e883a7b27bb0381353121bb81bf93667e8b67549f861b27bba06b3878aa181e4353d4fd15d976608d46fe4e4cd2b950210856240842100084210008421000842100476ded92dc4d234ddd0c4c2cc76bfc3ec4b5de001e3765ddd0ad7d0a73c5197652191c7a32aecef6531385cf56a886100105c09d6c401302e7d53cc6e183883bc2d1ab520e6969d0820f5542ab48b2a3a9bb5698f3e07a883d57366c7c6a8ecf4d9795a655b3e399886b7bc6774f300e5bb4cd8193bd4a1c4e2d919d9de0209f0c682dc014fb68e1b300459c3df92654f6d06f86a97d32040301cdf43e5c52adf4766fc1018dda0f741140df4f0baea2b19da0ee84be939bd42b2627b42c0413518eca204348dd00c49dca19f836621c1e417469980ca3c9bc6fa95897c9af9795473b3ea3b1203dad7346e244292149cc304ca7d86606364ee4d5f52f3c54fc99e065b72a06507389e0b31731d55e73cc4981a00ad3f1076890da74c7cae32ee9bbdd4161369b5b1bfc802ba209a5691c7925193a6c91c1e09ac008067747da35572ec96c6a98aaad61d3f11d600d6ff0053d130ec6ec4a98eaa594df4db0d0e7124660d98b3753af95f50b70ecfec3a584a7929824fe271f99c7ec380590c4e6ed93c99145522430f4431ad634435a000390b251085da7182108400210840021084002108400210840021084002a9f6dbbb63a8d42f6b5ee7160692017c02eb0df179f350df123e27d3c013430ed6d6c4c78a4ff2e94e99e2ee76fc808b5c9169c26b76831189c6d3c4626abaa3fbc65cd834661e16b459ade4124e3ca345314b8c933e830d0e09863b64870d546d1dace60837e6bd776841b4ae1d1ebc4655761006d097a786c82e93adb75aa3719b5332c1a4c5b198c04f21f54d7bc24a65de25a8bf2dcac44a4ec84f88b487714cfe20f8f5067e815018db42b276e7689a8f6b07cadba8114f9f35db8bda7064dcd927d96db9570389a789a265cc371701ed36730f223d0c1dcbeb1d85b5e962e853c45174b2a364710742d237381904710be3ea5464c34de6c38f92d6be06f69051ac70752a0cb5892d69261af0d9b1222486e523886a7bd8b282ab37642109c80210840021084002108400210a13b65da166070b5310e891660263338e83ea7c8141a95ba438db3da0c2e140389af4e94e81cef13bfc5a3c4ee81453be20ece0cef3f890444c0654cdff001cb3ecb01adb633d67e2abff0036ad4de6640d06b61e42c2137c5ed72f00bfc2c16b093c62e91c8e98fa75feccd8f1bf19f06d3969d0c4d43bad4dadf77cfb288dbff136bd6a2e6618b30ef209cf3de5803e16b88686b8daf94fdd6475f6952cd9a9e661110d32e1a788c813ff006bd756921cc77fc4e9e974929cb5453160c6eef7f1bfe460e71712e24924924932493724937249de9cec1c077f886531300e6746e0dbfd60755eed1734e578b17839b84b4c48f31048e3e6ad7f0c366ffab5dcd2640630cc45c1279eeb724d92750b39e18dfd4e25c5ec4cabd3530fa1609b57a2bcf3d3440556240b54a57a091fe1d231864d05238e716b64a9314944769aa065171766970cac88f98f19dc049b704d14dba126d45594cc5540f7963acd2e12e9139ae2e77344c7ba5b15b3c06021de2d088b1ebb8c6e4c1ac4e69e2de20174b608b8048b1883a8f55e9f1a5a3ce8644dbe5e4f3054ccc412466200d4900c79006e4ee00a49d4600040b8b5c19ff89296af57c4f0c05ad260c992403316037809cecac136a3e1c600127e9ed73edcd174ad8717926a30db2edd93f8b38bc2d3651aac6d7a6c01adcc4b5e00d06700c802d7693cd68db1be2e60aac0aadab40daee6e765ff00b9926399685856d2c25260029b84c4ddd73b8db799d232f96f4c5a6162dab4cd9a517c671dfe0faeb67ed1a55d99e85565461fc4c7070f291bd3a5f26eccdbb88a15054a159f4de2d2205b81110472216a5d91f8c06453da0d1c3be60f77b07d5bff0014e41d783604243058ca75982a527b5ec75c39a4107a8420c174210800586fff00d07b4cbab61b0c1de0198900fe33975f2691ff0032b68dab8f650a352b5430da6d2e3d370e64dbaaf973b4f8efe231aead5000e73b33b33cc337c5cc010008fba56fc16c506ee4889ab88398868f083afb269883bc89137dcbaaafd4870dda26f5813a937dde5a2d464ddbb392770d38948b4199133ba354a066f33cff007a293d87433389f9720cf3126da499e3074dc805f73a438a94ea52a792b5199b8710419200b7a6becb5aec8ec7ee70949a7539499d6499f559a6030f44d56536121a5ed24924e700827373b4adca81f0b00d2787013d172e6f83ba11adb1b55c3d932c45053f529ca695682e765a256eb61a537a985564fe1424dd844a6d900cc1f154bf88af1de51a4d04784bcb664cbbc2dd3fc5d6e6b4f661c38c408699993a8dd0387ef4592fc4da4e18c7546d4638656881ab61b94b48f393d55b025cad90f516e1a2b6f044c80235bdd758622439e246e1373c639eeea91a38d6e8f6f56fe45396d30e6d89df0664735dad9c9082ee220eae492e22e493adae663dd49ecdd35d6eee006e13bd303440201bcf495d3eb168753045c8cd0008227c33ca4dff0024b2daa2986b1cf931decec3b331350c804d9b04bcf98f95bccf41c38ae5b9dd944341b0b98b0b49e6b915835b2370b89d637c6a93a42d7d4dcf99ba20db762e7842114977dd8a6595c62010d998e17699e978b5e4f05e38a41e782a339e2ebc0f2863dec10d7546ef392b39809e2441bc46fdcbc4d1ac2859486e733ecd4210b4999c7c6ddb5dce1a8d20331ab53316cc4b694120f2cce6f5017cf6e767abbfc477eb73bf9ad2fe316d7efb681603e0a01b4c702e3e379f70dff6aa2552d18804d80899f2948fb2aa4f8f1f034fe08b6ae43a304f489fd1340f971e254ced2a4d790f248ef2c2370021a4efbbbd945b3084182246b3d50a68a7d09be90576d93ad9d8a34dae34dde371064683299024effb129bd621af708b03b818b0131ca652ec4e455c742a31c1b533b74372d882d3c84458f05b87667182ad0a2fd640ff00d56098860239ad7fe18d59c35211a1779080573e78e933af06472b4cbdc2f2a312802f0ae5a3a46e29a4310eca2c0171d01fd3727555e0092600d4aa3f6dfb69fc334b29b41aa644c7fa40de5dc5e62c376fe6256e91bf915ed6f68998661a74dc05536f0c782797f57e6b31fe0db52497197120efb9bc9e7aa8eef5cf69719244b9ced4993724f192bbc063e0c3a60db5dc7537112aab1c9743ac98e945aec655f099243ed075e29c6cfc4d11021e0e849120f984ef6ad50f6c65cc4810e9898b091c6dee9be128b46527ac8b441babf3b5b397fc7e33a8bd1ed6c553712082d2d801c2329fee2224132343f74d3334be1a00168bea7849de5798af99f1f2e68f4483284b80e3ee9d2d1cf2934c7d5b2fc8d06459e4c47908d575294ab827300b59243edfa2d8a49689cdca72d9c1d6069363bf7d8fa2714f0c3301fbba6fcbc8cf97fdfb27d837e674f97d02c93d0ca29487a30a38213b050a56caf147d469aed4c6b68d1a959da53639e79e5131e6744e9503e336d5eeb06da20c1acf00dff0b3c47ff2c83aabb74ace6c70e7251312c6b9d5311e332e739d51e78b9e7338a86da243eb90c9378bdafa1d37734a57c43aee2f8b3803238c40f39d7cd37d9c436a66240804899f9b402de7ec95dd5955c79a5e2ff81d6d5702f0c6190c00690646bef2a43018d66525c5b99b1a98cd1a09262777351987a12d754771813c77ae0522e3004936f3e4a31ae8ef939afbe3dbff00877b4291ef7c40b640706988beb116227ea172524f6e43972c10623483c12f86635f51aceedcf925a5c2649fed11a0d3dd7459e6f172672d6cad5be16bc1c3b07f4b9e0fafe4b2c6d1264325d7311bc0dfe8aebf0af1e1af7d3277c810778b8f6952cfb45bd3c5a77f26be0af61214eaa80ed4f6a19866e5066a448634c38f016d0713c34b95c895ba4763692b671daaed1774d2ca64e72dd204c4919ee2cd969131d235c83b49b543dde16d9d7937d7cf5d37fba99c4ed9ef1ae73aa0ccf3fcc73886b9fba20dcb0681ba08e3750d5e852702410e3ba1d71be637aa4554b63778f4d5bfcf800e0ea4e379206eb4585a34e1d146486f878a70fc516372c48f25e612a520d2faba036100936d44eb75449a094a326bc52d89bb09376bc111c648dd1c5255cb8589d3ac6efd12d531dde1f0530c68f53bae77e9ba12159b7beaa918bf272e5cf04bec1945cce87db8293d8f817b834de0198fddfa266d6c9577c0e1c31800e09b24a91cb8972674690cb042ac53a7351e19a66207081af4fc94eed7c4c0ca0c121c49de00178e66c079a80c1fcd4c8b0971e407cb1d60a9c3a3a62ae6275decfc32410466d246848f3b89293a18bc809177116e5ccf25d62ab0d5b6898d2c9961ee77aa78253f70f3c4ebccf342734a940842cb2ab123ebe5837c6edaf9b16e66a28d36b00dd99ffcc71f42c1d16f2be52ed8e35d89c4626a4d9d5aa11cdb2437a4655b2f0897a7b5ca4bc22b9589395b1a31a207949279c92bb6b6c9de06959ee222c4fb2e707433d46b2624dcf002ee36e0014c99169ba17ef32d0a61c2f2e3379226c7ebe8bdc139a438837b1e7173e961ea93c69f1468d1a0f2d13ad9cf304e834e9c3aefe4b99ef6bc9eae3b8527e0e1f4ac09f9c90e2778e1e90989c2b9873073803ae5246ba88dea49d727f7bd7a180f3f3548ca91c9923ce428dda4c344d263b20102342efc4e93c496b79408e697ec454c98a0edc6dac0fdef51b88c3075a02ef6317d2acc7d392e125a35b8120c7980b24d38b363c94b66ea71395a22ee3668e27f2582ed26d5662abb9e66a8ad503a40209cc773a6d111ca16cf83c6e4a2ec4e28c0682e2402ecade302493c4ac9bb4db5862712faed664698020f88802039d1f888f681cd4fd3a6db7e0df52d24be48ec438d40f2f0261a440b0130606ed428f7d3e16f2b275de6bcc11fbea024485d7470b76357bdd600ccf1ba91c06ce2e63ea55cd9698103404b81b5afc0a73d9b68fe2038970ca244004132065749d0fe697db78c2e8616e500970111336b710222524e55d1d3831292e527a5e06acaba72d01d05be89955ad9893c4d8c47b24ab3e4183a8bc1ebd7444ad8899eb96871816cbda3fb87d55c3135600553d9bfea33cc2b0ed077854f2ada370f4c8ced05682d235735c0f90bcf983f54cf08f21b264435b73ec02476a57cceff006b5bea6ff64fdd4dada641b784dae6fa0fdf25b54922b8b6db20dd371c6538c196c89701c8ccfb0d1220c9ebfbfa2977e1e69c8b39b7046b20266c82eed1e1c5d31f84bb99744f48d1099bd8e71cc32def399b7e3a99d6508a29f5247d73da3c777184c456df4e8d470f30d240f585f2d55640791700659e6617d05f15f161b82348b8b4d67b5b6d61a43cf4b007fc96038eac09753603e132e311e839c5ca57b950f85a861937e74272052b9b9b0e69becf6659aaeb0b86926263e689dd7027a243115812c1330d7749b2f69b9ee68639e4b449022cd001260794d9338da688c26a334eae85ab9cc1a4497384de23c57007afaa70e0e0034031e7bf8eaa3ab3ddf333c31f293a0d6de893a18d793060eefd654d47c9d79323f6befe495a267f7f9a1f896b4e582e77f48b9f32740990ab5087650040927ef295d97b41b4d85af6662e2e39c1f17cb66c45fc40199e3aade2ded13fa914d2968e311b44e8591d654af64a954ab50b9b3a10435c5b6d6246e903d157719890e3304297d83b432b4d2a64e77c971361023c20fdff00656716e15409c1ceaf45bf68ed873288a45c1e0497707999ead1f69dc1507695625e5d004ee0001ec95dad5de1e5ae75c6e0418f450f55c74598b1b8ed8fea33636b8c50f29d50458f44a122354d2952869e2bcc9bd749e70f7078acad7b4025ce2cdf0006e6dfac92ee1bb54a383c825cf76b3009027410171b368ceba2ef1558130df9469cf9aced94b690ceae63ab89f382b8a6128f5cb46e024ad136c71877c39a7811f5527b4b1c20069049e7d49f450c29d8661793c78e9ac1b42f2a54bd801d07d82474d968c64a214985d50491173e9cba27f8e1e01e2971fc3be23e63b809b74299ec9617548689745a7e51c5cedf012b8e10f96971b804bbf174dc380dc81e2ea0f8880a7103d54f613451551aa5707a249998d1cbb67b099ca3d109ec212726538a2e9f1776a97e3cd207c3458d6c73700f71f473474540da2e92daae26040cb3e27899f44f7b77b63bcda18aaa04b5d55cd6f30c68a41de8c9eaa2db5e00300cee22d1d7558d54b91d51a96258ff00bfdb18bc97b9d5080331d04dba93c902a659f08362049889df6e53ea97acc6b40cb31a998d7808dc9992ba553479934e32df627ddf1bef525b3367d3aad20d9c0eed6130294a18a349c1c2c6348e97d3821ad0b1ec71b67660a60439d73a129a60eef631bc470bc5c8bf1884e3686d03503735a24db89d07a051c0ff006989ddf9ac5d6c692fbba27769d563400e634340b981267401430232e764b60daf060c8d7a6e4eb078515c557d4786e468ca3ce7ec35e6a3dce12410971c38aa2fea3339d4ab425986f94ef01b39d549830d02e75fdf99295c360bbc0205c9b9366c7133be6d6e054e50eee9b452cd99bf3d43a0e3940e103529db278f1f27be88ac4e0c486b08881f4de789d7a85274365d314b354198bc10cbe8662412201103a269b3a8b9cfcc6f72e70826d317e5781d149ed1da6728a4d69cd947d0683840f6496ecebe1051b6884c534b4c0f97cc1837b123a6a9b94622a39cf875a2e40000d2da6fd505511e7ceb9684ca299f10ea0f21bcf4b143cc24dce3a806c2f360470ba1991ec56a3a0a6b55c96acf1a8368e29a9d6124517c93b2d1d8ec30c952a9889892600813d6e47a28dc7d50fab6980491ebaf9a96d9ecc981f9882e9275882e1022624daf12abe0f8e795d03cee38d21cbdd2405358265941619e0bc03bcab151364933318a0084664299522bb454cb6abf7cbdc479133a7551156af19562dbee06b3891a3881ea44fa5d57b1d4c08237dfcf9a7834f43e68494797e8503fc21739972d70c8db8dfbd739c711eaae8f3a5d8a34f89b1acc0f3831ef09134e0e5de2dd539c8ceef3b8174bf288300400e24c6fb881e6927628660641fcb779958cae35ad9ce71e7049f3b000795bdd0d711324990206e99d7947dd72e7b6f7b14a35e388f542164da6146945ca49ac971fdf34ad4ab009b2e28986cde38eef55a212583c610d34c80e2002c27236003a1746622e2c3724ebb8e53035bb8dedbf289dd37f44d68d6687033a4efd377dca78dabe1ca4b40bba49d26d3efec959d18dfdbb25366e463497092e00087f3be9bf42986d6c5b9d50dce56c86c1991c4fef8a614f141c66637c1200e102ebc0e0e8cae9266371d74fdf15943bcbc9503eb34c4c82059dc79ceef2b85e09bdc18dff00f5292cda92759d4f0d47baf5cd6c6e4c73395bd8af770249398ee8221be6789485600c7db92f5b5ac1bbc585f5124fdd70e7f3583eb8e8e1d4c6e2b8020ea947d4e63d2e929e25688d226db8f3dc8a62608120684b7499d37e8a3ea0cbe65142a81a91a715cd67499e62dfbd106b9391cd31bcfa294d938b6b33070372200d22144075ee9fecec3f78e326dbf9f258ff0026ad7458e9b838020d8e88451600202f540e845d768fcceff22a36b6a842a40337472dd10842a9c6c599f21ff26fd1c9b942160de0528fdd79faa10807d1e6eea175c3cc7d10843089c9d7d52b5f41fe23ea508419f222f5d3343d7e8842d3103d7857a84033872f5df9a1080472ed572842019da55bf27fb87dd0858cd8899d53bc1ef4210fa35763d6a108532c7fffd9
0	- Не задано	 	 	0	\N	\N	\N
5	Георгий	Попков	Наумович	1	1978-09-21	\N	\\xffd8ffe000104a46494600010101000000000000ffdb00430009060713121215101212151515151615151715161715151517161517171615151515181d2820181a251b151521312125292b2e2e2e171f3338332d37282d2e2bffdb0043010a0a0a0e0d0e171010172b1d1d1d2d2d2d2d2b2d2b2d2d2d2b2d2d2d2d2d2d2d2b2d2d2b2d2d2d2d2d2d2d2d2d2d2b2b2d2b2d2d2d372d37372d2d372d2d2d2bffc000110800e100e103012200021101031101ffc4001b00000105010100000000000000000000000200010304050607ffc4003a100002010204030506050303050000000000010203110405213112415106226171811391a1b1d1f0073242c1e13352f114236243727382b2ffc400190100030101010000000000000000000000000203010405ffc40023110101010003010002020203000000000000010203113121041241512261133271ffda000c03010002110311003f00f14090c24c00870531ee0049076013093009214afab24b5adae8fa0d27a01c7717b34895361c29df721b93d09ea63567d9596fef0b0fd1dfc5226a4efb12ba09f269f5ea2da799433c3ddf3b1730b80bf426c2527a7efa9bf84c15b5b3bfdadc9eb5d3a31c5db270795f135a6ffe7e9ef34259123a0c06056afefef62d7fa5b90bc9f5d79fc79d3cf71d90b49b4af639dad41c74b6c7b0bc3ab59af4fe4c2cef208d48b9416bd2c3e39bfb4797f17e771c1e05f256bf47cc97154a50d786d7f7106268ca8ced24fef9a34e1fee53bc65c495bcd783fe7de5fb71f5fc30b15076bff25366a6222e3c9dbde8cfa90b14cd4b511340b4131862844c71980330186c1600238840120c38f60011ee3d87480122440d828332b60aadef60e1f422932cd280a687a512ee1f08dfd01a145e86d6130d27b212e95ce2d67c28dde9a796c6fe032d9497f97f32de5d93eaaf7f17b1d660b00925a5886f91d7c5c1fdb23059359eaaff000d2c6bd1c22b5b5342305d09614990bab5db9c48af0a690d3a45f8506fcac0d4a025ed496464d540a5d4bb3a6559c2c6767b25731daac85548b9c773cfa2e746775a72b72f15e5f53d9251ba717ccf3aed3659c3376475f0f277f2bccfcbe1ebfca29625c650e35a5f74f93e8cc7953dd7af52e6aa0e2fc3f8f42ad356763a72e0d28d810e7bbf30594482c1610ccd006330982603087b080241d0c1200715843a00690d141dc4b632b61f0b0bb3530f42fb9060a95a37ea686158b54cb43018257495ce9f0182513372d85ecce8f0f0d16871f269e8f16674b385a56356942e53843665ea5b11aea89f0f4d795cb94e0ade44187dadf12c4656dffc0d09aa3a5beab9053869b6a451a8afb961b34acda94ee51a90fdcd9ab128d58eff007e24ac74674cbb1ccf6bb0db49733abb6a63f686971537ff001d7d06e2bd689f913bc579ee2d2d52f17e9b98d5a69b4fa1b55df0cefe6be7a1878e8d9bb73d4f472f134a9396a2b91b6122891c6621334058213058308421001a0900834634e3a187400a6b40294afa12a214ad23286dc57723e44d867a95e94bb8bc09b0eecc4d2b9f5d2e5d52d6b9d5601dedd34f89c765edf33abcbaa69638f6f4b8afc6d41df62d53455c3ad8bf18684d7f0d4e5c8b4a48a8d5b5e84d8769b06d4b095dec5b4bc2de80538245a8c50d227ad2bca9f814eb2dcd49246762e90ba8dc6bb6549d994b1d4f8a2d7545cc4a656aaee9893d746a771e5f9ac1c25383e7b7a3d3e673b5a6dee7a1f6cb2d56f6aba5df9a383ad1dcf438f5dc787cd8fd75633920d4493d9d84d1773a268661c806680b0426300308423009068143a0021d0c3a60043555cc7448a37d002c6167dd2e6122e4d1998595aeba1b796d4515764f4a65b781a0cdec2ab34fd7dc7350ccd465b742e47b42a2ed28bf039f59b5db8e491dd616b2b6e5ff006c9a5a9c047b4914d6f6f8a376866f1970a4f4d77f4d09dc58e8cf2e74e913bc5ae76d3cd7f8f891d0a896e55cbf149ecee438f8cf8b45dd7f0b8aa5ad3ab9b5382ef4d228d6ed7518f77895f9f81cae372f7293bcbcdf3f2f04664a8d185d5b8d73d6cb4eade83c911d6abbb8f68d4d776576b6b6cc079bd46ff2b7f1fdce5f2ecdb030bf146ac2d6bb50e28abed7713a8c0d6c24f4a75549f4ba52f58bd4cb9b3f866772ff00252c6f16928b4feec0c9685a961972fa11ba7e0c974e89a60f6ae17a0ce4720c93fd4b8b7f95277f4e5ef3bdcf28f1d29c7c0c0ec6de30941e8f89efa6dd0b635d62f4e7de25e59dabf69f0345d19c60971524b54be079eccf50ed1d351c3d792d2fa1e5f33a3f1ef79ae5fce9d6e7fe22911b24900ce871018c13040187108c03438c3834e3a190400e8960c8d048024b5a57eaadea491a9aef6216c36b532c347519465bed1779bb79dbe469d6c1e0a9ab549c78ba5eefd7a7a9cb471936953a776edaa8e86c50c9fdac74868e3c32574a4bab57dc87e9f7ed744df53e4ecf8acbe93d6927e49abfbb732ea6633a4d6b75d7ea7a065d82ff006ef885c6e34a3469c65c3c5c31774e53d35f1dec7159ee0249372db7deefd1f4d907cefaf4dd6bf5fdbae9def62f14aaa52d15ec7638cc2a51f43cbbf0cf112578bdae7ac5595e2bc8e5dfcb63b317bccae131d97cdc9bfd36726fea0e17278494e125aca364d6a95f9dd733a2cc69bf6728ebfc183093be9f4fb66675d2bac4d4e99b81ecc55e3a908de31aca2aa36e32a6f85a69a8d9bbe87459af67294f8546097024935a4b4d2edadb624cbe7af7aed78b66f4385d9af97f0575cb753a431f8f9e3bdfac4c2651382b7b4949749377f7969d2b69634a4cad5d10d45f2c0cc39a28e4f9728f149ff7fec686356a4184adc2e51eb67eedc25f86b9fb2b9efc43afc14bd9f39cbe08f369b3b3fc4ac4f15682e91b9c5499e8704eb11e47e5ebbe5bfe82d80c26096731982c763300421081a3410082301c70449804883444987160c116f0b052d194d9630152d2466bc367d5b8d07095d5f47cb7476b91e21ce2bbd2fbf130aa619c92947a7c8bf94d549d9c5dff00739f77b8ede29d56f62aef9fc7f739bcedab70dee6ed6af75647359bbd7e64f8fd5b96fc68f61eaf0d46bc4f56a53ee23c6fb35a54ba3d6f2f9f153b09cb9ff253f1fee124991e2f2752efc347d3930a94aceccb943c1e8462fa64508ce0ed287d0d1856befa16251b913a23f85f97d283e64388e64b285882bec65a68c4cc5597a94b0956d34fcd7bcb799bb99552b282e27b45dd9920d5723f892a3eda0d3d5c75f79c7b35bb5b9a46be21ce1f9524918bc47a5c72ccc95e2f36a6b92d87630ae3363a44c113623410842301d04982200219b1ae35c0093248b21248804b71e94ad206e03601d5e558dd1266f51ac9db4389c157b1d160715b6a736f2ede2dfc6d55ea7339f4ada9d1539dd1cdf6822fa09c7ea9cbff00549d9fe2525e87b176725c51f43c6b26c7455449bd1b47afe438b8452d51bcbe9ff1eff855ac4d277bafb4578ce50dae58cc31bbf04549af1b2f564b82839c2f38a4df2dec8e7d65d7fbfcfa1c362932f197570ce9bd3545ca156e8c85d75ec492451c54b42dd591471320a32c6c6ead230b35bb854f26bd6c6cd696adb32b325dc6b9b8b7efd033eb393c7954b0cf58bd1a2a347539ed051ab6e6a31bf9b30b1f46cf89733d49e3c5d4eaa9a1c438140c4134358010842007630ec1004d8371d8c00e992c59120d004b701b15c4016284b435b015f548c5a4ec5fc0ced25e626a298bd576d837dd32b354a6f4d896b622d1514fcfc88eb6c73e67d756b5f3a604f0cd3d34d4ebb20f6ba71546a2b97f266430dc5e8cee328cbe32a714daf1b35f7b0dbd7c67166f7dc69602abb69f95eb7fd99ad87c65befc4c8cb68c28dd4e774f6b7d0b55730c3ad1c9f9d883b6675678d2963a3cd7bc7e357d399ce63b3285bfdb529f5e14e565e365a0797e63c56566bcd35e5b8b7c6797aae86750cfaf57465b6f4bec6662e4908650acdb92873ddf9223a186f69294a5f9209ca4f95a3b7c43a0dc9c9c55e527c114b76c1edf56581c12c245deb621f7dadd479fd0bf0f1fed50fc8e5fd63ccb1f89f6b39d5fef9b6bcb9153130bc496be8d47a2f9914a5a5bc0efaf2d90d5b41163170d6fd4ae602198e33341842118084c7158006c2682b0cc000388360d003a0ac24380227a35354fa10a15eda996363aacbe2ea36bc113e3e0d2b2767e5731f25c770c93bf2b1a988c5f1339ecb2bab36588a9616acad1525af43a9ca7b3d5786eeb38dad6b58e3aa7127c516ee9df43a7cbf33a8e29c65cb54d5f50d55f8779cdfae970f90b6fbd564fc6f65f034f0d93518ed1bbb73bb7f1303098baf24bbcade06d6071136b5d086b563b3fe6efc6c52c2c62b8524ae67e3f0715de5a34c9a15adbb6435f137bf4e7f425df64bfecf4abf7574b1938ec5ee1d793b3b3d03c9329788a8a1fa16b39745d3cdff236736dea27bd7eb3bae8bb25828d1a0f15574eeb71bf28ad652f5fd8f1bed3e6ef1b8c9d66fba9da0ba456c7a1fe2bf68d53a2b0749db8959a5ca2b4b1e509705372e6cf4b8b1d4797cbbbaaaca7c539bf14bdc25cc8b2efcb293fee7f2248ecc684aad5637718f54ca535676345c7bf1f0457c453bb6d0055042945a04c04210801c710801c163dc6600c8240a0900121c484d8038f4293a92505ebe442db3afc8b25e185e5f9e4af6e7634313114d45a51e5a054eb33671396efa19589c370ea84b3b527c6865d24cea327c1a6ecce170b5dc648ecb2ccc9597a5d1cfc99b1d5c3a97d76780c34216f03522a2ddec7395f18ad1775eac7a19a25cdf97439fa75fed1b75a5149adac66622b2df922a627355d55b7fd91ab93766aa626d52b7153a5a3e1da735be8bf4c7c5ebf3373c7757e137cb33ea965581a98b9f0d3eec13efd4b68bc17f74bc0eab34c552c061da869657bbfccdff749f366a494285350845463156496c8f1afc43cfdd6a9ec62f45bf9f43b38f8e4f91c1c9cb75f6b9cc7e2e78aaf2ab37bbf72e48a19b55d3857917f0f0e18dcc4ccaade5f13a6fc8e6f6ac6115a8dfab7f41dec1a8da9538f549fbddff623c44ecbd09c3d0c35949f4d3dc569bd593d3d21e6432fcde6862a36c8e748966acc792302b7b36313d840100c21998d2b8cc4c1007b92446a549cb645aa7874b7d58046a23285d93495dd9172961acac348cacfad1b599dae538e8e265435b493517e9c8e4f1d0b21b24c77b1af4e7c94e2df95d5ccb047a867796a5de8faa38dcce9efd0f57ccf0ea74d4e16d5269f2699e739de1ecde9e68455c557a8e2cd0c2e2a4ad24ccdc7c5f1b459cb78a4d538a726f44926db7d125b85827ada867f24aceecd9ecce17118fa9c34a9da2b49547b2f0f165becf7e16e26bb53c43ff4f4fa3d6ab5e11da3ebee3adc765f1cad42a60db5c1a4a326e4aa2e7c7f5e42fe90d777fb7559076428e1ed371e3a9bf1cf569ffc56cbd0dda9a6a55ecf6794b194556a6fc251e709738b2b7683318d284a4e4924b7189eb94edf7683d8d3693d5e8bccf22a349cdb9cb9eb7343b419a4b1559bfd09f77cbad818c38636e45b18e92debb50c656d3856c8c193e29b35b33aa95ec64619d9dd86c65b35bf4ae91467e3657928f576fa9a98f569cbc3eec64d0579b93e4be2c9cf0f7d4b897b222aab6613d6570e71d18c54153613d804f9124b63000430c6856108615a6628efa8988036e9d28daeb602ac12451c3625c36dba334389548b71e5bae81e7a3df1250c1a4aedf798766b7062f8af6d2dcb9a2be22ab8cad7b95225c5c2f1f232f134f99a8aba6b85e8cad5a96960b3b12bd4bf0ab3f8e2283c1d57dfa6bb8df38f4f41fb4b96d9b6792e5d8a952a8a50938b5b34eccf5aec7e712c661aa53aaf8aa537bf3717b3646ce9595e5f9d42d559d4fe0fe194b3052b7f4e95492f37c314fe2ccbed6e5d28d7b24db93b24b76fa1d1fe17e06ad0c65ea45c78e9492e77d62f97918d7b64db6b5f99c976b29c781af02e6679f4692ef5d79e8dfa1c2e7b9b55ad7e14e31eaf4f8006264bda3ab80c439c1de2f49c394a3f55d4bfdb0ed3bc5b8c29b7c12576b6dff49c9d685e4ddeff00b96f0b866da6bde5718efea5ad7f0932ea2b875de2ede80632adae5cc4cd476ea62e2eaead964fd6666552ed448b0f14ea4172e28fcd11ce4e526d17b29a77ab04bfb95ce7d5f56cc59cdea77a6bc6df52a518da1f17fb0aacf8e727cb89bf8dc3ada41bea13c17d4141b6f7278bbdc8b0cb4256b57e26b14ebc75bf89247542aefa8349746601700e49c223432c438cc569874304801498787aee0d4a3fe574226c7401bd0774aa479fdb4cab88e0d789d9af7bf02ae5f8a7176be8cb19a4549712365ea74cab14f86704f9fc40ab1690796d942325c85899de4fa15fe09fcb21c5f11d5f643359616baa9bc5ab4d755f53170586e2a891b15b04e32565be9ef2761e57a560329862f11ede2ef1a694a2ff00e52dbdc4d86c8ea51a929c6ab8ddb7a5b4bef6bec3766e6f09868d3e16e72ef4bcdf223c5e2ab55db4267438f951a57949f14bab777f138fceb309d4bfe98fc59d062b0318273a92bdb56dec8e56ab75a6ded15b797d47c67ba5d6ba8830386bbbbd8d2a93515a10d6aea2b86250a950e940b135aecc7c6d62d626b58c89cb8993dd3e614159799ad9145fb44fa26fefdc66528ab9b395c75a9e14dfc48ebc573eb3611da0b9eefe64b98bda23e0e37937c968bd08b172bcfc862a4a282ada342a22c5720086ba21845166b6c56a72d6c0076f162084019a866388569904c42000413108d0646b54fe97a08400f957f4fd5924b98c22b3c4efab3927f5a3ea74b2febd2ffbe1f343884be9a78f47ccff00294f0ff944224ac73ddacfe8cbff005ffe91cce1769798845f8bca9727aa557764150422a9b2f1a51a63888e94ca6c3ee8dbcb3feaff00e37f262113d787cfaa595edef2a54fcec4218ab34858cd84200097e52a52fcfe830802710840d7ffd9
8	Роберт	Геннадиев	Семёнович	1	2010-07-03	\N	\\xffd8ffe000104a46494600010101000000000000ffdb00430009060713121215131313161615171816181818181816181515161515181717171717181d2820181e251d171521312225292b2e2e2e171f3338332d37282d2e2bffdb0043010a0a0a0e0d0e1a10101a2d1f1d1d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2b2d2d2d2d2d2b2d2d2d2d2d2d2d2d2d2d2d2d2d2d2b2d2d2d2d2d2d372b2d2d37ffc000110800e100e103012200021101031101ffc4001c0000010501010100000000000000000000030102040506000708ffc4003b1000010302040208050303040203000000010002110321041231410551062261718191a1f01332b1c1d11452e10742f1152362723382162434ffc400190100030101010000000000000000000000010203000405ffc40023110002020202020301010100000000000000010211031221311341045161713214ffda000c03010002110311003f00f150942614f85d64c59456b65369b54aa4d2488d106e851d49902dafdcd82d7f4638640063dfbfa2a3e0f802f7f300dbbff85bc60f86c0d169e5a9ee5cd9a7e916c70f643e235f2081771b3446e7b39fe1078670c20e775dc6f1a81c80e6ad709c365d99df36c3f68e43ee55c6170a0479f969f65cee5c522c1303868007bed560d17ca394ced1dfcd3594d19ae4811c042235c879d2670353aac6094486da49efb9d518d4d49303d505b5234499e7f3b226170f8e6b9c58dd45e3bf9a9b4a9105c4b899d06c3b944631ad33173a9eee65183e74f34104920fbfb26975c5a47bff000859b927844c264944a74cc5f623d0fe3ee95c4013e1efc549638102c8a406c60a70679d93c32e96c6defbd38541e3bfe53080808f770abb8d70f15184113dfcd5b44e9afbf343a9cbd3f08a034780f4a7839638db4d7e80fa4782ca3da41ee5eedd2ee0df10131079af1be2b822d7b9a45dbea39af43064d95339e6b5657b1c3c571a7b851dc084f6bfcd740ad7b43f21e4b937395cb039238288d4308d4d9cd73946169364ab3e1f84754395b61b9ecfca160f0b9a0e80fbb2d8f04e139a264339684ff0a396741842fb27705c2b698863733f96cd1ff23b2bac3612e0b8cbef3c9a3901b283c4f89d3a2df86c811af7e91fc9550ee92b9a3a8d7137125a6351a7aae4d5c8e87248dcb58004d63c4dbdf25e6f53a5754da00ef924fac2ec3f4b2a3791f309bc3217c88f4f153b13d957b4fd82f3ba5d2f79be5f0faab3c174b1aed447d7c92bc7243ee8d839fcbd943d5b0627cc02a9871c61d148a38d0edd2354322dd9507bdd19b580d02aca5583949641ba06259ac0ea6dcb646154f60faa881c3928b5f19162b0516dfa800c1b1fc261c5b675d166313c50df6903c275f29f4543c478ab8e9e7c93c60d9a548dfe338bb1a0f59be277d941abd2ea2c025f248986dd796e26a39c644f7fe024a142abecd6c03b9d4f82bac515db22e6fd23d02a74f40759a48f0053d9d2dab52f4a9b9c47381f49596e19d19712331beb79f4ff00216cb01c3320bb808ffd478dc212705d05293ec261ba4b503bfdca2f6cf38f470b79ff000b5182e20caad17877bb77e861676b70a917823b67f2a10e16f699a4e702069199a7befcefa8f54b6985a66bb1d4a5866e2178e7f52b84fc2a8caa059d981fafd257a3f0ce30fce29d5696c9ef13b79fbdd0fa73c1c57c2d4004b8025bde13e37a4894d5a3c0de275518b614caed8d75920f87b2a25410bd3473c44bae4d5cb1411aa5606897bdade67d1465a1e8a60f338bbba1724e5aab3256cb8c26121c001611b2b838c81969893b47ca3b4c5a7b3b92d6c13834068327fcc9ecf7cd48c170c0c17777888bfbee5c0e49f274a445a7c346a5a4bb5924cc9fba73b87c47548f7cc2b035434db4de6361d8b9f8c11ac059498d48cde2f83e63a2aeabc1dc34fa2d67fa8d21f33da0dfbf642a98ca26c1fe40fe1514e44dc62638609cd4565123656d8caf4b670f5fba881c0ee9f762d23a954223b3eda2b7c062cee555b54fc153ba9c9dae478f069704e8d3756b42b2aae1e0c2bcc261a545954cea849d154f10a2e3cd69598643c4e1650b0a662ebe1dc75dd47a9810755a1c55300c2a4e2f8c14846ae3a0f7a05452774674461458dd82b2c155a4357d31de42ca57ac1b0faee91cb61d806fde9ade943db6a1498d026ee825596272212caa27a461f134447fbf4fba60295531cc8eab98ff00fabda446f75e60ce96e3ee258e91a00db0172072d3d54dc374e18e1ffd8c3348d016b5a00da2759d7f28bf8ec58e7567a4b7122c49d7d8446d404dbec3f958a716399f130b572b8dfe1176669ec04ddaa4f05e36e7f55f670d47dfb949c5c4e9552364cc3b4ed7f7a7629f4db2dca7b8caaec054255ad33a42c9d9292a3c23fa8bc17f4f5c903a8f322d65912d95ef3fd4ee0a2b610b80eb53eb03d81784b45fb57a5827b44e29ad582f83dab948ca572b09b32080bd33a21c3f2d36db513e2bce704cccf68e657b3f0da3969b401b0f0b6abcdf952a491d9895b08fa605feb3f95558ec599ecfc76abbc4b2de0b39c45a60ae28f274d515b8ae204bb2b06671f733b28b89c8d1356acbbf68f941fba154c57c290c19ea3b522ffe028783e10eaae9aa7c3ded0baa11442727e8e3c7f25e8d168de489be9e21252e3d8a7d40439a1db08b18be89d8fc07c3ad90921ae16fdbcbd146c4f0539875f2c6a4837ed6aea8c1559c6f2734cb2c4f13aec8f8f4dae6926e05e5c263d506a52638f5269bb9697ed1e57521f812ecb4812e2480db974ed207f6f3d968ba65c15a29b4d83da05f43ddda964921b0cdc8cce1abb81c950413a1d8abbe1cd20aa9e0a3e24d0a904c4b1db8204c2d2e1f0a585b20cda7d17364547524ecbee1746403e5fcad0e169dc4ebcbbb58551c15c003630d31373331bef73f45741e49cac80f00652ebb493723283c82e72e913e8b640ea9062608d102be1e27b55a31b6bfb2a0fc3266493d63a88b6a23b048ba342aeccde370b726179cf1ec51a6ecc47fb8fd01fed6ed3cb7f55ec7fa704907707d42c4f48ba2eea952a3c060cd9449990199622f03422dccaae3a4f90b57d7661f1dc20fc1151c7338919b93420713e0cfcadcaf05c6e04c030068481a4faadee1300d0cf8751ccedd343e2aab11c06a30c53c4512d01c407bb29cb7900c5f4d177639c7a3cfcf8b226a48ccb6856c9d7a99880758241bd81378899857bd0fe07f130ee2f6cb5cf244e90001bf6ca350e8f30968ad8ba4d6e6399ac399e5c60c6d96c56d29e2a8b5ad6526f51a041b010204473efdcf3211c9952546c3866ddb304ee8896d43f09ee613f281bffdb90d95ef0de058991f198091a3da4127bcccfa6cb5d83c3073b9cee45ff31ee39df53a62221724f26c7628ea5370cc039bacfa2b9a74e2396e8c19091a22c4ea4c776c14920b760717403d8e69d0885f3674830068d77b234263ba4afa65cbc6fa79c22716f81ac1ee995d5f1e74f9397347da3cea122d37fa1255d7e4890d646678337fde67fd82f69c13486dfdd978df053fefb3fecbd9b08f803c179df2fb476e0f64b0240de546c470e6bb6953e85323ebce39a92600fe572a3a0ce378631824375d4de556be8520e167127500ebdd26c3d2da2d89c26a6ffe2c3d15657e16d7dcb4b4c6e608f2b278c9a60a465b8b50c3d46e5797b22ed300b8126044193a1f7ad7d1e1ac225d8a7012041a5d6b9891d68ff0afdfc0438e66bde46d1948d20ec919d1b3a65777b881e802bc73b5d1296084bb05c29b85c39ccccf52a5c073c0889fed6cda7999df92b2ad8ba55499a598f6b898ef8b0df9a5a5c0408ce7c05878ee76f256143858b00206db04b29b7cb2918c62a922b2860d8e88a6d1117014c185cc4c8906c76006e558330840b75759de761ca146ab4db0454cd1507c30d36022e648e765194ed8d1882e2b5994f3b20fc47d325bfb431a74806fb9f257fc11cd34d8f8d1a24c41765100f718b20d1c3cb9b34c755b0d71b9e503c214ac2d473dce60195a0755c08eb1b8200d6d09477d50ea40d5767048a82ed699037009e6a7614ba007b81740cc0681c35f4210aa65616b8871764daff29b88dcdc9f3532b123e5133ac6b6d35f24c9092207c797b983507e9a8fa7814dc5e103c297504598d0608cc2608066f3e68866e236d515c00c2712e06f26d07b0d8efb8fe156bba345c6f9dbdd0e1a4686fb9dd7a5be80224882a262286582012240b09893a9036ed4ea435d988c37450c91f1e39cd3bdf7f9968301d1c6832faae74ed668248b8e7cfd8575f08db5b723af7a3340dfc3b106db372ba1d86c3b58200000fb73521adbcceb6036e7298c3da862a1cc73345880d320cb4c5c89e728a11a64d6a656a7bf2ba565406082083c9755744ca22720eaac2f4869038c1b02d1ae9a95b573f3091a1823df9af3be9bb8fc6046c05fb537f0095ba2e7fd269ffc572c8feb1ffb92a1abfb3abc48f30e1f532d569ed0bd9b015416827480578935d067b57ab704aed7d2638fed13adeca9f2974ce2c0fd1afa2eefb47fed20d948a15330cc45a0448bf88f255f46b9b40da4ed6dc7d3cd2e2f89b2896e69eb383440bcbb4f05c6749694abcbae22d22489703a9ca8d59cd6b497682e6db772ac75682d912e9cb2356b5e75eeb0f246a38d6825801ea902729b970999df795ac6d495429b5ad01ad01b1220002fd810716e0d1274900c09d4c6c8cc692ebbbb84765e4efcf6513e2d4ce29b48245de0cd81d21d1733685acdaa08ea6c11f10b475865922e7623b75494b18d2ff86d611b023b3b36df54faf45998bea3010d000276e76fba63a9b9b565a06577cc49336d82d6cdc012f706d4905f0f3b44b09d1bce04f7c27bf0cc22e3375b3806f07b397723d67c6becfdd42a65d2ebdb611a7e6eb18b165520b406cc9327f68fbf24465221e5d95808b34c924837708d946c356806764fc180dbe626e4f5b524f2ec58745ad3aef307203c8f24f6669916999133050e9e31a48699d2676d79f8fd53db8800c6df94c4da628ae092d3631e31cd2d466a41df37658687b10f0a5c5a33fcdb9fa7d93dc763ee530b61dd040d21296d8c0f042d7c146c163dceab529b985a1b76bbfb5cdefe68d9abe82e0f3b992f606ba4c8998136f1884573445e10b138e6b5eca79807bc90013721a24c0df6f54958bcb8434650d907311d6263296c5c587e10fe0792bf0d543b2d5a2d2067c8e04101cc063344c5b504edc93f8ce39d49ad34d81e4b809fed17dc8d2e8ae6b18e2d10da956098bb4916d0e937f3482438b434868e725ae88272dfab627692421c8fc1328b43043400de5601a665deb68ec4b8d369898eb5bf7022046f3750994be1804bae3e627aad399dd6240b4f2ed2a57c5824779fe02726c6517114c48bc691117d21647a55842ecbe27ccad534fcc6f262dcadecaaec7e1fe26d24596e810e6461bf44792e5a9ff49a9fb0ae436675da3c029d3bade744ebc3729d9635f44826cae380e332bc02baf2ada27958f867a560310ecc018cb79ecf62133101b51c0bb563c1001b1701669f020a88caae2ceaea622fdc7ed1e2a4d17b835f39664061d898004f6e691e0bcfa3b512ab3cb6a08759f000b4eb25cdf022c8b54d473aa31840ca1a4106e1d065a479210a84c06c660e23ae225a0c3b29f54466222a3e000d306459ce20804df4034419444cc27c56d38273547489366b4c77d87b953303d51244b831ad79125a607f6ceb7912a0e22b39b46e339df405c336907c14ba55cfed2010db5ad3ae9cb743a03e41d3c43c567e7272123288020449713df64da18dce09d59a34c5ddac98e48188a4d6115010e0d71ce5ceb35a412636e5652c90408168ecd351a22ac1488f8aa96eeb22d0ca1927c557713aa0059fe91f1b73410de5e09ebd1a2bd9678ee39ac5bb1170dc489106c485e358ec7d673e4bdc3941200f25b1e8d711aafa2054996e87723b7b55e5f1f58d891cd72a47a2e1b16e9001911bea4ec99c438ab6875aa3c35bda616738471071a912aa7a73d1fad883f1412e22d9468077294209caa4ca4a4ead237dc1fa6146abecf6e5100419cc5dcc6dcbcd693e2070042f9ff8270aad45e1c5ae699ed5ec3d1cc439cdbf25a71d2549da025b476aa6689af43a41af21f2e04666c4db5832df091deb88b2e04346c05c93a01b924fdd626833690998eb418260b84f2f4f248f740ceef98070b4c44ff8d50e8e258fca5ae0e0e12d22f23982894a6f79074ecb411e93e2b0c370d8c6540c7069eb02412d3d9225217cba6464ec3aba62fcc6be2028868547d1c9f108703f36ce127ab683116d93714c0d194fc912626d07979f8a37f66d50b50dcbb3453901c1cd2497ce5113b1397cbbd4c2db933b47744aaea18aa972f6439ce686b66e184fccee51d69d740a737b373e3dfe5745025c1cda65d3a03a7e148e1f830cd4c94dc3b6651d820dd6622e992b285c933048b5096cf9ab8186d4710fdc44f6ab4c4f066b08783a1baa3e0b5018e616b30c3e24ce91eaab96d3b171a4d13386540e6653cf79efd95a332017f9479083331de3559fe17521e5a55e33e507ba6796fdcb9e5c33a21d036d5cd586673816826059a6341db63adb42ac28b018a801f948837241dae54375212e2498243fb246d6ee0614bc331a05a7281963ee23bd23456c3e0baf4d8ea873dc16b40ca076113788dd497d7736a306504381cc6fd513d502d06e4ae63c340681b5b90e49a69c904b9c4889d84b7b3decb519724e7d36b9b90805841691b11baec800809b4aa03a1443a76a284655f12c2e769590e23c1ea693217a06550f15870764ea542a479ee13a3f99d0e12ad1dc31cc10c5aaa58444ad42007113a26791b328fd18ae1d837b6a6e17a1e0307d5512be0059c15af0d5393b632748062380b2a466171bab0c170f6d310d0a6353c059242b9b7c032147acd0410620daf1066d17529e76e682f622cc99d4400034001a04002c046c06c885da6907be676811a58efb28ed80bbe2c1000379ee117bdfc9608faa33d3cafb6605a626d9ac402403e89bf0e006cd840ef8095f5e622f36fcea8155f9731b93ad85f901dfaa630e2d39a6d1117ef3b6812cfbf31efb90054f98bad133bd85c7a1061118e263b34d74b1ba290b2e878c606bf2cedf5ba9a312d3baf16e9674b9f4788576c75585ad1e0c6fdd0711fd46a99618d8246a55a38325f423c98f53db7f5239ae5f3cff00f34c5fef5ca9ff0034c8796066f098a34dc085b3c171669602d227712b044a56bc8d0aa64c6a468b71e8dce0b1c0d7107e691f7fb2d5b09205f511df7f55e4584c516546be4f5483e47fcaf58a0fccd0469f49dc2e5cf8f52f8e56496892794ccce8e1631c9198ebb6e6fac8bd88d4f9a8a4e8dd4c6bcf493e3aa736a116b9edf2d573d1727b2b3e6f1940d779e6a4d3aa6d9a0db5e7db1b73552eae40bf6c8b786b08d87ab6112445bea8506cbaa2ff00e634528155385afbdfc51ce2ced0b508cb094c70503f5a39a73f14d892eb6e81932c594c6aa761e90584e2dd288ead3f354f43a4f5419ce536aca4629f6e8f52c5d3b597617abaf9ac061fa6550882e9ed41c4f486a3ec5e56d58eb12e9b3d5e9d507420f8a23978d51e3b51a65af32b51c1fa6c6c2adfb53d344e5897a66e2a3d30bd43a7c429d401cc32a2bb893418dd2d92a68b17842608dcf9f62053c703ba254772582b80f9bb131d70a1d2ac731041d019fed33361ddf708aeaf703cf6ee1ea88d430d327aa4ee08ecbefe1f452a837edf4413a8edf2f7aa6716c5fc1a156a9d194deef269213c15b2591f07cf3d26c47c5c5e21ff00baabfd0c7d94109ae71264ea4927bcdca7af6170a8e162c2e4e95cb0081296522e502c72f4ce89e3be2506c9923aa7bc69efb5799ad2f42b1f92a1a64d9d71de05fd3e8a39a371298e54cf42d2faa50663651a64c8f7c977c5b81e33e91eab80ea0f52983adff8d11b0e3493e88127645a46d740cc96ea800850f158dca10711575f7dea8f8a3dceb0df44ca36c56e8362b8c80e17b02aab8a71c73c900c376519fd1daee339b5e4a6d0e8f65f9afda655f5821231949956dc5db42547754a93d56ad951c0300bb47a2b4c2f0fa25df258e5d87be6829a3ad7c66d72cf3f6beb1d18a5d1c3621c348ed85e974b84d100181a3b96a0ff002a550a749a0086fcb1b761f3f996735f4523823fa79b50e075c9826ea40e078916b4822d378337f311e4b798bc6b0438e59232bc348bf2208e574a314c3046845b783dbe297728f0c6acc4e0bf5748d987cfb3b5587e9f1ee398d311de256c285464b65a24cc78093f7568d748b0b24f22fa38b2479e0c5611f59ae19c42d6612b584f7689988c3824cec9b46c837627e13894c711dffc2653ab2db8bf24c06341ddcfb56410f4dd378d2d074b4477f7aca7f55f8a7c3c09a60f5ab38323fe22ee3f4f35a6a7db793cbdf9af1efea8f1915b1791a65b4464b699cc67fa01e0babe3c2e473e697a31f09ed125305d11a6ebd239192322e42f88b90139202e2b82e503a4e44c3d62c7073750642195c8518f4de158f1558d70dc5fb08d94bdf530b01d1ce29f09f95c7a8ef43cd6d195970e4c7ab3a61327d3aa7f9460fedd5563aa1ba77c609351b626b8ea9a30c0a0d3af254da0e4ad1ad58cab50b446caaabe31c39ff957ae83b2835f061d364d1a0b6d745157c5b8de5319c52a0d0a9d5385ce89d4b8212ad701966c888ede3757f714c1c45e772ad69f471e765368745ddba5df1a1bcd97ecacc131cfd7f2b5bc33056129dc3f82067a2b6acc34d8e706971689ca35246c14272be82e727db0f87c2b63416f4daca5e903dd90b0e7334182d9170751d96452605f64a9136fd11f10557bdf752ead5062daf61e44df92895932350e1512fc48d5437d5235d944c5f126b017b880d02fc952316fa1653490de94f4806170ee78ff00c8e96b07fc8ee7bb55e2155e5c4926492493b924dc9575d22e2eec5562f3f28b34721f954af0bd4c38f489c2e7b31cc48d29581369eaaa28f5c95720291404888744d8502c99cd6ca614760808056326705a7e05c4096e526e342b30ac384d48725946d06e8d78c4484d35ad62a253794b9c2e6d47dec9d46b153f0d8954ac729546a46e96511948be654251e8df755942a594ca75149a2ab92d28520740ac70f860aaf0f582b5c3555368a22cf0f4c594c6530ab998a01169e244cef6f189fc940c589a6932c6dd9efdee834b120ee94d45815e828309955e8352b2056ad011144af502acc457f72a2f10e221ba9545531afa966e9bbb60ab0858b29d1638ce21781a9f558ae97e389229e6b6a797776ad336896b0bce91f31dfbb92f3ae235b3d473a66ebb704159c7964d90f35d216a51aa4aa57613435c98c374f3a21ac320d9bb1726ae40d409c57048d095c544716a3ed0829522015c1c11f067ac808b86d5633e8d4503213dc1070eeb028ef20ae77d99022e846a55d467ca6a23597387aca652c42cfb6b908c31091c07533454f1c415368f15859238b4cfd6c2578ac7594dabb8a1d65170fc540b03e5deb0e788948cc79e6b7801e63d4309c4018d14cfd70e765e6b84e2f9624f8ca9678f779f553785a1fca99b9abc402a8e2bc640102e4f25973c45ee3027b85cff000a4e1b02f7119ac274bc91de8ac6a3d88e6df47329baabbad2e3fb41b0ff00b3becb4382e1c1b05f16dbfb4770dd170b8663040000555c7b8db29348913ef409adcb842f0b9656f4e38c0ca58d365e7c1c8fc4718eace24e8a2cecbd1c50d23472c9ecc633e64b56e948832909954308e164c212b9e94201117254ab1ac104d72726b8a88e86a265b2e6312d57ecb1af9045170e60a0a7d337582fa34d836c847cbb289c2eacc2b27b6eb9e5d822c8ce6213829ae6a05462c98c472534a7382420a600c738a1972239206a3661811594d39b494aa147b106cd4751a2392b2c261275b04b85a2acf0e0053948748360a801f2b54cace14c171746862634e455762f8afc3103559cc6638bccbdd61ee02550727c8ce745a714e906690c2ef3fbac6e3f14e71924945c4e30bacd16faa2e0f84baa34b9d66f35d98e2a08e694db655d13629bba357606120218e6af62dfb15fa26b459735d364b52d081bf01909014e2860dd61c7ca54d5cb0043a26245ca23a2451407eab972c08f6352b572e58665df09d95e9d972e5098911aed131cb97254508f51092ae4e8009e958b972c6245353f0e9172561458515298b972948645063bff002159fc6ea7bd72e5d38c9e43b05f385b11ff00e75cb95327a228c3637e63de9068b972ac7a0fa074f54fc4ecb972217fe863b4426ae5cb0c3d72e5c818ffd9
6	Прохор 	Захаров	Джорджевич	1	1980-03-12	200498	\\xffd8ffe000104a46494600010101000000000000ffdb004300090607121212131212121516151717161717151617151d1617191615171817181a1d1a1d2822181a251d1719213121252a2b2e2e2e171f3338332c37282d2e2bffdb0043010a0a0a0e0d0e1a10101a2d1e1f1f2d2d2d2d2d2d2d2b2d2d2b2b2b2d2d2d2d2d2d2d2b2d2d2d2d2d2d2d2d2d2b2d2d2b2d2d2b372b2d2d2d2d2d372d3737372dffc000110800c800fc03012200021101031101ffc4001c0000010403010000000000000000000000000105060702030408ffc4003f1000010302030506040405030305000000010002110321041231050622415107136171819132a1b1c12342d1f014526272e18292f14353a21516333483ffc4001801010003010000000000000000000000000001020304ffc40023110101000202020104030000000000000000010211032112315113223241617181ffda000c03010002110311003f00bb9050840802252a0a0429108401290a5212204949294848501291cf4cfbcdbc34f074fbca927900dbb8f90e7ee3d74555edddf7a9881344bc33c5f55ad024ea1b009f127c239a8b92d31dadec76d9a3447e2bc37ccf8c7dd46b6a768b42983929d4abd3235c478498b7cd540fc61177d47bc9feacac936d2a3afaf282b0359ee6e5008263e178cc419fccf3f0fa955f2ab78263b63b52c6103b9c3b1b27e339ea40f21027cc8d3c6cdc3b46c7589a948f22d14ea31cd77882e208fed3f750bc5623238b72bedd2b87be7abb2825be565bd8e655f81d4996cc5d5201fee8363afc720df5ba946a2cbd9bda4d6339834b440cd9a38ad624821a4f29b7f55c291eceed06938075400379f1303dbe244dfd0aa1e8576b2a0617f09e07098cc3496f581100f41124ad1b41959af6e5ad998490ca8099e5691cee3875e21d51174f55ecfda94710dcf46a35e39c1d3cfa15d21cbcb1bb9bdf5f03880fa4e91a3d8e272bb916dee224c739ebcefdd87bdf43174db55a4b241f8e04111ce635f15284ad24ad584c407b67cc18ea16e52824a0a101012842100842100164902102ca1092106c44a1108029129488110842012254141a6b5523e16e63d2c3dc9d157fbdbbef88c390c0ca6c24c1702ea807416cbc5e107eea798bae183493adcc0f124f2fbaa3f7ef681af5cbdefe06cb590c0d6024dcc93c4600e7654caaf8c46b6f6dd7d6ac5cf7d479e5cb4027874007ef55c580c74bf20a79c9e5c6449988bc0f6e5aad780c032a5601cf74380f885cf30201b8d4c8ea4dd3c623681a2fee685dbac8641703d5d9a60c72d794850b46e66cfaf4789ed6b1b041ccd70201ea0bafe84cf429a31789a0ecc1949f6fcd52bb29b5c49bd9c64081a4df98109df1a1c697799031f072bcb88cbc8912e8a6d3c5240cc72950ba9879a800748172e8360dd6d331edaab44647ff00e2f13dc96bb10723a5a2930d32207c43347908041b95bf05b31f5199e9d1a74c72aafd41e73c0d6bcf8c02275e69b3ba777f4d9543400d81603287410082246b306fc5e29cb68e2dad6b5a1c1ce26cd24c0665b977516b4cdf4515327c9b8d2bb586b36335cd371cb23f33413e22401c8c4c9585279eeaa3b0f3c258da8c244c3ec1edca608cd0d91fce3addb6a005c1c04126411360208224f173bcff009dd84c41a61c4e58caf67305cd749831aebf69d1594767f0cc2c6b9c034be62c73580b922d05d613d0c4271ddbdb870cdce01a8c6ba1c38780176a6478c74e21d537b71e0e46e4040712f683940b18126ed003899817fedbeaa351d45d52965cc38834110672901a5a356913a7f4e964d0b677537de83b3709a6492ee1136265b6100db947a8565ec5da6daec1518f6b8730391165e69ddaa2c73da5b5f2c5c43831ed81a3a60380d09b8307456aee2629d4aa32997b5e1f218f648e2024b1e347481226f6d60855f553adc5a8110958e900a15d46284a522010952a0c5280950804a1225419210825012b142100842100b0ad503412e2001cc980b350ded3b797f82c30cad05f5096b731100c4931ab8f41a753d5445b7d77e3bc2ea345cd0d26fcc9601aba0f0826c1b63124c5a6afdb9b5da6a5b8de794f036d0018d635ca2dcba84d18fdab52abe0124da6e6f03c3c16ad97c35017b7420f3b441b7a1f4906ca9afdd5f7fa8ec7527333973f5305d17768623cfe9e4b6f7a5cecdc5d6c331d3f319d74933eeb3a5b26ad5327365749902e449b01c8733e364e3b17769d50f007738888e9e51e3cd56e51ae3c76936962aa6229369b0340b5806e530606b331e640cb32b3c16c9651a350d77097fc0008710d75c9ea0b806827a3cdd3ed2dd2c5360b4b40170d9313d743cb51f45952dd77b416d526f32399f225a6d6d3c157cda7d231d4da34e1ae686e7e225a4580e1e67c5b6f38e49ace289a6f9a4d8a840900980d9072cfc248b4c81c2a5f5377184014e9c007e1249cc7f98db978fb251ba4419a841004068e5d7eb68ff98f387d2aada90735ed20f5169300d8f9c82478a7dc3ec87f773e24b63a46a39898fa2996c9dd16032ea71aea3e19fbc7b4a94d0d8cd682205eff00afcefea5465cbf09c7824f6a39f857d121ef04b4920f22483241241d627d8f24f03678aeda6f02e7493a8061cd161c42e63ab4f5533de8d84d34cf4067c740143fb87520193c2e2e2dbe90df94fd82be3c9b532e2d7a6cc06c8797e7000a8d716be39b81226da131e461dd53c6c9dbd4f0f580ad4a6812054227bcc33b35aab1b12c13796d8df9eac5b3b69bda6a071e2747bb8ba0fbc9f33ef86d1db5981a7507e236d7d48d241d012d89eb3e6aecaf534f516ccaad7536b9af151a402d782087022c6458cf82ea855af62b59e70c585e32b482c61033358e1682d265b20eb70411685659578ceb1425442208842100842102a1094040141488402108402494a52420c5e6c5503db45360ae2a54a955f51ed2da3483db918c0389e40075772b4c782bfdda2a03b5cd88f6d715dce19abbafd5a1a006b5a0e8d008b9b924d9bce2a6219bbf49ad2e2e821ad274bd471b068fe81a9bde3c5756036736b572c613958d689e64974bcf4379f35c7b309cad69710c7b8bcc1be4a60e9f2f61d54af7568657923849bb9bd248807e667c7c2f4ceea35e39dc4ab65eca6b9a465e1168ea0693d45e60eaa4581c1369b40688e52b9b643001239a7414f92e58ebb5d14e88202c711b39ae5ba80b05bdc569a8c6db2b81bb2d807c23d35f7589c1347209c4b9604dd4ea27cab91b840b0ab4c2ef2b92b35459d1298b6ae0bbc05bc8feaa29b7f62715270fca6e3cd4f72f54c5b7797afc963eab69df4a877a7026955194738f783109c71545f530ada9529b5fddc06bae2a651fd40de3c7583a1d5f37869d33529bdda492e313197981d67e5e69a7686d175014a913f86e3544f287e4349c7d5af1e52baf0b6c8e4e49acaa77d85e2e9d57d52d6e57358d690272b817120ebad8fa9375721548763b84a0712e7d27b995fba399b9b85cdccde2c808e2b8137120f3b9bbc2d231ac50842940489652201090a44192548950084210084210090a541081153fdb1d269a46bbcbac451a6393ea5404dba06b649ea6dc95c0a03da76c935e953a54e01151a5b3d4cfdb34f9aae498a6364b1ae82203402397c2c99d7a96bcfa009f773eb07beb3a753f3991f28f5951f7814a9e42459a470ce80904dbc1c7dd396e2d420bc588047beaef99fdc2cf3f4db8fdc5a9b3fe1faa70a625376cdf8177d2b1858474d7761d9fbbae8101725378fd92ba9a01e7f55ae2c72f61f0863474091cd1c8fcca1a07553a415cdf05c55dbaaeaad540e6571d47789f92ae4b62e67ba130edd6dc74e9fbfddd3f3d8547b78992d9e7613ea3ecb1adb14476bd66b60b818361d0e6275e7ac69d544315573d32cf88b1ad2c37221a4d8c8fe5e47abb594f3bdd54b9913041197cbafd0a88e1f110d2393ba6a0b620eb73a2eae39d39396f7a4f3b17c255a9b41959a78199b310e2082e078489bb49e57131a2f48aa27b18c3d4a752a553489a6ee12f139730bb5c3dc826398579d37480b495952a42952294042108058ac908116412254021084021084010841080802a33bf60370d52a09ce1bf871af79ad33eff0045265c3b4e86710448836f3b7eaa2fa4c7982c41617718610091f1db51ebf64efb82d9a4e7c5cd483e8d027e899f7d61b58b9adc9c551b947e5caf36f0b11ec148377a9e4c0d30db39c1ce07fb9df580b2cbf16d87e4b3b02f68636e2217453ab4dd60e6cf4b4aa8ea6f03a8300a8f24e8d608f72797fc2d15f6fe333b72d3ee8167785d52400d92038d8c02411a74d16730b7d36b9c9ed73ba9c5e5654f13162a95a5bdfb4034b9cc7656b802e8e198917e56e7eab3a7bf55cba6a5874d0f8414b8650c729576d1c570faad6cc4d8cf8a8c6ed6d6ef288739c25c330bde08f4ba66de8de5ab847343980b5d25ae067d0f8aaf95abf8cfda74fab988bad6faad912e854ed7df8c5ccb03449d3941e492aedac797b0bda298730bf3bcbf286031360604db42ad30caa99678c5c4ec5d3980f6fba6bdbb59a18ebde3455dd0deda8d6bfbfc3bc0610d7546c90d2470c8201b8ebf55ab178e355a1f4ab4b2458ccf523c145e3b3da71ce5f45de4a00d373ef6009ebf147e8a1fb31ad790d33d44728b999d558355b9e896102ec20f3379227c622ca0581a2032a387c4de0024c971ce0bbd010b6c2f4c39677172f607b42ad4a588a65a4d2153331dfcae7097b3d0c1ff0052b7d557d8260cd3a18991abd9ef0eff000ad45a46594d5d1121294a452a84210804210804a80b2083142528408842100842100910841e71ed67633a9622a0cbc26a877a543fe61766c3c3f7b45acb4068117b408fb29df6bbb3d95052cdf9daf64f8b4b5ccf9ca866e3c06b9ba16bf29f51fa82b9f3f5a7561dd97e4dd89dd5878a8f6b5ed6ba729046602e418f3e5d14ea8e230d59b4dc7331cc194169613949f84cea3cc4fcd769c307374e775c0762d0cd39489d407103d82ce7258d6e18deac76621d43b9345b49cf6be4ba48ccf26c4920dcdb9428e3b7268161fc3371f0c8ca09d0801bc267a429361594d96a74c4f5d4fb95d351f9411fbba5ced4cc649a91c9bbfb0a80a4c63a930e56c02409f7894d9bd5b029d72c60a6d80648005da0b787d548f633beff00230b9b1262a832a37d6cfdd88c8dcfc3d3707f779848305d611fcb0047a292d6af87a8d6078cae6821af639b99a0ea38ac418d083a2ea74384f34dd8cc2d37fc4c13d602999d9771171994d5867db270a2854a4199c54399fde1e27bad04c6ba6960a2181dd47d3cb02c4136267d64e8a6d4f61d3cd98344f5378f2929d3f86cad93f74b9d2638ceb4af7174fba6e52791249e73ccc28eeed61f3b6bbec4498f209f37f3141a1d07c07aeb0b0dd5c29a5873201ce32b1b3c4e73ba0579f8abd5cffa5cbd9ae0bbbc266220d47177a0b7d654acae6d9986eea8d3a7fcac6b7d8095d2ba319a8e4ceef2b4884214aa1084201084a500b20b159040852c242129418a10840210840884b091044fb46c2e7c3b5f1f03c7b3816fd4855ad26f7351e01b3d81c3fb98efb830aecda581657a4fa55272b8418b1179047883755a6fbeebb309429d46d4a8f71a990b9f166b813f94002e05fc7c9639e177b6fc79c98e9d1b276887b46929cc4155e6cbc53986f3afb475534d998bce012b9acd5757b39658e499b1f8d14de45cce9ea53e03694cd8a7305532466302fe7fe54d4e27bd90c80679fdd35edb39087dec63dcc4a79c0658374d7b6f10c0609178f656bf8ab2fdd5af67e233badfb84e0e8e6134ec8735cf739bd01b78ca74ace85589ad751ed099b6c6d76b41fdfd526d6da197f6542b6ce29cfe11d744c66d37521b3194bf89af4d87492e37f193f65636ebec9654c6531947e1b5ae27900cb981e2eca1473b3eddb38dab5cb6a647516b721896cb9cecc1c35d003faab7375776ff0084cef7bc3eabe012043406e800f5b9f25bcc2db3e1cf73925f948122112b7729108420108420128488940ab20b19420c90842044895220108414085088420144fb4dc2e7c0b8db82a5375f4f8b299e838a7d14b1716dac00c450ab45da54639bee2c7dd459b8997554060ab64abaf013127f4e5fe14d365b729f3ba846d1a2fa795ae6c3e9bff127911c3e1fb1e0a5fb23100b1a49fd8f45c99bbb0c92aa6eb2aefb4ac2556b995e8b883f0ba08e52458ebcd4b6aed86b434e80e822e54637a31a6a814e6cebc738322e27d20db5f463eca8f60bb4aaf49818f64916981faa64da9bd38bc4d4969201f2bf94d87eeebbb6bec86777c83dd71ce388de7c45ba0cbe29cf09b298688786c385a62c4e604691d7f765b7db3bd32fbef5b4c7b3dc33db879a9f1b8c9bcc08103d948f13a150fd8fb46ad29691c220198b133f63ff008a78ff00d71921b20820990418035d794d9615b4a6cda51249f1516a77ceff0041d34074527dbce01a49234307a4db9fba86e26b965070693d2d7278b41e249f980ad8446556a76254670f88ac347d6cadd34a6d137e633172b1d30ee2ec5fe0f03428110e0dccf1fd6f25eff9b88f44fcbaa7a70e57741488429404210804210804210102808421064842102148b24908121084204425420442ca155bdaa76862866c1e11ff008d1156a0ff00a408f841ff00b87e43c6103276a38ac39c5fe15dd1f8a45c1736d1e7a03ff2b930f887777974200311ced6b79f8a8e6d6c277428b8937664773d44bb5e77375d1b2f6b91c072e9a92640ca2fd0f3f92cb9b0d56fc19ee3562b6b7741a1ce87666cba794ccf893cd74d0db141cd0da95e94f324c8040e5d6f37525d9783a16aaf6b7365e7ef2730fd13bf738477c74a91bea58db983d45d65328dfc519c3d1c36219959598487cb8075e04e80472d0f9a3198ec1e0dada356b87bac5c2ce3a686046a07b27cc651d952d0fc3d093a1c8d07aea2216fc0d2d9f97f0b0d45bffe6d9bdaf2254f4941aa6f561b2914aa1cc5c0fc26f07a0b9b485c63699790da64389305a3309b41d40b99e44f2f5b2abd5a5f9720f202623928bed87d1b16b5a1c62e239da4c7cbd944ca6fa45c5a369d771a02010729e13af48d6d2d829af76368526e3b02cad0d68ad2e9d3e12584f4e2c87c2172ef0e3e5ec602606a1b6b0317e62473f04d385687576b8de7844ded7016bc78fa8c3932f6f59a4559f661bf62a3cecdc53a2b539145eeff00aac02434ff00581ee04eb2acd85ad9aac25d9108420109612140212c2440210840a8425840a84b0910108421c40b930812110a37b5f7fb66e1896d4c530b86aca7351c3c086031eaa25b57b6bc332450c3d5a8791796b1bf73f241694260de2df2c0e07ffb188687ff00db6f1543fe86c903c4c0547ef376a3b4714325378c3b1da8a321d1fde78bd5b9542fb897126649924ea49d493ccf8a9d0b5f79bb63a9569b9982a468cc8155e5a6a01d5ad12d69f124f92a94b897492492492499249324927527aaec7b005ca1b728273be1859c2d3aa07c244f9110a1d85c406d40438ce800d4830207f54697561ecaa5fc4e05cc709ccc3cf9c7eaab6a048d6ce698d0588241fa2bf3cf555e0bef1f8a95e0ea5663482c20379b85c449837b113758556572fce1afb082d04dee7e5a4f915d1ba6c657696bf33a0dc1201073c8d3a9e809e2b9d54ab0ddd536193124817b4d80b93cef7f35c79757a76e3771041b3f1358c963ae00cefb59b6981602faebce56d66c8c5b1f30f049cc72c9d49246a63fc782b21b89665cbaf507945c7591a2cf0fb498e66781ac8d3536207af3f355fa957f088053a388a725e35999d7a89f0d7caeb95945cf97419fe5969312d69f885a09224fa2996d5acdaa43203a2f04489040bc78283edcc68a41c24904cb21a003a386a349b1f3f456c7b5392ea18718f01ce6824bc9e2758f05fa58c820db44efb070e6a57a6df33e8354cd85119deeb4de62f73f20a67b9785caca98a70e4437c86b1e67e8bab871df24fe1cbc9978e16fca1fbd550b318f73096b9a5a5ae6920b4b74208b8208d55e1d97769f4f18d661716e0cc480035e6032bc731c854eade7a8e8287de2ab9ebbdc759bfb26f6a9cff2aa61f8c7b58242179af74bb43c7615ad0dabde305bbbab2e1e87e26fa18f056beeef6a985ad0dc434d079fcc65d4cffa8096fa88f154593d48930f59951a1ec735ed370e69041f22167081124254204442542012c2459041926adbdbc785c130bf135d94c7204f1bbc1ad1c4e3e4179db6ff0069fb4b144815cd16191928f05bfbbe39ff00528a3c1712e712e71d5c492e3e64dca9d0b6b78fb6daae25b81a0d637955ad771f10c6986fa93e4abbdb5bcd8dc5c9c4626a5407f21314ff00d8d86fc935b28c95bd949069a54cfb2dada6b7b5b6599678291a9ace6b6319a7ba1ab206e4a02b05c01f7e69c5e0c2e1a9aa09bf6738ecc5d40ea248f2894c1bc3b2df42a3ad01ee73847232730fa1f55d1d9e624336831a6dde31cd1e621c3e854df7eb639a941cfa625cc767ca05cf58f180b6b3cf8ffa638e5e1c9fc5567b3ebbe93cbe99bf3079c19e7e2bb711bc61c38ac41713f10d4ccc73708e5683e09a710d1f1b49937f71aad000743bc608f45c93b765dcf4973378987303504c90d00c45f4079cfd166edbd4f28973411d1c26075d7c75e8a18fa069f10120ebe1d0f82d6ea0e79bc0004c7eaa3c627ea6490ffee400939aa3af220d89b75d341f4b4a64c4621d54b4bad0400d064006e63ccdd682e0c1063cb99f3e88c2537133eaadad33b6da7bc260cd6a8da63e271171c80d4a9d6d560a141949a08047a434442d7b87b08b5a6b3dbc4ef841fcadff0028ed27687774fbb1ac13e227847d57670e3e18eefb7273e5e7978cfd2afc6f1173bab9c7e6b4b18ba9f4e001e0928d35cf5bc6ed9e2e4754e8c11cd7061d9041f14e0e0274509386c6db589c2bb350ace65ee01e13e6d363ea1589b17b59a821b89a21ff00d74eceff0069b1f70aae8ba1c484d0f44ec6df2c1626032b06b8fe47f0bbd26c7d095205e5ba750a91ec0df4c5e1480ca85ccfe4a9c4df4e6df42140f40c22157fb27b53a0f8188a4ea67f99bc4dfd7e454d3666d6a1886e6a1558f1cf29123cc6a3d5076c212c210790b666cb6d46b4f7f4daebcb5f20883d620dafa85da76432f189a462e3ff00924f9f0d8fdfdd08564466fd9ad63645563cc810dcda19927301d0693aad02894a844b37b4c80b0379b21083102d3056da1a1b7342102bc2e2312021080d9f8e1431146bde29d405d1cdba3fe44a97e277fb12fc532853653a34dce10e233b9cd26ceb90df4f9a10b7e2bd7fb19724effc3463b65d5a45ee7b01617b80a8c8c9733102ec37f84c7aa6c7618092dfa68842e6e6c6619d91d5c3979f1cb5a4bc8d42e3ab5a3e168b210a9135c54a917bb4266ea5db0777b1350b1eca4e2c9049b00403712754216dc58ccb2ed8f265e386e2e3d9d81eea9817b733754f7681b5457c5863391827ae5263eff242174f2dfb5cbc53ee34d6a320592329a10b95d4da69985d9981828420da0029210841880b3488419672b761eb54a6e0f63dcc70d1cd2411ea2e108413fdd7ed4aad3229e3467669de81f88d1d5c059e3ca0f9ab4b0bb730d51a1f4f1149cd3a10f691f542140fffd9
9	Алина	Соловьёва	Геннадиевна	2	2004-12-24	100223	\\xffd8ffe000104a46494600010101000000000000ffdb0043000906071212121510100f0f1515151515150f0f0f150f0f150f151515161615151515181d2820181a251d151521312125292b2e2e2e171f3338332d37282d2e2bffdb0043010a0a0a0d0d0d17100f152d1d171d2d2d2d2b2d2b2d2d2b2b2b2d2b2d2d2b2d2b2d2d2d2d382d2d2d2d2b2b2d2b2b2d2d2d2d2b2b2b2d2b2d2d2d2d2d2b372b2dffc000110800c0010703012200021101031101ffc4001b00000105010100000000000000000000000200010304050607ffc4003510000201030205030204040701000000000001020304110521061231415122617181b11332a1c15291f0f11423244262728207ffc4001801000301010000000000000000000000000001020304ffc4001f1101010101000300020300000000000000000111020321311213415161ffda000c03010002110311003f00f2a121c4912b3a131d213404a978b62a4d9a35e3946654586007091a16b1dd7ec66d3342da6fb3fdbf51538deb7a2be5ff003c16e8d14994f49ce72febee6ab463d37e7e2d59b362de461d091ab6b50ceb48dab634691956b334294c4a5d81620ca50993d39812ec192c64538cc96332f4b16e2c4caeaa04aa0f4b0532ad5259cc824c9b55221ab133aeb64f6f9355b336fba130570bc48e0db58597df667037b4945b5bfea7a26bb5134f18febc9c0eacb7e6c359f2d3fb1d1c39bc8a50a8bc3fd1e0d383ca4fd8c748d7b55e85f068ce240241b05a0346c0648d00d010041e0400482882824006909a1e23b0357aeb08c99bcbc9af77f9599120844997ad67d8a312f5b530a71d0695236a8a3134f46edb239fa7471f05c85bb703f0c9a8522171a76b334a8c8ceb6a668528094b30658810d3813c100491254c8e289a31023a63e47510d5318d43263609dd305c45810b467df74669c8a1790ca03705c42b1f95bf758db3f3d8e0b53949fe6fb60f49d6aca4f2d63be1613c9e77ac2ef8f9c64dbc75cfe58c946cd1965231e28d3b597a51b3158900c6721b2064c01db1b2044210800859198c012c592114095211ab5e3f4b31cd9ba86560cea941a781e962181ad671331430cd6b442e95cb5acfa9bb666050974366d2b463bc9e3f731ea36e6b669522dd2a2665b6b34b38dfdf666a5aea7465d26b3e1ec458bd5ea34cbd4e055a5517668b7098b15a9628962cafce12981adc593419454c9a9d4105f8a4488a90a84aaaa45c454fca04a257a9aad287e69c7e3252abc4d47a2cbf843c85b576a2295c21a1abd3975787ee2a938c96534fe3722c5eb2350a593c978852552697f13dbc1ec5751d8f2ae20b6cdc4d2f25f8fd565e49b1836f6cda72edd17b9b9ab6971a11a6e2dfaa2b993df12c6f82c5be91394338f4aeaff6449c4492a54567d4f2dfc17f96f5242fd72716d60898931366ac00d8391e40811f2204418353604904d0c0a1c0948a0c932208e7d4054d397d0924892ca92e779e98e885d7c3e7ea85cd1c3fbfb16ad22497a96e96cbb21f4f8e45fc2b3dac465827a10e67bb7f56354b7637e5dc8563529db47a67e856ab6b2cfa5ee625dea52cfa5e31dcaffe3aa27cce5258eefdfdb054e695ee3a18dddc53e8dfd0bf69c53562f1259f9d8e5a8ea351ae6e6cef8c6cde7febd71bf5352dae233c29ac3eddd3f8159fdc3e7adf95dae9bafaa9d5619b54ae533cf697a1e51d2e8d73cddccba8da574ca6054bbe50e953ca3235778d89354d438b9c1b8c239c7731aaebf7355e32d27f4fd40bd928272e54dbe8bcb395bed42a4b772692cbf4ecb6fb9af3359f771d8db51e77fe656f1fdb26fd858516bf367df3d4f20a572e79c4da6b7c36f32f745fa5a84e9b49cea43be72e49aec92ea96ffd752af8ea27963d9e95bd24b649fea1612d92c7c1c170ef10cea4941be6ff0091dd5b45c964cbad9f5b4cb3d1aa2d8f3bd5a8ff00aa936f0b31cfc3fec7a5d78e22ce26f2d54ae26fcadbe82e68b3e3474fb784e38f56f8cb6fb1c4717d45fe21d38fe5a6b957cf567a1e996fc91c3ceed72bf63cbf5a9f357ab2f3397e8f05f8a7bd479ee738a3919b1318e97290c38cc0184331802d31b23b184a3c5922644834007144b4258910e474c56689728753a6d6f9d987a74b743b5ccd27f5069ae5a9823fc69fceba6a74b28a1776e6ae9ad3896ab5964ca5cad735c43b1f565aefd4d17a57e2ac2c3d9732798b58e8d3f3b9b52d2d966d74f71ec5fe69fd719ba4e8118ce0ff000b95452737194aa4ab38bd9bcbc259ecbc1635dd0eae79e953d9eee29c77fd7666f5adab4b185d3059fc0c05ec4f1c8e2aa519aa79945a6baa96cd7c9afc1b27296185ac53ea5ce0ab64a6c8bf1527b77d4adf1030750b3e66d9d5c63e828d5a098b0f5e63c41a7d4ce23178fe2cac3f6fb14ab696e74d4392194b6f0d774fc743d0350d2f9b2624f46927e50e7561fe33a72b69c399518ba5429a8e79aac1ce752a26fa65bc7d4d2aba34652c28a78c72ac6cbe727496da7b366c6c12df055eed4cf1c9597a270ec6114d4229f7c248e869dbf2a2e52a78435633ab8cbbd7b1cfdbd9f3d5e67d399eff00436f5196cc86d69afc3876ceefebb92bf88358aca95194fa2a716f3e5e3078dce596dbeedb7f53bcff00e8baba4a36907e2551afd11c09d3e29eb5c9e7eb6e186c04364d580582c7608196043a6200b191b2331b2231a0d11c09e080cdca12886a21a4011c5608aa6d24cb4d15eb226c395d0e8d57a1d45b24d1c4e9757183b0d32ae518753dba79f8d18dba65885aa24b7dcb91a68952a2a241731c234a5032f539e1300e7b52a99d8b7c2b2c5431eb54cc8dfe19a1896474a3d062fd04312582f4608874a42ab4b252ab6fec684240cd008ce8db16a94037110949532bdc540a5329dc5415a72333549ed8f3b7f333f88b89295bc5463894f1884176ed97e119fc697ce149f2bc36d24d763ceea36f76db7ddbdf25f1c6fbacfc9e4fc6e43de5ccaa4e5526f3293cb64013401d31c9481648909c4090b183681033087101266031db184a1c19660ca9164f09004e984991261640c72910cd8526432025db199d369971d8e4ed99b3655b0cc3a8e9e2fa777655b6352150e56c2e4d9a57066d1a1526616b753d2cd0a95cc5d56a65300e76cd734f7e993d0743a092479ac2b38cf65959fdcf42e1dd42338ac32ba28ece82cac15ebc700d1badba95aef508a78cee16cc292e869d7df0cb0aa145acee1c264ad739c194caff00880caa0b40aad433aeaa93d6aa63df57ec84a71fc67719708fbb7fcb65f76730d1abc495b9abb5fc292fddfdcca6cebe26470f92ef54124060905ca5a03143b421f2011ca203896009211a06305210d243a43f284a22587049112412404922103124480239018266858006a4b068517829a45aa267dc6de3adbb2ac6c50b939ab699a742a99356cfe364cdd4aa6cc9235762ade4b2846e56addca2df2bebd9ee5bd13599c27be70df58f60ab5826cd1d274659ce0bb98892eba0a5ac55947d09b7db3b0b44d36e2751d4ad51e1f659585ecbb1774db4c35b1d3dad34bb19b54b1a09452f088674cb529904e414a2a54d8af3a858aeca35592a886e2a997753c2727e1976aee739c577dc94f913de5b2f8eecae66d2eee471b775b9e729f96d90098e91d71c345143b424293192393079852239300914c4e44191f20052620440165447e509084aa6c0e2c8d90038b0d4887985cc0499c864c879828b00b089ede5be0ad0618acd872e568c762ed1a8655b5c737a5f55fa97684cc2cc74cbb1a0ea3c6c61d6d5da962a45c7dd65a66c29942fe827d526839ff45454b5782c34e3f5691b3a7f11c62fd518b5ff00169e0e7e9697093c35fd92fbb6cbf0e16a78e6cac77f3e0ab236e39b5d6438b28c774b3e33845aa7c690ef15ff009699cdd3e11a0b19e57949f4f3f26a5b6856f4d2c413787d31e97b63289c8d7f57f6d69715d296d1e66fc24d90597104a52e59d1a90cf4e65d7dc9b4fb28c7fdb1cecf64bc17ae6845efb649b8c7a925f49555ca2adc48652c15ab54eec82882f6e1422e4de12596cf39d52f5d6a8e6fa748af08d3e28d59ce4e8c5fa57e6f77e0c6a513a3c7ce4d73f97bdb911aa617e116e348774cd5929f211ce25c9a2b5402c569223912cc898c80d0c1b05a006c8861c0975313602626c4b26c1e619839021e45903224c649130a2c8d049804f1912a915a2c962c46184b1335695431a9bf5366adbb31efeb7e3e34a94b2292c90527827a6f2c8681853fe91a16f72e3959787d579df3fb0d4a8a6695b5827d85abe7ab1142f3da4f6c74c633e0b96ce5279c60d0b6d3e3fc25fa76697442dabfd950dbec89252c92ca910d47825086ab29d68e565f4ecbc975433bbfe44774b610794ea6ff00cea9ff0066351905c414f96e26bdf253a733b67c8e2bf6b523306750a91aa2954184952a15a7314d91480a9a4c0613058c8c2630801843a42104c98e0208144c6682198101890ec1021a09323c8ea4309e21378443190d56a6d811c15b7934e8333ed96c5ea263d37e57a0c9e8cb7f72ac7d826c868daa1335ec6b2c1cc5bdcb5eff0026adbd7cf67f72551d3d0ba2e2b94739426cbb4f2c5a6d2a9724315906940b508120d18905ca2e3895a71c8079df1bd96271aa96cf6672c99eb7a9e9aab539424baf4f66796ea5633a33709af87e51d3e2eb66397cbce5d42a41a64190e323565a900921f9819303d0b0184d80c646092002880489085910944820131f200ed8d919b0401f236461042a5916460e34db0d2cd373605059dc3544b11a445e9a4e707416c5ba488a8c362c53899d6b13d2458fc31ada26853a445ab8ab4a89a96d481a744d1b5a44d544d6d48d1a3006de91729d310d3d3a658844508e09501a2a8887949a63c6020ab0875464ebda0c2e22d35bff00b65dd1bf1861923a790f9f0ae5faf0dd5749a96f2719c5e3b4bb32864f72d43498558b8ce29a679eebfc1538372a3bafe13a78f2efd73f7e2cf8e3f23e47a94a5178945a7e1ec323662404826030060902821016440b62037fffd9
\.


--
-- TOC entry 2272 (class 0 OID 40979)
-- Dependencies: 198
-- Data for Name: feedings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.feedings (feeding_id, pet_id, food_id, date_time, weight) FROM stdin;
8	10	3	2020-12-04 12:22:00	299
9	14	3	2020-01-01 00:00:00	100
10	15	4	2020-12-05 12:54:00	123
11	18	6	2020-12-22 10:37:00	30
13	18	6	2020-12-23 10:05:00	3000
14	10	7	2020-12-23 20:05:00	50
\.


--
-- TOC entry 2278 (class 0 OID 41003)
-- Dependencies: 204
-- Data for Name: foods; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.foods (food_id, name, producer) FROM stdin;
1	Корм "Тимошка"	Обнинский комбинат кормов для животных (ОККЖ)
2	Вискас	Проктор и Гэмбел
3	печенье "Добрый зверь"	Серпуховской комбинат жировых отходов
0	- Не задано	 
4	Сухарики "Педи Гри"	Перди Гри Пал inc.
5	Пшено В/С	Кировский Совхоз имени Фрунзе
6	Картофель Синеглазка	Совхоз "Шопино"
7	Рожь кормовая	ОФПК №1
\.


--
-- TOC entry 2260 (class 0 OID 32780)
-- Dependencies: 186
-- Data for Name: pets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pets (pet_id, specie, nickname, birthday, price, notes, photo, color, sex, breed) FROM stdin;
16	4	Алый	2019-12-04	10 027,00 ?	Пёс б/у. Работал в милиции	\\xffd8ffe000104a46494600010101000000000000ffdb00430009060712131215131313161515171817181717181818171e1b171e15161916181816181d28201a1a251d171922312125292b2e2e2e1a1f3338332d37282d2e2bffdb0043010a0a0a0e0d0e1a10101b2d2520252d2d2d2d2d2d2d2d2d2d2d2d2d2d2b2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2dffc0001108010c00bc03012200021101031101ffc4001c0001000203010101000000000000000000000506040708030102ffc40042100001030203040706040405030500000001000211032104053106124151071322617181a1143291b1c1f05272d1f1234262e108435382921533a2168393a3c2ffc400190101000301010000000000000000000000000203040105ffc4002111010100020202030101010000000000000001021103211231223241517161ffda000c03010002110311003f00de2b0f34cd28e1d9bf5ea369b660171893c8733627c8acc5a7ba50c68c463052d59876c46bfc47769e47800d1e4572d764db6f52a8d73439a439ae00820c820890411a85fb5aa7a1fda42c73b2daceb897e15c67b4cb9a94efc5bef0ee2ed0356d65d70444404444044440444404444044440444404444044440444405a0198aeb71788745df56a1bfe727eab7fae76ceb09ecf8fc453b822a1734ff0049718f388f82e65e9671fd9899b55af87aecaccb54a2f6d466bc0dda798225a4722ba1721cda9e2b0f4b1148f62a343873074734ff00534820f782b48e6741d88a5bec1ee88749e62641fd566f443b55ecd55d83aee8a755e03093eed530d68ee0f103c40fc44a8e396d2e5c355bc11114d4888a1f3eda6c2611a4d7acd69027701de79e50c17bf3d3bd0457491b60dcbb0dbcd20e22a4b68b0def6de791f85a0fc481c578f45bb53531d853d7906bd276ebc801bbcd2258fdd161371e2d360b47ed86d2bb1b8bab5dd313b94586fb94c70b5b789927be782d81d0f173315ba0435d41dbc2fa87b0b4f8ebf144b4dc6888888888808888088880888808888088880b4a7485851531f58821a46e91369218d6900f3b69e0b75ad67d31601aca42bb4769ef0c8d65fba7760783483e01433deba59c7adf6a8659987554cee09739ae6b984c198e060ea098b6a2eabe70e28ef3faa352a38c9b481fd226d68d46ab2f2a25ac25c65c4f68f007881e0bd696d3d07543458cb347bc635899e7e6abb34bae7e5a7860b6fb1b4016b2aba9cff218706c01a35c0c2b2645d27e21ceddab5e6d6ec531279d9aab7432863f12fa9508ddb5b5b96ce9f05e98dc261dcd2e639b2d3a8b69f5fd57373d4db9abeec8ccdaddbec68aa1aeac43237a99a7d8913798d48223f754ccc71f51e4b9ce277af264b9c79c9beab3b31c10c452ddd5edde7533c49e2d3dc63e4a1f26607d5a61e498e0e80207005598e3fb50f2ef512191e52e7f6dc2c2fe4b76f453943807e29e23787574c7f4820bcf86f003c4154da344546d101cd635cf0d0c68249ec92082441b88e373a2dd796609b468d3a2df769b1ac1e0d0049efb29cbb4739ae992888baac444404444044440444404444044440544e9870af38315dbfe438b88b18de69607c1e20ba3c1c55ed406dd55030359bc6a37aa03997f64fc049f25ccbd3b8fb734637175453a6d3bd4e9076eb8b0c39c48975f86bfbac6caaa0151ce926c2e758e20cebc55a76d1d4d95aa51dd05b0c701c8ee01fa2adb680688fa28e3778ed3ca6b2d32332cd886101d05c0e9de200f84288c0562d6efbdaf21e5d7062eddd9b0bff336fdebc71f5038597b60f06cdd2e73ed6ec8b79fa2949a88dbba9aa78d34e9876b06dded3cfc8ac2c5e103436a47f09ce91dd792c3c811c579332eaa581c64b1d3b92794c85fb7d7029b5ae04806ed0626384ff298b28cff008eff00ae8cd8ad96a2da3431151bbd50343e9874ff000c39b6ece85f06e4e87485725e585a8d731ae67ba5a0b63f09008f45eaa52691b762222eb82222022220222202222022220222202a97483880d6526b8c34b9c7cc0817ff007156d55adbfa21d85bea1ed8b4ccc8208e5067c828727d6a7c7f68e79da70f38dabbf782c8bc88eada45fcd46e2f14e00c9b2c6ceeabc57ac5d00b6a3c6ec5ac7745bc037c94757c439c6600b5e2c0f929633a8e657baf07b97b616ac1d6c7558c57d057516cda15d952852630ceec1f391bde92a1769f0018e040b4eabdf66410c6f648b71d4df552398d06963aa56b000d8bb74f94ebfb2cf3e39347db16dbe8673af68cb69b09ede1c9a0e1fd2d00d2ff00eb2d13cda55e972d7461b5ff00f4fc787b89187ad14eb4de1b3d8a9fec267f2972ea4690448b82b433bea222022220222202222022220222202222028ecff01d7d07b38fbcdbc4b85da0f74a9145cb3734ecbabb7376dcece6fd7a15298bd53d5b80b896349de2675dd111c437b95771bb1f5c598d98131cd6dcda5c67b1e60fa4fddeab14e6c1880c96981dddb66bfd4549fb1b099780045cda23525431b64d56ee3e0c7971b939a71983a948c546969e47fb2f4cbb085f51ade1a9f0527b47987b4626a1601d587bc538fc1bdd93e6002a6b65f2b03b5124f352cb2d463b8fcb513780c20701168d207250bb558c8069977f6e4bdf3bcc7a96eeb7de548c5629cf76f3892553c72e57c96e766334fd53009d6cba1fa1ddb9a55a8d3c0d676e6229b776983a54a6d160d3c5ed1ab79091a18e7ba34fe4b3b2c638d4690e2d7020b5c2c5a4105ae045c11620f05a19dd8a8a95d17ed5d4c6d17b2b09ad40b5af78801e083bae20583ac662da111302ea80888808888088880888808888088880888835874d39736a32939e2580104cf1244477db9725acea64758b377daabf5645da6a3888e5131a792dedb7b978ab8624eadd27bfeb30b4d3310e220c40b584e9dca9ced97a5fc7e95ecbb2501c6dd99b1f43f5566c3b453669000d4f25ed45a298ed037e2144e739932089f2efe1654f95c93d48ad66ce0fa8e234faa8b66009923506045eea772cc19ad5260869903e169f3566c3e54ca65ad75bdd33cece27e52afc7298f4ab29bedaef1148d376e6ae3c7979291a645068882e257ae601bd655aa07bc6183bb498e50a3b12d73853079ba0f9ab36af49bd86db5a980c6b7104175370dcacc6c0dea73a81a6f3751e624025750e499c50c5d16d7c3d46d4a6ed08e078870d5ae1c41b85c6b8ca7b8e8539b13b5189cbeb75f87748302ad33eed46de03873d61da8bf320f5c75e2288d96da2a18fc3b31141d2d759cd3ef31e23798f1c1c27cc1045882a5d011110111101111011110111101111043ed73a30956353ba05e2e5ed0b4dd7cbb70c7bc35b7d74bad9dd21621e1b429b621cf25dde1adb0f8ba7c952b18c2e6f0688e5e8b3735ef4d1c53adab98ccc0358471e47973556a38435aa4472d741a71f356eab93d5aa7b2c711cc881ebe4b2f2ac807584bdc219166e9bdca78aafcbc53f1f26465784a74581ad01ce8836b58f15179e5576f071b01603fdbf7f1565ccf16c6da90b713dff0070a979aef38b8f207e3603efbd4b8fb4793a57f16d971711af65bdda131f2f2588fe1220349f5fd94a3e8b88718b70e5ade3e0b0aa502e93e6afb54c8aee60f972f7ca593bdca2f6ef17ee5f9c5d0975b88feca5f2fc386335b9d7cc5aca711a95e8f76d6a657892482ec3d42056a63581a5467f589d342245ac474fe0b16cab4d9569b83d8f68735c342d22410b8eb30a25aeee23d387a2d83d0e7486306ff64c4be30d51d2c79d29543acf2a6e3af237e2e2bae3a2d1110111101111011110111101111056f6d980b2973eb0f8eeee3b7bcbddf451b94d3654603675cf94295db4c2ef510e1ab0fa1b1f58548c9b39145cea0f302a4eebb8031aacfc98eeeda38f2f8e966c736443001f40ab94301b85c22cebcf9dd6751ace9b991e91c355ed89ab3c2cb1dc72bdb5ccb1c7a4757c1b5c78491c7c4eab071f97800b604df8785fe5a29475304dac2dc8fcd7ada049b8e3cfee614a6e2175548c7e5f0dddb5b4f0855ec4e1c00e1c96c0cee988b0fd950b689db8c739bcbe90acc2dde90ce4d2b785a1bf580e178f252798d20d64c696d3bb41dd7f45f328c1d9952dcbe573f1f45edb4f586e6e811bae70f227efd392d9193256b33ae09817040fbfa28e95f4ba4928a48ba1fa0ddb9f69a3ec35dd35a8b669b8ff003d1040009fc4c903bc41e04adacb8b724cd2ae16bd3c4513bb5293839a7e6d31ab489047104aebfd9acee9e370d4b134bdda8d983ab4e8e69ef0e047920934444044440444404444044441f9a8c0e05a44822083c42d3bb79941c357007b8eed53e36e2d33c47c885b91446d3e48dc5d034cd9c3b4c7727471ee3a1f1ee51cf1dc4b0cb55ad3015c968267c14c51ad214065d53ab7163c1690482d22e08306de3c4f2e3a0996da1c343f7c164934d56edf8c4d4bf1f08e5dfc96661df03f6fbf458d538c001bcd1956019005e4448eefa25b1c92a3b3a7ee93e3c56bbda5aa0cb41d6c3cfe4ae1b538f11c82a461e9efd5048b0f5e56f15de39fa725fc4865f87229b267748831f3fbe67bd43ed155ec9bd8dbced7f92baefb437748024401e4b5ced0d525d7e1215fc796d46734840becafa0597e4ab558b74ff876da5dd7d5c03cd9f35a97e6000aadf3686b87e57735a54293d9dcddf84c4d1c4d3f7a93daf8d247f3349e4e6cb7cd076722c7cbb1acaf4a9d6a67799518d7b4f36b8023d0ac8404444044440444404444044441adba47cabaa78c430436a59f1c1f73e5bc3d41e6a0b03984001c6dc82da5b4d968c461aad289244b7f3348737d401e6b49e2d8ea51cac41eefb0a9e4c7b5b865d2d7408776411c877159553045ad0410491f5265536962dd0083e07c6d2ad7b3b8feb5bdaf79b1f23a2cf66a2fc6eea033fc9dee173cedf7a286a9806531c88d22cae79a4ef1fbe7f5551ceb0e5e4cb881e3c3f751c72fc4f2c27b446d2e61b8da6389e23eaaa199d406e78fe96591b4b8fdfa9034680df31a9fbe4a1ea559b2d9c78ea31f25dd7e17c017edacee592fcbea80269bafa58dfc3e2ac418457e9a57dad49cd2438107bc42fc041d1dfe1fb3e15b02ec2b8f6f0cf302ff00f69e4b9a7c9dbe3b801cd6d25cabd106d07b1e65449314eb7f02a783c8dc3dd0f0d33cb797552022220222202222022220222202d45b4382ff00b8d02775ce6f907387ca16dd542cd5b18aac0f39f2731a7eaaae5f516f17ec6ad7bdd48df4993f7eaac1b1b8d0ea8437f06be63f55fada2cb009734020f0587b2585dcac2a5c35eda8d8b5f77764c79855e53aa9e37b8b0664e37b19f87c3e2aaf9ad137f5d3e70ac798389746bf03eaa0f39a9149ced21b6bcf359b1f6d397a6a5cc59db77895eb91654fc4550c6349d248d00ef2745f732f52b6b74639401443a05f9713c493c6f6f25e8cf4f3efb65653b2b46930453693cc893317327459f570ecb02d1323d2e1582a3086e97325406643744da6dc38ebc2d2b2f2defa68e39d21730c9e854dedf6025d33c2de3eab5f6d2ecef5677e9fba6fba0683f45b09b8b0e71b07703323c80f10a0739ae37b74c8e22c0787a2971dca399cc6b5bb4f107cd75bf473b47edf97d1aee23ac82cab1fea36ce31c26ce8e4e0b96336c216bb7f838e97907bc15b2bfc3ded07578ba98373a195da5ec07fd566b1de59bd3f902d2cee8344440444404444044440444405aff6aea6ee31e3f1318ef42dff00f2b602d67b75547b691c43298f3ed1fa855737d56f0fd9199ad71d5c9e47e4b170387753a9876bcc038475603f0f5b55c40f1dd0147e7f8a2da64739f8c7d55eb6aa8d36b30af681bdd48693c4b0061602788049f89556fe16ac93e722b189afdb71e11e3e4abdb57898a3ba38c053189aa0b605ae2de2ed3e0157f6a78cf0b054f1cf92de4bd2a5432c151e264ade5b0d840cc2b275bfa5be8b526500ce9e8b706c7bff0084c6f2de07e3bdf55b25ac8f6cd6b864aa766f9a34022fc7efe4ad39e904b8fdfdeab53e7f5cf5b63adff4fa2c98cb964d596b1c5f6ae6bba64e93a72d7f4418f654b9deefef9923e4abb998902f3dcbf184c43a98d2448fd4788bad531e99ed6667140384c7783dd26cb0b62f1668e6184a931bb88a53f94d401e3cda485f7138dde61b7d2f7d1445490646bc3c782b22baeda458b95635b5a8d2acd32da8c63c11c9cd0e1f3594bae088880888808888088880b58749d86ddc552a83fcca707c58ed7e0f6fc16cf5af3a516cd5c3770a9ea59fa2af97eb56717d9aeb36a7bed7124c471f42adb8bcd056a38689ece1286f8e4e34c388f2903f6512fc136b3a951759b52ad3a6e22c775cf6b5d079c1305646d0d2ea7155e98101a4ee81c186ed1e4080b35b7c1a649e6c06d48124e927cd47d7a45ec2f22ce98b701c97dab549126cd32af984db2cb2ae1e9e1ebd1a8d6b18d6dd92010d825ae638bfce254b8a4f751e5b7d46bbc061f90567d94c6ba9d52d76844f9fedf258f8da5846389c362455613ee96bdae6f89734023bede0b230148121da45d68d74cf2f6f5da1c791201e72b5ae35c6a561e04fc15e3373bd50b7b89555c361f72abf7b5d3c966c7e357df9445e330860c093f6492b10d325bbb107945cf72bd53c130e83585859c64ed0c263b5048f1d0dbef82bf1bb5594d29ed60bb4faf0d263928ba83d149562038cf3f95bd54738ab62b7517441989af94e149d58d348ff00edb8b1bff886ab92a4743184753ca30c1c20bbaca807f4baabdcdf8820f9abba38222202222022220222202d73b77880fc56e8ff002d8d07b9c4971f42d59bb57b75d539d4b0e1ae7441a86e01e30de31cc98ee2b5a55ccaaef17b9dbce2778f1993727c567e5ce59a8d1c58597caa768621adad46751568903898aac303c745f7389a95eb39f73befbeb60481e5007c144e5ed655c4d2ae46f75335409fe616a531c05534cf92960d038ded25539758c8bb1ef2b55fcea1b4cc9811f0f351f83730817910b656c1608bf1aea96dca54cffc9f61e81cb64b68b468d038d80d79ab78f8f78a9e4e4d64e6fae583430558f673101e071f35bbf746b0a8db73842ca94ea32980c88739ad03b44ff3117d349faab7c7515796eabb9e60c16878b3c5c7d42ab6658275402ad36dc6a39ff7d55bb1788635bdb7b5a08d5c40f84aaebb3ca6dec89239831e9c553c9d7a5dc7dded8d94e25a644f69b16f8fd657ccc7160868d61c647747dfc162664ea551dbd4dce0ff000d7e0b1eae5b51f62e37b922df3d54b0bfd733c7f8a6e6eefe21165e393ba87b452f680e3437d9d686983d5c8de831caff00a6aa7732d98702487493ce39d9436072873f114a87fa95594e47f53dadd786aaf976a2cd3b1b0f45ac6b58c686b5a035ad02006810001c00017a2045d704444044440444405899bd0a95285565278654731cd63ccc35c5a4036e4b2d10733671ed8da8ec38c355df92c76ed3a8e2483060b5a6648b11e217862b175c54f67ea62a82d6b9a4105a6c3b5c80e6ba8152ba58cc1d4708cdd0e3bf59ad706f16ee3cdcf2900f9285c26bd2733bfd6a4c097e1cba779c5c048986da6206bc4dcfc02cdc1666e7182d81e32a27fea45a37dfa92e81f7c3fba8fc0e75d5b1dbf73bce2e22203899f217f4545e3caf757ce4c6751bafa2b82312e9edcd3047210e8f52ef82bf2aa7467822cc0b1ee6163eb175470708304eed39074ec35a63bd5ad68c66a699f3bbbb47e79998c3d1350804d835a4c4b8f7f70927b815a9f69b69f1352055ace6b5e771b4a97641fc537922359254df4c0fc487502c6bbaa0c792e0246f9733b263425a0f94c2d655bda7158969c3d2a957d9c196b1ae31f8b780d1c48b0d4e8b99636d771ca4646658500389b79ccf29955dab990980de1c79ad87906c2e3b1c77ab8385c3dc1de69155c47e1a6e1d913c5de2010af193f45195d021cea4eaee1c6bbb7c789a60061ff8a863c5fd4ef2ff001a8f647086a4d67cc0b3470f1856714070ef564db4c859863d6d36b5948c34318d0d0d81c034000595406344c0bf1b5ede4b3f2ee5d2fe3d59b62e3b09300f3063efca3cd42e3f2e696b2434da4c8f4f183e365647e244807ecc597ef15846bafa7ddd770e4b899f1cc91fb3fd25e3f04d0c2462e983eed52edf0380656b98fcc1de4b67e4fd2a65758377abf50f22ecaad73434f106ac757ff92d3799e5641802ddd1e2a2d983871907bedf7056bc729632658595d3b83da0c1d504d2c550a806a59558e03c4836d42c57ed965a1dba71d850e1a835e9d8f23dad573262f2cd4b44c770b28cc4d23c42923a75fd0cd283c02cad4dc0e85af699f020acb5cbdd17ec21cc713fc461185a466b3c5b78c4b6934ebbc78c68de2096ae9cc2e1db4d8da6c10d63435a2e61a040126fa041ea8888088880bcb1387654696d4635ed3ab5c0387c0af5441098bd91cbea3839f84a0e20409a6d88fcb107e0b3a9e518768606d0a405310c029b06e0e01b03b23c166a20222202f802fa88088883e39a088224722a0734d8dc0d7bba8358e99dfa605374f796ebe72a7d172c97dbb2d9e9ae2b7466f1503998905b260398440bda438c9d04dbe860f1db3198b20f505c03b56383ad61eeea419e5e30b71a2aef0e3564e6c9a271384a9241a5501fc8ee1e5658ff00fa7eb543230b8833c452a91ff2dd85bf9172716bf5dbcbbfc68dc26c6631e777d96a78bb7196fcce70254be03a1e2f20e26b6eb78b298977ff00210034f834adb68ac98e95dcb6c2c9f2aa385a2da14298a74d820347a924dcb8ea49b959a88a48bfffd9	Чёрный	1	Овчарка
0	0	 	2000-01-01	0,00 ?	 	\\xffd8ffe000104a46494600010101000000000000ffdb0043000906070f101010101010100f0f0f0f100f0d100f101010100f101515161615151515181d2820181a251b151321312125292b2e2e2e171f3338332d37282d2e2bffdb0043010a0a0a0e0d0e1b10101a2d2520252d2d2b2d2d2d2d2d2d2f2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2f2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2dffc000110800e100e103011100021101031101ffc4001c0000010501010100000000000000000000000102030607040508ffc40044100002010300050904070508020300000001020003041105122131410613223251617181910752a1b11442627292c1d1233343638224535473a2b2e1f193d2161734ffc4001a010100020301000000000000000000000000010502030406ffc4003511010002010204030606020007000000000001020304111221314105516113327181b1d11422425291a1c1e11523334362f0f1ffda000c03010002110311003f00dc6010080402010080402021303c9d23ca5b1b72456b9a28c37a6b8671fd0b93f09b698325fddacb0b64ad7acbc4afed12d3f854ee2bf614a2c14ff519d15d0e59ebb435cea28e2a9ed0aa1ea58d4f17ab4c7c37cd91e1fe7663f88f442fcbfbae1669df9adfa0994787d7f77f48fc44f9147b42ae37d9e47d9acbf9c8ff0087c7ee3f13e8e9a3ed1e9ff12d6e13b4a85a9f23309f0fbf698651a9af787a767cbcd1d5361ae291ecacad4fe2767c66ab68f357f4eff06719e93dd60b6bca751435375753b9918329f022734c4c4ed30d91313d1383212580402010080402010080402010080402010081cba4348d1b74352b544a4837b3b003c0769ee132a52d79dab1ba26d111bca9ba4397ccf916540b8e15ebe69d3f155eb34eec7a19ff00b93f2868b67fdb0aa694d295aae7e957951f3be8d03cda78617691e2677e2d356bee57e72e6be599eb2f296ee8d3d94a8aaf612066757b199f7a5ab8e23a4195349d53c40f01338c35863c7285aeaa1deedeb899c52be48e29339e7f79bf1193c31e48de4a2b3fbcdea63863c8de4e174e3eb1f398f057c93c527fd2c9d8ca1877898fb28ec9e32db5508daf499e83fbd498ae7c71bfce617c3c51b4c6ecab7dba7259b4672def68e054d5bb4ed384ab8f11b0ce0cbe1f4b7bbc9d14d45a3af35db4172ced2e8840fcd553fc2abd07cf76763794aecda4c98b9cc72f3874d3356cb1ab83399b4e8040201008040201008040201008084e37c0a669de5b80cd42c5457aabb2a563b2de91f1fae7b84eec3a39b4715f947f6d17cf11caaa2e90bb05f9cb9a8d7771c35bf774fb95772fce5ae2c1b46d58da1c77bf3de79cbcdbad2351f79d51d8bb04eaae2ad5aa6f32e49b1888040210201016010080aa48dd1b6e6e7b306d8c33d8788984d1945bcd64d03cb1b9b5c2b9373407063fb541dcc7ade72bb51e1f5bf3af29fe9d58f5135ebce1a6e84d3b42ed03d170c388dcca7b1870329b2e2be39dad0eda5e2d1bc3d5066b64201008040201008040201020bcbba7451aa547544419666380049ad66d3b4226622379669a7f94956fb58296b6b01c4e56b5c8ed3eea776f32db4fa58a739e76fa3932669b74e50ab5ce90d9cdd11cdd21b063613fa4b3a61db9dbab92d7ed0f3f337b01008042040201242c8040584080402028309897458de55a15055a0e69d41bf1d571d8c3889a72e0ae4af0da1b29926b3bc354e48f2be9dd8d46fd9dc28e9d32778f790f11f29e7f53a4b619f4f358e2cd17f8ad6a73391b8b008040201008040204179754e8d36a95182222967627000126b59b4ed0899888de595e9fd36d7cdced5cd3b2a6736f44f5ab370a9507c965d69f4fecf9473b4ff4e2c9938be0acdf5eb553b7628eaa8dc3fe65963c715872dadbb966c6220100841514b10aa0b31dcaa0b31f002266223794c44cf459f45f20afeb60b2a5b21e35492f8fb8bf9e270e5f11c14e51cfe0e8ae96f3d792c76becc288fdf5d5673c79a54a4bf1d63f19c77f16bfe9ac7cf9fd9ba3475ef2ecff00eb8b0edaff00f97fe26aff008a66f4fe19fe171a3adecdac8f56adca783a1ff729931e2b9a3ac44a274949f37937becd2a8c9a174afd895a9943f8d49f94e8a78b57f5d7f89ffdfab55b473da556d2ba02eed7f7d4582ff789d3a7f886ef39df8b538b2fb92e7be1bd3ac3cd137b5171017100c40203a9bb2b2ba314a887591c6f5330bd22f1b4b2ada627786a7c8ae560ba5e6aa616e107487071ef2fe6384f3babd24e19de3a2cf0e68c91b775c54e671b796010080402010118e36c0cbb955a6fe9d54a86c585b36decb9acbc4f6a0e1da65be974fece379f7a7fa71e6c9c53b768543485e1aad9dca3622f60fd65b63c715871dadbb966c6220108102c3c99e48dc5f61ff736fc6ab0c961fcb5e3e3ba71ea75b8f072eb3e5f76fc582d7e7d9a9e83e4f5ad9ae28d3e97d6a8fd2a8fde5bf218128b3ea72669ded3f2ecb0a62ad2393d4cce76c2660266484cc04cc06b004104020ef0768311c851b953c8647d6ad660254def43f8753eefbadddb8cb6d2f88cc7e4cbce3cdc79b4b13ceaceca90482082090c08c1046f0476cbaf557f4188062010080fa355e9bad4a6c56a21ca30f9784d7931d72566b6655b4d67786bfc90e50addd10dd5a8bd1aa9eeb7e8784f35a9c1386fc33f25b62c9192bbac8273b60804020100814bf683a65805b1a0dab56b8cd771be95bf1f02dbbd67768f0c5a78edd23ead19afb470c338d2770bb28d3d94a9ecc0e244bcc34dbf34f557dedda1e7cdec040210205bbd9ef27adef1dea5760fccb0c5b7bdd8cfdabddeb2bfc4353930c44523af7fb3ab4f8ab7e73fc359500000000018006c004f3f3cfaac466404cc909980998099809980998049140f68da040fedb4860ec5b903711b83f8f03e52dfc37533ff004adf2fb3875587f5c7cd43c4b8701710080402077682d28d675d6b2f50e16bafbc9dbe237ce5d5e9e33536efd9bb0e5e0b6edaf47dd2d44565390c015238833cccc4c4ed2b789ddd7201008040e5d297c96f46a56a87094919d8f70e03bceef39952937b4563ba2d3111bcb1bbdbea8454b9a9ff00e8bb6d6ff2e9fd551e0bf133d0e0c511b563a42b725e7acf597853b9a090161020103b344e92ab6b592bd138743b54f56a27156ee335e5c55cb49a59952f349de1b6e86d2b4eee8a57a47a2e3683bd1b8a9ef13cc66c36c579a596d4bc5e37876666a666bb80092400064927000ed262237e502afa4b97963449552f5d86c3cd0cafe23813bf1f8766bc6f3cbe2e7bea695f572dbfb46b46387a55e90f7995587a293365bc2f2c472989611aba4f5dd66d1da4a8dc26bd1a8b5178953b41ec2384e0c98af8e76bc6ce9ade2d1bc3aa60c8900810dddbad5a6f49c656a2323781189952f34b45a3b22d1bc6d2c3aa5128cf4dbad4dde9b7de5254fca7ac898b445a3bf3524c6d3b131250580402026240bd7b36d3046b5ab9ea74e8e78d33bd7c8fcfba51f8960e1b7b48efd563a4c9bc70cb4753912add87402010287ed22fb5da85929e8b9e7ee47f2d0f454f8b63d2586871f39c93f0873ea2dd2acef4a5c739509e0bd15f297b8abc3557de77971cd8c4b08100921601210f77923ca16b1ad93936f54815d47d5ec703b47ca72eaf4b19e9cbde8e9f66fc19bd9cf3e8d5f49698a16f43e9151c737aa0a15da6a646542f6933cf63c17c97e088e7f4595af5ad78a593f28b94b717ac43134e803d0a0a7677173f58fc04f43a6d2530472e73e7f65665cf6c9f078c04ea692c21d7a2b48d5b5aa2b516c30eb2fd5a8bc558719af2e2ae5af0dbff008cf1e49a4ef0d9344e904b9a34eb2756a2e71c54ee20f783913cc66c538af349ecb8a5e2f5e2875cd6c8404818f72a69eadf5d8ddfb50df8955bf39e9b493be0a4fa29f51cb259e662743497100c40310131026b2bb6a1569d65df4d816ef43b187a4d39f1465c73596cc57e0b44b6ed19722a22b0390c0107b8cf2d31b4ed2ba89dddb2010109818ce98d23ced6bcbace75ea1a140ff2d3a231dd9d66f397fa6c5c35ad3e72aecb7de6655a964e62c2040248202c20b202c091eb54654467664a5914909256983b4e0709115ac4ccc4739ea99b4cc6d264962580a040581a27b2fac4d0b84ce552be57bb590647a8cf99949e2b5ff9959f4ff2b1d14fe598f55ce55bb0900818cf292e83deddb0da39f65fc1843fed9ea74b4db0523d3ebcd4b9edbe4b7c5e7f3ddd37f0b56e39dee8e1372f3ddd2384dcbce88d8dcbce08d8dc641e32361a4fb38d21af6e299396a0c699fbbbd7e071e53cef8862e0cd33e7cfeeb7d2df8b1fc1781385d020793cabbf36f6573581c32517d43f6c8d54ff0051136e0a71e4ad7d5864b70d6658cdeaf374a8d21f55013e38ff00b9e970c6f336565f94443cf9bda8b0080490b21059216405804208d51471f493b49b986bf60f593c28dcd3518f193b4237349ed9286bdc82d14d6d66bae3152bb1af501debac0055f2503cf33cd788678cb9b9748e4b8d2e3e0a73eb3cd639c2e8240e5d277ab428d4acdba9a16f12370f33813662c7392f148eec6f68ad66588ed392db5989663dac4e49f8cf5bca3942866779dcbab081ab0175601ab0135601884ad3ecf6eb52e5e9e765440c07da53fa1951e2b4de916f25868edf9a61ad52390251ac0f814ef69f5bfb253a5fdf5cd143dea0eb37c84edd0c6f977f2868d44fe5663a59f354f70025fe18daaaebcf371cdac0402485840901600580dfb2361135c760f5994558ee8d9c9de665b2001243809083808171e417264d7717559714299cd1523f7ce3eb7dd1f132afc4359ece3d9d279cf5f4ff006edd2e0e29e3b7469d2816620240a07b45d3018ada21cea90f718e077aa7e7e92ebc334fb47b59f97dd5daccbfa23e6a5625b2bcb880b8806ac0356018809881e8f27eaf37756edc0bea9f023fea71ebabc586cead35b6bc36ab26ca89e656ee88140f69d53352c53f9b55cf921c7c658f87c7bd2e6d476671787351fef197d4f7615f6ea8a64c4490b00840271be040f71eefacca2be6c7744493bf6cc90502038080f02420e02059391bc9a6bca9af50116b4cf4cff7adee2f7769f2f0e0d6eae30576afbd3fd7abab4d83da4ef3d1ac53a6aaa154055500281b00037013ce4ccccef2b5e874848843c4e54e9e5b3a5b30d5ea64514eff0078f709d9a4d2ce7bfa47569cf9a31d7d595312c5998966662cec77b313924cf4911111b429a6779de462105c480b880621031091880989225a0755a937bb5699ff00509a7346f4b47a4b7629da63e2db345b654784f26bb7740cebda537f6ab31f62b1cfa4b3f0ff0076df272ea3ac33cafd77fbcdf397b5e90af9ea64c90202c211d5ac17bcf6498aee8ddcaee5b7cd911b2001083c480e0203c090838081eb726f423ded714d72b4d7a55ea7ba9d83ed1dc2736ab511829c53d7b43760c5392db766c5676c945169d35088830aa3809e62f7b5ed36b7595c5622b1b42698322421e769dd2f4ed291a8fb4eea6837bbf003f59bf4f82d9afc356bcb9231d7796537f7952e2ab56aa72efe8abc157b84f4b8f1d71d2295e8a6c9926f6e294204cdace0202e202e2403100c40310131242b6c5cf6383f1135dfc9b68da3439e80f013c94af5e940cefda68c57b33c0f3cbe7ab9fca59787f4b39753d99dd7ebb7de3f397d5e90af9ea64c90210e7ad71c17ccfe9338af9a265cf3341c2420f120384078101e04841e88490146598855037962700489988e72988de766cbc98d0cb676eb4f7d43d3acdef39dfe4374f2daad44e7c936eddbe0bac38a31d767ab399b040655a8154b31c2a82589e006f99444cced04cecc9b4fe956bbaed54e4531d1a0beea76f89de67a6d3608c38f87bf752e7cb392dbf6700137b41c0480e0202810175601ab00d5806ac042203f57a23bea201e644d5927afc1b71f6f8b63d103a03c27945ebd18144f6a54bf676b53dcb90a7fad4aceff000f9fcf31e8e7d4c7e58966b7830ede399e831fbaaeb75433362e3af5f3b06ee27b6675ab1994226683c4841c203c480e020482420e0240b27206c455be46232b6e8d5bbb5faa9f124ff4ce1f11c9c182623bf2fbbab494e2c9bf93589e6d6a2484902afed02fcd3b75a2a70d70daa7b79b5dadf351e72cbc33171649bcf6fab935993869b47767c04bd549c0480f0203809014080bab082eac0356124d58410884ba6da965edd7deaca7d0eb7e539b516da979f474608ded58f56bba317a227995d3b6055fda35a9a9a3eb91be905acbfd0413f0d69d3a3b70e68f5e4d59e37a4b24bdda430dcca0cf498ba6cacbf5797735f3b06ee3df3a6b5eed532804c907080f121070901e203c4841e203c0902edecb47ed6eff00cba18f5a92a7c5bdca7c67fc3bb43d6df2ff002d0e522c4402067bed0aa66ea92704b7d6f3676cfc1565ef86576c533e73f48566ba7f3c47a2b604b0709e0480e02107859014080ec4035601ab01310135607aba1a86b5dd15e14d19cf89d83f395dadbed867d67677e96bbe48f46a566b85128968e881cf7d416a537a6c32ae8c8c3b558608f4326266277844c6f1b3e7ed254de9a3516ebd076a4e7b429c67cf619eaf4f68b4c5bcd53922639793c913b1a0e101c21078901c2407ac0789083d6407881dba3b4857b72c68556a45c287d5087582e71d607b4cd5970e3cb11178df6674c96a7bb3b3d01ca6d21fe29ff051ff00d669fc169ff647f7f767f89cbfbbe871e51df9df7553c9698f92c7e0f4f1fa23fbfb9f89cbfb80d3f7dfe2aaff00a7f48fc260fd908fc4e5fdce6b9b8ab55f5ead46a8faa1759b19d51b40d9e266da52b48e1a46d0d77bdaf3bda480496078101e04841c04078590175602eac0356021580fb7a7961eb31bced09ac6f2b0722edf5ead6adc0b8a487eca6ff8ca7f11bf3ad3e7fcad7475e53668748600958ed3e02110320f693a339abbe700e85d26dff31460fc31e92f3c3b2ef4e1f2706a69b5b7f350597048ec97713bc6ee09e451243c4841c203c480f580f121090480f580f1210914480f590848048122880f02421201203c0901e040785908382c05d5809ab010ac093a94d9feb374507693b07c66abcef6d9b690be724f47f35469a7155e91ed63b49f52679dcf93da649bf9aef153829155944d4d820102b3cbdd0df4ab470a33569fed68f6eb2fd5f3191e93a7499bd964899e9ddab3538a9b30fba5ce1bc8f719eab15bb2a6f1dd089b581c2420f101e24078901e21090480f59083c770c9240006f24ee0242639af7a0b910baa1eec92c4679953aa17b988de653ea3c4a77db17f2b1c5a38db7bbddffe2d618c7d193d5f3eb99c7f8ed47ef9747e1f17ed78da67916a14bda92186de698eb2b7729de0cebc1e253bed97f973e5d1c4c6f454147020820e083bc11bc196cac98d9228902451083c0902402420f024070580bab00d580a948b100719133b46e446eedb0b6e7ae5500cd3b6c33761a8770f212bf57978317adbe8b0d2e3e2befda1a3d8d2d55129568ea80402035d7220635ed07417d1ae0d451fb0b9258762d5dec3cf7facbff0ed471d7867ac2bf538f8677ed2a632e0e25c44eee198d8a21078901c20482420f5901e2048b210b1f212cc55bc566191411aa81f6f62afa649f10270f88e49a60da3bf27568e9c5937f269f3cead84020679cb2b414eec951815a9ad53f7f255be40f9cbfd0649be1da7b4eca9d6d38726fe6f2009d8e348a24091448424512048a203c2c841756005604ac79aa7af8cd473a94978963ba69b4f14edda3ab752b3f35ab929a279aa601dac4ebd43ef39de7f2f2945a9cded724dbb76f82eb0e3f674d96a5189a1b4b00804020795ca2d114eee83d171b186c3c5586e61de0cd98b2ce3bc5a18de9168da585696d1d528557a35462a21dfc197830ee33d4e9f3d72578a153931cd67697009d4d078901e203c4841eb20482048b210b4fb3bac16edd4ec35281d5ef2a41c7a64f94aef13acce189f297668a76bcc7a348940b4101c040a172eea83754d07f0e80d6ee2cc4e3d003e72f3c36b318a67ce557ae9fcf11e8f05677b8522c812a890848a2409544842402407058427a1446d77d889b589ddb26bbdb6e51d5b295df9bab4159b5c55fa438c22f46d94f05e2e7bccadd6e68ac7b2afcfecb4d2e1fd76f92fb6b47544ac7727804020100801102a5cb8e4bade53d64c2d7a79349b81ed46ee3f09d7a4d4ce0b7a7769cd8b8e3d58d5cdbba3323a947538753b0833d3e2c917aef0aabd26279a3136359eb01e242122c80f58122c843a2cee1e9544ab4ce1e9b0653f307b88c8f3985e917acd6dd25952d35b45a1aae82d3d42ed41560b500fda52620329eeed1df3cdea34b930cf38e5e6b9c59ab92393d80b395b9e669ad3d42d57a4c1aa11d0a4a72cc7bfb07799d3a7d2e4cd3ca3979b4e5cf4c71cfab36b8b87ab51eab9cbd46d66eeec03b809e86948a562b5e90a5bde6f69b48592c122c09564212ac812acc509144843aadadf5b69d8a3ac4cc2f7e1655aee5a140de384518b5a6769fef98701f644e3d467f631b7eb9febfdac34f838e779e9f55eb46d98403662532d1e840201008040201011866053796bc905bb5e729e12e14745b838f75bf5e13b749acb609da7a3466c31923975647776b5293b53a8a51d4e194cf498b2d72578ab2abbd26b3b4a3136b59e242122c80f58122c841eb2048a3683b88dc46c23c0c837758bdad8c73d5b1d9cebfeb35fb3a7ed8fe219fb4bf9c98a38f13bc9da4f9ccdae6774ab31122c84255812ac842559025598a1d7428ecd773aa83692766c9aed7db9475655a6fd525bd27bc21501a76a0ed3b9ab770ec59c79f51187a73bfd3fdbbb069e6fce7a7d575d17a3969a8000000c00384a799999de56911111b43d402424b00804020100804020230cc0ae729f92d46f17a4355c752a28e92fea3ba7469f537c33bd7f86bc98ab9239b25d39a02e2cdb1557299e8d550751bf43dc67a1d36b71e68e5d7c9579705a9d5e689d8e73d6409040916420f5902459024590848b02459025590848b204aa642135142db00ccc66623a91132e966a74b1add3a87a94d36b13e134cda6dd39479b6d69cde8d8e86ad70c1ee3a280e5282f5477b9e27ba5766d6c5638717f3f658e1d2feabff0ba58d82a01b374ac773bc080b0080402010080402010080181c979629514ab28604608201064c4cc4ef04c6ecfb4ff00b3d192f6ada877f34db53fa4ef1f1f2969a7f13b57964e7eae2cba389e75522ff4757b76d5ad4d93bf1953e0dba5c62d4e3cb1f965c37c36a75840b37b56c916420f1204824091610916409164212ac81d14a8b1e1eb309bc4262b32949a49d76d66e08bb49f21b66b9bccf467147a16965755b0117e8d4cfd6619a84770e138b2eaf153ff0029fe9d78f4b7b75e50b3686e4d53a5b40258f59dfa4ede72b336a7265f7a79797677e3c34c7d164a16c16686d4f0080402010080402010080402010080d65060725d68e4a808650c0ef040224c4cc738263754f49f206d9f26986a2dfcb3d1fc2767a6276e2f10cd4eb3bfc5cf7d2e3b7a2b779c86ba4fddba541c03028dfa4eea78ad27de8d9cd6d1dbb4bcaada12ed3ad6ee476ae184eaaebb0dbf534db4d78ece734597ad4aaaf8d371f94dd19a93d2d1fcb54e298ed20320dfac3c41fd24f1a381326af6543e08c7f298ce4f583d9fa4baa8d076eadbd66f142bf3c4d56d4523ade19c60b4f4acbd0b7d1378dd5a294c76bb64fa09cd7d6e18ef32dd5d2e49edb3d4b6e49d57fdf567238ad30117d7799cb7f119fd15fe79b7d7471faa561d19c99a34ba94c03c4ef63e24ed3387267c993df9ddd34c54a7bb0f6e8d9aaf09a9b1d217101601008040201008040201008040201008040201880c6a40f081135a29e10216d1ca7808119d149d83d23700d169d8204aba3d7b204ab6aa3840956981c203e01008040201008040201008040201008040201008040201008040201008040201008040201008040201008040ffd9	 	0	 
17	7	Дерзкий	2020-01-07	12 500,00 ?	Ругается. Прятать от детей	\\xffd8ffe000104a46494600010101000000000000ffdb00430009060713111215121213151215151512151515151015171515151515161615151515181d2820181a251b161521312125292b2e2e2e171f3338332d37282d2e2bffdb0043010a0a0a0e0d0e1a10101a2d221f252d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2dffc000110800b7011303011100021101031101ffc4001c0000010501010100000000000000000000040001020305060708ffc4003f100001030301040803050704020300000001000211030421120531415106132261718191a132b1f0071442c1d12352627292a2e11582b2f1b3c2245383ffc4001b01000203010101000000000000000000000002010304050607ffc400371100020201030203060503030501000000000102110304122131410513512261718191b1061432a1c1d1e1f0233342245272b2f116ffda000c03010002110311003f00f6aa4ac90a5a02401d0489400e8012091200628019480c4200a9cd4c40a9b4a082e29492b253100974f701852d37d08026dc3b8849735d5134355bb212cb2344a452eae4aadcec6a332f2552dbf427695d1d5c90efad11449ee73556f3ecea0e22656958753addca90941546a00b369f3d05171bd6ad39b52b6f03c625152f02e34ddbb2da03ad74d2a036813ef5ad3928448451bf61e2159c80536b8e08c791c5da21a2d6ed4d3bd7a0d37887b34ca5e31ddb7046f5664f10a7c12b11176df6f35b716a7746cadc0b2df69b9f91b95d8e7397615a487ab70e5a55884daf7908a607476cec2cd35c96ae85e9091d0489400e801209120062504112f534030729a249ca820414009048a029208b980a13614546804db8820eb46953b80a5d6411c7a05959d9e0f04d71f40b63b6c00e086e3e80aca6eac811b9553c319a06d807dc392e7e5d0c6ba1536c16e2d9c17172607091629033adca69c6d513b8aaadb958e314e5c8dbccdbcb723b95ee30689decceb6b3eb5f04c85b7c374d0c92b624f233a1a5b21b1002efcf418651aa2b5919a565b306e2a88786e14ba0de632eafb18157c74587d08dec099d1bd4e8c80a5e8b0ae6878e493e0d51d15a51047b04aa115d0b2c951d97d5f646ee0b6466a8cf25c9654b30994852d6d01097780558bb0abc8b91e2c2c1548c3a09120074009048940117264052f72648822c7a92496b3c941058d950e8929ad5b4aaa7914028aa9dcca88e64c289beea37a89678442819db482a7f3b0b276b24dda0af8ea20c8a6237e1379d022993a5780ab554ba10122b028dac2caab3c24964505c83296c28595342ed2aaf4c2e56aeba8ea202fa2b9393220a20692c91bbb032f68d34d29b5c10655a3831eba3e17a8db3a12475964f6b82f5b19a688483e94052f926824566aaf6b0b1995da0a1c5d129f218caa0ee2a86a8b44e00a94c1a06ac0056c6d95b5440540a698b60fb3ea60052d5a211a2d2aa6584c2801d400e82448244a0005fb5edc47eda9e5c5a3b632e197007988cf2e295ce2bb97ad36677517c73d0c2da1f6876148968a86a91ff00d4cd43c9c601f22a89eb31c7bd9d4c1f87f5d955eddabdeebf6ea615cfdacd307f676cf3ba4bde1be81a0fcd50f5ebb23a50fc2996bdbc897c17ff000d51f6936700bb536621b01ce8e6ed2486f84cf72b7f398d75307ff9ed636d455d7cbe97d7edef24cfb4bb0260bde3f8baa7168ffdbd90b598ac1fe1cd755ed5f0b57fe7cc32efa5b62403f7863a44c365cefe968265266cd06b86648f84eb2ebcb6be3c7dcbf67ed9b6a8d0e6d6609cc39c1aeee96ba08f30ab865857529cba1d4636d4a0fe9c7d42aec82d9041f02972d33334d75322952d4e859a18ad9366bb6d202dcb1b488b03af4a1679ca8904aee237223a97106917da5c38ad78f58e488d81ae648dea9d4373446d28d6415823a99c3d90a2e0e959b51a86c9a22e62e6bc8db21a2b7315b1970234057367a944e561473fb52c0b721462c8e12b44388db2f6a9661cbd2e97c41d24c848d1abb6a061743f371ea58a160157a4a5bbc150f5ea83ca06a7d2924ee858e7aec8df0875891a96bb74efc8531d5b9752761ab6dd23070707d9698646c1c4b5d7daf00abb7bec56e25cd0637a8df323cb401b2b68029f1678c914b5474342bc84ee99298431f2a1a1932d0949120906da57f4ede93ab55769630493f2007124e00ef4939a8ab65d8304f3e458f1ab6cf16e93f4eee2ecbd8d3d4d176031bf11689f8dc326788ddf9f2736aa792d2e11f42f0ef01d3e9946735ba7ebdbe4bf93967d573a0124802049dc37c0e41666dbea76e308a6da44140ec886f32a6c4517dd8ea06a438405120e237123cd0438a7d462504ed46b6cfe935d5180caa748dcc20167f4a9dcce767f09d2e6bdf0e5f7ee759d16e9c97d66b2b318351035b5fa00ef21e63dd5d8326d97279bf10fc390c58de4c327c76ebf63d51955ae6cb482398323d575f86b83c94a328be551ceed4bad0f225717549a9ba1919a2f352c56c9a0db7b80d5763cbb593469d1b8078ad0f511a118432882aa8252e486c55590a9d4c5510982bdeb8f243153eb294c9a18570530503ddb5ae0ac846d8b24635e5b342f45a4c6aa8a3b996ea227054e7c7b597c1815f5310b32ea3d99f6b4bb4ad946d059d2d8d2819557311d06b58ce4af8ea28185dabc34cad98f5098b46a32f1b1bd5fe6a0da73f4185a57131e794599d9a8cbd216a5ab62d1ab63b403974306a54d7241af49f2ae6d162265c91cd224f17fb49e963ae6a9b7a67f634ea118fc6f68d249ee0ed407aae66a73bc8f6ae88f7be03e191d3c1679feb92fa27fcb47124ac88f4cdd0b522814b810ce06514439a436a4511bc3696c9aef01cca351e08905ac2411e202758e4fa233cf5b8212a94d2f982b98412d20b48de08823c677246aba9a23914d5a76862dfa90a09b17ba09b1209b1949166cf45f6fd4b3ac1e0b8b0e1ec0e80e1e1ba7bd3c323c6ed1cbf13d0435785c5a57d99df50ba17bdb66ee2353491e3a498f34f7e6cacf9f6af47934b2db334edb648684d3c0a8cb1646ad224c0597c9b748b6c2ad6839b9955cf4b28f22366a52b880923936aa15c4857bb59b3e672e014410d7958644b456fca5488b28782372d09704d833ae0ca94e989201da45c4485d9d1e69705746083564e174e6b7752f8c416eeb3f912a8f2b91e8562f74fc27d15aa0146d36f5cd6ee3e89658c2c6b5da61c62153f97e42ce82853042d2b1d2209f56a368d608eaa02e1d990a5d5e709d300bd9e4ea56e39b4f863c51d2dad7c656e59e55c96ed467f4a3699a56b5ea02416d37c104820910208dd93bd532cedf06bd0e28e4d4422fa59f3e54b9cc939de4ef93c67dd36c3defe6231ef4336e0287063c7551eb66ff0044767b6e6e1a1ed9a624bb2409dc04f1c9184f8b1dbe4a35fad78f139637cf63d0e9ec4a219a1b418f96b4cbbb435e9d024c60434677cbe70b4ec8f4a3ce4b5999cb739b5d7ddc750eb0d95429547965263674c00c1d922663801f09e79f04f18a4f8465cda8cb382dd26fe6737b536ddd0bd652635c2812e0e706e0069209eb019d5237472ef4d4a9bb30b6f7254743b56de955a515d8c73f46b717340d200009d5f864ea8c8dc79149929ae4dda3cb9a124f1b6b9fa9e7dd24e8e8b701cd24879ecf6b54081898df27e4b06582857bcf5fa0d7bd45c65d518c2d79959dcce96ff42cea07f9dc9773237b2152de72dca952f521e46baa04008c907d15d467fcdc6ebb9b5d1edb352daa6aa65a4ba039ae1870e5c20f9a54dc1da32eb34987558f6e4b5fc1eaf6bb659569ebd2e61812d7b4b483ddc08ef0b52caa48f05abd24b4d3a6d35ea802db69b5cf705189f2eccf66bb6e846f09f3ca2a3c8b6335d2b839a76f81932aad2a826c0c3e0a8c89510d9636e87359e3d44b0fb6b62f185d6c1a594d58c958bfd1c83385a63a06993b499d980ae8e2c2a22ec10d8cde4169e4b522a76c2672081b81dbb11bc8264432ff00f4b1118f44e2519775b086ad4207922828be95a968de95a027d577a4a268e56eae979e48cad93b36172b76908dfd9cc848ad48db8e3c1ad30169ddc038997b76cbef142a519d3ada4039c1e071c25657976c932ed2e47832c723ec797ecdfb3badd634d72c0d992c0e25c60f3d3a60f8aebe27be2a4ba1dec9adc5cb4dbf911db1d03acda8e7d02d2c26749c16f3100411c71e10ac70b170eb527cb2be8b36b52aff00b42e6e9706b80789f84e7918046784f7caaa29a91d1cf28cf0f4f81e95695891da735e1da44899735c5d01c31a5d2378efc615f17c7270724127c2a08a24132d8206b24ea9224fc2648874e24ee0084c8aa6b8a62b86d313534343b5012e21ad73b70398d5f33184d26ba94c31734d99d7d5ceaeb2a398d832ca751edc86b670c64f6a7f11d502600e34c9beace96182adb04dfab4bf9fe38bf53376f5ed2fbbe96d0d619196e29b5eec9304ead5999701bfbd67cf25b6abfa1bb418b23cf7beafeb5f6387d649e03cb3faac1547a8a497a89c3eb8fe6841d4a9c63febfe930db54b865155f1ba40e5fa274ac471daaba9552ed1f60a65c14db92b7c1bbb276ad5a6e149afc71639d2df0124069f309526959c7d7e970e74ed2b5dfbff0073a5b4b0a8e3ab2dcf104144b5091e27363f2e4d1d0d8d81c4992b1e5cce6546cd2a585946b2171492b69059897874959b2647744598d77765b9e00a6c115b915b91da6c1bf6bda083c17a7c192348be2ed1a9717400de1687962bb8f68cf3b44734bf9ac6bb916897fa981c54ad4c3d49dc81aa6dd60fc499668be83292274f6cb5db8a979e2bab21c9177fa8f7849f9d82ee2da04b9da406f214ad6637dc2d023b6a0e69ff00358fd42d11fbf8e6ab7adc7ea1b91cef545c4085c95d4c8959d2ecdb10005a54951a618cd0801649ca99a6e90aa5caae59781372037dde565f33925bb7c12ac37778057a4c10db8e2bdc6983e04def5a23268868e13a5fb6aa5bdc10c1f846fd277efded2770e7fe2d85316792704a997f47ba434ee25af68a4f7113d59c3a349d4ea4e11dda80f744b1aec3e3d5cb852e68dbb5baab4b4f5715e9b9a320c76a4b5f01d919d263260386480aa49a66c9bc39636dd31eb5e38b46ab7a8c00490c0e9683877658eed4384626410e1226093e3944c31add519af9f7fa92afb45b061f4f3f0ebb57b846fc9073bc3a7967bd24a5e9f61f1e177ca7f292473d7f6bd7333aabb5a4b80a4caa1c1ce189159c61b8dc0e392a251bf79d5c39d629da5b5fbe9ffea91c797383883d9df89888e056468f470a714fa8dd67300f90fc945166d1facf11ddc3e680d8ca2ad4c7d7c93c5589927b15b07799c031856478ea60d4cd4a2f6965b31c0768ea8c49024781fd6512926fa195607b12ddf53d5ba0f754ea5114fac0e73461a59a1e07f538380e63cc2e66a154ae8f25e2ba4cb8e7be51abeeba7f63a9632372a63193e8720b5a932424809546e1649b680c2bfa124aa5272903322eb669702b6e3c74eca585ec8b22c10ac9b6bb8d166d7dd6465649ce5ea3d957dd02c39252bea4a28b9b30e09b14a5d6c198f5f6234ba7f35d4c5a89417511d87d9ecd0ddc1559b3ca5dc1071a2221732796575658806a5b09384cb2314836d071099e67ea04fee83925f35905f46d4725e85c8b31ab3429b83426f34d09501de5daa272b6137c013aef82ad94be04c0553b59d0c58d51a159f91e017ad8be17c068ae041e9ac8a39ce97ec0fbc34d4a63f683c32d00e3eb92b20f9126ad51c05bda963a41d021ced5abf7009008e32e03cc2bccd540fb3b6c54a809738f5549dfb3067356a0275639005dddafbd4b44466ce936674cebb0b439cca8ddc5ae641ee8223d73e6a368eb233b4d8fb7e8dc8d2d31504eaa4e30f11f169e71dde709251a2f864dcc36e6a86833810727ba4955368d308b6d51e41b4eb6aad5080002e3bbbcae6ca9bb3dde977471463e88a3c521b22c528188394a2b9ab2b0df3ee9565fa9ced462955c4b1d4cb84118e5faf351beba14470eef6a46b6c271a755a5b57ab32d8246a0d3304f7f82aa694d53451aa8278dadb71f43d86cde748d441740980409e601c854e08aa3c24e31536a3d0380c26cd14d0b28b4271c2e4e4c65760956982b3a853029aac0b66395a2b922541a14e47c02087be160c8c604eb64e1646f74862c394ea6ba00354c25f399143b1e8727202151eaaa40530a494464a64ac19687a5706286d06caf571c765d8b92bbb10a9cb0da6f507464d7c9542565392975254ace53d142858732dc053b51a632d8ba91baf89a79b47b60fb85dcc6ee117ee2fc4ee2302ac24aaf2488989f2f52b440a3233c7fa4b4cd16d6a40380a8f34c1206741cb449c0cc93fcb8ccabd19a7d012c0c5a521c4bebb8e3910c04f7f64fa77a9ee2afd22d67e8eef0098818572087b5ce05a4104120cf3046479202cecb6774bc56b5ac2b66ad3a649881d634f6012381970063891ba567c90e0e869b51524df5471ad790e92e92f2e31ca2372c1920aa9763d6f876ab24e5ba4ff576fe85ba89311bb8aa76d23acb2b73da8982928d0a5ea317a9485791744339d02614a565593238ae831ba0ddfa8f7426f2b77732cf55e5aadac228df0230d39c1d43107b86f48f0b5cd999ea62fd9dad59e99d0cdb549ed14834d370c0cb9cc3e04ce8f02b14d4a12b3ce6bf41384fcc6ed3f93fee7674dead8727266912a870ac9e28d196480de72b9b97153e04b29aad954422ec56c54e42d125ec8a87a99c2e5ea223a20d642a218dae4627a92658bec4a2aacd4b18802b9e9f60a443e4a36b44d173525324734e54a4c9a2a34dcb4a8cc4a0fb4ab85e9232e0bb170c85e3e567cb3b3a71692334b72921139f9e5ed05b2a00112e06c7eaca6bdca98db0c92456daba9b1c5a67fda7f43ff25d2d2cbd9dafb0fa4cb6dc4ba93d6d89ae4577d4f5308e63f256c787c14cba72794edcd9ee79d152ab69ea7d474b80d7f143b4b491272d3c84ad09f732c95f003794453d2c6fc0d634371de4924f12492e26065c532164a80cf184c299f777102263ebb94012d8d2d0f7b84b5cd2d1c093a9a4998dd823c4aa32e45fa575376934eebcd92f67a7c435da81d47e2c081b80e5eab15a7c763d44314f1a8ceb9e17c104d271d27bd532a6ceae0528c5bea4cb3092f934ae620c1c663dd5ad2a31a9cd4e9f42f6bc7355ed66b5922354cc0e1952b8e8539651724d93a6d138cce0428e4cd3a6f8367646d1346ab5aca869ba46a776b0dcc97000c8ee554b13946e8c1a99c257071ddee3b83d3ba608029bc8c4bc90d69ef602248f1d2ab8626bbf3e870df83e697375fe773a0b1db34abfc0f048deddce1e2d3f3dca324a70fd48e465d3e4c52a9a09042cae5657b10fac25dbcd9532a755532610226b059a58ecb1f422eaea3caa29b2b6d45972e3f41e2c4f72a23887b287382be31a14ac3d3b8058e2aaa1c403ed84a88479e474c2bab0ba11c768532ad2b616e7235608dab2fa8e54be4ba52a40d50c65327456a3bb9656d7ab10db44e8e29e2919b2266757bf6b0c8cf7731c4278b94649a0d37eb0cb5b80e01cd32d3bbf307bc6e5d48bee753aa2dab584157c24accf913a399da9602e482ea61e417347c4201d33f091fbad3e4a8d46a678f26d8992534b82547a1b41e321ed3dcf11e8e0522d74d7548a9e5f71c5f48aca9b1c58c07b2e70971c9cf1d2072f756435929763d32f068bc7195f2d5b396da2c6b603441825dfc3de495af14e5256ce56b34f0c73d90f99bb714853a4df0681e11ba37e573e1ba5391e8f22c58b141bfd2a86a6d905ceee3fafe4ab97151475b1c94939be9498358bf4c9cc17388e7188fcd5b955d19741965052f46dd17bae24f255eca46ff3edf245c8412a1d913f5ec8a237243960dee53cf44533dabda7d4cdda378e739aca7c1cd27c41e7f5b969c58d453723cfebf55933648c317668d5a67e1718739a1d13ba30242cd2e8d7636c5273527cb0dab741acd7112377673c372aa38dca546ac99e18a0a4d75ec69db134aa31f4c905ae7386499906467bbe51c94a9eff00665d0aa7a58ca2d3e6cf42b0da5d6d30f1bf738727000fb820f810b9d9b0bc73a3c86a71ac391c0b3ef252d1826c7eb25250975d04f7a748be2ed09ae2543132245ad62cf9222226f61855280e66dc38ce13a8262d90a125124083ade84aa9e31d23458d84aa04970a8b7c7840645bd8d46ef0b4cf4f923d51ab0bd88b2a348dea9af51b23b067a96b82b8cdc5d0256ae5a846b8d49518b77b4ce47c96a841b31e7a5c2326bd7738f1cad11c741869728e8f6051701fc2ecc77f3f150f36d65f2cee2ecd7ad4cb7e21e7c0ad78f229728b5648e45c14db90c782482c761dfc07f0bbc381f19e0acd461f323b975460cd0b371b440e0b9accf13c7ba49a455ab0e0f149ce6900ef7c9ecfaab31df09f73df69b510cd83747aa5d0e3ea529104cbdf0f7472fc23b877782e9e37dfb2e879fd5c784aee52e5fc3b2361cd10d9c86ee58f7d3676bf2de6462aed2198e04004eec42ae49dda3a9a6daa0a13f810aa40ddeca63d791e7b631a814d307329db5d8a61197fc8954a900f3e1e2a147927266a8b5dcaa88711dfddec9e4d233e25927177d50831f9d4e31bf18c29b5d9143c7256f248ae852133189f9266dbe0a14618e129c97012cb8ed03c87a8dca278e919f4dab5927e8d06d2b90411e223b965945a676714a19634cb28df96b84e74ee3c7ba7dc2143fe4876f6fb2f9474dd12da9d5de1639d146e1a03671a6b8821a7f981207847009755153c4a4baafb1e73c5b4b2dce4b95f6f71ddd7a2b9d8ddf53cd4f92bd30ad71154441aab7c0dcc4be95385585b7d4b6729648945cd12556a3ed0e586d41e0b7c631e944a40c76701b8aaa7a457c327616d1a70b3b853a0a2d7942c60d10857a42d33a5ab6c0af4f9706f43c7234035f6407715825e1d7cd9679a9f5326ef6610b2cf46e258da664dd6cf254434cec852332b6c8c6e5ad6269154d5b02ff4d870c2a672da556d1d0ecca50164dd6c56db34def6819c8e453db8f2868a7d5181b4b67b5f269d4349d11f087b7cdaecfb85a716be51e24acb9c9d5b25657956da83cdd546546526970a8d0e6b8b4498730e2460020e7dcc6471c92f61357d8a1f2f83cc285135adcb9dd9757a952b3b9b5ae71f7d207f5299c94737fe2923d7f836393c135ff71454b268248e3f5e9dc8fcc4ba1b9f86c1c9c981d7246ee711c71839f55a20b7f532e69bd3a75eb545350c1cfc933c6c316ba1292b5c93654d580386318920c7e491412e59ab2eb1dd457545eca723e122473cf7fe692528a63e29e49c79427b037f0cf894269f71f26e85544ceaf5dfa8c43718207b6fe6b4c210a38da9d46a149a5fb153def061d907382467c3f5566d8d70638e7c9bd6fee1d6b4cb9af3886c4471dffe1516a2d2f52cf10cd2a517d3dc4453905c4e98f7fe156b957067c78af1bc89d510d7870dd1bb9f1ccfa2ae515c346dd2ea659314a0dd346bd568700633037782c9baa546cd1bb96457cf0d171697b33bc86907743d80ba67c4288cb6cebb1d3c98fcdc3cf5afdd1e99b0f6cb2e68b7b53545361a82083a8b44913bc4f10b14f13c73f71e0f57a696293b5c760aa409563e8644d05d2a077acf903a96382a37051438652cb202413430a064c3995a15b1ccd326c83ddc56c8644f92c88382ab946dd814d4ad0568c582c751b2e6d490b47e586f2cebd770c824014d7a01cab94131a32a0676cd694be522770355d9010f18dbaccfabb0a4e30b166d36e11c6c0abd93a92e7bc0e0c5a68cebbaee0a24d50dbe8cc73c92aa54572c8d9cefda5debd96d4e8b4f6ab3c63986c40fea733d0adfa38a73dcfa22dc4bb82dc5bf541acfdd631a04f2103e4550f14927397767acfc3fab59632c6bb1915aa19de3cb8a144f4809d4c993ddf9c7ccab564695239d9b4ca72b915de011eb9ef1bbe7eeacc726d9972e0863f69175b52000f5554e4ecdf874e9d4997b9d8fae70a126cbda8c50255af898f01faab1479289e47569038a1c4f984fbbd0a25838e45794447c8f23c13e2c8ce6eb74c9345763548601c49f607fc057bc69bbec717366df1a92e5770dab69a9a1dde0f9049be314ebd0c7e6c9d45be0cdbb043b1e07d42313b8726886670f691d058529a14cf3601e63b27dc15cccd2accd7bce861d4ed6a6bdc3d33a58d2efdfd3e3274fa492aceaf8f43d162cca58a327ddd7d780fe89dc9b6bbd532c05b4aa3667b2437b43bc4cf9426cb24d2b5d4e6ea340b363c904fa74f8a3d9a9ecf182d820e4106411cc1532d3a7d0f18e2d3a64ea50854cf032519572483b9619e9a5b82c1c54caa6585a26c368990a6306492ca778c7841c984d3a4b462c46c8e14972586dc2bf606c40b5ed02db8b843a81265ae1596c8a3aa5d239c24009002400c543697501b0ab528be84f267ed4a60b4ac3a96ab81faa39abca20ae4e456ca5d81d2b304ca451611479f7da092fda36d4876baa60747232e7fc9a174b49072c538aefc174e6a18f7301b8b82fb869e1a47b37f52575fc431ac5a68c1f56cd3f84f764d64a49f09035424b8e39e79ae1247d21f1c031713bc04e50e1ea515984900f39f54f17c19e785b9af42d613113c4e3c0a5ae4d31e95ef18b339f4f9a65d0ae6b9b438a3264fb70437e8428aeac9e81e7f509197a8ee29bc6f61d3cbdf826c6fda462d6624f14932bd9d6fa994ccc9ed03eb8f99fe92b73c7927bb623c36a9ac54dbebd7dccd53460692b1e78cb0cf6b32e29acb1dc8c7daed224024ee810324807e6aed3c9349d17ede0e96ceca29b2988ec8023bf8fbcacef02cce5913a6c559f671d816f99a5cd6ef0ea923c20b87be94a928c9af45fd8f59a3ccf262c7f1fa25d06b6768ae08def6807f99a637f2c289c9ecf81b6506b2f1d1ae7e47adfd9c6d1d6c341c72d9701dc4f01fa7e79bb473527b59e5fc5f0af337a3b47d005741e2471e806bd8854cb1214c0da1690562cd8d500d6aec2e7343c429aa5236e9eac258e0b6c17069689baa8432a7c0356a8ad84d0ea48932e8405726451d32e99cc12004801200aeacf058754a72e2234414bcb571a2f3637cb2da4caae3216856d5b192316f68e566cd2ae8572811b7a4aa864f5236d1e317d7bd7dfd7adc9b5a0ff0008a85acfed5e97c3f0d25f531f894eb1a82eec6a7f1b8f7363ce5df9856f8dcb9847dc7a0fc0d8e9669bf54be9d4855a79260885c14cfa0b4ac1deee071bf87aee4e8aa512bd039a9b169be8895368fa095b2f8c2917348e027c94d89e5b1f4f3c7877a9b13cb4340e5f5cd432c4a816fdf20cf0131f25663ea61d52b8b0bd8d4c0a34c8105c44f792e3fe17774516e2dfbcf9c78dcd29c52f4b7f561b547fc47b6ffc9737c5a1528cfe463f0f9fb2d196f6f595e9b7f8813e0d1a8ffc5628b70c5297b8e86e3acb6a589facfe9bfc954b36cc65096e9995b78f6e9b04896138e12f631bdff116f934a34ef745cffce8d9e83c33349370f5fe5946c5b43797142983a4bdc5b3921a0bf0ef080d3fee5a258e96d4769eb1284b2cbb275ef3d67a17d0ca96754d4a9503a2434366208e7c38e3c168c5a77196e7d8f23a8d5f98a91dc6a5b6cc76575157220c3da6c92b99aa90d404da3c9638c6cb210b2d16eee09d627668841c596752e0b4462d1a770994f9a4932892658eb748a442b06750576e65bc9d592bb7691cda14a2d050f28b4056faa02a679e311941b222a24df689da0b70e5cccdd4b6312012735438eeb5072426fcaeee58bb900ed3a3a29bde31a58f77f4b4954cb494c2acf04d976fd5d1b871cb802c9f0c9f77af4ba0e537f0399e27fae0be20f59b2fd20c19007936153e2eff00d6f823d1fe105ff4aefbcdbfd8d2bc7827cb057119eff143833dc3cd165aa286d2a6c4698f28195f62c61e5efbd0453ae4981e1c5488aba3215a7dd40ee2a8cebd30d3deaec7d4e76b5d419af60dd34a90e5a67c4c15e97491ac29fc4f9478be472d5493ecabf634d96f3823f09f5104ae6f89c5cb1aaf528d24a9816c8b526e4cb7e163bdc803e6571f3465e528bead9d2de74d70cd2d0d1e3fa7d77ac9abf6128fcc7c0adb6739b75e5b50d4e0da65873b9cd63dedfee71f40add17fb7b7bb7fd0ec69b2471ce3ebcff625d0ebdfba5cd1a849018e00e9125ccea69b1e00e396bcc77735ba527b9497f9c9d48e38e5d2ce0fabe97ee4bfa33e80b6bb6546b5ec70735c039ae0641072085b94ad59e49c5ae1966b53646d2bad5309641462d7ad2e5cdd441b1d1651cacb8e2ecd188368d25d0863b43ca43d4a69dc088c8188cacd2817f6260298e3101ea3a0c2b760e99b4e6ae8b89813a1b4a8da358ea1c08225893ca44a9083537961631a491e04fa93bc9369a161485722c0ad5042806dca61d6f5867b54aa37024cb9a5a23bf29258ed0d174d1e17b67649b6a1559bf553ad5409dcdeb98ca7278f6296af35af46ab1b39daff00f793f87f430ed9f3727b8d43fdb03e6b278a3ff564cf51f84d5e1c71f7b65f57311c30b8c7d0629a20e52824c618de0a91375f0863e0826e860e52c64c41e82baf6ac773a420769b401b48764abb0fea399e23fed33a1b719a6de5a49e50d6349f711e6bd4e255a782f77dcf8febe5bb5795fbdfedc1a0f906470c799195c6f11c8e3920be7fc0fa4827190ba3ae1d7557bb835b1fd4463d02a6118e59df6469c8dc22905dfde4768fc4e2431bcc813e83f45c1ccde7cd29765f637e05b62a262ed9b6ff00e21077bdf4d93c497d468255ba5c9ff51ee49fec8d2d74f7b4646db2ed4e63048a750496cc825af0f6c8fe22f5d5c125b149f747473ee6dc63d135f63d6fec9aecbaddd409334c87341fdc772f39f5ef4f8bf5348c3a9c75523bbea9dcd5f4ccb48855a2e2a6829018d9c754aae70b19288652b4854ad3f236f4ba05328c2bd63a2b731dd490e0429949b648f18eb211aa348ca571a1a2f71997155ba8e53ed1ecdc056c330ea08120074009002400a1003a0819cd0705141678a74f5b37971400ecb6d2dd804fe1632e418ff7860f45a34ebaaf718758fa4bd1afe0e0767d706e4f783eed6b973fc4b96dfc0f55f855a8b8c7e2bf70c0e32b907d02c702471df847433ce77c219c4a9482348268d4691052c911641d138ef4447b6ba141109c78be045d8450ce5c19fb45dd92afc2bda391e253ac2d9d45865ef77005c07ac9ff00d7dd7ad92a4a3e88f8a659dca527ddb61c47eca78b898f3c0f94ae26b62b7bc8fb237e91f0a2574ad338e1c7c339f45c8c391a4ce8cb928b5a5d6dc8de74b1e44f012d681ddbe7c567d44a30c0ebd7fa9a30febf91b1794da5d467e16d4d47ff00cd8e737fb835737037526bad7dda5f637c1a524ce67a334b5b2b5620cb9ec2478b1a49f197aef67e2a2bb23a3a47706fd5b3b2e805ef577b4c4e1faa99ff0070c7b86a9d3caa6995eb71de27ee3d8e175a8e058b4a289b142288b12280745009140245014dd346932a2490f07c9e757558eb74131256666c3d0415acc8482009208120074009003a0812007401e1fd2d7c6d47ea302a51b861f0a5725fff0000ef557e9dd495fbfee61d64376375eabec79d6cd1174e1c9bbbf94062c1aefd2cf4ff0085f9d447e0dff9f5351afc91c04ae4b5c1ef94ae4c8758429a286aa444bd482e04d7a19289d3a90a2894f924ea9272a5204e9a22f503b7c015c9ed30737b3e616bd2abc88e0f8dcf6e9e5f0674db3fe06f37768e78133f2202f5127c1f1d9bb9fc0328b8bde19f858d27cdd803d27d971bc4bf46d5dce8693876195bb14cf333e9f5f9ae3e68f950f79d184b7303d9ae2d739e01248d3e84195cdcf528a8bf89af1a6b94696d264d17c6f2d2d6ff00354218df72b269dffaa976be7e08d9d518bb02a0a6d75338d60bccf2352a01fda19e8bd03f6b9f87d8d98a7b62916d1b934ae29d51b83d8ef36b84fc8a231da699cf7af8a3e83057611e7048019002400c80120914a08a05da2f8a6ef02a18f15c9e58ebd927c4ac8e68ddb59eb629ad873ec906208b1f4a02c5a50162d280b1694058b4a02c5a50163c2083c23ed2406ed2a44eeebab523fcb59b4c1ffc8e4f174e25535719af83fa1c25819b87d48f8a96bf073fab71f7d4163d7be3e2cf49f85556a1fba2fee89d2addb70ee07d973e51f6533d5e2cede6947e65af3984a917b97b456e2a5154a4d22c9054742c5c8da9144b9723b8fd79a104ba0ed287c0d176c0abe6a307f1b7e6b66917b68f39e3b92b0cbe0cec6c9a23546fdde03ebd82f46cf92c6ec3763539d6e3c5d1e4d023e6562cb05395b366396d4517f5f59c6ee1e1c3ebbcaf3de232ff00536fa1d4d2af66d876cea5a69eae723cc985c6cd06ddbe891b212e68b6f2ae867587753d7548e629b0b9bfdfa0aab046e54baba5f57fd2cdc9d7271f6ad2cab49bc452a4c71e643bb5fdd2bd1da716d7a8eb8a46cded396d4c669d4307f85e263d47b94c9f05d1951efd68669b09fdd6fc82e8c3f4a3913fd4cb53102400c801200aab560d125032562a75838202885c416994128f36da56e3ad7c0c4ac538adccdd06f6a3ffd9	Алый	1	Ара
18	9	Тумбочка	2019-05-09	45 500,00 ?	Любит арахис	\\xffd8ffe000104a46494600010101000000000000ffdb0043000906071313121513121316161517191b1a181818191a1e1b1a1e1f1e1a1d1a1d221b1d1d2820191d251b1b1d21312125292d2e2e2e1a1f3338332d37282d2e2bffdb0043010a0a0a0e0d0e1a10101b2b2520262d2d2d2d2f2d2f2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2dffc000110800b6011403012200021101031101ffc4001c0000020203010100000000000000000000030402050001060708ffc4003f1000010204040306040405040105010000010211000321310412415105226106133271819142a1b1d152c1e1f007142362f1158292a27224334353b216ffc4001801000301010000000000000000000000000001020304ffc400241100020202020202030101000000000000000102111221315103416181132232f0a1ffda000c03010002110311003f00ed71d821879c99c0054a0402a0949caf4019eaab54ef0ee070f3ccc33e6a8a9279480921c0663ff8dec1ef78d4990b940674cb502480ab90752a49639887f88d6209e22b199456beed0c0a72101d9a80905aa960035896d74b6c9aa1f91880b5001d2492e962585406590ca2e74f2d2327a92a709706a19448721c90065d9ea2db4552909520e50b425dca732d33548268495139dea5bcb6ae711c1a94a09233a48073f854d50005281d2a682c0d1eab143b2cf3255e10333849a58ea0960e00d77804b4a4d5ecd9988e5f3a9e94ade22c0a52652b3ac65497239cb3a8135e71706bf9c4a4851628592b05d44d000e397331a060407ab7b4d0c8ae4a69cc1d5e10c2bb55d8bef00ee82bc2c4eb50db5c3d5dfda093e627366130d4a72e6b51e81cb00a0e2e2e45691bc703318e449ab32b29617399d4c4000160c59a0a0b06bc321f2eb470e28f40fd49f58c38515a33747fa5a0791330948292a4a920104b248aa438a9012081b5a902993c3896a0a2a254a0e48ca86772b482001d6aede70e82c22b2313b69afab08d109fb357e710562d33529297f1302aba8d2e450356f52c0eb12952b3552a2a2c39a996cc69ab56a6d05059aca35f91884c581563f388a49988cd282d55b8e9bbd19b76f3856762278525284208caea331651e4c1085661ea3f38742b2c2587b33fa9fca30ac5a8fb5cf5da12c3a6694e65940735eeb30a752ab8f2de1b9a82f9924f929afb9a0cbfe2150ec2a174a861d6f1a5cc6ad18e9a9fd981add80bd776bf8994dbeff9c46514abe10e4ea19cf5d4ee20a0b26bc4b366490e5b7fa44bbf7d9b5e9e7680cc2ca3573760e2d466aef56e9bb46d2a0f99980d1cd1f6268cfa534e90521585efc116f2a7da30cc17b03f3f6814f9a3367677614aa80b12da0631296a14524bbd8d6ce6c7dd85a0a1d9bef0d82687d47c8d23466ddc300f56a7bda20678240f0e7252156482003bb0045b62f054cc0094d598173aefd0d7ea37828560c4c7b007ca314b7d03fa7f98299a2a59edfb7d08da04841cd90a81d73d2d7a83507d08828766b470075a5bf7d23753a56f611154d650ca3325aa45c35080d7de9ed129a521c13503e1a83edd21d05835ac060cefb7e61be712511b5a2289a90761d7adaa2967a12f0a8241512a606c341ead53eba4142b1c5e5d446b976f988484f25f99f56a37cce91254d7700df50dfe47b343c42c648433b7d622a12ec416f38ac41587b39e9f32c6bfac61c496b0a0737f3a561e0c590fe597d47ac64229c4bfff001aa321e2c2d0795c44d9084822bfdc3ff272c453aed16185c42ca0a944e5bfc4ef414593d74a0822b0a4d4c905c3821cb6b5ebd22386c3a0b929b3254a0fcb4776ddef4df6319f28a218825412841484a733e7054a21cbb12a77d1ff00baf48089aa03ff00ae60f879f40e078d8d2c290fcc93295ca8484ab354a923c396c8cc451f7a5e2089524f3100101ca54cea23c3504862da74b3c1614027cf5a398cb02a559941203b072d99cf9b8da1557199b9c26614120b82052aeef5e5a51aa3a6b0fa7ba05963bb49000cc2ea2e68a04801b48daa5ca5a0e541517ca0a520a6f6773f402b053115f3f1eb50505e5cd5014526ba020bf2b6c3f0d206ae30a9c8ca3bb2b0f98b1ca34242aee4247da2e11c2e5a03965ab2dd2a02a48600160e068cf780e1b0d24853005d4abd1474724a4006ec34ac0056ca98658191294e6a28a7382970772c589a574784b19c466ad81ca1497cc4666d1c966b848abd62c4e2240572c95153872a48e5350e183a86a2bb4150a97de9289745233a8a5812c483434a8d22ea4b6c9d3d159238b2804e4084663ca4384bd49e5aa7a87ab8bc6a77105a15dee54871cceaca49b96483a9ad47b45961b029334e542132920ac029e536a3ef6311c5942b304cb7f0f38ca49512080c4be52f67eb07b0f4425e296b75850281cca4842854b7c4e02aedb308756b98af16472edca41d40a3ea69f4884bc20423c03394e64a500851ae553826e1c92c6f059fc3a5ad24a1b351aec9b5c8762efa697897c8d032932c872804825803a004fc4c3ce903c4e2e62087295555a17a307672e3620d627c3f0e8595cb5a03a4d1d3a5412c6ac5bfed1937048965094a00428b5a89ddcdc87dbf482b63b16ff5357f679114d7ac2ebe213ca99224b5f98adf7340cdaefbc5b4bc34b59202524796607d474d23664a40cc94248b2924569620bc2a1d95abc5a8904e40417040218b350d3ca35331ab72590e417eb6d5fa343f819482fcaeda1001af53a69131225004040e57f965f9318362d15d331ab660109737670fe40d89d9e229c6ae944d03300adf45bbdc758b599879747005cd00b75858e1066f0272b53517ada828d02b02bd78d52814a82487a12f5372c5dd25a8da43d3cad8f28514513ca59a9501259abe221e073658ab201b30019f7e87cfca1797c34021292091307880cb91831053d090d471b4524fb158fca9a52c90a0e09774d807dd5a7adc44272cd1ca333e81c8a94e61cdd2f480af0892baca6963c450056f5615676dda2733872455290525824b3a87529eb66150748282cd4dc4948ce1eee5d14be52ecabbd7ca1138a5512420bfc40161ec69ed0ecc972ddc21243d58821b77fc35f31aef0609967441d0660c09e87d60a6168a799895650e515142eaad6cf9aa1fe91b9b8d9a90f95219836fb3f3005bc8bc5a8c12039ca90d7ca457cda87d488d9c24a2966490e285d259eb41a43b614532b1e970c94d4025605b7b1afeef11993ec404bf92c6ef5059ff006f1613784c807c2036b4a92ed7240d9881eb0595c3a48f14bcdb246829a8ca49773fb687f62fa2b462d6012ce051e8589b53354694eb68dcb9eea19bbbd4329397a92e0dadae9173230e84a7c2c2b45b790b24b7aabed00fe670cca52825daa8a02e35ccec5f66f410ad8f4273e694a88c9ff53e8456a0c6431fc922600b293503c050436952da6d1a87f62fa278bc628a4a159b9b472016601dae04030eb291c89246b73e9bfa08c95c410273a3312699945c914a00c187ce1c96895b75b9fbc5528ae049dfb139b3c92eba9fc56291a0b381f78d21655992c4b10451bc8955ef9830da2d7ba92a6700b79bc124e1650b27a5cbfbbc2ca8789493e6f2b2c125e809a79b5add6199930265e672f5a0b7ca83ce2dbfd2642ec800f4a9f9c2c14996a4e1e582731b92f95eed52c7587927c0b168430334175151041f0936d83ea0edd2119d8a5a52867622a58317a91e4ff9c5e768250c3cbca95d4dd25c9e6b17b0f288a38482c9c8552d4904a81218f473a7ce1a92e592e2f84554beef30087758a907c2cc5c3bd6907978e29525254588539d5f302ee059b68617d9f4a140f7c100d0058727766bfca05c6715230f3734d980324929552e394bdabe5d20728b049a34b9ca29212a641ae425e83e1606893f285929f094832c8ae74a9cb1d585758adc176930a56b5a54483a650916d092e2e2b97d20cbe31252732d494cbfc4998871f26557eb68592418b65bce9e94a5d6594401de26e4e9682e1f88a929eed5e2ca680de9ca5edeff009c50c9ed2e054c3be135454183a416ad024a9be8f0a714ed261f3b00b435028a5c33ff00695005c7a42b8bd0ff0065b3b191c5dd5e12921ddf5b7c436e97782c8c621614853a4bd6ae46e6960ed47d639cc3e2a5a8bae6a2626c0a6c77a9018da2788c64a09a2ca54ec2a18dace413a7bc26a234e47472d484970ad89614356d1ce623a51e13c2e3c03e0a28bb820b54b51f66eb48e4b1fda8c24be654d33094d3bb58046fa96348e0fb45db69f88e441ee6500c128273114155dfd9a13c50f67aa71aed860642c83342d41b9515524eac598791315787edfe1e62f2e65019540acd2e1838ab006b1e2c95344d2633b28fa2a5e3a528012d6016a8035d68454fb02f58cc4e32524196b53160410141ac4507d2d1e17c3fb433a5e565d035fef7b475d87edd0225a662492b773b5581afe462e2d7b2649fa3d1ff0099052925c8e843534a8deb6f7d61fcca52689bb74b69b3fa6f14380e2689bcb2e60cc2c922b0e2f0aa55cfc9b577f778d145764393e8b41894b820aa9ec7df689cbc526af522cad40a51d98d83c53a30caa54b8b1df6827f2ca0ec7af9b5fcff004878aec593e8b69b3d2c09491ab91afddb5812e74b66a9e94ad9c312e62b4cb5122f5d48b91d22410abe60a03cfed062bb1e4fa1f93300a256522b4a6beb4ddad054cc6bae8abb0bd2951afde2be5a165f202b0d7195bd2eff0028c555594281a1277fdef0b10c8b0080cf99c176cc5c36c5cf940e582804a59ae13a7a5797cade5091c3aee086228cd5da0699eacc02c2d205ce47a6fef0f10c87e62cb8a135f84b1f6710399c44a4b12e1998839dfd988b7ce028c328f866850bd2f4d4873bfd61396b048256c5d99810762dd5e860514c1c9859e992a2e512f311cd9900907cf5de9bc646b132112d59662828ee9cc037a18c8a515f22c9fc04c37082ee1d81baa9ec19cfd23315885a55912093614bf90117850b76bd092dd2fe700918250e604a738f1162a6faa7e5d6273f7229c3a218792b44924879a1554b0703af41d22c30b90ca0b5109513e17a9035688925c2335ee4d9837a13d2238bc44a4664a11996d521853aa8f4d2336ecbe09ccc2b58c4ff00942120d7a35cf9015315b85c4a529a2aa58e527310d536049a11b5e2e8cc44d425c29c3e524311a3d43a614ad0d53399462ccf9a12ba02b0fcaeaa505ea2ba45a601d2148cec52ea531d37bd80bbc33da15cb294149095a4beae47fe4074d63ccff89bdbb131230b8760d49b3017243b896e05b556f41bc394ad704a54cdf6cfb7a14ac925c849acc7626950904324135a873d2385e2fc697885baa8d6b93eaa3527ce8d14f3263c412625cb543add8d2310aad4fbe90493c4e620be727a1a8f63f38589681a8bc4143b8cc5a5594cb4a65902a120d4f9d8db5de169b8e98a4e552890ef5d28d7d074b40de046010e61788ad04292a208d89af9b1ac6f13c4664cf1ad47d69ec29090894006f3c45e3235001b8da4b46a30c001446c2ec751034aad1302001a978b526a9514a86a0d6ff58eb3b3fdb79a9504cf59526d9aae2db5691ca48c395741bc1a4c9481ca92a3be9f6869d0347b2603894bc40cd2d61576b38f979436eaa660fa3ec74f7fb478ee1311325a9d0c93d14df9475dc33b50a504a660296218a4d09eb48d233ec871e8ee9073259496a39bd1fae862ae72e649578bab867f98313c1e3d9232a6f5245eb7706fe861f4cc4285140a47afd6358ba21ab07271ab29194548a902a69ff6f5ac0316a21684ac0524063ebe7602184ca4b832c94b5c00c9275ff3029a52b254a093a50bb6d5f3786aac4ee812f1841012736c285bd4695b344a74f2a1ca1c7c5a83e8fcb024ca404a8a524a810d522835dc9780cac69d54efa30a7de2b1e89becc24a1f2d06ac4b11a83bbf581226a4a89512f61b0fa16021d3392b49e5cabdc7dbdf580ff2ce08a28934500cdbbdbf38a4d7b157427c467e698a535cc641a749940ebe95fca37169aa25af93b3e18109aa1cbdd6a3989f5da1ec54f4a52ea52413bd239a1c650125d4d6094877f326033d0271cc4281624d7c459e83411c6e0dbb67566ab44e7f1e40ce024a8285092d5d4ff68e90a709c3a66a9976d2ac1f5ea7f48270fe1495249507f7873072d28529c68e06dbfcc46af18a6a266936d391d26164cb423286a08e638ff6bf0d844bcc24a8b8c8900ac916d580f388e3fb40020a525bfbb51f68f22ed2f1b42d4ac833a8de62aada72bfd63070695b35c93d214ed5f6a67632615a894a2c99609ca0751a931cf831b30f6370b96561d7f8d0bd354cd983d68d1202060884c6ff00965fe1313ee14039112c68d91eb017ac1e6ca20390d0a9308662a23041254ced4de249c32cd424c30042320bfcb2ff0009f9441b4300118db41132c9048148d010011023444312f0ea350291870aafc26100b261ac390ee43880aa51766aed0697216c794c302d1087199541b7dfed009b8ed103a39fb4065e1d54e58d04b966ad7eb00115e2979bc50c61f153189a16dfde029c32ab48966523ec6003a2e13da35a15949246a95475b82e2885550abe86e23cd8a42c050a286ba886b87e354ce3c434eb1719d1128d9ea6673877bec627ded2ec628bb39c444d4b3b32680ddf568b7282ec6df28ea8b4d1ced34c84e9aa48077d605df055fe50ecdc39090ce5ce83ea7484d528e66decdac69168969995f7d60f879f94977b53ac649955dc57f64695861582ca1598532b8befbeccd12dae18d27c95f981a9a7efce320d849282972a63b3fe91b8a7248145b2e64f0229092a624a839fc29153e661f9987cfca939435ff778731a864a9598848a50fb7941256180480f5201a1fd638df91bdb3a9412d0144b4a53a00239fc7e2f32ce5f53161da2c42d29ca90e19d55a8a8029a0731cd2e54c520b060905449a06ea75317e35ab644dee91c5f6e78bd4c941a7c4df4f28e3146907c64fcea528d5cff008854c653964eca8c69511378ebfbb4af86e1943c7257352af25a9c7cff00fd472063acec4a4cc44f94c4a4328b39604104f4b085156e86dd1453318012007f5812f159a8cd51af58671380014a0490c4c02661426ae6e3ea2246378c3c9bd7ef156a4c5a4d4660c7781ab0019dcfca10c1a07f4ffdbf94165ad90fd04440fe9ffb7f28cb4bff006c302289e491c847efca358c9598a5ae691218d1b1f941a539e634d86c20031090000212c4c9caae86d0c27109726bb0f2fd7ed07290b4d3d3ce0023841ca3d7f3812f127f01fdfa431295cbeff9c2f2f160b02e1e1012c5b00157ca7f488e1e7e67a37ac4f1524a8534af9c030d723a4300ebc531cad61bc165304beee4fad62582e093b10a52a58e54b051da9b0a98dcd97949967e1a1eb000b27195b6bbc1a700a493ea2032f0a2ee6273961296e8c04002a0feb04e1ab759d8fe5fe61549fbc3bc2d352761f5800ebbb200f78c15f110c598bb1a1d0d6c63d124e169994efa24dd2de57d34d63c7f84f10ee96561db3311ec3eaf1ea7c1b15decb243d18ac062de44508d77bc6b07a224b630ceaca9293f8c020b071702b7d37814b96a0a4ad29212cabea5f6ab0f4bb45bac80a0953660281e9f4ac0314f95d243a09291f334d4308b5264b8a0183c2256a2b1cabd8ebbd3578517c47bb1365a6a4967d001d3a43552732545076d3cc1d2273a42949928524109056bebe645de83ac527bd92d6b44b058293325a54b20298056656524eede4d58c8162b89a731a155aa90e2c1aa0dd9a3215487712e38fcf4a65f338cd74835cc07296d85bda2a2563880ea9bddd920063953f8955ffab3f9400e2254c49ce7fa952544d5f403cacc778b2e1b834f76852941d35c890092a3bddd4c05b684928ad956dbd155393deaca5130143d6604900b8b90486f2f685b8ba4a244d54b9c93c851a82c431bda958b8c6ae611301414ca0a14989cac77ca0073ade13e398396890a39402410ea154d2bd05e82072d6c12d9e133ae7ce0613789e28f316de22052302c147a5ff05bba3331085bf78a12ca19fc23385f4003872778f35488e9fb0b8b548c4c99c835ef0cb3d42905fefed0d7c0169fc45e04a933d53907916ca606ced4fce91c399a4dc98f46fe2363bfa692b582b5964a3509175333252ec3725f631e6e13585254e813b1ac34d3524fb989ce7dcb33de0186455b58beecff000e1327cb42c664b852d8d80b8fdef13eca212bb3b3952d25340524d6d7b7b184e77089e9405104a48f953daa408f6e952c620a92000914252c0253a8a9e67d0982712c02244b48ca14a2f9b28d9dab6156a01a46b87af6465ecf00561560550a1e907c3e0e74c072226286b431ed387c1f7c42664a00066d0873a1773bebada1b9f86521932900a4dd44f28f537556f5348586e832d59e133701353796b1fed3071c3e784e6eed6127521847b9cd95296ccced5268096b04dd8dfca2b38acb7741f1366729600683cbac0a03c8f1398b20904910b6b161da1613d613614fbfce2be49198798bc450c6933941aa5a232cdd8c76dc63b0c50542b4018ee5e81b551b6d4a47278fe173248750a39ae858fde0a0b0fc078fcec22ca92ca42bc48558ec46c7ac5a76a952264b4622429fbc3cc3e24a80aa48d2e1b76f58e52f16bc07814cc4a9684282590a512ab728700ece433c3b115a99ca6f11f78d2cbc432b5e369158403125348b2427bb97fdc7eba08424a882e21bc4c9599616a17723c9d9fd48806405191ea7f7ef1eb9d8844c44a3cb450055ba854050ab063a6ef1e43c3e5f30f38f61ecfce50968484ad4027403622e6a08605845453627a2ca47746502b592ee4070e92097d451f4834e96e09354a68175486360c0114dfac467cb0995decc9a9945b305cc52509700909399550a6bee4454ceed949eeffa014b9a4d44a429696a6be00e75768d6fa206f068ccb54b52ca6e5d601059fe2d9e9b521dc04b54c56705331295653a51a9a1f3f68e7b8be267cd4a089322529403a97333ac7fb2550791541470c9b2d05189c4cf527e14c952654bcc7aa3fa8aff0096cf14f6b425a63f3d6896a2852988a119949f96611a88e1f87e102464c1c92352521649d5d6be651dc98dc2b7fe63a41381e1e4cd2a130107ff008dd45935722e2fd63a5c049449cd40068033bfa7d4c717839465cd4a54ca2097482da51c96678bfc1f113341a1714616603f11b93d041e58bfa0835f6358c521454a98a42cbb2258e63ae9a455f6830e9992660422633b9484d1f29157a281201d488370ee16996b131458dc268c9770d5aa881aef0d713c42fbb202ca81a720e67d19edd4c64e96916afd9f37e252cb3e6606ed161c6a5659f301041ce4b1b87ad7ad62bd77f4890200d23befe1c4c489b2258467509eb9d969644964df47593fed8e09023a7ec9cfeeb132663900282559490a650670da835800b4fe31ca9a71899b3121295cb094805c0cafb68733fa98e1655e3d5bf8892654cc26651216953cb2454d40215e61c8f2f38f29942b0e4a813b0f25f33eaf1e93d84e18beea64d040ef0e4b1a81521da809d3a479fe0e4e65240b95048d6a48029ad4c7b2cde1c652132e49c92d3f88d4b368ceeef40f078d5b093d0c611294041b9a97a3022ec753a38f2a44a4254b98264c2e935cce4061a55c97b7a182e156132d95524172bbaba049f08167bc2e8c4a812268ce18310180059800198eb6fac6b6f6674312b192c29d2c2a58b56e45134dd9cb375806314b59742dab704b9f257bd985e13c2abfae14a5e650341603cf4b6822cc25ca80b8ad01f2f13359e8207fab05b46e5af965a4302012c366a16d1c549302c561f392870144543f4a127a36f1a95384a0e2a5cb10de4ec6e5f56785e5933d45d4425892581248f3d5cc2f91fc1e33da697971534385735d36eb15044753dbec3a65e295900cac038d4b731f78e72420f880f0b13d2b4f9c6459ef13f1893282a6108601d46adebe558f24ed4719134f77247f4924d59b31dfca13c462e64ee69cb33350e69ec2911952dc802aa24009d49340075786e5e9050be1b0ea52825209528b0003924d047a4603b3b370d819c5d2272d24905b912c69567353efac39d8fe0630d98e5cd340e7983c2973e104db6715317dc366f7e562a9526a1ebcb42ce79ae22942b6c972e8f1199c2e60922694d1d9b56bbb6dd60785c3a8b518137341ee6968ed7f8953972e64bca1025cc4a8b644f3174b9a8a91463fabf2d83c4ad6194b51ca3941a87161e54887a29029e860e08234e9e7ec4c7a22787e7c34947f2b397965213989948146dd454c4be91ca766e7ae64e44a12e5b2c84e5ca4d039342a2e59cc7a970c044b331693950d401981a026ec22bc6b91499c6e0bb23342abdd4ba83f14cd8b5328a6b48ea64f093554cc4cf290ce99644a4ab703bb19da9f8bda2fa64bef02f2312862ce4100dc1a5eaedf688230e4254412a09e55114a9b10ec4b0e914a85b1491c1a54b202644a54c61fd49a8331697d42a612a63b866261cc5e125218add4e189e6ad28396c09d0ed09499cf30673975039486d0b1adb5f9c5a6070e9e7993179d36009aa3577b8aeafeb0ff90e4e515857584a092edf090def16fc3652cabb998e45d59d2ed414773f3686b018a4ab32ca52e0b02f5235cc6c7f7e713c0ad59ce653039bc41218d19d4090a156b51fac6929b64462915b8be1b2f31cb3586cff00ba4643b330f21395825d9d56a1734ab122d190d49d722715d1cc4bc4105c1fd7ce2c0f6826b32728dc815314e55a46cd237708be5192935c0f238a4d49242af7fd983fff00d14c08c8c01fc41f37bc53e68d427e38bf40a725ece078f7fef2c977249fa6b152d1d2769f09ce5435fdfda28132ef1c538d4a8e98bb40917f58bee1d3d299a4b3e55a1400d82abd6c44532a5978b9e1a009a1f70fff002047c8428ad8db3b5ed3264e224ad4e4ac25e5d2809360058656af531e5ebe55111e8d864b4a4bd825cf40cff48e03884c0b9ca504e504d07cbdcdfd634f2c52a6478e4d969c065a0e224e7a242c1237636e85da3d50f15955009adc90e5b6778f1b4cc6a8ebf38ecb81f11efe5e66e6059406fbf91fbc2f0a4f4c7e46d6d1da1e2928a72e6501f0d2c4ddf4236a40158a4296962c96625bae8faef0849e133d41d32c9daa9ae8d7bf48d1e17382820cb5026c29b3d2ad6eb1b6305eccf29747425720174b123e2239adf21e502c2f10033254b74939937a0d9af148385ce7632c8f36fbeb19fe9b380cd91400d5d3a50eb11847b1e52e8bac6e11d6939b90d55560000eced416178626cd48484a0b83602c776034bdb6bc51e1b87cf9a39554ea5b6814fc1e265b3858cb6636f26275858ae2cacbe0e47f8a8129c4a65a4074a5cb75dfab825ce8db40fb23c2ccd921090eb9ab3a3d100b9206818faa80d629fb4b35733133153092b76ade916fd8ee32ac195328244c480a716ab83d18feb187b340533806267ce534a2332d9448c884a8bba47931a0768ecb82f63e461d59bc7343b15586940e00f32e6b019f8f9ceca25c17a804d58b8277a1a5e1f93c5312a43e50b0e466c8f5b9a81eb58d578dad919a2c70387084cc4a92a466520062edcccfeaa661d21ec2a009e3bbf812d309aa988f6a5348a497367ac169409558e520922c5deadd6353b1f31198291914b0c482ca686e2d826902fe24704562a525721226192728cb72ea01409d4ebefbc795776b94594929506394820f4a1b47b6707c04c79665a5612dcca4aa950e1dd237076f787b11c270f97ff5694ad416e82a4a484b7883b0e5e9ec2326bd168f3efe1c604ca0bc6cc0e0854b9440765160a5b6c3c20f5547a04a9689b256a48698ae5587a921aeee03b5fac5814a080b929010036a103c835342184280e65f7a9049d400c1eb98b900e57172f7e9571d09a2aa5e6922594300b70b0b672af76cad634208317b2f882568043a80f8f4b6afb16d7de2bf19c2d2bca9243a9598d814bfc39882081b7de2978acbc8a28131db466cbe96b6d1aa4a6436e25a70e599b37bb4e55dc8cc1c8672c0b06d5ada5a2ef1b284a402ec16006a0be97de39cec5c879e194029dcdea05581ead179c4e6a578c09243201500ed5d3eec2b0a7fd50e3fc8d1c3044b2800002b770ab877d638bc6cb20d4ea68e4ed627d3ac5d60788a9735292521493751ca124dd3a17f3711768952d454f966104d40f0034650b59df43d21c64fc6f6271cd68e0c4c50d7e7191d2e27b2b314a7925390d9c9fb7afac646df921d99e1239c18124d572c752b0d11561c3b7788f3ab7c8562ca570a9443952d21d8be50dea44695c2d293943ac914b86a9ff943fc8bb0c195f3b06909cc26cb51d81afb11f485323fc4045ecee132f2ea14d6705b72453f2863038794a0bef65a03332aa035a8906ee2f0bf2a487f8d9c6711c085b545efedd358a4ff004860697bfbfd9bde3d3b0f26467cb2e5f78a3a252ed7b1f87fc46b19c3914070c84667e6530b5fc2ededb46729c5be0a506972793f12e1a52a4a75553dc803e4ff003879581523d5491ec49fce3bac6765f34e4ab2a5c282d412976480c5b35cdd86e5e2ce7705929c8858e635fc4c6e9166adbce33ca2563239cc1f175cb0cc85500e6483f68e1bb5b2899ca9a12067a96767f5b47b6f0fe1e84b8992a50a55394115aea28771a454f6bf85618e1a6e5952c320b2824383a57776899f922fd0d424bd9e1f243eb1e83d8dc38c3cbef552d3304eb025db2bb9b30bb7a471c787e5adf7bfef4bf947a0f61f128523f969a0100954b72ec4f880f5afbc4c5d329ab45be17b469402f2c9512082e9012cd600082cbed500920cb39abcd983d7d3f6d04c6f0a924b21047516bfce2b6570324d54c029988e62cc4fa46b7e37e88a9a1d9dda64d42104023567e90acee3e9578a59ff0097e91d14fe11862803287dc5fca914ebe092667fede61e6684fd69094a1d03531197da0292e847b97fca94882fb50a05c4b142e3995fb3fa43f3384ca48729342c4053122b50fa46e4f0392a0cc5ea1df5f9336d0dbf1f42a9f6790f139ca993e628a7994a7000eb0ff0ee0ea5ba9414529f100092c5802c2b435a6c23d1784700085a67776955432e8e90e6a011b0263b7cb2864ce1190bd54059b6ea4563192a7a358fc94586e1b2bf9696a99288294e40950650624e5dc86b5ec62b70d8a9ca58eed059440a0ab25a8e6828ce4c5e76ca684250004f46052c199a8cfbfa47292a6cc58ca976483416d9d9c3d4de34f1c7f5b6449ececf03c392016500b480e01cd95f7d3d585a238d912923389466adae00b8d737c3a53e8d0b7f2042428004380115083d426c493bb88d28ab2046666018353a8666f41ed10516335788cb532d2328f0f3583ecdd1bd9e2817c465cc56508751675ab99572f942ac08a3b6b17495a8cbcbe19809009703721c575f7f280f12c0a4ceccb012132d2ebaf89c33017552feb5b438b40c0e370535402a5a8072e52ad4f42cc2d4f286b887104c9923bc0f3882402e6b500eede6637849c9e69c1fbb0e92ce4acffe27c55d6948a1c7abf9b9a141d19836620b2949606aed66b35edac38abe7844c9d7017033bbe4a95328841725810fa0094b114d6be70dcf98854949c4210a5143cb2394b3d9cd585a3581e1e70f98b962ceaa3b1d8e808fa432a965241002d195925850a6a92402e7d99eb0ed5e82b5b11c270f9485cb9dde2a53733119b771b87b5a27c11426cf9eb97729578e89e62da547ef687317c41594a93282dd194870026952c439f58e7384e32680a972c279cd5cb1d98311a1b45a4da6c96d2690f6278765cb3331ce2a42c51f4622fa515a45be0b13250a4296a49e5a0195c039894b24d5c92d4b528d115f0e93fcbf2ba6684b1d0939b51e4fcde55a4524bc207949405a945256ab8209346ab1b0a8bbc2d496c3f9e0e9f17c6a528be7229fdbe76cd4bc645361b032d49e792acc28aca32d46e9cb42d1b88a822ae45560f8d25c85c9528135751a36d943881cdc72aaa4a2600799b31347196e1cf8845de37852004824ba8eaa1ea2896f7a44e6e496c0151e56e6cb6a5c65dd99f68b52e9063f25077ca775a16a05e9980147e82cc60f87e292d21952f94b9ae5077bb3d12fac59c990f752dc509700072e34f9c0958279b9d4acc00395c8606cf44d03753bc372be458d1a4768d12920225a8249b85d68c5ad46f9c2133b4e15354a329c382d9837b14973d62d78e6125ce4a11ce1486629ca1356a6eab5e17c1f009085665296b50340199d8106d5afd6216356ca77c1097da0965454a4a8a486292451eb52d5d584453c7259566c8e01e5e6ad180661cba44a7f6770ee4baf317510e00d68d946bd746a41a4f66a5a5450a2a4a887003100117716ff0010b43d8baf8d82bccca63572a1e5a8fdef0a768389ca5ca54a12dc96739f62ed4eb587f0bc152a52810aa03adadd2f489cfecc4bcad994fd08f57a528225a433cba6cc1ae71b8cdadb68361716010c9552a0d1f67f0c76d88ec44b25c289bdfee044f0dd8c4a52680920872aa83b8e521e246329e24b5cb7c843162738274fedb97862402e391448b9cd7637666260bc3b87f7632ad6a29662004b50d28d7a0af9c1e5c9b1ccacc694351576b79986ac466217476ca082a2ca1a37f6bbfeb0256382082a479730a1d7e1a1f941ff00d3d2a2c4a8b3ea3503a6bd3e50bf12c1170962b02dcc1aa6f44dcef0d2f402b8ce262a54925cf28cc1f4adaa7ca13c363d6b0c1040a804961f24ddbf662f6770294659cee55715a00dab07780e2025084cb969524368c7e613b434c4c5c714c8129218d19882d4a532b5348c95c6119bfa485156a4aaa76d1a911c27050acca50586dcb5f5a8b45861386cb008199c03ca19c91b06818214c562d198ae74bcca2c012a14d1adf93c1f09365a09cb2e86b7142d7147f4892384256905692e0b8a8d36a560eae1f2653555ce6a5c100e82ce49af944dbe074697c682fc32d5aeb57f66bb97853beeed27333820e5cce5df4a3bf5b5ef169fe8d2c233052b29666b0701dc1167a00da42f3b069510975281d4b7cb977d5dc408195b3c29737bc585257980033d2e433e56d2a7483f1dc59ef52b58694c01493427992de1625dfde05c402652834d2e0316507ad6842683e71a9d874cf9a9698accc184c50ca962efe17152f51ac69be591f04786cd4875a1072b1194a89a3b6601692031f3f68361b1b2d0128ee5d092542baea5db588e1d0b52882167fb73259dc13f08a6b5f68b19fc112af11212c4bb81e8414b131326ef635421c438a09dfd3009414e66cc3918da892627c3b8882a2b12c849d5e94a59a86f7de09c2782c9924ccccb214c92ed47e8dbef1658bc049480124806ee46be967309bf486bb654e371f2e605009d0f2850add8dbca2b477526485776a54c7af33357cb611618fe10912d452156cc09239aacc080fa1f685b11c3906523be52c972e1241291a966727a37eb71b26546b89718cc84ac729218a81a1e8390b0ac56c9c415273124e60d7af2d8125141e50c9c24b644b9e1400d7325d20d7e1b8aeb0ecac2a01094cb9a5d8a726522b63b076d62b69689d365cf0ce34ac2a3ba089730024e6ef18d742088c8ab988960f34ca9af305023a72863e7bbc646785ee8bc877098b0b4a08195092aca9dbf634d229264c3394b72d53a072cfed4d23232378aa6c893b489c95bba8a94ea709d800cd47bb431252a521ca992e5c0ab97b926323209e822170d30e5ca961473a7cea636662410900934772c3a8a5c51c18c8c887c965889614ca35200af955fce26b24a9cec2351919141125a9ea609364301d6323210c5e6960e34d234679290232321d0814c1ac4f0d864aaa5c7937e71b8c83d012c7325b26dafb46b03843cb309a86eafb5ed7d235190df02f64388e2d454acccccd4e8df684b86cd495e620d0398c8c8aa58937b3a3c461ffa4ee7f10aecc6bbc56cd5b4c965419d4957252a433b368deb19191944b658a38a2119cad24ea180a7b98e538e4c5098e4f22d44802e03ed68c8c8d7c6a991e4e0b854ccb365ca19ac1409502f7a1a43d2a582144518b59c0b970e7f6d191911229149fe8a8973d0a987bc4a8662929166a8a355ec621c4e4f7531536a4a9777367219bca3719151936d592d24b46e763d403a4809072b3554c03397a5f48771b895995a778ec6f97d3da32321b4b409f20d1382a677612c50c16acceef5532486352f5866792a0b55168b94adc2980394050d2351912f5ff06b817e2535430e9580398abe257294d5c1bfa42f83e1cc5533312b094a812a550e609517abbbea232321dd44556c3f18c02159412acd44383462e59b60df48370795dca4a52a70524d85dae6fa696b46e320b7543a576130bc6121394cbcedaa8b1ad6c0758c8c8c81c55826cfffd9	Черный	1	Тибесткий
10	2	Арнольд	2020-05-12	1 333,00 ?	Экстравагантен	\\xffd8ffe000104a46494600010101000000000000ffdb00430009060712121015121211101010121210121610120f100f10120f1512161716151616181c2820181a251e151321312125292b2e2e2e171f3338332d37282d2e2bffdb0043010a0a0a0e0d0e1b10101b2b252026372d2d32352d372d2d2d2b2d2e2d2d2f2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2b2d2d2d2d2d2d2d2d2d2d2dffc000110800b7011303012200021101031101ffc4001b00010002030101000000000000000000000005060103040702ffc40033100002010302040306060301010000000000010203041121310512415106718113226191b1f0073252a1c1d114e1f12423ffc400190101000301010000000000000000000000000203040105ffc4002411010002020202020300030000000000000001020311122104311341235161141522ffda000c03010002110311003f00f710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011dc5f8e50b64bdb4f973b249ca58ef844251fc42b294d439a6b3a2938e239f9901f8a1692957a528f5a6d3f352ff679fdc592a7252ab2e75a3e54ba945f24c4cafc78e2d0f7fa7c4e8c926aa470fe27dff9d0ce3991e394b88a54d6258db1db076db71ba92588e8963de7f3c2317fb19e5c661abfc18d6f6f539f14a4b79c7e67dd2bfa72da717ea7925dd6aade75e9f2c6727046eeaa7a49c5b4d6537af917c799fc553e2ff5eccb8a52fd715ae357bbf8113c5bc676d434ccaa4ff4c165faf63cd28df4e725197345acefd4df71698a6eac1be7596d3da4518fcfb5e6635ad2f9f06b11bded648fe27a72c7f8b34bf539afe1168e05e27a374f9639854c67925d7c99e53c1aa42a36d2e55b61eb1cf5d3a176f0a70b4ee2357f465efa65ac7f26ba64b4cb2e4c75ac2f60034b3000000000000000000000000000000000000000000186c0c4e492cb2b3c57c4dcadc69acb5d7a1f1e24e2cf58c1e8b7f8943bce21f1ea63cfe471eaad58706fbb256eee255f3cef32d5c5ff0005078ddccaa568d38747879e8fe24cdbf1094aaa8ebe9d4eebfb1a7ed3daa4b9dad5f7c7f264b65988dcb5d71c4cf48ea7669462a4d766be8586ce8c1474c634e9d114abfe2bcd731a31c393714d6beee7be36782d74b2b1f7f7b18fc8fc55ddbdcb56198c93315fa6d94dcf2968b197e6fa1f76f6b8c670df7c77ce707cc534db7a2fbff666af12841673b74785f3ec64a65b5e750d338eb58dcbeebf0f4f1a61adb07356b3a8d72e7dd6f55afa3246caf63516534fcb54fd492a74932fad662db426626af34a55a74aefd9c72f9fdde58a5873ce133ddbc3bc3fd8d08a97e76b9a5e6fa7a150e1dc1a946e95c496671fcab1a7997db5aea6b28f6bc4d4f73ede3f95bf5f4dc0036b10000000000000000000000000000000000000000071f14abcb4de37676115c427ccdaec46de9dafb79e71db89464f1f5c15ea36352b4b48b587abe85b38cd8fb4a8a39587be73b1316563184124b448f36293b97a5368d42a14786aa6b2ff0036ab6c7db38f8bd4c47973bf5faaf32d1c5e9a59d563e2b42b37160ea494755193d5a794bc9f431ded3cb52d75ac71dc227c1be1cffeb3b89fbd3a927cadfe86f77f12ff004b8669d3cc8fe1b69cad4219f3f8677fbee4c56ace2fb0bcc6599b5dda5671c4568e5bce1d84796fe253945c127883965c73bf678ce658c3e9f547afaadccb976d37ecbab2b3c7b8052b96a338e8b3896cff00b3b8698f0e68c91e9ccdcf2e29a7dab1f87b731f692a51949c3d9f3f338722e78cb0f963d32b0f07a2d8d64fcf65e45778078529dab738ca4e724e3993e6c47b22c1423f7825e45eb6c9caae78f8ed5c7c6ceb955c3f324fc3970dd571cf4ce3240d783df38f818f0d5cff00eb8eade72b565be35a7e4855e4d7f1cbd14007b0f1c000000000000000000000000000000000000000189bd0abc6ef9ab4d3ff00458eea588b7f03cf6fabd48d6535b737ed933e7c9c261a30e3e71290af4d7b6f7bd34fe498a2b4d30724e2a715237d3f97a79118acc4ccbb368d4435dfdb2945a6b5f5216cb856936961e57a9636f4ff00a6b8633b6fa7a90bf8f5b5b72b699ed5aea1036b6ce2de37eabb6763eef2d9a5af55b763baf6d5f339477c7cfb1ae369aeb97cd8d5b7278f36fcc8dbc78e3c5b31f931ee65c56506f6d7e2735f43dffccdcbaacebf265a6d2d541688d37bc394b57af9ace0cf7f12dc35f6e47974f937f4aec1f4d7efd0ebb5a7eadbc6d9fa60e88f076b6cf96afbfa9df6b68a09b96fe982ac5e35f97fd2ccbe4d35d2278a45c63badb6cebf7a9c1e10a12957e66b44f73bb8b27565ca96567d09be0964a9452fdcd38f1ef275e9972e4d53bf6b147632698d4ec6d8bca3d3798c8000000000000000000000000000000000000000e7be5983f22937504de3af7ea5eabc729945e2cf926fb18fcbea225b3c4ee661bf85d7e47c9292c3fcaba936a055285ca93ce527f444f59df6747f3ee4b0de2610cd498b3bd434c1a6749f6362abd8e5bcaf3c622927ddf445d2ae36c3527eef3633e5939aca8d7a5eee9522b186ff0037cc8953a9ac9bce1e709e34ce8cdebc50a1bc94961efbe8426f5fb5b116f511b5968f3b4f314bd73d0db87d7a10d6be2484e2da4f4cfec68afc69f2e76ce1a5d7559c7df71f257f687c76fd27e6ba9a2b53cac7722297168b5f99eb86b3f1ff00a6d87128e339eb8642d969f729d715f7d424a9504bfbf4335a5847146fb3b197539b057f347aaac8c33eec9fa30d1336e1e5761417babc8d86e861900000000000000000000000000000000000000006248a5f89e87bc5d595bf1143a94e7a72a4c2ec17e3789512b41c3cfaff005f7fc129c32ef388bce719f9ebfd1d70b48bdf566bad678f793c79763060c76af7f4db9ef5b7490baab554334f7e8ba15ae21c56e96572b6b18db56fb964b1b94b11975ee4aab48496c8d56a4dfb89d33d6f14ea61e597dc6aba8c9f2b8be551c63748add4ba9cf2f5d77eccf66bde154de538ac7914ebef0c25557b35eeb79c19af8af5f7db4d6f5b7a6df09dc2f64a325aa4f99f5c9c1c5afb157962db8a597d938bcff08b0d9f0bf6717a61e0ab5cf0a9cabfba9b4a4b3f3d4ee4dc44414d4cccc35d9712cd38c937eee63bf4ce73f37fb93fc22b37159dfe272f0ff0ad4e5c6124ff006cafef1f224ad386548349a7a60c97acc77112d1598f53299a72d3d094e136dcd24fa1af8770eca592c16b45456123d0c1866662d2c39b34444d61bd23201b984000000000000000000000000000000000000000064171c8649b6c8fe234f28e5a370ed6753b57654b11cf514e595837c65ae189d1d74288aeba5f36dceda2b5be64be0775ad669e1ec663138ef6ae1616e76235db93df4939535296bb23eea5b4719c6daa23f87dfed196fdceab8e2118c774fb6bf344b712ec7a7239c5e866970f59cf7e98fa91f675d39e5e7196f62cb692e68e718fa91d6ddace8b6a1dcd92a51ec8f8b8b850d16fd8e27712659a5536eddaae22b4477d079457a7196f8648595c35b8dea4e3b84b839a3768db4eb264b7087196c001d700000000000000000000000000600000003064c018669ad1ca3733e5a02bb7d66d3c9f5435266b52ca386951e597c085aa9d6cc2a7a3640d6b594a6df42c3cfab46c85a2c1ce31294cea55795b7737d1b34c9aabc3727d52e1f83b15466c8ea76491bf9e71584c91ff0010c2b225a736e0a16edea48d0b33a68d0c1b923a8b5c68aec65d05d8da00e67671dcd94e8a46d07350ef2900075c0000000000000000000000000000601900600000c60c803e5c4d55691bcc60082ad9e67f0365adcc97c5324676716f2669d9c57421c676bb9d35a987dd3d564fac1f518e36324d4be706523200006400000000000000000000000000000000000000000000000000000c0000000000000000c800000000000000000000000000000000000fffd9	Пегий	1	Сейшельский
19	10	Кларис	2020-08-12	4 500,00 ?	Подвижна	\\xffd8ffe000104a46494600010101000000000000ffdb0043000906071413121513131315161517171a1a1718171718171718181817171818151817181d28201a1a251b181721312125292b2e2e2e171f3338332d37282d2e2bffdb0043010a0a0a0e0d0e1a10101a2d1d1f252d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2dffc000110800e100e103012200021101031101ffc4001c0000010501010100000000000000000000040002030506010708ffc4004b100001020305050504050a03070501000001021100032104123141510561718191132232a1b106c1d1f014425292e115233353627282a2b2f1347393435463c2c3d2d3074494b3e216ffc400190100030101010000000000000000000000000102030405ffc4002111010101010002030101000300000000000001110212210331415113328191ffda000c03010002110311003f00c076d5a9abf38ef6ac5f0a43e7c9090d9e34722234cb3896318b53ccbbc6f0a0e1e9ba1d294527bb13f6ac7bca2037759a9b9a25b123b4346e74006a3744d5c1bb39945d64ee78b399674b5e49aefa03c358ad9731283752ca2ecf9468765d8014df9872a7c22337d349ebd87b2ab91dd918d04d97da4825aa05794532e58bce9c3307d62ff6482511199557dc602d45482e707a7082e4dafba5cd418bdb7ec80a52d0d42091c6282558084907c405d3cbe7ca359758d988a7da2aa0d51e60c056a4bc13b4e410a429b1174f4fc0c57a5c2c851a456274f367174d1d8f9340d36c69180c60d5817545e8c0797a5615a90d775506e60c30a1b56cc37853ba60156cd216436be62353256e08fb387e30426ca998493466239e507927c1815d988c611410c758dd4fd8a1485102a0d628adfb32edd1a7be2fc9379acead35223894c5a5b6c052496ca16cdd9e555687a587d83d9e5cc0ee0082ed3ec94c4a0a9c16d2343b36c8a0318bdb15286a0c63fe95acf8e3c8264b292c4343636fff00a81b144b226a7031888da5d9acaccb850a14286450a14280142850a00d994bd41cf03489a72593dea1035a180ecaa0a960b0760ed5e1ce0b9809482ff3be316d157245f3534f9a718b7ed8cb4dc40a96ae71552cdc531c5e9c62df674bef8bd898555171b0eca91df563986a0e11773557402598e0807ccc0a6ea495fd548a0c5f410ace82b378f4f86e89ad799fae4d5a94abcae829e51aad9344246ece329b4275d0c4468361dbd2b42482f463117d1fe2cadd29c5f188af48cf6d4963c4302a05b8903de6356a58293193da60a73c1e9b9e2e33b14db454955d7d5b9353a87eb19eb4ca5768011567e3913d2b06ceb4905408cc13ad1cfc473802d87bc1493460f8d1dc01e51a465560500a5003e2d31f71292dbb0864f652145ea850506cc67e7115fbc58776f25d99ea5811d408916820af0ef2563c92a4f9980694db1f66b23514de922f0f222239330a6625cd1c0dd507187597c528e25dbae5d0889a759eeaab5a803f8bfbc06b2b2a59d49af9d306eb035b6ce14a71ab910a54c21d58034e6f4105c850be41700b752611abadf620a7047880c226d9fb36e8ba0078926a5941bafa88b2953028eff9a44d3882cb676063b2c55a2c2cf2e84691d167c358ceb59027b4b61ed2c6a7a901c728f195e263e81b5596f59d69d527d23c16df2aead49d0c6ff15f4e7f967b0f0a391d8d591428e4740840a144bd86f1d614016fb0edac0a35c2917967b4d2ee20ea1bce3172965242862234d61b45f485271cc5318cfa8d38bf87dbacc711941162b58be851d6b1612917d383f4f58abb6d84a70d621a46bed1301294834f76516d240480d188b0da6b5e1ca91a6d9b6d071ae5f8c4feb69f48fda758a0d7e5a283666d25ca553a647e062fb6b49bc493861f88df197b482953103a8623582cd1af40d97b684c960e191dc62bf6fdbbbc5bec7ba283665b422f07c5a87e6bc623da16bbce0e2079662093f13d598af9b34901f360f9863126cf65a0a49621db2205ea742c79c04825b2219c8d41c47918912149240350c0efc003cc31eb1b473d4eb2ec9adea8d1981201e707daaf04a8d09012461835d23fa62b5017e204850cce4a19bc1a999dd2f81040fe20141f8284023ae2edd03bc161408c2e901871768327a9d45d83292a1c0b3f431569986f105dc36590069c9c41ddbdeba6e877524efbddecf7fac211612922e95020b2d357d5dbcc4221cbe643eed3d5e23d9e1dd3969add2483d09e86245005d6ec0123ce94d6a7a1858b4b6c53b90d5a69506bee88d984a50388af204c4f2bbc1492cef787026e91e49eb02aa694c924e49c7f85ab001fb26dc1cdec87ba2f2caca668c7a5575777755f798bbd97b44099c1875c233b1a735abb54bbb28f08f9e76fd274c19de2fd63e85da96806493ba3e76db3fa65fef18d3e263f281850a146cc9d890f746f3e4214a0dde3961bcc464c204f1c8ec287e81f13d8ed265a9c731ac29925a226890daeccb6829053deccd6b07dad095a5c3f0ce30165b4aa5974968d26cedb9f6a877465d73637e7a947c9b217ce2e366485063f3c207d976a4cc5001be31a8ec0303808cdbf27596682953a5d86e8c9ed032d6a291e21824867ddc748d0aad0405103ba29c6321b4e785ab022b955b7ee8d27d27a981d0b1e1388c0e9a43664caa558e4de5d2239e9be2f8a105954cfed01a1d323b9a12451886f57c8c3c65a6a0005fca954e9c71113101e85c8a02ff55fbaa3bc611c3268d9fce111dd2e0e62290202da840208008cf7f3c6279486a3b8df97cfbe057ad707a8cb7379c3f06d74800e5b2fbde120b17c58d0f315e2043022f25c3528faddc08df5e90c95a9a86a8d77710d12061de4eb40703c47ba1188956962e477b10da005fd0f5835245dc1fbaa53e46841a8dd5e262a644d3781386f34ae35e3065955dc293567e2436b8b37ba00364ce2085e8a6a9c95708e38188ad04042d05d8a29a5083d287ac36c0b1754920d2a1ce494b0e6e1e2c67ac28053ba6e8c866ec37d41f284602d0d7965bae556f743c20a6a0e201de238994c4a4024952904be57af260977041183b1cd9e9c050758562a09b55b95d83035668f24dac937c9389358f5a952c10c438001e1801183f6b2c17147f6946ef003f087f1fa4fc9ed945868484124018987da0778fce512c81752579f853c4e2790f746ac51da155ba304d389ccc4403c3a5a09821c26008be8ead21477e94add0a0f616b38dec40f8c05324d690695447306e89560132f944b2a560d12b3c1166975c0bee83448b1d952949295076bc23d42d29fcc38d23cfb665dc1548d96cadb0908b8b67033cc465d3a38b86d8e5ad52ae060097255192dbd2ee92294cc57d708dadab6eca4a582802d4ee9f7461f695b8cc5e09a6152f0c5a0ec6aade6068c460e3845a4c90920624102981a5221b24a615240c58d46f20c16522a1c614cfa37a453309684060ce1b5c7e5e049a18e1e54307cf06ed726f3f74013d45f7fcb4047a7c39eee1a4751329511c497c98e7a65e5f18996963833e045473860c4aa9430a55a405024387048720280c52e3c34a43264b6cc2778bc48e421b66482f551cbc237d7c5f2f01254cc05c02cfbdfe444b25650c7120b8e47bc3cc1862640c8357c3865c786420e4492181ef25585eaf7878786175f7c2329168752925d9432a38351d3bc3908b03303109392929634202afa7d708abb6594a4b8496229ad6ac7818724b5de212d9034aefc600bf2c04a5162e5d4da90c935c194dd206b2298b2ab802fab65d5e229cb6ecee12685ea1982d24071af7ba476d46f1533fe902b8024a5a9bee753062b47cb4f78b962c295ae39728aedbf62ed909219c3e5abc588722845039d68080af9d62402a06e4de7c69788f23e713f46f1db64a37cd2a54479ff006892d52cb896304063fbc6aaf8728d4ed9d95717da80e94a6f643be48090dd3a4666da0a7b9f58d54779ab46d2eb0b303a94ddd4f331117386021ea6037fce3112d64fcd20226df0a390a00b9bcd58784bf869cfd214d4102829967e70c460467e912a4884a33c79c4f2d4805c120f3805a25417c711c6161cab29731230aeeaf587cdb4a55896ead009502331e7e61a2340e9be162b47050767277e3e7a44d2d08a310e38b1f380ece402e520eaeec77630425248ee964a8bb51dc51f0df016ad2420a80008e03a38ded12cb96c311b9ff11f2d154953350bb54fbc690626790717f3fc6034eb040af23ee8ae9891e784581b5a142e9a7280ed76658ae23754f4300468240c989dd43a3c11679a3eb0e991e8cd034977ba5ab99a0240d0fa6b0476a180507dc59c0e3a43244a90ee6f1481917f713159b4f6add2c8c9eac03be2ede9167b52d425ca748047c6297675804fed145494dd0193f5944e49187a08721757001da531def458d876f4c41017507df83c544b90a5901092a270090493c008b0f67363ccb65a65d9e59485cc2402a2c964a4a8f1ee83418c3c4ed6d6c56f131043d5bef0189e8623987bc0d4d52a6de08040e51522cbf4798ab3951132515256e684b91dccca48ba6b993062d6f5dcc327722b4d0105a27317ba23e907c64bb80ec180290955469807fda8b744a7ee60c039c49099858e9927ac56d9252557d3500a5d24d588010dccdde422eecb3029ef774a0149d4baa500473ab64ed0a9c4d2077d48150433e06e8749c37c0f653f9b24b3a68dbdbf01d60e90b24ab42160a730e429bc8c052c3be947e6529f7c2aa2da761ed121218b14e3984e3e71e6fb66cbd9a94a562b25b70a1278d40e71eb16437aa59eac37e94df18bf6bf66b80a24d0246a4938f9b7087cd2ee6c60160bd61904db50ca6de4f2720790f381a356250a142802f4ab8c46a39c3ccb88f08cd66a844c95eba6758844d3ac3d1de3523998027700d043e9f8438292055f76879e4639ddcbce87988464f56009270a3187ac558b0229cf43081074e11d0cd8e1963cfe758612a55429a96d3d086879b429fbcfa574d377e310c9964e05e94f9388dd044c96bba1c01881dd20d1b12c0115d4f2801aa53966ae83e11d937abde3ddc1e8db8e7f0f28e2e4862edb99b1e64188e4aeac439c9b2c32802652ef9babef1635a0552b950e79424c8cd26f0188fac394366cafb4935240add34c988ca192dd2ac48cc12fcea016800dda7602b94d9e2331d4678d233cab54c9485497294ab1040ae78e3d235365b525618d4b6aca1baa05ed5f4896d36349004c0087c48174fc3d37c128b3586d9b6a9b2a6099254b44c0f754824283820b115c098b3f667689b3dae45a4023b29a952a98a5d96dbee9545aaf61c8ef1048714ad0139817be23740ead89201acf5f061c843d4f8d56ed0da6a9d6b5da5492f366a957462c4e006ac43708bdb31be3b8e012024ee2680f2e39404765a54b7490da101a8347c6bd62e6c52d2052e8abf7404a4125fc218258e43482d573cd4e99c47755887a0c03e046a1ebce2d90416ab121cab10540120d799e515169c6f5083fd219f9b9f310459e6926e86c416d525e9eee662543ecd6824abbd9bd3102e3b7de05f8458a11df55d2183a48e2e52dd7d22a12a215dda05248e614416cc50983acaa203820104387a100b92467ddba211c11650c92720bea9041a743e510ed5b11992d61297524122b40a0411c813869129717121cba8be5e12febef8250b37c8c88209de439e340211bc736f59dad135232504a70c0326b15ab4b638c6dbdb2d99d9ae74fa558b68a55c4063baeabe4c619a3597630b32bb7f70850d850f097eb979c425262ee74bb18faf685f04a123f9a2054eb38a2654d3c5691e8233d698a932f4f48e291074d9d2ff52471987e10c253fab67fda30f4605037b75825237bf284421ff447ef471d2585c239bfba104816f47c033337f78eb0cc1a6831f386dc00bd61ea96f5048d73eba40699123ba5598c19f0cea1c0e7093de60c13a3835c4f086994cc6f26bc3d453ac752549a3d1b03831d377c2191a12031c0be5eed3ce0b98850a85de2717b8ac462f78b9c2b4816b52d419412898e3baf85416f50ca238c00c32d40b7746ec86e0fcda1c970480a502dbc79c449b4396290adc09f2c7ca1c8b506ba0948deaa6f04d03400489203172e463ee2e18fe1c20b45016002b30a577158647d0eb8c542ad45d89c3518e6d8d33c23b2e7025b1d32de43bd3a180d68b9468c90284dd0311fb24658c03326de26bd00e95ca3885173e266382dc63c407e3587cb9a14a179d2bc8902eabf7b2bdbf3ce11a6960b8662e3ecb618b37c62ca52024efea963c4c554a58722a939a68188dcaf4830ce1737834e3c0e1c30df8c23892f00a292e0b9a1c9b7c4d653e1183bdd23ae39540f931597dce0c776230c35d5a0eb2305114d70ea0730fc38c30311301285362e59f52c4f22f06c85770939b79547fca204903114c0119558bfbe09969bae40a33807027003c842359caef1bd4e3ab0229cc9f289a74b6619a8d393027853d220d988005d7aa41df524415290a52dc6747e05df9d0c20acf6d6c17ecb3024f858f427a620f28f1e9f28a0007135e580eac79347bd7657d2b0a02a9c0d412524d4678f9478a7b4920a67ac62ca6c34c7ce34e2b3f922a614758ef8516cd7aa875d6d238a8e266464d1c2baea3a47544e83df0e6ca1aa76801b79b5061e859fef1105111325634801c9ce82babd38561f2b7c3525b322089122f9a63c40f580cc36719961ccbf039c2425a9e21b87bc8893b2ba68092fcbe11c33c9c5f80a0e74f7c012a242ce80621cfcbc3d320ea87c88531f2e59444929aba6b91c40e4def8467230a0618806a78dd780d2fd0d44b877d5c1f818866d996314938b1c39bfc614a9aac01e4702fac4c662922931b739fed01032b2d54b8c1c0c0ee2cd08254f448393f52ccaf09c72ae5072ad855e30857117792540bbf18894896a2595d92b45553c8a438e9004332d0f4623452f1c1887f7446ed5072ad40f4ca269d6398800a9ae1fac901696d41c3938e511cb9cde1200de19cea1c96d71ca190ab3da42fbaa67faa4e3c2f0ca1d2d78a4b83857e300ce05c82195a538e222793368c6a400c7315f3108f53a12e5ce29f711e5845848510524d47e0e0ff2c0b2c51c06cc56875ddfde2e2cc905378352ea803a3871c68a1095075890f8862007dff2fe704cd91de092ccee41fd9c06ea91d0c3acd6772c4e9a6bfda19354ea52ce1e1072648af372ae909452d401bbad091470313ebd445c588e6cc00a80f81232193451d98852af3d05071189e1970022cec4a0428b07207f62610c1f2a514b7d676e18b3b47967b756159b6f668045eef69e272493b847aad95544b9a819d0d0e358c87fea4a0a577909ef4c0137b41892e34a36f23ec88ae6fb4f73d31bf91e47fbc9f2ff00ba1401f92e57eb51d7f18e469ffacb45bc71c6387be2632c0c2b0cb9f808859a85be7d00876547e9084803e31d07a7ac078866186056e8b0b35826cdfd14a5119a80a0fde5603998351b2e5cb17a6cf96fa4bfce9e577ba4ff001083462b25496ef1a0e31276afb80825769b3bd1136653ebad281f71009fe78b0b3c99e52e8b2ca969fb4b961bef5a4a87489d548a5130fc96f28925a1f072fa57ca34027ce00036cb3a00fd5aabd2425ba433e9873da534fee89e7fa88834f150242c55285be65a9e90912143c4081c0790222d85ad39db6d6ae083ea6744f2368209a5aadfe491ff00dd06d1e314b67b3a96580ea934e84019eb045c97287791da11c9235ae27845f2f6da48005aed2060eb949980e5fadf740fdb4b27fc459d7ba658eef554b944f9c1a2f2a29fb554e423b348c82523fe673012ed64d54cae43ce91a516296b248976059ff876854a35fd99eaba0ff0c4737d9770e25db10f8dd12ed32db4bf28a69cb287a9b2a8ac76e527c2dc0121fd52453383a6095340bddc5103bc921b0a0525c80dca2156c9014c89b294a1f5544cb5bfeece007426193ec13507bc850dec58f3c0f587e8bd993f66ad3810b4e4a4fc328e264107dff2d04c84a8067d3289e6a4b52ba8cf97e3d6168c7245948199074c8d70dd04d8a794f2ef0f2be93eb112263a3baae293450a62da415629c1658f881a16d2054122de6f024b0bc683d3ac5a94854b2478886cb139f2a9eb1476a90532f0f09237e4479181f67db55780bd4cfcc679e10be9516f2d9d287600d780f89a758393371bb8e4065bf9c54a9616e406a7a53d5fef45859d2c9620390f5f53e9b9a26ab16921cb28a9cb877f480fdaf4f6d2160065270cc80e2f103501e209969525920918601ba6607488e4aca9fc4c4115f5856e0f1d79b7e4c95f627f497ff7428dcfe4f4fecf9fc6145ffb32ff0026489ac4966b2ae616960a8e6c1db79d38989ccd952e88499aafb4b74a392125cf323840f6ab7aca6ea95dd182000940e0848091d228860b1213fa59c3f7657e755cd408963ef1e11c1b465a29264a5fed4dfceaf924812c7dd3c61b65d98b29bf308948d5589e08c49e2d13a369cb93fa0940abf5936aae2940a23ce11889966b44fba672c8195f724ff9729356dc0010e559644bf13a8b7fb45840e72e5de99d5a2aed1b5662def2d45f10280f10286064ab706830d7676a047e8e62650ff81203ff00a935417d2009b365acbabe9130eab98907cd2a3e71c976527010f1b3d4d8189d8a929a9b44a1859dcfed4d59fe8bb13cbb7a1bfc349eb3cffd58e4bd9aad214cd9ea760087f9785b1539a993b4127ff6d23a4dff00c9137e534b30b2c8df59c3d26bc089b0101f04ea69d3327844c9b3a4e0952cefeea7a0af98e101f8a41b4249c6c928e5dd993c1f35986f6d6527bd679a9fdcb439fbaa944f9c3664b9a6940344061c0918f3788acbb1672dfb396a511a027cf0e78405654df47b2a8b09b3d1fbf29130754ac1f28e2765252a7976b9414333dac9575296fe6832cdb0969fd24e932c8c419a1647f0ca0a30549d93200bcab4296c7ea4951e40cc29834b12d9fe985efcd1365e212aeced5783e0906fb75a421b4d32891f454cabd9cb2a96ae8a0a4f2ba218ab1d9945cfd24ef29949a7de55212a74947d6b63697e591f74a5a1e9627fca37bc168982b82d207f34bc79a44473ad6a05e65c983807037292ca079c302acc7bd7a724ebd9ca71c6ea930e5a65d1a6295fbd2eefa295084864eb24b9a42a510858faaac0ff00150577dde300da6c4b4926e942833838711a8220a9a9ba69f87a4488b45e4942cd74230e072e10e5181244cbe012aef0a149d07ac433a45091937beb106d09010a3730c77476cd6c2a4904d77d4c3389ac734a47ce4413e622cecb683892c1db076e3014b96480462f4f9e513d8e597dc303c222d6bcf1689b54c38a4778e64d7f082ec09bc28e4f573a39c620b4a4918b0de71833d9ab295a8f79a980c3ce22d3bce23ba743f7bffcc28d47e471ba390fc51b1e452b66acaa983b3fc35f9c208eda5493f9b0264d199a84f3d770ea62cf6c4fee94a7ba9763a9e3bb708cfa2cec498da30a82d93d6b55e5924f90e03011cbae0415d93c1322c74a086522ae5a09cab169b3ec24b5338b7d9fb14a9a99c6cac5b0d2960d844dad24feabb636c7175c8c445aaf63a321f2d17167b2801a26eca27c55e4a095b09203b718906c84b9245701ba2f9688709428f4f9d227c553aacf4dd8a8533807f0f9c205b47b2e16eddd18683f18d52ca4601cefc3a4036eb5a80a1e94e5485873aace2760893508bedf5a6aae23921c5ee27a187a6cc668bb36782324a126ef0082129e7583156fef14339a75304aec6851a16274a4060a5fb3967560951fe203c803eb067e439690c9969eaaf72841f639225e2a2dd4f58b696cd4fc62b222db19256cc555a4ca035229fcc4c076a912d355a91bd32a42147ef2c247ac6de6d96f0f9f531556cd8e915cf77c4c2b2c39d4bf6c44e9b2526b21477ad52d3fcb2e506fbc60746d2402df4693bbbd370ff53dd1a6b55803169691bd5def5a1e915532c0a6fcecc284e41291795a5d4258732c214a76203352b49375093a26f5785e518a8b659420de673a1703a03ef8b298b32cf7650497a198aed267129f0a7eef330399eb9c49230a3e5bb73ee87a580953d2b4f818b373e05e2ac59885070cf1673ecc41a62fd37bc496692a25cb9e70ef473858ec9b1ba6b5f7fce3165b32485952000199b5680ecabecc60f514f2222ff67ecab933b596aee9a149a86dc718cf75d5cc939bbff4895b3122845608d9c94a56c03522de6d9c2c86e30c99b34a015a9800e74a41977d31eafaf6efd293a79428cd7ffd9d8bedabee2e14699dff00187971fd63368177e303224b88b04594a8c5e593650090f17a9f167acd60528e11a3d93b173316961b200e5a2d2480040798e592c60306c22ca5cb88e48829061a5204347180c6239935b481164af36d615a7226b65b0270a7ce3ba0255be848c35e312daac77c30c3d62591b28101e275598a856d2ab64cfc2219b6a2598bb0cab17d69d84951c1a2097b14247769aea617b54b19d052959528be806232a9cbd60955b0b0bb40c70c38d71e7059f65a94c209b2ec6600271c2f1f70f7fa42ca7b10d927aaef7cdd14c6aa5704fbe2dac76c486a54eb53c5b288c7b3eecf97a9c49df062f65b5748a9cd4dea0a95342aafc5e25290748a3b4ce67482cd9e5c4c66b6c7b48b94c8905d448a9c49389030032eb15896cad76118e7f3ac505bec4a6247749388aacebdec4f26110d8bdbb941465cc53dc482b57d504b001f524800718d122df2565af00b76670e1b103e7588bcaa74c6fe4c09aac3b7d5189e2461bf3e115936c8a59a861f540a01b92237d3156751202c1baa092c7eb120371720455a26c85bdd50c9b465164ab862dc226f3553b8cf4ad986ac92e5856bc38189e4ec853355df2c07e11b29166964b5e714e9f3e9074ab1a3dec217853ff49195b0fb3e5588d7e31743654d435c2e0f89c61beba45f8988425cb000398c87b59ed714cbb52653a4ca42ab9a9494de37469f55f5222f9f8633bf3f42adfb524d9d92568ed14a0804e016a4954b4ac8c2f00589605b18c2da36eda17699885164049265a814cc964f856ff5904d2f0620921401aab37b776bf692d36d48bed31765b522b72622f15ca2e3c259c856214cd8341fb3b6c02a79a6f2128bd26790eaecd7793714062028142a5e46f3635d7c7232f3bd5f6cbfe5f9bfef36bff504722dbf266cff00d64aff00e4cdff00c71d8dbcb96397fad849b18060fba4f088cae1fdab34733bac1c86486ce1e8990109b0f54d61e906978accda02454c463685ef0e59c53779470275836486a10dba169f862c65cbbc6a60fb35986022be42ce090fbfe116f64594e30bf4bad916567b28682132008567b4a4e620a098d648c2da18c910cfa3c18111dbb0f0bc832240852ecc34825a1aa980030f0698b48114f6db6072347f20f11edbdac0254c6a0398f36b4fb52553829d807bc1f10c7e30a9c9fd73db2f690cb5dd661ae44efdd19c3b592b96bb47d6f0241fb443a88d5927f9e25f68ed689c8524f892483ca3173a7148b3a72489930ef75a811cd329221c9a5d75655dd8275c992debf9d0b5bfd6982a1f7252267f101ac1db0edc533662d44957e625a493876a897db2f8dc96dfc71944dac85209add4ad47f7949513ff0028e5075aeda5064a86650be464c949e852a8ac67e4d3ecbb7a916ab44a428a4f653d61f299351dbde233292258fe0df129db1726da90ec25cd4040d10932d14d126e8568e5ce26337ececf2572a7124912e6cb5ea4a03a6bbd2b426bf662b769dbc92a271988657201bcd293ca162bcb3dbd4addb75a62a523326aee543e900853fd9b8a596fda8291ed5a8da65d9e5172b0ca388496bd789fde2068c83ac793a6da7bb5379480145ea102ea586f50427cb58d1ec0b494cc00566cc70a3f6124152db4c6ef0e11179c5f3d6b6b336fad76a524a8dcedaf0c876777b396923795de3c0e9189db5b5a6aedd3517a8ab2149070bcab22663f1ed423eec49ed0ed5ecad72a5a3f58852ff74008427cd4ae2d19bda568b96d2a27c09483c53674a1ba868ae67b4757f0bd9c986609b657eece96aba3fe2cbbb350789eceeff198b1b04c1d82eca0ba900ce077b7e725fddef7144516ca9fd8a933b342814f10626b05aae4d54d460165401d1dd8f2a45589955b7e3b1a1fa06cefd64c850fca163d28e50fce1428e6af452887da32e0214282fd09f63ec9e181feb72850a244fb5f6caf08832d71d85073f48ebfe48acde28beb1c2851af0cbe51b1c30a1469189aa812d181850a155479d7b4bfa45f3fe911e5d6ff00173850a143a8b68fe9e6f1f708a5da1fecff00c957f5ce850a2a33e830f12ff8ff00a5513ed2fd1d9ffcaffa9321428a42c7d98f04cfde1e91516ff175f5850a14fb57e26b07e953cbdd1a7f63ff00c5cce27d63b0a27b5fc7f8a9f687fc77fa7fd29807da2ff153ff00cd57ac2851511434df0279fba1f65c0f08ec287f841a14285092ffd9	Серый	2	Домашняя
15	3	Роза	2020-05-09	3 500,00 ?	Так себе	\\xffd8ffe000104a46494600010101000000000000ffdb004300090607131312151313131615151718201b181818191a1a1e1b1a201a1d1e1a181a1f191f2820191a251e191a21312126292b2e2e301d1f3338362c37282d2e2bffdb0043010a0a0a0e0d0e1a10101a2d251f262d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2dffc000110800e800d903012200021101031101ffc4001c0000020301010101000000000000000000000604050703020108ffc4003f100001020306040403060601030500000001021100032104051231415106226171133281910742a12352b1c1e1f01462728292d13324b2f1152573c2d3ffc400190100030101010000000000000000000000000102030405ffc400221101010002030100020203000000000000000102110312213141512232046171ffda000c03010002110311003f00dc608208008208200208208020df1792644bc6add80dc984ab6dfe56ac49c240d08e60f9b1249a7d239f1ede78e78940b047d4ea7f285eb1ce293f33e40861f883f8471f2726f2d3b38b82f5db4eb86f813431fa9a866a7501f3cf27ce2ea326b3da0c95e24cc5a4a43805c8eaec32cdc6107622348b8ef44da2585a5b470083567a1198f68db8f3df958f271ebd58c10411b3110410400410410010410400410410010410400410410010410400410410010410400410410011e56a604ec1e3d456712dabc2b2cd5ec923d4d3f3856ea1c9bba6616b9c664f98a27339927f039475b358b117485287f2ff00b11536b9c428ab525cb8fcb48bdba6d24a1a996df9e71e65fecf726ba78816c973105c2491b4b0ff00e5a8ee5e2470cf15cbb3cf60ecbf3a03b92ece97f3102ad425a8e691c2f7909554cd014ff33e7ddc8fac28df9679945294924170b0a7059b250d7b98db1b76e4e492cf5fa3e4cd0b48524829507046a0e463dc67df08b88bc692ab3acbcc92687741aeb9312401b08d063b31cb736f3f2c7574208208a48820820020820800820820020823e28b401f6394c9e901dc7e51437cf11841c32d94aefca3d4667a42adb2f25acbad45676621bd321dc398c33e693e35c38ad68d66b4a561c107b477843e1fbd8e348352481e9ed0f915c5c9de17261d28820823566208208008208200216be221ff00a198dba7f1d7a69eb0cb157c5166f12c9393fc84fb737e51394dcaac2eb295865b6d65481be444177de5509259ba9fc81880a5b134a10e22b665a4a0b86cf335fc638faedeaf6d1d274f96b1e60372c48f57afe30bf6e9ca4ba71a4a4fdd71ea052a3f43431eacb7a85a19480b3ba14904ff006a07fa315b30baaa9a1cbbf47d7a67153163967bf17df0f6f04d9ed22614e1ab38f987cc9232243823562fa18fd0a85380778fcd5754e129492a662aa1cf4cfd9c7ab16d771e14bc49952c28b83cb89dd8bf2bf45553a5523ef46dc7755c9c90cb041046cc4410410010410400410470b45a928a135cfb0d54761d7d33803aae6019fef7308bc4dc54e4cb92a0f504b162d9874971bd223f14f10aa695ca924903ce02493d028076151cb43abeea32ac830b15a8b53623f94829c6c3a7fe79b93937e47471f1fe6a505cc2730a4f661964680b6d5305a67901830ec20b1d99ab40d9312dec407f4ac46b6cfe66fabc7264eee3c76b6e1825569960eaa1f888d6e333e059255694923cae7e87f48d323aff00c69fc6d727f99fde410410474b904104100104104004577114a52ecb39082cb5cb2949d8a8303f58b18817dcd2992a20b1df6857e1cfac538b0a25619696796196cc467e5c8659884b9b6e52490143b282549f54ac149f5112f8b64cc55a16b424d4390eee756fc5bac2dcb7f1038e956a777046bb46131dbabbe8e8abe13802576296e054a0809f5f088403fdbda2b0de80bb269a8384a5b2cca7f74899775df32749284244b6f9880afea6e571fda7d22f51c3d2e584ac2ce45d259c170f87ab02180abfbaf222d29ca428cc1890a4835e67a97e57ec40158d138578865ca696b6285a701209d49ad76aeaff008455da6db2a727025354f2a0a410e0a007cfca5dba53688b7659be629486a925f3ae4fb96cba768369a74b3f165a100a5333161018cc653e42a7cce7a92e4b388f127e254e0158d283841aa4120a864c3139c5a0a4265fd680a083208487a901ea92e54ede560ef4c842bdd77bac4e47f506eff2abb8fde6636c6d67636457c50c24054a0eec59c65f8c5edd9c792269c252a49001a107b8d328c5ed5386341c9a728e6320c4804d1806cce6fde23d827287325dfcc12f52e52024d5dcd19ba45ca97e8fb1deb266d113124ec687d8d63a5bedf2e4a714d5840c83ea761bc612bbd25cc4cb92b9ac4a7112924fda00c125c0214455c333b7536b612e84e298a99868eb51013cc00219c24e9573ae8615b0e4d9f2d9c553a6abc2b0c9c6bd5732894876c4a6344d0eae7406205f76b3211e1254b9b3e6566cdc2ca203b120304a039c2970007d738936f69166b399366981734f32d658956a41ec90c0694ea6142d97b098a52a660214a56171f2be4af9581012284d19c08cb3cab4c24dbb4e9a8455732b98f2acb9cea4249f66eb1f25db0b51589f5385fb019c55cc5201014bc7414961c7e0587aef1ea7c99843230a41cb1938896d0b37b93185c6d7561948eb36f0507707f03dda385954a98a727ac56252a496512770453d22c2cf681e54d55f8445c5d18d69df0de48798b0416001ee4d2bd87d61ee177812c465d94150e6592a3f9431476714d631e6f3e5db3b4410411a321041040041041001112f6901726620960506bb5287d0d625c53716dab0599601014b1843f5cfe94f5803f36ded6e2e482ce5ea35a3061a505226f0a5c62d4b7531009c4a76229b14b1cfafa663b2384664e59254c1fa30e9d1e2d15774d9093265a7096e6988049a062a6155339530ad35004617cf8da5fdba5b660b328a641702a4e585414a72f503cdd68f9d62b976c2b980ccc414d502af99a1d4304e6e439019a2cd374143a07fc64f33b00a18481888cf9862d3eb1f6c5600a41294b55cac82e4a4e2c5560299f5001892da04bb1f28586677c434f33621a10396b47c8968edfc21e5c6a04d5d55208a020272e8d90a8f9a2c4d9992541097c2e5dd4169e635a1d1e9b97d223deb665612fcaa00949391756255417ccfe2356864acb6ce4a11892ad0248342e1c25436384e6c72f58ade179026cc9b34a0129016da8677c3955ca7d856a5e426ef55b3104a92e1fcb4039699e61924d3e8f1e3879132cb6b1255886348e64b3e15015ec1fdc45fe09eef32942572804e2f199c5685214a639062402c2ac3411eaca4f22c3a02663acb96080a4249eb550e5a501315d7d4e2a99906333bb864e15289cd44024e7451f5bcb3cc97f698c0012b12d2bc83385cc187fb52d9b31caaef7e1694379d89699a0cb0e94fcc1aab05955a1774e5a3f78bee1db6f860e2e64ab097661cc486cc96484a5408c9d5eaaf6bbc5736695add4030340c038a64d5a0ebeb0c760c2259ae9e61ca32198d48c20be6c35d5df822cadf67248284283b8cc8d89058be40330ac749dc3ea9b2812ea29a25019db40aa90846b8eb9067f9a0a17325f3e2a00012b4d0000e20c9352194401d740e265df7f945252990b59c4559bd39794f5ad7502a5e31ad2282db23c199f6930e4f8402ed90676032ae4699474b14fb3cc0e4a90fd2691eaa4cb291df0c5edeb6255b089c482948e404100f40f42f99390621e132f0bdd20948494ab2c4912c86d9c2405a7f75824dabb55c2e6034052c6830284c07d7027f7a436f0d70d2576992853096b726b556104a838ecd196592f05020000e9937d053d2371f856f35289847fc6541f0d588615d06705c3762fbeb1ba6968480000180a003411f60823a5c820820800820820020820800858e34b2999e101f292acd9b2ae4619e12f8cef0c0b20bb00352df4ee7da15ba873e972dac80a29c20d3572285d46acefa457ddd642a595295a66a399a1058aba647f28f53a7a54ac449c2352410ff00dd4735cf731c55c57280f092080e41352c3a87033d47d639feb47b93283060e1c905c3d4b17c419249c2e72a7bce9f772f0f282e158b5ec70e17ae7bb11b8ad5d9ef594161456935a6fd428b83fbd34b79fc5d6505204c1315950923d581af7ac01e6c29332624f305a4bb29c254e72629aeee30e99447f88c84a6cc149187096003307cc0d9c01ec44799bc632829f0aa84d482aa64708660332d47f6311388ed29b759d4995302942a082c0ee922ad90ecd0bb43d57cf87773244854d56118cb82740c29b6f143c46a08bd65a98d1008d464ec06b997dde1dee922cf2109537898320cd414207753426719c92ab5266a73082c1b36c2902b9be20c7a18732dd2d15af49dff0052a5d5402c9296cd96a72199c96c4e3ef18b3bc301b1634864f8dcc372eeee7ca43aa82b51b450e12712a8490e5b42d97677c8d1845aa899a9f02503854b415541af31f760c7af78d2a4df73f0da13226cb090b0b092492e0101d23dcaaaf4a45170e933566582685b4230e2030f5517033ab81908d36efb3a11282129002477cf203b967ef19e706caffdc1684f284a95435203e8f9f427488996f6762eedf774c6fb549436585d4083552280392121d599043302415db4d99481441200357f302480520e8e09cc644b3c69d7fda12804e00e914c89ae79176d49772c694a2a2ac82685788564abf94e94294e1d4e4e5c07de005ebaef509524294932d5cac54cee589626834cdcc51f14c9fb4528067340eec3e5ca8976240afa6418af2bb52a98a0b46196e92024025233c23201c8cb36eaa115f3aed993d2a415038588c203e79aa8140b69a9853cbb56d4177362028ee1c57ea77a47e88f85f6750b2e3506c669467028fd767e9185f0cdcea55b2559d6082a98127b620e5f70904fa08fd45224a5094a1202529000032005008d64ddda32be69d208208d10208208008208200208208008ca7e202566d24253881f6ff4f1ab4631f12ed1345a94996e46652cf96a22729e1cfa59e20b784cb121097512eadddf2ce3d5c3c28b5a54b58525b214f7a8351e91db85ee7339666cc1cb56702a77a8a01bef17d63bcd6898a42aa71160fcc4742c4686afb4657c9a8a9ed2ecae184844f98a5ab0252e13e9f37d32688177ce9763b099a65899366018493404a83f718411eb0eb34267499e9967ce870c5c125ff4f784a916255aaef54b48fb492a66d69503a38788b77adfcdafe4ba2ededc4be3a434a92821aa90b1309ad4149c213a31d8476b8ef253a66bb29040591f323f9b7fd228156538b031c4ed85abed0ce2ea366b2295328b58c8fd008d397ac913c7bd9faf5984cb0a4e4d9ec1989eacf0bb6d7980ab6400002ee428e7ddd9f463b43d5c3664ceb1a0d0ba03fa8abc2a5e7615074f7ad1b22fa675fdbc653c5d2d2ece02f110425434d1dea3a5077116d76ac24a497012f400b05328397ab17141b44508f286704b31e9903eefde9b4585d765c6a28151f3763bfa27f0832be1c868baef02b1ab00d5ddaa5fa0fab454ddb36cb619930898ca5fcca524a80d938bdfff001132f5b4ff000f2c04b6359c290776cfb00e4f68cfaf5bc04a59422b30d54b2a42544e6e54b040fe9f40d19e1dae5a8794926eb5abbefc953db0ccc407f3e224bea038d9ab9ed48b79c80a42940821a84500daaaf28ea230ae1bbf04c9a944e775164ae8082720e1b3a08699bc4f68b1cd5d9880b4a438a7ca6ae465f48dbd97559ea5f619ed294859705b115381ca3224bfca7560cfd238aace31a5468e7372121ea13572ed9b97a1d5de82c1c588f361c5f7a8438d2af46eadeb4863b35ea8b54b2a48e64d5c0db46760043eb4b6ed73d8909bc6cea1552142a75c40a5dce66bb36d1aec65bc2d6f44d9f27ef25619248d59cd438639337ac6a51ae1f1390820822d2208208008208200208208008ca38be5ae65a5430a80dc115f72edd86b1abc649c74b54bb5952437f9543f4207bc4e7f158fd7cbbaca6484a5273392b110fd5e83d0457ded204d56651312592529700f7dbda292dfc42a33028a7cb42ca357ce810437e912adb6c4894266475a0f4190fad631d5d2d26c28388629aac492c9537989634cc14f426becd2a770f9333f88b22fc39e7ce8231a161fe719b17f30a76ac54d86f90b504f82ba86620311ab2b0aa8ec6bab432d9af818d24a4383452544b50b104b039b37789b0e546459ed2096bb90a99f7d33991dd9494abd2137892ea9f326136c9a8430c5e1a6b853b77396b531ac59f891de9ab0252a3fb2360343b4643c5931732d4b389dc972d96accfa520e3c24cb62e5e1e7e1fdea9329525241c26872a17a74d63cdf52462615ab920b51c13d34cba67ba97059c0b5f3315b0f63f4cdfd21f6558d2521cb9234de9996edbc67c97592f19b9b262e4289068e37f41f9f7866e1cbbd28054aa529b771fea39da6e5504962e6a437fbd7385be26bf264b92909a1512925cb8d88fdfe7138ded74ab34afbeefa136f04a5c7868240d89399fca15f8b6c45168593929883e8011f48b1b1ddc99f31090a29528918b363a6b586f9b629e848956bb2aa6e1f2cc94029c0d58b105b68dbfa65b9fa65fdb12070bdc8b9d39258842485295b35586e4c6897059c5a2d5396ae608404bb54b063f8fd223a513e68c167b3ae52723366b24246ac97cfae716f62b32244af08124673081e6dd350c127d545e80d62adb95dd29348f67b9250954c8d030009cf6727bf4ed14fc32f22d2a94e4051203d3da18edb6e0c53879943ca00a1a6d414c8019ee6172fa7953654c188684d1a9f5de1e37f0561bb816c8916dc492fcfa90e35346e8d1b0466df0e9289d3cce48f2a5d47aaa8907d028d368d2635c66a2288208228841041001041040041041001085f112ed054998ece2b4c4fd187eb0fb14bc5976a67c828398a8fcc42bf0e7d61b795dea4a8a90e06c9058bf7200f58f3e260414f29dd8021dfbe14fa027ac58dfb226cb3815865213962c2927d0b1f7c5dc457230298e2a9c954afa8318fb1ae906d57824652960e8d859c6cc0d3ac48ba26cc5b9532468403ec2a31d064ef944f99620a4d411de274dba6d1e1a449b3198900104a80773a3d451dcc4ec54a952d73124a1248a034532800d96ba1a12ff854dbee6c2092c919b3007b7e5e90c575da264b9a24cdb2996021cac552776506734c8ebef13ad964976ab399928a48524e1390d73aefbc6796562b192b39e1e41138948ec3f587b916f12f334d77ae7f4d6339b35eff00c33a15e71424f7ce262f88b1b3b01159616fa2652794e9785e2a21d3975cebef4e919bdfb6c2b9a52d9d4bf5fd43c5e5a388d1954ee7f48ab9566f1ed2d2c6206a4ec21638f5f69e596fc8efc37601e3a54a514ea0f51a3e435cda364b15e0e9095a52a6a62a10cc2a41abfd3ac28d9ee4c2318cc8af4caa3423f5ed1ee7da8a1070f9c683a5490e1fd07a3c5ee65eb3d6bc335bd285372a535a8013b6a4b13a6fe90b33ed684053e1e53420b1ab644518b330146d62a537bcc2e927cd451db36a12daecfb878e7365da14b013270518b87a746ae546e80c56c69dac0b2a9854c4245126828fe99f48f17f5942d94ca6cdf314a3d017d6b4f588f6cbd96899e190a6cb152beaef9b829358996fb620a70a5652a228c58e9902c37d6235653f0d7f06d1844f1a1c395451ff00dc69908df0b6ce532a6172a0486258eef9130f31d33e32a2082086420820800820820023ce2da027ff001031edda0008dcfe51e4b6df48f78447c5ac00492c06b00657c6761b324cc61331be89600ff52944fb3778ce0da24e32e820fde528b9f473ee4c6a3c700cd985402503ef2cb30c9c8d1fb3466f7bd8ace9738e6cc3b4b025a5ff00f916144f612ebbc637cad67b17d70cd0ba62a6cc3f38bab4cb9cac46cf6bc24b3248030fe04b8d213387af259561972d086aa89188253f796a9a4a50df7b943f70218ad96a4909595ae61c82c1c21ff95eaa0fd0778cf287160816ec60cc54a5c962e12025d5ba811d5d9de9bc4cbb6f7504042ecc007206125b0fcae08a3ed0a82f39814089aedf79dd9a800d0748ef278826907c4e62f4abd233b171138fee8973d266cb4b2c66daf7dcf58cd53358011a2daef25289601b7784fb4d9a5ae7f4ccb644c6bc575354b39f946bbaee9b6998c8a01ae91adf0b70ccbb34b70ca5abcca7209dfa342c5c93d0818129c34d3fdc304b528974ce29184d1e84e869afae9a4467976f049a595a916b54952528972578da582a04286caa33b3c2eccb3dad3314a9d21d219948622b9d5f133eff0058f532e92b972c2a7ac996a241c5524e789f4fdd5e25d8e7db519da02812490a60e320f4cfb7582593e16a97675d73012b96b32d4ee18330fbb4fa44d45a6694e15ad2f4ae171f86f1f6f3bc420362049a023f3143ec21627cf5a94e79df62c457470e74a07ea0c39da9f917b6abb42f9b1325aace453fa8bfa931cacb63059209ae42ac76ee222d88a9544950503ae7d8ee3a38ed1d577b265299cbeb46afac3f7e156adc056f1295e012196cddf4aeaf97b43fc615c3d7c052c2ca89538c24060e1b2d8c6e3679b892950c9401f70f1d18fc6397d7482082288410410011f0c7d809803e011f621cebc121db99b6fde711a4ded8fcb83b1531dbf189ed0f556b0abc4d7e844d129c0006253960764fe6d1766f121c196a71a063f8b462dc796c589ca3301e62490eed5c86edd20dcbf0692b8aede560a90188d2ac074da156c89f14f3109003a946a025f41ab92001472408e66f4c6024fd76d331f998e76d41434b0484838e69d5d8d068e94b800fcca57a459b5caef6996084848643bcb964f9941c78b348f33547b80c313f79178784e261c4acb2a0ee3271f70513406bca2a137994a7c4345cca25be540a3a76cb0a76092736311156c0580d07eff7d22754f70cb3a40527124b925f3fdb9fd77884133052915b66b714331ca2d655bc2c6d1362b68937c45666234bb23178bc1312047d4cc43690040973a9cc3fd44936cc80c9f43ec63caa7a18b91b441fe3e585003f7ac2ebb1db49f2a607c6a273af310fb878f3795e499751cc953f9ab519a4bd42851c762330628655b55312b407760a4b6a40723d52081bab044bb359953e531ccf297a7306f0d7f508fefd9022a71fed373fd234eb5a261a2bc251ddd48396b5523d71752911ee55ae64a644c485a2870a9886d0a142a01a805258b9ce39c8ba72729afde714dd854c5fd86c2809c2b415a45406c201d4a4e61f5661bbb45ee42f6a2a2d24a02a43aa9ff12e8a7d5292c02fb72934a28451ce2a2717367505dd3d0e4e3ab7a086bb458a5243e615e5c5d342134714a54d684867fa9998b34b91f390c01fe71a86a39e66dd9a0dc27ce16b1d42d4a608ab52beff00ba47e88bac3499432e44ff00da23f3f2153461f11494a4310996582934a022ac7ef651bf5cd7a4ab4c94ce92a74287a83aa543423268bc5353608208a210410401f0968a0bdaf3a8493853425e947fae9fa45adbe7848a9ea6329e37b64e9ce11325a403f302efa35337f4318f265f85e33f2709778cac92493a014277201d0470b4d844c3890b0e3456477058b8cf38c82c5c53364a8a14a482354a49776ab82281cf724c395dfc4067a1967129a8b4b3e6c5f9b3d19c57d4c6171b1a6e1cacaa9e84e172520bf3ab1862681333cdb50d6beb0b97d5a6cd6b0b953009539884ad40624f72f40f46df27a457a6fe54a3cf33101a51ce6083562a7a6d47de12789674d59f1a5cc02a4b5016ee28fa31d768d71c536e95f36ee99669a0ad0e073170e0a439edcc016f48f565bcd3301133ccb20392f525c961a388bae1ebe85a92254e2e40e524f46c34ae4f10ed9c2cbc4a54a20a5dc105b2cbf38bdfed3ff14379a062c49f2e433141403d000220a535fdb7be9de2eac1762973449259648001218ec1ea7d1a362e1fe1893669490532e64d7389679b0f449229f48596731126d8b9b92d2c0f864a4e44541ff5eb13eede1bb54ca04149d01041f639f714f78d4add788b3a8ab08283a331a176cb2a92045d59af3c6904310cfd2bb1d631bcb7f4beac7e670ddb13e64285336f4620d437e0e748a7b7d9ed0874a92a490ce0ef967946e936de929a9c8b3863ab7a1a451daad7675a48590cc49c49661d5ea0d723ed063cbfe85c58c5ae44c252ce7124287a939fb18e7fc390f42ef8413f77e657ebd551a65eb71a403365a90b4a41211caca493cdd5dc9f785fb1c94cc4943144c6c0cb184d086d6a3a803cc3bc6d339622e255933d52ce27e64904528082e3d881170e12a9b2d8e04a963325802c1b7215e1abfb7a45dd86e144ea26590aa92140904021d69c24a56d41842b519b88e96cbb964ad642129c471233a9249667517068e376687b81462da852897c2eca648ad4051cfbb3c4fb35b24a48500b5ad5915542417c26a4007af68882c892a7292311e57a10cc4e5a61043fa45b4aba41384292ee284b860d5eaa603dfa42b2079917e0c250894829399c01201c828ea4b972e1aa778f360b7cc2ca5073f75aa0eae7e501b389b64bb3131212a40054a27719b0efbe55ed1eecf2a4cf25656295228c4e62b9fac2b61a7d9af5b29094cda35490ca35d438cf37f5ee5aae3b5a2cd3133254d4f80b500b00000e2c9543987f33640c272b84e4ac15099895a33b03dc3814a3004fab44db1f08908c027905ba9cf4727ca76615aea4131ca158db208a7b96f1514a5139b180d88647a9a963fba651711b4bb40820821825f165f8844c54a7e6c2751ecd9e9b18c7ef9bc1466120950cdc3b00e75639572da2dbe264d548b6aa6a4bb9a823e5d4085eb45b029188a9b1075035a2826b4db165fcb1cf963bcb6d65f1477b62772c5468ee0b8da99e913ecb7814a59c9a32b3070ec082ec0e9d72ce296d5692a31e5615527dfac69d51b4ebc67e35129252d4cde9b396fc03ec22be5935dff7ac74b1cc1f36511e6ebd61c0ef74daccb981409041770ff943ccbb71290a96a5310ec4eb5a728afefd33a960bb8ce1e3e1d2573a719254594ccca21ab53405bd61673c18d38705f0d788af1a617c25db220f7cd84395bad284f281f9375ac7bf0116693841648f98b3a8eaa3bc677785f22d13bf8641c08a9597154ff5053b9e8239aff2ad67893795bfc55e1947161a2954001a39739e5de3dda66cd49002c10d916233009719e7126cb64c28c32ce2969a11cac19d8620057b7bc709d312a0524e791e95a86edac4d3479caabba09620efad497008ae51e6d5e6014a63bd3bb1d0f4e8fd62bef5bd5692d2c052945c339670ce48ec48a8ac74bbd3370f38a9672aad09353a81560768a93f25b4d958e58c34013e5ae2200f958643b471b758d131e6096f3659cd2a2313bba8b10904a5883ab69a755cb565310e1c386a38c8be6469fb68f521665a795694a07949ab8048234ab1cf4a37572958a5996d51c0478885a5bc262710481cc26020951a10cda96ad22ded168368422621271246252149524a8654a82b34342159014a4565b1025292b492d8c0524e162144a5401a611e539e5b3c49b14b4abec499812409985454310cb1214ceb1d0d52dedaca979be2c6568fb4c5893e4c1868826a9ab1c469a376a3725da16894262400524062948a3d0133281830c89ed125764582142509a321caea29f998a0314d1c8c7931ae429ef50f20cb96a764b94ab0a0275e7c6521f314634398a0b89abfb15e081342880254d62410c0aa9f33b29abca90c187a53f104b4d9a72d90132480796999a33f400311997d0c54ddb356642809c71cb53e240c6accf96a31072ee186cf9c5c5f531536ca99aa40572b1984305547292e3016ad5c396a983a8dad9568992e578b66e74a802cd931ab8d720c373de3e5878d5693f6c952180a1040ab1eb962190fd57783ef732ce020925c24f3365b6474cb2a67ab1daec88b563945214a660a7092839162a06a5ce629dcbc67d74ad9aec3c4d25c629879b5c2ac3d8161f4879b92da149090a2a0dcaa3a8d89dc7d7d0c7e71bc6ef996299819453898121ab4239487663424826bda1fb81389836098f466200a17ce8c43778bc66937d6c90442b0dbc2e8431df457549fc8d626c6a964ff00186e052bed9228457bed18790722691fb167494ac14a9214939820107d0c54c9e14b0a578d363b3856615e121c1e94a7a44e8f6fca726c3355cd2e5ae60dd085287ba4186de1be04bc2da7c3f01767967cd3272148007f2a540159d9a9b911fa5c06a08fb0f436c8acdf02640f3db272bfa5084fe38a25a7e06d8b5b4daffca57ff946a504326672be095801ff009ed67bae57e52845ff000dfc3eb25897e2493371331c6a069fe208f486d82168328f8a579166c3ca87350189c80e677ae8d0bdc0d62426589c529c6b0492aa65b38666ad18468bf10b83d56b96a5493f6b87ca4b0536cf40ad2b4cb28cbeca665993e14f9650b4904a562a43d1b1518b661e80b67185c2cdb597663bcd44a8f32400337275ab3e75a7b42a5e9394853b905c01bb54a45280bfa4584db62524a8cce5c452e454100390df225452c3bed08f7dde4a5281a8df266f969a52271c3d3cb23bdd96397852bc6144e645002f5c35c8d2bb3ef17027828672c5c0c99b604e61cb421dcd79e2484a8909482c06b4cbf5eb167ffa81231e8287df2fc7eb0b39445f1b56249600801813dced9c70913b19524003082c198048490fd9c9f78adb1def2828a08e56cf40f4fce18f87f846d16c5f8b5932158b994082a490dca9cceee585758898e56aad8a79d217382a5252662886c012ee9249490054a82c57a030ff00c39c02c894ab42c85a43604e16d01ab1c214c0948d4986db9ae49366404ca400598acb152bfa95aeb4cab48b18eac78f5f595cbf45f99c1561517367497d0a9453df09385e99b3c13f832c4b042a4b829c3e65655a020b8ccc304117a8827d9be195d72dc26cc588620cd9c41077056c6278e08b0787e17f0c9f0feee25b7fdd0c30430574fc3dbb410a1644380cf89797f975313ecdc2d649654512424ac82a20a9cb6557fa45cc1004155d1248632c17ddfd9f3688f27866c68f2d9a50fed116d0401c645925a03210948d80023ae18fb0400410410010410400410410010410400451718f0f0b648280c99a9e694b3f2ab62d5c2450fa1ab082082cd88c0f882e2b559c944c9131000aab0929cf30a0e93a6b11aebe05b7daeb26cebc3aad6d2d3e856d8bfb5e082224d5d2edf36b61f0c2f4465657ea99b27ffb2c45d5dbf08edd31bc6992a4a35a998aff0014b24ff941043eb0bb343e1bf87361b210bc0674c1f3cde6639f2a7ca18e459c6f0df04115a48820820020820800820820020820800820820020820803ffd9	Серая	2	Агнорская
14	2	Карл	2019-01-01	5 006,00 ?	Красавец	\\xffd8ffe000104a46494600010101000000000000ffdb004300090607131312151313131616151718171717171818171718181715171717171a1717181d2820181a251d171521312125292b2e2e2e171f3338332d37282d2e2bffdb0043010a0a0a0e0d0e1b10101b2d2520252d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2dffc000110800f200d003012200021101031101ffc4001c0000020203010100000000000000000000040503060102070008ffc4003910000103020403050703030403000000000100021103040512213141517106226181f0133291a1b1c1d107e1f11442521523729233b2d2ffc4001a010003010101010000000000000000000002030401000506ffc40026110002020203000203000203000000000000010211032112314113220432514261051481ffda000c03010002110311003f008ee1c4eea3a65d2b15b34c153da30c85e4c9ef479b248f1a649d54773a3804c2f28910837d33b95de8718d8453a22015b1a81da214577bb400a26da9f31aa6cad21cf1daec12eb43a292dd1bfd0cea54c68b0364968e12e735a27ab880816194f625e27e89ee291256f41f08c7d3da763b104107a11a1596d0680652d6169ec1f8a95a23f6d9b459f6612f35b29d11f475039a0e0efb320add04ecd40bab0525cb5cd1aa5c5a4c94d8494873d3a257dece81422e5dc9454e819458a597585b086f40a4fc30da8b22b8947547d32cf14ac5319b554f08c5d051953e86542b03a142dddc069d148fb49f74a96cf0e24cb9765b4d241649aab155dbb3b7659b17e5129add5b812004b9cc80932548f7211e7ff136bc905fb6044a82f1a224211d770214946b8768506ef47cdceec5f973185abecf9a6356d32f7828f2e6dd2ef227c4c4df4377d2cdaf25a5bdd069e8a7af78d6e60122ab5b313089c13fd584bedb43fb9bd35085eab48909032f9ccd84a7987dc97097e815308785315a336f54d30490a4a3719cce887beaf98103509636b161132b787d8d8bdd160af744745c9b1bc65d56a39d26261a393780f5c5741bdbccec708d323bff0052b995dd28d370aac704930d2b634ecdf68aa52765cd2c27bcd713948e9c0f22351f237eaef90d7032d70969f03e3c5722a2d874c13d0c2e9bd98ae0d114ce6c93a07887327888d0b77d74e8bb262f9234bbf00cd075682dcd6a61655c344a12ef0d734cff006f02a5a0c9d21794e124ea4498d493317d785e3542d276888b9a641039adaa32040087834d2366e4d90d16ea88b8a82217a952d24eea175073a63847c35fdbe29ea324142525a402fafc146f6945d7a7944c20d95493108ea569b1918bbd9250ba703129eda6200049c5a389903a9f5ba32ab69dbd175cd6f747b8c98f687949fede71a9e0a88e2949e8dc98a2d689aa3b4356a39b4e9ec1cf3009e4d1bb8f800500eacca80fb2aaca91b861923ab4c18f1885ccbb41da1ad7350bdee99d001a0681b35a366b4721fba12cee1cd21c1c41064106083c20f34cf821545d8ff23243f19fe3eb8b3a2546e62b414c83bad30ec41b5298a9b3bdd78e6e1bb87207431cc952d6a832eea2962707479dc1d93dcdde56c6e841765c85234d4ac5bb8b4a292d1ce291603ded179d601a278a04b9e1d28e351c6104571d1918d6985d0b2968d11956966665d924af8b3a9980a4b7c5336e9d154ac757f0636cc6b3459b9a6c2a5a6d6d41a68a00d01d0b6555a31a540356bb7bcc206a08f882b9d3ddb83bf82ea7470f6b9d9818d5734c62cbd8d77b0c435c63a03a7c93f04b9458cc72b1860d644b87bb1beec11d49ef1e815df0cb4600403e3a19f9364c792e796b7307baf87703a88f3699f82b9767b12a8465a8660e85c7369d7705394e873c768b8d9571196a439874cdff00d72ebf34e2dbb3e0fbbb19f23a47af1551a7705af9ddae111fbfaeaba2767eb4323870e878796a10e47096d89582d81d5ec9b1c413a47e49fba0313ecc381259acce8ae42e56afae90f831dff5ece7d69d9aaaf741109f611d9cc939e397c0ff0009f0aeb6654591715d04bf1944afe21d97696931e3f0fc848b0decbe57bb30d04127a8980ba3b087084bf12a81ba0dc9fdb5f82a2308c9d899c28ae3f0f60233001a3668064f5e7e4173afd52739e21cdcad6ed2632f2ee0df4f0d36d5745bfba7827216b77d4b7313d07f8f848e1a8d973aed6db020ba1c489cad04003a06efe5ce66153494690b8c5f2b67227d220ea35f1dd4acd23d422ee6d9d98e6f7a4c8e5d636e8365ad2a3aebf2953aeca1963ecc4fb3ab3b4b23a80ff8a2daf0e3ba82d3b94f2ec4ea786e00fa00a16121ca6c8ee5a12e1615777cd63804e30b6b6a0cfc121c430acc334a3ac283994a42e4b96905f1454ea4396b0e688959ccff00740844d4ae29993b7343d3bc6bdd2d2a494fed6c8ba338860f51cd04043d9e0ee60929ff00f5cf10d1a85a3899d7629f92551d0c729455306a84b0020a8d97609d513776aedf82f5b50046a354308b1b15bd8dad3087546cb0aa3fea0e08fa45b50b48ce0ce9fdc34fc2ea5d94a35438023bbc6788f0565ed5f6729dedbba93f43bb1dfe2e1b1e9c0854e08f176c6b825b89f2ee0748baa869035f25d0a960a480ed465d86dfca5775d99a96b59adaad23bd1235f81e2089577a2c395a0787afba2cdf5d1561da15dad2d4759f5e7af92bce1248681eb9fdd27b4b2f0f4158ecadb41e7ebe4a37272652a0920aa6e2b72745bb29adc53946a20b92027394b4dd0148692d6a040d505c933c2eb2a518addcceb1c278eb1b7c51d76cf5f055bc55da1ebf34719ca2c094232457eef1173dd0d39472dc9e1e7cb969e6a85db0bf3ab1b27fc9c751e7c3e32adcf6652473d2790551ed4d1001247fc40fafcfaeca9e6d93f048a77b613ebe0996074c3aa34bb5683af8f82514a838b8340249d00e249d95cf0fc35d4c365ba8df8c9f0e7e4ba4e90b72fe92768a4439a34415b5c823c539b978a8dca42830fecdb9dab4a5456b66ba6f4476f713a150d5c51d48c0d5a782debd17537e5705b56a4d78d42c8b7095a027b7b2dd4e9b2b528e309261b6229b9cd2a4b2b87d36f4528ba0e13c50e4a9aa265169d85500e6499242dea5f1cab342e581b0e2a1711508cb1012b8f864e57a0db2ba7110ed959300b16d47b44ee794f9154ba98a358ef667e3c974cfd3cb30585e474e235e453b027e878eea9971b6b76b1a1ad1002996095a1aaa9b45090bf1bb5a75185af6870f11c7c392ac32c5a0881a70fc2b6dd994bffa6f96a95936538b4802ded93663542ca5074f5ba3ade91e29718073968f342d8356c5ab71b23a12e4070b046aa67050547c21a18980624f893e0ab5887bb3e04fc741f64fb117c8f09558c66a903cfe9b792ee1bb3b915fbb31b24f570df6a62249f5f04e2e84a2306637da02ed8144900d8e7b15fa77468b7dbbc075576c4804341ff069d8c71285edb616e634e4040d840ef3be1a9f2d1743c22e9a5a39735be2590b49c81da71854e9aa26959f3b36c6ab4cb9a42398faad12d30ad388546bea39b00780d87d924bd664d370a57c6c5acd188aaf29b9c333b75150a5a29ae5a604980a50c39246abb8a61da9071b710b5b470048c87ac22a91304921094f1c687e484b8a92ec4284eb60b7d6f24c6e85b00e638b73271757ad0d922124bca06a1cc24744309717b062e9ec7186616eacf82d9d771aaee5d9dc39b42835ad11a6aa83fa5360ed5ce920735d44ab2355a29514b64750a8095bb8eabcf68423d6880e8b47852540a07ba1031d122bcbfa74186a3cc00279f901c4f44a3b3ddbda374fc81ae63b52d0e11980306173afd62c61cfaccb36bc329e473ea12ecb3024367892348e6e1c02aa5b76aab3afa80354114dcc0d0c717b5ac919da1c40ce728d4ebaec79558e2ab64b966f968fa626755ab9e82a577dc0547ed89f327ebfb2964f63e30b09f6b274435e3f4503244ad2bd7d08f0f5f742827a01b9ba6b1b99e4003ea76f9c7c555ab6396b70e2ca551ae70dc0f9efba59dbfc5dc432935ae76676ad6eee6ee5a3a890b969c55e2e0d5a603326a18dcb9047740194441f099e1cd5b08ae049293e675caf47d78a8e8b7294461b74dad499546cf6b5c072903d792dea5b6a90d0f4ec7186e244084d05f6610762aab4dd1b23ad2b09d50ecd695155c7ae8d3ace0035a0f210b4a243c0cc422bb6768c12fd5ce3d602a0d5358986b8a172fb523ce9e1e4f459f13b50e6900a574b18a9480665db8a3f03a4f022a9df6256d8cd80025a27e9f2fcae6dd0b83945f1666d3b3f7551c0125a0a3718ecfb2d1cd9ef38abcdae2b40536d46bc1d35d521bcc5295c5473de4656edb149c795fa7aef1ae3a2b8da42a38666f753036ad0f686eda21aa620c07bad04784a6186b0d5aac2d69dc723f847c5396cf3b243efa3ae767ad053a2d039724c9c54768d86347805b56740549423492b52542eaca2a95c1e281c87289bfb4d56432770871506f2a4a77a074409af46b8bf0e3bfacdd90ad52ab6b53a6e7b4803bba969120cf8101bf0554ec47626e0dcb1ef0e60690ed74248d471f9fd57d266bb5dc9669db37801ebc154a5164ae324f62ea56c4003d6ca665b6c3d714c9b49672049f8d58cf90595e8e9a6e7ee7f081b9b6869f1dbf253caa344baf4e9e3c3a23500799c8ff50b042ea65e37131a6bae9f6685c8ee70d7b080f2038c92dd4902604c713af48d75d17d31895091a807c0ede7f85597f66280767c8ccfbc90249e07c4f8a628da14dec1fb196c45b520e0416b04cff6f18f13a81ea0b5acdf99fa7d87d9136f6e1ad88d3e1f29505776a78708fa0e5f74a90d8835421ab6a3579428eae50369f1331f043d3abaef1e5fc2036cf76baa33d90cd0b9cdc5db9aeee881cf8fc7f10aefda6607b469279aa6b30fa8f7911a2c93de89ebed688ed6e5d065daee9861b893cf75da84baf70b7b4f775e689b6cac1e282566cb1a7b1be054e9d4a618d7069e3a0fba92e6d7d9b4b5b5337481f44b70fb7a72d6e7cbcf5564a3645ee0ca711cf8ac72a74ca652828ed95861acd303313e655efb042b3eb3411dd1a9047d159bb35d9c6d204be1c4f82718559b69d4765d899d11fa990fc89e4491601b286e2a69fca9c15155a521336551ab173aa9ff001f5e685755d7d1fa7e166ed841dbe7f994aee1a799f90fbfd92a4d94450657af3c41e87eb308275c6b13e7a8f9f150560eff0021e6e03ea50cd754066091cc7e42449bb288743ab3aae274123aab0dacc4a4384b38c26afad01518b4232ec3c550b2e4b68dcebae88917439a7a112c7fc37aba84b711a903c4a2ea5d346fc557312bf06a1d660683993fc8f8a6782945d9a5dd48048d48492bdeef3123a40ff91e07c374dc091defac24f8d5ab48d21b1f1d7a0fc754a6d87c415d8a01a6fe2341f63f250d4c438347c7f6499f529cc10e31cc867c443bea14adc440d052a7e798fc41711f24ab0c2eb5c1f3e5016d6598b802d8ebddfaa06be2af88d2390688f81d14b63727786ffd5bf60885be8b3dc6081c01274557ed051f64e1918e23a803e855a70ec59b97521418ad56b84e84226951e7acce2f6546ab5d94b9ad68d38c9fa94905677f79ff00ae83e4ad18855ee10d6aad1ab12327c92d1763cb19a05c26935efd58e3e3aaeafd8bc1dad7672c811a4a2b0eb0a14d9218040e4aaf8b76a9d51e69d2765cbcb45cf6ec4b9396a28e9d775da1a610380dde67bb5e2a936bdad6c64ace83f54f3b3b8cd17bf2d3fa2dff006061838cf68bf87ad737342d3748e2bcf5dc8f41400f167711f6fbaad5c5f386df53f64fafa5d3c956af21bc3d797e526527650a0890e255235a91e67f0b7a356a38fbcf3d4803e24a50eb923510d3cf6f89e28bb1ad9b5fd8798fdd65dfa775e16bb23ddd753d41fa21f11bccbfb2da854019a24f8b3a7a270b8bd910c64e6d4f144d0c4399551c4ae328cc17a9e272c041e7e5c7d792ce4d3a2d8c22d596daf8969baaade62c3da3bc38133a7870e6969c60c1e5afaf92addddefb4a840db72797346a57d0acb049176b7c71ce3be898baee5a751e73f403f2aa1873c81a68993ea98dcf50b3d239307ba78cc72b299e835ffac877c90c2ec71637e7f725477158cc4cf291f9dfca561af07de1af3e3f3fa2e164f4cb5c768f269fb04c2dd91b421a8d18d742886958711d5aa438011aa35a091aa4f5e93454ce5c512ced1519c8d32e46a4ab679d9f134ec29d420ebb2d2e6ce44b029d95a48246eb7bcab907744cecb9242a33707f531758d10f34e9996969d791542b22fa6ea8e76f2ed4f547605508aa5ad398999515ecd40e6186c13af3d5295a747ad18a4cad5f56ad51f9a3a2b87e9c62951b5f299d79eca4a964d0c600d825ba14ab007165cccec99fe8d6ab67d1361565bbacdd56855dc0710ced1aa6d589212dbd0e8302b9badf7496f7994debe9d52ab91c54f2b2b8b429aae8d4efeb73f641b6f88740d4ede027801e8a2ee1b252dab4b5fa9f0e486327613517d96cc2afa441709e26447973f5ba92fda1cd22154e8dd169194c6b03ee7d7d8cb9a38a82227555c64892716ba15e2f6903d70558bbaa6983aeb1d01eaae189d70e1baa7f68ae19948dcc70e71ebe298d20a19dad31332ecba9c071d49db8f9f05361f6c40248dd6fd9af66181aedc7adfd6eac4cb5133e3a7e7eaba290193359b583464d74fafaf043dc5cc121bbfc247815bd7b97096c083c638a5cf69904f3d52e4e8524d930a923edc0fe1669ba5421a8ca74e7d6ff00bac4ecde341141eb7756850374506215081a22019ad6be667876839a0051a354934b4783bf341b9b50bbdd90a3baa1ec8676182b1a4c5ca09f65a2ceab9a0071d53415f2f78ea554b0cc673823fbc0d3aacd7ed03e035cc20ae52a5b23c9f8f5b44b8261868d4cf3235dd22c5aa6673803bb8edd53317752a6b3a341d39a830fb30ea839cceab93b3d148b558dd305ab03b5239ee95bb217c86c4a1afc3d95809cd4e351c941675d86b7bc404766356740ec8dd372c4ea0f15703752173cc25cc6f79a7a99563a17e3819412360fc632af539a16b9042d6ad71e687a95b8ec122457164171a4a55767446dddc4a4b7d58f04b1966f6c65fe0040f5e489a6c0212ec3ca22bd7cbaa393a04333eb95018958b76731bd7645612ef6843bd725b7682a0e1bedf0fe5129484c946c43fe9ed6c111e5f147db53f24336a775196550190577366a8221bc670f15116c1d788859bb76a56a5d210a959ad51ec9c113488882876382c3ddfc26c44c891ec8294e2b725b1a13e08da95f820ee2abb5968d3646f484ca466a627dc86b7be42486ad57b5c5cd44d5c41ec33ecdbd54dfd5978ef436787e50c690b739375428c2ac8839898d51f745ce789d6068b3ed342dfa28ea075219df29595b7a5d839a3aaf46d470b34ce42fef4c9d27c9154e8dbd2a99ea87658f7b6413bb44e356a12d13b9f0550c7f197d77c174b470e0a8e16c75978c77b434e9b7fd900870dceeaaed7e712d064f247e1f868a94dae7ec0404db03c1323a4c01c915217972712b4e1701c03737cd59306c42b512054d41f92b154a2ccbdd6c9e242418e576d36911aac62967e8b5d3bf0e120a9cd606005cd304c46b3ea06b040d66782bad0710d999e685e3b2c8647458ad30e6d49d5135bb300805576cb1ac840263d7ecaf383e36daac1041450c717a617cb24556f3002d1dd557c51ce64878e8781fc2eb172f690aa3da2b6639bd51cf045a0a39594decd62c1aecb3a12b6c6af8bde29d3d5cef90955ac530e75079731da13f0572ec2dad3273901cf8dcea424a85ba0ed766f877679e44bccfd117718665d95b006848f15b9689829af0c6b62fe5655ee683819f150d4a9cd4b7b886b038ca517575ba4bc515d03f2b6306d6d545757606e557af716cbeea4d4f127b9fde3a15aa20ca565a4e2005468274907aa93b4377df63d9b1e0ab86ec139484c9b62f34f3027bbc392195f42ded05d31ed24bc11cb92c54a038ec81a78896b7fdd3c76440c601a4e1035d89dc2c517e198ed3b44945ed61040e93cd078b5e3aa3b24f894bdd5fbcd2e777414d6b5363867a6649471c693b3543d00a149d5412d265c3551db60c5ae0e7c183eef3eaae0fa4da4c80194c7f913a9e816b60d641fef9e29961502dad0a955c25c1ad6f008dbcb3ac76aba721a26762dcc272651f550df532340a79c9d9e7e7caf9d03f676f1d45c438c89e2b3da66b3570db749ae0bc4c71455ad32ea65ae329909a6a85a2b56f7e58e39242bd5a56863593a96e62aaf5ec728240ea963b1e782401ac6508e2cb71486dda2bf39585875d67e8b1d97ed8d5a0eefead9d7c1564d7703a99fdd116cf041eea26fd1fa6773c33b4b4ab3410e10425bda0c4d824485c6edefdd489c84895356c72ab9b05cb79b3792433c771319a03f30e5c91fd96ed1fb3e200faaa312b66be042ce3e9dc99d8afbb5ec2dee949df78fa83780b9bd0ab0e04cc02ae9875f02ccdb4980b5a6fd356c31f409e291e259c123923f13ac5cd395d042aede5d9102679a09a5d2173ee82ec2c8b8c98859ad634c3f346dc38203fd61c04356ac6d6aa73093d10a8b5b61452438a789b43bff1b4722a6a18b005d3ee9e4aab51aecd0779e2a5a6f7081c177c6bb0a73be861898993e3a744bc5071740e28c7550f86a1057735f238145015136b6a0e738b482471f04c2a61af67ba74e48cb1c56997416847939e5cde1a11e0b9cabb35ba1b50ecbe721ceacc79f127ee985a6075e9bc06642d27bc411b78292b0a6d64b37e1fba418a620ee048e601841c7278d052b48e846ca06db724a315b7247ba67a2a7db62f59a747b8b7c49d133a58fd58f78a9dce6fc4796e3107bda2768405b557b7343759dd3438f56e21a7a8509c4ea3899a4cfa2e539a77c428a4ba608caef2d7074441e092329e406436758d354f2a5fb78b5a3a1425c56a6e69397c374df95ff0a54ff8556a5cc9d405b7f53a6d1d0a2aa52a53058e1e68673e903a35df14e52bf072641a1d96a4f046b45289d50ded1b3eecf9ad52bf0d5b31ec742a2211d4ee8123ba11159d9892000009db92ee4d04c5308ca578e0d6b41d1a6543500277525bb35f01b95ae5a3ba0fa9707ded7bdbf44b6f3de46beb35d4cf30ef9109739facca18a776c04bd646ad1d97c46931a1af3049e2ab8d64ea4c2d1cd85b38a92a0d3a2e78f1b7ca4b802ee11bcaab5b57734ec08e4540c32752995bd06be38958a3c551add928b46905ecd2776f2e883ce068e1d0ac9765a8003d5138a5a121b935113f95d5b14ff624b2a0c74498e9c532a97ec6775aecb1c557acee0b3bae692d3f11d11bfe966a101b26763c3cf92c697a73fe32ff00875dd2acd39641091e3f85960f681cedf54bb0baafa15035c72eba83cd5cb11a81cc00f78b868382deb63ef915cc3cb5f45bb02d264f82c5780e81ea526b8b9cb50b0340d600f1560b3b79617b88cc7eda209c3768f37362e3f60ba34816876fcd2cbdb671712094cad2a81dd3b158a9a12392ca27da655af2c5d05ee300735050b868024a23b4159f54e468ee8f9aae238c5345b8a3ca3b63cba769235e491ee533b30ecb979ad99680bf4d9629a8dd84a6a2da60956890d94222efabc9ca360844c85d6c6c2eb665ae84c28825a678efd3d4a029cce9c744757b8ca0b38f1e834fcac96cd7da4032a7cd0cf177d02f328498525cb04c9d80810b9edd18f6e81982415e6bf6f0586bf870587084611bd6728c9585e5c7135bb24a905473363e6a1a5532c9f25bd2311e2b0e237b8c946b2e1f94c1e1fcaf0b6075d4f358a14c13c444c4a16f40b37b1a7241ce49ff001027e69c5ad634c65d4876875dbc047140d0ba631a58de3b90d971e9c938c09cd151a72f1fee3252e4ceb6fc09eda340ba78023fdda9b754eb0832c6cf23f40bcbc8bfc4663297da568f6fb0dd37c3ce8179790cfa44bf97d7fe9283de45dc0d02c2f2c2115b86aaa97e3fdd7755e5e470ecaff1fb635b1f7d4c3dca9e6bcbc91214fb2b4b257979587a06f4375bdd7bcb0bc87d07d0fa7c12f71f79797962ecc5fb118525c6fe41797918644a4a2355e5e5c70d29531ecdda0db92587de1d565790a30778785be26c196604af2f2997ec491fd84966e39c6bc53ba462e694692e12bcbca89177f8b3ffd9	Белый	1	Рязанский-верховой
\.


--
-- TOC entry 2274 (class 0 OID 40987)
-- Dependencies: 200
-- Data for Name: placements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.placements (placement_id, date_time, pet_id, cage_id, is_a_start, comments) FROM stdin;
7	2020-09-21 00:00:00	14	4	t	Хомяк помещён в клетку
6	2020-11-22 00:00:00	10	4	t	Поймано и помещено
9	2020-07-12 00:00:00	17	7	t	 Попугай в клетке
8	2020-12-24 00:00:00	14	5	f	Удалён
5	2020-12-23 00:00:00	16	2	t	Пса в клетку 13
10	2020-12-25 00:00:00	16	2	t	Собаку выселили из клетки
11	2020-07-14 00:00:00	17	7	f	Попугая выселили!
12	2020-12-25 00:00:00	19	8	t	Крысу - в клетку
\.


--
-- TOC entry 2266 (class 0 OID 32810)
-- Dependencies: 192
-- Data for Name: providers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.providers (provider_id, company_name, contact_person, contact_email, contact_phone, adress, requisites) FROM stdin;
1	Питомник "Зверская жизнь"	Агубеков Агубек Рафаилович	guba@grozny.com	855533399	Улица боснийских промышленников д.4. строение 54 кв.А	ИНН: 234290-934-203945
3	Участок номер 19	Саулов Рашид Мавлентиевич	said_baba@chechnya.biz	4483828428	Улица Герцога саксонского	ОКАТО: 324534534
4	Фабрика "Зверь"	Фёдор Небесный	dobro@kaluga.list.ru	23423424006	ул. Павших охотников,3	ИНН: 12343838383
0	- Не задано	 	 	 	 	 
5	Птицеферма "Дерзкий попугай"	Артур Соколов	arti@popka.spb.ru	234-43200-03	Саратов ул.Зорге д.6 кв.1	ОКАТО:42042023402
\.


--
-- TOC entry 2280 (class 0 OID 41011)
-- Dependencies: 206
-- Data for Name: sexes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sexes (sex_id, sex_name) FROM stdin;
1	мужской
2	женский
3	гермафродит
0	- Не задано
\.


--
-- TOC entry 2268 (class 0 OID 32821)
-- Dependencies: 194
-- Data for Name: species; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.species (specie_id, specie_name) FROM stdin;
1	Морская свинка
2	Хомяк\n
3	Кошка
4	Собака
6	Улитка
7	Попугай
8	Канарейка
9	Пони
10	Крыса
5	Черепаха
13	Чудище
15	Панда
0	- Не задано
\.


--
-- TOC entry 2276 (class 0 OID 40995)
-- Dependencies: 202
-- Data for Name: supplies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.supplies (supply_id, date_time, provider_id, pet_id, price, comments) FROM stdin;
4	2020-01-01 00:00:00	4	10	1 100,00 ?	Отдали по договору  №138
5	2020-01-02 00:00:00	3	15	2 500,00 ?	Конфискат
6	2020-09-01 00:00:00	3	16	1 000,00 ?	По договору
9	2020-02-24 00:00:00	4	18	1 200,00 ?	Договор 19
8	2020-10-03 00:00:00	5	17	501,00 ?	Отдали остатки
\.


--
-- TOC entry 2270 (class 0 OID 40971)
-- Dependencies: 196
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions (transaction_id, date_time, customer_id, pet_id, amount) FROM stdin;
6	2019-01-12 00:00:00	5	14	12 000,00 ?
7	2020-12-23 00:00:00	6	16	34 000,00 ?
8	2020-12-24 00:00:00	9	18	120 005,00 ?
9	2020-12-20 00:00:00	9	15	23 000,00 ?
\.


--
-- TOC entry 2313 (class 0 OID 0)
-- Dependencies: 187
-- Name: cages_cage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cages_cage_id_seq', 8, true);


--
-- TOC entry 2314 (class 0 OID 0)
-- Dependencies: 189
-- Name: customers_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_customer_id_seq', 9, true);


--
-- TOC entry 2315 (class 0 OID 0)
-- Dependencies: 197
-- Name: feedinds_feeding_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.feedinds_feeding_id_seq', 14, true);


--
-- TOC entry 2316 (class 0 OID 0)
-- Dependencies: 203
-- Name: foods_food_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.foods_food_id_seq', 7, true);


--
-- TOC entry 2317 (class 0 OID 0)
-- Dependencies: 185
-- Name: pets_pet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pets_pet_id_seq', 19, true);


--
-- TOC entry 2318 (class 0 OID 0)
-- Dependencies: 199
-- Name: placements_placement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.placements_placement_id_seq', 12, true);


--
-- TOC entry 2319 (class 0 OID 0)
-- Dependencies: 191
-- Name: providers_provider_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.providers_provider_id_seq', 5, true);


--
-- TOC entry 2320 (class 0 OID 0)
-- Dependencies: 205
-- Name: sexes_sex_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sexes_sex_id_seq', 5, true);


--
-- TOC entry 2321 (class 0 OID 0)
-- Dependencies: 193
-- Name: species_specie_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.species_specie_id_seq', 15, true);


--
-- TOC entry 2322 (class 0 OID 0)
-- Dependencies: 201
-- Name: supplies_supply_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.supplies_supply_id_seq', 9, true);


--
-- TOC entry 2323 (class 0 OID 0)
-- Dependencies: 195
-- Name: transactions_transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transactions_transaction_id_seq', 9, true);


--
-- TOC entry 2107 (class 2606 OID 32796)
-- Name: cages cages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cages
    ADD CONSTRAINT cages_pkey PRIMARY KEY (cage_id);


--
-- TOC entry 2109 (class 2606 OID 32807)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- TOC entry 2117 (class 2606 OID 40984)
-- Name: feedings feedinds_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedings
    ADD CONSTRAINT feedinds_pkey PRIMARY KEY (feeding_id);


--
-- TOC entry 2123 (class 2606 OID 41008)
-- Name: foods foods_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foods
    ADD CONSTRAINT foods_pkey PRIMARY KEY (food_id);


--
-- TOC entry 2105 (class 2606 OID 32788)
-- Name: pets pets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pets
    ADD CONSTRAINT pets_pkey PRIMARY KEY (pet_id);


--
-- TOC entry 2119 (class 2606 OID 40992)
-- Name: placements placements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.placements
    ADD CONSTRAINT placements_pkey PRIMARY KEY (placement_id);


--
-- TOC entry 2111 (class 2606 OID 32818)
-- Name: providers providers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.providers
    ADD CONSTRAINT providers_pkey PRIMARY KEY (provider_id);


--
-- TOC entry 2125 (class 2606 OID 41016)
-- Name: sexes sexes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sexes
    ADD CONSTRAINT sexes_pkey PRIMARY KEY (sex_id);


--
-- TOC entry 2113 (class 2606 OID 32826)
-- Name: species species_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.species
    ADD CONSTRAINT species_pkey PRIMARY KEY (specie_id);


--
-- TOC entry 2121 (class 2606 OID 41000)
-- Name: supplies supplies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplies
    ADD CONSTRAINT supplies_pkey PRIMARY KEY (supply_id);


--
-- TOC entry 2115 (class 2606 OID 40976)
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transaction_id);


--
-- TOC entry 2128 (class 2606 OID 57378)
-- Name: customers Customer_sex_key; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT "Customer_sex_key" FOREIGN KEY (sex) REFERENCES public.sexes(sex_id) ON DELETE SET DEFAULT NOT VALID;


--
-- TOC entry 2324 (class 0 OID 0)
-- Dependencies: 2128
-- Name: CONSTRAINT "Customer_sex_key" ON customers; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON CONSTRAINT "Customer_sex_key" ON public.customers IS 'Связь таблицы покупателей и полов';


--
-- TOC entry 2132 (class 2606 OID 57390)
-- Name: feedings Feeding_food_key; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedings
    ADD CONSTRAINT "Feeding_food_key" FOREIGN KEY (food_id) REFERENCES public.foods(food_id) ON DELETE SET DEFAULT NOT VALID;


--
-- TOC entry 2325 (class 0 OID 0)
-- Dependencies: 2132
-- Name: CONSTRAINT "Feeding_food_key" ON feedings; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON CONSTRAINT "Feeding_food_key" ON public.feedings IS 'Связь таблицы кормления и корма';


--
-- TOC entry 2131 (class 2606 OID 57385)
-- Name: feedings Feeding_pet_key; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedings
    ADD CONSTRAINT "Feeding_pet_key" FOREIGN KEY (pet_id) REFERENCES public.pets(pet_id) ON DELETE SET DEFAULT NOT VALID;


--
-- TOC entry 2326 (class 0 OID 0)
-- Dependencies: 2131
-- Name: CONSTRAINT "Feeding_pet_key" ON feedings; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON CONSTRAINT "Feeding_pet_key" ON public.feedings IS 'Связь кормления и животного';


--
-- TOC entry 2127 (class 2606 OID 65555)
-- Name: pets Pet_sex_key; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pets
    ADD CONSTRAINT "Pet_sex_key" FOREIGN KEY (sex) REFERENCES public.sexes(sex_id) NOT VALID;


--
-- TOC entry 2327 (class 0 OID 0)
-- Dependencies: 2127
-- Name: CONSTRAINT "Pet_sex_key" ON pets; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON CONSTRAINT "Pet_sex_key" ON public.pets IS 'Связь таблицы животных и пола';


--
-- TOC entry 2126 (class 2606 OID 65545)
-- Name: pets Pet_specie_key; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pets
    ADD CONSTRAINT "Pet_specie_key" FOREIGN KEY (specie) REFERENCES public.species(specie_id) ON DELETE SET DEFAULT NOT VALID;


--
-- TOC entry 2328 (class 0 OID 0)
-- Dependencies: 2126
-- Name: CONSTRAINT "Pet_specie_key" ON pets; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON CONSTRAINT "Pet_specie_key" ON public.pets IS 'Cвязь Животного и Вида';


--
-- TOC entry 2134 (class 2606 OID 57401)
-- Name: placements Placement_cage_key; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.placements
    ADD CONSTRAINT "Placement_cage_key" FOREIGN KEY (cage_id) REFERENCES public.cages(cage_id) ON DELETE SET DEFAULT NOT VALID;


--
-- TOC entry 2329 (class 0 OID 0)
-- Dependencies: 2134
-- Name: CONSTRAINT "Placement_cage_key" ON placements; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON CONSTRAINT "Placement_cage_key" ON public.placements IS 'Связь таблицы Размещения и клеток';


--
-- TOC entry 2133 (class 2606 OID 57396)
-- Name: placements Placement_pet_key; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.placements
    ADD CONSTRAINT "Placement_pet_key" FOREIGN KEY (pet_id) REFERENCES public.pets(pet_id) ON DELETE SET DEFAULT NOT VALID;


--
-- TOC entry 2330 (class 0 OID 0)
-- Dependencies: 2133
-- Name: CONSTRAINT "Placement_pet_key" ON placements; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON CONSTRAINT "Placement_pet_key" ON public.placements IS 'Связь таблицы Размещения и животного';


--
-- TOC entry 2135 (class 2606 OID 57406)
-- Name: supplies Supplie_provider_key; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplies
    ADD CONSTRAINT "Supplie_provider_key" FOREIGN KEY (provider_id) REFERENCES public.providers(provider_id) ON DELETE SET DEFAULT NOT VALID;


--
-- TOC entry 2331 (class 0 OID 0)
-- Dependencies: 2135
-- Name: CONSTRAINT "Supplie_provider_key" ON supplies; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON CONSTRAINT "Supplie_provider_key" ON public.supplies IS 'Связь таблица Поставки с Поставщиком';


--
-- TOC entry 2136 (class 2606 OID 57413)
-- Name: supplies Supply_pet_key; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplies
    ADD CONSTRAINT "Supply_pet_key" FOREIGN KEY (pet_id) REFERENCES public.pets(pet_id) ON DELETE SET DEFAULT NOT VALID;


--
-- TOC entry 2332 (class 0 OID 0)
-- Dependencies: 2136
-- Name: CONSTRAINT "Supply_pet_key" ON supplies; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON CONSTRAINT "Supply_pet_key" ON public.supplies IS 'Связь таблицы Поставки с Животным';


--
-- TOC entry 2129 (class 2606 OID 57420)
-- Name: transactions Transaction_customer_key; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT "Transaction_customer_key" FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id) ON DELETE SET DEFAULT NOT VALID;


--
-- TOC entry 2333 (class 0 OID 0)
-- Dependencies: 2129
-- Name: CONSTRAINT "Transaction_customer_key" ON transactions; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON CONSTRAINT "Transaction_customer_key" ON public.transactions IS 'Связь таблицы Транзакций с покупателями';


--
-- TOC entry 2130 (class 2606 OID 57425)
-- Name: transactions Transaction_pet_key; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT "Transaction_pet_key" FOREIGN KEY (pet_id) REFERENCES public.pets(pet_id) ON DELETE SET DEFAULT NOT VALID;


--
-- TOC entry 2334 (class 0 OID 0)
-- Dependencies: 2130
-- Name: CONSTRAINT "Transaction_pet_key" ON transactions; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON CONSTRAINT "Transaction_pet_key" ON public.transactions IS 'Связь таблицы Транзакций с животными';


-- Completed on 2020-12-27 20:46:38

--
-- PostgreSQL database dump complete
--

