--节假日配置表2018法定节假日配置

DROP TABLE IF EXISTS `holiday`;

CREATE TABLE `holiday` (
  `id` int(32) NOT NULL AUTO_INCREMENT,
  `year` varchar(20) NOT NULL,
  `month` varchar(20) NOT NULL,
  `day` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=169 DEFAULT CHARSET=utf8;

/*Data for the table `holiday` */

insert  into `holiday`(`id`,`year`,`month`,`day`) values (156,'2018','1','1,6,7,13,14,20,21,27,28'),(157,'2018','2','3,4,10,15,16,17,18,19,20,21,25'),(158,'2018','3','3,4,10,11,17,18,24,25,31'),(159,'2018','4','5,6,7,14,15,21,22,29,30'),(160,'2018','5','1,5,6,12,13,19,20,26,27'),(161,'2018','6','2,3,9,10,16,17,18,23,24,30'),(162,'2018','7','1,7,8,14,15,21,22,28,29'),(163,'2018','8','4,5,11,12,18,19,25,26'),(164,'2018','9','1,2,8,9,15,16,22,23,24'),(165,'2018','10','1,2,3,4,5,6,7,13,14,20,21,27,28'),(166,'2018','11','3,4,10,11,17,18,24,25'),(167,'2018','12','1,2,8,9,15,16,22,23,29,30');

-----------------------------------------------------------------------------------------------------

----判断是否节假日 true 是  false 否
DROP FUNCTION IF EXISTS fCheckHoliday ;

DELIMITER //
CREATE FUNCTION `fCheckHoliday`(s DATETIME) 
	RETURNS BOOLEAN 
BEGIN
    DECLARE a, b, c, d, e SMALLINT UNSIGNED DEFAULT 0;
    DECLARE holiday VARCHAR(50);
    SET a = (SELECT DATE_FORMAT(s, '%Y') FROM DUAL) ; -- 传入时间的年
    SET b = (SELECT DATE_FORMAT(s, '%m') FROM DUAL) ; -- 传入时间的月
    SET c = (SELECT DATE_FORMAT(s, '%d') FROM DUAL) ; -- 传入时间的日    
    SET e = (SELECT WEEKDAY(s)+1 FROM DUAL) ; -- 传入时间的星期 
    SET holiday = (SELECT DAY FROM `holiday` WHERE YEAR=a AND MONTH=b) ;
    IF (holiday IS NULL AND e>5) THEN
	SET d = 1 ;
    ELSEIF (holiday IS NULL AND e<=5) THEN
	SET d = 0 ;
    ELSE
	SET d = (SELECT FIND_IN_SET(c, holiday)) ; -- 检查传入日是否配置的工作日
    END IF;
    
    RETURN d>0;
END //

------------------------------------------------------------------------------------------------------


DROP FUNCTION IF EXISTS to_workdate ;

DELIMITER //
CREATE FUNCTION `to_workdate`(s DATETIME) 
	RETURNS DATE 
BEGIN
    DECLARE retDate DATE ;
    DECLARE isHoliday BOOLEAN;
    DECLARE n int unsigned default 0;
    SET retDate = s ;
	WHILE n <= 0 DO
            SELECT DATE_ADD(retDate, INTERVAL + 0 DAY) INTO retDate ;
	    SELECT fCheckHoliday(retDate) INTO isHoliday ;
            IF isHoliday IS FASLE THEN
	        SET n = 1 ;
                RETURN retDate;

            ELSE SELECT DATE_ADD(retDate, INTERVAL + 1 DAY) INTO retDate ;
                
	    END IF ; 
		
	END WHILE ;
END //


----------------------------------------------------------------------------------------------------

检测

SELECT to_workdate('2018-08-31 23:12:23') ;

