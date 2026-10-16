-- Bootstrap: полная схема БД ровно в том состоянии, которое оставляет
-- 'payload migrate' на свежей базе (снята с чистого прогона всех миграций).
-- Применять ТОЛЬКО на пустой БД нового сервера вместо зависшего CLI:
--   docker exec -i idesignart-db psql -U postgres -d idesignart < apps/payload/migrations-bootstrap.sql

--
-- PostgreSQL database dump
--

\restrict 4xYTmiAjuQJc7RGx9lAjxMzKcfqd0GPKoAckCXTpmbHRpXrD41ZlAhvSYosmX6R

-- Dumped from database version 16.14
-- Dumped by pg_dump version 16.14

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
-- Name: enum__pages_v_blocks_content_layout; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum__pages_v_blocks_content_layout AS ENUM (
    'narrow',
    'wide'
);


ALTER TYPE public.enum__pages_v_blocks_content_layout OWNER TO postgres;

--
-- Name: enum__pages_v_blocks_cta_banner_variant; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum__pages_v_blocks_cta_banner_variant AS ENUM (
    'dark',
    'accent'
);


ALTER TYPE public.enum__pages_v_blocks_cta_banner_variant OWNER TO postgres;

--
-- Name: enum__pages_v_blocks_hero_hero_cta_icon; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum__pages_v_blocks_hero_hero_cta_icon AS ENUM (
    'arrow-up-right',
    'arrow-right',
    'none'
);


ALTER TYPE public.enum__pages_v_blocks_hero_hero_cta_icon OWNER TO postgres;

--
-- Name: enum__pages_v_blocks_hero_hero_cta_variant; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum__pages_v_blocks_hero_hero_cta_variant AS ENUM (
    'accent',
    'dark',
    'outline'
);


ALTER TYPE public.enum__pages_v_blocks_hero_hero_cta_variant OWNER TO postgres;

--
-- Name: enum__pages_v_blocks_portfolio_grid_facts_icon; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum__pages_v_blocks_portfolio_grid_facts_icon AS ENUM (
    'layers',
    'house',
    'leaf',
    'compass'
);


ALTER TYPE public.enum__pages_v_blocks_portfolio_grid_facts_icon OWNER TO postgres;

--
-- Name: enum__pages_v_blocks_process_steps_steps_sketch; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum__pages_v_blocks_process_steps_steps_sketch AS ENUM (
    'plan',
    'iso',
    'elevation',
    'perspective'
);


ALTER TYPE public.enum__pages_v_blocks_process_steps_steps_sketch OWNER TO postgres;

--
-- Name: enum__pages_v_blocks_stats_items_icon; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum__pages_v_blocks_stats_items_icon AS ENUM (
    'layers',
    'house',
    'leaf',
    'compass',
    'heart',
    'trending-up'
);


ALTER TYPE public.enum__pages_v_blocks_stats_items_icon OWNER TO postgres;

--
-- Name: enum__pages_v_version_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum__pages_v_version_status AS ENUM (
    'draft',
    'published'
);


ALTER TYPE public.enum__pages_v_version_status OWNER TO postgres;

--
-- Name: enum__posts_v_version_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum__posts_v_version_status AS ENUM (
    'draft',
    'published'
);


ALTER TYPE public.enum__posts_v_version_status OWNER TO postgres;

--
-- Name: enum__projects_v_version_gallery_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum__projects_v_version_gallery_type AS ENUM (
    'before',
    'after',
    'render',
    'plan'
);


ALTER TYPE public.enum__projects_v_version_gallery_type OWNER TO postgres;

--
-- Name: enum__projects_v_version_meta_budget_range; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum__projects_v_version_meta_budget_range AS ENUM (
    'under-500k',
    '500k-1m',
    '1m-3m',
    'over-3m',
    'private'
);


ALTER TYPE public.enum__projects_v_version_meta_budget_range OWNER TO postgres;

--
-- Name: enum__projects_v_version_meta_property_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum__projects_v_version_meta_property_type AS ENUM (
    'apartment',
    'house',
    'office',
    'hospitality',
    'retail',
    'other'
);


ALTER TYPE public.enum__projects_v_version_meta_property_type OWNER TO postgres;

--
-- Name: enum__projects_v_version_meta_style; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum__projects_v_version_meta_style AS ENUM (
    'modern',
    'minimal',
    'scandi',
    'loft',
    'classic',
    'neoclassic',
    'japandi',
    'other'
);


ALTER TYPE public.enum__projects_v_version_meta_style OWNER TO postgres;

--
-- Name: enum__projects_v_version_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum__projects_v_version_status AS ENUM (
    'draft',
    'published'
);


ALTER TYPE public.enum__projects_v_version_status OWNER TO postgres;

--
-- Name: enum__services_v_version_pricing_unit; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum__services_v_version_pricing_unit AS ENUM (
    'sqm',
    'project',
    'hour',
    'render'
);


ALTER TYPE public.enum__services_v_version_pricing_unit OWNER TO postgres;

--
-- Name: enum__services_v_version_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum__services_v_version_status AS ENUM (
    'draft',
    'published'
);


ALTER TYPE public.enum__services_v_version_status OWNER TO postgres;

--
-- Name: enum_categories_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_categories_type AS ENUM (
    'project',
    'service',
    'style'
);


ALTER TYPE public.enum_categories_type OWNER TO postgres;

--
-- Name: enum_header_appearance_font_family; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_header_appearance_font_family AS ENUM (
    'inter',
    'manrope',
    'system'
);


ALTER TYPE public.enum_header_appearance_font_family OWNER TO postgres;

--
-- Name: enum_header_cta_icon; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_header_cta_icon AS ENUM (
    'arrow-up-right',
    'arrow-right',
    'none'
);


ALTER TYPE public.enum_header_cta_icon OWNER TO postgres;

--
-- Name: enum_header_cta_variant; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_header_cta_variant AS ENUM (
    'accent',
    'dark',
    'outline'
);


ALTER TYPE public.enum_header_cta_variant OWNER TO postgres;

--
-- Name: enum_leads_source; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_leads_source AS ENUM (
    'website',
    'calculator',
    'lead-magnet',
    'whatsapp',
    'telegram',
    'ads-google',
    'ads-yandex',
    'social',
    'referral',
    'other'
);


ALTER TYPE public.enum_leads_source OWNER TO postgres;

--
-- Name: enum_leads_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_leads_status AS ENUM (
    'new',
    'in-progress',
    'qualified',
    'meeting',
    'won',
    'lost',
    'nurture'
);


ALTER TYPE public.enum_leads_status OWNER TO postgres;

--
-- Name: enum_pages_blocks_content_layout; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_pages_blocks_content_layout AS ENUM (
    'narrow',
    'wide'
);


ALTER TYPE public.enum_pages_blocks_content_layout OWNER TO postgres;

--
-- Name: enum_pages_blocks_cta_banner_variant; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_pages_blocks_cta_banner_variant AS ENUM (
    'dark',
    'accent'
);


ALTER TYPE public.enum_pages_blocks_cta_banner_variant OWNER TO postgres;

--
-- Name: enum_pages_blocks_hero_hero_cta_icon; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_pages_blocks_hero_hero_cta_icon AS ENUM (
    'arrow-up-right',
    'arrow-right',
    'none'
);


ALTER TYPE public.enum_pages_blocks_hero_hero_cta_icon OWNER TO postgres;

--
-- Name: enum_pages_blocks_hero_hero_cta_variant; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_pages_blocks_hero_hero_cta_variant AS ENUM (
    'accent',
    'dark',
    'outline'
);


ALTER TYPE public.enum_pages_blocks_hero_hero_cta_variant OWNER TO postgres;

--
-- Name: enum_pages_blocks_portfolio_grid_facts_icon; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_pages_blocks_portfolio_grid_facts_icon AS ENUM (
    'layers',
    'house',
    'leaf',
    'compass'
);


ALTER TYPE public.enum_pages_blocks_portfolio_grid_facts_icon OWNER TO postgres;

--
-- Name: enum_pages_blocks_process_steps_steps_sketch; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_pages_blocks_process_steps_steps_sketch AS ENUM (
    'plan',
    'iso',
    'elevation',
    'perspective'
);


ALTER TYPE public.enum_pages_blocks_process_steps_steps_sketch OWNER TO postgres;

--
-- Name: enum_pages_blocks_stats_items_icon; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_pages_blocks_stats_items_icon AS ENUM (
    'layers',
    'house',
    'leaf',
    'compass',
    'heart',
    'trending-up'
);


ALTER TYPE public.enum_pages_blocks_stats_items_icon OWNER TO postgres;

--
-- Name: enum_pages_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_pages_status AS ENUM (
    'draft',
    'published'
);


ALTER TYPE public.enum_pages_status OWNER TO postgres;

--
-- Name: enum_posts_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_posts_status AS ENUM (
    'draft',
    'published'
);


ALTER TYPE public.enum_posts_status OWNER TO postgres;

--
-- Name: enum_projects_gallery_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_projects_gallery_type AS ENUM (
    'before',
    'after',
    'render',
    'plan'
);


ALTER TYPE public.enum_projects_gallery_type OWNER TO postgres;

--
-- Name: enum_projects_meta_budget_range; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_projects_meta_budget_range AS ENUM (
    'under-500k',
    '500k-1m',
    '1m-3m',
    'over-3m',
    'private'
);


ALTER TYPE public.enum_projects_meta_budget_range OWNER TO postgres;

--
-- Name: enum_projects_meta_property_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_projects_meta_property_type AS ENUM (
    'apartment',
    'house',
    'office',
    'hospitality',
    'retail',
    'other'
);


ALTER TYPE public.enum_projects_meta_property_type OWNER TO postgres;

--
-- Name: enum_projects_meta_style; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_projects_meta_style AS ENUM (
    'modern',
    'minimal',
    'scandi',
    'loft',
    'classic',
    'neoclassic',
    'japandi',
    'other'
);


ALTER TYPE public.enum_projects_meta_style OWNER TO postgres;

--
-- Name: enum_projects_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_projects_status AS ENUM (
    'draft',
    'published'
);


ALTER TYPE public.enum_projects_status OWNER TO postgres;

--
-- Name: enum_services_pricing_unit; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_services_pricing_unit AS ENUM (
    'sqm',
    'project',
    'hour',
    'render'
);


ALTER TYPE public.enum_services_pricing_unit OWNER TO postgres;

--
-- Name: enum_services_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_services_status AS ENUM (
    'draft',
    'published'
);


ALTER TYPE public.enum_services_status OWNER TO postgres;

--
-- Name: enum_subscriptions_source; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_subscriptions_source AS ENUM (
    'lead-magnet',
    'newsletter',
    'popup',
    'footer',
    'blog'
);


ALTER TYPE public.enum_subscriptions_source OWNER TO postgres;

--
-- Name: enum_subscriptions_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_subscriptions_status AS ENUM (
    'subscribed',
    'pending',
    'unsubscribed',
    'nurturing'
);


ALTER TYPE public.enum_subscriptions_status OWNER TO postgres;

--
-- Name: enum_users_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_users_role AS ENUM (
    'admin',
    'editor'
);


ALTER TYPE public.enum_users_role OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _pages_v; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._pages_v (
    id integer NOT NULL,
    parent_id integer,
    version_title character varying,
    version_slug character varying DEFAULT 'home'::character varying,
    version_seo_title character varying,
    version_seo_description character varying,
    version_seo_keywords character varying,
    version_seo_og_image_id integer,
    version_seo_noindex boolean DEFAULT false,
    version_updated_at timestamp(3) with time zone,
    version_created_at timestamp(3) with time zone,
    version__status public.enum__pages_v_version_status DEFAULT 'draft'::public.enum__pages_v_version_status,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    latest boolean
);


ALTER TABLE public._pages_v OWNER TO postgres;

--
-- Name: _pages_v_blocks_contact_form; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._pages_v_blocks_contact_form (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    _path text NOT NULL,
    id integer NOT NULL,
    eyebrow character varying DEFAULT 'Связаться'::character varying,
    title character varying DEFAULT 'Расскажите о проекте'::character varying,
    description character varying,
    _uuid character varying,
    block_name character varying
);


ALTER TABLE public._pages_v_blocks_contact_form OWNER TO postgres;

--
-- Name: _pages_v_blocks_contact_form_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public._pages_v_blocks_contact_form_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._pages_v_blocks_contact_form_id_seq OWNER TO postgres;

--
-- Name: _pages_v_blocks_contact_form_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public._pages_v_blocks_contact_form_id_seq OWNED BY public._pages_v_blocks_contact_form.id;


--
-- Name: _pages_v_blocks_content; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._pages_v_blocks_content (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    _path text NOT NULL,
    id integer NOT NULL,
    eyebrow character varying,
    title character varying,
    body jsonb,
    layout public.enum__pages_v_blocks_content_layout DEFAULT 'narrow'::public.enum__pages_v_blocks_content_layout,
    _uuid character varying,
    block_name character varying
);


ALTER TABLE public._pages_v_blocks_content OWNER TO postgres;

--
-- Name: _pages_v_blocks_content_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public._pages_v_blocks_content_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._pages_v_blocks_content_id_seq OWNER TO postgres;

--
-- Name: _pages_v_blocks_content_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public._pages_v_blocks_content_id_seq OWNED BY public._pages_v_blocks_content.id;


--
-- Name: _pages_v_blocks_cta_banner; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._pages_v_blocks_cta_banner (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    _path text NOT NULL,
    id integer NOT NULL,
    title character varying,
    description character varying,
    primary_cta_label character varying DEFAULT 'Оставить заявку'::character varying,
    primary_cta_href character varying DEFAULT '/contacts'::character varying,
    variant public.enum__pages_v_blocks_cta_banner_variant DEFAULT 'dark'::public.enum__pages_v_blocks_cta_banner_variant,
    _uuid character varying,
    block_name character varying
);


ALTER TABLE public._pages_v_blocks_cta_banner OWNER TO postgres;

--
-- Name: _pages_v_blocks_cta_banner_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public._pages_v_blocks_cta_banner_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._pages_v_blocks_cta_banner_id_seq OWNER TO postgres;

--
-- Name: _pages_v_blocks_cta_banner_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public._pages_v_blocks_cta_banner_id_seq OWNED BY public._pages_v_blocks_cta_banner.id;


--
-- Name: _pages_v_blocks_hero; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._pages_v_blocks_hero (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    _path text NOT NULL,
    id integer NOT NULL,
    hero_eyebrow character varying DEFAULT 'ЦИФРОВОЙ ДИЗАЙН ИНТЕРЬЕРОВ'::character varying,
    hero_description character varying DEFAULT 'Превращаем пустые комнаты в выразительные интерьеры для продажи недвижимости.'::character varying,
    hero_cta_enabled boolean DEFAULT true,
    hero_cta_label character varying,
    hero_cta_href character varying,
    hero_cta_new_tab boolean DEFAULT false,
    hero_cta_icon public.enum__pages_v_blocks_hero_hero_cta_icon DEFAULT 'arrow-up-right'::public.enum__pages_v_blocks_hero_hero_cta_icon,
    hero_cta_variant public.enum__pages_v_blocks_hero_hero_cta_variant DEFAULT 'accent'::public.enum__pages_v_blocks_hero_hero_cta_variant,
    hero_image_id integer,
    hero_mobile_image_id integer,
    hero_image_alt character varying DEFAULT 'Светлая гостиная с панорамными окнами, кремовым диваном и терракотовым креслом'::character varying,
    hero_mobile_image_alt character varying,
    hero_image_caption character varying DEFAULT '01 / Тёплый минимализм'::character varying,
    hero_show_image_caption boolean DEFAULT true,
    hero_image_position_x numeric DEFAULT 50,
    hero_image_position_y numeric DEFAULT 50,
    hero_mobile_image_position_x numeric DEFAULT 50,
    hero_mobile_image_position_y numeric DEFAULT 50,
    hero_caption_overlay_opacity numeric DEFAULT 0.15,
    bottom_line_enabled boolean DEFAULT true,
    bottom_line_left_text character varying DEFAULT 'Ваш объект. Новый взгляд.'::character varying,
    bottom_line_right_text character varying DEFAULT 'Виртуальный хоумстейджинг'::character varying,
    bottom_line_show_divider boolean DEFAULT true,
    _uuid character varying,
    block_name character varying
);


ALTER TABLE public._pages_v_blocks_hero OWNER TO postgres;

--
-- Name: _pages_v_blocks_hero_hero_title_lines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._pages_v_blocks_hero_hero_title_lines (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    id integer NOT NULL,
    text character varying,
    _uuid character varying
);


ALTER TABLE public._pages_v_blocks_hero_hero_title_lines OWNER TO postgres;

--
-- Name: _pages_v_blocks_hero_hero_title_lines_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public._pages_v_blocks_hero_hero_title_lines_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._pages_v_blocks_hero_hero_title_lines_id_seq OWNER TO postgres;

--
-- Name: _pages_v_blocks_hero_hero_title_lines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public._pages_v_blocks_hero_hero_title_lines_id_seq OWNED BY public._pages_v_blocks_hero_hero_title_lines.id;


--
-- Name: _pages_v_blocks_hero_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public._pages_v_blocks_hero_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._pages_v_blocks_hero_id_seq OWNER TO postgres;

--
-- Name: _pages_v_blocks_hero_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public._pages_v_blocks_hero_id_seq OWNED BY public._pages_v_blocks_hero.id;


--
-- Name: _pages_v_blocks_portfolio_grid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._pages_v_blocks_portfolio_grid (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    _path text NOT NULL,
    id integer NOT NULL,
    eyebrow character varying DEFAULT 'Портфолио'::character varying,
    title character varying,
    "limit" numeric DEFAULT 6,
    _uuid character varying,
    block_name character varying,
    show_filters boolean DEFAULT true
);


ALTER TABLE public._pages_v_blocks_portfolio_grid OWNER TO postgres;

--
-- Name: _pages_v_blocks_portfolio_grid_facts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._pages_v_blocks_portfolio_grid_facts (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    id integer NOT NULL,
    icon public.enum__pages_v_blocks_portfolio_grid_facts_icon DEFAULT 'layers'::public.enum__pages_v_blocks_portfolio_grid_facts_icon,
    value character varying,
    label character varying,
    _uuid character varying
);


ALTER TABLE public._pages_v_blocks_portfolio_grid_facts OWNER TO postgres;

--
-- Name: _pages_v_blocks_portfolio_grid_facts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public._pages_v_blocks_portfolio_grid_facts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._pages_v_blocks_portfolio_grid_facts_id_seq OWNER TO postgres;

--
-- Name: _pages_v_blocks_portfolio_grid_facts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public._pages_v_blocks_portfolio_grid_facts_id_seq OWNED BY public._pages_v_blocks_portfolio_grid_facts.id;


--
-- Name: _pages_v_blocks_portfolio_grid_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public._pages_v_blocks_portfolio_grid_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._pages_v_blocks_portfolio_grid_id_seq OWNER TO postgres;

--
-- Name: _pages_v_blocks_portfolio_grid_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public._pages_v_blocks_portfolio_grid_id_seq OWNED BY public._pages_v_blocks_portfolio_grid.id;


--
-- Name: _pages_v_blocks_pricing_calculator; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._pages_v_blocks_pricing_calculator (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    _path text NOT NULL,
    id integer NOT NULL,
    eyebrow character varying DEFAULT 'Прозрачные цены'::character varying,
    title character varying DEFAULT 'Узнайте стоимость'::character varying,
    _uuid character varying,
    block_name character varying
);


ALTER TABLE public._pages_v_blocks_pricing_calculator OWNER TO postgres;

--
-- Name: _pages_v_blocks_pricing_calculator_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public._pages_v_blocks_pricing_calculator_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._pages_v_blocks_pricing_calculator_id_seq OWNER TO postgres;

--
-- Name: _pages_v_blocks_pricing_calculator_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public._pages_v_blocks_pricing_calculator_id_seq OWNED BY public._pages_v_blocks_pricing_calculator.id;


--
-- Name: _pages_v_blocks_process_steps; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._pages_v_blocks_process_steps (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    _path text NOT NULL,
    id integer NOT NULL,
    eyebrow character varying DEFAULT 'Процесс'::character varying,
    title character varying DEFAULT 'Как мы работаем'::character varying,
    _uuid character varying,
    block_name character varying,
    description character varying DEFAULT 'Четыре листа — от первой идеи до готового интерьера'::character varying
);


ALTER TABLE public._pages_v_blocks_process_steps OWNER TO postgres;

--
-- Name: _pages_v_blocks_process_steps_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public._pages_v_blocks_process_steps_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._pages_v_blocks_process_steps_id_seq OWNER TO postgres;

--
-- Name: _pages_v_blocks_process_steps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public._pages_v_blocks_process_steps_id_seq OWNED BY public._pages_v_blocks_process_steps.id;


--
-- Name: _pages_v_blocks_process_steps_steps; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._pages_v_blocks_process_steps_steps (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    id integer NOT NULL,
    num character varying,
    title character varying,
    description character varying,
    duration character varying,
    _uuid character varying,
    sketch public.enum__pages_v_blocks_process_steps_steps_sketch DEFAULT 'plan'::public.enum__pages_v_blocks_process_steps_steps_sketch,
    image_id integer
);


ALTER TABLE public._pages_v_blocks_process_steps_steps OWNER TO postgres;

--
-- Name: _pages_v_blocks_process_steps_steps_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public._pages_v_blocks_process_steps_steps_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._pages_v_blocks_process_steps_steps_id_seq OWNER TO postgres;

--
-- Name: _pages_v_blocks_process_steps_steps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public._pages_v_blocks_process_steps_steps_id_seq OWNED BY public._pages_v_blocks_process_steps_steps.id;


--
-- Name: _pages_v_blocks_services_grid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._pages_v_blocks_services_grid (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    _path text NOT NULL,
    id integer NOT NULL,
    title character varying DEFAULT 'Чем мы можем помочь'::character varying,
    description character varying DEFAULT 'Полный цикл: от планировки и визуализации до реализации под ключ.'::character varying,
    _uuid character varying,
    block_name character varying
);


ALTER TABLE public._pages_v_blocks_services_grid OWNER TO postgres;

--
-- Name: _pages_v_blocks_services_grid_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public._pages_v_blocks_services_grid_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._pages_v_blocks_services_grid_id_seq OWNER TO postgres;

--
-- Name: _pages_v_blocks_services_grid_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public._pages_v_blocks_services_grid_id_seq OWNED BY public._pages_v_blocks_services_grid.id;


--
-- Name: _pages_v_blocks_stats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._pages_v_blocks_stats (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    _path text NOT NULL,
    id integer NOT NULL,
    _uuid character varying,
    block_name character varying
);


ALTER TABLE public._pages_v_blocks_stats OWNER TO postgres;

--
-- Name: _pages_v_blocks_stats_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public._pages_v_blocks_stats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._pages_v_blocks_stats_id_seq OWNER TO postgres;

--
-- Name: _pages_v_blocks_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public._pages_v_blocks_stats_id_seq OWNED BY public._pages_v_blocks_stats.id;


--
-- Name: _pages_v_blocks_stats_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._pages_v_blocks_stats_items (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    id integer NOT NULL,
    value character varying,
    label character varying,
    _uuid character varying,
    icon public.enum__pages_v_blocks_stats_items_icon DEFAULT 'layers'::public.enum__pages_v_blocks_stats_items_icon,
    description character varying,
    image_id integer
);


ALTER TABLE public._pages_v_blocks_stats_items OWNER TO postgres;

--
-- Name: _pages_v_blocks_stats_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public._pages_v_blocks_stats_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._pages_v_blocks_stats_items_id_seq OWNER TO postgres;

--
-- Name: _pages_v_blocks_stats_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public._pages_v_blocks_stats_items_id_seq OWNED BY public._pages_v_blocks_stats_items.id;


--
-- Name: _pages_v_blocks_testimonials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._pages_v_blocks_testimonials (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    _path text NOT NULL,
    id integer NOT NULL,
    eyebrow character varying DEFAULT 'Отзывы клиентов'::character varying,
    title character varying,
    _uuid character varying,
    block_name character varying
);


ALTER TABLE public._pages_v_blocks_testimonials OWNER TO postgres;

--
-- Name: _pages_v_blocks_testimonials_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public._pages_v_blocks_testimonials_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._pages_v_blocks_testimonials_id_seq OWNER TO postgres;

--
-- Name: _pages_v_blocks_testimonials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public._pages_v_blocks_testimonials_id_seq OWNED BY public._pages_v_blocks_testimonials.id;


--
-- Name: _pages_v_blocks_testimonials_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._pages_v_blocks_testimonials_items (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    id integer NOT NULL,
    quote character varying,
    author character varying,
    role character varying,
    _uuid character varying
);


ALTER TABLE public._pages_v_blocks_testimonials_items OWNER TO postgres;

--
-- Name: _pages_v_blocks_testimonials_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public._pages_v_blocks_testimonials_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._pages_v_blocks_testimonials_items_id_seq OWNER TO postgres;

--
-- Name: _pages_v_blocks_testimonials_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public._pages_v_blocks_testimonials_items_id_seq OWNED BY public._pages_v_blocks_testimonials_items.id;


--
-- Name: _pages_v_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public._pages_v_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._pages_v_id_seq OWNER TO postgres;

--
-- Name: _pages_v_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public._pages_v_id_seq OWNED BY public._pages_v.id;


--
-- Name: _pages_v_rels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._pages_v_rels (
    id integer NOT NULL,
    "order" integer,
    parent_id integer NOT NULL,
    path character varying NOT NULL,
    projects_id integer
);


ALTER TABLE public._pages_v_rels OWNER TO postgres;

--
-- Name: _pages_v_rels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public._pages_v_rels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._pages_v_rels_id_seq OWNER TO postgres;

--
-- Name: _pages_v_rels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public._pages_v_rels_id_seq OWNED BY public._pages_v_rels.id;


--
-- Name: _posts_v; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._posts_v (
    id integer NOT NULL,
    parent_id integer,
    version_title character varying,
    version_slug character varying,
    version_excerpt character varying,
    version_cover_image_id integer,
    version_category_id integer,
    version_content jsonb,
    version_author_id integer,
    version_published_at timestamp(3) with time zone,
    version_reading_time numeric,
    version_seo_title character varying,
    version_seo_description character varying,
    version_seo_keywords character varying,
    version_seo_og_image_id integer,
    version_seo_noindex boolean DEFAULT false,
    version_updated_at timestamp(3) with time zone,
    version_created_at timestamp(3) with time zone,
    version__status public.enum__posts_v_version_status DEFAULT 'draft'::public.enum__posts_v_version_status,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    latest boolean
);


ALTER TABLE public._posts_v OWNER TO postgres;

--
-- Name: _posts_v_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public._posts_v_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._posts_v_id_seq OWNER TO postgres;

--
-- Name: _posts_v_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public._posts_v_id_seq OWNED BY public._posts_v.id;


--
-- Name: _posts_v_rels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._posts_v_rels (
    id integer NOT NULL,
    "order" integer,
    parent_id integer NOT NULL,
    path character varying NOT NULL,
    categories_id integer,
    posts_id integer
);


ALTER TABLE public._posts_v_rels OWNER TO postgres;

--
-- Name: _posts_v_rels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public._posts_v_rels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._posts_v_rels_id_seq OWNER TO postgres;

--
-- Name: _posts_v_rels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public._posts_v_rels_id_seq OWNED BY public._posts_v_rels.id;


--
-- Name: _projects_v; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._projects_v (
    id integer NOT NULL,
    parent_id integer,
    version_title character varying,
    version_slug character varying,
    version_excerpt character varying,
    version_cover_image_id integer,
    version_meta_area numeric,
    version_meta_property_type public.enum__projects_v_version_meta_property_type,
    version_meta_style public.enum__projects_v_version_meta_style,
    version_meta_location character varying,
    version_meta_year numeric,
    version_meta_duration character varying,
    version_meta_budget_range public.enum__projects_v_version_meta_budget_range,
    version_brief jsonb,
    version_solution jsonb,
    version_testimonial_quote character varying,
    version_testimonial_author character varying,
    version_testimonial_role character varying,
    version_testimonial_photo_id integer,
    version_seo_title character varying,
    version_seo_description character varying,
    version_seo_keywords character varying,
    version_seo_og_image_id integer,
    version_featured boolean DEFAULT false,
    version_updated_at timestamp(3) with time zone,
    version_created_at timestamp(3) with time zone,
    version__status public.enum__projects_v_version_status DEFAULT 'draft'::public.enum__projects_v_version_status,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    latest boolean
);


ALTER TABLE public._projects_v OWNER TO postgres;

--
-- Name: _projects_v_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public._projects_v_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._projects_v_id_seq OWNER TO postgres;

--
-- Name: _projects_v_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public._projects_v_id_seq OWNED BY public._projects_v.id;


--
-- Name: _projects_v_rels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._projects_v_rels (
    id integer NOT NULL,
    "order" integer,
    parent_id integer NOT NULL,
    path character varying NOT NULL,
    categories_id integer
);


ALTER TABLE public._projects_v_rels OWNER TO postgres;

--
-- Name: _projects_v_rels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public._projects_v_rels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._projects_v_rels_id_seq OWNER TO postgres;

--
-- Name: _projects_v_rels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public._projects_v_rels_id_seq OWNED BY public._projects_v_rels.id;


--
-- Name: _projects_v_version_gallery; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._projects_v_version_gallery (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    id integer NOT NULL,
    image_id integer,
    caption character varying,
    type public.enum__projects_v_version_gallery_type DEFAULT 'after'::public.enum__projects_v_version_gallery_type,
    _uuid character varying
);


ALTER TABLE public._projects_v_version_gallery OWNER TO postgres;

--
-- Name: _projects_v_version_gallery_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public._projects_v_version_gallery_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._projects_v_version_gallery_id_seq OWNER TO postgres;

--
-- Name: _projects_v_version_gallery_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public._projects_v_version_gallery_id_seq OWNED BY public._projects_v_version_gallery.id;


--
-- Name: _services_v; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._services_v (
    id integer NOT NULL,
    parent_id integer,
    version_title character varying,
    version_slug character varying,
    version_short_description character varying,
    version_hero_headline character varying,
    version_hero_subheadline character varying,
    version_hero_image_id integer,
    version_body jsonb,
    version_pricing_price_from numeric,
    version_pricing_unit public.enum__services_v_version_pricing_unit DEFAULT 'project'::public.enum__services_v_version_pricing_unit,
    version_pricing_note character varying,
    version_seo_title character varying,
    version_seo_description character varying,
    version_seo_keywords character varying,
    version_seo_og_image_id integer,
    version_order numeric DEFAULT 0,
    version_featured boolean DEFAULT false,
    version_updated_at timestamp(3) with time zone,
    version_created_at timestamp(3) with time zone,
    version__status public.enum__services_v_version_status DEFAULT 'draft'::public.enum__services_v_version_status,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    latest boolean,
    version_card_image_id integer,
    version_tagline character varying
);


ALTER TABLE public._services_v OWNER TO postgres;

--
-- Name: _services_v_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public._services_v_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._services_v_id_seq OWNER TO postgres;

--
-- Name: _services_v_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public._services_v_id_seq OWNED BY public._services_v.id;


--
-- Name: _services_v_rels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._services_v_rels (
    id integer NOT NULL,
    "order" integer,
    parent_id integer NOT NULL,
    path character varying NOT NULL,
    projects_id integer
);


ALTER TABLE public._services_v_rels OWNER TO postgres;

--
-- Name: _services_v_rels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public._services_v_rels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._services_v_rels_id_seq OWNER TO postgres;

--
-- Name: _services_v_rels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public._services_v_rels_id_seq OWNED BY public._services_v_rels.id;


--
-- Name: _services_v_version_deliverables; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._services_v_version_deliverables (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    id integer NOT NULL,
    item character varying,
    description character varying,
    _uuid character varying
);


ALTER TABLE public._services_v_version_deliverables OWNER TO postgres;

--
-- Name: _services_v_version_deliverables_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public._services_v_version_deliverables_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._services_v_version_deliverables_id_seq OWNER TO postgres;

--
-- Name: _services_v_version_deliverables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public._services_v_version_deliverables_id_seq OWNED BY public._services_v_version_deliverables.id;


--
-- Name: _services_v_version_faqs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._services_v_version_faqs (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    id integer NOT NULL,
    question character varying,
    answer character varying,
    _uuid character varying
);


ALTER TABLE public._services_v_version_faqs OWNER TO postgres;

--
-- Name: _services_v_version_faqs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public._services_v_version_faqs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._services_v_version_faqs_id_seq OWNER TO postgres;

--
-- Name: _services_v_version_faqs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public._services_v_version_faqs_id_seq OWNED BY public._services_v_version_faqs.id;


--
-- Name: _services_v_version_pain_points; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._services_v_version_pain_points (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    id integer NOT NULL,
    point character varying,
    _uuid character varying
);


ALTER TABLE public._services_v_version_pain_points OWNER TO postgres;

--
-- Name: _services_v_version_pain_points_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public._services_v_version_pain_points_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._services_v_version_pain_points_id_seq OWNER TO postgres;

--
-- Name: _services_v_version_pain_points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public._services_v_version_pain_points_id_seq OWNED BY public._services_v_version_pain_points.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    title character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying,
    type public.enum_categories_type NOT NULL,
    seo_image_id integer,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    "order" numeric
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_id_seq OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: header; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.header (
    id integer NOT NULL,
    phone character varying,
    cta_enabled boolean DEFAULT true,
    cta_label character varying DEFAULT 'Зарегистрироваться'::character varying,
    cta_href character varying DEFAULT '/register'::character varying,
    cta_new_tab boolean DEFAULT false,
    cta_icon public.enum_header_cta_icon DEFAULT 'arrow-up-right'::public.enum_header_cta_icon,
    cta_variant public.enum_header_cta_variant DEFAULT 'accent'::public.enum_header_cta_variant,
    appearance_background_color character varying DEFAULT '#F8F7F3'::character varying,
    appearance_text_color character varying DEFAULT '#080808'::character varying,
    appearance_muted_text_color character varying DEFAULT '#303030'::character varying,
    appearance_accent_color character varying DEFAULT '#D7EF28'::character varying,
    appearance_accent_text_color character varying DEFAULT '#080808'::character varying,
    appearance_font_family public.enum_header_appearance_font_family DEFAULT 'inter'::public.enum_header_appearance_font_family,
    appearance_brand_px numeric DEFAULT 30 NOT NULL,
    appearance_navigation_px numeric DEFAULT 16 NOT NULL,
    appearance_button_text_px numeric DEFAULT 18 NOT NULL,
    appearance_button_height_px numeric DEFAULT 56 NOT NULL,
    appearance_button_padding_x_px numeric DEFAULT 28 NOT NULL,
    appearance_button_radius_px numeric DEFAULT 0 NOT NULL,
    appearance_header_height_px numeric DEFAULT 88 NOT NULL,
    updated_at timestamp(3) with time zone,
    created_at timestamp(3) with time zone
);


ALTER TABLE public.header OWNER TO postgres;

--
-- Name: header_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.header_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.header_id_seq OWNER TO postgres;

--
-- Name: header_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.header_id_seq OWNED BY public.header.id;


--
-- Name: header_navigation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.header_navigation (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    id character varying NOT NULL,
    label character varying NOT NULL,
    href character varying NOT NULL,
    new_tab boolean DEFAULT false
);


ALTER TABLE public.header_navigation OWNER TO postgres;

--
-- Name: leads; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.leads (
    id integer NOT NULL,
    name character varying NOT NULL,
    contact_email character varying,
    contact_phone character varying,
    service_id integer,
    project_details_property_type character varying,
    project_details_area numeric,
    project_details_budget character varying,
    project_details_timeline character varying,
    message character varying NOT NULL,
    source public.enum_leads_source DEFAULT 'website'::public.enum_leads_source,
    status public.enum_leads_status DEFAULT 'new'::public.enum_leads_status,
    assigned_to_id integer,
    notes character varying,
    consent boolean DEFAULT false NOT NULL,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.leads OWNER TO postgres;

--
-- Name: leads_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.leads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.leads_id_seq OWNER TO postgres;

--
-- Name: leads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.leads_id_seq OWNED BY public.leads.id;


--
-- Name: media; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.media (
    id integer NOT NULL,
    alt character varying NOT NULL,
    title character varying,
    caption character varying,
    credit character varying,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    url character varying,
    thumbnail_u_r_l character varying,
    filename character varying,
    mime_type character varying,
    filesize numeric,
    width numeric,
    height numeric,
    focal_x numeric,
    focal_y numeric,
    sizes_thumbnail_url character varying,
    sizes_thumbnail_width numeric,
    sizes_thumbnail_height numeric,
    sizes_thumbnail_mime_type character varying,
    sizes_thumbnail_filesize numeric,
    sizes_thumbnail_filename character varying,
    sizes_card_url character varying,
    sizes_card_width numeric,
    sizes_card_height numeric,
    sizes_card_mime_type character varying,
    sizes_card_filesize numeric,
    sizes_card_filename character varying,
    sizes_tablet_url character varying,
    sizes_tablet_width numeric,
    sizes_tablet_height numeric,
    sizes_tablet_mime_type character varying,
    sizes_tablet_filesize numeric,
    sizes_tablet_filename character varying,
    sizes_desktop_url character varying,
    sizes_desktop_width numeric,
    sizes_desktop_height numeric,
    sizes_desktop_mime_type character varying,
    sizes_desktop_filesize numeric,
    sizes_desktop_filename character varying,
    sizes_featured_url character varying,
    sizes_featured_width numeric,
    sizes_featured_height numeric,
    sizes_featured_mime_type character varying,
    sizes_featured_filesize numeric,
    sizes_featured_filename character varying
);


ALTER TABLE public.media OWNER TO postgres;

--
-- Name: media_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.media_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.media_id_seq OWNER TO postgres;

--
-- Name: media_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.media_id_seq OWNED BY public.media.id;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pages (
    id integer NOT NULL,
    title character varying,
    slug character varying DEFAULT 'home'::character varying,
    seo_title character varying,
    seo_description character varying,
    seo_keywords character varying,
    seo_og_image_id integer,
    seo_noindex boolean DEFAULT false,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    _status public.enum_pages_status DEFAULT 'draft'::public.enum_pages_status
);


ALTER TABLE public.pages OWNER TO postgres;

--
-- Name: pages_blocks_contact_form; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pages_blocks_contact_form (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    _path text NOT NULL,
    id character varying NOT NULL,
    eyebrow character varying DEFAULT 'Связаться'::character varying,
    title character varying DEFAULT 'Расскажите о проекте'::character varying,
    description character varying,
    block_name character varying
);


ALTER TABLE public.pages_blocks_contact_form OWNER TO postgres;

--
-- Name: pages_blocks_content; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pages_blocks_content (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    _path text NOT NULL,
    id character varying NOT NULL,
    eyebrow character varying,
    title character varying,
    body jsonb,
    layout public.enum_pages_blocks_content_layout DEFAULT 'narrow'::public.enum_pages_blocks_content_layout,
    block_name character varying
);


ALTER TABLE public.pages_blocks_content OWNER TO postgres;

--
-- Name: pages_blocks_cta_banner; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pages_blocks_cta_banner (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    _path text NOT NULL,
    id character varying NOT NULL,
    title character varying,
    description character varying,
    primary_cta_label character varying DEFAULT 'Оставить заявку'::character varying,
    primary_cta_href character varying DEFAULT '/contacts'::character varying,
    variant public.enum_pages_blocks_cta_banner_variant DEFAULT 'dark'::public.enum_pages_blocks_cta_banner_variant,
    block_name character varying
);


ALTER TABLE public.pages_blocks_cta_banner OWNER TO postgres;

--
-- Name: pages_blocks_hero; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pages_blocks_hero (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    _path text NOT NULL,
    id character varying NOT NULL,
    hero_eyebrow character varying DEFAULT 'ЦИФРОВОЙ ДИЗАЙН ИНТЕРЬЕРОВ'::character varying,
    hero_description character varying DEFAULT 'Превращаем пустые комнаты в выразительные интерьеры для продажи недвижимости.'::character varying,
    hero_cta_enabled boolean DEFAULT true,
    hero_cta_label character varying,
    hero_cta_href character varying,
    hero_cta_new_tab boolean DEFAULT false,
    hero_cta_icon public.enum_pages_blocks_hero_hero_cta_icon DEFAULT 'arrow-up-right'::public.enum_pages_blocks_hero_hero_cta_icon,
    hero_cta_variant public.enum_pages_blocks_hero_hero_cta_variant DEFAULT 'accent'::public.enum_pages_blocks_hero_hero_cta_variant,
    hero_image_id integer,
    hero_mobile_image_id integer,
    hero_image_alt character varying DEFAULT 'Светлая гостиная с панорамными окнами, кремовым диваном и терракотовым креслом'::character varying,
    hero_mobile_image_alt character varying,
    hero_image_caption character varying DEFAULT '01 / Тёплый минимализм'::character varying,
    hero_show_image_caption boolean DEFAULT true,
    hero_image_position_x numeric DEFAULT 50,
    hero_image_position_y numeric DEFAULT 50,
    hero_mobile_image_position_x numeric DEFAULT 50,
    hero_mobile_image_position_y numeric DEFAULT 50,
    hero_caption_overlay_opacity numeric DEFAULT 0.15,
    bottom_line_enabled boolean DEFAULT true,
    bottom_line_left_text character varying DEFAULT 'Ваш объект. Новый взгляд.'::character varying,
    bottom_line_right_text character varying DEFAULT 'Виртуальный хоумстейджинг'::character varying,
    bottom_line_show_divider boolean DEFAULT true,
    block_name character varying
);


ALTER TABLE public.pages_blocks_hero OWNER TO postgres;

--
-- Name: pages_blocks_hero_hero_title_lines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pages_blocks_hero_hero_title_lines (
    _order integer NOT NULL,
    _parent_id character varying NOT NULL,
    id character varying NOT NULL,
    text character varying
);


ALTER TABLE public.pages_blocks_hero_hero_title_lines OWNER TO postgres;

--
-- Name: pages_blocks_portfolio_grid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pages_blocks_portfolio_grid (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    _path text NOT NULL,
    id character varying NOT NULL,
    eyebrow character varying DEFAULT 'Портфолио'::character varying,
    title character varying,
    "limit" numeric DEFAULT 6,
    block_name character varying,
    show_filters boolean DEFAULT true
);


ALTER TABLE public.pages_blocks_portfolio_grid OWNER TO postgres;

--
-- Name: pages_blocks_portfolio_grid_facts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pages_blocks_portfolio_grid_facts (
    _order integer NOT NULL,
    _parent_id character varying NOT NULL,
    id character varying NOT NULL,
    icon public.enum_pages_blocks_portfolio_grid_facts_icon DEFAULT 'layers'::public.enum_pages_blocks_portfolio_grid_facts_icon,
    value character varying,
    label character varying
);


ALTER TABLE public.pages_blocks_portfolio_grid_facts OWNER TO postgres;

--
-- Name: pages_blocks_pricing_calculator; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pages_blocks_pricing_calculator (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    _path text NOT NULL,
    id character varying NOT NULL,
    eyebrow character varying DEFAULT 'Прозрачные цены'::character varying,
    title character varying DEFAULT 'Узнайте стоимость'::character varying,
    block_name character varying
);


ALTER TABLE public.pages_blocks_pricing_calculator OWNER TO postgres;

--
-- Name: pages_blocks_process_steps; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pages_blocks_process_steps (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    _path text NOT NULL,
    id character varying NOT NULL,
    eyebrow character varying DEFAULT 'Процесс'::character varying,
    title character varying DEFAULT 'Как мы работаем'::character varying,
    block_name character varying,
    description character varying DEFAULT 'Четыре листа — от первой идеи до готового интерьера'::character varying
);


ALTER TABLE public.pages_blocks_process_steps OWNER TO postgres;

--
-- Name: pages_blocks_process_steps_steps; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pages_blocks_process_steps_steps (
    _order integer NOT NULL,
    _parent_id character varying NOT NULL,
    id character varying NOT NULL,
    num character varying,
    title character varying,
    description character varying,
    duration character varying,
    sketch public.enum_pages_blocks_process_steps_steps_sketch DEFAULT 'plan'::public.enum_pages_blocks_process_steps_steps_sketch,
    image_id integer
);


ALTER TABLE public.pages_blocks_process_steps_steps OWNER TO postgres;

--
-- Name: pages_blocks_services_grid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pages_blocks_services_grid (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    _path text NOT NULL,
    id character varying NOT NULL,
    title character varying DEFAULT 'Чем мы можем помочь'::character varying,
    description character varying DEFAULT 'Полный цикл: от планировки и визуализации до реализации под ключ.'::character varying,
    block_name character varying
);


ALTER TABLE public.pages_blocks_services_grid OWNER TO postgres;

--
-- Name: pages_blocks_stats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pages_blocks_stats (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    _path text NOT NULL,
    id character varying NOT NULL,
    block_name character varying
);


ALTER TABLE public.pages_blocks_stats OWNER TO postgres;

--
-- Name: pages_blocks_stats_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pages_blocks_stats_items (
    _order integer NOT NULL,
    _parent_id character varying NOT NULL,
    id character varying NOT NULL,
    value character varying,
    label character varying,
    icon public.enum_pages_blocks_stats_items_icon DEFAULT 'layers'::public.enum_pages_blocks_stats_items_icon,
    description character varying,
    image_id integer
);


ALTER TABLE public.pages_blocks_stats_items OWNER TO postgres;

--
-- Name: pages_blocks_testimonials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pages_blocks_testimonials (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    _path text NOT NULL,
    id character varying NOT NULL,
    eyebrow character varying DEFAULT 'Отзывы клиентов'::character varying,
    title character varying,
    block_name character varying
);


ALTER TABLE public.pages_blocks_testimonials OWNER TO postgres;

--
-- Name: pages_blocks_testimonials_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pages_blocks_testimonials_items (
    _order integer NOT NULL,
    _parent_id character varying NOT NULL,
    id character varying NOT NULL,
    quote character varying,
    author character varying,
    role character varying
);


ALTER TABLE public.pages_blocks_testimonials_items OWNER TO postgres;

--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pages_id_seq OWNER TO postgres;

--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pages_id_seq OWNED BY public.pages.id;


--
-- Name: pages_rels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pages_rels (
    id integer NOT NULL,
    "order" integer,
    parent_id integer NOT NULL,
    path character varying NOT NULL,
    projects_id integer
);


ALTER TABLE public.pages_rels OWNER TO postgres;

--
-- Name: pages_rels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pages_rels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pages_rels_id_seq OWNER TO postgres;

--
-- Name: pages_rels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pages_rels_id_seq OWNED BY public.pages_rels.id;


--
-- Name: payload_kv; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payload_kv (
    id integer NOT NULL,
    key character varying NOT NULL,
    data jsonb NOT NULL
);


ALTER TABLE public.payload_kv OWNER TO postgres;

--
-- Name: payload_kv_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payload_kv_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payload_kv_id_seq OWNER TO postgres;

--
-- Name: payload_kv_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payload_kv_id_seq OWNED BY public.payload_kv.id;


--
-- Name: payload_locked_documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payload_locked_documents (
    id integer NOT NULL,
    global_slug character varying,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.payload_locked_documents OWNER TO postgres;

--
-- Name: payload_locked_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payload_locked_documents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payload_locked_documents_id_seq OWNER TO postgres;

--
-- Name: payload_locked_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payload_locked_documents_id_seq OWNED BY public.payload_locked_documents.id;


--
-- Name: payload_locked_documents_rels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payload_locked_documents_rels (
    id integer NOT NULL,
    "order" integer,
    parent_id integer NOT NULL,
    path character varying NOT NULL,
    media_id integer,
    pages_id integer,
    projects_id integer,
    services_id integer,
    posts_id integer,
    categories_id integer,
    leads_id integer,
    subscriptions_id integer,
    users_id integer
);


ALTER TABLE public.payload_locked_documents_rels OWNER TO postgres;

--
-- Name: payload_locked_documents_rels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payload_locked_documents_rels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payload_locked_documents_rels_id_seq OWNER TO postgres;

--
-- Name: payload_locked_documents_rels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payload_locked_documents_rels_id_seq OWNED BY public.payload_locked_documents_rels.id;


--
-- Name: payload_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payload_migrations (
    id integer NOT NULL,
    name character varying,
    batch numeric,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.payload_migrations OWNER TO postgres;

--
-- Name: payload_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payload_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payload_migrations_id_seq OWNER TO postgres;

--
-- Name: payload_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payload_migrations_id_seq OWNED BY public.payload_migrations.id;


--
-- Name: payload_preferences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payload_preferences (
    id integer NOT NULL,
    key character varying,
    value jsonb,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.payload_preferences OWNER TO postgres;

--
-- Name: payload_preferences_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payload_preferences_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payload_preferences_id_seq OWNER TO postgres;

--
-- Name: payload_preferences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payload_preferences_id_seq OWNED BY public.payload_preferences.id;


--
-- Name: payload_preferences_rels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payload_preferences_rels (
    id integer NOT NULL,
    "order" integer,
    parent_id integer NOT NULL,
    path character varying NOT NULL,
    users_id integer
);


ALTER TABLE public.payload_preferences_rels OWNER TO postgres;

--
-- Name: payload_preferences_rels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payload_preferences_rels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payload_preferences_rels_id_seq OWNER TO postgres;

--
-- Name: payload_preferences_rels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payload_preferences_rels_id_seq OWNED BY public.payload_preferences_rels.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.posts (
    id integer NOT NULL,
    title character varying,
    slug character varying,
    excerpt character varying,
    cover_image_id integer,
    category_id integer,
    content jsonb,
    author_id integer,
    published_at timestamp(3) with time zone,
    reading_time numeric,
    seo_title character varying,
    seo_description character varying,
    seo_keywords character varying,
    seo_og_image_id integer,
    seo_noindex boolean DEFAULT false,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    _status public.enum_posts_status DEFAULT 'draft'::public.enum_posts_status
);


ALTER TABLE public.posts OWNER TO postgres;

--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.posts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.posts_id_seq OWNER TO postgres;

--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- Name: posts_rels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.posts_rels (
    id integer NOT NULL,
    "order" integer,
    parent_id integer NOT NULL,
    path character varying NOT NULL,
    categories_id integer,
    posts_id integer
);


ALTER TABLE public.posts_rels OWNER TO postgres;

--
-- Name: posts_rels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.posts_rels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.posts_rels_id_seq OWNER TO postgres;

--
-- Name: posts_rels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.posts_rels_id_seq OWNED BY public.posts_rels.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.projects (
    id integer NOT NULL,
    title character varying,
    slug character varying,
    excerpt character varying,
    cover_image_id integer,
    meta_area numeric,
    meta_property_type public.enum_projects_meta_property_type,
    meta_style public.enum_projects_meta_style,
    meta_location character varying,
    meta_year numeric,
    meta_duration character varying,
    meta_budget_range public.enum_projects_meta_budget_range,
    brief jsonb,
    solution jsonb,
    testimonial_quote character varying,
    testimonial_author character varying,
    testimonial_role character varying,
    testimonial_photo_id integer,
    seo_title character varying,
    seo_description character varying,
    seo_keywords character varying,
    seo_og_image_id integer,
    featured boolean DEFAULT false,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    _status public.enum_projects_status DEFAULT 'draft'::public.enum_projects_status
);


ALTER TABLE public.projects OWNER TO postgres;

--
-- Name: projects_gallery; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.projects_gallery (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    id character varying NOT NULL,
    image_id integer,
    caption character varying,
    type public.enum_projects_gallery_type DEFAULT 'after'::public.enum_projects_gallery_type
);


ALTER TABLE public.projects_gallery OWNER TO postgres;

--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.projects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.projects_id_seq OWNER TO postgres;

--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- Name: projects_rels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.projects_rels (
    id integer NOT NULL,
    "order" integer,
    parent_id integer NOT NULL,
    path character varying NOT NULL,
    categories_id integer
);


ALTER TABLE public.projects_rels OWNER TO postgres;

--
-- Name: projects_rels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.projects_rels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.projects_rels_id_seq OWNER TO postgres;

--
-- Name: projects_rels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.projects_rels_id_seq OWNED BY public.projects_rels.id;


--
-- Name: services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.services (
    id integer NOT NULL,
    title character varying,
    slug character varying,
    short_description character varying,
    hero_headline character varying,
    hero_subheadline character varying,
    hero_image_id integer,
    body jsonb,
    pricing_price_from numeric,
    pricing_unit public.enum_services_pricing_unit DEFAULT 'project'::public.enum_services_pricing_unit,
    pricing_note character varying,
    seo_title character varying,
    seo_description character varying,
    seo_keywords character varying,
    seo_og_image_id integer,
    "order" numeric DEFAULT 0,
    featured boolean DEFAULT false,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    _status public.enum_services_status DEFAULT 'draft'::public.enum_services_status,
    card_image_id integer,
    tagline character varying
);


ALTER TABLE public.services OWNER TO postgres;

--
-- Name: services_deliverables; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.services_deliverables (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    id character varying NOT NULL,
    item character varying,
    description character varying
);


ALTER TABLE public.services_deliverables OWNER TO postgres;

--
-- Name: services_faqs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.services_faqs (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    id character varying NOT NULL,
    question character varying,
    answer character varying
);


ALTER TABLE public.services_faqs OWNER TO postgres;

--
-- Name: services_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.services_id_seq OWNER TO postgres;

--
-- Name: services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.services_id_seq OWNED BY public.services.id;


--
-- Name: services_pain_points; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.services_pain_points (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    id character varying NOT NULL,
    point character varying
);


ALTER TABLE public.services_pain_points OWNER TO postgres;

--
-- Name: services_rels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.services_rels (
    id integer NOT NULL,
    "order" integer,
    parent_id integer NOT NULL,
    path character varying NOT NULL,
    projects_id integer
);


ALTER TABLE public.services_rels OWNER TO postgres;

--
-- Name: services_rels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.services_rels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.services_rels_id_seq OWNER TO postgres;

--
-- Name: services_rels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.services_rels_id_seq OWNED BY public.services_rels.id;


--
-- Name: settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.settings (
    id integer NOT NULL,
    brand_name character varying DEFAULT 'idesignart'::character varying,
    brand_tagline character varying,
    brand_logo_id integer,
    brand_logo_dark_id integer,
    contacts_email character varying,
    contacts_phone character varying,
    contacts_whatsapp character varying,
    contacts_telegram character varying,
    contacts_instagram character varying,
    contacts_address character varying,
    contacts_map_embed character varying,
    seo_defaults_title character varying,
    seo_defaults_description_template character varying,
    seo_defaults_default_og_image_id integer,
    seo_defaults_google_verification character varying,
    seo_defaults_yandex_verification character varying,
    analytics_ga_id character varying,
    analytics_yandex_metrika_id character varying,
    analytics_plausible_domain character varying,
    lead_magnet_enabled boolean DEFAULT true,
    lead_magnet_title character varying,
    lead_magnet_subtitle character varying,
    lead_magnet_guide_file_id integer,
    lead_magnet_image_id integer,
    updated_at timestamp(3) with time zone,
    created_at timestamp(3) with time zone
);


ALTER TABLE public.settings OWNER TO postgres;

--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.settings_id_seq OWNER TO postgres;

--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.settings_id_seq OWNED BY public.settings.id;


--
-- Name: settings_social_proof_press_logos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.settings_social_proof_press_logos (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    id character varying NOT NULL,
    name character varying,
    logo_id integer,
    url character varying
);


ALTER TABLE public.settings_social_proof_press_logos OWNER TO postgres;

--
-- Name: settings_social_proof_stats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.settings_social_proof_stats (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    id character varying NOT NULL,
    value character varying NOT NULL,
    label character varying NOT NULL
);


ALTER TABLE public.settings_social_proof_stats OWNER TO postgres;

--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subscriptions (
    id integer NOT NULL,
    email character varying NOT NULL,
    name character varying,
    source public.enum_subscriptions_source DEFAULT 'lead-magnet'::public.enum_subscriptions_source,
    lead_magnet character varying,
    status public.enum_subscriptions_status DEFAULT 'subscribed'::public.enum_subscriptions_status,
    consent boolean DEFAULT false NOT NULL,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.subscriptions OWNER TO postgres;

--
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.subscriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.subscriptions_id_seq OWNER TO postgres;

--
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.subscriptions_id_seq OWNED BY public.subscriptions.id;


--
-- Name: subscriptions_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subscriptions_tags (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    id character varying NOT NULL,
    tag character varying
);


ALTER TABLE public.subscriptions_tags OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying NOT NULL,
    role public.enum_users_role DEFAULT 'editor'::public.enum_users_role NOT NULL,
    updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(3) with time zone DEFAULT now() NOT NULL,
    email character varying NOT NULL,
    reset_password_token character varying,
    reset_password_expiration timestamp(3) with time zone,
    salt character varying,
    hash character varying,
    login_attempts numeric DEFAULT 0,
    lock_until timestamp(3) with time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: users_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users_sessions (
    _order integer NOT NULL,
    _parent_id integer NOT NULL,
    id character varying NOT NULL,
    created_at timestamp(3) with time zone,
    expires_at timestamp(3) with time zone NOT NULL
);


ALTER TABLE public.users_sessions OWNER TO postgres;

--
-- Name: _pages_v id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v ALTER COLUMN id SET DEFAULT nextval('public._pages_v_id_seq'::regclass);


--
-- Name: _pages_v_blocks_contact_form id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_contact_form ALTER COLUMN id SET DEFAULT nextval('public._pages_v_blocks_contact_form_id_seq'::regclass);


--
-- Name: _pages_v_blocks_content id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_content ALTER COLUMN id SET DEFAULT nextval('public._pages_v_blocks_content_id_seq'::regclass);


--
-- Name: _pages_v_blocks_cta_banner id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_cta_banner ALTER COLUMN id SET DEFAULT nextval('public._pages_v_blocks_cta_banner_id_seq'::regclass);


--
-- Name: _pages_v_blocks_hero id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_hero ALTER COLUMN id SET DEFAULT nextval('public._pages_v_blocks_hero_id_seq'::regclass);


--
-- Name: _pages_v_blocks_hero_hero_title_lines id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_hero_hero_title_lines ALTER COLUMN id SET DEFAULT nextval('public._pages_v_blocks_hero_hero_title_lines_id_seq'::regclass);


--
-- Name: _pages_v_blocks_portfolio_grid id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_portfolio_grid ALTER COLUMN id SET DEFAULT nextval('public._pages_v_blocks_portfolio_grid_id_seq'::regclass);


--
-- Name: _pages_v_blocks_portfolio_grid_facts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_portfolio_grid_facts ALTER COLUMN id SET DEFAULT nextval('public._pages_v_blocks_portfolio_grid_facts_id_seq'::regclass);


--
-- Name: _pages_v_blocks_pricing_calculator id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_pricing_calculator ALTER COLUMN id SET DEFAULT nextval('public._pages_v_blocks_pricing_calculator_id_seq'::regclass);


--
-- Name: _pages_v_blocks_process_steps id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_process_steps ALTER COLUMN id SET DEFAULT nextval('public._pages_v_blocks_process_steps_id_seq'::regclass);


--
-- Name: _pages_v_blocks_process_steps_steps id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_process_steps_steps ALTER COLUMN id SET DEFAULT nextval('public._pages_v_blocks_process_steps_steps_id_seq'::regclass);


--
-- Name: _pages_v_blocks_services_grid id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_services_grid ALTER COLUMN id SET DEFAULT nextval('public._pages_v_blocks_services_grid_id_seq'::regclass);


--
-- Name: _pages_v_blocks_stats id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_stats ALTER COLUMN id SET DEFAULT nextval('public._pages_v_blocks_stats_id_seq'::regclass);


--
-- Name: _pages_v_blocks_stats_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_stats_items ALTER COLUMN id SET DEFAULT nextval('public._pages_v_blocks_stats_items_id_seq'::regclass);


--
-- Name: _pages_v_blocks_testimonials id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_testimonials ALTER COLUMN id SET DEFAULT nextval('public._pages_v_blocks_testimonials_id_seq'::regclass);


--
-- Name: _pages_v_blocks_testimonials_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_testimonials_items ALTER COLUMN id SET DEFAULT nextval('public._pages_v_blocks_testimonials_items_id_seq'::regclass);


--
-- Name: _pages_v_rels id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_rels ALTER COLUMN id SET DEFAULT nextval('public._pages_v_rels_id_seq'::regclass);


--
-- Name: _posts_v id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._posts_v ALTER COLUMN id SET DEFAULT nextval('public._posts_v_id_seq'::regclass);


--
-- Name: _posts_v_rels id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._posts_v_rels ALTER COLUMN id SET DEFAULT nextval('public._posts_v_rels_id_seq'::regclass);


--
-- Name: _projects_v id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._projects_v ALTER COLUMN id SET DEFAULT nextval('public._projects_v_id_seq'::regclass);


--
-- Name: _projects_v_rels id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._projects_v_rels ALTER COLUMN id SET DEFAULT nextval('public._projects_v_rels_id_seq'::regclass);


--
-- Name: _projects_v_version_gallery id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._projects_v_version_gallery ALTER COLUMN id SET DEFAULT nextval('public._projects_v_version_gallery_id_seq'::regclass);


--
-- Name: _services_v id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._services_v ALTER COLUMN id SET DEFAULT nextval('public._services_v_id_seq'::regclass);


--
-- Name: _services_v_rels id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._services_v_rels ALTER COLUMN id SET DEFAULT nextval('public._services_v_rels_id_seq'::regclass);


--
-- Name: _services_v_version_deliverables id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._services_v_version_deliverables ALTER COLUMN id SET DEFAULT nextval('public._services_v_version_deliverables_id_seq'::regclass);


--
-- Name: _services_v_version_faqs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._services_v_version_faqs ALTER COLUMN id SET DEFAULT nextval('public._services_v_version_faqs_id_seq'::regclass);


--
-- Name: _services_v_version_pain_points id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._services_v_version_pain_points ALTER COLUMN id SET DEFAULT nextval('public._services_v_version_pain_points_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: header id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.header ALTER COLUMN id SET DEFAULT nextval('public.header_id_seq'::regclass);


--
-- Name: leads id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leads ALTER COLUMN id SET DEFAULT nextval('public.leads_id_seq'::regclass);


--
-- Name: media id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.media ALTER COLUMN id SET DEFAULT nextval('public.media_id_seq'::regclass);


--
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages ALTER COLUMN id SET DEFAULT nextval('public.pages_id_seq'::regclass);


--
-- Name: pages_rels id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_rels ALTER COLUMN id SET DEFAULT nextval('public.pages_rels_id_seq'::regclass);


--
-- Name: payload_kv id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payload_kv ALTER COLUMN id SET DEFAULT nextval('public.payload_kv_id_seq'::regclass);


--
-- Name: payload_locked_documents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payload_locked_documents ALTER COLUMN id SET DEFAULT nextval('public.payload_locked_documents_id_seq'::regclass);


--
-- Name: payload_locked_documents_rels id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payload_locked_documents_rels ALTER COLUMN id SET DEFAULT nextval('public.payload_locked_documents_rels_id_seq'::regclass);


--
-- Name: payload_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payload_migrations ALTER COLUMN id SET DEFAULT nextval('public.payload_migrations_id_seq'::regclass);


--
-- Name: payload_preferences id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payload_preferences ALTER COLUMN id SET DEFAULT nextval('public.payload_preferences_id_seq'::regclass);


--
-- Name: payload_preferences_rels id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payload_preferences_rels ALTER COLUMN id SET DEFAULT nextval('public.payload_preferences_rels_id_seq'::regclass);


--
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- Name: posts_rels id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts_rels ALTER COLUMN id SET DEFAULT nextval('public.posts_rels_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- Name: projects_rels id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects_rels ALTER COLUMN id SET DEFAULT nextval('public.projects_rels_id_seq'::regclass);


--
-- Name: services id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services ALTER COLUMN id SET DEFAULT nextval('public.services_id_seq'::regclass);


--
-- Name: services_rels id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services_rels ALTER COLUMN id SET DEFAULT nextval('public.services_rels_id_seq'::regclass);


--
-- Name: settings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings ALTER COLUMN id SET DEFAULT nextval('public.settings_id_seq'::regclass);


--
-- Name: subscriptions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions ALTER COLUMN id SET DEFAULT nextval('public.subscriptions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: _pages_v_blocks_contact_form _pages_v_blocks_contact_form_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_contact_form
    ADD CONSTRAINT _pages_v_blocks_contact_form_pkey PRIMARY KEY (id);


--
-- Name: _pages_v_blocks_content _pages_v_blocks_content_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_content
    ADD CONSTRAINT _pages_v_blocks_content_pkey PRIMARY KEY (id);


--
-- Name: _pages_v_blocks_cta_banner _pages_v_blocks_cta_banner_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_cta_banner
    ADD CONSTRAINT _pages_v_blocks_cta_banner_pkey PRIMARY KEY (id);


--
-- Name: _pages_v_blocks_hero_hero_title_lines _pages_v_blocks_hero_hero_title_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_hero_hero_title_lines
    ADD CONSTRAINT _pages_v_blocks_hero_hero_title_lines_pkey PRIMARY KEY (id);


--
-- Name: _pages_v_blocks_hero _pages_v_blocks_hero_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_hero
    ADD CONSTRAINT _pages_v_blocks_hero_pkey PRIMARY KEY (id);


--
-- Name: _pages_v_blocks_portfolio_grid_facts _pages_v_blocks_portfolio_grid_facts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_portfolio_grid_facts
    ADD CONSTRAINT _pages_v_blocks_portfolio_grid_facts_pkey PRIMARY KEY (id);


--
-- Name: _pages_v_blocks_portfolio_grid _pages_v_blocks_portfolio_grid_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_portfolio_grid
    ADD CONSTRAINT _pages_v_blocks_portfolio_grid_pkey PRIMARY KEY (id);


--
-- Name: _pages_v_blocks_pricing_calculator _pages_v_blocks_pricing_calculator_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_pricing_calculator
    ADD CONSTRAINT _pages_v_blocks_pricing_calculator_pkey PRIMARY KEY (id);


--
-- Name: _pages_v_blocks_process_steps _pages_v_blocks_process_steps_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_process_steps
    ADD CONSTRAINT _pages_v_blocks_process_steps_pkey PRIMARY KEY (id);


--
-- Name: _pages_v_blocks_process_steps_steps _pages_v_blocks_process_steps_steps_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_process_steps_steps
    ADD CONSTRAINT _pages_v_blocks_process_steps_steps_pkey PRIMARY KEY (id);


--
-- Name: _pages_v_blocks_services_grid _pages_v_blocks_services_grid_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_services_grid
    ADD CONSTRAINT _pages_v_blocks_services_grid_pkey PRIMARY KEY (id);


--
-- Name: _pages_v_blocks_stats_items _pages_v_blocks_stats_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_stats_items
    ADD CONSTRAINT _pages_v_blocks_stats_items_pkey PRIMARY KEY (id);


--
-- Name: _pages_v_blocks_stats _pages_v_blocks_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_stats
    ADD CONSTRAINT _pages_v_blocks_stats_pkey PRIMARY KEY (id);


--
-- Name: _pages_v_blocks_testimonials_items _pages_v_blocks_testimonials_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_testimonials_items
    ADD CONSTRAINT _pages_v_blocks_testimonials_items_pkey PRIMARY KEY (id);


--
-- Name: _pages_v_blocks_testimonials _pages_v_blocks_testimonials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_testimonials
    ADD CONSTRAINT _pages_v_blocks_testimonials_pkey PRIMARY KEY (id);


--
-- Name: _pages_v _pages_v_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v
    ADD CONSTRAINT _pages_v_pkey PRIMARY KEY (id);


--
-- Name: _pages_v_rels _pages_v_rels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_rels
    ADD CONSTRAINT _pages_v_rels_pkey PRIMARY KEY (id);


--
-- Name: _posts_v _posts_v_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._posts_v
    ADD CONSTRAINT _posts_v_pkey PRIMARY KEY (id);


--
-- Name: _posts_v_rels _posts_v_rels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._posts_v_rels
    ADD CONSTRAINT _posts_v_rels_pkey PRIMARY KEY (id);


--
-- Name: _projects_v _projects_v_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._projects_v
    ADD CONSTRAINT _projects_v_pkey PRIMARY KEY (id);


--
-- Name: _projects_v_rels _projects_v_rels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._projects_v_rels
    ADD CONSTRAINT _projects_v_rels_pkey PRIMARY KEY (id);


--
-- Name: _projects_v_version_gallery _projects_v_version_gallery_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._projects_v_version_gallery
    ADD CONSTRAINT _projects_v_version_gallery_pkey PRIMARY KEY (id);


--
-- Name: _services_v _services_v_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._services_v
    ADD CONSTRAINT _services_v_pkey PRIMARY KEY (id);


--
-- Name: _services_v_rels _services_v_rels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._services_v_rels
    ADD CONSTRAINT _services_v_rels_pkey PRIMARY KEY (id);


--
-- Name: _services_v_version_deliverables _services_v_version_deliverables_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._services_v_version_deliverables
    ADD CONSTRAINT _services_v_version_deliverables_pkey PRIMARY KEY (id);


--
-- Name: _services_v_version_faqs _services_v_version_faqs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._services_v_version_faqs
    ADD CONSTRAINT _services_v_version_faqs_pkey PRIMARY KEY (id);


--
-- Name: _services_v_version_pain_points _services_v_version_pain_points_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._services_v_version_pain_points
    ADD CONSTRAINT _services_v_version_pain_points_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: header_navigation header_navigation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.header_navigation
    ADD CONSTRAINT header_navigation_pkey PRIMARY KEY (id);


--
-- Name: header header_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.header
    ADD CONSTRAINT header_pkey PRIMARY KEY (id);


--
-- Name: leads leads_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT leads_pkey PRIMARY KEY (id);


--
-- Name: media media_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_pkey PRIMARY KEY (id);


--
-- Name: pages_blocks_contact_form pages_blocks_contact_form_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_contact_form
    ADD CONSTRAINT pages_blocks_contact_form_pkey PRIMARY KEY (id);


--
-- Name: pages_blocks_content pages_blocks_content_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_content
    ADD CONSTRAINT pages_blocks_content_pkey PRIMARY KEY (id);


--
-- Name: pages_blocks_cta_banner pages_blocks_cta_banner_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_cta_banner
    ADD CONSTRAINT pages_blocks_cta_banner_pkey PRIMARY KEY (id);


--
-- Name: pages_blocks_hero_hero_title_lines pages_blocks_hero_hero_title_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_hero_hero_title_lines
    ADD CONSTRAINT pages_blocks_hero_hero_title_lines_pkey PRIMARY KEY (id);


--
-- Name: pages_blocks_hero pages_blocks_hero_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_hero
    ADD CONSTRAINT pages_blocks_hero_pkey PRIMARY KEY (id);


--
-- Name: pages_blocks_portfolio_grid_facts pages_blocks_portfolio_grid_facts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_portfolio_grid_facts
    ADD CONSTRAINT pages_blocks_portfolio_grid_facts_pkey PRIMARY KEY (id);


--
-- Name: pages_blocks_portfolio_grid pages_blocks_portfolio_grid_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_portfolio_grid
    ADD CONSTRAINT pages_blocks_portfolio_grid_pkey PRIMARY KEY (id);


--
-- Name: pages_blocks_pricing_calculator pages_blocks_pricing_calculator_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_pricing_calculator
    ADD CONSTRAINT pages_blocks_pricing_calculator_pkey PRIMARY KEY (id);


--
-- Name: pages_blocks_process_steps pages_blocks_process_steps_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_process_steps
    ADD CONSTRAINT pages_blocks_process_steps_pkey PRIMARY KEY (id);


--
-- Name: pages_blocks_process_steps_steps pages_blocks_process_steps_steps_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_process_steps_steps
    ADD CONSTRAINT pages_blocks_process_steps_steps_pkey PRIMARY KEY (id);


--
-- Name: pages_blocks_services_grid pages_blocks_services_grid_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_services_grid
    ADD CONSTRAINT pages_blocks_services_grid_pkey PRIMARY KEY (id);


--
-- Name: pages_blocks_stats_items pages_blocks_stats_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_stats_items
    ADD CONSTRAINT pages_blocks_stats_items_pkey PRIMARY KEY (id);


--
-- Name: pages_blocks_stats pages_blocks_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_stats
    ADD CONSTRAINT pages_blocks_stats_pkey PRIMARY KEY (id);


--
-- Name: pages_blocks_testimonials_items pages_blocks_testimonials_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_testimonials_items
    ADD CONSTRAINT pages_blocks_testimonials_items_pkey PRIMARY KEY (id);


--
-- Name: pages_blocks_testimonials pages_blocks_testimonials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_testimonials
    ADD CONSTRAINT pages_blocks_testimonials_pkey PRIMARY KEY (id);


--
-- Name: pages pages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: pages_rels pages_rels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_rels
    ADD CONSTRAINT pages_rels_pkey PRIMARY KEY (id);


--
-- Name: payload_kv payload_kv_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payload_kv
    ADD CONSTRAINT payload_kv_pkey PRIMARY KEY (id);


--
-- Name: payload_locked_documents payload_locked_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payload_locked_documents
    ADD CONSTRAINT payload_locked_documents_pkey PRIMARY KEY (id);


--
-- Name: payload_locked_documents_rels payload_locked_documents_rels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payload_locked_documents_rels
    ADD CONSTRAINT payload_locked_documents_rels_pkey PRIMARY KEY (id);


--
-- Name: payload_migrations payload_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payload_migrations
    ADD CONSTRAINT payload_migrations_pkey PRIMARY KEY (id);


--
-- Name: payload_preferences payload_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payload_preferences
    ADD CONSTRAINT payload_preferences_pkey PRIMARY KEY (id);


--
-- Name: payload_preferences_rels payload_preferences_rels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payload_preferences_rels
    ADD CONSTRAINT payload_preferences_rels_pkey PRIMARY KEY (id);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: posts_rels posts_rels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts_rels
    ADD CONSTRAINT posts_rels_pkey PRIMARY KEY (id);


--
-- Name: projects_gallery projects_gallery_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects_gallery
    ADD CONSTRAINT projects_gallery_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: projects_rels projects_rels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects_rels
    ADD CONSTRAINT projects_rels_pkey PRIMARY KEY (id);


--
-- Name: services_deliverables services_deliverables_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services_deliverables
    ADD CONSTRAINT services_deliverables_pkey PRIMARY KEY (id);


--
-- Name: services_faqs services_faqs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services_faqs
    ADD CONSTRAINT services_faqs_pkey PRIMARY KEY (id);


--
-- Name: services_pain_points services_pain_points_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services_pain_points
    ADD CONSTRAINT services_pain_points_pkey PRIMARY KEY (id);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: services_rels services_rels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services_rels
    ADD CONSTRAINT services_rels_pkey PRIMARY KEY (id);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: settings_social_proof_press_logos settings_social_proof_press_logos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings_social_proof_press_logos
    ADD CONSTRAINT settings_social_proof_press_logos_pkey PRIMARY KEY (id);


--
-- Name: settings_social_proof_stats settings_social_proof_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings_social_proof_stats
    ADD CONSTRAINT settings_social_proof_stats_pkey PRIMARY KEY (id);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: subscriptions_tags subscriptions_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions_tags
    ADD CONSTRAINT subscriptions_tags_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users_sessions users_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_sessions
    ADD CONSTRAINT users_sessions_pkey PRIMARY KEY (id);


--
-- Name: _pages_v_blocks_contact_form_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_contact_form_order_idx ON public._pages_v_blocks_contact_form USING btree (_order);


--
-- Name: _pages_v_blocks_contact_form_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_contact_form_parent_id_idx ON public._pages_v_blocks_contact_form USING btree (_parent_id);


--
-- Name: _pages_v_blocks_contact_form_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_contact_form_path_idx ON public._pages_v_blocks_contact_form USING btree (_path);


--
-- Name: _pages_v_blocks_content_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_content_order_idx ON public._pages_v_blocks_content USING btree (_order);


--
-- Name: _pages_v_blocks_content_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_content_parent_id_idx ON public._pages_v_blocks_content USING btree (_parent_id);


--
-- Name: _pages_v_blocks_content_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_content_path_idx ON public._pages_v_blocks_content USING btree (_path);


--
-- Name: _pages_v_blocks_cta_banner_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_cta_banner_order_idx ON public._pages_v_blocks_cta_banner USING btree (_order);


--
-- Name: _pages_v_blocks_cta_banner_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_cta_banner_parent_id_idx ON public._pages_v_blocks_cta_banner USING btree (_parent_id);


--
-- Name: _pages_v_blocks_cta_banner_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_cta_banner_path_idx ON public._pages_v_blocks_cta_banner USING btree (_path);


--
-- Name: _pages_v_blocks_hero_hero_hero_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_hero_hero_hero_image_idx ON public._pages_v_blocks_hero USING btree (hero_image_id);


--
-- Name: _pages_v_blocks_hero_hero_hero_mobile_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_hero_hero_hero_mobile_image_idx ON public._pages_v_blocks_hero USING btree (hero_mobile_image_id);


--
-- Name: _pages_v_blocks_hero_hero_title_lines_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_hero_hero_title_lines_order_idx ON public._pages_v_blocks_hero_hero_title_lines USING btree (_order);


--
-- Name: _pages_v_blocks_hero_hero_title_lines_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_hero_hero_title_lines_parent_id_idx ON public._pages_v_blocks_hero_hero_title_lines USING btree (_parent_id);


--
-- Name: _pages_v_blocks_hero_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_hero_order_idx ON public._pages_v_blocks_hero USING btree (_order);


--
-- Name: _pages_v_blocks_hero_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_hero_parent_id_idx ON public._pages_v_blocks_hero USING btree (_parent_id);


--
-- Name: _pages_v_blocks_hero_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_hero_path_idx ON public._pages_v_blocks_hero USING btree (_path);


--
-- Name: _pages_v_blocks_portfolio_grid_facts_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_portfolio_grid_facts_order_idx ON public._pages_v_blocks_portfolio_grid_facts USING btree (_order);


--
-- Name: _pages_v_blocks_portfolio_grid_facts_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_portfolio_grid_facts_parent_id_idx ON public._pages_v_blocks_portfolio_grid_facts USING btree (_parent_id);


--
-- Name: _pages_v_blocks_portfolio_grid_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_portfolio_grid_order_idx ON public._pages_v_blocks_portfolio_grid USING btree (_order);


--
-- Name: _pages_v_blocks_portfolio_grid_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_portfolio_grid_parent_id_idx ON public._pages_v_blocks_portfolio_grid USING btree (_parent_id);


--
-- Name: _pages_v_blocks_portfolio_grid_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_portfolio_grid_path_idx ON public._pages_v_blocks_portfolio_grid USING btree (_path);


--
-- Name: _pages_v_blocks_pricing_calculator_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_pricing_calculator_order_idx ON public._pages_v_blocks_pricing_calculator USING btree (_order);


--
-- Name: _pages_v_blocks_pricing_calculator_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_pricing_calculator_parent_id_idx ON public._pages_v_blocks_pricing_calculator USING btree (_parent_id);


--
-- Name: _pages_v_blocks_pricing_calculator_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_pricing_calculator_path_idx ON public._pages_v_blocks_pricing_calculator USING btree (_path);


--
-- Name: _pages_v_blocks_process_steps_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_process_steps_order_idx ON public._pages_v_blocks_process_steps USING btree (_order);


--
-- Name: _pages_v_blocks_process_steps_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_process_steps_parent_id_idx ON public._pages_v_blocks_process_steps USING btree (_parent_id);


--
-- Name: _pages_v_blocks_process_steps_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_process_steps_path_idx ON public._pages_v_blocks_process_steps USING btree (_path);


--
-- Name: _pages_v_blocks_process_steps_steps_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_process_steps_steps_image_idx ON public._pages_v_blocks_process_steps_steps USING btree (image_id);


--
-- Name: _pages_v_blocks_process_steps_steps_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_process_steps_steps_order_idx ON public._pages_v_blocks_process_steps_steps USING btree (_order);


--
-- Name: _pages_v_blocks_process_steps_steps_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_process_steps_steps_parent_id_idx ON public._pages_v_blocks_process_steps_steps USING btree (_parent_id);


--
-- Name: _pages_v_blocks_services_grid_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_services_grid_order_idx ON public._pages_v_blocks_services_grid USING btree (_order);


--
-- Name: _pages_v_blocks_services_grid_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_services_grid_parent_id_idx ON public._pages_v_blocks_services_grid USING btree (_parent_id);


--
-- Name: _pages_v_blocks_services_grid_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_services_grid_path_idx ON public._pages_v_blocks_services_grid USING btree (_path);


--
-- Name: _pages_v_blocks_stats_items_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_stats_items_image_idx ON public._pages_v_blocks_stats_items USING btree (image_id);


--
-- Name: _pages_v_blocks_stats_items_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_stats_items_order_idx ON public._pages_v_blocks_stats_items USING btree (_order);


--
-- Name: _pages_v_blocks_stats_items_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_stats_items_parent_id_idx ON public._pages_v_blocks_stats_items USING btree (_parent_id);


--
-- Name: _pages_v_blocks_stats_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_stats_order_idx ON public._pages_v_blocks_stats USING btree (_order);


--
-- Name: _pages_v_blocks_stats_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_stats_parent_id_idx ON public._pages_v_blocks_stats USING btree (_parent_id);


--
-- Name: _pages_v_blocks_stats_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_stats_path_idx ON public._pages_v_blocks_stats USING btree (_path);


--
-- Name: _pages_v_blocks_testimonials_items_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_testimonials_items_order_idx ON public._pages_v_blocks_testimonials_items USING btree (_order);


--
-- Name: _pages_v_blocks_testimonials_items_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_testimonials_items_parent_id_idx ON public._pages_v_blocks_testimonials_items USING btree (_parent_id);


--
-- Name: _pages_v_blocks_testimonials_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_testimonials_order_idx ON public._pages_v_blocks_testimonials USING btree (_order);


--
-- Name: _pages_v_blocks_testimonials_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_testimonials_parent_id_idx ON public._pages_v_blocks_testimonials USING btree (_parent_id);


--
-- Name: _pages_v_blocks_testimonials_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_blocks_testimonials_path_idx ON public._pages_v_blocks_testimonials USING btree (_path);


--
-- Name: _pages_v_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_created_at_idx ON public._pages_v USING btree (created_at);


--
-- Name: _pages_v_latest_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_latest_idx ON public._pages_v USING btree (latest);


--
-- Name: _pages_v_parent_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_parent_idx ON public._pages_v USING btree (parent_id);


--
-- Name: _pages_v_rels_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_rels_order_idx ON public._pages_v_rels USING btree ("order");


--
-- Name: _pages_v_rels_parent_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_rels_parent_idx ON public._pages_v_rels USING btree (parent_id);


--
-- Name: _pages_v_rels_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_rels_path_idx ON public._pages_v_rels USING btree (path);


--
-- Name: _pages_v_rels_projects_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_rels_projects_id_idx ON public._pages_v_rels USING btree (projects_id);


--
-- Name: _pages_v_updated_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_updated_at_idx ON public._pages_v USING btree (updated_at);


--
-- Name: _pages_v_version_seo_version_seo_og_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_version_seo_version_seo_og_image_idx ON public._pages_v USING btree (version_seo_og_image_id);


--
-- Name: _pages_v_version_version__status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_version_version__status_idx ON public._pages_v USING btree (version__status);


--
-- Name: _pages_v_version_version_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_version_version_created_at_idx ON public._pages_v USING btree (version_created_at);


--
-- Name: _pages_v_version_version_slug_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_version_version_slug_idx ON public._pages_v USING btree (version_slug);


--
-- Name: _pages_v_version_version_updated_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _pages_v_version_version_updated_at_idx ON public._pages_v USING btree (version_updated_at);


--
-- Name: _posts_v_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _posts_v_created_at_idx ON public._posts_v USING btree (created_at);


--
-- Name: _posts_v_latest_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _posts_v_latest_idx ON public._posts_v USING btree (latest);


--
-- Name: _posts_v_parent_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _posts_v_parent_idx ON public._posts_v USING btree (parent_id);


--
-- Name: _posts_v_rels_categories_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _posts_v_rels_categories_id_idx ON public._posts_v_rels USING btree (categories_id);


--
-- Name: _posts_v_rels_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _posts_v_rels_order_idx ON public._posts_v_rels USING btree ("order");


--
-- Name: _posts_v_rels_parent_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _posts_v_rels_parent_idx ON public._posts_v_rels USING btree (parent_id);


--
-- Name: _posts_v_rels_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _posts_v_rels_path_idx ON public._posts_v_rels USING btree (path);


--
-- Name: _posts_v_rels_posts_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _posts_v_rels_posts_id_idx ON public._posts_v_rels USING btree (posts_id);


--
-- Name: _posts_v_updated_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _posts_v_updated_at_idx ON public._posts_v USING btree (updated_at);


--
-- Name: _posts_v_version_seo_version_seo_og_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _posts_v_version_seo_version_seo_og_image_idx ON public._posts_v USING btree (version_seo_og_image_id);


--
-- Name: _posts_v_version_version__status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _posts_v_version_version__status_idx ON public._posts_v USING btree (version__status);


--
-- Name: _posts_v_version_version_author_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _posts_v_version_version_author_idx ON public._posts_v USING btree (version_author_id);


--
-- Name: _posts_v_version_version_category_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _posts_v_version_version_category_idx ON public._posts_v USING btree (version_category_id);


--
-- Name: _posts_v_version_version_cover_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _posts_v_version_version_cover_image_idx ON public._posts_v USING btree (version_cover_image_id);


--
-- Name: _posts_v_version_version_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _posts_v_version_version_created_at_idx ON public._posts_v USING btree (version_created_at);


--
-- Name: _posts_v_version_version_slug_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _posts_v_version_version_slug_idx ON public._posts_v USING btree (version_slug);


--
-- Name: _posts_v_version_version_updated_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _posts_v_version_version_updated_at_idx ON public._posts_v USING btree (version_updated_at);


--
-- Name: _projects_v_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _projects_v_created_at_idx ON public._projects_v USING btree (created_at);


--
-- Name: _projects_v_latest_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _projects_v_latest_idx ON public._projects_v USING btree (latest);


--
-- Name: _projects_v_parent_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _projects_v_parent_idx ON public._projects_v USING btree (parent_id);


--
-- Name: _projects_v_rels_categories_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _projects_v_rels_categories_id_idx ON public._projects_v_rels USING btree (categories_id);


--
-- Name: _projects_v_rels_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _projects_v_rels_order_idx ON public._projects_v_rels USING btree ("order");


--
-- Name: _projects_v_rels_parent_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _projects_v_rels_parent_idx ON public._projects_v_rels USING btree (parent_id);


--
-- Name: _projects_v_rels_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _projects_v_rels_path_idx ON public._projects_v_rels USING btree (path);


--
-- Name: _projects_v_updated_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _projects_v_updated_at_idx ON public._projects_v USING btree (updated_at);


--
-- Name: _projects_v_version_gallery_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _projects_v_version_gallery_image_idx ON public._projects_v_version_gallery USING btree (image_id);


--
-- Name: _projects_v_version_gallery_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _projects_v_version_gallery_order_idx ON public._projects_v_version_gallery USING btree (_order);


--
-- Name: _projects_v_version_gallery_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _projects_v_version_gallery_parent_id_idx ON public._projects_v_version_gallery USING btree (_parent_id);


--
-- Name: _projects_v_version_seo_version_seo_og_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _projects_v_version_seo_version_seo_og_image_idx ON public._projects_v USING btree (version_seo_og_image_id);


--
-- Name: _projects_v_version_testimonial_version_testimonial_phot_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _projects_v_version_testimonial_version_testimonial_phot_idx ON public._projects_v USING btree (version_testimonial_photo_id);


--
-- Name: _projects_v_version_version__status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _projects_v_version_version__status_idx ON public._projects_v USING btree (version__status);


--
-- Name: _projects_v_version_version_cover_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _projects_v_version_version_cover_image_idx ON public._projects_v USING btree (version_cover_image_id);


--
-- Name: _projects_v_version_version_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _projects_v_version_version_created_at_idx ON public._projects_v USING btree (version_created_at);


--
-- Name: _projects_v_version_version_slug_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _projects_v_version_version_slug_idx ON public._projects_v USING btree (version_slug);


--
-- Name: _projects_v_version_version_updated_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _projects_v_version_version_updated_at_idx ON public._projects_v USING btree (version_updated_at);


--
-- Name: _services_v_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _services_v_created_at_idx ON public._services_v USING btree (created_at);


--
-- Name: _services_v_latest_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _services_v_latest_idx ON public._services_v USING btree (latest);


--
-- Name: _services_v_parent_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _services_v_parent_idx ON public._services_v USING btree (parent_id);


--
-- Name: _services_v_rels_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _services_v_rels_order_idx ON public._services_v_rels USING btree ("order");


--
-- Name: _services_v_rels_parent_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _services_v_rels_parent_idx ON public._services_v_rels USING btree (parent_id);


--
-- Name: _services_v_rels_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _services_v_rels_path_idx ON public._services_v_rels USING btree (path);


--
-- Name: _services_v_rels_projects_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _services_v_rels_projects_id_idx ON public._services_v_rels USING btree (projects_id);


--
-- Name: _services_v_updated_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _services_v_updated_at_idx ON public._services_v USING btree (updated_at);


--
-- Name: _services_v_version_deliverables_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _services_v_version_deliverables_order_idx ON public._services_v_version_deliverables USING btree (_order);


--
-- Name: _services_v_version_deliverables_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _services_v_version_deliverables_parent_id_idx ON public._services_v_version_deliverables USING btree (_parent_id);


--
-- Name: _services_v_version_faqs_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _services_v_version_faqs_order_idx ON public._services_v_version_faqs USING btree (_order);


--
-- Name: _services_v_version_faqs_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _services_v_version_faqs_parent_id_idx ON public._services_v_version_faqs USING btree (_parent_id);


--
-- Name: _services_v_version_pain_points_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _services_v_version_pain_points_order_idx ON public._services_v_version_pain_points USING btree (_order);


--
-- Name: _services_v_version_pain_points_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _services_v_version_pain_points_parent_id_idx ON public._services_v_version_pain_points USING btree (_parent_id);


--
-- Name: _services_v_version_seo_version_seo_og_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _services_v_version_seo_version_seo_og_image_idx ON public._services_v USING btree (version_seo_og_image_id);


--
-- Name: _services_v_version_version__status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _services_v_version_version__status_idx ON public._services_v USING btree (version__status);


--
-- Name: _services_v_version_version_card_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _services_v_version_version_card_image_idx ON public._services_v USING btree (version_card_image_id);


--
-- Name: _services_v_version_version_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _services_v_version_version_created_at_idx ON public._services_v USING btree (version_created_at);


--
-- Name: _services_v_version_version_hero_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _services_v_version_version_hero_image_idx ON public._services_v USING btree (version_hero_image_id);


--
-- Name: _services_v_version_version_slug_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _services_v_version_version_slug_idx ON public._services_v USING btree (version_slug);


--
-- Name: _services_v_version_version_updated_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX _services_v_version_version_updated_at_idx ON public._services_v USING btree (version_updated_at);


--
-- Name: categories_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX categories_created_at_idx ON public.categories USING btree (created_at);


--
-- Name: categories_seo_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX categories_seo_image_idx ON public.categories USING btree (seo_image_id);


--
-- Name: categories_slug_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX categories_slug_idx ON public.categories USING btree (slug);


--
-- Name: categories_updated_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX categories_updated_at_idx ON public.categories USING btree (updated_at);


--
-- Name: header_navigation_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX header_navigation_order_idx ON public.header_navigation USING btree (_order);


--
-- Name: header_navigation_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX header_navigation_parent_id_idx ON public.header_navigation USING btree (_parent_id);


--
-- Name: leads_assigned_to_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX leads_assigned_to_idx ON public.leads USING btree (assigned_to_id);


--
-- Name: leads_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX leads_created_at_idx ON public.leads USING btree (created_at);


--
-- Name: leads_service_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX leads_service_idx ON public.leads USING btree (service_id);


--
-- Name: leads_updated_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX leads_updated_at_idx ON public.leads USING btree (updated_at);


--
-- Name: media_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX media_created_at_idx ON public.media USING btree (created_at);


--
-- Name: media_filename_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX media_filename_idx ON public.media USING btree (filename);


--
-- Name: media_sizes_card_sizes_card_filename_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX media_sizes_card_sizes_card_filename_idx ON public.media USING btree (sizes_card_filename);


--
-- Name: media_sizes_desktop_sizes_desktop_filename_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX media_sizes_desktop_sizes_desktop_filename_idx ON public.media USING btree (sizes_desktop_filename);


--
-- Name: media_sizes_featured_sizes_featured_filename_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX media_sizes_featured_sizes_featured_filename_idx ON public.media USING btree (sizes_featured_filename);


--
-- Name: media_sizes_tablet_sizes_tablet_filename_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX media_sizes_tablet_sizes_tablet_filename_idx ON public.media USING btree (sizes_tablet_filename);


--
-- Name: media_sizes_thumbnail_sizes_thumbnail_filename_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX media_sizes_thumbnail_sizes_thumbnail_filename_idx ON public.media USING btree (sizes_thumbnail_filename);


--
-- Name: media_updated_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX media_updated_at_idx ON public.media USING btree (updated_at);


--
-- Name: pages__status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages__status_idx ON public.pages USING btree (_status);


--
-- Name: pages_blocks_contact_form_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_contact_form_order_idx ON public.pages_blocks_contact_form USING btree (_order);


--
-- Name: pages_blocks_contact_form_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_contact_form_parent_id_idx ON public.pages_blocks_contact_form USING btree (_parent_id);


--
-- Name: pages_blocks_contact_form_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_contact_form_path_idx ON public.pages_blocks_contact_form USING btree (_path);


--
-- Name: pages_blocks_content_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_content_order_idx ON public.pages_blocks_content USING btree (_order);


--
-- Name: pages_blocks_content_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_content_parent_id_idx ON public.pages_blocks_content USING btree (_parent_id);


--
-- Name: pages_blocks_content_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_content_path_idx ON public.pages_blocks_content USING btree (_path);


--
-- Name: pages_blocks_cta_banner_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_cta_banner_order_idx ON public.pages_blocks_cta_banner USING btree (_order);


--
-- Name: pages_blocks_cta_banner_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_cta_banner_parent_id_idx ON public.pages_blocks_cta_banner USING btree (_parent_id);


--
-- Name: pages_blocks_cta_banner_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_cta_banner_path_idx ON public.pages_blocks_cta_banner USING btree (_path);


--
-- Name: pages_blocks_hero_hero_hero_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_hero_hero_hero_image_idx ON public.pages_blocks_hero USING btree (hero_image_id);


--
-- Name: pages_blocks_hero_hero_hero_mobile_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_hero_hero_hero_mobile_image_idx ON public.pages_blocks_hero USING btree (hero_mobile_image_id);


--
-- Name: pages_blocks_hero_hero_title_lines_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_hero_hero_title_lines_order_idx ON public.pages_blocks_hero_hero_title_lines USING btree (_order);


--
-- Name: pages_blocks_hero_hero_title_lines_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_hero_hero_title_lines_parent_id_idx ON public.pages_blocks_hero_hero_title_lines USING btree (_parent_id);


--
-- Name: pages_blocks_hero_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_hero_order_idx ON public.pages_blocks_hero USING btree (_order);


--
-- Name: pages_blocks_hero_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_hero_parent_id_idx ON public.pages_blocks_hero USING btree (_parent_id);


--
-- Name: pages_blocks_hero_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_hero_path_idx ON public.pages_blocks_hero USING btree (_path);


--
-- Name: pages_blocks_portfolio_grid_facts_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_portfolio_grid_facts_order_idx ON public.pages_blocks_portfolio_grid_facts USING btree (_order);


--
-- Name: pages_blocks_portfolio_grid_facts_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_portfolio_grid_facts_parent_id_idx ON public.pages_blocks_portfolio_grid_facts USING btree (_parent_id);


--
-- Name: pages_blocks_portfolio_grid_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_portfolio_grid_order_idx ON public.pages_blocks_portfolio_grid USING btree (_order);


--
-- Name: pages_blocks_portfolio_grid_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_portfolio_grid_parent_id_idx ON public.pages_blocks_portfolio_grid USING btree (_parent_id);


--
-- Name: pages_blocks_portfolio_grid_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_portfolio_grid_path_idx ON public.pages_blocks_portfolio_grid USING btree (_path);


--
-- Name: pages_blocks_pricing_calculator_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_pricing_calculator_order_idx ON public.pages_blocks_pricing_calculator USING btree (_order);


--
-- Name: pages_blocks_pricing_calculator_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_pricing_calculator_parent_id_idx ON public.pages_blocks_pricing_calculator USING btree (_parent_id);


--
-- Name: pages_blocks_pricing_calculator_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_pricing_calculator_path_idx ON public.pages_blocks_pricing_calculator USING btree (_path);


--
-- Name: pages_blocks_process_steps_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_process_steps_order_idx ON public.pages_blocks_process_steps USING btree (_order);


--
-- Name: pages_blocks_process_steps_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_process_steps_parent_id_idx ON public.pages_blocks_process_steps USING btree (_parent_id);


--
-- Name: pages_blocks_process_steps_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_process_steps_path_idx ON public.pages_blocks_process_steps USING btree (_path);


--
-- Name: pages_blocks_process_steps_steps_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_process_steps_steps_image_idx ON public.pages_blocks_process_steps_steps USING btree (image_id);


--
-- Name: pages_blocks_process_steps_steps_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_process_steps_steps_order_idx ON public.pages_blocks_process_steps_steps USING btree (_order);


--
-- Name: pages_blocks_process_steps_steps_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_process_steps_steps_parent_id_idx ON public.pages_blocks_process_steps_steps USING btree (_parent_id);


--
-- Name: pages_blocks_services_grid_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_services_grid_order_idx ON public.pages_blocks_services_grid USING btree (_order);


--
-- Name: pages_blocks_services_grid_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_services_grid_parent_id_idx ON public.pages_blocks_services_grid USING btree (_parent_id);


--
-- Name: pages_blocks_services_grid_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_services_grid_path_idx ON public.pages_blocks_services_grid USING btree (_path);


--
-- Name: pages_blocks_stats_items_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_stats_items_image_idx ON public.pages_blocks_stats_items USING btree (image_id);


--
-- Name: pages_blocks_stats_items_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_stats_items_order_idx ON public.pages_blocks_stats_items USING btree (_order);


--
-- Name: pages_blocks_stats_items_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_stats_items_parent_id_idx ON public.pages_blocks_stats_items USING btree (_parent_id);


--
-- Name: pages_blocks_stats_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_stats_order_idx ON public.pages_blocks_stats USING btree (_order);


--
-- Name: pages_blocks_stats_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_stats_parent_id_idx ON public.pages_blocks_stats USING btree (_parent_id);


--
-- Name: pages_blocks_stats_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_stats_path_idx ON public.pages_blocks_stats USING btree (_path);


--
-- Name: pages_blocks_testimonials_items_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_testimonials_items_order_idx ON public.pages_blocks_testimonials_items USING btree (_order);


--
-- Name: pages_blocks_testimonials_items_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_testimonials_items_parent_id_idx ON public.pages_blocks_testimonials_items USING btree (_parent_id);


--
-- Name: pages_blocks_testimonials_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_testimonials_order_idx ON public.pages_blocks_testimonials USING btree (_order);


--
-- Name: pages_blocks_testimonials_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_testimonials_parent_id_idx ON public.pages_blocks_testimonials USING btree (_parent_id);


--
-- Name: pages_blocks_testimonials_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_blocks_testimonials_path_idx ON public.pages_blocks_testimonials USING btree (_path);


--
-- Name: pages_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_created_at_idx ON public.pages USING btree (created_at);


--
-- Name: pages_rels_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_rels_order_idx ON public.pages_rels USING btree ("order");


--
-- Name: pages_rels_parent_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_rels_parent_idx ON public.pages_rels USING btree (parent_id);


--
-- Name: pages_rels_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_rels_path_idx ON public.pages_rels USING btree (path);


--
-- Name: pages_rels_projects_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_rels_projects_id_idx ON public.pages_rels USING btree (projects_id);


--
-- Name: pages_seo_seo_og_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_seo_seo_og_image_idx ON public.pages USING btree (seo_og_image_id);


--
-- Name: pages_slug_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX pages_slug_idx ON public.pages USING btree (slug);


--
-- Name: pages_updated_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pages_updated_at_idx ON public.pages USING btree (updated_at);


--
-- Name: payload_kv_key_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX payload_kv_key_idx ON public.payload_kv USING btree (key);


--
-- Name: payload_locked_documents_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payload_locked_documents_created_at_idx ON public.payload_locked_documents USING btree (created_at);


--
-- Name: payload_locked_documents_global_slug_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payload_locked_documents_global_slug_idx ON public.payload_locked_documents USING btree (global_slug);


--
-- Name: payload_locked_documents_rels_categories_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payload_locked_documents_rels_categories_id_idx ON public.payload_locked_documents_rels USING btree (categories_id);


--
-- Name: payload_locked_documents_rels_leads_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payload_locked_documents_rels_leads_id_idx ON public.payload_locked_documents_rels USING btree (leads_id);


--
-- Name: payload_locked_documents_rels_media_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payload_locked_documents_rels_media_id_idx ON public.payload_locked_documents_rels USING btree (media_id);


--
-- Name: payload_locked_documents_rels_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payload_locked_documents_rels_order_idx ON public.payload_locked_documents_rels USING btree ("order");


--
-- Name: payload_locked_documents_rels_pages_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payload_locked_documents_rels_pages_id_idx ON public.payload_locked_documents_rels USING btree (pages_id);


--
-- Name: payload_locked_documents_rels_parent_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payload_locked_documents_rels_parent_idx ON public.payload_locked_documents_rels USING btree (parent_id);


--
-- Name: payload_locked_documents_rels_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payload_locked_documents_rels_path_idx ON public.payload_locked_documents_rels USING btree (path);


--
-- Name: payload_locked_documents_rels_posts_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payload_locked_documents_rels_posts_id_idx ON public.payload_locked_documents_rels USING btree (posts_id);


--
-- Name: payload_locked_documents_rels_projects_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payload_locked_documents_rels_projects_id_idx ON public.payload_locked_documents_rels USING btree (projects_id);


--
-- Name: payload_locked_documents_rels_services_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payload_locked_documents_rels_services_id_idx ON public.payload_locked_documents_rels USING btree (services_id);


--
-- Name: payload_locked_documents_rels_subscriptions_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payload_locked_documents_rels_subscriptions_id_idx ON public.payload_locked_documents_rels USING btree (subscriptions_id);


--
-- Name: payload_locked_documents_rels_users_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payload_locked_documents_rels_users_id_idx ON public.payload_locked_documents_rels USING btree (users_id);


--
-- Name: payload_locked_documents_updated_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payload_locked_documents_updated_at_idx ON public.payload_locked_documents USING btree (updated_at);


--
-- Name: payload_migrations_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payload_migrations_created_at_idx ON public.payload_migrations USING btree (created_at);


--
-- Name: payload_migrations_updated_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payload_migrations_updated_at_idx ON public.payload_migrations USING btree (updated_at);


--
-- Name: payload_preferences_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payload_preferences_created_at_idx ON public.payload_preferences USING btree (created_at);


--
-- Name: payload_preferences_key_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payload_preferences_key_idx ON public.payload_preferences USING btree (key);


--
-- Name: payload_preferences_rels_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payload_preferences_rels_order_idx ON public.payload_preferences_rels USING btree ("order");


--
-- Name: payload_preferences_rels_parent_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payload_preferences_rels_parent_idx ON public.payload_preferences_rels USING btree (parent_id);


--
-- Name: payload_preferences_rels_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payload_preferences_rels_path_idx ON public.payload_preferences_rels USING btree (path);


--
-- Name: payload_preferences_rels_users_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payload_preferences_rels_users_id_idx ON public.payload_preferences_rels USING btree (users_id);


--
-- Name: payload_preferences_updated_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payload_preferences_updated_at_idx ON public.payload_preferences USING btree (updated_at);


--
-- Name: posts__status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX posts__status_idx ON public.posts USING btree (_status);


--
-- Name: posts_author_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX posts_author_idx ON public.posts USING btree (author_id);


--
-- Name: posts_category_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX posts_category_idx ON public.posts USING btree (category_id);


--
-- Name: posts_cover_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX posts_cover_image_idx ON public.posts USING btree (cover_image_id);


--
-- Name: posts_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX posts_created_at_idx ON public.posts USING btree (created_at);


--
-- Name: posts_rels_categories_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX posts_rels_categories_id_idx ON public.posts_rels USING btree (categories_id);


--
-- Name: posts_rels_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX posts_rels_order_idx ON public.posts_rels USING btree ("order");


--
-- Name: posts_rels_parent_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX posts_rels_parent_idx ON public.posts_rels USING btree (parent_id);


--
-- Name: posts_rels_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX posts_rels_path_idx ON public.posts_rels USING btree (path);


--
-- Name: posts_rels_posts_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX posts_rels_posts_id_idx ON public.posts_rels USING btree (posts_id);


--
-- Name: posts_seo_seo_og_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX posts_seo_seo_og_image_idx ON public.posts USING btree (seo_og_image_id);


--
-- Name: posts_slug_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX posts_slug_idx ON public.posts USING btree (slug);


--
-- Name: posts_updated_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX posts_updated_at_idx ON public.posts USING btree (updated_at);


--
-- Name: projects__status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX projects__status_idx ON public.projects USING btree (_status);


--
-- Name: projects_cover_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX projects_cover_image_idx ON public.projects USING btree (cover_image_id);


--
-- Name: projects_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX projects_created_at_idx ON public.projects USING btree (created_at);


--
-- Name: projects_gallery_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX projects_gallery_image_idx ON public.projects_gallery USING btree (image_id);


--
-- Name: projects_gallery_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX projects_gallery_order_idx ON public.projects_gallery USING btree (_order);


--
-- Name: projects_gallery_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX projects_gallery_parent_id_idx ON public.projects_gallery USING btree (_parent_id);


--
-- Name: projects_rels_categories_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX projects_rels_categories_id_idx ON public.projects_rels USING btree (categories_id);


--
-- Name: projects_rels_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX projects_rels_order_idx ON public.projects_rels USING btree ("order");


--
-- Name: projects_rels_parent_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX projects_rels_parent_idx ON public.projects_rels USING btree (parent_id);


--
-- Name: projects_rels_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX projects_rels_path_idx ON public.projects_rels USING btree (path);


--
-- Name: projects_seo_seo_og_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX projects_seo_seo_og_image_idx ON public.projects USING btree (seo_og_image_id);


--
-- Name: projects_slug_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX projects_slug_idx ON public.projects USING btree (slug);


--
-- Name: projects_testimonial_testimonial_photo_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX projects_testimonial_testimonial_photo_idx ON public.projects USING btree (testimonial_photo_id);


--
-- Name: projects_updated_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX projects_updated_at_idx ON public.projects USING btree (updated_at);


--
-- Name: services__status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX services__status_idx ON public.services USING btree (_status);


--
-- Name: services_card_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX services_card_image_idx ON public.services USING btree (card_image_id);


--
-- Name: services_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX services_created_at_idx ON public.services USING btree (created_at);


--
-- Name: services_deliverables_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX services_deliverables_order_idx ON public.services_deliverables USING btree (_order);


--
-- Name: services_deliverables_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX services_deliverables_parent_id_idx ON public.services_deliverables USING btree (_parent_id);


--
-- Name: services_faqs_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX services_faqs_order_idx ON public.services_faqs USING btree (_order);


--
-- Name: services_faqs_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX services_faqs_parent_id_idx ON public.services_faqs USING btree (_parent_id);


--
-- Name: services_hero_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX services_hero_image_idx ON public.services USING btree (hero_image_id);


--
-- Name: services_pain_points_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX services_pain_points_order_idx ON public.services_pain_points USING btree (_order);


--
-- Name: services_pain_points_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX services_pain_points_parent_id_idx ON public.services_pain_points USING btree (_parent_id);


--
-- Name: services_rels_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX services_rels_order_idx ON public.services_rels USING btree ("order");


--
-- Name: services_rels_parent_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX services_rels_parent_idx ON public.services_rels USING btree (parent_id);


--
-- Name: services_rels_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX services_rels_path_idx ON public.services_rels USING btree (path);


--
-- Name: services_rels_projects_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX services_rels_projects_id_idx ON public.services_rels USING btree (projects_id);


--
-- Name: services_seo_seo_og_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX services_seo_seo_og_image_idx ON public.services USING btree (seo_og_image_id);


--
-- Name: services_slug_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX services_slug_idx ON public.services USING btree (slug);


--
-- Name: services_updated_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX services_updated_at_idx ON public.services USING btree (updated_at);


--
-- Name: settings_brand_brand_logo_dark_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX settings_brand_brand_logo_dark_idx ON public.settings USING btree (brand_logo_dark_id);


--
-- Name: settings_brand_brand_logo_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX settings_brand_brand_logo_idx ON public.settings USING btree (brand_logo_id);


--
-- Name: settings_lead_magnet_lead_magnet_guide_file_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX settings_lead_magnet_lead_magnet_guide_file_idx ON public.settings USING btree (lead_magnet_guide_file_id);


--
-- Name: settings_lead_magnet_lead_magnet_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX settings_lead_magnet_lead_magnet_image_idx ON public.settings USING btree (lead_magnet_image_id);


--
-- Name: settings_seo_defaults_seo_defaults_default_og_image_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX settings_seo_defaults_seo_defaults_default_og_image_idx ON public.settings USING btree (seo_defaults_default_og_image_id);


--
-- Name: settings_social_proof_press_logos_logo_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX settings_social_proof_press_logos_logo_idx ON public.settings_social_proof_press_logos USING btree (logo_id);


--
-- Name: settings_social_proof_press_logos_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX settings_social_proof_press_logos_order_idx ON public.settings_social_proof_press_logos USING btree (_order);


--
-- Name: settings_social_proof_press_logos_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX settings_social_proof_press_logos_parent_id_idx ON public.settings_social_proof_press_logos USING btree (_parent_id);


--
-- Name: settings_social_proof_stats_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX settings_social_proof_stats_order_idx ON public.settings_social_proof_stats USING btree (_order);


--
-- Name: settings_social_proof_stats_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX settings_social_proof_stats_parent_id_idx ON public.settings_social_proof_stats USING btree (_parent_id);


--
-- Name: subscriptions_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX subscriptions_created_at_idx ON public.subscriptions USING btree (created_at);


--
-- Name: subscriptions_email_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX subscriptions_email_idx ON public.subscriptions USING btree (email);


--
-- Name: subscriptions_tags_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX subscriptions_tags_order_idx ON public.subscriptions_tags USING btree (_order);


--
-- Name: subscriptions_tags_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX subscriptions_tags_parent_id_idx ON public.subscriptions_tags USING btree (_parent_id);


--
-- Name: subscriptions_updated_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX subscriptions_updated_at_idx ON public.subscriptions USING btree (updated_at);


--
-- Name: users_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_created_at_idx ON public.users USING btree (created_at);


--
-- Name: users_email_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_email_idx ON public.users USING btree (email);


--
-- Name: users_sessions_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_sessions_order_idx ON public.users_sessions USING btree (_order);


--
-- Name: users_sessions_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_sessions_parent_id_idx ON public.users_sessions USING btree (_parent_id);


--
-- Name: users_updated_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_updated_at_idx ON public.users USING btree (updated_at);


--
-- Name: _pages_v_blocks_contact_form _pages_v_blocks_contact_form_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_contact_form
    ADD CONSTRAINT _pages_v_blocks_contact_form_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public._pages_v(id) ON DELETE CASCADE;


--
-- Name: _pages_v_blocks_content _pages_v_blocks_content_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_content
    ADD CONSTRAINT _pages_v_blocks_content_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public._pages_v(id) ON DELETE CASCADE;


--
-- Name: _pages_v_blocks_cta_banner _pages_v_blocks_cta_banner_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_cta_banner
    ADD CONSTRAINT _pages_v_blocks_cta_banner_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public._pages_v(id) ON DELETE CASCADE;


--
-- Name: _pages_v_blocks_hero _pages_v_blocks_hero_hero_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_hero
    ADD CONSTRAINT _pages_v_blocks_hero_hero_image_id_media_id_fk FOREIGN KEY (hero_image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: _pages_v_blocks_hero _pages_v_blocks_hero_hero_mobile_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_hero
    ADD CONSTRAINT _pages_v_blocks_hero_hero_mobile_image_id_media_id_fk FOREIGN KEY (hero_mobile_image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: _pages_v_blocks_hero_hero_title_lines _pages_v_blocks_hero_hero_title_lines_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_hero_hero_title_lines
    ADD CONSTRAINT _pages_v_blocks_hero_hero_title_lines_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public._pages_v_blocks_hero(id) ON DELETE CASCADE;


--
-- Name: _pages_v_blocks_hero _pages_v_blocks_hero_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_hero
    ADD CONSTRAINT _pages_v_blocks_hero_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public._pages_v(id) ON DELETE CASCADE;


--
-- Name: _pages_v_blocks_portfolio_grid_facts _pages_v_blocks_portfolio_grid_facts_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_portfolio_grid_facts
    ADD CONSTRAINT _pages_v_blocks_portfolio_grid_facts_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public._pages_v_blocks_portfolio_grid(id) ON DELETE CASCADE;


--
-- Name: _pages_v_blocks_portfolio_grid _pages_v_blocks_portfolio_grid_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_portfolio_grid
    ADD CONSTRAINT _pages_v_blocks_portfolio_grid_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public._pages_v(id) ON DELETE CASCADE;


--
-- Name: _pages_v_blocks_pricing_calculator _pages_v_blocks_pricing_calculator_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_pricing_calculator
    ADD CONSTRAINT _pages_v_blocks_pricing_calculator_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public._pages_v(id) ON DELETE CASCADE;


--
-- Name: _pages_v_blocks_process_steps _pages_v_blocks_process_steps_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_process_steps
    ADD CONSTRAINT _pages_v_blocks_process_steps_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public._pages_v(id) ON DELETE CASCADE;


--
-- Name: _pages_v_blocks_process_steps_steps _pages_v_blocks_process_steps_steps_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_process_steps_steps
    ADD CONSTRAINT _pages_v_blocks_process_steps_steps_image_id_media_id_fk FOREIGN KEY (image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: _pages_v_blocks_process_steps_steps _pages_v_blocks_process_steps_steps_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_process_steps_steps
    ADD CONSTRAINT _pages_v_blocks_process_steps_steps_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public._pages_v_blocks_process_steps(id) ON DELETE CASCADE;


--
-- Name: _pages_v_blocks_services_grid _pages_v_blocks_services_grid_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_services_grid
    ADD CONSTRAINT _pages_v_blocks_services_grid_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public._pages_v(id) ON DELETE CASCADE;


--
-- Name: _pages_v_blocks_stats_items _pages_v_blocks_stats_items_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_stats_items
    ADD CONSTRAINT _pages_v_blocks_stats_items_image_id_media_id_fk FOREIGN KEY (image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: _pages_v_blocks_stats_items _pages_v_blocks_stats_items_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_stats_items
    ADD CONSTRAINT _pages_v_blocks_stats_items_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public._pages_v_blocks_stats(id) ON DELETE CASCADE;


--
-- Name: _pages_v_blocks_stats _pages_v_blocks_stats_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_stats
    ADD CONSTRAINT _pages_v_blocks_stats_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public._pages_v(id) ON DELETE CASCADE;


--
-- Name: _pages_v_blocks_testimonials_items _pages_v_blocks_testimonials_items_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_testimonials_items
    ADD CONSTRAINT _pages_v_blocks_testimonials_items_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public._pages_v_blocks_testimonials(id) ON DELETE CASCADE;


--
-- Name: _pages_v_blocks_testimonials _pages_v_blocks_testimonials_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_blocks_testimonials
    ADD CONSTRAINT _pages_v_blocks_testimonials_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public._pages_v(id) ON DELETE CASCADE;


--
-- Name: _pages_v _pages_v_parent_id_pages_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v
    ADD CONSTRAINT _pages_v_parent_id_pages_id_fk FOREIGN KEY (parent_id) REFERENCES public.pages(id) ON DELETE SET NULL;


--
-- Name: _pages_v_rels _pages_v_rels_parent_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_rels
    ADD CONSTRAINT _pages_v_rels_parent_fk FOREIGN KEY (parent_id) REFERENCES public._pages_v(id) ON DELETE CASCADE;


--
-- Name: _pages_v_rels _pages_v_rels_projects_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v_rels
    ADD CONSTRAINT _pages_v_rels_projects_fk FOREIGN KEY (projects_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: _pages_v _pages_v_version_seo_og_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._pages_v
    ADD CONSTRAINT _pages_v_version_seo_og_image_id_media_id_fk FOREIGN KEY (version_seo_og_image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: _posts_v _posts_v_parent_id_posts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._posts_v
    ADD CONSTRAINT _posts_v_parent_id_posts_id_fk FOREIGN KEY (parent_id) REFERENCES public.posts(id) ON DELETE SET NULL;


--
-- Name: _posts_v_rels _posts_v_rels_categories_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._posts_v_rels
    ADD CONSTRAINT _posts_v_rels_categories_fk FOREIGN KEY (categories_id) REFERENCES public.categories(id) ON DELETE CASCADE;


--
-- Name: _posts_v_rels _posts_v_rels_parent_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._posts_v_rels
    ADD CONSTRAINT _posts_v_rels_parent_fk FOREIGN KEY (parent_id) REFERENCES public._posts_v(id) ON DELETE CASCADE;


--
-- Name: _posts_v_rels _posts_v_rels_posts_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._posts_v_rels
    ADD CONSTRAINT _posts_v_rels_posts_fk FOREIGN KEY (posts_id) REFERENCES public.posts(id) ON DELETE CASCADE;


--
-- Name: _posts_v _posts_v_version_author_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._posts_v
    ADD CONSTRAINT _posts_v_version_author_id_users_id_fk FOREIGN KEY (version_author_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: _posts_v _posts_v_version_category_id_categories_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._posts_v
    ADD CONSTRAINT _posts_v_version_category_id_categories_id_fk FOREIGN KEY (version_category_id) REFERENCES public.categories(id) ON DELETE SET NULL;


--
-- Name: _posts_v _posts_v_version_cover_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._posts_v
    ADD CONSTRAINT _posts_v_version_cover_image_id_media_id_fk FOREIGN KEY (version_cover_image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: _posts_v _posts_v_version_seo_og_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._posts_v
    ADD CONSTRAINT _posts_v_version_seo_og_image_id_media_id_fk FOREIGN KEY (version_seo_og_image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: _projects_v _projects_v_parent_id_projects_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._projects_v
    ADD CONSTRAINT _projects_v_parent_id_projects_id_fk FOREIGN KEY (parent_id) REFERENCES public.projects(id) ON DELETE SET NULL;


--
-- Name: _projects_v_rels _projects_v_rels_categories_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._projects_v_rels
    ADD CONSTRAINT _projects_v_rels_categories_fk FOREIGN KEY (categories_id) REFERENCES public.categories(id) ON DELETE CASCADE;


--
-- Name: _projects_v_rels _projects_v_rels_parent_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._projects_v_rels
    ADD CONSTRAINT _projects_v_rels_parent_fk FOREIGN KEY (parent_id) REFERENCES public._projects_v(id) ON DELETE CASCADE;


--
-- Name: _projects_v _projects_v_version_cover_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._projects_v
    ADD CONSTRAINT _projects_v_version_cover_image_id_media_id_fk FOREIGN KEY (version_cover_image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: _projects_v_version_gallery _projects_v_version_gallery_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._projects_v_version_gallery
    ADD CONSTRAINT _projects_v_version_gallery_image_id_media_id_fk FOREIGN KEY (image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: _projects_v_version_gallery _projects_v_version_gallery_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._projects_v_version_gallery
    ADD CONSTRAINT _projects_v_version_gallery_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public._projects_v(id) ON DELETE CASCADE;


--
-- Name: _projects_v _projects_v_version_seo_og_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._projects_v
    ADD CONSTRAINT _projects_v_version_seo_og_image_id_media_id_fk FOREIGN KEY (version_seo_og_image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: _projects_v _projects_v_version_testimonial_photo_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._projects_v
    ADD CONSTRAINT _projects_v_version_testimonial_photo_id_media_id_fk FOREIGN KEY (version_testimonial_photo_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: _services_v _services_v_parent_id_services_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._services_v
    ADD CONSTRAINT _services_v_parent_id_services_id_fk FOREIGN KEY (parent_id) REFERENCES public.services(id) ON DELETE SET NULL;


--
-- Name: _services_v_rels _services_v_rels_parent_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._services_v_rels
    ADD CONSTRAINT _services_v_rels_parent_fk FOREIGN KEY (parent_id) REFERENCES public._services_v(id) ON DELETE CASCADE;


--
-- Name: _services_v_rels _services_v_rels_projects_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._services_v_rels
    ADD CONSTRAINT _services_v_rels_projects_fk FOREIGN KEY (projects_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: _services_v _services_v_version_card_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._services_v
    ADD CONSTRAINT _services_v_version_card_image_id_media_id_fk FOREIGN KEY (version_card_image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: _services_v_version_deliverables _services_v_version_deliverables_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._services_v_version_deliverables
    ADD CONSTRAINT _services_v_version_deliverables_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public._services_v(id) ON DELETE CASCADE;


--
-- Name: _services_v_version_faqs _services_v_version_faqs_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._services_v_version_faqs
    ADD CONSTRAINT _services_v_version_faqs_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public._services_v(id) ON DELETE CASCADE;


--
-- Name: _services_v _services_v_version_hero_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._services_v
    ADD CONSTRAINT _services_v_version_hero_image_id_media_id_fk FOREIGN KEY (version_hero_image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: _services_v_version_pain_points _services_v_version_pain_points_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._services_v_version_pain_points
    ADD CONSTRAINT _services_v_version_pain_points_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public._services_v(id) ON DELETE CASCADE;


--
-- Name: _services_v _services_v_version_seo_og_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._services_v
    ADD CONSTRAINT _services_v_version_seo_og_image_id_media_id_fk FOREIGN KEY (version_seo_og_image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: categories categories_seo_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_seo_image_id_media_id_fk FOREIGN KEY (seo_image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: header_navigation header_navigation_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.header_navigation
    ADD CONSTRAINT header_navigation_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public.header(id) ON DELETE CASCADE;


--
-- Name: leads leads_assigned_to_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT leads_assigned_to_id_users_id_fk FOREIGN KEY (assigned_to_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: leads leads_service_id_services_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT leads_service_id_services_id_fk FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE SET NULL;


--
-- Name: pages_blocks_contact_form pages_blocks_contact_form_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_contact_form
    ADD CONSTRAINT pages_blocks_contact_form_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public.pages(id) ON DELETE CASCADE;


--
-- Name: pages_blocks_content pages_blocks_content_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_content
    ADD CONSTRAINT pages_blocks_content_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public.pages(id) ON DELETE CASCADE;


--
-- Name: pages_blocks_cta_banner pages_blocks_cta_banner_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_cta_banner
    ADD CONSTRAINT pages_blocks_cta_banner_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public.pages(id) ON DELETE CASCADE;


--
-- Name: pages_blocks_hero pages_blocks_hero_hero_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_hero
    ADD CONSTRAINT pages_blocks_hero_hero_image_id_media_id_fk FOREIGN KEY (hero_image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: pages_blocks_hero pages_blocks_hero_hero_mobile_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_hero
    ADD CONSTRAINT pages_blocks_hero_hero_mobile_image_id_media_id_fk FOREIGN KEY (hero_mobile_image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: pages_blocks_hero_hero_title_lines pages_blocks_hero_hero_title_lines_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_hero_hero_title_lines
    ADD CONSTRAINT pages_blocks_hero_hero_title_lines_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public.pages_blocks_hero(id) ON DELETE CASCADE;


--
-- Name: pages_blocks_hero pages_blocks_hero_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_hero
    ADD CONSTRAINT pages_blocks_hero_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public.pages(id) ON DELETE CASCADE;


--
-- Name: pages_blocks_portfolio_grid_facts pages_blocks_portfolio_grid_facts_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_portfolio_grid_facts
    ADD CONSTRAINT pages_blocks_portfolio_grid_facts_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public.pages_blocks_portfolio_grid(id) ON DELETE CASCADE;


--
-- Name: pages_blocks_portfolio_grid pages_blocks_portfolio_grid_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_portfolio_grid
    ADD CONSTRAINT pages_blocks_portfolio_grid_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public.pages(id) ON DELETE CASCADE;


--
-- Name: pages_blocks_pricing_calculator pages_blocks_pricing_calculator_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_pricing_calculator
    ADD CONSTRAINT pages_blocks_pricing_calculator_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public.pages(id) ON DELETE CASCADE;


--
-- Name: pages_blocks_process_steps pages_blocks_process_steps_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_process_steps
    ADD CONSTRAINT pages_blocks_process_steps_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public.pages(id) ON DELETE CASCADE;


--
-- Name: pages_blocks_process_steps_steps pages_blocks_process_steps_steps_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_process_steps_steps
    ADD CONSTRAINT pages_blocks_process_steps_steps_image_id_media_id_fk FOREIGN KEY (image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: pages_blocks_process_steps_steps pages_blocks_process_steps_steps_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_process_steps_steps
    ADD CONSTRAINT pages_blocks_process_steps_steps_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public.pages_blocks_process_steps(id) ON DELETE CASCADE;


--
-- Name: pages_blocks_services_grid pages_blocks_services_grid_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_services_grid
    ADD CONSTRAINT pages_blocks_services_grid_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public.pages(id) ON DELETE CASCADE;


--
-- Name: pages_blocks_stats_items pages_blocks_stats_items_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_stats_items
    ADD CONSTRAINT pages_blocks_stats_items_image_id_media_id_fk FOREIGN KEY (image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: pages_blocks_stats_items pages_blocks_stats_items_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_stats_items
    ADD CONSTRAINT pages_blocks_stats_items_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public.pages_blocks_stats(id) ON DELETE CASCADE;


--
-- Name: pages_blocks_stats pages_blocks_stats_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_stats
    ADD CONSTRAINT pages_blocks_stats_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public.pages(id) ON DELETE CASCADE;


--
-- Name: pages_blocks_testimonials_items pages_blocks_testimonials_items_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_testimonials_items
    ADD CONSTRAINT pages_blocks_testimonials_items_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public.pages_blocks_testimonials(id) ON DELETE CASCADE;


--
-- Name: pages_blocks_testimonials pages_blocks_testimonials_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_blocks_testimonials
    ADD CONSTRAINT pages_blocks_testimonials_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public.pages(id) ON DELETE CASCADE;


--
-- Name: pages_rels pages_rels_parent_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_rels
    ADD CONSTRAINT pages_rels_parent_fk FOREIGN KEY (parent_id) REFERENCES public.pages(id) ON DELETE CASCADE;


--
-- Name: pages_rels pages_rels_projects_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages_rels
    ADD CONSTRAINT pages_rels_projects_fk FOREIGN KEY (projects_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: pages pages_seo_og_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_seo_og_image_id_media_id_fk FOREIGN KEY (seo_og_image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: payload_locked_documents_rels payload_locked_documents_rels_categories_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payload_locked_documents_rels
    ADD CONSTRAINT payload_locked_documents_rels_categories_fk FOREIGN KEY (categories_id) REFERENCES public.categories(id) ON DELETE CASCADE;


--
-- Name: payload_locked_documents_rels payload_locked_documents_rels_leads_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payload_locked_documents_rels
    ADD CONSTRAINT payload_locked_documents_rels_leads_fk FOREIGN KEY (leads_id) REFERENCES public.leads(id) ON DELETE CASCADE;


--
-- Name: payload_locked_documents_rels payload_locked_documents_rels_media_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payload_locked_documents_rels
    ADD CONSTRAINT payload_locked_documents_rels_media_fk FOREIGN KEY (media_id) REFERENCES public.media(id) ON DELETE CASCADE;


--
-- Name: payload_locked_documents_rels payload_locked_documents_rels_pages_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payload_locked_documents_rels
    ADD CONSTRAINT payload_locked_documents_rels_pages_fk FOREIGN KEY (pages_id) REFERENCES public.pages(id) ON DELETE CASCADE;


--
-- Name: payload_locked_documents_rels payload_locked_documents_rels_parent_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payload_locked_documents_rels
    ADD CONSTRAINT payload_locked_documents_rels_parent_fk FOREIGN KEY (parent_id) REFERENCES public.payload_locked_documents(id) ON DELETE CASCADE;


--
-- Name: payload_locked_documents_rels payload_locked_documents_rels_posts_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payload_locked_documents_rels
    ADD CONSTRAINT payload_locked_documents_rels_posts_fk FOREIGN KEY (posts_id) REFERENCES public.posts(id) ON DELETE CASCADE;


--
-- Name: payload_locked_documents_rels payload_locked_documents_rels_projects_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payload_locked_documents_rels
    ADD CONSTRAINT payload_locked_documents_rels_projects_fk FOREIGN KEY (projects_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: payload_locked_documents_rels payload_locked_documents_rels_services_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payload_locked_documents_rels
    ADD CONSTRAINT payload_locked_documents_rels_services_fk FOREIGN KEY (services_id) REFERENCES public.services(id) ON DELETE CASCADE;


--
-- Name: payload_locked_documents_rels payload_locked_documents_rels_subscriptions_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payload_locked_documents_rels
    ADD CONSTRAINT payload_locked_documents_rels_subscriptions_fk FOREIGN KEY (subscriptions_id) REFERENCES public.subscriptions(id) ON DELETE CASCADE;


--
-- Name: payload_locked_documents_rels payload_locked_documents_rels_users_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payload_locked_documents_rels
    ADD CONSTRAINT payload_locked_documents_rels_users_fk FOREIGN KEY (users_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: payload_preferences_rels payload_preferences_rels_parent_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payload_preferences_rels
    ADD CONSTRAINT payload_preferences_rels_parent_fk FOREIGN KEY (parent_id) REFERENCES public.payload_preferences(id) ON DELETE CASCADE;


--
-- Name: payload_preferences_rels payload_preferences_rels_users_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payload_preferences_rels
    ADD CONSTRAINT payload_preferences_rels_users_fk FOREIGN KEY (users_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: posts posts_author_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_author_id_users_id_fk FOREIGN KEY (author_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: posts posts_category_id_categories_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_category_id_categories_id_fk FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE SET NULL;


--
-- Name: posts posts_cover_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_cover_image_id_media_id_fk FOREIGN KEY (cover_image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: posts_rels posts_rels_categories_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts_rels
    ADD CONSTRAINT posts_rels_categories_fk FOREIGN KEY (categories_id) REFERENCES public.categories(id) ON DELETE CASCADE;


--
-- Name: posts_rels posts_rels_parent_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts_rels
    ADD CONSTRAINT posts_rels_parent_fk FOREIGN KEY (parent_id) REFERENCES public.posts(id) ON DELETE CASCADE;


--
-- Name: posts_rels posts_rels_posts_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts_rels
    ADD CONSTRAINT posts_rels_posts_fk FOREIGN KEY (posts_id) REFERENCES public.posts(id) ON DELETE CASCADE;


--
-- Name: posts posts_seo_og_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_seo_og_image_id_media_id_fk FOREIGN KEY (seo_og_image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: projects projects_cover_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_cover_image_id_media_id_fk FOREIGN KEY (cover_image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: projects_gallery projects_gallery_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects_gallery
    ADD CONSTRAINT projects_gallery_image_id_media_id_fk FOREIGN KEY (image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: projects_gallery projects_gallery_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects_gallery
    ADD CONSTRAINT projects_gallery_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: projects_rels projects_rels_categories_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects_rels
    ADD CONSTRAINT projects_rels_categories_fk FOREIGN KEY (categories_id) REFERENCES public.categories(id) ON DELETE CASCADE;


--
-- Name: projects_rels projects_rels_parent_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects_rels
    ADD CONSTRAINT projects_rels_parent_fk FOREIGN KEY (parent_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: projects projects_seo_og_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_seo_og_image_id_media_id_fk FOREIGN KEY (seo_og_image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: projects projects_testimonial_photo_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_testimonial_photo_id_media_id_fk FOREIGN KEY (testimonial_photo_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: services services_card_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_card_image_id_media_id_fk FOREIGN KEY (card_image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: services_deliverables services_deliverables_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services_deliverables
    ADD CONSTRAINT services_deliverables_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public.services(id) ON DELETE CASCADE;


--
-- Name: services_faqs services_faqs_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services_faqs
    ADD CONSTRAINT services_faqs_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public.services(id) ON DELETE CASCADE;


--
-- Name: services services_hero_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_hero_image_id_media_id_fk FOREIGN KEY (hero_image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: services_pain_points services_pain_points_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services_pain_points
    ADD CONSTRAINT services_pain_points_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public.services(id) ON DELETE CASCADE;


--
-- Name: services_rels services_rels_parent_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services_rels
    ADD CONSTRAINT services_rels_parent_fk FOREIGN KEY (parent_id) REFERENCES public.services(id) ON DELETE CASCADE;


--
-- Name: services_rels services_rels_projects_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services_rels
    ADD CONSTRAINT services_rels_projects_fk FOREIGN KEY (projects_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: services services_seo_og_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_seo_og_image_id_media_id_fk FOREIGN KEY (seo_og_image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: settings settings_brand_logo_dark_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_brand_logo_dark_id_media_id_fk FOREIGN KEY (brand_logo_dark_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: settings settings_brand_logo_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_brand_logo_id_media_id_fk FOREIGN KEY (brand_logo_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: settings settings_lead_magnet_guide_file_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_lead_magnet_guide_file_id_media_id_fk FOREIGN KEY (lead_magnet_guide_file_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: settings settings_lead_magnet_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_lead_magnet_image_id_media_id_fk FOREIGN KEY (lead_magnet_image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: settings settings_seo_defaults_default_og_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_seo_defaults_default_og_image_id_media_id_fk FOREIGN KEY (seo_defaults_default_og_image_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: settings_social_proof_press_logos settings_social_proof_press_logos_logo_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings_social_proof_press_logos
    ADD CONSTRAINT settings_social_proof_press_logos_logo_id_media_id_fk FOREIGN KEY (logo_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- Name: settings_social_proof_press_logos settings_social_proof_press_logos_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings_social_proof_press_logos
    ADD CONSTRAINT settings_social_proof_press_logos_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public.settings(id) ON DELETE CASCADE;


--
-- Name: settings_social_proof_stats settings_social_proof_stats_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings_social_proof_stats
    ADD CONSTRAINT settings_social_proof_stats_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public.settings(id) ON DELETE CASCADE;


--
-- Name: subscriptions_tags subscriptions_tags_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions_tags
    ADD CONSTRAINT subscriptions_tags_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public.subscriptions(id) ON DELETE CASCADE;


--
-- Name: users_sessions users_sessions_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_sessions
    ADD CONSTRAINT users_sessions_parent_id_fk FOREIGN KEY (_parent_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 4xYTmiAjuQJc7RGx9lAjxMzKcfqd0GPKoAckCXTpmbHRpXrD41ZlAhvSYosmX6R

--
-- PostgreSQL database dump
--

\restrict 7qBkUuiNz9w9ulwMOd4SrrfghhaN0p35olq4EEAR9J0WUTQricMnlmciilaT2MJ

-- Dumped from database version 16.14
-- Dumped by pg_dump version 16.14

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
-- Data for Name: payload_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.payload_migrations (id, name, batch, updated_at, created_at) VALUES (1, '20260922_101054_initial_schema', 1, '2026-10-16 19:08:31.353+00', '2026-10-16 19:08:31.351+00');
INSERT INTO public.payload_migrations (id, name, batch, updated_at, created_at) VALUES (2, '20260922_114129_add_header_global', 1, '2026-10-16 19:08:31.525+00', '2026-10-16 19:08:31.525+00');
INSERT INTO public.payload_migrations (id, name, batch, updated_at, created_at) VALUES (3, '20261012_105926_portfolio_grid__drop_showAllButton', 1, '2026-10-16 19:08:31.657+00', '2026-10-16 19:08:31.657+00');
INSERT INTO public.payload_migrations (id, name, batch, updated_at, created_at) VALUES (4, '20261012_105942_portfolio_grid__add_showFilters_and_facts_cards', 1, '2026-10-16 19:08:31.671+00', '2026-10-16 19:08:31.671+00');
INSERT INTO public.payload_migrations (id, name, batch, updated_at, created_at) VALUES (5, '20261012_121240_portfolio_block_manual_projects__categories_order', 1, '2026-10-16 19:08:31.849+00', '2026-10-16 19:08:31.849+00');
INSERT INTO public.payload_migrations (id, name, batch, updated_at, created_at) VALUES (6, '20261013_073214_drop_hero_appearance_group', 1, '2026-10-16 19:08:32.006+00', '2026-10-16 19:08:32.005+00');
INSERT INTO public.payload_migrations (id, name, batch, updated_at, created_at) VALUES (7, '20261013_084339_stats_cards__add_icon_description_image', 1, '2026-10-16 19:08:32.05+00', '2026-10-16 19:08:32.05+00');
INSERT INTO public.payload_migrations (id, name, batch, updated_at, created_at) VALUES (8, '20261013_102414_services__add_cardImage_and_tagline', 1, '2026-10-16 19:08:32.102+00', '2026-10-16 19:08:32.102+00');
INSERT INTO public.payload_migrations (id, name, batch, updated_at, created_at) VALUES (9, '20261013_102429_services__drop_icon__replaced_by_cardImage_', 1, '2026-10-16 19:08:32.123+00', '2026-10-16 19:08:32.123+00');
INSERT INTO public.payload_migrations (id, name, batch, updated_at, created_at) VALUES (10, '20261013_124029_process_steps__add_description_and_sketch_fields', 1, '2026-10-16 19:08:32.154+00', '2026-10-16 19:08:32.154+00');
INSERT INTO public.payload_migrations (id, name, batch, updated_at, created_at) VALUES (11, '20261014_162547', 1, '2026-10-16 19:08:32.191+00', '2026-10-16 19:08:32.191+00');


--
-- Name: payload_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payload_migrations_id_seq', 11, true);


--
-- PostgreSQL database dump complete
--

\unrestrict 7qBkUuiNz9w9ulwMOd4SrrfghhaN0p35olq4EEAR9J0WUTQricMnlmciilaT2MJ

