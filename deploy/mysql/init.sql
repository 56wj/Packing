CREATE DATABASE IF NOT EXISTS db_kindlead
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE db_kindlead;

CREATE TABLE IF NOT EXISTS `department` (
  `department_id` INT NOT NULL AUTO_INCREMENT,
  `department_name` VARCHAR(100) NOT NULL,
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`department_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(64) NOT NULL,
  `password` VARCHAR(64) NOT NULL,
  `email` VARCHAR(128) DEFAULT NULL,
  `phone` VARCHAR(32) DEFAULT NULL,
  `department` VARCHAR(100) DEFAULT NULL,
  `roles` VARCHAR(255) DEFAULT NULL,
  `avatar` VARCHAR(512) DEFAULT NULL,
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `ctask` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `order_id` VARCHAR(128) DEFAULT NULL,
  `source_json` VARCHAR(1024) DEFAULT NULL,
  `type` VARCHAR(64) DEFAULT NULL,
  `state` VARCHAR(64) DEFAULT NULL,
  `create_user` INT DEFAULT NULL,
  `result_json` VARCHAR(1024) DEFAULT NULL,
  `middle_json` VARCHAR(1024) DEFAULT NULL,
  `result_excel` VARCHAR(1024) DEFAULT NULL,
  `tag_middle` INT DEFAULT 0,
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_ctask_create_user` (`create_user`),
  KEY `idx_ctask_type_state` (`type`, `state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `spe_pallet` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `pallet_name` VARCHAR(100) NOT NULL,
  `pallet_length` DOUBLE NOT NULL,
  `pallet_width` DOUBLE NOT NULL,
  `pallet_height` DOUBLE NOT NULL,
  `pallet_weight` DOUBLE NOT NULL,
  `pallet_type` VARCHAR(100) NOT NULL,
  `pallet_remark` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `spe_truck` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `length_m` DOUBLE NOT NULL,
  `width_m` DOUBLE NOT NULL,
  `height_m` DOUBLE NOT NULL,
  `weight_t` DOUBLE NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `spe_roll` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `roll_name` VARCHAR(100) NOT NULL,
  `roll_thickness` DOUBLE NOT NULL,
  `roll_length` DOUBLE NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `spe_pallet_roll_relations` (
  `pallet_id` INT NOT NULL,
  `roll_id` INT NOT NULL,
  `roll_nums` INT NOT NULL,
  PRIMARY KEY (`pallet_id`, `roll_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `spe_tube` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tube_name` VARCHAR(100) NOT NULL,
  `tube_approximate` DOUBLE NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `push_task` (
  `pid` INT NOT NULL AUTO_INCREMENT,
  `order_id` VARCHAR(128) NOT NULL,
  `type` VARCHAR(64) NOT NULL,
  `order_data` TEXT NOT NULL,
  `read_status` INT DEFAULT 0,
  `push_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `department` (`department_id`, `department_name`, `create_time`, `update_time`)
VALUES (1, '默认部门', NOW(), NOW())
ON DUPLICATE KEY UPDATE `department_name` = VALUES(`department_name`);

INSERT INTO `user` (`id`, `username`, `password`, `email`, `phone`, `department`, `roles`, `create_time`, `update_time`)
VALUES (1, 'admin', 'e10adc3949ba59abbe56e057f20f883e', 'admin@example.com', '13800000000', '默认部门', 'admin', NOW(), NOW())
ON DUPLICATE KEY UPDATE `roles` = VALUES(`roles`);

INSERT INTO `spe_pallet` (`id`, `pallet_name`, `pallet_length`, `pallet_width`, `pallet_height`, `pallet_weight`, `pallet_type`, `pallet_remark`)
VALUES (1, '默认托盘', 1200, 1000, 150, 30, '默认', '本地部署初始化数据')
ON DUPLICATE KEY UPDATE `pallet_name` = VALUES(`pallet_name`);

INSERT INTO `spe_truck` (`id`, `name`, `length_m`, `width_m`, `height_m`, `weight_t`)
VALUES (1, '默认货车', 9.6, 2.4, 2.6, 10)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

INSERT INTO `spe_roll` (`id`, `roll_name`, `roll_thickness`, `roll_length`)
VALUES (1, '默认卷膜', 100, 1000)
ON DUPLICATE KEY UPDATE `roll_name` = VALUES(`roll_name`);

INSERT INTO `spe_pallet_roll_relations` (`pallet_id`, `roll_id`, `roll_nums`)
VALUES (1, 1, 1)
ON DUPLICATE KEY UPDATE `roll_nums` = VALUES(`roll_nums`);

INSERT INTO `spe_tube` (`id`, `tube_name`, `tube_approximate`)
VALUES (1, '默认纸筒', 76)
ON DUPLICATE KEY UPDATE `tube_name` = VALUES(`tube_name`);
