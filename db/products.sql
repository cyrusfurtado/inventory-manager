create table products (
	id UUID NOT NULL PRIMARY KEY,
	product_name VARCHAR NOT NULL,
	part_number VARCHAR(50) NOT NULL,
	product_label VARCHAR(300) NOT NULL,
	starting_inventory INT,
	inventory_received INT,
	inventory_shipped INT,
	inventory_on_hand INT,
	minimum_required INT
);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('7f85672f-8f97-44be-8b3c-bfb0a4edb067', 'risperidone', 'CIQ-735096', 'risperidone', 9155, null, 0, 0, 611);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('d0ae730e-d79a-4f01-9bb4-42cdf1d8e90a', 'Divalproex Sodium', 'LWR-817212', 'Divalproex Sodium', 7617, null, 0, 0, 282);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('3caef524-81aa-4879-940a-4b3621434d03', 'petrolatum', 'JLJ-731517', 'Personal Care Petroleum', 6872, null, 0, 0, 352);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('647290c1-28de-4372-8a88-40cbb93f497f', 'disopyramide phosphate', 'ULR-360250', 'Norpace', 2038, 2371, 0, 0, 647);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('f6868042-723d-4ef9-9b0e-bbe906bedb3d', 'spironolactone', 'RXR-692802', 'Spironolactone', 4577, 3602, 0, 0, 163);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('45f8afa1-7de0-4837-b239-ef5c1303967f', 'Divalproex Sodium', 'KTQ-730557', 'Divalproex Sodium', 7486, 3161, 0, 0, 125);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('4b16bc84-8c21-4918-b70d-4b1ae2502851', 'PYRITHIONE ZINC', 'FBQ-342880', 'DANDRUFF 2 IN 1 SHAMPOO AND CONDITIONER', 3508, null, 0, 0, 185);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('69d16bf4-afe9-410d-9afe-ec85a2ebea3b', 'ZINC OXIDE', 'TXW-324497', 'GOOD NEIGHBOR PHARMACY DIAPER RASH CREAMY', 2366, 2508, 0, 0, 332);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('8d52237d-c84a-4a39-b0d1-1b982e756351', 'Octinoxate, Oxybenzone, Titanium Dioxide', 'ZNV-350259', 'Quiet Rose Always color stay-on Makeup Broad Spectrum SPF 15', 6859, 2783, 0, 0, 818);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('2a037af8-12dd-426c-89f9-eefc4a8e2cab', 'Cyproheptadine Hydrochloride', 'SAY-244366', 'Cyproheptadine Hydrochloride', 8559, null, 0, 0, 730);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('4b96c64d-c890-47b6-9d88-6f1e8d4a1b96', 'Antibacterial Hand Soap', 'AFU-353091', 'WhiskCare 367', 5480, 4267, 0, 0, 565);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('fd7370a9-9b36-470c-8fee-26dedcec4669', 'Methyl Salicylate, Menthol and Capsaicin', 'QXJ-199396', 'Overtime', 6640, 3964, 0, 0, 238);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('21bbd1d4-aa17-4429-9d7a-46049c306020', 'furosemide', 'CPU-482228', 'Lasix', 8566, 1444, 0, 0, 971);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('68643051-9b6f-44a4-bd72-2ddc8b8b6123', 'Pinchot Juniper', 'AMU-671937', 'Pinchot Juniper', 3777, 2314, 0, 0, 813);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('ee5b117e-af6e-4c43-8bb6-cb1bbe05d93e', 'Aesculus carnea, flos, Aesculus hippocastanum, flos, Agrimonia eupatoria, flos, Antimonium crudum, Avena sativa, Chamomilla, Colocynthis, Crocus sativus, Ferrum metallicum, Impatiens glandulifera, flos, Kali carbonicum, Natrum muriaticum, Populus tremula, flos, Staphysagria, Thyroidinum', 'QHX-302068', 'Easily Angered', 7589, 2212, 0, 0, 569);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('a2032c3e-fbd1-4167-b750-3d3ecc65eafe', 'Meloxicam', 'EAQ-084033', 'Meloxicam', 5221, null, 0, 0, 807);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('acdb44fb-9fb9-4fb8-87b0-599f5c8a95a8', 'estradiol', 'FNQ-362262', 'Vagifem', 1938, null, 0, 0, 802);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('3d94b38e-0d94-442d-b5cf-65dc758ad446', 'MICONAZOLE NITRATE', 'YZA-286404', 'Secura Antifungal', 9989, 382, 0, 0, 154);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('937dc15c-0168-4e04-91d2-7db5a423f53b', 'Tolnaftate', 'WSI-594345', 'Nail Active Daytime Anti-fungal', 7237, 543, 0, 0, 692);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('fa8438d9-f327-4374-b6e3-7aa48b547a44', 'OCTINOXATE and TITANIUM DIOXIDE', 'LPM-309322', 'SHISEIDO UV PROTECTIVE FOUNDATION', 8981, 4600, 0, 0, 845);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('990fdacb-e6a1-45a0-89e0-e69b9d02323c', 'Diphenoxylate Hcl and Atropine Sulfate', 'UZP-048443', 'Diphenoxylate Hcl and Atropine Sulfate', 3441, 4581, 0, 0, 645);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('f7b2ca87-c9a3-443f-b88a-073cef46fd41', 'Levothyroxine Sodium', 'LLD-391340', 'Levothyroxine Sodium', 8671, 437, 0, 0, 692);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('dd2b14bf-e7db-4fd9-8c09-a91695ef48bc', 'TITANIUM DIOXIDE', 'EXX-134772', 'SENSAI CELLULAR PERFORMANCE HYDRACHANGE TINTED 3 SOFT ALMOND', 5547, 3389, 0, 0, 579);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('2dd14100-5fa5-4e22-af6c-d3ec7722c0b5', 'American Sycamore', 'SSF-404800', 'PLATANUS OCCIDENTALIS POLLEN', 9038, 3440, 0, 0, 997);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('92f32668-962e-483d-8a66-48072ff7888a', 'dimethicone, octinoxate, oxybenzone', 'LID-848206', 'Softlips Intense Moisture Double Mint', 8628, null, 0, 0, 773);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('4bbe57fe-2346-4849-825a-4faf89e9f404', 'Ibuprofen', 'YNR-552062', 'Ibuprofen', 4956, 2316, 0, 0, 824);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('e7ddd2c0-4aea-4564-8920-65785fa67597', 'amoxicillin and clavulanate potassium', 'XMP-653163', 'Amoxicillin and Clavulanate Potassium', 9023, null, 0, 0, 456);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('c47d962c-6068-4164-87fa-8482821f1ef8', 'Methylprednisolone Acetate, Lidocaine Hydrochloride, Bupivacaine Hydrochloride, Povidine Iodine, Sodium Chloride, Isopropyl Alcohol', 'YNE-671871', 'Dyural 80 Kit', 8701, 3126, 0, 0, 645);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('b273a772-1423-4829-9cc5-58df92c1bfed', 'Ibuprofen', 'CJW-639549', 'ibuprofen', 7281, 1729, 0, 0, 917);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('b45cbb39-69eb-4e83-a665-c243940d2bbd', 'ALCOHOL', 'OFH-322420', 'Antibacterial Hand Sanitizer Spray', 6912, null, 0, 0, 662);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('2aa5d338-248c-4b8b-a7b9-52af04e4012f', 'Avobenzone, Octinoxate, Octisalate, Octocrylene, oxybenzone', 'WDV-524590', 'Advanced Dynamics Soothing day Moisture Broad Spectrum SPF 15', 7236, null, 0, 0, 169);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('d5a196b6-f2b8-4856-86b0-aa736ad14aaa', 'SCHOENOCAULON OFFICINALE SEED', 'KND-500877', 'Sabadilla Kit Refill', 2273, null, 0, 0, 625);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('5a58e622-1c05-4cff-92b8-3d8771b364c4', 'Ursodiol', 'HRT-786880', 'Ursodiol', 6388, null, 0, 0, 486);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('234d7a23-a5de-4918-a865-21946942a6c2', 'Polyvinyl Alcohol and Povidone and Tetrahydrozoline Hydrochloride', 'AWR-709000', 'Clear Eyes Triple Action', 9319, 2268, 0, 0, 407);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('b279f10a-6410-4f4a-ad47-8ebc482610c1', 'TITANIUM DIOXIDE', 'HWT-645250', 'DOUBLE PERFECTION LUMIERE', 7964, 2421, 0, 0, 619);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('45057078-a03e-4315-8d0c-7a82302bfc61', 'Titanium Dioxide', 'QQZ-073419', 'BareMinerals', 8745, 1176, 0, 0, 859);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('b2a0f19d-4bef-49ab-b296-4bda23ecdba7', 'Diphenhydramine Hydrochloride and Phenylephrine Hydrochloride', 'AFC-095310', 'Nite Time Cold and Cough', 6626, 2812, 0, 0, 708);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('db332512-850d-4550-8fbf-014c23cb1e8f', 'WATER', 'JVG-862947', 'Sterile Water', 7024, null, 0, 0, 219);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('d0291dc8-c365-4da7-8cc0-28cf8b73aec8', 'Nortriptyline Hydrochloride', 'IHW-858778', 'Nortriptyline Hydrochloride', 6312, 2070, 0, 0, 966);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('64f85967-5694-4741-9ce8-6de31427a77f', 'Simethicone', 'GRX-831936', 'Gas Relief', 8806, 204, 0, 0, 865);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('80162355-6830-4b9d-8812-25b2a0108cab', 'Clindamycin Hydrochloride', 'IAO-676390', 'Clindamycin Hydrochloride', 3835, 1328, 0, 0, 459);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('305e5866-19e4-4b3f-9b2c-88b1b7ac45f9', 'methotrexate', 'CEV-669864', 'Trexall', 4281, 3958, 0, 0, 337);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('bf372f8c-0ca2-4dc0-83f3-40062af7a071', 'Levothyroxine Sodium', 'RQK-315749', 'Levothyroxine Sodium', 7316, 2007, 0, 0, 641);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('21921698-e2a4-40eb-9cf2-51725228ab2e', 'ranitidine hydrochloride', 'LGE-836599', 'Ranitidine', 9558, 2677, 0, 0, 603);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('2038586f-6f7b-4918-ad36-17a763746c93', 'Esterified Estrogens and Methyltestosterone', 'RWV-721626', 'Esterified Estrogens and Methyltestosterone', 3335, 2526, 0, 0, 198);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('18364687-7b65-4859-946a-d2ce1e158445', 'Pollens - Weeds, Marshelder/Poverty Mix', 'FBH-486224', 'Pollens - Weeds, Marshelder/Poverty Mix', 1111, 3400, 0, 0, 408);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('613dd627-a415-4d68-9d28-f8bf4e53108a', 'nifedipine', 'EEF-472062', 'nifedipine', 1475, 4991, 0, 0, 571);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('2f17e16f-0716-48cf-a81c-69a4355e23f6', 'Gabapentin', 'FAB-499989', 'Neurontin', 9660, 4939, 0, 0, 176);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('14c1dc6a-3179-499d-a94c-d5a968255ebc', 'Levetiracetam', 'LMW-982176', 'Levetiracetam', 8819, 1353, 0, 0, 994);
insert into products (id, product_name, part_number, product_label, starting_inventory, inventory_received, inventory_shipped, inventory_on_hand, minimum_required) values ('c0c8ba38-005e-4bdf-bb7d-4f67d87d7faa', 'sodium sulfacetamide, sulfer', 'OTH-476924', 'Rosanil', 2336, 525, 0, 0, 565);
