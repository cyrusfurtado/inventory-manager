create table orders (
	id UUID NOT NULL PRIMARY KEY,
	title VARCHAR(50),
	first VARCHAR(50) NOT NULL,
	last VARCHAR(50) NOT NULL,
	product_id UUID REFERENCES products(id),
	number_shipped INT NOT NULL,
	order_date DATE NOT NULL
);
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('c4b8f609-32a1-4402-9859-06ac91887be8', 'Mrs', 'Delinda', 'Kemmer', null, 104, '2020-12-01');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('49582edc-baeb-4bf7-95af-ef347524995a', 'Dr', 'Oralee', 'Peat', null, 123, '2020-06-01');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('7934784b-a611-480a-a716-72d5232661d6', 'Honorable', 'Kelci', 'Treadger', null, 247, '2020-09-04');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('d191d3ad-50b3-4fc6-9b35-a7ed3941334a', 'Dr', 'Kile', 'Dougher', null, 376, '2021-03-15');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('3af9cfde-76e4-40e9-8551-8947ac9f591a', 'Mrs', 'Druci', 'Brothwood', null, 385, '2021-02-19');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('90b92308-6c26-476e-8d53-8a16d0dade19', 'Rev', 'Rouvin', 'Vardey', null, 443, '2020-11-06');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('eeccb55e-29d6-4b91-9b56-68393d85e26a', 'Ms', 'Celinka', 'Clarey', null, 392, '2020-05-28');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('c865f73d-07ad-41fa-8087-cb7104ae5bbf', 'Ms', 'Rriocard', 'Almack', null, 161, '2021-02-05');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('9f197731-d50d-46fb-b43e-9ebb3f8010a6', 'Honorable', 'Sabina', 'Laminman', null, 291, '2020-05-09');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('bc29eccd-69a2-4563-8e43-2b3fc31dbc3a', 'Mrs', 'Anna-maria', 'Tuckey', null, 107, '2020-09-10');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('c263d681-6db9-4c99-af89-e8e4588158d0', 'Ms', 'Tiffie', 'Girault', null, 216, '2020-12-16');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('cadc6baa-2de9-4382-bbfb-bc9bf79df23e', 'Ms', 'Barnett', 'Manilow', null, 34, '2020-09-01');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('ea4bb7bb-9b99-4690-a230-210edc98d358', 'Mrs', 'Bald', 'Dunguy', null, 67, '2021-04-02');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('e357bb9e-9da4-4be9-bd67-75075e5345f7', 'Ms', 'Kirby', 'Charrington', null, 236, '2020-11-27');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('f80897e6-ca24-4f7c-9d72-bc09ed3e9e50', 'Mrs', 'Max', 'Barraclough', null, 435, '2021-03-04');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('963df514-e169-4873-8cd5-0d01ec1a44a1', 'Honorable', 'Thurstan', 'Brimham', null, 285, '2020-11-30');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('9dce770c-e48e-413e-8671-cae32a6e4bd7', 'Dr', 'Goober', 'Disbrey', null, 51, '2020-06-13');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('1308859e-2381-418d-8ddb-63b319614045', 'Rev', 'Rayner', 'Gipp', null, 218, '2021-02-09');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('54cd8f94-2352-42bb-8a0a-3a20f2a8654a', 'Mr', 'Jacki', 'Toleman', null, 186, '2020-09-19');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('3d704bd9-0351-4d96-b816-e2e4e494eb6b', 'Mrs', 'Winfred', 'Reardon', null, 391, '2021-02-02');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('ac32cacc-b270-43a1-83c1-a8de9d7c058f', 'Honorable', 'Lawton', 'Mabee', null, 289, '2020-08-08');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('68fb9fba-6e97-4fe1-9b7c-b06c30d64c1a', 'Ms', 'Andromache', 'Matuszkiewicz', null, 95, '2020-12-19');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('47bd05e4-4bb4-4b49-aa69-402fcd4d32d5', 'Rev', 'Charley', 'Quittonden', null, 436, '2020-12-21');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('9ba2dfb2-4388-422f-9081-fb7be1b693de', 'Rev', 'Collen', 'Whisby', null, 234, '2021-01-30');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('cfe21b6b-9967-4795-8130-ce617fb3b63b', 'Honorable', 'Euell', 'Layburn', null, 245, '2020-05-28');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('c5be5a02-d179-44b4-b904-0741d29ae0a5', 'Dr', 'Murry', 'Laxe', null, 400, '2020-12-09');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('918b6660-c342-4ed1-9bbd-aff6c58902de', 'Honorable', 'Drusy', 'Gantley', null, 90, '2021-01-06');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('267a6bde-4993-4dc0-bced-31cbb8117b60', 'Mrs', 'Dom', 'Leasor', null, 437, '2020-12-15');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('88856ea8-e43f-4f8c-a287-e01d07b63710', 'Rev', 'Gwendolyn', 'Worham', null, 392, '2020-05-14');
insert into orders (id, title, first, last, product_id, number_shipped, order_date) values ('e2e850c7-82f3-4f37-8e0b-c956e2dfceec', 'Ms', 'Marlo', 'Laugheran', null, 200, '2020-08-06');
