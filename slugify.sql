-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE FUNCTION `slugify` (p_text VARCHAR(255))
RETURNS VARCHAR(255)
BEGIN
  DECLARE v_slug VARCHAR(255);
  
  SET v_slug = LOWER(p_text);
  SET v_slug = REPLACE(v_slug, 'á', 'a');
  SET v_slug = REPLACE(v_slug, 'é', 'e');
  SET v_slug = REPLACE(v_slug, 'í', 'i');
  SET v_slug = REPLACE(v_slug, 'ó', 'o');
  SET v_slug = REPLACE(v_slug, 'ö', 'o');
  SET v_slug = REPLACE(v_slug, 'ö', 'o');
  SET v_slug = REPLACE(v_slug, 'ő', 'o');
  SET v_slug = REPLACE(v_slug, 'ú', 'u');
  SET v_slug = REPLACE(v_slug, 'ü', 'u');
  SET v_slug = REPLACE(v_slug, 'ű', 'u');
  SET v_slug = REPLACE(v_slug, ' ', '_');

  RETURN v_slug;
END 