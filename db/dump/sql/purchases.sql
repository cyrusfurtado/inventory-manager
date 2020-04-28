create table purchases (
	id UUID NOT NULL PRIMARY KEY,
	supplier_id UUID REFERENCES suppliers(id),
	product_id UUID REFERENCES products(id),
	number_received INT NOT NULL,
	purchase_date DATE NOT NULl
);
insert into purchases (id, supplier_id, product_id, number_received, purchase_date) values ('e5ddc2ae-b853-422e-bebf-c07d801d6662', null, null, 4528, '2020-03-18');
insert into purchases (id, supplier_id, product_id, number_received, purchase_date) values ('484cc6d6-93f2-4932-9cd1-fc3ae73c6d78', null, null, 4976, '2019-07-08');
insert into purchases (id, supplier_id, product_id, number_received, purchase_date) values ('c0a2ba5a-3a67-4883-9b59-63d15aa95292', null, null, 2288, '2019-09-23');
insert into purchases (id, supplier_id, product_id, number_received, purchase_date) values ('e9c4501a-f10c-47a0-9e1e-aaee1f35a250', null, null, 2781, '2019-11-05');
insert into purchases (id, supplier_id, product_id, number_received, purchase_date) values ('b9c7cdd8-508e-4d2c-a620-234643fb1a57', null, null, 4147, '2020-03-15');
insert into purchases (id, supplier_id, product_id, number_received, purchase_date) values ('f276247d-99fa-4144-957d-be69bb3801c7', null, null, 604, '2019-07-21');
insert into purchases (id, supplier_id, product_id, number_received, purchase_date) values ('e0449d2d-8e07-46ca-a81f-d259e52520be', null, null, 3763, '2019-11-08');
insert into purchases (id, supplier_id, product_id, number_received, purchase_date) values ('bbf4f910-9363-4940-ac6b-c827a8c87dd5', null, null, 1056, '2019-08-30');
insert into purchases (id, supplier_id, product_id, number_received, purchase_date) values ('666a1d88-bdc8-4866-85c3-e716ee9d6256', null, null, 4169, '2020-01-15');
insert into purchases (id, supplier_id, product_id, number_received, purchase_date) values ('bf5a4696-20a4-42d2-b250-5c2b8bb666c1', null, null, 4029, '2020-03-26');
insert into purchases (id, supplier_id, product_id, number_received, purchase_date) values ('4ad15174-f20b-441d-9e83-e54b497e7433', null, null, 2732, '2019-07-22');
insert into purchases (id, supplier_id, product_id, number_received, purchase_date) values ('8851db43-ee8d-4b3a-be79-c5d01d20b07e', null, null, 427, '2019-09-01');
insert into purchases (id, supplier_id, product_id, number_received, purchase_date) values ('bd048325-adee-4464-8cba-85fa9f565ae8', null, null, 4063, '2020-02-05');
insert into purchases (id, supplier_id, product_id, number_received, purchase_date) values ('00a2e530-8064-4468-8994-921a8cdb62d3', null, null, 847, '2019-09-05');
insert into purchases (id, supplier_id, product_id, number_received, purchase_date) values ('a6bf0afe-74ef-484c-b3d7-446d9abe1880', null, null, 4135, '2019-09-27');
insert into purchases (id, supplier_id, product_id, number_received, purchase_date) values ('08d07342-9a9f-46b8-be24-8ffc1bc558d1', null, null, 780, '2019-06-03');
insert into purchases (id, supplier_id, product_id, number_received, purchase_date) values ('59d9a0a3-ae57-4461-a3f1-c72f45cd1598', null, null, 2574, '2019-11-22');
insert into purchases (id, supplier_id, product_id, number_received, purchase_date) values ('f9fca252-cd48-4ecd-9406-43a7c8085ad9', null, null, 921, '2019-08-15');
insert into purchases (id, supplier_id, product_id, number_received, purchase_date) values ('ded1aee3-6930-44af-941f-aab228d785ec', null, null, 4808, '2019-11-04');
insert into purchases (id, supplier_id, product_id, number_received, purchase_date) values ('0251f347-efdf-4d44-9a15-3451473ae775', null, null, 1214, '2019-10-26');
