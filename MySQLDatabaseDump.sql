CREATE DATABASE  IF NOT EXISTS `blog` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */;
USE `blog`;
-- MySQL dump 10.13  Distrib 8.0.13, for Win64 (x86_64)
--
-- Host: localhost    Database: blog
-- ------------------------------------------------------
-- Server version	8.0.13

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `article`
--

DROP TABLE IF EXISTS `article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `article` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `TEXT` longtext NOT NULL,
  `INSERT_DATE` datetime NOT NULL,
  `TITLE` varchar(255) NOT NULL,
  `AUTHOR` varchar(45) NOT NULL,
  `ACTIVE` int(1) NOT NULL DEFAULT '0',
  `ID_GUID` varchar(32) DEFAULT NULL,
  `UPDATE_DATE` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article`
--

LOCK TABLES `article` WRITE;
/*!40000 ALTER TABLE `article` DISABLE KEYS */;
INSERT INTO `article` VALUES (1,'ProjectBase (PB) kütüphanesi veri erişim mantalitesi olarak ORM (Object Relational Mapping) ile provider seviyesi arasında bir konumda bulunmaktadır. PB dış bir veri erişim yapısı ile beraber kullanılmak istendiğinde ortak transaction kullanım gerekliliği doğabilmektedir. Örneğin ORM olarak Entity Framework 6 (EF) kullanıyoruz ve bazı işlemleri EF ile bazılarını PB ile yapacağız fakat bu işlemlerin aynı transaction üzerinde yapılması gerekmekte. Bu durumda EF üzerinde aşağıdaki kod ile bir transaction başlatabiliriz:<br />\n<br />\n<pre>DataBaseContext context = new DataBaseContext();\nDbTransaction transaction =  context.Database.BeginTransaction().UnderlyingTransaction\n</pre>\n<br />\nBurada elde ettiğimiz transaction nesnesi veri tabanı bağlantısı açık ve işlem yapmaya hazır olan bir nesnedir. Bu işlemden sonra bu transaction nesnesi PB de kullanabiliriz:<br />\n<br />\n<pre>IDatabase2 db = DatabaseFactory.GetDbObject(DbSettings.TransactionMode);\ndb.UseExternalTransaction(transaction);\n</pre>\n<br />\nBuradan sonra PB ile yaptığımız işlemler EF ile oluşturduğumuz transaction üzerinden yapılacaktır. Normal EF kullanımından farklı olarak EF 6\'da transaction bu yazıda bahsettiğimz yöntemle başlatıldığında Commit edilmesi gerekmektedir:<br />\n<br />\n<pre>context.Save();\ncontext.Database.CurrentTransaction.Commit();\n</pre>\n<br />\nBu işlem sırasında aşağıdaki hususlara dikkat edilmesi gerekir:<br />\n<br />\n1. Dışarıda oluşturulan transaction geçerli bir durumda olmalı ve veri tabanı bağlantısı açık olmalıdır.<br />\n2. PB ile Commit veya RollBack yapıldığında PB sıralı yeni işlemleri yeni transaction kullanarak yapacaktır. Yani mevcut transaction geçerliliğini yitirecektir.<br />\n3. Bu işlem yapılırken PB transaction modda çalışır durumda olmalıdır.','2018-08-13 00:00:00','ProjectBase ile Transaction Üzerinden Dış Veri Erişim Yapıları ile Entegrasyon (Entity Framework 6 Örneği)','vyigity',1,NULL,NULL),(2,'<p>PB v4.0.0-beta ile veri tabanı işlemlerinin asenkron olarak yapılabilmesi amacıyla PB i&ccedil;ine asenkron mimari eklendi. Asenkron programlama (AP) .NET 4.5 ile ortaya &ccedil;ıktığı i&ccedil;in PB&#39;nin kullanılması i&ccedil;in minumum .NET 4.5 kullanılması gerekmektedir. AP&#39;de yapılacak yan işler ana işten ayrılarak asenkron bir şekilde halledilmekte ve ana işin bu yan işler sebebiyle meşgul edilmesi engellenebilmektedir. AP bir &ccedil;ok ama&ccedil;la kullanılabilmekle beraber Forms uygulamalarında UI (User Interface) thread, yani aray&uuml;z elemanlarını oluşturan thread, genellikle ana thread olmakla beraber tamamlanması uzun işlerde bu thread uzun s&uuml;re meşgul edilirse aray&uuml;z&uuml;n cevap vermemesine neden olmaktadır. Ayrıca form yapısında bir aray&uuml;z elemanını oluşturan thread&#39;den başka bir thread bu elemana ulaşmaya kalkıştığında &ouml;n tanımlı (default) olarak uygulama hata verecektir. AP form uygulamalarında kullanıldığında UI thread s&uuml;rekli meşgul edilmediği i&ccedil;in aray&uuml;z s&uuml;rekli aktif kalacaktır.<br />\r\n<br />\r\nAP ayrıca işi birden fazla Thread olarak yaptığı i&ccedil;in bu işlerin işlemcilere dağıtımı kolay olmakta ve işlemci sayısına g&ouml;re hız kazanımı elde edilebilmektedir.<br />\r\n<br />\r\nBu ama&ccedil;la bu yazıda PB v4.0.0-beta kullanan bir &ouml;rnek form uygulaması hazırlandı. Burada PB&#39;nin kodlarını Github &uuml;zerinde indirip ilgili fonksiyonları Thread.Sleep() fonksiyonu kullanıp geciktirerek AP&#39;nin etkisini daha rahat g&ouml;zlemleyebilirsiniz. Oluşturulan forms aray&uuml;z&uuml; aşağıda verilmiştir:<br />\r\n&nbsp;</p>\r\n\r\n<div class=\"separator\" style=\"clear:both; text-align:center\"><a href=\"https://2.bp.blogspot.com/-dTSWtEXjKv0/Wq5dKySZEzI/AAAAAAAAAR4/Tzr-g3JJgUA_k-rRCSrmKxOAVlaGMOegACLcBGAs/s1600/ap.PNG\" style=\"margin-left: 1em; margin-right: 1em;\"><img src=\"/ArticleContent/ap.PNG\" style=\"height:500px; width:420px\" /></a></div>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p><br />\r\nAray&uuml;zde 2 tane GridView, bir button ve bir label kullanılmıştır. DOLDUR tuşuna basıldığında label &uuml;zerine yazı yazılmadan &ouml;nce veri &ccedil;ekme işlemleri başlatılmakta, yazı yazdırılmakta ve veriler GridView&#39;lar i&ccedil;ine y&uuml;klenmektedir. GridView&#39;lar i&ccedil;ine veriler kendi aralarında da eş zamansız y&uuml;klendiği i&ccedil;in aynı anda y&uuml;klenmemektedir. Bu işlemler esnasında aray&uuml;z s&uuml;rekli cevap verir durumda olacaktır.<br />\r\n<br />\r\nPB v4.0.0-beta bağlantı y&ouml;netimini (Connection Management) eş zamansız (asenkron) yapmamaktadır. Yani bağlantı işlemleri ger&ccedil;ekleştirmek i&ccedil;in işlemleri y&uuml;r&uuml;ten ana thread kullanılmaktadır. Bu y&uuml;zden bağlantı sırasında kısa s&uuml;reli bir meşguliyet meydana gelebilmektedir. Aşağıda forms uygulamasının kodları verilmiştir:</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<pre>\r\npublic class EMPLOYEE\r\n{\r\n    public string FIRST_NAME { get; set; }\r\n    public string LAST_NAME { get; set; }\r\n    public decimal SALARY { get; set; }\r\n    public DateTime? HIRE_DATE { get; set; }\r\n\r\n}\r\n\r\nprivate async void BtIslem_Click(object sender, EventArgs e)\r\n{\r\n    string sql = &quot;select * from employees&quot;;\r\n    string sql2 = &quot;update employees set first_name = &#39;VELI YIGIT&#39; where employee_id = 101&quot;;\r\n\r\n    var db = DatabaseFactory.GetDbObjectAsync(DbSettings.ManuelConnectionManagement);\r\n\r\n    var task = db.GetObjectListAsync(sql);\r\n    var task2 = db.ExecuteQueryAsync(sql2);\r\n    var task3 = db.GetObjectListAsync(sql);\r\n\r\n    LbBilgi.Text = &quot;Verilerin gelmesini beklememe gerek yok!&quot;;\r\n\r\n    GwData.DataSource = await task;\r\n    await task2;\r\n    GwData2.DataSource = await task3;\r\n\r\n    db.CloseConnection();\r\n}\r\n</pre>\r\n\r\n<p><br />\r\nTuşun basılma (click) olayında (event) &quot;async&quot; anahtar kelimesi ile asenkron kod i&ccedil;erdiği belirtilmektedir. Asenkron işlemlerin sonu&ccedil;ları &quot;await&quot; anahtar kelimesi kullanılarak beklenmektedir. Bir noktada await kullanıldı ise ana thread beklenen işlem sonu&ccedil;lanana kadar alt satırları işlememektedir. Yukarıdaki kod bloğunda g&ouml;r&uuml;ld&uuml;ğ&uuml; &uuml;zere 2 veri &ccedil;ekme işlemi ve bir g&uuml;ncelleme (update) işlemi asenkron olarak başlatılmaktadır. Label &uuml;zerine yazı yazdırıldıktan sonra (bu arada veritabanı işlemleri asenkron olarak devam etmekte), daha sonra sonu&ccedil;lar beklenerek ilgili aray&uuml;z elemanları g&uuml;ncellenmektedir. Bu bekleme işlemi sırasında ana thread bloklanmadığı i&ccedil;in aray&uuml;z s&uuml;rekli cevap verir durumda olacaktır.<br />\r\n<br />\r\nBurada bir diğer &ouml;nemli nokta &quot;Manuel Connection Management&quot; modunun kullanılmasıdır. Otomatik y&ouml;netimde yan thread bağlantıyı diğerleri işlemler sonu&ccedil;lanmadan kesebilmekte ve bu durum işlemlerin hatalı sonu&ccedil;lanmasına neden olabilmektedir. Bu sebeple AP kullanılacak ise Manuel mod veya Transaction mod kullanılması gerekmektedir.<br />\r\n<br />\r\nB&uuml;t&uuml;n veritabanı işlemleri sonu&ccedil;landıktan sonra bağlandı kesilmektedir.<br />\r\n<br />\r\n&quot;Bu yazıda &quot;Oracle Managed Provider&quot;, Oracle 11g Express Edition ve HR şeması test verileri kullanılmıştır.&quot;<br />\r\n<br />\r\n&nbsp;&quot;https://github.com/vyigity/ProjectBase&quot;</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>&nbsp;</p>\r\n','2018-03-18 00:00:00','ProjectBase (PB) ile Asenkron Programlama - Asynchronous Programming with ProjectBase (PB)','vyigity',1,NULL,'2018-12-18 19:20:54'),(3,'ProjectBase (PB) v2.5.0 ile birçok QueryGenerator (QG) sıkıntısı çözüldü ve global parametre özelliği kütüphaneye eklendi. Eski usülde parametre kullanımları eğer veri tabanı bağımsız tanımlanmak isteniyorsa FilterText özelliği içinde verilmeliydi. Bu yöntemde eğer parametre karakteri veri tabanı ile uyumsuz ise değiştiriliyordu. Bu yöntem lokal parametre kullanımı olarak tanımlanmaktadır. Global parametre kullanımında parametre SelectText, FilterText veya SelectTail içinde kullanılabilmektedir. Bu özellik ayrıca karmaşık sql komutlarının parametrik olarak QG tarafından işlenebilmesine de olanak sağlamaktadır. Aşağıdaki örneği inceleyelim:<br />\n<br />\n<pre>var db = DatabaseFactory.GetDbObject();\nvar gen = QueryGeneratorFactory.GetDbObject(ParameterMode.Global);\n\nstring sql = @\"\n               select * from employees e\n                            \n               where e.employee_id =\n \n               (select max(employee_id) from employees \n                where salary &gt; .p.SALARY and commission_pct &gt; .p.COMMISSION)\n              \";\n\ngen.SelectText = sql;\ngen.AddFilterParameter(\"SALARY\", 8000);\ngen.AddFilterParameter(\"COMMISSION\", 0.1d);\n\nvar dt = db.ExecuteQueryDataTable(gen.GetSelectCommandBasic());\n</pre>\n<br />\nBurada karmaşıklığı artırmak için iç içe select cümlecikleri kullandık ve iç cümleciğe parametrik olarak bir değer gönderdik. Global parametre tanımında parametre tanımlaması \".p.\" prefiksi kullanılarak yapılmaktadır. Örnekte gösterildiği gibi \"SALARY\" isimli parametre \".p.SALARY\" olarak tanımlanmıştır. Neden \".p.\" gibi bir şey prefiks olarak tercih edildi diye soracak arkadaşlar için burada karmaşık bir derleyiciye sahip olmadığımız için örüntü (pattern) olarak yazılabilecek sql cümlecikleri içinde en az denk gelebilecek bir yapıyı tercih etmemiz gerekiyordu diye soruyu cevaplayabilirim. Yukarıdaki kod çalıştırıldığında sonuç DataTable olarak elde edilecektir.<br />\n<br />\n\"Bu yazıda \"Oracle Managed Provider\", Oracle 11g Express Edition ve HR şeması test verileri kullanılmıştır.\"<br />\n<br />\n&nbsp;\"https://github.com/vyigity/ProjectBase\"\n','2017-12-16 00:00:00','ProjectBase kütüphanesi ile evrensel (global) parametre kullanımı','vyigity',1,NULL,NULL),(5,'<p>23213123 das das das das dasdas d</p>\r\n','2018-12-16 19:50:00','deneme2','vyigity',0,'c440736575bf44babd6cbdf22d34c0c2','2018-12-18 19:15:41'),(6,'<p>dasdasdasfas</p>\r\n','2018-12-18 19:16:24','deneme3','vyigity',0,'4af812115ee641a78fa53ad90a37af32',NULL);
/*!40000 ALTER TABLE `article` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_category`
--

DROP TABLE IF EXISTS `article_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `article_category` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ARTICLE_ID` int(11) NOT NULL,
  `CATEGORY_ID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_category_article` (`CATEGORY_ID`),
  CONSTRAINT `fk_category_article` FOREIGN KEY (`CATEGORY_ID`) REFERENCES `category` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article_category`
--

LOCK TABLES `article_category` WRITE;
/*!40000 ALTER TABLE `article_category` DISABLE KEYS */;
INSERT INTO `article_category` VALUES (1,1,1),(2,1,2),(3,1,3),(7,3,7),(8,3,2),(9,1,7),(37,5,7),(38,6,3),(43,2,3),(44,2,6),(45,2,4),(46,2,7);
/*!40000 ALTER TABLE `article_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bad_word`
--

DROP TABLE IF EXISTS `bad_word`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `bad_word` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `WORD` varchar(45) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `WORD_UNIQUE` (`WORD`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bad_word`
--

LOCK TABLES `bad_word` WRITE;
/*!40000 ALTER TABLE `bad_word` DISABLE KEYS */;
INSERT INTO `bad_word` VALUES (10,'veli'),(9,'yiğit'),(11,'yolcu');
/*!40000 ALTER TABLE `bad_word` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `category` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `LABEL_TEXT` varchar(45) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'BİLGİSAYAR BİLİMLERİ'),(2,'JQUERY'),(3,'C#'),(4,'ORACLE'),(5,'MYSQL'),(6,'JAVASCRIPT'),(7,'VYIGITY'),(8,'ORM'),(9,'ENTITY FRAMEWORK');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `comment` (
  `ID` varchar(40) NOT NULL,
  `ARTICLE_ID` int(11) NOT NULL,
  `COMMENT_TEXT` varchar(100) NOT NULL,
  `INSERT_DATE` datetime NOT NULL,
  `USER_NAME` varchar(45) NOT NULL,
  `APPROVED` varchar(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
INSERT INTO `comment` VALUES ('7958074237f64469b9cd84a75414c339',3,'Yiğitin blog yorumu','2018-12-15 17:09:26','vyigity 3','1'),('8e0667e0a3b94dd0a27a79016e8cb16d',1,'Deneme yorum.','2018-12-14 23:21:02','vyigity','0'),('a',1,'İyi bir yazı olmuş.','2018-12-13 00:00:00','Fırtına91','1'),('b',1,'İyi bir yazı olmuş.','2018-12-09 00:00:00','Deli','1'),('f39c2b53079e45d8b1f07b50f61abaec',2,'okula yiğite git','2018-12-15 17:03:12','vyigity2','0');
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `user` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `USER_NAME` varchar(45) NOT NULL,
  `PASSWORD` varchar(45) NOT NULL,
  `CREATE_DATE` datetime NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'vyigity','1234','2018-12-10 00:00:00');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'blog'
--

--
-- Dumping routines for database 'blog'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-02-24 19:36:38
