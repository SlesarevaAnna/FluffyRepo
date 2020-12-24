PGDMP             	            x            fluffy_friend    9.6.18    12.3 {    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    32777    fluffy_friend    DATABASE     �   CREATE DATABASE fluffy_friend WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Russian_Russia.1251' LC_CTYPE = 'Russian_Russia.1251';
    DROP DATABASE fluffy_friend;
                postgres    false            �           0    0    DATABASE fluffy_friend    COMMENT     q   COMMENT ON DATABASE fluffy_friend IS 'База данных зоомагазина "Пушистый друг"';
                   postgres    false    2281            �            1259    32780    pets    TABLE     3  CREATE TABLE public.pets (
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
    DROP TABLE public.pets;
       public            postgres    false            �           0    0 
   TABLE pets    COMMENT     C   COMMENT ON TABLE public.pets IS 'Таблица животных';
          public          postgres    false    186            �            1259    41011    sexes    TABLE     i   CREATE TABLE public.sexes (
    sex_id integer NOT NULL,
    sex_name character varying(100) NOT NULL
);
    DROP TABLE public.sexes;
       public            postgres    false            �           0    0    TABLE sexes    COMMENT     \   COMMENT ON TABLE public.sexes IS 'Таблица полов для Зоомагазина';
          public          postgres    false    206            �            1259    32821    species    TABLE     q   CREATE TABLE public.species (
    specie_id integer NOT NULL,
    specie_name character varying(100) NOT NULL
);
    DROP TABLE public.species;
       public            postgres    false            �           0    0    TABLE species    COMMENT     @   COMMENT ON TABLE public.species IS 'Виды животных';
          public          postgres    false    194            �            1259    40971    transactions    TABLE     �   CREATE TABLE public.transactions (
    transaction_id integer NOT NULL,
    date_time timestamp(0) without time zone NOT NULL,
    customer_id integer DEFAULT 0 NOT NULL,
    pet_id integer DEFAULT 0 NOT NULL,
    amount money NOT NULL
);
     DROP TABLE public.transactions;
       public            postgres    false            �           0    0    TABLE transactions    COMMENT     ~   COMMENT ON TABLE public.transactions IS 'Покупки (таблица взаимодействия с клиентами)';
          public          postgres    false    196            �            1259    41026    available_pets_view    VIEW     `  CREATE VIEW public.available_pets_view AS
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
  WHERE (NOT (pets.pet_id IN ( SELECT transactions.pet_id
           FROM public.transactions)));
 &   DROP VIEW public.available_pets_view;
       public          postgres    false    186    186    186    186    186    186    186    186    194    194    196    206    206            �           0    0    VIEW available_pets_view    COMMENT     �   COMMENT ON VIEW public.available_pets_view IS 'показывает всех доступных животных в продаже';
          public          postgres    false    207            �            1259    32791    cages    TABLE     �   CREATE TABLE public.cages (
    cage_id integer NOT NULL,
    number character varying(50),
    place character varying(100),
    dimentions character varying(50),
    has_drinker boolean,
    has_feader boolean,
    prefered_specie integer
);
    DROP TABLE public.cages;
       public            postgres    false            �           0    0    TABLE cages    COMMENT     n   COMMENT ON TABLE public.cages IS 'Клетки (и прочие помещения для питомцев)';
          public          postgres    false    188            �            1259    57357    cage_name_plus    VIEW     �  CREATE VIEW public.cage_name_plus AS
 SELECT cages.cage_id,
    (((((cages.number)::text || ' ('::text) || (cages.place)::text) || ') - '::text) || (species.specie_name)::text) AS name_plus
   FROM (public.cages
     LEFT JOIN public.species ON ((species.specie_id = cages.prefered_specie)))
  ORDER BY (((((cages.number)::text || ' '::text) || (cages.place)::text) || '-'::text) || (species.specie_name)::text);
 !   DROP VIEW public.cage_name_plus;
       public          postgres    false    194    194    188    188    188    188            �           0    0    VIEW cage_name_plus    COMMENT     i   COMMENT ON VIEW public.cage_name_plus IS 'Расширенное наименование клетки';
          public          postgres    false    210            �            1259    32789    cages_cage_id_seq    SEQUENCE     z   CREATE SEQUENCE public.cages_cage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.cages_cage_id_seq;
       public          postgres    false    188            �           0    0    cages_cage_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.cages_cage_id_seq OWNED BY public.cages.cage_id;
          public          postgres    false    187            �            1259    32799 	   customers    TABLE       CREATE TABLE public.customers (
    customer_id integer NOT NULL,
    name character varying(100) NOT NULL,
    surname character varying(100) NOT NULL,
    patronymic character varying(100),
    sex integer DEFAULT 0,
    birthday date,
    card_id bigint,
    photo bytea
);
    DROP TABLE public.customers;
       public            postgres    false            �           0    0    TABLE customers    COMMENT     T   COMMENT ON TABLE public.customers IS 'Покупатели зоомагазина';
          public          postgres    false    190            �            1259    57353    customer_name_plus    VIEW     j  CREATE VIEW public.customer_name_plus AS
 SELECT customers.customer_id,
    (((((customers.surname)::text || ' '::text) || (customers.name)::text) || ' '::text) || (customers.patronymic)::text) AS name_plus
   FROM public.customers
  ORDER BY (((((customers.surname)::text || ' '::text) || (customers.name)::text) || ' '::text) || (customers.patronymic)::text);
 %   DROP VIEW public.customer_name_plus;
       public          postgres    false    190    190    190    190            �           0    0    VIEW customer_name_plus    COMMENT     ]   COMMENT ON VIEW public.customer_name_plus IS 'Расширенное имя клиента';
          public          postgres    false    209            �            1259    32797    customers_customer_id_seq    SEQUENCE     �   CREATE SEQUENCE public.customers_customer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.customers_customer_id_seq;
       public          postgres    false    190            �           0    0    customers_customer_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.customers_customer_id_seq OWNED BY public.customers.customer_id;
          public          postgres    false    189            �            1259    40979    feedings    TABLE     �   CREATE TABLE public.feedings (
    feeding_id integer NOT NULL,
    pet_id integer DEFAULT 0 NOT NULL,
    food_id integer DEFAULT 0 NOT NULL,
    date_time timestamp(0) without time zone NOT NULL,
    weight real
);
    DROP TABLE public.feedings;
       public            postgres    false            �           0    0    TABLE feedings    COMMENT     Z   COMMENT ON TABLE public.feedings IS 'Таблица кормлений животных';
          public          postgres    false    198            �            1259    40977    feedinds_feeding_id_seq    SEQUENCE     �   CREATE SEQUENCE public.feedinds_feeding_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.feedinds_feeding_id_seq;
       public          postgres    false    198            �           0    0    feedinds_feeding_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.feedinds_feeding_id_seq OWNED BY public.feedings.feeding_id;
          public          postgres    false    197            �            1259    41003    foods    TABLE     �   CREATE TABLE public.foods (
    food_id integer NOT NULL,
    name character varying(100) NOT NULL,
    producer character varying(100)
);
    DROP TABLE public.foods;
       public            postgres    false            �           0    0    TABLE foods    COMMENT     @   COMMENT ON TABLE public.foods IS 'Таблица кормов';
          public          postgres    false    204            �            1259    41001    foods_food_id_seq    SEQUENCE     z   CREATE SEQUENCE public.foods_food_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.foods_food_id_seq;
       public          postgres    false    204            �           0    0    foods_food_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.foods_food_id_seq OWNED BY public.foods.food_id;
          public          postgres    false    203            �            1259    49161    pet_name_plus    VIEW     ,  CREATE VIEW public.pet_name_plus AS
 SELECT pets.pet_id,
    (((((species.specie_name)::text || ' '::text) || (pets.breed)::text) || ' - '::text) || (pets.nickname)::text) AS nick_plus
   FROM (public.pets
     LEFT JOIN public.species ON ((species.specie_id = pets.specie)))
  ORDER BY pets.pet_id;
     DROP VIEW public.pet_name_plus;
       public          postgres    false    186    186    194    194    186    186            �           0    0    VIEW pet_name_plus    COMMENT     �   COMMENT ON VIEW public.pet_name_plus IS 'Расширенные имена животных по идентификатору';
          public          postgres    false    208            �            1259    32778    pets_pet_id_seq    SEQUENCE     x   CREATE SEQUENCE public.pets_pet_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.pets_pet_id_seq;
       public          postgres    false    186            �           0    0    pets_pet_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.pets_pet_id_seq OWNED BY public.pets.pet_id;
          public          postgres    false    185            �            1259    40987 
   placements    TABLE     �   CREATE TABLE public.placements (
    placement_id integer NOT NULL,
    date_time timestamp(0) without time zone NOT NULL,
    pet_id integer NOT NULL,
    cage_id integer NOT NULL,
    is_a_start boolean NOT NULL,
    comments character varying(200)
);
    DROP TABLE public.placements;
       public            postgres    false            �           0    0    TABLE placements    COMMENT     ^   COMMENT ON TABLE public.placements IS 'Таблица размещения животных';
          public          postgres    false    200            �            1259    40985    placements_placement_id_seq    SEQUENCE     �   CREATE SEQUENCE public.placements_placement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.placements_placement_id_seq;
       public          postgres    false    200            �           0    0    placements_placement_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.placements_placement_id_seq OWNED BY public.placements.placement_id;
          public          postgres    false    199            �            1259    32810 	   providers    TABLE     >  CREATE TABLE public.providers (
    provider_id integer NOT NULL,
    company_name character varying(100) NOT NULL,
    contact_person character varying(200),
    contact_email character varying(100),
    contact_phone character varying(50),
    adress character varying(200),
    requisites character varying(200)
);
    DROP TABLE public.providers;
       public            postgres    false            �           0    0    TABLE providers    COMMENT     T   COMMENT ON TABLE public.providers IS 'Поставщики зоомагазина';
          public          postgres    false    192            �            1259    32808    providers_provider_id_seq    SEQUENCE     �   CREATE SEQUENCE public.providers_provider_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.providers_provider_id_seq;
       public          postgres    false    192            �           0    0    providers_provider_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.providers_provider_id_seq OWNED BY public.providers.provider_id;
          public          postgres    false    191            �            1259    41009    sexes_sex_id_seq    SEQUENCE     y   CREATE SEQUENCE public.sexes_sex_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.sexes_sex_id_seq;
       public          postgres    false    206             	           0    0    sexes_sex_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.sexes_sex_id_seq OWNED BY public.sexes.sex_id;
          public          postgres    false    205            �            1259    32819    species_specie_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.species_specie_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.species_specie_id_seq;
       public          postgres    false    194            	           0    0    species_specie_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.species_specie_id_seq OWNED BY public.species.specie_id;
          public          postgres    false    193            �            1259    40995    supplies    TABLE       CREATE TABLE public.supplies (
    supply_id integer NOT NULL,
    date_time timestamp(0) without time zone NOT NULL,
    provider_id integer DEFAULT 0 NOT NULL,
    pet_id integer DEFAULT 0 NOT NULL,
    price money,
    comments character varying(100)
);
    DROP TABLE public.supplies;
       public            postgres    false            	           0    0    TABLE supplies    COMMENT     X   COMMENT ON TABLE public.supplies IS 'Таблица поставок животных';
          public          postgres    false    202            �            1259    40993    supplies_supply_id_seq    SEQUENCE        CREATE SEQUENCE public.supplies_supply_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.supplies_supply_id_seq;
       public          postgres    false    202            	           0    0    supplies_supply_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.supplies_supply_id_seq OWNED BY public.supplies.supply_id;
          public          postgres    false    201            �            1259    40969    transactions_transaction_id_seq    SEQUENCE     �   CREATE SEQUENCE public.transactions_transaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.transactions_transaction_id_seq;
       public          postgres    false    196            	           0    0    transactions_transaction_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.transactions_transaction_id_seq OWNED BY public.transactions.transaction_id;
          public          postgres    false    195            #           2604    32794    cages cage_id    DEFAULT     n   ALTER TABLE ONLY public.cages ALTER COLUMN cage_id SET DEFAULT nextval('public.cages_cage_id_seq'::regclass);
 <   ALTER TABLE public.cages ALTER COLUMN cage_id DROP DEFAULT;
       public          postgres    false    187    188    188            $           2604    32802    customers customer_id    DEFAULT     ~   ALTER TABLE ONLY public.customers ALTER COLUMN customer_id SET DEFAULT nextval('public.customers_customer_id_seq'::regclass);
 D   ALTER TABLE public.customers ALTER COLUMN customer_id DROP DEFAULT;
       public          postgres    false    189    190    190            +           2604    40982    feedings feeding_id    DEFAULT     z   ALTER TABLE ONLY public.feedings ALTER COLUMN feeding_id SET DEFAULT nextval('public.feedinds_feeding_id_seq'::regclass);
 B   ALTER TABLE public.feedings ALTER COLUMN feeding_id DROP DEFAULT;
       public          postgres    false    198    197    198            2           2604    41006    foods food_id    DEFAULT     n   ALTER TABLE ONLY public.foods ALTER COLUMN food_id SET DEFAULT nextval('public.foods_food_id_seq'::regclass);
 <   ALTER TABLE public.foods ALTER COLUMN food_id DROP DEFAULT;
       public          postgres    false    203    204    204                        2604    32783    pets pet_id    DEFAULT     j   ALTER TABLE ONLY public.pets ALTER COLUMN pet_id SET DEFAULT nextval('public.pets_pet_id_seq'::regclass);
 :   ALTER TABLE public.pets ALTER COLUMN pet_id DROP DEFAULT;
       public          postgres    false    185    186    186            .           2604    40990    placements placement_id    DEFAULT     �   ALTER TABLE ONLY public.placements ALTER COLUMN placement_id SET DEFAULT nextval('public.placements_placement_id_seq'::regclass);
 F   ALTER TABLE public.placements ALTER COLUMN placement_id DROP DEFAULT;
       public          postgres    false    199    200    200            &           2604    32813    providers provider_id    DEFAULT     ~   ALTER TABLE ONLY public.providers ALTER COLUMN provider_id SET DEFAULT nextval('public.providers_provider_id_seq'::regclass);
 D   ALTER TABLE public.providers ALTER COLUMN provider_id DROP DEFAULT;
       public          postgres    false    191    192    192            3           2604    41014    sexes sex_id    DEFAULT     l   ALTER TABLE ONLY public.sexes ALTER COLUMN sex_id SET DEFAULT nextval('public.sexes_sex_id_seq'::regclass);
 ;   ALTER TABLE public.sexes ALTER COLUMN sex_id DROP DEFAULT;
       public          postgres    false    206    205    206            '           2604    32824    species specie_id    DEFAULT     v   ALTER TABLE ONLY public.species ALTER COLUMN specie_id SET DEFAULT nextval('public.species_specie_id_seq'::regclass);
 @   ALTER TABLE public.species ALTER COLUMN specie_id DROP DEFAULT;
       public          postgres    false    194    193    194            /           2604    40998    supplies supply_id    DEFAULT     x   ALTER TABLE ONLY public.supplies ALTER COLUMN supply_id SET DEFAULT nextval('public.supplies_supply_id_seq'::regclass);
 A   ALTER TABLE public.supplies ALTER COLUMN supply_id DROP DEFAULT;
       public          postgres    false    202    201    202            (           2604    40974    transactions transaction_id    DEFAULT     �   ALTER TABLE ONLY public.transactions ALTER COLUMN transaction_id SET DEFAULT nextval('public.transactions_transaction_id_seq'::regclass);
 J   ALTER TABLE public.transactions ALTER COLUMN transaction_id DROP DEFAULT;
       public          postgres    false    195    196    196            �          0    32791    cages 
   TABLE DATA           m   COPY public.cages (cage_id, number, place, dimentions, has_drinker, has_feader, prefered_specie) FROM stdin;
    public          postgres    false    188   �       �          0    32799 	   customers 
   TABLE DATA           j   COPY public.customers (customer_id, name, surname, patronymic, sex, birthday, card_id, photo) FROM stdin;
    public          postgres    false    190   ��       �          0    40979    feedings 
   TABLE DATA           R   COPY public.feedings (feeding_id, pet_id, food_id, date_time, weight) FROM stdin;
    public          postgres    false    198   �       �          0    41003    foods 
   TABLE DATA           8   COPY public.foods (food_id, name, producer) FROM stdin;
    public          postgres    false    204   	�       �          0    32780    pets 
   TABLE DATA           j   COPY public.pets (pet_id, specie, nickname, birthday, price, notes, photo, color, sex, breed) FROM stdin;
    public          postgres    false    186   �       �          0    40987 
   placements 
   TABLE DATA           d   COPY public.placements (placement_id, date_time, pet_id, cage_id, is_a_start, comments) FROM stdin;
    public          postgres    false    200   �       �          0    32810 	   providers 
   TABLE DATA           �   COPY public.providers (provider_id, company_name, contact_person, contact_email, contact_phone, adress, requisites) FROM stdin;
    public          postgres    false    192   A�       �          0    41011    sexes 
   TABLE DATA           1   COPY public.sexes (sex_id, sex_name) FROM stdin;
    public          postgres    false    206   ��       �          0    32821    species 
   TABLE DATA           9   COPY public.species (specie_id, specie_name) FROM stdin;
    public          postgres    false    194   ^�       �          0    40995    supplies 
   TABLE DATA           ^   COPY public.supplies (supply_id, date_time, provider_id, pet_id, price, comments) FROM stdin;
    public          postgres    false    202   �       �          0    40971    transactions 
   TABLE DATA           ^   COPY public.transactions (transaction_id, date_time, customer_id, pet_id, amount) FROM stdin;
    public          postgres    false    196   7�       	           0    0    cages_cage_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.cages_cage_id_seq', 4, true);
          public          postgres    false    187            	           0    0    customers_customer_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.customers_customer_id_seq', 5, true);
          public          postgres    false    189            	           0    0    feedinds_feeding_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.feedinds_feeding_id_seq', 7, true);
          public          postgres    false    197            	           0    0    foods_food_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.foods_food_id_seq', 3, true);
          public          postgres    false    203            		           0    0    pets_pet_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.pets_pet_id_seq', 15, true);
          public          postgres    false    185            
	           0    0    placements_placement_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.placements_placement_id_seq', 4, true);
          public          postgres    false    199            	           0    0    providers_provider_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.providers_provider_id_seq', 4, true);
          public          postgres    false    191            	           0    0    sexes_sex_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.sexes_sex_id_seq', 5, true);
          public          postgres    false    205            	           0    0    species_specie_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.species_specie_id_seq', 15, true);
          public          postgres    false    193            	           0    0    supplies_supply_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.supplies_supply_id_seq', 3, true);
          public          postgres    false    201            	           0    0    transactions_transaction_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.transactions_transaction_id_seq', 5, true);
          public          postgres    false    195            7           2606    32796    cages cages_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.cages
    ADD CONSTRAINT cages_pkey PRIMARY KEY (cage_id);
 :   ALTER TABLE ONLY public.cages DROP CONSTRAINT cages_pkey;
       public            postgres    false    188            9           2606    32807    customers customers_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);
 B   ALTER TABLE ONLY public.customers DROP CONSTRAINT customers_pkey;
       public            postgres    false    190            A           2606    40984    feedings feedinds_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.feedings
    ADD CONSTRAINT feedinds_pkey PRIMARY KEY (feeding_id);
 @   ALTER TABLE ONLY public.feedings DROP CONSTRAINT feedinds_pkey;
       public            postgres    false    198            G           2606    41008    foods foods_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.foods
    ADD CONSTRAINT foods_pkey PRIMARY KEY (food_id);
 :   ALTER TABLE ONLY public.foods DROP CONSTRAINT foods_pkey;
       public            postgres    false    204            5           2606    32788    pets pets_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.pets
    ADD CONSTRAINT pets_pkey PRIMARY KEY (pet_id);
 8   ALTER TABLE ONLY public.pets DROP CONSTRAINT pets_pkey;
       public            postgres    false    186            C           2606    40992    placements placements_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.placements
    ADD CONSTRAINT placements_pkey PRIMARY KEY (placement_id);
 D   ALTER TABLE ONLY public.placements DROP CONSTRAINT placements_pkey;
       public            postgres    false    200            ;           2606    32818    providers providers_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.providers
    ADD CONSTRAINT providers_pkey PRIMARY KEY (provider_id);
 B   ALTER TABLE ONLY public.providers DROP CONSTRAINT providers_pkey;
       public            postgres    false    192            I           2606    41016    sexes sexes_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.sexes
    ADD CONSTRAINT sexes_pkey PRIMARY KEY (sex_id);
 :   ALTER TABLE ONLY public.sexes DROP CONSTRAINT sexes_pkey;
       public            postgres    false    206            =           2606    32826    species species_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.species
    ADD CONSTRAINT species_pkey PRIMARY KEY (specie_id);
 >   ALTER TABLE ONLY public.species DROP CONSTRAINT species_pkey;
       public            postgres    false    194            E           2606    41000    supplies supplies_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.supplies
    ADD CONSTRAINT supplies_pkey PRIMARY KEY (supply_id);
 @   ALTER TABLE ONLY public.supplies DROP CONSTRAINT supplies_pkey;
       public            postgres    false    202            ?           2606    40976    transactions transactions_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transaction_id);
 H   ALTER TABLE ONLY public.transactions DROP CONSTRAINT transactions_pkey;
       public            postgres    false    196            L           2606    57378    customers Customer_sex_key    FK CONSTRAINT     �   ALTER TABLE ONLY public.customers
    ADD CONSTRAINT "Customer_sex_key" FOREIGN KEY (sex) REFERENCES public.sexes(sex_id) ON DELETE SET DEFAULT NOT VALID;
 F   ALTER TABLE ONLY public.customers DROP CONSTRAINT "Customer_sex_key";
       public          postgres    false    190    206    2121            	           0    0 *   CONSTRAINT "Customer_sex_key" ON customers    COMMENT     �   COMMENT ON CONSTRAINT "Customer_sex_key" ON public.customers IS 'Связь таблицы покупателей и полов';
          public          postgres    false    2124            P           2606    57390    feedings Feeding_food_key    FK CONSTRAINT     �   ALTER TABLE ONLY public.feedings
    ADD CONSTRAINT "Feeding_food_key" FOREIGN KEY (food_id) REFERENCES public.foods(food_id) ON DELETE SET DEFAULT NOT VALID;
 E   ALTER TABLE ONLY public.feedings DROP CONSTRAINT "Feeding_food_key";
       public          postgres    false    204    198    2119            	           0    0 )   CONSTRAINT "Feeding_food_key" ON feedings    COMMENT     }   COMMENT ON CONSTRAINT "Feeding_food_key" ON public.feedings IS 'Связь таблицы кормления и корма';
          public          postgres    false    2128            O           2606    57385    feedings Feeding_pet_key    FK CONSTRAINT     �   ALTER TABLE ONLY public.feedings
    ADD CONSTRAINT "Feeding_pet_key" FOREIGN KEY (pet_id) REFERENCES public.pets(pet_id) ON DELETE SET DEFAULT NOT VALID;
 D   ALTER TABLE ONLY public.feedings DROP CONSTRAINT "Feeding_pet_key";
       public          postgres    false    198    186    2101            	           0    0 (   CONSTRAINT "Feeding_pet_key" ON feedings    COMMENT     u   COMMENT ON CONSTRAINT "Feeding_pet_key" ON public.feedings IS 'Связь кормления и животного';
          public          postgres    false    2127            K           2606    65555    pets Pet_sex_key    FK CONSTRAINT     {   ALTER TABLE ONLY public.pets
    ADD CONSTRAINT "Pet_sex_key" FOREIGN KEY (sex) REFERENCES public.sexes(sex_id) NOT VALID;
 <   ALTER TABLE ONLY public.pets DROP CONSTRAINT "Pet_sex_key";
       public          postgres    false    206    2121    186            	           0    0     CONSTRAINT "Pet_sex_key" ON pets    COMMENT     p   COMMENT ON CONSTRAINT "Pet_sex_key" ON public.pets IS 'Связь таблицы животных и пола';
          public          postgres    false    2123            J           2606    65545    pets Pet_specie_key    FK CONSTRAINT     �   ALTER TABLE ONLY public.pets
    ADD CONSTRAINT "Pet_specie_key" FOREIGN KEY (specie) REFERENCES public.species(specie_id) ON DELETE SET DEFAULT NOT VALID;
 ?   ALTER TABLE ONLY public.pets DROP CONSTRAINT "Pet_specie_key";
       public          postgres    false    2109    186    194            	           0    0 #   CONSTRAINT "Pet_specie_key" ON pets    COMMENT     e   COMMENT ON CONSTRAINT "Pet_specie_key" ON public.pets IS 'Cвязь Животного и Вида';
          public          postgres    false    2122            R           2606    57401    placements Placement_cage_key    FK CONSTRAINT     �   ALTER TABLE ONLY public.placements
    ADD CONSTRAINT "Placement_cage_key" FOREIGN KEY (cage_id) REFERENCES public.cages(cage_id) ON DELETE SET DEFAULT NOT VALID;
 I   ALTER TABLE ONLY public.placements DROP CONSTRAINT "Placement_cage_key";
       public          postgres    false    188    2103    200            	           0    0 -   CONSTRAINT "Placement_cage_key" ON placements    COMMENT     �   COMMENT ON CONSTRAINT "Placement_cage_key" ON public.placements IS 'Связь таблицы Размещения и клеток';
          public          postgres    false    2130            Q           2606    57396    placements Placement_pet_key    FK CONSTRAINT     �   ALTER TABLE ONLY public.placements
    ADD CONSTRAINT "Placement_pet_key" FOREIGN KEY (pet_id) REFERENCES public.pets(pet_id) ON DELETE SET DEFAULT NOT VALID;
 H   ALTER TABLE ONLY public.placements DROP CONSTRAINT "Placement_pet_key";
       public          postgres    false    2101    200    186            	           0    0 ,   CONSTRAINT "Placement_pet_key" ON placements    COMMENT     �   COMMENT ON CONSTRAINT "Placement_pet_key" ON public.placements IS 'Связь таблицы Размещения и животного';
          public          postgres    false    2129            S           2606    57406    supplies Supplie_provider_key    FK CONSTRAINT     �   ALTER TABLE ONLY public.supplies
    ADD CONSTRAINT "Supplie_provider_key" FOREIGN KEY (provider_id) REFERENCES public.providers(provider_id) ON DELETE SET DEFAULT NOT VALID;
 I   ALTER TABLE ONLY public.supplies DROP CONSTRAINT "Supplie_provider_key";
       public          postgres    false    2107    192    202            	           0    0 -   CONSTRAINT "Supplie_provider_key" ON supplies    COMMENT     �   COMMENT ON CONSTRAINT "Supplie_provider_key" ON public.supplies IS 'Связь таблица Поставки с Поставщиком';
          public          postgres    false    2131            T           2606    57413    supplies Supply_pet_key    FK CONSTRAINT     �   ALTER TABLE ONLY public.supplies
    ADD CONSTRAINT "Supply_pet_key" FOREIGN KEY (pet_id) REFERENCES public.pets(pet_id) ON DELETE SET DEFAULT NOT VALID;
 C   ALTER TABLE ONLY public.supplies DROP CONSTRAINT "Supply_pet_key";
       public          postgres    false    186    2101    202            	           0    0 '   CONSTRAINT "Supply_pet_key" ON supplies    COMMENT        COMMENT ON CONSTRAINT "Supply_pet_key" ON public.supplies IS 'Связь таблицы Поставки с Животным';
          public          postgres    false    2132            M           2606    57420 %   transactions Transaction_customer_key    FK CONSTRAINT     �   ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT "Transaction_customer_key" FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id) ON DELETE SET DEFAULT NOT VALID;
 Q   ALTER TABLE ONLY public.transactions DROP CONSTRAINT "Transaction_customer_key";
       public          postgres    false    190    196    2105            	           0    0 5   CONSTRAINT "Transaction_customer_key" ON transactions    COMMENT     �   COMMENT ON CONSTRAINT "Transaction_customer_key" ON public.transactions IS 'Связь таблицы Транзакций с покупателями';
          public          postgres    false    2125            N           2606    57425     transactions Transaction_pet_key    FK CONSTRAINT     �   ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT "Transaction_pet_key" FOREIGN KEY (pet_id) REFERENCES public.pets(pet_id) ON DELETE SET DEFAULT NOT VALID;
 L   ALTER TABLE ONLY public.transactions DROP CONSTRAINT "Transaction_pet_key";
       public          postgres    false    2101    196    186            	           0    0 0   CONSTRAINT "Transaction_pet_key" ON transactions    COMMENT     �   COMMENT ON CONSTRAINT "Transaction_pet_key" ON public.transactions IS 'Связь таблицы Транзакций с животными';
          public          postgres    false    2126            �   �   x�]��	�@��3Ul��]E����S����x�d!(		�-���7x����{?&�����zF��
�1Hk��]��4KJ��	+^mfq*Qvp�=�%m�����t<h�h��6JG4k���{��_s��3Y8q+�+x��Em7��y?Z#      �   N   x�3�0����.6\�|aǅ���_�wa��]@r煹6\l��Ĺ��b;�!����������!g�q��qqq �#�      �      x������ � �      �   �   x�m�M
�0���)�t#�\���CQ�"��T�ii�V�0�FN��,�7y3�N:�G:��Ƈ�
\���-�VgTj��W�JE8�'!�)��
o�
�.���\k&]&�x�=;2ءNyNgW��2FP��Io;6���C�9<\/t��H�d���_��B��*�_d��2�E�d��dg1�Qq�#vҷ�� k�ª      �   �   x�=�MN�0���S� �c��p���B����H�G*m-H�t����n�������	*���fp��^q�Zk���B-alc�7��^���涠v�k�l��A��O���E'A�榳g�4�9�|�TT�����Ǉl��J`�=�|6�{�r���)���[��d[�T��dɞJ��9�imY����(g���X��D
�����H��J�Ф�tI�F*�u6"~Yz��St� ��s��q�      �   G   x�3�4202�50�50R00�#NCSNc���/컰��֋��^�{a����xaǅ�{��}\1z\\\ <��      �   �  x�U��n�@���uMG�g��� H�IQQ)m�*I�"Q��h��p�����W8��83iKь-������4�b&#���f��|��d�9Jy��[,���9&r�T��?4���%��([��v�Y��{���=��QY����<W������lPSЏp�gr��G~29�SfV���S㌖��BRB�N�f���\�.p���<^ͭ[Mb��4����:�| �np��,�L��=��B��rR�q��l�l�lm�jmn����W�e6K2�d��~������-1�f�a���V��gz{��5m�Z�#�p��"{�'���Z�cJ#��?臭�Nmt�����b��.�Vgg����;�������F�:��z�k9�3���3��j��6+���Ӽ$%�K��+za�(�z=Z�      �   R   x��K�0@��
>v���@K!m5�uD�i��d�^
�B����5F���L��^-\D[�|Í����ZU� ��2�      �   �   x�%���0D��*R�@����!��@rG ���@,�@��16���7��N�|�Wh`|�px¡RF
wt��M����.z�+�L�S�>p~�L�B���H�2Y�^�sXԑZ��N�� �8�#�B	ɞ�-W��K�U�����ph��2}�M�榊�N���� � �i      �      x������ � �      �      x������ � �     