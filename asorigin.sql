

CREATE DATABASE IF NOT EXISTS asorigin;
USE asorigin;
SET FOREIGN_KEY_CHECKS = 0;


DROP TABLE IF EXISTS `alarmforward`;
CREATE TABLE `alarmforward`  (
  `forID` int(11) NOT NULL AUTO_INCREMENT,
  `forName` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `forUser` varchar(5000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `forCategory` varchar(5000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `forMethod` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `forTime` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `forStatus` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`forID`) USING BTREE,
  UNIQUE INDEX `forName`(`forName`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ;


DROP TABLE IF EXISTS `alarmlog`;
CREATE TABLE `alarmlog`  (
  `alarmLogID` bigint(11) NOT NULL AUTO_INCREMENT,
  `alarmTime` datetime(0) NOT NULL,
  `alarmDevice` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `alarmType` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `alarmCategory` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `alarmLevel` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `alarmDetail` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `alarmRecoveryTime` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `timeInt` bigint(20) NOT NULL,
  `alarmConfirmTime` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `alarmRepairTime` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`alarmLogID`) USING BTREE,
  INDEX `timeIntKey`(`timeInt`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ;


DROP TABLE IF EXISTS `alarmthreshold`;
CREATE TABLE `alarmthreshold`  (
  `thID` int(11) NOT NULL AUTO_INCREMENT,
  `thName` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `thType` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `thCategory` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `thValue` float NOT NULL,
  `thCount` int(11) NOT NULL,
  `thLevel` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `operator` char(2) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `thStatus` char(3) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`thID`) USING BTREE,
  INDEX `thCategoryKey`(`thCategory`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ;


DROP TABLE IF EXISTS `forwardlog`;
CREATE TABLE `forwardlog`  (
  `forwardLogID` bigint(11) NOT NULL AUTO_INCREMENT,
  `alarmDevice` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `alarmType` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `alarmCategory` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `alarmLevel` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `method` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `user` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `logTime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `timeInt` bigint(20) NOT NULL,
  `forwardDetail` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`forwardLogID`) USING BTREE,
  INDEX `timeIntKey`(`timeInt`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ;


DROP TABLE IF EXISTS `lang`;
CREATE TABLE `lang`  (
  `langID` int(11) NOT NULL AUTO_INCREMENT,
  `langcode` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `langname` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`langID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ;

-- ----------------------------
-- Records of lang
-- ----------------------------
INSERT INTO `lang` VALUES (1, 'cht', '??????');
INSERT INTO `lang` VALUES (2, 'chs', '??????');
INSERT INTO `lang` VALUES (3, 'eng', 'English');
INSERT INTO `lang` VALUES (4, 'cum', 'Customize');

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role`  (
  `rolename` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `rolerule` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`rolename`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES ('Admin', '15,15');
INSERT INTO `role` VALUES ('Guest', '0,0');
INSERT INTO `role` VALUES ('User', '15,15');

-- ----------------------------
-- Table structure for system
-- ----------------------------
DROP TABLE IF EXISTS `system`;
CREATE TABLE `system`  (
  `itemID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `type` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `value` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`itemID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ;

-- ----------------------------
-- Records of system
-- ----------------------------
INSERT INTO `system` VALUES (1, 'item.PWSetting', 'item.PWExpire', '0');
INSERT INTO `system` VALUES (2, 'item.PWSetting', 'item.PWNotify', '0');
INSERT INTO `system` VALUES (3, 'item.PWSetting', 'item.PWHistory', '0');
INSERT INTO `system` VALUES (4, 'item.PWSetting', 'item.PWminlen', '0');
INSERT INTO `system` VALUES (5, 'item.PWSetting', 'item.PWerrcnt', '0');
INSERT INTO `system` VALUES (6, 'item.PWSetting', 'item.PWRule', '1');
INSERT INTO `system` VALUES (7, 'item.PWSetting', 'item.Space', 'Apply');
INSERT INTO `system` VALUES (8, 'item.MailSetting', 'item.MailServer', '');
INSERT INTO `system` VALUES (9, 'item.MailSetting', 'item.MailPort', '25');
INSERT INTO `system` VALUES (10, 'item.MailSetting', 'item.MailUsername', '');
INSERT INTO `system` VALUES (11, 'item.MailSetting', 'item.MailPassword', '');
INSERT INTO `system` VALUES (13, 'item.MailSetting', 'item.MailSender', '');
INSERT INTO `system` VALUES (15, 'item.MailSetting', 'item.MailTest', '');
INSERT INTO `system` VALUES (16, 'item.MailSetting', 'item.Space', 'Apply');
INSERT INTO `system` VALUES (31, 'item.TimeSetting', 'item.NTPServer', '');
INSERT INTO `system` VALUES (32, 'item.TimeSetting', 'item.Space', 'Apply');
INSERT INTO `system` VALUES (33, 'item.SNMPSetting', 'item.SNMPEnable', '0');
INSERT INTO `system` VALUES (34, 'item.SNMPSetting', 'item.SNMPVersion', '2');
INSERT INTO `system` VALUES (35, 'item.SNMPSetting', 'item.SNMPIP', '0.0.0.0');
INSERT INTO `system` VALUES (36, 'item.SNMPSetting', 'item.SNMPPort', '161');
INSERT INTO `system` VALUES (37, 'item.SNMPSetting', 'item.Community', 'public');
INSERT INTO `system` VALUES (38, 'item.SNMPSetting', 'item.TrapIP', '');
INSERT INTO `system` VALUES (39, 'item.SNMPSetting', 'item.TrapPort', '162');
INSERT INTO `system` VALUES (40, 'item.SNMPSetting', 'item.TrapCommunity', 'public');
INSERT INTO `system` VALUES (41, 'item.SNMPSetting', 'item.Space', 'Apply');
INSERT INTO `system` VALUES (51, 'item.SMSSetting', 'item.URL', '');
INSERT INTO `system` VALUES (52, 'item.SMSSetting', 'item.Space', 'Apply');
INSERT INTO `system` VALUES (101, 'item.HASetting', 'item.haEnable', '0');
INSERT INTO `system` VALUES (102, 'item.HASetting', 'item.haStatus', 'OFF');
INSERT INTO `system` VALUES (103, 'item.HASetting', 'item.haInterface', '');
INSERT INTO `system` VALUES (104, 'item.HASetting', 'item.haVirtualID', '');
INSERT INTO `system` VALUES (105, 'item.HASetting', 'item.haPriority', '');
INSERT INTO `system` VALUES (106, 'item.HASetting', 'item.haVIP', '');
INSERT INTO `system` VALUES (107, 'item.HASetting', 'item.haSendMail', '0');
INSERT INTO `system` VALUES (108, 'item.HASetting', 'item.haMailAddress', '');
INSERT INTO `system` VALUES (109, 'item.HASetting', 'item.haPreempt', 'OFF');
INSERT INTO `system` VALUES (110, 'item.HASetting', 'item.Space', 'Apply');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `userName` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `phone` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `pwtime` bigint(20) NULL DEFAULT NULL,
  `pwhistory` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `role` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `lang` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `errcnt` smallint(6) NULL DEFAULT NULL,
  `status` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `note` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '',
  `lineID` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `lineToken` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`userName`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('admin', '230c78da07ae7a4cae60c2e3ff35122e', 'jacky.lin@weitech.com.tw', '', 1623199162910, '230c78da07ae7a4cae60c2e3ff35122e', 'Admin', 'cht', 0, 'ON', '', '', '');

-- ----------------------------
-- Table structure for userlog
-- ----------------------------
DROP TABLE IF EXISTS `userlog`;
CREATE TABLE `userlog`  (
  `logID` int(11) NOT NULL AUTO_INCREMENT,
  `userName` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `ip` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `item` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `type` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `result` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `notes` varchar(5000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0',
  `logTime` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `timeInt` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`logID`) USING BTREE,
  INDEX `timeIntKey`(`timeInt`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ;

-- ----------------------------
-- Records of userlog
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;





DROP TABLE IF EXISTS `ingest`;
CREATE TABLE `ingest`  (
  `ingestID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `sourceFolder` varchar(50) DEFAULT NULL,
  `profile` varchar(50) DEFAULT NULL,
  `status` varchar(50) DEFAULT 'Queued',
  `createTime` datetime DEFAULT NULL,
  PRIMARY KEY (`ingestID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `ingestlog`;
CREATE TABLE `ingestlog`  (
  `ingestLogID` int(11) NOT NULL AUTO_INCREMENT,
  `createTime` datetime DEFAULT NULL,
  `endTime` datetime DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `sourceFolder` varchar(50) DEFAULT NULL,
  `profile` varchar(50) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `note` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`ingestLogID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;


-- ??????  ????????? asorigin.profile ??????
DROP TABLE IF EXISTS `profile`;
CREATE TABLE `profile`  (
  `profileID` int(4) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `outputUrl` varchar(50) DEFAULT NULL,
  `profileRule` varchar(50) DEFAULT NULL,
  `transcode` enum('Y','N') DEFAULT NULL,
  PRIMARY KEY (`profileID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `profilerules`;
CREATE TABLE `profilerules`  (
  `profileRulesID` int(4) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `value1` varchar(50) DEFAULT NULL,
  `value2` varchar(50) DEFAULT NULL,
  `value3` varchar(50) DEFAULT NULL,
  `value4` varchar(50) DEFAULT NULL,
  `value5` varchar(50) DEFAULT NULL,
  `value6` varchar(50) DEFAULT NULL,
  `value7` varchar(50) DEFAULT NULL,
  `value8` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`profileRulesID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `vod`;
CREATE TABLE `vod`  (
  `vodID` int(12) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `duration` varchar(50) DEFAULT NULL,
  `size` varchar(50) DEFAULT NULL,
  `profile` varchar(50) DEFAULT NULL,
  `video` varchar(1000) DEFAULT NULL,
  `audio` varchar(1000) DEFAULT NULL,
  `text` varchar(200) DEFAULT NULL,
  `output` varchar(2000) DEFAULT NULL,
  `drmrules` varchar(2000) DEFAULT NULL,
  `sourceFolder` varchar(200) DEFAULT NULL,
  `outputUrl` varchar(200) DEFAULT NULL,
  `transcode` enum('Y','N') DEFAULT NULL,
  PRIMARY KEY (`vodID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `drmrules`;
CREATE TABLE `drmrules`  (
  `drmID` int(4) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `preset` enum('Y','N') DEFAULT NULL,
  `value1` varchar(200) DEFAULT NULL,
  `value2` varchar(200) DEFAULT NULL,
  `value3` varchar(200) DEFAULT NULL,
  `value4` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`drmID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `drmtable`;
CREATE TABLE `drmtable`  (
  `vod` varchar(50) DEFAULT NULL,
  `profileRule` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `preset` enum('Y','N') DEFAULT 'N',
  `value1` varchar(200) DEFAULT NULL,
  `value2` varchar(200) DEFAULT NULL,
  `value3` varchar(200) DEFAULT NULL,
  `value4` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `live`;
CREATE TABLE `live`  (
  `liveID` int(11) NOT NULL AUTO_INCREMENT,
  `streamName` varchar(50) DEFAULT NULL,
  `inputType` varchar(50) DEFAULT NULL,
  `input` varchar(50) DEFAULT NULL,
  `liveWindow` int(4) DEFAULT '60',
  `archiveLifecycle` int(4) DEFAULT '120',
  `profile` varchar(50) DEFAULT NULL,
  `video` varchar(1000) DEFAULT NULL,
  `audio` varchar(1000) DEFAULT NULL,
  `text` varchar(200) DEFAULT NULL,
  `output` varchar(2000) DEFAULT NULL,
  PRIMARY KEY (`liveID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `shaka`;
CREATE TABLE `shaka`  (
  `shakaID` int(11) NOT NULL AUTO_INCREMENT,
  `streamName` varchar(50) DEFAULT NULL,
  `inputType` varchar(50) DEFAULT NULL,
  `input` varchar(500) DEFAULT NULL,
  `liveWindow` int(4) DEFAULT '60',
  `archiveLifecycle` int(4) DEFAULT '120',
  `profile` varchar(50) DEFAULT NULL,
  `video` varchar(1000) DEFAULT NULL,
  `defaultLanguage` varchar(50) DEFAULT NULL,
  `audio` varchar(1000) DEFAULT NULL,
  `text` varchar(200) DEFAULT NULL,
  `output` varchar(2000) DEFAULT NULL,
  `langCode` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`shakaID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

