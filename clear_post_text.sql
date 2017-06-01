-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE FUNCTION `clear_post_text` (p_text TEXT)
RETURNS TEXT
BEGIN
  DECLARE v_text TEXT;
  SET v_text = p_text;
  SET v_text = REPLACE(v_text, '&eacute;', 'é'); 
RETURN v_text;
END $$