-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

USE `wp_sample` $$
DROP PROCEDURE IF EXISTS `load_keywords` $$

CREATE PROCEDURE `load_keywords` ()
BEGIN
  DECLARE v_keyword_name VARCHAR(255);
  DECLARE v_term_taxonomy_id INTEGER;
  DECLARE v_term_id	INTEGER;
  DECLARE v_done BOOLEAN DEFAULT FALSE;

  DECLARE v_cursor CURSOR FOR
    SELECT DISTINCT kw.keyword
      FROM `comsciblog`.`keyword` kw;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;
 
  OPEN v_cursor;
  cursor_loop: LOOP
    FETCH v_cursor INTO v_keyword_name;
    IF v_done THEN 
      LEAVE cursor_loop; 
    END IF;
  
	-- Get the inserting record's post_id in the new database 
	BEGIN
	 SELECT `AUTO_INCREMENT`
	   INTO v_term_id
	   FROM INFORMATION_SCHEMA.TABLES
	  WHERE TABLE_SCHEMA = 'wp_sample'
	    AND TABLE_NAME   = 'wp_terms';
	END;  

  -- Insert keyword to wp_terms
  INSERT INTO `wp_sample`.`wp_terms`
  (`name`,
   `slug`,
   `term_group`
  )
  VALUES
  ( v_keyword_name,
	v_keyword_name,  -- TODO: "slugify"
	0
  );
  
  INSERT INTO `wp_sample`.`wp_term_taxonomy`
  (
  `term_id`,
  `taxonomy`,
  `description`,
  `parent`,
  `count`
  )
  VALUES
  (
  v_term_id,
  'post-tag',
  '',
  0,
  1
 );
 
 SELECT MAX(term_taxonomy_id) 
   INTO v_term_taxonomy_id
   FROM wp_sample.wp_term_taxonomy;

  COMMIT; 
  
  CALL load_post_keywords(v_keyword_name, v_term_taxonomy_id);
 
 END LOOP cursor_loop;
END $$

DELIMITER ;