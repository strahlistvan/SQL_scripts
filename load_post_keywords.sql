-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

USE `wp_sample` $$

DROP PROCEDURE IF EXISTS `load_post_keywords` $$

CREATE PROCEDURE `load_post_keywords` ( IN p_keyword VARCHAR(255),
										IN p_term_taxonomy_id INTEGER )
BEGIN

  DECLARE v_done BOOLEAN;
  DECLARE v_post_id INTEGER;

  DECLARE v_cursor CURSOR FOR
    SELECT DISTINCT kw.post_id
      FROM `comsciblog`.`keyword` kw
     WHERE kw.keyword = p_keyword
   COLLATE utf8_unicode_ci;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;
  
 OPEN v_cursor;
 cursor_loop: LOOP
   FETCH v_cursor INTO v_post_id;
   
	INSERT IGNORE INTO `wp_sample`.`wp_term_relationships`
	( `object_id`,
	  `term_taxonomy_id`,
	  `term_order` )
	VALUES
	( v_post_id,
	  p_term_taxonomy_id,
	  0 )
      ;

   
 END LOOP cursor_loop;
END $$

DELIMITER ;