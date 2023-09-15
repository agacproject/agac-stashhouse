-- --------------------------------------------------------
-- Sunucu:                       127.0.0.1
-- Sunucu sürümü:                10.4.28-MariaDB - mariadb.org binary distribution
-- Sunucu İşletim Sistemi:       Win64
-- HeidiSQL Sürüm:               12.5.0.6677
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


CREATE TABLE IF NOT EXISTS `stashhouse` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coords` longtext DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


DELETE FROM `stashhouse`;
INSERT INTO `stashhouse` (`id`, `coords`, `data`) VALUES
	(12, '{"x":-1063.591552734375,"y":-1160.2901611328126,"z":2.75486040115356}', '{"password":"1240","sold":true,"price":"1400"}'),
	(13, '{"x":-1163.663330078125,"y":-905.9116821289063,"z":6.70496654510498}', '{"password":"6802","sold":true,"price":"1"}'),
	(14, '{"x":-1171.9293212890626,"y":-910.662841796875,"z":6.7045612335205}', '{"price":"1000","sold":true,"password":"8283"}'),
	(15, '{"x":-1023.04296875,"y":-997.859375,"z":2.15019226074218}', '{"password":"1008","sold":true,"price":"100"}'),
	(16, '{"x":-134.2350311279297,"y":-1580.3475341796876,"z":34.20806503295898}', '{"password":"0606","price":"1800","sold":true}'),
	(17, '{"x":-1074.1773681640626,"y":-1152.6920166015626,"z":2.15859746932983}', '{"password":"4578","price":"100","sold":true}'),
	(18, '{"x":-1279.5452880859376,"y":-843.3931884765625,"z":16.15115737915039}', '{"price":"100","password":"4578","sold":true}');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
