-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

USE `wp_sample` $$
DROP PROCEDURE IF EXISTS `load_posts` $$
SET SQL_SAFE_UPDATES = 0 $$

CREATE PROCEDURE `load_posts`( IN p_username VARCHAR(60),
						IN p_base_url	VARCHAR(200)
					  )
BEGIN
  DECLARE v_post_id_old INTEGER;
  DECLARE v_post_id_wp  INTEGER;
  DECLARE v_user_id     INTEGER DEFAULT 2;
  DECLARE v_title 	    VARCHAR(100);
  DECLARE v_text  	    TEXT;
  DECLARE v_created_at  DATETIME;
  DECLARE v_updated_at  DATETIME;
  DECLARE v_done	    BOOLEAN DEFAULT FALSE;

  DECLARE v_cursor CURSOR FOR
   SELECT t.post_id, t.title, t.text, t.created_at, t.updated_at
	 FROM `comsciblog`.`post` t
    WHERE 1=1;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;

  SELECT `ID` 
    INTO v_user_id
	FROM `wp_sample`.`wp_users` u
   WHERE TRIM(u.user_login) = TRIM(p_username);
    
  OPEN v_cursor;
  cur_loop: LOOP

	FETCH v_cursor INTO v_post_id_old, v_title, v_text, v_created_at, v_updated_at;
	IF v_done
	  THEN LEAVE cur_loop; 
	END IF;

	-- Get the inserting record's post_id in the new database 
	BEGIN
	 SELECT `AUTO_INCREMENT`
	 INTO v_post_id_wp
	 FROM  INFORMATION_SCHEMA.TABLES
	 WHERE TABLE_SCHEMA = 'wp_sample'
	 AND   TABLE_NAME   = 'wp_posts';
	END;

	INSERT INTO `wp_sample`.`wp_posts`
	(`post_author`,
	`post_date`,
	`post_date_gmt`,
	`post_content`,
	`post_title`,
	`post_excerpt`,
	`post_status`,
	`comment_status`,
	`ping_status`,
	`post_password`,
	`post_name`,
	`to_ping`,
	`pinged`,
	`post_modified`,
	`post_modified_gmt`,
	`post_content_filtered`,
	`post_parent`,
	`guid`,
	`menu_order`,
	`post_type`,
	`post_mime_type`,
	`comment_count`)
	VALUES
	(v_user_id,
 	 v_created_at,
	 v_created_at,
	 v_text,
	 v_title,
	'',
	 'publish',
	 'open',
	 'open',
	 '',
  	 '',
	 '',
	 '',
	 v_updated_at,
	 v_updated_at,
	 '',
	 0,
	 '',
	 0,
	 'post',
	 '',
	 0);

  END LOOP cur_loop;

  UPDATE wp_sample.wp_posts p 
     SET p.guid = CONCAT(p_base_url, p.ID)
  WHERE 1=1;

--  ROLLBACK;
END $$

DELIMITER ;