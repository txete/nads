-- En colab no funcionan muchas cosas del squema que si podemos ejecutar por pgadmin
-- Voy a comentarlas para que no se rompa aunque la maquina quede mas pobre

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.9 (Ubuntu 14.9-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 15.3

-- Started on 2023-09-28 17:56:39

-- SET statement_timeout = 0;
-- SET lock_timeout = 0;
-- SET idle_in_transaction_session_timeout = 0;
-- SET client_encoding = 'UTF8';
-- SET standard_conforming_strings = on;
-- -- SELECT pg_catalog.set_config('search_path', '', false);
-- SET check_function_bodies = false;
-- SET xmloption = content;
-- SET client_min_messages = warning;
-- SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 41423)
-- Name: netflix; Type: SCHEMA; Schema: -; Owner: postgres
--

-- CREATE SCHEMA netflix;


-- ALTER SCHEMA netflix OWNER TO postgres;

--
-- TOC entry 6 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


-- ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 224 (class 1255 OID 41424)
-- Name: function_after_update_rating(); Type: FUNCTION; Schema: netflix; Owner: postgres
--

CREATE FUNCTION netflix.function_after_update_rating() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
	UPDATE netflix.movie
	SET avg_rating = (SELECT avg(CASE WHEN r.rating = TRUE THEN 1 ELSE 0 END) * 100
					   		FROM netflix.rating r WHERE r.id_movie = new.id_movie)
	WHERE id_movie = new.id_movie;
	RETURN null;
END;$$;


ALTER FUNCTION netflix.function_after_update_rating() OWNER TO postgres;

--
-- TOC entry 3404 (class 0 OID 0)
-- Dependencies: 224
-- Name: FUNCTION function_after_update_rating(); Type: COMMENT; Schema: netflix; Owner: postgres
--

COMMENT ON FUNCTION netflix.function_after_update_rating() IS 'function to update the average rating of a movie after updating a rating';


--
-- TOC entry 236 (class 1255 OID 41425)
-- Name: insert_ad(character varying, real, boolean, smallint, integer[]); Type: PROCEDURE; Schema: netflix; Owner: postgres
--

CREATE PROCEDURE netflix.insert_ad(IN _ad_description character varying, IN _ad_budget real, IN _ad_is_active boolean, IN _aprox_rating smallint, IN _genre_ids integer[])
    LANGUAGE plpgsql
    AS $$DECLARE
	inserted_id integer;
	_id integer;
	
BEGIN
INSERT INTO netflix.ad(ad_description, ad_budget, ad_is_active, aprox_rating)
	VALUES (_ad_description, _ad_budget, _ad_is_active, _aprox_rating)
	RETURNING ad_id INTO inserted_id ;


FOREACH _id IN ARRAY _genre_ids
LOOP
	INSERT INTO netflix.ad_genre(ad_id, id_genre)
		VALUES (inserted_id, _id);
END LOOP;
END;$$;


ALTER PROCEDURE netflix.insert_ad(IN _ad_description character varying, IN _ad_budget real, IN _ad_is_active boolean, IN _aprox_rating smallint, IN _genre_ids integer[]) OWNER TO postgres;

--
-- TOC entry 237 (class 1255 OID 41426)
-- Name: insert_movie(character varying, character varying); Type: PROCEDURE; Schema: netflix; Owner: postgres
--

CREATE PROCEDURE netflix.insert_movie(IN _title character varying, IN _description character varying)
    LANGUAGE sql
    AS $$INSERT INTO netflix.movie(title, description)
VALUES (_title, _description);$$;


ALTER PROCEDURE netflix.insert_movie(IN _title character varying, IN _description character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 210 (class 1259 OID 41427)
-- Name: ad; Type: TABLE; Schema: netflix; Owner: postgres
--

CREATE TABLE netflix.ad (
    ad_id integer NOT NULL,
    ad_description character varying NOT NULL,
    ad_budget real DEFAULT 0 NOT NULL,
    ad_is_active boolean DEFAULT false NOT NULL,
    aprox_rating smallint
);


ALTER TABLE netflix.ad OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 41434)
-- Name: ad_genre; Type: TABLE; Schema: netflix; Owner: postgres
--

CREATE TABLE netflix.ad_genre (
    ad_id integer NOT NULL,
    genre_id integer NOT NULL
);


ALTER TABLE netflix.ad_genre OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 41437)
-- Name: ads_ad_id_seq; Type: SEQUENCE; Schema: netflix; Owner: postgres
--

ALTER TABLE netflix.ad ALTER COLUMN ad_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME netflix.ads_ad_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 213 (class 1259 OID 41438)
-- Name: genre; Type: TABLE; Schema: netflix; Owner: postgres
--

CREATE TABLE netflix.genre (
    genre_id integer NOT NULL,
    genre character varying NOT NULL
);


ALTER TABLE netflix.genre OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 41443)
-- Name: genre_id_genre_seq; Type: SEQUENCE; Schema: netflix; Owner: postgres
--

ALTER TABLE netflix.genre ALTER COLUMN genre_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME netflix.genre_id_genre_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 215 (class 1259 OID 41444)
-- Name: movie; Type: TABLE; Schema: netflix; Owner: postgres
--

CREATE TABLE netflix.movie (
    movie_id integer NOT NULL,
    title character varying NOT NULL,
    description character varying,
    avg_rating smallint,
    plays integer
);


ALTER TABLE netflix.movie OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 41449)
-- Name: movie_genre; Type: TABLE; Schema: netflix; Owner: postgres
--

CREATE TABLE netflix.movie_genre (
    movie_id integer NOT NULL,
    genre_id integer NOT NULL
);


ALTER TABLE netflix.movie_genre OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 41452)
-- Name: movie_id_movie_seq; Type: SEQUENCE; Schema: netflix; Owner: postgres
--

ALTER TABLE netflix.movie ALTER COLUMN movie_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME netflix.movie_id_movie_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 218 (class 1259 OID 41453)
-- Name: playlist; Type: TABLE; Schema: netflix; Owner: postgres
--

CREATE TABLE netflix.playlist (
    playlist_id integer NOT NULL,
    viewer_id integer NOT NULL,
    playlist_name character varying
);


ALTER TABLE netflix.playlist OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 41458)
-- Name: playlist_id_playlist_seq; Type: SEQUENCE; Schema: netflix; Owner: postgres
--

ALTER TABLE netflix.playlist ALTER COLUMN playlist_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME netflix.playlist_id_playlist_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 220 (class 1259 OID 41459)
-- Name: playlist_movie; Type: TABLE; Schema: netflix; Owner: postgres
--

CREATE TABLE netflix.playlist_movie (
    playlist_id integer NOT NULL,
    movie_id integer NOT NULL
);


ALTER TABLE netflix.playlist_movie OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 41462)
-- Name: rating; Type: TABLE; Schema: netflix; Owner: postgres
--

CREATE TABLE netflix.rating (
    viewer_id integer NOT NULL,
    movie_id integer NOT NULL,
    rating boolean
);


ALTER TABLE netflix.rating OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 41465)
-- Name: viewer; Type: TABLE; Schema: netflix; Owner: postgres
--

CREATE TABLE netflix.viewer (
    viewer_id integer NOT NULL,
    username character varying NOT NULL,
    password character varying NOT NULL
);


ALTER TABLE netflix.viewer OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 41470)
-- Name: user_id_user_seq; Type: SEQUENCE; Schema: netflix; Owner: postgres
--

ALTER TABLE netflix.viewer ALTER COLUMN viewer_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME netflix.user_id_user_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 3384 (class 0 OID 41427)
-- Dependencies: 210
-- Data for Name: ad; Type: TABLE DATA; Schema: netflix; Owner: postgres
--

COPY netflix.ad (ad_id, ad_description, ad_budget, ad_is_active, aprox_rating) FROM stdin;
1	Ad 1	1000	t	4
2	Ad 2	500	f	3
3	Ad 3	750	t	5
4	Ad 4	2000	t	4
5	Ad 5	1500	f	2
\.


--
-- TOC entry 3385 (class 0 OID 41434)
-- Dependencies: 211
-- Data for Name: ad_genre; Type: TABLE DATA; Schema: netflix; Owner: postgres
--

COPY netflix.ad_genre (ad_id, genre_id) FROM stdin;
1	1
1	3
2	2
3	1
3	3
4	1
4	4
5	2
5	5
\.


--
-- TOC entry 3387 (class 0 OID 41438)
-- Dependencies: 213
-- Data for Name: genre; Type: TABLE DATA; Schema: netflix; Owner: postgres
--

COPY netflix.genre (genre_id, genre) FROM stdin;
1	Action
2	Comedy
3	Drama
4	Horror
5	Romance
\.


--
-- TOC entry 3389 (class 0 OID 41444)
-- Dependencies: 215
-- Data for Name: movie; Type: TABLE DATA; Schema: netflix; Owner: postgres
--

COPY netflix.movie (movie_id, title, description, avg_rating, plays) FROM stdin;
4	The Godfather: Part II	The early life and career of Vito Corleone in 1920s New York City is portrayed, while his son, Michael, expands and tightens his grip on the family crime syndicate.	9	850000
5	12 Angry Men	A jury holdout attempts to prevent a miscarriage of justice by forcing his colleagues to reconsider the evidence.	8	700000
1	The Shawshank Redemption	Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.	80	1000000
2	The Godfather	The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.	60	900000
3	The Dark Knight	When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.	60	800000
\.


--
-- TOC entry 3390 (class 0 OID 41449)
-- Dependencies: 216
-- Data for Name: movie_genre; Type: TABLE DATA; Schema: netflix; Owner: postgres
--

COPY netflix.movie_genre (movie_id, genre_id) FROM stdin;
1	1
1	3
2	1
2	3
3	1
3	4
4	1
4	3
4	4
5	2
5	3
\.


--
-- TOC entry 3392 (class 0 OID 41453)
-- Dependencies: 218
-- Data for Name: playlist; Type: TABLE DATA; Schema: netflix; Owner: postgres
--

COPY netflix.playlist (playlist_id, viewer_id, playlist_name) FROM stdin;
1	1	Favorites
2	1	Watch Later
3	2	Comedy
4	2	Drama
5	3	Horror
\.


--
-- TOC entry 3394 (class 0 OID 41459)
-- Dependencies: 220
-- Data for Name: playlist_movie; Type: TABLE DATA; Schema: netflix; Owner: postgres
--

COPY netflix.playlist_movie (playlist_id, movie_id) FROM stdin;
1	1
1	2
1	3
2	4
2	5
3	2
3	5
4	1
4	3
4	4
5	2
5	4
5	5
\.


--
-- TOC entry 3395 (class 0 OID 41462)
-- Dependencies: 221
-- Data for Name: rating; Type: TABLE DATA; Schema: netflix; Owner: postgres
--

COPY netflix.rating (viewer_id, movie_id, rating) FROM stdin;
1	1	t
1	2	t
1	3	f
2	1	t
2	2	f
2	3	t
3	1	f
3	2	t
3	3	t
4	1	t
4	2	f
4	3	f
5	1	t
5	2	t
5	3	t
\.


--
-- TOC entry 3396 (class 0 OID 41465)
-- Dependencies: 222
-- Data for Name: viewer; Type: TABLE DATA; Schema: netflix; Owner: postgres
--

COPY netflix.viewer (viewer_id, username, password) FROM stdin;
1	john_doe	password123
2	jane_doe	qwertyuiop
3	bob_smith	letmein
4	alice_jones	password
5	sam_wilson	123456
\.


--
-- TOC entry 3405 (class 0 OID 0)
-- Dependencies: 212
-- Name: ads_ad_id_seq; Type: SEQUENCE SET; Schema: netflix; Owner: postgres
--

-- SELECT pg_catalog.setval('netflix.ads_ad_id_seq', 5, true);


--
-- TOC entry 3406 (class 0 OID 0)
-- Dependencies: 214
-- Name: genre_id_genre_seq; Type: SEQUENCE SET; Schema: netflix; Owner: postgres
--

-- SELECT pg_catalog.setval('netflix.genre_id_genre_seq', 5, true);


--
-- TOC entry 3407 (class 0 OID 0)
-- Dependencies: 217
-- Name: movie_id_movie_seq; Type: SEQUENCE SET; Schema: netflix; Owner: postgres
--

-- SELECT pg_catalog.setval('netflix.movie_id_movie_seq', 5, true);


--
-- TOC entry 3408 (class 0 OID 0)
-- Dependencies: 219
-- Name: playlist_id_playlist_seq; Type: SEQUENCE SET; Schema: netflix; Owner: postgres
--

-- SELECT pg_catalog.setval('netflix.playlist_id_playlist_seq', 5, true);


--
-- TOC entry 3409 (class 0 OID 0)
-- Dependencies: 223
-- Name: user_id_user_seq; Type: SEQUENCE SET; Schema: netflix; Owner: postgres
--

-- SELECT pg_catalog.setval('netflix.user_id_user_seq', 5, true);


--
-- TOC entry 3216 (class 2606 OID 41472)
-- Name: ad_genre ad_genre_pkey; Type: CONSTRAINT; Schema: netflix; Owner: postgres
--

ALTER TABLE ONLY netflix.ad_genre
    ADD CONSTRAINT ad_genre_pkey PRIMARY KEY (ad_id, genre_id);


--
-- TOC entry 3214 (class 2606 OID 41474)
-- Name: ad ad_pkey; Type: CONSTRAINT; Schema: netflix; Owner: postgres
--

ALTER TABLE ONLY netflix.ad
    ADD CONSTRAINT ad_pkey PRIMARY KEY (ad_id);


--
-- TOC entry 3218 (class 2606 OID 41476)
-- Name: genre genre_name; Type: CONSTRAINT; Schema: netflix; Owner: postgres
--

ALTER TABLE ONLY netflix.genre
    ADD CONSTRAINT genre_name UNIQUE (genre);


--
-- TOC entry 3220 (class 2606 OID 41478)
-- Name: genre genre_pkey; Type: CONSTRAINT; Schema: netflix; Owner: postgres
--

ALTER TABLE ONLY netflix.genre
    ADD CONSTRAINT genre_pkey PRIMARY KEY (genre_id);


--
-- TOC entry 3224 (class 2606 OID 41480)
-- Name: movie_genre movie_genre_pkey; Type: CONSTRAINT; Schema: netflix; Owner: postgres
--

ALTER TABLE ONLY netflix.movie_genre
    ADD CONSTRAINT movie_genre_pkey PRIMARY KEY (movie_id, genre_id);


--
-- TOC entry 3222 (class 2606 OID 41482)
-- Name: movie movie_pkey; Type: CONSTRAINT; Schema: netflix; Owner: postgres
--

ALTER TABLE ONLY netflix.movie
    ADD CONSTRAINT movie_pkey PRIMARY KEY (movie_id);


--
-- TOC entry 3228 (class 2606 OID 41484)
-- Name: playlist_movie playlist_movie_pkey; Type: CONSTRAINT; Schema: netflix; Owner: postgres
--

ALTER TABLE ONLY netflix.playlist_movie
    ADD CONSTRAINT playlist_movie_pkey PRIMARY KEY (movie_id, playlist_id);


--
-- TOC entry 3226 (class 2606 OID 41486)
-- Name: playlist playlist_pkey; Type: CONSTRAINT; Schema: netflix; Owner: postgres
--

ALTER TABLE ONLY netflix.playlist
    ADD CONSTRAINT playlist_pkey PRIMARY KEY (playlist_id);


--
-- TOC entry 3230 (class 2606 OID 41488)
-- Name: rating rating_pkey; Type: CONSTRAINT; Schema: netflix; Owner: postgres
--

ALTER TABLE ONLY netflix.rating
    ADD CONSTRAINT rating_pkey PRIMARY KEY (viewer_id, movie_id);


--
-- TOC entry 3232 (class 2606 OID 41492)
-- Name: viewer username; Type: CONSTRAINT; Schema: netflix; Owner: postgres
--

ALTER TABLE ONLY netflix.viewer
    ADD CONSTRAINT username UNIQUE (username);


--
-- TOC entry 3234 (class 2606 OID 41490)
-- Name: viewer viewer_pkey; Type: CONSTRAINT; Schema: netflix; Owner: postgres
--

ALTER TABLE ONLY netflix.viewer
    ADD CONSTRAINT viewer_pkey PRIMARY KEY (viewer_id);


--
-- TOC entry 3244 (class 2620 OID 41493)
-- Name: rating trigger_after_update_rating; Type: TRIGGER; Schema: netflix; Owner: postgres
--

CREATE TRIGGER trigger_after_update_rating AFTER INSERT OR UPDATE OF rating ON netflix.rating FOR EACH ROW EXECUTE FUNCTION netflix.function_after_update_rating();


--
-- TOC entry 3235 (class 2606 OID 41494)
-- Name: ad_genre fk_ad_genre; Type: FK CONSTRAINT; Schema: netflix; Owner: postgres
--

ALTER TABLE ONLY netflix.ad_genre
    ADD CONSTRAINT fk_ad_genre FOREIGN KEY (ad_id) REFERENCES netflix.ad(ad_id);


--
-- TOC entry 3236 (class 2606 OID 41499)
-- Name: ad_genre fk_genre_ad; Type: FK CONSTRAINT; Schema: netflix; Owner: postgres
--

ALTER TABLE ONLY netflix.ad_genre
    ADD CONSTRAINT fk_genre_ad FOREIGN KEY (genre_id) REFERENCES netflix.genre(genre_id);


--
-- TOC entry 3237 (class 2606 OID 41504)
-- Name: movie_genre fk_genre_movie; Type: FK CONSTRAINT; Schema: netflix; Owner: postgres
--

ALTER TABLE ONLY netflix.movie_genre
    ADD CONSTRAINT fk_genre_movie FOREIGN KEY (genre_id) REFERENCES netflix.genre(genre_id);


--
-- TOC entry 3238 (class 2606 OID 41509)
-- Name: movie_genre fk_movie_genre; Type: FK CONSTRAINT; Schema: netflix; Owner: postgres
--

ALTER TABLE ONLY netflix.movie_genre
    ADD CONSTRAINT fk_movie_genre FOREIGN KEY (movie_id) REFERENCES netflix.movie(movie_id);


--
-- TOC entry 3240 (class 2606 OID 41514)
-- Name: playlist_movie fk_movie_playlist; Type: FK CONSTRAINT; Schema: netflix; Owner: postgres
--

ALTER TABLE ONLY netflix.playlist_movie
    ADD CONSTRAINT fk_movie_playlist FOREIGN KEY (movie_id) REFERENCES netflix.movie(movie_id);


--
-- TOC entry 3241 (class 2606 OID 41519)
-- Name: playlist_movie fk_playlist_movie; Type: FK CONSTRAINT; Schema: netflix; Owner: postgres
--

ALTER TABLE ONLY netflix.playlist_movie
    ADD CONSTRAINT fk_playlist_movie FOREIGN KEY (playlist_id) REFERENCES netflix.playlist(playlist_id);


--
-- TOC entry 3239 (class 2606 OID 41524)
-- Name: playlist fk_playlist_viewer; Type: FK CONSTRAINT; Schema: netflix; Owner: postgres
--

ALTER TABLE ONLY netflix.playlist
    ADD CONSTRAINT fk_playlist_viewer FOREIGN KEY (viewer_id) REFERENCES netflix.viewer(viewer_id);


--
-- TOC entry 3242 (class 2606 OID 41529)
-- Name: rating fk_rating_movie_viewer; Type: FK CONSTRAINT; Schema: netflix; Owner: postgres
--

ALTER TABLE ONLY netflix.rating
    ADD CONSTRAINT fk_rating_movie_viewer FOREIGN KEY (movie_id) REFERENCES netflix.movie(movie_id);


--
-- TOC entry 3243 (class 2606 OID 41534)
-- Name: rating fk_rating_viewer_movie; Type: FK CONSTRAINT; Schema: netflix; Owner: postgres
--

ALTER TABLE ONLY netflix.rating
    ADD CONSTRAINT fk_rating_viewer_movie FOREIGN KEY (viewer_id) REFERENCES netflix.viewer(viewer_id);


--
-- TOC entry 3403 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

-- REVOKE USAGE ON SCHEMA public FROM PUBLIC;
-- GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2023-09-28 17:56:39

--
-- PostgreSQL database dump complete
--

