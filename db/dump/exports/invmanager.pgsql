--
-- PostgreSQL database dump
--

-- Dumped from database version 11.7
-- Dumped by pg_dump version 11.7

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
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: create_order(character varying, character varying, character varying, uuid, integer, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_order(title character varying, first_name character varying, last_name character varying, product_id uuid, number_shipped integer, order_date date) RETURNS uuid
    LANGUAGE plpgsql
    AS $_$DECLARE
	_ouid uuid := null;
	i_count integer := 0;
BEGIN
	_ouid := uuid_generate_v4();
	
	RAISE NOTICE '_puid: %', _ouid;
		
	EXECUTE format('INSERT INTO orders (
						 id, 
						 title, 
						 first, 
						 last, 
						 product_id, 
						 number_shipped, 
						 order_date,
				  		 created)
						 VALUES($1, $2, $3, $4, $5, $6, $7, $8)') 
						 USING 
						 _ouid,
						 title,
						 first_name,
						 last_name,
						 product_id,
						 number_shipped,
						 order_date,
						 NOW();
	GET DIAGNOSTICS i_count = ROW_COUNT;
	
	IF i_count = 1 THEN
		return _ouid;
	ELSE
		RAISE 'Ambigious [%] rows inserted', i_count;
	END IF;
END;
$_$;


ALTER FUNCTION public.create_order(title character varying, first_name character varying, last_name character varying, product_id uuid, number_shipped integer, order_date date) OWNER TO postgres;

--
-- Name: create_product(character varying, character varying, character varying, integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_product(product_name character varying, part_number character varying, product_label character varying, starting_inventory integer, inventory_received integer, inventory_shipped integer, minimum_required integer DEFAULT 10) RETURNS uuid
    LANGUAGE plpgsql
    AS $_$DECLARE
	_inventory_on_hand integer := 0;
	_puid uuid := null;
	i_count integer := 0;
BEGIN
	_puid := uuid_generate_v4();
	
	RAISE NOTICE '_puid: %', _puid;
	
	_inventory_on_hand := starting_inventory + inventory_received - inventory_shipped;
	
	RAISE NOTICE '_inventory_on_hand: %', _inventory_on_hand;
	
	EXECUTE format('INSERT INTO products (
						 id, 
						 product_name, 
						 part_number, 
						 product_label, 
						 starting_inventory, 
						 inventory_received, 
						 inventory_shipped, 
						 inventory_on_hand, 
						 minimum_required,
				  		 created)
						 VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)') 
						 USING 
						 _puid,
						 product_name,
						 part_number,
						 product_label,
						 starting_inventory,
						 inventory_received,
						 inventory_shipped,
						 _inventory_on_hand,
						 minimum_required,
						 NOW();
	GET DIAGNOSTICS i_count = ROW_COUNT;
	
	IF i_count = 1 THEN
		return _puid;
	ELSE
		RAISE 'Ambigious [%] rows inserted', i_count;
	END IF;
END;
$_$;


ALTER FUNCTION public.create_product(product_name character varying, part_number character varying, product_label character varying, starting_inventory integer, inventory_received integer, inventory_shipped integer, minimum_required integer) OWNER TO postgres;

--
-- Name: create_purchase(uuid, uuid, integer, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_purchase(supplier_id uuid, product_id uuid, number_received integer, purchase_date date) RETURNS uuid
    LANGUAGE plpgsql
    AS $_$DECLARE
	_puid uuid := null;
	i_count integer := 0;
BEGIN
	_puid := uuid_generate_v4();
	
	RAISE NOTICE '_puid: %', _puid;
	
	EXECUTE format('INSERT INTO purchases (
						 id, 
						 supplier_id, 
						 product_id, 
						 number_received, 
						 purchase_date,
				  		 created)
						 VALUES($1, $2, $3, $4, $5, $6)') 
						 USING 
						 _puid,
						 supplier_id,
						 product_id,
						 number_received,
						 purchase_date,
						 NOW();
	GET DIAGNOSTICS i_count = ROW_COUNT;
	
	IF i_count = 1 THEN
		return _puid;
	ELSE
		RAISE 'Ambigious [%] rows inserted', i_count;
	END IF;
END;
$_$;


ALTER FUNCTION public.create_purchase(supplier_id uuid, product_id uuid, number_received integer, purchase_date date) OWNER TO postgres;

--
-- Name: create_supplier(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_supplier(supplier character varying) RETURNS uuid
    LANGUAGE plpgsql
    AS $_$DECLARE
	_suid uuid := null;
	i_count integer := 0;
BEGIN
	_suid := uuid_generate_v4();
	
	RAISE NOTICE '_suid: %', _suid;
	
	EXECUTE format('INSERT INTO suppliers (
						 id, 
						 supplier,
				  		 created)
						 VALUES($1, $2, $3)') 
						 USING 
						 _suid,
						 supplier,
						 NOW();
	GET DIAGNOSTICS i_count = ROW_COUNT;
	
	IF i_count = 1 THEN
		return _suid;
	ELSE
		RAISE 'Ambigious [%] rows inserted', i_count;
	END IF;
END;
$_$;


ALTER FUNCTION public.create_supplier(supplier character varying) OWNER TO postgres;

--
-- Name: create_user(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_user(user_name character varying, email character varying, first_name character varying, last_name character varying, hash character varying, salt character varying, user_type character varying, address character varying, phone character varying) RETURNS uuid
    LANGUAGE plpgsql
    AS $_$DECLARE
	_uuid uuid := null;
	i_count integer := 0;
	_user_type varchar := 'guest';
	_user_name varchar := '';
	_user_email varchar := '';
BEGIN
	IF ( user_name IS DISTINCT FROM null OR email IS DISTINCT FROM null)
	AND first_name IS DISTINCT FROM null
	AND hash IS DISTINCT FROM null
	AND salt IS DISTINCT FROM null THEN
		IF user_name IS DISTINCT FROM null THEN
			_user_name := user_name;
		END IF;
		
		IF email IS DISTINCT FROM null THEN
			_user_email := email;
		END IF;
		
		IF user_type IS DISTINCT FROM null THEN
			_user_type := user_type;
		END IF;
		
		_uuid := uuid_generate_v4();

		RAISE NOTICE '_suid: %', _uuid;

		EXECUTE format('INSERT INTO users (
							 	id, 
							 	first_name,
							 	last_name,
								user_name,
								email,
								type,
								created,
								updated,
								address,
								phone,
								hash,
								salt)
							 VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)') 
							 USING 
							 _uuid, first_name, last_name,
							 _user_name, _user_email, _user_type,
							 NOW(), cast(null AS timestamptz), address,
							 phone, hash, salt;
		GET DIAGNOSTICS i_count = ROW_COUNT;

		IF i_count = 1 THEN
			return _uuid;
		ELSE
			RAISE 'Ambigious [%] rows inserted', i_count;
		END IF;
	ELSE
		RAISE 'Invalid username / email';
	END IF;
END;
$_$;


ALTER FUNCTION public.create_user(user_name character varying, email character varying, first_name character varying, last_name character varying, hash character varying, salt character varying, user_type character varying, address character varying, phone character varying) OWNER TO postgres;

--
-- Name: get_count(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_count(table_name character varying) RETURNS TABLE(count bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY EXECUTE format('SELECT COUNT(*) AS COUNT FROM %s', table_name);
END;$$;


ALTER FUNCTION public.get_count(table_name character varying) OWNER TO postgres;

--
-- Name: get_order(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_order(oid uuid) RETURNS TABLE(id uuid, title character varying, first character varying, last character varying, product_id uuid, number_shipped integer, order_date date, created timestamp with time zone, updated timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$BEGIN
	RETURN QUERY 
	EXECUTE format('SELECT * FROM orders WHERE id = $1') USING oid;
END;
$_$;


ALTER FUNCTION public.get_order(oid uuid) OWNER TO postgres;

--
-- Name: get_orders(integer, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_orders(query_limit integer DEFAULT 10, page integer DEFAULT 1, col_name character varying DEFAULT NULL::character varying, col_dir character varying DEFAULT 'DESC'::character varying) RETURNS TABLE(id uuid, title character varying, first character varying, last character varying, product_id uuid, number_shipped integer, order_date date, created timestamp with time zone, updated timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$DECLARE
	query_offset integer := 0;
	_col_name varchar := 'order_date';
	_col_dir varchar := 'DESC';
BEGIN
	query_offset := (page - 1) * query_limit;
	
	IF col_name IS DISTINCT FROM NULL THEN
		_col_name := col_name;	
	END IF;
	
	IF col_dir IS DISTINCT FROM NULL THEN
		_col_dir := col_dir;
	END IF;
	
	-- use quote_ident(sort_by)
	IF upper(_col_dir) IN ('ASC', 'DESC') THEN
		RETURN QUERY EXECUTE format('SELECT * FROM orders  
				ORDER BY %s %s LIMIT $1
				OFFSET $2', _col_name, _col_dir) USING query_limit, query_offset;	
	ELSE
		RAISE 'ambigious order by direction';
	END IF;
	
END;$_$;


ALTER FUNCTION public.get_orders(query_limit integer, page integer, col_name character varying, col_dir character varying) OWNER TO postgres;

--
-- Name: get_product(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_product(pid uuid) RETURNS TABLE(id uuid, product_name character varying, part_number character varying, product_label character varying, starting_inventory integer, inventory_received integer, inventory_shipped integer, inventory_on_hand integer, minimum_required integer, created timestamp with time zone, updated timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$BEGIN
	RETURN QUERY 
	EXECUTE format('SELECT * FROM products WHERE id = $1') USING pid;
END;
$_$;


ALTER FUNCTION public.get_product(pid uuid) OWNER TO postgres;

--
-- Name: get_products(integer, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_products(query_limit integer DEFAULT 10, page integer DEFAULT 1, col_name character varying DEFAULT NULL::character varying, col_dir character varying DEFAULT 'DESC'::character varying) RETURNS TABLE(id uuid, product_name character varying, part_number character varying, product_label character varying, starting_inventory integer, inventory_received integer, inventory_shipped integer, inventory_on_hand integer, minimum_required integer, created timestamp with time zone, updated timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$DECLARE
	query_offset integer := 0;
	_col_name varchar := 'product_label';
	_col_dir varchar := 'DESC';
BEGIN
	query_offset := (page - 1) * query_limit;
	
	IF col_name IS DISTINCT FROM NULL THEN
		_col_name := col_name;	
	END IF;
	
	IF col_dir IS DISTINCT FROM NULL THEN
		_col_dir := col_dir;
	END IF;
	
	-- use quote_ident(sort_by)
	IF upper(_col_dir) IN ('ASC', 'DESC') THEN
		RETURN QUERY EXECUTE format('SELECT * FROM products  
				ORDER BY %s %s LIMIT $1
				OFFSET $2', _col_name, _col_dir) USING query_limit, query_offset;	
	ELSE
		RAISE 'ambigious order by direction';
	END IF;
	
END;$_$;


ALTER FUNCTION public.get_products(query_limit integer, page integer, col_name character varying, col_dir character varying) OWNER TO postgres;

--
-- Name: get_purchase(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_purchase(pid uuid) RETURNS TABLE(id uuid, supplier_id uuid, product_id uuid, number_received integer, purchase_date date, created timestamp with time zone, updated timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$BEGIN
	RETURN QUERY 
	EXECUTE format('SELECT * FROM purchases WHERE id = $1') USING pid;
END;
$_$;


ALTER FUNCTION public.get_purchase(pid uuid) OWNER TO postgres;

--
-- Name: get_purchases(integer, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_purchases(query_limit integer DEFAULT 10, page integer DEFAULT 1, col_name character varying DEFAULT NULL::character varying, col_dir character varying DEFAULT 'DESC'::character varying) RETURNS TABLE(id uuid, supplier_id uuid, product_id uuid, number_received integer, purchase_date date, created timestamp with time zone, updated timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$DECLARE
	query_offset integer := 0;
	_col_name varchar := 'purchase_date';
	_col_dir varchar := 'DESC';
BEGIN
	query_offset := (page - 1) * query_limit;
	
	IF col_name IS DISTINCT FROM NULL THEN
		_col_name := col_name;	
	END IF;
	
	IF col_dir IS DISTINCT FROM NULL THEN
		_col_dir := col_dir;
	END IF;
		
	IF upper(_col_dir) IN ('ASC', 'DESC') THEN
		RETURN QUERY EXECUTE format('SELECT * FROM purchases  
				ORDER BY %s %s LIMIT $1
				OFFSET $2', _col_name, _col_dir) USING query_limit, query_offset;	
	ELSE
		RAISE 'ambigious order by direction';
	END IF;
	
END;$_$;


ALTER FUNCTION public.get_purchases(query_limit integer, page integer, col_name character varying, col_dir character varying) OWNER TO postgres;

--
-- Name: get_supplier(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_supplier(sid uuid) RETURNS TABLE(id uuid, supplier character varying, created timestamp with time zone, updated timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$BEGIN
	RETURN QUERY 
	EXECUTE format('SELECT * FROM suppliers WHERE id = $1') USING sid;
END;
$_$;


ALTER FUNCTION public.get_supplier(sid uuid) OWNER TO postgres;

--
-- Name: get_suppliers(integer, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_suppliers(query_limit integer DEFAULT 10, page integer DEFAULT 1, col_name character varying DEFAULT NULL::character varying, col_dir character varying DEFAULT 'ASC'::character varying) RETURNS TABLE(id uuid, supplier character varying, created timestamp with time zone, updated timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$DECLARE
	query_offset integer := 0;
	_col_name varchar := 'supplier';
	_col_dir varchar := 'ASC';
BEGIN
	query_offset := (page - 1) * query_limit;
	
	IF col_name IS DISTINCT FROM NULL THEN
		_col_name := col_name;	
	END IF;
	
	IF col_dir IS DISTINCT FROM NULL THEN
		_col_dir := col_dir;
	END IF;
	
	-- use quote_ident(sort_by)
	IF upper(_col_dir) IN ('ASC', 'DESC') THEN
		RETURN QUERY EXECUTE format('SELECT * FROM suppliers  
				ORDER BY %s %s LIMIT $1
				OFFSET $2', _col_name, _col_dir) USING query_limit, query_offset;	
	ELSE
		RAISE 'ambigious order by direction';
	END IF;
	
END;$_$;


ALTER FUNCTION public.get_suppliers(query_limit integer, page integer, col_name character varying, col_dir character varying) OWNER TO postgres;

--
-- Name: get_user(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_user(username character varying DEFAULT ''::character varying, useremail character varying DEFAULT ''::character varying) RETURNS TABLE(id uuid, first_name character varying, last_name character varying, user_name character varying, email character varying, type character varying, created timestamp with time zone, updated timestamp with time zone, address character varying, phone character varying, hash character varying, salt character varying)
    LANGUAGE plpgsql
    AS $_$
BEGIN
	IF username IS DISTINCT FROM '' THEN
		RETURN QUERY EXECUTE format('SELECT * FROM users WHERE user_name = $1') USING username;
	ELSIF useremail IS DISTINCT FROM '' THEN
		RETURN QUERY EXECUTE format('SELECT * FROM users WHERE email = $1') USING useremail;
	ELSE
		RAISE 'Invalid argument list. Enter a username / email.';
	END IF;
END;
$_$;


ALTER FUNCTION public.get_user(username character varying, useremail character varying) OWNER TO postgres;

--
-- Name: remove_order(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.remove_order(oid uuid) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
	u_count integer := 0;
BEGIN 
	EXECUTE format('DELETE FROM orders WHERE id = $1') USING oid;
	GET DIAGNOSTICS u_count = ROW_COUNT;
	return u_count;
END;
$_$;


ALTER FUNCTION public.remove_order(oid uuid) OWNER TO postgres;

--
-- Name: remove_product(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.remove_product(pid uuid) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
	u_count integer := 0;
BEGIN 
	EXECUTE format('DELETE FROM products WHERE id = $1') USING pid;
	GET DIAGNOSTICS u_count = ROW_COUNT;
	return u_count;
END;
$_$;


ALTER FUNCTION public.remove_product(pid uuid) OWNER TO postgres;

--
-- Name: remove_purchase(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.remove_purchase(pid uuid) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
	u_count integer := 0;
BEGIN 
	EXECUTE format('DELETE FROM purchases WHERE id = $1') USING pid;
	GET DIAGNOSTICS u_count = ROW_COUNT;
	return u_count;
END;
$_$;


ALTER FUNCTION public.remove_purchase(pid uuid) OWNER TO postgres;

--
-- Name: remove_supplier(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.remove_supplier(sid uuid) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
	u_count integer := 0;
BEGIN 
	EXECUTE format('DELETE FROM suppliers WHERE id = $1') USING sid;
	GET DIAGNOSTICS u_count = ROW_COUNT;
	return u_count;
END;
$_$;


ALTER FUNCTION public.remove_supplier(sid uuid) OWNER TO postgres;

--
-- Name: table_query_operation(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.table_query_operation() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$DECLARE
	user_name varchar := 'anonymous';
	_target_id uuid := null;
BEGIN
	IF NEW.id IS DISTINCT FROM null THEN
		_target_id := NEW.id;
	ELSIF OLD.id IS DISTINCT FROM null THEN
		_target_id := OLD.id;
	ELSE
		_target_id := '00000000-0000-0000-0000-000000000000';
	END IF;

	EXECUTE format('INSERT INTO audit_logs 
				  (target_id, table_name, query_type, user_name, time) 
				  VALUES($1, $2, $3, $4, $5)') 
				  USING _target_id, TG_table_name, TG_op, user_name, NOW();
	RETURN NEW;
END;
$_$;


ALTER FUNCTION public.table_query_operation() OWNER TO postgres;

--
-- Name: update_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_column() RETURNS bigint
    LANGUAGE plpgsql
    AS $$DECLARE
	rec RECORD;
	inv_rec integer := null;
BEGIN
	FOR rec in SELECT
					product_label, 
					starting_inventory, 
					inventory_received, 
					inventory_shipped, 
					inventory_on_hand, 
					minimum_required FROM products LIMIT 10
	LOOP
		IF rec.inventory_received IS NULL THEN
			inv_rec := ROUND(RANDOM() * rec.starting_inventory);
			RAISE NOTICE 'product_label inv_received % %', product_label, inv_rec;
		END IF;
	END LOOP;
END;
$$;


ALTER FUNCTION public.update_column() OWNER TO postgres;

--
-- Name: update_order(uuid, character varying, character varying, character varying, uuid, integer, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_order(id uuid, title character varying, first_name character varying, last_name character varying, product_id uuid, number_shipped integer, order_date date) RETURNS integer
    LANGUAGE plpgsql
    AS $_$DECLARE
	u_count integer := 0;
BEGIN
	EXECUTE format('UPDATE orders 
						 SET title = $2, 
						 first = $3, 
						 last = $4, 
						 product_id = $5, 
						 number_shipped = $6, 
						 order_date = $7,
				   		 updated = $8 WHERE id = $1') 
						 USING
						 id,
						 title,
						 first_name,
						 last_name,
						 product_id,
						 number_shipped,
						 order_date,
						 NOW();
	GET DIAGNOSTICS u_count = ROW_COUNT;
	return u_count;
END;
$_$;


ALTER FUNCTION public.update_order(id uuid, title character varying, first_name character varying, last_name character varying, product_id uuid, number_shipped integer, order_date date) OWNER TO postgres;

--
-- Name: update_orders_column(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.update_orders_column()
    LANGUAGE plpgsql
    AS $$DECLARE
	product_count INTEGER := 0;
	product_uid UUID := null;
	rec RECORD;
BEGIN
	SELECT into product_count COUNT(*) FROM products;
	 
	FOR rec in SELECT 
				product_id,
				id
				FROM orders
	LOOP
		SELECT into product_uid id FROM products 
		OFFSET (FLOOR(RANDOM() * product_count)) LIMIT 1;		
			
		UPDATE orders 
		SET product_id = product_uid
		WHERE id = rec.id;
	END LOOP;
	
	COMMIT;
END;$$;


ALTER PROCEDURE public.update_orders_column() OWNER TO postgres;

--
-- Name: update_product(uuid, character varying, character varying, character varying, integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_product(id uuid, product_name character varying, part_number character varying, product_label character varying, starting_inventory integer, inventory_received integer, inventory_shipped integer, minimum_required integer DEFAULT 10) RETURNS integer
    LANGUAGE plpgsql
    AS $_$DECLARE
	u_count integer := 0;
	_inventory_on_hand integer := 0;
BEGIN		
	_inventory_on_hand := starting_inventory + inventory_received - inventory_shipped;
	
	RAISE NOTICE '_inventory_on_hand: %', _inventory_on_hand;
	
	EXECUTE format('UPDATE products 
						 SET product_name = $2, 
						 part_number = $3, 
						 product_label = $4, 
						 starting_inventory = $5, 
						 inventory_received = $6, 
						 inventory_shipped = $7, 
						 inventory_on_hand = $8, 
						 minimum_required = $9, updated = $10 WHERE id = $1') 
						 USING
						 id,
						 product_name,
						 part_number,
						 product_label,
						 starting_inventory,
						 inventory_received,
						 inventory_shipped,
						 _inventory_on_hand,
						 minimum_required,
						 NOW();
	GET DIAGNOSTICS u_count = ROW_COUNT;
	return u_count;
END;
$_$;


ALTER FUNCTION public.update_product(id uuid, product_name character varying, part_number character varying, product_label character varying, starting_inventory integer, inventory_received integer, inventory_shipped integer, minimum_required integer) OWNER TO postgres;

--
-- Name: update_product_columns(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.update_product_columns()
    LANGUAGE plpgsql
    AS $$DECLARE
	rec RECORD;
	inv_rec INTEGER := 0;
	inv_shipped INTEGER := 0;
	inv_on_hand INTEGER := 0;
BEGIN
	FOR rec in SELECT
				id,
				product_label,
				starting_inventory,
				inventory_received,
				inventory_shipped,
				inventory_on_hand,
				minimum_required
				 FROM products
	LOOP
		inv_rec := 0;
		inv_shipped := 0;
		inv_on_hand := 0;
		IF rec.inventory_received IS NULL THEN
			inv_rec := ROUND(0.1 * rec.starting_inventory);
			RAISE DEBUG 'product_label inv_received % %', rec.product_label, inv_rec;
			UPDATE products SET inventory_received = inv_rec WHERE id = rec.id;
			RAISE NOTICE 'inventory received for label: % updated', rec.product_label; 
		END IF;
		
		IF rec.inventory_shipped = 0 THEN
			inv_shipped := ROUND(0.2 * rec.starting_inventory);
			RAISE DEBUG 'product label %: inv_shipped: %', rec.product_label, inv_shipped;
			UPDATE products SET inventory_shipped = inv_shipped WHERE id = rec.id;
			RAISE NOTICE 'inventory shipped for label: % updated', rec.product_label;
		END IF;
		
		IF rec.inventory_on_hand = 0 AND inv_shipped IS DISTINCT FROM 0 THEN
			RAISE DEBUG 'inventory_on_hand is zero for %', rec.product_label;
			IF rec.inventory_received <> 0 THEN
				inv_on_hand := (rec.starting_inventory + rec.inventory_received) - inv_shipped;
				RAISE DEBUG 'rec.inventory_received: % inv_on_hand: %', rec.inventory_received, inv_on_hand;	
			ELSIF inv_rec <> 0 THEN
				inv_on_hand := (rec.starting_inventory + inv_rec) - inv_shipped;
				RAISE DEBUG 'inv_rec: % inv_on_hand: %', inv_rec, inv_on_hand;
			END IF;
			
			IF inv_on_hand <> 0 THEN
				UPDATE products SET inventory_on_hand = inv_on_hand WHERE id = rec.id;
				RAISE NOTICE 'inventory on hand for label: % updated', rec.product_label;
			END IF;
		END IF;
		
	END LOOP;		
END;
$$;


ALTER PROCEDURE public.update_product_columns() OWNER TO postgres;

--
-- Name: update_purchase(uuid, uuid, uuid, integer, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_purchase(id uuid, supplier_id uuid, product_id uuid, number_received integer, purchase_date date) RETURNS integer
    LANGUAGE plpgsql
    AS $_$DECLARE
	u_count integer := 0;
BEGIN		
	EXECUTE format('UPDATE purchases 
						 SET supplier_id = $2, 
						 product_id = $3, 
						 number_received = $4, 
						 purchase_date = $5,
				   		 updated = $6 WHERE id = $1') 
						 USING
						 id,
						 supplier_id,
						 product_id,
						 number_received,
						 purchase_date,
						 NOW();
	GET DIAGNOSTICS u_count = ROW_COUNT;
	return u_count;
END;
$_$;


ALTER FUNCTION public.update_purchase(id uuid, supplier_id uuid, product_id uuid, number_received integer, purchase_date date) OWNER TO postgres;

--
-- Name: update_purchases_column(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.update_purchases_column()
    LANGUAGE plpgsql
    AS $$DECLARE
	supplier_count INTEGER := 0;
	product_count INTEGER := 0;
	product_uid UUID := null;
	supplier_uid UUID := null;
	rec RECORD;
BEGIN
	SELECT into supplier_count COUNT(*) FROM suppliers;	
	SELECT into product_count COUNT(*) FROM products;
	 
	FOR rec in SELECT 
				supplier_id,
				product_id,
				id
				FROM purchases
	LOOP
		SELECT into product_uid id FROM products 
		OFFSET (FLOOR(RANDOM() * product_count)) LIMIT 1;		
		
		SELECT into supplier_uid id FROM suppliers 
		OFFSET (FLOOR(RANDOM() * supplier_count)) LIMIT 1;
	
		UPDATE purchases 
		SET supplier_id = supplier_uid, product_id = product_uid
		WHERE id = rec.id;
	END LOOP;
	
	COMMIT;
END;$$;


ALTER PROCEDURE public.update_purchases_column() OWNER TO postgres;

--
-- Name: update_supplier(uuid, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_supplier(id uuid, supplier character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$DECLARE
	u_count integer := 0;
BEGIN		
	EXECUTE format('UPDATE suppliers 
						 SET supplier = $2,
				   		 updated = $3 WHERE id = $1') 
						 USING
						 id,
						 supplier,
						 NOW();
	GET DIAGNOSTICS u_count = ROW_COUNT;
	return u_count;
END;
$_$;


ALTER FUNCTION public.update_supplier(id uuid, supplier character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_logs (
    id bigint NOT NULL,
    target_id uuid NOT NULL,
    table_name character varying(80) NOT NULL,
    query_type character varying(20) NOT NULL,
    user_name character varying NOT NULL,
    "time" timestamp(6) with time zone NOT NULL
);


ALTER TABLE public.audit_logs OWNER TO postgres;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.audit_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.audit_logs_id_seq OWNER TO postgres;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.audit_logs_id_seq OWNED BY public.audit_logs.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id uuid NOT NULL,
    title character varying(50),
    first character varying(50) NOT NULL,
    last character varying(50) NOT NULL,
    product_id uuid,
    number_shipped integer NOT NULL,
    order_date date NOT NULL,
    created timestamp(6) with time zone,
    updated timestamp(6) with time zone
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id uuid NOT NULL,
    product_name character varying NOT NULL,
    part_number character varying(50) NOT NULL,
    product_label character varying(300) NOT NULL,
    starting_inventory integer,
    inventory_received integer,
    inventory_shipped integer,
    inventory_on_hand integer,
    minimum_required integer,
    created timestamp(6) with time zone,
    updated timestamp(6) with time zone
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: purchases; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchases (
    id uuid NOT NULL,
    supplier_id uuid,
    product_id uuid,
    number_received integer NOT NULL,
    purchase_date date NOT NULL,
    updated timestamp(6) with time zone,
    created timestamp(6) with time zone
);


ALTER TABLE public.purchases OWNER TO postgres;

--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suppliers (
    id uuid NOT NULL,
    supplier character varying(50),
    created timestamp(6) with time zone,
    updated timestamp(6) with time zone
);


ALTER TABLE public.suppliers OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying,
    user_name character varying NOT NULL,
    email character varying(100) NOT NULL,
    type character varying(20) NOT NULL,
    created timestamp(0) with time zone NOT NULL,
    updated timestamp(0) with time zone,
    address character varying,
    phone character varying(20),
    hash character varying NOT NULL,
    salt character varying NOT NULL,
    CONSTRAINT users_type_check CHECK ((((type)::text = 'admin'::text) OR ((type)::text = 'guest'::text) OR ((type)::text = 'entry'::text) OR ((type)::text = 'audit'::text)))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN id SET DEFAULT nextval('public.audit_logs_id_seq'::regclass);


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_logs (id, target_id, table_name, query_type, user_name, "time") FROM stdin;
2	a3d9d4bc-244c-45b4-b637-12e8a87b95de	suppliers	UPDATE		2020-04-28 13:17:05.639103+05:30
3	a3d9d4bc-244c-45b4-b637-12e8a87b95de	suppliers	UPDATE	anonymous	2020-04-28 13:23:08.310882+05:30
5	00000000-0000-0000-0000-000000000000	suppliers	DELETE	anonymous	2020-04-28 13:28:12.923106+05:30
6	a3d9d4bc-244c-45b4-b637-12e8a87b95df	suppliers	DELETE	anonymous	2020-04-28 13:30:33.357823+05:30
7	411e9461-57b3-4980-9795-36ec6aebaa1c	suppliers	INSERT	anonymous	2020-04-28 13:31:36.924317+05:30
8	820915f7-88d4-4dd5-88c9-6b80f2980efb	products	DELETE	anonymous	2020-04-28 13:36:22.865768+05:30
9	c9b21e32-9548-497c-9ed7-0011a4f3ec92	products	UPDATE	anonymous	2020-04-28 13:39:54.460407+05:30
10	54f0e223-b857-484d-a6d0-712e77c0c129	products	INSERT	anonymous	2020-04-28 13:42:03.235464+05:30
11	17868893-ac73-424c-8f31-39325192f052	products	INSERT	anonymous	2020-04-28 13:47:09.302794+05:30
12	4ad15174-f20b-441d-9e83-e54b497e7433	purchases	UPDATE	anonymous	2020-04-28 13:53:04.481428+05:30
13	6f95268b-a8c9-4129-a9ed-d142d05dc2ab	suppliers	INSERT	anonymous	2020-04-28 14:04:37.551678+05:30
14	6f95268b-a8c9-4129-a9ed-d142d05dc2ab	suppliers	UPDATE	anonymous	2020-04-28 14:05:32.977536+05:30
15	411e9461-57b3-4980-9795-36ec6aebaa1c	suppliers	UPDATE	anonymous	2020-04-30 13:14:13.366207+05:30
17	52901450-ee60-494e-8c81-2461623f2607	users	INSERT	anonymous	2020-05-02 14:22:04.665574+05:30
18	9b586758-f3c5-4afb-84ad-d9158dc70e4a	users	INSERT	anonymous	2020-05-02 16:47:46.285105+05:30
19	8765fbea-213e-43e3-a7de-16a4a5ee8d27	users	INSERT	anonymous	2020-05-03 16:46:09.739688+05:30
20	cc9204c2-f839-47d1-8771-0c0eb0ed2f4e	users	INSERT	anonymous	2020-05-03 16:47:59.949953+05:30
21	fbdccb0f-535a-4c32-973f-de4f0897fe83	users	INSERT	anonymous	2020-05-03 16:58:00.839999+05:30
22	7fde3e51-d118-4f4e-bb42-220ea5e7302b	users	INSERT	anonymous	2020-05-03 16:59:13.112278+05:30
23	73522759-0a85-4694-8ec8-37f94c981aba	users	INSERT	anonymous	2020-05-03 17:04:11.5467+05:30
24	48d4a60e-215f-4dfb-807a-eac0a7764417	users	INSERT	anonymous	2020-05-03 17:08:58.294452+05:30
25	bea946ee-4d1b-4c9b-b1d4-711fc49095e0	users	INSERT	anonymous	2020-05-03 17:09:57.770023+05:30
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, title, first, last, product_id, number_shipped, order_date, created, updated) FROM stdin;
c4b8f609-32a1-4402-9859-06ac91887be8	Mrs	Delinda	Kemmer	f6868042-723d-4ef9-9b0e-bbe906bedb3d	104	2020-12-01	\N	\N
49582edc-baeb-4bf7-95af-ef347524995a	Dr	Oralee	Peat	18364687-7b65-4859-946a-d2ce1e158445	123	2020-06-01	\N	\N
7934784b-a611-480a-a716-72d5232661d6	Honorable	Kelci	Treadger	bf372f8c-0ca2-4dc0-83f3-40062af7a071	247	2020-09-04	\N	\N
d191d3ad-50b3-4fc6-9b35-a7ed3941334a	Dr	Kile	Dougher	d0291dc8-c365-4da7-8cc0-28cf8b73aec8	376	2021-03-15	\N	\N
3af9cfde-76e4-40e9-8551-8947ac9f591a	Mrs	Druci	Brothwood	2aa5d338-248c-4b8b-a7b9-52af04e4012f	385	2021-02-19	\N	\N
90b92308-6c26-476e-8d53-8a16d0dade19	Rev	Rouvin	Vardey	4bbe57fe-2346-4849-825a-4faf89e9f404	443	2020-11-06	\N	\N
eeccb55e-29d6-4b91-9b56-68393d85e26a	Ms	Celinka	Clarey	5a58e622-1c05-4cff-92b8-3d8771b364c4	392	2020-05-28	\N	\N
c865f73d-07ad-41fa-8087-cb7104ae5bbf	Ms	Rriocard	Almack	937dc15c-0168-4e04-91d2-7db5a423f53b	161	2021-02-05	\N	\N
9f197731-d50d-46fb-b43e-9ebb3f8010a6	Honorable	Sabina	Laminman	21921698-e2a4-40eb-9cf2-51725228ab2e	291	2020-05-09	\N	\N
bc29eccd-69a2-4563-8e43-2b3fc31dbc3a	Mrs	Anna-maria	Tuckey	3caef524-81aa-4879-940a-4b3621434d03	107	2020-09-10	\N	\N
c263d681-6db9-4c99-af89-e8e4588158d0	Ms	Tiffie	Girault	80162355-6830-4b9d-8812-25b2a0108cab	216	2020-12-16	\N	\N
cadc6baa-2de9-4382-bbfb-bc9bf79df23e	Ms	Barnett	Manilow	69d16bf4-afe9-410d-9afe-ec85a2ebea3b	34	2020-09-01	\N	\N
ea4bb7bb-9b99-4690-a230-210edc98d358	Mrs	Bald	Dunguy	f7b2ca87-c9a3-443f-b88a-073cef46fd41	67	2021-04-02	\N	\N
e357bb9e-9da4-4be9-bd67-75075e5345f7	Ms	Kirby	Charrington	69d16bf4-afe9-410d-9afe-ec85a2ebea3b	236	2020-11-27	\N	\N
f80897e6-ca24-4f7c-9d72-bc09ed3e9e50	Mrs	Max	Barraclough	b2a0f19d-4bef-49ab-b296-4bda23ecdba7	435	2021-03-04	\N	\N
963df514-e169-4873-8cd5-0d01ec1a44a1	Honorable	Thurstan	Brimham	4bbe57fe-2346-4849-825a-4faf89e9f404	285	2020-11-30	\N	\N
9dce770c-e48e-413e-8671-cae32a6e4bd7	Dr	Goober	Disbrey	8d52237d-c84a-4a39-b0d1-1b982e756351	51	2020-06-13	\N	\N
1308859e-2381-418d-8ddb-63b319614045	Rev	Rayner	Gipp	613dd627-a415-4d68-9d28-f8bf4e53108a	218	2021-02-09	\N	\N
54cd8f94-2352-42bb-8a0a-3a20f2a8654a	Mr	Jacki	Toleman	613dd627-a415-4d68-9d28-f8bf4e53108a	186	2020-09-19	\N	\N
3d704bd9-0351-4d96-b816-e2e4e494eb6b	Mrs	Winfred	Reardon	c47d962c-6068-4164-87fa-8482821f1ef8	391	2021-02-02	\N	\N
ac32cacc-b270-43a1-83c1-a8de9d7c058f	Honorable	Lawton	Mabee	647290c1-28de-4372-8a88-40cbb93f497f	289	2020-08-08	\N	\N
68fb9fba-6e97-4fe1-9b7c-b06c30d64c1a	Ms	Andromache	Matuszkiewicz	990fdacb-e6a1-45a0-89e0-e69b9d02323c	95	2020-12-19	\N	\N
47bd05e4-4bb4-4b49-aa69-402fcd4d32d5	Rev	Charley	Quittonden	a2032c3e-fbd1-4167-b750-3d3ecc65eafe	436	2020-12-21	\N	\N
9ba2dfb2-4388-422f-9081-fb7be1b693de	Rev	Collen	Whisby	2dd14100-5fa5-4e22-af6c-d3ec7722c0b5	234	2021-01-30	\N	\N
cfe21b6b-9967-4795-8130-ce617fb3b63b	Honorable	Euell	Layburn	b273a772-1423-4829-9cc5-58df92c1bfed	245	2020-05-28	\N	\N
c5be5a02-d179-44b4-b904-0741d29ae0a5	Dr	Murry	Laxe	acdb44fb-9fb9-4fb8-87b0-599f5c8a95a8	400	2020-12-09	\N	\N
918b6660-c342-4ed1-9bbd-aff6c58902de	Honorable	Drusy	Gantley	45f8afa1-7de0-4837-b239-ef5c1303967f	90	2021-01-06	\N	\N
267a6bde-4993-4dc0-bced-31cbb8117b60	Mrs	Dom	Leasor	ee5b117e-af6e-4c43-8bb6-cb1bbe05d93e	437	2020-12-15	\N	\N
88856ea8-e43f-4f8c-a287-e01d07b63710	Rev	Gwendolyn	Worham	8d52237d-c84a-4a39-b0d1-1b982e756351	392	2020-05-14	\N	\N
e2e850c7-82f3-4f37-8e0b-c956e2dfceec	Ms	Marlo	Laugheran	69d16bf4-afe9-410d-9afe-ec85a2ebea3b	200	2020-08-06	\N	\N
824a40c1-0ec1-4d2c-abd7-e29755b5878f	Mr.	John	Snow	68643051-9b6f-44a4-bd72-2ddc8b8b6123	20	0323-12-14	\N	\N
967045ab-385f-482e-96e1-12108cda0bab	Mr.	Joey	Snowden	68643051-9b6f-44a4-bd72-2ddc8b8b6123	50	2019-12-14	\N	\N
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required, created, updated) FROM stdin;
d8fc2201-7ef5-4311-ae00-31f128a7304d	tosaxofon	xxx-0099	tosaxinnnn	500	100	50	550	50	\N	\N
c9b21e32-9548-497c-9ed7-0011a4f3ec92	test pr	2321-4413	my product	400	40	10	430	10	\N	\N
54f0e223-b857-484d-a6d0-712e77c0c129	my test pr	xxyy-4413	my-product	500	40	10	530	10	\N	\N
17868893-ac73-424c-8f31-39325192f052	mysstest pr	xxyy-4413	my-product	500	40	10	530	10	\N	\N
4b96c64d-c890-47b6-9d88-6f1e8d4a1b96	Antibacterial Hand Soap	AFU-353091	WhiskCare 367	5480	4267	1096	8651	565	\N	\N
fd7370a9-9b36-470c-8fee-26dedcec4669	Methyl Salicylate, Menthol and Capsaicin	QXJ-199396	Overtime	6640	3964	1328	9276	238	\N	\N
d0ae730e-d79a-4f01-9bb4-42cdf1d8e90a	Divalproex Sodium	LWR-817212	Divalproex Sodium	7617	762	1523	6856	282	\N	\N
21bbd1d4-aa17-4429-9d7a-46049c306020	furosemide	CPU-482228	Lasix	8566	1444	1713	8297	971	\N	\N
3caef524-81aa-4879-940a-4b3621434d03	petrolatum	JLJ-731517	Personal Care Petroleum	6872	687	1374	6185	352	\N	\N
647290c1-28de-4372-8a88-40cbb93f497f	disopyramide phosphate	ULR-360250	Norpace	2038	2371	408	4001	647	\N	\N
68643051-9b6f-44a4-bd72-2ddc8b8b6123	Pinchot Juniper	AMU-671937	Pinchot Juniper	3777	2314	755	5336	813	\N	\N
f6868042-723d-4ef9-9b0e-bbe906bedb3d	spironolactone	RXR-692802	Spironolactone	4577	3602	915	7264	163	\N	\N
ee5b117e-af6e-4c43-8bb6-cb1bbe05d93e	Aesculus carnea, flos, Aesculus hippocastanum, flos, Agrimonia eupatoria, flos, Antimonium crudum, Avena sativa, Chamomilla, Colocynthis, Crocus sativus, Ferrum metallicum, Impatiens glandulifera, flos, Kali carbonicum, Natrum muriaticum, Populus tremula, flos, Staphysagria, Thyroidinum	QHX-302068	Easily Angered	7589	2212	1518	8283	569	\N	\N
a2032c3e-fbd1-4167-b750-3d3ecc65eafe	Meloxicam	EAQ-084033	Meloxicam	5221	522	1044	4699	807	\N	\N
45f8afa1-7de0-4837-b239-ef5c1303967f	Divalproex Sodium	KTQ-730557	Divalproex Sodium	7486	3161	1497	9150	125	\N	\N
b279f10a-6410-4f4a-ad47-8ebc482610c1	TITANIUM DIOXIDE	HWT-645250	DOUBLE PERFECTION LUMIERE	7964	2421	1593	8792	619	\N	\N
4b16bc84-8c21-4918-b70d-4b1ae2502851	PYRITHIONE ZINC	FBQ-342880	DANDRUFF 2 IN 1 SHAMPOO AND CONDITIONER	3508	351	702	3157	185	\N	\N
69d16bf4-afe9-410d-9afe-ec85a2ebea3b	ZINC OXIDE	TXW-324497	GOOD NEIGHBOR PHARMACY DIAPER RASH CREAMY	2366	2508	473	4401	332	\N	\N
8d52237d-c84a-4a39-b0d1-1b982e756351	Octinoxate, Oxybenzone, Titanium Dioxide	ZNV-350259	Quiet Rose Always color stay-on Makeup Broad Spectrum SPF 15	6859	2783	1372	8270	818	\N	\N
2a037af8-12dd-426c-89f9-eefc4a8e2cab	Cyproheptadine Hydrochloride	SAY-244366	Cyproheptadine Hydrochloride	8559	856	1712	7703	730	\N	\N
acdb44fb-9fb9-4fb8-87b0-599f5c8a95a8	estradiol	FNQ-362262	Vagifem	1938	194	388	1744	802	\N	\N
3d94b38e-0d94-442d-b5cf-65dc758ad446	MICONAZOLE NITRATE	YZA-286404	Secura Antifungal	9989	382	1998	8373	154	\N	\N
937dc15c-0168-4e04-91d2-7db5a423f53b	Tolnaftate	WSI-594345	Nail Active Daytime Anti-fungal	7237	543	1447	6333	692	\N	\N
fa8438d9-f327-4374-b6e3-7aa48b547a44	OCTINOXATE and TITANIUM DIOXIDE	LPM-309322	SHISEIDO UV PROTECTIVE FOUNDATION	8981	4600	1796	11785	845	\N	\N
990fdacb-e6a1-45a0-89e0-e69b9d02323c	Diphenoxylate Hcl and Atropine Sulfate	UZP-048443	Diphenoxylate Hcl and Atropine Sulfate	3441	4581	688	7334	645	\N	\N
f7b2ca87-c9a3-443f-b88a-073cef46fd41	Levothyroxine Sodium	LLD-391340	Levothyroxine Sodium	8671	437	1734	7374	692	\N	\N
dd2b14bf-e7db-4fd9-8c09-a91695ef48bc	TITANIUM DIOXIDE	EXX-134772	SENSAI CELLULAR PERFORMANCE HYDRACHANGE TINTED 3 SOFT ALMOND	5547	3389	1109	7827	579	\N	\N
2dd14100-5fa5-4e22-af6c-d3ec7722c0b5	American Sycamore	SSF-404800	PLATANUS OCCIDENTALIS POLLEN	9038	3440	1808	10670	997	\N	\N
262dea47-980c-4361-969a-6ed86093e494	my priduct	xxx-6666	myproduct	1000	500	100	1400	5	\N	\N
92f32668-962e-483d-8a66-48072ff7888a	dimethicone, octinoxate, oxybenzone	LID-848206	Softlips Intense Moisture Double Mint	8628	863	1726	7765	773	\N	\N
4bbe57fe-2346-4849-825a-4faf89e9f404	Ibuprofen	YNR-552062	Ibuprofen	4956	2316	991	6281	824	\N	\N
e7ddd2c0-4aea-4564-8920-65785fa67597	amoxicillin and clavulanate potassium	XMP-653163	Amoxicillin and Clavulanate Potassium	9023	902	1805	8120	456	\N	\N
c47d962c-6068-4164-87fa-8482821f1ef8	Methylprednisolone Acetate, Lidocaine Hydrochloride, Bupivacaine Hydrochloride, Povidine Iodine, Sodium Chloride, Isopropyl Alcohol	YNE-671871	Dyural 80 Kit	8701	3126	1740	10087	645	\N	\N
b273a772-1423-4829-9cc5-58df92c1bfed	Ibuprofen	CJW-639549	ibuprofen	7281	1729	1456	7554	917	\N	\N
b45cbb39-69eb-4e83-a665-c243940d2bbd	ALCOHOL	OFH-322420	Antibacterial Hand Sanitizer Spray	6912	691	1382	6221	662	\N	\N
2aa5d338-248c-4b8b-a7b9-52af04e4012f	Avobenzone, Octinoxate, Octisalate, Octocrylene, oxybenzone	WDV-524590	Advanced Dynamics Soothing day Moisture Broad Spectrum SPF 15	7236	724	1447	6513	169	\N	\N
693814d4-aa93-4cf4-9854-9f1d1d0786d7	my latest product	ghft-4343	melasofaxin	2500	300	500	2300	50	\N	\N
d5a196b6-f2b8-4856-86b0-aa736ad14aaa	SCHOENOCAULON OFFICINALE SEED	KND-500877	Sabadilla Kit Refill	2273	227	455	2045	625	\N	\N
5a58e622-1c05-4cff-92b8-3d8771b364c4	Ursodiol	HRT-786880	Ursodiol	6388	639	1278	5749	486	\N	\N
234d7a23-a5de-4918-a865-21946942a6c2	Polyvinyl Alcohol and Povidone and Tetrahydrozoline Hydrochloride	AWR-709000	Clear Eyes Triple Action	9319	2268	1864	9723	407	\N	\N
45057078-a03e-4315-8d0c-7a82302bfc61	Titanium Dioxide	QQZ-073419	BareMinerals	8745	1176	1749	8172	859	\N	\N
b2a0f19d-4bef-49ab-b296-4bda23ecdba7	Diphenhydramine Hydrochloride and Phenylephrine Hydrochloride	AFC-095310	Nite Time Cold and Cough	6626	2812	1325	8113	708	\N	\N
db332512-850d-4550-8fbf-014c23cb1e8f	WATER	JVG-862947	Sterile Water	7024	702	1405	6321	219	\N	\N
d0291dc8-c365-4da7-8cc0-28cf8b73aec8	Nortriptyline Hydrochloride	IHW-858778	Nortriptyline Hydrochloride	6312	2070	1262	7120	966	\N	\N
64f85967-5694-4741-9ce8-6de31427a77f	Simethicone	GRX-831936	Gas Relief	8806	204	1761	7249	865	\N	\N
80162355-6830-4b9d-8812-25b2a0108cab	Clindamycin Hydrochloride	IAO-676390	Clindamycin Hydrochloride	3835	1328	767	4396	459	\N	\N
305e5866-19e4-4b3f-9b2c-88b1b7ac45f9	methotrexate	CEV-669864	Trexall	4281	3958	856	7383	337	\N	\N
bf372f8c-0ca2-4dc0-83f3-40062af7a071	Levothyroxine Sodium	RQK-315749	Levothyroxine Sodium	7316	2007	1463	7860	641	\N	\N
21921698-e2a4-40eb-9cf2-51725228ab2e	ranitidine hydrochloride	LGE-836599	Ranitidine	9558	2677	1912	10323	603	\N	\N
2038586f-6f7b-4918-ad36-17a763746c93	Esterified Estrogens and Methyltestosterone	RWV-721626	Esterified Estrogens and Methyltestosterone	3335	2526	667	5194	198	\N	\N
18364687-7b65-4859-946a-d2ce1e158445	Pollens - Weeds, Marshelder/Poverty Mix	FBH-486224	Pollens - Weeds, Marshelder/Poverty Mix	1111	3400	222	4289	408	\N	\N
613dd627-a415-4d68-9d28-f8bf4e53108a	nifedipine	EEF-472062	nifedipine	1475	4991	295	6171	571	\N	\N
2f17e16f-0716-48cf-a81c-69a4355e23f6	Gabapentin	FAB-499989	Neurontin	9660	4939	1932	12667	176	\N	\N
14c1dc6a-3179-499d-a94c-d5a968255ebc	Levetiracetam	LMW-982176	Levetiracetam	8819	1353	1764	8408	994	\N	\N
c0c8ba38-005e-4bdf-bb7d-4f67d87d7faa	sodium sulfacetamide, sulfer	OTH-476924	Rosanil	2336	525	467	2394	565	\N	\N
b16b64ea-fbea-40fb-ab00-2e77229459c8	product tst 3	DHFT-94729	SYmoflaxin	1500	300	500	1300	50	\N	\N
d5d6e828-1b7e-47fc-8983-93e06159d91c	test name	ddd-ewe	some- label	14	20	10	24	10	\N	\N
\.


--
-- Data for Name: purchases; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchases (id, supplier_id, product_id, number_received, purchase_date, updated, created) FROM stdin;
32415f93-47d5-41e9-999b-05ab0bc817ce	8659773b-2c78-4896-848d-5c9c4bb48e27	b45cbb39-69eb-4e83-a665-c243940d2bbd	10	2019-07-05	\N	\N
1f4137a5-0767-4b9e-a33f-f88f9ffac681	8659773b-2c78-4896-848d-5c9c4bb48e27	b45cbb39-69eb-4e83-a665-c243940d2bbd	10	2019-07-05	\N	\N
4ad15174-f20b-441d-9e83-e54b497e7433	8659773b-2c78-4896-848d-5c9c4bb48e27	b45cbb39-69eb-4e83-a665-c243940d2bbd	37	2019-07-05	\N	\N
e5ddc2ae-b853-422e-bebf-c07d801d6662	f3267a7a-e10e-4f37-b64a-6be6fed6c588	c0c8ba38-005e-4bdf-bb7d-4f67d87d7faa	4528	2020-03-18	\N	\N
c0a2ba5a-3a67-4883-9b59-63d15aa95292	b76bc617-2b56-4c9d-80a3-3761e40ce33a	b273a772-1423-4829-9cc5-58df92c1bfed	2288	2019-09-23	\N	\N
e9c4501a-f10c-47a0-9e1e-aaee1f35a250	e0c5f812-f561-4d47-adc0-a578e36a2069	f6868042-723d-4ef9-9b0e-bbe906bedb3d	2781	2019-11-05	\N	\N
b9c7cdd8-508e-4d2c-a620-234643fb1a57	46c62e98-6f4d-430f-a177-2527970ea719	2f17e16f-0716-48cf-a81c-69a4355e23f6	4147	2020-03-15	\N	\N
f276247d-99fa-4144-957d-be69bb3801c7	97c77abe-449b-46b1-a3ae-e70a0d22c003	68643051-9b6f-44a4-bd72-2ddc8b8b6123	604	2019-07-21	\N	\N
e0449d2d-8e07-46ca-a81f-d259e52520be	bb319a4f-74bc-48af-ae3a-0ed5f52d5897	fd7370a9-9b36-470c-8fee-26dedcec4669	3763	2019-11-08	\N	\N
bbf4f910-9363-4940-ac6b-c827a8c87dd5	819500ed-2e3f-48af-9d78-74cf0d3d9c30	2f17e16f-0716-48cf-a81c-69a4355e23f6	1056	2019-08-30	\N	\N
666a1d88-bdc8-4866-85c3-e716ee9d6256	aea3f841-1f9c-4303-9bc0-22e8c6e27cd5	acdb44fb-9fb9-4fb8-87b0-599f5c8a95a8	4169	2020-01-15	\N	\N
bf5a4696-20a4-42d2-b250-5c2b8bb666c1	f0db2b83-d4ac-43b1-b52d-96fef8e74dad	647290c1-28de-4372-8a88-40cbb93f497f	4029	2020-03-26	\N	\N
8851db43-ee8d-4b3a-be79-c5d01d20b07e	e05332b7-c585-4bff-bb76-3040100bee31	db332512-850d-4550-8fbf-014c23cb1e8f	427	2019-09-01	\N	\N
bd048325-adee-4464-8cba-85fa9f565ae8	bf0a7ca9-f872-4d1f-803d-f9ebb98c2585	bf372f8c-0ca2-4dc0-83f3-40062af7a071	4063	2020-02-05	\N	\N
00a2e530-8064-4468-8994-921a8cdb62d3	f3d458c4-40a7-4efe-ad67-95c9bf01b568	fa8438d9-f327-4374-b6e3-7aa48b547a44	847	2019-09-05	\N	\N
a6bf0afe-74ef-484c-b3d7-446d9abe1880	ef564b43-935c-4a0e-8f96-d4c2aeee5c83	21bbd1d4-aa17-4429-9d7a-46049c306020	4135	2019-09-27	\N	\N
08d07342-9a9f-46b8-be24-8ffc1bc558d1	5234be84-c5fd-42af-b3f5-131209906997	c0c8ba38-005e-4bdf-bb7d-4f67d87d7faa	780	2019-06-03	\N	\N
59d9a0a3-ae57-4461-a3f1-c72f45cd1598	a12f3cf6-b18b-496a-843b-cf65425b1358	fd7370a9-9b36-470c-8fee-26dedcec4669	2574	2019-11-22	\N	\N
f9fca252-cd48-4ecd-9406-43a7c8085ad9	ebe237c7-1776-47f0-b8be-4698e282710c	4bbe57fe-2346-4849-825a-4faf89e9f404	921	2019-08-15	\N	\N
ded1aee3-6930-44af-941f-aab228d785ec	30a476ff-6587-43a3-88cf-ada2a419607c	18364687-7b65-4859-946a-d2ce1e158445	4808	2019-11-04	\N	\N
0251f347-efdf-4d44-9a15-3451473ae775	5575521f-9fe9-4e6f-911d-8a065239e21f	acdb44fb-9fb9-4fb8-87b0-599f5c8a95a8	1214	2019-10-26	\N	\N
\.


--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.suppliers (id, supplier, created, updated) FROM stdin;
1fcbeabb-8b36-43ce-a505-7e5ed00b2d60	Sun Pharmaceutical Industries Limited	\N	\N
67d73aba-764e-4b24-bfea-185ac023f17c	DOLGENCORP INC	\N	\N
e0c5f812-f561-4d47-adc0-a578e36a2069	Paddock Laboratories, LLC	\N	\N
30a476ff-6587-43a3-88cf-ada2a419607c	Hospira, Inc.	\N	\N
783ced34-9ce5-4232-86a6-7322e90c3c71	SPAI-SONS PHARMACEUTICAL INTERNATIONAL COSMETICS	\N	\N
c4f7c7d6-8dc9-4f04-8f77-253b545467a3	Allermed Laboratories, Inc.	\N	\N
23d4c190-7b6d-4fda-ad8a-661627fa330a	J. A. Cosmetics U.S. INC	\N	\N
a738f182-601a-4a67-98c0-b46165680fc3	Cardinal Health	\N	\N
64fef7c7-804c-4a5e-948a-38efdc94e397	Meijer Distribution Inc	\N	\N
a12f3cf6-b18b-496a-843b-cf65425b1358	Par Pharmaceutical, Inc.	\N	\N
5575521f-9fe9-4e6f-911d-8a065239e21f	Apotex Corp.	\N	\N
d8abecca-19d9-4847-8813-06462ad23d8f	ALK-Abello, Inc.	\N	\N
c00d7345-3647-4039-806d-859d686d4b2d	Dispensing Solutions, Inc.	\N	\N
aea3f841-1f9c-4303-9bc0-22e8c6e27cd5	Hikma Pharmaceutical	\N	\N
97c77abe-449b-46b1-a3ae-e70a0d22c003	Bryant Ranch Prepack	\N	\N
072484d1-a0c8-4570-a75e-27ca923cf769	ENCHANTE ACCESSORIES INC.	\N	\N
819500ed-2e3f-48af-9d78-74cf0d3d9c30	STAT Rx USA LLC	\N	\N
f3267a7a-e10e-4f37-b64a-6be6fed6c588	Home Sweet Homeopathics	\N	\N
8c296c41-1582-4b0b-8892-cd7ec2aa2815	Health Care Products	\N	\N
5234be84-c5fd-42af-b3f5-131209906997	Uriel Pharmacy Inc.	\N	\N
0927c8f0-236d-44a3-abe7-6dd32e514b4f	Mylan Pharmaceuticals Inc.	\N	\N
ef564b43-935c-4a0e-8f96-d4c2aeee5c83	Antigen Laboratories, Inc.	\N	\N
ea361c0e-9945-430d-b242-2af10355fdd1	Cardinal Health	\N	\N
c50708f3-841f-4f03-8a4d-6cf3d11311d3	LaCorium Health International Pty Ltd	\N	\N
f3d458c4-40a7-4efe-ad67-95c9bf01b568	Steris Corporation	\N	\N
f9849bab-23d9-42b2-989e-ab9cd66f43e9	Hikma Pharmaceutical	\N	\N
45ee42a4-01c9-451e-8e03-05aea0ffda30	Antigen Laboratories, Inc.	\N	\N
8659773b-2c78-4896-848d-5c9c4bb48e27	STERIS Corporation	\N	\N
b09a7376-f5f3-463c-9afe-2067b03a8cda	Amerisource Bergen	\N	\N
b76bc617-2b56-4c9d-80a3-3761e40ce33a	WG Critical Care, LLC	\N	\N
bf0a7ca9-f872-4d1f-803d-f9ebb98c2585	Golden State Medical Supply, Inc.	\N	\N
a661f7b1-d374-4154-99a8-742afe5041dd	sanofi-aventis U.S. LLC	\N	\N
0d3f4229-d458-40da-be3b-9c3a9353e63f	Glenmark Generics, Inc. USA	\N	\N
bb319a4f-74bc-48af-ae3a-0ed5f52d5897	Preferred Pharmaceuticals, Inc.	\N	\N
f0db2b83-d4ac-43b1-b52d-96fef8e74dad	A-S Medication Solutions LLC	\N	\N
1a641faa-4b72-41e6-923e-d8a8858cb7cc	AvKARE, Inc.	\N	\N
f3eaa883-f3d4-44f0-bb4c-3098ea11c41f	Antigen Laboratories, Inc.	\N	\N
1012379a-c928-4e74-9576-3e5d4a6890bc	STAT RX USA LLC	\N	\N
3ef0cc7e-f4b2-4189-8f5b-8b00995d4c15	Rij Pharmaceutical Corporation	\N	\N
82773341-f4b5-4ce1-8d74-0ff4b865b81c	BioMarin Pharmaceutical Inc.	\N	\N
32a8a223-328d-4238-9225-a97e831c7742	Nelco Laboratories, Inc.	\N	\N
fc75b7ac-b3d5-46b7-bcb6-d00b959b6a83	Wockhardt USA, LLC	\N	\N
e05332b7-c585-4bff-bb76-3040100bee31	Ranbaxy Pharmaceuticals Inc.	\N	\N
c3b7808f-7365-4c40-ac73-59ec1709b440	CLINIQUE LABORATORIES INC	\N	\N
b7c4ad5c-6a02-4fc0-b9b5-3a405c24468a	Forest Laboratories, Inc.	\N	\N
14ad4d14-0cb8-4914-a58d-e4743884b8f9	St Marys Medical Park Pharmacy	\N	\N
46c62e98-6f4d-430f-a177-2527970ea719	Bausch & Lomb Incorporated	\N	\N
ebe237c7-1776-47f0-b8be-4698e282710c	PD-Rx Pharmaceuticals, Inc.	\N	\N
098e7f0e-c844-4fef-8e04-edadd9661a45	Wal-Mart Stores Inc	\N	\N
6f95268b-a8c9-4129-a9ed-d142d05dc2ab	Dom Dominque Inc.	2020-04-28 14:04:37.551678+05:30	2020-04-28 14:05:32.977536+05:30
411e9461-57b3-4980-9795-36ec6aebaa1c	Wockhardt USA LLC.	\N	2020-04-30 13:14:13.366207+05:30
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, first_name, last_name, user_name, email, type, created, updated, address, phone, hash, salt) FROM stdin;
52901450-ee60-494e-8c81-2461623f2607	Cirius	\N	admin	admin@test.com	admin	2020-05-02 14:22:05+05:30	\N	\N	\N	87e0a2467ad6eeaceef8a8177b86b61cae191defed9c4c2dec395240bb40d32cc2bbacd889e6098ee93a1582fcc4831f2c11ae5474698733872a539e96108c55	7c581a6ba15b4531
9b586758-f3c5-4afb-84ad-d9158dc70e4a	Dwain	\N	dwayn	dwayn@gmail.co.in	guest	2020-05-02 16:47:46+05:30	\N	no mans land	9087564512	e69eaf4025fab5d65ac763b633a28d1e42427d8e1f4ed88f258485e33f717fd2a8418c0ca41ec9ca09324e92b228ac9e80248ac4d7fb0e79a3ef08e8ccbc5676	55ab2117c705d907
8765fbea-213e-43e3-a7de-16a4a5ee8d27	Dwain 2	\N	dwayn2	dwayn2@gmail.co.in	guest	2020-05-03 16:46:10+05:30	\N	no mans land	9087564512	116c67c345813547adf842a6a3014a8466d65529956000c77abed592d9087acbe9435aefcef63c99f2740c046fab3dba4ee407fb64283f77332169abc7708093	72a2e55f55745123
cc9204c2-f839-47d1-8771-0c0eb0ed2f4e	Dwain 3	\N	dwayn3	dwayn3@gmail.co.in	guest	2020-05-03 16:48:00+05:30	\N	no mans land	9087564512	a2513da7662c59550fea30026f6bfd117489989133a2163c7cd9d10540ba6016329e5005136875858663fcd88d57ececc852e698e1cd236510dcf27a2fe8a7a9	5fb0d97cfa201e28
fbdccb0f-535a-4c32-973f-de4f0897fe83	Dwain 4	\N	dwayn4	dwayn4@gmail.co.in	guest	2020-05-03 16:58:01+05:30	\N	no mans land	9087564512	fc30a2f857d0630c2517f46c645ccc7681b194532d321f4d30b06964d0a63abc8f14894b081c8f994d50941117a0d531cb8b313252680870eec0225dee9e0a3f	682ce51c9883d316
7fde3e51-d118-4f4e-bb42-220ea5e7302b	Dwain 5	\N	dwayn5	dwayn5@gmail.co.in	guest	2020-05-03 16:59:13+05:30	\N	no mans land	9087564512	582a9992d49551df37a89b69408ff332c3111a5acc34b73a329e1e7401b93d0e020bad720c2f34d52f40b34149fb4e9e9db4e15e98b753806383eff448892aad	78526506cc3f7a3e
73522759-0a85-4694-8ec8-37f94c981aba	Dwain 6	\N	dwayn6	dwayn6@gmail.co.in	guest	2020-05-03 17:04:12+05:30	\N	no mans land	9087564512	4990edc113abbb16e2861a3ea553fe8cb06532234c5d9fb924a899a47f33f6343bc9b834cf0872e1c9e3a8541f9868e0965e058e00a359d74c8b5197c21a2a32	972a8867b22f0175
48d4a60e-215f-4dfb-807a-eac0a7764417	Dwain 7	\N	dwayn7	dwayn7@gmail.co.in	guest	2020-05-03 17:08:58+05:30	\N	no mans land	9087564512	7e06968f5fee504a92511b1aae1628d37a4da5fdbfe651c58d25eed156820d6570dc9775b2f6af0c3373b720f0f71927fee39b9fdebd19b32a5612c82ed0ec05	eb7ae648d47e2388
bea946ee-4d1b-4c9b-b1d4-711fc49095e0	Dwain 8	\N	dwayn8	dwayn8@gmail.co.in	guest	2020-05-03 17:09:58+05:30	\N	no mans land	9087564512	93d2d8ae9591ba15f6f8c05f058751dc63bdff46dd03adfae46d8fa18b493f8bb3b90d967033ece1113805cca802ddb893a4a46f9cce7b6af12b5ec17d8604d2	eabc0c074b648c06
\.


--
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.audit_logs_id_seq', 25, true);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: purchases purchases_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_pkey PRIMARY KEY (id);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_hash_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_hash_key UNIQUE (hash);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_salt_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_salt_key UNIQUE (salt);


--
-- Name: users users_user_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_user_name_key UNIQUE (user_name);


--
-- Name: orders table_operation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER table_operation AFTER INSERT OR DELETE OR UPDATE ON public.orders FOR EACH ROW EXECUTE PROCEDURE public.table_query_operation();


--
-- Name: products table_operation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER table_operation AFTER INSERT OR DELETE OR UPDATE ON public.products FOR EACH ROW EXECUTE PROCEDURE public.table_query_operation();


--
-- Name: purchases table_operation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER table_operation AFTER INSERT OR DELETE OR UPDATE ON public.purchases FOR EACH ROW EXECUTE PROCEDURE public.table_query_operation();


--
-- Name: suppliers table_operation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER table_operation AFTER INSERT OR DELETE OR UPDATE ON public.suppliers FOR EACH ROW EXECUTE PROCEDURE public.table_query_operation();


--
-- Name: users table_operation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER table_operation AFTER INSERT OR DELETE OR UPDATE ON public.users FOR EACH ROW EXECUTE PROCEDURE public.table_query_operation();


--
-- Name: orders orders_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: purchases purchases_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: purchases purchases_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id);


--
-- PostgreSQL database dump complete
--

