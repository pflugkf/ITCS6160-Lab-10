/*Kristin Pflug*/

#1
DROP TRIGGER IF EXISTS friendly_trigger;
DELIMITER //
CREATE TRIGGER friendly_trigger
AFTER INSERT ON highschooler
FOR EACH ROW 
BEGIN
	IF(NEW.name ='Friendly') THEN
		INSERT INTO likes(ID1, ID2) SELECT NEW.ID, ID FROM highschooler WHERE ID != NEW.ID;
    END IF;
END;

#2
DROP PROCEDURE IF EXISTS insert_friend;
DELIMITER //
CREATE PROCEDURE insert_friend(IN person1 INT, IN person2 INT)
BEGIN
    SET @pair_exists = (SELECT COUNT(*) FROM friend WHERE ID1=person1 AND ID2=person2);
    SET @reverse_pair_exists = (SELECT COUNT(*) FROM friend WHERE ID1=person2 AND ID2=person1);
	IF(@pair_exists < 1) THEN
		INSERT INTO friend VALUE (person1, person2);
    END IF;
	IF(@reverse_pair_exists < 1) THEN
		INSERT INTO friend VALUE (person2, person1);
    END IF;
END //
DELIMITER ;
CALL insert_friend(1934, 1661);

#3
DROP TRIGGER IF EXISTS auto_inc_highschooler;
DELIMITER //
CREATE TRIGGER auto_inc_highschooler
BEFORE INSERT ON highschooler
FOR EACH ROW 
BEGIN
	IF(NEW.ID IS NULL) THEN
		SET @highest_id = (SELECT MAX(ID) FROM highschooler);
        SET NEW.ID = @highest_id+1;
    END IF;
END;
INSERT INTO highschooler VALUES (NULL, 'Josh', 8);

#4a 
DROP VIEW IF EXISTS full_friend;
CREATE VIEW full_friend AS
SELECT t1.name AS name1, t1.grade AS grade1, t2.name AS name2, t2.grade AS grade2 FROM friend
JOIN highschooler AS t1 ON friend.ID1 = t1.ID
JOIN highschooler AS t2 ON friend.ID2 = t2.ID;

#4b
SELECT name1, name2 FROM full_friend WHERE grade1 != grade2;


