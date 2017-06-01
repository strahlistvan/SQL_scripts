-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE PROCEDURE `load_post_keywords` ( IN p_post_id_old INTEGER,
										IN p_post_id_wp  INTEGER
								      )
BEGIN
  DECLARE v_found IN
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;

  DECLARE v_cursor CURSOR FOR
    SELECT kw.keyword
      INTO v_keyword
      FROM `comsciblog`.`keyword` kw
     WHERE kw.keyword_id = p_post_id;

 cursor_loop: LOOP
   FETCH v_cursor INTO v_keyword_name;
 END LOOP cursor_loop;
END $$

DELIMITER ;