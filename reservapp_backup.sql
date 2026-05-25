-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: localhost    Database: reservapp
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ciudades`
--

DROP TABLE IF EXISTS `ciudades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ciudades` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cod_postal` varchar(10) DEFAULT NULL,
  `nombre` varchar(100) NOT NULL,
  `id_provincia` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK6h3l8h0ojmralgau26drq0ar` (`id_provincia`),
  CONSTRAINT `FK6h3l8h0ojmralgau26drq0ar` FOREIGN KEY (`id_provincia`) REFERENCES `provincias` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ciudades`
--

LOCK TABLES `ciudades` WRITE;
/*!40000 ALTER TABLE `ciudades` DISABLE KEYS */;
INSERT INTO `ciudades` VALUES (1,'01001','Vitoria-Gasteiz',1),(2,'02001','Albacete',2),(3,'03001','Alicante',3),(4,'04001','Almera',4),(5,'33001','Oviedo',5),(6,'05001','vila',6),(7,'06001','Badajoz',7),(8,'08001','Barcelona',8),(9,'08911','Badalona',8),(10,'08201','Sabadell',8),(11,'09001','Burgos',9),(12,'10001','Cceres',10),(13,'11001','Cdiz',11),(14,'39001','Santander',12),(15,'12001','Castelln de la Plana',13),(16,'13001','Ciudad Real',14),(17,'14001','Crdoba',15),(18,'16001','Cuenca',16),(19,'17001','Girona',17),(20,'18001','Granada',18),(21,'19001','Guadalajara',19),(22,'20001','San Sebastin',20),(23,'21001','Huelva',21),(24,'22001','Huesca',22),(25,'07001','Palma',23),(26,'23001','Jan',24),(27,'15001','A Corua',25),(28,'26001','Logroo',26),(29,'35001','Las Palmas de Gran Canaria',27),(30,'24001','Len',28),(31,'25001','Lleida',29),(32,'27001','Lugo',30),(33,'28001','Madrid',31),(34,'28801','Alcal de Henares',31),(35,'28901','Getafe',31),(36,'29001','Mlaga',32),(37,'30001','Murcia',33),(38,'31001','Pamplona',34),(39,'32001','Ourense',35),(40,'34001','Palencia',36),(41,'36001','Pontevedra',37),(42,'37001','Salamanca',38),(43,'38001','Santa Cruz de Tenerife',39),(44,'40001','Segovia',40),(45,'41001','Sevilla',41),(46,'42001','Soria',42),(47,'43001','Tarragona',43),(48,'44001','Teruel',44),(49,'45001','Toledo',45),(50,'46001','Valencia',46),(51,'46700','Ganda',46),(52,'46900','Torrent',46),(53,'47001','Valladolid',47),(54,'48001','Bilbao',48),(55,'49001','Zamora',49),(56,'50001','Zaragoza',50);
/*!40000 ALTER TABLE `ciudades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `empleados`
--

DROP TABLE IF EXISTS `empleados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empleados` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `activo` bit(1) NOT NULL,
  `apellidos` varchar(150) DEFAULT NULL,
  `email` varchar(150) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `rol` enum('ADMIN_EMPRESA','BASICO','SUPERVISOR') NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `id_empresa` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK6fdpo2x5rmegfbngre7xb3yoh` (`email`),
  KEY `FK3vpin99i90hobyqowv4pv0cpm` (`id_empresa`),
  CONSTRAINT `FK3vpin99i90hobyqowv4pv0cpm` FOREIGN KEY (`id_empresa`) REFERENCES `empresas` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empleados`
--

LOCK TABLES `empleados` WRITE;
/*!40000 ALTER TABLE `empleados` DISABLE KEYS */;
INSERT INTO `empleados` VALUES (1,_binary '','Martnez Gil','juan.martinez@elclasico.com','Juan','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','ADMIN_EMPRESA','620000001',1),(2,_binary '','Snchez Mora','pedro.sanchez@elclasico.com','Pedro','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','SUPERVISOR','620000002',1),(3,_binary '','Lpez Vidal','antonio.lopez@elclasico.com','Antonio','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','BASICO','620000003',1),(4,_binary '','Rodrguez Cano','jose.rodriguez@elclasico.com','Jos','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','BASICO','620000004',1),(5,_binary '','Garca Blanco','laura.garcia@chicstudio.com','Laura','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','ADMIN_EMPRESA','620000005',2),(6,_binary '','Fernndez Ruiz','carmen.fernandez@chicstudio.com','Carmen','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','SUPERVISOR','620000006',2),(7,_binary '','Daz Moreno','lucia.diaz@chicstudio.com','Luca','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','BASICO','620000007',2),(8,_binary '','Moreno Herrera','rosa.moreno@chicstudio.com','Rosa','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','BASICO','620000008',2),(9,_binary '','Ruiz Jimnez','marcos.ruiz@dentalsonrisa.com','Dr. Marcos','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','ADMIN_EMPRESA','620000009',3),(10,_binary '','Torres Vargas','isabel.torres@dentalsonrisa.com','Dra. Isabel','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','SUPERVISOR','620000010',3),(11,_binary '','Vargas Ortega','elena.vargas@dentalsonrisa.com','Elena','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','BASICO','620000011',3),(12,_binary '','Herrera Castro','ana.herrera@dentalsonrisa.com','Ana','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','BASICO','620000012',3),(13,_binary '','Jimnez Soler','marta.jimenez@dentalsonrisa.com','Marta','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','BASICO','620000013',3),(14,_binary '','Castro Navarro','roberto.castro@fitlife.com','Roberto','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','ADMIN_EMPRESA','620000014',4),(15,_binary '','Morales Reyes','sandra.morales@fitlife.com','Sandra','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','SUPERVISOR','620000015',4),(16,_binary '','Romero Medina','diego.romero@fitlife.com','Diego','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','BASICO','620000016',4),(17,_binary '','Navarro Delgado','fran.navarro@fitlife.com','Fran','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','BASICO','620000017',4),(18,_binary '','Guerrero Santos','silvia.guerrero@relaxbeauty.com','Silvia','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','ADMIN_EMPRESA','620000018',5),(19,_binary '','Molina Ramos','patricia.molina@relaxbeauty.com','Patricia','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','SUPERVISOR','620000019',5),(20,_binary '','Ramos Ortega','natalia.ramos@relaxbeauty.com','Natalia','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','BASICO','620000020',5),(21,_binary '','Ortega Pea','beatriz.ortega@relaxbeauty.com','Beatriz','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','BASICO','620000021',5),(22,_binary '','Santos Lara','cristina.santos@relaxbeauty.com','Cristina','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','BASICO','620000022',5),(23,_binary '','Flores Blanco','manuel.flores@tallerlopez.com','Manuel','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','ADMIN_EMPRESA','620000023',6),(24,_binary '','Delgado Vega','raul.delgado@tallerlopez.com','Ral','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','SUPERVISOR','620000024',6),(25,_binary '','Blanco Fuentes','oscar.blanco@tallerlopez.com','scar','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','BASICO','620000025',6),(26,_binary '','Serrano Prieto','pablo.serrano@fisioterapiasanar.com','Dr. Pablo','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','ADMIN_EMPRESA','620000026',7),(27,_binary '','Vega Moya','claudia.vega@fisioterapiasanar.com','Dra. Claudia','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','SUPERVISOR','620000027',7),(28,_binary '','Reyes Gimnez','alvaro.reyes@fisioterapiasanar.com','lvaro','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','BASICO','620000028',7),(29,_binary '','Medina Esteban','nuria.medina@fisioterapiasanar.com','Nuria','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','BASICO','620000029',7),(30,_binary '','Surez Pons','eva.suarez@mentesana.com','Dra. Eva','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','ADMIN_EMPRESA','620000030',8),(31,_binary '','Iglesias Vera','hugo.iglesias@mentesana.com','Dr. Hugo','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','SUPERVISOR','620000031',8),(32,_binary '','Len Ferrer','sara.leon@mentesana.com','Sara','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','BASICO','620000032',8),(33,_binary '','Cabrera Rico','adriana.cabrera@esteticabella.com','Adriana','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','ADMIN_EMPRESA','620000033',9),(34,_binary '','Mendoza Amparo','vanessa.mendoza@esteticabella.com','Vanessa','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','SUPERVISOR','620000034',9),(35,_binary '','Fuentes Mora','daniela.fuentes@esteticabella.com','Daniela','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','BASICO','620000035',9),(36,_binary '','Corts Soler','marina.cortes@esteticabella.com','Marina','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','BASICO','620000036',9),(37,_binary '','Pea Gil','alicia.pena@esteticabella.com','Alicia','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','BASICO','620000037',9),(38,_binary '','Aguilar Moya','tomas.aguilar@globalidiomas.com','Prof. Toms','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','ADMIN_EMPRESA','620000038',10),(39,_binary '','Castillo Nieto','julia.castillo@globalidiomas.com','Prof. Julia','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','SUPERVISOR','620000039',10),(40,_binary '','Domnguez Rubio','andres.dominguez@globalidiomas.com','Prof. Andrs','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','BASICO','620000040',10),(41,_binary '','Nieto Sanz','victor.nieto@patasycolas.com','Dr. Vctor','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','ADMIN_EMPRESA','620000041',11),(42,_binary '','Pascual Cano','gloria.pascual@patasycolas.com','Dra. Gloria','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','SUPERVISOR','620000042',11),(43,_binary '','Rubio Prieto','irene.rubio@patasycolas.com','Irene','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','BASICO','620000043',11),(44,_binary '','Sanz Vera','hector.sanz@patasycolas.com','Hctor','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','BASICO','620000044',11),(45,_binary '','Lara Fuentes','jorge.lara@visionclara.com','Jorge','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','ADMIN_EMPRESA','620000045',12),(46,_binary '','Prieto Esteban','pilar.prieto@visionclara.com','Pilar','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','SUPERVISOR','620000046',12),(47,_binary '','Gimnez Mora','marcos.gimenez@visionclara.com','Marcos','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','BASICO','620000047',12),(48,_binary '','Esteban Gil','paula.esteban@dieteticaverde.com','Paula','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','ADMIN_EMPRESA','620000048',13),(49,_binary '','Ferrer Blanco','ivan.ferrer@dieteticaverde.com','Ivn','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','SUPERVISOR','620000049',13),(50,_binary '','Mora Santos','raquel.mora@dieteticaverde.com','Raquel','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','BASICO','620000050',13),(51,_binary '','Varela Pons','luis.varela@abogadosgarcia.com','Luis','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','ADMIN_EMPRESA','620000051',14),(52,_binary '','Pons Rico','monica.pons@abogadosgarcia.com','Mnica','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','SUPERVISOR','620000052',14),(53,_binary '','Rico Navarro','amparo.rico@abogadosgarcia.com','Amparo','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','BASICO','620000053',14),(54,_binary '','Soler Vidal','rebeca.soler@estudiomomento.com','Rebeca','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','ADMIN_EMPRESA','620000054',15),(55,_binary '','Moya Castillo','gonzalo.moya@estudiomomento.com','Gonzalo','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','SUPERVISOR','620000055',15),(56,_binary '','Vera Aguilar','ignacio.vera@estudiomomento.com','Ignacio','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','BASICO','620000056',15),(57,_binary '','Gil Domnguez','tamara.gil@estudiomomento.com','Tamara','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','BASICO','620000057',15);
/*!40000 ALTER TABLE `empleados` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `empresa_imagenes`
--

DROP TABLE IF EXISTS `empresa_imagenes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empresa_imagenes` (
  `id_empresa` bigint NOT NULL,
  `url` varchar(255) DEFAULT NULL,
  KEY `FKchxyqc74hvj6uoo30l3yn2w7h` (`id_empresa`),
  CONSTRAINT `FKchxyqc74hvj6uoo30l3yn2w7h` FOREIGN KEY (`id_empresa`) REFERENCES `empresas` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empresa_imagenes`
--

LOCK TABLES `empresa_imagenes` WRITE;
/*!40000 ALTER TABLE `empresa_imagenes` DISABLE KEYS */;
/*!40000 ALTER TABLE `empresa_imagenes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `empresas`
--

DROP TABLE IF EXISTS `empresas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empresas` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `descripcion` text,
  `direccion` varchar(255) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `logo_url` varchar(255) DEFAULT NULL,
  `nombre` varchar(150) NOT NULL,
  `sector` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `id_ciudad` bigint NOT NULL,
  `id_usuario` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKsut5m9tl4o2cd7uesqktvtu6v` (`id_ciudad`),
  KEY `FK3nl7avihb97w9y2gjeudmtdw9` (`id_usuario`),
  CONSTRAINT `FK3nl7avihb97w9y2gjeudmtdw9` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `FKsut5m9tl4o2cd7uesqktvtu6v` FOREIGN KEY (`id_ciudad`) REFERENCES `ciudades` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empresas`
--

LOCK TABLES `empresas` WRITE;
/*!40000 ALTER TABLE `empresas` DISABLE KEYS */;
INSERT INTO `empresas` VALUES (1,'Barbera de estilo tradicional con los mejores maestros del oficio','Calle Mayor 10','info@elclasico.com',NULL,'Barbera El Clsico','Peluquera','910000001',33,1),(2,'Centro de belleza capilar femenino de alta gama en el corazn de Barcelona','Passeig de Grcia 45','info@chicstudio.com',NULL,'Peluquera Chic Studio','Peluquera','930000001',8,1),(3,'Clnica dental con tratamientos para toda la familia en un ambiente cercano','Avenida del Puerto 12','info@dentalsonrisa.com',NULL,'Clnica Dental Sonrisa','Salud','960000001',50,1),(4,'Gimnasio moderno con equipamiento de ltima generacin y clases dirigidas','Calle Alcal 150','info@fitlife.com',NULL,'Gimnasio FitLife','Deporte','910000002',33,2),(5,'Spa y centro de bienestar en el corazn de Sevilla con circuito de aguas','Avenida de la Constitucin 5','info@relaxbeauty.com',NULL,'Spa Relax & Beauty','Bienestar','954000001',45,2),(6,'Taller de automviles multimarca con ms de 20 aos de experiencia en Bilbao','Calle Autonoma 88','info@tallerlopez.com',NULL,'Taller Mecnico Lpez','Automocin','944000001',54,3),(7,'Centro especializado en fisioterapia manual y rehabilitacin deportiva','Paseo de la Independencia 22','info@fisioterapiasanar.com',NULL,'Centro Fisioterapia Sanar','Salud','976000001',56,3),(8,'Psicologa clnica y terapia cognitivo-conductual para adultos y parejas','Calle Serrano 80','info@mentesana.com',NULL,'Centro Psicologa Mente Sana','Salud','910000003',33,4),(9,'Centro de esttica integral: depilacin lser, manicura, faciales y ms','Passeig de Grcia 120','info@esteticabella.com',NULL,'Centro Esttica Bella','Esttica','930000002',8,5),(10,'Academia con profesores nativos de ingls y francs para todos los niveles','Avenida del Reino de Valencia 55','info@globalidiomas.com',NULL,'Academia Idiomas Global','Educacin','960000002',50,6),(11,'Clnica veterinaria con servicio de urgencias 24h y consultas especializadas','Calle Bravo Murillo 60','info@patasycolas.com',NULL,'Veterinaria Patas & Colas','Veterinaria','910000004',33,7),(12,'Centro ptico con las ltimas tecnologas en revisin visual y adaptacin de lentillas','Calle Larios 15','info@visionclara.com',NULL,'ptica Visin Clara','Salud','952000001',36,7),(13,'Consulta de nutricin y diettica con planes 100% personalizados','Avenida de la Palmera 33','info@dieteticaverde.com',NULL,'Nutricionista & Diettica Verde','Salud','954000002',45,8),(14,'Despacho especializado en derecho laboral, familiar y civil en Madrid','Calle Velzquez 25','info@abogadosgarcia.com',NULL,'Bufete Abogados Garca','Legal','910000005',33,9),(15,'Fotografa profesional para eventos, bodas, bebs y retratos familiares','Carrer del Consell de Cent 300','info@estudiomomento.com',NULL,'Estudio Fotogrfico Momento','Fotografa','930000003',8,10);
/*!40000 ALTER TABLE `empresas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `horarios`
--

DROP TABLE IF EXISTS `horarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `horarios` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `apertura` time(6) NOT NULL,
  `cierre` time(6) NOT NULL,
  `dia` enum('DOMINGO','JUEVES','LUNES','MARTES','MIERCOLES','SABADO','VIERNES') NOT NULL,
  `id_empresa` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKhijbun011f892qrtaolgy9uhd` (`id_empresa`),
  CONSTRAINT `FKhijbun011f892qrtaolgy9uhd` FOREIGN KEY (`id_empresa`) REFERENCES `empresas` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horarios`
--

LOCK TABLES `horarios` WRITE;
/*!40000 ALTER TABLE `horarios` DISABLE KEYS */;
INSERT INTO `horarios` VALUES (1,'09:00:00.000000','20:00:00.000000','LUNES',1),(2,'09:00:00.000000','20:00:00.000000','MARTES',1),(3,'09:00:00.000000','20:00:00.000000','MIERCOLES',1),(4,'09:00:00.000000','20:00:00.000000','JUEVES',1),(5,'09:00:00.000000','20:00:00.000000','VIERNES',1),(6,'09:00:00.000000','15:00:00.000000','SABADO',1),(7,'10:00:00.000000','14:00:00.000000','DOMINGO',1),(8,'09:30:00.000000','19:30:00.000000','LUNES',2),(9,'09:30:00.000000','19:30:00.000000','MARTES',2),(10,'09:30:00.000000','19:30:00.000000','MIERCOLES',2),(11,'09:30:00.000000','19:30:00.000000','JUEVES',2),(12,'09:30:00.000000','19:30:00.000000','VIERNES',2),(13,'09:30:00.000000','19:30:00.000000','SABADO',2),(14,'10:00:00.000000','14:00:00.000000','DOMINGO',2),(15,'09:00:00.000000','20:00:00.000000','LUNES',3),(16,'09:00:00.000000','20:00:00.000000','MARTES',3),(17,'09:00:00.000000','20:00:00.000000','MIERCOLES',3),(18,'09:00:00.000000','20:00:00.000000','JUEVES',3),(19,'09:00:00.000000','20:00:00.000000','VIERNES',3),(20,'09:00:00.000000','14:00:00.000000','SABADO',3),(21,'10:00:00.000000','13:00:00.000000','DOMINGO',3),(22,'07:00:00.000000','22:00:00.000000','LUNES',4),(23,'07:00:00.000000','22:00:00.000000','MARTES',4),(24,'07:00:00.000000','22:00:00.000000','MIERCOLES',4),(25,'07:00:00.000000','22:00:00.000000','JUEVES',4),(26,'07:00:00.000000','22:00:00.000000','VIERNES',4),(27,'08:00:00.000000','20:00:00.000000','SABADO',4),(28,'09:00:00.000000','15:00:00.000000','DOMINGO',4),(29,'10:00:00.000000','20:00:00.000000','LUNES',5),(30,'10:00:00.000000','20:00:00.000000','MARTES',5),(31,'10:00:00.000000','20:00:00.000000','MIERCOLES',5),(32,'10:00:00.000000','20:00:00.000000','JUEVES',5),(33,'10:00:00.000000','21:00:00.000000','VIERNES',5),(34,'10:00:00.000000','21:00:00.000000','SABADO',5),(35,'10:00:00.000000','18:00:00.000000','DOMINGO',5),(36,'08:00:00.000000','18:00:00.000000','LUNES',6),(37,'08:00:00.000000','18:00:00.000000','MARTES',6),(38,'08:00:00.000000','18:00:00.000000','MIERCOLES',6),(39,'08:00:00.000000','18:00:00.000000','JUEVES',6),(40,'08:00:00.000000','18:00:00.000000','VIERNES',6),(41,'09:00:00.000000','14:00:00.000000','SABADO',6),(42,'10:00:00.000000','13:00:00.000000','DOMINGO',6),(43,'09:00:00.000000','20:00:00.000000','LUNES',7),(44,'09:00:00.000000','20:00:00.000000','MARTES',7),(45,'09:00:00.000000','20:00:00.000000','MIERCOLES',7),(46,'09:00:00.000000','20:00:00.000000','JUEVES',7),(47,'09:00:00.000000','20:00:00.000000','VIERNES',7),(48,'09:00:00.000000','14:00:00.000000','SABADO',7),(49,'10:00:00.000000','13:00:00.000000','DOMINGO',7),(50,'09:00:00.000000','21:00:00.000000','LUNES',8),(51,'09:00:00.000000','21:00:00.000000','MARTES',8),(52,'09:00:00.000000','21:00:00.000000','MIERCOLES',8),(53,'09:00:00.000000','21:00:00.000000','JUEVES',8),(54,'09:00:00.000000','20:00:00.000000','VIERNES',8),(55,'10:00:00.000000','14:00:00.000000','SABADO',8),(56,'10:00:00.000000','14:00:00.000000','DOMINGO',8),(57,'10:00:00.000000','20:00:00.000000','LUNES',9),(58,'10:00:00.000000','20:00:00.000000','MARTES',9),(59,'10:00:00.000000','20:00:00.000000','MIERCOLES',9),(60,'10:00:00.000000','20:00:00.000000','JUEVES',9),(61,'10:00:00.000000','20:00:00.000000','VIERNES',9),(62,'10:00:00.000000','20:00:00.000000','SABADO',9),(63,'10:00:00.000000','14:00:00.000000','DOMINGO',9),(64,'08:00:00.000000','21:00:00.000000','LUNES',10),(65,'08:00:00.000000','21:00:00.000000','MARTES',10),(66,'08:00:00.000000','21:00:00.000000','MIERCOLES',10),(67,'08:00:00.000000','21:00:00.000000','JUEVES',10),(68,'08:00:00.000000','21:00:00.000000','VIERNES',10),(69,'09:00:00.000000','14:00:00.000000','SABADO',10),(70,'10:00:00.000000','14:00:00.000000','DOMINGO',10),(71,'09:00:00.000000','20:00:00.000000','LUNES',11),(72,'09:00:00.000000','20:00:00.000000','MARTES',11),(73,'09:00:00.000000','20:00:00.000000','MIERCOLES',11),(74,'09:00:00.000000','20:00:00.000000','JUEVES',11),(75,'09:00:00.000000','20:00:00.000000','VIERNES',11),(76,'09:00:00.000000','14:00:00.000000','SABADO',11),(77,'10:00:00.000000','13:00:00.000000','DOMINGO',11),(78,'10:00:00.000000','20:00:00.000000','LUNES',12),(79,'10:00:00.000000','20:00:00.000000','MARTES',12),(80,'10:00:00.000000','20:00:00.000000','MIERCOLES',12),(81,'10:00:00.000000','20:00:00.000000','JUEVES',12),(82,'10:00:00.000000','20:00:00.000000','VIERNES',12),(83,'10:00:00.000000','20:00:00.000000','SABADO',12),(84,'10:00:00.000000','14:00:00.000000','DOMINGO',12),(85,'09:00:00.000000','19:00:00.000000','LUNES',13),(86,'09:00:00.000000','19:00:00.000000','MARTES',13),(87,'09:00:00.000000','19:00:00.000000','MIERCOLES',13),(88,'09:00:00.000000','19:00:00.000000','JUEVES',13),(89,'09:00:00.000000','19:00:00.000000','VIERNES',13),(90,'10:00:00.000000','14:00:00.000000','SABADO',13),(91,'10:00:00.000000','13:00:00.000000','DOMINGO',13),(92,'09:00:00.000000','19:00:00.000000','LUNES',14),(93,'09:00:00.000000','19:00:00.000000','MARTES',14),(94,'09:00:00.000000','19:00:00.000000','MIERCOLES',14),(95,'09:00:00.000000','19:00:00.000000','JUEVES',14),(96,'09:00:00.000000','19:00:00.000000','VIERNES',14),(97,'10:00:00.000000','14:00:00.000000','SABADO',14),(98,'10:00:00.000000','13:00:00.000000','DOMINGO',14),(99,'10:00:00.000000','20:00:00.000000','LUNES',15),(100,'10:00:00.000000','20:00:00.000000','MARTES',15),(101,'10:00:00.000000','20:00:00.000000','MIERCOLES',15),(102,'10:00:00.000000','20:00:00.000000','JUEVES',15),(103,'10:00:00.000000','20:00:00.000000','VIERNES',15),(104,'10:00:00.000000','20:00:00.000000','SABADO',15),(105,'10:00:00.000000','15:00:00.000000','DOMINGO',15);
/*!40000 ALTER TABLE `horarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `provincias`
--

DROP TABLE IF EXISTS `provincias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `provincias` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `provincias`
--

LOCK TABLES `provincias` WRITE;
/*!40000 ALTER TABLE `provincias` DISABLE KEYS */;
INSERT INTO `provincias` VALUES (1,'lava'),(2,'Albacete'),(3,'Alicante'),(4,'Almera'),(5,'Asturias'),(6,'vila'),(7,'Badajoz'),(8,'Barcelona'),(9,'Burgos'),(10,'Cceres'),(11,'Cdiz'),(12,'Cantabria'),(13,'Castelln'),(14,'Ciudad Real'),(15,'Crdoba'),(16,'Cuenca'),(17,'Girona'),(18,'Granada'),(19,'Guadalajara'),(20,'Guipzcoa'),(21,'Huelva'),(22,'Huesca'),(23,'Islas Baleares'),(24,'Jan'),(25,'La Corua'),(26,'La Rioja'),(27,'Las Palmas'),(28,'Len'),(29,'Lleida'),(30,'Lugo'),(31,'Madrid'),(32,'Mlaga'),(33,'Murcia'),(34,'Navarra'),(35,'Ourense'),(36,'Palencia'),(37,'Pontevedra'),(38,'Salamanca'),(39,'Santa Cruz de Tenerife'),(40,'Segovia'),(41,'Sevilla'),(42,'Soria'),(43,'Tarragona'),(44,'Teruel'),(45,'Toledo'),(46,'Valencia'),(47,'Valladolid'),(48,'Vizcaya'),(49,'Zamora'),(50,'Zaragoza');
/*!40000 ALTER TABLE `provincias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reserva_empleados`
--

DROP TABLE IF EXISTS `reserva_empleados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reserva_empleados` (
  `id_reserva` bigint NOT NULL,
  `id_empleado` bigint NOT NULL,
  KEY `FK6ara6ridfugh3g5imppa64x14` (`id_empleado`),
  KEY `FKetl4n8h1huo5y1r0vjau4bw1x` (`id_reserva`),
  CONSTRAINT `FK6ara6ridfugh3g5imppa64x14` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id`),
  CONSTRAINT `FKetl4n8h1huo5y1r0vjau4bw1x` FOREIGN KEY (`id_reserva`) REFERENCES `reservas` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reserva_empleados`
--

LOCK TABLES `reserva_empleados` WRITE;
/*!40000 ALTER TABLE `reserva_empleados` DISABLE KEYS */;
INSERT INTO `reserva_empleados` VALUES (1,3),(2,7),(3,11),(4,16),(5,32),(6,28),(7,20),(8,35),(9,4),(10,12),(11,17),(12,21),(13,25),(14,40),(15,43),(16,3),(16,4),(17,9),(18,22),(19,29),(20,36),(21,49),(22,3),(23,20),(23,21),(24,52),(25,6),(26,37),(27,55),(28,16),(29,47),(30,13),(31,34),(32,31),(33,50),(34,7),(34,8),(35,44);
/*!40000 ALTER TABLE `reserva_empleados` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservas`
--

DROP TABLE IF EXISTS `reservas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservas` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `estado` enum('CANCELADA','CONFIRMADA','FINALIZADA','PENDIENTE') NOT NULL,
  `fecha` date NOT NULL,
  `hora_fin` time(6) NOT NULL,
  `hora_inicio` time(6) NOT NULL,
  `id_servicio` bigint NOT NULL,
  `id_usuario` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK2owpd8tl1b57k4cmqhuttlu2e` (`id_servicio`),
  KEY `FKhjryje6u1cr0d4dubad1jja6` (`id_usuario`),
  CONSTRAINT `FK2owpd8tl1b57k4cmqhuttlu2e` FOREIGN KEY (`id_servicio`) REFERENCES `servicios` (`id`),
  CONSTRAINT `FKhjryje6u1cr0d4dubad1jja6` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservas`
--

LOCK TABLES `reservas` WRITE;
/*!40000 ALTER TABLE `reservas` DISABLE KEYS */;
INSERT INTO `reservas` VALUES (1,'FINALIZADA','2026-03-10','10:30:00.000000','10:00:00.000000',1,11),(2,'FINALIZADA','2026-03-15','11:45:00.000000','11:00:00.000000',5,11),(3,'FINALIZADA','2026-04-02','11:00:00.000000','10:00:00.000000',9,11),(4,'FINALIZADA','2026-04-20','10:00:00.000000','09:00:00.000000',14,11),(5,'CANCELADA','2026-05-10','18:00:00.000000','17:00:00.000000',30,11),(6,'FINALIZADA','2026-05-20','09:45:00.000000','09:00:00.000000',26,11),(7,'PENDIENTE','2026-05-30','13:00:00.000000','12:00:00.000000',18,11),(8,'PENDIENTE','2026-06-05','12:00:00.000000','11:00:00.000000',33,11),(9,'FINALIZADA','2026-02-20','11:20:00.000000','11:00:00.000000',2,12),(10,'FINALIZADA','2026-03-05','10:45:00.000000','10:00:00.000000',10,12),(11,'FINALIZADA','2026-04-10','10:00:00.000000','09:00:00.000000',15,12),(12,'FINALIZADA','2026-05-01','16:00:00.000000','15:00:00.000000',19,12),(13,'FINALIZADA','2026-05-20','11:00:00.000000','10:00:00.000000',23,12),(14,'CONFIRMADA','2026-06-01','11:00:00.000000','10:00:00.000000',38,12),(15,'PENDIENTE','2026-06-10','11:20:00.000000','11:00:00.000000',41,12),(16,'FINALIZADA','2026-01-15','10:45:00.000000','10:00:00.000000',3,13),(17,'FINALIZADA','2026-02-28','12:30:00.000000','11:00:00.000000',12,13),(18,'FINALIZADA','2026-04-15','15:15:00.000000','14:00:00.000000',20,13),(19,'CANCELADA','2026-05-05','09:30:00.000000','09:00:00.000000',27,13),(20,'PENDIENTE','2026-05-25','12:45:00.000000','12:00:00.000000',34,13),(21,'CONFIRMADA','2026-06-03','11:00:00.000000','10:00:00.000000',48,13),(22,'FINALIZADA','2026-04-01','09:30:00.000000','09:00:00.000000',4,14),(23,'FINALIZADA','2026-05-15','15:00:00.000000','13:00:00.000000',22,14),(24,'PENDIENTE','2026-06-15','11:00:00.000000','10:00:00.000000',51,14),(25,'FINALIZADA','2026-04-05','11:30:00.000000','10:00:00.000000',6,15),(26,'FINALIZADA','2026-05-20','11:45:00.000000','11:00:00.000000',35,15),(27,'CONFIRMADA','2026-06-20','11:00:00.000000','10:00:00.000000',54,15),(28,'CANCELADA','2026-05-10','08:45:00.000000','08:00:00.000000',16,16),(29,'PENDIENTE','2026-06-02','10:30:00.000000','10:00:00.000000',45,16),(30,'FINALIZADA','2026-04-20','10:30:00.000000','10:00:00.000000',11,17),(31,'PENDIENTE','2026-06-08','13:00:00.000000','12:00:00.000000',36,17),(32,'CONFIRMADA','2026-05-12','17:30:00.000000','16:00:00.000000',31,18),(33,'PENDIENTE','2026-06-10','11:30:00.000000','11:00:00.000000',49,18),(34,'FINALIZADA','2026-05-18','12:00:00.000000','10:00:00.000000',7,19),(35,'CONFIRMADA','2026-06-12','10:15:00.000000','10:00:00.000000',42,20);
/*!40000 ALTER TABLE `reservas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `servicios`
--

DROP TABLE IF EXISTS `servicios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `servicios` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `capacidad` int NOT NULL DEFAULT '1',
  `descripcion` text,
  `duracion` int NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `id_empresa` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKqxr74kjhxpagsm3e52d0k2h48` (`id_empresa`),
  CONSTRAINT `FKqxr74kjhxpagsm3e52d0k2h48` FOREIGN KEY (`id_empresa`) REFERENCES `empresas` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servicios`
--

LOCK TABLES `servicios` WRITE;
/*!40000 ALTER TABLE `servicios` DISABLE KEYS */;
INSERT INTO `servicios` VALUES (1,1,'Corte clsico con acabado a mquina o tijera',30,'Corte caballero',15.00,1),(2,1,'Afeitado tradicional con navaja y toalla caliente',20,'Afeitado clsico',10.00,1),(3,1,'Servicio completo de corte de pelo y arreglo de barba',45,'Corte + barba',22.00,1),(4,1,'Tinte y perfilado de barba con productos naturales',30,'Tinte de barba',12.00,1),(5,1,'Corte femenino personalizado segn tipo de cabello',45,'Corte mujer',25.00,2),(6,1,'Coloracin completa con productos de alta calidad',90,'Tinte completo',55.00,2),(7,1,'Mechas californianas con tcnica balayage',120,'Mechas californianas',75.00,2),(8,1,'Recogido o peinado para bodas y eventos especiales',60,'Peinado para evento',40.00,2),(9,1,'Limpieza bucal completa con ultrasonidos y fluorizacin',60,'Limpieza dental',50.00,3),(10,1,'Empaste de una pieza dental con composite de ltima generacin',45,'Empaste',80.00,3),(11,1,'Revisin y ajuste de aparato de ortodoncia',30,'Revisin ortodoncia',40.00,3),(12,1,'Blanqueamiento profesional en consulta con luz LED',90,'Blanqueamiento dental',150.00,3),(13,1,'Extraccin simple o compleja bajo anestesia local',30,'Extraccin dental',60.00,3),(14,1,'Sesin de entrenamiento 100% personalizado 1 a 1',60,'Personal trainer',35.00,4),(15,15,'Clase colectiva de yoga para todos los niveles',60,'Clase de yoga',15.00,4),(16,20,'Clase de ciclo indoor de alta intensidad',45,'Clase de spinning',12.00,4),(17,1,'Evaluacin inicial y diseo de plan de entrenamiento',60,'Evaluacin fsica',25.00,4),(18,1,'Masaje de cuerpo completo con aceites esenciales',60,'Masaje relajante',45.00,5),(19,1,'Masaje especfico para deportistas con tcnica de tejido profundo',60,'Masaje deportivo',50.00,5),(20,1,'Tratamiento facial hidratante y antienvejecimiento',75,'Tratamiento facial',65.00,5),(21,1,'Tratamiento de envoltura con barro y algas marinas',90,'Envoltura corporal',70.00,5),(22,4,'Acceso completo al circuito de aguas y zona de relajacin',120,'Circuito spa',85.00,5),(23,1,'Revisin completa de 30 puntos del vehculo',60,'Revisin general',40.00,6),(24,1,'Cambio de aceite y filtro con aceite de calidad premium',30,'Cambio de aceite',25.00,6),(25,1,'Alineacin y equilibrado de ruedas',45,'Alineacin direccin',35.00,6),(26,1,'Sesin de fisioterapia manual y terapia miofascial',45,'Sesin fisioterapia',40.00,7),(27,1,'Masaje teraputico para contracturas y dolor muscular',30,'Masaje teraputico',30.00,7),(28,1,'Sesin de electroterapia con ultrasonidos y TENS',30,'Electroterapia',25.00,7),(29,1,'Rehabilitacin especfica para lesiones deportivas',60,'Rehabilitacin dep.',50.00,7),(30,1,'Sesin de terapia psicolgica cognitivo-conductual individual',60,'Terapia individual',60.00,8),(31,2,'Sesin de terapia orientada a la dinmica y comunicacin en pareja',90,'Terapia de pareja',80.00,8),(32,1,'Evaluacin psicolgica inicial sin compromiso',60,'Primera consulta',40.00,8),(33,1,'Sesin de depilacin lser en piernas completas',60,'Depilacin lser',80.00,9),(34,1,'Manicura con esmaltado semipermanente y cuidado de cutculas',45,'Manicura completa',20.00,9),(35,1,'Pedicura con esmaltado semipermanente y exfoliacin',45,'Pedicura completa',20.00,9),(36,1,'Tratamiento facial hidratante con mascarilla y srum',60,'Facial hidratante',45.00,9),(37,1,'Depilacin y perfilado de cejas con hilo y pinza',15,'Depilacin cejas',8.00,9),(38,1,'Clase de ingls particular con profesor nativo',60,'Ingls individual',25.00,10),(39,6,'Clase de ingls en grupos reducidos de mximo 6 alumnos',60,'Ingls en grupo',15.00,10),(40,1,'Clase de francs particular con profesor nativo',60,'Francs individual',25.00,10),(41,1,'Revisin veterinaria general de tu mascota',20,'Consulta general vet.',30.00,11),(42,1,'Vacunacin anual con actualizacin de cartilla sanitaria',15,'Vacunacin',20.00,11),(43,1,'Revisin dental veterinaria con limpieza ultrasnica',30,'Revisin dental vet.',45.00,11),(44,1,'Intervencin quirrgica menor con anestesia local',60,'Ciruga menor vet.',120.00,11),(45,1,'Revisin completa de la vista y determinacin de graduacin',30,'Revisin visual',20.00,12),(46,1,'Adaptacin y perodo de prueba de lentes de contacto',30,'Adaptacin lentillas',25.00,12),(47,1,'Exploracin del fondo de ojo con retingrafo de ltima generacin',30,'Fondo de ojo',35.00,12),(48,1,'Evaluacin nutricional completa, anamnesis y objetivos',60,'1 Consulta nutricin',50.00,13),(49,1,'Sesin de control y ajuste del plan diettico mensual',30,'Seguimiento mensual',30.00,13),(50,1,'Elaboracin de plan diettico 100% personalizado con recetas',45,'Plan dieta personal.',40.00,13),(51,1,'Consulta inicial de asesora legal general',60,'Consulta legal',80.00,14),(52,1,'Asesoramiento en derecho laboral: despidos, ERTEs y contratos',60,'Asesora laboral',90.00,14),(53,1,'Consulta en derecho de familia: divorcios, custodias y herencias',60,'Consulta familiar',80.00,14),(54,1,'Sesin fotogrfica de retrato individual o familiar en estudio',60,'Sesin de retrato',80.00,15),(55,1,'Sesin fotogrfica newborn o de primeros meses del beb',90,'Sesin beb',120.00,15),(56,1,'Reportaje fotogrfico completo del da de la boda',240,'Reportaje de boda',500.00,15),(57,1,'Edicin y retoque profesional de tu sesin o reportaje',120,'Edicin fotogrfica',60.00,15);
/*!40000 ALTER TABLE `servicios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `apellidos` varchar(150) DEFAULT NULL,
  `email` varchar(150) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `rol` enum('ADMIN','CLIENTE','EMPRESA') NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKkfsp0s1tflm1cwlj8idhqsad0` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'Garca Lpez','carlos.garcia@reservapp.com','Carlos','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','EMPRESA','600000001'),(2,'Martnez Ruiz','ana.martinez@reservapp.com','Ana','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','EMPRESA','600000002'),(3,'Lpez Fernndez','miguel.lopez@reservapp.com','Miguel','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','EMPRESA','600000003'),(4,'Snchez Daz','laura.sanchez@reservapp.com','Laura','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','EMPRESA','600000004'),(5,'Romero Torres','pedro.romero@reservapp.com','Pedro','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','EMPRESA','600000005'),(6,'Navarro Castro','isabel.navarro@reservapp.com','Isabel','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','EMPRESA','600000006'),(7,'Moreno Vega','roberto.moreno@reservapp.com','Roberto','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','EMPRESA','600000007'),(8,'Jimnez Ramos','silvia.jimenez@reservapp.com','Silvia','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','EMPRESA','600000008'),(9,'Vargas Ortega','diego.vargas@reservapp.com','Diego','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','EMPRESA','600000009'),(10,'Flores Medina','patricia.flores@reservapp.com','Patricia','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','EMPRESA','600000010'),(11,'Herrera Blanco','javier.herrera@email.com','Javier','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','CLIENTE','611000001'),(12,'Delgado Santos','maria.delgado@email.com','Mara','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','CLIENTE','611000002'),(13,'Ruiz Guerrero','alejandro.ruiz@email.com','Alejandro','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','CLIENTE','611000003'),(14,'Serrano Iglesias','carmen.serrano@email.com','Carmen','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','CLIENTE','611000004'),(15,'Molina Cabrera','fernando.molina@email.com','Fernando','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','CLIENTE','611000005'),(16,'Reyes Fuentes','elena.reyes@email.com','Elena','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','CLIENTE','611000006'),(17,'Cruz Pea','andres.cruz@email.com','Andrs','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','CLIENTE','611000007'),(18,'Aguilar Corts','natalia.aguilar@email.com','Natalia','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','CLIENTE','611000008'),(19,'Domnguez Nieto','raul.dominguez@email.com','Ral','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','CLIENTE','611000009'),(20,'Cano Rubio','beatriz.cano@email.com','Beatriz','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','CLIENTE','611000010');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-25  8:37:05
