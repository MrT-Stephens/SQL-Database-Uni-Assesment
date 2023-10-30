--Will drop all the tables that get created within the script.
DROP TABLE StaffMember CASCADE CONSTRAINTS;
DROP TABLE Customer CASCADE CONSTRAINTS;
DROP TABLE BillingInfomation CASCADE CONSTRAINTS;
DROP TABLE CustomerOrder CASCADE CONSTRAINTS;
DROP TABLE MenuItem CASCADE CONSTRAINTS;
DROP TABLE OrderedMenuItem CASCADE CONSTRAINTS;
DROP TABLE Supplier CASCADE CONSTRAINTS;
DROP TABLE Ingredient CASCADE CONSTRAINTS;
DROP TABLE MenuItemIngredient CASCADE CONSTRAINTS;
DROP TABLE Review CASCADE CONSTRAINTS;
DROP TABLE MenuItemReview CASCADE CONSTRAINTS;
DROP TABLE Question_D_A_Query CASCADE CONSTRAINTS;
DROP TABLE Question_D_B_Query CASCADE CONSTRAINTS;
DROP TABLE Question_D_C_Query CASCADE CONSTRAINTS;
DROP TABLE Question_D_D_Query CASCADE CONSTRAINTS;
DROP TABLE Question_D_E_Query CASCADE CONSTRAINTS;
DROP TABLE Question_D_F_Query CASCADE CONSTRAINTS;
DROP TABLE Question_D_G_Query CASCADE CONSTRAINTS;
DROP TABLE Question_D_H_Query CASCADE CONSTRAINTS;

--Will drop the customer primary key sequence.
DROP SEQUENCE CustomerIncrement;

--Creates 'StaffMember' table with all the required columns.
CREATE TABLE StaffMember 
(
    StaffMemberId NUMBER(10) NOT NULL,
    StaffRank VARCHAR(30) NOT NULL,
    FirstName VARCHAR(30) NOT NULL,
    LastName VARCHAR(30) NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL,
    AddressLineOne VARCHAR(80) NOT NULL,
    City VARCHAR(40) NOT NULL,
    PostCode VARCHAR(15) NOT NULL,

    CONSTRAINTS StaffMember_StaffMemberId_pk PRIMARY KEY (StaffMemberId)
);

--Creates a sequence whcih starts at one and increments by one.
CREATE SEQUENCE CustomerIncrement START WITH 1 INCREMENT BY 1;

--Creates 'Customer' table with all the required columns.
CREATE TABLE Customer 
(
    CustomerId NUMBER(10) DEFAULT CustomerIncrement.NEXTVAL,  --<--Use the increment here to auto generate priamry key.
    FirstName VARCHAR(30) NOT NULL,
    LastName VARCHAR(30) NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL,
    EmailAdress VARCHAR(50) NOT NULL,
    AddressLineOne VARCHAR(80) NOT NULL,
    City VARCHAR(40) NOT NULL,
    PostCode VARCHAR(15) NOT NULL,
    
    CONSTRAINTS Customer_CustomerId_pk PRIMARY KEY (CustomerId)
);

--Creates 'BillingInfomation' table with all the required columns.
CREATE TABLE BillingInfomation
(
    BillingInfoId VARCHAR(12) NOT NULL,
    CustomerId NUMBER(10) NOT NULL,
    NameOnCard VARCHAR(50) NOT NULL,
    AddressLineOne VARCHAR(80) NOT NULL,
    City VARCHAR(40) NOT NULL,
    PostCode VARCHAR(15) NOT NULL,
    CardNumber VARCHAR(20) NOT NULL,
    ExpiryDate VARCHAR(10) NOT NULL,
    ThreeDigitSecurityNo NUMBER(3) NOT NULL,

    CONSTRAINTS BillingInfomation_BillingInfoId_pk PRIMARY KEY (BillingInfoId),
    CONSTRAINTS BillingInfomation_CustomerId_fk FOREIGN KEY (CustomerId) REFERENCES Customer (CustomerId)
);

--Creates 'CustomerOrder' table with all the required columns.
CREATE TABLE CustomerOrder
(
    OrderNo NUMBER(10) NOT NULL,
    CustomerId NUMBER(10) NOT NULL,
    StaffMemberId NUMBER(10) NOT NULL,
    DateOfOrder DATE NOT NULL,
    CollectionOrDelivery VARCHAR(10) NOT NULL,
    TotalCost NUMBER(10, 5) NOT NULL,

    CONSTRAINTS CustomerOrder_OrderNo_pk PRIMARY KEY (OrderNo),
    CONSTRAINTS CustomerOrder_CustomerId_fk FOREIGN KEY (CustomerId) REFERENCES Customer (CustomerId),
    CONSTRAINTS CustomerOrder_StaffMemberId_fk FOREIGN KEY (StaffMemberId) REFERENCES StaffMember (StaffMemberId)
);

--Creates 'MenuItem' table with all the required columns.
CREATE TABLE MenuItem
(
    MenuItemId VARCHAR(10) NOT NULL,
    ItemName VARCHAR(40) NOT NULL,
    ItemDescription VARCHAR(300) NULL,
    ProductionCost NUMBER(10, 5) NOT NULL,
    SalesPrice NUMBER(10, 5) NOT NULL,
    TimeToMake INTERVAL DAY TO SECOND NOT NULL,

    CONSTRAINTS MenuItem_MenuItemId_pk PRIMARY KEY (MenuItemId)
);

--Creates 'OrderedMenuItem' composite table with all the required columns.
CREATE TABLE OrderedMenuItem
(
    OrderedMenuItemId VARCHAR(10) NOT NULL,
    MenuItemId VARCHAR(10) NOT NULL,
    OrderNo NUMBER(10) NOT NULL,

    CONSTRAINTS OrderedMenuItem_pk PRIMARY KEY (OrderedMenuItemId, MenuItemId, OrderNo),
    CONSTRAINTS OrderedMenuItem_MenuItemId_fk FOREIGN KEY (MenuItemId) REFERENCES MenuItem (MenuItemId),
    CONSTRAINTS OrderedMenuItem_OrderNo_fk FOREIGN KEY (OrderNo) REFERENCES CustomerOrder (OrderNo)
);

--Creates 'Supplier' table with all the required columns.
CREATE TABLE Supplier 
(
    SupplierId VARCHAR(10) NOT NULL,
    SupplierName VARCHAR(60) NOT NULL,
    SupplierEmailAdress VARCHAR(50) NULL,
    SupplierPhoneNumber VARCHAR(15) NULL,
    SupplierOrderWebSite VARCHAR(300) NULL,
    DeliveryFee NUMBER(10, 5) NULL,

    CONSTRAINTS Supplier_SupplierId_pk PRIMARY KEY (Supplierid)
);

--Creates 'Ingredient' table with all the required columns.
CREATE TABLE Ingredient 
(
    IngredientId VARCHAR(10) NOT NULL,
    SupplierId VARCHAR(10) NOT NULL,
    IngredientName VARCHAR(60) NOT NULL,
    PurchaseCostPerPack NUMBER(10, 5) NOT NULL,
    QuantityPerPack NUMBER(10, 5) NOT NULL,

    CONSTRAINTS Ingredient_IngredientId_pk PRIMARY KEY (IngredientId),
    CONSTRAINTS Ingredient_SupplierId_fk FOREIGN KEY (SupplierId) REFERENCES Supplier (SupplierId)
);

--Creates 'MenuItemIngredient' composite table with all the required columns.
CREATE TABLE MenuItemIngredient
(
    MenuItemId VARCHAR(10) NOT NULL,
    IngredientId VARCHAR(10) NOT NULL,

    CONSTRAINTS MenuItemIngredient_pk PRIMARY KEY (MenuItemId, IngredientId),
    CONSTRAINTS MenuItemIngredient_MenuItemId_fk FOREIGN KEY (MenuItemId) REFERENCES MenuItem (MenuItemId),
    CONSTRAINTS MenuItemIngredient_IngredientId_fk FOREIGN KEY (IngredientId) REFERENCES Ingredient (IngredientId)
);

--Creates 'Review' table with all the required columns.
CREATE TABLE Review
(
    ReviewId VARCHAR(10) NOT NULL,
    CustomerId NUMBER(10) NOT NULL,
    Rating NUMBER(10, 2) NOT NULL,
    Message VARCHAR(1024) NULL,

    CONSTRAINT Review CHECK (Rating BETWEEN 0 AND 5),
    CONSTRAINTS Review_ReviewId_pk PRIMARY KEY (ReviewId),
    CONSTRAINTS Review_CustomerId_fk FOREIGN KEY (CustomerId) REFERENCES Customer (CustomerId)
);

--Creates 'MenuItemReview' composite table with all the required columns.
CREATE TABLE MenuItemReview
(
    ReviewId VARCHAR(10) NOT NULL,
    MenuItemId VARCHAR(10) NOT NULL,

    CONSTRAINTS MenuItemReview_pk PRIMARY KEY (ReviewId, MenuItemId),
    CONSTRAINTS MenuItemReview_ReviewId_fk FOREIGN KEY (ReviewId) REFERENCES Review (ReviewId),
    CONSTRAINTS MenuItemReview_MenuItemId_fk FOREIGN KEY (MenuItemId) REFERENCES MenuItem (MenuItemId)
);

--Inserts the required data for querys into the 'StaffMember' table.
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('46710032', 'Front Of House', 'Townsend', 'Hablet', '6633716149', '93 Mariners Cove Drive', 'Saint-Laurent-du-Var', 'CF58 9EK');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('65355722', 'Front Of House', 'Brunhilda', 'New', '9746156246', '9667 Ridgeview Court', 'Cabeo', 'CF12 8VK');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('15432328', 'Delivery Driver', 'Siana', 'Domleo', '6907043961', '8 Graceland Park', 'Barrinha', 'CF26 4TY');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('44660275', 'Delivery Driver', 'Bud', 'Forster', '9212182743', '375 Vermont Pass', 'Bojongbenteng', 'CF07 8ML');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('54412904', 'Chef', 'Sharl', 'Pensom', '3047599500', '3221 Debra Trail', 'Kostopil', 'CF44 2OY');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('83922252', 'Chef', 'Norris', 'Hollingsby', '4549421911', '2453 Bluejay Drive', 'Mianhu', 'CF69 5EY');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('06018304', 'Manager', 'Freeland', 'Mallinson', '6872967783', '89009 Gulseth Pass', 'Xiage', 'CF99 9CW');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('90375976', 'Delivery Driver', 'Sheree', 'Dansken', '7546850825', '0547 Logan Junction', 'Wenshang', 'CF13 1MQ');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('96365977', 'Chef', 'Arlin', 'Gauche', '6944271078', '64 Hovde Road', 'Isojoki', 'CF16 2DH');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('69889195', 'Manager', 'Juanita', 'Leversuch', '3985955178', '1 Arizona Point', 'Yanglang', 'CF71 9XS');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('04061955', 'Chef', 'Nadiya', 'Pirelli', '1606598627', '2802 Hintze Way', 'Tartagal', 'CF47 7PP');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('19533433', 'Chef', 'Minna', 'Van den Velden', '7501033095', '2796 Prairie Rose Alley', 'Aix-en-Provence', 'CF92 7PF');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('02993827', 'Chef', 'Moina', 'Rablan', '8944706635', '086 Lakeland Terrace', 'Bendungan', 'CF09 5UQ');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('58799094', 'Chef', 'Dunc', 'MacMenamin', '8838341219', '12 Blackbird Pass', 'Uk', 'CF13 5XZ');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('84106589', 'Front Of House', 'Horatius', 'Hess', '4921012467', '141 Dorton Hill', 'Santa Anita', 'CF50 1NM');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('47302347', 'Front Of House', 'Brittany', 'Bullant', '7679730169', '8 Derek Pass', 'Shanghuang', 'CF91 0GD');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('25818738', 'Chef', 'Sherill', 'Gowdie', '7677767775', '5837 Ridge Oak Street', 'Ilinskiy', 'CF92 4ZB');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('39179386', 'Chef', 'Roslyn', 'Vannuchi', '9448481661', '4666 Crownhardt Parkway', 'El Obeid', 'CF02 8PI');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('00256151', 'Manager', 'Ted', 'Vaillant', '6725655245', '72237 Hooker Circle', 'Mafa', 'CF39 0TZ');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('29904046', 'Chef', 'Karlotta', 'Peinton', '5365541255', '0467 Bluestem Park', 'Trkeri', 'CF64 4YP');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('26872423', 'Front Of House', 'Ivette', 'Lorey', '1376794729', '225 Hoepker Place', 'Czarnoyy', 'CF75 0KL');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('10367439', 'Manager', 'Gayleen', 'Tafani', '1996167202', '93265 Waubesa Parkway', 'Hernani', 'CF79 1IL');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('12367952', 'Chef', 'Darrell', 'Enbury', '1668971765', '33 Algoma Court', 'Bata Tengah', 'CF20 9KC');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('41030123', 'Chef', 'Roseline', 'Limeburner', '6533576159', '17658 Esch Pass', 'Setonokalong', 'CF99 7DE');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('68111390', 'Front Of House', 'Kata', 'Robshaw', '3199973446', '978 Evergreen Place', 'Ciparay', 'CF98 6LL');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('05825281', 'Front Of House', 'Orel', 'Castelli', '7166864223', '9418 Troy Junction', 'Sokolovo', 'CF43 8DY');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('92658117', 'Front Of House', 'Jeanette', 'Prozescky', '3887970719', '3 Colorado Trail', 'Cikawunggading', 'CF10 9NG');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('11762432', 'Manager', 'Lucais', 'Sollon', '2117990136', '9 Esch Center', 'Alor Setar', 'CF01 4FB');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('34794634', 'Chef', 'Nicol', 'Delos', '6737594909', '168 Dwight Terrace', 'Lanling', 'CF91 6JX');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('34794563', 'Chef', 'Carrol', 'Rickis', '5229662757', '59813 Heath Parkway', 'Oster', 'CF06 5KD');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('35311290', 'Chef', 'Allx', 'Ellesmere', '3491729621', '75 Charing Cross Plaza', 'Jiangduo', 'CF87 9IO');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('91544819', 'Front Of House', 'Clarence', 'Greenside', '5318514924', '549 Northport Alley', 'abieniec', 'CF80 4DL');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('33934465', 'Chef', 'Manuel', 'Gawler', '9033857550', '3 Caliangt Crossing', 'Qinhe', 'CF90 3QI');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('69221749', 'Chef', 'Renata', 'Silverman', '4924171929', '93 Anzinger Terrace', 'Esperanza', 'CF96 4RK');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('54636256', 'Delivery Driver', 'Pieter', 'Dwelling', '1376710014', '1914 Jenna Street', 'Yingchengzi', 'CF26 0YX');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('03938140', 'Chef', 'Angie', 'Mulryan', '8873917610', '64 Fairfield Hill', 'Fangshan', 'CF67 8GK');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('85799449', 'Chef', 'Emelen', 'Potzold', '3662807670', '67 Dottie Parkway', 'Mikhaylovsk', 'CF72 9CT');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('83134183', 'Chef', 'Trevar', 'Dow', '7519396343', '6 Washington Park', 'Batn', 'CF42 5PB');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('61684060', 'Front Of House', 'Bobby', 'Sheryne', '5198850737', '8990 Fairview Street', 'Kongoussi', 'CF59 4UE');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('47624437', 'Chef', 'Dorelle', 'Feehery', '3724997498', '8296 Northview Crossing', 'La Esperanza', 'CF62 9CV');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('49905442', 'Chef', 'Patrica', 'Lippi', '1048953372', '55 Raven Road', 'Vale das Ms', 'CF61 3CD');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('04174597', 'Chef', 'Marybelle', 'Bamlet', '9063734448', '9276 School Way', 'Oslo', 'CF03 4MS');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('33928194', 'Front Of House', 'Leon', 'Jacob', '3978100981', '6875 Hauk Point', 'Balzers', 'CF08 8CL');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('77697867', 'Chef', 'Pia', 'Fazan', '9906960077', '963 Stone Corner Street', 'Sanjinquan', 'CF47 0UJ');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('94359484', 'Chef', 'Merle', 'Garfit', '9585107790', '92701 Banding Alley', 'Th Trn Tam ip', 'CF00 1TY');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('98429404', 'Chef', 'Lil', 'Piquard', '6951961994', '81520 Merrick Road', 'San Fernando', 'CF74 0NL');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('52348832', 'Delivery Driver', 'Bernarr', 'Penke', '7252705366', '732 Gulseth Terrace', 'Shiozawa', 'CF11 6ZC');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('22564680', 'Front Of House', 'Chelsea', 'Kembery', '4533421454', '86 Nova Park', 'Tiantai Chengguanzhen', 'CF99 7CI');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('71091282', 'Delivery Driver', 'Mia', 'Newsome', '7963511066', '11 Lillian Drive', 'Karangpao', 'CF85 3RN');
INSERT INTO StaffMember (StaffMemberId, StaffRank, FirstName, LastName, PhoneNumber, AddressLineOne, City, Postcode) VALUES ('60213686', 'Front Of House', 'Shannon', 'Di Biagi', '7876086043', '07 Onsgard Hill', 'Birendranagar', 'CF40 8LB');

--Inserts the required data for querys into the 'Customer' table.
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Lorita', 'Blamires', '1542442771', 'lblamires0@icio.us', '04 Lighthouse Bay Lane', 'Kumla', 'NP76 5BR');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Ivy', 'Chalke', '6392846318', 'ichalke1@homestead.com', '66130 Rowland Park', 'Ninove', 'NP13 2SM');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Tommy', 'Tabrett', '7338196425', 'ttabrett2@nifty.com', '9 Donald Parkway', 'Tawau', 'NP54 0TO');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Hewett', 'Warrilow', '7424369029', 'hwarrilow3@mit.edu', '2161 Meadow Vale Hill', 'San Roque', 'NP01 9UN');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Hendrika', 'Boldock', '4473097226', 'hboldock4@walmart.com', '17 Summer Ridge Road', 'Fastovetskaya', 'NP22 4MD');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Correna', 'Mapother', '1296695213', 'cmapother5@whitehouse.gov', '8 Riverside Pass', 'Dili', 'NP79 8QI');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Armstrong', 'Mayfield', '8778925587', 'amayfield6@addtoany.com', '3 Monica Point', 'Thủ Thừa', 'NP65 0XS');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Rosene', 'Druett', '9706357680', 'rdruett7@fastcompany.com', '4 Corben Parkway', 'Daojiang', 'NP61 1NX');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Dorie', 'Prickett', '1785241203', 'dprickett8@tripadvisor.com', '6974 Esker Hill', 'Huzhen', 'NP68 7FW');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Caressa', 'Sunners', '2368335579', 'csunners9@hao123.com', '472 Stone Corner Alley', 'Quintela', 'NP75 7WG');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Kaleb', 'Greaser', '5056061069', 'kgreasera@dailymail.co.uk', '5 Main Park', 'Caldono', 'NP49 3JK');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Philippa', 'Harraway', '4921271232', 'pharrawayb@gizmodo.com', '087 Colorado Trail', 'Santi Suk', 'NP71 1EX');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Caressa', 'Turford', '2153919563', 'cturfordc@etsy.com', '7784 Fordem Junction', 'Philadelphia', 'NP72 7CB');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Baldwin', 'Sakins', '2918127824', 'bsakinsd@cloudflare.com', '95 Tennessee Avenue', 'Cemara', 'NP81 1JC');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Sullivan', 'Bernath', '7418918216', 'sbernathe@ehow.com', '1656 Packers Trail', 'Tubigan', 'NP14 2MO');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Cindee', 'Ineson', '2366249423', 'cinesonf@google.com.au', '5 Loftsgordon Drive', 'Bungbulang', 'NP84 1ZM');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Christie', 'Gossart', '3621614741', 'cgossartg@usatoday.com', '2 Cordelia Point', 'Kostanay', 'NP54 3FG');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Si', 'Szabo', '5649991303', 'sszaboh@pbs.org', '2439 School Plaza', 'Jedlińsk', 'NP94 1JD');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Maude', 'Olsson', '9841614582', 'molssoni@sciencedirect.com', '7028 Mosinee Junction', 'Pakham', 'NP50 5QA');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Goraud', 'Ruperti', '8056997614', 'grupertij@hubpages.com', '2789 Prairieview Court', 'Chwałowice', 'NP74 6AR');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Roderich', 'Frake', '9485539282', 'rfrakek@prnewswire.com', '3182 Clyde Gallagher Lane', 'Benito Juarez', 'NP72 4LS');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Arlen', 'Tootin', '1983675079', 'atootinl@columbia.edu', '41746 Valley Edge Crossing', 'Teutônia', 'NP39 0AK');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Sander', 'Bamlett', '2251366649', 'sbamlettm@g.co', '9349 Iowa Pass', 'La Quebrada', 'NP46 6DF');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Lanie', 'Guion', '4533004547', 'lguionn@hugedomains.com', '41398 Birchwood Terrace', 'Oslo', 'NP36 9GL');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Chaim', 'Hoston', '2031317850', 'chostono@newsvine.com', '66 Express Terrace', 'Lezhë', 'NP09 8RW');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Hayes', 'Malyan', '1797478489', 'hmalyanp@disqus.com', '6 Anderson Crossing', 'Kyzylorda', 'NP47 2RY');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Dani', 'Barthrup', '5859379573', 'dbarthrupr@apache.org', '86 Magdeline Court', 'Vanderbijlpark', 'NP01 7UA');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Mora', 'Balling', '5101460318', 'mballings@cornell.edu', '5511 Melvin Terrace', 'Richmond', 'NP69 3OF');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Lind', 'Zemler', '8976010787', 'lzemlert@ycombinator.com', '43729 Hanson Center', 'Gueltat Zemmour', 'NP92 1AC');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Tabbie', 'Pitherick', '5258881833', 'tpithericku@eventbrite.com', '45072 Roxbury Avenue', 'Nunhala', 'NP73 1FP');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Chester', 'MacFadden', '7041548419', 'cmacfaddenv@etsy.com', '68 Bay Pass', 'Cikendi', 'NP78 2GJ');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ( 'Cyndia', 'Everall', '3328144019', 'ceverallw@i2i.jp', '4 Rutledge Junction', 'Varkaus', 'NP23 2JP');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Mason', 'Harrie', '2938432159', 'mharriex@upenn.edu', '979 Schiller Court', 'Jatiprahu', 'NP95 8NA');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Estrella', 'Road', '6951649344', 'eroady@about.com', '47562 Jay Place', 'Rosmaninhal', 'NP99 4LG');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Celia', 'Solano', '8489334068', 'csolanoz@java.com', '87647 Bobwhite Point', 'Fort Abbās', 'NP85 3ML');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Shalom', 'Flounders', '4421543836', 'sflounders10@shutterfly.com', '7 Reinke Place', 'Munde', 'NP47 3UN');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Somerset', 'Heasman', '9734301394', 'sheasman11@craigslist.org', '13 Dayton Circle', 'Paterson', 'NP74 9XR');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Miriam', 'Rebillard', '9153167953', 'mrebillard12@naver.com', '74304 Debs Avenue', 'Tianyi', 'NP92 3YL');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Page', 'Dyos', '9199325259', 'pdyos13@seesaa.net', '7 Stone Corner Pass', 'Arrifes', 'NP87 3KL');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Ilyse', 'MacKegg', '3943083649', 'imackegg14@histats.com', '78736 Park Meadow Hill', 'Dijon', 'NP86 0LK');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Berny', 'Gordge', '2746481527', 'bgordge15@newyorker.com', '735 Helena Road', 'Теарце', 'NP87 8QT');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Caspar', 'Pessolt', '9243806633', 'cpessolt16@wikipedia.org', '2841 Barnett Parkway', 'Djibouti', 'NP16 6JI');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Gabbie', 'Orange', '6436129602', 'gorange17@forbes.com', '95 Arkansas Center', 'Lapuz', 'NP72 6XA');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Erick', 'Gauvain', '2373082562', 'egauvain18@msn.com', '65480 La Follette Circle', 'Kuala Terengganu', 'NP94 6FP');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Weider', 'Bould', '7184465484', 'wbould19@youtube.com', '60683 Eastwood Avenue', 'Anrong', 'NP06 7MN');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Sybila', 'Kinny', '2226847440', 'skinny1a@i2i.jp', '8150 Village Point', 'Concepción Tutuapa', 'NP26 9KF');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Rozanne', 'Arter', '6025468284', 'rarter1b@studiopress.com', '771 Schurz Drive', 'Guápiles', 'NP99 1BS');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Cobb', 'Rizzardini', '9558513642', 'crizzardini1c@tripod.com', '60066 Ridgeway Trail', 'Jistebnice', 'NP24 9CZ');
INSERT INTO Customer (FirstName, LastName, PhoneNumber, EmailAdress, AddressLineOne, City, Postcode) VALUES ('Nancee', 'Warder', '2292936707', 'nwarder1d@biglobe.ne.jp', '1 Laurel Drive', 'Anhua', 'NP89 0VS');

--Inserts the required data for querys into the 'BillingInfomation' table.
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL8088697', 1, 'Lorita Blamires', '04 Lighthouse Bay Lane', 'Kumla', 'NP76 5BR', '3441270396930530', '09-21', '119');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL7418336', 2, 'Ivy Chalke', '66130 Rowland Park', 'Ninove', 'NP13 2SM', '132776054343509', '07-26', '933');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL0926645', 3, 'Tommy Tabrett', '9 Donald Parkway', 'Tawau', 'NP54 0TO', '3599841648818060', '02-28', '106');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL3923729', 4, 'Hewett Warrilow', '2161 Meadow Vale Hill', 'San Roque', 'NP01 9UN', '8226092265832380', '07-28', '209');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL4200391', 5, 'Hendrika Boldock', '17 Summer Ridge Road', 'Fastovetskaya', 'NP22 4MD', '7967610102201670', '08-24', '504');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL9193977', 6, 'Correna Mapother', '8 Riverside Pass', 'Dili', 'NP79 8QI', '3495314412740650', '05-26', '116');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL3972024', 7, 'Armstrong Mayfield', '3 Monica Point', 'Thủ Thừa', 'NP65 0XS', '4357296876809290', '00-28', '386');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL2133054', 8, 'Rosene Druett', '4 Corben Parkway', 'Daojiang', 'NP61 1NX', '8607402187424860', '09-24', '773');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL5280853', 9, 'Dorie Prickett', '6974 Esker Hill', 'Huzhen', 'NP68 7FW', '1169785759094340', '04-21', '163');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL7921544', 10, 'Caressa Sunners', '472 Stone Corner Alley', 'Quintela', 'NP75 7WG', '7732146857855200', '06-26', '932');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL6926847', 11, 'Kaleb Greaser', '5 Main Park', 'Caldono', 'NP49 3JK', '7581516621262700', '05-27', '747');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL3543784', 12, 'Philippa Harraway', '087 Colorado Trail', 'Santi Suk', 'NP71 1EX', '6750841995368700', '08-22', '370');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL4923839', 13, 'Caressa Turford', '7784 Fordem Junction', 'Philadelphia', 'NP72 7CB', '2639633961185250', '03-28', '875');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL8596367', 14, 'Baldwin Sakins', '95 Tennessee Avenue', 'Cemara', 'NP81 1JC', '2582085061054780', '04-22', '311');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL6814864', 15, 'Sullivan Bernath', '1656 Packers Trail', 'Tubigan', 'NP14 2MO', '3198336249187200', '04-27', '859');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL6106908', 16, 'Cindee Ineson', '5 Loftsgordon Drive', 'Bungbulang', 'NP84 1ZM', '9047272629712180', '04-27', '537');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL6884243', 17, 'Christie Gossart', '2 Cordelia Point', 'Kostanay', 'NP54 3FG', '1960952499097470', '07-26', '351');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL0562612', 18, 'Si Szabo', '2439 School Plaza', 'Jedlińsk', 'NP94 1JD', '6155998545633030', '03-28', '0');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL2984606', 19, 'Maude Olsson', '7028 Mosinee Junction', 'Pakham', 'NP50 5QA', '4847706209695030', '05-27', '460');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL8180201', 20, 'Goraud Ruperti', '2789 Prairieview Court', 'Chwałowice', 'NP74 6AR', '7198765396893540', '03-23', '11');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL4863581', 21, 'Roderich Frake', '3182 Clyde Gallagher Lane', 'Benito Juarez', 'NP72 4LS', '9990548361559480', '00-27', '188');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL7180673', 22, 'Arlen Tootin', '41746 Valley Edge Crossing', 'Teutônia', 'NP39 0AK', '9709287992924790', '02-26', '651');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL7310435', 23, 'Sander Bamlett', '9349 Iowa Pass', 'La Quebrada', 'NP46 6DF', '4110300724402720', '09-23', '299');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL7962725', 24, 'Lanie Guion', '41398 Birchwood Terrace', 'Oslo', 'NP36 9GL', '7423521902931540', '05-22', '151');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL1834723', 25, 'Chaim Hoston', '66 Express Terrace', 'Lezhë', 'NP09 8RW', '9253560023473050', '07-29', '686');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL8770851', 26, 'Hayes Malyan', '6 Anderson Crossing', 'Kyzylorda', 'NP47 2RY', '7599914340308250', '04-22', '590');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL4293137', 27, 'Kris Swede', '45 Kinsman Pass', 'Rybnoye', 'NP58 1JV', '9434158661533440', '07-22', '584');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL5668805', 28, 'Dani Barthrup', '86 Magdeline Court', 'Vanderbijlpark', 'NP01 7UA', '6688144054738540', '03-21', '338');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL0872979', 29, 'Mora Balling', '5511 Melvin Terrace', 'Richmond', 'NP69 3OF', '3644145916986790', '04-23', '986');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL6186410', 30, 'Lind Zemler', '43729 Hanson Center', 'Gueltat Zemmour', 'NP92 1AC', '3094565807206950', '05-28', '407');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL5267653', 31, 'Tabbie Pitherick', '45072 Roxbury Avenue', 'Nunhala', 'NP73 1FP', '8386801713156440', '05-25', '20');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL3804399', 31, 'Chester MacFadden', '68 Bay Pass', 'Cikendi', 'NP78 2GJ', '3874388200247990', '05-22', '438');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL2473576', 32, 'Cyndia Everall', '4 Rutledge Junction', 'Varkaus', 'NP23 2JP', '8669341950719020', '06-26', '828');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL1597481', 33, 'Mason Harrie', '979 Schiller Court', 'Jatiprahu', 'NP95 8NA', '5823719503465290', '05-21', '762');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL4814782', 34, 'Estrella Road', '47562 Jay Place', 'Rosmaninhal', 'NP99 4LG', '6068566470977070', '09-29', '468');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL3207057', 35, 'Celia Solano', '87647 Bobwhite Point', 'Fort Abbās', 'NP85 3ML', '3929029525334200', '08-20', '369');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL7013002', 36, 'Shalom Flounders', '7 Reinke Place', 'Munde', 'NP47 3UN', '988686554605469', '07-29', '981');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL7449727', 37, 'Somerset Heasman', '13 Dayton Circle', 'Paterson', 'NP74 9XR', '2463191931921520', '06-24', '109');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL5706254', 38, 'Miriam Rebillard', '74304 Debs Avenue', 'Tianyi', 'NP92 3YL', '7168041682406710', '05-29', '422');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL4122371', 39, 'Page Dyos', '7 Stone Corner Pass', 'Arrifes', 'NP87 3KL', '1260245354488780', '06-24', '413');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL7999746', 40, 'Ilyse MacKegg', '78736 Park Meadow Hill', 'Dijon', 'NP86 0LK', '5698285569722880', '05-29', '362');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL3372499', 41, 'Berny Gordge', '735 Helena Road', 'Теарце', 'NP87 8QT', '7357349427321320', '03-28', '778');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL2138380', 42, 'Caspar Pessolt', '2841 Barnett Parkway', 'Djibouti', 'NP16 6JI', '8573484258350500', '06-21', '369');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL6262968', 43, 'Gabbie Orange', '95 Arkansas Center', 'Lapuz', 'NP72 6XA', '8110361709170530', '06-20', '676');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL3463616', 44, 'Erick Gauvain', '65480 La Follette Circle', 'Kuala Terengganu', 'NP94 6FP', '9863435187330880', '04-21', '104');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL5524453', 45, 'Weider Bould', '60683 Eastwood Avenue', 'Anrong', 'NP06 7MN', '4101631935961950', '08-28', '711');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL3602782', 46, 'Sybila Kinny', '8150 Village Point', 'Concepción Tutuapa', 'NP26 9KF', '3446624852892060', '00-26', '366');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL2474285', 47, 'Rozanne Arter', '771 Schurz Drive', 'Guápiles', 'NP99 1BS', '588360929810375', '04-21', '646');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL3944024', 48, 'Cobb Rizzardini', '60066 Ridgeway Trail', 'Jistebnice', 'NP24 9CZ', '623564476113703', '08-21', '153');
INSERT INTO BillingInfomation (BillingInfoId, CustomerId, NameOnCard, AddressLineOne, City, Postcode, CardNumber, ExpiryDate, ThreeDigitSecurityNo) VALUES ('BILL2857041', 49, 'Nancee Warder', '1 Laurel Drive', 'Anhua', 'NP89 0VS', '890043265875797', '02-20', '714');

--Inserts the required data for querys into the 'CustomerOrder' table.
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('1', 1, '46710032', TO_TIMESTAMP('12/01/2023 18:47:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '27.84');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('2', 2, '65355722', TO_TIMESTAMP('09/01/2023 03:22:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '28.3');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('3', 3, '15432328', TO_TIMESTAMP('25/11/2022 18:06:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '30.48');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('4', 4, '44660275', TO_TIMESTAMP('08/04/2022 23:38:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '28.22');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('5', 5, '54412904', TO_TIMESTAMP('21/09/2022 03:12:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '26.9');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('6', 6, '83922252', TO_TIMESTAMP('08/09/2022 17:24:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '24.76');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('7', 7, '6018304', TO_TIMESTAMP('02/04/2022 18:22:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '25');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('8', 8, '90375976', TO_TIMESTAMP('02/08/2022 11:44:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '28.34');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('9', 9, '96365977', TO_TIMESTAMP('11/12/2022 09:45:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '28.56');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('10', 10, '69889195', TO_TIMESTAMP('11/10/2022 21:29:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '24.64');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('11', 11, '4061955', TO_TIMESTAMP('02/12/2022 04:06:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '25.86');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('12', 12, '19533433', TO_TIMESTAMP('25/03/2023 02:19:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '28.86');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('13', 13, '2993827', TO_TIMESTAMP('04/03/2023 21:06:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '27.44');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('14', 14, '58799094', TO_TIMESTAMP('21/08/2022 23:39:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '26.14');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('15', 15, '84106589', TO_TIMESTAMP('20/10/2022 04:36:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '25.02');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('16', 16, '47302347', TO_TIMESTAMP('26/01/2023 20:38:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '30.94');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('17', 17, '25818738', TO_TIMESTAMP('04/04/2022 09:22:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '27.38');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('18', 18, '39179386', TO_TIMESTAMP('05/11/2022 18:57:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '29.14');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('19', 19, '256151', TO_TIMESTAMP('06/10/2022 03:29:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '28.24');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('20', 20, '29904046', TO_TIMESTAMP('01/10/2022 13:16:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '24.74');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('21', 21, '26872423', TO_TIMESTAMP('15/02/2023 19:51:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '27.16');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('22', 22, '10367439', TO_TIMESTAMP('23/02/2023 16:54:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '25.94');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('23', 23, '12367952', TO_TIMESTAMP('06/06/2022 17:08:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '27.62');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('24', 24, '41030123', TO_TIMESTAMP('10/01/2023 05:23:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '25.36');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('25', 25, '68111390', TO_TIMESTAMP('30/05/2022 01:18:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '29.06');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('26', 26, '5825281', TO_TIMESTAMP('14/07/2022 12:06:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '24.44');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('27', 27, '92658117', TO_TIMESTAMP('20/12/2022 04:56:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '28.86');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('28', 28, '11762432', TO_TIMESTAMP('14/08/2022 08:37:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '26.14');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('29', 29, '34794634', TO_TIMESTAMP('30/09/2022 15:57:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '26.32');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('30', 30, '34794563', TO_TIMESTAMP('21/09/2022 10:11:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '28.12');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('31', 1, '46710032', TO_TIMESTAMP('24/01/2023 18:47:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '27.84');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('32', 2, '65355722', TO_TIMESTAMP('12/02/2023 03:22:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '28.3');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('33', 3, '15432328', TO_TIMESTAMP('20/12/2022 18:06:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '30.48');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('34', 4, '44660275', TO_TIMESTAMP('09/05/2022 23:38:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '28.22');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('35', 5, '54412904', TO_TIMESTAMP('25/09/2022 03:12:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '26.9');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('36', 6, '83922252', TO_TIMESTAMP('11/09/2022 17:24:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '24.76');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('37', 7, '6018304', TO_TIMESTAMP('12/05/2022 18:22:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '25');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('38', 8, '90375976', TO_TIMESTAMP('22/08/2022 11:44:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '28.34');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('39', 9, '96365977', TO_TIMESTAMP('21/12/2022 09:45:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '28.56');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('40', 10, '69889195', TO_TIMESTAMP('21/10/2022 21:29:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '24.64');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('41', 11, '4061955', TO_TIMESTAMP('17/12/2022 04:06:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '25.86');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('42', 12, '19533433', TO_TIMESTAMP('15/05/2023 02:19:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '28.86');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('43', 13, '2993827', TO_TIMESTAMP('05/03/2023 21:06:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '27.44');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('44', 14, '58799094', TO_TIMESTAMP('27/08/2022 23:39:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '26.14');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('45', 15, '84106589', TO_TIMESTAMP('29/11/2022 04:36:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '25.02');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('46', 16, '47302347', TO_TIMESTAMP('29/01/2023 20:38:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '30.94');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('47', 17, '25818738', TO_TIMESTAMP('09/05/2022 09:22:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '27.38');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('48', 18, '39179386', TO_TIMESTAMP('22/11/2022 18:57:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '29.14');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('49', 19, '256151', TO_TIMESTAMP('21/10/2022 03:29:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '28.24');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('50', 20, '29904046', TO_TIMESTAMP('14/10/2022 13:16:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '24.74');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('51', 21, '26872423', TO_TIMESTAMP('28/02/2023 19:51:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '27.16');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('52', 22, '10367439', TO_TIMESTAMP('29/03/2023 16:54:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '25.94');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('53', 23, '12367952', TO_TIMESTAMP('26/06/2022 17:08:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '27.62');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('54', 24, '41030123', TO_TIMESTAMP('20/01/2023 05:23:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '25.36');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('55', 25, '68111390', TO_TIMESTAMP('30/06/2022 01:18:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '29.06');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('56', 26, '5825281', TO_TIMESTAMP('21/07/2022 12:06:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '24.44');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('57', 27, '92658117', TO_TIMESTAMP('29/12/2022 04:56:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '28.86');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('58', 28, '11762432', TO_TIMESTAMP('28/08/2022 08:37:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '26.14');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('59', 29, '34794634', TO_TIMESTAMP('30/11/2022 15:57:00', 'DD/MM/YYYY HH24:MI:SS'), 'Delivery', '26.32');
INSERT INTO CustomerOrder (OrderNo, CustomerId, StaffMemberId, DateOfOrder, CollectionOrDelivery, TotalCost) VALUES ('60', 30, '34794563', TO_TIMESTAMP('13/10/2022 10:11:00', 'DD/MM/YYYY HH24:MI:SS'), 'Collection', '28.12');

--Inserts the required data for querys into the 'Menuitem' table.
INSERT INTO MenuItem (MenuItemId, ItemName, ItemDescription, ProductionCost, SalesPrice, TimeToMake) VALUES ('MENU4360', 'Steak and Chips', 'Amazing', '3.32', '7.62', TO_DSINTERVAL('0 00:12:36'));
INSERT INTO MenuItem (MenuItemId, ItemName, ItemDescription, ProductionCost, SalesPrice, TimeToMake) VALUES ('MENU2485', 'Sausage and Chips', 'Good', '1.09', '6.3', TO_DSINTERVAL('0 00:12:56'));
INSERT INTO MenuItem (MenuItemId, ItemName, ItemDescription, ProductionCost, SalesPrice, TimeToMake) VALUES ('MENU2582', 'Chilli Con Carne', 'Good', '1.16', '7.85', TO_DSINTERVAL('0 00:11:50'));
INSERT INTO MenuItem (MenuItemId, ItemName, ItemDescription, ProductionCost, SalesPrice, TimeToMake) VALUES ('MENU4984', 'Chicken Curry', 'Amazing', '4.28', '7.39', TO_DSINTERVAL('0 00:14:31'));
INSERT INTO MenuItem (MenuItemId, ItemName, ItemDescription, ProductionCost, SalesPrice, TimeToMake) VALUES ('MENU7469', 'Cheese Pizza', 'Good', '1.61', '6.72', TO_DSINTERVAL('0 00:18:59'));
INSERT INTO MenuItem (MenuItemId, ItemName, ItemDescription, ProductionCost, SalesPrice, TimeToMake) VALUES ('MENU5356', 'Pepperoni Pizza', 'Good', '3.23', '6.73', TO_DSINTERVAL('0 00:11:34'));
INSERT INTO MenuItem (MenuItemId, ItemName, ItemDescription, ProductionCost, SalesPrice, TimeToMake) VALUES ('MENU4413', 'Chicken Pizza', 'Amazing', '1.83', '5.65', TO_DSINTERVAL('0 00:15:45'));
INSERT INTO MenuItem (MenuItemId, ItemName, ItemDescription, ProductionCost, SalesPrice, TimeToMake) VALUES ('MENU1914', 'Tomato Pasta', 'Amazing', '3.5', '6.85', TO_DSINTERVAL('0 00:12:12'));
INSERT INTO MenuItem (MenuItemId, ItemName, ItemDescription, ProductionCost, SalesPrice, TimeToMake) VALUES ('MENU4213', 'Coke', 'Amazing', '1.63', '7.32', TO_DSINTERVAL('0 00:16:49'));
INSERT INTO MenuItem (MenuItemId, ItemName, ItemDescription, ProductionCost, SalesPrice, TimeToMake) VALUES ('MENU7608', 'Sprite', 'Great', '4.18', '6.96', TO_DSINTERVAL('0 00:11:02'));
INSERT INTO MenuItem (MenuItemId, ItemName, ItemDescription, ProductionCost, SalesPrice, TimeToMake) VALUES ('MENU9139', 'Fanta', 'Good', '1.28', '5.36', TO_DSINTERVAL('0 00:18:19'));
INSERT INTO MenuItem (MenuItemId, ItemName, ItemDescription, ProductionCost, SalesPrice, TimeToMake) VALUES ('MENU8368', 'Pepsi', 'Great', '1.28', '7.57', TO_DSINTERVAL('0 00:18:17'));
INSERT INTO MenuItem (MenuItemId, ItemName, ItemDescription, ProductionCost, SalesPrice, TimeToMake) VALUES ('MENU1921', 'Noodles', 'Good', '2.93', '6.86', TO_DSINTERVAL('0 00:16:22'));
INSERT INTO MenuItem (MenuItemId, ItemName, ItemDescription, ProductionCost, SalesPrice, TimeToMake) VALUES ('MENU6135', 'Fish and Chips', 'Good', '4.5', '6.86', TO_DSINTERVAL('0 00:15:30'));
INSERT INTO MenuItem (MenuItemId, ItemName, ItemDescription, ProductionCost, SalesPrice, TimeToMake) VALUES ('MENU9722', 'Beef Burger', 'Great', '2.93', '6.21', TO_DSINTERVAL('0 00:13:14'));

--Inserts the required data for querys into the 'OrderedMenuItem' composite table.
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI94609', 'MENU4360', '1');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI16995', 'MENU2485', '2');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI31305', 'MENU2582', '3');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI88174', 'MENU4984', '4');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI76825', 'MENU7469', '5');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI84601', 'MENU5356', '6');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI66680', 'MENU4413', '7');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI57452', 'MENU1914', '8');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI10375', 'MENU4213', '9');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI97059', 'MENU7608', '10');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI54718', 'MENU9139', '11');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI08397', 'MENU8368', '12');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI46139', 'MENU1921', '13');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI69819', 'MENU6135', '14');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI67288', 'MENU9722', '15');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI88356', 'MENU4360', '16');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI29261', 'MENU2485', '17');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI42585', 'MENU2582', '18');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI94440', 'MENU4984', '19');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI35557', 'MENU7469', '20');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI73435', 'MENU5356', '21');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI07295', 'MENU4413', '22');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI40733', 'MENU1914', '23');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI69951', 'MENU4213', '24');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI24514', 'MENU7608', '25');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI73279', 'MENU9139', '26');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI86405', 'MENU8368', '27');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI54871', 'MENU1921', '28');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI51299', 'MENU6135', '29');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI45131', 'MENU9722', '30');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI55195', 'MENU2485', '1');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI66675', 'MENU2582', '2');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI08171', 'MENU4984', '3');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI91660', 'MENU7469', '4');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI67841', 'MENU5356', '5');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI95940', 'MENU4413', '6');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI74471', 'MENU1914', '7');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI07556', 'MENU4213', '8');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI32014', 'MENU7608', '9');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI18817', 'MENU9139', '10');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI56848', 'MENU8368', '11');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI11149', 'MENU1921', '12');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI20698', 'MENU6135', '13');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI74249', 'MENU9722', '14');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI03452', 'MENU2485', '15');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI31543', 'MENU2582', '16');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI58924', 'MENU4984', '17');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI40445', 'MENU7469', '18');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI12302', 'MENU5356', '19');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI64024', 'MENU4413', '20');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI84804', 'MENU1914', '21');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI68940', 'MENU4213', '22');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI25716', 'MENU7608', '23');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI97277', 'MENU9139', '24');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI12802', 'MENU8368', '25');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI41166', 'MENU1921', '26');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI89227', 'MENU6135', '27');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI35690', 'MENU9722', '28');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI97631', 'MENU2485', '29');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI48064', 'MENU2582', '30');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI30735', 'MENU4360', '1');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI15334', 'MENU2485', '2');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI28011', 'MENU2582', '3');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI13747', 'MENU4984', '4');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI58874', 'MENU7469', '5');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI55860', 'MENU5356', '6');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI16493', 'MENU4413', '7');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI63345', 'MENU1914', '8');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI80768', 'MENU4213', '9');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI95529', 'MENU7608', '10');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI50813', 'MENU9139', '11');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI29562', 'MENU8368', '12');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI70493', 'MENU1921', '13');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI19461', 'MENU6135', '14');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI58768', 'MENU9722', '15');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI44649', 'MENU4360', '16');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI36837', 'MENU2485', '17');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI33200', 'MENU2582', '18');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI97356', 'MENU4984', '19');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI53571', 'MENU7469', '20');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI92843', 'MENU5356', '21');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI83354', 'MENU4413', '22');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI98515', 'MENU1914', '23');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI13990', 'MENU4213', '24');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI44073', 'MENU7608', '25');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI75486', 'MENU9139', '26');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI08203', 'MENU8368', '27');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI42993', 'MENU1921', '28');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI60742', 'MENU6135', '29');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI24563', 'MENU9722', '30');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI42734', 'MENU2485', '1');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI17797', 'MENU2582', '2');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI34304', 'MENU4984', '3');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI03925', 'MENU7469', '4');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI93691', 'MENU5356', '5');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI11859', 'MENU4413', '6');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI30858', 'MENU1914', '7');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI89162', 'MENU4213', '8');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI89991', 'MENU7608', '9');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI40351', 'MENU9139', '10');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI50427', 'MENU8368', '11');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI89587', 'MENU1921', '12');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI02102', 'MENU6135', '13');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI12879', 'MENU9722', '14');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI83362', 'MENU2485', '15');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI80910', 'MENU2582', '16');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI64784', 'MENU4984', '17');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI11775', 'MENU7469', '18');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI08759', 'MENU5356', '19');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI71426', 'MENU4413', '20');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI86806', 'MENU1914', '21');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI07143', 'MENU4213', '22');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI55750', 'MENU7608', '23');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI48354', 'MENU9139', '24');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI61538', 'MENU8368', '25');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI12187', 'MENU1921', '26');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI26929', 'MENU6135', '27');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI12711', 'MENU9722', '28');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI33374', 'MENU2485', '29');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI05930', 'MENU2582', '30');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00001', 'MENU4360', '31');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00002', 'MENU2485', '32');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00003', 'MENU2582', '33');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00004', 'MENU4984', '34');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00005', 'MENU7469', '35');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00006', 'MENU5356', '36');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00007', 'MENU4413', '37');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00008', 'MENU1914', '38');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00009', 'MENU4213', '39');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00010', 'MENU7608', '40');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00011', 'MENU9139', '41');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00012', 'MENU8368', '42');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00013', 'MENU1921', '43');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00014', 'MENU6135', '44');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00015', 'MENU9722', '45');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00016', 'MENU4360', '46');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00017', 'MENU2485', '47');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00018', 'MENU2582', '48');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00019', 'MENU4984', '49');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00020', 'MENU7469', '50');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00021', 'MENU5356', '51');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00022', 'MENU4413', '52');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00023', 'MENU1914', '53');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00024', 'MENU4213', '54');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00025', 'MENU7608', '55');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00026', 'MENU9139', '56');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00027', 'MENU8368', '57');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00028', 'MENU1921', '58');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00029', 'MENU6135', '59');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00030', 'MENU9722', '60');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00031', 'MENU2485', '31');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00032', 'MENU2582', '32');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00033', 'MENU4984', '33');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00034', 'MENU7469', '34');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00035', 'MENU5356', '35');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00036', 'MENU4413', '36');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00037', 'MENU1914', '37');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00038', 'MENU4213', '38');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00039', 'MENU7608', '39');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00040', 'MENU9139', '40');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00041', 'MENU8368', '41');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00042', 'MENU1921', '42');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00043', 'MENU6135', '43');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00044', 'MENU9722', '44');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00045', 'MENU2485', '45');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00046', 'MENU2582', '46');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00047', 'MENU4984', '47');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00048', 'MENU7469', '48');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00049', 'MENU5356', '49');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00050', 'MENU4413', '50');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00051', 'MENU1914', '51');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00052', 'MENU4213', '52');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00053', 'MENU7608', '53');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00054', 'MENU9139', '54');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00055', 'MENU8368', '55');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00056', 'MENU1921', '56');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00057', 'MENU6135', '57');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00058', 'MENU9722', '58');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00059', 'MENU2485', '59');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00060', 'MENU2582', '60');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00061', 'MENU4360', '31');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00062', 'MENU2485', '32');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00063', 'MENU2582', '33');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00064', 'MENU4984', '34');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00065', 'MENU7469', '35');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00066', 'MENU5356', '36');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00067', 'MENU4413', '37');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00068', 'MENU1914', '38');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00069', 'MENU4213', '39');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00070', 'MENU7608', '40');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00071', 'MENU9139', '41');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00072', 'MENU8368', '42');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00073', 'MENU1921', '43');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00074', 'MENU6135', '44');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00075', 'MENU9722', '45');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00076', 'MENU4360', '46');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00077', 'MENU2485', '47');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00078', 'MENU2582', '48');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00079', 'MENU4984', '49');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00080', 'MENU7469', '50');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00081', 'MENU5356', '51');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00082', 'MENU4413', '52');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00083', 'MENU1914', '53');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00084', 'MENU4213', '54');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00085', 'MENU7608', '55');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00086', 'MENU9139', '56');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00087', 'MENU8368', '57');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00088', 'MENU1921', '58');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00089', 'MENU6135', '59');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00090', 'MENU9722', '60');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00091', 'MENU2485', '31');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00092', 'MENU2582', '32');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00093', 'MENU4984', '33');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00094', 'MENU7469', '34');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00095', 'MENU5356', '35');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00096', 'MENU4413', '36');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00097', 'MENU1914', '37');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00098', 'MENU4213', '38');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00099', 'MENU7608', '39');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00100', 'MENU9139', '40');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00101', 'MENU8368', '41');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00102', 'MENU1921', '42');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00103', 'MENU6135', '43');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00104', 'MENU9722', '44');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00105', 'MENU2485', '45');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00106', 'MENU2582', '46');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00107', 'MENU4984', '47');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00108', 'MENU7469', '48');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00109', 'MENU5356', '49');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00110', 'MENU4413', '50');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00111', 'MENU1914', '51');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00112', 'MENU4213', '52');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00113', 'MENU7608', '53');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00114', 'MENU9139', '54');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00115', 'MENU8368', '55');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00116', 'MENU1921', '56');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00117', 'MENU6135', '57');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00118', 'MENU9722', '58');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00119', 'MENU2485', '59');
INSERT INTO OrderedMenuItem (OrderedMenuItemId, MenuItemId, OrderNo) VALUES ('OMI00120', 'MENU2582', '60');

--Inserts the required data for querys into the 'Supplier' table.
INSERT INTO Supplier (SupplierId, SupplierName, SupplierEmailAdress, SupplierPhoneNumber, SupplierOrderWebSite, DeliveryFee) VALUES ('SUP2235', 'Costco', 'warehousememberservices@costco.co.uk', '01923 830 477', 'https://www.costco.co.uk/', '10.57');
INSERT INTO Supplier (SupplierId, SupplierName, SupplierEmailAdress, SupplierPhoneNumber, SupplierOrderWebSite, DeliveryFee) VALUES ('SUP7830', 'Booker', 'N/A', '01933 371000', 'https://www.booker.co.uk/content/pages/catering/our-ranges.html', '0');
INSERT INTO Supplier (SupplierId, SupplierName, SupplierEmailAdress, SupplierPhoneNumber, SupplierOrderWebSite, DeliveryFee) VALUES ('SUP7542', 'Tesco', 'N/A', '0800 323 4040', 'https://www.tesco.com/', '4.5');
INSERT INTO Supplier (SupplierId, SupplierName, SupplierEmailAdress, SupplierPhoneNumber, SupplierOrderWebSite, DeliveryFee) VALUES ('SUP1985', 'Morrisons', 'N/A', '0345 611 611', 'https://groceries.morrisons.com/webshop/startWebshop.do', '5.98');

--Inserts the required data for querys into the 'Ingredient' table.
INSERT INTO Ingredient (IngredientId, SupplierId, IngredientName, PurchaseCostPerPack, QuantityPerPack) VALUES ('ING2245', 'SUP2235', 'Chips', '4.35', '1');
INSERT INTO Ingredient (IngredientId, SupplierId, IngredientName, PurchaseCostPerPack, QuantityPerPack) VALUES ('ING4376', 'SUP7830', 'Steak', '10.35', '1');
INSERT INTO Ingredient (IngredientId, SupplierId, IngredientName, PurchaseCostPerPack, QuantityPerPack) VALUES ('ING3205', 'SUP7542', 'Sausages', '5.35', '1');
INSERT INTO Ingredient (IngredientId, SupplierId, IngredientName, PurchaseCostPerPack, QuantityPerPack) VALUES ('ING4307', 'SUP1985', 'Chilli Powder', '2.34', '1');
INSERT INTO Ingredient (IngredientId, SupplierId, IngredientName, PurchaseCostPerPack, QuantityPerPack) VALUES ('ING6945', 'SUP2235', 'Beef Mince', '5.67', '1');
INSERT INTO Ingredient (IngredientId, SupplierId, IngredientName, PurchaseCostPerPack, QuantityPerPack) VALUES ('ING0544', 'SUP7830', 'Red Kidney Beans', '3.45', '1');
INSERT INTO Ingredient (IngredientId, SupplierId, IngredientName, PurchaseCostPerPack, QuantityPerPack) VALUES ('ING5494', 'SUP7542', 'Tomatoes', '3.89', '1');
INSERT INTO Ingredient (IngredientId, SupplierId, IngredientName, PurchaseCostPerPack, QuantityPerPack) VALUES ('ING4333', 'SUP1985', 'Baked Beans', '2.65', '1');
INSERT INTO Ingredient (IngredientId, SupplierId, IngredientName, PurchaseCostPerPack, QuantityPerPack) VALUES ('ING9544', 'SUP2235', 'Chicken', '11.2', '1');
INSERT INTO Ingredient (IngredientId, SupplierId, IngredientName, PurchaseCostPerPack, QuantityPerPack) VALUES ('ING5483', 'SUP7830', 'Curry Sauce', '3.09', '1');
INSERT INTO Ingredient (IngredientId, SupplierId, IngredientName, PurchaseCostPerPack, QuantityPerPack) VALUES ('ING5487', 'SUP7542', 'Mushrooms', '2.76', '1');
INSERT INTO Ingredient (IngredientId, SupplierId, IngredientName, PurchaseCostPerPack, QuantityPerPack) VALUES ('ING5466', 'SUP1985', 'Onions', '2.45', '1');
INSERT INTO Ingredient (IngredientId, SupplierId, IngredientName, PurchaseCostPerPack, QuantityPerPack) VALUES ('ING8695', 'SUP2235', 'Cheese', '1.2', '1');
INSERT INTO Ingredient (IngredientId, SupplierId, IngredientName, PurchaseCostPerPack, QuantityPerPack) VALUES ('ING5363', 'SUP7830', 'Pizza Base', '1.02', '1');
INSERT INTO Ingredient (IngredientId, SupplierId, IngredientName, PurchaseCostPerPack, QuantityPerPack) VALUES ('ING7765', 'SUP7542', 'Pepperoni', '4.54', '1');
INSERT INTO Ingredient (IngredientId, SupplierId, IngredientName, PurchaseCostPerPack, QuantityPerPack) VALUES ('ING5435', 'SUP1985', 'Pasta', '3.96', '1');
INSERT INTO Ingredient (IngredientId, SupplierId, IngredientName, PurchaseCostPerPack, QuantityPerPack) VALUES ('ING9655', 'SUP2235', 'Coke', '2.34', '1');
INSERT INTO Ingredient (IngredientId, SupplierId, IngredientName, PurchaseCostPerPack, QuantityPerPack) VALUES ('ING5594', 'SUP7830', 'Sprite', '4.54', '1');
INSERT INTO Ingredient (IngredientId, SupplierId, IngredientName, PurchaseCostPerPack, QuantityPerPack) VALUES ('ING9954', 'SUP7542', 'Fanta', '5.4', '1');
INSERT INTO Ingredient (IngredientId, SupplierId, IngredientName, PurchaseCostPerPack, QuantityPerPack) VALUES ('ING3244', 'SUP1985', 'Pepsi', '2.78', '1');
INSERT INTO Ingredient (IngredientId, SupplierId, IngredientName, PurchaseCostPerPack, QuantityPerPack) VALUES ('ING9653', 'SUP7830', 'Fish', '4.5', '1');
INSERT INTO Ingredient (IngredientId, SupplierId, IngredientName, PurchaseCostPerPack, QuantityPerPack) VALUES ('ING4395', 'SUP7542', 'Noodles', '1.45', '1');
INSERT INTO Ingredient (IngredientId, SupplierId, IngredientName, PurchaseCostPerPack, QuantityPerPack) VALUES ('ING2222', 'SUP1985', 'Beef Burger', '5.67', '1');
INSERT INTO Ingredient (IngredientId, SupplierId, IngredientName, PurchaseCostPerPack, QuantityPerPack) VALUES ('ING9000', 'SUP1985', 'Rolls', '3.23', '1');

--Inserts the required data for querys into the 'MenuItemIngredient' composite table.
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU4360', 'ING2245');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU4360', 'ING4376');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU2485', 'ING2245');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU2485', 'ING3205');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU2582', 'ING4307');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU2582', 'ING6945');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU2582', 'ING0544');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU2582', 'ING5494');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU2582', 'ING4333');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU2582', 'ING5487');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU2582', 'ING5466');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU4984', 'ING5494');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU4984', 'ING9544');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU4984', 'ING5483');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU4984', 'ING5487');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU4984', 'ING5466');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU7469', 'ING5494');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU7469', 'ING8695');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU7469', 'ING5363');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU5356', 'ING5494');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU5356', 'ING8695');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU5356', 'ING5363');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU5356', 'ING7765');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU4413', 'ING5494');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU4413', 'ING8695');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU4413', 'ING5363');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU4413', 'ING9544');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU1914', 'ING5494');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU1914', 'ING5435');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU4213', 'ING9655');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU7608', 'ING5594');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU9139', 'ING9954');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU8368', 'ING3244');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU1921', 'ING4307');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU1921', 'ING5494');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU1921', 'ING9544');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU1921', 'ING5483');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU1921', 'ING5487');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU1921', 'ING5466');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU1921', 'ING4395');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU6135', 'ING2245');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU6135', 'ING5483');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU6135', 'ING9653');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU9722', 'ING2245');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU9722', 'ING5494');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU9722', 'ING4333');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU9722', 'ING2222');
INSERT INTO MenuItemIngredient (MenuItemId, IngredientId) VALUES ('MENU9722', 'ING9000');

--Inserts the required data for querys into the 'Review' table.
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00001', 1, '0.2', 'Not great at all.');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00002', 2, '0.4', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00003', 3, '0.6', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00004', 4, '0.8', 'Bad.');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00005', 5, '1', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00006', 6, '1.2', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00007', 7, '1.4', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00008', 8, '1.6', 'Ok.');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00009', 9, '1.8', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00010', 10, '2', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00011', 11, '2.2', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00012', 12, '2.4', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00013', 13, '2.6', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00014', 14, '2.8', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00015', 15, '3', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00016', 16, '3.2', 'Pretty good.');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00017', 17, '3.4', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00018', 18, '3.6', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00019', 19, '3.8', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00020', 20, '4', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00021', 21, '4.2', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00022', 22, '4.4', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00023', 23, '4.6', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00024', 24, '4.8', 'Amazing.');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00025', 25, '5', 'Unbelivable.');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00026', 26, '0.4', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00027', 27, '0.8', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00028', 28, '1.2', 'Bad.');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00029', 29, '1.6', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00030', 30, '2', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00031', 31, '2.4', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00032', 32, '2.8', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00033', 33, '3.2', 'Pretty good.');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00034', 34, '3.6', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00035', 35, '4', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00036', 36, '4.4', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00037', 37, '4.8', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00038', 38, '0.3', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00039', 39, '0.6', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00040', 40, '0.9', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00041', 41, '1.2', 'Bad.');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00042', 42, '1.5', 'Bad.');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00043', 43, '1.8', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00044', 44, '2.1', '');
INSERT INTO Review (ReviewId, CustomerId, Rating, Message) VALUES ('REV00045', 45, '2.4', 'Pretty good.');

--Inserts the required data for querys into the 'MenuItemReview' composite table.
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00001', 'MENU4360');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00002', 'MENU2485');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00003', 'MENU2582');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00004', 'MENU4984');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00005', 'MENU7469');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00006', 'MENU5356');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00007', 'MENU4413');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00008', 'MENU1914');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00009', 'MENU4213');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00010', 'MENU7608');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00011', 'MENU9139');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00012', 'MENU8368');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00013', 'MENU1921');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00014', 'MENU6135');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00015', 'MENU9722');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00016', 'MENU4360');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00017', 'MENU2485');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00018', 'MENU2582');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00019', 'MENU4984');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00020', 'MENU7469');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00021', 'MENU5356');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00022', 'MENU4413');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00023', 'MENU1914');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00024', 'MENU4213');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00025', 'MENU7608');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00026', 'MENU9139');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00027', 'MENU8368');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00028', 'MENU1921');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00029', 'MENU6135');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00030', 'MENU9722');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00031', 'MENU4360');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00032', 'MENU2485');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00033', 'MENU2582');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00034', 'MENU4984');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00035', 'MENU7469');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00036', 'MENU5356');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00037', 'MENU4413');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00038', 'MENU1914');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00039', 'MENU4213');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00040', 'MENU7608');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00041', 'MENU9139');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00042', 'MENU8368');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00043', 'MENU1921');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00044', 'MENU6135');
INSERT INTO MenuItemReview (ReviewId, MenuItemId) VALUES ('REV00045', 'MENU9722');

--All the required querys, will create tables for each of them.

--Query for question D part A. Lists the customers id and full name with there order id's, dates of orders, and total cost of orders
CREATE TABLE    Question_D_A_Query AS
SELECT          Cust.CustomerId AS "Customer ID", 
                (Cust.FirstName || ' ' || Cust.LastName) AS "Customer Name", 
                Ord.OrderNo AS "Order No", 
                TO_CHAR(Ord.DateOfOrder, 'DD-MM-YYYY HH24:MI:SS') AS "Date Order Taken", 
                Ord.TotalCost AS "Total Cost"
FROM            Customer Cust
RIGHT JOIN      CustomerOrder Ord ON Cust.CustomerId = Ord.CustomerId;

--Query for question D part B. Does the same as question D part A, but will sort by customer name and date of order.
CREATE TABLE    Question_D_B_Query AS
SELECT          Cust.CustomerId AS "Customer ID", 
                (Cust.FirstName || ' ' || Cust.LastName) AS "Customer Name", 
                Ord.OrderNo AS "Order No", 
                TO_CHAR(Ord.DateOfOrder, 'DD-MM-YYYY HH24:MI:SS') AS "Date Order Taken", 
                Ord.TotalCost AS "Total Cost"
FROM            Customer Cust
RIGHT JOIN      CustomerOrder Ord ON Cust.CustomerId = Ord.CustomerId
ORDER BY        Cust.FirstName ASC, 
                Ord.DateOfOrder ASC;

--Query for question D part C. Lists the customers orders and menu items containing the ingredient 'ING4307'.
CREATE TABLE    Question_D_C_Query AS
SELECT DISTINCT Cust.CustomerId AS "Customer ID", 
                (Cust.FirstName || ' ' || Cust.LastName) AS "Customer Name", 
                Ord.OrderNo AS "Order No", 
                Menu.MenuItemId AS "Menu Item Id", 
                MI.ItemName AS "Item Name", 
                Ing.IngredientId AS "Ingredient Id"
FROM            CustomerOrder Ord
INNER JOIN      Customer Cust ON Ord.CustomerId = Cust.CustomerId
INNER JOIN      OrderedMenuItem Menu ON Ord.OrderNo = Menu.OrderNo
INNER JOIN      MenuItem MI ON Menu.MenuItemId = MI.MenuItemId
RIGHT JOIN      MenuItemIngredient Ing ON Menu.MenuItemId = Ing.MenuItemId
WHERE           Ing.IngredientId = 'ING4307' --<--Change this to change the ingredient that it will look for.
ORDER BY        Ord.OrderNo ASC;

--Query for question D part D. Returns the number of customers with orders.
CREATE TABLE    Question_D_D_Query AS 
SELECT          COUNT(DISTINCT Ord.CustomerId) AS "No Of Customers With Orders" --<--Counts the number of 'CustomerOrder' primary keys.
FROM            CustomerOrder Ord;

--Query for question D part E. Lists the menu items that customer '39460927' has ordered between dates '01/01/2023' and '30/01/2023'.
CREATE TABLE    Question_D_E_Query AS
SELECT          Ord.OrderNo AS "Order No", 
                OMI.MenuItemId AS "Menu Item Id", 
                Menu.ItemName AS "Ordered Menu Items"
FROM            CustomerOrder Ord 
LEFT JOIN       OrderedMenuItem OMI ON Ord.OrderNo = OMI.OrderNo
RIGHT JOIN      MenuItem Menu ON OMI.MenuItemId = Menu.MenuItemId
INNER JOIN      Customer Cust ON Ord.CustomerId = Cust.CustomerId
WHERE           Ord.CustomerId = '1'                --<----
AND             Ord.DateOfOrder                     -----^^
BETWEEN         TO_DATE('05/01/2022', 'DD/MM/YYYY') --<--^^
AND             TO_DATE('30/01/2023', 'DD/MM/YYYY') --<--Change this to change the customer it looks for or the date range.
ORDER BY        Ord.OrderNo ASC;

--Query for question D part F. Returns the number of orders that have been taken for each menu item.
CREATE TABLE    Question_D_F_Query AS
SELECT          Menu.MenuItemId AS "Menu Item Id", 
                Menu.ItemName AS "Menu Item Name", 
                COUNT(OMI.MenuItemId) AS "Num Of Orders"
FROM            OrderedMenuItem OMI
INNER JOIN      CustomerOrder Ord ON Ord.OrderNo = OMI.OrderNo
RIGHT JOIN      MenuItem Menu ON OMI.MenuItemId = Menu.MenuItemId
WHERE           Ord.DateOfOrder 
BETWEEN         TO_DATE('02/01/2023', 'DD/MM/YYYY') 
AND             TO_DATE('30/01/2023', 'DD/MM/YYYY')
GROUP BY        Menu.MenuItemId, Menu.ItemName 
ORDER BY        COUNT(OMI.MenuItemId) ASC;

--Query for question D part G. Lists the customers orders including if they are collection order between the dates '02/01/2023' and '30/01/2023'.
CREATE TABLE    Question_D_G_Query AS 
SELECT          (Cust.FirstName || ' ' || Cust.LastName) AS "Customer Name", 
                Ord.OrderNo AS "OrderNo", 
                Ord.CollectionOrDelivery AS "Type Of Order", 
                TO_CHAR(Ord.DateOfOrder, 'DD-MM-YYYY HH24:MI:SS') AS "Date Order Taken between 02/01/2023 and 30/01/2023"
FROM            CustomerOrder Ord
RIGHT JOIN      Customer Cust ON Ord.CustomerId = Cust.CustomerId
WHERE           Ord.DateOfOrder 
BETWEEN         TO_DATE('02/01/2023', 'DD/MM/YYYY') --<----
AND             TO_DATE('30/01/2023', 'DD/MM/YYYY') --<--Change this to change the dates it will get data between.
ORDER BY        Ord.CollectionOrDelivery ASC;

--Query for question D part H. Lists the total orders for each customer including the average spend and there total spend for a year.
CREATE TABLE    Question_D_H_Query AS
SELECT          Cust.CustomerId AS "Customer Id", 
                (Cust.FirstName || ' ' || Cust.LastName) AS "Customer Name", 
                TO_CHAR(Ord.DateOfOrder, 'DD-MM-YYYY HH24:MI:SS') AS "Date Order Taken", 
                ROUND(AVG(Ord.TotalCost), 2) AS "AverageCost", 
                ROUND(SUM(Ord.TotalCost), 2) AS "Annual Cost"
FROM            Customer Cust 
RIGHT JOIN      CustomerOrder Ord ON Cust.CustomerId = Ord.CustomerId
WHERE           EXTRACT(YEAR FROM Ord.DateOfOrder) = '2023' --<--Change this to change the year that it will calculate for.
GROUP BY        Cust.CustomerId, (Cust.FirstName || ' ' || Cust.LastName), TO_CHAR(Ord.DateOfOrder, 'DD-MM-YYYY HH24:MI:SS')
ORDER BY        SUM(Ord.TotalCost) DESC;

--Extra querys that arnt any questions.

--Returns the order cost and billing infomation of a ceratin order and a certain customer.
SELECT      Ord.OrderNo AS "Order No", 
            Ord.TotalCost AS "Total Cost Of Order", 
            Bil.NameOnCard AS "Name On Card", 
            Bil.AddressLineOne AS "Address Line One", 
            Bil.City, 
            Bil.Postcode, 
            Bil.CardNumber AS "Card Number", 
            Bil.ExpiryDate AS "Expiry Date", 
            Bil.ThreeDigitSecurityNo AS "Three Digit Security No"
FROM        Customer Cust
INNER JOIN  CustomerOrder Ord ON Cust.CustomerId = Ord.CustomerId
RIGHT JOIN  BillingInfomation Bil ON Cust.CustomerId = Bil.CustomerId
WHERE       Cust.CustomerId = '2' 
AND         Ord.OrderNo = '2';

--Returns the different ingredients including price, quantity per pack, id, and there suppliers with the supplier name and id.
SELECT      Ing.IngredientId AS "Ingredient Id", 
            Ing.IngredientName AS "Ingredient Name", 
            Ing.PurchaseCostPerPack AS "Purchase Cost Per Pack", 
            Ing.QuantityPerPack AS "Quantity Per Pack", 
            Sup.SupplierId AS "Supplier Id", 
            Sup.SupplierName AS "Supplier Name"
FROM        Ingredient Ing
LEFT JOIN   Supplier Sup ON Ing.SupplierId = Sup.SupplierId
ORDER BY    Ing.PurchaseCostPerPack ASC;

--Returns the ammount of orders taken by each staff member.
SELECT      Staff.StaffMemberId AS "Staff Member Id", 
            (Staff.FirstName || ' ' || Staff.LastName) AS "Staff Name", 
            Staff.StaffRank AS "Staff Rank", 
            COUNT(Ord.StaffMemberId) AS "Ammount Of Orders Taken"
FROM        StaffMember Staff
RIGHT JOIN  CustomerOrder Ord ON Staff.StaffMemberId = Ord.StaffMemberId
GROUP BY    Staff.StaffMemberId, 
            (Staff.FirstName || ' ' || Staff.LastName), 
            Staff.StaffRank;