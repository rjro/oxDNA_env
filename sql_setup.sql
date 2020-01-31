USE azdna;

DROP TABLE IF EXISTS `Jobs`;

CREATE TABLE `Jobs` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `userId` int(11) DEFAULT NULL,
  `name` varchar(16) DEFAULT NULL,
  `uuid` varchar(64) DEFAULT NULL,
  `slurmId` varchar(16) DEFAULT NULL,
  `creationDate` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `Users`;

CREATE TABLE `Users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(32) NOT NULL DEFAULT '',
  `password` varchar(64) NOT NULL DEFAULT '',
  `email` varchar(100) NOT NULL UNIQUE,
  `status` int(1) NOT NULL DEFAULT `1`, --1 - basic; 2 - advanced; 3 - administrator
  `group` int(1) NOT NULL,
  `creationDate` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;